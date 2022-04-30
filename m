Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB6CC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 14:54:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F1940E62;
	Sat, 30 Apr 2022 10:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id teY4nZMqeGgM; Sat, 30 Apr 2022 10:54:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EDDA49ED2;
	Sat, 30 Apr 2022 10:54:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5545B40E62
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 10:54:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TMZuMu6CHpY for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Apr 2022 10:54:46 -0400 (EDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1224040D05
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 10:54:46 -0400 (EDT)
Received: by mail-il1-f169.google.com with SMTP id y11so5632593ilp.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 07:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NnGCAeCGdC2rOPLY2oMqMtD1zv1olyIAR5RFlZYS+gA=;
 b=a/7ueX23zIupx6WHoMqsapfnlyIq6LOELnCnD7v1Sa5KY95hYZMyfm4kahYII9lfMr
 OzuaTO5pOFUxYfWJytz3ZEBgygOm3+nIKWiEU38lJlVC/9jlZpxFCsbkDxHErAnKsowW
 pFvE4MFmkuiUfs34FkO5FLsWQQq2EfwKagrOEsZW/m3lEnSWlw0+mpb49DKrnAmMcZMK
 Ppk04Z95OUdqvN6s7NtQ3BBeuMAoC2La8ei0fczLIKjXwDp0bPdfRhin+exVl+ZftEG5
 7Om6qYJufbu7hba+ffEJPiOM8LteFXGTIsUr3XJSi3PGu6zIJSuo+9kCKEJ96Q7bpxeW
 +jlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NnGCAeCGdC2rOPLY2oMqMtD1zv1olyIAR5RFlZYS+gA=;
 b=SSqmLpej5NPxje5oGUQQ8HcWL+G1BQf3kqeRmCu0LTdqzis7aWqCixwaJWFKD0wewO
 NY2EJk17sSE6Ot4bXMivv39sZc/HsL4YQ95lbrQ6Eh8NBK3xjyOPTVhea7V/rqrNhLzR
 /SHgqAE5peYHxN/JWs3ONC2+BvKjxqFkM1FvQaSCqMpG4KWSCGVBR/ZNVS1rHm9yoi3o
 JrXzyql1vuzdjDCHsRwQmIeKmC4d79F/g2fI2NHhDnhhMqaceSen1vbqTj0/bSeVhVPc
 gK0NOV2JMt8b7oPan1L9I7DRdzX3ip5SDo3JCLqUYWWfCO4ExkGCBGRk2jVjrYlIddyu
 plDQ==
X-Gm-Message-State: AOAM531+nMr/ZkpDsNAeei5P+Y4Xqsvu0FmKpgQYLvNlAB1Wbg/IATqO
 o2qZvsTgwYVEgTXICAWQwu46JQ==
X-Google-Smtp-Source: ABdhPJwyEZqyYROVRVGoDYDjRfNcz69FnbV5ZW8qR0u1NGaJiGU05f6rGpiezo8BzP0zPRfv7lW4wA==
X-Received: by 2002:a92:ca0b:0:b0:2cc:45da:de13 with SMTP id
 j11-20020a92ca0b000000b002cc45dade13mr1731044ils.146.1651330485174; 
 Sat, 30 Apr 2022 07:54:45 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 z5-20020a05663803a500b0032b5b40c82dsm382616jap.65.2022.04.30.07.54.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 07:54:44 -0700 (PDT)
Date: Sat, 30 Apr 2022 14:54:41 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 04/18] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
Message-ID: <Ym1Nsaq/ERUx/ebD@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-5-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-5-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Gavin,

On Sun, Apr 03, 2022 at 11:38:57PM +0800, Gavin Shan wrote:
> This supports SDEI_EVENT_REGISTER hypercall, which is used by guest
> to register event. The event won't be raised until it's registered
> and enabled. For those KVM owned events, they can't be registered
> if they aren't exposed.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 78 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 3507e33ec00e..89c1b231cb60 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -25,6 +25,81 @@ static struct kvm_sdei_exposed_event exposed_events[] = {
>  	for (idx = 0, event = &exposed_events[0];	\
>  	     idx < ARRAY_SIZE(exposed_events);		\
>  	     idx++, event++)
> +#define kvm_sdei_for_each_event(vsdei, event, idx)	\
> +	for (idx = 0, event = &vsdei->events[0];	\
> +	     idx < ARRAY_SIZE(exposed_events);		\
> +	     idx++, event++)
> +
> +static struct kvm_sdei_event *find_event(struct kvm_vcpu *vcpu,
> +					 unsigned int num)
> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *event;
> +	int i;
> +
> +	kvm_sdei_for_each_event(vsdei, event, i) {
> +		if (event->exposed_event->num == num)
> +			return event;
> +	}
> +
> +	return NULL;
> +}

I imagine you'll drop this hunk in the next spin.

> +static unsigned long hypercall_register(struct kvm_vcpu *vcpu)

Hmm, hypercall_ is not a very descriptive scope. Could you instead do
something like kvm_sdei_?

so for this one, kvm_sdei_event_register()? Provides decent context
clues to connect back to the spec as well.

> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_event *event;
> +	unsigned int num = smccc_get_arg(vcpu, 1);
> +	unsigned long ep_address = smccc_get_arg(vcpu, 2);
> +	unsigned long ep_arg = smccc_get_arg(vcpu, 3);

We discussed using some structure to track the registered context of an
event. Maybe just build it on the stack then assign it in the array?

> +	unsigned long route_mode = smccc_get_arg(vcpu, 4);

This is really 'flags'. route_mode is bit[0]. I imagine we don't want to
support relative mode, so bit[1] is useless for us in that case too.

The spec is somewhat imprecise on what happens for reserved flags. The
prototype in section 5.1.2 of [1] suggests that reserved bits must be
zero, but 5.1.2.3 'Client responsibilities' does not state that invalid
flags result in an error.

Arm TF certainly rejects unexpected flags [2].

[1]: DEN0054C https://developer.arm.com/documentation/den0054/latest
[2]: https://github.com/ARM-software/arm-trusted-firmware/blob/66c3906e4c32d675eb06bd081de8a3359f76b84c/services/std_svc/sdei/sdei_main.c#L260

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
