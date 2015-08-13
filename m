From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 14/14] arm64: 36 bit VA
Date: Thu, 13 Aug 2015 12:34:04 +0100
Message-ID: <1439465645-22584-15-git-send-email-suzuki.poulose@arm.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, "Suzuki K. Poulose" <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

36bit VA lets us use 2 level page tables while limiting the
available address space to 64GB.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8327edf..0407fd3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -164,6 +164,7 @@ config FIX_EARLYCON_MEM
=20
 config PGTABLE_LEVELS
 =09int
+=09default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
 =09default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
 =09default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
 =09default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
@@ -472,6 +473,10 @@ choice
 =09  space sizes. The level of translation table is determined by
 =09  a combination of page size and virtual address space size.
=20
+config ARM64_VA_BITS_36
+=09bool "36-bit"
+=09depends on ARM64_16K_PAGES
+
 config ARM64_VA_BITS_39
 =09bool "39-bit"
 =09depends on ARM64_4K_PAGES
@@ -491,6 +496,7 @@ endchoice
=20
 config ARM64_VA_BITS
 =09int
+=09default 36 if ARM64_VA_BITS_36
 =09default 39 if ARM64_VA_BITS_39
 =09default 42 if ARM64_VA_BITS_42
 =09default 47 if ARM64_VA_BITS_47
@@ -564,7 +570,7 @@ config ARCH_WANT_GENERAL_HUGETLB
 =09def_bool y
=20
 config ARCH_WANT_HUGE_PMD_SHARE
-=09def_bool y if ARM64_4K_PAGES || ARM64_16K_PAGES
+=09def_bool y if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
=20
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 =09def_bool y
--=20
1.7.9.5
