Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8292BE63F
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772227338; cv=none; b=MbLD+vD56sZV1Wlwnsav3lyVqmmkYWn7MX/T14qRy2CIqXIaWLlBzW0/07q18d7+CcDBAxW6OPfMoKxuQwDby3BUV46LzvxKS+LYzEm+Ot5k9wK9c2CsB7defrg9q1TC5kQ+ixbayGpWLsg8aip355lsAERJ9TpZLEv4/BypzDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772227338; c=relaxed/simple;
	bh=KZV5/gKKt/L2LiLu9lL0s0Maw3uWjGsBz31crUz8LE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbQej7Jj6gMt9paw8TcPZpUddIGZQb7X+sDN9+SS4brXtk9VCrtnmsz46556Bvi2bvFH4xeruYbV1YtVTTk4w5ZsfE2s2jx7iJc0sBCgvkFf404tj9MurNWG4mSkSXcvv0z1+DAa/2OpjHXclTj4t1Kx8jgLEQ6B2aC35SpXazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oB++lCIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oB++lCIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E85C19425;
	Fri, 27 Feb 2026 21:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772227338;
	bh=KZV5/gKKt/L2LiLu9lL0s0Maw3uWjGsBz31crUz8LE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oB++lCILHj7wQr1AjKDw/drBtOs3M/ntyeK/knYp6ZjHnvvqw6IrOnn3uixkkyyG3
	 Mgaj+EMxWUYBcaIxNRdqOhCT+MSmyYmYsv/YaEQQzjmgfilc/O9v5zI7esP95P09SH
	 /TOMFmCAzEWQ3kUlod2QrktV+VG0AP3diseEwKzTQbu0190oZO+7w7XJT89aHe8EHW
	 0qqp+W6u7RVVo7QTsgSfKcig33vx1bCW/QFnGlRZl0cQFDpXed+BKkBvCxiMrGlIKP
	 mV02b1d2zOrI0GwChG123CFewkEeGvJnJJgXKBgtxgQJrYnP3rx1tKKMIlBD6zd6/0
	 ANpUdZPiqSrMw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines
Date: Fri, 27 Feb 2026 21:21:35 +0000
Message-ID: <20260227212136.7660-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227212136.7660-1-will@kernel.org>
References: <20260227212136.7660-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the SPE and BRBE nVHE world-switch routines operate on the
host_debug_state directly, tweak the BRBE code to do the same for
consistency.

This is purely cosmetic.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 75158a9cd06a..06ae122a7761 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -158,9 +158,9 @@ static void __trace_switch_to_host(void)
 			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
-static void __debug_save_brbe(u64 *brbcr_el1)
+static void __debug_save_brbe(void)
 {
-	*brbcr_el1 = 0;
+	u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);
 
 	/* Check if the BRBE is enabled */
 	if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
@@ -175,8 +175,10 @@ static void __debug_save_brbe(u64 *brbcr_el1)
 	write_sysreg_el1(0, SYS_BRBCR);
 }
 
-static void __debug_restore_brbe(u64 brbcr_el1)
+static void __debug_restore_brbe(void)
 {
+	u64 brbcr_el1 = *host_data_ptr(host_debug_state.brbcr_el1);
+
 	if (!brbcr_el1)
 		return;
 
@@ -192,7 +194,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 
 	/* Disable BRBE branch records */
 	if (host_data_test_flag(HAS_BRBE))
-		__debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
+		__debug_save_brbe();
 
 	if (__trace_needs_switch())
 		__trace_switch_to_guest();
@@ -208,7 +210,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe();
 	if (host_data_test_flag(HAS_BRBE))
-		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
+		__debug_restore_brbe();
 	if (__trace_needs_switch())
 		__trace_switch_to_host();
 }
-- 
2.53.0.473.g4a7958ca14-goog

