From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 1/3] arm64: crypto/aes-ce-ccm: Cleanup hwcap check
Date: Mon, 31 Oct 2016 16:03:43 +0000
Message-ID: <1477929825-5907-2-git-send-email-suzuki.poulose@arm.com>
References: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, ard.biesheuvel@linaro.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Use the module_cpu_feature_match to make sure the system has
HWCAP_AES to use the module.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f4bf2f2..fa82eaa 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -14,6 +14,7 @@
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
+#include <linux/cpufeature.h>
 #include <linux/module.h>
 
 #include "aes-ce-setkey.h"
@@ -296,8 +297,6 @@ static struct aead_alg ccm_aes_alg = {
 
 static int __init aes_mod_init(void)
 {
-	if (!(elf_hwcap & HWCAP_AES))
-		return -ENODEV;
 	return crypto_register_aead(&ccm_aes_alg);
 }
 
@@ -306,7 +305,7 @@ static void __exit aes_mod_exit(void)
 	crypto_unregister_aead(&ccm_aes_alg);
 }
 
-module_init(aes_mod_init);
+module_cpu_feature_match(AES, aes_mod_init);
 module_exit(aes_mod_exit);
 
 MODULE_DESCRIPTION("Synchronous AES in CCM mode using ARMv8 Crypto Extensions");
-- 
2.7.4
