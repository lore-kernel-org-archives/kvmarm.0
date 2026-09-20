Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054B477E31;
	Sun, 20 Sep 2026 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789940324; cv=none; b=QJr2MIAVNbWRgmMWRirgW1uNhljR8jYwurP2p87+pxBKi4W4j20LOJvDxL0y/Bgj9YlA1syJ0yez2k8uZEUJpOiyd98VDjYHLtvPmwfheQigWh1xwebp2xrI/QCvX3rRWsQ79ISz3Vz3zkeCfyavhU7nECfd5+8j7I83hr20Fqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789940324; c=relaxed/simple;
	bh=fwIddvi1wR/e01U643iPxsJp+Zmz4hbvLWf8uzT2IiY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FO7jV66sGdLQUFNsrvY69SK6k26nYZTig+XOZRTF0IvxRIbNOuZTUsH2GM5P9aHAtCTWWpWUlvCH0GMa/BRGzQ+vMLMsHCTI0UrYygA7p9Tkhjmea9m1sz/uIO7xPiw7wbtREXdM7WeY71sYKAuGbZTABMkryN1zp/+b/+mrJfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTjFG8SQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTjFG8SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD9B1F00893;
	Sun, 20 Sep 2026 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789940319;
	bh=1CXuaRU6OcmRP7VoXeFud9oP6QQPei7BYbbXVxyWItY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BTjFG8SQOToSfhyOmytMo/oEffAnGX5NDysJIIb0JW9PDXi0S28EKSp4PznL7THkC
	 SOFZ1DzzW0kl/WVsyGARBJpYPCUVOB3cf0MjeYzOzaYga3xp0i8mhWpFmfR1H3PzhA
	 8S71H/OdZyXXMX8KMqC065+6rrAuULKj6InIqt9nNPZiVdGdO+A5NF3za/75jcPOLF
	 PKsGqEoK6rlVKoJpbLjOv0pz/HjmQrOgJyn2MB6pp/XNnNpIun1IktUaPTlk8BdpjM
	 asMEz6bjL45lyW88JrgA5xK11OeDFwtESukf+mQuF4Hz30uIxLyLdSSOyTfuTe3YIJ
	 Ov7B47Rna9SzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 04/20] KVM: arm64: Avoid including linux/kvm_host.h
 in kvm_pgtable.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260920212845.707-5-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 21:38:38 +0000
Message-Id: <20260920213838.EDD9B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kvm: missing includes in kvm_pgtable.h for FIELD_GET and others
--

commit 0c7ef6102444f8add04f2e7e4854a331850bf438
Author: Steven Price <steven.price@arm.com>

KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h

This commit drops the linux/kvm_host.h include from kvm_pgtable.h to avoid
future include cycles. It replaces it with lightweight headers for types
and a forward declaration for struct kvm_s2_mmu, while making the dependency
on kvm_host.h explicit in pgtable.c and kvm_pkvm.h.

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/as=
m/kvm_pgtable.h
> index 41a8687938eb6..c2e4b29e605fc 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -8,9 +8,13 @@
>  #define __ARM64_KVM_PGTABLE_H__
> =20
>  #include <linux/bits.h>
> -#include <linux/kvm_host.h>
> +#include <linux/kvm_types.h>
> +#include <linux/rbtree_types.h>
> +#include <linux/rcupdate.h>
>  #include <linux/types.h>

[Severity: Low]
Does removing linux/kvm_host.h leave some macros used later in this header
without their explicit includes?

For example, in kvm_get_parange_max(), the code relies on PAGE_SHIFT:

    if (kvm_lpa2_is_enabled() ||
           (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && PAGE_SHIFT =3D=3D 16))

In kvm_pte_to_phys(), the code relies on FIELD_GET:

    pa |=3D FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;

And in kvm_pte_to_pfn(), it uses __phys_to_pfn:

    return __phys_to_pfn(kvm_pte_to_phys(pte));

Should this file explicitly include <linux/bitfield.h>, <asm/page.h>, and=20
<asm/memory.h> to prevent build fragilities when it is included in an=20
isolated compilation unit?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920212845.707-=
1-suzuki.poulose@arm.com?part=3D4
