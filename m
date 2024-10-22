Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710D2199248
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608023; cv=none; b=e8dSaRnG/kAHUVbM7WIFZcH5d5Z99VPVhxRsSFMifCcVSEWhiFpOTG9ohULIEB2oC/OL5AkpdrxMUpeS3cKgw13V3inDoklLViLiorTe5YXry4X1sJrAXJXLuqnre7NxsXT+vLh+YFxfcd4EKi4FnGB7niUdXFABetQE13MLb7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608023; c=relaxed/simple;
	bh=OiX1pDTPcyDAhIHmZUWZEV/cXKJscPtv9OwJmaPy9FU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FJv66+QctmiDPdFoPwx+qNA7ZD0INPHz7JBZaHsVGYJZ9HIqO1/4cegqBZIR6iDubiRt5XEEGf6V0Ty49zQc0wdDX5xt4NBRltnZlxgIhHds/GYhi3lAymsPqygG+1WJnHsn95lAdmWDZxJR/Z/aCWx8EYyA4QhT4M9BZqW5qnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5nJ4K2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5nJ4K2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95D5C4CEE6;
	Tue, 22 Oct 2024 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729608023;
	bh=OiX1pDTPcyDAhIHmZUWZEV/cXKJscPtv9OwJmaPy9FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5nJ4K2QIKNRJ5BkEJxD0f10CqsAhVH4tcBG9F2N/jNw2LKura2LxDK7WvRB8WP5c
	 qWK0KBXuOK3mOdJIL4KYtfj+al/tLdqPBCS6M9UHMoA37KQlTpJS6TdWXtPQIP4pcV
	 8sJ6NGr2ZQsit08QglOHZEvAKxrCsv2Z009mNtPXw3iDunqXIUGtg6kC8WqS7a0IAm
	 Ucvlp4aR5XlOYwF2gkp1wWsVRuhF7jvzIQohvHS4b5HswzNuqdtNgSUZeky6vf5qiz
	 69Bep19I7KJIYaWgDqkvqiNcRPhzw7mwHAEcKwhHu3lCItT64fxisgvRGs7WxNEk29
	 DA3JZ6JuoUMdQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/2] KVM: arm64: Just advertise SEIS as 0 when emulating ICC_CTLR_EL1
Date: Tue, 22 Oct 2024 15:40:15 +0100
Message-Id: <20241022144016.27350-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241022144016.27350-1-will@kernel.org>
References: <20241022144016.27350-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ICC_CTLR_EL1 accesses from a guest are trapped and emulated on systems
with broken SEIS support and without FEAT_GICv3_TDIR. On such systems,
we mask SEIS support in 'kvm_vgic_global_state.ich_vtr_el2' and so the
value of ICC_CTLR_EL1.SEIS visible to the guest is always zero.

Simplify the ICC_CTLR_EL1 read emulation to return 0 for the SEIS field,
rather than reading an always-zero value from the global state.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 18d4677002b1..3f9741e51d41 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1012,9 +1012,6 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
 	/* IDbits */
 	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
-	/* SEIS */
-	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK)
-		val |= BIT(ICC_CTLR_EL1_SEIS_SHIFT);
 	/* A3V */
 	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-- 
2.47.0.105.g07ac214952-goog

