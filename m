Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0670B421F0D;
	Thu, 30 Apr 2026 11:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547777; cv=none; b=IduPVITu9xr3GOaIyfKqmh5q6KxP05KgF2aL8ykTKZ8C9I+lzRoHFQVGU7os1WxZoxq4zkLz61Q6l6mizEbg1NIJhRjajc0ojecEsucY8q2MMDJG2mutEMdPJqSoYoUhPCkdrySFNvPZJZn9I5LmHvh5PmizuCQzOXw0eV5Yv+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547777; c=relaxed/simple;
	bh=/RURBevpFF+4tw+ka7Tw3QDbKLsEWw0aWfJtqGVfHwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVhPfrKwqGOVMD7s6GxhYxCIp/wB8UeV3h9wgrWXj5nwJOcA7PMd5cW7xMXpePkPwwzKyZIFWW2oD0OjXLmKXiX1gRfjTnzjRJKG37gfAvDA6tdBIkIDM0zaDiDIoL9eH6ljKVOYLGp5ZH/8yMNtBo2dq2tM1cwe8RBUeFQs8/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dg83rIEn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dg83rIEn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DC61356C;
	Thu, 30 Apr 2026 04:16:10 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18E533F763;
	Thu, 30 Apr 2026 04:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547775; bh=/RURBevpFF+4tw+ka7Tw3QDbKLsEWw0aWfJtqGVfHwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dg83rIEnCnvnNNd90W6UyyYmALfyt5w3xkYcgsMDx7kJQnSLWr+aI1bKWqOcI7gUb
	 f3YA79bgia7x7C+As0zyTHsMVTPe98UnOnrZcgz57AqdzZNuP3ALca1cAQCPqPWKxP
	 gHZ6XNUy68+rW5XuA+jTKVIrUYB6Ky9olnogHKH4=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 12/12] KVM: arm64: Enable KVM_HW_DIRTY_BIT
Date: Thu, 30 Apr 2026 12:14:16 +0100
Message-ID: <20260430111424.3479613-14-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the corresponding bit to enable hardware accelerated dirty-bitmap and
dirty-ring cleaning for arm64. Actually using acceleration depends on the
cpus enabling FEAT_HACDBS as well as the pre-requisite features for it,
such as FEAT_HDBSS and FEAT_HAFDBS.

Also, add myself as maintainer for the new bits introduced.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 MAINTAINERS            | 7 +++++++
 arch/arm64/kvm/Kconfig | 1 +
 2 files changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d25342ca8aa1..4b8a2b05b916 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2069,20 +2069,27 @@ F:	arch/arm64/boot/dts/Makefile
 ARM ARCHITECTED TIMER DRIVER
 M:	Mark Rutland <mark.rutland@arm.com>
 M:	Marc Zyngier <maz@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/include/asm/arch_timer.h
 F:	arch/arm64/include/asm/arch_timer.h
 F:	drivers/clocksource/arm_arch_timer.c
 F:	drivers/clocksource/arm_arch_timer_mmio.c
 
+ARM STAGE-2 DIRTY-BIT TRACKER/CLEANER ACCELERATOR
+M:	Leonardo Bras <leo.bras@arm.com>
+L:	kvmarm@lists.linux.dev
+S:	Maintained
+F:	arch/arm64/include/asm/kvm_dirty_bit.h
+F:	arch/arm64/kvm/dirty_bit.c
+
 ARM ETHOS-U NPU DRIVER
 M:	Rob Herring (Arm) <robh@kernel.org>
 M:	Tomeu Vizoso <tomeu@tomeuvizoso.net>
 L:	dri-devel@lists.freedesktop.org
 S:	Supported
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
 F:	drivers/accel/ethosu/
 F:	include/uapi/drm/ethosu_accel.h
 
 ARM GENERIC INTERRUPT CONTROLLER DRIVERS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..db8487bf738b 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -27,20 +27,21 @@ menuconfig KVM
 	select VIRT_XFER_TO_GUEST_WORK
 	select KVM_VFIO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select NEED_KVM_DIRTY_RING_WITH_BITMAP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_READONLY_MEM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select HAVE_KVM_HW_DIRTY_BIT if ACPI
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
 	help
 	  Support hosting virtualized guest machines.
 
 	  If unsure, say N.
 
 if KVM
 
-- 
2.54.0

