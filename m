Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E93C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:43:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51CEE4B207;
	Tue, 11 Jan 2022 04:43:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hOLE+GEzd5Ii; Tue, 11 Jan 2022 04:43:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04AB84B187;
	Tue, 11 Jan 2022 04:43:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5804B4B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:43:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H9Stuwv7itL0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 04:43:44 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B8394B134
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:43:44 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 y16-20020a17090a6c9000b001b13ffaa625so4184429pjj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 01:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=KnfNQM0P4Kk/f9HQK7av976cxzJdXVOcvjBDqvTAbaY=;
 b=IjCXqpKc+vMIKLi9hRQJSIg68R7/Cz32H2/4DJlhXVmA1PZ19v18p5UQAKRlNk1e8F
 dm/Y6k/pT62yLd/t0Bc94Kt8sBX16j8Tu/56AObBV/IQf7XFNpRXOgS3yLPylNTOBPwF
 gHOEj9abGeKdyo+BoWy4CjIFJH8GFmFg1KzGN2aUYNu15qNcZ6apuwlAKjfMXY6twOJq
 GP2POuPGGi1krxVpvwkfNiTOS5ibOBMj3RSx/AnqsEboglGJe1MN7HJqCCqlwNsh7Fk1
 Pn8haluL3FOdtV0fUmUCsKQfxmVeRd+JEZFlDtYJE2IChbtQc3p0BdbGexx5EKEphO9O
 S2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=KnfNQM0P4Kk/f9HQK7av976cxzJdXVOcvjBDqvTAbaY=;
 b=dJTDXmwW22n/Raby8moFANZbvnJ2Sco8iQQDnFoemJwlsNPPNYhc2i3K4KpFM4boln
 oce2nK9WmUvYhBWevv+nNZZ/NY3Ab4xuSQWpZvvVVYC12r8HkF4dRldAL+B9feLo0DdZ
 5ETvmqw0M6YHCFGas7RxEG+CAsvjRFmtHfomQWjkkxs2gu1FaA7fkOpaDEmpbxC9LJZs
 5O9Gh1VvcmW4P63oiOOIUjI6xMsrh2SsNiuIrV7zy/STBd/gF4NTrsyPl2PlMA84p8Zc
 F3QLzDwyB3U3TO56fva1s2NEsL03SmyTSUZRd8h9IUUOao5jCP1eE7+B1oJVDKIMacRV
 LHWg==
X-Gm-Message-State: AOAM533GqM5qD1bXpGhQscHjMnP/bJxQ6vYUWUaxlkTthWmFRFy0bjXD
 NQDg0n7eKlGTCJ+VjNK68Cg=
X-Google-Smtp-Source: ABdhPJwZfBwo/+msCTr23aIWD9mZnC/DNPCKsxnz15D3ucfytOuuINvDcO9OxS7QXee/78A4REhNjQ==
X-Received: by 2002:a17:90b:4f8d:: with SMTP id
 qe13mr2230606pjb.178.1641894223413; 
 Tue, 11 Jan 2022 01:43:43 -0800 (PST)
Received: from [30.43.104.246] ([47.89.83.37])
 by smtp.gmail.com with ESMTPSA id lp6sm2214580pjb.55.2022.01.11.01.43.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 11 Jan 2022 01:43:42 -0800 (PST)
Message-ID: <40d818a2-0c91-e06e-6ce8-ac8123b8d1d4@gmail.com>
Date: Tue, 11 Jan 2022 17:43:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
Content-Language: en-US
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
From: Shannon Zhao <shannon.zhaosl@gmail.com>
In-Reply-To: <20210815001352.81927-7-gshan@redhat.com>
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2021/8/15 8:13, Gavin Shan wrote:
> +static unsigned long kvm_sdei_hypercall_context(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_vcpu_regs *regs;
> +	unsigned long index = smccc_get_arg1(vcpu);
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* Sanity check */
> +	if (!(ksdei && vsdei)) {
> +		ret = SDEI_NOT_SUPPORTED;
> +		goto out;
> +	}
Maybe we could move these common sanity check codes to 
kvm_sdei_hypercall to save some lines.

Thanks,
Shannon
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
