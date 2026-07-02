Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFFE30D415;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008183; cv=none; b=nAqigP8e9790DG+mNOYBDHwOHml8wRB3yzlV2TCFEQtjm5jCdgOaMVOAgY+6Wihh0l+D3E86BqQ1ZAXVxLFacpAjJE4gtdr2+7SNYR3qsUJkLjq8mf2mMkRCGomrPa7DJAwOM6Q5B1faPhgoT8Mb08UthDcaYE6O/zV2iEqjF1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008183; c=relaxed/simple;
	bh=MtAJZYgazm0g6ElkRPPG6jwawo4QFpDdto1ATHG/0pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAN8r0uIN/Qi/yIU8cOy+Y8olFtrpOf5el7kkNVmyDUd5lpxwpitfoRlXqVIvF5h+2BAQ7nkvJGBLvmYdS98qOcyG5tdRRi3DXl0scp16FXMhiYhE3S9uaMwMEOgQ5h8+gAlBvefldkEcLyHJrYQc9YcpWQMj4fMcfDK78BB/8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGD/5/is; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGD/5/is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C271F00ADB;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008181;
	bh=3b57fUmXrFyOVzzlOsTfO/957aLg/iVp6bk7RPxjuoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGD/5/isl1tuVmv4gPdYEju4C4j/QC/2bzeGeO6fLt78Wrcf5aOFZMpynKQwILnBQ
	 KV01VT2CKjp9ob3F86U0N/eOh928NCykEvhmRg26XRkDxg5G9M9Dak4EiGUJGLcnyj
	 SrcOsrNvD0xwb7MW6t4sVVJyTkBPXGyq+nbxYEwvI58CGM5RbhWFd0KxekWjae3vSM
	 5DDO/0TcVvBG7d8Ak8alGnhSQ2A5RccdwMequV+KX5mfPcYkDCvvsuyBU5CRgNc7+y
	 /rg2UYHBldjh89aB/HeEZBi2GZy6uCD6cuGIZ5Z4PoyK2jJUQH4Ug3aOYMMoI1IWkZ
	 0jr/f8CLY1oXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsR-00000000ojd-2FZi;
	Thu, 02 Jul 2026 16:02:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV on ERET fast path
Date: Thu,  2 Jul 2026 17:02:27 +0100
Message-ID: <20260702160248.1377250-8-maz@kernel.org>
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

We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
set. This is an odd check, as  NV doesn't mean much if HCR_EL2.TGE==1.

Replace this bizarre check with is_nested_ctxt() which makes a lot
more sense: if we are running an L2, the ERET trap must go to L1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d5..3b76e0468317b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -349,8 +349,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Unless the trap has to be forwarded further down the line,
 	 * of course...
 	 */
-	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
-	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
+	if (is_nested_ctxt(vcpu) ||
+	    __vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET)
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.47.3

