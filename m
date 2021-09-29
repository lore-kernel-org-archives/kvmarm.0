Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E54C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:41:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F38AB6147F
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F38AB6147F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70EFC4B11F;
	Wed, 29 Sep 2021 09:41:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m5ehVJPPonRz; Wed, 29 Sep 2021 09:41:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A234B0D9;
	Wed, 29 Sep 2021 09:41:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C954B0B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:41:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7lHVwtZNdY1N for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 09:41:14 -0400 (EDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E68F49FE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:41:14 -0400 (EDT)
Received: by mail-wm1-f46.google.com with SMTP id
 b204-20020a1c80d5000000b0030cd967c674so3849469wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 06:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8zTkbVm3Z8SpIKUtLyUq9LTghZR593e6SVoW4QuNd20=;
 b=AxUSXoBB3tfQRc8aFp3qs+NkR4akyD1opeDx5OBAxYf7bBFGb1HqX25oj6+k1NvtaQ
 R9gzgBYCJcKaiSfZoXWC0pqMCzly17i2jBs2xQ8Jur5GRFQ8+149QSXLUa0lkmleon4q
 2XQ/wMo/QAb3s+25Kni2BXlUaSSaaoGxmpKCChPJM7/bK7FC27Oywc8yO1aW49TeP0Hp
 79/ys06I6zm/wX8btcvzUe3Y0UFMsL4fJE8lBxAfobOzIj5OhrnUzMCzIkpNxbMWoBjM
 80piIvv78GPVKgZED6TVqizKJMXnlm9NTTpHEFuFiIWu4mmEHPCyIPvAbDQCoEMntXyq
 WlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8zTkbVm3Z8SpIKUtLyUq9LTghZR593e6SVoW4QuNd20=;
 b=ktNZuGBEDbLz+M2AGqPM/bmm+KloO93CCBwvVcaLPSC35yIN7CZzHjVudbO/rJDwn0
 vPlUZze7TcpoegL9PAPTU+k/fMYsqNqq6O0Ig1PZvywqD9rlRcoITeAjtKWHS2qX6BUY
 zfCiG8461vwbFuVogtqNoA4KidTwmTFUs1Fuqloj8fkSjL6FxlBoOU1HbGGdoBuxu9uf
 E2bbF2sBn+nDlsBuswaMkPT8wZdpY2CWMEVwMxxxu4IlzvAUIvwJTt67VjxFoufu0hVK
 1weSN218mqg9JAhvHvvjpOsuRqNMd4RiYD4eAw61sY09QiFvF/RpZCFhgEHLQMdtevkI
 W9nQ==
X-Gm-Message-State: AOAM533BzdL8gQRh/XsNh0ta753oJh/KWxuYfb4AGA7c0U5NYZ8C89Jo
 YvZOiHqa8aa7uQpCaM+fmIGSHQ==
X-Google-Smtp-Source: ABdhPJyiEDyoR1KgDk/hdilL8nWV/fMgBRNsKeMkLMofDuNYSGHNUhEe8kaPI7XdOFqMRNFm1cWREg==
X-Received: by 2002:a1c:2348:: with SMTP id j69mr10228371wmj.189.1632922873028; 
 Wed, 29 Sep 2021 06:41:13 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:1ebb:fd0f:cf53:11c5])
 by smtp.gmail.com with ESMTPSA id z8sm2696973wrm.63.2021.09.29.06.41.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 06:41:12 -0700 (PDT)
Date: Wed, 29 Sep 2021 14:41:10 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 4/5] KVM: arm64: Prevent re-finalisation of pKVM for a
 given CPU
Message-ID: <YVRs9nkIg3BZ6cVR@google.com>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-5-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210923112256.15767-5-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thursday 23 Sep 2021 at 12:22:55 (+0100), Will Deacon wrote:
> __pkvm_prot_finalize() completes the deprivilege of the host when pKVM
> is in use by installing a stage-2 translation table for the calling CPU.
> 
> Issuing the hypercall multiple times for a given CPU makes little sense,
> but in such a case just return early with -EPERM rather than go through
> the whole page-table dance again.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index bacd493a4eac..cafe17e5fa8f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -123,6 +123,9 @@ int __pkvm_prot_finalize(void)
>  	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
>  	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
>  
> +	if (params->hcr_el2 & HCR_VM)
> +		return -EPERM;

And you check this rather than the static key because we flip it upfront
I guess. Makes sense to me, but maybe a little comment would be useful :)
In any case:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
