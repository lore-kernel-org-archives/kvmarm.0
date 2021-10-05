Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D91C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A17D61373
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2A17D61373
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B3C4B24E;
	Tue,  5 Oct 2021 09:35:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZWzQQ0FOlGgQ; Tue,  5 Oct 2021 09:35:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9B304B2F3;
	Tue,  5 Oct 2021 09:35:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC404B2C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:34:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ulGEcSsWdimk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:34:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF944B24E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:34:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633440898;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=f66jq9s7AStKUyKZZVEZqhv66J5ngEqYwoHoMEH8w+A=;
 b=RnBytloDoT+kncxdWdaxQGTaQHVmQ/ckG+z1LQ/UO1AUt6mWfBag79FQWjIQjgph2u6Gsc
 YDbPvrXfaJ3sGhpln7NBnJ8ZV749NzqeEsbz4m6tqxps7MsN/L6gNhp08L8XC7dsCeBfEK
 u/fQcDSUBxgEOvfgBV+rNoaC1b9cBPU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-Ch-bUmQOPgu7EDWK7Ryxxw-1; Tue, 05 Oct 2021 09:34:57 -0400
X-MC-Unique: Ch-bUmQOPgu7EDWK7Ryxxw-1
Received: by mail-ed1-f70.google.com with SMTP id
 z6-20020a50cd06000000b003d2c2e38f1fso20650191edi.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=f66jq9s7AStKUyKZZVEZqhv66J5ngEqYwoHoMEH8w+A=;
 b=fNODCgy+gfE2YJuIoe+/t8dcyRQLa+iUJjFMuvkYW8711m92O5iGo6XpLTtM4yRGp9
 r0656jmmnMLHzD4SnyP9PavHdhNavmsz6zH4cR0QH3nxjjvHn9Nqpo8xjjW1WYQXRFpf
 NqfubL+QPQtr/cFy6n0ZwhbNAsDeF96RtAfYvHTJ9pszPkGRGkEIPl3SAPrqypFb1oY1
 Vi+2GfAqG0JD1a6/isg5OqHdehJwEo5mNJfzGEwsk/fpeG5saciq7KTr0NpySCneCQv4
 G6eJTYDzYHOyQ2qAIIgQB0sW6AP2Vj0mXhd4Ms+Wofgr1sE70l2yRwMxTnxcDnBPXjhI
 yuhA==
X-Gm-Message-State: AOAM533cGrdmQsHOppAkfSdPPzJrMgGxkQXwzjwPW1OTvj2a2JDTCudu
 FmDEqDjdGK/pWs85//x/NorKKQhjsgstVn2kRoNFHX24j37k0T46DAxOe7gaN4bjmTP+9sFfAuT
 vqenMV4FXoQEJO4TC3VwlN9+4
X-Received: by 2002:a05:6402:141:: with SMTP id
 s1mr26328124edu.317.1633440896158; 
 Tue, 05 Oct 2021 06:34:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydXTEJ/zRmP0xlonD8tRFF80Bntkf7CsDT18a72UqthZAFNFgH3eVa2yk0Rf30igZ2SO+7YQ==
X-Received: by 2002:a05:6402:141:: with SMTP id
 s1mr26328105edu.317.1633440895979; 
 Tue, 05 Oct 2021 06:34:55 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id b5sm8729431edu.13.2021.10.05.06.34.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:34:55 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:34:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 04/11] KVM: arm64: Rename the KVM_REQ_SLEEP handler
Message-ID: <20211005133453.f7h2yrnicaducrbn@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-5-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-5-oupton@google.com>
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

On Thu, Sep 23, 2021 at 07:16:03PM +0000, Oliver Upton wrote:
> The naming of the kvm_req_sleep function is confusing: the function
> itself sleeps the vCPU, it does not request such an event. Rename the
> function to make its purpose more clear.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..3d4acd354f94 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -649,7 +649,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>  	}
>  }
>  
> -static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> +static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
>  {
>  	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>  
> @@ -679,7 +679,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> -			vcpu_req_sleep(vcpu);
> +			kvm_vcpu_sleep(vcpu);
>  
>  		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
>  			kvm_reset_vcpu(vcpu);
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
