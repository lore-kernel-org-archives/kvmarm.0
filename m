From: Julien Thierry <julien.thierry@arm.com>
Subject: [RESEND PATCH 0/2] arm/arm64: kvm: Disable branch profiling in HYP
 code
Date: Fri, 20 Oct 2017 12:34:15 +0100
Message-ID: <1508499257-10014-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59EF549D24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XCdrE4k63fyu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:33:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 365F7406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:33:20 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

[Resending for Christoffer and adding kvmarm to recipients]

Hi,

When enabling branch profiling, a lockup occurs at boot time, after
displaying: "kvm [1]: Hyp mode initialized successfully"

The issue is caused by the Hyp code getting instrumented and trying to
access unmapped code or data, which happens when trying to initialize EL2.

So it also seems like KVM is misleadingly announcing it was initialized and
yet gets stuck during initialization.

* First patch deals with printing the initialization message once KVM has
  fully initialized Hyp mode
* Second patch actually disables branch profiling instrumentation in Hyp
  code

Cheers,

Julien Thierry (2):
  arm/arm64: kvm: Move initialization completion message
  arm/arm64: kvm: Disable branch profiling in HYP code

 arch/arm/kvm/hyp/Makefile   |  2 +-
 arch/arm64/kvm/hyp/Makefile |  2 +-
 virt/kvm/arm/arm.c          | 31 ++++++++++++++-----------------
 3 files changed, 16 insertions(+), 19 deletions(-)

--
1.9.1
