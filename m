Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA28C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 20:52:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA4406109D
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 20:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA4406109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5834ACC9;
	Tue,  7 Sep 2021 16:52:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hb2cGmH0GAb0; Tue,  7 Sep 2021 16:52:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6454B08B;
	Tue,  7 Sep 2021 16:52:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C404B08B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 16:52:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrJTS4xPb0gX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 16:52:26 -0400 (EDT)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A35A04ACC9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 16:52:26 -0400 (EDT)
Received: by mail-pl1-f179.google.com with SMTP id e7so6585341plh.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 13:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZD4j0dIbXDPxZzB5zy3lU+EMIURf4JISQ9XraoRzmVE=;
 b=gs6NtmfnkLqF9NVivjccT/E1NM1MuGNlQW4c1ayJ8Z6wS1p43MFIKGf+qz+2YzaBi5
 cjFMNmIH+QwmLP0myg/0tYxRZBel2yEaQ8FT8eYHdmebz5CU2rBzEhgn3AWt40v1G7G/
 db3kL5u9qkAgwfHDm1mt9I/HfhgBw8VIB7MyyRJXxZePCpncWHRotTBSDZ8oa+cFR/hC
 Sk+lUc1Q9NJp7oJooz3BQ76611abiiunlfiUC9MeJAIg5fMRF+aPhfWKNNvaGPUCUxCS
 oXxwwSOElaIoXrofOXZBbb3y1UwCNgK9IpSGbB3jAJBXwiD3peBx+hFsFsPimE7B2gRN
 n7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZD4j0dIbXDPxZzB5zy3lU+EMIURf4JISQ9XraoRzmVE=;
 b=UL+rxDEmryGnJSc4TnwAXu6Io9ayYHRbYuuaQHl0aVlUSo+xOYSlgLBJMMRRprbUlD
 RJxWh5xl4HOssiY3VVP3a5cqwzWpf8BQZsWGTIbH7+TvD8bsZQQMxJNy2umezUWw1BCW
 YWyU9XNCummwF4zhq4bIhnvlE2perg6lAsLaQ3Qjjihyb0toF4OQqV8hjblWbvkP1VKd
 H92PJcyGo5KkzeMNBXor8B7cgdfvg/xpwQzMb1gO8pIMJyVQSuYX8kncuCIan8s9PYQl
 EAi6ENGnUxv4nC4MiZ3iqiZ8JQ99whXuA207ZbeeljC7urAfnDrhV9IjvtfXTbigX4+l
 8s8Q==
X-Gm-Message-State: AOAM533Q4g7eUAVJXcq9zqJRBDUg8gJreeSKBWR1xaTEtnFLkxZ3Ll/i
 bJeEyysyKtJuasPpVD7BXKjD1Q==
X-Google-Smtp-Source: ABdhPJyC9Rx5xBdPvu6Zi/Z25HeneZXtf+yUR+/2WJKZ4jkwTOc1Gz9L+IBv/EcXZiBZ+PDxdv5Haw==
X-Received: by 2002:a17:90b:224f:: with SMTP id
 hk15mr343120pjb.134.1631047945599; 
 Tue, 07 Sep 2021 13:52:25 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h8sm7120pfr.219.2021.09.07.13.52.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 13:52:25 -0700 (PDT)
Date: Tue, 7 Sep 2021 13:52:21 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <YTfRBSs3Y1OjNH5u@google.com>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907181737.jrg35l3d342zgikt@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210907181737.jrg35l3d342zgikt@gator.home>
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

On Tue, Sep 07, 2021 at 08:17:37PM +0200, Andrew Jones wrote:
> On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> > Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> > (second patch). memslot_modification_stress_test builds and runs in
> > aarch64 without any modification. memslot_perf_test needs some nits
> > regarding ucalls (first patch).
> > 
> > Can anybody try these two tests in s390, please?
> > 
> > Changes:
> > v2: Makefile tests in the right order (from Andrew).
> 
> Hi Ricardo,
> 
> You could have collected all the r-b's too.

Thanks Andrew. Will try to do it next time (if changes are small like
in this patch set.

Thanks,
Ricardo

> 
> Thanks,
> drew
> 
> > 
> > Ricardo Koller (2):
> >   KVM: selftests: make memslot_perf_test arch independent
> >   KVM: selftests: build the memslot tests for arm64
> > 
> >  tools/testing/selftests/kvm/Makefile          |  2 +
> >  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
> >  2 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
