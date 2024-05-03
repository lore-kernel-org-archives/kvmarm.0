Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F6C15358F
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714741407; cv=none; b=EWaeFHojIgCy0zeJR/F7n+tX5wfgOWJPXQ+33j0olKRu3Yd0WxQZ7waZaQwrFI8jMfQOcOq1sKD5U29vK2Hs8nwrUodQWj2syB5vecQQwVmKivVwkhW8SD1Y6pnmsrDqqalqMOXduYwkV051JHTGYEibSfUUuolTP4TwT2XbnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714741407; c=relaxed/simple;
	bh=zyddZqUCL7P/l1h4KmUABQWY5FfJEVCxJZm7OZ/3NF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nyPfpJX/kKzPrxAoZcKMUHErmRqz35xt08O3hkwJr+mST7qXF59q80MJSzRaxeqwVLswgz+c/HcGYoebypQvirm7omZ43IGjkSAmq+OY3wTlNWI0cbHqnhWxaevwD4lOSrk00Jh3e5ja6MqR2Hpf7+UcI8vxUnEwrUDZ7gZj4ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90E15175A;
	Fri,  3 May 2024 06:03:50 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 052593F73F;
	Fri,  3 May 2024 06:03:21 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com,
	bp@alien8.de,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	joey.gouly@arm.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	maz@kernel.org,
	mingo@redhat.com,
	mpe@ellerman.id.au,
	naveen.n.rao@linux.ibm.com,
	npiggin@gmail.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	szabolcs.nagy@arm.com,
	tglx@linutronix.de,
	will@kernel.org,
	x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v4 27/29] kselftest/arm64: parse POE_MAGIC in a signal frame
Date: Fri,  3 May 2024 14:01:45 +0100
Message-Id: <20240503130147.1154804-28-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240503130147.1154804-1-joey.gouly@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach the signal frame parsing about the new POE frame, avoids warning when it
is generated.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/arm64/signal/testcases/testcases.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/testcases.c b/tools/testing/selftests/arm64/signal/testcases/testcases.c
index e4331440fed0..e6daa94fcd2e 100644
--- a/tools/testing/selftests/arm64/signal/testcases/testcases.c
+++ b/tools/testing/selftests/arm64/signal/testcases/testcases.c
@@ -161,6 +161,10 @@ bool validate_reserved(ucontext_t *uc, size_t resv_sz, char **err)
 			if (head->size != sizeof(struct esr_context))
 				*err = "Bad size for esr_context";
 			break;
+		case POE_MAGIC:
+			if (head->size != sizeof(struct poe_context))
+				*err = "Bad size for poe_context";
+			break;
 		case TPIDR2_MAGIC:
 			if (head->size != sizeof(struct tpidr2_context))
 				*err = "Bad size for tpidr2_context";
-- 
2.25.1

