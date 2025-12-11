Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A848189F43
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464979; cv=pass; b=laxn1GdL18SPEFwWdXtX5A+54N01ujBiMRlVAm2oR2pqB/WkELJV12nG+kRDhFKiJwiIYeCunpnQLttiSKAf6C0NnzveAm/HEiBgLxlkF3TPOy8J+k1BshOHKSTj37nqC8EoiY4WcSwVCaLlN+l4/+zDCPaDdtdbr6FL7+uLq1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464979; c=relaxed/simple;
	bh=5k7G6/vHOZ/ZELJRWze07kLHkh4Upe+J24EgYvfN/uQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tzQhuAbfKegOYchdLVpXZqCiH3cmpVd3ZPr8OrhM09yg1cicClQ7c1ZminVvT7iEpSMl/hefi7InkxiJF580SJ1K6tObhLGWpiX2V43HeRVVNS72hw+IrE5Tkl4Y181HCfgY7BGJwjxQevRN6LQIsRnsgCieNCkMcyE4n0LM7WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yUrzDIbi; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yUrzDIbi"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ed67a143c5so559961cf.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 06:56:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765464976; cv=none;
        d=google.com; s=arc-20240605;
        b=FR7cI1jYJPLaSYoPsqdfnC9d9Al7aCpvP4DwRKNGXENcL6cnaSUXM1PiRAQVD0ICVx
         zW73brSwuYwwSmemsalQr2GnwCQEcD7RE6LxS2FlQdohSquc9bd++g81l5wGfCh5NeI2
         FKvK29IW/WU0qwtyYg5ufgFH7SgxkMZmfQlpelaMQ2ZfFchvvkwZHZ0fmlVhepx56bEk
         tc3LNVBCZTdENhF4ojhoWwWKV4f1B6DP6x+3fUa/Y7pKJ1/roElbwoqSrZ1ifBl8Er4j
         3JeKu/CndxtfP7RHo8ORcSZtbags365koowp4Pf368Mr9H1TxZUFfle9dNvekihFLsYV
         wKgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        fh=NG/nEuPEgoaPuGimMFCytjJ02a7zmffXXGabTKRy8/o=;
        b=FXz05OH8iIGMZRokz/EOctyt3lqcFPUN+hIHufkEwJkGVBEC9pgFWFLE0Mz9/Oamdw
         sGdGkvu1TBRChmwwhiriuf1sJKJ2xHZwBIAGLYa/uNz2yzFxu8VajrG1FfRJUTXjWawa
         P4iRT+r/r+8OyDWGUkq0Sj4DCDso33GuB/S00/GRWa7yPJ2bc+JSWhAtNcte1PAyKENq
         bf5o6T26IK25p6eIxcCrGcifkoOaunBHgr63XpwdwXCWIjs5EdI9LJTEXuCzN0Qryw+Y
         4blMO+Ohc0In973iorVt/vKfzwhv4RVPlpR/JC9cqc7Ek635HjeQcRcGMqiYKYnlrGGm
         mm1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765464976; x=1766069776; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        b=yUrzDIbiJM+qy15O5RG2n/7Sdpc+2SOyfJHrvhuZBqdyOSszd2XRy1FmkdkiBqSTik
         r+pS9BLGSGCgzgmcgyVBY4x/qS9cyt17S8Hi+dpHmoZbl9QUCgFE6jhe2DXrdxL15fbj
         OjmGku4jPOA40dd1fYn/XOflE+TqKjvmNB4o4UDBtjjJ3QAT3LrMLUqyto3R1PgEyfkM
         LSF6ACCWkyXjDLaOwpWETcDVyo6v4ceDR7iFwCJnG+8bJwStY4DvDpdHnH0CG0JibK8i
         gpeGJ6Uk51gj0YIHvRp0IBsX97yj+3BeNMZGzB/IY+3ReI+e8dfxcF9N2I/kfg+eOdEE
         H00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464976; x=1766069776;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LSd8N+GnU3kOnAVY+f16uUov3Vq7sUiHBSfthzax8S4=;
        b=g17+dnj3irIQzg26t+cuhSCA4h64wsJhaNbHIaYu2YIN6GRzOMx3PBMCYCyHW1LO8O
         nM7eujd2S2rCeR0dqPmHFpEsQpiA5TfXSVMMn2gn56Rr1kQgAJ4/rBCiUl3TJIyVoFyI
         X8Ky6c4KTzh2dv7hcA6IfY9ZEhYfubqEBK+ARhOkbmNV/VsN4A32IrCg+/h2v3TE+qSh
         BgXHQQBXMZPvevNnd0rORjc4jFXIa/gQKa7fjlLtBVtw+PrDutI90NPU9iXEh4hRBdg9
         60fa/qp8kDRYu6kdHP6kc7vNLsz+1ha3QXcql7JtpsAz9SF0JsAqe/atSGMw3KD87pkV
         C9Gg==
X-Gm-Message-State: AOJu0YxVjvyv+PtMddHyEvRYadva6dzzcD5P1zLVlunPb7mwsXdLrDCo
	VBHmQb2MxTKOFNxwRDpghh8KJ4Rsur8dz+bjpPBj1xmau8ye7rU72DjFl1JDGnZ02s19UYEbyU3
	iJOzqNnw/4R2vRp8V8z8XaPd07S8/oE9CXATheU2U
X-Gm-Gg: AY/fxX7NAyaBRccNovn9oANbB5DRJcmqYQ5U1b1WuigPO6dY8mw5hNcsv7fMdRHqw+K
	39vI8mjPRlQOOXV6z+e4WmAbZoV5GvW+fZiUDMnPiSHUsdOjavac+hhNNWSSY3jYa9cIaKvOCXi
	yzxbEnaTyRoIxX08EqoF5bjlGWfhlp1Ip/T7eYfd8JPnYukYnw+4RhJDFzzHjhhMBtcJqMxStj5
	A5eWRlRGACpeHccaFQlFbVv5o/RUlrg/ItgRQdlD0WM2pnQTeU4s6jPdeGKNCoKD6bj69Yz
X-Google-Smtp-Source: AGHT+IFgjwqJGgZa7LZD4L5r7a6kWYEP7wTy3klGGOECrWDWiCBkWZLd3nH8UUUtuYTcOmHg8w6evp1g6WqoN0gf/WI=
X-Received: by 2002:a05:622a:106:b0:4f1:b41a:a38a with SMTP id
 d75a77b69052e-4f1bed269bdmr10288581cf.3.1765464976027; Thu, 11 Dec 2025
 06:56:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org>
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 14:55:39 +0000
X-Gm-Features: AQt7F2r2xUgOLmLbDl7ihpbE251_7xooz1URlan3WSuQuzZ8uzvAyHS3-gcFwgs
Message-ID: <CA+EHjTx8LYCCY=W+ifaQ4Ny3mJ_+u0GL5T2FaKWvaX-oqVPT6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: VTCR_EL2 conversion to feature
 dependency framework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 10 Dec 2025 at 17:30, Marc Zyngier <maz@kernel.org> wrote:
>
> This is a follow-up on my VTCR_EL2 sanitisation series, with extra
> goodies, mostly as a consequence of Alexandru's patches and review.
>
> * From [1]:
>
>   - Added two patches fixing some FEAT_XNX issues: one dating back
>     from the hVHE introduction, and the other related to the newer
>     stuff in 6.19.
>
>   - Expanded the scope of the RES1 handling in DECLARE_FEAT_MAP() to
>     deal with FGTs, as we're about to get quality stuff thanks to
>     GICv5.
>
>   - Simplified the S2TGRANx detection slightly.
>
>   - Collected RBs, with thanks
>
> [1] https://lore.kernel.org/r/20251129144525.2609207-1-maz@kernel.org
>
> Marc Zyngier (6):
>   KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
>   arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
>   arm64: Convert VTCR_EL2 to sysreg infratructure
>   KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
>   KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
>   KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings

For the series, on qemu, hVHE and protected hVHE:
Tested-by: Fuad Tabba <tabba@google.com>


Cheers,
/fuad



>  arch/arm64/include/asm/kvm_arm.h     | 52 ++++-----------
>  arch/arm64/include/asm/kvm_host.h    |  1 +
>  arch/arm64/include/asm/kvm_pgtable.h |  2 +
>  arch/arm64/include/asm/sysreg.h      |  1 -
>  arch/arm64/kvm/config.c              | 94 ++++++++++++++++++++++++----
>  arch/arm64/kvm/emulate-nested.c      | 55 +++++++++-------
>  arch/arm64/kvm/hyp/pgtable.c         | 32 +++++++---
>  arch/arm64/kvm/nested.c              | 11 ++--
>  arch/arm64/tools/sysreg              | 63 ++++++++++++++++++-
>  9 files changed, 217 insertions(+), 94 deletions(-)
>
> --
> 2.47.3
>
