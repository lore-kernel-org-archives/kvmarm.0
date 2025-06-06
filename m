Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68699243387
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254214; cv=none; b=dWDw8K6dAWxh8SX5sxyeIE4K0HAAqOV69FW9Kvd3XrWYzm5efGjG4vXh5wRfIW49YWLxcPBH1mahXY4/Uzb+lHKNNlOpK8KhZ5KDY6ISD/iLD4dAg4YGjZvcLIrt4GcR7a7OgF34c1cjx/GsUv61XgYsir+eQC2hYs83KKTdDFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254214; c=relaxed/simple;
	bh=tDZJ8MdVpbFF98N3E0urgkWbnwg6TPPRxGQmM7S5sCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oQB7AfXWylrXUchJ06tYepBgIXrjbXSlS9y+hnO412WAJ43RHeCxK1bnPSjVe9ojQcplnISAsmiCPgy1dyhuPdolDkBRFOiLb92WjSxa9csVyZwN21lVvYJ9llRFqIdVftidAMcU7mwAHopCn5KgpXXt9VO+HAUktyGipZCgD2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ex/3qYiB; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ex/3qYiB"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74292762324so2652773b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254212; x=1749859012; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1B0vc7yWbsW+rKAINzGAVsuBa1AMOLkrNMvFT9P3s=;
        b=ex/3qYiBKlrRD+r/acRRMrKxzc1RcCFlp9CBaGl9sC3DjaU7BFEdlz05X4hnZhTjjd
         xE2dw9Z+cfq3uOYtrH30yVM+w/mdgmXBRp9hjlmbpnwrdY2U8u1dWqR6B3Wz2/TaG38X
         rPAvK08sz9huHBP+ZKNpTAvoO5/bzTgSg1tVtEem7xWA9MJHvUzUiS/p7DvFvoeN2URN
         /GNtCvLYUJIB6hd24rzQxEzFxe7CuK1EkDtopOiBXwgVP5VCnl1AdjjAvN3tHxsP82d5
         pS74AgHZ8bdnrMc0vUaJxeojE5WFsb3Couq0uXJnYJrWW9cN+OarfIY6bhiJX0Zcu+tf
         2eNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254212; x=1749859012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1B0vc7yWbsW+rKAINzGAVsuBa1AMOLkrNMvFT9P3s=;
        b=ul22mxHnMJ5Xn4qR/jacwq/daRrWovLPQy+udmvAjNfMT4d5MFN8q40QHXyMeqmw+k
         YC5O0QIf/PfI1BcAA0LlJ+l/ZNseLKcHzMCnZqRiSUfeE+KK3B9vWRkzKAjdjLRNEvEd
         2jZJKKefR74n6vdGLnTOW8WcbYXSbDrym+Rh1cQ8O30POJkZPtK83vvWWAAuWKmTQcLy
         KT2bQ6LNqxl3FUkzISIkbySlBRJCDeqEAjNe9/krA9ReYPYjXkkm4JH72hiKn86QmuJh
         1bKPkZc1z+mi6sL4++gCW5Z/plNXfnwYUkT608WzSZsc08ZhoIyzzZEDhHbGFHyGJTYY
         mZow==
X-Forwarded-Encrypted: i=1; AJvYcCUsl8bXb0Zrr5n/lPePYJ7j0+LGguh0k5AsHq47sd644pmgqV8zDD+YOiJhMeO2GZBKGcPikF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiI5URMLPq/HpZvXiWymVCH/2/ienXi7Kj7VkCJbw1338OYdFK
	3IlCQaQeH4xPiGt9c1oZZInLWzxDseayb7Bcr960dxLuVBKjCLddrdiFN/Kk01qZLxl08YiNLS9
	Fr+qa1Cp+PQ==
X-Google-Smtp-Source: AGHT+IE9Z9v/BE8RbJx8HxWBNlBZkwC9QUKC5wtM41pIlGUzD9tGi9yGCVQWA834njnwpPNlSWj8ZpkvvF9W
X-Received: from pfbhw18.prod.google.com ([2002:a05:6a00:8912:b0:748:8e9:968e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:69b:b0:21a:de8e:5cc3
 with SMTP id adf61e73a8af0-21ee24cbf1bmr6832335637.4.1749254211881; Fri, 06
 Jun 2025 16:56:51 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:17 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-14-vipinsh@google.com>
Subject: [PATCH v2 13/15] KVM: selftests: Add arm64 auto generated test files
 for KVM Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add auto generated test files for ARM platform.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/tests/arch_timer/default.test        | 1 +
 .../selftests/kvm/tests/arm64/aarch32_id_regs/default.test       | 1 +
 .../selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test | 1 +
 .../selftests/kvm/tests/arm64/debug-exceptions/default.test      | 1 +
 tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test  | 1 +
 tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test  | 1 +
 tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test  | 1 +
 .../selftests/kvm/tests/arm64/page_fault_test/default.test       | 1 +
 tools/testing/selftests/kvm/tests/arm64/psci_test/default.test   | 1 +
 tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test | 1 +
 .../testing/selftests/kvm/tests/arm64/smccc_filter/default.test  | 1 +
 .../selftests/kvm/tests/arm64/vcpu_width_config/default.test     | 1 +
 tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test   | 1 +
 tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test    | 1 +
 .../selftests/kvm/tests/arm64/vgic_lpi_stress/default.test       | 1 +
 .../selftests/kvm/tests/arm64/vpmu_counter_access/default.test   | 1 +
 tools/testing/selftests/kvm/tests/get-reg-list/default.test      | 1 +
 17 files changed, 17 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/get-reg-list/default.test

diff --git a/tools/testing/selftests/kvm/tests/arch_timer/default.test b/tools/testing/selftests/kvm/tests/arch_timer/default.test
new file mode 100644
index 000000000000..97cac72515e2
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arch_timer/default.test
@@ -0,0 +1 @@
+arch_timer
diff --git a/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test b/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
new file mode 100644
index 000000000000..e9dc42eacb27
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
@@ -0,0 +1 @@
+arm64/aarch32_id_regs
diff --git a/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test b/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
new file mode 100644
index 000000000000..ebc7f45fab7e
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
@@ -0,0 +1 @@
+arm64/arch_timer_edge_cases
diff --git a/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test b/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
new file mode 100644
index 000000000000..dc427a64e1cd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
@@ -0,0 +1 @@
+arm64/debug-exceptions
diff --git a/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test b/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
new file mode 100644
index 000000000000..628731a70178
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
@@ -0,0 +1 @@
+arm64/hypercalls
diff --git a/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test b/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
new file mode 100644
index 000000000000..94e2aef05572
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
@@ -0,0 +1 @@
+arm64/mmio_abort
diff --git a/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test b/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
new file mode 100644
index 000000000000..5fa28e3d6f9c
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
@@ -0,0 +1 @@
+arm64/no-vgic-v3
diff --git a/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test b/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
new file mode 100644
index 000000000000..dbf95af263d8
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
@@ -0,0 +1 @@
+arm64/page_fault_test
diff --git a/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test b/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
new file mode 100644
index 000000000000..1cbe0cee5277
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
@@ -0,0 +1 @@
+arm64/psci_test
diff --git a/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test b/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
new file mode 100644
index 000000000000..e305642fda26
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
@@ -0,0 +1 @@
+arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test b/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
new file mode 100644
index 000000000000..98dd986522a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
@@ -0,0 +1 @@
+arm64/smccc_filter
diff --git a/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test b/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
new file mode 100644
index 000000000000..d00fd74341ac
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
@@ -0,0 +1 @@
+arm64/vcpu_width_config
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
new file mode 100644
index 000000000000..7835ba6157b5
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
@@ -0,0 +1 @@
+arm64/vgic_init
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
new file mode 100644
index 000000000000..387612d50530
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
@@ -0,0 +1 @@
+arm64/vgic_irq
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
new file mode 100644
index 000000000000..c31424bc5a88
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
@@ -0,0 +1 @@
+arm64/vgic_lpi_stress
diff --git a/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test b/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
new file mode 100644
index 000000000000..505743df541f
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
@@ -0,0 +1 @@
+arm64/vpmu_counter_access
diff --git a/tools/testing/selftests/kvm/tests/get-reg-list/default.test b/tools/testing/selftests/kvm/tests/get-reg-list/default.test
new file mode 100644
index 000000000000..07b9427b9f83
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/get-reg-list/default.test
@@ -0,0 +1 @@
+get-reg-list
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

