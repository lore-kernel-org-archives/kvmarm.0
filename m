Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A649A450410;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461741; cv=none; b=ai3MNHSaEeh1sPYmW4Q/Tgxexl7TosAJwPJ2n5MYnUt2uyspq78pK9m+MAHU0NHsUkuT1nIxUWjWmp3yodzXUDYUagt8KOnNknMgNQwWbDOJDKAEUSTO0QoJMdPvjzIO+L/TJy03asjbJ4IJiocCwyvjNM8KG1AcCyAc5f5Zwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461741; c=relaxed/simple;
	bh=Vdvmb/idCconkunwe5vqiLNHSM1hVRs9qmxEo8J62CU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kD221gC8bq3bBdjIQo3yEI6h7NyXKSp6DXr4pUDGs7h6F4m6ifZqKukMJ9TxqTMHBJDMRPbERf2LHEJr6RMQXdudo2RB6Cvd+8cGPSqGKHe5q8B+dOSNNHEfKEIAnqO1juvjbxOb/gbg3Di8BmIabBUFqR+Dv9JYTBSpzlI19H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcUx1Tgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcUx1Tgz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F3B5C2BCF5;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791461741;
	bh=Vdvmb/idCconkunwe5vqiLNHSM1hVRs9qmxEo8J62CU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tcUx1Tgzhe2IrqtHXyPnyeX6hfmOsewW3geO5QA7zbZJDJcKL6vWAen9NZVss5Q7P
	 O4nyZWcD/CIHQafRBmDPHD0NfSm/NKRjWao6KSEroYIcO5X88MA85g0uhmfhfA1iRY
	 awUQGhx1Zy25J6EQLjavbnVa5wplmnxNylx3L7Ulb4GaJOBrmEw3rQvWT1Q8c8Jw4e
	 pcfYFyOANszFuuom9rZYho4L58G56cX/l6N4rO5HDDZCzcmyI0rwE8Ib3M/TGNSr2S
	 J95clSoIbvUkzwF1OmR7PqMZRx5m3HSBfFwZzt9X3/aqJ+dwAnAobYy5IJGUdYEwO3
	 5NbtB7daNwU+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4100ECA6007;
	Thu,  8 Oct 2026 12:15:41 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Thu, 08 Oct 2026 23:15:41 +1100
Subject: [PATCH 2/2] arm64: Apply existing Apple CPU workarounds to M3 and
 M4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com>
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
In-Reply-To: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791461740; l=1320;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=4DZxVFKEdF/Pu4GYU+OpToXoJYmi+szLHgZHQGkaf0M=;
 b=abXZoPRVUxn8QpLlM9NH1pz4/xpj6h3GJjVNe/wpQmf4rPCSbEySETEDlYQg8trN+7qvOD4b8
 FO5G/JfJ2FRBRnINns7srdp/CPX57G11XBwKnKf9G6NvfH+fnb8cNu4
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Michael Reeves <michael.reeves077@gmail.com>

Add M3, M3 Pro, M3 Max and base M4 to apple_cpus so they receive the
existing PMU trap and broken SEIS workarounds needed by KVM.

Co-developed-by: Yureka Lilian <yureka@cyberchaos.dev>
Signed-off-by: Yureka Lilian <yureka@cyberchaos.dev>
Tested-by: Yureka Lilian <yureka@cyberchaos.dev>
Tested-by: Myria Sarvay <myrialsarvay@gmail.com>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 arch/arm64/kernel/cpu_errata.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index e0c094025..8a7703b86 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -288,6 +288,14 @@ static const struct midr_range apple_cpus[] = {
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
 	{},
 };
 

-- 
2.56.0


