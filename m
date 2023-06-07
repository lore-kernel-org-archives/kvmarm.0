Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC11ACB5
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 15:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D57CC433D2;
	Wed,  7 Jun 2023 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686151767;
	bh=mzXQFcnbgpxCxLLllnDlVrYI8CxDAbXujJB+YCzNOqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DatMQfrTxYx/iC/eMWLZePyv8HHzza+XpUZH37RH617tdqFYmMdYse4xLuGJG58eI
	 3PHZZ9oNr58PVZ/rQsBWdpCvqLYGS7lqkwYJKhaZgXRKNWQPdNkOZsGc+OIXclaL23
	 zGJc+caHUbrYsehIkFvnYg64K9Jy+htdwoGp2wOIiFzsAJqeLTHSP/SlXBr1XNHnH8
	 dar1vy8FtitJxmPryI6sr6eWxPFMQ25T+lVjUwaeArwBkbbX9UUZoVv8G1TXL7Um7E
	 h2dHaqHWyzXu6GYwaIyORBRdxQNkGlowO2ejPWgGk1Us11Qz/IPp3/UA2ze14qmFRJ
	 pk2YPL9HSc0DA==
Date: Wed, 7 Jun 2023 08:29:25 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Fix a circular locking issue
Message-ID: <20230607152925.GA1231177@dev-arch.thelio-3990X>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
 <20230518100914.2837292-2-jean-philippe@linaro.org>
 <20230606221525.GA2269598@dev-arch.thelio-3990X>
 <ZIAUTD9Og0ccyzrv@linux.dev>
 <87h6rjoeh7.wl-maz@kernel.org>
 <20230607132819.GA1086197@myrica>
 <87fs73nwiy.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs73nwiy.wl-maz@kernel.org>

On Wed, Jun 07, 2023 at 04:04:53PM +0100, Marc Zyngier wrote:
> On Wed, 07 Jun 2023 14:28:19 +0100,
> Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:
> > 
> > On Wed, Jun 07, 2023 at 09:37:08AM +0100, Marc Zyngier wrote:
> > > > > After this change landed in 6.4-rc5 as commit 59112e9c390b
> > > > > ("KVM: arm64: vgic: Fix a circular locking issue"), my QEMU Fedora VM on
> > > > > my SolidRun Honeycomb fails to get to GRUB.
> > > > 
> > > > [...]
> > > > 
> > > > > I built a kernel with CONFIG_PROVE_LOCKING=y but I do not see any splats
> > > > > while this is occurring. Additionally, neither my Raspberry Pi 4 or my
> > > > > Ampere Altra system have any issues, so it is possible this could be a
> > > > > platform specific problem. I am more than happy to provide any
> > > > > additional information and test kernels and patches to help get to the
> > > > > bottom of this. My kernel configuration is attached.
> > > > 
> > > > I was unable to reproduce the issues you're seeing on 6.4-rc5, but I
> > > > don't have any different machines from you available atm. Based on
> > > > your description it sounds like your VM was able to do _something_
> > > > since it sounds like a few escape codes got out over serial...
> > > > I'm wondering if you're getting wedged somewhere on a VGIC MMIO access.
> > > > 
> > > > We don't have a precise tracepoint for VGIC accesses, but kvm:kvm_mmio
> > > > should do the trick. So, given that you're the lucky winner at
> > > > reproducing this bug right now, do you mind collecting a dump from that
> > > > tracepoint and sharing the access that happens before your VM gets
> > > > wedged?
> > > > 
> > > > Curious if Marc has any additional insight, since (unsurprisingly) he
> > > > has a lot more experience in dealing with the GIC than I. In the
> > > > meantime I'll stare at the locking flows and see if anything stands
> > > > out.
> > > 
> > > RPI4 is GICv2 nVHE, the NXP machine is GICv3 nVHE, and the Altra is
> > > GICv3 VHE. Not sure this is relevant here, but that's one data point.
> > > 
> > > Having been able to start the guest means that we should have fully
> > > initialised the GIC. So a lockup is likely be an interaction with the
> > > GIC emulation itself, either because we failed to release a lock
> > > during initialisation, or due to some logic error in the GIC emulation
> > > (which is not necessarily MMIO...).
> > > 
> > > I've just given 6.4-rc5 a go on my Synquacer, which is the closest
> > > thing I have to Nathan's NXP box, and I can't spot anything odd.
> > > 
> > > It would also help to get access to the EDK2 build. It wouldn't be the
> > > first time that a change in KVM breaks some EDK2 behaviour.
> > 
> > I found a build here:
> > https://koji.fedoraproject.org/koji/buildinfo?buildID=2204660
> > edk2-aarch64-20230301gitf80f052277c8-31.fc39.noarch.rpm
> > usr/share/edk2/aarch64/QEMU_EFI-silent-pflash.raw
> > 
> > Haven't managed to reproduce the issue yet, but I can only test with QEMU
> > emulating the cortex-a72 and GICv3 at the moment, and I still need to
> > reproduce the VMM command-line exactly. I think it would be helpful to get
> > the exact grub image as well, right now I'm using
> > Fedora-Server-KVM-38-1.6.aarch64.qcow2
> 
> I think I managed to trigger the sucker by using the GICv2-on-GICv3
> feature, which Nathan's HW supports. The vcpu is blocked in WFI, and
> the timer interrupt is never made pending.
> 
> Interestingly, the vgic state reads:
> 
> TYP   ID TGT_ID PLAEHCG     HWID   TARGET SRC PRI VCPU_ID
> [...]
> PPI   27      0 0100110       27        1   0   0      -1
> 
> meaning that we don't see the timer interrupt being enabled (PLAEHCG
> reads as Not-Pending, Line-Level-high, Not-Active, Not-Enabled,
> HW-deactivation, Level, Group0), despite the timer having raised the
> interrupt line (the input level is high).
> 
> So I'm changing tack altogether. This isn't a locking issue, but a
> distributor issue! It feels like we're registering a GICv3 distributor
> instead of a GICv2, so the register map is fscked-up from a guest
> perspective.
> 
> As it turns out, this is indeed exactly what this patch does, by
> always using the host's GIC type instead of what was requested for the
> guest. This works just fine on RPI4 (GICv2) and Altra (GICv3 without
> compat), but totally fails on SQ (GICv3 with GICv2-compat). I expect
> that this is the issue Nathan is facing.
> 
> I came up with the following patch, which fixes it for me on my
> SynQuacer. Nathan, could you please try it with your config?

Works like a charm :)

Tested-by: Nathan Chancellor <nathan@kernel.org>

Thanks a lot for quickly getting to the bottom of this!

> Thanks,
> 
> 	M.
> 
> From f42d872b2796a2a3e719fdc51cc206aa274bf0ed Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 7 Jun 2023 15:38:44 +0100
> Subject: [PATCH] KVM: arm64: Restore GICv2-on-GICv3 functionality
> 
> When reworking the vgic locking, the vgic distributor registration
> got simplified, which was a very good cleanup. But just a tad too
> radical, as we now register the *native* vgic only, ignoring the
> GICv2-on-GICv3 that allows pre-historic VMs (or so I thought)
> to run.
> 
> As it turns out, QEMU still defaults to GICv2 in some cases, and
> this breaks Nathan's setup!
> 
> Fix it by propagating the *requested* vgic type rather than the
> host's version.
> 
> Fixes: 59112e9c390b ("KVM: arm64: vgic: Fix a circular locking issue")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 6eafc2c45cfc..c8c3cb812783 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -446,6 +446,7 @@ int vgic_lazy_init(struct kvm *kvm)
>  int kvm_vgic_map_resources(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> +	enum vgic_type type;
>  	gpa_t dist_base;
>  	int ret = 0;
>  
> @@ -460,10 +461,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	if (!irqchip_in_kernel(kvm))
>  		goto out;
>  
> -	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
> +	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
>  		ret = vgic_v2_map_resources(kvm);
> -	else
> +		type = VGIC_V2;
> +	} else {
>  		ret = vgic_v3_map_resources(kvm);
> +		type = VGIC_V3;
> +	}
>  
>  	if (ret) {
>  		__kvm_vgic_destroy(kvm);
> @@ -473,8 +477,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	dist_base = dist->vgic_dist_base;
>  	mutex_unlock(&kvm->arch.config_lock);
>  
> -	ret = vgic_register_dist_iodev(kvm, dist_base,
> -				       kvm_vgic_global_state.type);
> +	ret = vgic_register_dist_iodev(kvm, dist_base, type);
>  	if (ret) {
>  		kvm_err("Unable to register VGIC dist MMIO regions\n");
>  		kvm_vgic_destroy(kvm);
> -- 
> 2.39.2
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
