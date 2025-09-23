Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1012C326D
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649786; cv=none; b=QlOn3GBC/5KihUqSqEkh2545YoJ6CNaNyOsv6Uf53hMvx5MZhNrrsHvWLQiT6oEAmZ6VCvx5qNG+QrTriLwTZ6BnwbwygZSE+QjR7ktM9oHEbyFpSeokywqS0sTYafVACdbcezqURp/474rYOUcSz/LfV2Z+YXrbDS7leQQmZts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649786; c=relaxed/simple;
	bh=Py7l0YS0EW7fsBvD6gVVgfYxM8uX6Dlxs9iZ8oTPMeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usOb9cZeLmaiMc3UCx46X96O9zV1nx0R1rfxv7tNL1ogs5olr6pB7vkJM4RLWqxtgs7e54IrUHXXwizhYKOwLbHc/ZT03qX5H5thafYd+vqhGCuV/QuAZbSXsfT3gUCNPaKnon8gBjs1tL0vvPiCulwZGIOlbOdyar4QUVw7SGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63E425E0;
	Tue, 23 Sep 2025 10:49:35 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E078E3F5A1;
	Tue, 23 Sep 2025 10:49:39 -0700 (PDT)
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>
Subject: [RFC PATCH 07/16] arm64/proton-pack: make alternative callbacks safe
Date: Tue, 23 Sep 2025 18:48:54 +0100
Message-ID: <20250923174903.76283-8-ada.coupriediaz@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174903.76283-1-ada.coupriediaz@arm.com>
References: <20250923174903.76283-1-ada.coupriediaz@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alternative callback functions are regular functions, which means they
or any function they call could get patched or instrumented
by alternatives or other parts of the kernel.
Given that applying alternatives does not guarantee a consistent state
while patching, only once done, and handles cache maintenance manually,
it could lead to nasty corruptions and execution of bogus code.

Make the Spectre mitigations alternative callbacks safe by marking them
`noinstr` when they are not.
This is possible thanks to previous commits making `aarch64_insn_...`
functions used in the callbacks safe to inline.

`spectre_bhb_patch_clearbhb()` is already marked as `__init`,
which has its own text section conflicting with the `noinstr` one.
Instead, use `__no_instr_section(".noinstr.text")` to add
all the function attributes added by `noinstr`, without the section
conflict.
This can be an issue, as kprobes seems to only block the text sections,
not based on function attributes.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
This is missing `spectre_bhb_patch_wa3()` and
`spectre_v4_patch_fw_mitigation_enable()` callbacks, which would need
some more work :
- `spectre_bhb_patch_wa3()` uses `WARN` which is instrumented, and
  I am not sure if it is safe to remove. It feels like something else
  should be done there ?
- `spectre_v4_patch_fw_mitigation_enable()` calls into
  `spectre_v4_mitigations_off()` which calls `pr_info_once()` to notice
  the disabling of the mitigations on the command line, which is
  instrumentable but feels important to keep. I am not sure if there
  would be a better place to generate that message ?
  Interestingly, this was brought up recently[0].
  It also calls `cpu_mitigations_off()` which checks a static variable
  against a static enum, in a common code C file, and is instrumentable.
  This one feels like it could be `__always_inline`'d, but given it is
  common code and the static nature of operands in the check, maybe
  marking it `noinstr` would be acceptable ?

[0]: https://lore.kernel.org/all/aNF0gb1iZndz0-be@J2N7QTR9R3/
---
 arch/arm64/kernel/proton-pack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index edf1783ffc81..4ba8d24bf7ef 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1174,6 +1174,7 @@ void noinstr spectre_bhb_patch_wa3(struct alt_instr *alt,
 }
 
 /* Patched to NOP when not supported */
+__noinstr_section(".init.text")
 void __init spectre_bhb_patch_clearbhb(struct alt_instr *alt,
 				   __le32 *origptr, __le32 *updptr, int nr_inst)
 {
-- 
2.43.0

