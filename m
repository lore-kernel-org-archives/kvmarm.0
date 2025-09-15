Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E841F30BB
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 09:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757927616; cv=none; b=V/w0PYO5CPq6dFquFvEzBaooR6IUSNA7syyeszivr7FABZE2j43W6/bl2j4qttAxpFyYGdnom6W6HD3LSL22YDKs1gun79RCH9Drc3LeGmk35tQyLXnMa5YKMk6L3wV1cg4hf+s2J6awOCJXSBBRLLDYrSWJRAI9VTjbf59gOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757927616; c=relaxed/simple;
	bh=NtcqAVPtebwVePikKYuDoVB0ug1k1jHfCkmM7NepnwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghQe957PAdTjxDkh6CgGqbqykSEHCrJk5Tz1FwawRGjXA3sLX2FdBOVLHtyHBNbFsJCvmj7NNqCSxcndaO4JH+859eiDUlARFxb9WCUGZQo/Xs5BTuuw6HrfpFxjvEx6UFdhjUry3kcOyQkK6BdWCdDS0HnhTyKRXHotmnN47hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E468B1424;
	Mon, 15 Sep 2025 02:13:24 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 177063F694;
	Mon, 15 Sep 2025 02:13:30 -0700 (PDT)
Message-ID: <5d30d737-945f-4524-81ac-12ff03edca6c@arm.com>
Date: Mon, 15 Sep 2025 10:13:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Fix debug checking for np-guests using huge
 mappings
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, james.morse@arm.com, tabba@google.com,
 Quentin Perret <qperret@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 stable@vger.kernel.org
References: <20250815162655.121108-1-ben.horgan@arm.com>
 <aKMkvQEyeK1QH12X@google.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aKMkvQEyeK1QH12X@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/18/25 14:03, Vincent Donnefort wrote:
> Thanks for the fix!
> 
> On Fri, Aug 15, 2025 at 05:26:55PM +0100, Ben Horgan wrote:
>> When running with transparent huge pages and CONFIG_NVHE_EL2_DEBUG then
>> the debug checking in assert_host_shared_guest() fails on the launch of an
>> np-guest. This WARN_ON() causes a panic and generates the stack below.
>>
>> In __pkvm_host_relax_perms_guest() the debug checking assumes the mapping
>> is a single page but it may be a block map. Update the checking so that
>> the size is not checked and just assumes the correct size.
>>
>> While we're here make the same fix in __pkvm_host_mkyoung_guest().
>>
>>   Info: # lkvm run -k /share/arch/arm64/boot/Image -m 704 -c 8 --name guest-128
>>   Info: Removed ghost socket file "/.lkvm//guest-128.sock".
>> [ 1406.521757] kvm [141]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:1088!
>> [ 1406.521804] kvm [141]: nVHE call trace:
>> [ 1406.521828] kvm [141]:  [<ffff8000811676b4>] __kvm_nvhe_hyp_panic+0xb4/0xe8
>> [ 1406.521946] kvm [141]:  [<ffff80008116d12c>] __kvm_nvhe_assert_host_shared_guest+0xb0/0x10c
>> [ 1406.522049] kvm [141]:  [<ffff80008116f068>] __kvm_nvhe___pkvm_host_relax_perms_guest+0x48/0x104
>> [ 1406.522157] kvm [141]:  [<ffff800081169df8>] __kvm_nvhe_handle___pkvm_host_relax_perms_guest+0x64/0x7c
>> [ 1406.522250] kvm [141]:  [<ffff800081169f0c>] __kvm_nvhe_handle_trap+0x8c/0x1a8
>> [ 1406.522333] kvm [141]:  [<ffff8000811680fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4
>> [ 1406.522454] kvm [141]: ---[ end nVHE call trace ]---
>> [ 1406.522477] kvm [141]: Hyp Offset: 0xfffece8013600000
>> [ 1406.522554] Kernel panic - not syncing: HYP panic:
>> [ 1406.522554] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
>> [ 1406.522554] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
>> [ 1406.522554] VCPU:0000000000000000
>> [ 1406.523337] CPU: 3 UID: 0 PID: 141 Comm: kvm-vcpu-0 Not tainted 6.16.0-rc7 #97 PREEMPT
>> [ 1406.523485] Hardware name: FVP Base RevC (DT)
>> [ 1406.523566] Call trace:
>> [ 1406.523629]  show_stack+0x18/0x24 (C)
>> [ 1406.523753]  dump_stack_lvl+0xd4/0x108
>> [ 1406.523899]  dump_stack+0x18/0x24
>> [ 1406.524040]  panic+0x3d8/0x448
>> [ 1406.524184]  nvhe_hyp_panic_handler+0x10c/0x23c
>> [ 1406.524325]  kvm_handle_guest_abort+0x68c/0x109c
>> [ 1406.524500]  handle_exit+0x60/0x17c
>> [ 1406.524630]  kvm_arch_vcpu_ioctl_run+0x2e0/0x8c0
>> [ 1406.524794]  kvm_vcpu_ioctl+0x1a8/0x9cc
>> [ 1406.524919]  __arm64_sys_ioctl+0xac/0x104
>> [ 1406.525067]  invoke_syscall+0x48/0x10c
>> [ 1406.525189]  el0_svc_common.constprop.0+0x40/0xe0
>> [ 1406.525322]  do_el0_svc+0x1c/0x28
>> [ 1406.525441]  el0_svc+0x38/0x120
>> [ 1406.525588]  el0t_64_sync_handler+0x10c/0x138
>> [ 1406.525750]  el0t_64_sync+0x1ac/0x1b0
>> [ 1406.525876] SMP: stopping secondary CPUs
>> [ 1406.525965] Kernel Offset: disabled
>> [ 1406.526032] CPU features: 0x0000,00000080,8e134ca1,9446773f
>> [ 1406.526130] Memory Limit: none
>> [ 1406.959099] ---[ end Kernel panic - not syncing: HYP panic:
>> [ 1406.959099] PS:834003c9 PC:0000b1806db6d170 ESR:00000000f2000800
>> [ 1406.959099] FAR:ffff8000804be420 HPFAR:0000000000804be0 PAR:0000000000000000
>> [ 1406.959099] VCPU:0000000000000000 ]
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> Fixes: db14091d8f75 ("KVM: arm64: Stage-2 huge mappings for np-guests")
> 
> Not sure if it really matters but it's more about fixing f28f1d02f4ea (KVM: arm64: Add a range
> to __pkvm_host_unshare_guest()) which introduced the check size !=
> kvm_granule_size(). Even though this is noop until db14091d8f75

Happy to update the Fixes tag with whatever is required. I was in two
minds but opted for db14091d8f75 as that's where this starts to make a
functional difference.

> 
>> Cc: Vincent Donnefort <vdonnefort@google.com>
>> Cc: Quentin Perret <qperret@google.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: stable@vger.kernel.org
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>Thanks!
Ben

