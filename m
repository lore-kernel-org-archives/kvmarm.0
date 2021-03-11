Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C70C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:40:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 052C564FC3
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 10:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 052C564FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787574B69C;
	Thu, 11 Mar 2021 05:40:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dVu3hYOgKe2d; Thu, 11 Mar 2021 05:40:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A784B6BD;
	Thu, 11 Mar 2021 05:40:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87E0A4B691
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:40:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O4i7HoJDzRjO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 05:40:26 -0500 (EST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5725D4B643
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 05:40:26 -0500 (EST)
Received: by mail-wr1-f46.google.com with SMTP id j2so1255098wrx.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 02:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=x7dj7m0IqQSmVZy2aSDZleyuSlNYKW9a/ZCzpcFSLV0=;
 b=QzEiz4ezQniLybdnDy+B3onf6US6y74U1SgN5rHlI+ZmV58h4BldaYUhlmr8dq8coZ
 wsunQbmi5SFHla/8So7acDUTQX/m4FsR7kMYAQjeF1mDzcdsizwl6d12fD1CXRKrPJ0N
 eOetUItUfAD6t20hJDE0sKnabVZ3ABUWORz2YRqX+7NpPnJ56KCvxnsaphj/3k2coxO0
 WnmYp8pikyfkAFH1iMcfcOUY9LwSy0JRGcmVtjEXSgSuJvI5GsnQVU10VOm/Lf0iS4aR
 84KS40Um1XlhHbwERidW1Tt8Lg4VfeeeXwf2LJwiAGO5BDO2y9kuU1TtuEAcKlhbw/y7
 xldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=x7dj7m0IqQSmVZy2aSDZleyuSlNYKW9a/ZCzpcFSLV0=;
 b=h6bFggQI0LdYMxExHfXNXFyMypAOjXimvaU6j5Wdg7nTdT2OjK0d5HGEWSDw5KN2bG
 Avn5rqVBqTPS4NaSmKERtE58+VKT1w5Iw/68ysLzBxJ+5ZydhDddgXpJEoaDOgiO8ThW
 UBVQdp0FTSaK7cgqTjdjug8ECWTbhd9pjLIUmqGhV0KiuiN/bUZ7o2JMIPkyAYrWRM5n
 Z986sUCM25OUGosmSxqIlZxWSRYhKzSlaFGmiDy5kuorgqkJ5hSsXOSzoyW1jMO1qDww
 HI+PwafT82FAzoaU4a5QnuTJ7kBLMSAYCss09sL8vrHR0GHe+/nT3Ox8XDdLEHcIaFXr
 dO5Q==
X-Gm-Message-State: AOAM5300CBkp+DPYl3YzpPWumTP8V65KB8xsj9i/3Y6qqoKdxvL8/NUx
 SY7pSGstLzBU4BMYMPN6pghJJA==
X-Google-Smtp-Source: ABdhPJyiiKwT/A6ppgUs4f+GjLSsDKYEx9RQPlr5m0FVk84pobzrFg7Nh362DHAntJQuxuvZset3JA==
X-Received: by 2002:adf:fbce:: with SMTP id d14mr7751922wrs.44.1615459225332; 
 Thu, 11 Mar 2021 02:40:25 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id f16sm3177531wrt.21.2021.03.11.02.40.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 02:40:25 -0800 (PST)
Date: Thu, 11 Mar 2021 10:40:22 +0000
From: Quentin Perret <qperret@google.com>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 05/10] KVM: arm64: Track where vcpu FP state was last
 loaded
Message-ID: <YEnzlqnT8QdfpDpR@google.com>
References: <20210304115454.3597879-1-ascull@google.com>
 <20210304115454.3597879-6-ascull@google.com>
 <YEny6LbBPmKpK95k@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEny6LbBPmKpK95k@google.com>
Cc: kernel-team@android.com, maz@kernel.org, Dave.Martin@arm.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thursday 11 Mar 2021 at 10:37:28 (+0000), Quentin Perret wrote:
> On Thursday 04 Mar 2021 at 11:54:48 (+0000), 'Andrew Scull' via kernel-team wrote:
> > Keep track of the cpu that a vcpu's FP state was last loaded onto. This
> > information is needed in order to tell whether a vcpu's latest FP state
> > is already loaded on a cpu to avoid unnecessary reloading.
> > 
> > The method follows the pattern used by thread_struct whereby an
> > fpsimd_cpu field is added and updated when the state is loaded.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > Cc: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       | 1 +
> >  arch/arm64/kvm/arm.c                    | 2 ++
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
> >  3 files changed, 5 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 8a559fa2f237..a01194371ae5 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -306,6 +306,7 @@ struct kvm_vcpu_arch {
> >  	struct kvm_guest_debug_arch vcpu_debug_state;
> >  	struct kvm_guest_debug_arch external_debug_state;
> >  
> > +	int fpsimd_cpu;
> >  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> >  
> >  	struct {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e3edea8379f3..87141c8d63e6 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -313,6 +313,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  
> >  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> >  
> > +	vcpu->arch.fpsimd_cpu = NR_CPUS;
> 
> Is this supposed to be an invalid CPU number? If so, then NR_CPUS + 1 ?

Obviously not, forget me.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
