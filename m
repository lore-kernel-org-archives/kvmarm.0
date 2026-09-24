Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8C149BD9B;
	Thu, 24 Sep 2026 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266007; cv=none; b=EP3XWz748PTt2jmP3zzC2POpdKFPFyTfbOYLLx6Hz3BjtTKlSenMRYhJZhF530nSAYzsVjNzFmMEjPRJjYV/qtfduljpDRu1RU2/q+MNF06YWDWXsiJs8mrQ2XlbMIUsF0tgUJrXujSWSb3puwUVtWNJg02PCueZEB6hNByJ+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266007; c=relaxed/simple;
	bh=1DYRIPe8PKoi5a5tSzSos3MNlYuYMYyYfWo3uNo+uDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/9j6rjhfK/BnmEXtyQAtbR/SC9WrZJ2RKK+DIM/ojZfU9a1I44zfG/4roaCLtL0Hm0A4c6qZ3nT03EcFA0kmnlZs7cUOaySLBg0Slg7E6lDiHUJOGXnHGmMnkwIs92WgOLHtS3fpdY8Dq9D2r+l3aqpmDH2fuAAd4cGj0foVcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ILdBX9Bp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ILdBX9Bp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 555781EDB;
	Thu, 24 Sep 2026 09:06:41 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B34573F86C;
	Thu, 24 Sep 2026 09:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790266004; bh=1DYRIPe8PKoi5a5tSzSos3MNlYuYMYyYfWo3uNo+uDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILdBX9BpTIh+oUiiBaKCiAb+ZwBfDuI3rKINORMCNIssuj6sl0+xbySKHrSSSTSku
	 aSNvR0h1OXbbamKGJ4LYWYZWT11lP+Ys+fIGibACCerX5URmZCH06BNHAbtILOkpY9
	 PQ2x5RdGXYaI7KEs1E1CPVeUHO6TCzXi70Y9zZL4=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v20 19/22] KVM: arm64: CCA: WARN on injected undef exceptions
Date: Thu, 24 Sep 2026 17:05:01 +0100
Message-ID: <20260924160504.853911-20-suzuki.poulose@arm.com>
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

From: Steven Price <steven.price@arm.com>

The RMM doesn't allow injection of a undefined exception into a realm
guest. Add a WARN to catch if this ever happens.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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

