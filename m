Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC34C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 17:18:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33E1661019
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 17:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33E1661019
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A25DD4B0BB;
	Mon, 19 Jul 2021 13:18:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTz5N3PYqJNN; Mon, 19 Jul 2021 13:18:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB0C4A4E5;
	Mon, 19 Jul 2021 13:18:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 239E64A1A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 13:18:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s4v6xqdOjlFJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 13:18:08 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C00140FC7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 13:18:08 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id a13so22939017wrf.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 10:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/Xmu5FPqUyjX/AwFlDabtmrvnaqYTVi+iQ6O/Qt9w3U=;
 b=GcCvN0tvN5Qo1sPuEvd5e8Kiu9SppusmgEE+8feDajKDgBnTsTuQobZHqBMkPe4+XY
 yDuvGw8+USSyAwlYdV40GobxMRoS7Pazgu1thJ3JvazliW/fsy13HMsBFQPYjLdIdFfy
 yFL2gx3s6YHADMMGEc+dX1e6tegPCpIYQXsCEPbjVpdY0UTwHVXQhxr19NtHh4hPTAZ1
 UWcn7ZRvOVjzdiESzn8l/UhXaBilVgTKvPTIbHN1YVHSYdgQK0MJXV2KjODEbabseXLi
 4exz6XdzSK+5EwLOoofh8rWI2oDPAHZjmXO5UHi3Ckw+K10jfY0Qpm8zbUq2xNHwZzt7
 WgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/Xmu5FPqUyjX/AwFlDabtmrvnaqYTVi+iQ6O/Qt9w3U=;
 b=SlkZufadpS8PiufPEv7lo7WqZ7lk+eLckuFtb8+IaalwiXIAC7x1XdaP9EK0YYwuW0
 Dq39d28qZyEExzMbvO4bmKV7Rs5tkN5TEdzcxzztrsKRizbErC6OzgC4LKIYHRYL6ggq
 ewGVBHaNfEYpKUVhzqQ7gpuZyiMyLs3F/YfhEOGkw1NMzXz9zMNP9sGrrYlEzI9KYzN2
 33c4DMItHEg6qViINeQ/DSq/0z0BeW25mCXTN/TtFHWzUa6LQMW6t378bM5G7oBiWHYh
 w2MtINZbPRHHpLwXEUUPUQjmbMqXgTZuLNyfOgmB4hCWu7ivoMAj68hRDnBf3XwJdQTm
 Pl6w==
X-Gm-Message-State: AOAM530Qmd26BQnFzVRSyFYasXKEqI1PLv/FxoJ6fIw7Q1FlMXN3CF3D
 gzuxouz1NqBbUF0do2T5YTKh7A==
X-Google-Smtp-Source: ABdhPJxB1LiYaftghh0ifR2L76/445eAkiioG51gjnaxWSKBrKU6oQPzKqFBlbAnW5eZ1f2hyOGEvA==
X-Received: by 2002:adf:9084:: with SMTP id i4mr31273012wri.23.1626715086799; 
 Mon, 19 Jul 2021 10:18:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id r18sm21209280wrt.96.2021.07.19.10.18.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Jul 2021 10:18:06 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:18:02 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/16] KVM: arm64: Don't issue CMOs when the physical
 address is invalid
Message-ID: <YPWzykpDMOhT2yh8@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-3-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Thursday 15 Jul 2021 at 17:31:45 (+0100), Marc Zyngier wrote:
> Make sure we don't issue CMOs when mapping something that
> is not a memory address in the S2 page tables.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 05321f4165e3..a5874ebd0354 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -619,12 +619,16 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	}
>  
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
> -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> -		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> -
> -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> -		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> +	if (kvm_phys_is_valid(phys)) {
> +		if (mm_ops->dcache_clean_inval_poc &&
> +		    stage2_pte_cacheable(pgt, new))
> +			mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new,
> +								      mm_ops),
> +						       granule);
> +		if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> +			mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> +						 granule);
> +	}

Hrmpf so this makes me realize we have a problem here, not really caused
by your patch though.

Specifically, calling kvm_pgtable_stage2_set_owner() can lead to
overriding valid mappings with invalid mappings, which is effectively an
unmap operation. In this case we should issue CMOs when unmapping a
cacheable page to ensure it is clean to the PoC, like the
kvm_pgtable_stage2_unmap() does.

Note that you patch is already an improvement over the current state of
things, because calling stage2_pte_cacheable(pgt, new),
kvm_pte_follow(new, mm_ops) and friends is bogus when 'new' is invalid
...

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
