Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B65ABA28
	for <kvmarm@lists.linux.dev>; Tue, 29 Nov 2022 20:52:16 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id k7so14613923pll.6
        for <kvmarm@lists.linux.dev>; Tue, 29 Nov 2022 12:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=F7jvBnyDwX9jxgAemBxejnd4O9JXPZrcvYXNE7GFZGQm/Z0q2kdvMSWiGMGyQ6qMwA
         Vv6fFZZT1ZUAcE/BH2BQjE4MTsN0LU5H0ypBMObfgp/SvNWXX0JV/sfJENc+GRwE5cGv
         Q0tjfCNBTGA5yuWKjxzaXGD/BbTlWbuUjFysKTv0WaDbj2/TNvLL2Nc0ZN0B1FybkBVB
         skt1uA4U2z4qMeKjILz+19uhFUgNiMIsOvhZOEEFQUQMpUkX0+K2HfAvIIkqe80xJHen
         Vum9HVri9OMfTgf6U1cevcV0V4qb+2j0QXjNvjBnthx7WaQpOn4W7217C5SavgC6c/xS
         Pccw==
X-Gm-Message-State: ANoB5plBunV5yQynB91GKu7h895ANT2pAnjSpSL9f2B2Jzkhg/wHpWjh
	FFybUm5HI9nS5y07TG4QHdFLUQ==
X-Google-Smtp-Source: AA0mqf5zWdkH3xH2EphKKbDCqWzEBIeWxi3op3Of+IS1hUt3Omy1pEG69elJYrpi56m64lfNCX6qYA==
X-Received: by 2002:a17:902:7790:b0:189:9973:fb58 with SMTP id o16-20020a170902779000b001899973fb58mr5888074pll.59.1669755135786;
        Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id c31-20020a17090a492200b00218b32f6a9esm1784905pjh.18.2022.11.29.12.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:52:15 -0800 (PST)
Date: Tue, 29 Nov 2022 12:52:12 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Zw/J3srTsZ57P7@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129191946.1735662-3-oliver.upton@linux.dev>
Message-ID: <20221129205212.vk5LmN-daMt7t7pL7cPbOLO-zeWhRvThnF8OaoSNfBA@z>

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
