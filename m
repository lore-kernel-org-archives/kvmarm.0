Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D25C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 21:18:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A72860F45
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 21:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A72860F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D66407ED;
	Tue,  3 Aug 2021 17:18:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id usMq9WuaVko9; Tue,  3 Aug 2021 17:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B724066E;
	Tue,  3 Aug 2021 17:18:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4864066E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 17:18:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aKaze-voKKPE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 17:18:29 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B423040630
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 17:18:29 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id c16so891159lfc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 14:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ta6l2xXWDT9u5jccv96eXJ1qjXmVTPggm0wilGcpdVs=;
 b=BdE9W00YEuXqcEPUPfUmVzyU+jcHWH+410m74a1ncOOtdr5zirV7UEplYvEhtLPMre
 WaJruCdCQxginzPDCczLWu89yDppye3VsjFTRRvJx0YL9OFa5tRmy2fIQWJ12YlcZfY1
 kTufqa+cc2M7lKqhQemENjDHf1CRXAyT9ZktXCzVoIaVNxD0D6KRIOYOCg1zIh1b4Jwp
 2R3NiFWyLNR200i/dmGmjfDVaVGGG2CBL5Dh7GGv1K/XTgQCvRBZ/38jnpkv0bTShWe6
 UR72L1IOHGOyCrNc7ttsTvZYbgs4gvGld1YdPhKmDauqAZ/glfLv0vhV5gYwXRnmBPjC
 8s3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ta6l2xXWDT9u5jccv96eXJ1qjXmVTPggm0wilGcpdVs=;
 b=mFAVbKQnF7G5KN5ixW6Tk4AStG7WMc+buh17a5QSMK/kgWzJ3t9cCWWyQ2x3Tw2zMp
 2RoXyJ2t8JgQOQRl8bkzxEVEKXfETmK+V8ZLbngf2ekEz1hNaJtWdsSxBijP4YRhmrHy
 SeEKEjMBgMKjSqzKlby57rPJCm3tcCy0OVFXZIcuf5fsaO6Ik95yD5J5VfC2qteskiHX
 jdHEOM06WsorTyGIjtHv8NC4S/wt7fXf3e5nmtIE/BBna+EZhBI4gSjO/sqbTiXK6I18
 BT/VuOxLfpVKwYGpZq62gB/bj8pOMIcbviTF3DKU5LDfjh1W/I22mZZufXWAYvkrU6cH
 mtQg==
X-Gm-Message-State: AOAM5318ASnyDakKaqMOEOlDhTSjJ+GDri20ApE3wZSUtlU60HLZ6fmn
 PdcotVtfUCfV3zcNWY5UGg3p7eLBBGYMxEESypJCcA==
X-Google-Smtp-Source: ABdhPJxHnayzG6ipEbIowb4o96jcK4d1APZCmmGvNA676lxtxxTmkXjlKp38rlwEV12gMG1y7qkziiPC0bhMql6xLi8=
X-Received: by 2002:ac2:57cd:: with SMTP id k13mr147309lfo.117.1628025508018; 
 Tue, 03 Aug 2021 14:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-3-oupton@google.com>
 <YQRAGSJ1PxwXA2m/@google.com>
In-Reply-To: <YQRAGSJ1PxwXA2m/@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 3 Aug 2021 14:18:17 -0700
Message-ID: <CAOQ_Qsiko1U4ZQPuSkxQtzxZ_PVvW7JCMoBvY06uMoNrVSjj+g@mail.gmail.com>
Subject: Re: [PATCH v5 02/13] KVM: x86: Refactor tsc synchronization code
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Fri, Jul 30, 2021 at 11:08 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 29, 2021, Oliver Upton wrote:
> > Refactor kvm_synchronize_tsc to make a new function that allows callers
> > to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> > for the sake of participating in TSC synchronization.
> >
> > This changes the locking semantics around TSC writes.
>
> "refactor" and "changes the locking semantics" are somewhat contradictory.  The
> correct way to do this is to first change the locking semantics, then extract the
> helper you want.  That makes review and archaeology easier, and isolates the
> locking change in case it isn't so safe after all.

Indeed, it was mere laziness doing so :)

> > Writes to the TSC will now take the pvclock gtod lock while holding the tsc
> > write lock, whereas before these locks were disjoint.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> > +/*
> > + * Infers attempts to synchronize the guest's tsc from host writes. Sets the
> > + * offset for the vcpu and tracks the TSC matching generation that the vcpu
> > + * participates in.
> > + *
> > + * Must hold kvm->arch.tsc_write_lock to call this function.
>
> Drop this blurb, lockdep assertions exist for a reason :-)
>

Ack.

> > + */
> > +static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
> > +                               u64 ns, bool matched)
> > +{
> > +     struct kvm *kvm = vcpu->kvm;
> > +     bool already_matched;
>
> Eww, not your code, but "matched" and "already_matched" are not helpful names,
> e.g. they don't provide a clue as to _what_ matched, and thus don't explain why
> there are two separate variables.  And I would expect an "already" variant to
> come in from the caller, not the other way 'round.
>
>   matched         => freq_matched
>   already_matched => gen_matched

Yeah, everything this series touches is a bit messy. I greedily
avoided the pile of cleanups that are needed, but alas...

> > +     spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>
> I believe this can be spin_lock(), since AFAICT the caller _must_ disable IRQs
> when taking tsc_write_lock, i.e. we know IRQs are disabled at this point.

Definitely.


>
> > +     if (!matched) {
> > +             /*
> > +              * We split periods of matched TSC writes into generations.
> > +              * For each generation, we track the original measured
> > +              * nanosecond time, offset, and write, so if TSCs are in
> > +              * sync, we can match exact offset, and if not, we can match
> > +              * exact software computation in compute_guest_tsc()
> > +              *
> > +              * These values are tracked in kvm->arch.cur_xxx variables.
> > +              */
> > +             kvm->arch.nr_vcpus_matched_tsc = 0;
> > +             kvm->arch.cur_tsc_generation++;
> > +             kvm->arch.cur_tsc_nsec = ns;
> > +             kvm->arch.cur_tsc_write = tsc;
> > +             kvm->arch.cur_tsc_offset = offset;
>
> IMO, adjusting kvm->arch.cur_tsc_* belongs outside of pvclock_gtod_sync_lock.
> Based on the existing code, it is protected by tsc_write_lock.  I don't care
> about the extra work while holding pvclock_gtod_sync_lock, but it's very confusing
> to see code that reads variables outside of a lock, then take a lock and write
> those same variables without first rechecking.
>
> > +             matched = false;
>
> What's the point of clearing "matched"?  It's already false...

None, besides just yanking the old chunk of code :)

>
> > +     } else if (!already_matched) {
> > +             kvm->arch.nr_vcpus_matched_tsc++;
> > +     }
> > +
> > +     kvm_track_tsc_matching(vcpu);
> > +     spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> > +}
> > +

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
