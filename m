Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61B547FAF7;
	Wed, 19 Aug 2026 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157808; cv=none; b=A30rWK2otLnreTNWdk4VwWLG9nXJxDwSF3itmD3Qx6q/oYcd2ED4OiyA7FJ8Lk9s2a0tavaDA6KBHS/Vd/Qqpp2AliyzDLQapBUogYUog8uHsjsfKNQcuUxYZ2CWr7Y8qtkx4P1Gh8Cq9hK1cjdfg76Soe5v2U2UHA+C7cVTyDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157808; c=relaxed/simple;
	bh=VIUkQ94exd0fsWVgtOu9X04fu5O1175raidrFn8JdNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDqfqFM6wPT6AWDX01PV04RIK1822HMU4EJkVsagkun1Lp7wcQjcxRFW3wNi001wVmQba2tXQ9+Nny0jDN31u7zzTVdKiGGTLSdVHlQPWKCfST1P2oKSZ+knjrScsJEBRXBotLJgl+NCsJAwbr4usX98WhTzQvQD9lybFTSn4OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Eoz4XMRI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Eoz4XMRI"
Received: from [10.4.158.9] (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id E7E1720B710C;
	Wed, 19 Aug 2026 09:42:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E7E1720B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787157777;
	bh=OW0dqZF0Tw87jJhKLPZdRY2tzBT8TsRQxLqTUZn7Xtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Eoz4XMRIHs7rLC1x7d8ewg4RH390Io5QlMETXcWXvchGO9JdwcoSTBPnzmBPIkvPo
	 1nIMJsgVXKomXL1an6beMl1EH5GvA2non1SBLBrDDvY4Dc4XnSnFoXNFQ+r0zm5+Sm
	 pEt64EsHYknG0F1zGXisSSqxM7GkeObl3ZRDa77Q=
Message-ID: <da92b216-e4ee-4392-9a35-de7bc1683f83@linux.microsoft.com>
Date: Wed, 19 Aug 2026 09:43:21 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 08/11] coco: guest: arm64: Verify DA evidence with
 RSI_VDEV_GET_INFO digests
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jic23@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Samuel Ortiz <sameo@rivosinc.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-9-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Kameron Carr <kameroncarr@linux.microsoft.com>
In-Reply-To: <20260427082805.931832-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/2026 1:28 AM, Aneesh Kumar K.V (Arm) wrote:
> Add guest-side evidence verification based on RSI_VDEV_GET_INFO and use the
> verified TDISP interface report to validate Realm MMIO mappings.
> 
> During lock:
> - refresh host caches from device
> - read certificate/VCA/interface-report/measurement objects from host cache
> - fetch trusted digest metadata from RSI_VDEV_GET_INFO
> - verify host-provided objects against RSI digests
> - initialize and populate PCI TSM evidence objects
> - preserve lock/meas/report nonces and digests in guest state
> 
> Add mapping helpers to walk MMIO entries from the TDISP report and perform
> RSI_VDEV_VALIDATE_MAPPING on map, or RIPAS destroy on unmap. Reject malformed
> range progress while validating.
> 
> During unlock:
> - invalidate mappings derived from the evidence report
> - unlock the device and tear down MMIO bookkeeping
> 
> This ensures host-cached DA objects are cryptographically verified before
> being trusted for mapping and attestation state transitions.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/rsi_cmds.h         |  40 +++
>  arch/arm64/include/asm/rsi_smc.h          |  60 +++++
>  drivers/virt/coco/arm-cca-guest/Kconfig   |   2 +
>  drivers/virt/coco/arm-cca-guest/arm-cca.c | 287 +++++++++++++++++++++-
>  drivers/virt/coco/arm-cca-guest/rsi-da.c  | 145 +++++++++++
>  drivers/virt/coco/arm-cca-guest/rsi-da.h  |  22 ++
>  6 files changed, 545 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index 596bdc356f1a..f72d8e0cd422 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -186,4 +186,44 @@ static inline unsigned long rsi_features(unsigned long index, u64 *out)
>  	return res.a0;
>  }
>  
> +static inline long
> +rsi_vdev_validate_mapping(unsigned long vdev_id,
> +			  phys_addr_t ipa_base, phys_addr_t ipa_top,
> +			  phys_addr_t pa_base, phys_addr_t *next_ipa,
> +			  unsigned long flags, unsigned long lock_nonce,
> +			  unsigned long meas_nonce, unsigned long report_nonce)
> +{
> +	struct arm_smccc_1_2_regs res;
> +	struct arm_smccc_1_2_regs regs = {
> +		.a0 = SMC_RSI_VDEV_VALIDATE_MAPPING,
> +		.a1 = vdev_id,
> +		.a2 = ipa_base,
> +		.a3 = ipa_top,
> +		.a4 = pa_base,
> +		.a5 = flags,
> +		.a6 = lock_nonce,
> +		.a7 = meas_nonce,
> +		.a8 = report_nonce,
> +	};
> +
> +	arm_smccc_1_2_invoke(&regs, &res);
> +	*next_ipa = res.a1;
> +
> +	if (res.a2 != RSI_ACCEPT)
> +		return -EPERM;
> +
> +	return res.a0;
> +}
> +
> +static inline unsigned long rsi_vdev_get_info(unsigned long vdev_id,
> +					      unsigned long digest_phys)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_VDEV_GET_INFO,
> +			     vdev_id, digest_phys, &res);
> +
> +	return res.a0;
> +}
> +
>  #endif /* __ASM_RSI_CMDS_H */
> diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
> index 4af4638fdd49..99b34b37b693 100644
> --- a/arch/arm64/include/asm/rsi_smc.h
> +++ b/arch/arm64/include/asm/rsi_smc.h
> @@ -125,6 +125,9 @@
>  
>  #ifndef __ASSEMBLER__
>  
> +#define RSI_HASH_SHA_256 0
> +#define RSI_HASH_SHA_512 1
> +
>  struct realm_config {
>  	union {
>  		struct {
> @@ -183,6 +186,63 @@ struct realm_config {
>   */
>  #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
>  
> +#define RSI_VDEV_REPORT_FORMAT_TDISP 0x1

You define this but never verify the format_type.

> +struct rsi_vdevice_info {
> +	union {
> +		struct {
> +			u64 flags;
> +			u64 id_index;
> +			union {
> +				u8 hash_algo;
> +				u64 padding0;
> +			};
> +			u64 lock_nonce;
> +			u64 meas_nonce;
> +			u64 report_nonce;

Nit:
I found the name `lock_nonce` confusing. I originally assumed this was the
nonce passed in when calling RHI_DA_VDEV_GET_MEASUREMENTS. The new RSI spec
(2.0 beta 3) names these lock_seq, meas_seq, report_seq. Consider matching
these names since the values represent sequence counters and to
differentiate them from the nonce used in RHI_DA_VDEV_GET_MEASUREMENTS.

> +			union {
> +				u8 format_type;
> +				u64 padding1;
> +			};
> +			u64 format_version;
> +			union {
> +				u8 state;
> +				u64 padding2;
> +			};
> +
> +		};
> +		u8 padding3[0x80];
> +	};
> +	union { /* 0x80  */
> +		struct {
> +			u8 protocol_data_digest[0x40];
> +			u8 identity_digest[0x40];
> +			u8 pubkey_digest[0x40];
> +			u8 meas_digest[0x40];
> +			u8 report_digest[0x40];
> +		};
> +		u8 padding4[0x1c0 - 0x80];
> +	};
> +	union { /* 0x1c0  */
> +		struct {
> +			u64 vsmmu_addr;
> +			u64 vsmu_vsid;
> +		};
> +		u8 padding5[0x200 - 0x1c0];
> +	};
> +};
> +
> +/*
> + * Get information for a device.
> + * arg1 == Realm device identifier (vdev id)
> + * arg2 == IPA to which configuration data will be written
> + * ret0 == Status / error
> + */
> +#define SMC_RSI_VDEV_GET_INFO			SMC_RSI_FID(0x19D)
> +
> +#define RSI_DEV_MEM_COHERENT		BIT(0)
> +#define RSI_DEV_MEM_LIMITED_ORDER	BIT(1)
> +#define SMC_RSI_VDEV_VALIDATE_MAPPING		SMC_RSI_FID(0x19F)
> +
>  struct rsi_host_call {
>  	union {
>  		u16 imm;
> diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
> index d295146bd92a..8ed4b95df5e4 100644
> --- a/drivers/virt/coco/arm-cca-guest/Kconfig
> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
> @@ -5,6 +5,8 @@ config ARM_CCA_GUEST
>  	tristate "Arm CCA Guest driver"
>  	depends on ARM64
>  	select PCI_TSM if PCI
> +	select CRYPTO_LIB_SHA256
> +	select CRYPTO_LIB_SHA512
>  	select TSM_REPORTS
>  	select AUXILIARY_BUS
>  	help
> diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
> index 0f9cfb329a06..320dd5aa7b9a 100644
> --- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
> +++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
> @@ -198,39 +198,304 @@ static void unregister_cca_tsm_report(void *data)
>  }
>  
>  #ifdef CONFIG_PCI_TSM
> +
> +static int __maybe_unused
> +cca_update_dev_measurements(struct pci_dev *pdev, const u8 *nonce)
> +{
> +	int ret;
> +	void *measurements;
> +	int measurements_size;
> +	int vdev_id = rsi_vdev_id(pdev);
> +	struct pci_tsm_evidence *evidence;
> +	struct rsi_vdevice_info *dev_info;
> +	struct pci_tsm_evidence_object *obj;
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +
> +	/* Regenerate the measurement from the device */
> +	ret = rhi_update_vdev_measurements_cache(pdev, nonce);
> +	if (ret) {
> +		pci_err(pdev, "failed to update device measurements from device (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_MEASUREMENT,
> +				     &measurements, &measurements_size);
> +	if (ret) {
> +		pci_err(pdev, "failed to get device measurements from the host (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
> +	if (!dev_info) {
> +		ret = -ENOMEM;
> +		goto free_measurements;
> +	}
> +
> +	if (rsi_vdev_get_info(vdev_id, virt_to_phys(dev_info))) {
> +		pci_err(pdev, "failed to get device digests (%d)\n", ret);
> +		ret = -EIO;
> +		goto free_dev_info;
> +	}
> +
> +	/* Make sure no unexpected lock/unlock operation happened from guest */
> +	if (dsc->dev_info.lock_nonce != dev_info->lock_nonce) {
> +		pci_err(pdev, "Unexpected lock/unlock operation from host (%d)\n", ret);
> +		ret = -EIO;
> +		goto free_dev_info;
> +	}
> +
> +	/*
> +	 * Verify that the digests of the provided reports match with the
> +	 * digests from RMM
> +	 */
> +	ret = cca_verify_digest(dev_info->hash_algo, measurements,
> +				measurements_size, dev_info->meas_digest);
> +	if (ret) {
> +		pci_err(pdev, "RMM provided digest mismatch (%d)\n", ret);
> +		goto free_dev_info;
> +	}
> +
> +	/* fill evidence details */
> +	evidence = &dsc->pci.base_tsm.evidence;
> +
> +	/* Now update the evidence under lock. */
> +	down_write(&evidence->lock);
> +	evidence->generation = dev_info->meas_nonce;
> +
> +	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS];
> +	if (obj->data)
> +		kvfree(obj->data);
> +	obj->data = measurements;
> +	obj->len = measurements_size;
> +
> +	dsc->dev_info.meas_nonce    = dev_info->meas_nonce;
> +	memcpy(dsc->dev_info.meas_digest, dev_info->meas_digest, SHA512_DIGEST_SIZE);
> +	up_write(&evidence->lock);
> +
> +	kfree(dev_info);
> +	return 0;
> +
> +free_dev_info:
> +	kfree(dev_info);
> +free_measurements:
> +	kvfree(measurements);
> +	return ret;
> +}
> +
> +static int cca_collect_dev_evidence(struct pci_dev *pdev, struct cca_guest_dsc *dsc)
> +{
> +	int ret;
> +	int vdev_id = rsi_vdev_id(pdev);
> +	struct pci_tsm_evidence *evidence;
> +	struct rsi_vdevice_info *dev_info;
> +	struct pci_tsm_evidence_object *obj;
> +	void *certificate, *vca, *interface_report, *measurements;
> +	int certificate_size, vca_size, interface_report_size, measurements_size;
> +
> +	/* Regenerate interface report and measurement from the device */
> +	ret = cca_update_device_object_cache(pdev, NULL);
> +	if (ret) {
> +		pci_err(pdev, "failed to update device objects from device (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_CERTIFICATE,
> +				     &certificate, &certificate_size);
> +	if (ret) {
> +		pci_err(pdev, "failed to get device certificate from the host (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_VCA, &vca, &vca_size);
> +	if (ret) {
> +		pci_err(pdev, "failed to get device VCA from the host (%d)\n", ret);
> +		goto free_certificate;
> +	}
> +
> +	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_INTERFACE_REPORT,
> +				     &interface_report, &interface_report_size);
> +	if (ret) {
> +		pci_err(pdev, "failed to get interface report from the host (%d)\n", ret);
> +		goto free_vca;
> +	}
> +
> +	ret = rhi_read_cached_object(vdev_id, RHI_DA_OBJECT_MEASUREMENT,
> +				     &measurements, &measurements_size);
> +	if (ret) {
> +		pci_err(pdev, "failed to get device certificate from the host (%d)\n", ret);
> +		goto free_interface_report;
> +	}
> +
> +	dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
> +	if (!dev_info) {
> +		ret = -ENOMEM;
> +		goto free_measurements;
> +	}
> +
> +	if (rsi_vdev_get_info(vdev_id, virt_to_phys(dev_info))) {
> +		pci_err(pdev, "failed to get device digests (%d)\n", ret);
> +		ret = -EIO;
> +		goto free_dev_info;
> +	}
> +
> +	/* Make sure no unexpected lock/unlock operation happened from guest */
> +	if (dsc->dev_info.lock_nonce != dev_info->lock_nonce) {
> +		pci_err(pdev, "Unexpected lock/unlock operation from host (%d)\n", ret);
> +		ret = -EIO;
> +		goto free_dev_info;
> +	}
> +
> +	/*
> +	 * Verify that the digests of the provided reports match with the
> +	 * digests from RMM
> +	 */
> +	ret = cca_verify_digests(dev_info->hash_algo, certificate,
> +				 certificate_size, vca, vca_size,
> +				 interface_report, interface_report_size,
> +				 measurements, measurements_size, dev_info);
> +	if (ret) {
> +		pci_err(pdev, "RMM provided digest mismatch (%d)\n", ret);
> +		goto free_dev_info;
> +	}
> +
> +	/* fill evidence details */
> +	evidence = &dsc->pci.base_tsm.evidence;
> +
> +	/* Now update the evidence under lock. */
> +	down_write(&evidence->lock);
> +	evidence->generation = dev_info->meas_nonce;
> +
> +	/* we default to slot 0 in pdev_create */
> +	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_CERT0];
> +	WARN_ON(obj->data);
> +	obj->data = certificate;
> +	obj->len = certificate_size;
> +
> +	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_VCA];
> +	WARN_ON(obj->data);
> +	obj->data = vca;
> +	obj->len = vca_size;
> +
> +	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_REPORT];
> +	WARN_ON(obj->data);
> +	obj->data = interface_report;
> +	obj->len = interface_report_size;
> +
> +	obj = &evidence->obj[PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS];
> +	WARN_ON(obj->data);
> +	obj->data = measurements;
> +	obj->len = measurements_size;
> +
> +	dsc->dev_info.meas_nonce    = dev_info->meas_nonce;
> +	dsc->dev_info.report_nonce  = dev_info->report_nonce;
> +	memcpy(dsc->dev_info.cert_digest, dev_info->identity_digest, SHA512_DIGEST_SIZE);
> +	memcpy(dsc->dev_info.vca_digest, dev_info->protocol_data_digest, SHA512_DIGEST_SIZE);
> +	memcpy(dsc->dev_info.meas_digest, dev_info->meas_digest, SHA512_DIGEST_SIZE);
> +	memcpy(dsc->dev_info.report_digest, dev_info->report_digest, SHA512_DIGEST_SIZE);
> +	up_write(&evidence->lock);
> +
> +	kfree(dev_info);
> +	return 0;
> +
> +free_dev_info:
> +	kfree(dev_info);
> +free_measurements:
> +	kvfree(measurements);
> +free_interface_report:
> +	kvfree(interface_report);
> +free_vca:
> +	kvfree(vca);
> +free_certificate:
> +	kvfree(certificate);
> +	return ret;
> +}
> +
>  static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
>  {
>  	int ret;
> +	enum hash_algo digest_algo;
> +	struct cca_guest_dsc *cca_dsc;
> +	int vdev_id = rsi_vdev_id(pdev);
> +	struct rsi_vdevice_info *dev_info;
>  
> -	struct cca_guest_dsc *cca_dsc __free(kfree) =
> -		kzalloc_obj(struct cca_guest_dsc);
> +	cca_dsc = kzalloc_obj(struct cca_guest_dsc);
>  	if (!cca_dsc)
>  		return ERR_PTR(-ENOMEM);
>  
>  	ret = pci_tsm_devsec_constructor(pdev, &cca_dsc->pci, tsm_dev);
>  	if (ret)
> -		return ERR_PTR(ret);
> +		goto free_cca_dsc;
>  
>  	ret = cca_device_lock(pdev);
>  	if (ret)
> -		return ERR_PTR(ret);
> +		goto free_cca_dsc;
>  
> -	/* collect evidence without nonce */
> -	ret = cca_update_device_object_cache(pdev, NULL);
> -	if (ret) {
> -		cca_device_unlock(pdev);
> -		return ERR_PTR(ret);
> +	dev_info = kmalloc_obj(struct rsi_vdevice_info);
> +	if (!dev_info) {
> +		ret = -ENOMEM;
> +		goto dev_unlock;
> +	}
> +
> +	if (rsi_vdev_get_info(vdev_id, virt_to_phys(dev_info))) {
> +		ret = -EIO;
> +		goto free_dev_info;
> +	}
> +
> +	/* collect the lock nonce */
> +	cca_dsc->dev_info.lock_nonce = dev_info->lock_nonce;
> +
> +	switch (dev_info->hash_algo) {
> +	case RSI_HASH_SHA_256:
> +		digest_algo = HASH_ALGO_SHA256;
> +		break;
> +	case RSI_HASH_SHA_512:
> +		digest_algo = HASH_ALGO_SHA512;
> +		break;
> +	default:
> +		ret = -EIO;
> +		goto free_dev_info;
>  	}
> +	pci_tsm_init_evidence(&cca_dsc->pci.base_tsm.evidence,
> +			      dev_info->id_index, digest_algo);
>  
> -	return &no_free_ptr(cca_dsc)->pci.base_tsm;
> +	/* collect evidence without nonce */
> +	ret = cca_collect_dev_evidence(pdev, cca_dsc);
> +	if (ret)
> +		goto free_dev_info;
> +
> +	kfree(dev_info);
> +	return &cca_dsc->pci.base_tsm;
> +
> +free_dev_info:
> +	kfree(dev_info);
> +dev_unlock:
> +	cca_device_unlock(pdev);
> +free_cca_dsc:
> +	kfree(cca_dsc);
> +	return ERR_PTR(ret);
>  }
>  
>  static void cca_tsm_unlock(struct pci_tsm *tsm)
>  {
> -	struct cca_guest_dsc *cca_dsc = to_cca_guest_dsc(tsm->pdev);
> +	long ret;
> +	struct pci_dev *pdev = tsm->pdev;
> +	struct cca_guest_dsc *cca_dsc = to_cca_guest_dsc(pdev);
> +
> +	/* invalidate dev mapping based on interface report */
> +	ret = cca_unmap_evidence_report_range(tsm->pdev);
> +	if (ret) {
> +		pci_err(tsm->pdev, "failed to invalidate the interface report\n");
> +		goto err_out;
> +	}
>  
>  	cca_device_unlock(tsm->pdev);
> +	pci_tsm_mmio_teardown(cca_dsc->pci.mmio);
>  
> +err_out:
> +	/*
> +	 * No error handling from this function. Leave the device locked
> +	 */
> +	pci_tsm_mmio_free(tsm->pdev, cca_dsc->pci.mmio);
>  	kfree(cca_dsc);
>  }
>  
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> index 9f9e54174813..039138768f8f 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> @@ -6,6 +6,7 @@
>  #include <linux/pci.h>
>  #include <linux/mem_encrypt.h>
>  #include <asm/rsi_cmds.h>
> +#include <crypto/hash.h>
>  
>  #include "rsi-da.h"
>  #include "rhi-da.h"
> @@ -85,3 +86,147 @@ int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce)
>  
>  	return rhi_update_vdev_measurements_cache(pdev, nonce);
>  }
> +
> +static inline int
> +rsi_validate_dev_mapping(unsigned long vdev_id, phys_addr_t start_ipa,
> +		phys_addr_t end_ipa, phys_addr_t io_pa,
> +		unsigned long flags, unsigned long lock_nonce,
> +		unsigned long meas_nonce, unsigned long report_nonce)
> +{
> +	unsigned long ret;
> +	phys_addr_t next_ipa;
> +
> +	while (start_ipa < end_ipa) {
> +		ret = rsi_vdev_validate_mapping(vdev_id, start_ipa, end_ipa,
> +						io_pa, &next_ipa, flags,
> +						lock_nonce, meas_nonce, report_nonce);
> +		if (ret || next_ipa <= start_ipa || next_ipa > end_ipa)
> +			return -EINVAL;
> +		io_pa += next_ipa - start_ipa;
> +		start_ipa = next_ipa;
> +	}
> +	return 0;
> +}
> +
> +static inline int rsi_invalidate_dev_mapping(phys_addr_t start_ipa, phys_addr_t end_ipa)
> +{
> +	return rsi_set_memory_range(start_ipa, end_ipa, RSI_RIPAS_EMPTY,
> +				    RSI_CHANGE_DESTROYED);
> +}
> +
> +static int cca_apply_evidence_report_range(struct pci_dev *pdev,
> +		struct pci_tsm_mmio *mmio, bool map)
> +{
> +	int i, ret;
> +	struct resource *res;
> +	unsigned long mmio_flags = 0; /* non coherent, not limited order */
> +	int vdev_id = rsi_vdev_id(pdev);
> +	struct pci_tsm_mmio_entry *entry;
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +
> +	for (i = 0; i < mmio->nr; i++) {

In the tsm unlock code path cca_tsm_unlock() ->
cca_unmap_evidence_report_range() -> cca_apply_evidence_report_range()
there is no null pointer check on mmio / dsc->pci.mmio.

dsc->pci.mmio is only initialized in the tsm accept path, so if the device
is locked then unlocked without an accept, this will lead to a null pointer
dereference.

Regards,
Kameron

> +		entry = pci_tsm_mmio_entry(mmio, i);
> +		res = &entry->res;
> +
> +		if (res->desc != IORES_DESC_ENCRYPTED)
> +			continue;
> +
> +		if (map)
> +			ret = rsi_validate_dev_mapping(vdev_id, res->start,
> +						       res->end + 1, entry->tsm_offset,
> +						       mmio_flags,
> +						       dsc->dev_info.lock_nonce,
> +						       dsc->dev_info.meas_nonce,
> +						       dsc->dev_info.report_nonce);
> +		else
> +			ret = rsi_invalidate_dev_mapping(res->start, res->end + 1);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +int cca_map_evidence_report_range(struct pci_dev *pdev, struct pci_tsm_mmio *mmio)
> +{
> +	return cca_apply_evidence_report_range(pdev, mmio, true);
> +}
> +
> +int cca_unmap_evidence_report_range(struct pci_dev *pdev)
> +{
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +	struct pci_tsm_mmio *tsm_mmio = dsc->pci.mmio;
> +
> +	return cca_apply_evidence_report_range(pdev, tsm_mmio, false);
> +}
> +
> +int cca_verify_digest(u64 hash_algo, uint8_t *report,
> +		size_t report_size, uint8_t *report_digest)
> +{
> +	u8 digest[SHA512_DIGEST_SIZE];
> +	size_t digest_size;
> +	void (*digest_func)(const u8 *data, size_t len, u8 *out);
> +
> +	switch (hash_algo) {
> +	case RSI_HASH_SHA_256:
> +		digest_func = sha256;
> +		digest_size = SHA256_DIGEST_SIZE;
> +		break;
> +	case RSI_HASH_SHA_512:
> +		digest_func = sha512;
> +		digest_size = SHA512_DIGEST_SIZE;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	digest_func(report, report_size, digest);
> +	if (memcmp(report_digest, digest, digest_size))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int cca_verify_digests(u64 hash_algo,
> +		uint8_t *certificate, size_t certificate_size,
> +		uint8_t *vca, size_t vca_size,
> +		uint8_t *interface_report, size_t interface_report_size,
> +		uint8_t *measurements, size_t measurements_size,
> +		struct rsi_vdevice_info *dev_info)
> +{
> +	int ret;
> +	struct {
> +		uint8_t *report;
> +		size_t size;
> +		uint8_t *digest;
> +	} reports[] = {
> +		{
> +			certificate,
> +			certificate_size,
> +			dev_info->identity_digest
> +		},
> +		{
> +			vca,
> +			vca_size,
> +			dev_info->protocol_data_digest
> +		},
> +		{
> +			interface_report,
> +			interface_report_size,
> +			dev_info->report_digest
> +		},
> +		{
> +			measurements,
> +			measurements_size,
> +			dev_info->meas_digest
> +		}
> +
> +	};
> +
> +	for (int i = 0; i < ARRAY_SIZE(reports); i++) {
> +		ret = cca_verify_digest(hash_algo, reports[i].report,
> +					reports[i].size, reports[i].digest);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> index 88067d2230ab..07a044d3e335 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> @@ -9,11 +9,23 @@
>  #include <linux/pci.h>
>  #include <linux/pci-tsm.h>
>  #include <asm/rsi_smc.h>
> +#include <crypto/sha2.h>
>  
>  #define MAX_CACHE_OBJ_SIZE	SZ_16M
>  
> +struct dsm_device_info {
> +	u64 lock_nonce;
> +	u64 meas_nonce;
> +	u64 report_nonce;
> +	u8 cert_digest[SHA512_DIGEST_SIZE];
> +	u8 vca_digest[SHA512_DIGEST_SIZE];
> +	u8 meas_digest[SHA512_DIGEST_SIZE];
> +	u8 report_digest[SHA512_DIGEST_SIZE];
> +};
> +
>  struct cca_guest_dsc {
>  	struct pci_tsm_devsec pci;
> +	struct dsm_device_info dev_info;
>  };
>  
>  static inline struct cca_guest_dsc *to_cca_guest_dsc(struct pci_dev *pdev)
> @@ -39,5 +51,15 @@ int cca_device_unlock(struct pci_dev *pdev);
>  int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce);
>  struct page *alloc_shared_pages(int nid, gfp_t gfp_mask, unsigned long min_size);
>  int free_shared_pages(struct page *page, unsigned long min_size);
> +int cca_map_evidence_report_range(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
> +int cca_unmap_evidence_report_range(struct pci_dev *pdev);
> +int cca_verify_digest(u64 hash_algo, uint8_t *report,
> +		size_t report_size, uint8_t *report_digest);
> +int cca_verify_digests(u64 hash_algo,
> +		uint8_t *certificate, size_t certificate_size,
> +		uint8_t *vca, size_t vca_size,
> +		uint8_t *interface_report, size_t interface_report_size,
> +		uint8_t *measurements, size_t measurements_size,
> +		struct rsi_vdevice_info *dev_info);
>  
>  #endif

