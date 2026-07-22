Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9119472F6C;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706181; cv=none; b=oviFEhkAYu/1LClyF9o4M/85yqGhKXIIcNvb+lTPp/Ra/a8MhPZvWvUCmXLZWm9mnxUGJGdy1Z+4MeBzyK4MEY2ABZvMkU6mt6GmTlL07CHS3M2kCiCqbn8OAyx08OrrP/eRIjXFLxjMDyUXcpovrBfxxzKN+dekB2Hahl1Ol1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706181; c=relaxed/simple;
	bh=Ys1eDVvA1svGP92SwQIqDfOk8Krcyq1dezPkLb8AVr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbkkupBKsFBuK+Q+TkEexFMjfF8VRrU85SHYhSuBRsJtNGgnnukqO8vx1SOU3+ghEThNvgU45J2kYPEwBqEGzOUGv9o66NuOx4BijktnDlpN8M7RVrJUwKeAoq9V0j++GzhvEvOUU9WNaTEi2q3U5BzxWh+yjPDM7khnvQqtclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTkPCTuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTkPCTuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763A41F01560;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706179;
	bh=kLmrcXzgSh6kVfmUn8DHrwgH54mD1mlSJlkD4Me8Yyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTkPCTuTvnbmXBge7WEihszZKG+8qLPUg3AowkH1HKwXRq9VSvY0VNoQJlLS8x/Rz
	 KM0Kd7vkLTRYkC1vpAU0S6on7VIoG6W04/QR9niVFcVF5cUF61wRMLzfnhIgKu8mlF
	 paa7BrlAdyNg7vMVYS3L0EPUscPVWTA3EzY3Lth5az4ux1HXSnfWEqrPbeMFuHu4aE
	 jIvT9Uz5nTMJGR1QlWd6AJYxgkVkB+KVAKVk2yMusOLCYAZXiNNnfSAUv1Nft49YaB
	 A61j7Ns4Yvns3Ai04s4NmK02blJFeLZXrDeh4xWraX0yXj7N+417BZL3toUyBag2zS
	 3bK7nu+0bB4+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbV-00000007VfN-3WIM;
	Wed, 22 Jul 2026 07:42:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 16/28] KVM: arm64: Split NV-specific exit fixups from the non-NV handling
Date: Wed, 22 Jul 2026 08:42:22 +0100
Message-ID: <20260722074234.3330999-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to facilitate further changes, move the NV handling of
early fixups in its own helper. This also makes the code slightly
simpler to parse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index a8da40568a048..53af19212895d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -539,18 +539,15 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[0x3F]				= kvm_hyp_handle_impdef,
 };
 
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
 {
-	synchronize_vcpu_pstate(vcpu);
-
 	/*
 	 * If we were in HYP context on entry, adjust the PSTATE view
 	 * so that the usual helpers work correctly. This enforces our
 	 * invariant that the guest's HYP context status is preserved
 	 * across a run.
 	 */
-	if (vcpu_has_nv(vcpu) &&
-	    unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
+	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
 		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 		switch (mode) {
@@ -567,8 +564,15 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	}
 
 	/* Apply extreme paranoia! */
-	BUG_ON(vcpu_has_nv(vcpu) &&
-	       !!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
+	BUG_ON(!!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
+}
+
+static bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	synchronize_vcpu_pstate(vcpu);
+
+	if (vcpu_has_nv(vcpu))
+		fixup_nv_guest_exit(vcpu);
 
 	return __fixup_guest_exit(vcpu, exit_code, hyp_exit_handlers);
 }
-- 
2.47.3

