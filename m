Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110FD47140C;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706179; cv=none; b=s/Y5zs6p8k1KzB6cHmV+wsqGkY1fnnIzkpcVejG3nJncOUS/H3pV1IPKGXyXxSaioalrV07LlNRoeUg4GFAHKiHODzvXQSXldH7cibGCpokzM7yhDBtheoaXg2q7No7jrK0h8xaXwPmPUUrjjlSF+bJB/iakoIuHrI7SAmI+sQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706179; c=relaxed/simple;
	bh=KWU70KX0tFQDCTwjw+AhlaY2OczDd8WZ7jdJiKpJv7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+ROB7O6b7znj5HJ+Txsxj1tu9ZS+2eW90H0Dz2lsC4km1envf+5q8A3ZRBnnEkKR5eFV7qul0LFEQkRvWYgj54XBu57z0W/cZXP12GC6UOJc+d3WTXTfyP2MD1K+kbNeM5GiX/dHuaCt6f/QWNgpIQklDce2QWipnRmhRs+fkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WejH/5Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WejH/5Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DFF1F00ADE;
	Wed, 22 Jul 2026 07:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706177;
	bh=MJqhkCIE3M8tbIb7660VksyabSZHni+DFQYUe7gvf3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WejH/5Hilz6maKALvEN4gyrkWQZyum1OeSyIkA92Y8VeWWzM3CKKPr1Xy41lKgynt
	 odDjOyt4bTG05sKfXzuCHPUnQD+WMj7/PSxKo+5gqf9RM0iFmCL/jdGltqMLri4ELP
	 fyHuLlIjpJgGclMt4EgRlpmEhNVuUoYXSGgUSXdSQ470/VCSUhu0nQ4/cWBQssLQeV
	 xuNE5ro4doLB2QbhM3RrDntEl+UFR34OBLvzJAI4VtTBU0iTun8NqiFux0B0lAag1x
	 mfLBRX/sZ7QXxWTiJXtRkN5yzWG8ktUYK2ZcO1R2Ds0EuFTeOZiSMZIhKqroBdHLOk
	 0wlhMcilML+SQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbT-00000007VfN-3Lj8;
	Wed, 22 Jul 2026 07:42:55 +0000
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
Subject: [PATCH v3 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET fast path
Date: Wed, 22 Jul 2026 08:42:13 +0100
Message-ID: <20260722074234.3330999-8-maz@kernel.org>
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

We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
set. This is an odd check, as NV doesn't mean much if HCR_EL2.TGE==1.

Similarly, evaluating HFGITR_EL2.ERET makes little sense, as
this only applies to the nested context, while the ERET fast-path
is purely for the benefit of L1.

Replace these bizarre checks with is_nested_ctxt() which makes a lot
more sense: if we are running an L2, the ERET trap must go to L1.

Fixes: dd0717a998f77 ("KVM: arm64: nv: Fast-track 'InHost' exception returns")
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

