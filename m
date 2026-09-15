Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C5E4AF674
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 15:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487026; cv=none; b=i9SurdkFMFvzzcm+Oa7+hm5+UR/vRHtCo2yfU3wVDowzZ4MnF3cyt1iQ0ZcVd2F48rS0sktumwHUL/+FXxlUF6rY7qp9Sc1xc1pm8goz9DYWyLQrYn8YSauxhz2yqrWBhIZtJN/ImZ/y1UFxjErWft2uyYhbRK0SGLC5B0o02nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487026; c=relaxed/simple;
	bh=B3XXboLvPkx6dcOeOmoMJEVAmJvgwTkHHDv9chNx8vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuBJtDvOd4OnZGvGa63B5fYILgZRNk63r3YmAzRxn/PeFgz+KLiSu1HQ8g7oo8FG6NIsdJZnYzmWblXt/BKbTC8uv7oUOP6HILHHkR1s+ICBnXtJoQA0AikwcT/wLpuNJF0yJbl1IKXAgRPkVah/6LwsP/UN1ausbGITvYwJX40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s7+YPBFQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s7+YPBFQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 773FC1570;
	Tue, 15 Sep 2026 08:43:39 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 786C73F882;
	Tue, 15 Sep 2026 08:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789487023; bh=B3XXboLvPkx6dcOeOmoMJEVAmJvgwTkHHDv9chNx8vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7+YPBFQT58OoE1Uxuggw3iFQzbJZ1gHumDNW7y2cUr1H96wbIklTYGLDCUreTNwy
	 3YxqtanquhJiQlt1Hm5COhOvwhGsfFvypLyKZbYNBCqia/ZvJ5S+CkK8IiGsy1YYsR
	 g3BdfsnOW6b9cBwj9KEV1rMbNS23eRn816xN4xN4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v6 7/7] KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
Date: Tue, 15 Sep 2026 16:43:05 +0100
Message-ID: <20260915154305.3852871-8-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
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
index b8ba2d09ed96..3c3bc231eab7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2519,15 +2519,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
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

