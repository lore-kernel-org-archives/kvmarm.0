Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04FDC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:36:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FB126128C
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 13:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6FB126128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF76E4B12F;
	Wed, 29 Sep 2021 09:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gcye4IteaTd1; Wed, 29 Sep 2021 09:36:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3A0D4B11F;
	Wed, 29 Sep 2021 09:36:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE3E84B0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6V75UxPSxJb1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 09:36:54 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A2004B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:36:54 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id d6so4288165wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 06:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=p1lN5h412iZ+jiYL21D4EDp28QaTlZGVFwXpgnAG8zY=;
 b=DZo/M4QwNbhHQlkBcEl3KRzaLXdJF3wDPS/Ks3k8DgOCWQosYBd8pvWAEjyzS3s5o9
 3wSq7sTesam/4qyjsV0UxADlliAjJwMnlZ80rO57uKw75z3BNaJE67OeA/zjElYfNBnB
 upu9H1oGAwkJZWJ5kKHu8XL6UOnWbvf3DORDTyvGnaTtIQJneKhyY01YN0in5proaZ1D
 CL0LwrgFYEmEGSP9olyni8Heu0DZDAscMtnIy/cEWldMrjYZjt2ZIOdlAVDcNC/coLzy
 nGaT2CHchlFVlHvVb6gZLG8WKtLmeOgZbLyZcwTt7Up67Hr7VV7vzA0MyJhxGa1H8L5V
 mXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=p1lN5h412iZ+jiYL21D4EDp28QaTlZGVFwXpgnAG8zY=;
 b=CqSG6emHIsQjOt0drW2n1tzbfloBUDghMmpr1+uKrILOVeJnqPqTEXjfOsURQiSVUW
 6AiXGhSt0fJ53mSIDa3uvqU59qOwsutv7TRk4BliDSR652OVP8DR5GRnIYSFvVa/U0xm
 ESSPuaNjYdgrCuv3G2mYBFgiQdPESNj9TSOElZvis2m7FoLvpG43uzmF9f4OGYAUUB3E
 //oTxMOHYEy9NawW/67yDYLSm7kZFyt7Ste3t24IY4RI5Mu5BekNvpbcrR18ERvLTe8a
 g+3CDZXiz3AqkdYT8u+3KQjrrF7HZH7EyNwMrrb3tzIhI5MMF/tjZkUS8TUmnL/EaC0I
 gvDg==
X-Gm-Message-State: AOAM5312CjTYziq6wGkfaX1s6cJL2u5IU+It4F3kUPj7ihNF6lzukK6b
 N3zPaeLh4FsED1svpxVfDYYzzw==
X-Google-Smtp-Source: ABdhPJxkZq3g55PyvQwEmuy68Rg4FY1ju/lkwZnhBlN5+gehJC8BuR5CbcA5bJB+m5HEiXAV5EsTeA==
X-Received: by 2002:adf:fe89:: with SMTP id l9mr6930369wrr.0.1632922613458;
 Wed, 29 Sep 2021 06:36:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:1ebb:fd0f:cf53:11c5])
 by smtp.gmail.com with ESMTPSA id z12sm2418453wrv.31.2021.09.29.06.36.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 06:36:53 -0700 (PDT)
Date: Wed, 29 Sep 2021 14:36:47 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 3/5] KVM: arm64: Propagate errors from
 __pkvm_prot_finalize hypercall
Message-ID: <YVRr76aI+5zhq3nY@google.com>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-4-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210923112256.15767-4-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thursday 23 Sep 2021 at 12:22:54 (+0100), Will Deacon wrote:
> If the __pkvm_prot_finalize hypercall returns an error, we WARN but fail
> to propagate the failure code back to kvm_arch_init().
> 
> Pass a pointer to a zero-initialised return variable so that failure
> to finalise the pKVM protections on a host CPU can be reported back to
> KVM.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9506cf88fa0e..13bbf35896cd 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1986,9 +1986,25 @@ static int init_hyp_mode(void)
>  	return err;
>  }
>  
> -static void _kvm_host_prot_finalize(void *discard)
> +static void _kvm_host_prot_finalize(void *arg)
>  {
> -	WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize));
> +	int *err = arg;
> +
> +	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
> +		WRITE_ONCE(*err, -EINVAL);
> +}

I was going to suggest to propagate the hypercall's error code directly,
but this becomes very racy so n/m...

But this got me thinking about what we should do when the hyp init fails
while the protected mode has been explicitly enabled on the kernel
cmdline. That is, if we continue and boot the kernel w/o KVM support,
then I don't know how e.g. EL3 can know that it shouldn't give keys to
VMs because the kernel (and EL2) can't be trusted. It feels like it is
the kernel's responsibility to do something while it _is_ still
trustworthy.

I guess we could make any error code fatal in kvm_arch_init() when
is_protected_kvm_enabled() is on, or something along those lines? Maybe
dependent on CONFIG_NVHE_EL2_DEBUG=n?

It's probably a bit theoretical because there really shouldn't be any
reason to fail hyp init in production when using a signed kernel image
etc etc, but then if that is the case the additional check I'm
suggesting shouldn't hurt and will give us some peace of mind. Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
