Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57243AA1
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 01:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729819578; cv=none; b=b5mdycA3xxmLdPncnuDkbd8iNdeEg7dXLSEXk0vKQsnG0/vPkLQkuxOC0pCkMUGrvG7kE+XNwyA4ahA92rHgAIS2gE86aOyzurw0FTJ9n1mlExvrzJ4eqgknyyqh/pkLdb+bPmSVxeEj9YuVtaX9rGuMh/bksfx0jGRhkje2ES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729819578; c=relaxed/simple;
	bh=TcVtJv6oUrY/z+KHe26ljIu9/SEu81k+ENS3CDWIuk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSu4ae6iZ1S85JbAJBUEd4vJ7TM1eZgEhTwmqAZJ0t25DGnjOpQQJREV/Z/MegmTvvFm9B83CXVDL2HomvYVuQwpMzZN2ZP7xK6wIDSXdkKzkeYSZBwVVfiQRINiZXVvsO4gl/Vg5phCiSF/S21DOoWdXboypSj3Yhw5aQ/IqnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DcfmS8+V; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DcfmS8+V"
Date: Thu, 24 Oct 2024 18:25:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729819574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LbVgZw7rn3qGcaKG7VGgStY+XOz4C32vFUVkMj/8HwI=;
	b=DcfmS8+VrSpd0LFYtcWnb7KKcDO7ABI/h87NsY/f60XLm/GpI7R+hGNkifm/2CPH9O0doR
	YIvzvtnlahSAzLst29DQzaaj/bZQTRsCSvMmLmuhWbviSm01lamoqzF65C3UkYQw3BcbAh
	FC763oyUU5mnnqz0aKoET/15rUSxF68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 1/3] KVM: arm64: Add hypercall support for
 retrieving migration targets
Message-ID: <ZxrzhAh3qE9hLV-U@linux.dev>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
 <20241024094012.29452-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024094012.29452-2-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi,

On Thu, Oct 24, 2024 at 10:40:10AM +0100, Shameer Kolothum wrote:
> +``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``
> +------------------------------------------------------
> +
> +Query total number of migration target CPUs the Guest VM will be running during its
> +lifetime and version information applicable to the data format used for
> +``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``. The maximum number of targets
> +supported is 64. Also the version number supported currently is 1.0. This hypercall
> +must be handled by the userspace VMM.
> +
> ++---------------------+-------------------------------------------------------------+
> +| Presence:           | Optional; KVM/ARM64 Guests only                             |
> ++---------------------+-------------------------------------------------------------+
> +| Calling convention: | HVC64                                                       |
> ++---------------------+----------+--------------------------------------------------+
> +| Function ID:        | (uint32) | 0xC600007D                                       |
> ++---------------------+----------+--------------------------------------------------+
> +| Arguments:          | None                                                        |
> ++---------------------+----------+----+---------------------------------------------+
> +| Return Values:      | (int64)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else       |
> +|                     |          |    | [0-31] total migration targets              |
> +|                     |          |    | [32-63] version number                      |
> ++---------------------+----------+----+---------------------------------------------+

We can't treat a single register as both a signed quantity *and* a full
64 bits of bitfields. Maybe just scrap the version and have this thing
either return a negative error or positive quantity of implementations.

> +``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``
> +-------------------------------------------------------
> +
> +Request migration target CPU information for the Guest VM. The information must be
> +provided as per the format described by the version info in
> +``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``. At present, we only support
> +the below format which corresponds to version 1.0. This hypercall will always be
> +preceded by ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID`` and may be
> +invoked multiple times to retrieve the total number of target CPUs information
> +advertised. This hypercall must be handled by the userspace VMM.
> +
> +A typical userspace usage scenario will be like below:
> +
> +1. Receives ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_NUM_FUNC_ID``
> +
> +   * Returns total number of migration targets and version number
> +   * Reset current target index to zero
> +2. Receives ``ARM_SMCCC_VENDOR_HYP_KVM_MIGRN_TARGET_CPUS_FUNC_ID``
> +
> +   * Returns MIDR/REVIDR info in return register fields. Can return up to 4
> +   * Update current target index based on returned target info
> +   * If there are remaining register fields, return zero to indicate the end
> +   * Repeat step 2 until current target index == total number of migration targets

Hmm... I'd rather we make the guest supply the target index of the
implementation it wants to discover. Otherwise, the VMM implementation
of this hypercall interface is *stateful* and needs to remember to
migrate that...

> ++---------------------+-------------------------------------------------------------+
> +| Presence:           | Optional; KVM/ARM64 Guests only                             |
> ++---------------------+-------------------------------------------------------------+
> +| Calling convention: | HVC64                                                       |
> ++---------------------+----------+--------------------------------------------------+
> +| Function ID:        | (uint32) | 0xC600007E                                       |
> ++---------------------+----------+----+---------------------------------------------+
> +| Arguments:          | None                                                        |
> ++---------------------+----------+----+---------------------------------------------+
> +| Return Values:      | (int64)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else       |
> +|                     |          |    | [0-31] MIDR, [31-63] REVIDR, else           |
> +|                     |          |    | [0-63] Zero to mark end.                    |
> ++---------------------+----------+----+---------------------------------------------+

Same deal here, x0 needs to always be treated as a signed quantity.

How about -1 on error, 0 on success?

Then, in the remaining registers:

> +|                     | (uint64) | R1 | [0-31] MIDR, [32-63] REVIDR, else           |
> +|                     |          |    | [0-63] Zero to mark end.                    |
> ++---------------------+----------+----+---------------------------------------------+

Both MIDR_EL1 and REVIDR_EL1 are 64 bit registers in AArch64. So we need
to transfer a full 64 bits, even if the top half is _presently_ RES0 in
MIDR_EL1.

> +|                     | (uint64) | R2 | [0-31] MIDR, [32-63] REVIDR, else           |
> +|                     |          |    | [0-63] Zero to mark end.                    |
> ++---------------------+----------+----+---------------------------------------------+
> +|                     | (uint64) | R3 | [0-31] MIDR, [32-63] REVIDR, else           |
> +|                     |          |    | [0-63] Zero to mark end.                    |
> ++---------------------+----------+----+---------------------------------------------+

I think it's fine to have this hypercall return a single MIDR/REVIDR
pair at a time. This is not a performance sensitive interface and will
only be called a few times at boot.

Actually -- what if we crammed everything into a single hypercall?

DISCOVER_IMPLEMENTATION_FUNC_ID

 - Arguments:
   - arg0: selected implementation index

 - Return value:
   - r0: -1 on error, otherwise the maximum possible implementation index
   - r1: MIDR_EL1 of the selected implementation
   - r2: REVIDR_EL1 of the selected implementation

We're guaranteed at least one CPU implementation of course, so the guest
can just start w/ index 0 and iterate from there.

-- 
Thanks,
Oliver
