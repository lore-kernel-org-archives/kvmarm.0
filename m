Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F98347DD
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187088; cv=none; b=dgxcQ+d6tsvs3xhQmjSGPe8IG8tJj6Xz9NxZSr5cLLweJD2Y+BzZu3qzIT/8GjitP3CsZqjrwOhco1oyuS9az3r5e9/8IkZfTzGbNoNHUksgT2oNnK0M7tgZ0MD3trl8cTGcUejpsI+nAp7VQhTt7btPmVh6icXip1yl8IMuqms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187088; c=relaxed/simple;
	bh=HtjLkyksoYjyYOKD/ZkMZxhcs6zetBmEZQKavbHSO+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ljye1fjE89XDA7cG666Da7PAUkXvKt2SswS3ynZ0gaE/h/QYU97UoJQZw5H+Dexl0WX1CGACH+KrYHviy/oN/qW4BMjd7+x9LnpY0QH+KVaTtat9MGpCQ4CNrA6nqDXfjLAED9crZ/IuZFDGiVWXZGpzY+fb0TRRr24xRhcqqQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99F4A1515;
	Fri, 23 Jan 2026 08:51:19 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B78583F694;
	Fri, 23 Jan 2026 08:51:24 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 14/14] arm64: gitlab-ci: add EL2 tests to CI
Date: Fri, 23 Jan 2026 16:50:53 +0000
Message-Id: <20260123165053.2250754-15-joey.gouly@arm.com>
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

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 .gitlab-ci.yml | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 7e3d4661..ee3274dd 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -126,6 +126,36 @@ build-aarch64-clang-efi:
       | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
+build-aarch64-el2:
+ extends: .intree_template
+ script:
+ - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
+ - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
+ - make -j2
+ - ACCEL=tcg MAX_SMP=8 EL2=y ./run_tests.sh
+      cache
+      debug-bp
+      debug-sstep
+      debug-wp
+      gicv2-active
+      gicv2-ipi
+      gicv2-mmio
+      gicv3-active
+      gicv3-ipi
+      its-introspection
+      its-trigger
+      pci-test
+      pmu-cycle-counter
+      pmu-event-counter-config
+      pmu-sw-incr
+      selftest-setup
+      selftest-smp
+      selftest-vectors-kernel
+      selftest-vectors-user
+      timer
+      | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
 build-arm:
  extends: .outoftree_template
  script:
-- 
2.25.1

