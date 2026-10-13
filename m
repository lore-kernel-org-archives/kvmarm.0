Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40F3C1419;
	Tue, 13 Oct 2026 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885002; cv=none; b=JRG5tGfT2nHFKiBsXu8RPUyD+JsL1Hte0CDJtgznCgZF5YUUzsPLB0q3uwZeau1aSr3Tc8iWkZAMTF05zEgCSplisjpLc30cD0q/xXMXWARSQqyJaIPBGUjCTVVNoLTqWYsaBFensMROUPCNWyvIkMNjwAck6Z85WlCTQiNtLks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885002; c=relaxed/simple;
	bh=idIl52e02jXTxRAG8R7Otgm6OgjBgSuRfL7EacxHpYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA4OZqFEoreYfMiuVXBixY4oReTf7H21QE0QgeK3ru20mT8SPk7sSq9T8xCT2XkWkUqU0YbP28rRD5BoskDDV1RHpC9A4hompouXqIGC6ztro+raMh0MilXqc1PXa62xRcprkOWdXDWjvBJsykDlrtiLvdMcb+igH9Vhlse2aPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3K2649V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3K2649V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A0A1F000FF;
	Tue, 13 Oct 2026 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885000;
	bh=2kWuPYcAL6kOilfqJn43FNi9ku5creI58f/N2ytqYz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C3K2649VPixC4TS0l/sU7HD47yxSIFjA5pf3aMdt6mWl89U+gLWLgTVJQWBuV16rc
	 pFn5vFTRCXDq102JGUIo9EfWpFLToPbGDvHWBevzUXFJKJjONn+svohMzTCDrIMHDh
	 IZ/bytDkSbiVnwVglm0xLtIO36kCayHDVc8u/nq2nsyTTDNyxmakJ0Cew00KTgUF04
	 ebJ6dXp5z6uefmEtJYwNzWT0evCDxi3lMEVKqkgAsVMcX8Qn19E71AcBd3zHta76wK
	 YpogugwmfsWidvb4AyN/VqBsClJ+RPAafmLyB9Y8cEtdzZTjwkasMQsTd18cNmXgFI
	 yyQll6xL+Rj0g==
Date: Tue, 13 Oct 2026 02:49:54 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: vgic-its: Remove the pending state of
 a discarded LPI
Message-ID: <as3-wkYnyOxu-Xlh@kernel.org>
References: <20261013081646.933312-1-fuad.tabba@linux.dev>
 <20261013081646.933312-3-fuad.tabba@linux.dev>
 <sashiko-outbox-169278@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-169278@kernel.org>

On Tue, Oct 13, 2026 at 08:50:51AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] kvm: arm64: vgic-its: TOCTOU race resurrects discarded LPI due to IPI skip
> - [High] kvm: arm64: vgic-its: Race on vcpu->arch.pause breaks mutual exclusion
> - [Medium] kvm: arm64: vgic-its: Global VM halt on DISCARD causes Denial of Service
> --
> 
> commit 4bb7971d12d2fa6f1083c9f2ddc383b8d63483fb
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> KVM: arm64: vgic-its: Remove the pending state of a discarded LPI
> 
> This commit ensures the pending state of a queued LPI is cleared when handling
> an ITS DISCARD command. It halts the guest before clearing the pending state if
> the LPI is queued on a running vCPU.
> 
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -829,12 +829,26 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
> >  		struct its_device *device = find_its_device(its, device_id);
> >  		int ite_esz = vgic_its_get_abi(its)->ite_esz;
> >  		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
> > +		struct vgic_irq *irq = ite->irq;
> > +		bool queued;
> > +
> > +		vgic_its_invalidate_cache(its);
> > +
> >  		/*
> > -		 * Though the spec talks about removing the pending state, we
> > -		 * don't bother here since we clear the ITTE anyway and the
> > -		 * pending state is a property of the ITTE struct.
> > +		 * A queued LPI can be pending in a running vCPU's list register,
> > +		 * which the exit path folds back: halt the guest before clearing.
> >  		 */
> > -		vgic_its_invalidate_cache(its);
> > +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> > +			queued = irq->vcpu;
> > +
> > +		if (queued)
> > +			kvm_arm_halt_guest(kvm);
> 
> [Severity: Medium]
> Does this introduce a denial of service if a guest spams DISCARD commands?
> 
> Because kvm_arm_halt_guest() forces all vCPUs in the VM to exit, a guest
> rapidly issuing DISCARD commands for a single vCPU's LPI could repeatedly
> lock up the entire VM and cause host starvation. Could we restrict the
> synchronization strictly to the target irq->vcpu where the LPI is queued?

A guest has chosen to shoot itself in the foot, why should we care? The
whole point of pausing the VM is to flush state and block the vCPU
threads...

> > +
> > +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
> > +			irq->pending_latch = false;
> 
> [Severity: High]
> Is there a window here where an exiting vCPU might overwrite the cleared
> latch and resurrect the LPI?
> 
> If the target vCPU is just exiting when kvm_arm_halt_guest() broadcasts
> KVM_REQ_SLEEP, the vCPU sets vcpu->mode = OUTSIDE_GUEST_MODE before folding
> its hardware state in kvm_arch_vcpu_ioctl_run().
> 
> Because kvm_request_needs_ipi() checks:
> 
> virt/kvm/kvm_main.c:kvm_request_needs_ipi() {
>     if (req & KVM_REQUEST_WAIT)
>         return mode != OUTSIDE_GUEST_MODE;
> }
> 
> The IPI is skipped and kvm_arm_halt_guest() returns immediately without
> waiting for the vCPU to sync. The DISCARD thread then clears
> irq->pending_latch = false.
> 
> Concurrently, the exiting vCPU executes kvm_vgic_sync_hwstate(), reads the
> still-pending state from the hardware LR, and unconditionally overwrites the
> cleared latch back to true:
> 
> arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_fold_lr() {
>     if (irq->config == VGIC_CONFIG_EDGE && (val & ICH_LR_PENDING_BIT))
>         irq->pending_latch = true;
> }
> 
> Could we coordinate with the vCPU's state folding sequence to ensure the
> discard isn't lost?

https://lore.kernel.org/kvmarm/20260929093548.3598547-1-maz@kernel.org/

> > +
> > +		if (queued)
> > +			kvm_arm_resume_guest(kvm);
> 
> [Severity: High]
> Can concurrent DISCARD commands on different ITS instances break the mutual
> exclusion of vcpu->arch.pause?
> 
> vgic_its_cmd_handle_discard() executes holding the per-ITS its->its_lock.
> If a VM has multiple ITS devices, two DISCARD commands could run concurrently
> and both call kvm_arm_halt_guest(), which sets vcpu->arch.pause to true
> across all vCPUs.
> 
> The first thread to finish will call kvm_arm_resume_guest(), which does:
> 
> arch/arm64/kvm/arm.c:kvm_arm_resume_guest() {
>     kvm_for_each_vcpu(i, vcpu, kvm) {
>         vcpu->arch.pause = false;
>         __kvm_vcpu_wake_up(vcpu);
>     }
> }
> 
> This unconditionally clears the pause flag and wakes up all vCPUs while the
> second thread is still modifying VGIC state assuming the guest is fully
> halted.
> 

https://lore.kernel.org/kvmarm/20260929093548.3598547-1-maz@kernel.org/

Thanks,
Oliver
