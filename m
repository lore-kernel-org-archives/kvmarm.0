Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6640C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 16:59:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 385CD20789
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 16:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ub6t8/MO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 385CD20789
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DC64B98C;
	Mon,  9 Nov 2020 11:59:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3v4NOM359Jfl; Mon,  9 Nov 2020 11:59:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 407404B97A;
	Mon,  9 Nov 2020 11:59:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44CA04B975
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 11:59:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wi1NKnDb9qov for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 11:59:39 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02A3E4B7C6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 11:59:38 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id w1so9470491wrm.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2020 08:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/xpU6aOe7zsc2ojDYPHqW1B2hesNecHBAri6xa34+HU=;
 b=ub6t8/MOSTRAo1q64ajRgsXANVnqPQ0Z+9yCni3FNC/THKKkF0KWrlmaz4Olll8n91
 kVKuS1MZQFSC+t2hiWbsvar3jXt0qc4njXZbFuvLN1ktikhMbKhhMP1Wc8q/Yv/TPP+b
 hJ/NE1YGg+VVLbCCGwZqOoijzhJ6rvi/OyPoa3eCHndq0cb9TzQ80jQHnMpFHsHFbMsW
 Ft2Z4y5VsrwEdcbniSqDvm5r6hrmmARhroKk1GDg7iOaPJ7T8d6t7PSsh9AjUU6TsIIy
 MB6nqhIpOYeFZ/s894F5jblZArz/cSbk1ckM9cDku2Kgjpo3YCxBR4jSgQsufS9ldBO0
 c6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/xpU6aOe7zsc2ojDYPHqW1B2hesNecHBAri6xa34+HU=;
 b=VTyI2rlyYELt6os1c7nQcG1WEDhBTI8KNFWKL+ksDzCD6TyLR48alWzh69j2jt9y84
 Ujbg104WQ8yPwaWJxZE8u26JRp6Pp9/XP/kmtD1yiWIkPSu4MVME1GDwbyUND6MxC2Im
 lMRzTwi4x+4nS/PZUVGDyPz4dFuvry2J2B5wjwhyrDBtEjpVNTwncG4kt5LyoGDj7Hzm
 v8rEi67T8HtE9mTVp4TTCPIsPDkSTLDBHWQISoWW4YU2jx95EKNyfztdRHXR1jTpib86
 UJM246q/tpKJ0qfoQivw9uEJxQvUnt/lPJXK1HRaBviEd+yHlNv0wdGO4/FR7unXOAW6
 +K/g==
X-Gm-Message-State: AOAM533qbYWvC2TAkE0CxkbArCKIIYFk03591nIRqenBRjI8KAyjfNGI
 2qqtqN8Jzn6xjQWuthL9pqbdKw==
X-Google-Smtp-Source: ABdhPJxTSTLsT2jswsky+1lrZdCHipmnbSyPEtOAfZOAYkuKuCpAmY1FsIwpQPGF3duv+aoj3xTxKw==
X-Received: by 2002:a5d:6689:: with SMTP id l9mr12801967wru.134.1604941177704; 
 Mon, 09 Nov 2020 08:59:37 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id b8sm7527771wrv.57.2020.11.09.08.59.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 Nov 2020 08:59:37 -0800 (PST)
Date: Mon, 9 Nov 2020 16:59:33 +0000
From: Quentin Perret <qperret@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 17/24] kvm: arm64: Add __hyp_pa_symbol helper macro
Message-ID: <20201109165933.GA447754@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-18-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201109113233.9012-18-dbrazdil@google.com>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hey David,

On Monday 09 Nov 2020 at 11:32:26 (+0000), David Brazdil wrote:
> Add helper macro for computing the PA of a kernel symbol in nVHE hyp
> code. This will be useful for computing the PA of a PSCI CPU_ON entry
> point.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/psci.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c b/arch/arm64/kvm/hyp/nvhe/psci.c
> index b0b5df590ba5..7510b9e174e9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/psci.c
> +++ b/arch/arm64/kvm/hyp/nvhe/psci.c
> @@ -20,6 +20,16 @@ s64 hyp_physvirt_offset;
>  
>  #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
>  
> +#define __hyp_pa_symbol(sym)					\
> +	({							\
> +		extern char sym[];				\
> +		unsigned long kern_va;				\
> +								\
> +		asm volatile("ldr %0, =%1" : "=r" (kern_va)	\
> +					   : "S" (sym));	\
> +		kern_va - kimage_voffset;			\
> +	})
> +

Could this be simplified to __hyp_pa(hyp_symbol_addr(sym))? That would
avoid the dependency on kimage_voffset.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
