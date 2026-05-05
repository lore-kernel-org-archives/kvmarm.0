Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233CD36C9CC
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777992490; cv=none; b=Iw/1qGoQlNQI5roa6COvj9YDq77bCWCrdHr9xnwUM6s+D/Yz4baeMKzSjy0VqemfsVTkORvDYl9Vm8kmWC8RzG7fIxEMuLGMDzeOHYlAMAUWxRziIOuXy1QO3nconwI0X3lXtpCOWrqnFi5tUYdfJVz9trlll7n10+bDA3BmzFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777992490; c=relaxed/simple;
	bh=hKzjIB4H5JRY6TdRWGACYXGfz13rGeCXV3Fdn17yKlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DEun1CZwNGGLpsDYExWCW16zo+dRrmu/LT6HaDcRGD5U189WND0x/U3YvrPtVm5Cei7Jhjin3FzHe9r9J2RfOPRl2T1j4snuIA2Yne22DDkVZcO1o9opfu2cUBlc0/vECzKzL/0DhAQDnAdnK8Ylpd3QOh8b5JfgoAbl2iyuG/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O/55uKkB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O/55uKkB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3958F1655;
	Tue,  5 May 2026 07:48:03 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023B13F763;
	Tue,  5 May 2026 07:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777992488; bh=hKzjIB4H5JRY6TdRWGACYXGfz13rGeCXV3Fdn17yKlc=;
	h=From:To:Cc:Subject:Date:From;
	b=O/55uKkB+vcPmr4EJfehOTAvGwU8FGPjM8g/6EcoeZljsH5mkHLvMnYWCFBq5XY8e
	 /tLMKw0L5DB7hOBGWWr3aAKpruqJ1n/v6cTTxW0WwirxIImoBwbZbZJ3wCxHe2W9b8
	 JVxixAn+uezgvhKeMDumqzL7LvT2OA6sF0/wnpbs=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH] KVM: arm64: nv: Consider the DS bit when translating TCR_EL2
Date: Tue,  5 May 2026 15:47:35 +0100
Message-ID: <20260505144735.1496530-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running an nVHE L1, TCR_EL2 is mapped to TCR_EL1. Writes to the
register are trapped and written to TCR_EL1 after a translation.
Booting an nVHE L1 with 52-bit VA isn't working because the translation
was ignoring the DS bit set by the guest, hence causing repeating level
0 faults. Add it in the translation function.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_nested.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 091544e6af44..dc2957662ff2 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -23,6 +23,7 @@ static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
 static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 {
 	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_DS) ? TCR_DS : 0) |
 	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
 	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
 	       (tcr & TCR_EL2_TG0_MASK) |
-- 
2.43.0

