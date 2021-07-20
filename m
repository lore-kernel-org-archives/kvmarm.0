Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE13C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:09:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 824FF6113A
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 824FF6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 020C54B0DA;
	Tue, 20 Jul 2021 06:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XtTaXUT2RCDU; Tue, 20 Jul 2021 06:09:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17D554B0D4;
	Tue, 20 Jul 2021 06:09:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2194B0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:09:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VRUIKJDYoP4S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 06:09:26 -0400 (EDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1C544A195
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:09:26 -0400 (EDT)
Received: by mail-wr1-f47.google.com with SMTP id d2so25426268wrn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 03:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=0j3bPtwVUVm/jZDBUJXolF4U+AmslpUbr8sCL6VPfoA=;
 b=HAyimdTxgae0VX9e5mbMhkKbnj16MrHWbI0i37pITjBmQQJ4VRXmvUpgvzO9ymMIKg
 mjrgM+dSiSax+84SIS0Okxr3ALUy2Ehb+jDqtr2dpRRcd9ugaeJaePM84jSgNnWfo7b6
 owAA6Yabf9pZ2CECadWlx2Vf/UcEBe3Ru/Hg8eXnI3Od9skjqLcVzLQYwMKdHLP1FjTf
 UXYVjUdCfgJtyqHqmkXXSPNvKzWc7/4OhrDx4gVDizRY6QqTXT5ADTSEwm8EW6X4NsiK
 KfeXgor2I58mOMbFMQYxJ6eRaDl5r+ueK7+ScH5nlJkkcOYGasQrSdjuHKcsvRFOpkbH
 csUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0j3bPtwVUVm/jZDBUJXolF4U+AmslpUbr8sCL6VPfoA=;
 b=nQzpwWby7J0wWt/TB0Q3vfOXN9EWyY5duuAw2QDde+0FpYOMmmNkbu6dzj4TNff9xR
 iEr7UTWMS87z4//uviOccrR9oQNzhwWTTmypc0nHqE74UZlfEeD1ECaVsQBxxBTzftp9
 DhTNUBKp07FrOTzg1rmoM5IiYU0wQTwT2OWOCKeRGtPlprmcdSahhbr45Dy0C0Vb+Swt
 7sUki/O7FeREJubyAmcWXPNXxuJY5VLjUzTYAa3wtDLFx1kelpvKz3CrJdKrNi5eKyZa
 1NwmyJZMit4fCUiZgdWwXGtafSb9zwnkE0TtxFdpowhm3NYPnDrR9AjdQTxa2F0J4td1
 oShQ==
X-Gm-Message-State: AOAM532iS4OWT7n8VCOeoEXqcruY0GTPSVpB1ChGzzATz2d9uQye0FIg
 A+2nbeBy7RLrjLa9R1mISywc4w==
X-Google-Smtp-Source: ABdhPJw9FCFTdkiAN4LxfJoUs++5xlLWx8lVhaIJEWeX7hAEofC+sahFp6Ki2Mrs5oqdp3xuqh93zw==
X-Received: by 2002:adf:a2c3:: with SMTP id t3mr33970462wra.223.1626775765602; 
 Tue, 20 Jul 2021 03:09:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id m15sm19470088wmc.20.2021.07.20.03.09.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 03:09:25 -0700 (PDT)
Date: Tue, 20 Jul 2021 11:09:21 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Message-ID: <YPag0YQHB0nph5ji@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-4-maz@kernel.org>
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

On Thursday 15 Jul 2021 at 17:31:46 (+0100), Marc Zyngier wrote:
> @@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.arg		= &map_data,
>  	};
>  
> -	if (owner_id > KVM_MAX_OWNER_ID)
> +	if (!annotation || (annotation & PTE_VALID))
>  		return -EINVAL;

Why do you consider annotation==0 invalid? The assumption so far has
been that the owner_id for the host is 0, so annotating a range with 0s
should be a valid operation -- this will be required when e.g.
transferring ownership of a page back to the host.

>  
>  	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
