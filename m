Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4803B47F7;
	Thu, 30 Jul 2026 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395461; cv=none; b=lcd0eTsuMfWlZGBs/9NmAh35g7TuDRv84LghQJAoVFO1wGbSFAJ0NzL4BJZigfoUqihfiwHXNb7gLHahoSkpIW+Rwoi2w5+V2+30Vl5t7dQqpyQWcRhAzVQo5X9AB9lNOHuo1PzzuqICJfE5O/ZLfOxzJ8Sl4FkiYVY7oe7mDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395461; c=relaxed/simple;
	bh=frXsTw0CZJSHp9d6YujsQpbV1DBLRXcmPcWyoGbJmcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDDMCd2OASISD8Ien+6mBFT/lfqfHwTYqnY0vkY3IsRR/P27pLJRiuy1gfr7Jf1oZWfaGZI6WnT5KlFbL8SGWkajw8IqKETjafKNjk47r+krfvS1OUlTTdEMe2LOSWg/m5KzCTj0hxa55dUBgobh5iBgHbY2ryGoCovF9sEJU/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GC5jL5Yv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GC5jL5Yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B21C1F00ACF;
	Thu, 30 Jul 2026 07:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395451;
	bh=G9+ykDGTeX7ssPXU6PioVfASuLM5szFW8JhODOwghig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GC5jL5Yvk3BBNxpeTcyUiE43rRWpQGTSSZXneAYATTMu78kPRAkabECkPXFd/hZJg
	 XbNkATTY/QzRuwSZbY/CElX45F2sd7igxN2sKrl6jAoH/6cFFGo22lW0IiQVK7L7ak
	 d0ZO7pk3/ceq9ovY8X54Qr33YMBXyOgj4sOVmt9Gx/P8NWxZ8qNb7wpI5RgAQjZeYX
	 oulSL2Fyk5L8kFMCAIGXt9s+sZmwaIQ8L+4Mf9XJuDKFfO9ng/YMWr5E6Sisa5OoQo
	 WjYE7Hae8/EhMDj2+uA5xwCO7gTCcYXWcEtazsQH7cnVur3D4UJuC5s2Wz4xGsb9Ng
	 1I9D+etpVw71A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKun-0000000AOpW-3bIa;
	Thu, 30 Jul 2026 07:10:49 +0000
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
Subject: [PATCH v4 07/29] KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET fast path
Date: Thu, 30 Jul 2026 08:10:00 +0100
Message-ID: <20260730071022.296811-8-maz@kernel.org>
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

We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
set. This is an odd check, as NV doesn't mean much if HCR_EL2.TGE==1.

Similarly, evaluating HFGITR_EL2.ERET makes little sense, as
this only applies to the nested context, while the ERET fast-path
is purely for the benefit of L1.

Replace these bizarre checks with is_nested_ctxt() which makes a lot
more sense: if we are running an L2, the ERET trap must go to L1.

Fixes: dd0717a998f77 ("KVM: arm64: nv: Fast-track 'InHost' exception returns")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d5..684cebf23aa0e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -344,13 +344,15 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * if this is a VHE guest hypervisor returning to its own
 	 * userspace, or the hypervisor performing a local exception
 	 * return. No need to save/restore registers, no need to
-	 * switch S2 MMU. Just do the canonical ERET.
+	 * switch S2 MMU. Just do the canonical ERET unless we are in
+	 * nested context.
 	 *
-	 * Unless the trap has to be forwarded further down the line,
-	 * of course...
+	 * Note that this is made possible because KVM itself never traps
+	 * ERET when running an L2. The consequence is that any ERET trap is
+	 * the result of HCR_EL2 or HFGITR_EL2 programming by L1 for its own
+	 * guest, and the exception must be forwarded to L1.
 	 */
-	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
-	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
+	if (is_nested_ctxt(vcpu))
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.47.3

