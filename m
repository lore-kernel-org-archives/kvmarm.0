From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests v8 04/10] arm/arm64: irq enable/disable
Date: Thu,  8 Dec 2016 18:50:24 +0100
Message-ID: <20161208175030.12269-5-drjones@redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208175030.12269-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/processor.h   | 10 ++++++++++
 lib/arm64/asm/processor.h | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index 857bdd96a3cc..6dc1472468dd 100644
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
 #define MPIDR __ACCESS_CP15(c0, 0, c0, 5)
 static inline unsigned int get_mpidr(void)
 {
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 0898d89f9761..f42f15c79d43 100644
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
 static inline unsigned int get_mpidr(void)
 {
 	return read_sysreg(mpidr_el1);
-- 
2.9.3

