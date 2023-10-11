Received: from out-199.mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52E199D6
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 08:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fI2e3O2C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697012236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/P2cXWXKHxiKIrHs6BVDT2TzNGuicu3kg1x643elmo=;
	b=fI2e3O2CpjLkohDlSCvitB3OpjTRFNOfdJtfu703Z85lVSCv4t3gBkVUM4Vfg6v7GgaBy5
	LzI0tIPRPDT1AnFQpb/3fWRPTdK7PrTLkeNSGZzrhEF/VsFuumyY7qbPoLmidASbJOKYJq
	1TzqA43oxEmdbQoeO1rov+LAVtBNWCs=
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
Subject: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Date: Wed, 11 Oct 2023 08:16:48 +0000
Message-ID: <20231011081649.3226792-3-oliver.upton@linux.dev>
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

Prevent the guest from setting the NSH bit, which enables event counting
while the PE is in EL2. kvm_pmu_create_perf_event() never wired up the
bit, nor does it make any sense in the context of a guest without NV.

While at it, build the event type mask using explicit field definitions
instead of relying on ARMV8_PMU_EVTYPE_MASK. KVM probably should've been
doing this in the first place, as it avoids changes to the
aforementioned mask affecting sysreg emulation.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0666212c0c15..087764435390 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -663,8 +663,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	mask  =  ARMV8_PMU_EVTYPE_MASK;
-	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
+	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
 
 	reg = counter_index_to_evtreg(pmc->idx);
-- 
2.42.0.609.gbb76f46606-goog

