Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5EEC4741F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:35:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F286D20756
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 18:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="j74lrtCw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F286D20756
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1EA4B2BF;
	Tue, 22 Sep 2020 14:34:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hfGfhdcI1SL6; Tue, 22 Sep 2020 14:34:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3125C4B24E;
	Tue, 22 Sep 2020 14:34:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22BD24B181
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:34:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XLnbW6nUfimJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 14:34:56 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF1E44B134
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 14:34:55 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id b79so4369452wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Ig3mZwlM5VgOYpaLezhg7vQFxV24lXeVdfnz5xWj0rM=;
 b=j74lrtCwlnu6fqYOp87AYQKgh20vY4HWutnBUDTD/MqKbmkWvoiV1gzSZV1V651W6t
 0EKrZbRNvxSaOS5XQN/3rRjYUWD+Ybjv7r9BGve2BX11HJKB1svj+6D+/qfyXmfvs5PX
 +uTe4FmQnZePv8i6hoTB84tksthKi2ioxGQFqtqwFVhQQsPsEIsaZHKXIpuaML4TRitw
 C99CuqPCX6sqXqJwRmpmlW0UUiuKt8OkI4se3513BsxjHTyOHyDzrjDiH2IAT20a8hxQ
 syrZurWX6+zVVt9bSCPXFUuRjAYKQbteOrwVjfILeDBIkZQWQziXt/ZnAD2Waf7SR4a8
 vZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ig3mZwlM5VgOYpaLezhg7vQFxV24lXeVdfnz5xWj0rM=;
 b=SbOpBUEEhMogES9Hkp3Con5TWUaF029rdTH59P7+tj7fA+R6nNc46YCsdd9qc9kfAt
 H5TKGOfowXuehpgGztxyDCOuAWZcc8/j2xsk0FKPp1DcEjDEEwnr0U2/MWc8OaR4Hv9t
 3TZLptO8DS/yFYTUeMmqCFyHy+dOgHD/fcQOZvO3GS2ivpI6RY6yV79TiyYP6ZXOQ4Uh
 3RZ7AdXbV12DBaIi9lsmSp/tX4nPX99xKWPpWBfP/fqdlGVisA889UmvOgwQvawzuZf2
 5o6FVCGbkCwGNUvdfxNNx4+3maQrMH4vC3arw5UNdK76GQkW39YreicuyYC4LT/jUjml
 zkBg==
X-Gm-Message-State: AOAM531eny4KbL2kAydqVX+ApSu8NlbGTJ4dcS0Lu8bjyrQ2S8soel+T
 sDujI+TXuxAD2l9VmhbXjxceNFskpgNs8bfz
X-Google-Smtp-Source: ABdhPJxj0h/V08O5vb8gOXVPpqliJJY+kmMZI4zN+kzRDjl+BRuapEiHWcZOA9NImhQeqmN/2EE34w==
X-Received: by 2002:a1c:40a:: with SMTP id 10mr1283670wme.61.1600799694728;
 Tue, 22 Sep 2020 11:34:54 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:55c2:2cdf:ff31:96a3])
 by smtp.gmail.com with ESMTPSA id 63sm29411016wrh.71.2020.09.22.11.34.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Sep 2020 11:34:53 -0700 (PDT)
Date: Tue, 22 Sep 2020 19:34:52 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 10/11] kvm: arm64: Set up hyp percpu data for nVHE
Message-ID: <20200922183452.xalwog2ojsc5ogpe@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-11-dbrazdil@google.com>
 <20200918122219.GD31096@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918122219.GD31096@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

> > -#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
> > -#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
> > +/* Array of percpu base addresses. Length of the array is nr_cpu_ids. */
> > +extern unsigned long *kvm_arm_hyp_percpu_base;
> > +
> > +/*
> > + * Compute pointer to a symbol defined in nVHE percpu region.
> > + * Returns NULL if percpu memory has not been allocated yet.
> > + */
> > +#define this_cpu_ptr_nvhe(sym)	per_cpu_ptr_nvhe(sym, smp_processor_id())
> 
> Don't you run into similar problems here with the pcpu accessors when
> CONFIG_DEBUG_PREEMPT=y? I'm worried we can end up with an unresolved
> reference to debug_smp_processor_id().

Fortunately not. This now doesn't use the generic macros at all.

> >  /* The VMID used in the VTTBR */
> >  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> > @@ -1258,6 +1259,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  	}
> >  }
> >  
> > +#define kvm_hyp_percpu_base(cpu)	((unsigned long)per_cpu_ptr_nvhe(__per_cpu_start, cpu))
> 
> Having both kvm_arm_hyp_percpu_base and kvm_hyp_percpu_base be so
> completely different is a recipe for disaster! Please can you rename
> one/both of them to make it clearer what they represent?

I am heavily simplifying this code in v4. Got rid of this macro completely, so
hopefully there will be no confusion.

> > -	if (!kvm_pmu_switch_needed(attr))
> > +	if (!ctx || !kvm_pmu_switch_needed(attr))
> >  		return;
> >  
> >  	if (!attr->exclude_host)
> > @@ -49,6 +49,9 @@ void kvm_clr_pmu_events(u32 clr)
> >  {
> >  	struct kvm_host_data *ctx = this_cpu_ptr_hyp(kvm_host_data);
> >  
> > +	if (!ctx)
> > +		return;
> 
> I guess this should only happen if KVM failed to initialise or something,
> right? (e.g. if we were booted at EL1). If so, I'm wondering whether it
> would be better to do something like:
> 
> 	if (!is_hyp_mode_available())
> 		return;
> 
> 	WARN_ON_ONCE(!ctx);
> 
> so that any unexpected NULL pointer there screams loudly, rather than causes
> the register switch to be silently ignored. What do you think?

Unfortunately, this happens on every boot. I don't fully understand how the
boot order is determined, so please correct me if this makes no sense, but 
kvm_clr_pmu_events is called as part of CPUHP_AP_PERF_ARM_STARTING. The first
time that happens is before KVM initialized (tested from inserting
BUG_ON(!ctx)). That's not a problem, the per-CPU memory is there and it's all
zeroes. It becomes a problem with this patch because the per-CPU memory is not
there *yet*.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
