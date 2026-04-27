Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B80386C12;
	Mon, 27 Apr 2026 06:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272741; cv=none; b=uFUU7b9bqwGWiFp2KfW4yYqZaCUWSWXY0q4E+108GrvbEz2sLCEnLLEGE2WSG+PUXszU844pYlHDSEiBJlywlQ2drlPl2D14czL+qgChJaskqe6j8G9N+lsYzBP1ZA4zJHMB9mV2TdborCHHiS3Ltv0RGeUmHxb4Mj/9vzp5uEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272741; c=relaxed/simple;
	bh=8p8XrF54svUmqa/FbWkb2wAIIOl++3NsWo5wZGvA1c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onRV8qEv5JgnyZaDqI1s8RKlZAEIjsUgFGJRKxT0E8Y1YSvTI8LOyMcjEUa2AgZrvftQayM/hFQ00iKvWSOZLTibJb5xlkK6kRh9g3sLd1vH19OkyowoeZ/bfxMera2sRYT+eRLFuav1zdtE1inx2qqoU8HQ/Ek5xJrz40utG+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sg37gUfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sg37gUfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B232C2BCB8;
	Mon, 27 Apr 2026 06:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272741;
	bh=8p8XrF54svUmqa/FbWkb2wAIIOl++3NsWo5wZGvA1c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg37gUfhb/ZDeXMT0+OWQwVpkDHoLz2Uv7klAyb01XOEDt3MjNZa/syXzY/+U5MXK
	 hHCCxciBkznRX11dahJV4GoWClyQqAoQoknIR9IpetNxdHX1VSDHm2PqoDHEzSh5dt
	 V8p/RnYMb5mPcesmqicUCU6wpwDbt6+X2BH6u2SrA4nNcSRZCMZtvg+nUQgn5kqCAo
	 /rO8Swm6Y0NWZGvLM/zSP/Q2uM4JF1zCmrKb4arClzdIIg8NmXHLfXB3cXMmBFvPSi
	 wr/WYlYix1GbF/VNqVa561+CJXn85pY2q5rwrtD9kdF13p6xGRwr9rh17bYSzjrf5b
	 ftEXDXzzlaSpA==
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
Subject: [RFC PATCH v4 08/14] coco: host: arm64: Register device public key with RMM
Date: Mon, 27 Apr 2026 12:21:15 +0530
Message-ID: <20260427065121.916615-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

- Introduce the SMC_RMI_PDEV_SET_PUBKEY helper and the associated struct
rmi_public_key_params so the host can hand the device’s public key to
the RMM.

- Parse the certificate chain cached during SPDM session setup, extract the
final certificate’s public key, and recognise RSA-3072, ECDSA-P256, and
ECDSA-P384 keys before calling into the RMM.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h       |   9 ++
 arch/arm64/include/asm/rmi_smc.h        |  17 +++
 drivers/virt/coco/arm-cca-host/Kconfig  |   4 +
 drivers/virt/coco/arm-cca-host/rmi-da.c | 155 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |   2 +
 5 files changed, 187 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 8024e9d89e55..00e0a08e17a6 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -765,4 +765,13 @@ static inline unsigned long rmi_pdev_stop(unsigned long pdev_phys)
 	return res.a0;
 }
 
+static inline unsigned long rmi_pdev_set_pubkey(unsigned long pdev_phys, unsigned long key_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_SET_PUBKEY, pdev_phys, key_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 9056a7639667..7a5d57a8be7a 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -538,4 +538,21 @@ struct rmi_dev_comm_data {
 	};
 };
 
+#define RMI_SIG_RSASSA_3072	0
+#define RMI_SIG_ECDSA_P256	1
+#define RMI_SIG_ECDSA_P384	2
+
+struct rmi_public_key_params {
+	union {
+		struct {
+			u8 public_key[1024];
+			u8 metadata[1024];
+			u64 public_key_len;
+			u64 metadata_len;
+			u8 rmi_signature_algorithm;
+		};
+		u8 padding[0x1000];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/virt/coco/arm-cca-host/Kconfig b/drivers/virt/coco/arm-cca-host/Kconfig
index efe40d61d5d8..c5076e2b4eb5 100644
--- a/drivers/virt/coco/arm-cca-host/Kconfig
+++ b/drivers/virt/coco/arm-cca-host/Kconfig
@@ -8,7 +8,11 @@ config ARM_CCA_HOST
 	depends on PCI
 	depends on KVM
 	select PCI_TSM
+	select KEYS
+	select X509_CERTIFICATE_PARSER
 	select AUXILIARY_BUS
+	select CRYPTO_ECDSA
+	select CRYPTO_RSA
 
 	help
 	  ARM CCA RMM firmware is the trusted runtime that enforces memory
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 8a43a1f1c036..996979dba709 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -8,6 +8,9 @@
 #include <linux/pci-doe.h>
 #include <linux/delay.h>
 #include <asm/rmi_cmds.h>
+#include <crypto/internal/rsa.h>
+#include <keys/asymmetric-type.h>
+#include <keys/x509-parser.h>
 
 #include "rmi-da.h"
 
@@ -383,6 +386,158 @@ static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_s
 	return wait_for_dev_state(PDEV_COMMUNICATE, tsm, target_state, RMI_PDEV_ERROR);
 }
 
+static int __maybe_unused parse_certificate_chain(struct pci_tsm *tsm)
+{
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	unsigned int chain_size;
+	unsigned int offset = 0;
+	u8 *chain_data;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(tsm->pdev);
+
+	/* If device communication didn't results in certificate caching. */
+	if (!pf0_ep_dsc->cert_chain.cache || !pf0_ep_dsc->cert_chain.cache->offset)
+		return -EINVAL;
+
+	chain_size = pf0_ep_dsc->cert_chain.cache->offset;
+	chain_data = pf0_ep_dsc->cert_chain.cache->buf;
+
+	while (offset < chain_size) {
+		ssize_t cert_len =
+			x509_get_certificate_length(chain_data + offset,
+						    chain_size - offset);
+		if (cert_len < 0)
+			return cert_len;
+
+		struct x509_certificate *cert __free(x509_free_certificate) =
+			x509_cert_parse(chain_data + offset, cert_len);
+
+		if (IS_ERR(cert)) {
+			pci_warn(tsm->pdev, "parsing of certificate chain not successful\n");
+			return PTR_ERR(cert);
+		}
+
+		/* The key in the last cert in the chain is used */
+		if (offset + cert_len == chain_size) {
+			void *public_key __free(kfree) =
+				kzalloc(cert->pub->keylen, GFP_KERNEL);
+
+			if (!public_key)
+				return -ENOMEM;
+
+			if (!strcmp("ecdsa-nist-p256", cert->pub->pkey_algo)) {
+				pf0_ep_dsc->rmi_signature_algorithm = RMI_SIG_ECDSA_P256;
+			} else if (!strcmp("ecdsa-nist-p384", cert->pub->pkey_algo)) {
+				pf0_ep_dsc->rmi_signature_algorithm = RMI_SIG_ECDSA_P384;
+			} else if (!strcmp("rsa", cert->pub->pkey_algo)) {
+				struct rsa_key rsa_key = {0};
+				size_t skip = 0;
+				int ret;
+
+				ret = rsa_parse_pub_key(&rsa_key, cert->pub->key,
+							cert->pub->keylen);
+				if (ret)
+					return ret;
+
+				while (skip < rsa_key.n_sz && !rsa_key.n[skip])
+					skip++;
+
+				/* check we have 3072 bits len */
+				if ((rsa_key.n_sz - skip) != (3072 >> 3))
+					return -EINVAL;
+
+				pf0_ep_dsc->rmi_signature_algorithm = RMI_SIG_RSASSA_3072;
+			} else {
+				return -EINVAL;
+			}
+
+			memcpy(public_key, cert->pub->key, cert->pub->keylen);
+			pf0_ep_dsc->cert_chain.public_key = no_free_ptr(public_key);
+			pf0_ep_dsc->cert_chain.public_key_size = cert->pub->keylen;
+			pf0_ep_dsc->cert_chain.valid = true;
+			return 0;
+		}
+
+		offset += cert_len;
+	}
+
+	/* something wrong with chain size and parsing. */
+	return -EINVAL;
+}
+
+static inline void key_param_free(struct rmi_public_key_params *param)
+{
+	return free_page((unsigned long)param);
+}
+
+static inline int copy_key_part(u8 *buf, const u8 *key_buf, size_t sz)
+{
+	int skip;
+
+	/* skip leading zero in asn.1 */
+	for (skip = 0; skip < sz; skip++)
+		if (key_buf[skip])
+			break;
+
+	memcpy(buf, key_buf + skip, sz - skip);
+	return sz - skip;
+}
+
+DEFINE_FREE(key_param_free, struct rmi_public_key_params *, if (_T) key_param_free(_T))
+static int __maybe_unused pdev_set_public_key(struct pci_tsm *tsm)
+{
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(tsm->pdev);
+	/* Check that all the necessary information was captured from communication */
+	if (!pf0_ep_dsc->cert_chain.valid)
+		return -EINVAL;
+
+	struct rmi_public_key_params *key_params __free(key_param_free) =
+		(struct rmi_public_key_params *)get_zeroed_page(GFP_KERNEL);
+	if (!key_params)
+		return -ENOMEM;
+
+	key_params->rmi_signature_algorithm = pf0_ep_dsc->rmi_signature_algorithm;
+
+	switch (key_params->rmi_signature_algorithm) {
+	case RMI_SIG_ECDSA_P384:
+	case RMI_SIG_ECDSA_P256:
+	{
+		key_params->public_key_len = pf0_ep_dsc->cert_chain.public_key_size;
+		memcpy(key_params->public_key,
+		       pf0_ep_dsc->cert_chain.public_key,
+		       pf0_ep_dsc->cert_chain.public_key_size);
+		key_params->metadata_len = 0;
+		break;
+	}
+	case RMI_SIG_RSASSA_3072:
+	{
+		int ret;
+		struct rsa_key rsa_key = {0};
+
+		ret = rsa_parse_pub_key(&rsa_key,
+					pf0_ep_dsc->cert_chain.public_key,
+					pf0_ep_dsc->cert_chain.public_key_size);
+		if (ret)
+			return ret;
+
+		key_params->public_key_len = copy_key_part(key_params->public_key,
+							   rsa_key.n, rsa_key.n_sz);
+		key_params->metadata_len = copy_key_part(key_params->metadata,
+							 rsa_key.e, rsa_key.e_sz);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	if (rmi_pdev_set_pubkey(virt_to_phys(pf0_ep_dsc->pdev.rmm_pdev),
+				virt_to_phys(key_params)))
+		return -ENXIO;
+	return 0;
+}
+
 static void pdev_state_transition_workfn(struct work_struct *work)
 {
 	unsigned long state;
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 784eb1fff95d..7d38e548b659 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -59,6 +59,7 @@ struct cca_host_pdev_dsc {
  * @pci: Physical Function 0 TDISP link context
  * @pdev: pdev communication context
  * @sel_stream: Selective IDE Stream descriptor
+ * @rmi_signature_algorithm: Signature algorithm used for public key
  * @cert_chain: cetrificate chain
  * @vca: SPDM's Version-Capabilities-Algorithms cache object
  */
@@ -67,6 +68,7 @@ struct cca_host_pf0_ep_dsc {
 	struct cca_host_pdev_dsc pdev;
 	struct pci_ide *sel_stream;
 
+	uint8_t rmi_signature_algorithm;
 	struct {
 		struct cache_object *cache;
 
-- 
2.43.0

