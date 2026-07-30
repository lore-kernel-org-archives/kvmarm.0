Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264C43BB9EF;
	Thu, 30 Jul 2026 07:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395468; cv=none; b=S86UVuUqiv3AEdFXU8HRVD6P4q5q+/x9/0o0m0t79MAH/3Pn+/wZk0vNEkt4e1fSHK5P+wDC9aUyWmhOb20pzQ07V+duDWkznqdMb5BGA8HRwe8oKyaZt6ih/TcpDnNeftebfl6hsu1F1WzLoQr8jjpwcpzZaANWTvhiruWLr1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395468; c=relaxed/simple;
	bh=w+EhWlX+qPy30XG42S6s3EApG0JUaH1FUB+lO5ZOjM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VES5MmT/KdW/8/SoVfZAxdFrwJZEUE0x4g19G7OkWY1X2iGu/IOWhJfN/AuCN27cQAJ4jDEXfw3NszCPGSOfLP3Yx1Cgflm6pdBGm3ygwhA3sTR+xYKBaNpL8kjxe6RF60qPw/GN4W6d08pzyunHfUQNrGH1cjOoW/AlzCZxuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpHQ5fJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpHQ5fJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B00D1F0155D;
	Thu, 30 Jul 2026 07:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395453;
	bh=c5q7g0Tr+SZI10mLKtzVtO1D8rNE5+dliITwvOUWOnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpHQ5fJNOZiy/x1XyD2zTqwYkkGWW6roZBeLZJBcYgB+pvfd8//crvrVkVcJTqZ3J
	 MxdcpXwJO2O6uTHBbOCnfCgynxop/6So3eklO/URS/gCS8nR4I+CuR1FSgvFgim0t3
	 aN5XpRiK1m+cNvjuaQsGn2HqKPfHWPAehemgSjct/wsypCVIfZQ+ApxqC7q50hQtS3
	 O5uUZwkwjDe3Lmm5DzYj3Fz6Jke113Y4RwH6RmCxcXS9E14zF5PSM3MEP4f302Psp4
	 i+BxS5FYCuZCdKuxgtPXuGcwZWPYL32wPZVyUAzQoLeBseW5NHBzTn1K2Be69frD62
	 dn7hhKDfa3VqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKup-0000000AOpW-3gmO;
	Thu, 30 Jul 2026 07:10:51 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 16/29] KVM: arm64: Split NV-specific exit fixups from the non-NV handling
Date: Thu, 30 Jul 2026 08:10:09 +0100
Message-ID: <20260730071022.296811-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to facilitate further changes, move the NV handling of
early fixups in its own helper. This also makes the code slightly
simpler to parse.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
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

