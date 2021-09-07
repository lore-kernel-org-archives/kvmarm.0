Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03558C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 952F761101
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 952F761101
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486EA4B10B;
	Tue,  7 Sep 2021 14:18:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qsUpKp0DFiNP; Tue,  7 Sep 2021 14:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8F24B11B;
	Tue,  7 Sep 2021 14:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB56C4B10B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8mgRAZYjAmB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:18:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D889F4B0DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:18:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631038718;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LUu7mpwr2jWyNZjk6B2vNYIBEH3XQErYN13Ykm4FJUs=;
 b=Zlv2XlJuz6/fCPCbkjkdKdtC2znDykQM3UFbYGmy4kBiBC8s+jcM0RFkq9uFdyc5rbbqG3
 Wr+LT7/zpa0qNOfQ2Fz4ZcN9mj29PQGO5aJrSZBgJGAV31aYToreF5RajXMQATXtem+MNX
 9svEyhKifRefQcLShB2HvLCt1vOqCqI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-vdZCXE9XMUKvmBIm-MvPUQ-1; Tue, 07 Sep 2021 14:18:37 -0400
X-MC-Unique: vdZCXE9XMUKvmBIm-MvPUQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 o14-20020a1709062e8e00b005d37183e041so4078553eji.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LUu7mpwr2jWyNZjk6B2vNYIBEH3XQErYN13Ykm4FJUs=;
 b=XZ0Ha8vmlAXZ4eVjC747JGjdgRMsUUetz4CDcjNp9A2+ypaI2Y78LmSXsywrR0qSgc
 ewwknNCyoKyP0hFs1EyGFHEPKKrOzDhB0MNW7AvG10bH6JI/w60TUkYo8+7pZM41f/oN
 lckQeJv+Cle7STGhaUms48Kby3COXNqfk+jKvGdh2c/I7Pq8KrHT1wC4+AsTmfeG9XSC
 rCJKGr1woaOq1yhISTYOrK1ipo5jYkDmSaH4jbYkqcFwY+oAENkteEOkpgdJY9PTmvVb
 z/pNCWoyQ91uJj5E+BUGibgndi+i0cmCi9QN4P3MUZvvEHL4DKhcWD3SLTzm6PXECDXZ
 Y0JQ==
X-Gm-Message-State: AOAM531xY9VeARej2+EGX2Jf7dusaHRAAtzsCbqgl8ceXiaNddiHNapb
 LzhqlG8inmIqnhnbTCx6LAXxZ8dJI2qXrYkRFmTkJRRzwtmy14O1aX+wPvV6VBp7Fs+K+QSxDbW
 WUJQkARREH+HArf/wod6Pdrkg
X-Received: by 2002:a17:906:6dcb:: with SMTP id
 j11mr19706636ejt.202.1631038716449; 
 Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ16MXBVuMZi4LPFWDJ41bJqO5hzeQF793u0WWbWMrnfuEmtTm1ev6ELecKdk1XtNTMtystg==
X-Received: by 2002:a17:906:6dcb:: with SMTP id
 j11mr19706624ejt.202.1631038716320; 
 Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id p16sm6895261eds.63.2021.09.07.11.18.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 11:18:36 -0700 (PDT)
Date: Tue, 7 Sep 2021 20:18:34 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <20210907181834.uqecqygvvlvmetbl@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907180957.609966-3-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210907180957.609966-3-ricarkol@google.com>
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

On Tue, Sep 07, 2021 at 11:09:57AM -0700, Ricardo Koller wrote:
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5832f510a16c..5ed203b9314c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -92,6 +92,8 @@ TEST_GEN_PROGS_aarch64 += dirty_log_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
>  TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>  TEST_GEN_PROGS_aarch64 += kvm_page_table_test
> +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> +TEST_GEN_PROGS_aarch64 += memslot_perf_test
>  TEST_GEN_PROGS_aarch64 += set_memory_region_test
>  TEST_GEN_PROGS_aarch64 += steal_time
>  TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
