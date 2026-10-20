Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792540403;
	b=z5km9pBemzL1cCmv3a6U9PrART5Hwa7RK7RPFyeu1RVCyoG/YI74S/xUq0NXpQt4N5cq
	 8ULJ2B1Y4Z0XcMYrKVH2NPQ2yQ8Ocqn0F/bM06BRPi5Z3Z8D1qXkOiOnvbSgz30RHF+h6
	 z7LxOUYLnmfDGHMLDweF2rWruE/k8bKWNjC4W5mfnpCi0za9+L+7bjkoy7W6bFWM8Gz52
	 eYkoDxPvR4NTEm8ods/88id9ucwueZz1+6QZhSD11Hole1/Uc/SxAzJwSouM57lO6KZNW
	 TH5qw0M/SDvYpKr2cAPvbcAQkKt+aHdAPvIrS/Kcl7zXG1V0j3dyPin5CNFP0xQ/gvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792540403;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8uxk441ISQMCr6ffs1OiNE54QJj6KTHjiAkmGI9m0+8=;
	b=r2XYTrW74/feiBgoWg0bM+YG1UyXDFKIfEkHBm6rKc+D00e8rb/UCa8fs+JDsYMlAX3j
	 BePv57Vc/GvPfwmua4768uElfAPniMOfFg7u2HTpyxXcQO3E02zGt39DKa4JhTnUuRmu6
	 7YgTSyuK8P3hsnU+51iz8Z5PQSjse1EVV+XqH9XnJs2J6RidIMqtkYjqtBznSOaPGCL0l
	 R27Rr6PurSHK4JQdzNANGXggVb7BEQ500TXJ11ixXT4rOFkOhtRGHkA6AFDP/DC8t/Mmd
	 2s156T6tQp05Zfx844yxfRxAgRlh8rySMBtckkULmKyo2nb+ANdU2d8Ec9PFspYn5GA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnYzOoRA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5AF606A31F;
	Tue, 20 Oct 2026 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnYzOoRA
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792540403;
	b=vGtGllpzHJmtTtoDXCg/wNdQpRXjzeagkkaUhC3kYSrjoAieobwOfjcNRGqwEagu29v2
	 DZXyMIifnQAme7k/RnKFngawG4x32GnlrSXbyvVnqqnFHMyVhlPZp/r3R2bFKWxYWk7Gy
	 CjP/qCzYaXmXZzuGktnMEe/C7Owv8Kioj1U9da1N0YbDcYFEd4FHYfe7GDl4gObI3rk72
	 skCH/Z9g1oBTBTtluGgfaEmBI2O4j9V47Ch2utlsiFFcsW6NPv/LrqxqHMOGjnh/QL+Po
	 uIntX9QulJdGvObW1GIT77B2MITl+l5Lo5wsrtG04bv6gvogOF3NP5pgdb64hjNlNOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792540403;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=8uxk441ISQMCr6ffs1OiNE54QJj6KTHjiAkmGI9m0+8=;
	b=3dBVmFlcpKRT4qxnYtLyF8fPXafZ0YSqKi92slRHj7qIzoo9rHxhWEYF5c9DZ87RXVl1
	 FW/zT+seH/RfyA1byFPttSi/y79qWyrbEfjQiC1IeZ0GhpFJfgAh+pbjNZ4PCf8cbDsab
	 09K+qKBYIBNuugIbSjL/cNDmZwuK0/qjwJsAbzXiaAkAJfhlDlKRmS6YTOm0Ia0yEcJYL
	 Gu3UgLkUxYj2r/umXtFIwE8aLcZ+Eyzgw/O+NThOu7lwL0agUDy+dy4A49/HJg7ZIQcUm
	 dXgZ6oLbsPYuid6fqklMZs4CJUaT9nmjMnzzzGYrNTfp7SAkHH7lOKrYpPd4aiU//7w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2A9121F000CA;
	Tue, 20 Oct 2026 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792540403;
	bh=8uxk441ISQMCr6ffs1OiNE54QJj6KTHjiAkmGI9m0+8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AnYzOoRAI98rD6gX9bom8k7NKqrMiXMN8Iper7cSb6a3qGGkCzUL1Y8tU6xFgvcZ1
	 qrs3MphwSNQmt5Uim4Z3xqmG5mW6058AhgnFfT5a0EuVm9T8+MtBoCFQ04p+nz49p8
	 4eM6JORqX1/4J1wSqVZwnfiMNHH7tDfWocuXX7IXV7e/e1tXTVHXy+yaLXZXa6rPIM
	 cgZKS5mXoYVAnU0JUSdyyouURFr78EXAnFKHO8l4J1j2S7svNAJSKaaG/t/QVSNa3Q
	 ztORLw6d0Ok9MCjzm2d7HU7JrNTzeer3DFhT5fmgdLqayEvlo5S3GgAZlJR9hxL7B7
	 EviZIwlXSMLqA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9015B43267;
	Tue, 20 Oct 2026 23:53:21 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Wed, 21 Oct 2026 10:53:21 +1100
Subject: [PATCH v2 2/2] arm64: Apply existing Apple Silicon CPU workarounds
 to newer CPUs
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261021-apple-m3-m4-kvm-v2-2-04905152cc2a@gmail.com>
References: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
In-Reply-To: <20261021-apple-m3-m4-kvm-v2-0-04905152cc2a@gmail.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Myria Sarvay <myrialsarvay@gmail.com>, 
 Yureka Lilian <yureka@cyberchaos.dev>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>, 
 Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>, 
 asahi@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792540400; l=2838;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=PFEvneEC+/aHCyp+lZlYQ70fLEswRlQt4crDxkng4ZM=;
 b=tdzSqkZ6HaKIHAWImFyWY66JwbtNxJmwuTwJTnGZZiLnX6q5CW+eemkITphNFG4ER38EIwCOr
 6m8dQm1oFgJBeqMtTnFaL2l0m6ROA2s5BnrD3vmK7nq+4wKb+MQO9vF
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com
Content-Transfer-Encoding: 7bit

From: Michael Reeves <michael.reeves077@gmail.com>

Add M3, M3 Pro, M3 Max, base M4, A18 Pro and M5 Pro to apple_cpus
so they receive the existing PMU trap and broken SEIS workarounds.

Add these CPUs to has_vgic_v3 so KVM detects TDIR support and can
trap guest DIR accesses without trapping all common registers.

Co-developed-by: Yureka Lilian <yureka@cyberchaos.dev>
Signed-off-by: Yureka Lilian <yureka@cyberchaos.dev>
Tested-by: Yureka Lilian <yureka@cyberchaos.dev>
Tested-by: Myria Sarvay <myrialsarvay@gmail.com>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 arch/arm64/kernel/cpu_errata.c | 12 ++++++++++++
 arch/arm64/kernel/cpufeature.c | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0c094025..bc91bc13b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -288,6 +288,18 @@ static const struct midr_range apple_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_ECORE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_PCORE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_A18_PRO_TAHITI_ECORE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_A18_PRO_TAHITI_PCORE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M5_PRO_SOTRA_MCORE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M5_PRO_SOTRA_PCORE),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3ae3ad1a1..bb82b80b3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2357,6 +2357,18 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
 		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
 		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_SAWTOOTH_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M3_EVEREST_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_ECORE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M4_DONAN_PCORE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_A18_PRO_TAHITI_ECORE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_A18_PRO_TAHITI_PCORE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M5_PRO_SOTRA_MCORE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M5_PRO_SOTRA_PCORE),
 		{},
 	};
 	struct arm_smccc_res res = {};

-- 
2.56.0


