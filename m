Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D59C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:34:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5303361176
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5303361176
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D454B0EF;
	Thu,  9 Sep 2021 01:34:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N64jGB4j5J-4; Thu,  9 Sep 2021 01:34:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B849D4B0F2;
	Thu,  9 Sep 2021 01:34:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 655DC4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:34:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kZDjBsyzcf8m for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 01:34:43 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 625364A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:34:43 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id a13so803039iol.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 22:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=y2Hl2l4cxBWAmvma6OCIzHq+HL4honh1QiJPwU9rasU=;
 b=h0trGScMtT5bQc/2VuAgPUXIbyF8zoHK/m2lOVQQC7tyT0+N9vwYgAYl0C7N+3clR9
 9GhxGKDa0YmXUs7zbK+2egOPre9sEsGTgq6ZZ9vBfRp67UeT8J4VCDFJvbSMCvfYQkL4
 dJsIjN5VShAqkQxXN04P6nXY7quSg4zza2QawEf9RSHqbuiuhDkcTW32Do2SizpJ7QRC
 cb26MSQiRsktbLZ+9DGCB8pAeUbvrDxFMRCqaK9WNqBQ8ZpiOZGNpX9AkIx4B2QjGgfP
 LzVyTeBWH9iuO1vBdsL8zYB5iMC96Sb/LGZeIVJqS19WCm3v+Y7CuSIQN7ZZrdgw6Efn
 cNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=y2Hl2l4cxBWAmvma6OCIzHq+HL4honh1QiJPwU9rasU=;
 b=LHXf6p1xvBw5bo15EBSOiEE4Pk74R4gfLFKjMmKZAh4gjEPS8C6B5Of/mZiMORchvV
 7gMiOSadydnuM8X2hV/CyPfPwCH6dFE9kVbFzYOvJ+K6wCtc1UO4CnF71s9CbO5rReqj
 MylhzZ0E8IVacVMLahr+bNTXiCbJXJsuJ0CkzrDmW9EdZtmwyApI73Sow23Mlm4JXYvT
 WjVjYQ5IrG04p63VwlW1Q5TaQch3ln2c3RpN+nBO2sbXNj2jaoFWaUu8OsDPcrtp/daJ
 99ZY9WayoFAuFLEAzQDSmSUI4DdHo6MXvf5by/1H+eg2agJpwHzjWX2lGZgIOHJS9UKS
 CX9g==
X-Gm-Message-State: AOAM531LBYHXNIzwlLRiduTAAdRvBy0uC33Yl7jga1F+Tm7l91vmLfl/
 9fth1LBErvhZgYzTTv7Vpm3h2Q==
X-Google-Smtp-Source: ABdhPJwNOgynlp5UJ/IiTJl67bZenp2a5LYW9EGf/gzrp3rUUolZcWeZIJhwxhwOFZMFl5RRTaQTXA==
X-Received: by 2002:a05:6638:1613:: with SMTP id
 x19mr1279010jas.77.1631165682590; 
 Wed, 08 Sep 2021 22:34:42 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id z10sm409971ill.69.2021.09.08.22.34.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 22:34:42 -0700 (PDT)
Date: Thu, 9 Sep 2021 05:34:38 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 17/18] KVM: arm64: selftests: Replace ARM64_SYS_REG
 with ARM64_SYS_KVM_REG
Message-ID: <YTmc7s5hdAuN5PPy@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-18-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-18-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thu, Sep 09, 2021 at 01:38:17AM +0000, Raghavendra Rao Ananta wrote:
> With the introduction of ARM64_SYS_KVM_REG, that takes the
> system register encodings from sysreg.h directly, replace
> all the users of ARM64_SYS_REG, relyiing on the encodings
> created in processor.h, with ARM64_SYS_KVM_REG.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c     |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c     |  3 ++-
>  .../selftests/kvm/include/aarch64/processor.h    | 10 ----------
>  .../selftests/kvm/lib/aarch64/processor.c        | 16 ++++++++--------
>  4 files changed, 11 insertions(+), 20 deletions(-)

I would probably just squash this into the patch that introduces the
ARM64_SYS_KVM_REG macro.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
