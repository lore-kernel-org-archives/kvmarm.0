Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120C2C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 07:04:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E36661101
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 07:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7E36661101
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F13C64B116;
	Thu,  9 Sep 2021 03:04:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5HLMIWgFa2r3; Thu,  9 Sep 2021 03:04:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F22EB4B107;
	Thu,  9 Sep 2021 03:04:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F8A4B0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 03:04:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XqHm5UeqZ+Aw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 03:04:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0C140623
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 03:04:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631171073;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=l2l5r4SBCHwEiq0ScaB4dWcgzj5hh1v8SYuZuO29rHo=;
 b=JQg0hWdqMt8c0gs+TnrlcGs0gllLgjO6JSIQPWcDvwCiTM8z8++8MhHxuwFsZL4nyzbz3v
 H5kEGid6hDG0Y6SJ2fc6uLMaemocY3SXm15++zCgIxkMQJR3LZztX9mMi3JeRIlawPFPYM
 lz71HHLc9PLq07nUYtg5iPn9CVM1MEg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-aSKkoNWiOyqYFh8qhMG02g-1; Thu, 09 Sep 2021 03:04:32 -0400
X-MC-Unique: aSKkoNWiOyqYFh8qhMG02g-1
Received: by mail-ej1-f71.google.com with SMTP id
 gw26-20020a170906f15a00b005c48318c60eso344343ejb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 00:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l2l5r4SBCHwEiq0ScaB4dWcgzj5hh1v8SYuZuO29rHo=;
 b=hqnt/ICtbaBIQ5m6zdgoqS0AAnwNwXjYB3F8gfLh9qGEfRaAO8MA/IVnxnejnk3i0l
 YQLzxvRVhiUhaPDaAkHVNN5QfCMPdm/boOw4qRjIRRugIduEIZFV1BLEkJk2Do+PE1at
 8tv/x8tw1Tv1IVmAxz10xYPIa+usWqsuM6LPzXqFkubvKDiXpZUp8DNdZh4tV7Pk/3yf
 nOUFFET3GRdiC6Pzq3gZLDV17J7KZ1sAZC8PGSQy7zf2QWbV5loiXY1/AHeMJ7DwKdrs
 XlnC0dhaJyQAD9VUesa5Yio+STaSrRwldV6X901O0F8X511WVsAgYNs11w3fufk58Z4H
 8guQ==
X-Gm-Message-State: AOAM5309O8VDpIbKKwx25GY2iZLm3JDFAWbEn8Q6kcKhsSd3ynk+3oWl
 EC82BIOB4Ul2aWYX+cNEBj578ORV3qtMi3plbqNX/SAioI1vaqLTw301dYQ51gBtUXkM3+QdIVW
 nuI/6sZROgkOLtNtqH77gj8tm
X-Received: by 2002:a17:906:7302:: with SMTP id
 di2mr1869684ejc.409.1631171070963; 
 Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaTI3qYEno3ZJd14sTF6cADqRVW3Joo5jc8lsKG9esd951qp14KjQPeWPkFFvJv/w4BJzeLw==
X-Received: by 2002:a17:906:7302:: with SMTP id
 di2mr1869651ejc.409.1631171070762; 
 Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id cr9sm499745edb.17.2021.09.09.00.04.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
Date: Thu, 9 Sep 2021 09:04:23 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <20210909070423.5z4eg7wkmswpdi33@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-5-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210909013818.1191270-5-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index bed4ffa70905..ac8b63f8aab7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -26,6 +26,20 @@
>  
>  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
>  
> +/*
> + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> + * SYS_* register definitions in sysreg.h to use in KVM
> + * calls such as get_reg() and set_reg().
> + */
> +#define ARM64_SYS_KVM_REG(sys_reg_id)			\
> +({							\
> +	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
> +			sys_reg_Op1(sys_reg_id),	\
> +			sys_reg_CRn(sys_reg_id),	\
> +			sys_reg_CRm(sys_reg_id),	\
> +			sys_reg_Op2(sys_reg_id));	\
> +})


I don't think we need the ({ }), do we? Anyway,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

> +
>  /*
>   * Default MAIR
>   *                  index   attribute
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
