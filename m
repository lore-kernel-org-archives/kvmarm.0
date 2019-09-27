Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DE8C32774
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:42:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B573E2146E
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B573E2146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D344A743;
	Fri, 27 Sep 2019 06:42:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u7YspEvljSZQ; Fri, 27 Sep 2019 06:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DEF4A735;
	Fri, 27 Sep 2019 06:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78EAA4A728
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UcCr-SxQGCgz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 06:42:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7684A700
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:42:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF95728;
 Fri, 27 Sep 2019 03:42:33 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B2FC3F534;
 Fri, 27 Sep 2019 03:42:33 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 0/6] arm: Use stable test output lines
Date: Fri, 27 Sep 2019 11:42:21 +0100
Message-Id: <20190927104227.253466-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When using kvm-unit-tests inside automated testing frameworks,
variable test naming becomes a problem. Some frameworks recognise tests
by their test output line and group the outputs from various runs for
statistical and reporting purposes. Having variable output like timer
values in there spoils this approach. Also the test name should be
somewhat self-explanatory, which is not true for every test.
Some examples highlighting the problem (TAP output from run-tests.sh -t):
ok 1 - selftest: setup: smp: nr_cpus = 2
ok 2 - selftest: setup: mem: size = 256 MB
ok 8 - selftest: smp: CPU(  1) mpidr=0080000001
ok 9 - selftest: smp: CPU(  2) mpidr=0080000002
ok 54 - gicv2: mmio: ITARGETSR: byte writes successful (0x1f => 0x01010001)
ok 55 - gicv2: mmio: all 3 CPUs have interrupts
ok 73 - invalid-function
ok 76 - cpu-on
ok 90 - ptimer-busy-loop: timer has expired (-8445)

This series aims to fix most of the problems, by making the actual test
report output line stable. I think this is best practises in the testing
world, at least when using TAP. We still retain the full information, by
moving every variable output into INFO: lines (which are still logged,
but typically filtered for automated processing).
The above lines now look like this:
ok 1 - selftest: setup: smp: number of CPUs matches expectation
ok 2 - selftest: setup: mem: memory size matches expectation
ok 8 - selftest: smp: MPIDR test on all CPUs
ok 49 - gicv2: mmio: ITARGETSR: byte writes successful
ok 50 - gicv2: mmio: all CPUs have interrupts
ok 68 - psci: invalid-function
ok 71 - psci: cpu-on
ok 85 - ptimer-busy-loop: timer has expired

Looks a bit more boring, but it's nicer for automated processing and
logging.

I am open for a discussion about the general approach, thus this is
dealing with ARM tests for now only.

Looking forward to any feedback!

Cheers,
Andre

Andre Przywara (6):
  arm: gic: check_acked: add test description
  arm: gic: Split variable output data from test name
  arm: timer: Split variable output data from test name
  arm: selftest: Split variable output data from test name
  arm: selftest: Make MPIDR output stable
  arm: Add missing test name prefix calls

 arm/gic.c      | 64 ++++++++++++++++++++++++++++++--------------------
 arm/pci-test.c |  2 ++
 arm/psci.c     |  2 ++
 arm/selftest.c | 23 ++++++++++++++----
 arm/timer.c    |  3 ++-
 5 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
