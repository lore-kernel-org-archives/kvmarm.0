Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3552E2850;
	Mon, 27 Apr 2026 06:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272773; cv=none; b=djq3jhEeCGhr+df6VprjEpToS2vf+AhZog7JDSaKd1xqy7Y2FXqvfbnYW+yLgBVYbW46ITJCvoNNdNRgBic5cATLybxOMzIIHBnJITVYl9z14sOmKDpQr7ca5pMtkGHU2+9Oz7izSHtFYq/iCTjZDt5+P0jM4agz3nziHbzjrVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272773; c=relaxed/simple;
	bh=TKihfP1sVP9MoGos7O6yEjkbJNsJ70AjwacVZf82tOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb6efkaXL+1iP8MaPqc3VjLd559qS/4HtP4YFYDF4C5lppmmOYRtf7WHvn6gVTS+Lvcd8z+TA1sG+9mQsn5kPpQfggyYloylJOE2hHXOScovxBM3yrSQuxdJErI+1QeBWoe0lIpWeXgtm5F3omwBW6VmeTfWAAEimu33JPAWU50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jb1GNe7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jb1GNe7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D30BC4AF0B;
	Mon, 27 Apr 2026 06:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272773;
	bh=TKihfP1sVP9MoGos7O6yEjkbJNsJ70AjwacVZf82tOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jb1GNe7oJiWmum8eE+T3ZUHoLT6j/OA0ZwpbjHuWebCbYAIuZ5FoqY15tUhTJx2LK
	 WrPejaCgrTcjFQhm1tLf1LCclzLc98EreGo2TbtiXili1SBXxQKmvUbddoIW3dgwg0
	 ZZBY37PV8tL/nS/NnKgMmneG9MNHBfsGz14rTMiNTL6zxzXQV9twoTmkVFytCTfGlt
	 m8piyK1TPe0UrBE8Bq8wUHvsKD9mB9ZU32UlrJu7lGedIKeN2n7IF6XW9dHuCtOfvl
	 OhV2qrdcw2+V+TDF7OfyqUv4VT1Rztktxc2ez54IHSTLpZRIb1uXMnFyhKLLsW+ej8
	 V32UcleUrrZHA==
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
Subject: [RFC PATCH v4 14/14] coco: host: arm64: Add NCOH_SYS stream support for RC endpoints
Date: Mon, 27 Apr 2026 12:21:21 +0530
Message-ID: <20260427065121.916615-15-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach the host CCA pdev setup to handle PCI_EXP_TYPE_RC_END devices.

Classify RC integrated endpoints as RMI_PDEV_FLAGS_CATEGORY_ON_CHIP_EP when
building the RMM pdev parameters, and only advertise SPDM support when a
DOE mailbox is present.

Also add the stream setup path for these devices by creating an
RMI_PDEV_STREAM_NCOH_SYS stream using the endpoint pdev and its bridge
address windows. This allows RC endpoints to participate in the TDISP flow
without requiring a separate root-port pdev.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/arm-cca.c | 28 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 10 +++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 265aa0cb612a..8b1182620872 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -277,11 +277,39 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 	return ret;
 }
 
+static int cca_pdev_create_ncoh_sys_stream(struct pci_dev *pdev)
+{
+	int ret;
+	long stream_handle;
+	struct rmi_pdev_stream_params *params;
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+
+	params = (struct rmi_pdev_stream_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	params->flags = 0;
+	params->type = RMI_PDEV_STREAM_NCOH_SYS;
+	params->pdev_1 = virt_to_phys(pf0_ep_dsc->pdev.rmm_pdev);
+	params->pdev_2 = 0; /* ignored */
+	params->ide_sid = 0; /* ignored */
+	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
+
+	ret = cca_pdev_stream_connect(pdev, NULL, params, &stream_handle);
+	if (!ret)
+		pf0_ep_dsc->stream_handle = stream_handle;
+
+	free_page((unsigned long)params);
+	return ret;
+}
+
 static int cca_pdev_create_streams(struct pci_dev *pdev, unsigned long stream_id)
 {
 	switch (pci_pcie_type(pdev)) {
 	case PCI_EXP_TYPE_ENDPOINT:
 		return cca_pdev_create_ncoh_stream(pdev, stream_id);
+	case PCI_EXP_TYPE_RC_END:
+		return cca_pdev_create_ncoh_sys_stream(pdev);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index a10ac6ff03d1..33a2551fd09f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -66,6 +66,16 @@ static int init_pdev_params(struct pci_dev *pdev, struct rmi_pdev_params *params
 		category = RMI_PDEV_FLAGS_CATEGORY_ROOT_PORT;
 		break;
 	}
+	case PCI_EXP_TYPE_RC_END: {
+		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+
+		/* Use SPDM if present */
+		if (pf0_ep_dsc->pci.doe_mb)
+			params->flags = RMI_PDEV_FLAGS_SPDM;
+
+		category = RMI_PDEV_FLAGS_CATEGORY_ON_CHIP_EP;
+		break;
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.43.0

