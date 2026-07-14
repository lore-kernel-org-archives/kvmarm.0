Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF3443E4A3;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020612; cv=none; b=RvNH+17surDuZgDZqj5YAjc1PwfQcir8iaYyFKDNMqiNr2Tp22rS9+UJdDnvczBGD6RZEklf8e7TRLofcOndq0YI2cI+N+W08SjlYL4000teZKP6v2qvT4Z5SMoeh4QY/0MwuQsiRhZlcM+NvxJJPn5I/Aqo48unsXCTHW3X4kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020612; c=relaxed/simple;
	bh=wAzutAmaHf9i1ssDoEdRaUVhFKTQILHtrZU4EsvUqQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwBnwdK2+xD9OHn/NbZ5mXTMAI+gD4le0K2MrAKLfxjkqFfxO3/bn18ukAjwXq0sIkKAK+r8bDUwl93uY4iHM1o9oE278Ms7y/KxbqYh38hcxGTRZD8OG9U55bvt4WTIV7aJ5egqgYQlsArdTct1WLbnW3HEZ3CW2fnXbmQ0ROA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cU3xx+9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cU3xx+9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D5E1F00ACA;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020610;
	bh=aXa18Ch0e2vLZlGrASFesIEpC3EeeinYhnVoxsPLqAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cU3xx+9nGoHfhJkUHxZyGSzyElamXWMe0e0YOTd1b7jQHzJ0gDDeL03EaYWmDJ6/F
	 d4iuk93JZAQ7OuN4EymGjsVnF6IPbFW1Ho62niPVMYOiU1hGtUR2Muk56K00Tr/aTM
	 TjHQOjG0Q/6Z22rgU3KOwQ44CfuUKd5pVM+IJL7hW2YZDlglGItoNAclmE72w1MDQo
	 QWL5PSV1Fj17ZmGMt+x/LsJNXnPY2tvLWOnSjyZCpOOF3xckP/MFmIfA6rdHp0TGwB
	 Sz4J/p3yNmMbnQmlEWjT2+bZKsahasDuNh/lDYXLadJwrHlaABssRvJlwo7HZuNy3C
	 PmH0gdLDSPXjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFw-00000004ny1-1uIo;
	Tue, 14 Jul 2026 09:16:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET fast path
Date: Tue, 14 Jul 2026 10:16:20 +0100
Message-ID: <20260714091641.1970822-8-maz@kernel.org>
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
 arch/arm64/kvm/hyp/vhe/switch.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d5..a83be345f8450 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -344,13 +344,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * if this is a VHE guest hypervisor returning to its own
 	 * userspace, or the hypervisor performing a local exception
 	 * return. No need to save/restore registers, no need to
-	 * switch S2 MMU. Just do the canonical ERET.
-	 *
-	 * Unless the trap has to be forwarded further down the line,
-	 * of course...
+	 * switch S2 MMU. Just do the canonical ERET unlesss we are in
+	 * nested context.
 	 */
-	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
-	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
+	if (is_nested_ctxt(vcpu))
 		return false;
 
 	spsr = read_sysreg_el1(SYS_SPSR);
-- 
2.47.3

