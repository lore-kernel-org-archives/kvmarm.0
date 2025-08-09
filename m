Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568A1D61BC
	for <kvmarm@lists.linux.dev>; Sat,  9 Aug 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754747521; cv=none; b=Q8zBlxzzLH0Gv8SN0JeeadoN0Ql4Tfjut/16MTJFtX/qIbJ0MgYbkF/+gEwef4CsQOCaG23AkSCjy5AOtf6pl9wk9OUDrX9iOVJe9EX7tesnSMsF2Pkuh9ZX7q4/wcF524OX3GnLr2S+5X7s+w0ZXiV0Dk5Z7RoHHyeTP6PmMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754747521; c=relaxed/simple;
	bh=tjyqMDsgDi7/+p9JXVyraldUe4Vb3gfBUInuu8Tjjwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nP4+nW+PKhdJxtBAsBbk2wmi8OOmthMXQDDJly81rWRdBV/I/CsatYC6WfPAK5BKLoeR00acyoyBdhIIJEI9eAIig8fyV0Pga3Yg5uNijoAS3Zv4mJiYrDTQyio9BMPaYhW0WyQPT7E0jZ5UemdHlYF4FMuxv/oyB0+g3QODRQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=CWc6sKu4; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="CWc6sKu4"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76c3607d960so3297159b3a.1
        for <kvmarm@lists.linux.dev>; Sat, 09 Aug 2025 06:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754747517; x=1755352317; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jFMFOpY04n7pfsjOLDYFeb6qmDpqp5aExAGmAsyPClc=;
        b=CWc6sKu43/IAmdH/mYfJHRft2zP1BjCXSttkQKNx6yavmxQ8PukjCBclDYB1oIcXLm
         7oflE0mn1C0i7HNax7b/M0uiy3t+gqiIdBDB/jegCET0Vs+BXpAwdBn0MV2EAF7HxQD5
         KOjwToo6Ncop/ZWx99DXWdOblqUdBdHRx7brEfWkDNngsI2ja//Bu/HMwDc4SQQ1CLIg
         MQPbUYkyemyTmwgLhYeS/AP5fm36JaeqfJXAnxEa8ZpoCtQJPJpe54jAvAaKW3j00UUQ
         hkNNbvmOh6UhTJAb2NKTmNdeNgqeMCAh3x44wnwb92AyjYLWCVgUY2RH5sFp4kBBxDMN
         ymrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754747517; x=1755352317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jFMFOpY04n7pfsjOLDYFeb6qmDpqp5aExAGmAsyPClc=;
        b=HcZtRnMHoGcqcSi0DUzYRD+HHLYqlssAZYrHAQQESqn/aRVC48x73ZTpSyxAipAeB0
         nbIfOgCXcm38w9jbVFkrkNmGX+xCaHubPSHlNdw1+I6tDTjRIxxSsWeyq5he02d7AUqp
         jFLtaAcgZhPK5GjhKDMn/kDAW4ogfFNaaAS4ag2YAii/9495f5xr8ypd3KR66Lu+MxN4
         keAHvdWbHbwyjajaR+AYkzw3e2je3eUCoWzyshrARyaAwI1686QTX5YvwT6P85D/Lb03
         K95rCuhvyXa30NBvC9gCThWLVV3q51mFprTQA3mosLb9CsI9PRGdKLPJ4tfFLnD8s3sg
         uwVg==
X-Forwarded-Encrypted: i=1; AJvYcCWV9Qvm2TLsucmYbWjOqzqlWyLfVgvspTxYt8xbr7qD0PJzl1MSrV56gmCshRbcD3gQmoZHwbQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtTSDCNXyJah+5kWqGAOuauer41Psk+8QFCahz1mA3l4RUvIfx
	POUgpyOt0iWWWQjdaBkdoIf6aWYbzgj+3PkK1WzjhjNdgK9q0dO8BbtrvxyHyaFC/OVSlDpPc1Z
	uG5A7HZ6w+6Fp9x+MqNpS6DCEtX3MOHu8jOO562HjVkGgwdrceME=
X-Gm-Gg: ASbGncu76s9YQktCp95gYfG2q8QtiY12fWmM7Y98Wy/jMF/rKR7JA8gFFN+4BUuIT6G
	wUlbz8HUBQwzfDyEry8JggJ4vx/pjd0HT2OU8gCGT6QaDNrJq+1s/hGwB1pObVCL1CxAL2rnSJG
	pTYN3ipkVvtyoskIEXJoH/jZ99StyG2QbFBrnQlo+MKDhNY+snvZoQYdA8RL2zV5cic07gSsvvH
	nIg75PQUXnEVOTVm0y/0LEDXTjE9I+HJgEvsExd+2OO+at9ls0qjVARQoAwLshvm6h6jebMP51S
	/UyYR7AQvelNUItChjYT62fsKj2roSvfnK5cp9mMmNgyxk4ndkTC9CFRBrXisJAQelVjPxH5A8e
	WQZQFj0KX/NYPYNSK7RFWvX527tZdUEPT40PtDsbVd/YyipbDTCJ+6qvCcaZrRD97QA==
X-Google-Smtp-Source: AGHT+IEeNgCRS6Ls8b+R2Cf86RDBC5tmWlbLAIMn2W5koGX7pj8yLDZ046+xiBALeYUwG2HzAegNfg==
X-Received: by 2002:a05:6a21:6d94:b0:240:1bdb:bed2 with SMTP id adf61e73a8af0-240551be2a1mr10707896637.32.1754747516856;
        Sat, 09 Aug 2025 06:51:56 -0700 (PDT)
Received: from zenbook (1-162-100-9.dynamic-ip.hinet.net. [1.162.100.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8fa10sm22538342b3a.52.2025.08.09.06.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 06:51:56 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2] KVM: arm64: ptdump: Don't test PTE_VALID alongside other attributes
Date: Sat,  9 Aug 2025 21:53:56 +0800
Message-ID: <20250809135356.1003520-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

The attribute masks and test values in the ptdump code are meant for
individual attributes, however for stage-2 ptdump we included PTE_VALID
while testing for R, W, X, and AF. This led to some confusion and the
flipped output for the executable attribute.

Remove PTE_VALID from all attribute masks and values so that each test
matches only the relevant bits.

Additionally, the executable attribute printing is updated to align with
stage-1 ptdump, printing "NX" for non-executable regions and "x " for
executable ones.

Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
Tested on QEMU.

Changes in v2, thanks to those listed in the Suggested-by tags:
  - remove PTE_VALID from .mask and .val
  - make executable attribute output format identical to stage-1 ptdump
  - Link to v1: https://lore.kernel.org/kvmarm/20250802104021.3076621-1-r09922117@csie.ntu.edu.tw/
---
 arch/arm64/kvm/ptdump.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 098416d7e5c25..dc5acfb00af91 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -32,23 +32,23 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 		.set	= " ",
 		.clear	= "F",
 	}, {
-		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
-		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
 		.set	= "R",
 		.clear	= " ",
 	}, {
-		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
-		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 		.set	= "W",
 		.clear	= " ",
 	}, {
-		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
-		.val	= PTE_VALID,
-		.set	= " ",
-		.clear	= "X",
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.set	= "NX",
+		.clear	= "x ",
 	}, {
-		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
-		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
 		.set	= "AF",
 		.clear	= "  ",
 	}, {
-- 
2.50.1

