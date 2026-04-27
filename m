Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9673822A1;
	Mon, 27 Apr 2026 08:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280081; cv=none; b=TcdGSqm62poQgS4SBIywV5+3o7ngchIXhjBS8P3VZ3JZ+TSRBAUnbE2bzaF/Hpq8sJ1Tzd7lvh9eI+NEKZk+6eGstWKUKp1aIu0b1rCrvlwvqYEvGiLkdKfqGKNx5qrt0dXSwZX5v87ChdHFr6buS1NAB3Y4IY3X81VM9IeTSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280081; c=relaxed/simple;
	bh=rtTVLA/VJy6evbm/ivqwSH7GHIN3HGJDjRTvLrxIYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHeu/fewJNOloTFtpgWiowjChfSqVuYKV6UPlnWQDqTIADKARMiF0rcMEOrinxp025joH+mANxDAtsRNpmaXUZfuFJgGa33mBmcsNkg38c+W7ZGZn0VBxt3FJ9ApLWORWOyG3AxgilcGfotN+yTUfFTwsAdbh8PiRPtFkVNj51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYA+IKY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYA+IKY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32838C2BCB4;
	Mon, 27 Apr 2026 08:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280080;
	bh=rtTVLA/VJy6evbm/ivqwSH7GHIN3HGJDjRTvLrxIYOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYA+IKY2frtx6nmf4OwXRF+4boBROWsLfWGDclUZDZ3h5mqiGfUfCWy45DliG73NY
	 DtVPJ/m6kJpKw3HhNuU7N99Gq8aaEgOkJJ5ZvsOWPSsRnsRRQAmzH7gYIqaIfkM1Xt
	 BuAT5BtWdk2BvpXZQKXqS12IVLeLiuckuqhsVvT2i7UfPf/aefweHiOEG5DB4q1P8b
	 YXR5HKtvCK/LN5nj2N7Y8RtzQOao8iQ4lG8IDzA8FZcdF+rxKOylZur4oYk5kBi09R
	 axWzFwThdcRMCtAAeHxsu0XC73e8YuLlG+bWLJFUU6Utq8QCBXxsV+ocus76UzhjuD
	 M3bkYAFfbkP5w==
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
Subject: [RFC PATCH v4 07/16] coco: host: arm64: Add pdev stream key refresh and purge helpers
Date: Mon, 27 Apr 2026 14:23:35 +0530
Message-ID: <20260427085344.941627-8-aneesh.kumar@kernel.org>
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

Add RMI command wrappers for PDEV stream key refresh and key purge,
and plumb them into arm-cca host helper functions.

The new helpers follow the existing stream operation pattern: issue the
RMI command for the local and optional peer pdev, then run the shared
stream synchronization work before returning.

This prepares the arm-cca host code to refresh or purge stream keys
during later vdev and stream state transitions.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h       | 24 +++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 35 +++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  4 +++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 242ce2fac14e..03dffba763e1 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -925,4 +925,28 @@ static inline unsigned long rmi_vdev_lock(unsigned long rd,
 	return res.a0;
 }
 
+static inline unsigned long rmi_pdev_stream_key_refresh(unsigned long pdev1_phys,
+		unsigned long pdev2_phys, unsigned long stream_handle)
+{
+
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STREAM_KEY_REFRESH, pdev1_phys,
+			     pdev2_phys, stream_handle, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_stream_key_purge(unsigned long pdev1_phys,
+		unsigned long pdev2_phys, unsigned long stream_handle)
+{
+
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STREAM_KEY_PURGE, pdev1_phys,
+			     pdev2_phys, stream_handle, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 84f0b2211cd1..128079d5b993 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1038,3 +1038,38 @@ void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 err_out:
 	return ERR_PTR(ret);
 }
+
+int cca_pdev_refresh_stream_key(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle)
+{
+
+	phys_addr_t rmm_pdev2_phys = 0;
+	struct cca_host_pdev_dsc *pdev_dsc1 = to_cca_pdev_dsc(pdev1);
+
+	if (pdev2)
+		rmm_pdev2_phys = virt_to_phys(to_cca_pdev_dsc(pdev2)->rmm_pdev);
+
+	if (rmi_pdev_stream_key_refresh(virt_to_phys(pdev_dsc1->rmm_pdev),
+					rmm_pdev2_phys, stream_handle))
+		return -EIO;
+
+	return submit_stream_work(pdev1, pdev2, stream_handle);
+}
+
+
+int cca_pdev_purge_stream_key(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle)
+{
+
+	phys_addr_t rmm_pdev2_phys = 0;
+	struct cca_host_pdev_dsc *pdev_dsc1 = to_cca_pdev_dsc(pdev1);
+
+	if (pdev2)
+		rmm_pdev2_phys = virt_to_phys(to_cca_pdev_dsc(pdev2)->rmm_pdev);
+
+	if (rmi_pdev_stream_key_purge(virt_to_phys(pdev_dsc1->rmm_pdev),
+				      rmm_pdev2_phys, stream_handle))
+		return -EIO;
+
+	return submit_stream_work(pdev1, pdev2, stream_handle);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index cd13cbf650d5..d6cdbc638d6d 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -235,5 +235,9 @@ int cca_pdev_disconnect_stream(struct pci_dev *pdev1,
 		struct pci_dev *pdev2, unsigned long stream_handle);
 void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 		struct pci_dev *pf0_dev, u32 guest_rid);
+int cca_pdev_refresh_stream_key(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle);
+int cca_pdev_purge_stream_key(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle);
 
 #endif
-- 
2.43.0

