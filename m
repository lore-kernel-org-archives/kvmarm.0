Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE031DC9A3;
	Sat, 19 Jul 2025 02:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891114; cv=none; b=n8pxf87cYl7x6iVO1gRtozXb61JZz55OpHWEyc4JVyvZtEzRJk1J6ejYzh/L4qVD/Q/N870R0sVbiMIlSGnaP3Xt+j6uxRZqm+mmOh077rsThJ7rwB42OVYhm11R4cvrjY2bdCvNTLyZ+gqgVSUBCnLZvf9jfCeK6LTRYzRs8BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891114; c=relaxed/simple;
	bh=Qkay+td2CTF8tiBwafQanjBkZb8hXhQmz0Ko/raVV7c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m+xMKqVdgO946HweuQbYESY/MbmsQw3i2Ne1TXnsLKR4hcOcfjODAAKIni9BpzRG0O6JdoFB2STaeBFfGybqIdil2H+tYbLmCcoAT3fZ/1ymufxlhp0Q4WrbWumnziZE92oTozvUJVd2v5iPp67d1y58IykkQoCR25Dnn9jLwUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvzBhPX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvzBhPX2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9659C4CEFF;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752891113;
	bh=Qkay+td2CTF8tiBwafQanjBkZb8hXhQmz0Ko/raVV7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kvzBhPX2As4S9PpPjzujySHMe3jFqms6HMlL0V9wpkpYHlWsxrHjO9A2MEYY2eLbh
	 mEroUHMTA7LOsSDrqNMug+L0vFFnSHdZGYzahA6Vvkl/DHIDo8qMZYSLMmvBHlPltP
	 j7X3xEDLpX5YHb8RfrhHyPyfnoKrCWKomCE68FZk2mPohdZ2el872gDANrEIWpKI5w
	 cKLDKQlTeJAymtOSOmH/wMSwynhrOxQNZ90YfMlVunbB6jzAxYwi+kBX4aXJ6AXPc4
	 XT9NI+bklB9duXZFpDHsAnWe+3IoZSkWc9RnrL+D1yB1v9KaEgHLMDCPxpMl4l8zUn
	 0YKzI6KzZbJxw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB895C83F1A;
	Sat, 19 Jul 2025 02:11:53 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Sat, 19 Jul 2025 02:11:27 +0000
Subject: [PATCH v8 5/7] KVM: arm64: Mask response to FFA_FEATURE call
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250719-virtio-msg-ffa-v8-5-03e8e8dbe856@google.com>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
In-Reply-To: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752891112; l=1363;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=55yA/b9WaRmX85NmDdLJkZinkMYQwcAGAdUeGaUKBZ4=;
 b=sNeyafSSHUrLsmXTiUjqsrcfVjOFuY4rtzvyG/u1PdIsoRhxBd/haBBhQ1GbB2Dt0nX/m0MLl
 pbxXYv/TMoOA6/Y9FNIxafXa33hJUmsrt3XKiCqhCvmuwtgEaAsL8Mt
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

The minimum size and alignment boundary for FFA_RXTX_MAP is returned in
bit[1:0]. Mask off any other bits in w2 when reading the minimum buffer
size in hyp_ffa_post_init.

Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 include/linux/arm_ffa.h       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 5a173ea481940236356e2bc4248d094a858a0923..2cbecc9af5d27a9e7c8497001cf9b0987c72bdb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -733,7 +733,7 @@ static int hyp_ffa_post_init(void)
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
 
-	switch (res.a2) {
+	switch (res.a2 & FFA_FEAT_RXTX_MIN_SZ_MASK) {
 	case FFA_FEAT_RXTX_MIN_SZ_4K:
 		min_rxtx_sz = SZ_4K;
 		break;
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e1634897e159cdc208931938649eb0fb04d5a070..cd7ee4df9045dceca1c4e0dca2d533b770b1b056 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -128,6 +128,7 @@
 #define FFA_FEAT_RXTX_MIN_SZ_4K		0
 #define FFA_FEAT_RXTX_MIN_SZ_64K	1
 #define FFA_FEAT_RXTX_MIN_SZ_16K	2
+#define FFA_FEAT_RXTX_MIN_SZ_MASK	GENMASK(1, 0)
 
 /* FFA Bus/Device/Driver related */
 struct ffa_device {

-- 
2.50.0.727.gbf7dc18ff4-goog


