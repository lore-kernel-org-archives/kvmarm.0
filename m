Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EF8C43460
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 18:31:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FAD761446
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 18:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FAD761446
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81EB14B86D;
	Fri, 14 May 2021 14:31:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Gu1kEEIbhcV; Fri, 14 May 2021 14:31:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6859D4B58A;
	Fri, 14 May 2021 14:31:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F36A4B4E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 14:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pPhVbaTClaEC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 14:31:19 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50FED4B2FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 14:31:19 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id d16so325059pfn.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 11:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9E0wuTet4JopXThnpnWVLzmH9GIGkngbwCTAn/avRcg=;
 b=goRBrZkKl2sbgciLAmD3ktsJwV7wNxZ1BcVR788hJtYJTxhgb8RdlnM/1V3wuvVXAE
 jhqJR10uPQLiGkT/WpT5P9HxbS8k9PdfZTd7dQoNCOtX1I/4fnVwPvwOc8mMYLpimbqm
 1ua3Pf20dPMTZAApXbRkY17Ny9Mr1dQTtX0NUY9/HvNWM16HaqJUUi65R0+6DEn+Fu7y
 TngnjP2wi99y49A900MYT55pnrGfD8d3t7kcig3puEWydknkswKr6OqUtgVPWbXeRBwS
 GrqF9Won5bad3AQb/00v75asUB6Le8JHJy60aqCDu2qo13f5rAbAntXHBtZj4xUOFiSz
 dTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9E0wuTet4JopXThnpnWVLzmH9GIGkngbwCTAn/avRcg=;
 b=LSWRI6NN0j76bpb50yQN/SKJF6J3qVmpbAGvVPC3Gp78jwzQHzdWvuzW0ntWu1r52m
 5IcepkyRyi2N25T1mfR6oNdHNTqnyjyvtwD6p+5R334zce9zqHpOIYHt0rRQ6tAiwTh3
 RgEkty95ntFWmAo8f/Flfz7Mq0SUa/3l9zvVY6scZkLcEzKUpEcJVXFyR1mBZ9R2N+vM
 stPfHGLKMcHzyYEFINF0qiBGlbb+OLL2jzOVRtQbdBBqeup78aA5Nm6Y4lpb3V54RpPB
 b/uAKk2FOf1qQMMS/792WyQO6X0GQtYJsELmP0Fo8nl57dcuzoc7BSBLH4QPMhds65Wr
 nERQ==
X-Gm-Message-State: AOAM531uoroUpp+MkeFa+8K3uU+CUVCBKcWaFIcJ24kHPCd0gVrejXh4
 BBNrXrBYy5iGa32lJNO7dZcbdg==
X-Google-Smtp-Source: ABdhPJzk7gYz4Qlli53km2eo6kviqemudDpAU62A2i0TNtr4F5m6ss+yMWkSWLn48joRzCEHlSSr2g==
X-Received: by 2002:aa7:9a81:0:b029:28e:b12c:9862 with SMTP id
 w1-20020aa79a810000b029028eb12c9862mr47973754pfi.51.1621017078283; 
 Fri, 14 May 2021 11:31:18 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id e2sm5038138pjk.31.2021.05.14.11.31.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 May 2021 11:31:17 -0700 (PDT)
Date: Fri, 14 May 2021 11:31:13 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and
 debug test
Message-ID: <YJ7B8TCwvzxJLJH/@google.com>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <aeeec52e-5a13-be39-3b9c-cf25a27b97b1@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <aeeec52e-5a13-be39-3b9c-cf25a27b97b1@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Thu, May 13, 2021 at 08:37:33AM +0200, Auger Eric wrote:
> Hi Ricardo,
> 
> On 5/13/21 2:27 AM, Ricardo Koller wrote:
> > Hi,
> > 
> > These patches add a debug exception test in aarch64 KVM selftests while
> > also adding basic exception handling support.
> > 
> > The structure of the exception handling is based on its x86 counterpart.
> > Tests use the same calls to initialize exception handling and both
> > architectures allow tests to override the handler for a particular
> > vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> > 
> > The debug test is similar to x86_64/debug_regs, except that the x86 one
> > controls the debugging from outside the VM. This proposed arm64 test
> > controls and handles debug exceptions from the inside.
> > 
> > Thanks,
> > Ricardo
> > 
> > v2 -> v3:
> > 
> > Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
> > the reviews and tests from Eric and Zenghui.
> You are welcome. This version does not fail anymore on Cavium Sabre so
> this looks to fix the previously reported issue.
> 
> Thanks

Great, thanks Eric. The issue was that writing to mdscr needed ISBs
afterward (discovered by Zenghui).

> 
> Eric
> > - add missing ISBs after writing into debug registers.
> > - not store/restore of sp_el0 on exceptions.
> > - add default handlers for Error and FIQ.
> > - change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
> > - use Andrew's suggestion regarding __GUEST_ASSERT modifications
> >   in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).
> > 
> > v1 -> v2:
> > 
> > Addressed comments from Andrew and Marc (thank you very much):
> > - rename vm_handle_exception in all tests.
> > - introduce UCALL_UNHANDLED in x86 first.
> > - move GUEST_ASSERT_EQ to common utils header.
> > - handle sync and other exceptions separately: use two tables (like
> >   kvm-unit-tests).
> > - add two separate functions for installing sync versus other exceptions
> > - changes in handlers.S: use the same layout as user_pt_regs, treat the
> >   EL1t vectors as invalid, refactor the vector table creation to not use
> >   manual numbering, add comments, remove LR from the stored registers.
> > - changes in debug-exceptions.c: remove unused headers, use the common
> >   GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> > - changes in processor.h: write_sysreg with support for xzr, replace EL1
> >   with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> > 
> > Ricardo Koller (5):
> >   KVM: selftests: Rename vm_handle_exception
> >   KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
> >     reporting
> >   KVM: selftests: Move GUEST_ASSERT_EQ to utils header
> >   KVM: selftests: Add exception handling support for aarch64
> >   KVM: selftests: Add aarch64/debug-exceptions test
> > 
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   3 +-
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
> >  .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
> >  .../selftests/kvm/include/x86_64/processor.h  |   4 +-
> >  .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++
> >  .../selftests/kvm/lib/aarch64/processor.c     | 131 +++++++++
> >  .../selftests/kvm/lib/x86_64/processor.c      |  22 +-
> >  .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
> >  .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
> >  .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
> >  13 files changed, 615 insertions(+), 47 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
