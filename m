From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 9/9] arm/arm64: KVM: Initialise the host pmu
Date: Tue, 31 Jan 2017 17:16:30 +0000
Message-ID: <20170131171630.26898-10-punit.agrawal@arm.com>
References: <20170131171630.26898-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C277C40A66
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72-zbYUUrifs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 12:17:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFFC40187
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:35 -0500 (EST)
In-Reply-To: <20170131171630.26898-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we've added support for handling TLB traps as well as
infrastructure for monitoring these operations, all that remains is
initialising the host pmu for arm/arm64.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d7446456e0c..e5f77a3d08ea 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1266,6 +1266,7 @@ static int init_subsystems(void)
 		goto out;
 
 	kvm_perf_init();
+	arm_host_pmu_init();
 	kvm_coproc_table_init();
 
 out:
@@ -1456,6 +1457,7 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_perf_teardown();
+	arm_host_pmu_teardown();
 }
 
 static int arm_init(void)
-- 
2.11.0
