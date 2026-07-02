Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2B2C21C7;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008181; cv=none; b=a9DtSt5J4davvl+q4oznOmzSmMANgvtgvzI/0dPxK5FcslgsWqD33i0e5zzMMzDPtbk7ZDWKpU25aopHSwxLgUeoiyJ3+Q7nfWxV0MxEbbNq0haWYeq4crd6d1d7lkRWwFrm6Jd4AGY2vd9BZnqg9kgs/nM+oJ2am7o93sFbxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008181; c=relaxed/simple;
	bh=kiLJ6Ye2ZU4RIqvOn/Er9MZG3Ljc/QKrIPthp2UnVrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt0Kxrsxhtxw+nD2SZiGPfz8/GRuq+2ISTBRDNJgmG0JvpTdVE1DCYoi/7PB3h+peBMCXQe1xwFVLPAqI/t50uTDwJCNScdVEJgk76gToIaFuPKhWIzZI+72Rg0UK8hmZ6QhrCaluXbovu5penoIQqiMOJgQd34wi6FBGokfmIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnXqomTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnXqomTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D4C1F00A3E;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008180;
	bh=gvrrbJTL90HdKfSM8IpDXKokn+aRKB1T3PPohkJWp6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnXqomTVwOsPxDPWwwRWthqmZoBpsg81HyJRcBI4Oo0rcTG2El9BqM2CctBdqzBg8
	 TN8bXDbshlLTRhPIU1eLTWDlALfCgZwW2EgMCYe/RoVpR4RTCi0t2/TUT3oKr6Xzy5
	 uGujHgaOitcRFc6G0LLsx0k8aIdORIq+wnb0XgDux3L8vHIatRjLPwWQzfVuIaj/MA
	 2LikL3AW5Q7+VPsBJLUBzXM6q/xmCxuVpGvHqskEYIEJfHRR9NZCeQKeqpjrNUgLm1
	 +K2Wr4x36pkDtnoWRcndO7Z7yQ31RFPiiYPaGLxXyQD0RXpRRuNV10XZbfVGT4fQgj
	 r+2tq/PDt5Pig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsQ-00000000ojd-312O;
	Thu, 02 Jul 2026 16:02:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 03/28] KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
Date: Thu,  2 Jul 2026 17:02:23 +0100
Message-ID: <20260702160248.1377250-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
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

