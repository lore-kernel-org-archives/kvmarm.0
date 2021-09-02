Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DDEC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10A6460FD7
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 10A6460FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679A94B128;
	Thu,  2 Sep 2021 17:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zjmy95kea4K4; Thu,  2 Sep 2021 17:01:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A3F4B11A;
	Thu,  2 Sep 2021 17:01:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D71934B10A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:21:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RhUVyMCfe1Km for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 15:21:46 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C45D54A524
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:21:46 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id e7so3059963pgk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 12:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bTPb2LtwY0BuCTlFiP191M1j/fLfSg4VVRY2NYVbQM8=;
 b=S/7EM5Sy//hkeACCvKyqm5sVVqBrQaqsdvxj8V+pqH+VLsMswwElPvPODqMd7fVjBQ
 5i230e6v/OtvAgnS/CLoAsXnvILeltliV0s92h56yoUA0fUf11fzBxIPynn5EMbuXXRb
 gl5wjP5M2Lau95yABeHZjPjOapP29zLMK0IS+/+ygST5fVXgaJPDUEEdyNeVz93uhZ/d
 85dVXSxIWc3ixj4OrK1qCnh5UqmWozTZAXAk8AOj9Av8RLaDEsT6WgMig+7/yc9yTAd0
 QUPr4LbBjx9ibxnCt7BKdmJvrZfo0aFFeURS5oDPX3mGs2EAYO6KWacDYmpbuNM4tQl0
 b25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bTPb2LtwY0BuCTlFiP191M1j/fLfSg4VVRY2NYVbQM8=;
 b=VBM2eeSA0Ixx1B7csZ+clTRHooOnCh8Zp9AvV1Fi+iK0zaP8Jksy7M+mZSN4V4sA9E
 50gIcXeyVqT+Sb9M5tdOUohl9mNm1tzzDrRhRwDhXxGCenWszkQZutHNHTAxcOnYq10S
 JmXllvzYiEwXwtlRQY4Vz3PlJggJf4y6QxTrUMvzQ8I/g0SEF2pUYiHhhevCw/F6p6yK
 ZQqVqG4MifC0pEr0awOPi0FggWWbmJ7Lj4k8mvMUiS3Y5X6RUIoi7m5MbMCQ4MoFHFCL
 tVc4k+jApKMold5aMTs3fAC+NkQQudr5rxXbWxrvzIVeV/h0fVG1SOtIM47Hbqgsk0Np
 w6Rg==
X-Gm-Message-State: AOAM532kB0NjM+0atllSkRy6qJAHT306ZXzGWfSWs0l0t9t3YaafLMxC
 I/VIJNKlrSFINaI/kmuOAvYFEg==
X-Google-Smtp-Source: ABdhPJyHmQYfdDfH5nHCWTHDLHiMkKrNuJmjtl34uxM72CrPEH11VQku3MHYEgMhSvkmPIwPWS9zAg==
X-Received: by 2002:aa7:85d8:0:b0:408:78f4:a5fe with SMTP id
 z24-20020aa785d8000000b0040878f4a5femr4725944pfn.2.1630610505325; 
 Thu, 02 Sep 2021 12:21:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id 6sm3086990pjz.8.2021.09.02.12.21.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 12:21:44 -0700 (PDT)
Date: Thu, 2 Sep 2021 19:21:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v7 5/6] KVM: x86: Refactor tsc synchronization code
Message-ID: <YTEkRfTFyoh+HQyT@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-6-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-6-oupton@google.com>
X-Mailman-Approved-At: Thu, 02 Sep 2021 17:01:18 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Aug 16, 2021, Oliver Upton wrote:
> Refactor kvm_synchronize_tsc to make a new function that allows callers
> to specify TSC parameters (offset, value, nanoseconds, etc.) explicitly
> for the sake of participating in TSC synchronization.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> +	struct kvm *kvm = vcpu->kvm;
> +	bool already_matched;
> +
> +	lockdep_assert_held(&kvm->arch.tsc_write_lock);
> +
> +	already_matched =
> +	       (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
> +

...

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
> +		kvm->arch.cur_tsc_generation++;
> +		kvm->arch.cur_tsc_nsec = ns;
> +		kvm->arch.cur_tsc_write = tsc;
> +		kvm->arch.cur_tsc_offset = offset;
> +
> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> +		kvm->arch.nr_vcpus_matched_tsc = 0;
> +	} else if (!already_matched) {
> +		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> +		kvm->arch.nr_vcpus_matched_tsc++;
> +	}
> +
> +	kvm_track_tsc_matching(vcpu);
> +	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);

This unlock is imbalanced if matched and already_matched are both true.  It's not
immediately obvious that that _can't_ happen, and if it truly can't happen then
conditionally locking is pointless (because it's not actually conditional).

The previous code took the lock unconditionally, I don't see a strong argument
to change that, e.g. holding it for a few extra cycles while kvm->arch.cur_tsc_*
are updated is unlikely to be noticable.

If you really want to delay taking the locking, you could do

	if (!matched) {
		kvm->arch.cur_tsc_generation++;
		kvm->arch.cur_tsc_nsec = ns;
		kvm->arch.cur_tsc_write = data;
		kvm->arch.cur_tsc_offset = offset;
	}

	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
	if (!matched)
		kvm->arch.nr_vcpus_matched_tsc = 0;
	else if (!already_matched)
		kvm->arch.nr_vcpus_matched_tsc++;
	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);

or if you want to get greedy

	if (!matched || !already_matched) {
		spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
		if (!matched)
			kvm->arch.nr_vcpus_matched_tsc = 0;
		else
			kvm->arch.nr_vcpus_matched_tsc++;
		spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
	}

Though I'm not sure the minor complexity is worth avoiding spinlock contention.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
