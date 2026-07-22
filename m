Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9092447255D;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706182; cv=none; b=GIHYEonqsUrkkmAH3sckqp/qZTxYLUe7MiHAi8/v0/ToaF3A9CddBGIsbjqbGUZN3nzoLz9vNg8Ak86EuXDQ6fqSNFF+eiWtou8naRGrSRm7SI2okBX/HIUzlEk3zvxdpBlh6b6WenDQAXbVlDKYkAnKtaIdv50dPBkSM0fSwRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706182; c=relaxed/simple;
	bh=rUcyN6uAGe1vOQ9GUqQn+mE1kPx8Ir0yEVvo3/IzGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOLSkjtdWfqUQqX4+B6z1+xuN6IklveYEheL8riQVURCkmCrZADNJNYDwE+HipSmHnDbINBWLIRX5tr7swtGZX0IrI1qqo4McBbUvD4sTZedOu3G13SclZIVa5LcFIknOrC78WNdW0hzT5hcgNdJuwN8w2sOnuR1onVAnvyVtno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzJHohDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzJHohDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5736B1F00ACA;
	Wed, 22 Jul 2026 07:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706179;
	bh=xoiK/RNeZLIkLzyKO8ly8OA0RZ+EXunPBVOADEEok6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzJHohDVyI6P4ZJ4DQTUQLOatceS5eWJpoGlO6jAJTfihjhxEuPH5xdf0NgajRyRV
	 tM0g0Mir4HbL3zjmrbHx+nqNVO/lknikIg7cDf6epQPyO8aXrGRznyMZvfUZ5IBfNy
	 DJ8oB5lmQF9exHLYARxFayn9JvAXNMglEdUgFVoEYiSCRoOaQR/lsDYxatp5yrnMne
	 mC4zb1zxZ2KU72Ejx9v53rKN8+0IoAEdl0WpmnbhrYG4Hpf1FbItBeOdbWmayZ30l2
	 eMyrK62segb7uFkCAPYKFookTDfxnB1kTp5r50x/BQzLXdZTHtVlAK3aIzEGOoiiCF
	 nuXvkHpncyT2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbV-00000007VfN-2cJ6;
	Wed, 22 Jul 2026 07:42:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 15/28] arm64: Add ARM64_HAS_NV3 capability
Date: Wed, 22 Jul 2026 08:42:21 +0100
Message-ID: <20260722074234.3330999-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As a bunch of KVM code is going to depend on FEAT_NV3 being detected
on the host, add a new capability that will describe it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/cpucaps | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 242dc211d8efa..7e0414509e89a 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_NV2P1
+HAS_NV3
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
-- 
2.47.3

