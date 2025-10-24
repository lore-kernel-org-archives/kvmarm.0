Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5485247281
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761278545; cv=none; b=i9HzVkliFKphV+Y7Eb0ZZclBPV6sYVCPeyFeNrYss+O7QrSH7T+WCrfarsOavwHcjo1T7s17axHoKjYkQx9R2ALxZUA5rMoMX33Wq4+2eIVrN0DLU8wWrZWrHXxzaoE+a36IGlmpIcnjLG3FViZA02Hmoa1Qf1cCk9HhzFf1A+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761278545; c=relaxed/simple;
	bh=anFenXs5SSmIQDDFcAAXj+497BeD1hkVlrd+XbtHMbM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HF5QNlK8iHtrJd3BwreAQ6o2w/VRcrN3MOaCQkx7VCpKNmR47UHySCnc0hIN7pwnCnQH7dIHi0Pm1I9qGPKhj0OBrQsbngkhLpIri5LisZfHQBGKUgjM4ioIoQzBeirSHRbWeZ8WV/84mPS48u5PEowj6SJu9MYuNzp/d84K3+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27A281CDD;
	Thu, 23 Oct 2025 21:02:15 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 615E73F59E;
	Thu, 23 Oct 2025 21:02:21 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: ben.horgan@arm.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH V2 1/2] arm64/mm: Drop redundant 'level' range trimming in __tlbi_level()
Date: Fri, 24 Oct 2025 05:02:06 +0100
Message-Id: <20251024040207.137480-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251024040207.137480-1-anshuman.khandual@arm.com>
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Page table level value has already known to be in the range [0..3] before
entering inside the conditional 'if' loop. Hence any subsequent trimming
is just redundant and can be dropped off.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 18a5dc0c9a54..131096094f5b 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -110,7 +110,7 @@ static inline unsigned long get_trans_granule(void)
 									\
 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) &&	\
 	    level >= 0 && level <= 3) {					\
-		u64 ttl = level & 3;					\
+		u64 ttl = level;					\
 		ttl |= get_trans_granule() << 2;			\
 		arg &= ~TLBI_TTL_MASK;					\
 		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
-- 
2.30.2

