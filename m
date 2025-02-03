Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DA620B807
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606255; cv=none; b=ogJOt/DTWY8PUeN/nv0g8yV1gn4iSuEi0enQnfMpuDpyum9u9N4hYjm3BvzwgacbcGbNhqWaOlRNIYEayybOoJwVa/iQqPDq5Ah+2jkFUumTZaSb4K3P6LdVxumOpjpVEq5plt8ec9kjfVrbavlimMKR557rz/tt18GaMeMRS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606255; c=relaxed/simple;
	bh=ho3d6fVLgrviPwBvnqL34Nxeur65MzBGNAN2yziZ6HQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hxT6kZoDqr4AE77qQnOKt8EjmLN3q3j9ELC0eVpQHiXF+TC4qAnMY607qUn5wT7bsfMvRdioiEYfzx1sBMDz3q/bKrwjEfYeT/+L6mxFJb1iSMC+m2FJhl/Cj5ZpVvHDiwRspiAGirB/StR6TApWi2aN2JMHxAe3uJPoratLF5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ofa4kCMt; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ofa4kCMt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738606236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e369Jpd9wPQ4GpElGKCHjESBmU67aDzaobWVmnI1uJ8=;
	b=ofa4kCMtiparBCe4boLmjE+S/1U89CstG73zch3eEWzQFZ+niK/Jbe1/GAeaHaUeu5a37s
	V540zPGIAuQT4mFe6tQxp4O+V+lqnJmpa2GJ2Ae/gyPLUfCL6KNjYCIuGxwazrNweJEUcv
	GUHiTpJNG4qUzpnaIdWyGWTdhedaHNU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH] arm: pmu: Actually use counter 0 in test_event_counter_config()
Date: Mon,  3 Feb 2025 10:10:26 -0800
Message-Id: <20250203181026.159721-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

test_event_counter_config() checks that there is at least one event
counter but mistakenly uses counter 1 for part of the test.

Most implementations have more than a single event counter which is
probably why this went unnoticed. However, due to limitations of the
underlying hardware, KVM's PMUv3 emulation on Apple silicon can only
provide 1 event counter.

Consistenly use counter 0 throughout the test, matching the precondition
and allowing the test to pass on Apple parts.

Cc: Eric Auger <eric.auger@redhat.com>
Fixes: 4ce2a804 ("arm: pmu: Basic event counter Tests")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 9ff7a301..2dc0822b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -396,13 +396,13 @@ static void test_event_counter_config(void)
 	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
 	 * select counter 0
 	 */
-	write_sysreg(1, PMSELR_EL0);
+	write_sysreg(0, PMSELR_EL0);
 	/* program this counter to count unsupported event */
 	write_sysreg(0xEA, PMXEVTYPER_EL0);
 	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
-	report((read_regn_el0(pmevtyper, 1) & 0xFFF) == 0xEA,
+	report((read_regn_el0(pmevtyper, 0) & 0xFFF) == 0xEA,
 		"PMESELR/PMXEVTYPER/PMEVTYPERn");
-	report((read_regn_el0(pmevcntr, 1) == 0xdeadbeef),
+	report((read_regn_el0(pmevcntr, 0) == 0xdeadbeef),
 		"PMESELR/PMXEVCNTR/PMEVCNTRn");
 
 	/* try to configure an unsupported event within the range [0x0, 0x3F] */

base-commit: 1f08a91a41402b0e032ecce8ed1b5952cbfca0ea
-- 
2.39.5

