Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1006B46D08B;
	Mon, 14 Sep 2026 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388833; cv=none; b=M9KBI29pFm8baXjjzuo7V9hkwLXgyJpVAFVhGfcjLdv/atGHBdKMFFhd0By8eaDuyAWikK4NXEioD9LVF+MJtbm2SiohmnUG76J7hIxbyV/Qh3EM5BBvOgZ1Lg7Q2e9XAs3vN41jB4LqDyNfAjsT63gl2U9j0le+k2MzTrBGWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388833; c=relaxed/simple;
	bh=Y4FlysXiT+xF7JlukrCtrhUE/JomIeYHyF5yaw00498=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fn83WaI4CoSPqZ4Jzs1q1VW3rrNkEfFQ1DriF83qYWRSvxejRIAXnUSe00Z1JmrkWuLYfHDDSdBxljQkQgVmj+CgrWLC+jxuPzm0PK0zuvmPzyukvbFYpnGaie67Zws5M0f+buQUDJrg8NtsUU6nUujD0EhpLxYUQCVRu8OV3ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BD0J6OC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BD0J6OC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B441F0089D;
	Mon, 14 Sep 2026 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388831;
	bh=iKvODBKPVjNkw+FyDfWvIqPPmR7jxIaTnYa7ga+H6Fg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BD0J6OC+lga4CbFP4aSfvYa6SYSaAKYvgPlAAhSvC0RQdhWy3MFA3LYh/OVFwfjvR
	 GQOA/NE4uAuWzSqCpT4H1D9nLxYeKTFKXuGfMZTUgmWeQkbay5w2f8zLRI33pyzLPf
	 uAePava7AOMmjWZcuKXwb2ZLHV0Ns0Vdp6k1xbzuQenZGqPZ4AD0Olo0nFyzVaiM81
	 Ckm7xEOMJkyJEHi5jCsLST9ccJTHbr70FgrTc1Q8GG9ruJTXxjE5Xtc3AKc83GjWGO
	 jxM1VYM0PWHF7JJeqMfR8xe8riXjAI68aw7QUbB/kgvE0VjnP8uWobo+PX/2LOAaDT
	 CZRCIKWYr54dQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:17 +0100
Subject: [PATCH v2 06/13] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-6-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2249; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Y4FlysXiT+xF7JlukrCtrhUE/JomIeYHyF5yaw00498=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/9a6DvvzsJ/B8rz3ocsCvnIcmyGyjkn6+Z/nVef/
 nq77POn6R2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYyLIbjAxT9s+Nf5IdfJw1
 pfKYjJTy2bc80ZHikQce5WtXJ56zfcTH8IdT8dv6HPMaVsfjS9k+c1Te9fqSZPBsO+ehNY9LHfe
 8Y2cHAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

topup_mmu_memcache() sizes the page-table cache from
vcpu->arch.hw_mmu, which is the MMU that faulted.

Pass the target s2fd->mmu instead, so the mmu used can be controlled by the
caller.

For a guest abort this is vcpu->arch.hw_mmu, so this commit introduces no
functional change in practice.

However, it's necessary for a future change which introduces stage 2
pre-faulting which must always target the canonical MMU regardless of the
vCPU's last-run context.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/kvm/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 13541218cadb..8c23fef4ecf8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1554,9 +1554,9 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
 		return &vcpu->arch.pkvm_memcache;
 }
 
-static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
+static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
 {
-	int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+	int min_pages = kvm_mmu_cache_min_pages(mmu);
 
 	if (!is_protected_kvm_enabled())
 		return kvm_mmu_topup_memory_cache(memcache, min_pages);
@@ -1654,7 +1654,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 
 	if (!perm_fault) {
 		memcache = get_mmu_memcache(s2fd->vcpu);
-		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
 	}
@@ -1755,7 +1755,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	int ret;
 
 	hyp_memcache = get_mmu_memcache(vcpu);
-	ret = topup_mmu_memcache(vcpu, hyp_memcache);
+	ret = topup_mmu_memcache(s2fd->mmu, hyp_memcache);
 	if (ret)
 		return -ENOMEM;
 
@@ -2159,7 +2159,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
 	memcache = get_mmu_memcache(s2fd->vcpu);
 	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
 	    is_protected_kvm_enabled()) {
-		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
 	}

-- 
2.55.0

