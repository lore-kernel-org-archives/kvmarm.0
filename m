Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0DB143C7E
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806041; cv=none; b=WokfiTWPqpjuGmWbnCWmkjR0BRn7Up9x+KLjIWVQAJJek2eiFr+pAPMJoDEkHd3dWqouo6ypUzS9X6w9Fa6AdOm0rwQ6WxnpzwVI+W7R9hBie6i1xLu3sWp8dgRk2oznxuGGYPlD0pLdj7zEAeT5NBMfZcIdxZFA/3yvorF9IpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806041; c=relaxed/simple;
	bh=FqnB7kgaBCDCr1gJAqYv8s/Q7KLDiI91AqC351tbdGc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FeIzArbPaf8Lz36WmfULiBDGrtBVrteq/3q3bLI8gj4gw/uhAJ7QJS2mN2D17n/zgjckuL9FMe/y2a8sQ5lLX4LTio0qebiE42gP4pCTIfCl/vN7X8NJm0cdeRdejk+ojIvU+0r0EXsCjux1YPjo7/xhqHh6cZ+boCMJ9+t+Dcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E84CC1474;
	Thu, 28 Nov 2024 07:01:04 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1F3CB3F66E;
	Thu, 28 Nov 2024 07:00:33 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [PATCH] arm64: Fix sve_vl() for build errors
Date: Thu, 28 Nov 2024 15:00:02 +0000
Message-Id: <20241128150002.2424523-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 5b9895f8a5d9 ("arm: Fix clang error in sve_vl()") breaks the build
with the following compiler version, as the "rdvl" expects a 64bit register.

/tmp/ccGJYtuC.s: Assembler messages:
/tmp/ccGJYtuC.s:2165: Error: operand mismatch -- `rdvl w3,#8'
/tmp/ccGJYtuC.s:2165: Info:    did you mean this?
/tmp/ccGJYtuC.s:2165: Info:     rdvl x3, #8
make: *** [<builtin>: arm/selftest.o] Error 1
make: *** Waiting for unfinished jobs....

$ aarch64-none-elf-gcc --version
aarch64-none-elf-gcc (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16)) 10.2.1 20201103

Fix this by switching to use "unsigned long" variable and restoring the 64bit
register for the instruction

Fixes: 5b9895f8a5d9 ("arm: Fix clang error in sve_vl()")
Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm64/asm/processor.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index e261e74d..e5b0ad10 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -154,12 +154,12 @@ static inline bool system_supports_sve(void)
 	return ((get_id_aa64pfr0_el1() >> ID_AA64PFR0_EL1_SVE_SHIFT) & 0xf) != 0;
 }
 
-static inline int sve_vl(void)
+static inline unsigned long sve_vl(void)
 {
-	int vl;
+	unsigned long vl;
 
 	asm volatile(".arch_extension sve\n"
-		     "rdvl %w0, #8"
+		     "rdvl %x0, #8"
 		     : "=r" (vl));
 
 	return vl;
-- 
2.34.1

