Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37255C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 17:39:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F64161102
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 17:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9F64161102
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6324B168;
	Tue,  7 Sep 2021 13:39:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1GO+bFsCEKS8; Tue,  7 Sep 2021 13:39:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236224B187;
	Tue,  7 Sep 2021 13:39:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74E34B168
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 13:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XNJQjF5mj4pq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 13:39:09 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D326C4B167
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 13:39:08 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id j16so8745238pfc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=N9XNca23yCVuMer6cozayHgHWR6STLiyzFjRVxePEPo=;
 b=EnarTh7cut0Nbx0XzOOv0XDmjBrKae2D4uyjc/WmVXkkwMc04IdFdV1WvtAkSa/ZX6
 FQGBRMyZ6OamW7FeDIUHjTeCvrGMdmkFS8t8+7/ElllUPFIf+0LaGEWOSzpSYS+plt6O
 clF31dL7Et0RmMVQX0PAJSZTaGL6mL19CCUQVhSn7mR1r4FiwPtkSVJMYv0sQZtsa0vG
 b28WEb5XklDYSaOBi/SnChi30NUWzB7T52XEZv6tCgMvQEi5NBFOKYeksSyDyugFx7Y2
 AsAB9Kyh4zxlHLTtHLfNyYtsDjPTh6WfPpAmow9HtvFcvCo0//J0yUNWiWy8lwBgNDOx
 A98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=N9XNca23yCVuMer6cozayHgHWR6STLiyzFjRVxePEPo=;
 b=TKlpiIV0hI+PuQudCYw8/o5Nmu/hD0o+I7bNDtD1kdETjdMzw0st2qSo1F3Kzu5ZIV
 rBkJo+AeceO/Dg6q+0vboEz18bS5l/xBMF5juOgZhKVAez/7h4w9vqzGHTz9LkJmPV/v
 xS+wvMu0wSU76ddjh+KIeDEU+72lW7q1GyldqkZm2a3xVrXNAn9JTxAa/lIPbxNZjBd9
 EBD0M1Fb8ndLClICX2NfB7SqswhEmR4Tk28LXtzME98Y10c6i+gIDEFDrr0xinWDVFFJ
 7Q26xoEc2fShWF1Px4jy5agwpwCgvDXcMVuqcP9uwrR0zDKZj5D8xiaCB95QF9Ennj2/
 XJYw==
X-Gm-Message-State: AOAM53212MHE64UR88cl5CwlyGyhlVJS2S2h5OIb+sXCJuwTZSQsSOTi
 Z6CxqAlwcXKcBuynP9hI+6NGcw==
X-Google-Smtp-Source: ABdhPJzJIhKu/IIbm9AjhTgNXpclcGvl/MPPLV0Ct7sfXulKZXpHFLz2PYWzXiC+ypD//jzEhwqqMg==
X-Received: by 2002:a63:7c58:: with SMTP id l24mr17796563pgn.464.1631036347761; 
 Tue, 07 Sep 2021 10:39:07 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id l1sm3130985pju.15.2021.09.07.10.39.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 10:39:07 -0700 (PDT)
Date: Tue, 7 Sep 2021 10:39:03 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
Message-ID: <YTejt+fOxK9iUwn2@google.com>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-3-ricarkol@google.com>
 <20210906065248.c57sluz2764ixe7u@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210906065248.c57sluz2764ixe7u@gator.home>
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

On Mon, Sep 06, 2021 at 08:52:48AM +0200, Andrew Jones wrote:
> On Fri, Sep 03, 2021 at 04:11:54PM -0700, Ricardo Koller wrote:
> > Add memslot_perf_test and memslot_modification_stress_test to the list
> > of aarch64 selftests.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5832f510a16c..e6e88575c40b 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -84,6 +84,8 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
> >  TEST_GEN_PROGS_x86_64 += steal_time
> >  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  
> > +TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
> > +TEST_GEN_PROGS_aarch64 += memslot_perf_test
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> 
> These tests need to be added below the aarch64/* tests and in alphabetical
> order.
> 

Sure, will fix this in v2.

Thanks,
Ricardo

> Thanks,
> drew
> 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
