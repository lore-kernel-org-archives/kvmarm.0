Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EAA30D3EF;
	Fri,  3 Jul 2026 16:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096403; cv=none; b=Yia+cgR+y0Snkckijtup7hJF8EhvPOdqRMQKWe9XTTBM1GU5yzOqCKDYcT7ym094K/c1da+PI2v5AvTFYj939VcuOXK/iUc54HuGcf070w1Bd8A4CnDMsqcWxiZY+O0XV3jR6wg+LT1RbZqxisMJ85pwqF2kdJonTq6Zf0k5Dj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096403; c=relaxed/simple;
	bh=4ooGemjroHOkN2Fv3Tr+5Te0QzoiNzjhaHXiObfbvP0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sELpqJD158f3uZDB85AwHY0hOtcFLVtEZ57IPt7kds9fhBKi61rLwudtH1r5nqFDfAWNwBQOroq7VuRl2cpAL7L87s53ifHB0VpFsQRTIRWvfZUOZ02TCmgTdHUlIVgb5VxVwDOBFavYOl/X543b51SP3z5nG24aWey6LxbNsOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LP0HGsM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LP0HGsM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4391F000E9;
	Fri,  3 Jul 2026 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096401;
	bh=N9Jq3kjNV674DbijTSDDVQe4/R2z9zJTzA0301+rZt8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LP0HGsM694SBLnj1hiY+Mr5orX5Jt2ZaHyyklODgB2teTZKstS3koyN165H7Bqd97
	 o/0qeLQ7uv/+BaExB3wZzgzjKylz3v19kk8qMkCXdpqdPrRXgwMsPJYfw27yUKwUVC
	 +rkYY32h9cspwnMCi5aOI047r8wsZikT5iEOknwXxMmo+pWfS0DIwAar6ziYqtZolF
	 79Jm616LC0jHQjT9kl1/yQLrgcUlf4I+SQ9Dyx44uYmpuON1BwZeqkkwGV+odV/rt/
	 wB6+zyG1I0XrQGGCeORecMgocHj598FUwbNjKvaYbar2ZGa1zOA3tyewgnlK2clCfZ
	 yzUiiwspY024w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 40/40] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-41-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-41-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:33:21 +0000
Message-Id: <20260703163321.8A4391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Crucial MMIO register restore ordering constraints detailed in t=
he commit message are omitted from the added documentation, which can lead =
to failed guest restoration.
--

commit 79d8bc0db4bccb0f97ab687e528e56b0455f7ae3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Add the VGICv5 IRS save/restore sequences

This commit documents the required sequences for saving and restoring
the state of the virtual GICv5 IRS to avoid failures when restoring a guest.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst

[ ... ]

> +IRS Restore Sequence:
> +---------------------
> +
> +The following ordering must be followed when restoring the virtual GICv5=
 and
> +IRS:

[ ... ]

> +e) Restore guest memory.
> +f) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
> +   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. KVM uses the restored IRS_IST_CFGR and
> +   IRS_IST_BASER state to allocate the LPI IST during the following step.
> +g) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on

[Severity: Medium]
The commit message notes that IRS_IDx registers must be restored first,
and that IRS_IST_CFGR must be restored prior to IRS_IST_BASER. Should these
intra-group ordering constraints be explicitly mentioned in step f?

Without these constraints documented here, userspace implementers might
restore the MMIO registers in an arbitrary or address-sequential order,
which the commit message states will almost certainly fail to restore a gue=
st
capable of handling interrupts correctly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D40
