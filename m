Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2100369D5B;
	Fri,  7 Aug 2026 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122762; cv=none; b=BGAcis0uFPgAnMUMFX1HS8WdM/m/g2ZG7LPh8Ht1t1OphTJn2qMVmTl7e0mEhFEOe8PGa7nb01EvsWEpkpmE3LpchjHBoJvCMi+SykiYCXOqLZ0eWzpHrlilJpoEz2XkNABeE60FHQflpd3Up6TpwbepcaAH7+Lqf9Erwldqxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122762; c=relaxed/simple;
	bh=Je6kucAvuRmMA2FG/1ZWu9BLQWBPR0lsm5GVfwHbs58=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ouGQ9W3JhpEz7GeMJgZUvDRR8k/0IxPdhC1eJf9Rga1LP4jfrCr0drPbkK/SxJl9u3JkIC6fwDgTP+x9judSaE2yUMjTLYX9aOlR/xFv1IXaLa/ssJHPAx0cNGUFEjZERXu4zgS8IGCEgYx5DinEO66U6wvbG+sFQVdb6UJ6LSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6dVYAiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6dVYAiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F011F00ADB;
	Fri,  7 Aug 2026 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122760;
	bh=HrLNBkC6c3ogSlCR3T2iNQiLVntPKSHXkVgSybJhEoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T6dVYAiWbCVPPlhRSrhV4dD/FFiswulxKWvbEYi4R7XBVNUtTvFU9XzOcoqQ7V9M9
	 iPNnilgsqO9+D750kXs3d3ZILmYp+SN5BG05/6agD2MgO4tuDvCgb/ZBD2cO03rhOJ
	 L5xAZLAZLEU8i4VzFpVZROkti9BLNb1M0ul65sjjm+DoMKlbNOZzO05JIyU8red4Zr
	 4OR67U2gQUp7PZilmBk5b2vAwKW6YuyfN11xFx7GI2Bd2FQaqD/phNeLAZinAlrNLQ
	 zcl1jmym0+GcL7USvjxhewL5DXj7vUjun3t6+yH0jqgvcagdIqpI3tMc5RZP1t6cUa
	 au7gc81klEmHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-42-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-42-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:12:39 +0000
Message-Id: <20260807171240.33F011F00ADB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The file-level macro `VGIC_V5_MAX_NR_SPIS` contradicts the actual m=
aximum SPI count hardcoded in the test logic and KVM implementation.
--

--- Patch [41]: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribu=
te tests ---
commit da8da00920607df68a148cd61772ea241d9a820f
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 NR_IRQS attribute tests

This commit adds coverage for the VGICv5 NR_IRQS attribute. It verifies
that KVM rejects values outside the supported range, non-32-aligned counts,
and attempts to change the count after initialization.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 51ea2fe7141ad..f4c0d2c003bb4 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> @@ -13,6 +13,8 @@
>  #include "vgic.h"
> =20
>  #define NR_VCPUS		1
> +#define VGIC_V5_DEFAULT_NR_SPIS	32
> +#define VGIC_V5_MAX_NR_SPIS	BIT(16)

[Severity: Low]
This isn't a bug, but this macro defines the maximum as 65536, whereas the
commit message correctly mentions a "1024-SPI maximum".

[ ... ]

> @@ -125,60 +184,92 @@ static void test_vgic_v5_create(void)
>  	vm_gic_destroy(&v);
>  }
> =20
> -static void guest_irq_handler(struct ex_regs *regs)
> +static void test_vgic_v5_nr_irqs_attrs(void)
>  {
> -	bool valid;
> -	u32 hwirq;
> -	u64 ia;
> -	static int count;
> -
> -	/*
> -	 * We have pending interrupts. Should never actually enter WFI
> -	 * here!
> -	 */
> -	wfi();
> -	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
> -
> -	ia =3D gicr_insn(CDIA);
> -	valid =3D GICV5_GICR_CDIA_VALID(ia);
> -
> -	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
> -
> -	if (!valid)
> -		return;
> -
> -	gsb_ack();
> -	isb();
> -
> -	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
> -
> -	gic_insn(hwirq, CDDI);
> -	gic_insn(0, CDEOI);
> +	const u32 max_nr_spis =3D BIT(10);

[Severity: Low]
Does VGIC_V5_MAX_NR_SPIS go completely unused in favor of this local
max_nr_spis variable?

Should VGIC_V5_MAX_NR_SPIS be defined as BIT(10) and used here instead to
avoid having two contradictory limits?

> +	struct kvm_vcpu *vcpu;
> +	struct vm_gic v;
> +	u32 nr_irqs;
> +	int ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D41
