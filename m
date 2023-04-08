Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDDC1FB8
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49646C433A1;
	Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680969891;
	bh=US5LgOkEdpl62fowcQRVYLy7fF93C93CA99kNdbfIwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCY4S7kWTdXK/2/LcY/9XEjNkufz63Sd0hwrG/JptxZTNYLbu/WqS40lujYVz+ZyM
	 dLRFUiN67+D/4BoIJOTNfc8v6spJksqUO3mHZCNdnjPh81DOSmVUBLZn3PrTccaslR
	 KFneTOaNzZd56mLaPylMgBG/NVMyjgMji6ZXuUz9oIc3jB6HrT7P2o5HLoOWQrLDHT
	 ePL92dtJijcNAXz2QtB/IAqVymYUwSOBJStvNOB6kh7Id3kdPnCWkNF1anUkXWSMHZ
	 zJrCQ2/PJkVjPD+PJBsAH6svMfoTrshwiy6FO4Ba6Peiu5KDylHKemcjIX/WxQVq5/
	 /ukYx8WpuQJZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1plB3Z-006wc5-9n;
	Sat, 08 Apr 2023 17:04:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 3/5] KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_poc()
Date: Sat,  8 Apr 2023 17:04:25 +0100
Message-Id: <20230408160427.10672-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408160427.10672-1-maz@kernel.org>
References: <20230408160427.10672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We rely on the presence of a DSB at the end of kvm_flush_dcache_to_poc()
that, on top of ensuring completion of the cache clean, also covers
the speculative page table walk started from EL1.

Document this dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..2e9ec4a2a4a3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -297,6 +297,13 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = host_mmu.arch.vtcr;
 	params->hcr_el2 |= HCR_VM;
+
+	/*
+	 * The CMO below not only cleans the updated params to the
+	 * PoC, but also provides the DSB that ensures ongoing
+	 * page-table walks that have started before we trapped to EL2
+	 * have completed.
+	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
 	write_sysreg(params->hcr_el2, hcr_el2);
-- 
2.34.1

