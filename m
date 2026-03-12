Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A327470;
	Thu, 12 Mar 2026 08:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302519; cv=none; b=Q5pSIOiClWCGMYzQ3AiZu+IaYIErBfHN+6VdXjtwQYi3/Sy14DGLzSMQcqaCwj0UO9S1onLhvDl45WNo+XA+2j0NXkRLB2ZTfzA2krXfi0b1Mq7Q0OwKu7hcKP7GA8IJw8Tjq5BnJ868JkkMRmFgD46ik+oREqzdGtkF+6tliKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302519; c=relaxed/simple;
	bh=u+K2YX0UiSGjqu/03TsV46CS2J8/TdkIpbUuur3YNrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4OMKhj41NyBgB1s73oDm4cx0c6N6XrhE81ZhgSTEhfbJqWd2mhGYkfPe/KIIt8zFWvjj9GYGN58B4RzLKRiRTTmpgSrmFJ164TaSyjvEOLREvYxo5tZnyYgovF60/Hew76Aev2W1ar4ewLA85BhbXtzjNZfz0QjP74LVm7RYsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vb82oAZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vb82oAZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD661C116C6;
	Thu, 12 Mar 2026 08:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302518;
	bh=u+K2YX0UiSGjqu/03TsV46CS2J8/TdkIpbUuur3YNrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vb82oAZQB5riuIp6fPLoLpOePoCwPydEF1xFAVupqMWfuEQP0NvsxQIC6ZS3hIulO
	 827rgOsl/s4E5/l49GFccCO/LlvHivBjgkq3zgfnYCgpuSQiu7aVceFaw9YY+VD6Zb
	 KW50EqulVzvveWrVjPO90feb+l1eV2A3/7ZITBV4zngj5bkspJqqimawN4jkMM1GZ7
	 OtLo2/R7vept85hSX5SaGWjXzILwV/Uyr031CLBZkMLn8vYTvudhYe400Nfutj+jYd
	 zfQ48riBOWQHt+4T8W0o1DnEJsyvq/unfEzR8JtMhPeanEQeWDFMR3XeNdgY1NUGv2
	 HtfMWnQmXHPXA==
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
Subject: [RFC PATCH v3 01/10] KVM: arm64: RMI: Add and export kvm_has_da_feature helper
Date: Thu, 12 Mar 2026 13:31:20 +0530
Message-ID: <20260312080129.3483585-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
References: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kvm_has_da_feature() helper for use in later patches.
Update reserved fields based on Alp17 spec.

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
 arch/arm64/include/asm/kvm_rmi.h | 1 +
 arch/arm64/include/asm/rmi_smc.h | 3 ++-
 arch/arm64/kvm/rmi.c             | 6 ++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 1b2cdaac6c50..a967061af6ed 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -90,6 +90,7 @@ u32 kvm_realm_ipa_limit(void);
 u32 kvm_realm_vgic_nr_lr(void);
 u8 kvm_realm_max_pmu_counters(void);
 unsigned int kvm_realm_sve_max_vl(void);
+bool kvm_has_da_feature(void);
 
 u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 1000368f1bca..f6f786bfb9c9 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -86,7 +86,8 @@ enum rmi_ripas {
 #define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
 #define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
 #define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
-#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 42)
+#define RMI_FEATURE_REGISTER_0_DA		BIT(42)
+#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 61)
 
 #define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
 #define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 478a73e0b35a..08f3d2362dfd 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1738,6 +1738,12 @@ int kvm_init_realm_vm(struct kvm *kvm)
 	return 0;
 }
 
+bool kvm_has_da_feature(void)
+{
+	return rmi_has_feature(RMI_FEATURE_REGISTER_0_DA);
+}
+EXPORT_SYMBOL_GPL(kvm_has_da_feature);
+
 void kvm_init_rmi(void)
 {
 	/* Only 4k page size on the host is supported */
-- 
2.43.0

