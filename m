Return-Path: <SRS0=dNnP=JG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DFCC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 08:08:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C4D0C611BF
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 08:08:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4D0C611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B3054BA88;
	Fri,  9 Apr 2021 04:08:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Un1JK3If58R7; Fri,  9 Apr 2021 04:08:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CBF4B955;
	Fri,  9 Apr 2021 04:08:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 172224B94D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 04:08:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dl-rAdGIEu66 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Apr 2021 04:08:15 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CBD64B92F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 04:08:15 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id 12so4706944wrz.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Apr 2021 01:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4n5XQyXIMcAvvSVHJa1+lHKqEgUtFQKp+M5Ydfb4ys4=;
 b=PBaL3LS2SQBr213UpbZLcQZtzq8Tftnqxcf972qOnt5LcxDOzXyTUP4oKSW2ZS5/Vd
 FP1LTP3r747Omm5WJgBItRP4SGiXHuPPovxyhQIKcRyh/azg5wC6tC3NmdUHtNIFjWfR
 /c+crwDj4lx11ztCTwZ6v5qIRbyzblZUGR76rTxW5lvCggLHC38yKc9lzTubbRdV+rEr
 3x1pGsyZe9omFLP2X4dBbpzV+uMYZgdKJoIU/im8w88aFlyHzl9r8K2GIjNtxIVLFMj4
 JvQ191AvXnwi+/vhXtdnlXOwaKdGcBqLEow+QVLGlr34TIa2H/HuNu65/tO1/PuG/Qbp
 IO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4n5XQyXIMcAvvSVHJa1+lHKqEgUtFQKp+M5Ydfb4ys4=;
 b=WVV8cLXhn++drogJikX/tvfx/pBeJxAcbWf/rvDu77Oe7xXiZjbvFyLgGPl/t+w05s
 FFC6g5/X754cyhKA4r8T5/jebCL9Ptn12BbZgQfkx7Ahx/UMjBACPAtpma+3T3NwgXBp
 s5qUlDM8EP9VJQ5XIjd7mONknVYcN9seCagSHLiojZlnDyVRBYcb2C5Sc6f1edx4KtEa
 qkQSiH35ceVGbmaVhZH09Ql48JgvTWzgmR8xuStEtJEA/sYyK4hdMbO2NGtvZEJ92e+7
 /Qtix7XPzwUl1MkLzc7nHNN+D+Mq7GvOhq82A4FIx9nmk7E6928ZVnmFbInKS0wYzqU1
 0W/w==
X-Gm-Message-State: AOAM533U9a15BgRgEcRnvwA2IHRzq+4w7zT6Fdc8TLlQJlYnRE6w4aH1
 lonqnueY3lSKAsetXgM/9y8fXg==
X-Google-Smtp-Source: ABdhPJxINGm2Cs/J55+AIsgzJGyjQFvX8rWJi0ktXHgRlfGG7RsZH/UItz3GB7TR9I/PNd+/Ulb7Vg==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr16279163wre.183.1617955694111; 
 Fri, 09 Apr 2021 01:08:14 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id z1sm3276489wrt.8.2021.04.09.01.08.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Apr 2021 01:08:13 -0700 (PDT)
Date: Fri, 9 Apr 2021 08:08:11 +0000
From: Quentin Perret <qperret@google.com>
To: Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH v4 1/2] KVM: arm64: Move CMOs from user_mem_abort to the
 fault handlers
Message-ID: <YHALa38PPQBceqF9@google.com>
References: <20210409033652.28316-1-wangyanan55@huawei.com>
 <20210409033652.28316-2-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210409033652.28316-2-wangyanan55@huawei.com>
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

On Friday 09 Apr 2021 at 11:36:51 (+0800), Yanan Wang wrote:
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> +static void stage2_invalidate_icache(void *addr, u64 size)
> +{
> +	if (icache_is_aliasing()) {
> +		/* Flush any kind of VIPT icache */
> +		__flush_icache_all();
> +	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
> +		/* PIPT or VPIPT at EL2 */
> +		invalidate_icache_range((unsigned long)addr,
> +					(unsigned long)addr + size);
> +	}
> +}
> +

I would recommend to try and rebase this patch on kvmarm/next because
we've made a few changes in pgtable.c recently. It is now linked into
the EL2 NVHE code which means there are constraints on what can be used
from there -- you'll need a bit of extra work to make some of these
functions available to EL2.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
