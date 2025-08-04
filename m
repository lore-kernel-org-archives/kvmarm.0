Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659D02264CC;
	Mon,  4 Aug 2025 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754345034; cv=none; b=Ypnc8yXVPaJDOAwyH+G5Ydbdt2NuVT2QFKWaAoGCKWkb9ejTIlpmmvEy8Mm+p2WGdXD0HD3hEdxatnHKz+vxVFXFd7Up9gQdboMOvvNQgqcbcbuFJ/M2Fp7J20ILoodhbFDsCYRfIK8haaktH1B/q1ie5QBpyrLR7pM5H6xFyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754345034; c=relaxed/simple;
	bh=UAR/BA3+g2BfEvK1wW5/YdEy81GLQUdnAhGQq5KtqDA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=duvEtDM8DhNfdqPSStJ0JTWdw3WZvFpx47J54ztEBWAmiZCL8tY09tx6MldnNPh8MiEjzev1dNmX0McLnjpxqaCbR5H66ZgUjlOuUSybmMTOAOgzAU9qmlaRsllXZko28l8pSgqIPNxeBthZgBJv2KsueVu/qXxw6Vkj//rtAig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uf92592r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uf92592r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0EDC4CEE7;
	Mon,  4 Aug 2025 22:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754345033;
	bh=UAR/BA3+g2BfEvK1wW5/YdEy81GLQUdnAhGQq5KtqDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=uf92592rClnEy+UaD4xHpbIZfXFcUmEcODX6xrQ2jTsBZPb4z2rzILvh7rGVBNnG9
	 iK+E9AQGco/4qlp6fGZJrg1jtGxgAyMNspWVIOd/tsPqWXhZx1PzqB8V5tm7E5jLlL
	 WE3J/tjbyweHiH7N8GCqRr1hCwmNERrA9B1/5CuaKKqJYxosY5zzqg+AP1TM4xS28k
	 V/9y2LLV7jlThcsyapgk/A1J/48Z32f6VbXzBo3OFU6d0zSFHTRCMDhA9p8Y2R4cHv
	 2aOhzf33s4JjCJe40xgBToGycCi3vthj0Wx13uRIR96+YrVUNSbg+6ayAhLZr8zVtp
	 K7YnS71Ba6WUA==
Date: Mon, 4 Aug 2025 17:03:52 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 09/38] iommufd/vdevice: Add TSM Guest request uAPI
Message-ID: <20250804220352.GA3644611@bhelgaas>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-10-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Add TSM Guest request uAPI against iommufd_vdevice to forward various
> TSM attestation & acceptance requests from guest to TSM driver/secure
> firmware. This uAPI takes function only after TSM Bind.
> 
> After a vPCI device is locked down by TSM Bind, CoCo VM should attest
> and accept the device in its TEE. These operations needs interaction
> with secure firmware and the device, but doesn't impact the device
> management from host's POV. It doesn't change the fact that host should
> not touch some part of the device (see TDISP spec) to keep the trusted
> assignment, and host could exit trusted assignment and roll back
> everything by TSM Unbind.
> 
> So the TSM Guest request becomes a passthrough channel for CoCo VM to
> exchange request/response blobs with TSM driver/secure firmware. The
> definition of this IOCTL illustates this idea.

s/illustates/illustrates/

> +++ b/drivers/pci/tsm.c
> @@ -861,7 +861,7 @@ int pci_tsm_unbind(struct pci_dev *pdev)
>  EXPORT_SYMBOL_GPL(pci_tsm_unbind);
>  
>  /**
> - * pci_tsm_guest_req - VFIO/IOMMUFD helper to handle guest requests
> + * pci_tsm_guest_req - IOMMUFD helper to handle guest requests
>   * @pdev: @pdev representing a bound tdi

I dunno where this got added (not this patch), but "TDI" might be an
initialism that should be capitalized?

>   * @info: envelope for the request
>   *
> @@ -871,11 +871,12 @@ EXPORT_SYMBOL_GPL(pci_tsm_unbind);
>   * posts to userspace (e.g. QEMU) that holds the host-to-guest RID
>   * mapping.
>   */
> -int pci_tsm_guest_req(struct pci_dev *pdev, struct pci_tsm_guest_req_info *info)
> +static int __pci_tsm_guest_req(struct pci_dev *pdev, struct tsm_guest_req_info *info)
>  {
>  	struct pci_tdi *tdi;
>  	int rc;
>  
> +

Spurious diff.

>  	lockdep_assert_held_read(&pci_tsm_rwsem);
>  
>  	if (!pdev->tsm)
