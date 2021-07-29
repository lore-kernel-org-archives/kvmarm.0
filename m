Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B250DC4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:45:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31EC360F5E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 17:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 31EC360F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4814B0E3;
	Thu, 29 Jul 2021 13:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CqBw9PiBTF6u; Thu, 29 Jul 2021 13:45:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7E44B0E8;
	Thu, 29 Jul 2021 13:45:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378D34B0E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:45:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mh9RohUfevSJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 13:45:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BF7F4B0E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:45:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627580732;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rT316eGUa2+7b7jjZkTlKN4mfhqRrOL4B5+LcpVHIKo=;
 b=grfq1yWAxVB+Fkz4WU+waEqqQcTqYWn+KNZuuBsdsyp302Y8/S6jr1Z7RLbTBHGUes9+pi
 cKS5c0IByFr6cKR8bX1OFxCrW3iTq8uxpbZfZ4ojVy0/qQUc/sWl0iYFtDj44qgUZwGoj9
 nWyf1OZ5XGU7PJSwAElrW0sE4YJpe/w=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-ibzkHwCTN6KLTLESwQKzfg-1; Thu, 29 Jul 2021 13:45:29 -0400
X-MC-Unique: ibzkHwCTN6KLTLESwQKzfg-1
Received: by mail-io1-f70.google.com with SMTP id
 z17-20020a0566022051b0290528db19d5b3so4267716iod.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rT316eGUa2+7b7jjZkTlKN4mfhqRrOL4B5+LcpVHIKo=;
 b=dkmE7h1SJ/S+jacW1HhPhP2TAp5aiJf67DIyOmX/6WCv6s4C0jvRW336TYkz3ntQF6
 w1bchWK775JccV8p2PqeCLuHkAtdwkWyFeQ23eqnongAQwNKuaYO1IYhzCho9bPiYJHu
 h3q5uAcHim7f3ASP5h6tU2lsdvYP3XHy+MXIJlNvnDFE29LFonP+lujrKFfIrNamIUJN
 bV9gANCGzq+jz5hvH4bKUEXY0A/1Eog05/4fBax6tcjR8Rf0ndrvEtx6sSmRoEVJiqND
 fGtEhtHjOW7tP12GtelSMt9jFZrVtkItOkTie+NAXnuNQRM6GeoQCHtIUqhTuk4ibruw
 Xsyw==
X-Gm-Message-State: AOAM530mFdICFdu8+r/FpEtL1PRy20olAkmrfInn/XCWblWn0ZkoVF2/
 CNMaOtQabyeiW4trc8tfgKQLxyISKnppnfDnz1VOD4Y8iDFd8L6nIkQ2KpB1r0ogjIgE5L3CPak
 2zmYAh/EgC1kLZZsONSzLTwLl
X-Received: by 2002:a05:6638:3a12:: with SMTP id
 j18mr5555698jaj.75.1627580729307; 
 Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf77LhlT9YvfAjMD/rhjDi5lGqSzYugzzvfmOLDdrWVhTSAaNJZlRA4FN/MoqzmCofE6vzAQ==
X-Received: by 2002:a05:6638:3a12:: with SMTP id
 j18mr5555679jaj.75.1627580729171; 
 Thu, 29 Jul 2021 10:45:29 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id j18sm2589446ioa.53.2021.07.29.10.45.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 10:45:28 -0700 (PDT)
Date: Thu, 29 Jul 2021 19:45:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 13/13] selftests: KVM: Add counter emulation benchmark
Message-ID: <20210729174516.nje54y7c5iy5qyn4@gator>
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-14-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210729173300.181775-14-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Jul 29, 2021 at 05:33:00PM +0000, Oliver Upton wrote:
> Add a test case for counter emulation on arm64. A side effect of how KVM
> handles physical counter offsetting on non-ECV systems is that the
> virtual counter will always hit hardware and the physical could be
> emulated. Force emulation by writing a nonzero offset to the physical
> counter and compare the elapsed cycles to a direct read of the hardware
> register.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++++
>  3 files changed, 209 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
