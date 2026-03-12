Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBA92E88BB;
	Thu, 12 Mar 2026 08:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302548; cv=none; b=c9ZQM9pqkrfimlrcowFVzkW9JkQPulhl6Jf/lzlpsWdSgnNvt7MEPTvfPXGmsD9uZPoNHm0vld2a6tzffH9nHncaxmyim6VDaMNtCmssmXT74h4z+L59JIISJrGf6Qf/XQuA6yfSvQWY22VnC4zlnsxU1oR8CfikyY3zNG6bIR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302548; c=relaxed/simple;
	bh=Gzj/qINUbsAKyM46DkOxoWyoR/eowsPritJzhjgn8qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfBKGuoOFsC98u2Q7b0Iouept/ZVggX23y8gEoEgFLjWTEEed9jF/hQA3jgmGGRE50RI1qXoyp4z7dAiezmT8429FrVt9LhI6ofar1hSnyIkPg8mqh9rd9g/mEfEgITjayPERgRpWqJbTvOwpDTSNMFAsLhH0iEwf3yYPV69W2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rwthk/kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rwthk/kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F4C116C6;
	Thu, 12 Mar 2026 08:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302547;
	bh=Gzj/qINUbsAKyM46DkOxoWyoR/eowsPritJzhjgn8qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rwthk/kkaJXkDR6/kz9Vay9yZpdMCZPU201cnMwjmbpLQEftZgLG3x8wAvgQAnqAf
	 hTsWrWlJ9weeH8lSWTFf8Xhy87+XauV8JFUfAjpvGY3iAKV6upYE/iLCf0oQuMSeMS
	 SJ3P+mViJcniQLKFxBJ8qjMVHDVvQn1vhLHKol8Vz3MyTg2AcsmO1PbyuN2bShxaua
	 8H+m6DQnFoNpyTNQkNqucJInlAxk6hJyGtxZ+RrVtvAuOrJJ6H2737hrTHd86Y+4v0
	 GtR348dZJgW4ULzKSVSN2JzaGONW7n19Iyo6nvJzt+P0gKRB1wUaS/kuHYrEQWCVEv
	 pXC6Nvp8E16gg==
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
	Steven Price <steven.price@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 05/10] coco: host: arm64: Add helper to stop and tear down an RMM pdev
Date: Thu, 12 Mar 2026 13:31:24 +0530
Message-ID: <20260312080129.3483585-6-aneesh.kumar@kernel.org>
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

Add helper to stop and tear down an RMM pdev
- describe the RMI_PDEV_STOP/RMI_PDEV_DESTROY SMC IDs and provide
  wrappers in rmi_cmds.h
- implement pdev_stop_and_destroy() so the host driver stops the pdev,
  waits for it to reach RMI_PDEV_STOPPED, destroys it, frees auxiliary
  granules, and drops the delegated page

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
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h       | 18 +++++++++++++++
 arch/arm64/include/asm/rmi_smc.h        |  2 ++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 30 +++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  1 +
 4 files changed, 51 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index b86bf15afcda..f10a0dcaa308 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -556,4 +556,22 @@ static inline unsigned long rmi_pdev_abort(unsigned long pdev_phys)
 	return res.a0;
 }
 
+static inline unsigned long rmi_pdev_stop(unsigned long pdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STOP, pdev_phys, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_destroy(unsigned long pdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_DESTROY, pdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index c91cd0e389a9..3a57c7245029 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -50,7 +50,9 @@
 #define SMC_RMI_PDEV_ABORT		SMC_RMI_CALL(0x0174)
 #define SMC_RMI_PDEV_COMMUNICATE        SMC_RMI_CALL(0x0175)
 #define SMC_RMI_PDEV_CREATE             SMC_RMI_CALL(0x0176)
+#define SMC_RMI_PDEV_DESTROY		SMC_RMI_CALL(0x0177)
 #define SMC_RMI_PDEV_GET_STATE		SMC_RMI_CALL(0x0178)
+#define SMC_RMI_PDEV_STOP		SMC_RMI_CALL(0x017c)
 
 #define RMI_ABI_MAJOR_VERSION	1
 #define RMI_ABI_MINOR_VERSION	0
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 93512f7e73d5..ba6d67e5f54e 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -435,3 +435,33 @@ int cca_pdev_ide_setup(struct pci_dev *pdev)
 {
 	return submit_pdev_state_transition_work(pdev, RMI_PDEV_NEEDS_KEY);
 }
+
+void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
+{
+	int ret;
+	struct cca_host_pf0_dsc *pf0_dsc = to_cca_pf0_dsc(pdev);
+	phys_addr_t rmm_pdev_phys = virt_to_phys(pf0_dsc->rmm_pdev);
+
+	if (WARN_ON(rmi_pdev_stop(rmm_pdev_phys)))
+		return;
+
+	ret = submit_pdev_state_transition_work(pdev, RMI_PDEV_STOPPED);
+	if (ret)
+		return;
+
+	if (WARN_ON(rmi_pdev_destroy(rmm_pdev_phys)))
+		return;
+
+	kfree(pf0_dsc->cert_chain.public_key);
+	kvfree(pf0_dsc->cert_chain.cache);
+	kvfree(pf0_dsc->vca);
+	pf0_dsc->cert_chain.cache = NULL;
+	pf0_dsc->vca = NULL;
+
+	/* Free the aux granules */
+	free_aux_pages(pf0_dsc->num_aux, pf0_dsc->aux);
+	pf0_dsc->num_aux = 0;
+	if (!rmi_granule_undelegate(rmm_pdev_phys))
+		free_page((unsigned long)pf0_dsc->rmm_pdev);
+	pf0_dsc->rmm_pdev = NULL;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index db4bf893f596..fbfbcd40beb4 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -116,4 +116,5 @@ static inline struct cca_host_comm_data *to_cca_comm_data(struct pci_dev *pdev)
 
 int cca_pdev_create(struct pci_dev *pdev);
 int cca_pdev_ide_setup(struct pci_dev *pdev);
+void cca_pdev_stop_and_destroy(struct pci_dev *pdev);
 #endif
-- 
2.43.0

