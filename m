Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191831DFC6
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 14:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718202637; cv=none; b=XkKoRlb6WVUTXwEdBM4Yzvm+2jfIeJtjtSUgBQEDl/ozsWlsXSmhX1OGvmpsm3pCGXBqZwdSFYDzeqKDnnrS9Xjfjxpr8pAfxsUCsh8+aCYPHqD90Pkmxt4X0S7GQSppaSkEnWqBV1txbb8q6QsH3BWjTYyyRvTz06PY/sAR8aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718202637; c=relaxed/simple;
	bh=LV3THBchGf1nyX4WaDCE6tNBFycyZa9nRIZ8SRGdEWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bm5LZCIWv5yyxbnWNg9+bKL4UMWbxF8LVS500mpdXvzlNMeVRF6B0VVt8PefKtX73ygq5Nbkyes0IJhUAmKRJUltDvWwTWKj0VLtb0vOi+Zr4yP1umBWqXE/+jiMJbkx1KB4WhUiPEQZhAMEo03F65Uiua2/8e/yqf1k4nbmHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C17621042;
	Wed, 12 Jun 2024 07:30:59 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFB943F64C;
	Wed, 12 Jun 2024 07:30:31 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:30:29 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	Sudeep Holla <sudeep.holla@arm.com>, maz@kernel.org,
	oliver.upton@linux.dev, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, lpieralisi@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Add support for FFA_PARTITION_INFO_GET
Message-ID: <ZmmxBWIerq5Durve@bogus>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515172258.1680881-3-sebastianene@google.com>

On Wed, May 15, 2024 at 05:22:56PM +0000, Sebastian Ene wrote:
> Handle the FFA_PARTITION_INFO_GET host call inside the pKVM hypervisor
> and copy the response message back to the host buffers.
>
> Save the returned FF-A version as we will need it later to interpret the
> response from the TEE.
>
I don't understand the context of the above statement and this patch.
Did you mean use the saved version to take apt action/decision within
FFA_PARTITION_INFO_GET handler. Or is it just missed cleanup ?

The change itself looks good.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

--
Regards,
Sudeep
