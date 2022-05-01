Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B207EC433F5
	for <kvmarm@archiver.kernel.org>; Sun,  1 May 2022 06:55:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21D7040FF0;
	Sun,  1 May 2022 02:55:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zq0YCOZw2DPq; Sun,  1 May 2022 02:55:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1545043C8C;
	Sun,  1 May 2022 02:55:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A45A740FF0
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 02:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4iAfqRtQrxKC for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 02:55:10 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DFA240FAA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 02:55:10 -0400 (EDT)
Received: by mail-il1-f179.google.com with SMTP id t4so6345650ilo.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 23:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=66d7SyRrONsXl8W4lFBX0N0VrTFcPFH9NXUMscq4ECs=;
 b=gpPu6skWQ2IhiBwq3C3Wc2ylJ363rdzpeVUcCH8kt9q7dHvFWOJnbcsgRbrOQFYKcv
 xrJApxsgnQjhM+ch1GfLHZVpgsTsxgUrisEHTgxjKRMkpBQquVQ+/xBVCpfdJ93hA3K/
 SgsLTwxHUi4HHmRW9L/hPBCR2UvYVZowMynW9UKHqqyPyLrpYzubdqiO/QUGqdSViE7m
 z6tL918AfC6MwJ+iX0V19yA3+jIRdVzwhXFkj/UtPLcXe23XsUGoFMHkcSQTHPTEDl1q
 qTv/u+du++0uQwQVqkWvjlmDbakho2tAf7ecAylV/KuDI4v+JsMZK13/y6YihPVVZ5z+
 tgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=66d7SyRrONsXl8W4lFBX0N0VrTFcPFH9NXUMscq4ECs=;
 b=2Egh+B+Lub5DES+R+kmk0GAqwU8CVc/fx7xz7XlB9dSRUyT6hUhVhBRPBfJQbz1D9J
 IcVWMdIKUp5nu13z3HereXwJbEEjFE01G/6LLXD6w8Ch8P/1rPPL+BKvhrRHo6XIZaQl
 FnrHxeES/ERNpYrIaEh6vp681ouKE9dc8Btk05o0B3jmEvXeAFzDDvX3fs2Uih757Qjx
 tDjwg2o4H9bZiB4JGa+8+w+oy7GNDVS7W04e9Q43Lfti2CsMU2xBlw/+ZeHZSEhwJkZb
 wWlEiBSGN+U0ILuKGGr5+v/XjZrX3wEicpJqmo5p5qu1K/qL2Gpb1D6dM7JUJPdkYBx6
 wF7A==
X-Gm-Message-State: AOAM530yHH9yXq4UC1j/2IOvrsbdj5HYYuGJK3ScNNgSoHS3qBkv//M5
 +3Qt85+f317zd85UFXF7B5tmhg==
X-Google-Smtp-Source: ABdhPJxyPVbw+8ZIaPFEomRXrig6kQMnEuxlIz0lgU1En0dO9EeQyCH8axYSrs0P1kc0Cz80nR0P1w==
X-Received: by 2002:a05:6e02:160f:b0:2cd:5c76:817e with SMTP id
 t15-20020a056e02160f00b002cd5c76817emr2859671ilu.133.1651388109758; 
 Sat, 30 Apr 2022 23:55:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t17-20020a6bdb11000000b0065a47e16f4csm1152530ioc.30.2022.04.30.23.55.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 23:55:08 -0700 (PDT)
Date: Sun, 1 May 2022 06:55:05 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 15/18] KVM: arm64: Support SDEI_FEATURES hypercall
Message-ID: <Ym4uyaGGhPXlnkHQ@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-16-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-16-gshan@redhat.com>
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

On Sun, Apr 03, 2022 at 11:39:08PM +0800, Gavin Shan wrote:
> This supports SDEI_FEATURES hypercall. It's used by guest to
> retrieve the supported features, which are number of slots for
> the interrupt binding events and relative mode for the event
> handler. Currently, none of them is supported.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index e1f6ab9800ee..ab0b7b5e3191 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -527,6 +527,23 @@ static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
>  	return ret;
>  }
>  
> +static unsigned long hypercall_features(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long feature = smccc_get_arg(vcpu, 1);
> +	unsigned long ret;
> +
> +	switch (feature) {
> +	case 0: /* BIND_SLOTS */
> +	case 1: /* RELATIVE_MODE */

Can you create macros for these?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
