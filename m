Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5558A17A5BE
	for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 00:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758416002; cv=none; b=o9moVxb0mxkrfgHmWNwMyKRkzAg8sPxYHKY00OWyiHMRFRIhDGzEjmbxMPqW5703jnxnK/o/7Rvp2ZifEIRnHAnOfs7Ma2AzD1+uMjgCA/s7RyDRKeq090LGfVwe7cQ5aTnFJpTilDDHSEIQ1wJ+arOxGT0u9wqfkvpPpIY5GDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758416002; c=relaxed/simple;
	bh=axcwQxaBTiXNOSvrDfk4LQ8ceCNJlurH7BMt/iXdSu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pMvxoRgmq8rTZCm8QcNzSHzpu3q31kqO7FnA9IBSTn8mxSHYvGBKPoPOZzWtivrqLo00wfWYMF+428emtbn1X5Bdd4F5QijhmpRkkwpBl/Sr0resajvj3CEIRjzZ7FV/gA6h5TamKU6egs4hi1FRJtsVoP5AAW6jMP3Lc8EkWdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9980D1688;
	Sat, 20 Sep 2025 17:53:06 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9181A3F66E;
	Sat, 20 Sep 2025 17:53:10 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH V5 1/4] tools: header : arm64: Replace TCR_NFD[0|1] with TCR_EL1_NFD[0|1]
Date: Sun, 21 Sep 2025 06:22:57 +0530
Message-Id: <20250921005300.2535994-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250921005300.2535994-1-anshuman.khandual@arm.com>
References: <20250921005300.2535994-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace TCR_NFD[0|1] (used in TCR_CLEAR_FUJITSU_ERRATUM_010001) with field
definitions which are available in tool sysreg format. Helps in completely
dropping off the adhoc TCR_NFD[0|1] macros later.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 tools/arch/arm64/include/asm/cputype.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
index 139d5e87dc95..dfa12df5e290 100644
--- a/tools/arch/arm64/include/asm/cputype.h
+++ b/tools/arch/arm64/include/asm/cputype.h
@@ -243,7 +243,7 @@
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
 #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
-#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
+#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
 
 #ifndef __ASSEMBLY__
 
-- 
2.25.1

