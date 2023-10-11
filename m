Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4C19BD2
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nOGAlB2D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697012234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4MtoeUio+QJkGABxRH9TB9eJMl3DOp+ol2TBjjaaNk=;
	b=nOGAlB2DnGpg6RE7lLGfaR1M3Nm4Ta5kiffzTkiJebyxxBPn3bjs2t1G96WeuBR6P6Zc12
	0hPCeExtmT53kw8V0DyaHUn++UpeP7zwQ/UcnAfIz8h0exp8vsdwqpQ7JLipFuUIiyw57A
	4VXFa+kMs4QF4EJzbi4jYzJe5P01Qi8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	James Clark <james.clark@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
Date: Wed, 11 Oct 2023 08:16:47 +0000
Message-ID: <20231011081649.3226792-2-oliver.upton@linux.dev>
In-Reply-To: <20231011081649.3226792-1-oliver.upton@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The existing PMU emulation code is inadequate for use with nested
virt. Disable the feature altogether with NV until the hypervisor
controls are handled correctly.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1bfdd583b261..356b7eec3c93 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1238,9 +1238,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
-	/* Disallow NV+SVE for the time being */
+	/* Disallow PMU and SVE with NV for the time being */
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features) &&
-	    test_bit(KVM_ARM_VCPU_SVE, &features))
+	    (test_bit(KVM_ARM_VCPU_SVE, &features) ||
+	     test_bit(KVM_ARM_VCPU_PMU_V3, &features)))
 		return -EINVAL;
 
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
-- 
2.42.0.609.gbb76f46606-goog

