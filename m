Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116213D76
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738680962; cv=none; b=aBKcpQixnmGhFgpwThPz6jtFkFWJlzGfyrJ85aJcglTTBzFFIrz9jrtYKmliMNJ1CEYgp6VvaUW+51Y6ljXotghCDraN9puppyoXPrC+OAiZodX1vzQ+aP8cJu1VAMsfIsHbWPaHRTCi3O4FNanBw2vrHq5lYnQZo/BpCNmwRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738680962; c=relaxed/simple;
	bh=/54KAUGrgAu+EY8yrKbHB4///ZOU7MFp40KO/eRvFjE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZwQIZOeKk1bswOFHpSortfwGm09gHsCLmtRyrXbSJw2VxUAWj88X93uDyJs07RFLotYkWGvSunL0gC4aFv9vF+dv28RNWeq0OZ+xT8BdKfEi7if++2vOAfSeK6K+HNuYf6CyLbwpdYIiBBqfVmKD6sUZA/a9LIWVMtkXwuqcw/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hY34tf7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hY34tf7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F32C4CEDF;
	Tue,  4 Feb 2025 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738680961;
	bh=/54KAUGrgAu+EY8yrKbHB4///ZOU7MFp40KO/eRvFjE=;
	h=From:To:Cc:Subject:Date:From;
	b=hY34tf7QLqKPmNkKHaymhuwSAdpujXj5JOKlDDXIEV/9vzG7TxbmXMPM7hGwC31Ds
	 Sq9ITR2oShRcLLM8qBV4Hs/gDc4YIFU/poN8AJ0JRgYvsPo7TyNe2tv7IylwoclqaN
	 eBc9S5DTifJZmzvaXW7CjgcE8yItxyEVoHvPNRIlgKnhd4UkBt2GYa0wHIVoFBaVoS
	 vgrEMyTbBjHSMBExylP4OXNP4u0cnUXmkDKnNDS3fSmcHScFdLJf1PRX7q+a4Zd4p7
	 N9Ee5ahSZU/oDeXtej7EaMXwenCAAc9RbJOZ0NeQYb5ytfCULKz/qlOIPvzwolKako
	 T3RVVe8p76f6A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfKLG-000SW3-VU;
	Tue, 04 Feb 2025 14:55:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH] KVM: arm64: Fix nested S2 MMU structures reallocation
Date: Tue,  4 Feb 2025 14:55:54 +0000
Message-Id: <20250204145554.774427-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For each vcpu that userspace creates, we allocate a number of
s2_mmu structures that will eventually contain our shadow S2
page tables.

Since this is a dynamically allocated array, we reallocate
the array and initialise the newly allocated elements. Once
everything is correctly initialised, we adjust pointer and size
in the kvm structure, and move on.

But should that initialisation fail *and* the reallocation triggered
a copy to another location, we end-up returning early, with the
kvm structure still containing the (now stale) old pointer. Weeee!

Cure it by assigning the pointer early, and use this to perform
the initialisation. If everything succeeds, we adjust the size.
Otherwise, we just leave the size as it was, no harm done, and the
new memory is as good as the ol' one (we hope...).

Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d3214c3a40393..6969c273b39e1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -93,20 +93,22 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!tmp)
 		return -ENOMEM;
 
+	swap(kvm->arch.nested_mmus, tmp);
+
 	/*
 	 * If we went through a realocation, adjust the MMU back-pointers in
 	 * the previously initialised kvm_pgtable structures.
 	 */
 	if (kvm->arch.nested_mmus != tmp)
 		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-			tmp[i].pgt->mmu = &tmp[i];
+			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
 
 	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
-		ret = init_nested_s2_mmu(kvm, &tmp[i]);
+		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
 
 	if (ret) {
 		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
-			kvm_free_stage2_pgd(&tmp[i]);
+			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
 
 		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 		vcpu->arch.ctxt.vncr_array = NULL;
@@ -115,7 +117,6 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	}
 
 	kvm->arch.nested_mmus_size = num_mmus;
-	kvm->arch.nested_mmus = tmp;
 
 	return 0;
 }
-- 
2.39.2

