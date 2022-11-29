Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC5DC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 20:52:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C82E64B3DB;
	Tue, 29 Nov 2022 15:52:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2-7YpoCBBNW7; Tue, 29 Nov 2022 15:52:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A635243C58;
	Tue, 29 Nov 2022 15:52:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4FAB40DAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 15:52:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qWfMmra3w5qt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 15:52:16 -0500 (EST)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0C1540B6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 15:52:16 -0500 (EST)
Received: by mail-pl1-f172.google.com with SMTP id 4so14652430pli.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 12:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=52SMROLRGWbt9mwpSBUjPx/3msXb6vFt7ItVy/cqB1k=;
 b=VhKagD+9381ydRAyKPEL5EsmY+AM67HAZZ/33h8VvA8l2VXlMlKxq+fM5BueYSKXKt
 MlYUlT1r2orjroDtbBdQLFNwyfElcb4r+5lE0sxkugaizGLV5rqQhubBgdx5ttpa3za0
 oliMzzN9b4nvEx2UounppSrAbCEbsdm/nmGfxJve0S1hIp8oK/34PAiQq2P0gRHNpQON
 Hed36jy70ZutuQ+XKz5nU9QmAvnQT6CmU+OyL+RjADMzi1jdYipeoPsS5VzO7M2oqh+q
 oUjXehpCZSlKTc1/n9q+Fw+1tkSNk+0rW8qA5VeEmwAbYZihapsyiUMqxDw9ljYAQ/PU
 SMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=52SMROLRGWbt9mwpSBUjPx/3msXb6vFt7ItVy/cqB1k=;
 b=Aea1Wej0Brcmqe+EYGHaPs538IzTOz2t9jufvJFGkcGW6n11l7P3MXQwSBQVSR5+4u
 reCPdKfskCmsx/EFeQjfwCKOCnHBXi/qWGVUjCKhMI6vWAQWVIGCMF8G4Nvg6jG/vAmY
 vD3rq3jnZ/5GB0s9LxAWusYJhLd7g9+5VSaBzXaEJTUvpH6YJ2NSOqBBYIkhfBiEnyqR
 RHtunsx6QP+/zgPr3Dwea4WNg4IKBKwE/jc7vBmh4tx2BkIPj074m7GiHWieREkJLFNV
 ArHHu0hXHrMfN/oCjHjudLr37rNFr0yPmNdUWrjMlscaFQi6ii9RVDfmMDZ1EXikqQpH
 2r2g==
X-Gm-Message-State: ANoB5pmSNhHrI/c5MOkqFpoCevMgfDHJgZDZ23WWFEG+ZFzWmAG7p2gY
 XT7zuLj/MsHIQDkoz+Q10pARoQ==
X-Google-Smtp-Source: AA0mqf5zWdkH3xH2EphKKbDCqWzEBIeWxi3op3Of+IS1hUt3Omy1pEG69elJYrpi56m64lfNCX6qYA==
X-Received: by 2002:a17:902:7790:b0:189:9973:fb58 with SMTP id
 o16-20020a170902779000b001899973fb58mr5888074pll.59.1669755135786; 
 Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 c31-20020a17090a492200b00218b32f6a9esm1784905pjh.18.2022.11.29.12.52.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Date: Tue, 29 Nov 2022 12:52:12 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Zw/J3srTsZ57P7@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221129191946.1735662-3-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> Of course, if the PTE wasn't changed then there are absolutely no
> serialization requirements. Skip the DSB for an unsuccessful update to
> the access flag.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6..9626f615d9b8 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1094,9 +1094,13 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>  {
>  	kvm_pte_t pte = 0;
> -	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -				 &pte, NULL, 0);
> -	dsb(ishst);
> +	int ret;
> +
> +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> +				       &pte, NULL, 0);
> +	if (!ret)
> +		dsb(ishst);

At the moment, the only reason for stage2_update_leaf_attrs() to not
update the PTE is if it's not valid:

	if (!kvm_pte_valid(pte))
			return 0;

I guess you could check that as well:

+	if (!ret || kvm_pte_valid(pte))
+		dsb(ishst);

> +
>  	return pte;
>  }
>  
> -- 
> 2.38.1.584.g0f3c55d4c2-goog
> 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
