From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 04/26] KVM: arm: Select ARM_GIC_V3 and ARM_GIC_V3_ITS
Date: Fri, 27 Oct 2017 15:28:33 +0100
Message-ID: <20171027142855.21584-5-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C0E49D38
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dvNKtGAYbfUj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:27:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F7C49D55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:55 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The GICv4 support introduces a hard dependency between the KVM
core and the ITS infrastructure. arm64 already selects it at
the architecture level, but 32bit doesn't. In order to avoid
littering the kernel with #ifdefs, let's just select the whole
of the GICv3 suport code.

You know you want it.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 4e2b192a030a..52b50af04e3b 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -23,6 +23,8 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select ARM_GIC
+	select ARM_GIC_V3
+	select ARM_GIC_V3_ITS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
-- 
2.11.0
