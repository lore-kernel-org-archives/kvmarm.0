Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A349C4DE;
	Thu, 10 Sep 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049177; cv=none; b=dFM9Ut7nZRtTfILFWFk0GhDrfE3NyPm3o6cDbBmx2HcRuDsZCng7UXg6g22Om/r3thhR1iPSLVtIErbQfSacS1X4n5yYdnVrLdIBo68ugUEqhLRUtkP0btV6q0zqGWGZjSbdqCMAOd/F9KgWhTwzlEi2cdO2JUJqQh2M3ajabKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049177; c=relaxed/simple;
	bh=MMAtey+9IMba7dZkmuYNGjCD59kI8+2TWL769qvRkcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GXPHL3s3oGBBIqwD/lbwl0wSibCvvCD61tEn4YsGMrUXY+rN3cI2DsGZJxg3Uh/tHgidoPqP8/2amexRKUOpAfI+FY0fTNET+OQXIcEhWkSRhbgBxExHClc+Is1U/VU/oCS358dh6Mrz+uH0Mc5vjF5FOSNEW+tVf95R4/TDFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTsc+wSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTsc+wSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D361F000FF;
	Thu, 10 Sep 2026 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049175;
	bh=CB6ghbgDfVwHgjqO9k99YiMcwetqo8QudA9rXLeQUJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTsc+wSRMF2u/wDOvehp/0qBJt2b6pliIpB8D0gu6ByMP1AzSUdEGLw5HWf1KnB9g
	 46Sj9Lo7ZwCUzaCiIh8Zj8qGO7o+uAAzdZKISao/KO8Knla8Y1V05ehrDquUYMx9rS
	 sFPZoxPvnSglk5FTTgo+T4whprCq9pyZjIjFMOZsZVSQgnfJTjLqK5rx82+3TEHagT
	 5U08vrubQAvdJDlxQ7Wi92o34oPdA+PePTbnmJ+Q3gZNAzrrF3yrlxIIumelh0DtU+
	 4FfF3e78Iez2KQlGEzqg0eg+bzV1Tv7OOlrCzGI7AItzHbJphftQKNvZyfOW519LB8
	 1wLMQty+M4MlQ==
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
Subject: [PATCH v5 08/15] coco: host: arm64: Register device public key with RMM
Date: Thu, 10 Sep 2026 19:35:01 +0530
Message-ID: <20260910140509.868402-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910140509.868402-1-aneesh.kumar@kernel.org>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
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
 drivers/virt/coco/arm-cca-host/Kconfig  |   7 ++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 152 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |   2 +
 include/linux/arm-rmi-cmds.h            |   9 ++
 include/linux/arm-smccc-rmi.h           |  18 +++
 5 files changed, 188 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/Kconfig b/drivers/virt/coco/arm-cca-host/Kconfig
index d2bf44f9776a..43f0f0228e0c 100644
--- a/drivers/virt/coco/arm-cca-host/Kconfig
+++ b/drivers/virt/coco/arm-cca-host/Kconfig
@@ -9,6 +9,13 @@ config ARM_CCA_HOST
 	depends on ARM_RMM_RMI
 	depends on HAVE_ARM_SMCCC_DISCOVERY
 	select PCI_TSM
+	select KEYS
+	select ASYMMETRIC_KEY_TYPE
+	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select CRYPTO
+	select X509_CERTIFICATE_PARSER
+	select CRYPTO_ECDSA
+	select CRYPTO_RSA
 
 	help
 	  ARM CCA RMM firmware is the trusted runtime that enforces memory
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 7a72e8eead90..394b6a87f2d3 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -8,6 +8,9 @@
 #include <linux/pci-ecam.h>
 #include <linux/pci-doe.h>
 #include <linux/delay.h>
+#include <crypto/internal/rsa.h>
+#include <keys/asymmetric-type.h>
+#include <keys/x509-parser.h>
 
 #include "rmi-da.h"
 
@@ -378,6 +381,154 @@ static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_s
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
+			char *signature_algorithm __free(kfree) = NULL;
+			void *public_key __free(kfree) =
+				kzalloc(cert->pub->keylen, GFP_KERNEL);
+
+			if (!public_key)
+				return -ENOMEM;
+
+			if (!strcmp("rsa", cert->pub->pkey_algo)) {
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
+			} else if (strcmp("ecdsa-nist-p256", cert->pub->pkey_algo) &&
+				   strcmp("ecdsa-nist-p384", cert->pub->pkey_algo)) {
+				return -EINVAL;
+			}
+
+			signature_algorithm = kstrdup(cert->pub->pkey_algo, GFP_KERNEL);
+			if (!signature_algorithm)
+				return -ENOMEM;
+
+			memcpy(public_key, cert->pub->key, cert->pub->keylen);
+			pf0_ep_dsc->rmi_signature_algorithm =
+				no_free_ptr(signature_algorithm);
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
+	u8 *key __free(free_page) = (u8 *)get_zeroed_page(GFP_KERNEL);
+	u8 *metadata __free(free_page) = (u8 *)get_zeroed_page(GFP_KERNEL);
+	struct rmi_public_key_params *key_params __free(key_param_free) =
+		(struct rmi_public_key_params *)get_zeroed_page(GFP_KERNEL);
+	if (!key_params || !key || !metadata)
+		return -ENOMEM;
+
+	if (!strcmp("ecdsa-nist-p384", pf0_ep_dsc->rmi_signature_algorithm) ||
+	    !strcmp("ecdsa-nist-p256", pf0_ep_dsc->rmi_signature_algorithm)) {
+		key_params->key_len = pf0_ep_dsc->cert_chain.public_key_size;
+		memcpy(key, pf0_ep_dsc->cert_chain.public_key,
+		       pf0_ep_dsc->cert_chain.public_key_size);
+		key_params->metadata_len = 0;
+	} else if (!strcmp("rsa", pf0_ep_dsc->rmi_signature_algorithm)) {
+		int ret;
+		struct rsa_key rsa_key = {0};
+
+		ret = rsa_parse_pub_key(&rsa_key,
+					pf0_ep_dsc->cert_chain.public_key,
+					pf0_ep_dsc->cert_chain.public_key_size);
+		if (ret)
+			return ret;
+
+		key_params->key_len = copy_key_part(key, rsa_key.n, rsa_key.n_sz);
+		key_params->metadata_len = copy_key_part(metadata,
+							 rsa_key.e, rsa_key.e_sz);
+	} else {
+		return -EINVAL;
+	}
+
+	key_params->key_addr = virt_to_phys(key);
+	key_params->metadata_addr = virt_to_phys(metadata);
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
@@ -454,6 +605,7 @@ void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
 		return;
 
 	if (pf0_ep_dsc) {
+		kfree(pf0_ep_dsc->rmi_signature_algorithm);
 		kfree(pf0_ep_dsc->cert_chain.public_key);
 		kvfree(pf0_ep_dsc->cert_chain.cache);
 		kvfree(pf0_ep_dsc->vca);
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index f3bd106c8a54..92bcd9571cb8 100644
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
 
+	char *rmi_signature_algorithm;
 	struct {
 		struct cache_object *cache;
 
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index f947b2f4909a..1f1dc771a8ff 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -715,4 +715,13 @@ static inline unsigned long rmi_pdev_stop(unsigned long pdev_phys)
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
 #endif
diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
index 3133b34354ce..fdc830379060 100644
--- a/include/linux/arm-smccc-rmi.h
+++ b/include/linux/arm-smccc-rmi.h
@@ -596,4 +596,22 @@ struct rmi_dev_comm_data {
 	};
 };
 
+struct rmi_public_key_params {
+	union {
+		struct {
+			union { /* 0x0 */
+				u64 key_addr;
+				u8 padding0[0x400];
+			};
+			union { /* 0x400 */
+				u64 metadata_addr;
+				u8 padding1[0x400];
+			};
+			u64 key_len;
+			u64 metadata_len;
+		};
+		u8 padding[0x1000];
+	};
+};
+
 #endif /* __LINUX_ARM_SMCCC_RMI_H_ */
-- 
2.43.0

