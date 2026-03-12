Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DF82F6911;
	Thu, 12 Mar 2026 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302577; cv=none; b=o6L4PSlxml4qTLZiWarTxyIhhFNJ58twU4O+KTDc5KVQzi9FuG8P5AdWM0JjN0Ctmj9xoGPLO+l/uK6eJ9tcdy0Qi6+bBkaVxuc9IFR2TvLpZjG18E6NJmHu1PRzuL3Gt2d1x6smxX5u7zX4Oc1+dnk8TnfvzxCnoR2D4mesmUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302577; c=relaxed/simple;
	bh=VUOalaLBOiIjNU7HAVFo9dX7mrBFsxxsTy0R3pqsmiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INw8qYrAE2PSlA4uyg5VL938LoOJmupwl+GSW2Zt//N00BFYz9plrjdHWhmjx5BsxCwcl+4JqdqCOBlE54b9hSGDqjdfjQeY3fBQ1blgUOWYR0NW7+vAjcLGLmPLZWXfcB7pa0hkJuSeNqmjrqUVSsax1DwNaCMRhRtXnZGiS1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8yyNa4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8yyNa4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0403C116C6;
	Thu, 12 Mar 2026 08:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302576;
	bh=VUOalaLBOiIjNU7HAVFo9dX7mrBFsxxsTy0R3pqsmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8yyNa4VyLTf0tyCFwWp0S3qHwqgkTAfm0cRv9O1syDi+2BWEl29J9apIZpUqM0+5
	 ow9zb4swvsbprvRm/6ho2KsDLbsWQX2+DCN3dUgjIntvDOO+5jmrJVqFTexgwqYi2A
	 F+BTW+NWJu0gRno013nGvUk1Mp6pgxYMPNiJBQqmPEfG/Bd4nChFPz9qeXjDE0syIv
	 se6ksweIXnnulu8JqHhSkO6AK9jAluigEWpFUbXe93E3U59e5l57Pq6cq6NMSAA4wK
	 G9U361IcRaWarYkkcSV8KxCFUcuPDTZ+5Th2cDX8Z+UW95Qq8UrArqeAHbcO6H4o+A
	 4jAGYHtoNWDrg==
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
Subject: [RFC PATCH v3 10/10] coco: host: arm64: Register device public key with RMM
Date: Thu, 12 Mar 2026 13:31:29 +0530
Message-ID: <20260312080129.3483585-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
References: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
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

- Parse the certificate chain cached during IDE setup, extract the final
certificate’s public key, and recognise RSA-3072, ECDSA-P256, and
ECDSA-P384 keys before calling into the RMM.

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
 arch/arm64/include/asm/rmi_cmds.h       |   9 ++
 arch/arm64/include/asm/rmi_smc.h        |  18 +++
 drivers/virt/coco/arm-cca-host/Kconfig  |   4 +
 drivers/virt/coco/arm-cca-host/rmi-da.c | 174 +++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h |   2 +
 5 files changed, 206 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index f10a0dcaa308..339bea517760 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -574,4 +574,13 @@ static inline unsigned long rmi_pdev_destroy(unsigned long pdev_phys)
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
index 3a57c7245029..907e00f4855a 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -52,6 +52,7 @@
 #define SMC_RMI_PDEV_CREATE             SMC_RMI_CALL(0x0176)
 #define SMC_RMI_PDEV_DESTROY		SMC_RMI_CALL(0x0177)
 #define SMC_RMI_PDEV_GET_STATE		SMC_RMI_CALL(0x0178)
+#define SMC_RMI_PDEV_SET_PUBKEY		SMC_RMI_CALL(0x017b)
 #define SMC_RMI_PDEV_STOP		SMC_RMI_CALL(0x017c)
 
 #define RMI_ABI_MAJOR_VERSION	1
@@ -427,4 +428,21 @@ struct rmi_dev_comm_data {
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
+		} __packed;
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
index ba6d67e5f54e..029758ada136 100644
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
 
@@ -386,6 +389,158 @@ static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_s
 	return wait_for_dev_state(PDEV_COMMUNICATE, tsm, target_state, RMI_PDEV_ERROR);
 }
 
+static int parse_certificate_chain(struct pci_tsm *tsm)
+{
+	struct cca_host_pf0_dsc *pf0_dsc;
+	unsigned int chain_size;
+	unsigned int offset = 0;
+	u8 *chain_data;
+
+	pf0_dsc = to_cca_pf0_dsc(tsm->pdev);
+
+	/* If device communication didn't results in certificate caching. */
+	if (!pf0_dsc->cert_chain.cache || !pf0_dsc->cert_chain.cache->offset)
+		return -EINVAL;
+
+	chain_size = pf0_dsc->cert_chain.cache->offset;
+	chain_data = pf0_dsc->cert_chain.cache->buf;
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
+				pf0_dsc->rmi_signature_algorithm = RMI_SIG_ECDSA_P256;
+			} else if (!strcmp("ecdsa-nist-p384", cert->pub->pkey_algo)) {
+				pf0_dsc->rmi_signature_algorithm = RMI_SIG_ECDSA_P384;
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
+				pf0_dsc->rmi_signature_algorithm = RMI_SIG_RSASSA_3072;
+			} else {
+				return -EINVAL;
+			}
+
+			memcpy(public_key, cert->pub->key, cert->pub->keylen);
+			pf0_dsc->cert_chain.public_key = no_free_ptr(public_key);
+			pf0_dsc->cert_chain.public_key_size = cert->pub->keylen;
+			pf0_dsc->cert_chain.valid = true;
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
+static int pdev_set_public_key(struct pci_tsm *tsm)
+{
+	struct cca_host_pf0_dsc *pf0_dsc;
+
+	pf0_dsc = to_cca_pf0_dsc(tsm->pdev);
+	/* Check that all the necessary information was captured from communication */
+	if (!pf0_dsc->cert_chain.valid)
+		return -EINVAL;
+
+	struct rmi_public_key_params *key_params __free(key_param_free) =
+		(struct rmi_public_key_params *)get_zeroed_page(GFP_KERNEL);
+	if (!key_params)
+		return -ENOMEM;
+
+	key_params->rmi_signature_algorithm = pf0_dsc->rmi_signature_algorithm;
+
+	switch (key_params->rmi_signature_algorithm) {
+	case RMI_SIG_ECDSA_P384:
+	case RMI_SIG_ECDSA_P256:
+	{
+		key_params->public_key_len = pf0_dsc->cert_chain.public_key_size;
+		memcpy(key_params->public_key,
+		       pf0_dsc->cert_chain.public_key,
+		       pf0_dsc->cert_chain.public_key_size);
+		key_params->metadata_len = 0;
+		break;
+	}
+	case RMI_SIG_RSASSA_3072:
+	{
+		int ret;
+		struct rsa_key rsa_key = {0};
+
+		ret = rsa_parse_pub_key(&rsa_key,
+					pf0_dsc->cert_chain.public_key,
+					pf0_dsc->cert_chain.public_key_size);
+		if (ret)
+			return ret;
+
+		key_params->public_key_len = copy_key_part(key_params->public_key,
+							   rsa_key.n, rsa_key.n_sz);
+		key_params->metadata_len = copy_key_part(key_params->metadata,
+							   rsa_key.e, rsa_key.e_sz);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	if (rmi_pdev_set_pubkey(virt_to_phys(pf0_dsc->rmm_pdev),
+				virt_to_phys(key_params)))
+		return -ENXIO;
+	return 0;
+}
+
 static void pdev_state_transition_workfn(struct work_struct *work)
 {
 	unsigned long state;
@@ -433,7 +588,24 @@ static int submit_pdev_state_transition_work(struct pci_dev *pdev, int target_st
 
 int cca_pdev_ide_setup(struct pci_dev *pdev)
 {
-	return submit_pdev_state_transition_work(pdev, RMI_PDEV_NEEDS_KEY);
+	int ret;
+
+	ret = submit_pdev_state_transition_work(pdev, RMI_PDEV_NEEDS_KEY);
+	if (ret)
+		return ret;
+	/*
+	 * we now have certificate chain in dsm->cert_chain. Parse that and set
+	 * the pubkey.
+	 */
+	ret = parse_certificate_chain(pdev->tsm);
+	if (ret)
+		return ret;
+
+	ret = pdev_set_public_key(pdev->tsm);
+	if (ret)
+		return ret;
+
+	return submit_pdev_state_transition_work(pdev, RMI_PDEV_READY);
 }
 
 void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index fbfbcd40beb4..38550103c2a5 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -49,6 +49,7 @@ struct cca_host_comm_data {
  * @rmm_pdev: Delegated granule address of rmm pdev object
  * @num_ax: Number of auxiliary granules allocated for pdev
  * @aux: Delegated auxiliary granules
+ * @rmi_signature_algorithm: Signature algorithm used for public key
  * @object_lock: lock used to protect access to cached obects in PF0 and TDIs
  * @cert_chain: cetrificate chain
  * @vca: SPDM's Version-Capabilities-Algorithms cache object
@@ -62,6 +63,7 @@ struct cca_host_pf0_dsc {
 	int num_aux;
 	void *aux[MAX_PDEV_AUX_GRANULES];
 
+	uint8_t rmi_signature_algorithm;
 	struct mutex object_lock;
 	struct {
 		struct cache_object *cache;
-- 
2.43.0

