Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2D43E7151
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 13:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616482; cv=none; b=hrTPlpdIp61nmzc43kI57aDyUXgUF7QAdCFG5TrIwnNAv7LPx0fCxj1YWPLcy8BPtP+jKi16OF3lp8GFunDxXm0sn2sDuIYTF9rCxcKKtVosy9rWXI7fZ3RfvS+JLh6LcGeeJPHJN4wv24rr27Xq9Ydp/h/IPzCiRTOwm9bJLNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616482; c=relaxed/simple;
	bh=PwnNb0pQjR9jZ3vJL0puyCjiPOXJLaR8FU0epCCREF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCBB8+z1RzUKV+mUc7rHAqn54clkjFoEyJtLgaZapexGnRS3+RHplxhdXL7Ul0TwDIWT00MtgG416FpSf0/UGl0oIrlWT5dbKomBUb3Qs/eJ2VlJAmzwtHRz85bH3fIubVl4639BHDp8idS2Mdp6JxkOsxr+g6cAlgxGZwTWhn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LB4opcid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LB4opcid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C2AC2BC86;
	Fri, 27 Mar 2026 13:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616482;
	bh=PwnNb0pQjR9jZ3vJL0puyCjiPOXJLaR8FU0epCCREF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB4opcidM9ORtf9hp20k4phhg43fiOTM4TvjsQ3MpAkiNLPnQo9emYUrj70moZHhW
	 COaT7D04kPH3sX8TO89iTmQzGS9rBtfDW2xE+5KfR5KxmrbYG/XAzZOm5PB6ZsgbAZ
	 9KNAD8NOKP2TfjytorS8169plGRLgXWXE0K5k1c7kbBD4FSqCp4opGwj5acgvrK6+h
	 Uua3sEbzMMO7SsnrDr3oSGcDbYxVYlcxk5hnXsE2njGsojiAhJpV3jFcQzlTIvej/i
	 ECuYQZhBgPcnW4LXQXO1CTMieaHBIPHWAxUWfzbDKaA1rlDDsxf+gg7goLFL8bKxZL
	 wrDUdK2PoYs8g==
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
Subject: [PATCH v4 3/3] KVM: arm64: Don't pass host_debug_state to BRBE world-switch routines
Date: Fri, 27 Mar 2026 13:00:46 +0000
Message-ID: <20260327130047.21065-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327130047.21065-1-will@kernel.org>
References: <20260327130047.21065-1-will@kernel.org>
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
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 84bc80f4e36b..f8904391c125 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -156,8 +156,10 @@ static void __trace_switch_to_host(void)
 			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
-static void __debug_save_brbe(u64 *brbcr_el1)
+static void __debug_save_brbe(void)
 {
+	u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);
+
 	*brbcr_el1 = 0;
 
 	/* Check if the BRBE is enabled */
@@ -173,8 +175,10 @@ static void __debug_save_brbe(u64 *brbcr_el1)
 	write_sysreg_el1(0, SYS_BRBCR);
 }
 
-static void __debug_restore_brbe(u64 brbcr_el1)
+static void __debug_restore_brbe(void)
 {
+	u64 brbcr_el1 = *host_data_ptr(host_debug_state.brbcr_el1);
+
 	if (!brbcr_el1)
 		return;
 
@@ -190,7 +194,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 
 	/* Disable BRBE branch records */
 	if (host_data_test_flag(HAS_BRBE))
-		__debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
+		__debug_save_brbe();
 
 	if (__trace_needs_switch())
 		__trace_switch_to_guest();
@@ -206,7 +210,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
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

