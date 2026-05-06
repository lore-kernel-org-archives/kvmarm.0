Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51418D636;
	Wed,  6 May 2026 08:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778055280; cv=none; b=tQP0GG6FMhUk69MfgdXQzrsjpV4GKyvG9wyI2Baav+blShpi6K3jO63D0zEIHnUKvFvPX/hCPp99oF82btvzheOWW9PDXw8qCKKScIBjMnvcSeHVIkQcwWe5wu79G4A0Xr9LGi8x+iGTRUNRM25TlGQeHrRAEn50SQ/LyIt0ONs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778055280; c=relaxed/simple;
	bh=7Lic6fZQegZG6YVItAhYwyATUQXw9Th9iYZShZ0NxE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfvPu/1bwanYQZetdtRBVP5x0SAht7GGyr3uX6Q22/n9QP6PMqlcGelSNlFLLtX7+RKzrWsvFL2BdpLmot9HMH8yP8X23dRbsYzpFJ0DHlJKWNb63RmP144UHHl9s8MozlsyajY3bpPj3FUCAo+8dDgFX6lVj1ToXvKNKHgkcVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUZL+oxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUZL+oxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94822C2BCC9;
	Wed,  6 May 2026 08:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778055280;
	bh=7Lic6fZQegZG6YVItAhYwyATUQXw9Th9iYZShZ0NxE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jUZL+oxg1qJnVnVjPspD+OANvkZ+akUJ6dnyw/wLGEU7Rm440h74KG4YelYCITc8p
	 cSe1j2cKSwzfRi4FBy4LVwxX26E18nh4QdcJFVPoej00IaD37gZOIKsccwTvr9+vRv
	 TpTdIs/V0VtWfS77nIgZDR8FYSkRCaYhqte1Dy8xPwb8PLKM3RIMp25dKN+wMsAeo1
	 EQGTh9RAzvBlTOa1GT3UmX9WgTPLMFnmK3XHVlfY6Zoy0zoHnvOlGNFo+0b1XKQRZ6
	 KwKwM33YvXtajHtLFjzpCGKjcMV55pCh4fRz7/+EGPfj5v9s1KT0FImJMEJ/P5XvEw
	 Q2zP9L1hASzVQ==
Date: Wed, 6 May 2026 09:14:34 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	jarkko@kernel.org, zohar@linux.ibm.com, roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [RFC PATCH 2/3] firmware: arm_ffa: initialise ff-a after
 finalising pKVM initialisation
Message-ID: <20260506-colossal-bee-of-discussion-08ac76@sudeepholla>
References: <20260505095409.1948371-1-yeoreum.yun@arm.com>
 <20260505095409.1948371-3-yeoreum.yun@arm.com>
 <20260505-super-gecko-of-argument-655030@sudeepholla>
 <afoHizU8NgFWzvYW@e129823.arm.com>
 <20260505-adaptable-mussel-of-virtuosity-2751db@sudeepholla>
 <afohuFhVBIyUFEMT@e129823.arm.com>
 <20260506-warm-deer-of-energy-522bfa@sudeepholla>
 <afrygFx4OoCbbr+a@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afrygFx4OoCbbr+a@e129823.arm.com>

On Wed, May 06, 2026 at 08:49:20AM +0100, Yeoreum Yun wrote:
> Hi,
> 
> I mean like DT node, it seems to add some "FF-A" device for this.
> Anyway, right now as your suggestion, let me respin with platform device
> again.
> 

Please check my branch ffa_plat_dev [1] as I noted in the last email.

-- 
Regards,
Sudeep

[1] https://git.kernel.org/sudeep.holla/l/ffa_plat_dev
