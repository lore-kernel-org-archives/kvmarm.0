Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087DA1A0731
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561616; cv=none; b=C+qDI89mgT4cFy5OIgbYZOsCe8vllg+MUPDAMfo4Ak0tQFHIsc9k7TmXtCchv4fpERb/blbH1N9ykrjhwWy+GZrQJVv9dVWtE+H45HCVwu6DQxjxhA+h0OsJyi9tL1kohX8yrLCQco9MhjhSiWHH8sIn7mXaclEUFQrHpq9NHkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561616; c=relaxed/simple;
	bh=QpibTT59eRhgnFQprM5zNZ8yyf3H4QvIDg3G6x2zri8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkYhcuOPCcG4wWYv3QRr1kwg8fshzwe8CWWRJby7E695tdFevmnb+XoFNV3VRjv7Hp8HVrnqrVkYaF606sEvycPbgQgUOUydhHPBs3Bx9g69Ep4u2nDQZ5fYs7wdy0OFw4sIONvHsvzra4UySRK3cFh2btVu5PHXX0+hHLV+NiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 194E812FC;
	Tue, 13 Aug 2024 08:07:20 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C86793F6A8;
	Tue, 13 Aug 2024 08:06:52 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:06:50 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 05/10] arm64: Add encoding for PIRE0_EL2
Message-ID: <20240813150650.GB3321997@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144738.2048302-6-maz@kernel.org>

On Tue, Aug 13, 2024 at 03:47:33PM +0100, Marc Zyngier wrote:
> PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
> regime, and it is sorely missing from the sysreg file.
> 
> Add the sucker.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/tools/sysreg | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7ceaa1e0b4bc..8e1aed548e93 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2853,6 +2853,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
>  Fields	PIRx_ELx
>  EndSysreg
>  
> +Sysreg	PIRE0_EL2	3	4	10	2	2
> +Fields	PIRx_ELx
> +EndSysreg
> +
>  Sysreg	PIR_EL1		3	0	10	2	3
>  Fields	PIRx_ELx
>  EndSysreg

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
