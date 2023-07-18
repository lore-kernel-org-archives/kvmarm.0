Received: from out-25.mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6FC46A1
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 18:45:48 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689705946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iKIFl9NA7PVsvCSLYRYTNFXejHlO0WaC9nSPwmDM1kY=;
	b=iA+gzBlSxFJOw78rw1QLizVWa43RscWoA7hK6UKbdhkWD5rYhgxWdpNPPTwrbnhV8Igt6A
	b0xJYYk/GH0a9+0xhwZUw0fH7kYQuTAwsmrC/9UlxcK4cnFg/YjnX3REl8nJ2osd90nnd3
	5U3qi4hdshQRZ/NJK7um9P6s3YQ/X9U=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Allow pKVM on v1.0 compatible FF-A implementations
Date: Tue, 18 Jul 2023 18:45:37 +0000
Message-ID: <20230718184537.3220867-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

pKVM initialization fails on systems with v1.1+ FF-A implementations, as
the hyp does a strict match on the returned version from FFA_VERSION.
This is a stronger assertion than required by the specification, which
requires minor revisions be backwards compatible with earlier revisions
of the same major version.

Relax the check in hyp_ffa_init() to only test the returned major
version. Even though v1.1 broke ABI, the expectation is that firmware
incapable of using the v1.0 ABI return NOT_SUPPORTED instead of a valid
version.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 58dcd92bf346..ab4f5d160c58 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -705,7 +705,20 @@ int hyp_ffa_init(void *pages)
 	if (res.a0 == FFA_RET_NOT_SUPPORTED)
 		return 0;
 
-	if (res.a0 != FFA_VERSION_1_0)
+	/*
+	 * Firmware returns the maximum supported version of the FF-A
+	 * implementation. Check that the returned version is
+	 * backwards-compatible with the hyp according to the rules in DEN0077A
+	 * v1.1 REL0 13.2.1.
+	 *
+	 * Of course, things are never simple when dealing with firmware. v1.1
+	 * broke ABI with v1.0 on several structures, which is itself
+	 * incompatible with the aforementioned versioning scheme. The
+	 * expectation is that v1.x implementations that do not support the v1.0
+	 * ABI return NOT_SUPPORTED rather than a version number, according to
+	 * DEN0077A v1.1 REL0 18.6.4.
+	 */
+	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
 	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);

base-commit: 9d2a55b403eea26cab7c831d8e1c00ef1e6a6850
-- 
2.41.0.255.g8b1d071c50-goog

