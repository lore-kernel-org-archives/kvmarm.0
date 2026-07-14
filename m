Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6567E43E48C;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020614; cv=none; b=guOD0xGXdHWyXPsYjtH9Av4KpOpZkjVJ+q5bP6IMWOU4pb3yBNkKDKerYsOVXPvI4wR8T7Bdv2bmp6AYYtU869/2Em0Iikwlklvhx2JDz0ERS06uzQDLLtHpD/inqndvO9DKTtyLKKAlUMzfk/hljmivkTKndbcqDigKAZYXFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020614; c=relaxed/simple;
	bh=BBZvMyIFS49P7F8oJbEJZDSt4qZQ8LVvYOW4V8p4l5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyh10PQfWHQ3JMfiZQ5vCBs0aCDAB8H0cqL1hPg8B93kFJgONkOD4SvR6DXHKnAvJe8p2nYFt9RwZzZONVImHWjJ4te+hV1VVsQ5chlL2I2q+X+4ArB5WvDODVY9OOWWTtU9wlA+TMxowm4BNAbTWxCE0mvrx/PnQ7SzdefLOas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHxVGTsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHxVGTsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0915A1F0155F;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020612;
	bh=c+ZanZNTCeiK1eDDtdkdj8prMqqP83sRneyyFt5rg3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHxVGTsjcXDVv7ZwawJ57t4SLcMk9SbcLZVA9P1Jc+YO3CprEnThCl1ftXHPp+a4S
	 BEiqCptLVi2IrZg/KirmAiBORdOFLO2FwclEKpjrYQukaktkQ+RkovLDaq1+r0C1fp
	 fm4XqByVg9VNamCB2mXKtnXvEKVs35AI8JxmKSggQh8Dsk/Ra9r1+6oKxE9ZFmn12f
	 W7+wCzo8OT93KdrdRJmNlOIW+8nPHe7Fd7N2mHhPsh14s4FQTWNC3DNA6c4O2cvUC4
	 wzmSNaN/HXFOOJ4nsLCGj7jnpnQgueFq6hMcHhCvOSLgRCtSnNYoOFlnpvShhx3GFX
	 KcuX/ySuabCCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFy-00000004ny1-1XO4;
	Tue, 14 Jul 2026 09:16:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 16/28] KVM: arm64: Split NV-specific exit fixups from the non-NV handling
Date: Tue, 14 Jul 2026 10:16:29 +0100
Message-ID: <20260714091641.1970822-17-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
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
index 8460a8a6745b3..e26cc575e60e1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -534,18 +534,15 @@ static const exit_handler_fn hyp_exit_handlers[] = {
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
@@ -562,8 +559,15 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
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

