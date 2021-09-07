Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D858DC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:17:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6534361100
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6534361100
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D22844B0C3;
	Tue,  7 Sep 2021 14:17:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QjM3ox5Rz-kA; Tue,  7 Sep 2021 14:17:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D341D4B0D7;
	Tue,  7 Sep 2021 14:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 120664B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:17:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ABDFp6HTft0d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:17:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A844B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:17:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631038661;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=VSRbOlY+OHZP5PtEtcC0z8g882/C6wUmRhyO/ff6igM=;
 b=SuPtcux2xgsXHdal657FWJGy47b6x4JCrQ6yOUJhWFevfjs6iepIAHy/lB5JsVw0oT8B0j
 vavdf40eeiul/OHm9PtcByD6UrdjFpcS00repK027iGEbClsbMVjY7lkr4O+emeNuq2vyZ
 Hj2PNDfSslZxWgsRMD2luUe+Tn/e8z4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-78_d-ooMNACHzNIAdkTe4Q-1; Tue, 07 Sep 2021 14:17:40 -0400
X-MC-Unique: 78_d-ooMNACHzNIAdkTe4Q-1
Received: by mail-ed1-f71.google.com with SMTP id
 y19-20020a056402441300b003cd8ce2b987so5765912eda.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VSRbOlY+OHZP5PtEtcC0z8g882/C6wUmRhyO/ff6igM=;
 b=eoP8S8U8QbaOdfFAmfLSk60r/pI5pNrUkaQYfVXKum4gmge5ET42tJIzwow3/edUeU
 e3SQ93gLclNFgyuuSyiggM8fmAJXTBOvH/rKRk+I9eYBU3NMjUBOhK8Oaqv+7KyBU/9B
 PHcGjb09O2NXYe7FGHy2wkgG8N8WWdpwX39f3twXXSCqEaUMovu+3cFy+4cfvdFQu4cR
 O7nZ9jqnoloqkyfg8NNFcIzyjkTFkPoKNUGBjxScjtGT/p8gVtDuHo9/4XKexN+YNC0o
 AhEz3n/z5TJUIfb8dYDGF+/HVSfaoycgX86Rckee1/wBRd4LJR9WIpNA3dj6JnNwheLM
 zTFw==
X-Gm-Message-State: AOAM533isJzuoHQkOQsYDhXHOL7uahvX7ZfugU+Zn5097ywvmWUpGY/D
 c3X7oLafnlyJ/FqAu+pKWFP/AwXEPYMXoswcKITL6BzFjOI4EJzIr5UvY7UKPwV9G/wLNRLn4R8
 n0epBuDFVLN9SyK19w2cI62OL
X-Received: by 2002:a50:bae1:: with SMTP id x88mr794588ede.345.1631038659288; 
 Tue, 07 Sep 2021 11:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaCEmwQmWDQZJpKuWe8E9uHqzGgJWY6tNPoUhVwCP6oeVzBnMbBzTJRsKnGs5tkZpfATBS/A==
X-Received: by 2002:a50:bae1:: with SMTP id x88mr794565ede.345.1631038659056; 
 Tue, 07 Sep 2021 11:17:39 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id e18sm5706473ejx.46.2021.09.07.11.17.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 11:17:38 -0700 (PDT)
Date: Tue, 7 Sep 2021 20:17:37 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <20210907181737.jrg35l3d342zgikt@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210907180957.609966-1-ricarkol@google.com>
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

On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> (second patch). memslot_modification_stress_test builds and runs in
> aarch64 without any modification. memslot_perf_test needs some nits
> regarding ucalls (first patch).
> 
> Can anybody try these two tests in s390, please?
> 
> Changes:
> v2: Makefile tests in the right order (from Andrew).

Hi Ricardo,

You could have collected all the r-b's too.

Thanks,
drew

> 
> Ricardo Koller (2):
>   KVM: selftests: make memslot_perf_test arch independent
>   KVM: selftests: build the memslot tests for arm64
> 
>  tools/testing/selftests/kvm/Makefile          |  2 +
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
