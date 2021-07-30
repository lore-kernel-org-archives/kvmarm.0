Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8635C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 17:52:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 371C860F48
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 17:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 371C860F48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 927F84B0DF;
	Fri, 30 Jul 2021 13:52:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5fUgQIdXTze; Fri, 30 Jul 2021 13:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A514B0C7;
	Fri, 30 Jul 2021 13:52:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C5C4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 13:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rc2Q0LUdnh00 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 13:52:30 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5123A4A51D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 13:52:30 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id h14so19432862lfv.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=w74FCyABGqlKztmmT/szhNY9h5zAocpT2ax3CC8sfng=;
 b=DMrMZW03lBg/IWAb0IutYWMvCcEgS9xE5oJAt+jb+XBSyYmWnF1bbfCrZjz7dswIwD
 3v09mJ2EWLLHzJdjDf1awDYZg7EXnIFc+cImRm3dt9ORzBzqc6NkD+G5XTaI0Zcen3XU
 4cCh5vSyAZ7M/7ch8OPmEQSoGVBqGVkmlSuoAz2i+3aMHhE16KOplP7P7310dJvFMc7r
 473AiUM6s5r/ikkrJBXsLg/dLLccX9P/NPC+CEdOheJvLrqF2WWEkzYeBpo55NGME49y
 5MFHPpccGBKyttRw8SZHiN1GNbFcg1Rwcwr0J/jQi6dJrksfxK2UQM3qkKKIKTimvKSi
 4mKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=w74FCyABGqlKztmmT/szhNY9h5zAocpT2ax3CC8sfng=;
 b=HJxwQFW/qLn3G76u7298zVJuoyLX5Z8YHbVffwkFm5jHSJj8YRie5RqcuQ0BYzXyQC
 j0zTAA6k8xYkCxayFbMXDuUDM7vPT50xhxTctv9dPsgoNBnSEyOPy2yOql21Fmq3iXjh
 FGxuNwW4kzYChqXKMuevu0rbG0xk2RgReD9Vb8kDYi/Xb6+JK79Ai5GBP9dXPNwx1Efc
 fmDNp4ZMKxEH49uLFZMeynGtYp+3p95O4qA6DRuxhJipwJzHfRvle9xyR+2DqL1z15vd
 w/ARZOk+8BJtYVIQQr/jygY7YYaISRpRbsAYdMsuzyUN7kQvamic1FFRAmo1BnvfZ7pl
 hlrA==
X-Gm-Message-State: AOAM533bqVFQBPseuUTVs6pN2t7yVPSggkULxe5T54mdnEdC/rVHQIXi
 JYDB6LwZwvstZsHTe4BwEceoTBS6of46dhoIueDDXw==
X-Google-Smtp-Source: ABdhPJz0PS/v5uJNj45dAFVPDlHbQva1oT/iA2HWlKW9EoPtntJYtcQmwoF/lTYfoxBt8w02Z4/+/RsU10oVF052rmE=
X-Received: by 2002:a05:6512:3d26:: with SMTP id
 d38mr2541587lfv.411.1627667548598; 
 Fri, 30 Jul 2021 10:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
 <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org>
 <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
 <YQQvT7vAnRrcAcx/@google.com>
In-Reply-To: <YQQvT7vAnRrcAcx/@google.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 30 Jul 2021 10:52:17 -0700
Message-ID: <CAOQ_Qsjzp785QCnu9rzkuEMH9Q7tee-edJpKNgD_14t3NpaS5w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work
 function
To: Sean Christopherson <seanjc@google.com>
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

On Fri, Jul 30, 2021 at 9:56 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jul 30, 2021, Oliver Upton wrote:
> >
> > On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 29 Jul 2021 23:09:16 +0100, Oliver Upton <oupton@google.com> wrote:
> > > > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> > > >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> > > >  }
> > > >
> > > > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     return kvm_request_pending(vcpu) ||
> > > > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > > > +                     xfer_to_guest_mode_work_pending();
> > >
> > > Here's what xfer_to_guest_mode_work_pending() says:
> > >
> > > <quote>
> > >  * Has to be invoked with interrupts disabled before the transition to
> > >  * guest mode.
> > > </quote>
> > >
> > > At the point where you call this, we already are in guest mode, at
> > > least in the KVM sense.
> >
> > I believe the comment is suggestive of guest mode in the hardware
> > sense, not KVM's vcpu->mode designation. I got this from
> > arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
> > intentions.
>
> Yeah, the comment is referring to hardware guest mode.  The intent is to verify
> there is no work to be done before making the expensive world switch.  There's
> no meaningful interaction with vcpu->mode, on x86 it's simply more convenient
> from a code perspective to throw it into kvm_vcpu_exit_request().

Yep, the same is true for ARM as well, doing it the way it appears in
this patch allows for the recycling of the block to enable irqs and
preemption.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
