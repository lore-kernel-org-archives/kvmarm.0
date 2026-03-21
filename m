Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CD12D7DEF;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774128278; cv=none; b=HTPVV+rksPyBe2SQUJehBSaFq+pvrRCc7Aypd6HwWXFOPEmP6D8dAbW0VxtImrvK24JMCZrf8RES2aRX+PLAgORZs5FfaHD1bWSe/hZj1umA5BJHf4Ohd99qG11TIyoVe+mja4dB2ECCSVMZJj9uWcNerMnMcnWD+qZpYbjnYr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774128278; c=relaxed/simple;
	bh=Onaqa9IKbnLKX/Vmgh2xBDMn59TUFd4xYAihYdZV7qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbTqCjDN+FnJLA5wo++S2pgHKFMsboIVH4gjWSjwFLrEbjJ6ZGqQbwE6wHWF3dB+BtqMjV/dVwJ1JDVVNQ8NYCWuTGMDR/GcgYgB+VSeeIs0b32gSbncF0/9QEPyGD7WiDpQRdgO1FnTr5DRJfl5/dftvPkkauQbZ1HLssH3jXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNXVYwjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNXVYwjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0ACC2BCB2;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774128278;
	bh=Onaqa9IKbnLKX/Vmgh2xBDMn59TUFd4xYAihYdZV7qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNXVYwjLRTx4u9BNEE7LDSjuVNIww05omx5sxRRCxlQZ0xxk1Mhuy70J+4Xio00BK
	 4Yp59rAXiCsV0RIb9ISxzYteCEePrpZ+os4PwRxbbxuZYRMrjl/qj+ktWuXs43SRGz
	 fx1xFhsr7TC04yWtUfxDY4LsU3vyhBu01laQfRrpRU/rpc4YAHnK7XRb/x/552UkIL
	 qiFLfVRiA5t2Tg6WPHFoNNEh1ds1M6wKgPloH2qy7AJYXl1SCJ1kRFD6UqZuPBOcuh
	 E+rxmlQc0PSkJh6q80aasYVKJ44DOqURFkWe0wLAARz7paGq3M0sxl7RDZoYNWUk8/
	 4umdJU5/RX8Wg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w43oC-00000004NPB-2Cot;
	Sat, 21 Mar 2026 21:24:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 3/5] KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
Date: Sat, 21 Mar 2026 21:24:17 +0000
Message-ID: <20260321212419.2803972-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321212419.2803972-1-maz@kernel.org>
References: <20260321212419.2803972-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, smostafa@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

__kvm_hyp_init_cpu really is an internal label for kvm_hyp_cpu_entry
and kvm_hyp_cpu_resume.

Make it clear that this is what it is, and drop a pointless branch
in kvm_hyp_cpu_resume.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 55e0dce65dc56..2e80fcbff2dff 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -175,7 +175,6 @@ SYM_CODE_END(___kvm_hyp_init)
 SYM_CODE_START(kvm_hyp_cpu_entry)
 	mov	x1, #1				// is_cpu_on = true
 	b	__kvm_hyp_init_cpu
-SYM_CODE_END(kvm_hyp_cpu_entry)
 
 /*
  * PSCI CPU_SUSPEND / SYSTEM_SUSPEND entry point
@@ -184,17 +183,8 @@ SYM_CODE_END(kvm_hyp_cpu_entry)
  */
 SYM_CODE_START(kvm_hyp_cpu_resume)
 	mov	x1, #0				// is_cpu_on = false
-	b	__kvm_hyp_init_cpu
-SYM_CODE_END(kvm_hyp_cpu_resume)
 
-/*
- * Common code for CPU entry points. Initializes EL2 state and
- * installs the hypervisor before handing over to a C handler.
- *
- * x0: struct kvm_nvhe_init_params PA
- * x1: bool is_cpu_on
- */
-SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
+SYM_INNER_LABEL(__kvm_hyp_init_cpu, SYM_L_LOCAL)
 	mov	x28, x0				// Stash arguments
 	mov	x29, x1
 
@@ -223,7 +213,8 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 1:	wfe
 	wfi
 	b	1b
-SYM_CODE_END(__kvm_hyp_init_cpu)
+SYM_CODE_END(kvm_hyp_cpu_resume)
+SYM_CODE_END(kvm_hyp_cpu_entry)
 
 SYM_CODE_START(__kvm_handle_stub_hvc)
 	/*
-- 
2.47.3

