Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13BEC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 718CC61368
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 718CC61368
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 120AE4B17B;
	Wed, 29 Sep 2021 03:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uavm8Q-21Zxs; Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBEB4B137;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 263684B0BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1zLnRSBoHvhq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 17:26:19 -0400 (EDT)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B9394B09C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 17:26:19 -0400 (EDT)
Received: by mail-pl1-f181.google.com with SMTP id w11so11037plz.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=L4Z1qtd59VARXTo8mTMZfhpyo/YJa2yppwRF4l1omg8=;
 b=rSq0scJL/ha88RRlXKX42Isqbw/cwS5kVIP0Rz8OfVzzn6D5kKDMweVE0Q4ktQSiMJ
 FhxFPNTbhY9xS2vAGEQ+qB5gV/IMUC6h9JD8Smhm2ssJbOQpHIqEJKUl6mN0qk2Gvwz4
 iqKk5TZe73g8eJV+2vJnrwoJvPJ1P6NI4t92YcMxTQruO4ZgcMdMIYBXrSN2yeCfPbAN
 tFQ4GxwssW84Y1vg4LGpetlrhcF6FFA2L4YDutUNKomAAwAsIirg3JkaUm6HVKTrF3V4
 BHRGBPVxBUQcMzwQWA2PNjc4/b6DItbdmvXb7Ajmp33ZzPOIr2q8iG4+IHZG+ueXE4Hc
 nmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=L4Z1qtd59VARXTo8mTMZfhpyo/YJa2yppwRF4l1omg8=;
 b=0uS22C8TdgfPqPYuvivNLTCRMkmtUzW5p6PK6WRcUKnbdIQ2PUOqepOMEd8NpX9qNl
 1WKFPHOQ2cjmEkbemy6X91WPz0LshtW9mTf7OdQZpSbwjI4cRcBeL+cTa4wwSchhk5Mn
 W8ydKaDVdXe43E4TG55VHDKaTgBCDYqhUPoY4+PqhqVYdu9+8wHVmDffsiR1m+QzipQQ
 DoxpMt1PSpw7EqNs/6jvne/tnUHLCq6dY1kCdQOax87Sa965oThckKUpsINyAaSXaoUp
 rylzeANHhz9jav/rotX2DWngj/fF09Z+cQnqAGm6N6/Yf3PLhvxI03VFBLgCRivvZkP8
 KvwQ==
X-Gm-Message-State: AOAM532b69mDm8V664hhC2xzRB8jSbcYY0JxW9dzoKozSy0Q7+hIyRDV
 B5yQM0R1P+ApUa3GIfs38xLatw==
X-Google-Smtp-Source: ABdhPJyiNQfJ0RYEvCNSbQfmhva0TWeah3nt33T8BlFeMgmCPfbY0etgFPJGRuPzGjsIEt8CokHbDg==
X-Received: by 2002:a17:902:a3c2:b0:13d:be85:43ca with SMTP id
 q2-20020a170902a3c200b0013dbe8543camr7239171plb.0.1632864378224; 
 Tue, 28 Sep 2021 14:26:18 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id j20sm109118pgb.2.2021.09.28.14.26.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 14:26:17 -0700 (PDT)
Date: Tue, 28 Sep 2021 21:26:13 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 04/14] KVM: Reconcile discrepancies in halt-polling stats
Message-ID: <YVOIdZhAe5Bqn4hc@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-5-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-5-seanjc@google.com>
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Sep 24, 2021 at 05:55:18PM -0700, Sean Christopherson wrote:
> Move the halt-polling "success" and histogram stats update into the
> dedicated helper to fix a discrepancy where the success/fail "time" stats
> consider polling successful so long as the wait is avoided, but the main
> "success" and histogram stats consider polling successful if and only if
> a wake event was detected by the halt-polling loop.
> 
> Move halt_attempted_poll to the helper as well so that all the stats are
> updated in a single location.  While it's a bit odd to update the stat
> well after the fact, practically speaking there's no meaningful advantage
> to updating before polling.
> 
> Note, there is a functional change in addition to the success vs. fail
> change.  The histogram updates previously called ktime_get() instead of
> using "cur".  But that change is desirable as it means all the stats are
> now updated with the same polling time, and avoids the extra ktime_get(),
> which isn't expensive but isn't free either.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 12fe91a0a4c8..2ba22b68af3b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3202,12 +3202,23 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  					  ktime_t end, bool success)
>  {
> +	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
>  	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
>  
> -	if (success)
> -		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
> -	else
> -		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
> +	++vcpu->stat.generic.halt_attempted_poll;
> +
> +	if (success) {
> +		++vcpu->stat.generic.halt_successful_poll;
> +
> +		if (!vcpu_valid_wakeup(vcpu))
> +			++vcpu->stat.generic.halt_poll_invalid;
> +
> +		stats->halt_poll_success_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
> +	} else {
> +		stats->halt_poll_fail_ns += poll_ns;
> +		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_fail_hist, poll_ns);
> +	}
>  }
>  
>  /*
> @@ -3227,30 +3238,16 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	if (do_halt_poll) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
> -		++vcpu->stat.generic.halt_attempted_poll;
>  		do {
>  			/*
>  			 * This sets KVM_REQ_UNHALT if an interrupt
>  			 * arrives.
>  			 */
> -			if (kvm_vcpu_check_block(vcpu) < 0) {
> -				++vcpu->stat.generic.halt_successful_poll;
> -				if (!vcpu_valid_wakeup(vcpu))
> -					++vcpu->stat.generic.halt_poll_invalid;
> -
> -				KVM_STATS_LOG_HIST_UPDATE(
> -				      vcpu->stat.generic.halt_poll_success_hist,
> -				      ktime_to_ns(ktime_get()) -
> -				      ktime_to_ns(start));
> +			if (kvm_vcpu_check_block(vcpu) < 0)
>  				goto out;
> -			}
>  			cpu_relax();
>  			poll_end = cur = ktime_get();
>  		} while (kvm_vcpu_can_poll(cur, stop));
> -
> -		KVM_STATS_LOG_HIST_UPDATE(
> -				vcpu->stat.generic.halt_poll_fail_hist,
> -				ktime_to_ns(ktime_get()) - ktime_to_ns(start));
>  	}
>  
>  
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
