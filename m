Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B973BC667;
	Thu, 30 Jul 2026 07:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396575; cv=none; b=QoighlqQuqtzKkZaVjOYFtRDiI7OzDazeWrAP6xxiJS8J8+bynwAcdXfFaZvXnDYyXpv+VHaKiAeNT7zVjzGwVKa/7szwvDA0YrB9EZZOP6hlZ/iwTP+8dP72+12IZ7VUdBu961NY0q4VlJaNVsDXURbVz3rhyX6gZIMmfXLHzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396575; c=relaxed/simple;
	bh=us8/kwHOCkC+ze7eJvt9ZwoEeX8jhB3JVG/ffjRD8GQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AIKOu/c8yc0H+zdb4os449q1Aq/TQa24cGU+yEW6fsjphYGUWkhoU6C7yDlzreDwBCKZ04XFBbX3f0youjG/poF53+tC8RFzq5Jp97NBrjBySqnqCb/GBXmCYsDobqLWG08z9sjYIkXKuP8/KNWrhl82wV5zA6h4ZjfzeuQ+qPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0ucGNIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0ucGNIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DB21F000E9;
	Thu, 30 Jul 2026 07:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785396570;
	bh=uDtXzQYEy6HPSifsXa/sKd1ARzcD5Uk+vzAv7kHR7oI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0ucGNIXmzHYqf5gLRJRjjQ1t/0jLw7AuPWdjhkSRMpZbwgIFDzXeeXz6UeQv0hJ/
	 nCQdNskZs6+HTSyY6f9jD7tC4BHb7RXNDmm/Y3d4qvo83DJsHJyxXVLI1DDdhMymT6
	 iTuEODDnlWZhH4Ym3IYluWGvUa1uCNZPHdwe2+nCHT3qoE5BaqlHTjnw9a1VCT2nmk
	 ezaOgb+H04zHuKVr8Uz7oA9jm4akogys9pMoqpdjP4TIRGKHY1g6q5v8VxBK7rUTAn
	 IHqMlytmSWPtnysNfBX3OunMmNRWTvwQJN1X9wBWHl0X30CFSMu6+37gp6etYHYGfk
	 w8mcz5S5bQpUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/29] KVM: arm64: Merge guest's HCRX_EL2 using
 NV_HCRX_GUEST_EXCLUDE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260730071022.296811-4-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 07:29:29 +0000
Message-Id: <20260730072930.85DB21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The NV_HCRX_GUEST_EXCLUDE macro fails to exclude HCRX_EL2_MCE2, al=
lowing a nested hypervisor to break KVM's transparent MOPS migration handli=
ng.
--

--- Patch [3]: [PATCH v4 03/29] KVM: arm64: Merge guest's HCRX_EL2 using NV=
_HCRX_GUEST_EXCLUDE ---
commit 32a9437b5c31bcb57be7ba071a094800d7980587
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE

This commit refactors HCRX_EL2 handling by introducing a macro that
explicitly lists the bits excluded from the merge, preventing the nested
guest from overriding them.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 18131e395e24c..0903e08f4b6a0 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h

[ ... ]

> @@ -325,6 +325,24 @@ static inline void __deactivate_traps_mpam(void)
>  		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
>  }
> =20
> +/*
> + * Just like for HCR_EL2, we can't let the guest mess with some of the
> + * basics we rely on in HCRX_EL2. However, the major difference is that
> + * HCRX_EL2 only affects EL1, and never EL2 (sudden outburst of sanity, I
> + * guess). So it is always the guest inflicting it on its own guestx.
> + *
> + * Things we don't want to let the guest control are:
> + *
> + * - TMEA: That's for us to decide how an SEA is routed, not the guest.
> + *
> + * - PTTWI: Similarly, it is for us to decide whether Reduced Coherency =
for
> + *   the PTW is a thing. It really isn't.
> + *
> + * - EnIDCP128: We don't allow IMPDEF sysregs -- full stop.
> + */
> +#define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI | \
> +				 HCRX_EL2_EnIDCP128)

[Severity: High]
This isn't a bug introduced by this patch, but since NV_HCRX_GUEST_EXCLUDE
enumerates the bits the nested guest is not allowed to override, should
HCRX_EL2_MCE2 be excluded here as well?

KVM (L0) relies on intercepting MOPS exceptions (via HCRX_EL2.MCE2=3D1) to
handle vCPU physical migrations transparently. If L0 merges a value from the
L1 hypervisor that sets MCE2 to 0 (which happens naturally if L1 does not
support MOPS), and L0 then migrates the physical CPU while L2 is executing a
MOPS instruction, the MOPS exception could trap to EL1 (L2) instead of
EL2 (L0).

Would this cause the nested guest kernel to crash with an unexpected
exception, potentially breaking stability during host migrations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D3
