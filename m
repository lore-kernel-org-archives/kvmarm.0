Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164A51D7E52
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323202; cv=none; b=DnjFhazscdLjqy51YtMvuSUg+5AKeEN/zgigqfGiLtlxQMmjAP5WYk1aE/XGUKyawaH4l22bZfdf4KX6ZP9j041diP8JpDmOaM2c96UvposZyz/Kx+vGbUJ30TCTiPJBEiOeLf2RFtM1x/B30/5kKsb3y0rb/NzRX8VISQZYAw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323202; c=relaxed/simple;
	bh=gmhogXVIjxcMHxNtFr7DqfLABBYcSc+BN0WKJoTxcXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ+2ujQU+GtPCHxz8WfQosB17+OBT8jLKW937bslaAVoo56etk+UMX8yy93AhdvH+HuY6AQRQDB5V1S9d3Wjpf8G8MKQgwWlhfzsunTU6dfXFuLFX21xxIVCfehDHKzfub29eAPdiM7Apgh7MOPoN+6PzvauQUdTG6dJh5qI9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UPVdg01o; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UPVdg01o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xwlIbatlsQguFWOjN1fYxOqiHRXyNQuzagd9UqixmJ0=;
	b=UPVdg01oZI1wKrcYzRCvwxqCQSTLXnqYth5NkKYsc8AozKcm13V1s3fXO97Hlc0YoNOYS/
	NeYqw3j7xqP9CuJBPx9JJ/sencmXgzttbfJUvxYPtQLdZm8LIlk/dHKcyvFI/TpGwwCDBT
	wf9FoS56iOoyLWXRvsCELEplQ2hxeB4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 14/17] KVM: arm64: nv: Honor MDCR_EL2.HPME
Date: Mon,  7 Oct 2024 17:45:56 +0000
Message-ID: <20241007174559.1830205-15-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When the PMU is configured with split counter ranges, HPME becomes the
enable bit for the counters reserved for EL2.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 723c9388b118..e45f5de278c6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -613,8 +613,15 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	return (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) &&
-	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
+	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
+		return false;
+
+	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
+		return mdcr & MDCR_EL2_HPME;
+
+	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
 }
 
 static bool kvm_pmc_counts_at_el0(struct kvm_pmc *pmc)
-- 
2.47.0.rc0.187.ge670bccf7e-goog

