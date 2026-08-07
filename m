Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A367730BF6B;
	Fri,  7 Aug 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121718; cv=none; b=qRwRRpIY15bNrrJzlwwJCp+1SdmsLFcQ1dnZoGIcDI8ea/sVsZFeQ6XDDlDgWNyRIsrXhlgxFBktahQlnviI523X1+5mRs7rAD2SymZowdy7ho41Jfe51JrOZLgdCJ9Y+fbjgpbsfylIQs4Ybmy6GWPZyK2mm9ewIT9dnJ9Fi24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121718; c=relaxed/simple;
	bh=YUEYrZ0o8cScx0bdmAjlXvWj3gn80/PGLB/BlKrlRnY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hnyu0jElmAeZgO1sbojoqgvc7KMIojrO1plx9xCWCi3zzyqVrZmJ0QYWmWB9FEPamhtXuJveN40OY5aOplfALNaIRwX8rEE7vJIn48s7xAMbDr4y3BpsQ6aOaKaMTgUXGENgJ7KZnIouCJlO81nuR3bqrMS2gydqBJRWHzJDulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bqts4DUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bqts4DUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC21F000E9;
	Fri,  7 Aug 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121717;
	bh=ykm8uV/8cTTzzPi1HTkNXcDZFyx3Z3m58aIzhGZrJnk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bqts4DUbbWgUrSLTPbAlgyJrkvdhEGct4WGgDZ6hfk7IgkXMxnlpHk75h099p3N7A
	 u3n2PTj2ljzQ+dewErN0EvcgKhkxkWXGPu7L9MRPnGcbrkNshbJcPc6gzAC3ivSfgd
	 m7yHHy9n5v38BIDolZkcK1qjuaXiojKMy6t/ovKqM5H9jvDAbdPHWrQC7GIQb9DfZ+
	 U1Zpd6Pw3rGUc74Y0kOfwOMYsizO1XObQ0HgdmUlCRat3DbQ3VoH4eR8DKu76nPxH9
	 dx7UbIo1XWXJF/0GpjS4Q00eLS6OlztgDkqL9OpH9W4rVitNuR/BC9WZQpRkjMGz3I
	 Zn7pYfS9GO1oQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-37-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-37-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:55:16 +0000
Message-Id: <20260807165516.D7FC21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Restricting user-space writes to VGICv5 system registers, IRS MMIO=
 registers, and IST state after a VCPU has run prevents VM soft reset.
--

--- Patch [36]: [PATCH v5 36/49] Documentation: KVM: Document KVM_DEV_ARM_V=
GIC_GRP_CPU_SYSREGS for VGICv5 ---
commit 5be826b5b86ddbcfa778f582ad314ba1e4599113
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
   =20
This commit documents the KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS API for the virt=
ual
GICv5, defining the register layout, supported system registers, and error
codes.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index c782ea4d4609c..7e41d6699538f 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
[ ... ]
> +  Errors:
> +
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +    -ENXIO   Getting or setting this register is not supported
> +    -EBUSY   VCPU is running, or write attempted after a VCPU has run

[Severity: High]
Does returning -EBUSY when a write is attempted after a VCPU has run prevent
VM soft resets?

During a soft reset (such as PSCI SYSTEM_RESET), QEMU typically pauses the
vCPUs and rewrites the initial state of the GIC device while the KVM VM is
still considered to have run once, since it doesn't destroy and recreate the
entire KVM VM.

If KVM enforces this restriction on KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS and
other device states, won't this reject QEMU's state restore sequence and
prevent the VM from rebooting gracefully?

> +    -EINVAL  Invalid mpidr or register value supplied
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D36
