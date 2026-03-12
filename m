Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A91C2E88BB;
	Thu, 12 Mar 2026 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302555; cv=none; b=a0sl3b6e4c7Sd32xNBAu/KQms+8G7GORLNy1Yo1x3D1d2dDqT9aQOp1kENlzqQk6HUNnHfenlSwrOfx9FrfnHDRzw4n4q8FRsKgXRVEt7ZdbO3uJ9S8GbKaBPzQ4etN5AU/I+ee3gPcaP94n/DMuEDR64JAhDXuDFeWp+kEuqhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302555; c=relaxed/simple;
	bh=za/IJI/M4boNse0krvOPCedzdOn+suKa0F46ZZO+gZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifIY+5mSjiVsQowLtwkVe23vUWJRxgrDy+biPv6j9YOYttLsYNtTL7yV2qkmOjAiHjlCElgKpg9rOU6Lpwu+7i1NL28lNtW2ZtARkPq+TsRpTVVf/lsvkQ0zH32xlA4gtXvnuz8ZneEGFYwRyc7xYwXomr/buITdqbbuXHDF2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RI+nA7uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RI+nA7uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E6C2BCB0;
	Thu, 12 Mar 2026 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302555;
	bh=za/IJI/M4boNse0krvOPCedzdOn+suKa0F46ZZO+gZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI+nA7ukMybNnkm3lH6oVEgqiYcpyFBnzTFL2NOQgUdbOm74tb7wEhZUC/D/XXy4r
	 +4cOwBl14c/GXbc4AtgSZpsLAhoEMvkVKLvlFz9ROvUyWhAaSnUhdhHQXcYjq7M78W
	 Av0vAr7sM9UvyMb9lFS79sYWoDMUd6NLqRoa+YyjVuf+jMmVGR1ojevgW5QXjSRNrG
	 CbbiQOggMSfgBdEaMxXQq6/uPscz4Ad8mxTS/+5+dYVemLKkDPhXZdq7WIcYXPYw4D
	 dblKI6MXASVTOqJvhlmyOwyP2MQkwDstJZm4wvBSzxNHs3Oqf7H76ozgOHcPIrafMr
	 u0jbUW/HX0chw==
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
Subject: [RFC PATCH v3 06/10] coco: host: arm64: Instantiate RMM pdev during device connect
Date: Thu, 12 Mar 2026 13:31:25 +0530
Message-ID: <20260312080129.3483585-7-aneesh.kumar@kernel.org>
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

An RMM pdev object represents a communication channel between the RMM
and a physical device, for example a PCIe device. With the required
helpers now in place, update the connect callback to create an RMM pdev
object.

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
 drivers/virt/coco/arm-cca-host/arm-cca.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 4ed5e8ec9e91..987c1be566ba 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -67,8 +67,8 @@ static void cca_tsm_pci_remove(struct pci_tsm *tsm)
 	}
 }
 
-static __maybe_unused int init_dev_communication_buffers(struct pci_dev *pdev,
-							 struct cca_host_comm_data *comm_data)
+static int init_dev_communication_buffers(struct pci_dev *pdev,
+					  struct cca_host_comm_data *comm_data)
 {
 	int ret = -ENOMEM;
 
@@ -172,6 +172,16 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 	if (rc)
 		goto err_tsm;
 
+	rc = init_dev_communication_buffers(pdev, &pf0_dsc->comm_data);
+	if (rc)
+		goto err_comm_buff;
+	rc = cca_pdev_create(pdev);
+	if (rc)
+		goto err_pdev_create;
+
+	rc = cca_pdev_ide_setup(pdev);
+	if (rc)
+		goto err_ide_setup;
 	/*
 	 * Once ide is setup, enable the stream at the endpoint
 	 * Root port will be done by RMM
@@ -179,6 +189,12 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 	pci_ide_stream_enable(pdev, ide);
 	return 0;
 
+err_ide_setup:
+	cca_pdev_stop_and_destroy(pdev);
+err_pdev_create:
+	free_dev_communication_buffers(&pf0_dsc->comm_data);
+err_comm_buff:
+	tsm_ide_stream_unregister(ide);
 err_tsm:
 	pci_ide_stream_teardown(rp, ide);
 	pci_ide_stream_teardown(pdev, ide);
@@ -205,6 +221,9 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 	ide = pf0_dsc->sel_stream;
 	stream_id = ide->stream_id;
 
+	cca_pdev_stop_and_destroy(pdev);
+	free_dev_communication_buffers(&pf0_dsc->comm_data);
+
 	pci_ide_stream_release(ide);
 	pf0_dsc->sel_stream = NULL;
 	clear_bit(stream_id, cca_stream_ids);
-- 
2.43.0

