Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE407DA6A
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737998776; cv=none; b=OvRw12jxDlXKzXrHaT0gvj1jS8xHq4xrxAec39Adcy6sZ9bngKP1YY/sucW1NfYqy6YyGprhpwkqvRkUHs3hj7C1MBW4jLgPf06AcJnP2efqccGm9X70qYca4qZkI7/d6jgzIAhMPbw+0RcFIJ1JoryAtxuCxwwfADXkM8TtMEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737998776; c=relaxed/simple;
	bh=VJ8FP8QlEkNGmDqXIlDS0d3QuvUfIrsm2TlomNf1JEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9BASnA39MCzcFUCYqhxSC96hmB7qCsSKUZotOKh2NkZ8HL5yZF7VbiPhrUt9lZpfmnGbwTErpIIDazPPeWMe0A4SazFDR3SWCWG7MyCQyq0fFcgtkzIaBFXvM7l1UanRbV3DU4jYRokjBRoccX6XsGDEzUpsBawbpIsOjPfBI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRz5Y2D9; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRz5Y2D9"
Date: Mon, 27 Jan 2025 09:26:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737998771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ayRwvzgAh4SnVASswlH+xNoCzewLIlYOtXUUrA327pI=;
	b=MRz5Y2D9/SPAeNFeAr85vntgZyVtpA6aO5tivSaAAdT9B/joUFn4JfYJxrChk42V2OOgom
	lj3vjgwD8NKTyK5KUTjtcnAMuOC8pUqKdWzfpUSfHd0hjTe3LKO4B+cy+CmOp9w4cUcwC1
	SRo65tC11tYVboIE1sxi9FKbqRcTt3w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 2/4] KVM: arm64: Introduce hypercall support for
 retrieving target implementations
Message-ID: <Z5fBrFVIs0jOiR9W@linux.dev>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-3-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124151732.6072-3-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 24, 2025 at 03:17:30PM +0000, Shameer Kolothum wrote:
> If the Guest requires migration to multiple targets, these hypercalls
> will provide a way to retrieve the target CPU implementations from
> the user space VMM.
> 
> Subsequent patch will use this to enable the associated errata.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  Documentation/virt/kvm/arm/hypercalls.rst | 59 +++++++++++++++++++++++
>  include/linux/arm-smccc.h                 | 15 ++++++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index af7bc2c2e0cb..718725cbf6c7 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -142,3 +142,62 @@ region is equal to the memory protection granule advertised by
>  |                     |          |    +---------------------------------------------+
>  |                     |          |    | ``INVALID_PARAMETER (-3)``                  |
>  +---------------------+----------+----+---------------------------------------------+
> +
> +``ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID``
> +-------------------------------------------------------
> +Request the target CPU implementation version information and the number of target
> +implementations for the Guest VM.
> +
> ++---------------------+-------------------------------------------------------------+
> +| Presence:           | Optional;  KVM/ARM64 Guests only                            |
> ++---------------------+-------------------------------------------------------------+
> +| Calling convention: | HVC64                                                       |
> ++---------------------+----------+--------------------------------------------------+
> +| Function ID:        | (uint32) | 0xC6000040                                       |
> ++---------------------+----------+--------------------------------------------------+
> +| Arguments:          | None                                                        |
> ++---------------------+----------+----+---------------------------------------------+
> +| Return Values:      | (int64)  | R0 | ``SUCCESS (0)``                             |
> +|                     |          |    +---------------------------------------------+
> +|                     |          |    | ``NOT_SUPPORTED (-1)``                      |
> +|                     +----------+----+---------------------------------------------+
> +|                     | (uint64) | R1 | Bit[63] Must be zero                        |
> +|                     |          |    +---------------------------------------------+

Why? R0 is sufficient to determine if the hypercall was successful, and
this is already defined as an unsigned quantity to the guest.

> +|                     |          |    | Bits [62:32] Major version                  |
> +|                     |          |    +---------------------------------------------+
> +|                     |          |    | Bits [31:0] Minor version                   |
> +|                     +----------+----+---------------------------------------------+

Do we really need a full u64 of version information? If you collapse
this down to a u32 it'd align with the versioning scheme for PSCI /
SMCCC.

-- 
Thanks,
Oliver
