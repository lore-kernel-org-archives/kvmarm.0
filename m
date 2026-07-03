Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABE6286D4D;
	Fri,  3 Jul 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096880; cv=none; b=L52kvzJIQ3EHcFBEI1oKVT7wEI031M4T3IYshjL+Qdwlw9kUBHuRcM5p+xaihh/DXLvkjXW6z1P3AW95j4PKfWpFFojefIZ+hTxZX+IfO6pQTea3Kw9dM7WMQOLlp4nT0ojZxd3gDk2/9+WxxG4ojwhJ6y751FeSWJkuvVJgYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096880; c=relaxed/simple;
	bh=6x9MgVV4wWUG+uVEZgiCHhBYAtwBOf944hoD9f7sTXY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gf3hqcHZI2y0IcgW0FiecV+6n6614JrpmUXoTFa91qDsyDtgEs42VbMAoNMkxTcGfJ7/6cdKFSZNyK8eP0UTby7CFifHjfXeUW5dz8nwuAPnWjMH1J7HjQ4imTVYCTpkdK8JYM09TncfaVP8ymu3KUSIyFj6UITbh/Tle5rRwLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bd1LxEXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bd1LxEXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A84B1F000E9;
	Fri,  3 Jul 2026 16:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096879;
	bh=Zv7AUVT+4oPx3kxJIEKKvIyqQ9dSH7B0QdptAxByu/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bd1LxEXwimKL8EaCljcqSNgT+inlQlIKKawa3RvQ/ycD1zqDQ7HcVboG42apx+opb
	 jGaAjg4YUfxKtGaZbhNgnpFa89Spa+pEIUkwRNW7KOhzQKXiEcMql5yTr29HQt7Ycj
	 1rnpsHOxCAVedT97+1YO1dofhZKrpCMr8lmBDZwXJ6pI5+vPGQI7BtCc5gEXDrvZ0g
	 E27hPi7m2SJB4TP60LpvQ1GSgjF4JATilMK1sSDRIrkrdKtJkOKjKqCf/In72+xCon
	 Cwqd3Y9b1hQOu3yfn0/pAbN3vaoyHVLKLTZ0PiK61FRH57Liic29Ta1ZYllB8axGIt
	 9t+YTtNSF5Q6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 35/40] KVM: arm64: gic-v5: Add CoreSight MMIO regs to
 IRS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-36-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-36-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:41:18 +0000
Message-Id: <20260703164119.2A84B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing MMIO register descriptors for the second 64KB frame of t=
he GICv5 IRS.
--

commit 15bd2f995f6e9330e8aab99ee4212a882b554a17
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
   =20
This commit exposes the CoreSight identification registers in the emulated
GICv5 IRS MMIO region. It returns the architectural identification values on
reads and ignores writes.

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 1d63cfe704fda..17be776b4a2b9 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -465,6 +465,43 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu=
 *vcpu, gpa_t addr,
 	}
 }
=20
> +static unsigned long vgic_v5_coresight_read(struct kvm_vcpu *vcpu,
> +					    gpa_t addr, unsigned int len)
> +{
> +	const size_t offset =3D addr & (SZ_64K - 1);

[Severity: Medium]
The handler masks the address to support both 64KB frames, but is it possib=
le
that accesses to the second frame will never actually reach this function?

The KVM MMIO dispatcher relies on the vgic_v5_irs_registers array below to
find the appropriate handler. If the descriptors for the second frame are
missing from the array, the dispatcher will reject the access and return 0
before ever calling this handler.

[ ... ]

@@ -776,6 +813,47 @@ static const struct vgic_register_region vgic_v5_irs_r=
egisters[] =3D {
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SWERR_SYNDROMER1,
 				  vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
> +
> +	/* CoreSight identification registers */
> +	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_DEVARCH,
> +				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> +				  VGIC_ACCESS_32bit),

[Severity: Medium]
Does this array need explicit descriptors for the second 64KB frame?

Since vgic_v5_irs_registers only contains descriptors for the first frame's
CoreSight registers, a guest reading from the second frame=20
(e.g., SZ_64K + GICV5_CORESIGHT_DEVARCH) will not match any entry during the
search in vgic_find_mmio_region().

Will this cause the dispatcher to treat the second frame access as unhandled
and return 0, leaving the masking logic in vgic_v5_coresight_read() as dead
code?

> +	REGISTER_DESC_WITH_LENGTH(GICV5_CORESIGHT_PIDR4,
> +				  vgic_v5_coresight_read, vgic_mmio_write_wi, 4,
> +				  VGIC_ACCESS_32bit),

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D35
