Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287E7445AE6;
	Fri,  4 Sep 2026 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523675; cv=none; b=LvCALlod9V+IzogEz2pgMEvH23YgQw7Q8QhyynMEEsSG79HdSMS7QN66EEqO/e94EoYfhmEwdn3hTNEIMq2x63l6HNTEOjinqMqT8cFmHUod5xqIcvWXh4hmk1Oiv8pyslYgFtccNpcMQAeVMTrTpZMHw61GPZ8m95+mYXMvRc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523675; c=relaxed/simple;
	bh=CK9n4VCMDypYejdSnKZeJo2EVDIOP2fhE0s+07ka2S0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kZIhUk/CYFnYiKlbuvDwUogF4alunzDDlSIpZcW9A5/NzT7cJvLiOEbCD7F1WgOQai4g5rhLwnjrpTamBDsXB+FIVa3fLJHKMbbtwZcEF4g8+sgOSjTDSXUh+HA7TJCaRAbjxj7/CqMuVklHc3P8eHQ9kXlumAAMXvYJw45Tejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr3yICnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr3yICnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB231F00A3D;
	Fri,  4 Sep 2026 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788523673;
	bh=rmcMolSmFk23ROazRbdLdxSZj3H4RuxHaPYTIv53aTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xr3yICnJqNZShRvw/ddFnNdCBtbwFl1GarRXwRRvZZ8/tbu9HiqJM826swg1tFrTi
	 KzJiu0TSQm8UlCwye6QfmXi3BUHwp2/596YKC2A2RegziNKxX6aPjH8Y5zT8gji/tu
	 Szj/3IcZgeDIPIziFtStaLRpEsaAS3jnw3LrgcEBWRYJKByHDdIa4so8stX1chMoLy
	 exABq+YZvwgFHiZpEFM4AWmuxfKdb0zWidUjLc//UAKdk/bHbhjOZnaCFTQQuvkcuZ
	 4TiqaAMuw4nm7cvXbPuLCD7nCGIARNLyQPu7SekyB9BTAMQetyxhwj9ud8cOb5JVR0
	 +x8DxK6KX/5kA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-5-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-5-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:07:53 +0000
Message-Id: <20260904120753.8BB231F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] GICV5_IRS_SETLPIR is incorrectly defined at offset 0x0000, collidin=
g with GICV5_IRS_IDR0.
--

commit 9b3628d351292c770b6fc2a902ed50e62d907d8f
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Define remaining IRS MMIO registers

This commit completes the set of defined IRS MMIO registers in the GICv5
header file to support full emulation of the IRS MMIO interface in KVM.

> diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/a=
rm-gic-v5.h
> index 59a5875854319..8dc5847a646eb 100644
> --- a/include/linux/irqchip/arm-gic-v5.h
> +++ b/include/linux/irqchip/arm-gic-v5.h
> @@ -63,20 +63,34 @@

[ ... ]

>  /*
>   * IRS registers and tables structures
>   */
>  #define GICV5_IRS_IDR0			0x0000
>  #define GICV5_IRS_IDR1			0x0004

[ ... ]

> @@ -167,15 +256,111 @@

[ ... ]

> +#define GICV5_IRS_SWERR_SYNDROMER1_ADDR	GENMASK_ULL(55, 3)
> +
>  #define GICV5_ISTL1E_VALID		BIT_ULL(0)
> +#define GICV5_IRS_ISTL1E_SIZE		8UL
> =20
>  #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
> =20
> +#define GICV5_IRS_SETLPIR		0x0000
> +#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)

[Severity: Low]
Does this new macro incorrectly overlap with GICV5_IRS_IDR0?

Both GICV5_IRS_SETLPIR and GICV5_IRS_IDR0 are defined at the exact same
register offset (0x0000). While GICV5_IRS_SETLPIR currently appears to be
unused in the codebase, defining it at 0x0000 rather than its proper
architectural doorbell offset creates a conflict with GICV5_IRS_IDR0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D4
