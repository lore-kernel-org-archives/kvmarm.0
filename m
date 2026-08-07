Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7975A3A3E7A;
	Fri,  7 Aug 2026 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116546; cv=none; b=ip06Y/JIbn1XE27kbXdlGy3cx0SildFvtZWE15Mp5FELbAWfXsW3MLXw8AKQbV5kg5AzLNnAmnmduLni8OUGjtJT29Tmi+1DqLuHT0tLyIxXml7HigMgvGPlvhv958Wf9iSrNm0T9zjih7cFd8rSmIgVU+ZXIO5al8soJ/wcZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116546; c=relaxed/simple;
	bh=vPVZTrknIyM46hH9bR+9qD8b6SFdxFQ1zOpnSjE9/rc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sv+N5myoYlU6obuj//BK1aMw91EsfoG1Hg8GYl1489O1tW7aAm7GXQYxrvT8VOLSA0Q+6Th0wughsxpkC5ly964UuM5UIo2zJo59Bszkcf1aMwgsL6GFFi4NeWKc/KowquP0NlCGWIoj3Gbk+j31eIeQe6XQstN4xpIuuHN7EV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jk4oMTSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jk4oMTSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF92D1F00A3A;
	Fri,  7 Aug 2026 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786116545;
	bh=OOlzRbljKnkFu16/MB9PVUB8MCO2lX7/OJp5C/PvegQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jk4oMTSOG4RSb2iXlPWPRNmCmYLM8asBJvfEEZ5UQRPs7o+YiI0IqIWMz2vLWXco/
	 y4RcwjV7BBOSQJ1jtzRmnntbPAmE/ByHrRkCk8Y6qoOpFqyj0DJLCLIcD8AySK5lzG
	 Awe/ApMw/kZhJA6QJoCtev+9GxG5ntmuPo7ZHqzYa4Ztmg+G+wGaLz+kwHSSFiZibB
	 GQTe9c3oRDSPUpu2rjTR514KBFMGZOeD5uFTtOLhjbL2NaQivw/OYLR98AAnwWPJD/
	 ZK3z49cwPjLA646vRabX6GDRopbumjJwlEw6pVGBN4OStfb3GoX+Q0FwzVDW7OQml8
	 bEnMu2MTDZrFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-29-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-29-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 15:29:04 +0000
Message-Id: <20260807152904.EF92D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Reusing KVM_DEV_ARM_VGIC_GRP_NR_IRQS with conflicting semantics =
for VGICv5 creates a UAPI inconsistency that breaks generic VMM initializat=
ion.
--

--- Patch [28]: [PATCH v5 28/49] Documentation: KVM: Extend VGICv5 device a=
ttribute docs ---
commit b29b54b5c700b9d3c2f478e0ca8a49cc3cef29a7
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Extend VGICv5 device attribute docs

This commit updates the VGICv5 documentation to cover PPI, SPI, and LPI
interrupts. It documents the GICv5 IRS address attribute and its GPA layout,
as well as a GICv5-specific interpretation of the KVM_DEV_ARM_VGIC_GRP_NR_I=
RQS
attribute.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 70b9162755c7e..c782ea4d4609c 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst

[ ... ]

> +  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
> +   Attributes:
> +
> +    A value describing the number of SPIs for this GIC instance. This is
> +    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or =
PPIs.

[Severity: Medium]
Does reusing the KVM_DEV_ARM_VGIC_GRP_NR_IRQS attribute with conflicting
semantics for VGICv5 create a UAPI inconsistency that breaks generic VMM
initialization?

VMMs that use shared, generic GIC initialization code will likely pass
num_spis + 32 (the standard for GICv2/v3) to this attribute. Will this
cause them to incorrectly provision the number of IRQs for VGICv5, either
allocating an unintended number of SPIs or failing initialization entirely
if the value exceeds the GICv5 SPI limit?

> +    The value ranges from 32 to KVM's VGICv5 maximum of 1024 SPIs, in
> +    increments of 32. If userspace does not set this attribute, KVM uses=
 32
> +    SPIs by default.
> +
> +    kvm_device_attr.addr points to a __u32 value.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D28
