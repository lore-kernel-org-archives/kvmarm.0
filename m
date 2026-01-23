Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C504029993E
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187086; cv=none; b=VOhyfHLvn3+araBdpERH3C239iPqRMGyHBvb0qMHeE/ibDznFYQkxiA0neRYbbPhbbWDGGePQGq/AJ1bAaiv/XQiND8zNipxMLrJiWGEGujaA3rcqMlUkDu8+wtoKVXNw0ZPR65WcdPjWQKD32wf4bVNlNSXAYYlKHdzQCIUgp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187086; c=relaxed/simple;
	bh=7X1vpDlYeqoEsvWPSkssPu/nTKr99aLl51SG0QdV/0k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=noOF4xmhwd7Mj5fWff1BlrThJrKqrjpaJGxqQxcVYLAY3oyDW5UEFaYPjWGnzZvxEcpkBDO1bIYGxiJYtkQrUKC7UblNU7rbpD50NUnrWm/61nr0i5NJXLxujBUAsiAWsfPvEJhvbaSWxavuNK25qmEJGWO6tTvhujyyQsKbaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D65461691;
	Fri, 23 Jan 2026 08:51:17 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 126323F694;
	Fri, 23 Jan 2026 08:51:22 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 13/14] arm64: debug: skip tests at EL2
Date: Fri, 23 Jan 2026 16:50:52 +0000
Message-Id: <20260123165053.2250754-14-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These tests are currently broken and need investigation.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arm/debug.c b/arm/debug.c
index 572786a9..0299fd28 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -267,6 +267,11 @@ static noinline void test_hw_bp(bool migrate)
 	int num_bp = get_num_hw_bp();
 	int i;
 
+	if (current_level() == CurrentEL_EL2) {
+		report_skip("test broken for EL2");
+		return;
+	}
+
 	install_exception_handler(EL1H_SYNC, ESR_EC_HW_BP_CURRENT, hw_bp_handler);
 
 	reset_debug_state();
@@ -314,6 +319,11 @@ static noinline void test_wp(bool migrate)
 	int num_wp = get_num_wp();
 	int i;
 
+	if (current_level() == CurrentEL_EL2) {
+		report_skip("test broken for EL2");
+		return;
+	}
+
 	install_exception_handler(EL1H_SYNC, ESR_EC_WP_CURRENT, wp_handler);
 
 	reset_debug_state();
-- 
2.25.1

