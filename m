Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DD4C48BE6
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 07:40:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E39FB610A2
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 07:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E39FB610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3429240874;
	Mon, 14 Jun 2021 03:40:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kkHWr6HSI0hj; Mon, 14 Jun 2021 03:40:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 159A840CF8;
	Mon, 14 Jun 2021 03:40:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5155B40856
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 03:40:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+infuwGgiiK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 03:40:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E35240667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 03:40:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623656449;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3vluf07n1e9CMotPaBeCeLpe5If4SME3MyJJJYYovH4=;
 b=eSttsqFmsNX4R+j+uF51ncYMq3gFA5g8kZt5qtwtabSt/ymNeg3DsFyqq+JfDOZcQ+KfTD
 9gQWTtCwCBAzQ1Tmnkh7NPSNQ+4Z9zmR1IflxqE2rO48VlGvVo8KONX/4UG2GyOQcrhaTg
 noxnv00fEVxn4SG1kQvi1IN1vqMGDTs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-r_HBa_ozMyyWmbRJLtdebQ-1; Mon, 14 Jun 2021 03:40:48 -0400
X-MC-Unique: r_HBa_ozMyyWmbRJLtdebQ-1
Received: by mail-ej1-f72.google.com with SMTP id
 n19-20020a1709067253b029043b446e4a03so2689522ejk.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 00:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3vluf07n1e9CMotPaBeCeLpe5If4SME3MyJJJYYovH4=;
 b=a1u5J0pDvdkMF+MtCC2ivggV3E4Sidt0JpnvyvqJS2b/I/51BGJh/XcNfcSVGp7EJy
 01oaVvhOYH8lApgfYNK+qUdBwkk7fDZcMNsIwY2TySCIKTagV1Mn3AHfGuOm8yrhh0Ak
 IMxmqd+BlFAQdNKxc5VnuHspzgHgVrdVeK+POKnZaQ72LI8cB5sU4aERKfXt5K1L+Xwg
 SnTTlDLQnynUfngfN+VYeNnOBW71Qs0wt0QTBaqrhSwo4xEYiPl5gxQ4ORwq9h/l+rOw
 vzTiQqG3LjCCV97Tn6z/hP5NgDDSeZUpTU5vT1eblE+0oFy/99J4edIUu0SOhMJ1X9hJ
 PgZA==
X-Gm-Message-State: AOAM532vRYSI2nMMbuUVp2iEk8NYliGw6jEsDI4FXKpvZScn+72P5RDS
 ty172AHox0Rtr30HvxqrR44qTpASEThuzVAVWJoxRqQzbvWr9HF0kY9jZ05VM5da76174+GHt+k
 JxReuf8d0U2to+lpI4EVsKf3y
X-Received: by 2002:a05:6402:4395:: with SMTP id
 o21mr15611037edc.163.1623656447250; 
 Mon, 14 Jun 2021 00:40:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXFlZ+swOY5PozQnD2lwcOa9P4NfPBGblip0aRW2ve2FhR7KJrAMeV3SRvrOwFQafoV2qa0A==
X-Received: by 2002:a05:6402:4395:: with SMTP id
 o21mr15611021edc.163.1623656447053; 
 Mon, 14 Jun 2021 00:40:47 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id c19sm7910388edw.10.2021.06.14.00.40.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Jun 2021 00:40:46 -0700 (PDT)
Date: Mon, 14 Jun 2021 09:40:44 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and
 debug test
Message-ID: <20210614074044.vntupqsiuqmqobsy@gator>
References: <20210611011020.3420067-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 10, 2021 at 06:10:14PM -0700, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo
> 
> v3 -> v4:
> 
> V3 was dropped because it was breaking x86 selftests builds (reported by
> the kernel test robot).
> - rename vm_handle_exception to vm_install_sync_handler instead of
>   vm_install_vector_handlers. [Sean]
> - use a single level of routing for exception handling. [Sean]
> - fix issue in x86_64/sync_regs_test when switching to ucalls for unhandled
>   exceptions reporting.
> 
> v2 -> v3:
> 
> Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
> the reviews and tests from Eric and Zenghui.
> - add missing ISBs after writing into debug registers.
> - not store/restore of sp_el0 on exceptions.
> - add default handlers for Error and FIQ.
> - change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
> - use Andrew's suggestion regarding __GUEST_ASSERT modifications
>   in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).
> 
> v1 -> v2:
> 
> Addressed comments from Andrew and Marc (thank you very much):
> - rename vm_handle_exception in all tests.
> - introduce UCALL_UNHANDLED in x86 first.
> - move GUEST_ASSERT_EQ to common utils header.
> - handle sync and other exceptions separately: use two tables (like
>   kvm-unit-tests).
> - add two separate functions for installing sync versus other exceptions
> - changes in handlers.S: use the same layout as user_pt_regs, treat the
>   EL1t vectors as invalid, refactor the vector table creation to not use
>   manual numbering, add comments, remove LR from the stored registers.
> - changes in debug-exceptions.c: remove unused headers, use the common
>   GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> - changes in processor.h: write_sysreg with support for xzr, replace EL1
>   with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> 
> Ricardo Koller (6):
>   KVM: selftests: Rename vm_handle_exception
>   KVM: selftests: Complete x86_64/sync_regs_test ucall
>   KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
>     reporting
>   KVM: selftests: Move GUEST_ASSERT_EQ to utils header
>   KVM: selftests: Add exception handling support for aarch64
>   KVM: selftests: Add aarch64/debug-exceptions test
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
>  .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
>  .../selftests/kvm/include/x86_64/processor.h  |   4 +-
>  .../selftests/kvm/lib/aarch64/handlers.S      | 126 +++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     |  97 +++++++
>  .../selftests/kvm/lib/x86_64/processor.c      |  23 +-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |   4 +-
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
>  .../selftests/kvm/x86_64/sync_regs_test.c     |   7 +-
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
>  .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
>  15 files changed, 592 insertions(+), 50 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 
> -- 
> 2.32.0.272.g935e593368-goog
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
