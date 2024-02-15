Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CFE12E1C7
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708020398; cv=none; b=PzyncqDTCxgNJ8T+s6blodpc1mHO20wkGUVmt79kDqL/G5+P7ZgDdd/U3RiH/StG2oC22R0XmdSc9iJP7vIqocztil4ApKOz+G4kOIYmIbiOXQ/TzTOoklOEXrShWBr/JjntitJ34Ybv8AEyS2+Kr5UQumW5xDVRGifxkhIG16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708020398; c=relaxed/simple;
	bh=OosWs8u9cs8y9LWvS8gLD04v8o3jCysymmgHAPljOLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmBxsJUis/ay35IDHU/LFGZLaC23s/zrWbrwSSDq+0gkefeoUH7z6hxMe+2au7hwi0f/bip7Io1D9ztNeW6D0BgyLMbVGHsSfFdMFHcMgPqzmRCekp1fCs/Pvnrh86ug6YqX20NA7mGCJP+t7lvPtZBf8M1DWvHnplPEqZJ6MEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF9FC433C7;
	Thu, 15 Feb 2024 18:06:35 +0000 (UTC)
Date: Thu, 15 Feb 2024 18:06:33 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 01/26] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1
 fields and variants
Message-ID: <Zc5SqaxkjhLKR1o9@arm.com>
References: <20240214131827.2856277-1-maz@kernel.org>
 <20240214131827.2856277-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214131827.2856277-2-maz@kernel.org>

On Wed, Feb 14, 2024 at 01:18:02PM +0000, Marc Zyngier wrote:
> Despite having the control bits for FEAT_SPECRES and FEAT_PACM,
> the ID registers fields are either incomplete or missing.
> 
> Fix it.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

In case you need another ack on this patch:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
