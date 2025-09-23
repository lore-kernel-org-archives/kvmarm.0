Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D464A2949E0
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649766; cv=none; b=APinjv4QbX//3bNgrkSbxTChoMZApfZv/GhyinAVEgb6uEAhywfqE5VIBgCWaAMPhs2rUNw/0BbHh1L098rhncvnHqSPLCqg0GnadjjQ/FSXeV+l1mLOme/Wm7ORTNMjYa53uCy/ho5+S9pQQ12FXEQlzS2+4qZTPbsVe1rQ0O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649766; c=relaxed/simple;
	bh=Jf411jvxYLsqPZur/yDlu4YD6Al+gJMzr3Rj3+S6nac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4p6IHDjOO4hGFowkVtFo5YFoIg2JG6zOv1A0SMuYxRhmeqnJkWGByW6WhE17ngkqxgVSUN+qTXO0yzlHrsx9gSDBPavvCHWuIqXgOGFSdsyHWB0Wc4NGj0Z7lIPxHQU6sRMca+d5nbfMADYtorSsG2yHhltmbXcx47bNtPR6Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEBD7267F;
	Tue, 23 Sep 2025 10:49:15 -0700 (PDT)
Received: from e137867.cambridge.arm.com (e137867.arm.com [10.1.30.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67B913F5A1;
	Tue, 23 Sep 2025 10:49:20 -0700 (PDT)
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
Subject: [RFC PATCH 02/16] arm64: kasan: make kasan_hw_tags_enable() callback safe
Date: Tue, 23 Sep 2025 18:48:49 +0100
Message-ID: <20250923174903.76283-3-ada.coupriediaz@arm.com>
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

Make `kasan_hw_tags_enable()` safe by preventing its instrumentation.
This is possible thanks to a previous commit making
`kasan_hw_tags_enabled()` always inlined, preventing any instrumentation
in the callback.

As `kasan_hw_tags_enable()` is already marked as `__init`,
which has its own text section conflicting with the `noinstr` one,
use `__no_instr_section(".noinstr.text")` to add
all the function attributes added by `noinstr`, without the section
conflict.
This can be an issue, as kprobes seems to only block the text sections,
not based on function attributes.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
---
 arch/arm64/kernel/mte.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..a525c1d0c26d 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -239,6 +239,7 @@ static void mte_update_gcr_excl(struct task_struct *task)
 void __init kasan_hw_tags_enable(struct alt_instr *alt, __le32 *origptr,
 				 __le32 *updptr, int nr_inst);
 
+__noinstr_section(".init.text")
 void __init kasan_hw_tags_enable(struct alt_instr *alt, __le32 *origptr,
 				 __le32 *updptr, int nr_inst)
 {
-- 
2.43.0

