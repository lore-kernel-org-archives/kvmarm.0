Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8B9382394;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611387; cv=none; b=hC8Ywv/a66z9S113sglfoigi9MbsaERnOUwa+QDmkWWM+FZjxPhpoVyOFQWHTRR38RokJUdDDl/xNSRyHLQZAb4dJ2/haCquWFfEJINBBoUVnztKfRenPWwavdkx1XqWbz4jIBBq23jVJKV3xfZr6fbgbqCIBr2xtuQ6jACwuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611387; c=relaxed/simple;
	bh=JLaNnn4Z96cQuZ+mgviskKs9pjvRxJpA5npZ1PilnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5K7MPjADW05RZOsSi8NTI7Se3ShmZdNoGuEAIxfWxQIs5Pz2bwcQCLQDK1W9PPfATIO1OXLDjgDkp+r3DPXNaLSQzaZS12IZwRhfQ8Bze3BTM/wSn9W/a86TbO6c/ZyCtr4R63pPMV4r5q+CrYXmvjNtwWza0vMlpwH6e1HfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1DulSSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1DulSSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FC8C2BC87;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611386;
	bh=JLaNnn4Z96cQuZ+mgviskKs9pjvRxJpA5npZ1PilnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1DulSSbA+vnqnf2XVW7GeXoX4/gyIFkgDhEML58oAQyyhzHasIp1fVFju9X6MrzQ
	 XMwhhvn0DACeb9gWhsKO/MXry46J+9g1B1j0JvTQphRcvHFkPJa6nV/bhhCbN4c0BT
	 CZUjZxopHS9NxCbl/dfcqmIzepUgC6j8Jn+ieD+DzkeOK/9ODcnRCrTxTrk9x4rV5l
	 IFTLbMAIHgM165kWsOCpBYDPu1r98trEfeZgFqQkwaL1MioPYaRCXJpjsRVq5d4gkJ
	 sfSstYq4eaRa9fbx8aFFs2iHO3uOuAm/TEWCMyavDSU3fYU6VQsjODeuJu8ZEg7Pe8
	 6+uTzJLPDDxQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UG-00000006K4a-37HP;
	Fri, 27 Mar 2026 11:36:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 11/30] KVM: arm64: Optimize early exit checks in kvm_s2_fault_pin_pfn()
Date: Fri, 27 Mar 2026 11:35:59 +0000
Message-ID: <20260327113618.4051534-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Fuad Tabba <tabba@google.com>

Optimize the early exit checks in kvm_s2_fault_pin_pfn by grouping all
error responses under the generic is_error_noslot_pfn check first,
avoiding unnecessary branches in the hot path.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2b85daaa4426b..0c71e3a9af8b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1791,12 +1791,13 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
-	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
-		return 0;
-	}
-	if (is_error_noslot_pfn(fault->pfn))
+	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
+		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+			kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
+			return 0;
+		}
 		return -EFAULT;
+	}
 
 	return 1;
 }
-- 
2.47.3

