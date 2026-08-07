Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C4837FF68;
	Fri,  7 Aug 2026 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121570; cv=none; b=SmOYOgsFl1LCRdGfBdSsRFXOHS8bFQFwSbWxHTo55eNoX1Gve/qDoWhm9t5YZkUzY4VVmIW1+2OGGlusaJQVaW2Vlze6+B+ff6UJD8Zd51ufFWpj5JrtW5jTmkRYWt++APQpnwRZrpp/S8uaghgoCdp6MIMrQX7YFKGIpH1jNHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121570; c=relaxed/simple;
	bh=m1Lrigw36CXsM5Jgst+loU0naiCW4ioLnVPV8fDQFIU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Hjo9VJlb2pZPMgob9ULDIqRlyzRnmOK26CTdC7cDx4X7VJsfNuRxUrSXaKi/2+HvbbXKMJoD9o3xf+Y10Ad+T+8rVn5+RDI+f34y/mMNiN/abAI+BxqktyX20L1+XT9zFWnQdhgcjtlAQnhcgQGjQDlot1ULlmpEc5KmcyPbIvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Me+wLhnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Me+wLhnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701EE1F000E9;
	Fri,  7 Aug 2026 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121569;
	bh=18sgdS/ICGLtHq/FN1oCpWttdaCWU5mPGOIRpYxz0mQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Me+wLhnUkDRwxhvhV6gGU8pjPw1mPspFujXqYi2B2JBxVnFtxWfGAQBK/hJ5l06uO
	 Jol8Y0VkI/KthjApIFVpZiXoyI4XX168L8LelS/jC/pB0wdt8mNQepde+1CWFW8zJ6
	 keCzhAG0UWjNFAHXoNKseOb1p3POP7OUBvFaXzZJextHXmu78VzxYJrFl1d+lIAe7c
	 82QNvf2EDJnPkS1RSsD5ynhsb5e/c8bLFh6Z/HkwlmzVJuxsWbNOEeWSwyHE8UKLBZ
	 g5kQMsvZQoRla+C1XPOzXEfOQuONPGBpd+g27yrUDMNu9cLSKYXmY67DybL56W0FX0
	 W8Ax7c+inGRCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 37/49] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-38-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-38-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:52:49 +0000
Message-Id: <20260807165249.701EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing indentation for the KVM_DEV_ARM_VGIC_GRP_IRS_REGS group bre=
aks the document's list structure.
--

--- Patch [37]: [PATCH v5 37/49] Documentation: KVM: Add KVM_DEV_ARM_VGIC_G=
RP_IRS_REGS to VGICv5 docs ---
commit e5dffc46ed9c5cdaecdbb49991374d8f99bfa132
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs

This commit documents the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used
to read and write the virtual IRS's MMIO register state. It provides a
GICv5-specific interface using IRS terminology.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 7e41d6699538f..6dd3ff555ba02 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -149,3 +149,50 @@ Groups:
>      -EBUSY   VCPU is running, or write attempted after a VCPU has run
>      -EINVAL  Invalid mpidr or register value supplied
>      =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +
> +KVM_DEV_ARM_VGIC_GRP_IRS_REGS

[Severity: Low]
This isn't a bug, but does this group name need to be indented by two space=
s?

Being flush left breaks the list structure under the "Groups:" section. This
will cause the entry to be rendered as a top-level paragraph rather than a
list item in the generated HTML documentation.

> +    Attributes:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D37
