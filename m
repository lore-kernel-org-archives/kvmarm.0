From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v6 05/11] arm/arm64: irq enable/disable
Date: Mon, 14 Nov 2016 22:08:33 +0100
Message-ID: <1479157719-31021-6-git-send-email-drjones@redhat.com>
References: <1479157719-31021-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1479157719-31021-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/processor.h   | 10 ++++++++++
 lib/arm64/asm/processor.h | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index bc46d1f980ee..959ecda5dced 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -35,6 +35,16 @@ static inline unsigned long current_cpsr(void)
 
 #define current_mode() (current_cpsr() & MODE_MASK)
 
+static inline void local_irq_enable(void)
+{
+	asm volatile("cpsie i" : : : "memory", "cc");
+}
+
+static inline void local_irq_disable(void)
+{
+	asm volatile("cpsid i" : : : "memory", "cc");
+}
+
 static inline unsigned long get_mpidr(void)
 {
 	unsigned long mpidr;
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 94f7ce35b65c..d54a4ed1c187 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -68,6 +68,16 @@ static inline unsigned long current_level(void)
 	return el & 0xc;
 }
 
+static inline void local_irq_enable(void)
+{
+	asm volatile("msr daifclr, #2" : : : "memory");
+}
+
+static inline void local_irq_disable(void)
+{
+	asm volatile("msr daifset, #2" : : : "memory");
+}
+
 #define DEFINE_GET_SYSREG(reg, type)				\
 static inline type get_##reg(void)				\
 {								\
-- 
2.7.4

