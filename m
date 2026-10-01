Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9584A0F1E;
	Thu,  1 Oct 2026 21:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888879; cv=none; b=PWH1mX2gSqtnnI+Zr0ADFeTWQn1zMXvYNarkZzWWDar4vTa+2V2fcaapQeSzl2Zcu/ZuI/oXJWQb6KsI/f04jqSXD02NSsXZyg64ClQTksWaQALTGBeXx4mLrNp3Am8DkTSymBK+AJQJD9p2v7xlKked31nh8SzwesA5Vhq6x90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888879; c=relaxed/simple;
	bh=RosB8NRTeZaidf7WIQy5/72KniYUL3pT9/e6vHv0efs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upJmZNZOkM2ujnQ9tsfmfZ8YZthqL9iZcBGlc8f/kYiOSt2fEFSCWWUW6XTcP6EEMT1CHN+tIlsGTw1WbCvYuX3zioHcGPzPyDzKDRtncYeAnVWLRov+2WuiPCUCFEWgx+aRBlRFWmkagQ1T18Ir11w1gymIL8THQV/bozUtrPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o27CXdAl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o27CXdAl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED607175A;
	Thu,  1 Oct 2026 14:07:50 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D57F43F86F;
	Thu,  1 Oct 2026 14:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888874; bh=RosB8NRTeZaidf7WIQy5/72KniYUL3pT9/e6vHv0efs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o27CXdAlycTaZj+7ERtlVFvVTTgl3FF/WPRT1P2nWSTSk4DiOodWkS05jRDj/WmGI
	 GThLTesgyVGs8v8TzAGr2CntbfMeQ6z3fg0MpH52Urln3TVY+NSwNLDXpBBm8Wcjwa
	 zpVFjsSBxHHKf+PsOYCLQ8hn9uhSbR1HNelTJaS8=
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
Subject: [PATCH v21 09/23] KVM: arm64: Reuse kvm_stage2_unmap_range in kvm_unmap_gfn_range
Date: Thu,  1 Oct 2026 22:06:49 +0100
Message-ID: <20261001210703.1597150-10-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
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

