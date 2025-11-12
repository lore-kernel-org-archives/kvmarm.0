Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140522FE06F
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762942052; cv=none; b=kAgLCfhEEY54TQHHvUf+c6KU+mtl3sv7xqxBVit7SthZjueyqi63jEfHWw2+dineKqfZPSFzZpOfACG6eVMgbmLlheJnsom4tkGHuIC7aFTCz9gbqgeOtzzfzw1AbtMgBDlWX4nxLyaubPmcImT1ntvIerx+v8iz7/kT7sLt3Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762942052; c=relaxed/simple;
	bh=qv0rkaW2D6V9ujLxu5wOdIydA/9+KagOl+U71EexFE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWyESadAgBbIWStXX6ux7Vn+pjebOSVcAk4K+YdNyeSL2WDpSipNKyDcHjnVQvS0W0+igAPQd9QSV9F5c83UQWQJrKBiEYj5EN5tUbTVUzXCPXECs2vpOGzSZXLpWwtc65u2+Gaim0dDR3HgMQkrL2+SYW8W3eUdKsf3A9YVrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1rY93bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1rY93bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FA2C19423;
	Wed, 12 Nov 2025 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762942051;
	bh=qv0rkaW2D6V9ujLxu5wOdIydA/9+KagOl+U71EexFE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1rY93bGfF6KQBMEuguUMHxXmPbykSVli0bFRJZXzqDxNf56tK/QJW7OZvEny9K9A
	 mECJ/EsU11mobGrrYDAUQB7lP26PGcqvA3saTFaf/tvpR58N2wXlhJT1xvtJFCFM8G
	 rui532D3tvKMHRlpXlROMTmhwrY+wNQe7jIy+zJjRcztZgEnqfMWBK4fVbXwLNzblO
	 Ynb1yH13ENfWZM6fGRUUXwvlQ1vjv6YpDumnH5jOPeZwwy7YjBzY4KpPj7zgDu/Hqf
	 PSLCieSmJ1JGgDZXDvXig3+E/sVH6X5DPUV+bd9nSpDk6bdbPDfH87qdqiWDrmuV5i
	 1U1sRp+r6luTw==
Date: Wed, 12 Nov 2025 02:07:30 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Subject: Re: [PATCH v4 7/8] KVM: arm64: Check whether a VM IOCTL is allowed
 in pKVM
Message-ID: <aRRcYltFUrBlcbfX@kernel.org>
References: <20251112092051.1376245-1-tabba@google.com>
 <20251112092051.1376245-8-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112092051.1376245-8-tabba@google.com>

Hi Fuad,

On Wed, Nov 12, 2025 at 09:20:50AM +0000, Fuad Tabba wrote:
> +/*
> + * Check whether the KVM VM IOCTL is allowed in pKVM.
> + *
> + * Certain features are allowed only for non-protected VMs in pKVM, which is why
> + * this takes the VM (kvm) as a parameter.
> + */
> +static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
> +{
> +	switch (ioctl) {
> +	case KVM_CREATE_IRQCHIP:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_IRQCHIP);
> +	case KVM_ARM_SET_DEVICE_ADDR:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SET_DEVICE_ADDR);
> +	case KVM_ARM_MTE_COPY_TAGS:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE);
> +	case KVM_ARM_SET_COUNTER_OFFSET:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_COUNTER_OFFSET);
> +	case KVM_HAS_DEVICE_ATTR:
> +	case KVM_SET_DEVICE_ATTR:
> +	case KVM_GET_DEVICE_ATTR:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_DEVICE_CTRL) ||
> +		       kvm_pkvm_ext_allowed(kvm, KVM_CAP_VM_ATTRIBUTES);
> +	case KVM_ARM_GET_REG_WRITABLE_MASKS:
> +		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
> +	default:
> +		return true;
> +	}
> +}
> +

I was thinking of something a bit more tabular since CCA will impose its
own restrictions + pKVM could share the ioctl <=> KVM_CAP association.

Anyway, ioctl filtering should be an allowlist (default to false) just
like kvm_pkvm_ext_allowed(). The default assumption is that new UAPI is not
supported for pVMs unless explicitly stated otherwise.

Thanks,
Oliver
