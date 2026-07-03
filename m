Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F79274658;
	Fri,  3 Jul 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096072; cv=none; b=gap4IEeGwDfjjoTPuVRN8a2LEmbJ4v5avlNYPy+C/ECfeHhDvbXzIWVlY7k5VxqSUqmYEQYJ4TxIPbVtpjJT91lZfF4t/Pv+JdoRieiQc0mgRboGs0rDZsg2NHTc9e181eb3Ipzy/3Fh2pkUT/GT206pE1qFhH6XJNDyK/Wc18s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096072; c=relaxed/simple;
	bh=QSzJ3lq0NA5nGjGariJ8dHpn+5Dg3VsZ4IquM//3FO0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iWJlaBGM/1J0abN3Tmjg/rH+E8TAmKNpWud0Ueyhc2SYkZDq7ox3cWZcrO/tFE6ut/uD4Ay8YSVhE7SiOmM1sz16Phk9SO+CCN5VIff73rYhf2SuN09DvXKfADM8jBxMHK8AEfdgmIijKl3YWcxPL5g1mhrm1ZsfwWjTRvI0QFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrWUHYnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrWUHYnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DF41F000E9;
	Fri,  3 Jul 2026 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096070;
	bh=IjR5hjjzRRrefQ33nZ6HDgBp9mYkwndhRtGLbx4cJZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GrWUHYnnFn9XRKg42UqYDgl5FHobq+WEHWETGo3mVA7dHif72DUhgmU1tpOkEUHUO
	 nk6MAkKnu18qppaOUPR+1cXvXQ0qjeECQx4gQsVtD8qOmgllehsaEoblXXu8q3I8/H
	 h0H5Sn77ZhPJ4opWoiMiO4VKSF4lPdEN4HjYCRU/IB8uT6XyuKM3Cou+mShqu1pZe2
	 nE5jekDmJ1VAstgipXV2JSbhKWc8+9pBU//VMMAjAzuW+hEqfNZynuOdPdwkrzExCW
	 skLmfPfDKy9L3Jyxk4HAcretXlNP5FfhFJfsGQN0lK1w43Q13ffmS9sex0ESx7Uh1C
	 83LUYO9HzjErw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/40] Documentation: KVM: Extend VGICv5 docs for
 KVM_VGIC_V5_ADDR_TYPE_IRS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-31-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-31-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:27:49 +0000
Message-Id: <20260703162749.E9DF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message fails to mention the documentation added for =
`KVM_DEV_ARM_VGIC_GRP_NR_IRQS`.
--

commit 92443b4583f2d91d23b1a76accf4a3fbb6ee8c84
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Extend VGICv5 docs for KVM_VGIC_V5_ADDR_TYPE_IRS

This commit updates the VGICv5 documentation to specify the GPA space
requirements for the GICv5 IRS. It also expands the supported interrupt
types and adds documentation for the KVM_DEV_ARM_VGIC_GRP_NR_IRQS group.

> Now that it is possible and required to set the address of the GICv5
> IRS in GPA space, update the documentation accordingly. This region
> must be 64KByte-aligned, and covers a total range of 128KBytes.

[Severity: Medium]
Is the commit description missing some context? The message focuses entirely
on KVM_VGIC_V5_ADDR_TYPE_IRS, but the patch also introduces the following
documentation block for KVM_DEV_ARM_VGIC_GRP_NR_IRQS:

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 70b9162755c7e..5c6323d82f784 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
[ ... ]
> +  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
> +   Attributes:
> +
> +    A value describing the number of SPIs for this GIC instance. This is
> +    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or =
PPIs.
> +    The value ranges from 32 to the maximum value reported by
> +    GICV5_IRS_IDR5.SPI_RANGE, in increments of 32. If userspace does not=
 set
> +    this attribute, KVM uses 32 SPIs by default.

Could the commit message be expanded to accurately describe the full scope
of the documentation changes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D30
