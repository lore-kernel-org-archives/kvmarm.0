Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4786C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 06:51:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 478636113E
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 06:51:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 478636113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5C0D4B0E2;
	Tue, 14 Sep 2021 02:51:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1+A4GEyyr1ng; Tue, 14 Sep 2021 02:51:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4994B152;
	Tue, 14 Sep 2021 02:51:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 083964B152
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 02:51:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFnR5YSyMHaT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 02:51:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26BD84B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 02:51:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631602268;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uo1ypxwE99K2K4JA/RxOGUNqzLACfvlm1lsSRFgGyDc=;
 b=MLR0Gmc4NgURvjHy3VjPHcj2HQd0QWEFYYTMmrhFpVF64MqxlUELmILnAi2PLFhvw0SuVD
 m6ltkbzmiK9X62BWy8sKcqSQ2u5oIin0l09gB7RDso/ekbd2yx/wcWd/VS/ODbWNG9EQ69
 hutvBHVlhV56n7j9ajmtconU1sB0G78=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-qHNMW6F5MJW8FlHi6T2TDQ-1; Tue, 14 Sep 2021 02:51:02 -0400
X-MC-Unique: qHNMW6F5MJW8FlHi6T2TDQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 s15-20020a056402520f00b003cad788f1f6so6201927edd.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 23:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uo1ypxwE99K2K4JA/RxOGUNqzLACfvlm1lsSRFgGyDc=;
 b=RMtqn8jF1PBcFLHSlecZsBkhpxfE83ftbSTIOClgWeuo71Rct+qI1dsiRHyGtwPA6v
 OyZlDih81mLcWpF0VQOo+VKboKjc1/+/BzqvbjFDnWHpz+hoSpMDWy5u9CkW1uD+YgTc
 f2tPg0v3J5zl5mZgcI9XrX11rubNF4GIN8XRh6Ei8pLIVNe+IVay1ha7uviSTpLTu8j8
 UXGZUsbmrLbogGC6zWNRQFpi1LNl2/6BRtLdUA4vBQKhQDnAxiHBA8zQF3xoKZtORLpu
 /5a5andlm2G0E8ZGn1+RcP5g7v0H2cLc17NustRnOW1W8fu8zxWIX0GGAQMlSYKr08p1
 v1fw==
X-Gm-Message-State: AOAM532ncJ4dL4q3L1X+I//krgP1ozebbRtyNoFVn2dYc3Q7WGVBGG82
 sIPlcwpUydaFo9AeKGFSIhCcChkInErHabWnYQ5hrPK8I+D1OpG6c+ha8NrtGpNQO6LOlgMALco
 h5otCkDGAoCuvYN7DcPEQewg2
X-Received: by 2002:a17:906:686:: with SMTP id
 u6mr16587588ejb.569.1631602261069; 
 Mon, 13 Sep 2021 23:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylIm78jMF8rvHMhD/z1+b0Q3pmhqeY5KYi6PHEiggzRATGOoFe+gFNpkPigFiX6dd/K2Nvxw==
X-Received: by 2002:a17:906:686:: with SMTP id
 u6mr16587561ejb.569.1631602260877; 
 Mon, 13 Sep 2021 23:51:00 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id k21sm4417460ejj.55.2021.09.13.23.50.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 23:51:00 -0700 (PDT)
Date: Tue, 14 Sep 2021 08:50:58 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 04/14] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <20210914065058.3ujet4nesbzxy4vr@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-5-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210913230955.156323-5-rananta@google.com>
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

On Mon, Sep 13, 2021 at 11:09:45PM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Also replace all the users of ARM64_SYS_REG, relying on
> the encodings created in processor.h, with ARM64_SYS_KVM_REG and
> remove the definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  2 +-
>  .../selftests/kvm/include/aarch64/processor.h | 20 ++++++++++---------
>  .../selftests/kvm/lib/aarch64/processor.c     | 16 +++++++--------
>  4 files changed, 21 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
