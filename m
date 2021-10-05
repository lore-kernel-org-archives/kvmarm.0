Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7BCC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:23:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AD6061502
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0AD6061502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FAA44B2F7;
	Tue,  5 Oct 2021 09:23:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WaC-E-bWfE-h; Tue,  5 Oct 2021 09:23:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8166F4B2F8;
	Tue,  5 Oct 2021 09:23:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D784B2F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:23:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lSmspwnCCy2O for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:23:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB25E4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:23:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633440223;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=cT7Qtyinns0zBAn2ayLQCXEWWojO35G+FtQtOxKscjM=;
 b=i41eC4Yvn1cnkEOvkoXpmS1zpTnJ0eDUURl6M9A1g8b7BPdkqu1kgHGq/q9eKOUafK/kPZ
 iR4JAJhXJowcQkEpjCeuQjCuVVfZUvHALhvTtYLN+QPJlAbkOYscf9Y1c4SsUNCkFc0kbg
 mOtGA7uBQUfr80oPx3msIgfQSefa36c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-tTpovRR4NRuUaTxEgPSTvA-1; Tue, 05 Oct 2021 09:23:40 -0400
X-MC-Unique: tTpovRR4NRuUaTxEgPSTvA-1
Received: by mail-ed1-f69.google.com with SMTP id
 w6-20020a50d786000000b003dabc563406so16221171edi.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cT7Qtyinns0zBAn2ayLQCXEWWojO35G+FtQtOxKscjM=;
 b=RN2yWlkeTGmgNygPaB7YWa4duBqE9WSSeQYRoM+pevgVAGKF13htVLLSf17fvI/r7J
 q+Ok/RNy08JvN6ZPw1VNlLmdcRxZf7QmuNdEsOIYCkpqVm37ovo5LH8ryX9orNNxfkg0
 9oUUFGGx/t2oj1gz912WsDGjz8VE3i9BE1laSIwKvhczb/nApj7WJkGf9qQBCR0XM8UX
 SZ+Dv2tU/fnUuoGn0aMV82kJXakDZo3vYDBjnP9+mfkeLnUKfvonijRXCg1IwTyMn2p8
 FOoNGVZ3oiJg8bjok1MtbqhgI1l/79F+99seQ/nT3TMusCvEiMI1q9lsTek30DpvwD3g
 BzyQ==
X-Gm-Message-State: AOAM531Hv87tl4cY335qUJVQ5ZDHerwB0feTppIjKXgIwCLa9OaBFEbX
 1SwYWmi215lXcgD4cbzkf1pwOmlo6qou0Zm4f3l8hWTXO0BItGLGygdBm3r4hPFzIZGqQGPFLGp
 pIOCdJoTaNVacd51ck1tzleBe
X-Received: by 2002:a17:906:a082:: with SMTP id
 q2mr24638232ejy.535.1633440219753; 
 Tue, 05 Oct 2021 06:23:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwakvv7GWEI+W/r0KCyXEC2f4X0QMYDDyKl3xx8Uk4KQI3UQr5BIHMj+4kf9CTH/OjfA2NmQw==
X-Received: by 2002:a17:906:a082:: with SMTP id
 q2mr24638216ejy.535.1633440219608; 
 Tue, 05 Oct 2021 06:23:39 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id w2sm8769794edj.44.2021.10.05.06.23.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:23:38 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:23:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
Message-ID: <20211005132336.njnelrjkmtipzr5l@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-3-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-3-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 07:16:01PM +0000, Oliver Upton wrote:
> The only valid calling SMC calling convention from an AArch32 state is
> SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
> when called from AArch32 rather than comparing against known SMC64 PSCI
> functions.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index d46842f45b0a..310b9cb2b32b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
>  
>  static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
>  {
> -	switch(fn) {
> -	case PSCI_0_2_FN64_CPU_SUSPEND:
> -	case PSCI_0_2_FN64_CPU_ON:
> -	case PSCI_0_2_FN64_AFFINITY_INFO:
> -		/* Disallow these functions for 32bit guests */
> -		if (vcpu_mode_is_32bit(vcpu))
> -			return PSCI_RET_NOT_SUPPORTED;
> -		break;
> -	}
> +	/*
> +	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
> +	 */
> +	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
> +		return PSCI_RET_NOT_SUPPORTED;
>  
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
