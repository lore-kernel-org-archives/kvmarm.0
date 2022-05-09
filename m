Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2BCC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 22:36:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4410B4B08B;
	Mon,  9 May 2022 18:36:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tn3DNX1gCL3c; Mon,  9 May 2022 18:36:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4064B0C0;
	Mon,  9 May 2022 18:36:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDA54B092
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:36:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Q3bC+Obgnxk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 18:36:05 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E3B049EF0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:36:05 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id z18so16875983iob.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 15:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OSnht+8VCAB6CRGae6+His6a8pPmQv2FFPIyTYc0Bpc=;
 b=pO3gpVng8y8atVOaJE0kjrwYtdT6e+MRQ4x1h47NCCzQvKnOUxu3/dgFV014FfNPjT
 GY4WhlrMBvSQ/Q5+EhWVnCjnTYjomy3sTe4nsGsSTtvhT5qgROC0SN0Zc/M5g7GtN+lE
 Ruq8fYoR7/k+P+vSGh9pYjzhFjuOh8/+ioB9Ui2NCxmJEOCYog3nvaUlxykBTI6qOrV5
 32e26PmWjrVnm3dK2n6fWFOX/YmS0HJw91xrSPvU1SvbhE0uSgCTryB3ATilTo8NAAF5
 eP1arEqfXNoMSOAxX31QbP9xE5yd1P5sI7xXdVxWyFc1X9zwJhWR5bb+6BJIv7peaPW3
 B/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OSnht+8VCAB6CRGae6+His6a8pPmQv2FFPIyTYc0Bpc=;
 b=YUZq427yoN2BUDnihDi/3Pwvun5lzKP0De6S/S3kFx2b/AFeoDxujk+6bMBtRKq77S
 Xob2uwADiTAY5hQWn6n7zzRke1jZjeRECWVLWSTDTgRUswgjXHPeMUuIV8/DEfuQEJgF
 53N/Ph98Vf/+6RW7NsQpR24TzTcHE63GWkAz/AMPu+2E+/Wg4u5PpJ4rHX+2V/lh64tT
 pcqmulh9Ca5xgtSz0/Sw/Th5/ifcJSC80bQS7HcID1JnEVObsiIk+DskJ8wy7SIXbp61
 BgTjxJZLuGTNabDbifuSX1gs8Vgb8lSOp2UFVpLDaxGTBwW9iAnUC0yYODvRrzMjWXJZ
 T4MA==
X-Gm-Message-State: AOAM5313RSG7BGmbHpj5EBJUJL9Sn67MpFBJtP8G6x9rCMIF/5PAtGVf
 3E3CFNpBbLqSXdFAdObBkeS1og==
X-Google-Smtp-Source: ABdhPJycub8ue9uVjQrr3auGUDS3nibsPeiX1OCClK9zcna5Od9ajYwZLZtpHgtTe/lmKnlDJa3DbA==
X-Received: by 2002:a05:6638:2104:b0:32c:26ac:4d8e with SMTP id
 n4-20020a056638210400b0032c26ac4d8emr3361940jaj.89.1652135764457; 
 Mon, 09 May 2022 15:36:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 g4-20020a056e02130400b002cde6e352c8sm3448252ilr.18.2022.05.09.15.36.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 15:36:03 -0700 (PDT)
Date: Mon, 9 May 2022 22:36:00 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Reenable pmu in Protected Mode
Message-ID: <YnmXULIsOO27g/8N@google.com>
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-5-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220509120330.3043773-5-tabba@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Fuad,

On Mon, May 09, 2022 at 12:03:30PM +0000, Fuad Tabba wrote:
> Now that the pmu code does not access hyp data, reenable it in
> protected mode.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 3dc990ac4f44..11c43bed5f97 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -774,8 +774,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  {
>  	struct arm_pmu_entry *entry;
>  
> -	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
> -	    is_protected_kvm_enabled())
> +	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)

IIUC, you intend to enable the PMU for non-pVM guests, right? Based on
the pKVM feature registers + trap handlers I can see that pVM use of the
PMU is in fact disabled. It'd be good to state in the commit message
what is exactly intended for pVMs and non-pVMs.

Since the PMU counters are disabled outright for pVMs, is there any
value in context switching between host/guest in this case?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
