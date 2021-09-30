Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FDAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:09:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDB13619E5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BDB13619E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19BF94A3A5;
	Thu, 30 Sep 2021 13:09:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wWwIyIRZCxeF; Thu, 30 Sep 2021 13:09:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03504A3BF;
	Thu, 30 Sep 2021 13:09:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6A74083E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:09:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s6Gf2kZd7v1u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:09:12 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0260407ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:09:12 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 qe4-20020a17090b4f8400b0019f663cfcd1so833996pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EKGhHlRmNBHgim3DLaH7xTsK+Y5v1XvB6gEB+uTNeB8=;
 b=Ynt0Fe92ATIga4frdOXMZjXNKXXZSaPeQQAjGzSzWV9Kpo9gc3Y6JCFCI+fYAGT+tr
 fVH9GP0DIonT6Ibd2dLJGEuGW3i9A6JcGOkfOusbI8k3Lm7zXKlh3OS1buWjntZrLfoj
 SmnU0Tq76FxLTTs5j+a5d7Ry+frmSQ1kImg15JQdqFDq/FEmSLARE3Xn5u6cB6fB/KIa
 xX4qRqrGWqjzHucKkTdtA9EpWBZ7C1QlHMwDtRUQ+U17MuM+nsSfsf8/QoAPfCrvqeuy
 QR3jMq7wsCUw5hzP2MKrA/cW6l5x6rgX4mzp2ct3nOs8WAHUWc97lTK22Pm+OqAFcSog
 UTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EKGhHlRmNBHgim3DLaH7xTsK+Y5v1XvB6gEB+uTNeB8=;
 b=h5IimysquHTkEqRPHsayulfUvSSac/CkRiwPg6nG0vA0V4IIq5banmPWbccg7DY4dC
 +NG66sdEIO/JtgudgMNLCZGFx04TaCxUgiVyFzUhy0D+PcdS1eR11xTmtMUzgJz5dmTX
 MDWoNAtkJ6xlTexI9Z5/PXNVyLzeRRIFI6tXw+v+Se3TouH4pEm0bDp8CzHl5mL6w0nU
 waZzbRM+hkwhDBP/KKvdE+Bx1gOPv4AK87SznMwuGcmKhdhBUlC5ARYqKNS4ZF7A5ch6
 1zc9vPBXkcnw6z95WDfw2HbbShjefLbWuDprl8IMeeeCQLiBFoyFYLpeagU2z4A9pb35
 9Tig==
X-Gm-Message-State: AOAM531vXiBnr2TMPoBQrhjo8WxDo0LP62EgwgzWgXf5gSUYCs5OsWQh
 4UsHdLFfwhvAhxF/yTgETeY+4A==
X-Google-Smtp-Source: ABdhPJy9a/9KPfExzlaHiK/uSGhoB3fOWzfp7hJLJmdGT0YDd2SJ7vM/v/Qxj0xUnoUgKECV9LqvSQ==
X-Received: by 2002:a17:90a:11:: with SMTP id 17mr7624246pja.238.1633021751439; 
 Thu, 30 Sep 2021 10:09:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id k127sm3746313pfd.1.2021.09.30.10.09.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 10:09:10 -0700 (PDT)
Date: Thu, 30 Sep 2021 17:09:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
Message-ID: <YVXvM2kw8PDou4qO@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878rzetk0o.wl-maz@kernel.org>
Cc: Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 20:16:04 +0100, Oliver Upton <oupton@google.com> wrote:
> > @@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> >  			kvm_vcpu_sleep(vcpu);
> >  
> > +		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > +			kvm_vcpu_suspend(vcpu);
> > +

...

> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 275a27368a04..5e5ef9ff4fba 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
> >  	} else {
> >  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> >  		vcpu->stat.wfi_exit_stat++;
> > -		kvm_vcpu_block(vcpu);
> > -		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +		kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> >  	}
> >  
> >  	kvm_incr_pc(vcpu);
> 
> This is a change in behaviour. At the point where the blocking
> happens, PC will have already been incremented. I'd rather you don't
> do that. Instead, make the helper available and call into it directly,
> preserving the current semantics.

Is there architectural behavior that KVM can emulate?  E.g. if you were to probe a
physical CPU while it's waiting, would you observe the pre-WFI PC, or the post-WFI
PC?  Following arch behavior would be ideal because it eliminates subjectivity.
Regardless of the architectural behavior, changing KVM's behavior should be
done explicitly in a separate patch.

Irrespective of PC behavior, I would caution against using a request for handling
WFI.  Deferring the WFI opens up the possibility for all sorts of ordering
oddities, e.g. if KVM exits to userspace between here and check_vcpu_requests(),
then KVM can end up with a "spurious" pending KVM_REQ_SUSPEND if maniupaltes vCPU
state.  I highly doubt that userspace VMMs would actually do that, as it would
basically require a signal from userspace, but it's not impossible, and at the
very least the pending request is yet another thing to worry about in the future.

Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
doesn't enter rcuwait if power_off (or pause) was cleared after the request was
made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.

> It is also likely to clash with Sean's kvm_vcpu_block() rework, but we
> can work around that.

Ya.  Oliver, can you Cc me on future patches?  I'll try to keep my eyeballs on this
series.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
