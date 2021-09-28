Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADECBC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EA706137A
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5EA706137A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9B84B0DE;
	Wed, 29 Sep 2021 03:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6cI65+poLOxv; Wed, 29 Sep 2021 03:12:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C22674B154;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7FBA40191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:03:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aJY+Hn9gKiV9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 18:03:18 -0400 (EDT)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94F7F40162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:03:18 -0400 (EDT)
Received: by mail-pg1-f170.google.com with SMTP id y186so580473pgd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=HhWJHJzwSlwok1AmtMjKCRhZCZC7gZ0nzg2WuvY1qEE=;
 b=tigZj4v4CeD0329C4UL89vBMNZKnQ83w87+ZjG/BkopVGCTWeqLcdLtmMMMyBh4mY7
 7Dg9uin+BfDKQe3/AO/kBYz/oYXaVu1zZluev925ki7GPxG9RsFR+LVM6CwXOErqWOQ1
 pcncNiTkf8gIAQ18xmLQoQFFSVJjeL/kv9WgotyouEYXoN9oN4CFt1v1v3hF+tD2MuSP
 4hRr4rqTnaTfyQu2hB8T0n1Sl6+dT/y/KrjaEze5I0PN5XK1QLwnll8S68T9w3WOhivA
 8src448DI7RUYdTJ7WPFB9p1z6qh3ARAEdVyO8+kHbRNjGL0an+DZUP9EMoHBQVa5OH2
 UFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HhWJHJzwSlwok1AmtMjKCRhZCZC7gZ0nzg2WuvY1qEE=;
 b=hCGkdNbSlOY3yZoVujsTBz2vRGePePRDcT9qDVtzQ8SlVnh7Xk0oIenPVZL213vUZy
 owHtSvkvUTZUgss0BpTufCIIM5Ybt6f0drKZ/5doBd4hxZJNmWHTnYr0RSZfXt2dS2qp
 h0YoYqPFkKMhup2SmsmXhCXzjW6W1fw4Ti0ZbFilPYzZ9iXXDsK8fAna40RnfNuhk4Pj
 xNKgNMrpnNKLXikjQ5pDh9s2bRmkiJFmdWPZJUjVEweqy+NQVrWShVAC65Gv8ud4RnAB
 J9RvlPikbtKSIrkyDCkdVBfIowJGs9MkoO1tWXqJeL/Wz6h/CTzczRtIpiKJ4VAhHeUn
 eOeg==
X-Gm-Message-State: AOAM532vqggUSngh4TY8tnXTSBJB3xLDymhaD5elsFWB+JtGqDP9WQVV
 TW+GSM3Sc3Rq9yf6KQToxgdL4Q==
X-Google-Smtp-Source: ABdhPJz8FBfuYulYfix3SaPNrNClCNKJqQQmFIru90iSEGa1D9tLSPPzdOByJRFDeYbge7PjxYA/EA==
X-Received: by 2002:aa7:980a:0:b0:43e:670:8505 with SMTP id
 e10-20020aa7980a000000b0043e06708505mr7905502pfl.74.1632866597392; 
 Tue, 28 Sep 2021 15:03:17 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id t33sm129606pfg.71.2021.09.28.15.03.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 15:03:16 -0700 (PDT)
Date: Tue, 28 Sep 2021 22:03:13 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 10/14] KVM: Split out a kvm_vcpu_block() helper from
 kvm_vcpu_halt()
Message-ID: <YVORIQVU3Vz/gWUI@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-11-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-11-seanjc@google.com>
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

On Fri, Sep 24, 2021 at 05:55:24PM -0700, Sean Christopherson wrote:
> Factor out the "block" part of kvm_vcpu_halt() so that x86 can emulate
> non-halt wait/sleep/block conditions that should not be subjected to
> halt-polling.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++------------
>  2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2a8be3fb9ba..655c2b24db2d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,6 +966,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>  void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>  
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 280cf1dca7db..fe34457530c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3199,6 +3199,34 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +/*
> + * Block the vCPU until the vCPU is runnable, an event arrives, or a signal is
> + * pending.  This is mostly used when halting a vCPU, but may also be used
> + * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
> + */
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +{
> +	bool waited = false;
> +
> +	kvm_arch_vcpu_blocking(vcpu);
> +
> +	prepare_to_rcuwait(&vcpu->wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		if (kvm_vcpu_check_block(vcpu) < 0)
> +			break;
> +
> +		waited = true;
> +		schedule();
> +	}
> +	finish_rcuwait(&vcpu->wait);
> +
> +	kvm_arch_vcpu_unblocking(vcpu);
> +
> +	return waited;
> +}
> +
>  static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  					  ktime_t end, bool success)
>  {
> @@ -3221,6 +3249,12 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  	}
>  }
>  
> +/*
> + * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
> + * polling is enabled, busy wait for a short time before blocking to avoid the
> + * expensive block+unblock sequence if a wake event arrives soon after the vCPU
> + * is halted.
> + */
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  {
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> @@ -3245,21 +3279,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  		} while (kvm_vcpu_can_poll(cur, stop));
>  	}
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
> -	prepare_to_rcuwait(&vcpu->wait);
> -	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -	finish_rcuwait(&vcpu->wait);
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
> +	waited = kvm_vcpu_block(vcpu);
>  
>  	cur = ktime_get();
>  	if (waited) {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
