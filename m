Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE585490C;
	Fri, 12 Apr 2024 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918111; cv=none; b=TU4UCcNHy/Bd0dzjePJNgNCKr2F0/Zs/fQu7h4eG8fSthLqkcf6y75rRP+qxT3s1X0KHBnNi4d1j7NU1433FnBMmZ5QamjB0OZIDR1a/TiQp+FVa3jSrp6bN8tuV0vxyh/PFZRn/5ixLiXa5Zsg3rxXhoPPmXgkk4aZLtq5FmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918111; c=relaxed/simple;
	bh=SpT/LFvTyGusz8aCmIBMHkb4uzOotu1G8SqSr67r580=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cnylAChGv+px8rjzkaILDAjh1FbbUFfTHIpN29Jy1HKdBaCZb4LjAIsZVHX4Bn7P4U6uWqQzWdkR3y8+1BRULc0CxsO+JToqCJlRj5aKwB9Tj7Y+IMyBUs1yjBIlOfvIM6VZZqpTN5QKh0Fu876r0EcM6C3LXxSLWFISHCDibUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B13E15A1;
	Fri, 12 Apr 2024 03:35:38 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B9073F64C;
	Fri, 12 Apr 2024 03:35:07 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 25/33] arm: Add build steps for QCBOR library
Date: Fri, 12 Apr 2024 11:34:00 +0100
Message-Id: <20240412103408.2706058-26-suzuki.poulose@arm.com>
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

The QCBOR library will be used for Realm attestation.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index b3e085d3..de73601d 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -9,6 +9,8 @@ ldarch = elf64-littleaarch64
 arch_LDFLAGS = -pie -n
 arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
+CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
+CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
 
 sve_flag := $(call cc-option, -march=armv8.5-a+sve, "")
 ifneq ($(strip $(sve_flag)),)
@@ -35,6 +37,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
+cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
@@ -64,4 +67,5 @@ tests += $(TEST_DIR)/realm-sea.$(exe)
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
-	$(RM) lib/arm64/.*.d
+	$(RM) lib/arm64/.*.d		\
+	      lib/qcbor/src/.*.d
-- 
2.34.1

