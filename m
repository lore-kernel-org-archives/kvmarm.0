Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBAB226CE5;
	Wed, 18 Jun 2025 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750256935; cv=none; b=ZZ2xr6TGNSoM0v1fE0+V/Vl4+nyroWRzEBxUO08+iAYHPCLgnW28XgSyh31aF3Wl4kaKtXPKTV8376aAkTtWbNV7GHA+Q9zT0RuiQSe+wWpc0z2olD7lEMohOxigzNcnZag7r2ataEuZ0mofmBihWzXwJUdGnZj6AkUyTUmQiAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750256935; c=relaxed/simple;
	bh=zkmqS7UxRiCDCSuzOXaMnQUFUHrfVLQapBiLPL35hXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xk/cmgNTZTz0p93V3bPf/2jeTyaBqwLJH5/5gBrF3HpqjW8MXNTVv9hjXByGOO/tVAQ4hjkGmzEN289frhJNIxy9tQ6/sX9hrRKN2s6p3ubD3786o7jOHbPSu6nrtVFpuMcLRy1O2o12WCRH7ArRr/4FSC6jLcqZKcp//A+GJ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92066C4CEE7;
	Wed, 18 Jun 2025 14:28:48 +0000 (UTC)
Date: Wed, 18 Jun 2025 15:28:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, david@redhat.com, ddutile@redhat.com,
	seanjc@google.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, kjaju@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, tabba@google.com, qperret@google.com,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
Subject: Re: [PATCH v7 1/5] KVM: arm64: Rename symbols to reflect whether CMO
 may be used
Message-ID: <aFLNHvCdz3v6XrCr@arm.com>
References: <20250618065541.50049-1-ankita@nvidia.com>
 <20250618065541.50049-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618065541.50049-2-ankita@nvidia.com>

On Wed, Jun 18, 2025 at 06:55:37AM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, the kvm_is_device_pfn() detects if the memory is kernel
> mapped. It thus implies whether KVM can use Cache Maintenance
> Operations (CMOs) on that PFN. Rename the function to reflect this.
> 
> Additionally, the "device" variable is effectively trying to setup the S2
> to prevent CMOs. Calling it 'disable_cmo' would make this code clearer.

I'm not sure CMOs is the only reason. Another is to prevent the guest
from mapping device memory as something other than Device with
possible implications for external aborts.

-- 
Catalin
