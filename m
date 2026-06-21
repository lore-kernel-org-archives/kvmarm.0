Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2349D23E342
	for <kvmarm@lists.linux.dev>; Sun, 21 Jun 2026 21:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782077527; cv=none; b=hwp5FRCCcMqz9CQ/FfRf7DYb4auXD+ccf+NRz3aBebVazTXEy3SbnbWTip2mTf1hQHhkS+Kxp+05FZU3DxzBYozy4aOMv5GgKG78Wo+5i641y2AycjNJh7JDd+wpjI0gi3kLy8AcQo8mvgptKVhrCr4QMiwxURoRnSFcJwXVX3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782077527; c=relaxed/simple;
	bh=SDLb1cS2N91skoPPJ3reHRFoH9AJINaVn07sOl7wU2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WEKFZNeBCvS2jqzv1+QVmvgGgNL4NkamhxOQRTuhZ8fGktL53GXOAtBs1/q7Z31lYic3FnXsPNYjBxqnVGD/bCgF60ApD2j8Ga+UPU5I1lw50VzHS3flwZpdAAmXvwx9+Ue5yrgDM2t7mLpG6XZ6FjeTOSafY1mVKxfMZK7yg2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=CTIHjOBg; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="CTIHjOBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782077522;
	bh=/Ryzop9cHyfud4/d7uNpvbJV5dfV4NrntLAoHfM5aDQ=;
	h=From:To:Cc:Subject:Date:From;
	b=CTIHjOBgmIM1IBldz7lPxD44cMRJ6LYDEn6J2SRREEKJVqH2xEkPoRjUrzS+Is18i
	 ojjobDstlMpraaUwTikYGe6DaLK1MITg/DVBKsWzLaMdiizZ5UtLZnT8nCEHyuwJxf
	 9r0QxbsiAqJdiOMtxP0LLFvPf/vaIYci/O9zCaDM=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4gk4KZ4K5Jz10y9;
	Sun, 21 Jun 2026 21:32:02 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4gk4KY65pSz10y6;
	Sun, 21 Jun 2026 21:32:01 +0000 (UTC)
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Bradley Morgan <include@grrlz.net>
Subject: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
Date: Sun, 21 Jun 2026 21:31:55 +0000
Message-ID: <20260621213155.6019-1-include@grrlz.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected guest faults charge long term pins to the VM's mm. Teardown
can run later from file release, where current->mm may be unrelated.

Drop the charge from kvm->mm instead.

Fixes: 4e6e03f9eadd ("KVM: arm64: Hook up reclaim hypercall to pkvm_pgtable_stage2_destroy()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
---
 arch/arm64/kvm/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..428723b1b0f5 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -352,7 +352,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 		page = pfn_to_page(mapping->pfn);
 		WARN_ON_ONCE(mapping->nr_pages != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
-		account_locked_vm(current->mm, 1, false);
+		account_locked_vm(kvm->mm, 1, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
 		kfree(mapping);
 	}
-- 
2.53.0

