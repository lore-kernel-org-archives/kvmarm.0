Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A76DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 19:57:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 110664B26E;
	Mon,  9 May 2022 15:57:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bBt434Dp0C8A; Mon,  9 May 2022 15:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A1C408AA;
	Mon,  9 May 2022 15:57:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68486408AA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 15:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vyU4iJmKighQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 15:57:45 -0400 (EDT)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EA97408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 15:57:45 -0400 (EDT)
Received: by mail-il1-f175.google.com with SMTP id z12so10040108ilp.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 12:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UREYdDElVT63DJ85rhyIs5tD66WOEgYZkl05/GC/WxA=;
 b=Il/cOYnpyhm8Hs17rCt1yiTHqAg9YbsWT67w3eRco/qYj1x8NVVYhjfbLQn1Qjw0lO
 b+8wNy8hspQwcpNQmc4yOdsBpj9tYxFsg5/Knh2XMm2F7+vmVlYRBiz6Ea23OhdQSAWq
 NOZfVG3vx2rivbRKmeeVc+sHwyqhWoexOj2ykdAYchZdQ7P2VlQEZii4Z83birH2mFh+
 1AcQ7lCfHgsS7RU1l3lGYfX4VH8ors0qUJJYq0FnAossYl8z/l6no/SgsNYpvP/wrXky
 I5jxIhIVJDsDirXDpD4yEW5kRE8mB0N8whGJZMMdEkxrgrXtxr6nam3HI59c34M/sHjw
 Ibdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UREYdDElVT63DJ85rhyIs5tD66WOEgYZkl05/GC/WxA=;
 b=GLYlYB/OVRqtd6dFXbMg83VBt2CvmkEqqOYjQCqbuHdsW4mLrW3uvftWl+j1OfkEjd
 VxXAiSvKTZlitqsyWryAIUWN2+jdQcnj8o5IC7l1xIAHcgSlYK/z/96gjABsbUtJG+/+
 XZVVxzkqHJGRF+xxMPXAgLH+et6qT5EYYu0xsCG9JwuMhR0FzV2Uzux9/BItr42YG5kJ
 MuUDHz5q2V3Fp83ZjwFTJ+ru3PAY5yK4OA7toGFGGV7YvpONpkhGgxWSVXDwmYg3Pxqi
 txlQmDFbHCXHwSOmFUoFkNzejjEqN7WBqzGmPwUxuusCNB6Z7XoE0+epEb3FzD9cG+h0
 kQjQ==
X-Gm-Message-State: AOAM530g1z2CFtQybiHPqYiskhdxAViF43FfRNmWMyCc+voTeN+JWKjf
 qPycZXjDmtmCYlUgCrV77bdi6A==
X-Google-Smtp-Source: ABdhPJwQCgWSG2CxUH+XCn8bLC5vpebAZgxkfDFCp3/9KeJqN4sbnJHyjrJOCHXYq04N6AvkoQa/Mg==
X-Received: by 2002:a05:6e02:15c8:b0:2bd:fdca:18a8 with SMTP id
 q8-20020a056e0215c800b002bdfdca18a8mr7509767ilu.320.1652126264533; 
 Mon, 09 May 2022 12:57:44 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 4-20020a92c644000000b002cde6e352e2sm3350687ill.44.2022.05.09.12.57.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 12:57:43 -0700 (PDT)
Date: Mon, 9 May 2022 19:57:40 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: Repack struct kvm_pmu to reduce size
Message-ID: <YnlyNPnwuxRcVlP8@google.com>
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-3-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220509120330.3043773-3-tabba@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, May 09, 2022 at 12:03:28PM +0000, Fuad Tabba wrote:
> struct kvm_pmu has 2 holes using 10 bytes. This is instantiated
> in all vcpus, so it adds up. This repacking removes all holes.

nit: commit messages should be written in the imperative. So maybe
'Repack the structure to remove all holes'.

> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  include/kvm/arm_pmu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 20193416d214..eaa8290b116f 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -21,12 +21,12 @@ struct kvm_pmc {
>  };
>  
>  struct kvm_pmu {
> -	int irq_num;
> +	struct irq_work overflow_work;
>  	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
>  	DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
> +	int irq_num;
>  	bool created;
>  	bool irq_level;
> -	struct irq_work overflow_work;
>  };
>  
>  struct arm_pmu_entry {
> -- 
> 2.36.0.512.ge40c2bad7a-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
