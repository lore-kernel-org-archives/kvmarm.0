Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEEAC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:18:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68D7660E52
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 68D7660E52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1C74B0DB;
	Tue,  7 Sep 2021 14:18:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iqcDktjoTYKD; Tue,  7 Sep 2021 14:18:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09BC64B0DE;
	Tue,  7 Sep 2021 14:18:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE464B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:18:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2WF6USLxU73 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:18:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8574B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:18:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631038691;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/Y4ioFnJuisj2BTJf1/oHJdXHMcO8vnvhxc0AOo9EVM=;
 b=Zijclc+mTnRuNE+Gyunc+QeFW8I3l6/vepQPv62P6HLCKvRv0t6/LhC33QKg3LD9XOrU6n
 WOfWJqvZRYgNkfKAVv0yOAg7l8/FxdPUJ5a2/WE2O3EYbO4cYBLqvTaZPFVNsN2M9Xk6bG
 bE1/U3pBtROn7qrqASNRiFo7xUTc88w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-j71M0aBOOhqUkElRKJT_oQ-1; Tue, 07 Sep 2021 14:18:09 -0400
X-MC-Unique: j71M0aBOOhqUkElRKJT_oQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 g4-20020a056402180400b003c2e8da869bso5782730edy.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/Y4ioFnJuisj2BTJf1/oHJdXHMcO8vnvhxc0AOo9EVM=;
 b=hYfg/prXOzBaxAsITlHunch3BP+UdY387L5Yybk+riUEOs9+vSyl550jotjOJAWAlC
 v3h82/a/p4QJPSf/4LLJZCDODTKauSXurXfvU0rojXahHLXT5EczSqC2qe/Vk/DCsPHV
 mZeU4MxC2sfQm3TOTa0XdWQY+I5lcM8XJBZfJ7GBy1QI72NW5g7Pxi+n8b15anEDw0Bl
 911NLPrwrahRDlS+JWa59U5vffYClq931UFr2/nIZGmu7iIeLX+MiO/mVo5cG3U1Xr4B
 j36rn2YAisO/0blBemSbUUnpTXtSdVtyc2z7N8qloX+9+wkcR0TK8QnQL1kBVx0ESxLT
 BbnQ==
X-Gm-Message-State: AOAM531zcjsiV1KtSLbmBB4kltS7WFFvTCYRZ6Tb7D1ByZ7md0zAJ4AH
 kerPMNHNiJJKaU+IdCxVU6pxt7hu0uC+O7tbquNOCMh25ZrgyQE93Fdfyhfr6uBSW4iCJkPuyCC
 rk6iYY9kPSvLvgw0SwTlCxwiD
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr844572edv.384.1631038688790; 
 Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2BAJqv2ikfIL9GSFYL9FGap4baDkbWIjl814C12RIpseaaxrMOITupVIIE6OrP+B3Y8wgKQ==
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr844557edv.384.1631038688652; 
 Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id be5sm6926257edb.57.2021.09.07.11.18.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
Date: Tue, 7 Sep 2021 20:18:06 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: make memslot_perf_test arch
 independent
Message-ID: <20210907181806.wqlspjygukc574yz@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907180957.609966-2-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210907180957.609966-2-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 07, 2021 at 11:09:56AM -0700, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need to know
> details like what kind of exit they generate on a specific arch.  More
> specifically, there is no need to check whether an exit is KVM_EXIT_IO
> in x86 for the host to know that the exit is ucall related, as
> get_ucall() already makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
