Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BEC3EDE72;
	Thu, 20 Aug 2026 11:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224720; cv=none; b=NalypPQARQFcKChbXMIXvYKXrPNMVONS45IaCT/Cdw3ayqYg0mNMf/aB5C/zgURaMptyfzBM7j15wEmI7duMG8WD/wvassxCL+FhBXWOLkEIlU5FlG35r105wJbrt4HKtrJ1JwCWKugzRriRZg97lA20oGEq5Xu3nnwG3AlagvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224720; c=relaxed/simple;
	bh=SdEAhDJE3ceKTkP+KHkZa5VUf6xd31d914SRKQNJZ5c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MMpnrswTOSlNu+KvfdcP4F/JkVGy+eZ8hQKs8iloeAb6Ge0i5EwSuNsWdPP/YwJj3yWJHo2uGohbm6aNMVYkLdoCplLtl/Xo4FhfuOk7irmmSSb3reZ4Ime5cmbd4mLclyyN8BU1/FWlCLkE4tb+OMFrSYX2wlkYKq3zbmol7fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4ejpgkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4ejpgkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A531F000E9;
	Thu, 20 Aug 2026 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787224713;
	bh=kD8M/YKHqWqzGIENajqOC2rY0txazHy/e/Ja7hOOoXE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=N4ejpgkcSr7xuovl0VUw3yUMsE5hXE63S3pSHaRM7XjXdVv/+Brt0GYH7OKMHkg+W
	 QMy1BeBvHx0o3sXHvln8dA8ma/oYy4+2Zyl0fDHb11veUnnYoAQyUePu6qPwMnxJnc
	 ljUeDCitQA/l7zP1BsEnJ9QYTBZKypvZ46isguSOlpNj8oZlXo29rpaMuLX73m6B+x
	 /f6Q5SaTCtcfgXiKmpncrMXtkZE6urbY8H2nenEICEeiNnVuZCcz3V3XWYGQBmuuco
	 GVnVaCIN85PNKewAUOYrH943fuMrZuVKIPvJZZtdo9fgYiijyrjFoU0MzgkmVv28nm
	 3dAf1vXRPuUNA==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Kameron Carr <kameroncarr@linux.microsoft.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
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
Subject: Re: [RFC PATCH v4 08/11] coco: guest: arm64: Verify DA evidence
 with RSI_VDEV_GET_INFO digests
In-Reply-To: <da92b216-e4ee-4392-9a35-de7bc1683f83@linux.microsoft.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-9-aneesh.kumar@kernel.org>
 <da92b216-e4ee-4392-9a35-de7bc1683f83@linux.microsoft.com>
Date: Thu, 20 Aug 2026 16:48:23 +0530
Message-ID: <yq5alda1vy4g.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Kameron Carr <kameroncarr@linux.microsoft.com> writes:

> On 4/27/2026 1:28 AM, Aneesh Kumar K.V (Arm) wrote:
>
>> +struct rsi_vdevice_info {
>> +	union {
>> +		struct {
>> +			u64 flags;
>> +			u64 id_index;
>> +			union {
>> +				u8 hash_algo;
>> +				u64 padding0;
>> +			};
>> +			u64 lock_nonce;
>> +			u64 meas_nonce;
>> +			u64 report_nonce;
>
> Nit:
> I found the name `lock_nonce` confusing. I originally assumed this was the
> nonce passed in when calling RHI_DA_VDEV_GET_MEASUREMENTS. The new RSI spec
> (2.0 beta 3) names these lock_seq, meas_seq, report_seq. Consider matching
> these names since the values represent sequence counters and to
> differentiate them from the nonce used in RHI_DA_VDEV_GET_MEASUREMENTS.
>

Will switch to that name.

>
>> +			union {
>> +				u8 format_type;
>> +				u64 padding1;
>> +			};
>> +			u64 format_version;
>> +			union {
>> +				u8 state;
>> +				u64 padding2;
>> +			};
>> +
>> +		};
>> +		u8 padding3[0x80];
>> +	};

...

>> +static int cca_apply_evidence_report_range(struct pci_dev *pdev,
>> +		struct pci_tsm_mmio *mmio, bool map)
>> +{
>> +	int i, ret;
>> +	struct resource *res;
>> +	unsigned long mmio_flags = 0; /* non coherent, not limited order */
>> +	int vdev_id = rsi_vdev_id(pdev);
>> +	struct pci_tsm_mmio_entry *entry;
>> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
>> +
>> +	for (i = 0; i < mmio->nr; i++) {
>
> In the tsm unlock code path cca_tsm_unlock() ->
> cca_unmap_evidence_report_range() -> cca_apply_evidence_report_range()
> there is no null pointer check on mmio / dsc->pci.mmio.
>
> dsc->pci.mmio is only initialized in the tsm accept path, so if the device
> is locked then unlocked without an accept, this will lead to a null pointer
> dereference.
>

I already have a fix for it in my development branch.


modified   drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -489,13 +489,15 @@ static void cca_tsm_unlock(struct pci_tsm *tsm)
 	}
 
 	cca_device_unlock(tsm->pdev);
-	pci_tsm_mmio_teardown(cca_dsc->pci.mmio);
+	if (cca_dsc->pci.mmio)
+		pci_tsm_mmio_teardown(cca_dsc->pci.mmio);
 
 err_out:
 	/*
 	 * No error handling from this function. Leave the device locked
 	 */
-	pci_tsm_mmio_free(tsm->pdev, cca_dsc->pci.mmio);
+	if (cca_dsc->pci.mmio)
+		pci_tsm_mmio_free(tsm->pdev, cca_dsc->pci.mmio);
 	kfree(cca_dsc);
 }
 
modified   drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -155,7 +155,9 @@ int cca_unmap_evidence_report_range(struct pci_dev *pdev)
 	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
 	struct pci_tsm_mmio *tsm_mmio = dsc->pci.mmio;
 
-	return cca_apply_evidence_report_range(pdev, tsm_mmio, false);
+	if (tsm_mmio)
+		return cca_apply_evidence_report_range(pdev, tsm_mmio, false);
+	return 0;
 }
 
 int cca_verify_digest(u64 hash_algo, uint8_t *report,


-aneesh
