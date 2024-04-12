Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDE855E73;
	Fri, 12 Apr 2024 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918088; cv=none; b=SWda6zV8jPf3evcRuBpAgCG0vfH9tYwgtXzIvwpmZSrDw9KGV0zuv6LlODFW4C/vxuIWX8YETBBhj3huvGysMEnLEnwU9OiJKlBhdzbAjqSKRFu9+Xiw2nITACz3xkfWf230OCnQCXtX2IjZ5B5p1GMt5vXl5YmAPFOqaGvG4RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918088; c=relaxed/simple;
	bh=wUZU7g6gvE0//COzcxg5bmUDHl71afdnQ/iskb5dCo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WqHvo95O+yUsL4GYzh73IJN7tAtx+7GCFU2SGMHkE/CSIOzfdJWscUq+O7KpHBhx2qjRHaOwIoL0eA8jFMCmb8sMmFhBelo3KS5a/w3YqEN1D5n6iDPl3qSkyHvLkVPZTvdpSYK6zFQyhAqMqmUz7s+LA9WdJ+kH8uKYvY8deTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A76C339;
	Fri, 12 Apr 2024 03:35:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AB1A3F64C;
	Fri, 12 Apr 2024 03:34:45 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 14/33] arm: selftest: realm: skip pabt test when running in a realm
Date: Fri, 12 Apr 2024 11:33:49 +0100
Message-Id: <20240412103408.2706058-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

The realm manager treats instruction aborts as fatal errors, skip this
test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/selftest.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..8caadad3 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -19,6 +19,7 @@
 #include <asm/smp.h>
 #include <asm/mmu.h>
 #include <asm/barrier.h>
+#include <asm/rsi.h>
 
 static cpumask_t ready, valid;
 
@@ -393,11 +394,17 @@ static void check_vectors(void *arg __unused)
 					  user_psci_system_off);
 #endif
 	} else {
+		if (is_realm()) {
+			report_skip("pabt test not supported in a realm");
+			goto out;
+		}
+
 		if (!check_pabt_init())
 			report_skip("Couldn't guess an invalid physical address");
 		else
 			report(check_pabt(), "pabt");
 	}
+out:
 	exit(report_summary());
 }
 
-- 
2.34.1

