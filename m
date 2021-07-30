Return-Path: <SRS0=pkzt=MX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E36C4338F
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F350F61040
	for <kvmarm@archiver.kernel.org>; Sat, 31 Jul 2021 09:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F350F61040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A62704A4FC;
	Sat, 31 Jul 2021 05:33:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wwkHlFwsLpxD; Sat, 31 Jul 2021 05:33:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38FF14B0B3;
	Sat, 31 Jul 2021 05:33:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD944B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 14:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k3-EwQADc72G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 14:08:31 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E70B14B0E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 14:08:30 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 e2-20020a17090a4a02b029016f3020d867so15512502pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=U22IQhYTRPCkpysTSxxrY3OXIOUsjrcBM5qAQtaDVGA=;
 b=BJssnUAjT5z70MZ1iYT6dX4sF9p17EqqxIOWql+F9Uk8seuT1Mmsl7bvn2fUo1Pxfs
 C0mI9NqkKrBsVLH21YczNMMZWnEb00G/LeWP+XWxMl9sekNLaTj2vC3Vnm74nx/G0dMn
 eNiQ1lqpoxIHiIUv6WBxrWXpe/VXZLNqKGHiwmR5kARWiynI3rNGZ1js4fLeXV5ynjeg
 6EPIuYKuAoyH8YJ7gJSSc90S35Rxgbrix/L5TDPDQWBMyyFfmmrNWLdpJnEQDHoj1xaA
 PzOZepFRIe5aFLECjxaqVYxxkEyfC6P5u5zunGvK2WGla6dONwBDm1nEg60N/MesbBpP
 35pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U22IQhYTRPCkpysTSxxrY3OXIOUsjrcBM5qAQtaDVGA=;
 b=BRLEXmYLDmqX2fc3u3juzMO/lLEp3HXPmfgB/1yaK7W1ZEN5hRkSpoC6VL52VvbYfh
 KYe3L/hdQpmQvvlRVfVLVqswb42PRfyARjH0/3+vxW2eB7u/fsoNq1jQs3dfH+vLCOGX
 HIs0AGs574TegHPuG4FdqKHsyuQ1YltPSuYNKqUa8ZVnQ1Jvuir2w/pLddPIyUFsc2WE
 5TiFP92MtLSibkgKSYUGbdt/6fjVRiObKjic9x2HhVfMLN+jPddY2uMLb70i81aPKl2x
 qX66aR0DLSfKiLja1YkcqeUYTb5gO7dHFw9ROrmvtGiOAF9zz57HyX9h/NrOU4cU/DM3
 f5Xg==
X-Gm-Message-State: AOAM533sCtUJODXzaVFyjrGSHaTmc9+9V8FNC/Rh7IA2QMrUNmxRS+ek
 spQpS3oa7q2L7TmGNFlbZCOD/g==
X-Google-Smtp-Source: ABdhPJzMaCyOmywV/AHhhMPn1KKKBoyFNH+eqA4FYc+b1MRy4AW0ZMGXtjZhMOgw+LQ8/a9GL5IIXQ==
X-Received: by 2002:a17:90b:250f:: with SMTP id
 ns15mr4291311pjb.26.1627668509611; 
 Fri, 30 Jul 2021 11:08:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id h7sm1368044pjs.38.2021.07.30.11.08.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Jul 2021 11:08:29 -0700 (PDT)
Date: Fri, 30 Jul 2021 18:08:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 02/13] KVM: x86: Refactor tsc synchronization code
Message-ID: <YQRAGSJ1PxwXA2m/@google.com>
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-3-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210729173300.181775-3-oupton@google.com>
X-Mailman-Approved-At: Sat, 31 Jul 2021 05:33:51 -0400
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

On Thu, Jul 29, 2021, Oliver Upton wrote:
> Refactor kvm_synchronize_tsc to make a new function that allows callers
> to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> for the sake of participating in TSC synchronization.
> 
> This changes the locking semantics around TSC writes.

"refactor" and "changes the locking semantics" are somewhat contradictory.  The
correct way to do this is to first change the locking semantics, then extract the
helper you want.  That makes review and archaeology easier, and isolates the
locking change in case it isn't so safe after all.

> Writes to the TSC will now take the pvclock gtod lock while holding the tsc
> write lock, whereas before these locks were disjoint.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> +/*
> + * Infers attempts to synchronize the guest's tsc from host writes. Sets the
> + * offset for the vcpu and tracks the TSC matching generation that the vcpu
> + * participates in.
> + *
> + * Must hold kvm->arch.tsc_write_lock to call this function.

Drop this blurb, lockdep assertions exist for a reason :-)

> + */
> +static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
> +				  u64 ns, bool matched)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	bool already_matched;

Eww, not your code, but "matched" and "already_matched" are not helpful names,
e.g. they don't provide a clue as to _what_ matched, and thus don't explain why
there are two separate variables.  And I would expect an "already" variant to
come in from the caller, not the other way 'round.

  matched         => freq_matched
  already_matched => gen_matched

> +	unsigned long flags;
> +
> +	lockdep_assert_held(&kvm->arch.tsc_write_lock);
> +
> +	already_matched =
> +	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> +
> +	/*
> +	 * We track the most recent recorded KHZ, write and time to
> +	 * allow the matching interval to be extended at each write.
> +	 */
> +	kvm->arch.last_tsc_nsec = ns;
> +	kvm->arch.last_tsc_write = tsc;
> +	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
> +
> +	vcpu->arch.last_guest_tsc = tsc;
> +
> +	/* Keep track of which generation this VCPU has synchronized to */
> +	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
> +	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
> +	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
> +
> +	kvm_vcpu_write_tsc_offset(vcpu, offset);
> +
> +	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);

I believe this can be spin_lock(), since AFAICT the caller _must_ disable IRQs
when taking tsc_write_lock, i.e. we know IRQs are disabled at this point.

> +	if (!matched) {
> +		/*
> +		 * We split periods of matched TSC writes into generations.
> +		 * For each generation, we track the original measured
> +		 * nanosecond time, offset, and write, so if TSCs are in
> +		 * sync, we can match exact offset, and if not, we can match
> +		 * exact software computation in compute_guest_tsc()
> +		 *
> +		 * These values are tracked in kvm->arch.cur_xxx variables.
> +		 */
> +		kvm->arch.nr_vcpus_matched_tsc = 0;
> +		kvm->arch.cur_tsc_generation++;
> +		kvm->arch.cur_tsc_nsec = ns;
> +		kvm->arch.cur_tsc_write = tsc;
> +		kvm->arch.cur_tsc_offset = offset;

IMO, adjusting kvm->arch.cur_tsc_* belongs outside of pvclock_gtod_sync_lock.
Based on the existing code, it is protected by tsc_write_lock.  I don't care
about the extra work while holding pvclock_gtod_sync_lock, but it's very confusing
to see code that reads variables outside of a lock, then take a lock and write
those same variables without first rechecking.

> +		matched = false;

What's the point of clearing "matched"?  It's already false...

> +	} else if (!already_matched) {
> +		kvm->arch.nr_vcpus_matched_tsc++;
> +	}
> +
> +	kvm_track_tsc_matching(vcpu);
> +	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> +}
> +
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
