Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03E649DB8B;
	Thu, 10 Sep 2026 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049148; cv=none; b=ZjRoMxAV28a7U0RNq6vAB7La2JNJ8gPm9v+n624wOc85TyFFprRJ1y8LS6nv1ItfargKnHr+3FFkHPcOJodOajoYqNbVzQ/5T5cs5MV0yv4n9Od5i7FhPFy8w/G22m4DHak//pCiZDl0topjzsZ2lJsOgTrCc3+904y7PXxY8P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049148; c=relaxed/simple;
	bh=j2vpmR9myFwAcMjs58RSG+Vi3DV7VWhNBTVrLRXGffI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FU5rj/JK5b5UdLbKRd/LAeGb3glt9a7gNdC0mIn83/AnHLA8QB01/L1em/dXVQX+hOsR2i+Bghmns4pAqCgwxpGO1oulKDgKYYwYL+bnpAzh6ohdJunPWE9WvnUFt2B7vCaSUiNV/qa2p43ZTzlpdXFwkNZ9C0NctD9CHPTMfPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXqZJQPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXqZJQPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6310D1F000FF;
	Thu, 10 Sep 2026 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049146;
	bh=luXs/S+Jd2KjBu4OQ9brsQHU+FfslBl2cNL4bNycYLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXqZJQPNFlO9/UykM96CLppxtOFbk0Ol3RL7i4VXURo6OoPYE7Hio1SE7ITiM4wGD
	 bJV9HBk/AGRRnoLBB1u8cVw4BU/btRgxNwlPzPDvBhVSzWUWd5SZv62qc0MWtVn1hq
	 seBdwbFLXvofdWfGxSy2ip3TAEOlzCqRebgE9uDAamx14h+JunJCfRxd9yX6fz6cw+
	 H7kXv3GdUeQmkdapzX7nwbN7oJ3WscH+1eBdPZk1WRoyVOPjvA1OkuI76LDUtid1V0
	 ZARQhoAx9SFuWFVe8IKoftnCGjaJnrF5ZXG6pX+yi3EQaY+k+zLrsqs8i/3qBvqwB+
	 jVvNbOcKCvT4Q==
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
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH v5 04/15] coco: host: arm64: Add RMM pdev stop and destroy helper
Date: Thu, 10 Sep 2026 19:34:57 +0530
Message-ID: <20260910140509.868402-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910140509.868402-1-aneesh.kumar@kernel.org>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the host-side helper needed to tear down an RMM pdev object once later
disconnect and error paths are wired up.

Describe RMI_PDEV_STOP and RMI_PDEV_DESTROY, add the PDEV_STOP SMCCC
wrapper, and issue PDEV_DESTROY through the SRO helper. The new teardown
helper stops the pdev, drives device communication until RMM reports
RMI_PDEV_STOPPED, destroys the RMM object, releases cached PF0
device-communication state, and undelegates the backing granule.

No caller is added here; this prepares the teardown side of the RMM pdev
lifecycle for the follow-up patches that connect it to IDE stream
disconnect.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/rmi-da.c | 47 ++++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h |  1 +
 include/linux/arm-rmi-cmds.h            |  9 +++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 495a3bd2798f..7a72e8eead90 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -394,7 +394,7 @@ static void pdev_state_transition_workfn(struct work_struct *work)
 	WARN_ON(state != setup_work->target_state);
 }
 
-static int __maybe_unused submit_pdev_state_transition_work(struct pci_dev *pdev,
+static int submit_pdev_state_transition_work(struct pci_dev *pdev,
 		enum rmi_pdev_state target_state)
 {
 	enum rmi_pdev_state state;
@@ -420,3 +420,48 @@ static int __maybe_unused submit_pdev_state_transition_work(struct pci_dev *pdev
 		return -1;
 	return 0;
 }
+
+static inline int rmi_pdev_destroy(unsigned long pdev_phys,
+		unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
+				       SMC_RMI_PDEV_DESTROY, pdev_phys);
+
+	return 0;
+}
+
+void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
+{
+	int ret;
+	unsigned long rmi_ret;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(pdev);
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	phys_addr_t rmm_pdev_phys = virt_to_phys(pdev_dsc->rmm_pdev);
+
+	if (WARN_ON(rmi_pdev_stop(rmm_pdev_phys)))
+		return;
+
+	ret = submit_pdev_state_transition_work(pdev, RMI_PDEV_STOPPED);
+	if (ret)
+		return;
+
+	ret = rmi_pdev_destroy(rmm_pdev_phys, &rmi_ret);
+	if (WARN_ON(ret || rmi_ret))
+		return;
+
+	if (pf0_ep_dsc) {
+		kfree(pf0_ep_dsc->cert_chain.public_key);
+		kvfree(pf0_ep_dsc->cert_chain.cache);
+		kvfree(pf0_ep_dsc->vca);
+		pf0_ep_dsc->cert_chain.cache = NULL;
+		pf0_ep_dsc->vca = NULL;
+	}
+
+	if (!rmi_undelegate_page(rmm_pdev_phys))
+		free_page((unsigned long)pdev_dsc->rmm_pdev);
+	pdev_dsc->rmm_pdev = NULL;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 07034b034b53..f3bd106c8a54 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -133,5 +133,6 @@ static inline struct cca_host_comm_data *to_cca_comm_data(struct pci_dev *pdev)
 }
 
 int cca_pdev_create(struct pci_dev *pdev);
+void cca_pdev_stop_and_destroy(struct pci_dev *pdev);
 
 #endif
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index c2fc80dd19cc..f947b2f4909a 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -706,4 +706,13 @@ static inline unsigned long rmi_pdev_abort(unsigned long pdev_phys)
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
 #endif
-- 
2.43.0

