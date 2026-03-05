Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207B53B4EB2
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721907; cv=none; b=ThZw6j1lURvv7j0Tfx+M8FcpMvW8dyAtp/14itFuFob/2XMknMlrUAtrissA3mMwy+/5tqbz4eFGKRzo20faVOGJvhLTZLjh8OG4h6ldnGUX2waHOmYXLTKRIMjjMk5W06kWyn1ZyiVHegeT8adxMh9ftudeAoPI47XVNBCZkRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721907; c=relaxed/simple;
	bh=YshTdXZE6tSIxpmvZ+PoaUxdLFqBKwTJbDdG/9UZ5h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1UR5z/EISHXtR7xcVVjE85MR8Ew77Xjbbr8kXhwRO60JSZxnsJyZn9YcUbG5hQHhxwM2gQAPcppn3lSe/WmiRjFZm/+8Z2qHQVbiPoAsxTfr52hPiLpqS5Qra03O0mDkzKDhvAScpbMZoye3UfD+LXDMu2pnAusdRi3wBlIKj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJBiiDRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJBiiDRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D40BC116C6;
	Thu,  5 Mar 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721906;
	bh=YshTdXZE6tSIxpmvZ+PoaUxdLFqBKwTJbDdG/9UZ5h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJBiiDRAYf+sBjbg3KuxTBwvP6h/0DNlNmdhmVwOvWz8yfXV2wmEHCbSTuCznYrc+
	 qBAT9DUbhaO00g4cDsjJzUU3KJHTw+DuHJY4ocziGqGxa83nTleVdGXl1qWnAXjn+9
	 pKrLVr1Qhx39Fmjr5g6XEaNqBWcWrIdAo2tRU8odnSg4/n8D/BLsT4zCP60/YNWKSW
	 kGh92OlO0+fcKCYxu5opepMmrkdVn7JXG8SRrbh7HYkg2fkuyBBbjdncIexFcW0UIG
	 PtNIX3VqyIMIo/M23bqswCniDuI00LuVqP8uObM/Y7D51lpmh+Fju6jIYEmo/i9kSz
	 n6VglKRUS1XdA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 16/36] KVM: arm64: Factor out pKVM host exception injection logic
Date: Thu,  5 Mar 2026 14:43:29 +0000
Message-ID: <20260305144351.17071-17-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inject_undef64() open-codes the logic to inject an exception into the
pKVM host. In preparation for reusing this logic to inject a data abort
on an unhandled stage-2 fault from the host, factor out the meat and
potatoes of the function into a new inject_host_exception() function
which takes the ESR as a parameter.

Cc: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 49 ++++++++++++++----------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7294c94f9296..adfc0bc15398 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -705,43 +705,40 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	kvm_skip_host_instr();
 }
 
-/*
- * Inject an Undefined Instruction exception into the host.
- *
- * This is open-coded to allow control over PSTATE construction without
- * complicating the generic exception entry helpers.
- */
-static void inject_undef64(void)
+static void inject_host_exception(u64 esr)
 {
-	u64 spsr_mask, vbar, sctlr, old_spsr, new_spsr, esr, offset;
+	u64 sctlr, spsr_el1, spsr_el2, exc_offset = except_type_sync;
+	const u64 spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT |
+			      PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
 
-	spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
+	exc_offset += CURRENT_EL_SP_ELx_VECTOR;
+
+	spsr_el1 = spsr_el2 = read_sysreg_el2(SYS_SPSR);
+	spsr_el2 &= spsr_mask;
+	spsr_el2 |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
+		    PSR_MODE_EL1h;
 
-	vbar = read_sysreg_el1(SYS_VBAR);
 	sctlr = read_sysreg_el1(SYS_SCTLR);
-	old_spsr = read_sysreg_el2(SYS_SPSR);
-
-	new_spsr = old_spsr & spsr_mask;
-	new_spsr |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
-	new_spsr |= PSR_MODE_EL1h;
-
 	if (!(sctlr & SCTLR_EL1_SPAN))
-		new_spsr |= PSR_PAN_BIT;
+		spsr_el2 |= PSR_PAN_BIT;
 
 	if (sctlr & SCTLR_ELx_DSSBS)
-		new_spsr |= PSR_SSBS_BIT;
+		spsr_el2 |= PSR_SSBS_BIT;
 
 	if (system_supports_mte())
-		new_spsr |= PSR_TCO_BIT;
-
-	esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
-	offset = CURRENT_EL_SP_ELx_VECTOR + except_type_sync;
+		spsr_el2 |= PSR_TCO_BIT;
 
 	write_sysreg_el1(esr, SYS_ESR);
 	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
-	write_sysreg_el1(old_spsr, SYS_SPSR);
-	write_sysreg_el2(vbar + offset, SYS_ELR);
-	write_sysreg_el2(new_spsr, SYS_SPSR);
+	write_sysreg_el1(spsr_el1, SYS_SPSR);
+	write_sysreg_el2(read_sysreg_el1(SYS_VBAR) + exc_offset, SYS_ELR);
+	write_sysreg_el2(spsr_el2, SYS_SPSR);
+}
+
+static void inject_host_undef64(void)
+{
+	inject_host_exception((ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) |
+			       ESR_ELx_IL);
 }
 
 static bool handle_host_mte(u64 esr)
@@ -764,7 +761,7 @@ static bool handle_host_mte(u64 esr)
 		return false;
 	}
 
-	inject_undef64();
+	inject_host_undef64();
 	return true;
 }
 
-- 
2.53.0.473.g4a7958ca14-goog

