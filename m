From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH 0/2] arm64: extend arch timer tests
Date: Mon, 16 Jul 2018 16:14:36 +0100
Message-ID: <20180716151438.9877-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 425874A127
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id stKEoekjkRY1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 11:01:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FC54A129
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 11:01:43 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

While debugging some timer emulation IRQ problem, I realised that the
failure pattern I was looking at is not covered by kvm-unit-tests.

Add a test for the TVAL register, also check that KVM correctly injects
the timer interrupt for the emulated physical timer when the guest is in
WFI (hint: it does not, starting with 4.15-rc, I am on it).

Cheers,
Andre.

Andre Przywara (2):
  arm64: timer: add TVAL accessors
  arm64: timer: Add TVAL timeout test and test IRQ trigger

 arm/timer.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
2.14.4
