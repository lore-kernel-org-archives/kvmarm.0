Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9203471268;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706178; cv=none; b=LmQy1Y+zuOCSZ31ePypax/QFl7QfmMwUY56xV61P15XbO4Vt8ffHJL2p50OH5P/7c/Nos5r6FA7WpcP4AYSxhXIq/y3Lgl68WhqzMVXopLEgpvCb1e6nzThs26udH+eO0gdYi2q1u8lHKnP3aj/8RVg4SnLZHX63+THL+/SfS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706178; c=relaxed/simple;
	bh=mTOEGmhZ7jOufvcxtJKFGGp2qApnl576+Q9IYSG9vnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbjjkTDL/0Qwqkum8tCl6KKs9HSQreqaKuBwR/liRA0gXlNwRn5jODsXyj6YHscUkZfxMK2UyY7TTQYp4aIJalaILHMyGmtDz+MHbr8FsIFhtTTEELHUEM2X0lC/mBEwklOw373CSUFlV7iz9IJ58Cot9GXNuNjwsQoCbXCvoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGXWfeH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGXWfeH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4E01F00A3E;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706176;
	bh=NUB9M22I6lR5cIA4XgQ8HOaVa6MjFO6+CCyfQOO+5Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGXWfeH65qo8S0vJpI8aSz6wdBn5ctl9HqUq7XwSb0wdxMVw9eqUpzK9rMdq2oTY+
	 OV7NM0ubWod5uiAfy5Tt6mMeOATcT01M2k0YfTBzeuJOmSKsqU9MEk18+6BjzeEteS
	 M30u5ZOG6Qh0AeOQ9BpdYvnEHmc7Q0dFygBXgoPm57jR6r1Gkk+LnuiVaQJn1NXZGD
	 gx+JkJ3ffybIEYCVH8Dry8ZKwL/RdyQ3jZpSrcMJArUutNhEZyMW+NswgcUx8s6eT7
	 vvftP4Dz7z6w1XMUXD7Wpf70r1xXyenhfX2/CFxLSAD5GejNCUCDOLwx6hbTnBgRHV
	 F+l2OnxAm6zfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbS-00000007VfN-3UI4;
	Wed, 22 Jul 2026 07:42:54 +0000
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
Subject: [PATCH v3 03/28] KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
Date: Wed, 22 Jul 2026 08:42:09 +0100
Message-ID: <20260722074234.3330999-4-maz@kernel.org>
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

The way we merge the guest-provided HCRX_EL2 value with the host's
is bonkers. We try to make it look like the FGT registers by using
positive and negative polarities for traps, but most of these bits
are not strictly about trapping, as they actively change the way
some architectural state is managed.

It would be far better to deal with these bits like we do for
HCR_EL2, by enumerating the list of bits we don't allow the guest
to override. This is simplified by the fact that HCRX_EL2 only
affects EL1, and not EL2.

Re-jig the HCRX_EL2 handling with a macro that list the bits excluded
from the merge (TMEA, PTTWI, EnIDCP128).

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4bf624a49591d..8e5f492f39086 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -325,6 +325,24 @@ static inline void __deactivate_traps_mpam(void)
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
 }
 
+/*
+ * Just like for HCR_EL2, we can't let the guest mess with some of the
+ * basics we rely on in HCRX_EL2. However, the major difference is that
+ * HCRX_EL2 only affects EL1, and never EL2 (sudden outburst of sanity, I
+ * guess). So it is always the guest inflicting it on its own guestx.
+ *
+ * Things we don't want to let the guest control are:
+ *
+ * - TMEA: That's for us to decide how an SEA is routed, not the guest.
+ *
+ * - PTTWI: Similarly, it is for us to decide whether Reduced Coherency for
+ *   the PTW is a thing. It really isn't.
+ *
+ * - EnIDCP128: We don't allow IMPDEF sysregs -- full stop.
+ */
+#define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI | \
+				 HCRX_EL2_EnIDCP128)
+
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
@@ -350,8 +368,8 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		u64 hcrx = vcpu->arch.hcrx_el2;
 		if (is_nested_ctxt(vcpu)) {
 			u64 val = __vcpu_sys_reg(vcpu, HCRX_EL2);
-			hcrx |= val & __HCRX_EL2_MASK;
-			hcrx &= ~(~val & __HCRX_EL2_nMASK);
+			hcrx |= (val & ~NV_HCRX_GUEST_EXCLUDE);
+			hcrx &= ~(~val & ~NV_HCRX_GUEST_EXCLUDE);
 		}
 
 		ctxt_sys_reg(hctxt, HCRX_EL2) = read_sysreg_s(SYS_HCRX_EL2);
-- 
2.47.3

