Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7473538D40B
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030412; cv=none; b=faDVm+d+4hrbcC7HuchJfDwZI9Ohk9ZRhgq1FZ8x3tbi55BWD3+q+PSIIdCklQFXSC61fmF9IANV+lBeSrRtgwtJyG9Fjpw2sdZAx3Tkd8CFgJWoJ/dzBX4h8xjxr+XJMbfik8EGQQDGjSS4I7sluRzeh0xeD6oi9Fprh243iNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030412; c=relaxed/simple;
	bh=dEOA4qysSRG7n58hsk4J7X5+FYVGdQ3ln2cyFcm1ZyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk0qTh/n9Fx1+kyIoQALyw3Vv5LUrlhc2nv6cL/yhz0xZwlqXxFD6/pDj0G9/CXkCGnxJjj8uHLgmvK4HpQ69pD66JwJhBHSUxpfqYLnhT1a29Ruo6P5HVdbaMSpLPDb/vhVuWM8E3aiHGJVzY9TL5gfb/HuDlURjBNrVwZQ4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=srF8MC90; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="srF8MC90"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABABB497;
	Tue, 14 Jul 2026 05:00:06 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74CC93FAF5;
	Tue, 14 Jul 2026 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030410; bh=dEOA4qysSRG7n58hsk4J7X5+FYVGdQ3ln2cyFcm1ZyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srF8MC90nVSBrVEL7QmF7JLmmo8Sv8R3E3KsdFRWfZU1J878GxNO9qhYIiAQb5Q8N
	 FXIx+lnr/rY/WmSScZds/P1s0xqA8awh9vzBebK8k+08Z0xUjctiUIoH4mpazdURc1
	 /O4vbxzfPregZE9Qw4ba+7MZZaQm3ROtT/68SYbs=
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
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v4 4/6] KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
Date: Tue, 14 Jul 2026 12:59:23 +0100
Message-ID: <20260714115926.2044757-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714115926.2044757-1-weilin.chang@arm.com>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__unmap_stage2_range() and kvm_unmap_cipa_range_nested() are using the
same arguments, clean this up by using local variables.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 73629aa1ade6..6bfc1fbc5387 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2441,15 +2441,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
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
-	kvm_unmap_cipa_range_nested(kvm, range->start << PAGE_SHIFT,
-				    (range->end - range->start) << PAGE_SHIFT,
-				    range->may_block);
+	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_unmap_cipa_range_nested(kvm, gpa, size, may_block);
+
 	return false;
 }
 
-- 
2.43.0

