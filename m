Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AD24A8A17;
	Thu, 10 Sep 2026 14:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049223; cv=none; b=lpqrjm/hdyRIgtAO+ZhaYWKYQwbkUNQZhA6nfC6fljMztemhrLJuQzeQV8ziHGE0ZPLPJZ6iq6AORK7HxCkLntJDTpIH6i6u9elwcWdZR1qjnc1nSPhsFTSmeiRZqrsG4KKB1Yn5pObuqpxYWcxwdXpdyYtQzSxxCgAeugDoFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049223; c=relaxed/simple;
	bh=kko8o+2yLViA7AjY6vne36W8QZaUMTzZtOffEn/gjKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZHuiOvTOtTbyCP9bsVweuiE1ja+TTljT9kMTvZaTNBfjPXdFVOkriJmSQGcw3mUlWG9elUyQRfhPUR6bMQV1fWdxBTCwocXC4Y61roMYU48qbI0eyBeFBqXd7s7q8xYGc0otpooc5572LViOiNkn6/v8Ghd1+Q63JtI90RCchw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyQiX9GX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyQiX9GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A321F0089B;
	Thu, 10 Sep 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049222;
	bh=7scpEVVr4UU62YzdzYFb4j0SlzJSeqGX0ORVVeED+nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyQiX9GXEjjt2r/KKPAuTr18MSFEFjkQhuO1GnsboRPFfeyD6Vfrcj5zGP342Hpcn
	 Vb9DMA+iGTmteG3jFNDRH2l/EJlnb7w9Hy/yttWSz9uzW2rwPVtknfqtBuvjfzjJKP
	 TNOQA8tqDfddmWhmP4g/rp93U+cZpQ5I6LckzJmB++30zG2B4KZ6GqF0CUvwzPkSR3
	 r4vyeDVLTiiq+iRX9RlWZoX2dn2GsyXC8q0dYKBf0I5fGH31YVxakjb3JI+J0BYMqm
	 VdRhoA7nstQFRxjZ+/ttRSpn38JZw6zYnRzRL0yy7yvADDdiXxnXdSCcZ0ffScjXnz
	 u95B0wYR8BwYw==
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
Subject: [PATCH v5 15/15] coco: host: arm64: Enable PCI TSM connect callbacks
Date: Thu, 10 Sep 2026 19:35:08 +0530
Message-ID: <20260910140509.868402-16-aneesh.kumar@kernel.org>
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

The previous patches build up the Arm CCA host device-assignment flow: RMM
pdev creation and teardown, device communication, public-key setup, peer
stream coordination, RMM stream connect/disconnect, and support for both
endpoint and RC endpoint stream types.

Now that the connect and disconnect paths contain the complete setup and
teardown sequence, register them in pci_tsm_ops and drop the __maybe_unused
annotations.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index b7b0cc0a016c..e8afd54c23f6 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -295,7 +295,7 @@ static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
 	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
 }
 
-static int __maybe_unused cca_tsm_connect(struct pci_dev *pdev)
+static int cca_tsm_connect(struct pci_dev *pdev)
 {
 	struct pci_dev *rp = pcie_find_root_port(pdev);
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
@@ -385,7 +385,7 @@ static int __maybe_unused cca_tsm_connect(struct pci_dev *pdev)
 	return ret;
 }
 
-static void __maybe_unused cca_tsm_disconnect(struct pci_dev *pdev)
+static void cca_tsm_disconnect(struct pci_dev *pdev)
 {
 	struct pci_ide *ide;
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
@@ -414,6 +414,8 @@ static void __maybe_unused cca_tsm_disconnect(struct pci_dev *pdev)
 static struct pci_tsm_ops cca_link_pci_ops = {
 	.probe = cca_tsm_pci_probe,
 	.remove = cca_tsm_pci_remove,
+	.connect = cca_tsm_connect,
+	.disconnect = cca_tsm_disconnect,
 };
 
 static void cca_link_tsm_remove(void *tsm_dev)
-- 
2.43.0

