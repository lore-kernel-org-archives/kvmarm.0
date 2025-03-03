Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DA71487F4;
	Mon,  3 Mar 2025 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045390; cv=none; b=jxw92QghWk+T2VLvE8Okm57KGyhp4zgSHjGTuOwhaAnZCdto6IN4OcG6LzEsVZ1NCFbCn7KYEy+gti4BlW2Nh/IythHfx+PBLd2a2rUIIIQ+i7G9bU41FCQva+vY+tPkL7BQJLsKLqLuQgKt8Ravl/gtcp8m1yyoVGJU1gaSA7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045390; c=relaxed/simple;
	bh=a8a9IK/kNpa34r9G10IOTtk/N5+iTd8OkmB8cSTMxgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odTaqBs47yrND1Chg+PSgopGunSAZ+yaKYTvXlsPJAr2nX+GG5rwSPxAag5p7sAQpY7DvvzIONwKMmFlmyuxLJLKWydBwcZVrtdxjiA+H7p/SiB3a7EUKDCumFBuUj+VyhjResz0vOxfDH3UICQ1K35r4hfGdw+3oV4fFcdvfMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U18h4J6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U18h4J6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B5BC4CEE8;
	Mon,  3 Mar 2025 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741045389;
	bh=a8a9IK/kNpa34r9G10IOTtk/N5+iTd8OkmB8cSTMxgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U18h4J6eHzdpV/lQruFiVfI0FCi9kpiJl21LupatW+d1VqZD4BijRx2feSVu4Pdg3
	 I1k6dRx8/BbjL8eOwBQkWbzkNdxB+nwD3qHtRNjhiTI1mS6wzdzppN5KN8CUXcWV5U
	 45xubGB5Zm0UtnScNszufU1Qn96OKzP8XYzPQVXopp+JVl1/+2iDJRL+g6Lzn8Dmc/
	 TnuQzfkJrNW/FuufAKgebUxjOol8dvfjv7U55kvM7WK3e8WI3QpQ8e5ZJGDMD8eq/K
	 2O7iDJ4TlE7KLPoZi7RPcuQtg/QjuJQ2d3ljc2+f/dqjwqDWxkR4iqLqm7T0SjINVq
	 imaYnUzij4rMw==
Date: Mon, 3 Mar 2025 23:43:03 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on
 ffa init
Message-ID: <20250303234259.GA30749@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227181750.3606372-4-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 27, 2025 at 06:17:48PM +0000, Sebastian Ene wrote:
> Map the hypervisor's buffers irrespective to the host and return
> a linux error code from the FF-A error code on failure. Remove
> the unmap ff-a buffers calls from the hypervisor as it will
> never be called.
> Prevent the host from using FF-A directly with Trustzone
> if the hypervisor could not map its own buffers.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
>  1 file changed, 17 insertions(+), 29 deletions(-)

[...]

> @@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
>  {
>  	struct arm_smccc_res res;
>  	void *tx, *rx;
> +	int ret;
>  
>  	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
>  		return 0;
> @@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
>  		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
>  	};
>  
> +	/* Map our hypervisor buffers into the SPMD */
> +	ret = ffa_map_hyp_buffers();
> +	if (ret)
> +		return ret;

Doesn't calling RXTX_MAP here undo the fix from c9c012625e12 ("KVM:
arm64: Trap FFA_VERSION host call in pKVM") where we want to allow for
the host to negotiate the version lazily?

Will
