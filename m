Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD554746A8;
	Sun, 20 Sep 2026 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939800; cv=none; b=kvXGZxSFaPvtaJJviT9UJWqmdHXkJFUdhBKGVUlNQ+9KXjJhMLxFCWuMM3n9Go+vAj0Ddu3e8tkUpdycQedHPx0xROcgSBvHKwMk/5thKym/DOyBahE2QkpJe3dJiRuO4x3lPVoiCQBKk+DvpjsLVpDfk7oYtugZdvxmw2SDOUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939800; c=relaxed/simple;
	bh=rO1Aepg+ZPdfUbjznCSF+LW5fDa0Tz1f7cbp73DbIAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2uLp9CxiCKEr+ikm29FXwiJQ3Vgs0FpMIpND4SptYldmrC7+MmHAA3FMY6nPgwTgjJ90QWVlZs31696Oac3wSZ83qpM+71601eavkNbtxPNfLaAW96I6NKY3HNT1EuqquvOouId2gXBjx/KjrJ/Ata7GGuFxrGGrINmA9y15p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kq3+W1RI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kq3+W1RI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DD901596;
	Sun, 20 Sep 2026 14:29:51 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08F323F632;
	Sun, 20 Sep 2026 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939794; bh=rO1Aepg+ZPdfUbjznCSF+LW5fDa0Tz1f7cbp73DbIAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kq3+W1RI/qPQ2NfEO5DrVboqxaszn7lCx5A2coHap3EL24Fga/nmAJdG3Qq8g63eP
	 ftY3WNM9G7KiigNTDVNmz0OJ8dT1cAOfg0VogL1mMBwXy890dQDpEwpGD12YKNkvuo
	 Y29abNnhNRLpaFLqnWwezDU+Q8GMGCjbMAP3jeNQ=
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
Subject: [PATCH v19 17/20] KVM: arm64: CCA: WARN on injected undef exceptions
Date: Sun, 20 Sep 2026 22:28:42 +0100
Message-ID: <20260920212845.707-18-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
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

