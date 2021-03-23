Return-Path: <SRS0=T+on=IV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63481C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 09:47:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8495619C2
	for <kvmarm@archiver.kernel.org>; Tue, 23 Mar 2021 09:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8495619C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E49E4B414;
	Tue, 23 Mar 2021 05:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Twm8YStFo41y; Tue, 23 Mar 2021 05:47:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7304F4B3E8;
	Tue, 23 Mar 2021 05:47:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C724B3E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 05:47:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svhVcfUY+EI8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Mar 2021 05:47:54 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6E3E4B3E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 05:47:53 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id e9so20055060wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Mar 2021 02:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CFy34a5oRP6FBo34jkzCBDrM18ET5oxeV6C09KGor/M=;
 b=fLnTZIW+ncV0V4pak/1zB/4eGA2vCG0u8582JlaRuKJaekepck3Hi51f15dz/ZWlxz
 sQUvU6WQ+PnQl5ejeXthi6pN4WHunjYv9+RVag/vl+JjIlaFfcjUiJj2SdcFMJdSpcEN
 4fbKMtXCvaxkH5oqnf983GkVGeMgxjerVGs3H0Xnw48l0XHHV5AgEkQisTeP3US4wJ1i
 M+MOMHNzAbxPAZ1zFxg5Qx8q7oLZhxqoomj51Gs9va0UXqRKA9cDLvg/wDDQO7/9rCI2
 aYm0pJQgp8mSu9HyMPZBMGm3YhgaA2hVcvcQWQrBNUheqOFP+G6LTR1Y+m4Bp5w1e9+H
 feMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CFy34a5oRP6FBo34jkzCBDrM18ET5oxeV6C09KGor/M=;
 b=BLoeM01rVTZClkPC9Npk75rXfNnlem+P1S2FHLTEChBxLLgEY+xzRM/wT2fb4VzQKc
 NRx1UZ6XLC5HC3OB/BqIglsgIedKYbAlaTZLStjTxoLDRWxQpEowkAo8r5n7WCIYd0jS
 OLNW5Y/8p/YjKVKCXoZa2UAlwgREGh9oR8w3oxBLiqzGJjHaq90PcUOvPZe0StfQmEbU
 oIdyHKY1X1CAUlXRtLIYH+7jj2RXCoHH2O/YnpXW5C/tPMz1+uTrI3CvwvoHIzcExSGb
 x4pcqnP+n6u6JukGZYgOhWLWuBpT8uC9i/6XZmuGLRhUmFv3qXhqJphFmweGSAsZpGyT
 xBmg==
X-Gm-Message-State: AOAM5304v7QLucBSqXCIOgV6JyGQR/XWbMWgyjALZk5MPw+pNV9r4a99
 hAIsJW97FnTNr6BBkvdj0DqcJA==
X-Google-Smtp-Source: ABdhPJy48bd7zMN/7IQI/7qwsmEMtZoUKMwW7NIyR6X4/+xBeETwQsu0Z7rjmuADJ6dWg+IBGOQErA==
X-Received: by 2002:a05:6000:4b:: with SMTP id
 k11mr3023308wrx.35.1616492873041; 
 Tue, 23 Mar 2021 02:47:53 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id h62sm2322264wmf.37.2021.03.23.02.47.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Mar 2021 02:47:52 -0700 (PDT)
Date: Tue, 23 Mar 2021 09:47:50 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Drop the CPU_FTR_REG_HYP_COPY
 infrastructure
Message-ID: <YFm5Rsz8HlKo2sss@google.com>
References: <20210322175639.801566-1-maz@kernel.org>
 <20210322175639.801566-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210322175639.801566-4-maz@kernel.org>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 tabba@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Monday 22 Mar 2021 at 17:56:39 (+0000), Marc Zyngier wrote:
> Now that the read_ctr macro has been specialised for nVHE,
> the whole CPU_FTR_REG_HYP_COPY infrastrcture looks completely
> overengineered.
> 
> Simplify it by populating the two u64 quantities (MMFR0 and 1)
> that the hypervisor need.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
