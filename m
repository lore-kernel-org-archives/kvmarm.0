Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E868313529
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765460312; cv=pass; b=C1fofrODCmHzuH39yVVbvnVYoIiqgUvAm7DPkvYwo7e2gi197slFpe7HAcvB2YxWLH1LDPpnEsrUlifgvnx49717Rp4y/0fYjzY6CyneO8x7JO/f6wYFR0nTqACypsiHRPoAEw5y2GM1NFZWEyt1u7rXWAijvBjdIseupgMjzpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765460312; c=relaxed/simple;
	bh=hcICbtk53nhUUs/NMDQ1oP8T2GuoW7seYibfAF2T1Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZL713Fn84kBj0W/jiGJq1AxdzT1XwtMGLi4zblTMtYkVveur99WAjRvKXCouX3FwCpWeHzeN6b5GvrFWImKFz1uVk/qiuf47pVxahQu4E98FGxCzYRxiPR2NTay0VrIv3M0dfwzgf9m0i6OsCRuoxAWQgScJBNbFt4wtggY2BDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lOK/jq7P; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lOK/jq7P"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee147baf7bso408451cf.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 05:38:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765460308; cv=none;
        d=google.com; s=arc-20240605;
        b=KhrhzKWsOKeyakBefsPYVoiuIRV6ydXJEAWMvQ9a0ZwZl6oba8VkHfHhUSFt/10dEv
         nVbHfMHEXnRF3rhGx1k+QYNmCaYM8Yfv1kssPWrJfIIblk/3dLBee8N2NcL5qlzPWvZm
         jeqaiwvmeRbctbiLhaj5MHgvKeb8e0ig72BPcaEqc5vimcdQwk3bXTBgEV0uuFaeZ/Vj
         T+w/pnmN/m3X0ob2zUog/X9XppSV7SHtsmJVG21lCHMUhdRaWAA7AllwlabtX9HwwaxM
         xvn4kzNRQ8ihkzBXMhLs6f9yTz5OPgDFTNpOrV9iTSh3NeuNGc1C8GTShy9/vI6yTrHt
         yOkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        fh=NG/nEuPEgoaPuGimMFCytjJ02a7zmffXXGabTKRy8/o=;
        b=Cq84hQm57HdmhgUrXPGsal0IgPWew4tpg7F4/8IAqamLPUo8c7PNgHKofSm21PXQeF
         0ffWyisoXys4MUxvRLGi3tQOVeWo9HLIbLmn6VZ8iNxXakL+0xc9HwJEdvF8+3YDqc5g
         oab1QOSV9nkZqj+DhJof8k+RtGi575kDnIJ6/ZILf5lMi7V17o9x+QZriRYjfjAUwo/J
         rRQHhnjlANU9CrvMQsxKXbLFV+UL4P4IHJYmXbiOGsI7pF/rOY97PFp8ne+HFWd1teIR
         qRkKIdQA8DuQyKDGpad0MTErc+CjfDJuaEA27SmXxOIxbdbLihrJTNX86g+/yKTJmSzG
         eXRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765460308; x=1766065108; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        b=lOK/jq7PoHFkAfy1shKJUJR1EUB6++asI3lshBP1rd+yHbhV3L60AgyMNahXn95uOF
         Bp47xEmA+FDM8kncAJt00y0z+N5DCFuTEEDnzjwgMklJVsnUa+Ac8aOdiy75A7d6Y/G6
         AMfC2d9ampIKTLc4S1pCGjfPW0lEyoNs8SSnpvIJH8Qu8lSJ1iH/B6wxkVXIfcYbzHzd
         600A29T4dw/VJF1IAzP5XgADEdw9sbAfn5f2C2g6ICBMHdpfHItZiJfoCKSTJow+ecsg
         CaVluc7Eu5/UJFcKFnZD2OKsuHMgTK02lnEOl37qF4fpwsMNrHQ4AJ4PZ5/HHaRfs9Tu
         ystw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765460308; x=1766065108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATH4Gg6w1rZmrC11/iAIWnrEEpvY40NWpwaW65dF7vY=;
        b=fvxbSi6rxzZ6g9c8zHN8F6U/PybPf2MjYPJ9NH52i2KHwuAIsy9rsduIXTrE40LoZU
         iMXIKUhwyb/1yMAFccextbNklRYnwE7X7j5E+NVgNlESHHXTY5bdK227JfjpfA9XE5ew
         X/asNa8NovAUQ1yBVd2dMwxirgq8GO9Qp/KKoib23vWfAxY+yIqsNDWNVs6bAdZRIwFT
         BCO42nyjfqRD7/teDYWILg+ls0J0ELh7cLZPShl6nd9odnLQwRBEyvE6oELHYkwnTAxF
         k7X2HMnztZCh9gO5gT4leQuA3NaYuaT/23ud54EXYqsjfpQpPzTXXg6im7sVNp0AF1V6
         a2uQ==
X-Gm-Message-State: AOJu0Yy4MGQt6Yd5Hgn35TZzKumwJCS0TSylNqulIPQlGc0zNEBqOmgD
	7wsy41nWsDJn3tO0vbsu+CAxWjycjC27G7O1Vf3tkzZDVyjP+USDPWSfkXk2hheEc1kjdyphY21
	QIQqmYjZaksK+IWoGs2WBqajcJD86yg9j8/lsNOao
X-Gm-Gg: AY/fxX59u9sTkN1fvUto6lnQSXbRD4GHjc3oBmV+1xn9Uo8phAxARq16pdoAgvQDwAy
	nD1tgwmDOcTumIa91xE87r19R29KaYNwcd76Filhy0P+DrX+Lkb3kkHVohZ1/nneM9SMaTb6OG3
	5d53tq7AFLVKYaZO/TQq0t/Bnw9WdRieX2nuCdbYA47eLLKtrooV9c8S0YJzfOSE6pKQusVDLIZ
	ZN6iqFVr9dun/GKeMmh/StfSkF90mYkfxT9orQeqZMzNGKf8Xv9wl6ymH+WigKmcnRBaz51
X-Google-Smtp-Source: AGHT+IHBNLZXUtBWlYCMhaz48//h3NT3a97dTmms6v9GAdwjCupUlBdtKCU9vgSfcoVTwxvogMmesy8WxjYwyhWFLco=
X-Received: by 2002:ac8:6059:0:b0:4f1:bf1a:f040 with SMTP id
 d75a77b69052e-4f1bf1af253mr7198561cf.2.1765460307167; Thu, 11 Dec 2025
 05:38:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210173024.561160-1-maz@kernel.org> <20251210173024.561160-2-maz@kernel.org>
In-Reply-To: <20251210173024.561160-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 11 Dec 2025 13:37:50 +0000
X-Gm-Features: AQt7F2oIVnn0zGnmHiuvEME1EKDfc3M1hrNZuxqGEx_qeLODVk3FAHpDGjocJ9Y
Message-ID: <CA+EHjTwh=Vop_v5+2_wj57Y-Wg=Q12aw7hUYdNB2CGA4Kq0ZKQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
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
> The current XN implementation is tied to the EL2 translation regime,
> and fall flat on its face with the EL2&0 one that is used for hVHE,
> as the permission bit for privileged execution is a different one.
>
> Fixes: 6537565fd9b7f ("KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index fc02de43c68dd..be68b89692065 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -87,7 +87,15 @@ typedef u64 kvm_pte_t;
>
>  #define KVM_PTE_LEAF_ATTR_HI_SW                GENMASK(58, 55)
>
> -#define KVM_PTE_LEAF_ATTR_HI_S1_XN     BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_XN   BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_UXN  BIT(54)
> +#define __KVM_PTE_LEAF_ATTR_HI_S1_PXN  BIT(53)
> +
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN                                     \
> +       ({ cpus_have_final_cap(ARM64_KVM_HVHE) ?                        \
> +                       (__KVM_PTE_LEAF_ATTR_HI_S1_UXN |                \
> +                        __KVM_PTE_LEAF_ATTR_HI_S1_PXN) :               \
> +                       __KVM_PTE_LEAF_ATTR_HI_S1_XN; })
>
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN     GENMASK(54, 53)

I was just wondering, is this patch really necessary, considering
patch 6/6 redos the whole thing and fixes the bug?

That said:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> --
> 2.47.3
>
