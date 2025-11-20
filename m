Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05E248896;
	Thu, 20 Nov 2025 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763660659; cv=none; b=lZdW/lO8ZFRrhAqxNDOaPcG31X3UNkC4osx5PGFc5Ye529JJ0N0i3spQ4/bs1O1c4hcPi8BGEhXNz4jDlj09wojUvPhLE5v6pk1D4eTPhgIrNtf3gzjq5V7CIx9019bGlvh8e0idJw9oHyo7SUve4gD+/KKdmyNomYe9be2mmmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763660659; c=relaxed/simple;
	bh=+n22BUwJ53cb4afS601Gb58g3F5kIlENQJ9OS2CEsSY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XaqgLg7Le9uR9iGTA17VHi9/ZyKgLX+dnXa6CMDe82LOk/dvT0T+ZcvuWGMu4/pO2xMNhtid1klsZezm8njxIS9uZj3sAGTB22fLVGBm9GY0I6ttBzNcV8eLmCQ43oCakv13+57lEl+kJqDelRmZN7i4OOyuYuEGfIueWSUMdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hsvv0Ths; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hsvv0Ths"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=r9zZXVI/mCOGGyhrvsJLe8JzaXDENpfVQWN4p9QxMiI=;
	b=hsvv0Thsn+ln+ErqFGd6eqgH5mdfN4f8MES1Vd9OexVaRali0nDIHUG6chIlhDmH+u31DQEGq
	wt3K29fcH3kzg7jX8WO6FlTTLnR8Qyb/ThGuoMr9eoZIVLtH2/ikkycLtA9pQj97mvgbubxOy4+
	c6+YByi+FhBCRSUgqMbZy5M=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dC5KR4Q6gz1vnyK;
	Fri, 21 Nov 2025 01:42:51 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dC5Kw1RsyzJ468k;
	Fri, 21 Nov 2025 01:43:16 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B0B91402EF;
	Fri, 21 Nov 2025 01:44:02 +0800 (CST)
Received: from localhost (10.48.159.58) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 20 Nov
 2025 17:44:00 +0000
Date: Thu, 20 Nov 2025 17:43:59 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
CC: <linux-coco@lists.linux.dev>, <kvmarm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <aik@amd.com>, <lukas@wunner.de>, Samuel Ortiz
	<sameo@rivosinc.com>, Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Steven Price
	<steven.price@arm.com>, Bjorn Helgaas <helgaas@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 07/11] coco: guest: arm64: Validate Realm MMIO
 mappings from TDISP report
Message-ID: <20251120174359.00001817@huawei.com>
In-Reply-To: <20251117140007.122062-8-aneesh.kumar@kernel.org>
References: <20251117140007.122062-1-aneesh.kumar@kernel.org>
	<20251117140007.122062-8-aneesh.kumar@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 19:30:03 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> Parse the TDISP device interface report and drive the RSI
> RDEV_VALIDATE_MAPPING handshake for each Realm MMIO window. The new
> helper walks the reported ranges, rejects malformed entries, and either
> validates the IPA->PA mapping when the device transitions to RUN or tears
> it down with RIPAS updates on unlock.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

A few minor things in here.

> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> index aa6e13e4c0ea..c70fb7dd4838 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c

> +int cca_apply_interface_report_mappings(struct pci_dev *pdev, bool validate)
> +{
> +	int ret;
> +	struct resource *r;
> +	unsigned int range_id;
> +	phys_addr_t mmio_start_phys;
> +	struct pci_tdisp_mmio_range *mmio_range;
> +	phys_addr_t ipa_start, ipa_end, bar_offset;
> +	struct pci_tdisp_device_interface_report *interface_report;
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +
> +	interface_report = (struct pci_tdisp_device_interface_report *)dsc->interface_report;
> +	mmio_range = (struct pci_tdisp_mmio_range *)(interface_report + 1);
> +
> +
> +	for (int i = 0; i < interface_report->mmio_range_count; i++, mmio_range++) {
> +

I would make scope of some of the variables used in here explicit by declaring them in the loop.
e.g. range_id.

> +		range_id = FIELD_GET(TSM_INTF_REPORT_MMIO_RANGE_ID, mmio_range->range_attributes);
> +
I would drop this blank line. Keep the variable set and error check tightly together.
> +		if (range_id >= PCI_NUM_RESOURCES) {
> +			pci_warn(pdev, "Skipping broken range [%d] #%d %d\n",
> +				 i, range_id, mmio_range->num_pages);
> +			continue;
> +		}
> +
> +		r = pci_resource_n(pdev, range_id);
> +

Likewise I would drop this blank line.

> +		if (r->end == r->start ||
> +		    resource_size(r) & ~PAGE_MASK || !mmio_range->num_pages) {
Seems like an odd wrap.
		if (r->end == r->start ||
		    resource_size(r) & ~PAGE_MASK ||
		    !mmio_range->num_pages) {

or
		if (r->end == r->start || resource_size(r) & ~PAGE_MASK ||
		    !mmio_range->num_pages) {

Only exception being if you are going to edit this in a patch soon after and this
is about avoiding churn in that patch  - if so ignore this comment.


> +			pci_warn(pdev, "Skipping broken range [%d] #%d %d pages, %llx..%llx\n",
> +				i, range_id, mmio_range->num_pages, r->start, r->end);
> +			continue;
> +		}
> +
> +		if (FIELD_GET(TSM_INTF_REPORT_MMIO_IS_NON_TEE, mmio_range->range_attributes)) {
> +			pci_info(pdev, "Skipping non-TEE range [%d] #%d %d pages, %llx..%llx\n",
> +				 i, range_id, mmio_range->num_pages, r->start, r->end);
> +			continue;
> +		}
> +
> +		/* No secure interrupts, we should not find this set, ignore for now. */
> +		if (FIELD_GET(TSM_INTF_REPORT_MMIO_MSIX_TABLE, mmio_range->range_attributes) ||
> +		    FIELD_GET(TSM_INTF_REPORT_MMIO_PBA, mmio_range->range_attributes)) {
> +			pci_info(pdev, "Skipping MSIX (%ld/%ld) range [%d] #%d %d pages, %llx..%llx\n",
> +				 FIELD_GET(TSM_INTF_REPORT_MMIO_MSIX_TABLE, mmio_range->range_attributes),
> +				 FIELD_GET(TSM_INTF_REPORT_MMIO_PBA, mmio_range->range_attributes),
> +				 i, range_id, mmio_range->num_pages, r->start, r->end);
> +			continue;
> +		}
> +
> +		/* units in 4K size*/
> +		mmio_start_phys = mmio_range->first_page << 12;
> +		bar_offset = mmio_start_phys & (pci_resource_len(pdev, range_id) - 1);
> +		ipa_start = r->start + bar_offset;
> +		ipa_end = ipa_start + (mmio_range->num_pages << 12);
> +
> +		if (!validate)
> +			ret = rsi_invalidate_dev_mapping(ipa_start, ipa_end);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> index fa9cc01095da..32cf90beb55e 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> @@ -12,6 +12,28 @@

>  struct cca_guest_dsc {
>  	struct pci_tsm_devsec pci;
>  	void *interface_report;
> @@ -42,5 +64,5 @@ int cca_device_unlock(struct pci_dev *pdev);
>  int cca_update_device_object_cache(struct pci_dev *pdev, struct cca_guest_dsc *dsc);
>  struct page *alloc_shared_pages(int nid, gfp_t gfp_mask, unsigned long min_size);
>  int free_shared_pages(struct page *page, unsigned long min_size);
> -

Check all patches for noise like this. Either that white space is good to have in which case
keep it. Or it's not in which case delete.

> +int cca_apply_interface_report_mappings(struct pci_dev *pdev, bool validate);
>  #endif

