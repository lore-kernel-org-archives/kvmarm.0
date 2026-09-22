Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B26A5505FA;
	Tue, 22 Sep 2026 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086739; cv=none; b=D2R3ljQJVOR6TJaSSurTGi7B46Ji+fOPNjEheWgocbaGRAuiH1UpJnwdcdyQ/BTCjvDzwbg3fNIG0xhgK39esrU+nhC/FrBEvTs+ZMni0yOg3LGhBnXqp4uuWWis18VjIBE0LTnJwgSfnqH7PRZbxHwbEb9G3m7JzwQI7H0EXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086739; c=relaxed/simple;
	bh=eoI9LJ1R2FVCS/++1XTnAO/eBVHu+hbr5+7z4vbkU20=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JN8wQe9/bauJw7GL1cK10BaPpRVh6eevBt3kPo7g1JCqtlp8dxS4FB/quv1oRJhKJ8Y4Hh49Sg53LYJL0DSp0xIbKbjyWuc8bIII0IBGHutMRn1yTTIpp0I4GfV1smlREB72qmNieNwGMqfhCwu/8ZsfLN1cVBMvc23Wg5coUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOlgA7Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOlgA7Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226CC1F00893;
	Tue, 22 Sep 2026 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086736;
	bh=oxn6Ca7Nx4NbYpUu5UoOQ5jCWdGj3GIw0I/CPTd85kY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IOlgA7XuqBZ358yrxXULdyure+iaa6Mtuf80OmgbeuqhqCuTB2v0k2F6EiMDUPbPU
	 3m/CDU838Fx9Cuj3VrRqxb8fOrcMoBWMEOZ0pb0cJgO8/kJAoZNUC1PSR9LhaIy6ke
	 GfnBpClZfRSYx1HUWJ4TF5XHKGxVsG3ruLkA5eAt/gDJ8XP8uvkYVr2Yg20xDT0rYC
	 g3/54T4UMrBg4Y6weTH7/dl+lRP4ojPDzGsH/qarwlW19LekWZmT0Yln/H45sNrc0k
	 r2PRqB/JLYEMYE8b/oo0SiseSOM5+EsL1MJUVbCeeFNO7sOhg01Fi7zbDTFeJAGjTY
	 sdpA9kHcx5/BA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:18:01 +0100
Subject: [PATCH v3 07/14] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-7-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2291; i=ljs@kernel.org;
 h=from:subject:message-id; bh=eoI9LJ1R2FVCS/++1XTnAO/eBVHu+hbr5+7z4vbkU20=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29UlmLNxokNxRUbu3cJH6rt9+pwqsOXP3nzq3XCh9f
 fS+SQZNHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIsSEjw6UHl3eq3WfOWspR
 xsKxeM/p7uktubm6Vzhf1txPazv+h5nhv8f1a/c/Ojgdtn6zeucc0W8a5dUsJiu7Zz2Y+kTZU/o
 YLy8A
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
index 5c429065a4fe..221ea069f9bb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1606,9 +1606,9 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
 		return &vcpu->arch.pkvm_memcache;
 }
 
-static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
+static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
 {
-	int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+	int min_pages = kvm_mmu_cache_min_pages(mmu);
 
 	if (!is_protected_kvm_enabled())
 		return kvm_mmu_topup_memory_cache(memcache, min_pages);
@@ -1707,7 +1707,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 
 	if (!perm_fault) {
 		memcache = get_mmu_memcache(s2fd->vcpu);
-		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
+		ret = topup_mmu_memcache(s2fd->mmu, memcache);
 		if (ret)
 			return ret;
 		if (kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
@@ -1825,7 +1825,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	int ret;
 
 	hyp_memcache = get_mmu_memcache(vcpu);
-	ret = topup_mmu_memcache(vcpu, hyp_memcache);
+	ret = topup_mmu_memcache(s2fd->mmu, hyp_memcache);
 	if (ret)
 		return -ENOMEM;
 
@@ -2251,7 +2251,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
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

