Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F0D153BC7
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375351; cv=none; b=GaVcC8PrYo6EHyJEG+0xfPcWlHYUs/W8909n0kSDGLoWxqtY4xkP12XlAscS3BlmTrq/QnKaqmoT4O+pZt+e2V3sJgPIzbn8Fc86cY4sIh5VDTjFRqbgUSUNxL4q0N6b0CkyZW+jOWEXHeThBYOj1265XNvXEriHmQ8Nnt3cZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375351; c=relaxed/simple;
	bh=I9iI3RFhKdFbaSfxKkqBt3z0ab6BmQWyrkRplkix14Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpXBllMFyI467JJGjYNebMhOILXtUKxSwHe36/rn6l7z31zoyMOb9Z7qCbNI1lZThFuR1Z2AEFd1yzRrS+pkZZRHjLCZr5/EwWMIVeBZp3Yw6bJeGnPeOhrPPpXCS6r3pMRBBvdHXvBvZWInaDazSi8TWlUwZbqe2NJnUevnE4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D23C4CECF;
	Thu, 31 Oct 2024 11:49:08 +0000 (UTC)
Date: Thu, 31 Oct 2024 11:49:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, gshan@redhat.com, james.morse@arm.com,
	shameerali.kolothum.thodi@huawei.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 1/7] arm64/sysreg: Convert existing MPAM sysregs and
 add the remaining entries
Message-ID: <ZyNusiQFI9Kh-Zqx@arm.com>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
 <20241030160317.2528209-2-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030160317.2528209-2-joey.gouly@arm.com>

On Wed, Oct 30, 2024 at 04:03:11PM +0000, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Move the existing MPAM system register defines from sysreg.h to
> tools/sysreg and add the remaining system registers.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
