Return-Path: <SRS0=pkzt=MX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB956C432BE
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AD5A61042
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AD5A61042
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D53B4A524;
	Sat, 31 Jul 2021 05:33:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fZ9MTHF6r-mv; Sat, 31 Jul 2021 05:33:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B0F4B08C;
	Sat, 31 Jul 2021 05:33:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 320804B0BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjrWvKGNWbql for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 12:56:53 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D38D4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 12:56:53 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id mt6so16140353pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 09:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NHmczmIzJufSB3Li/LucyxkDOJfl+luasFO2GMfh3i8=;
 b=EwcggOYo/KbZsqbv7CnLQji1AaGLnOh5sUY2NEpMi13aXZro2JK54VQT6EA0LGqEhp
 1dUrc+sHK5QUBLJMqWCOkVhRORDMasbGc+TOD24B7tNkfpzuGSMo8PWaKmEy1U7xtHUx
 q2Tra7+g6UGs9nC/2zTwsRW3ZjjJMQUqLUuu86eJdfpsqEdwAhNF1wbUviE7h7v3e4No
 ZhEeZbFW48Wecy/exed5zVehY2v7yXNhQFiz7UAWuLehu8RXOsgutb5gJvvx4xh51f0m
 ch4nma24ljAdFeNIidkVIV4YCjh9zTv7Sz9NEIs3gib/XxkJ9DakVPEgZNpUgkRMS3f3
 pmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NHmczmIzJufSB3Li/LucyxkDOJfl+luasFO2GMfh3i8=;
 b=PMGetXih5+807YJ58qoibodQy1gBfczs65zsLFx7oF2Wa0uhZ3ZVbJCkIMry3z2YCW
 SBTpkGl/jtIo7oDww2jjwyz+HHlP8yss25mR/xf9yvHv5Twhp2pe7QFpmfIbxWo1m3sQ
 dHwQnilrLBmcKnjsyXn2K9kl3vueByPR+RI2NGPVHKrFpbLvzeKhmaOrXdZ39KWFvZbT
 GSSZ6a7QdTQbdaaLGbY7DF/Kl2mJITZYGRb8tX5rhocPRgkArG4+k98kg4EEUa6j7QXr
 i83qeRzU1OpPsjSjPttyfsuUIhE+mlmJFz1pc1l0mH5crLlwxKnOHKhuP90ZHmEs4LOz
 A+mw==
X-Gm-Message-State: AOAM531LBzvhLlkMcTK6ar4IbCAdQ4ZnKQgEhVWwzmBtjBgOK6MynHsD
 ihDfVZVMt+ctHG3ssqIPZNmRTA==
X-Google-Smtp-Source: ABdhPJzWI6FoTcaZNj62M9u9nn73qB7KjElQlQVRB3Sn9a2CCf11QZlLRjOgsi/YapsBA2ELYgUCvw==
X-Received: by 2002:a63:4e11:: with SMTP id c17mr3123982pgb.54.1627664212050; 
 Fri, 30 Jul 2021 09:56:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id f3sm2904882pfe.123.2021.07.30.09.56.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Jul 2021 09:56:51 -0700 (PDT)
Date: Fri, 30 Jul 2021 16:56:47 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work
 function
Message-ID: <YQQvT7vAnRrcAcx/@google.com>
References: <20210729220916.1672875-1-oupton@google.com>
 <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org>
 <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
X-Mailman-Approved-At: Sat, 31 Jul 2021 05:33:51 -0400
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Fri, Jul 30, 2021, Oliver Upton wrote:
> 
> On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 29 Jul 2021 23:09:16 +0100, Oliver Upton <oupton@google.com> wrote:
> > > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> > >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> > >  }
> > >
> > > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > > +{
> > > +     return kvm_request_pending(vcpu) ||
> > > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > > +                     xfer_to_guest_mode_work_pending();
> >
> > Here's what xfer_to_guest_mode_work_pending() says:
> >
> > <quote>
> >  * Has to be invoked with interrupts disabled before the transition to
> >  * guest mode.
> > </quote>
> >
> > At the point where you call this, we already are in guest mode, at
> > least in the KVM sense.
> 
> I believe the comment is suggestive of guest mode in the hardware
> sense, not KVM's vcpu->mode designation. I got this from
> arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
> intentions.

Yeah, the comment is referring to hardware guest mode.  The intent is to verify
there is no work to be done before making the expensive world switch.  There's
no meaningful interaction with vcpu->mode, on x86 it's simply more convenient
from a code perspective to throw it into kvm_vcpu_exit_request().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
