Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCB615C14F
	for <kvmarm@lists.linux.dev>; Mon, 19 Aug 2024 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724060402; cv=none; b=F3D53yESVO3KL1H4rzRrrkk9LmoT/LtOLzGolY6t4+ZrpeeHx/MWujSQI2lCFKA4/xf5s1gWKSnovnLkKeZSOkwJ3vJcAEbjbK7kFRMEkV0Sj4BSmB8VC6dSvzHBBrursDl8lZSxoCsBV73ztVGJ1uMo1lpOen6V39+YHtX3qFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724060402; c=relaxed/simple;
	bh=bZ6vGbPmvwOx/GIthpCbSvL175P2tDigq3U8iOTGuIY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sOXIhKUM2Lm/UgRhrG1Qa6Zsdc7n9V3hDIM2InLp7WWK8ERbCUtkkxHHGy3yH5eTNC9z4KUYp53XOrVmwwqTetz7UyW47AnxsHpkIoFL5mL2Kx6iStsQpbtwPaTkECLo1f8KEPqcSfUt6TZ6zcoSMvjD5vJPKw+dbAXeuITZPek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WnS9t54mpz1j6jL;
	Mon, 19 Aug 2024 17:34:58 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id DE3461A0188;
	Mon, 19 Aug 2024 17:39:56 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 17:39:56 +0800
Subject: Re: [PATCH] KVM: arm64: vgic: Hold config_lock while tearing down a
 CPU interface
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, Alexander Potapenko
	<glider@google.com>
References: <20240808091546.3262111-1-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c8f4602a-c3af-958f-6c8e-a4226d613a6b@huawei.com>
Date: Mon, 19 Aug 2024 17:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240808091546.3262111-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/8/8 17:15, Marc Zyngier wrote:
> Tearing down a vcpu CPU interface involves freeing the private interrupt
> array. If we don't hold the lock, we may race against another thread
> trying to configure it. Yeah, fuzzers do wonderful things...
> 
> Taking the lock early solves this particular problem.
> 
> Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on demand")
> Reported-by: Alexander Potapenko <glider@google.com>
> Tested-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 7f68cf58b978..41feb858ff9a 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -438,14 +438,13 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  	unsigned long i;
>  
>  	mutex_lock(&kvm->slots_lock);
> +	mutex_lock(&kvm->arch.config_lock);
>  
>  	vgic_debug_destroy(kvm);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		__kvm_vgic_vcpu_destroy(vcpu);
>  
> -	mutex_lock(&kvm->arch.config_lock);
> -
>  	kvm_vgic_dist_destroy(kvm);
>  
>  	mutex_unlock(&kvm->arch.config_lock);

The following splat was triggered when running the vgic_init selftest on
a lockdep kernel (I use rc4, with defconfig + PROVE_LOCKING).

I'm not entirely sure that the splat is related to this change. Just
haven't got time to dig further so post it out early for record.

 ======================================================
 WARNING: possible circular locking dependency detected
 6.11.0-rc4-dirty Not tainted
 ------------------------------------------------------
 vgic_init/358856 is trying to acquire lock:
 ffff2028021b53c8 (&kvm->srcu){.+.+}-{0:0}, at: __synchronize_srcu+0x0/0x170

 but task is already holding lock:
 ffff2028021b4f80 (&kvm->arch.config_lock){+.+.}-{3:3}, at:
kvm_vgic_destroy+0x50/0x1e0

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&kvm->arch.config_lock){+.+.}-{3:3}:
        __mutex_lock+0x84/0x400
        mutex_lock_nested+0x24/0x30
        vgic_mmio_write_v3_misc+0x48/0x120
        dispatch_mmio_write+0x90/0x128
        __kvm_io_bus_write+0xb4/0xec
        kvm_io_bus_write+0x68/0x100
        io_mem_abort+0xf0/0x3f0
        kvm_handle_guest_abort+0x5d0/0x108c
        handle_exit+0x6c/0x1c4
        kvm_arch_vcpu_ioctl_run+0x41c/0xac4
        kvm_vcpu_ioctl+0x310/0xaf4
        __arm64_sys_ioctl+0xa8/0xec
        invoke_syscall+0x48/0x110
        el0_svc_common.constprop.0+0x40/0xe0
        do_el0_svc+0x1c/0x28
        el0_svc+0x4c/0x11c
        el0t_64_sync_handler+0xc0/0xc4
        el0t_64_sync+0x190/0x194

 -> #0 (&kvm->srcu){.+.+}-{0:0}:
        __lock_acquire+0x1304/0x2044
        lock_sync+0xd8/0x128
        __synchronize_srcu+0x50/0x170
        synchronize_srcu_expedited+0x24/0x34
        kvm_io_bus_unregister_dev+0x110/0x26c
        vgic_unregister_redist_iodev+0x20/0x2c
        kvm_vgic_destroy+0xe8/0x1e0
        kvm_vgic_map_resources+0xa8/0x138
        kvm_arch_vcpu_run_pid_change+0xc0/0x430
        kvm_vcpu_ioctl+0xa24/0xaf4
        __arm64_sys_ioctl+0xa8/0xec
        invoke_syscall+0x48/0x110
        el0_svc_common.constprop.0+0x40/0xe0
        do_el0_svc+0x1c/0x28
        el0_svc+0x4c/0x11c
        el0t_64_sync_handler+0xc0/0xc4
        el0t_64_sync+0x190/0x194

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&kvm->arch.config_lock);
                                lock(&kvm->srcu);
                                lock(&kvm->arch.config_lock);
   sync(&kvm->srcu);

  *** DEADLOCK ***

 3 locks held by vgic_init/358856:
  #0: ffff20280aa19b40 (&vcpu->mutex){+.+.}-{3:3}, at:
kvm_vcpu_ioctl+0x84/0xaf4
  #1: ffff2028021b40a8 (&kvm->slots_lock){+.+.}-{3:3}, at:
kvm_vgic_destroy+0x44/0x1e0
  #2: ffff2028021b4f80 (&kvm->arch.config_lock){+.+.}-{3:3}, at:
kvm_vgic_destroy+0x50/0x1e0

 stack backtrace:
 CPU: 74 UID: 0 PID: 358856 Comm: vgic_init Kdump: loaded Not tainted
6.11.0-rc4-dirty
 Call trace:
  dump_backtrace+0x98/0xf0
  show_stack+0x18/0x24
  dump_stack_lvl+0x90/0xd0
  dump_stack+0x18/0x24
  print_circular_bug+0x290/0x370
  check_noncircular+0x15c/0x170
  __lock_acquire+0x1304/0x2044
  lock_sync+0xd8/0x128
  __synchronize_srcu+0x50/0x170
  synchronize_srcu_expedited+0x24/0x34
  kvm_io_bus_unregister_dev+0x110/0x26c
  vgic_unregister_redist_iodev+0x20/0x2c
  kvm_vgic_destroy+0xe8/0x1e0
  kvm_vgic_map_resources+0xa8/0x138
  kvm_arch_vcpu_run_pid_change+0xc0/0x430
  kvm_vcpu_ioctl+0xa24/0xaf4
  __arm64_sys_ioctl+0xa8/0xec
  invoke_syscall+0x48/0x110
  el0_svc_common.constprop.0+0x40/0xe0
  do_el0_svc+0x1c/0x28
  el0_svc+0x4c/0x11c
  el0t_64_sync_handler+0xc0/0xc4
  el0t_64_sync+0x190/0x194

Thanks,
Zenghui
