Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5555C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 18:08:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6748D4B25D;
	Wed, 12 Jan 2022 13:08:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u7oUrgosYxRW; Wed, 12 Jan 2022 13:08:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 235414B18F;
	Wed, 12 Jan 2022 13:08:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83EF54B18F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:08:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tmB-BlGtrz1p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 13:08:44 -0500 (EST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com
 [209.85.219.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AF574B174
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:08:44 -0500 (EST)
Received: by mail-yb1-f178.google.com with SMTP id n68so7927556ybg.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=eLoe+yCOLX8twUoVnJSmKEThBpM9HQQFjJ/YCsOmEqo=;
 b=sM2pOGw+VpV9fEIP1NjSY4EwV7AcQhlq5kQpevs1vpJUY1/wqvZGO14UsjVSIGi4KO
 0xFyyWnKF8RnRiQ9QTjCBqspBtCwUaJMbb1JnyobjHfOw7HAOB45fyPrbx6ULMES3QfA
 1K+5NVv6/9/HPmtYoPxk7tPP+UAka3Gns3nyHc7K3xrpJHSngSgARkxqZMQ47npXn644
 DE9+7odqYt8BstnTgUifJbQ7/R9av7njwqtwSCbDdmjN753efTawRlUW5KocyfCemjeW
 pPHXtnlznKcgGaSD30YnQph+Ju3ocJHis1S1NlIQFcHPcVRynTbi1J386LRNrmp+S+zE
 ukWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=eLoe+yCOLX8twUoVnJSmKEThBpM9HQQFjJ/YCsOmEqo=;
 b=jKtxLLo+L31LeXEdQTAP5/gz6Q98RIHM8Nm8e01ukrFEHn/cssdyFdzpHrLPDvW070
 udHp1Nzph60RT3G1bphUKDLQR0xeNgL7//fsHk7pqOMO0A8Gyy+us0EmNs5iAkLd06rK
 j+55ivgcWOe0YuN4XShXR7jxBNHibEgUvYZ7lgeXtFVPLmvcZP7ENIxvFZo5sdiLVQqw
 1lLUa6fdewueyd3R0YOqYvk7cgHwFGoOjQyZQXxyGkVnwC9d1eASI5ajVHsIaDyaCFma
 k4rmuqYAvVxkUsRw7IV1EKdlf3ffyncYMDOfGsxMH5kDOUgsgow1Kz0DRzGj3GYPTnPU
 4KKA==
X-Gm-Message-State: AOAM531ITtlTphp03LRb9sLRlBiPGWFmzkX6I5KoRri7HLCyHbV0hzXX
 GvkJeBfHKAnGnNk87EI0KVoyWY1dJwtRbLTQ0dkfeQ==
X-Google-Smtp-Source: ABdhPJyOENQ36F72MCUSVYL6GkdmncC92a9wV1s6msf5ZpTvvHnphmMhSYKEkA/XtQw4bc2lP+lyOA6otSG7YAZ1iDM=
X-Received: by 2002:a25:d750:: with SMTP id o77mr1052699ybg.543.1642010923523; 
 Wed, 12 Jan 2022 10:08:43 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
 <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
 <Yd3UymPg++JW98/2@google.com>
In-Reply-To: <Yd3UymPg++JW98/2@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 12 Jan 2022 10:08:32 -0800
Message-ID: <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Jan 11, 2022 at 11:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 11, 2022, Raghavendra Rao Ananta wrote:
> > On Tue, Jan 11, 2022 at 9:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
> > > unnecessary contention as it will serialize this bit of code if multiple vCPUs
> > > are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
> > > VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
> > > There's still a possibility that multiple vCPUs will contend for kvm->lock on their
> > > first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
> > > a more elegant solution depending on the use case, e.g. a lockless approach might
> > > work (or it might not).
> > >
> > But is it safe to read kvm->vm_started without grabbing the lock in
> > the first place?
>
> Don't know, but that's my point.  Without a consumer in generic KVM and due to
> my lack of arm64 knowledge, without a high-level description of how the flag will
> be used by arm64, it's really difficult to determine what's safe and what's not.
> For other architectures, it's an impossible question to answer because we don't
> know how the flag might be used.
>
> > use atomic_t maybe for this?
>
> No.  An atomic_t is generally useful only if there are multiple writers that can
> possibly write different values.  It's highly unlikely that simply switching to an
> atomic address the needs of arm64.
>
> > > > > > +                     kvm->vm_started = true;
> > > > > > +                     mutex_unlock(&kvm->lock);
> > > > >
> > > > > Lastly, why is this in generic KVM?
> > > > >
> > > > The v1 of the series originally had it in the arm specific code.
> > > > However, I was suggested to move it to the generic code since the book
> > > > keeping is not arch specific and could be helpful to others too [1].
> > >
> > > I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
> > > but I'm skeptical in this particular case.  The code _is_ arch specific in that
> > > arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
> > > versus a hypothetical x86 use case that might be completely ok with a lockless
> > > implementation.  And it's not obvious that there's a plausible, safe use case
> > > outside of arm64, e.g. on x86, there is very, very little that is truly shared
> > > across the entire VM/system, most things are per-thread/core/package in some way,
> > > shape, or form.  In other words, I'm a wary of providing something like this for
> > > x86 because odds are good that any use will be functionally incorrect.
> > I've been going back and forth on this. I've seen a couple of
> > variables declared in the generic struct and used only in the arch
> > code. vcpu->valid_wakeup for instance, which is used only by s390
> > arch. Maybe I'm looking at it the wrong way as to what can and can't
> > go in the generic kvm code.
>
> Ya, valid_wakeup is an oddball, I don't know why it's in kvm_vcpu instead of
> arch code that's wrapped with e.g. kvm_arch_vcpu_valid_wakeup().
>
> That said, valid_wakeup is consumed by generic KVM, i.e. has well defined semantics
> for how it is used, so it's purely a "this code is rather odd" issue.  vm_started
> on the other hand is only produced by generic KVM, and so its required semantics are
> unclear.

Understood. I'll move it to arm64 and we can refactor it if there's a
need for any other arch(s).

Thanks,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
