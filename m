Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985131E848;
	Thu,  2 Jul 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008186; cv=none; b=QHe/91ITCTdg4gkxMtGxA6zry02VmUaIVzZCNlfXhm0F2lP6e3zPef7E0NHRNbbcDSY81iOO2slEaLkvyqMVUdOinCOpAlIaviqvLMbiucZUqfKdSLqSdnlxPGSKruHYK74ZroQFH5JZ2qoiXOidCBEhP5kDv5nTpe3phxq7NMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008186; c=relaxed/simple;
	bh=rUcyN6uAGe1vOQ9GUqQn+mE1kPx8Ir0yEVvo3/IzGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+i4kAjXksSP3jNVXlKabBTXU8y4G+SMmJi2P5lxdaq9NtzcM3Ex55l7Qls3SAy9G+wy77TdGp2ABbKdfbaIXgqeP+oXdh30Xe/NG3HrPt2oNGj29iJmCLBfhHcyq4TC5ZmCSu0KkqCQr5/KdMgH2QVoRfUZ51Dspde7r3a4acg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooq2MoRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooq2MoRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AD21F000E9;
	Thu,  2 Jul 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008182;
	bh=xoiK/RNeZLIkLzyKO8ly8OA0RZ+EXunPBVOADEEok6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooq2MoRvgWiEFq98enjtf/N6G9pI1Hp2DU6M7nlLExo9easAVqes1G8cQtPfJYgrg
	 ek7vk4EyZxyJxh7B1bjLIUpBcaKFjlTXqGmMlZ6Hfl6p0fLdMhRqfdMcTHVlLBqYNj
	 gepRgy/yGGVJc6PbLdBfLLkILfIlbA2a5VL5du1KLJBUUzVY9bs/EIKiVgZmjy6wL8
	 SkvclwxYjIvuGOH/gY2JOTc8Z2VHH1owQCRZk0Q12y3lWmr5W1lBzgF8Lb4GYeAmwC
	 00PuJrSU34nAxZsEt/dqKDlZhrPgfUijHuIq51YtpDaBsEklKa1u+8jVBYjHbTFJ0i
	 9oXnmP9HwCwfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsT-00000000ojd-0ejd;
	Thu, 02 Jul 2026 16:03:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 15/28] arm64: Add ARM64_HAS_NV3 capability
Date: Thu,  2 Jul 2026 17:02:35 +0100
Message-ID: <20260702160248.1377250-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
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

