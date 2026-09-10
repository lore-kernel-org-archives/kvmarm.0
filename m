Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35214A3F3A;
	Thu, 10 Sep 2026 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049216; cv=none; b=dFnvsoulJpXqtAnpS8ppCYHI04QWoy/rS/7PgiQOOsBw7vwq9scDMtua53S0BtZFYEcqvC5ebegrTQNaZz1Gv20o8/q8hPdYXoYK6wR4Wgg4VTbzkyaGHh7zreQD5utvKAir8OBDK3kEFDLaFky6MUry3h0swjw4gF31N3BNl3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049216; c=relaxed/simple;
	bh=c5lfmiCJYlY+UhANXT9srmqmEWUJIiCKECCxpceAQII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgdqUnfNE5TSjppgS/zyBYpDgMCrw2Z9zdMyVg1SMUvmvyryxFncAuwN/0bblHG/Zvxc+tmtEZeWOEUqqxikz6NubOt4g6iDkqYpNUmT2Fkjljqckr/eTo0V2E3TgpGHSloyCddb0JQmRtUoVlVIdj2NAgqnPMlOpcpDMPfRwwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g16gXhhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g16gXhhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039471F00898;
	Thu, 10 Sep 2026 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049214;
	bh=HfACVSTqqZWVHHMsfW9j7D8zjVuyoIFAMlGVkuERVwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g16gXhhxkVq5S5oxzfWsaWCw3urd025JZW1sxsu9eBUu1CdJDqpISr68hktAo/CHr
	 2F2O/QCunWoL+37JccgSRDvuhWzbmLGW4J0X2PhPFNGRVwApRS5XmPH5Lf0Ylg4PPa
	 YbhNeDsiLtUHHK83QQtbLdaJ3I9v5IhzjCI5tAM3J049vv7Atw+WEUIhjtbQvwAAf4
	 dDzmBw1Y1FPRD6I1J8/MaZjYuBAMNfvOZl1N2XddNvNnW4w4BWdXCZSt6NfMABdXqd
	 KBVRcFCrHkdq0LMLI22NTuK2daML6fj7B3HFs5psQJtkawQQmgXk/MYUp4/fhuY4nP
	 mtTkAoj8KrYTA==
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
Subject: [PATCH v5 14/15] coco: host: arm64: Add NCOH_SYS stream support for RC endpoints
Date: Thu, 10 Sep 2026 19:35:07 +0530
Message-ID: <20260910140509.868402-15-aneesh.kumar@kernel.org>
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
 drivers/virt/coco/arm-cca-host/main.c   | 28 +++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 10 +++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index 70cbff181561..b7b0cc0a016c 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -252,11 +252,39 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
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
+	params->stream_type = RMI_PDEV_STREAM_NCOH_SYS;
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
index fcca9f73b5fb..794385f818ce 100644
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

