Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DDC472F6B;
	Fri,  7 Aug 2026 12:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105656; cv=none; b=h2rw8Q6OrJMoz0eONSIubJI2dHMZjkkZtfAuefvj6FNMDQMOOWDtNO9sMb3sHVIAWl03OnIiTDZx4t3G171z6pZr/1giqaku8meQUiMKaqWiWRoeNcRyvRm6l++L1z6AtfKZ2uoBRkSL1hgHMkxxzTHfk3NwsVmXPzAPojjhicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105656; c=relaxed/simple;
	bh=milNRTV9JuCttVXWjmpscNc0sJYd92uIWtAF8wTtPJg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QR3Ay6i6JqNvww+xXlR3dnqtUO1cx+nlPoFyd5ehUBOFkfqWW2Z9mnNYSgIW/TTG9W0Ji8UsRvl8OM1kch9JF5glBfKtv+VR/Zh/VOz5ycBdL00865HZ+3SEv6QOrfaRSTA7QUIEe/AnP0m4NaSjtLXi5/wRj/lMdrLihP52m1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CF0a1fJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CF0a1fJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87211F00AC4;
	Fri,  7 Aug 2026 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786105640;
	bh=ZqqDOsGhnf8PDPJOo5mSEGVCyRUbERg+aniOkAgTNPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CF0a1fJTKkXcJJKsxEqaC23Dpl9V6EWrwQDsHO+sLvy9SqiHQi3Lle/417a7x8o4s
	 ZLfvIcd10Xm/h5sAgI6LIJrsJLchBOaP3yg6c+LJq36S4WF8fLUTe1r7eZSAn2bRnT
	 PKJw8khgJ1yCRN7rfqT3+jVIAXL7fnztEOJXaWahMnIKdmnarRZYJcW2Xoksm4Rykr
	 S1z/nW3SteOSQY0Ysn7ScEn0+f0VHnbii7qx3dSu4vjagj8okP4FwgzNm6YU+IIKrR
	 NbLCq/8LZMjBmbu5E/iVAErYylAwThJtEJP7qTio2bYqzdGqqL0N8jPfKhg42bfTmb
	 H3AzGrEMCqKHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-8-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:27:19 +0000
Message-Id: <20260807122719.B87211F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The hardware-based limit for maximum vCPUs is silently clobbered b=
y a hardcoded maximum in the GICv3 legacy fallback path.
- [Medium] The return type of `vgic_v5_irs_vped_size()` is `u16`, which wil=
l silently truncate descriptor sizes of 64KB or larger to 0.
--

--- Patch [7]: [PATCH v5 07/49] KVM: arm64: gic-v5: Cache host IRS ID regis=
ters ---
commit d81802dd59faf96c570bb509e00ac335dada7904
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Cache host IRS ID registers
   =20
This commit caches the GICv5 IRS ID registers to configure virtual-machine
resources based on hardware capabilities rather than extracting individual
fields. It limits the maximum number of vCPUs using the VPE capacity from
the cached IRS_IDR4 register while retaining KVM's upper bound.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index d4789ff3e7402..41ca2098ecb73 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -61,10 +77,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  		goto skip_v5;
>  	}
> =20
> -	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
> -
> +	vgic_v5_irs_cache_id_regs(info);
>  	vgic_v5_get_implemented_ppis();
> =20
> +	kvm_vgic_global_state.max_gic_vcpus =3D min(vgic_v5_irs_max_vpes(&irs_c=
aps),
> +						  VGIC_V5_MAX_CPUS);
> +

[Severity: High]
Does the GICv3 legacy fallback path under the skip_v5 label in vgic_v5_prob=
e()
overwrite this dynamically computed hardware limit?

If the max_gic_vcpus limit is later expanded by a static value (like
VGIC_V3_MAX_CPUS via a max() assignment), could it permit userspace to crea=
te
more vCPUs for a GICv5 VM than the hardware IRS actually supports (for exam=
ple,
allowing 512 vCPUs even if the hardware restricts it to 16 VPEs)?

>  	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
>  	if (ret) {
>  		kvm_err("Cannot register GICv5 KVM device.\n");

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index fe49fb56dc3c9..c6f0ab69f7a2e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h

[ ... ]

> @@ -630,6 +646,65 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
>  void vgic_v4_commit(struct kvm_vcpu *vcpu);
>  int vgic_v4_put(struct kvm_vcpu *vcpu);
> =20

[ ... ]

> +static inline u16 vgic_v5_irs_vped_size(const struct vgic_v5_irs_caps *c=
aps)
> +{
> +	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, caps->idr4));
> +}
> +

[Severity: Medium]
If a hardware implementation reports a size parameter of 16 or greater
(indicating 64KB or more), will the BIT() operation in vgic_v5_irs_vped_siz=
e()
result in 65536 and silently truncate to 0 when cast to the u16 return type?

Could this zero-byte size calculation lead to 0-byte allocations or infinite
loops in dependent resource sizing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D7
