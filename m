Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52ABC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 09:40:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68D376138F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 09:40:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 68D376138F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3AFD4079A;
	Tue, 19 Oct 2021 05:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GMR0xGU4xABM; Tue, 19 Oct 2021 05:40:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDBD94A193;
	Tue, 19 Oct 2021 05:40:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E823D4086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:40:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s1RI++zbs13G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 05:40:28 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFEB14079A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:40:28 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id r18so46590685wrg.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 02:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+v4Hfkg/w1/B4R5A/ecV7kDZ1+BpxRgtZ9ZYRUTGvYQ=;
 b=SKdRW7siAk731anszKLFJ7LCVf1ZukxuHCQa9UfvTaS+LMfaeSqnc+PdFEyz2b9Vql
 R9n2h4pfsBE+hTtl9Ghcf73/JuT7EvSbvrayRN4ynnOPhQo2YSbaa2uPZt5r4puv5gfK
 GaTMyTPjRRQgvhLvowqAFIDI+9cKrp/IeO9ZAC8t6pdqf4w8t/Q1YC4NIoHvacb0FPms
 Cgm3gUBIOrm4FhPkuzjC6bGgzVMTNnDNWmpEOZz92J1kYF54KTktv+6+qRpIPIOleMfH
 7rW14/k/BiowMiLxGBg2YIKmhi2tV85quWfj9WotO4rPM5TGN+7tWvTBQUosIYMhYK9X
 v8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+v4Hfkg/w1/B4R5A/ecV7kDZ1+BpxRgtZ9ZYRUTGvYQ=;
 b=mtTEFcvHU28zb4o9XUmj8YaUf51a3NWN5lP0RJX4mEYsWmNWNreWSFQlce3z3T8dmI
 iZy9+Gn3I1PG14w5whFCR8rQFP2KNrtsXa+Bg4fL9Ps0eJCLXp7SquyC7Fg21oMsZEwo
 LqcbSpgYGW9Nwz1PwOPXPVD1za5+UjAalp6cdC7rxKylp1nC/cVxFyE2MdQBF9c9LFJX
 Xpwf24jsEybdrEFuJv73VHzJiCefOmT4DtJST2vkTHiqu2X2cW8aKWXzpQCQA0tR+cLa
 aE0SUQGku4ahZBpQXJnwxC8hcXfSAqT8w46HUu2YRYMDzideRctIn9Q5HfE5zyig8OuT
 OEbQ==
X-Gm-Message-State: AOAM532htn5wB/7OUDJBwAZSVTrr5zcPUl2en5criN9cOfR0XUdeewmk
 WE8lyatfqAC9R/BJXVLStvBvMA==
X-Google-Smtp-Source: ABdhPJy9ly25Wdf1sCClM7a9Zz77DNMQFpedsH5Fh26mLWFifdz5sv78JyKVIUA8hXD5r5R+3vWcpA==
X-Received: by 2002:adf:ec46:: with SMTP id w6mr29994052wrn.240.1634636427307; 
 Tue, 19 Oct 2021 02:40:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 by smtp.gmail.com with ESMTPSA id g33sm1594777wmp.45.2021.10.19.02.40.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Oct 2021 02:40:26 -0700 (PDT)
Date: Tue, 19 Oct 2021 10:40:24 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 16/16] KVM: arm64: pkvm: Unshare guest structs during
 teardown
Message-ID: <YW6SiMLU19YN1ARe@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-17-qperret@google.com>
 <87h7dhupfa.wl-maz@kernel.org> <YW1NLb9Pn9NyEYZF@google.com>
 <YW1+mQ6Bn2HXwl34@google.com>
 <3ec8ab06f9950a13818109051835fdb9@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ec8ab06f9950a13818109051835fdb9@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Monday 18 Oct 2021 at 18:12:22 (+0100), Marc Zyngier wrote:
> On 2021-10-18 15:03, Quentin Perret wrote:
> > On Monday 18 Oct 2021 at 11:32:13 (+0100), Quentin Perret wrote:
> > > Another option is to take a refcount on 'current' from
> > > kvm_arch_vcpu_run_map_fp() before sharing thread-specific structs with
> > > the hyp and release the refcount of the previous task after unsharing.
> > > But that means we'll have to also drop the refcount when the vcpu
> > > gets destroyed, as well as explicitly unshare at that point. Shouldn't
> > > be too bad I think. Thoughts?
> > 
> > Something like the below seems to work OK on my setup, including
> > SIGKILL'ing the guest and such. How much do you hate it?
> 
> It is annoyingly elegant! Small nitpick below.
> 
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> > b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..50598d704c71 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -322,6 +322,7 @@ struct kvm_vcpu_arch {
> > 
> >  	struct thread_info *host_thread_info;	/* hyp VA */
> >  	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> > +	struct task_struct *parent_task;
> > 
> >  	struct {
> >  		/* {Break,watch}point registers */
> > @@ -738,6 +739,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> > +void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
> > 
> >  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr
> > *attr)
> >  {
> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 2fe1128d9f3d..27afeebbe1cb 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -15,6 +15,22 @@
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/sysreg.h>
> > 
> > +void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
> > +{
> > +	struct task_struct *p = vcpu->arch.parent_task;
> > +	struct user_fpsimd_state *fpsimd;
> > +	struct thread_info *ti;
> > +
> > +	if (!static_branch_likely(&kvm_protected_mode_initialized) || !p)
> 
> Shouldn't this be a check on is_protected_kvm_enabled() instead?
> The two should be equivalent outside of the initialisation code...

Yup, it'd be nice to do checks on kvm_protected_mode_initialized only
when they're strictly necessary, and that's not the case here. I'll fold
that change in v2.

Cheers
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
