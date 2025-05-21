Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120CB4B1E7B
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 11:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825493; cv=none; b=JOO7UzDfPnW+WmwxAVPKLksHDsiAbsl7p5vB/fY1aKX6APAapnBnUL0SqlEmnnvVLm4W3LLeadrAn4szX2F2KSZIRu/pcDNTXxelQEm9aR7RDMKuG+ZlyDOvLygTkvFGXbqv21rWGVOc3FQTHJ3LQLrtjVu9bJzwh4NO+rnOOzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825493; c=relaxed/simple;
	bh=WJdu57W6UhDvcHCfpgC+UA9weTaVsrZwvOCeKead1G0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WqIphDi/35HE+kodNIUX7yn8a5pH1QNUeLGK1cwmnyt/59bUzFl7AJqYTa74kQwELzrQnyLrBud8OLE8fiCVYnHuxhBSYkn5RZ8yuy5vHehS776NKuOnufQK9cm7YJY9dfWk2dLsld7mwA11gORoVQxcLUXh1pQ5nr6dzo2NA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2db5NFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2db5NFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8672CC4CEE4;
	Wed, 21 May 2025 11:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747825492;
	bh=WJdu57W6UhDvcHCfpgC+UA9weTaVsrZwvOCeKead1G0=;
	h=From:To:Cc:Subject:Date:From;
	b=f2db5NFhShu2tICwJNJQFax1HAv25M/sDmZZRWTxQsEPnxBJ8HCEWWC77Sj+kfS3n
	 yQHXYydq8WtpxCjpmlUeizYLrSs0NQ36I1EcDoYj5QMxk55tXWa0NIHnkkmpwbXMzy
	 kfJYEEmMWA6odT5O7UdPZ5h/4T2iMp7mVipKM4jscO3pd6QeXmj3Rk10OMoA/sgyHS
	 z4VDlw1O+z+Ewo4xv5cWDTy+/BhaK8+1ZnfWgjmxLHnTFyCszOrA5882mOIRccLR+c
	 lsD+TXJp8ObQZPghLFMdSMU36zwZvnOEcJWWFZTgqqu9X8mdGc6emjKDp9uAWdLPOz
	 fBKdtbK6ZRVIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uHhFi-00GuEZ-Ca;
	Wed, 21 May 2025 12:04:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: nv: Release faulted-in VNCR page from mmu_lock critical section
Date: Wed, 21 May 2025 12:04:35 +0100
Message-Id: <20250521110435.66273-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The conversion to kvm_release_faultin_page() missed the requirement
for this to be called within a critical section with mmu_lock held
for write. Move this call up to satisfy this requirement.

Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2381663d2ee98..e7e71f1615f19 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1228,9 +1228,9 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
 		vt->cpu = -1;
 
 		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
+		kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw);
 	}
 
-	kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw);
 	if (vt->wr.pw)
 		mark_page_dirty(vcpu->kvm, gfn);
 
-- 
2.39.2

