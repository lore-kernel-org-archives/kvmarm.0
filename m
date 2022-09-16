Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417F6ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri, 16 Sep 2022 18:10:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCF64BBD8;
	Fri, 16 Sep 2022 14:10:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id apbJUz7fTptp; Fri, 16 Sep 2022 14:09:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72FD94BCB2;
	Fri, 16 Sep 2022 14:09:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 285884BCB2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 14:09:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wMTLyvSPpUbD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 14:09:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F31F84BCAB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 14:09:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663351797;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=dGo9IIHnzVXPXPzRwNLgG2J2p1J5QcMOec8HOITKZNg=;
 b=WJwTwtrTw9Rh96kTdmSRUY7AZclZN2Dg56fVltfr5XtzmXcRcjvOgkcMQijXla8Lm3gKFJ
 mpfDn5gISn/1B4XcsUCHzrgaO0/EviZ3PQr/v7PnlEb9gw3avhUFevcoFoAmMSGCcnannN
 6DcK0M82RlOr+ZjJelw9FPbypuEBvkw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-8-RBgJHkPWOM6PWpK06oSQ-1; Fri, 16 Sep 2022 14:09:55 -0400
X-MC-Unique: 8-RBgJHkPWOM6PWpK06oSQ-1
Received: by mail-qv1-f72.google.com with SMTP id
 n15-20020ad444af000000b004a2a341ad71so15413869qvt.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 11:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=dGo9IIHnzVXPXPzRwNLgG2J2p1J5QcMOec8HOITKZNg=;
 b=DyjMOnMNGidvuQ2z5jzHRL03EoeDllQILZrILpZb5NDt3EtOaNjkQCV7FwFJ03UzEh
 CMEEYBOvp3uF5CNpFl5mRK/kVPxgZV7hCZoe6cIGD0UsOrnc/9vNRts9suFkwtwoSPN8
 yP6xPWexa/CV2Tzc+wpgJ+oKKpTRFcGCx9HNzdf7pORXAtPl/QExOifOHCRq2mNvN0m8
 uYZgXm2tXo7BVN//LC6O5TLQkyxlUKLmAzv/UtYvXaALF4j/QgE/6Hk7yHmpI6wXVg0Q
 hJmKtMnfeE4U+XV9nv7MK2EpxUSl4jpXq//WHEtG7SSCHy0QRIIyTDwzbkAlDlUwCRQ3
 /0ow==
X-Gm-Message-State: ACrzQf2fBmXvFGoiKyb4Xvt9cRiYABHSEqn4MmI81VrjgjnRW96nvO6o
 0YVDpHyCTP/jXKU3puZQz8WNAmeDnUC0+BLUg0KjnsT4y1XlRPFuy1nhu3Yyshh2NLAxj763nKV
 gKmPTZN0ZMzgctNvOLIloowxQ
X-Received: by 2002:ac8:5f4d:0:b0:35b:ba2e:ce1 with SMTP id
 y13-20020ac85f4d000000b0035bba2e0ce1mr5516867qta.26.1663351795091; 
 Fri, 16 Sep 2022 11:09:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Eq8nutd1y8SgkrtcXFUsUl9UMHM0MnxQbGXx8ngkMtdvW9XgFJl7Id6By2Z5c1AZ7GoPT7w==
X-Received: by 2002:ac8:5f4d:0:b0:35b:ba2e:ce1 with SMTP id
 y13-20020ac85f4d000000b0035bba2e0ce1mr5516842qta.26.1663351794880; 
 Fri, 16 Sep 2022 11:09:54 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 l19-20020a05620a28d300b006b60d5a7205sm7398453qkp.51.2022.09.16.11.09.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 16 Sep 2022 11:09:54 -0700 (PDT)
Date: Fri, 16 Sep 2022 14:09:52 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <YyS78BqsQxKkLOiW@xz-m1.local>
References: <20220916045135.154505-1-gshan@redhat.com>
 <20220916045135.154505-2-gshan@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220916045135.154505-2-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, drjones@redhat.com, shan.gavin@gmail.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 corbet@lwn.net, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 will@kernel.org, linux-kselftest@vger.kernel.org, bgardon@google.com,
 dmatlack@google.com, pbonzini@redhat.com, shuah@kernel.org,
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

On Fri, Sep 16, 2022 at 12:51:31PM +0800, Gavin Shan wrote:
> This adds KVM_REQ_RING_SOFT_FULL, which is raised when the dirty
> ring of the specific VCPU becomes softly full in kvm_dirty_ring_push().
> The VCPU is enforced to exit when the request is raised and its
> dirty ring is softly full on its entrance.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/x86/kvm/x86.c       | 5 +++--
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/dirty_ring.c    | 4 ++++
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..7f368f59f033 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10265,8 +10265,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	bool req_immediate_exit = false;
>  
>  	/* Forbid vmenter if vcpu dirty ring is soft-full */
> -	if (unlikely(vcpu->kvm->dirty_ring_size &&
> -		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
> +	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> +	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
> +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
>  		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
>  		trace_kvm_dirty_ring_exit(vcpu);
>  		r = 0;

As commented previously - can we use kvm_test_request() instead? because we
don't want to unconditionally clear the bit.  Instead of making the request
again, we can clear request only if !full.

We can also safely move this into the block of below kvm_request_pending()
as Marc used to suggest.

To explicitly use kvm_clear_request(), we may need to be careful on the
memory barriers.  I'm wondering whether we should have moved
smp_mb__after_atomic() into kvm_clear_request() because kvm_clear_request()
is used outside kvm_check_request() and IIUC all the call sites should
better have that barrier too to be safe.

Side note: when I read the code around I also see some mis-use of clear
request where it can be omitted, e.g.:

		if (kvm_check_request(KVM_REQ_UNHALT, vcpu)) {
			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
		}

Maybe it's a sign of bad naming, so we should renamed kvm_check_request()
to kvm_test_clear_request() too to show that clearing after that is not
needed?

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
