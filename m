Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A854313E15
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 10:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780570616; cv=none; b=Ua4ld0uwHXR0AxbHV3F4zCkx3nP+hw+DA3WV+tYKQ/oPXxcZE2T3EaSRrM8o5vYEZTIgL2qIw17bO8SRsYAGXx7HIHZM6IjiCzkoa6yjpQy6I0sVHgM5ydWwJnLR+xqJatv5wA1wrbksRtRNmSXjRWoPAdnTwDyoy2HV1QrFJ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780570616; c=relaxed/simple;
	bh=HCb3/WN6zMkp5n1Xqjc3nuxOHCSxZwt8K49OZDMiCIA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dK/KnqjOZgbsMVzL8kT3qgRpC+t2U41kjf8hiuOyyzFQOP7+MtmVClE270lmYeUhegrWkPGHkw1GGZCCOWe9C6ZB70KPiULNyL775kPqylekhKbPcgd3R3hIgA8dKG0mchcuFfVHybATAlMQFXXoZeIp9tduJraCDm2ou2etN/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cwkU4DuR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cwkU4DuR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04A2A3297;
	Thu,  4 Jun 2026 03:56:49 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E81C3F7D8;
	Thu,  4 Jun 2026 03:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780570613; bh=HCb3/WN6zMkp5n1Xqjc3nuxOHCSxZwt8K49OZDMiCIA=;
	h=From:To:Cc:Subject:Date:From;
	b=cwkU4DuR1Xf9pTsO+KsjwTqpBSJNLyykOzxaNWidfAVine3a5YT9t9NtDEBikQ97g
	 vVMI43M3UwG8DhdlDq52TeQS4BUXrX+uUQNzkYoa+xRflSvUhvvgkvSm73f3ygEw/V
	 mh2a3AP6ndhtYcXHjid6OCeKdDB2oUzt72hMfDNU=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1] KVM: arm64: Restore POR_EL0 access to host EL0
Date: Thu,  4 Jun 2026 11:54:34 +0100
Message-Id: <20260604105434.2297268-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CPTR_EL2.E0POE was being cleared in __deactivate_cptr_traps_vhe(), which meant
that any accesses to POR_EL0 from host EL0 would trap and be reported to
userspace as an Illegal instruction. This would happen after running any VM,
regardless if it used POE or not.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Link: https://sashiko.dev/#/patchset/20260602155430.2088142-1-maz@kernel.org?part=1
---

Tested by (paraphrased):

	$ ./read_por_el0
	$ ./lkvm run -f kvm-unit-tests/timer.flat
	$ ./read_por_el0 # This gets "Illegal instruction"

Also ran the above flow in a nested VM.

 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 320cd45d49c5..e9b36a3b27bb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -181,6 +181,8 @@ static inline void __deactivate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
 		val |= CPACR_EL1_ZEN;
 	if (cpus_have_final_cap(ARM64_SME))
 		val |= CPACR_EL1_SMEN;
+	if (cpus_have_final_cap(ARM64_HAS_S1POE))
+		val |= CPACR_EL1_E0POE;
 
 	write_sysreg(val, cpacr_el1);
 }
-- 
2.25.1

