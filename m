Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C5EC07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:29:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D423D61404
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 15:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D423D61404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4944A4B0FB;
	Fri,  4 Jun 2021 11:29:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CXdJb4xMkCR2; Fri,  4 Jun 2021 11:29:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 073B84B101;
	Fri,  4 Jun 2021 11:29:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D618F4B0C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:20:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bsa8BOfl3nOm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 05:20:36 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A68AB4B0C1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:20:36 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 fy24-20020a17090b0218b029016c5a59021fso562062pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Jun 2021 02:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mBAEhjZZRv7Jcy7Zua0pi2TsECX3PFBDfNxkyFGsLO0=;
 b=GFzrB6mDdP8QDUkM5E2D3SpI1YuNW543kJ1Zx1kk0NuEJ9dY60dkreacgqq7B7HMEs
 uqcy1p2HaKtSeecuRPdMc+ZpGU/OEc3CdNONynbGrv/3vMYyT7bl4zUw0YUQ9/GOQcn/
 p9MzmRmMsJwpomp+rOKp0w+JG2E9nloY+xf18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mBAEhjZZRv7Jcy7Zua0pi2TsECX3PFBDfNxkyFGsLO0=;
 b=ZQaDotc/iiIWYi83tzHYdM73jdcnFx34bQDRT/QsgoGl0iDClVD9LhR4625NJLFPId
 TZ6eclYDw/vCcXeOeainFFbKVw+29GRGDC2OqjJdAmhpr6vw7YnBE0/ojlS37ahH7lF8
 Tnk1YbSqI+KBRhn4zitKxSb6Tuun6DWPFUtrRDElVqDMvT/mGtH8BrdQlKXeuCSEVk2F
 b7vVRMEzWfbOHQukhBFKfHem7tCBiTUS/xOelvBvCiTTc4NLC6oyBww5rkgeeX5RcAJ5
 bRA+lW56ZmW63XKazQe/71FwrcNK1ALb02huxUEhAfQ1Wi4d4IVnmNMy1kk31pTqvR2x
 lIdg==
X-Gm-Message-State: AOAM532ygLjJze74yTTOhlY3k4vBDUGJPV4boS/VjFTCf7kd3m+c0k2Z
 48FZy4gRHO5vz5bBbX2Nj/vshw==
X-Google-Smtp-Source: ABdhPJxqC/sFmH8NWFwbR+x7mytZyDKEx7TFmgf8/+UGv7fZox1XEZk3IYhTIOf3hSBOmUz/xertuQ==
X-Received: by 2002:a17:90b:607:: with SMTP id gb7mr3845129pjb.5.1622798435671; 
 Fri, 04 Jun 2021 02:20:35 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
 by smtp.gmail.com with ESMTPSA id p19sm4236799pjv.21.2021.06.04.02.20.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Jun 2021 02:20:34 -0700 (PDT)
Date: Fri, 4 Jun 2021 18:20:28 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLnwXD5pPplTrmoZ@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87v96uyq2v.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87v96uyq2v.wl-maz@kernel.org>
X-Mailman-Approved-At: Fri, 04 Jun 2021 11:29:07 -0400
Cc: linux-s390@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On (21/06/04 09:46), Marc Zyngier wrote:
[..]
> > +void kvm_arch_pm_notifier(struct kvm *kvm)
> > +{
> > +#ifdef CONFIG_PM
> > +	int c;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	for (c = 0; c < kvm->created_vcpus; c++) {
> > +		struct kvm_vcpu *vcpu = kvm->vcpus[c];
> > +		int r;
> > +
> > +		if (!vcpu)
> > +			continue;
> 
> Wouldn't kvm_for_each_vcpu() avoid this kind of checks?

Right, that's what I do in v2, which I haven't posted yet.

[..]
> > +#include <linux/notifier.h>
> > +
> >  #ifndef KVM_MAX_VCPU_ID
> >  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> >  #endif
> > @@ -579,6 +581,10 @@ struct kvm {
> >  	pid_t userspace_pid;
> >  	unsigned int max_halt_poll_ns;
> >  	u32 dirty_ring_size;
> > +
> > +#ifdef CONFIG_PM
> > +	struct notifier_block pm_notifier;
> > +#endif
> 
> I'd certainly like to be able to opt out from this on architectures
> that do not implement anything useful in the PM callbacks.

Well on the other hand PM-callbacks are harmless on those archs, they
won't overload the __weak function.

> Please consider making this an independent config option that individual
> archs can buy into.

Sure, I can take a look into this, but how is this better than __weak
function? (that's a real question)

[..]
> > +#ifdef CONFIG_PM
> > +static int kvm_pm_notifier_call(struct notifier_block *bl,
> > +				unsigned long state,
> > +				void *unused)
> > +{
> > +	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
> > +
> > +	switch (state) {
> > +	case PM_HIBERNATION_PREPARE:
> > +	case PM_SUSPEND_PREPARE:
> > +		kvm_arch_pm_notifier(kvm);
> 
> How about passing the state to the notifier callback? I'd expect it to
> be useful to do something on resume too.

For different states we can have different kvm_arch functions instead.
kvm_arch_pm_notifier() can be renamed to kvm_arch_suspend_notifier(),
so that we don't need to have `switch (state)` in every arch-code. Then
for resume/post resume states we can have kvm_arch_resume_notifier()
arch functions.

> > +		break;
> > +	}
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +static void kvm_init_pm_notifier(struct kvm *kvm)
> > +{
> > +	kvm->pm_notifier.notifier_call = kvm_pm_notifier_call;
> > +	kvm->pm_notifier.priority = INT_MAX;
> 
> How is this priority determined?

Nothing magical here. I want this to be executed first, before we suspend
ftrace, RCU and the like. Besides KVM is usually the last one to register
its PM callbacks, so there can be something on the notifier list that
returns NOTIFY_STOP_MASK in front of KVM PM-notifier list entry.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
