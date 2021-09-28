Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14E7C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D0F5613C8
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5D0F5613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED61E4B135;
	Wed, 29 Sep 2021 03:12:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zLKtXc6jECX3; Wed, 29 Sep 2021 03:12:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457044B131;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F14449F5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E1Pq-piTtTdP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 15:01:43 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B16649DE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:01:43 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 k23-20020a17090a591700b001976d2db364so3590130pji.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 12:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xt0gEcyOTVXB3cbfAORCeU0aPfpfHLNMXNfI9X69CVQ=;
 b=P2WbyomAz9CC+YDhARNtEQPob4jnZ2g2oykK3Tx9s3ZzF3kIhs4M8u5I6nL6TYVoGq
 rrOLmGGUE/wsUTWlv/vaHIT0qruIxiC5Hconls6bpVJIAswiiw3izm0NUdKLNEX/vTj1
 hNuCFj8rB/KJEKNYPyTIjrwmUxsuMdqXz/A3MzGuI1a3Kwyq70MOLXcjCuAwjRmB7Dhb
 kf47CJCAyIoWzJus9Q6TAK/lSg8ZsxvgmyTdZgT9A2DiUE772alKYF35OPb474XMP0BJ
 1g92CPbM5JIG9MA0Bz7RxJUC/t1T7o89IaaifLPvH7z+3t2ti9exdaFi/jE6y9Sz0Jjp
 UImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xt0gEcyOTVXB3cbfAORCeU0aPfpfHLNMXNfI9X69CVQ=;
 b=szGcR1jXH42pQ3RtCVRMlcQR61dPtNF/dt/SgblpJGzeCbvODYiHW55gZnpHC8Uo1f
 4mAVejnyeuIv4oHN9h9CPcTgn3w5c0++I6EZMivhB6Vz0jJdqroLfhfniaIw9HqgwhrH
 Zf/KB8rsvS0DkRK/HvNsk2P0HD6OtIkmTc2kvHyXvX0BKqQ0tMq327svWPueEmoFZ8wO
 dcR15mwP5TrbQRhFWZPq2JszkvFjpucNm3jCCora09rKZrtdolmDqKVd9NZK2ns1BR7I
 sGw5bGQ1b3aUjbGYuNj+J4uUVCNmar5Dv/cHo7z/cEBIPTxrYDhLMzVrt/aUCHPy34LE
 fZhw==
X-Gm-Message-State: AOAM531miCuz1L+pDwhFOnz33OCjzHaaNkgqeqzueKjIpiES0Ff5aRyK
 35fE2S3ek89PnHDcW4WYh02LUQ==
X-Google-Smtp-Source: ABdhPJwN22eVEV+ILvTVZFxrClU0H39RaKFVj+LTEdtXecOP9yW45Z7Ldv9r7U41GdYk3WWGVE+ldw==
X-Received: by 2002:a17:902:b909:b0:13a:2d8e:12bc with SMTP id
 bf9-20020a170902b90900b0013a2d8e12bcmr6453208plb.6.1632855701799; 
 Tue, 28 Sep 2021 12:01:41 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id j24sm20993011pfh.65.2021.09.28.12.01.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 12:01:41 -0700 (PDT)
Date: Tue, 28 Sep 2021 19:01:38 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 03/14] KVM: Refactor and document halt-polling stats
 update helper
Message-ID: <YVNmkuaUYwYvlbaY@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-4-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-4-seanjc@google.com>
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

On Fri, Sep 24, 2021 at 05:55:17PM -0700, Sean Christopherson wrote:
> Add a comment to document that halt-polling is considered successful even
> if the polling loop itself didn't detect a wake event, i.e. if a wake
> event was detect in the final kvm_vcpu_check_block().  Invert the param
> to the update helper so that the helper is a dumb function that is "told"
> whether or not polling was successful, as opposed to having it determinine
> success/failure based on blocking behavior.
> 
> Opportunistically tweak the params to the update helper to reduce the
> line length for the call site so that it fits on a single line, and so
> that the prototype conforms to the more traditional kernel style.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8b33f5045b4d..12fe91a0a4c8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3199,13 +3199,15 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -static inline void
> -update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
> +static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
> +					  ktime_t end, bool success)
>  {
> -	if (waited)
> -		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
> -	else
> +	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
> +
> +	if (success)
>  		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
> +	else
> +		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
>  }
>  
>  /*
> @@ -3274,9 +3276,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> +	/*
> +	 * Note, halt-polling is considered successful so long as the vCPU was
> +	 * never actually scheduled out, i.e. even if the wake event arrived
> +	 * after of the halt-polling loop itself, but before the full wait.
> +	 */
>  	if (do_halt_poll)
> -		update_halt_poll_stats(
> -			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
> +		update_halt_poll_stats(vcpu, start, poll_end, !waited);
>  
>  	if (halt_poll_allowed) {
>  		if (!vcpu_valid_wakeup(vcpu)) {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
