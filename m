Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CFC374E73
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 14:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534351; cv=none; b=evhmoEXzk5p2ywWR7JFaw/tN+TVkrtSgygF6yBoqzuOom5z4PYoBSVxR+BevUK38nvFZTLy2iQHt0a6CjKtk6XMTRUPkPEvPgHEcVaUVLI1LLbdINufjUFMT8MzjapxlPAgOPUnY8YMMq5jSy269UEtex6HIDJnltj1Fi1q+8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534351; c=relaxed/simple;
	bh=StaDbNBzF2YpHyypvAqrXBhu70KT7B2dbT9ZMMYZa9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qC2G7crFVQ7CHA0ig9hBa1uz0igRijiJxTJo4E5YTg96A8HaMVMsbVyW0YpDIeFei/krhvd3yXri214HVPO5apV4f8gyGiBFw6LCVxUnHeqnGIfaPaOAMwj+ZXf3jRr7lxFzjCZNXG/emTP+eTb1NKRKDcGRJ26/AgE0mWqqmKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNLAs4NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNLAs4NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5CFC116C6;
	Thu, 26 Mar 2026 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534350;
	bh=StaDbNBzF2YpHyypvAqrXBhu70KT7B2dbT9ZMMYZa9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNLAs4NSIz9eXn2I4JWari9HKyf1CIYDNU2v+Sxvfyjz/CYY16GXTNLnW9+P8N+4c
	 S/tTV3STo1aDwv0RVpmS2UhCZVlTSj8Mk4cb4hOEtRnuPZo/AcWbiz8iWoWp6YBN7X
	 W9+HU+WXuUhlm9yQ4D04q62KiSDViqZfFozlj3KPyXBuwMYlH9vY8WzBog/7pFgBXq
	 XJ/NdH3sxJVJxZU3J75riQy2bdLbrS3BhZSYEQPtwqLg3D/Dwpk4sig4dHRV2/Oc9R
	 hWuMfB3/J8rF+AQiuv4fab1UGqHF/eRWgKnDHOs327KJerxnYRWrjqD0cN9EvM5DbW
	 MRsmHuCUEUk1Q==
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
Subject: [PATCH v3 3/3] KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines
Date: Thu, 26 Mar 2026 14:12:13 +0000
Message-ID: <20260326141214.18990-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326141214.18990-1-will@kernel.org>
References: <20260326141214.18990-1-will@kernel.org>
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
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 84bc80f4e36b..50413171bd1a 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -156,9 +156,9 @@ static void __trace_switch_to_host(void)
 			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
-static void __debug_save_brbe(u64 *brbcr_el1)
+static void __debug_save_brbe(void)
 {
-	*brbcr_el1 = 0;
+	u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);
 
 	/* Check if the BRBE is enabled */
 	if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
@@ -173,8 +173,10 @@ static void __debug_save_brbe(u64 *brbcr_el1)
 	write_sysreg_el1(0, SYS_BRBCR);
 }
 
-static void __debug_restore_brbe(u64 brbcr_el1)
+static void __debug_restore_brbe(void)
 {
+	u64 brbcr_el1 = *host_data_ptr(host_debug_state.brbcr_el1);
+
 	if (!brbcr_el1)
 		return;
 
@@ -190,7 +192,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 
 	/* Disable BRBE branch records */
 	if (host_data_test_flag(HAS_BRBE))
-		__debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
+		__debug_save_brbe();
 
 	if (__trace_needs_switch())
 		__trace_switch_to_guest();
@@ -206,7 +208,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe();
 	if (host_data_test_flag(HAS_BRBE))
-		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
+		__debug_restore_brbe();
 	if (__trace_needs_switch())
 		__trace_switch_to_host();
 }
-- 
2.53.0.1018.g2bb0e51243-goog

