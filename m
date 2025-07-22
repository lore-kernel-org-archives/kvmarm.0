Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5139FB667
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753189153; cv=none; b=cMoleEPTElBTLnNYVB7KZeUqlEHeelXRFiVo10szDw4PwcinLt9NIGUc81IaVS4B9CpwEr35Gf/6lco03cjy1upIIWaeRVxKKGNXJ+HBHmpPG9FG8/dGyAG/lFpPpwNaPFKh9GBm+Z4AKLbIHa8cvD7gJuCcwoPKL3qnOYbtUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753189153; c=relaxed/simple;
	bh=736uIAHzyrcCRqCqAhExqhDC1+D7LWtMyOXmc0eNxLc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aVKUETCGo2MLUDdUinbLyDX5Kb/PwhBEZN+No6IJbT9GaTNnaJMErwweG/4/9nMqXKh2IJ7Tx044bZPQhJV01dMq0ONmtjg062RtwVXHciiTWYO0wN1O/hv5WKNCwejSFKnYlNe2kpiLJ+dyaKUyY1Uk+8m7MOVUX6Gq/WLQmfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90713152B;
	Tue, 22 Jul 2025 05:59:04 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 633153F6A8;
	Tue, 22 Jul 2025 05:59:08 -0700 (PDT)
Message-ID: <17b526ff-b824-4c24-8ac0-6821e5cc8900@arm.com>
Date: Tue, 22 Jul 2025 13:59:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com >> Zenghui Yu" <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 qperret@google.com, vdonnefort@google.com, Fuad Tabba <tabba@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Ryan.Roberts@arm.com
From: Ben Horgan <ben.horgan@arm.com>
Subject: [bug report] KVM: arm64: Add a range to __pkvm_host_unshare_guest()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On trying to boot a pkvm guest when using transparent huge pages I see 
the crash below. I'm using v6.6-rc7.

kvm [141]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!

It looks pkvm_pgtable_stage_relax_perms() can be called with a block 
mapping but in __pkvm_host_relax_perms_guest() it assumes page size for 
the assert_host_shared_guest() check. With the following patch, I no 
longer see the crash:

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c 
b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8957734d6183..52c802da4172 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1010,9 +1010,12 @@ static int __check_host_shared_guest(struct 
pkvm_hyp_vm *vm, u64 *__phys, u64 ip
                 return ret;
         if (!kvm_pte_valid(pte))
                 return -ENOENT;
-       if (kvm_granule_size(level) != size)
+       if (size && kvm_granule_size(level) != size)
                 return -E2BIG;

+       if (!size)
+               size = kvm_granule_size(level);
+
         state = guest_get_page_state(pte, ipa);
         if (state != PKVM_PAGE_SHARED_BORROWED)
                 return -EPERM;
@@ -1100,7 +1103,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct 
pkvm_hyp_vcpu *vcpu, enum kvm_
         if (prot & ~KVM_PGTABLE_PROT_RWX)
                 return -EINVAL;

-       assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+       assert_host_shared_guest(vm, ipa, 0);
         guest_lock_component(vm);
         ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
         guest_unlock_component(vm);


  root@172:/# /share/lkvm run -k /share/arch/arm64/boot/Image
   Info: # lkvm run -k /share/arch/arm64/boot/Image -m 704 -c 8 --name 
guest-128
   Info: Removed ghost socket file "/.lkvm//guest-128.sock".
[ 1406.521757] kvm [141]: nVHE hyp BUG at: 
arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!
[ 1406.521804] kvm [141]: nVHE call trace:
[ 1406.521828] kvm [141]:  [<ffff8000811676b4>] 
__kvm_nvhe_hyp_panic+0xb4/0xe8
[ 1406.521946] kvm [141]:  [<ffff80008116d12c>] 
__kvm_nvhe_assert_host_shared_guest+0xb0/0x10c
[ 1406.522049] kvm [141]:  [<ffff80008116f068>] 
__kvm_nvhe___pkvm_host_relax_perms_guest+0x48/0x104
[ 1406.522157] kvm [141]:  [<ffff800081169df8>] 
__kvm_nvhe_handle___pkvm_host_relax_perms_guest+0x64/0x7c
[ 1406.522250] kvm [141]:  [<ffff800081169f0c>] 
__kvm_nvhe_handle_trap+0x8c/0x1a8
[ 1406.522333] kvm [141]:  [<ffff8000811680fc>] 
__kvm_nvhe___skip_pauth_save+0x4/0x4
[ 1406.522454] kvm [141]: ---[ end nVHE call trace ]---
[ 1406.522477] kvm [141]: Hyp Offset: 0xfffece8013600000
[ 1406.522554] Kernel panic - not syncing: HYP panic:
[ 1406.522554] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
[ 1406.522554] FAR:ffff8000804be420 HPFAR:0000000000804be0 
PAR:0000000000000000
[ 1406.522554] VCPU:0000000000000000
[ 1406.523337] CPU: 3 UID: 0 PID: 141 Comm: kvm-vcpu-0 Not tainted 
6.16.0-rc7 #97 PREEMPT
[ 1406.523485] Hardware name: FVP Base RevC (DT)
[ 1406.523566] Call trace:
[ 1406.523629]  show_stack+0x18/0x24 (C)
[ 1406.523753]  dump_stack_lvl+0xd4/0x108
[ 1406.523899]  dump_stack+0x18/0x24
[ 1406.524040]  panic+0x3d8/0x448
[ 1406.524184]  nvhe_hyp_panic_handler+0x10c/0x23c
[ 1406.524325]  kvm_handle_guest_abort+0x68c/0x109c
[ 1406.524500]  handle_exit+0x60/0x17c
[ 1406.524630]  kvm_arch_vcpu_ioctl_run+0x2e0/0x8c0
[ 1406.524794]  kvm_vcpu_ioctl+0x1a8/0x9cc
[ 1406.524919]  __arm64_sys_ioctl+0xac/0x104
[ 1406.525067]  invoke_syscall+0x48/0x10c
[ 1406.525189]  el0_svc_common.constprop.0+0x40/0xe0
[ 1406.525322]  do_el0_svc+0x1c/0x28
[ 1406.525441]  el0_svc+0x38/0x120
[ 1406.525588]  el0t_64_sync_handler+0x10c/0x138
[ 1406.525750]  el0t_64_sync+0x1ac/0x1b0
[ 1406.525876] SMP: stopping secondary CPUs
[ 1406.525965] Kernel Offset: disabled
[ 1406.526032] CPU features: 0x0000,00000080,8e134ca1,9446773f
[ 1406.526130] Memory Limit: none
[ 1406.959099] ---[ end Kernel panic - not syncing: HYP panic:
[ 1406.959099] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
[ 1406.959099] FAR:ffff8000804be420 HPFAR:0000000000804be0 
PAR:0000000000000000
[ 1406.959099] VCPU:0000000000000000 ]---

Thanks,

Ben

