From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 0/2] arm/arm64: introduce PSCI tests
Date: Mon, 27 Feb 2017 18:32:06 +0100
Message-ID: <20170227173208.14854-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0738140C38
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:31:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cfGgQ34q4BCz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:31:05 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDC4640C2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:31:04 -0500 (EST)
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
List-Id: kvmarm@lists.cs.columbia.edu

Andrew Jones (1):
  arm/arm64: psci: support testing tcg

Levente Kurusa (1):
  arm/arm64: Add PSCI tests

 arm/Makefile.common |   1 +
 arm/psci.c          | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |   6 +++
 3 files changed, 151 insertions(+)
 create mode 100644 arm/psci.c

-- 
2.9.3
