Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E2A58597B;
	Tue,  8 Sep 2026 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884636; cv=none; b=jsMwt93t8x7uToQCqL2vxjcKuxEJJFQdRFVIuH7jQwwl6VT28QAGAoocGRZqWZKCYnuHo6VUgu18TLBfyLGe0cJcjsNG4RP9sC9RCLv+zHXrmATWO3jKubVwN5z4iQV0Nco+N/GiXLen2G3BZUL2R3f0gZhGS7DnXRN5JjWXBPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884636; c=relaxed/simple;
	bh=4dJcz7Ui6l+RUG6SvRhjywJMQzx66cIRrcDMmHTUl6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp7UHtSsgez5b3D7QJgzdS/LscghQgwov93V6kiMmrOXmispspsz1EhVHtU7/GknjGla4n9ffCZ0lztfd4EMFpw7nbIMtJNmWNOkgTKrNzqSZOWFWpoviOWInJIoTro3Yc1bhSe2bjMMMOGGHzJMU24HpxSmGEAqZtaHgQwZVRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xk9L4HoP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xk9L4HoP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F5F61C01;
	Tue,  8 Sep 2026 09:23:50 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C90673F7B4;
	Tue,  8 Sep 2026 09:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884634; bh=4dJcz7Ui6l+RUG6SvRhjywJMQzx66cIRrcDMmHTUl6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xk9L4HoPqQR3OWVdrHMS46rx1HZ9nOwVn3L6/b1ETu0ntTEaRrCnntL2V9WhXDKRS
	 qpDRirgQESNLkXnlmH8YCb0QnVJVkCNvKchEChb/2yHzBTxJZ7lBmYQYI32s8p9ckL
	 sBk/PFi15aSwyMgoAHm30r74g6USmZXA2rdMs52Q=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 18/20] KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
Date: Tue,  8 Sep 2026 17:22:21 +0100
Message-ID: <20260908162223.1683432-19-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding VM specific backends for stage2 operation,
switch to kvm_stage2_unmap_range() instead of __unmap_stage2_range()
from the kvm_unmap_gfn_range(). Drop the bail out check for protected
VMs and defer that to the one in kvm_stage2_unmap_range(). Later we
would replace the logic in kvm_stage2_unmap_range() with VM specific
backends.

No functional changes intended.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..67852acf7a6f8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2436,12 +2436,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
+	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
+				(range->end - range->start) << PAGE_SHIFT,
+				range->may_block);
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
-- 
2.43.0

