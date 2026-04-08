Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86532391505;
	Wed,  8 Apr 2026 20:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775679976; cv=none; b=nZfiWgsRCHq6EkxfxvC2dCKP8WRpwBm22JGzV8ecD0NDJK6Ea/436RLOabGj1LoEfyTVJHrK1+IvJRh93yBTNqlK+rckdQGQpGIuwnHZx1kfNsK1KnpA/RL2azQOflVoYyOS/3AzAEvTAXEdIzgYjx/GiBAE6iAFrUl14XvTu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775679976; c=relaxed/simple;
	bh=jt95EpgQlwvn140i8uzvf32sS76tCpuf6c/S67u/ajQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAZya7LHiqmcaQlePC8suTuy0ildDSljVVxaov6VomzX7LFCKWS2RF3ylSJAbi5whGxvJhLdlkYntouvsM2JwvpEQ2IrH1DDifiTP5gRkfBjPsQaKfBl6YJT2GrQiV3Lowm24iXg9yp2GrCYJcuS3mc9juMzwu4Ct/TXNwHP4zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EnW7yCGQ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EnW7yCGQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=xT3HNXt0q205SHvVfxbeqCwBMz/Vdt7pmnVCLCDcy+k=; b=EnW7yCGQnOBfrXthwZ22O5s79+
	rKKQibCVwjLY5k66FDxgDxYbpmR/O8hl+z+k9Mp+RsTVXile9JV0/MEW+uopybVNP4jfiVS5f1fkR
	Oxp2Aia1lv+h/sOPHwT8cbKc/4CseX5A2AqM0PNToR1FEgy/p0oZtr98hwfD1fpz+6BiePKuQJBAl
	tfdB11GZKWt4a5hTkRVj8xnzHvViW4L0NLD+dVHg/WNWBtAiJXKSqwM1MdrUTzsYl4vDzpL2LosXo
	dPFkLeIV70Ksp2dJCzqqLR3wlj+Q3wbdDlQu3bOuCJO5UWfyRylLnhJdww1fs7d1Y7WVWQQ0udUm9
	J119SUGA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZTM-0000000AmLw-2H9h;
	Wed, 08 Apr 2026 20:26:00 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAZTL-00000008oxS-0geV;
	Wed, 08 Apr 2026 21:25:59 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 2/2] KVM: arm64: selftests: Add KVM_CAP_ARM_DISABLE_EXITS UAPI test
Date: Wed,  8 Apr 2026 21:23:48 +0100
Message-ID: <20260408202557.2102476-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260408202557.2102476-1-dwmw2@infradead.org>
References: <20260408202557.2102476-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Test the KVM_CAP_ARM_DISABLE_EXITS capability interface:
 - KVM_CHECK_EXTENSION reports KVM_ARM_DISABLE_EXITS_WFI
 - KVM_ENABLE_CAP succeeds with valid flags (WFI, zero)
 - KVM_ENABLE_CAP fails with EINVAL for unknown flags

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/arm64/disable_exits.c       | 48 +++++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/disable_exits.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 878d7cb92555..d8e7ff122445 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -179,6 +179,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_irq
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vgic_group_iidr
 TEST_GEN_PROGS_arm64 += arm64/vgic_group_v2
+TEST_GEN_PROGS_arm64 += arm64/disable_exits
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 += arm64/idreg-idst
diff --git a/tools/testing/selftests/kvm/arm64/disable_exits.c b/tools/testing/selftests/kvm/arm64/disable_exits.c
new file mode 100644
index 000000000000..27fe6c9297b2
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/disable_exits.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * disable_exits.c - Test KVM_CAP_ARM_DISABLE_EXITS UAPI
+ *
+ * Verify that KVM_CHECK_EXTENSION reports the valid exit disable mask
+ * and that KVM_ENABLE_CAP accepts valid flags and rejects invalid ones.
+ */
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	int r;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_DISABLE_EXITS));
+
+	r = kvm_check_cap(KVM_CAP_ARM_DISABLE_EXITS);
+	TEST_ASSERT(r & KVM_ARM_DISABLE_EXITS_WFI,
+		    "KVM_CHECK_EXTENSION should report WFI: got 0x%x", r);
+	TEST_ASSERT(r & KVM_ARM_DISABLE_EXITS_WFE,
+		    "KVM_CHECK_EXTENSION should report WFE: got 0x%x", r);
+
+	vm = vm_create(1);
+
+	/* Valid: disable WFI trapping */
+	vm_enable_cap(vm, KVM_CAP_ARM_DISABLE_EXITS, KVM_ARM_DISABLE_EXITS_WFI);
+
+	/* Valid: disable WFE trapping */
+	vm_enable_cap(vm, KVM_CAP_ARM_DISABLE_EXITS, KVM_ARM_DISABLE_EXITS_WFE);
+
+	/* Valid: disable both */
+	vm_enable_cap(vm, KVM_CAP_ARM_DISABLE_EXITS,
+		      KVM_ARM_DISABLE_EXITS_WFI | KVM_ARM_DISABLE_EXITS_WFE);
+
+	/* Valid: no exits disabled (no-op) */
+	vm_enable_cap(vm, KVM_CAP_ARM_DISABLE_EXITS, 0);
+
+	/* Invalid: unknown bit set */
+	r = __vm_enable_cap(vm, KVM_CAP_ARM_DISABLE_EXITS, 1ULL << 31);
+	TEST_ASSERT(r == -1 && errno == EINVAL,
+		    "Unknown flags should fail with EINVAL: got %d errno %d",
+		    r, errno);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.51.0

