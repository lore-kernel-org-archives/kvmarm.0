Return-Path: <SRS0=R38U=L2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA3AC11F68
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BEEB61423
	for <kvmarm@archiver.kernel.org>; Fri,  2 Jul 2021 16:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BEEB61423
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177FE4B096;
	Fri,  2 Jul 2021 12:30:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WIpclXPudbVk; Fri,  2 Jul 2021 12:30:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCBC34A588;
	Fri,  2 Jul 2021 12:30:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C74C4A195
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0sNUtxf9fwVW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jul 2021 12:30:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABAA40895
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jul 2021 12:30:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CD1DD6E;
 Fri,  2 Jul 2021 09:30:31 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D39A3F5A1;
 Fri,  2 Jul 2021 09:30:29 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
 lvivier@redhat.com, kvm-ppc@vger.kernel.org, david@redhat.com,
 frankja@linux.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 0/5] arm: Add kvmtool to the runner script
Date: Fri,  2 Jul 2021 17:31:17 +0100
Message-Id: <20210702163122.96110-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Cc: vivek.gautam@arm.com, andre.przywara@arm.com, maz@kernel.org
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

kvm-unit-tests has support for running arm64 tests under kvmtool since
2019. However, each test had to be run manually since the runner script was
blissfully unware of other VMMs beside qemu.

This series aims to support running all the tests automatically with
kvmtool, like it has always been possible to do with qemu by invoking:

$ ./run_tests.sh

The runner script will choose kvmtool as the VMM if the tests has been
configured with the kvmtool target.

I see several advantages to being able to use kvmtool alongside qemu:

- kvmtool is smaller and a lot easier to hack than qemu, which means it may
  be possible for developers to prefer it over qemu when adding new
  features to KVM. Being able to run all the tests reliably and
  automatically is useful in the development process.

- kvmtool runs all the tests faster than qemu (roughly 3 times faster on
  4xA53s). I think this is another nice feature for development.

- kvmtool does things differently than qemu: different memory layout,
  different uart, PMU emulation is optional, etc. This makes it a good
  testing vehicule for kvm-unit-tests.

This series is an RFC for various reasons:

- The migration tests work under kvmtool because when kvm-unit-tests
  writes something to the UART (like "Now migrate the VM, then press a key
  a key to continue...\n"), a read will return the last character that was
  written (newline, in this case). I don't know if this is a feature or a
  bug with the kvm-unit-tests UART mini-driver or with kvmtool, and I'm
  investigating it.

- I've tried to keep the changes as small as possible, but I would like
  some feedback about my approach, as I am not very familiar with bash
  scripting.

- The series needs more testing. I've only tested the patches on a
  rockpro64 with qemu and kvmtool, and on my Ryzen amd64
  machine (qemu only, --target=kvmtool is available only for arm/arm64).

TODO:

- More testing, especially on powerpc and s390x which are touched in patch #2.
- README changes to reflect kvmtool support for the runner script.
- Figure out how to handle migration tests under kvmtool.

Comments welcome and much appreciated.

Alexandru Elisei (5):
  lib: arm: Print test exit status on exit if chr-testdev is not
    available
  scripts: Rename run_qemu_status -> run_test_status
  run_tests.sh: Add kvmtool support
  scripts: Generate kvmtool standalone tests
  configure: Ignore --erratatxt when --target=kvmtool

 scripts/arch-run.bash   |  50 ++++++++++++++++--
 scripts/runtime.bash    |  94 ++++++++++++++++++++++++++++------
 scripts/mkstandalone.sh |   9 +++-
 arm/run                 | 110 ++++++++++++++++++++++++----------------
 powerpc/run             |   2 +-
 s390x/run               |   2 +-
 run_tests.sh            |  11 +++-
 configure               |  26 +++++++---
 lib/chr-testdev.h       |   1 +
 lib/arm/io.c            |  10 +++-
 lib/chr-testdev.c       |   5 ++
 11 files changed, 243 insertions(+), 77 deletions(-)

-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
