Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356AB486BA9;
	Fri,  4 Sep 2026 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524733; cv=none; b=hY8TqHz8HYlTR9bce8+JQEmSp6lQ6Sq1xQHd5NIx8pteIVlKnXuZG1h6sNN+Dqpc007tgJL/ImP/DYMtzhyv384ZNqEgqDE43aNO+plUscM7GWRLGTgQEcRQlcPnG2M98J4Ko6UVe0RSemQqr5PBUPXT5vH9dZ7FiftngZjn1Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524733; c=relaxed/simple;
	bh=CpbtbD7Wc33g45Bskij5TX68g1CWOovrGGNmK+xuQK0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tRA2ws4Qew7TqAtbvrDQLBUrXTDqE1KsfjZ2j78NjWhhIH3U4uqRntV4ZDCONEalh3SUpoXKvV5M84qJL1YLfwZotTpWyasl7ezWxmMNYnRjBH0VHVBqv3mHPwJBZmVCz3UStPPQrFAZ6sx901jeqTcalUaYa7jHagEVQ0Bp20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXEgtco9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXEgtco9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607ED1F00A3D;
	Fri,  4 Sep 2026 12:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524730;
	bh=E9afYG0/R8lNe/CXj2Qyka4QqhMua5LYQqQOfSJwHsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UXEgtco9rxSmCP1L+lWwcmKWqSsLts29bMxveNqLsuYe8DoKFROPbTCVI5G0OavCT
	 izUnymeNJtgbges/4GsKTi26w5Z1R6hKZeuf62eWYxAsiQLYXvMIt5i03zR6SrgZP5
	 Unmmwc2Ph3s6XZx7HxujYcgRugODXl/0+T3SeBWGAnNc3zNRczPqo8arCWtSxHnX8z
	 v6KcgfsPUNJXRyswG0dDCqJB9pl+ify5WputZxkde5l/Vuke6Cil7tnyiSLSVfU8zY
	 6hxx1FYd4UZI/wdsbz7MUYQ/Tf8QOswn4qQHAU5pIoBd988diCyKTYGsCvFkPgb3KA
	 uS63PqUk02DXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/49] KVM: arm64: gic-v5: Cache host IRS ID
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260904113404.4051341-8-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:25:29 +0000
Message-Id: <20260904122530.607ED1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Integer truncation in vgic_v5_irs_vped_size and vgic_v5_irs_vmd_si=
ze can lead to zero-sized allocations and host memory corruption.
--

commit 04b027d3b388107549c9e9457c0e98e85ca72ba3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Cache host IRS ID registers

This commit caches the GICv5 IRS ID registers (IRS_IDR2, IRS_IDR3, IRS_IDR4)
instead of extracting their individual fields into kvm_vgic_global_state. It
also introduces accessor helpers to derive capabilities directly from these
cached registers.

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 086b7578e5f33..c82aa7c9e3f32 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
[ ... ]
> @@ -627,6 +643,65 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
[ ... ]
> +static inline u16 vgic_v5_irs_vmd_size(const struct vgic_v5_irs_caps *ca=
ps)
> +{
> +	if (!(caps->idr3 & GICV5_IRS_IDR3_VMD))
> +		return 0;
> +
> +	return BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, caps->idr3));
> +}

[Severity: High]
Will this return type truncate the descriptor size to 0?

The hardware field GICV5_IRS_IDR3_VMD_SZ is 6 bits, allowing values up to 6=
3.
If the host hardware provides a size shift >=3D 16, BIT() will produce a va=
lue
>=3D 65536. Casting this to u16 truncates it to 0.

When vgic_v5_probe() uses this size to allocate the descriptor tables, a
0-byte allocation results in a ZERO_SIZE_PTR. KVM will then program
virt_to_phys(ZERO_SIZE_PTR) into the host GIC hardware, which can cause
host physical memory corruption when the hardware accesses it.

> +
> +static inline u16 vgic_v5_irs_vped_size(const struct vgic_v5_irs_caps *c=
aps)
> +{
> +	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, caps->idr4));
> +}

[Severity: High]
Can the same truncation occur here?

Similar to the VMD size above, GICV5_IRS_IDR4_VPED_SZ is a 6-bit field. If
the hardware reports a shift >=3D 16, BIT() produces a value that truncates
to 0 in a u16 return type, leading to the same zero-sized allocation issue
when programming the Virtual PE Descriptor size.

> +
> +static inline u32 vgic_v5_irs_max_vpes(const struct vgic_v5_irs_caps *ca=
ps)
> +{
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D7
