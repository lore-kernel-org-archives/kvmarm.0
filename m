From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv4 09/10] arm64: enable pointer authentication
Date: Thu,  3 May 2018 14:20:30 +0100
Message-ID: <20180503132031.25705-10-mark.rutland@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503132031.25705-1-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, mark.rutland@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that all the necessary bits are in place for userspace, add the
necessary Kconfig logic to allow this to be enabled.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index eb2cf4938f6d..d6ce16b1ee47 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1127,6 +1127,29 @@ config ARM64_RAS_EXTN
 
 endmenu
 
+menu "ARMv8.3 architectural features"
+
+config ARM64_PTR_AUTH
+	bool "Enable support for pointer authentication"
+	default y
+	help
+	  Pointer authentication (part of the ARMv8.3 Extensions) provides
+	  instructions for signing and authenticating pointers against secret
+	  keys, which can be used to mitigate Return Oriented Programming (ROP)
+	  and other attacks.
+
+	  This option enables these instructions at EL0 (i.e. for userspace).
+
+	  Choosing this option will cause the kernel to initialise secret keys
+	  for each process at exec() time, with these keys being
+	  context-switched along with the process.
+
+	  The feature is detected at runtime. If the feature is not present in
+	  hardware it will not be advertised to userspace nor will it be
+	  enabled.
+
+endmenu
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
2.11.0
