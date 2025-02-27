Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE4C228CA5
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 09:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740650316; cv=none; b=TG+VSOtM5bqU1h76ZIEE389EywI6X0aGgLJEQZ6KsvgVXw/IVan510nEPZX5oP6gOwdpWhLwDR/PzfGMeGOOcPsBsdmI5o7zJ/tHyuyiAXY84iwdmmiz/0Xk50jm1WSC8tlRES2PBkzy6kO141Fap+orysm8yDIdRRtX4OF5MJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740650316; c=relaxed/simple;
	bh=/st8Sg7ccz/8QIygt3HEXge9KyM2nl1VrUJyP1gdEX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zt6Gc0Jd5mV3Xs9m9oTiQ/XGtKkBMxgYJpCVKxPsAatO/wi/WpG89xra8eWlvyKHeVT06+gO/F5U2OcWA8CJlz3zX9xKq2sYjIKjJzSXZuWad8tOUeTYOW5OQjMDbXxhkc4oZg1EEkajwrjVanBpSvfqI7dnUGifi/2MztQlnUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D7972BCC;
	Thu, 27 Feb 2025 01:58:49 -0800 (PST)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36ECE3F673;
	Thu, 27 Feb 2025 01:58:31 -0800 (PST)
Date: Thu, 27 Feb 2025 09:58:28 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, oliver.upton@linux.dev,
	snehalreddy@google.com, suzuki.poulose@arm.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 2/3] KVM: arm64: Map the hypervisor FF-A buffers on ffa
 init
Message-ID: <Z8A3RLoZxVxcz3wj@bogus>
References: <20250226214853.3267057-1-sebastianene@google.com>
 <20250226214853.3267057-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226214853.3267057-3-sebastianene@google.com>

On Wed, Feb 26, 2025 at 09:48:52PM +0000, Sebastian Ene wrote:
> Map the hypervisor's buffers irrespective to the host and return
> a linux error code from the FF-A error code on failure. Remove
> the unmap ff-a buffers calls from the hypervisor as it will
> never be called and move the definition of the
> ffa_to_linux_error map in the header where it should belong to.
> Prevent the host from using FF-A if the hypervisor could not
> map its own buffers with Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c     | 46 ++++++++++++-------------------
>  drivers/firmware/arm_ffa/driver.c | 24 ----------------
>  include/linux/arm_ffa.h           | 24 ++++++++++++++++

Can you post the code movement from driver to the header as separate patch
so that I can take it separately to avoid conflicts with the other changes
I have. It could be just fine but I see no reason as why it can't be a
separate change or why it needs to be bundled here.

-- 
Regards,
Sudeep
