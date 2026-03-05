Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1703A4F4F
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728129; cv=none; b=iRl6f4Y3RXjQHXjjCVdz0zj9qOs/oV1h/T0/5ntuNrU3J5IcD2ZHBFuxYZVXF3+8qDQc9PSWPJey28yVw4T5GmdpePPj3Vs8Uo9gzKhzHSxRcbB/Zpdd1R1JLa8MNi8pRlLC37FJi+dgnePZ6lqImRgvMiclUWtDq1+ZC5v8yZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728129; c=relaxed/simple;
	bh=2S5PTvK87I+Qh5I19el/UlNBKG+XhL7b+ScuE9mZI04=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=g7NHdmbfrPYZxu1MJsW+iegVkfDAdPuvYse63SuJEuvdmqP+WcAKWcxi/uSpx6u6IaMKZaY54yfAaevYGnpGbJGViBZSma0tpL06/4GUzwniDezi8xZy2yuGNLP436IJWqUYhhCoKzOfrmv9OOoZG0ej+zWstDzUBUqdLnnV79M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g2jQakzr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g2jQakzr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439cd6b0aedso1022751f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772728126; x=1773332926; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bO2UOIDwg7LbHLAJUvx/Ly3Rtx5QYHbhjFHT70hclSM=;
        b=g2jQakzrWHjJ80KPxMbOdWEB5lkv87+SLblF25OMKp/OHn49Oo29x3e9qOZ9goEnoI
         ZKn2p9bxdYjkVWt01GV+8jEnKMsJL2ullU6z2Q9u4pPnIt1UzEQMKwIyY38Olm+4jHHG
         F540OoPWwjvFWUzQNWSHJAuWbkd3Xfl0uzU5mFRDvUDlPL4wTZJ9MoU78CXYk4zi0RTJ
         fYuKFrP6ZlAOPDPF6qHgB4VdMt74egs/4/5zwrZJ2O1O2pXwM8HBJpl/Qrvv9XzFkzWe
         XTjIItsK8xh49s+VQeGiBpETqPSYJvsEtCJYph3Op6dNMBzcku6RmCuqBpmnLKc4hiNo
         7Rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772728126; x=1773332926;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bO2UOIDwg7LbHLAJUvx/Ly3Rtx5QYHbhjFHT70hclSM=;
        b=ujSNMT7vfJoagWJm7urGiUFRYVjAq3+3w1irFTuimm6sGX5N1DhoZRNciSwJijvJfb
         ARP1DIYyFT4U4Ign+b6uaFBJRY+uSZDq4flk18DDUhQNWK013k07tRtfx1LJxmDAC6C0
         BxbisxFupr5LR1b/u9T74Ae5elschkgrzr5OxQf06jVc7AELq5i1Xr+7sO4uzyPmj/Q2
         6BLJ/jINUtUnpmrz2iJXU8TjDrG1G7JQMWTk7ETzLyutXW3s479l2E3eu/0zzdjODfIT
         w8wSL6f/nImr6zC/6qatRAT0fzCjolbhoU4q3WOzLxyIUWDDasWdPrMuJwePdbVjToTw
         HUZg==
X-Forwarded-Encrypted: i=1; AJvYcCX/QwwH8T76m6eCcK59Uo5pldgdh+k1++FxOFdv3UgGTlH71ax+BeXLpZBEIqYj6veJpki9cS8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyay5U1od6bQvf5NPHhaHS0XfxNndfIewQCjE7PoqVz2lfahz4V
	nGDt6yUmAaJ+2s4uK9z/939qq+av4JqhLaj9+Zu/lbPUUFDDLXp2cnKBp0Ndoe98II8=
X-Gm-Gg: ATEYQzyPijrf3Afo7gC4hHZEhzpxVm7hVDXkFHMJ3+oaHquDY/jcBEtCIJA7oddvffW
	sF9oSWzGDbXvif3RLTHYbI+WrXrimz9Nl6fyq7IK2hNBqio9IUON3S4Q7lqGcamzW05DVT6uoth
	5D4LLhteSKWXvAwT0LPWXhGGsUUEBwH9kPkglPHKVBdkUeeXZJ71WTIVppBx/t0t4CDXClSfdOh
	K+JTDHb2+UqyB75FkyqkDfbI4vqAtHGTVFsZwmaLEA333DrjXSvtorUIWRq7njVS6VzwLsgLJci
	9hBlvevKKGVoYv6sd91LKbqIM8MAOe6zZulerg8GGpBSVXobW9KDcP1MsPq95RDFjxZGzZCsOsW
	teC6ucPuK+ll5/uM3UySR2xXUH+SRo+GRKOmUEKHjsh4ivVCe490k1eAMcjJHHhWap1du7mQ0V7
	6uIg1FAdpJ2Ol8qbSKbI7UPLJclG8i8sCJ
X-Received: by 2002:a05:6000:2386:b0:439:bcc2:bf0a with SMTP id ffacd0b85a97d-439c7f79f3emr12042592f8f.23.1772728126496;
        Thu, 05 Mar 2026 08:28:46 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439c2f8c0e7sm19596034f8f.29.2026.03.05.08.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 08:28:46 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Subject: [PATCH v2 0/3] KVM: arm64: Read PMUVer as unsigned
Date: Thu, 05 Mar 2026 16:28:16 +0000
Message-Id: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACCvqWkC/4WNQQrCMBBFr1Jm7UiSYhFX3kO6iGaajtqkTGpQS
 u5u7AVcvgf//RUSCVOCU7OCUObEMVQwuwZuow2ekF1lMMp0qlUHvNuJEj7yhPP0yiSY2Acc6Ni
 qqyPrjIO6nYUGfm/dS1955LRE+Ww3Wf/sv2LWqJHIKmu07pxT5ycHK3EfxUNfSvkCeqU9f7sAA
 AA=
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Colton Lewis <coltonlewis@google.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

Fix some issues with the signedness of PMUVer and PerfMon ID fields.

I ran into the first issue when testing "ARM64 PMU Partitioning" patches
on the FVP. The second issue was only found by inspection.

Signed-off-by: James Clark <james.clark@linaro.org>
---
Changes in v2:
- Handle ID_AA64DFR0_EL1_PMUVer_IMP_DEF correctly by using
  pmuv3_implemented()
- Fix another issue with incorrect sign in cpufeature.c
- Add a commit to refactor has_pmuv3() to use pmuv3_implemented() for
  consistency
- Link to v1: https://lore.kernel.org/r/20260305-james-kvm-pmuver-sign-v1-1-eea0a2116dd0@linaro.org

---
James Clark (3):
      KVM: arm64: Read PMUVer as unsigned
      arm64: cpufeature: Make PMUVer and PerfMon unsigned
      arm64: cpufeature: Use pmuv3_implemented() function

 arch/arm/include/asm/arm_pmuv3.h |  7 +++++++
 arch/arm64/kernel/cpufeature.c   | 16 ++++------------
 arch/arm64/kvm/debug.c           |  5 ++++-
 3 files changed, 15 insertions(+), 13 deletions(-)
---
base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
change-id: 20260305-james-kvm-pmuver-sign-fe830bdead2d

Best regards,
-- 
James Clark <james.clark@linaro.org>

