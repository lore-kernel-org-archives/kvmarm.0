From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 0/2] Support micro operation measurement on
 arm64
Date: Mon,  3 Sep 2018 14:20:00 +0200
Message-ID: <20180903122002.569-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A953A4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 08:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HPYYBhN+uSqm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 08:20:05 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D51EA4A1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 08:20:05 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

I dropped the version numbers, but this is v4 of Shih-Wei Li's series of
the same name, last posted in January. I took the liberty of
incorporating all the comments v3 had, plus making some other cleanup
tweaks. These tests are too nice to let them slip away, let's get them
reviewed and merged.

v2:
 - add missing 'L' in 'UL' for PS_PER_SEC. There's a lot of picoseconds
   in a second!

Thanks,
drew

*** BLURB HERE ***

Shih-Wei Li (2):
  arm/arm64: add GICD_IIDR definition
  arm64: add micro-bench

 arm/Makefile.arm64 |   1 +
 arm/micro-bench.c  | 213 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |   8 ++
 lib/arm/asm/gic.h  |   1 +
 4 files changed, 223 insertions(+)
 create mode 100644 arm/micro-bench.c

-- 
2.17.1
