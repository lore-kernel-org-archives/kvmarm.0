Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789010;
	b=apH7eB1PEQTuSH6gEcUlUke3jX3GPYLdKuvHSrZg2bBrDMlrTVAEr1Mi0hhig/MkerE+
	 zyn2A1a5BzoVzKsplK1AIqUu4+bC0nXOL0fToY2tOlQq8JlwvmiiaqAVPMvvltIcMzZI6
	 13vrVdAEZgI0LPlS6KQcgPAn+4rewdKj6rqAfyAYaGzWQO2ydphTm+JlQ2rdikKsyUyi7
	 4zHJjj2hisgpvsKTcqlsvPrX6pMRv8f0nITi4VZcL1xB1Onff5eHk89YImgGwsPPLjW8u
	 B2LgHjyF+xM4FuaO5eEv9/drV1dHzmu8zFLjcF4uY13KqQOKt9f+w/t6kTEINo59uJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=T+c+qHuV/ncfk0023R5jpsYWy4rJwxIEtWqn9Nfv4Lo=;
	b=JHXpTywjY5ImNA8VGegRjEIn2PSYetfTtP7P8SyAFdqbrEP+R7SBuPolZ0n70ZNTGxq1
	 2EddHrUOiWjbIA0Ttgf5xPled8uOI/aDsqT4i5ldTqsBjwPZ/fEEVeE/wSpRU63Nv6buz
	 puZGzJAIKTI+UbP5C6/ZB6poYCE2lEZOfUalFcTLbDA2VOGQMo00e+jG7iojTZPtdgLEW
	 /OnqkIB5f67hIQ2HKUwQJ7v56kbLx7GSGi0LMfpkXhQ6+JVyWW0rsw17Knj48XsIxDjM4
	 NH1vMMDoSKIQohfj2uqK3llxUoHLiz/Yrf9tNqpVGmCXtdIxpdPU8XV3bK8fxi6/Qlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=agYJsb+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A238C606A329
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=agYJsb+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF581F031EB;
	Fri, 23 Oct 2026 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789010;
	bh=T+c+qHuV/ncfk0023R5jpsYWy4rJwxIEtWqn9Nfv4Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agYJsb+EQPYXMKeO1zM8RpvVkHX30OAoLO/yZtFnQzlQR/VKT30fuVqlG5oG1QXpt
	 T/XvZahkhtWU9YXr4Fym960TssRGKWp7/jbC6qX9u1GcZYgq7iElpLblSb5Xn1NslE
	 xoi9EsTWT4VcHY8MBeDm/kNwGCS4yeqmzzu5nTDwhVo0AAIQKkXJHltW6DMkmMKwKG
	 oDQFA0mfAqufSFi1ejZTNyUaDpvSsrfedizJhVWbqVEkbMxxaGLkZ1M0cfrIQq2isI
	 DTznVGUV9wMji2zs42o5zof2eG7BGSbD5uzN1yPP+9GLOcCLIe0RiAD2A+jxE2dXpK
	 xoQZ4nXdtJblA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 19/28] arm64: Add command line switch to disable FEAT_S2FWB
Date: Fri, 23 Oct 2026 13:56:01 -0700
Message-ID: <20261023205610.1044532-20-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assigning noncoherent devices to KVM guests does not work when guest
memory is forced writeback. There's absolutely no reason to support
this configuration, especially when disabling FWB is a valid fallback.

Add a command line switch to disable FWB in anticipation of KVM
mandating it for noncoherent DMA. Use a kvm_arm alias that can be
remapped in the distant future to select passthough S2 attributes
when FEAT_S2FWB becomes mandatory in the architecture.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++++
 arch/arm64/kernel/pi/idreg-override.c           | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33cd30996e47..1c0e3b9e726d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3265,6 +3265,10 @@ Kernel parameters
 			"nested" and "protected" are experimental and should be
 			used with extreme caution.
 
+	kvm-arm.nofwb
+			[KVM,ARM,EARLY] Disable the use of stage-2 forced
+			writeback in KVM.
+
 	kvm-arm.vgic_v3_group0_trap=
 			[KVM,ARM,EARLY] Trap guest accesses to GICv3 group-0
 			system registers
diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
index 274bc72ba98d..188e1fb2eb2c 100644
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -103,6 +103,7 @@ static const struct ftr_set_desc mmfr2 __prel64_initconst = {
 	.override	= &id_aa64mmfr2_override,
 	.fields		= {
 		FIELD("varange", ID_AA64MMFR2_EL1_VARange_SHIFT, mmfr2_varange_filter),
+		FIELD("fwb", ID_AA64MMFR2_EL1_FWB_SHIFT, NULL),
 		{}
 	},
 };
@@ -245,6 +246,7 @@ static const struct {
 } aliases[] __initconst = {
 	{ "kvm_arm.mode=nvhe",		"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" },
 	{ "kvm_arm.mode=protected",	"arm64_sw.hvhe=1" },
+	{ "kvm_arm.nofwb",		"id_aa64mmfr2.fwb=0" },
 	{ "arm64.nosve",		"id_aa64pfr0.sve=0" },
 	{ "arm64.nosme",		"id_aa64pfr1.sme=0" },
 	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
-- 
2.47.3

