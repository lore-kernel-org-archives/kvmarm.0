Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DCAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:33:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 024BB613D1
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 024BB613D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDDE49DE3;
	Thu, 30 Sep 2021 13:33:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jGDWcx83hCzn; Thu, 30 Sep 2021 13:33:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C08B49FB7;
	Thu, 30 Sep 2021 13:33:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 361B3407ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:33:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ev9tYxrF2gtu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:33:02 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB59340762
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:33:01 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id b20so28775893lfv.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iKfk6HbG6TObfzRUE4EIW/odvNzsG1SnwK5+/9/zkj0=;
 b=FZRkwMcuX90szqNm8YFb+9IVR7uiAeZo8r7TCRXR3IDZfCNFSlSfMMhs/4798maVNE
 eNU1fPnAEMfL3RKUFRSjECHb286st1nKKy6Q2PA3fRGGfggOVmy7coNju0QA7C157LJa
 XvFraoQx4x64Rww3mHpMWwfFF1ixtkG3dVgr/l2iAv/YJAIqMZCFin3oW6uQeOH2KOqF
 NQoxJq8LAvdo0J7SOXyJ6xMUyrE8fRAxgmKVixVYkUCdr9bcniWqFe/GP+fNCU4uU8cG
 u8GocJ0vHGdAEfCQhL4DrmOH6gHADQYm+8pAFClVByMFLRyOEs716JBCAZ0c+R2rLiJy
 Hf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iKfk6HbG6TObfzRUE4EIW/odvNzsG1SnwK5+/9/zkj0=;
 b=jpbxnJbcqHf/sSwdqUIfaIJWcedqhH59tfeHl8PlhZ/nP5DUekX36hQIJD5V6QAcQf
 rdsoAzX/U5Kv30joirZ3oPSY0lqczIp6RpRAbh//osz9WkCev0Qia4B0EWa/owHbwAEv
 U9FnRiiuJVoJjgx01wE/yJWtmInHCgHwW6uIRsgrDDkYVClRW8CmVuWUZIaIW7+MgRdn
 Io6qLmid0Ck7qK8EeyzYSHqiToAAow9MwxQcXIcHOKypcB0C0x5n9UsrnNUw0K7enWS2
 Aw5DiX7WVeT1T120RJ+jpPAKnc/qrmaZjeyqqYv+bNSelBrQjGKQV4jTSCmTI/wCYc0F
 1lSQ==
X-Gm-Message-State: AOAM532zBgcZI8lrgQRrrMCJyTIMHU0J+mV4oWaggGbkWsJSYFD8j4A6
 49e4XAwvJKj9kjLd6mbdgpm7PBaQzgtIan9bVHPCgw==
X-Google-Smtp-Source: ABdhPJzq/VatrgxhazbFBsyW1Zf46+5YaQA0HtXNK2rb6j4UxNfmN8UeiVWKq+G80yaEkN4sKybzTxB+SboJZ9UvAR4=
X-Received: by 2002:a2e:719:: with SMTP id 25mr7561449ljh.251.1633023180023;
 Thu, 30 Sep 2021 10:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org> <YVXvM2kw8PDou4qO@google.com>
In-Reply-To: <YVXvM2kw8PDou4qO@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 30 Sep 2021 10:32:49 -0700
Message-ID: <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Marc Zyngier wrote:
> > On Thu, 23 Sep 2021 20:16:04 +0100, Oliver Upton <oupton@google.com> wrote:
> > > @@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> > >             if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> > >                     kvm_vcpu_sleep(vcpu);
> > >
> > > +           if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > > +                   kvm_vcpu_suspend(vcpu);
> > > +
>
> ...
>
> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 275a27368a04..5e5ef9ff4fba 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
> > >     } else {
> > >             trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> > >             vcpu->stat.wfi_exit_stat++;
> > > -           kvm_vcpu_block(vcpu);
> > > -           kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > > +           kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > >     }
> > >
> > >     kvm_incr_pc(vcpu);
> >
> > This is a change in behaviour. At the point where the blocking
> > happens, PC will have already been incremented. I'd rather you don't
> > do that. Instead, make the helper available and call into it directly,
> > preserving the current semantics.
>
> Is there architectural behavior that KVM can emulate?  E.g. if you were to probe a
> physical CPU while it's waiting, would you observe the pre-WFI PC, or the post-WFI
> PC?  Following arch behavior would be ideal because it eliminates subjectivity.
> Regardless of the architectural behavior, changing KVM's behavior should be
> done explicitly in a separate patch.
>
> Irrespective of PC behavior, I would caution against using a request for handling
> WFI.  Deferring the WFI opens up the possibility for all sorts of ordering
> oddities, e.g. if KVM exits to userspace between here and check_vcpu_requests(),
> then KVM can end up with a "spurious" pending KVM_REQ_SUSPEND if maniupaltes vCPU
> state.  I highly doubt that userspace VMMs would actually do that, as it would
> basically require a signal from userspace, but it's not impossible, and at the
> very least the pending request is yet another thing to worry about in the future.
>
> Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.

Yeah, I don't think the punt is necessary for anything but the case
where userspace sets the MP state to request WFI behavior. A helper
method amongst all WFI cases is sufficient, and using the deferral for
everything is a change in behavior.

> > It is also likely to clash with Sean's kvm_vcpu_block() rework, but we
> > can work around that.
>
> Ya.  Oliver, can you Cc me on future patches?  I'll try to keep my eyeballs on this
> series.

Sure thing :)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
