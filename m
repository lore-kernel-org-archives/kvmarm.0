Return-Path: <SRS0=qFti=EC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD4DC4363A
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:18:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B8BD22265
	for <kvmarm@archiver.kernel.org>; Tue, 27 Oct 2020 17:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B8BD22265
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAC104B203;
	Tue, 27 Oct 2020 13:18:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4HUDf1MrdgHa; Tue, 27 Oct 2020 13:18:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A95E84B20C;
	Tue, 27 Oct 2020 13:18:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 962624B20C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IYgM0kgUi93 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Oct 2020 13:18:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CADE4B203
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Oct 2020 13:18:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42D05139F;
 Tue, 27 Oct 2020 10:18:46 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEE5C3F719;
 Tue, 27 Oct 2020 10:18:43 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 0/5] arm64: Statistical Profiling
 Extension Tests
Date: Tue, 27 Oct 2020 17:19:39 +0000
Message-Id: <20201027171944.13933-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Cc: pbonzini@redhat.com
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

This series implements two basic tests for KVM SPE: one that checks that
the reported features match what is specified in the architecture,
implemented in patch #3 ("arm64: spe: Add introspection test"), and another
test that checks that the buffer management interrupt is asserted
correctly, implemented in patch #5 ("am64: spe: Add buffer test"). The rest
of the patches are either preparatory patches, or a fix, in the case of
patch #2 ("lib/{bitops,alloc_page}.h: Add missing headers").

This series builds on Eric's initial version [1], to which I've added the
buffer tests that I used while developing SPE support for KVM.

KVM SPE support is current in RFC phase, hence why this series is also sent
as RFC. The KVM patches needed for the tests to work can be found at [2].
Userspace support is also necessary, which I've implemented for kvmtool;
this can be found at [3]. This series is also available in a repo [4] to make
testing easier.

[1] https://www.spinics.net/lists/kvm/msg223792.html
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3
[3] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
[4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v2

Alexandru Elisei (3):
  lib/{bitops,alloc_page}.h: Add missing headers
  lib: arm/arm64: Add function to unmap a page
  am64: spe: Add buffer test

Eric Auger (2):
  arm64: Move get_id_aa64dfr0() in processor.h
  arm64: spe: Add introspection test

 arm/Makefile.arm64        |   1 +
 lib/arm/asm/mmu-api.h     |   1 +
 lib/arm64/asm/processor.h |   5 +
 lib/alloc_page.h          |   2 +
 lib/bitops.h              |   2 +
 lib/libcflat.h            |   1 +
 lib/arm/mmu.c             |  32 +++
 arm/pmu.c                 |   1 -
 arm/spe.c                 | 506 ++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |  15 ++
 10 files changed, 565 insertions(+), 1 deletion(-)
 create mode 100644 arm/spe.c

-- 
2.29.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
