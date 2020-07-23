Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A72C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 10:04:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8BB220737
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 10:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4Tjc4MS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8BB220737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 397FE4B32B;
	Thu, 23 Jul 2020 06:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bXXVxa2KHG2T; Thu, 23 Jul 2020 06:04:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F75F4B2F9;
	Thu, 23 Jul 2020 06:04:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD1AA4B306
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 22:51:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s8dl3bDZNKyd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 22:51:46 -0400 (EDT)
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com
 [209.85.160.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB8F54B2FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 22:51:45 -0400 (EDT)
Received: by mail-qt1-f194.google.com with SMTP id j10so3405367qtq.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 19:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=3FGTIJsMWiuqsdJoUqDQziqKZol4pbNpNal4MX+V3kg=;
 b=D4Tjc4MSqAmk0rC//KBKh1MiOvF64ETmR5erHLkBNz/8G+d73CGhYZI1//N88xp3ZB
 PvKfFZuUeECW1tLVijoi3JQv9Up/t+hwwQgH3c8cswSdN6b+/Up9tW7+AtjRsHCmSMCX
 r4n01aNGXw77bOe/qpolDszh83WgniXUkiV5FRZrDN+31aJwo7pQVXKpIKpw5aIEsGtc
 Aec8VcRO62DibdZaLmJbPEQHsaxCYOcSRLIzgJUrA1mrdcESDQmhishwfqeMnn4kmy0s
 /liNR1YE0Fl6tdMi+cbCOMBaisHdmnJ3esEqnEFXLgeP+Ir4bBfTpC1fKWXfgCvzYJdD
 Sxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3FGTIJsMWiuqsdJoUqDQziqKZol4pbNpNal4MX+V3kg=;
 b=EGWv00NxiNzV/N3FxpJAfRPu4rIyFfsd+aFjxFD9RotpwvXIsvPYXGD11YlcJ0TTPa
 hbFCU+CueE3NfDEkgt2saVfAzaH1Jy7gitwEwUHTuY4SbxUeGrgd4NlgVphggeAfZbdM
 BrfmWUpXQervMswPmhs4rBag8X+V3j5U6BhGt5BaV5VkUbMciajlMmiU8Jru2pOQlHeZ
 fGaPHOdSOKfic7aV5sqPVx4Rpkt9hVqv303cksIKIFEX6PtUNpDQRW0iYjbKBxOvbeAy
 We2u5+Wp/rDsxh4cTw3FutVeReWA2E0TP8ylqAaFlbeySCwOiQCIY5Jd/LSyYvDOmX0H
 h+Hg==
X-Gm-Message-State: AOAM530a/jGJ5bn44Ki75TqjjuiztPEX4VEL5/hayGOKyoX+yerH/j5x
 WF3eNMwedWzxn9UUW3gLWe0=
X-Google-Smtp-Source: ABdhPJzB3i+6fJCaN7bK3FLHzxEfYv91xyQg7+WuzYFSVlcaYRmb6plJdBFlgj+XI2n9fahxWfbf8A==
X-Received: by 2002:ac8:464f:: with SMTP id f15mr2224175qto.211.1595472705344; 
 Wed, 22 Jul 2020 19:51:45 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
 by smtp.gmail.com with ESMTPSA id x13sm1288730qts.57.2020.07.22.19.51.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Jul 2020 19:51:44 -0700 (PDT)
Date: Wed, 22 Jul 2020 19:51:42 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
Message-ID: <20200723025142.GA361584@ubuntu-n2-xlarge-x86>
References: <20200722162231.3689767-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200722162231.3689767-1-maz@kernel.org>
X-Mailman-Approved-At: Thu, 23 Jul 2020 06:04:22 -0400
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Jul 22, 2020 at 05:22:31PM +0100, Marc Zyngier wrote:
> So far, vcpu_has_ptrauth() is implemented in terms of system_supports_*_auth()
> calls, which are declared "inline". In some specific conditions (clang
> and SCS), the "inline" very much turns into an "out of line", which
> leads to a fireworks when this predicate is evaluated on a non-VHE
> system (right at the beginning of __hyp_handle_ptrauth).
> 
> Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
> using the cpus_have_final_cap() helpers, which are __always_inline,
> generate much better code, and are the only thing that make sense when
> running at EL2 on a nVHE system.
> 
> Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thank you for the quick fix! I have booted a mainline kernel with this
patch with Shadow Call Stack enabled and verified that using KVM no
longer causes a panic.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>

For the future, is there an easy way to tell which type of system I am
using (nVHE or VHE)? I am new to the arm64 KVM world but it is something
that I am going to continue to test with various clang technologies now
that I have actual hardware capable of it that can run a mainline
kernel.

Cheers,
Nathan

> ---
>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 147064314abf..a8278f6873e6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -391,9 +391,14 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  
> -#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
> -				  system_supports_generic_auth()) && \
> -				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
> +#ifdef CONFIG_ARM64_PTR_AUTH
> +#define vcpu_has_ptrauth(vcpu)						\
> +	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
> +	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
> +	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +#else
> +#define vcpu_has_ptrauth(vcpu)		false
> +#endif
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>  
> -- 
> 2.28.0.rc0.142.g3c755180ce-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
