Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04458C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:23:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69F5A61166
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 17:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69F5A61166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7EB94A3A5;
	Tue, 21 Sep 2021 13:23:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MC16vQmTwYOY; Tue, 21 Sep 2021 13:23:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5C14A193;
	Tue, 21 Sep 2021 13:23:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EEE249FB7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:23:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PTT9ZyW8ZL-h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 13:23:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E0540667
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 13:23:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632244987;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Crx2yXztHF3g4rFcd1goQcNIJRLU07HcReSxyZxd2Qo=;
 b=AIoIxisxrqRT3Y87eSpYFGTUBLNfPGL/SSX0/TFwaD/Dx5tcqL9FcsfJ5qq0SJ5A7z8fXx
 NUnnYlDd8nhYUZkaT4GS+fPG0jO0Tpt8/JRJercb6N18LmZX9urX02N605EVCIXt1rSmPE
 wxdWRYLNNWTjIAo2+lPlN1Hz9HiB7bY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-2UiXpl9sPjyM7fP5ni0V6w-1; Tue, 21 Sep 2021 13:23:06 -0400
X-MC-Unique: 2UiXpl9sPjyM7fP5ni0V6w-1
Received: by mail-ed1-f69.google.com with SMTP id
 e7-20020a50d4c7000000b003d871ecccd8so5797998edj.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 10:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Crx2yXztHF3g4rFcd1goQcNIJRLU07HcReSxyZxd2Qo=;
 b=1HbwnfygdOplhAg26I7hS6Dvnh5yY6C3844MHX0WkZC84t+doYg2uicftbKn98wfOC
 cPLhU8ADf2+oKIxA2qDn9EWmOUtc2D2N2LuIWuUspqty6ISnFWajjMlxweetLkmN1+EX
 0YQfiqSeFcAEjfSLmIFQP/VXLfoc2Bv2lI6p/+diPljH8VVYmZWkJmUltJ7owOgGR3fS
 PQ5hAq0QnVHyiYnPLP07TK7wd0c+lDMFV5C1bvDGILEi47xZHcnXX3QqFbBkvzvMIMfe
 /MALvXExKKm1LBU5SvhoAq7dvThdbHNrSOmUxsXG36gXXfp6NlCsVeoEoq9Yh2GtAFmI
 XfGA==
X-Gm-Message-State: AOAM530jPJD0ERTA2Y4q4PyITY7N/9BysEPf93QEuFGJysBFqPthro+u
 7MTXRIfEm5MjPuLuI/WWrNH809wp7bdfcy+cfnlU7mDR3WrUBbwq6iWMYbsB21j2q30SHH5S2NJ
 bXs9pSitAxD76qBpjqsciv9wy
X-Received: by 2002:a17:906:3e08:: with SMTP id
 k8mr36810590eji.361.1632244984985; 
 Tue, 21 Sep 2021 10:23:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzxrG1oc6ZNBnXvUP4hiTHEcdtV+vXwmMe3LlCQlBiZU6QBmCkJE3OvUTs/WUzYdBFWgbkmw==
X-Received: by 2002:a17:906:3e08:: with SMTP id
 k8mr36810570eji.361.1632244984751; 
 Tue, 21 Sep 2021 10:23:04 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id j2sm8939392edt.0.2021.09.21.10.23.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 10:23:03 -0700 (PDT)
Date: Tue, 21 Sep 2021 19:23:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 2/2] selftests: KVM: Align SMCCC call with the spec in
 steal_time
Message-ID: <20210921172301.3tkne2ucpev62r6h@gator.home>
References: <20210921171121.2148982-1-oupton@google.com>
 <20210921171121.2148982-3-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210921171121.2148982-3-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Tue, Sep 21, 2021 at 05:11:21PM +0000, Oliver Upton wrote:
> The SMC64 calling convention passes a function identifier in w0 and its
> parameters in x1-x17. Given this, there are two deviations in the
> SMC64 call performed by the steal_time test: the function identifier is
> assigned to a 64 bit register and the parameter is only 32 bits wide.
> 
> Align the call with the SMCCC by using a 32 bit register to handle the
> function identifier and increasing the parameter width to 64 bits.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..aafaa8e38b7c 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -118,12 +118,12 @@ struct st_time {
>  	uint64_t st_time;
>  };
>  
> -static int64_t smccc(uint32_t func, uint32_t arg)
> +static int64_t smccc(uint32_t func, uint64_t arg)
>  {
>  	unsigned long ret;
>  
>  	asm volatile(
> -		"mov	x0, %1\n"
> +		"mov	w0, %w1\n"
>  		"mov	x1, %2\n"
>  		"hvc	#0\n"
>  		"mov	%0, x0\n"
> -- 
> 2.33.0.464.g1972c5931b-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
