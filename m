Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D338C4320E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:00:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD86E60F22
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD86E60F22
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B2984B0CD;
	Thu, 29 Jul 2021 13:00:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id js27YacXp15t; Thu, 29 Jul 2021 13:00:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F00249D50;
	Thu, 29 Jul 2021 13:00:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D20B40870
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:00:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8qyquWFTPqny for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 13:00:28 -0400 (EDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A4244081C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:00:28 -0400 (EDT)
Received: by mail-wr1-f53.google.com with SMTP id g15so7792608wrd.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rFgImdL4oRnQoKBA5pI3AwMwu/TF6E4dvPNBUaLQNFQ=;
 b=Ym5Ufkl/exEhxT3LXpkyNJPvberJTQmdCqua9HnSvE4M1l834pSV3ErwW2z0EyYWzN
 25tlJDAdf4Z8milEdWy0tk01sdQ6hArqX5HIewWnMc4zSAriwLR/66Pb62qomNeOfoZ9
 uHH4jP7oMOLk7iBAtSooAcqjMGyBacUbzwf2prksRZN34Etp9YS6CxBG1OmhWxdt5iwv
 Cz0hTGe2SZ6LQAjhb/19b6Onsoqj3n+calSmMc1PqDOdl6S5v2E+DIvW1JqZultHFGaZ
 e0HJto+/7kXHwepNw+rHHp76Vd4deu1YTEZU2A+fO6L5MjxxixVrUs1tBlqHMKsC19AF
 Ywgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rFgImdL4oRnQoKBA5pI3AwMwu/TF6E4dvPNBUaLQNFQ=;
 b=GYmBWB/1Z12hKT6rdcJebb8juv9MfgSsXELKnnGiEYgz7Vtla68CyGJe/AH0JP01UJ
 Ta52vObKMaT323itPWuCtGqgrOSKUYGF8vKAKo9r412LeyVrtM6tOTYXtGtPL4vfiTCC
 I1w+04xUmpwRcNKxzVmJGc/Wy5dp/cT/x0WW640a8KlKQyU9PdVf75sm6Kv7sgfIhM8N
 i3T1XNSnlmyNn4mg9X+frXa3fOpB+CXo8D5P5yyEuDDecZdH5E2qHsJswMqy+JHvQ35d
 ebia3MDDU4VrALJcZ9BviFjjPCNrAo8TazRLBilR5/Lbzn7I7KM7YAmnv4AFWOqrxYM6
 CJfw==
X-Gm-Message-State: AOAM531BAOiff2chS21R7uFOr5FM5hqm168ISZJJFG9M4pVzZWsQBzHx
 qigzy1Ldfe/rvbIdDoukJ/4ikQ==
X-Google-Smtp-Source: ABdhPJyFz2hml+WnVbZ7VNzv3kjo6OC8XSEJ53KL7oluYjYUSeypg9pkHqCQ9bSEkCwBjaOkz9WNEQ==
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr4243003wrw.197.1627578027075; 
 Thu, 29 Jul 2021 10:00:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:293a:bc89:7514:5218])
 by smtp.gmail.com with ESMTPSA id q22sm3841194wmc.16.2021.07.29.10.00.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 10:00:26 -0700 (PDT)
Date: Thu, 29 Jul 2021 18:00:23 +0100
From: Quentin Perret <qperret@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Minor optimization of range_is_memory
Message-ID: <YQLep2cwhyzWu2cL@google.com>
References: <20210728153232.1018911-1-dbrazdil@google.com>
 <20210728153232.1018911-3-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210728153232.1018911-3-dbrazdil@google.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wednesday 28 Jul 2021 at 15:32:32 (+0000), David Brazdil wrote:
> Currently range_is_memory finds the corresponding struct memblock_region
> for both the lower and upper bounds of the given address range with two
> rounds of binary search, and then checks that the two memblocks are the
> same. Simplify this by only doing binary search on the lower bound and
> then checking that the upper bound is in the same memblock.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index a6ce991b1467..37d73af69634 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -189,13 +189,18 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
>  	return false;
>  }
>  
> +static bool is_in_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
> +{

Nit: addr@ could be u64 for consistency -- struct kvm_mem_range holds
IPAs in general.

> +	return range->start <= addr && addr < range->end;
> +}
> +
>  static bool range_is_memory(u64 start, u64 end)
>  {
> -	struct kvm_mem_range r1, r2;
> +	struct kvm_mem_range r;
>  
> -	if (!find_mem_range(start, &r1) || !find_mem_range(end - 1, &r2))
> +	if (!find_mem_range(start, &r))
>  		return false;
> -	if (r1.start != r2.start)
> +	if (!is_in_mem_range(end - 1, &r))
>  		return false;
>  
>  	return true;

Nit: maybe drop the second if and simplify to:

	return is_in_mem_range(end - 1, &r);

With that:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
