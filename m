From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v5 1/5] arm64: Add utilities to save restore pointer
 authentication keys
Date: Mon, 28 Jan 2019 12:28:42 +0530
Message-ID: <1548658727-14271-2-git-send-email-amit.kachhap@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A40384A369
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YPzOILdVKlsA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 01:59:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73BD44A41A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:18 -0500 (EST)
In-Reply-To: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The keys can be switched either inside an assembly or such
functions which do not have pointer authentication checks, so a GCC
attribute is added to enable it.

A function ptrauth_keys_store is added which is similar to existing
function ptrauth_keys_switch but saves the key values in memory.
This may be useful for save/restore scenarios when CPU changes
privilege levels, suspend/resume etc.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index 15d4951..98441ce 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -11,6 +11,13 @@
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 /*
+ * Compile the function without pointer authentication instructions. This
+ * allows pointer authentication to be enabled/disabled within the function
+ * (but leaves the function unprotected by pointer authentication).
+ */
+#define __no_ptrauth	__attribute__((target("sign-return-address=none")))
+
+/*
  * Each key is a 128-bit quantity which is split across a pair of 64-bit
  * registers (Lo and Hi).
  */
@@ -50,6 +57,13 @@ do {								\
 	write_sysreg_s(__pki_v.hi, SYS_ ## k ## KEYHI_EL1);	\
 } while (0)
 
+#define __ptrauth_key_save(k, v)				\
+do {								\
+	struct ptrauth_key __pki_v = (v);			\
+	__pki_v.lo = read_sysreg_s(SYS_ ## k ## KEYLO_EL1);	\
+	__pki_v.hi = read_sysreg_s(SYS_ ## k ## KEYHI_EL1);	\
+} while (0)
+
 static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
 {
 	if (system_supports_address_auth()) {
@@ -63,6 +77,19 @@ static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
 		__ptrauth_key_install(APGA, keys->apga);
 }
 
+static inline void ptrauth_keys_store(struct ptrauth_keys *keys)
+{
+	if (system_supports_address_auth()) {
+		__ptrauth_key_save(APIA, keys->apia);
+		__ptrauth_key_save(APIB, keys->apib);
+		__ptrauth_key_save(APDA, keys->apda);
+		__ptrauth_key_save(APDB, keys->apdb);
+	}
+
+	if (system_supports_generic_auth())
+		__ptrauth_key_save(APGA, keys->apga);
+}
+
 extern int ptrauth_prctl_reset_keys(struct task_struct *tsk, unsigned long arg);
 
 /*
@@ -88,6 +115,7 @@ do {									\
 	ptrauth_keys_switch(&(tsk)->thread.keys_user)
 
 #else /* CONFIG_ARM64_PTR_AUTH */
+#define __no_ptrauth
 #define ptrauth_prctl_reset_keys(tsk, arg)	(-EINVAL)
 #define ptrauth_strip_insn_pac(lr)	(lr)
 #define ptrauth_thread_init_user(tsk)
-- 
2.7.4
