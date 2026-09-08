Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E419584946;
	Tue,  8 Sep 2026 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884625; cv=none; b=Ao+p0PeRQ/FABW7D/t8RmZAGOpS3n3RjuQv2C8rhWBoK6tbupaScMA79px3ryEYZgnEeWpd0WQbJMUR7wNvEX1maYJNb/FB/ZiDF3pxT9OoQw65ugkpMy3UWkv8/bUtmWDnCMDzkvFfIoAMWunDN6EzTntUFiR9s+49YlO9+dRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884625; c=relaxed/simple;
	bh=rO1Aepg+ZPdfUbjznCSF+LW5fDa0Tz1f7cbp73DbIAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQF8eKMEn6ZQqaorpOUlVNjIoATOjOvl0vmci8gXGR6Ms5MXiIbE3gLIem4Y6iRqtxDmSEts7LFMdSE9qeIwEf0zyyLcfjEK4Fp0PC1zLGhIIyAQxCpS4qYssVe1hNX68Z68sC/gLMh/SKQtZm+HwEYVp7LvSyj7p9OTXOXFc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TREfTy4D; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TREfTy4D"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 407821C01;
	Tue,  8 Sep 2026 09:23:39 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BA6643F7D8;
	Tue,  8 Sep 2026 09:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884622; bh=rO1Aepg+ZPdfUbjznCSF+LW5fDa0Tz1f7cbp73DbIAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TREfTy4DfvUOhrBPONa+KEhnkj0+0n2gCSA15H2mLGooirGLP4ip4tXpKvb0vB9VK
	 17XwONb5gU/G3yWRcnK0dY4n2Pm8cN1rZNLqGOA12+bQeLm+ntA+OpLrk2OuWfrlio
	 ZG2oDGaY1ItLsEVvmLjdlVtp3fmqC1yvfiugSxXc=
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
	enju.kohei@fujitsu.com
Subject: [PATCH v17 15/20] KVM: arm64: CCA: WARN on injected undef exceptions
Date: Tue,  8 Sep 2026 17:22:18 +0100
Message-ID: <20260908162223.1683432-16-suzuki.poulose@arm.com>
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

From: Steven Price <steven.price@arm.com>

The RMM doesn't allow injection of a undefined exception into a realm
guest. Add a WARN to catch if this ever happens.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Switch to KVM_BUG() to mark the VM as bugged as well.
Changes since v6:
 * if (x) WARN(1, ...) makes no sense, just WARN(x, ...)!
---
 arch/arm64/kvm/inject_fault.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d6c4fc16f8795..d61a3ff04fabb 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -317,6 +317,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
  */
 void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 {
+	KVM_BUG(vcpu_is_rec(vcpu), vcpu->kvm, "Unexpected undefined exception injection to REC");
 	if (vcpu_el1_is_32bit(vcpu))
 		inject_undef32(vcpu);
 	else
-- 
2.43.0

