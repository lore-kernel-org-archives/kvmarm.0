Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239D54457B1
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 20:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395124; cv=none; b=ud66bREoE7EXkoOVYuszAWwQ7TXHy2FKyV3UwU5GMcC8bfFaeGQreK0hXqiZ9fk7wl720tROi8MyS8LPn7Ik5w/dwmyR/3+S8CxKf198P5wJ2q9EXEbIMTIQnyPP3pwMhWk4Br3C+K4r5h44ycra63F0O1LlCQr1V12c+nudU+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395124; c=relaxed/simple;
	bh=WaxPznMv/qn072xMj4ZtLqSYLS1ETbEkJqwZWvJUvvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UROFlR3Tv9f83Xf8apIX5eG4QzA/O+S4rIioHFOWejGd9AJTgjPebD5KQ8a/KSb6QMmNrrqvJ2zNs8hIpNzWDJ2LCJLZ4m2KRB8d3VxQ0symIsHt6NHUMSsp5rFazV7lTv3wpzE8oewXsfBss5iffEms0mbyMqLDu1EF7u5GM+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=azDkaTuC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="azDkaTuC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62B3114BF;
	Mon, 10 Aug 2026 13:51:58 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F2FF3F673;
	Mon, 10 Aug 2026 13:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786395122; bh=WaxPznMv/qn072xMj4ZtLqSYLS1ETbEkJqwZWvJUvvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azDkaTuCtoM0963uMoAgwfn60Y35yixNRfx7qxD7cyA0McQWE0HKFpDhq5aSxTaHD
	 l9/lSrVuzw3tpVCsv/w+HCi25HRvRIBZ5yvLtzOrTNXMGy4W59Y943W8ifm6PR3OGh
	 XcZzcq9Upt5b43oIlLOhxprb1TGx1KsPmEiKcPXw=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v5 6/6] KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
Date: Mon, 10 Aug 2026 21:50:38 +0100
Message-ID: <20260810205038.118843-7-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260810205038.118843-1-weilin.chang@arm.com>
References: <20260810205038.118843-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__unmap_stage2_range() and kvm_nested_unmap_cipa_range() are using the
same arguments. Clean this up by using local variables.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 241f020910d8..9d3ea44a894b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2512,15 +2512,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	gpa_t gpa = range->start << PAGE_SHIFT;
+	size_t size = (range->end - range->start) << PAGE_SHIFT;
+	bool may_block = range->may_block;
+
 	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
-	kvm_nested_unmap_cipa_range(kvm, range->start << PAGE_SHIFT,
-				    (range->end - range->start) << PAGE_SHIFT,
-				    range->may_block);
+	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_nested_unmap_cipa_range(kvm, gpa, size, may_block);
+
 	return false;
 }
 
-- 
2.43.0

