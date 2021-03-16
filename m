Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8A6C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:46:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8ABDA64F4C
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ABDA64F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 068224B581;
	Tue, 16 Mar 2021 06:46:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CWatyAxy6jz7; Tue, 16 Mar 2021 06:46:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A824B603;
	Tue, 16 Mar 2021 06:46:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE654B603
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:46:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2oqlBATU9uLO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 06:45:59 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 441104B581
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:45:59 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id o16so7167250wrn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Zsdz2h8hf8Y/24lVeadYaeeQAMOF3TALsCOQcWpVAJk=;
 b=SJTMsl6KBrovYMSkF7DcCJIHr0K+jwCLFtt5KCAHC4SmzQZMxaKdsw4YmOZ6G8gQ/i
 F54HseY7kRTu5nSHt0RbnDBuMDiPhg324fyoJelGspMcblDCPxRPcTQ4ar6eoV9mVIlm
 qTFoHlBhuBgya022zZGChk+AuO5qVI1rZReb5GhTu3+QsezemBJqLbqN/HibJ/uMoxSm
 SIyx1yXH6rEgYgr8M6/PhZ58ySzz4360Vx59ApLJ2L/Ko3guwywAckBrVjdDgstbNPKR
 Dj0+wLofArhDqFekakXYvgpiOLeiZbsKcI5aY7IlY7hCv43TEs3oaYM2NnUEc2U1306r
 dEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Zsdz2h8hf8Y/24lVeadYaeeQAMOF3TALsCOQcWpVAJk=;
 b=R7JkJN01eM7kQLMePUPoxPZzQYxPbfZ8a8eFphgvOLpmDakB1sjW9PxKQGmjFHNkHc
 Y/pM3F5IhOHoAyCB24NRSKMfL3479hfviD7RG1h1FRiyY+8zuNH6+GWnJtzoBpwaCAi+
 9hXpDVLR8MZtl07E4Uqx6HCO6FHYFKYBZXW4jy3/Ejr+iMA9QIJSl9GMwKsgOIvXLWQm
 HoU5DelPeEs63Uaw9FrTA6iaaXSb6mvIN/eM6u38ze5Nf9yZ7kmCiU19QKiM27ARAZ0a
 oVvjl+XuBGT7uoPmNqnxRLN1maBxsBv2ZNtdAsQR6AR83xOVJPsmY82Rjdrsj5/b1G3Z
 TvXA==
X-Gm-Message-State: AOAM53274LEDD0NyQKn21sfqvd/5wdByhIh0g2pdyFfbr7sc3mz4Cq3c
 NxGX6/mjMpjkgQ2BLAS0u06dZQ==
X-Google-Smtp-Source: ABdhPJzzT1u4K5ULsw5LvTSW/vhY00CzqQZU1WwxkZhBult5lmWWoNSeYotgmhqJqS602sEukhDbsw==
X-Received: by 2002:adf:a418:: with SMTP id d24mr4111334wra.187.1615891558225; 
 Tue, 16 Mar 2021 03:45:58 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id j203sm2868593wmj.40.2021.03.16.03.45.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Mar 2021 03:45:58 -0700 (PDT)
Date: Tue, 16 Mar 2021 10:45:55 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/10] KVM: arm64: Add a nVHE-specific SVE VQ reset
 hypercall
Message-ID: <YFCMY2TDl4/6++PJ@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-9-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-9-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tuesday 16 Mar 2021 at 10:13:10 (+0000), Marc Zyngier wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c4afe3d3397f..9108ccc80653 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -593,7 +593,9 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> -#define kvm_call_hyp_nvhe(f, ...)						\
> +static inline void __kvm_reset_sve_vq(void) {}

Why is this one needed? With an explicit call to kvm_call_hyp_nvhe() you
shouldn't need to provide a VHE implementation I think.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
