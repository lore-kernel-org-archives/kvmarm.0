Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185ED3BCD01;
	Thu, 16 Jul 2026 07:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187558; cv=none; b=OnjqwNB+bln0bFcTlRwh2Ev/csI2LSuWKqsBJJvpQkDr5NMJP/ZqEPonj3HiTs07TleYug0s7Qhi6iBwUyybMMGjDwF1vHcDB+uEZxfbN+3HYhVsFf1nrTagPNsgFzvfDG3k4CXNqDnspAICyTz4ob2ozhyI++3dh+odpp2prew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187558; c=relaxed/simple;
	bh=Np5vro/iaKpCDRoTmTN0z2nXvU3o+YX83+k/D/xhD9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZfY3StGnSZRiqGq5QJ7T/YWM7Lt0oDlUzwKI43dTZAbG0UeBj8eZbb5eN0zF6A/1ByKLO4osi9juZ38/SztKMPGa5HZzmsIbAIU9LFLVB1BDYA0NDctPWn3BnZMoWMva5MTtGynlGohWzzDszm5q98WIrAim3RNibLDYKIoBWuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hO/BIT9l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hO/BIT9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD321F00A3A;
	Thu, 16 Jul 2026 07:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784187556;
	bh=malUCnvO8ek8Kt+Gg1lNXeMv1KHUcTELIq/XhwfI6sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hO/BIT9ln2bUAPkNbyvzxxux7ErFAgTUvcalcKpl5Jaf+VQYiVFJMug5EX3x8Bqc2
	 S4U7rwqfVZmmDD2NmfZ/vJVLSZOVa6ASiCBGIma65ebcTMNqGIl959cmGtsobnmYGO
	 s1xSxQRZv56yqAwUlyV8vZPK7tlE5UhGYqmKl6f7o1+7k0JahWCyC3DUNHhmnkYIwN
	 zkyGSLvfliQQfKz+IhioE/uCXL21tndw4re04pxz0HUIomjL9BZhcP5DaONo76hN+H
	 sYnyphfPKqhyi2s9T7mptMyC4kPKF/xNSxFVnr6v1mUMLMHDD87mv65Xn9dB96zc8s
	 YmAfeXShj9fZw==
Date: Thu, 16 Jul 2026 00:39:15 -0700
From: Oliver Upton <oupton@kernel.org>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	yuzenghui@huawei.com, wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com, caijian11@h-partners.com,
	liuyonglong@huawei.com, yezhenyu2@huawei.com, yubihong@huawei.com,
	linuxarm@huawei.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, leo.bras@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
Message-ID: <aliKo7dTZzKcWHzI@kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260709104026.2612599-4-zhengtian10@huawei.com>

Hi Tian,

On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> -	if (prot & KVM_PGTABLE_PROT_W)
> +	if (prot & KVM_PGTABLE_PROT_W) {
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> +		/*
> +		 * No DEVICE filter needed here: relax_perms is only called
> +		 * on FSC_PERM faults. Device pages always get full RW from
> +		 * initial mapping and are never write-protected during
> +		 * migration, so they never trigger a permission fault.
> +		 */
> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	} else {
> +		/*
> +		 * Clear DBM on W→RO downgrade to prevent hardware from
> +		 * silently upgrading RO+DBM back to W+dirty, which would
> +		 * bypass KVM's write tracking and cause data corruption.
> +		 */
> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +	}
> +

This block makes it pretty evident that the DBM bit really *is* the
write permission bit. I'd much rather we introduce the concept of dirty
state to the page table library and migrate the abstract write
permission to the DBM field, even if we don't have FEAT_HAFDBS.

That way everything 'just works' from outside the page-table library:
write-protecting hugepages would have the effect of clearing DBM and we
can separately reap dirty state from page descriptors.

If/when the architecture forces FEAT_S2PIE upon us we will need to make
this change anyway since dirty state management is unconditional and
handled separately from the actual permissions.

Thanks,
Oliver
