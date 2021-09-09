Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CA1C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 06:56:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 551C4611B0
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 06:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 551C4611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE3E4B10C;
	Thu,  9 Sep 2021 02:56:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v-cvT-FdxXkL; Thu,  9 Sep 2021 02:56:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5B224B0F4;
	Thu,  9 Sep 2021 02:56:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C1FA4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 02:56:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id myiGYHrAvN3w for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 02:56:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7964B0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 02:56:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631170578;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qscILqSOiDtHr2K06miwU5XrXdXBp14iQB45BddDnqs=;
 b=H58rWzPnrTyUPi4Urx5FcHo9EUCrzOa/5tLExEudlFBQTXmwbqwHLmxI2eIP4v0KcXhmos
 /tkEwInTnNyvTo7ZUo6rhJxiwKPRqZ4zmLKWY2cCQOpBEKo0qU/SST1ifz51CNNhIX8/7g
 nHx6+CYQTWT5uC7DiZIR9y3ibfUiE1o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-7jkJgtWNOsm4Hki28_ILvw-1; Thu, 09 Sep 2021 02:56:16 -0400
X-MC-Unique: 7jkJgtWNOsm4Hki28_ILvw-1
Received: by mail-ed1-f71.google.com with SMTP id
 i17-20020aa7c711000000b003c57b06a2caso458047edq.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 23:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qscILqSOiDtHr2K06miwU5XrXdXBp14iQB45BddDnqs=;
 b=eLUy+6H0CL/gon9Zd+XC2NZw94t2vc5BQyt342/9dalIa7S4D7DmNYS9H7sPoOFAB/
 vOu/l6lTum64I+fFdM4Kz41vG9jV84nlOC4DGg6BxmRFN8cg5zSHT1YzmG9fdqMRN2T1
 aCoSBcLj+GZfXcgi/1PEP47xeEGsU+wehVaygMYpeA1tqPKC757+EETfdtluBHxKmcKq
 OKn2oVjXMkvdVeQUuMSWsWoACUk9mZaiHgRa2rp+K/tRLQDtnMJd/LQ8z4jKiwMIkwif
 A+iDGfhgaaJlgc4rGQS6T2xe1RzIRElZVCWnqsFLsshi6ZapDk2sNxAwpaUn0i/tMAzX
 g3aA==
X-Gm-Message-State: AOAM5311QHPN/aFxkeKFNxK3PVWMjm2IAOZnO22e2BJIVUrk7u6cOXaF
 XXDi0UZQ02HbREyGqukpZrDvcbQDVpk9WnRftoO59fMCHQcprbAFG1jXdlCk42jKsu7mc2MsCFu
 aJTMeG2xAeYG5ovQU9Kff/zKX
X-Received: by 2002:a17:906:adb:: with SMTP id
 z27mr1768641ejf.235.1631170575638; 
 Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpo2+DqJ1Q+SdKK5uQrU7ZDb5hL1qYXbG3ULjiHa/exReDGCf5X1iUjVNkVgI9sq45uc1HcA==
X-Received: by 2002:a17:906:adb:: with SMTP id
 z27mr1768615ejf.235.1631170575371; 
 Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id c21sm381830ejz.69.2021.09.08.23.56.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 23:56:15 -0700 (PDT)
Date: Thu, 9 Sep 2021 08:56:12 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
Message-ID: <20210909065612.d36255fur5alf6sl@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-4-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210909013818.1191270-4-rananta@google.com>
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

On Thu, Sep 09, 2021 at 01:38:03AM +0000, Raghavendra Rao Ananta wrote:
> Make use of the register read/write definitions from
> sysreg.h, instead of the existing definitions. A syntax
> correction is needed for the files that use write_sysreg()
> to make it compliant with the new (kernel's) syntax.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
>  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
>  2 files changed, 15 insertions(+), 26 deletions(-)
>

Same comment as Oliver, otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
