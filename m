Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F4118E1F
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 00:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762390033; cv=none; b=MoyLst7Z+sd5XU/k/pNRpwXOh3OvLtryaqHz6lAnrt6Ov2obQg0r3nUzdzK47emtISgAzAvbsMwuL4VyWYHW4zl7NQwkIklcBfJh4CdCs0rxWzrh12NoDPKPhYNoPyCD1ML/lVm5roYN00iqwGSRwzQacbMmEruKCyGpLmSuPGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762390033; c=relaxed/simple;
	bh=AEGMowcUM3ycr0LiIvHiW83T2NtbNRk/6HmwVq2Rrtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xp5wh4d63tl6mU19yojySISnWe8jXKY/wt5qof04YqPsdYcyH7qG2s/b7q2/TK8fAQFlJOdCc+3hB+bqDXlI5Dxn/32yTiTBabdx5R/GoEH1s9+2RDktmtmxcMHgp7S+oGnchnWSlpqkTSafJFE3L7HOu8Go2qept5AEkcg1t3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c6NbePwe; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c6NbePwe"
Date: Wed, 5 Nov 2025 16:46:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762390029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U0Bjiq2Xph0M3llbuqZGVZYAcyHObQZqhvPhfq18qNY=;
	b=c6NbePwequvxviO+mU2Gee2wFwL7IiWh9CiICU/NHUNugVfFy9JlTMfvfYbEl2sQk2Kjbc
	3vsn8cV9TemYaVrzvVkN7MILmL42mjCLCkt44PkjKwkKGlsX9xecRr6eGb1gdYNtkrv8GZ
	UbuN4LGd2kbYN32eGdPdhzAfTxficSM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may
 take LPI xarray lock
Message-ID: <aQvwA68yqbUV5Iiw@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
 <20250905100531.282980-7-oliver.upton@linux.dev>
 <b4d7cb0f-f007-0b81-46d1-998b15cc14bc@huawei.com>
 <86cy5wvknf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cy5wvknf.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Nov 05, 2025 at 10:28:04AM +0000, Marc Zyngier wrote:
> On Wed, 05 Nov 2025 09:37:10 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> > I got the following splat on a lockdep kernel. The reproducing step can
> > be easily inferred from the backtrace (i.e., starting a guest with an
> > assigned device).

Ouch, sorry about that!

> >  ================================
> >  WARNING: inconsistent lock state
> >  6.18.0-rc4-00019-g284922f4c563-dirty #2390 Not tainted
> >  --------------------------------
> >  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> >  swapper/10/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> >  ffff8000a504de18 (&xa->xa_lock#19){?.+.}-{3:3}, at: vgic_put_irq+0x28/0x110
> >  {HARDIRQ-ON-W} state was registered at:
> >    lock_acquire+0x1c8/0x354
> >    _raw_spin_lock+0x48/0x60
> >    vgic_add_lpi.part.0+0x70/0x2f8
> >    vgic_its_cmd_handle_mapi.isra.0+0x398/0x418
> >    vgic_its_process_commands.part.0+0x4d4/0xfa0
> >    vgic_mmio_write_its_cwriter+0x80/0xa4
> >    dispatch_mmio_write+0xd0/0x128
> >    __kvm_io_bus_write+0xb4/0xe8
> >    kvm_io_bus_write+0x58/0x98
> >    io_mem_abort+0xe8/0x3f0
> >    kvm_handle_guest_abort+0x4d0/0x1414
> >    handle_exit+0x6c/0x1c4
> >    kvm_arch_vcpu_ioctl_run+0x678/0xbfc
> >    kvm_vcpu_ioctl+0x1ac/0xb24
> >    __arm64_sys_ioctl+0xac/0x104
> >    invoke_syscall+0x48/0x10c
> >    el0_svc_common.constprop.0+0x40/0xe0
> >    do_el0_svc+0x1c/0x28
> >    el0_svc+0x50/0x2c0
> >    el0t_64_sync_handler+0xa0/0xe4
> >    el0t_64_sync+0x198/0x19c
> >  irq event stamp: 5415534
> >  hardirqs last  enabled at (5415533): [<ffff8000813e291c>]
> > default_idle_call+0x7c/0x138
> >  hardirqs last disabled at (5415534): [<ffff8000813dabf4>]
> > enter_from_kernel_mode+0x10/0x3c
> >  softirqs last  enabled at (5415516): [<ffff8000800c7b54>]
> > handle_softirqs+0x4ac/0x4c4
> >  softirqs last disabled at (5415511): [<ffff800080010748>]
> > __do_softirq+0x14/0x20
> > 
> >  other info that might help us debug this:
> >   Possible unsafe locking scenario:
> > 
> >         CPU0
> >         ----
> >    lock(&xa->xa_lock#19);
> >    <Interrupt>
> >      lock(&xa->xa_lock#19);
> > 
> >   *** DEADLOCK ***
> > 
> >  2 locks held by swapper/10/0:
> >   #0: ffff00280db646a0 (&ctx->wqh#2){-...}-{3:3}, at:
> > eventfd_signal_mask+0x38/0xc0
> >   #1: ffff8000a504e480 (&kvm->irq_srcu){.?.+}-{0:0}, at:
> > irqfd_wakeup+0x88/0x2ac
> > 
> >  stack backtrace:
> >  CPU: 10 UID: 0 PID: 0 Comm: swapper/10 Kdump: loaded Not tainted
> > 6.18.0-rc4-00019-g284922f4c563-dirty #2390 PREEMPT
> >  Call trace:
> >   show_stack+0x18/0x24 (C)
> >   dump_stack_lvl+0x90/0xd0
> >   dump_stack+0x18/0x24
> >   print_usage_bug.part.0+0x29c/0x358
> >   mark_lock+0x6c0/0x960
> >   __lock_acquire+0xd4c/0x20fc
> >   lock_acquire+0x1c8/0x354
> >   vgic_put_irq+0x54/0x110
> >   vgic_its_inject_cached_translation+0x178/0x25c
> >   kvm_arch_set_irq_inatomic+0xac/0x124
> 
> Right. This might_lock() is gross, and clearly doesn't do the right
> thing outside of direct injection of LPIs.
> 
> I think we should drop it, but we should ensure that lpi_xa.xa_lock is
> never taken in interrupt context.
> 
> Oliver, what do you think?

It is possible (albeit improbable) that the last reference to an LPI gets
dropped here after injecting a cached translation. When that is the
case, vgic_put_irq() will take the xa_lock from an irq context. So
I'd say the might_lock() here is valid.

Zenghui, does reverting 982f31bbb5b0 ("KVM: arm64: vgic-v3: Don't require
IRQs be disabled for LPI xarray lock") make this go away?

Thanks,
Oliver
