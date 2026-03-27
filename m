Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7031623E330
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639693; cv=none; b=j1OouyeTnnlz7z+R40RoIPAo10vpgKdmjpeagYyE8Pgw5GxN1jEPrNd2kZEotSq1FftzbsBrD384HzqAAtZhDcKLNe/lvCJM6ijMchHF7a16dSWQWbJx/Ny4WLhuo2XqLuS/xvHHU0R3kebJ2uPblMDCbZ9OukPke8zYt9IdOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639693; c=relaxed/simple;
	bh=yq2ota2VO49Q0+/CyqaatJG112O6ZocHYaW5aOeSzjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk0JB4i9V4Dq80uiRq9wMgCx85EsWptlXECN/Cfdv+lA0N5unXWI0CdVASuL8SuG7K0Oxzx8AiaiyNX18kODiSRn0ADdcCtPRD7k62XYJZEbTWi5+ysaCh6m0grzGBUYFJyuRq0gSSCeLUlIxANeqqmWREaziBb/fMHEWCjVKRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFhHYHtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFhHYHtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581BAC19423;
	Fri, 27 Mar 2026 19:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774639693;
	bh=yq2ota2VO49Q0+/CyqaatJG112O6ZocHYaW5aOeSzjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFhHYHtjs+gJN5kCmxel6f7ptw4DSU6tJYESvFiTA16QurJt2PkxVYB6mj8JqNYj6
	 JywLPM6dr5kAIJaLLjhhgWgpv/rSTbl1tMs/dS95eyBeJPihVHsEP7VxIiE6z99LYv
	 91wVA5Im3L1slEOpDwEo6SbJaj/XRxwP73f7RqzGLwkRpaqnenEd6y3DRoteKnIMxG
	 ofe2wJj6dpdbTTYU88ZvPQaR8Zo/MxLlM69xW87X5pwBYGxKScqigbDnyskBypgJEM
	 ven7Dp1kUluaFUmrBxTV4jpa69Ma+g60tL2ou0xJopnloTbQUQul7AVqCUB0NCor3V
	 X1VT24VltJpvw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: Don't leave mmu->pgt dangling on kvm_init_stage2_mmu() error
Date: Fri, 27 Mar 2026 19:27:56 +0000
Message-ID: <20260327192758.21739-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327192758.21739-1-will@kernel.org>
References: <20260327192758.21739-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kvm_init_stage2_mmu() fails to allocate 'mmu->last_vcpu_ran', it
destroys the newly allocated stage-2 page-table before returning ENOMEM.

Unfortunately, it also leaves a dangling pointer in 'mmu->pgt' which
points at the freed 'kvm_pgtable' structure. This is likely to confuse
the kvm_vcpu_init_nested() failure path which can double-free the
structure if it finds it via kvm_free_stage2_pgd().

Ensure that the dangling 'mmu->pgt' pointer is cleared when returning an
error from kvm_init_stage2_mmu().

Link: https://sashiko.dev/#/patchset/20260327140039.21228-1-will%40kernel.org?patch=12265
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..34e9d897d08b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1013,6 +1013,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 out_destroy_pgtable:
 	kvm_stage2_destroy(pgt);
+	mmu->pgt = NULL;
 out_free_pgtable:
 	kfree(pgt);
 	return err;
-- 
2.53.0.1018.g2bb0e51243-goog

