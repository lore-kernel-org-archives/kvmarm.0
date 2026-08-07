Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED31371868;
	Fri,  7 Aug 2026 12:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786104378; cv=none; b=bRVaQT2suisdEXyNKCcpnewG8WPcXo5MaalR+vHH+4wNTBL0wTfjsYovd7KaOYIU98/GkG/zB319AtF02adpi39lCIk1rCeXk9/+zMY84xx/3bxgxEjKxHiMOSXW3STKP3NAkZ3YNQJhtBwGyj2LuKekr/1sxT4UQ8XnU/lGo3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786104378; c=relaxed/simple;
	bh=g4goh5Q6QWcbTQWdn+P1k27xYNcN6Cpp3HaCvqN4YN8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fN4vth/B49eY55qVmTMRUthNztP2z5iABZqGmwqT0zs7za4OZ3yZYdYmy7o5IWbVG2fpA4slOt7AGrY+FrogwJe/ZOrcby6iSAHQx+I1W6DClZpDyiswXo12ylSPYjSoksaMFv3aElkErgngsI1JfbqPB8rEGZ9muGIIH+7S7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjcyWOJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjcyWOJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F7A1F000E9;
	Fri,  7 Aug 2026 12:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786104359;
	bh=epzoVBQ/mGS3kgP2IGJ/2OITvPlU1mX9ibU1p5Eu3QQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MjcyWOJgjDQhEgC0L+1Pa2+CzqRjrCacCOJnqzrew7inQikrZrDdmy6l/FYoPHjli
	 VP/isQ7wrYgd6KTpMejHzDKRnhWqubXKKtC3i9uo2FeKC4Gzq5ltH7a3J2TEs5KOZV
	 E22i6ubmWXVrq4dsgESAoFetYjtA17LgRoDbR1IK+pQ3FoqmcscTfGk0T5bIVIv/KX
	 NlQ15IJ+od0/a6mBuWdpPyg+XP3e1rVO86kuH78zT3pN6H5ZeXnb7Aa7/xopcfYO9K
	 qgHWn9pNpPZ4QvtyF542YNs9j5J1B0S17mI6YRvUNMUAZqJdx4mdn6zU58YNI3EzJG
	 2U30hQN7x7W/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-5-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-5-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:05:58 +0000
Message-Id: <20260807120559.38F7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] `GICV5_IRS_SETLPIR` is incorrectly defined with an offset of `0x00=
00`, which aliases the read-only `GICV5_IRS_IDR0` register.
--

--- Patch [4]: [PATCH v5 04/49] KVM: arm64: gic-v5: Define remaining IRS MM=
IO registers ---
commit 4e5353692b267764abed96c8124c3aebc194d9cf
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Define remaining IRS MMIO registers

Complete the set of defined IRS MMIO registers in the GICv5 header file.
Up until now, the set of defined IRS MMIO registers has been driven by
code requirements. However, in order to properly emulate the IRS MMIO
interface in KVM, the full set of IRS MMIO registers needs to be added.

> diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/a=
rm-gic-v5.h
> index 681c5c51207d6..83cfcd056b250 100644
> --- a/include/linux/irqchip/arm-gic-v5.h
> +++ b/include/linux/irqchip/arm-gic-v5.h
> @@ -62,20 +62,34 @@

[ ... ]

>  /*
>   * IRS registers and tables structures
>   */
>  #define GICV5_IRS_IDR0			0x0000
>  #define GICV5_IRS_IDR1			0x0004
>  #define GICV5_IRS_IDR2			0x0008

[ ... ]

> @@ -166,15 +255,111 @@

[ ... ]

>  #define GICV5_ISTL1E_VALID		BIT_ULL(0)
> +#define GICV5_IRS_ISTL1E_SIZE		8UL
> =20
>  #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
> =20
> +#define GICV5_IRS_SETLPIR		0x0000

[Severity: High]
Is GICV5_IRS_SETLPIR defined with the correct offset here?

This aliases the read-only GICV5_IRS_IDR0 register defined earlier at 0x000=
0.

If KVM implements the IRS MMIO emulator expecting guest writes to the SETLP=
IR
register at offset 0x0000, will guests attempting to use the correct
architectural offset for SETLPIR fail?

Could writes to 0x0000 also interfere with IDR0 emulation, potentially
breaking LPI generation via the IRS in virtual machines?

> +#define GICV5_IRS_SETLPIR_ID		GENMASK(23, 0)
> +
>  /*
>   * ITS registers and tables structures
>   */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D4
