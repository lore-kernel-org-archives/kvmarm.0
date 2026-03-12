Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28873451B2;
	Thu, 12 Mar 2026 08:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302945; cv=none; b=GIhSjvlW1Bid3NA2a5YjZNbTuLYeZDY4bZ/TKwT8tMJWQzxBy/Xc62EpQqwZqD0TbCpnn5b+t+8zf/CPMp07o46u4zwvK80/NvuIGp+k1yUtB1Cz3gl8OdHsO9uabpQVFxgL9ZqghzZcNgN9oOG1x5QbO7gfyOVaRcQkkVVA/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302945; c=relaxed/simple;
	bh=jhZYbIx/ioIMcp6Qf6D0AyrmnhioxKZ41Sj/eUJHFfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/0JuJrODk+Nof9Iqhg4uOzdzKXOxYX5PHw9+pdgn3SYMDNoYcSu+Eo4NTDsZnewLKrWGef46yumsvmuutvpLN/aVBFiOHOtacaI9pYeaou1CdfPOGqfwcPdRH0DRvHB0PPT28+yUynYspFYUkIpyETVbkzmqPxY7Vre6z/1gbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKYOE0yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKYOE0yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1860C19424;
	Thu, 12 Mar 2026 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302945;
	bh=jhZYbIx/ioIMcp6Qf6D0AyrmnhioxKZ41Sj/eUJHFfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKYOE0yj56TVOGQs+HqiYrGUiscjS+7Paz0/3LYmU7nuBD/2Du3+nExFTdkh1ULgD
	 dGWs8qbF0H1tHb3oT+bLOPVxvIeMSCJTDnOyMfVMhOrMzzcCYjddcWnQYNUsM3/1xu
	 4LHflMegH/5Xmr2eCX3C1PMy5MCKnDUOgGVgHQpLSrLCtufw8bj35qmy+n01sF0tIs
	 jZEDf7uGl2YfdrlfgWm1SMlmaaz4DySbsmJ9xbULq+7cv7fZ/tZaRe8nY2EzC7e9iS
	 Yz1cTMfVShhB48tSs+Q0dAGo8M+QYeQqv1cwv0qCLG2DnkKselxARbDsrUNi0oY4Vw
	 6f3AC7mhAXJUg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 12/12] KVM: arm64: CCA: enable DA in realm create parameters
Date: Thu, 12 Mar 2026 13:37:43 +0530
Message-ID: <20260312080743.3487326-13-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
References: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have all the required steps for DA in-place, enable
DA while creating realm.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_smc.h | 1 +
 arch/arm64/kvm/rmi.c             | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 384bde2d423e..5598b19ffc1d 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -118,6 +118,7 @@ enum rmi_ripas {
 #define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
 #define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
 #define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
+#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
 
 /*
  * Note many of these fields are smaller than u64 but all fields have u64
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 5de49a47d782..328eef406419 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -703,6 +703,9 @@ static int realm_create_rd(struct kvm *kvm)
 	if (r)
 		goto out_undelegate_tables;
 
+	/* For now default enable DA */
+	if (rmi_has_feature(RMI_FEATURE_REGISTER_0_DA))
+		params->flags |= RMI_REALM_PARAM_FLAG_DA;
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys)) {
-- 
2.43.0

