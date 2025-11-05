Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510D1E572F
	for <kvmarm@lists.linux.dev>; Wed,  5 Nov 2025 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762335436; cv=none; b=QVAYZ1CIvfDivNFHmjNcL5d79D0F3MYKPEtpD0YL+Vm0SLhRzlSDFTNdhP69Ekvn77E1blLi7uWchmXhCKnL5BgP63Wi49qaKUW6pu8AzPduflrpnF9j8hJByVPlzg0K+1Z77Yly97scKLUjoiRMu3MlxdZDLb1gptHIIzGimyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762335436; c=relaxed/simple;
	bh=GgAYd8m09eAkiFvYHfWthaUQ1qqw4sQEEnpEmXaxa5I=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BsjblBCfKG5g/jMvERXkfwfz21jg/6TzaNx9zA4+wSCG8WvYFXlySDNEej+VeaS24D0OCbwwny7ypvwetmB+PU082UYBQRvjaZtt7WUkbhtbUR/OEzWLQ3P/BtFamBXy0Mw5OwHU6CNdCmvHurJColellrcFpxeX/625+IECM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=a+4+iU/J; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="a+4+iU/J"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DZut6UUlhMErLbvp+0SGWnWDqtR3mrE8M0cra01Munc=;
	b=a+4+iU/JM4Y+ta/pNg5p6q1UU1/k6pFpKrzpPlmOjMMv2aaD9Pah0kOGeGF99WrxPCDjcjUxs
	n2QYSXMBhUdCSGpNtzlzcp3GhnDMhJWu9hjzvGENWXfAzFGkXfhXDqPKUSM5QbLJQD7ipMq8BEs
	oSxrX5bt1eg5J3AT2nUQFnc=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d1gD82LpxzmV6n;
	Wed,  5 Nov 2025 17:35:36 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id ACA9D140156;
	Wed,  5 Nov 2025 17:37:11 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Nov 2025 17:37:10 +0800
Subject: Re: [PATCH v2 6/6] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may
 take LPI xarray lock
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Ben Horgan
	<ben.horgan@arm.com>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
 <20250905100531.282980-7-oliver.upton@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b4d7cb0f-f007-0b81-46d1-998b15cc14bc@huawei.com>
Date: Wed, 5 Nov 2025 17:37:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250905100531.282980-7-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Hi Oliver,

On 2025/9/5 18:05, Oliver Upton wrote:
> The release path on LPIs is quite rare, meaning it can be difficult to
> find lock ordering bugs on the LPI xarray's spinlock. Tell lockdep that
> vgic_put_irq() might acquire the xa_lock to make unsafe patterns more
> obvious.
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index a21b482844ce..3b247041a130 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -142,6 +142,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> +	if (irq->intid >= VGIC_MIN_LPI)
> +		might_lock(&dist->lpi_xa.xa_lock);

I got the following splat on a lockdep kernel. The reproducing step can
be easily inferred from the backtrace (i.e., starting a guest with an
assigned device).

 ================================
 WARNING: inconsistent lock state
 6.18.0-rc4-00019-g284922f4c563-dirty #2390 Not tainted
 --------------------------------
 inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 swapper/10/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 ffff8000a504de18 (&xa->xa_lock#19){?.+.}-{3:3}, at: vgic_put_irq+0x28/0x110
 {HARDIRQ-ON-W} state was registered at:
   lock_acquire+0x1c8/0x354
   _raw_spin_lock+0x48/0x60
   vgic_add_lpi.part.0+0x70/0x2f8
   vgic_its_cmd_handle_mapi.isra.0+0x398/0x418
   vgic_its_process_commands.part.0+0x4d4/0xfa0
   vgic_mmio_write_its_cwriter+0x80/0xa4
   dispatch_mmio_write+0xd0/0x128
   __kvm_io_bus_write+0xb4/0xe8
   kvm_io_bus_write+0x58/0x98
   io_mem_abort+0xe8/0x3f0
   kvm_handle_guest_abort+0x4d0/0x1414
   handle_exit+0x6c/0x1c4
   kvm_arch_vcpu_ioctl_run+0x678/0xbfc
   kvm_vcpu_ioctl+0x1ac/0xb24
   __arm64_sys_ioctl+0xac/0x104
   invoke_syscall+0x48/0x10c
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x50/0x2c0
   el0t_64_sync_handler+0xa0/0xe4
   el0t_64_sync+0x198/0x19c
 irq event stamp: 5415534
 hardirqs last  enabled at (5415533): [<ffff8000813e291c>]
default_idle_call+0x7c/0x138
 hardirqs last disabled at (5415534): [<ffff8000813dabf4>]
enter_from_kernel_mode+0x10/0x3c
 softirqs last  enabled at (5415516): [<ffff8000800c7b54>]
handle_softirqs+0x4ac/0x4c4
 softirqs last disabled at (5415511): [<ffff800080010748>]
__do_softirq+0x14/0x20

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&xa->xa_lock#19);
   <Interrupt>
     lock(&xa->xa_lock#19);

  *** DEADLOCK ***

 2 locks held by swapper/10/0:
  #0: ffff00280db646a0 (&ctx->wqh#2){-...}-{3:3}, at:
eventfd_signal_mask+0x38/0xc0
  #1: ffff8000a504e480 (&kvm->irq_srcu){.?.+}-{0:0}, at:
irqfd_wakeup+0x88/0x2ac

 stack backtrace:
 CPU: 10 UID: 0 PID: 0 Comm: swapper/10 Kdump: loaded Not tainted
6.18.0-rc4-00019-g284922f4c563-dirty #2390 PREEMPT
 Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x90/0xd0
  dump_stack+0x18/0x24
  print_usage_bug.part.0+0x29c/0x358
  mark_lock+0x6c0/0x960
  __lock_acquire+0xd4c/0x20fc
  lock_acquire+0x1c8/0x354
  vgic_put_irq+0x54/0x110
  vgic_its_inject_cached_translation+0x178/0x25c
  kvm_arch_set_irq_inatomic+0xac/0x124
  irqfd_wakeup+0x1a0/0x2ac
  __wake_up_common+0x94/0x10c
  __wake_up_locked_key+0x1c/0x28
  eventfd_signal_mask+0x78/0xc0
  vfio_msihandler+0x18/0x28
  __handle_irq_event_percpu+0x8c/0x374
  handle_irq_event+0x4c/0xa8
  handle_fasteoi_irq+0x108/0x198
  handle_irq_desc+0x40/0x58
  generic_handle_domain_irq+0x1c/0x28
  gic_handle_irq+0x4c/0x120
  call_on_irq_stack+0x30/0x48
  do_interrupt_handler+0x80/0x84
  el1_interrupt+0x3c/0x60
  el1h_64_irq_handler+0x18/0x24
  el1h_64_irq+0x6c/0x70
  default_idle_call+0x80/0x138 (P)
  do_idle+0x21c/0x27c
  cpu_startup_entry+0x34/0x3c
  secondary_start_kernel+0x144/0x164
  __secondary_switched+0xc0/0xc4

Thanks,
Zenghui
