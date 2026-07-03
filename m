Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E21A6807;
	Fri,  3 Jul 2026 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096619; cv=none; b=jdqQS6uDFHjpe28pqdPjdFzwt8GpM1sWph7MZw5lYlYnpLNV9oUZzvyHAehJASxMzRemPcuf2nwT6tOoE5QDHW8XBmDxLIZf/B8D4DBGBkc361DGSIwc6CkQqrpjzNhzpIptLbhFKzkS9wShVMF8Fk2MhFNoq3a533/pHV65h4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096619; c=relaxed/simple;
	bh=34cHef6++ScAG1l0kLWU9b6iQ8ZsFc9465wfrUsqI8M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N6mxwNVWquoIUX/gN4wepUQRM8vHcDkOGaYEIAWA2e/iXVC0dxLyWFZ37BUkqi8w1zTwVvRbtC7vUPreWvfDrkeE9Ob5K0GsXTL7rPTXVJ6mXVa6/c9PtZr1Gk/txZKKFu3UB1IwB7+t0mExq0Z+nLcTDcsb+8RE6gCS/z3eXeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKi55h5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKi55h5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88C81F000E9;
	Fri,  3 Jul 2026 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096618;
	bh=FCTOF/39yNvp88QqKeJyMKFnaYyqgUtecEpGVGwNk7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KKi55h5FncgWCnlXEA1JExVskELvNLtLFDAn0GFCCjjaBMlVg0A6Pz2+BsEWZpU3n
	 x2THmL0pyJX6Xc7f9OKa4LBkWL0f8HjBrDczfzyKBHvAu2uWufOaNl3uX0jUZ9dXng
	 UV3RMYU2UN/u/Thi/Y/o7DVD0SpYTvTSYC3mQOP/woWFjmnMIlpuMThFW1AN+6Kimx
	 m528ld7Hp9fd3aO+nPosTrAdjGv3A0mW1lOhMweorReGDKTwsoyV8DwAR7LjAu4zKc
	 DDWmCOeSfSq4h5Nw+iCEO+/Yg6IUepO4hTSULP6LdLpmQ6Bw3oReQP9s0xDX6lS3Dr
	 e89WkKEQ+vN+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 37/40] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-38-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-38-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:36:57 +0000
Message-Id: <20260703163657.A88C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS section in the VGICv5 document=
ation omits the 'Errors:' block and the AArch64 encoding note present in th=
e VGICv3 documentation.
--

commit 05ce42abb9af5d1426ded4bbef4cb5ae56533caf
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5

This commit documents the KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS device attribute
group for VGICv5. It details the MPIDR and instruction encoding format, alo=
ng
with the list of supported system registers.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 5c6323d82f784..e2045b09f27d0 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
[ ... ]
> +    ICC_PPI_PRIORITYR14_EL1
> +    ICC_PPI_PRIORITYR15_EL1
> +    ICC_APR_EL1
> +    ICC_CR0_EL1
> +    ICC_PCR_EL1
> +    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

[Severity: Low]
The commit message mentions that the main body of documentation was directly
copied from VGICv3 as it has identical operation. However, the 'Errors:' bl=
ock
(documenting -ENXIO, -EBUSY, -EINVAL) and the note about AArch64 encoding
present in the VGICv3 documentation appear to be missing here.

Should this section include the 'Errors:' block and encoding note to fully=
=20
match the API contract documented for VGICv3?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D37
