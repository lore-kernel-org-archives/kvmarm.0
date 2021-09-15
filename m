Return-Path: <SRS0=HAfI=OF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD375C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 05:55:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B7BD61216
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 05:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B7BD61216
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 876194B0F7;
	Wed, 15 Sep 2021 01:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cvaY2D8gAeJf; Wed, 15 Sep 2021 01:55:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FCBB4B0C0;
	Wed, 15 Sep 2021 01:55:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8FF4B091
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Sep 2021 01:55:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cEu4dIF+qVbi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Sep 2021 01:55:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECED84B08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Sep 2021 01:55:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631685308;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xA4ByGlEfEieWx2EOyrJAeS2vRhXErE4knQ2GkX8GRQ=;
 b=C3mYO9dS5MIk8ay23dzigrjpe/uBoQRmyejNgDBWf938KO0n+Fcri8cdiseovSTohuL4NO
 Dcs4FW88TTGw5BggUK62ok9IcYRSMnF9vcNwO4iWW4zZAOwat5jmTm4+Jeupq03Yt/WBdm
 krlPOT7syGOEON/jtwmoN6rA1DdZKUU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-aILUmAWJNtuVlOHixia5BA-1; Wed, 15 Sep 2021 01:55:01 -0400
X-MC-Unique: aILUmAWJNtuVlOHixia5BA-1
Received: by mail-ej1-f70.google.com with SMTP id
 bx10-20020a170906a1ca00b005c341820edeso896601ejb.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 22:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xA4ByGlEfEieWx2EOyrJAeS2vRhXErE4knQ2GkX8GRQ=;
 b=HHvlC5JLYzdoehzQKfgp7yN5QogK+U6CI5O4/Ztp72CE6OCogKfLWPLzB+BXfKLAgI
 uTxkGxuGPlwL05zkjG+Zzv/oGUnynymjOZaWxk8WVCasVWImrday3lWILtEpU0HlQUsB
 Wn9xgQhT7z0wVoB8XtA/p36AW5mzp5ytyKGNOA1ioFKNWn8fSUVi5QTgRDsb8gu85N7U
 LIvqYmNrl0PV4zB3csuLMt06B542/T8AVF03+EkhRe/z1ll95ab9O+vKDSEZ4cR/ugtc
 wPiHujJvHXw6Mx7L2Md37bBb8dRS5dZ38C9zwx54KX/1aw3TdyDa6gv8yeY5JB4WX7hS
 Oguw==
X-Gm-Message-State: AOAM531ad+n+ERtmeY8ThYIlqbegkSAQKtRucqGxW/mGS2w3KWLQ9LlO
 Z4iVUf+sVzglRavHT2X9WEZ/nYxZ/TA2W70g8DEucg0qZvZ2KcrUb53Tc01ulYCBPT8W/aKDnlp
 YZbFDF+zlAlfws9dgBEKfnU6K
X-Received: by 2002:a17:906:e105:: with SMTP id
 gj5mr22935865ejb.408.1631685300680; 
 Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmQFNRGGALDgSXECb7+CrH4Fm9yKRXtMUcjRCgpoUKc0xeyaWdPjESYb6S0eyWptweOgXupA==
X-Received: by 2002:a17:906:e105:: with SMTP id
 gj5mr22935848ejb.408.1631685300500; 
 Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id ba29sm5086767edb.5.2021.09.14.22.54.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Sep 2021 22:55:00 -0700 (PDT)
Date: Wed, 15 Sep 2021 07:54:58 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v7 09/15] KVM: arm64: selftests: Maintain consistency for
 vcpuid type
Message-ID: <20210915055458.tek6piqjyswxlvfv@gator.home>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-10-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210914223114.435273-10-rananta@google.com>
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

On Tue, Sep 14, 2021 at 10:31:08PM +0000, Raghavendra Rao Ananta wrote:
> The prototype of aarch64_vcpu_setup() accepts vcpuid as
> 'int', while the rest of the aarch64 (and struct vcpu)
> carries it as 'uint32_t'. Hence, change the prototype
> to make it consistent throughout the board.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 2 +-
>  tools/testing/selftests/kvm/lib/aarch64/processor.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 515d04a3c27d..27d8e1bb5b36 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -63,7 +63,7 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
>  	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, &reg);
>  }
>  
> -void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init);
> +void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
>  void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
>  			      struct kvm_vcpu_init *init, void *guest_code);
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index db64ee206064..34f6bd47661f 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -212,7 +212,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> -void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
> +void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init)
>  {
>  	struct kvm_vcpu_init default_init = { .target = -1, };
>  	uint64_t sctlr_el1, tcr_el1;
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
