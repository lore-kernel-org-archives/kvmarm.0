Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005B0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 20:28:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBEA4A100;
	Thu, 28 Apr 2022 16:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 480l3nLlgCCR; Thu, 28 Apr 2022 16:28:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA344B0C0;
	Thu, 28 Apr 2022 16:28:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D57D4A100
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 16:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id loURYYqf44Z8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 16:28:25 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D659F49F46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 16:28:25 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id f5so2728627ilj.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 13:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=6sv0GF1GP/peGzeAnSyLbNtF4CFloHInfqU4kjm9WdI=;
 b=Y/wsjClMN++XsvsNCYWdaaPGePF4LKIUu/iMDjgLEcYz2XtUXoMSXFU9ZRB+wW66gd
 WT5oSiJxdT47BAIEBE9ImP1pbJ2Jb1PPgAdR4tYJeK159J/llFucaVeCG1usC0IC60Kd
 Xa72xHGmGck/P8vgzly0JWsf0GErfllifcjIQ4bINh5awjg1gGnX915yRIHXmrVkUA02
 ycgbYhYS6dhpZk+tRX04j3+rh3Svc6j/Zychi1JHFD4ZTcjZXNjDMRk20yu52IAABITW
 yqMjyjJJukZo3xe20xjczVHYIH+nUVfpdV2iv7zKFqM5eSKQ5qO8TXzjMaAFwAcMTmad
 4/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6sv0GF1GP/peGzeAnSyLbNtF4CFloHInfqU4kjm9WdI=;
 b=x8ij+6CUm70mFvWPzpci1wtOLraZKrglJ9iaPMXiAdv+0pVfQeQFwBIYcEP4/OwCT+
 1Vx8io8X55RZvfe6pHSF9GElbFF/WagUPa0gZ7nAr/G3lvOo/S+zNhsjVqZvlv0JnS5I
 eeLN99NJC/52wVfMdJ0av7cqYUXj3vDGSja963KzT+cEN5aLpNXVW8nzVPEaODs3bbZF
 AF3UiGdYDaLrS5JA1U5ZXamiS7uZjn1i4ucPN6LDbi25ZHhhuE3MDVlocctGMfMU2kgO
 f0cJuRtvE0fZvCluCiTpddWf1+bGJk0TgZ/5Q+VN9rYawby/SToxI3gJH0sXMul1peo3
 AXTA==
X-Gm-Message-State: AOAM530H2aVwJFWrxPoPVMhKup0f8zVE8xKZMYntqskxHULpxhykgjng
 LYnjJYWmcGxtQvHCD5h1IiBIiA==
X-Google-Smtp-Source: ABdhPJz/yXt3lG6cl/JU2sPuwA/hh0+369fSVG2hTihoZHe4v1NH/nUJnKy3UpRTTPW1Lg7k6vL4/Q==
X-Received: by 2002:a05:6e02:17c6:b0:2cc:3cfa:7f77 with SMTP id
 z6-20020a056e0217c600b002cc3cfa7f77mr15030215ilu.144.1651177704952; 
 Thu, 28 Apr 2022 13:28:24 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 s4-20020a056602240400b00657c2032191sm533334ioa.19.2022.04.28.13.28.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Apr 2022 13:28:24 -0700 (PDT)
Date: Thu, 28 Apr 2022 20:28:20 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add SDEI virtualization
 infrastructure
Message-ID: <Ymr45B+8xTlhi7vk@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-4-gshan@redhat.com>
 <YmMiyt/TDjJt0mdG@google.com>
 <36899ea9-e8bd-27b2-8dfb-75b76eab50d7@redhat.com>
 <YmRI7Bh7fWCYLUGT@google.com>
 <0e26da1a-00bb-3d63-a8bf-6cd3271b0a38@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0e26da1a-00bb-3d63-a8bf-6cd3271b0a38@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Gavin,

On Sun, Apr 24, 2022 at 11:00:56AM +0800, Gavin Shan wrote:

[...]

> Yes, The assumption that all events are always singled by software should
> be true. So this field (@signaled) can be dropped either. So I plan to
> change the data structures like below, according to the suggestions given
> by you. Please double check if there are anything missed.
> 
> (1) Those fields of struct kvm_sdei_exposed_event are dropped or merged
>     to struct kvm_sdei_event.
> 
>     struct kvm_sdei_event {
>            unsigned int          num;
>            unsigned long         ep_addr;
>            unsigned long         ep_arg;
> #define KVM_SDEI_EVENT_STATE_REGISTERED         0
> #define KVM_SDEI_EVENT_STATE_ENABLED            1
> #define KVM_SDEI_EVENT_STATE_UNREGISTER_PENDING 2
>            unsigned long         state;                 /* accessed by {test,set,clear}_bit() */
>            unsigned long         event_count;
>     };
> 
> (2) In arch/arm64/kvm/sdei.c
> 
>     static kvm_sdei_event exposed_events[] = {
>            { .num = SDEI_SW_SIGNALED_EVENT },
>     };
> 
> (3) In arch/arm64/kvm/sdei.c::kvm_sdei_create_vcpu(), the SDEI events
>     are instantiated based on @exposed_events[]. It's just what we're
>     doing and nothing is changed.

The part I find troubling is the fact that we are treating SDEI events
as a list-like thing. If we want to behave more like hardware, why can't
we track the state of an event in bitmaps? There are three bits of
relevant state for any given event in the context of a vCPU: registered,
enabled, and pending.

I'm having some second thoughts about the suggestion to use MP state for
this, given that we need to represent a few bits of state for the vCPU
as well. Seems we need to track the mask state of a vCPU and a bit to
indicate whether an SDEI handler is active. You could put these bits in
kvm_vcpu_arch::flags, actually.

So maybe it could be organized like so:

  /* bits for the bitmaps below */
  enum kvm_sdei_event {
  	KVM_SDEI_EVENT_SW_SIGNALED = 0,
	KVM_SDEI_EVENT_ASYNC_PF,
	...
	NR_KVM_SDEI_EVENTS,
  };

  struct kvm_sdei_event_handler {
  	unsigned long ep_addr;
	unsigned long ep_arg;
  };

  struct kvm_sdei_event_context {
  	unsigned long pc;
	unsigned long pstate;
	unsigned long regs[18];
  };

  struct kvm_sdei_vcpu {
  	unsigned long registered;
	unsigned long enabled;
	unsigned long pending;

	struct kvm_sdei_event_handler handlers[NR_KVM_SDEI_EVENTS];
	struct kvm_sdei_event_context ctxt;
  };

But it is hard to really talk about these data structures w/o a feel for
the mechanics of working the series around it.

> > > > Do we need this if we disallow nesting events?
> > > > 
> > > 
> > > Yes, we need this. "event == NULL" is used as indication of invalid
> > > context. @event is the associated SDEI event when the context is
> > > valid.
> > 
> > What if we use some other plumbing to indicate the state of the vCPU? MP
> > state comes to mind, for example.
> > 
> 
> Even the indication is done by another state, kvm_sdei_vcpu_context still
> need to be linked (associated) with the event. After the vCPU context becomes
> valid after the event is delivered, we still need to know the associated
> event when some of hypercalls are triggered. SDEI_1_0_FN_SDEI_EVENT_COMPLETE
> is one of the examples, we need to decrease struct kvm_sdei_event::event_count
> for the hypercall.

Why do we need to keep track of how many times an event has been
signaled? Nothing in SDEI seems to suggest that the number of event
signals corresponds to the number of times the handler is invoked. In
fact, the documentation on SDEI_EVENT_SIGNAL corroborates this:

"""
The event has edgetriggered semantics and the number of event signals
may not correspond to the number of times the handler is invoked in the
target PE.
"""

DEN0054C 5.1.16.1

So perhaps we queue at most 1 pending event for the guest.

I'd also like to see if anyone else has thoughts on the topic, as I'd
hate for you to go back to the whiteboard again in the next spin.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
