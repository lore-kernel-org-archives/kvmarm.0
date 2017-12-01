From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 0/3] arm64: SVE fixes for v4.15-rc1
Date: Fri,  1 Dec 2017 15:19:39 +0000
Message-ID: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D7849D6E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hwb+QqhXdpxC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Dec 2017 10:16:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A87C2406BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Dec 2017 10:16:52 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This mini-series contains a few fixes for known issues in the arm64 SVE
patches that missed the merge window.

They should be considered fixes for v4.15.

Dave Martin (3):
  arm64: KVM: Move CPU ID reg trap setup off the world switch path
  arm64: fpsimd: Abstract out binding of task's fpsimd context to the
    cpu.
  arm64/sve: KVM: Avoid dereference of dead task during guest entry

 arch/arm64/include/asm/kvm_emulate.h |  8 ++++++
 arch/arm64/kernel/fpsimd.c           | 51 +++++++++++++++++++++---------------
 arch/arm64/kvm/hyp/switch.c          |  4 ---
 3 files changed, 38 insertions(+), 25 deletions(-)

-- 
2.1.4
