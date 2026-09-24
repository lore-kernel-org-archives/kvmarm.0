Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7EB4AF670;
	Thu, 24 Sep 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265962; cv=none; b=oILdXM/3SzY/JmCBgnWX33BJocs3rs+H9FkYJX09tBhg/xU7XWm+ukXF6uOLj1nCEE6sCdiqf/cuLTcASD8GYhRcfKb09JXe5568cFNxPG8X/mfTFfa0B3NlgRR+HXx5kTFYwv+Af2Y97Mx73v3xIYcdGGZwfOhfJ5Uy6SleQTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265962; c=relaxed/simple;
	bh=RosB8NRTeZaidf7WIQy5/72KniYUL3pT9/e6vHv0efs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoFCHQMwfKE6SUW6StKeKYRALZEHYVBrcD2+a9h57no294Fwto7LBiJ5HksvlupsYXsSEIM68Vf1ABmEA5jukSu6uI/7Z+VNZxjEzbH3euQR3LYucBjGpgjvkLymVAG2lDkJtVHBkmov7CXcw7FSem8GQNCu5u89ckPTk41fHjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vll1Jx0i; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vll1Jx0i"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5684A1CE0;
	Thu, 24 Sep 2026 09:05:56 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7994B3F86C;
	Thu, 24 Sep 2026 09:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265959; bh=RosB8NRTeZaidf7WIQy5/72KniYUL3pT9/e6vHv0efs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vll1Jx0io1INPQwoNKH2983r9hz0Hhn6LgJVkdXLc5+W3MOKnbjugXxyV2zaqec5H
	 oxoJ4pLDAH8E44bfNSwBy2m8K5zSC8Pl6s9Fu5rUnfQlfNLWL2PHVAckz463eoTfaB
	 rvBmb04PiFV0XcxggA6Jr1Qx5yPqelMblYQKbMHE=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v20 09/22] KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
Date: Thu, 24 Sep 2026 17:04:51 +0100
Message-ID: <20260924160504.853911-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
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

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0f4e8b71fa85d..365e2a12c2348 100644
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
+			       (range->end - range->start) << PAGE_SHIFT,
+			       range->may_block);
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
-- 
2.43.0

