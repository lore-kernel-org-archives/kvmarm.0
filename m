Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792540403;
	b=d98PGgW1BRWDSKYiK0LqNEtUhSeXlAc17+h6knq1Rnpobg1Q9jCkuNO69KgQPF32tb+3
	 gAh/V+4J+szXPlnbp3dFZKzyQW1IaKgQZA+Eu/dO+UhF0f7PdExlzQOjISxgFDuCqqjef
	 R7tNTw6KFulm30xLw8aiE3M+PgpBkxFcAiS9mWJLwLLJEYrTrLdHJ9v/SIfUhnvoD2S4l
	 VQdRUP8Ic6eObVG9yndCOeJqEBjAuqMazAg0VLGdNx3tjXWT400DCp3iRNRCP6YcXgBCs
	 rnAPLqkUZB6LN+N/typoSStAEeMKBUxhazFxN8YaHg8Tftn4Rw1GRcHJEhnMAB7x2hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792540403;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=gN0ju8lD81Sz1gc8sNBSSmRi9TErZR5ipKv96L1LgaY=;
	b=Zj9SV/yYH8TkWtKWK3MWH3+bTWXVVYL/Y0HNBDfr/3j/d19sgiNtsGztaiXQsZSrrQhp
	 yj43VK+Ns22zQVdAhBIgrQZIQVB1fuiVVlMuNW7Ubtw+8OkeVmh947AZfuCWrF6wXAPIL
	 ycLhblD9wYLed38jeWJ9jvjtEusYmjkvsCgTZuNAsKPpMp+7Z+aWVERqTDFbkowWsDAnf
	 lb6CFV/81g/m1ddMJyhc6vw+GrJHQuJr/9wfHr9u5VGCSLMi30vurkRVMPZiFCHOfIo/p
	 P03leUIbaTB4phbd/2q2lYy4A1uRfWlfPrsZsk6GiBtgouSZbpjJj3FXvbIdeZ/GWsQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aGkCXRtp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF2606A319;
	Tue, 20 Oct 2026 23:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aGkCXRtp
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792540402;
	b=u2U1bHzfkEY6I7lLCJ/SFHjBdyF/GaCxkT5TUxNB4ACAhGouKcmmPqqiVEYB0sk2pZHq
	 ISzQNcPJnwDBUpewZQIYvO6rfv6bYDL04Cb2ZfN+Et+1HFuNoSs4lPDGzkz3qVqCZnecs
	 DG8wenyHn16CIRZ+pKQrsjTIP2ooUNcaZ/6I9UdphRR0lUKinW/4WvkEOxnHKU2kYSs9/
	 rcMgUsM6V/XrzOtWR/GdUXCNMNwyq97Vh8XbtRqz1a6TN9tjdBf8m0u9QWyOrj10juwzZ
	 4T2ivFTanKGXaqHYG74iKfc9aMYfxyGaxkY9++AbKM5hakX8b8OXTriYB2v0Wgd7XSQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792540402;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=gN0ju8lD81Sz1gc8sNBSSmRi9TErZR5ipKv96L1LgaY=;
	b=Sv1Qt/e4gRae3oGx14VIXcG0jDEJROu+8CXR8NqXEBOgnlY1s1wTS1Fh4bc0vBn3MiJb
	 aasfZ/iQsha5jbSxudUULoV1IEfN9DfkvUTvT+OscknNPfpEtewSOSF5HVDl3KNnTfoQV
	 5+2ymDaZjLKLqnFqNIqsI2XBsUihBwAC6a10n339uTNU+c0La2gjs/Zvkjh5rYToxt9El
	 Vw5Ui1JwQPyp//WlXhCbrJVx3Q2uW1akWv52Cue5/7BiAuO5Mdc0KJvM5vDRosaqJwIRT
	 y3FUyfJ7F10V13A+avCTRJLUNIDtVuXN+8b8nJht+6M8e7g1cudyYYtbq3B5NujzVhA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2A7751F000C9;
	Tue, 20 Oct 2026 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792540402;
	bh=gN0ju8lD81Sz1gc8sNBSSmRi9TErZR5ipKv96L1LgaY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aGkCXRtpC0or3gEmzbjpEJic9B2qM3E5Kg4IjQncI7M3S7657e2FivPIiEMEZw+r3
	 jJVubdBG1R38ftg2434RGaN8tCXxdi+3xBkhYJdss5n84ZzhFYH4eGopPJp5JmM7gu
	 0AYcI+XsS1UPIhjY1ObLV4fiyjZpzNZJfpA85swasNt+OZSyTKqCfNDtbnq8qbRrDv
	 eNPMUPnPDpnUJGqPp5Jz2ZpSvz8riwnKi7M95Ky/dO7t8SYEbY3Iwjq24j5GYK2CHY
	 U5e5yOCgdPI/fssr6cNoGFbt5NDkYonAMaapF386eVpivYXRVCn3v5NLEtvK6B8PnU
	 Vydixk8nuC9EA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 88B034325C;
	Tue, 20 Oct 2026 23:53:21 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Wed, 21 Oct 2026 10:53:20 +1100
Subject: [PATCH v2 1/2] arm64: Add CPU part numbers for newer Apple Silicon
 CPUs
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-apple-m3-m4-kvm-v2-1-04905152cc2a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792540400; l=3412;
 i=michael.reeves077@gmail.com; s=20261008-m3-m4-kvm;
 h=from:subject:message-id;
 bh=juCh5R4p12iRnVQ+5ShiPPNpDD7QYQmROKo57ewmfzo=;
 b=xd1M2Vm/pX07aguQJcvtqE1esHZjP8TTsj2WXuu/Kgl1MA1T8FOezXwcpxMsXOpvoEXMhu6Pe
 LZ08uLRwMngDkSFJAG1IA5yzYxFGrG7GYwxpZ+W0pn3NU42VQ0jyU5o
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=oi7WuppQ1A+qFZp9DdfIwDnpC3WZ+XY6fJK1upV/CSY=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/20261008-m3-m4-kvm with auth_id=1131
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Myria Sarvay <myrialsarvay@gmail.com>

Add CPU part numbers and MIDR definitions for M3, M3 Pro, M3 Max,
base M4, A18 Pro and M5 Pro so CPU workarounds can identify these cores.

Use the SoC codenames for M4, A18 Pro and M5 Pro, with suffixes for
their core types, as separate core codenames are not known.

Signed-off-by: Myria Sarvay <myrialsarvay@gmail.com>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 arch/arm64/include/asm/cputype.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 1fa29616e..86adfebcb 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -155,6 +155,18 @@
 #define APPLE_CPU_PART_M2_AVALANCHE_PRO	0x035
 #define APPLE_CPU_PART_M2_BLIZZARD_MAX	0x038
 #define APPLE_CPU_PART_M2_AVALANCHE_MAX	0x039
+#define APPLE_CPU_PART_M3_SAWTOOTH	0x042
+#define APPLE_CPU_PART_M3_EVEREST	0x043
+#define APPLE_CPU_PART_M3_SAWTOOTH_PRO	0x044
+#define APPLE_CPU_PART_M3_EVEREST_PRO	0x045
+#define APPLE_CPU_PART_M3_SAWTOOTH_MAX	0x048
+#define APPLE_CPU_PART_M3_EVEREST_MAX	0x049
+#define APPLE_CPU_PART_M4_DONAN_ECORE	0x052
+#define APPLE_CPU_PART_M4_DONAN_PCORE	0x053
+#define APPLE_CPU_PART_A18_PRO_TAHITI_ECORE	0x060
+#define APPLE_CPU_PART_A18_PRO_TAHITI_PCORE	0x061
+#define APPLE_CPU_PART_M5_PRO_SOTRA_MCORE	0x064
+#define APPLE_CPU_PART_M5_PRO_SOTRA_PCORE	0x065
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 #define AMPERE_CPU_PART_AMPERE1A	0xAC4
@@ -250,6 +262,22 @@
 #define MIDR_APPLE_M2_AVALANCHE_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_PRO)
 #define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
 #define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
+#define MIDR_APPLE_M3_SAWTOOTH MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH)
+#define MIDR_APPLE_M3_EVEREST MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST)
+#define MIDR_APPLE_M3_SAWTOOTH_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH_PRO)
+#define MIDR_APPLE_M3_EVEREST_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST_PRO)
+#define MIDR_APPLE_M3_SAWTOOTH_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_SAWTOOTH_MAX)
+#define MIDR_APPLE_M3_EVEREST_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M3_EVEREST_MAX)
+#define MIDR_APPLE_M4_DONAN_ECORE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M4_DONAN_ECORE)
+#define MIDR_APPLE_M4_DONAN_PCORE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M4_DONAN_PCORE)
+#define MIDR_APPLE_A18_PRO_TAHITI_ECORE \
+	MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_A18_PRO_TAHITI_ECORE)
+#define MIDR_APPLE_A18_PRO_TAHITI_PCORE \
+	MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_A18_PRO_TAHITI_PCORE)
+#define MIDR_APPLE_M5_PRO_SOTRA_MCORE \
+	MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M5_PRO_SOTRA_MCORE)
+#define MIDR_APPLE_M5_PRO_SOTRA_PCORE \
+	MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M5_PRO_SOTRA_PCORE)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 #define MIDR_AMPERE1A MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1A)
 #define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)

-- 
2.56.0


