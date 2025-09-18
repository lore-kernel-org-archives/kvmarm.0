Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4054224B09
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208468; cv=none; b=C7Ces3kWeuXPet/7O89cmLG6wqlWzPyjsfUiDH9/BqSzACCedAa5/EMXB3K3z46vQgkU5eNP04GzJjBuAKzBsB9EsBKs9RVNgdd2Mb40qA0ZJoi1J3iInyk0Em8A0O4xD5V5Ja9yZs4AEkTTXMJqztwDC/jLBj4V8sW0CuQMz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208468; c=relaxed/simple;
	bh=6jGnFcZBrQ+wDYBngB6mrU39fbKG6WI/sLlnxGwzCdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BPy1+RBdYt0TV2DOTMNOXdH8xOTpYxLRRWXOXDU6X56eJkcPj1QaBZ71jmGMWHSteBe9gFVUKrm7s+hUeoQRo7cj1Qph02pHqDeC41rnwKe9Hhj60TCFurPHxr95DjVVNDRoJprUgOrQPdoerOZU5iVoCHdKVtZ7HJ722qh/AsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPXm5j2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPXm5j2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7B0C4CEE7;
	Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208468;
	bh=6jGnFcZBrQ+wDYBngB6mrU39fbKG6WI/sLlnxGwzCdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPXm5j2mdkJ9OBKIqOQX73W2itriaGnc+7a151MPHxMhu11/rBBu6y96jmXrZBtJb
	 nZp3rxMLPMAngWwfW5rSCfa8963//EbhRuh2qvlWcQDl/pUrhL4JenYNZMPmwI2DkT
	 DzAScmcnLjgms9i+GIf8w3SMUoqIYcgONRDUhYqP4LMDBjy9xDonEr+ip7BACngzwE
	 pfFq5SkSsXAGSPw8tf5tHNCW7Ek/i+fgRdthFc/JhII1oA/vhN3OlrElLjoiwvFPVl
	 Wg2BhqwCdtVs73YzHyxFACEevBu9N8e4MRJaQxRgqkJKsoK8PmarmiVpakHgx7wOxA
	 N2zXTi8CkCqLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL4-00000007TmF-1fwx;
	Thu, 18 Sep 2025 15:14:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 01/10] KVM: arm64: Remove duplicate FEAT_{SYSREG128,MTE2} descriptions
Date: Thu, 18 Sep 2025 16:13:53 +0100
Message-Id: <20250918151402.1665315-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250918151402.1665315-1-maz@kernel.org>
References: <20250918151402.1665315-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Turns out I'm rather bad at noticing that the description of features
has already been added. Remove superflusous definitions for SYSREG128
and MTE2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index da66c4a147752..d85dd05c00b0e 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -131,7 +131,6 @@ struct reg_bits_to_feat_map {
 #define FEAT_SPMU		ID_AA64DFR1_EL1, SPMU, IMP
 #define FEAT_SPE_nVM		ID_AA64DFR2_EL1, SPE_nVM, IMP
 #define FEAT_STEP2		ID_AA64DFR2_EL1, STEP, IMP
-#define FEAT_SYSREG128		ID_AA64ISAR2_EL1, SYSREG_128, IMP
 #define FEAT_CPA2		ID_AA64ISAR3_EL1, CPA, CPA2
 #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
@@ -143,7 +142,6 @@ struct reg_bits_to_feat_map {
 #define FEAT_LSMAOC		ID_AA64MMFR2_EL1, LSM, IMP
 #define FEAT_MixedEnd		ID_AA64MMFR0_EL1, BIGEND, IMP
 #define FEAT_MixedEndEL0	ID_AA64MMFR0_EL1, BIGENDEL0, IMP
-#define FEAT_MTE2		ID_AA64PFR1_EL1, MTE, MTE2
 #define FEAT_MTE_ASYNC		ID_AA64PFR1_EL1, MTE_frac, ASYNC
 #define FEAT_MTE_STORE_ONLY	ID_AA64PFR2_EL1, MTESTOREONLY, IMP
 #define FEAT_PAN		ID_AA64MMFR1_EL1, PAN, IMP
-- 
2.39.2

