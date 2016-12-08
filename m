From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v2 0/2] arm/pmu: fixups for AArch64
Date: Thu,  8 Dec 2016 18:05:47 +0100
Message-ID: <20161208170549.8793-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5247F4044D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t3vTr+ATfqEq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 12:04:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BAFB401D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 12:04:52 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The first patch fixes probing on ThunderX, where ID_DFR0 is zero.
The second patch removes noise from most run_tests.sh runs since
TCG PMU isn't really ready to be tested regularly yet.

Andrew Jones (2):
  arm/pmu: fix probe on AArch64
  arm/pmu: don't run tcg tests

 arm/unittests.cfg | 20 ++++++++++----------
 arm/pmu.c         | 37 ++++++++++++++++++++++---------------
 2 files changed, 32 insertions(+), 25 deletions(-)

-- 
2.9.3
