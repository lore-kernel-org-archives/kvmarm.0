Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0653D28C5B1;
	Mon, 27 Apr 2026 08:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280137; cv=none; b=VJeNBYOOVAZ4kuG7wKi6kZtb+eYR/2XPqdDQo1H5U6utqJZJNlD1Dy5Vg9h+l+u0Ji+qmpooxVBMZw6Si4o/pSNJ5xgo+XBKwWMjkAl93/cYVvBiAA86ILKX12rxbpiHrZtY6WBenefc9R0nE11jPo8EMiVz0/o2oBqtUSp+4MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280137; c=relaxed/simple;
	bh=bOeW3wbvkkrlNUf/VIWIVhSCHUYQcXavZMh9tYHAPFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsdhIru7QjrlNkPQ4SKxgImGrjG6dOYSgus61D3wEJcTBxXw9tC6ku5Wv3DpXxn4TAO3sRo8KartCBuripOTvzW7TOQeMOx2xYNqTWZ+4oxLDad1vI4LbO4laUn8vCHzejOcSEfBHukHp354brRg7XIVREHowH/75/CBqVXJVAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=el4gRSMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="el4gRSMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B750C19425;
	Mon, 27 Apr 2026 08:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280136;
	bh=bOeW3wbvkkrlNUf/VIWIVhSCHUYQcXavZMh9tYHAPFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el4gRSMhKtyPa8PfIyrtLcnxhEU67PzIeRckrMU2d/sCX6uHEDbYVpT1z9/3kcR3m
	 FhXZyRQefVv5RMhGqFZpoIrSX2eLxueKjxm5Lf745+Xx9Vl5vzvUI/QzJDmEk2bs6M
	 dXoNySpemHjGRhOdJV+1CbZ5rR9AzeScSn5m4cS7SIGQrBk2Mc5uQz8EjORYM9AND6
	 CzAruS+R8Ns3bdfknS3S6cZjM9LXRtUHF2jlw4BUIsA2kiqsD7xH8lvqLjESw0zc1O
	 q++suWnwXeV9RZIQqBt57xDCY853fmmbJ40ncaS4CQZh283hJx2N3oSQ+0Xee2k4Nv
	 BY3rWVUtKlVHA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 16/16] KVM: arm64: CCA: enable DA in realm create parameters
Date: Mon, 27 Apr 2026 14:23:44 +0530
Message-ID: <20260427085344.941627-17-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have all the required steps for DA in-place, enable
DA while creating realm.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_smc.h | 1 +
 arch/arm64/kvm/rmi.c             | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index f3ad545d68b7..c02e2f087b1c 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -268,6 +268,7 @@ struct rmm_config {
 #define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
 #define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
 #define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
+#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
 
 struct realm_params {
 	union { /* 0x0 */
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index cc9e045dcae9..e041c4caee79 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -691,6 +691,9 @@ static int realm_create_rd(struct kvm *kvm)
 	if (r)
 		goto out_undelegate_tables;
 
+	/* For now default enable DA */
+	if (rmm_has_reg2_feature(RMI_FEATURE_REGISTER_2_DA))
+		params->flags |= RMI_REALM_PARAM_FLAG_DA;
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys)) {
-- 
2.43.0

