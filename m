From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/11] arm: KVM: Add missing kvm_stage2_has_pmd() helper
Date: Thu,  7 Feb 2019 13:18:41 +0000
Message-ID: <20190207131843.157210-10-marc.zyngier@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C1B4A423
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynq4-rJF7yye for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Feb 2019 08:19:21 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13ABA4A481
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:21 -0500 (EST)
In-Reply-To: <20190207131843.157210-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Fixup 32bit by providing the now required helper.

Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/stage2_pgtable.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index c4b1d4fb1797..de2089501b8b 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -76,4 +76,9 @@ static inline bool kvm_stage2_has_pud(struct kvm *kvm)
 #define S2_PMD_MASK				PMD_MASK
 #define S2_PMD_SIZE				PMD_SIZE
 
+static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
+{
+	return true;
+}
+
 #endif	/* __ARM_S2_PGTABLE_H_ */
-- 
2.20.1
