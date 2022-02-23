Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E25DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 12:57:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C254C3FA;
	Wed, 23 Feb 2022 07:57:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Rg4fV8iz23w; Wed, 23 Feb 2022 07:57:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 869B14C4F3;
	Wed, 23 Feb 2022 07:57:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BC54C3F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:57:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 67sXQA8RFYxa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 07:57:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E75BF4C256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 07:57:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C22EED1;
 Wed, 23 Feb 2022 04:57:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E283F70D;
 Wed, 23 Feb 2022 04:57:12 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
 varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 0/3] configure changes and rename
 --target-efi
Date: Wed, 23 Feb 2022 12:55:34 +0000
Message-Id: <20220223125537.41529-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

The first two patches are fixes for stuff I found while working on patch
#3.

Patch #3 ("Rename --target-efi to --[enable|disable]-efi") is where the
configure option --target-efi gets renamed.

Changes in v2:

* Dropped what was patch #3, which made arm/arm64 configure option
  --target available to all architectures.

* Renamed --target-efi to --[enable|disable]-efi instead of --efi-payload.

Alexandru Elisei (3):
  configure: Fix whitespaces for the --gen-se-header help text
  configure: Restrict --target-efi to x86_64
  Rename --target-efi to --[enable|disable]-efi

 Makefile             | 10 +++-------
 configure            | 22 +++++++++++++++-------
 lib/x86/acpi.c       |  4 ++--
 lib/x86/amd_sev.h    |  4 ++--
 lib/x86/asm/page.h   |  8 ++++----
 lib/x86/asm/setup.h  |  4 ++--
 lib/x86/setup.c      |  4 ++--
 lib/x86/vm.c         | 12 ++++++------
 scripts/runtime.bash |  4 ++--
 x86/Makefile.common  |  6 +++---
 x86/Makefile.x86_64  |  6 +++---
 x86/access_test.c    |  2 +-
 x86/efi/README.md    |  2 +-
 x86/efi/run          |  2 +-
 x86/run              |  4 ++--
 15 files changed, 49 insertions(+), 45 deletions(-)

-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
