From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 03/28] arm64: efi: Add missing Kconfig dependency on KERNEL_MODE_NEON
Date: Fri, 27 Oct 2017 11:50:45 +0100
Message-ID: <1509101470-7881-4-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The EFI runtime services ABI permits calls to EFI to clobber
certain FPSIMD/NEON registers, as per the AArch64 procedure call
standard.

Saving/restoring the clobbered registers around such calls needs
KERNEL_MODE_NEON, but the dependency is missing from Kconfig.

This patch adds the missing dependency.

This will aid bisection of the patches implementing support for the
ARM Scalable Vector Extension (SVE).

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 05aa592..5cfb79d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1064,6 +1064,7 @@ config EFI_STUB
 config EFI
 	bool "UEFI runtime support"
 	depends on OF && !CPU_BIG_ENDIAN
+	depends on KERNEL_MODE_NEON
 	select LIBFDT
 	select UCS2_STRING
 	select EFI_PARAMS_FROM_FDT
-- 
2.1.4
