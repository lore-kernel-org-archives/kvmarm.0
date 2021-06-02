Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FE8C47083
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 10:43:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 191F8613B4
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 10:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 191F8613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 925904019D;
	Wed,  2 Jun 2021 06:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KyYLvio5Buxd; Wed,  2 Jun 2021 06:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9AD9407A0;
	Wed,  2 Jun 2021 06:43:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE823407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 06:43:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FFrSg9wtKs0T for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 06:43:44 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B449C4019D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 06:43:44 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 p13-20020a05600c358db029019f44afc845so1376189wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 03:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uetljnpMVagZUL5muUxDZIQ/D9uiCnsyXeZAzCtugkc=;
 b=S5AMEA55e6WiHfILJvvLPJjjSa/Yq2hHfihL5FLlwc0nkqiEigDVv6zGaQ9Zqw30CZ
 ZcNArqEE1KLDPi62Lj3DON4XRA4lRQEPl3mkiGXqf1NuzcbVyz2xB5213Beslcbi0VY+
 vsODVyRmobfR1fCmUKCnp2nQgPmer3uq6shiln93ca9H6FsgwmDg30qGDQ8d9/7e24Mp
 CSLPgs6X+XyQ7pC/c2x8ETo1zkBVPUtq9sPOkmehhhoJFv3lhBEv40tvpOSBlEY1/b8H
 QUE7F5ZbBoi4Gyi+g8C3tw7hkEOfNdrM3DT6aidkaFGmRGF0N81BVxOpbVVxuR5GQeKr
 JnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uetljnpMVagZUL5muUxDZIQ/D9uiCnsyXeZAzCtugkc=;
 b=CzA0Uz1AoZT7bWs2qWmt9ZRTBZGqngG0xCY5/UF5ULvsx1D575HjIA5/OXYes1h1oq
 OcY/fL/Lx0I8tpyqpFutqrMOAu0O7e/luqIr91F3Q2oHhhC6tVvFbJ0ufdkDOYK2vtpl
 sxpae/pwZdfAmkpc6XLd+FiPEnYho+uhFm1yt7A512FWk6S5lYT9E0gT9TUm9Weosf3Z
 4cZIogwS3oj2hhbZcYWMTVtI75F0f8ra06/lDnXRRsbye/1dS2+SZD14QvdWOWqmoBW6
 MDkZsagHsQ1N/C15A/GUJUzHvRPQM9X2Z46DrODsGyn0jY3LhR0sDwII35QNs5Ynbk10
 apSw==
X-Gm-Message-State: AOAM530UnD3Z77USscyvWpxHiTORgWGZPju/lvvduK9rP8QNRtwPqEvr
 c685tNPX39oenuwT+j/gbTc9jw==
X-Google-Smtp-Source: ABdhPJwVt/mkHfPZsWQ7XeVPY+TVxGZoc9ruOznSEZgl2V+JcARglYdu24JT3h1Ue3fGnhgc5QDPqA==
X-Received: by 2002:a7b:c042:: with SMTP id u2mr30819876wmc.127.1622630623364; 
 Wed, 02 Jun 2021 03:43:43 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id 31sm7003760wrc.96.2021.06.02.03.43.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 03:43:42 -0700 (PDT)
Date: Wed, 2 Jun 2021 10:43:40 +0000
From: Quentin Perret <qperret@google.com>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH v5 1/6] KVM: arm64: Introduce KVM_PGTABLE_S2_GUEST
 stage-2 flag
Message-ID: <YLdg3K6m0P+cis2P@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210415115032.35760-2-wangyanan55@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Yanan,

On Thursday 15 Apr 2021 at 19:50:27 (+0800), Yanan Wang wrote:
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c3674c47d48c..a43cbe697b37 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -61,10 +61,12 @@ struct kvm_pgtable_mm_ops {
>   * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
>   *				ARM64_HAS_STAGE2_FWB.
>   * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
> + * @KVM_PGTABLE_S2_GUEST:	Whether the page-tables are guest stage-2.
>   */
>  enum kvm_pgtable_stage2_flags {
>  	KVM_PGTABLE_S2_NOFWB			= BIT(0),
>  	KVM_PGTABLE_S2_IDMAP			= BIT(1),
> +	KVM_PGTABLE_S2_GUEST			= BIT(2),

Assuming that we need this flag (maybe not given Marc's suggestion on
another patch), I'd recommend re-naming it to explain _what_ it does,
rather than _who_ is using it.

That's the principle we followed for e.g. KVM_PGTABLE_S2_IDMAP, so we
should be consistent here as well.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
