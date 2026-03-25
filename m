Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315453242D8
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 18:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774462836; cv=none; b=Gr4N9Ed38HjvgDssgSwfpQnnPHxoHis0RQMCEI0D6VKNhLvx90s5+oXA86in3EHx3mbC6Zhr9rYgUS/sYxZ9CjKl+ICy700S3sLJlOfuYK5xvzUNViUqdxalpqQxCkpTKakugRf7BzYmuAp2MkEGwpu7SH672CX44zQ+aSECmsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774462836; c=relaxed/simple;
	bh=j2/es1QhPhuq51aj/X0brAWozFW8cVd/nUY1rJQCm28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=kqGc57pVFGQ2Te7e3uJPPn1YJCjYQxM8rZnGK8TOaCBevh4u5OStZ1WCfW10YNwAydHVbZhSCTNuGQGFGGRfDG/KTYrfff/GwlVs/xaC4ZyPTdzz04Z/CLKhXLlNGz7RtcN1uFLNjozDLwX6m7uiXMPIST1pLgvS11ZwJ9FE/b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RnRqlju/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RnRqlju/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0CC51F02;
	Wed, 25 Mar 2026 11:20:26 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 687383F836;
	Wed, 25 Mar 2026 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774462832; bh=j2/es1QhPhuq51aj/X0brAWozFW8cVd/nUY1rJQCm28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnRqlju//v+l8+03/0wteCA6R1iCsC1AxpJi6NyA/fWzpmNollbBo80IOtBxUXBxZ
	 G5EG2hgtu/qJ5SgLsJ9eud5ObOxoheQ95D/hyREnHIaEvJHzxuqvDMmezCC/dm26sj
	 AWDLdr/3IUF3rzLY+0m1k9SAPvra5hVsUBx3KeD0=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: [PATCH] arm64/kvm: Enable eager hugepage splitting if HDBSS is available
Date: Wed, 25 Mar 2026 18:20:27 +0000
Message-ID: <acQna2hLwdr1juTN@devkitleo>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <acQj5grOdZT8LUGp@devkitleo>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <20260225040421.2683931-5-zhengtian10@huawei.com> <acQj5grOdZT8LUGp@devkitleo>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FEAT_HDBSS speeds up guest memory dirty tracking by avoiding a page fault
and saving the entry in a tracking structure.

That may be a problem when we have guest memory backed by hugepages or
transparent huge pages, as it's not possible to do on-demand hugepage
splitting, relying only on eager hugepage splitting.

So, at stage2 initialization, enable eager hugepage splitting with
chunk = PAGE_SIZE if the system supports HDBSS.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 070a01e53fcb..bdfa72b7c073 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -993,22 +993,26 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
 	if (!mmu->last_vcpu_ran) {
 		err = -ENOMEM;
 		goto out_destroy_pgtable;
 	}
 
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
-	 /* The eager page splitting is disabled by default */
-	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+	 /* The eager page splitting is disabled by default if system has no HDBSS */
+	if (system_supports_hacdbs())
+		mmu->split_page_chunk_size = PAGE_SIZE;
+	else
+		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
 
 	mmu->pgd_phys = __pa(pgt->pgd);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
 	return 0;
 
 out_destroy_pgtable:
-- 
2.53.0

