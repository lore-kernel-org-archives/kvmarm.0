Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6D146D55F;
	Thu,  6 Aug 2026 11:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786017230; cv=none; b=QXaZghtZGpKrS+2DmpbZ+epUf95ALFIa49Wvb8CeJV1u4e1As0a1ZHUZlj14PuOOjnDnN2ZEygHMyhDx7JsPWEU7F+/M7gWy8xPceRVyXQkvoBXRCtr9H9O3LvWQ3viYIFr58q8iDrZXhS/ujkFTGXdBqawPG5nsRYlosHAHvmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786017230; c=relaxed/simple;
	bh=brAeps8PV/mXXmXHBh9GPBU0Pu28QCuagqDm5bbyICo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+NLOof20a3wxfjuSFI8rovDC5IGp/K67mO5ZF/6HnCf2UdSxMd+e1iR3Zd8+OgP1y0K4bB/Xj+T3Q51+ueSpdxnxuoMo9GaoHHCMpcArzHA25Jhz/9Rgl18kDK87dxmwhHkZMzIss4hYVVegHYIbl4x+EQzyelRY29fpW1VkSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNkfoXMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNkfoXMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D211F000E9;
	Thu,  6 Aug 2026 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786017229;
	bh=Ha9LLQG1ctYaUnh+KJBwsvLh8iHyjbB8c3vr8YZ9ipY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZNkfoXMZcZHCu2ZfT6ItuDYzqtpkX8eie7e5teFukbHUWm3LLo7KnuwGS2cRytXQp
	 wJcwXIYRevuo9dlvME3LVxYFlVu0GysdkHvjYU5DZ/JOmn/8kLD6g/ej6vXMQCT313
	 V9IakhR+Wrbue9AdLR8PeIL3k9PrbI5nVhq8cS8Xy8lXviNVMPz45a8d4MSDvy7fXU
	 nOlp0bTKjcnBf7TsGfsHkstxHkTvsQaLgsDHFqCSRJIMfI6XSnczkKn0ncLYZieKBf
	 7X2vGsn+wtPnzLlscpTsz5jHklLp78zmLuUzlI2DzjlIHEYKM4Edw0m2Q/K79FdLls
	 O2/TnQ9Iid+vQ==
Date: Thu, 6 Aug 2026 12:53:41 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH 2/6] firmware: arm_rmm: Add wrappers for direct RMI calls
Message-ID: <anR1xZrKkrsJhrGe@willie-the-truck>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-3-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715142739.80398-3-steven.price@arm.com>

On Wed, Jul 15, 2026 at 03:27:33PM +0100, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boilerplate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v14:
>  * Update to RMM v2.0-bet2 spec.
>  * Move SRO related wrappers to a later patch due to dependencies.
>  * Common wrappers are split into include/linux/arm-rmi-cmds.h.
> Changes from v13:
>  * Update to RMM v2.0-bet1 spec including some SRO support (there still
>    some FIXMEs where SRO support is incomplete).
> Changes from v12:
>  * Update to RMM v2.0 specification
> Changes from v8:
>  * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
>    rmi_rtt_read_entry() for consistency.
> Changes from v7:
>  * Minor renaming of parameters and updated comments
> Changes from v5:
>  * Further improve comments
> Changes from v4:
>  * Improve comments
> Changes from v2:
>  * Make output arguments optional.
>  * Mask RIPAS value rmi_rtt_read_entry()
>  * Drop unused rmi_rtt_get_phys()
> ---
>  arch/arm64/include/asm/rmi_cmds.h | 67 +++++++++++++++++++++++

This doesn't need to be in the arch code. Please work with Aneesh to put
this somewhere else.

Will
