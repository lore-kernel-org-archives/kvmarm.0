From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 05/15] arm64: Handle 4 level page table for swapper
Date: Tue, 15 Sep 2015 16:41:14 +0100
Message-ID: <1442331684-28818-6-git-send-email-suzuki.poulose@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Catalin.Marinas@arm.com, Will.Deacon@arm.com, Mark.Rutland@arm.com, Marc.Zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, suzuki.poulose@arm.com, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

At the moment, we only support maximum of 3-level page table for
swapper. With 48bit VA, 64K has only 3 levels and 4K uses section
mapping. Add support for 4-level page table for swapper, needed
by 16K pages.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/head.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 46670bf..01b8e58 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -271,7 +271,10 @@ ENDPROC(preserve_boot_args)
  */
 =09.macro=09create_pgd_entry, tbl, virt, tmp1, tmp2
 =09create_table_entry \tbl, \virt, PGDIR_SHIFT, PTRS_PER_PGD, \tmp1, \tmp2
-#if SWAPPER_PGTABLE_LEVELS =3D=3D 3
+#if SWAPPER_PGTABLE_LEVELS > 3
+=09create_table_entry \tbl, \virt, PUD_SHIFT, PTRS_PER_PUD, \tmp1, \tmp2
+#endif
+#if SWAPPER_PGTABLE_LEVELS > 2
 =09create_table_entry \tbl, \virt, SWAPPER_TABLE_SHIFT, PTRS_PER_PTE, \tmp=
1, \tmp2
 #endif
 =09.endm
--=20
1.7.9.5

