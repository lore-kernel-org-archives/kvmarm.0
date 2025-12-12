Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EDD312831
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 09:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765532391; cv=none; b=a+0navfGhHPMPTZEHp8nltfmS1TJXMA584UB5oANx/YQe8bQdjSj2e1VmQun35RughkKCaRxilvMCKsGhZhR3s3GE+dcr/RIsqzAcUkZ+23mgaTc8lhb8pMvAcsCKP8sjKOGIXDg8Qg259lMBE1v7bFSYO17ksxSun0sMv/gHXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765532391; c=relaxed/simple;
	bh=e5QOsR0BNFelxy02wdhwDwZe2B8E7CbpolBFmlg6keM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVDKiBeur6227RHQuPfDukjSQ//YrMt1Lz3nXzpoHrRCzzwlruwY51fPhHgYT0ALchAzdHq+ZiL+6otFlOU+Lcw/su2uxRCTXphDu3AC3H+iJU2Mf51R1chfGgTyfnYtO1WIERVxWKgNEl56I6PCphkCtOd4HJJg9P6SagMbDnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AB9C1063;
	Fri, 12 Dec 2025 01:39:41 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99A143F73B;
	Fri, 12 Dec 2025 01:39:46 -0800 (PST)
Date: Fri, 12 Dec 2025 09:39:43 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 01/35] arm64/sysreg: Add new SPE fields
Message-ID: <aTvi33vLZU5S9CoM@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-2-alexandru.elisei@arm.com>
 <20251210183827.GA3920451@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210183827.GA3920451@e132581.arm.com>

Hi Leo,

On Wed, Dec 10, 2025 at 06:38:27PM +0000, Leo Yan wrote:
> On Fri, Nov 14, 2025 at 04:06:42PM +0000, Alexandru Elisei wrote:
> 
> [...]
> 
> >  Sysreg	PMBIDR_EL1	3	0	9	10	7
> > -Res0	63:12
> > +Res0	63:48
> > +Field	47:32	MaxBuffSize
> > +Res0	31:12
> >  Enum	11:8	EA
> >  	0b0000	NotDescribed
> >  	0b0001	Ignored
> >  	0b0010	SError
> >  EndEnum
> > -Res0	7:6
> > +Enum	7:6	AddrMode
> > +	0b00	VM_ONLY
> > +	0b01	BOTH
> > +	0b10	RESERVED
> > +	0b11	nVM_ONLY
> > +EndEnum
> 
> Not sure how to select the enum names, but seems names above don't match
> well to the definitions.  How about:
> 
>   Enum  7:6     AddrMode
>         0b00    VA_ONLY         // Virtual address only
>         0b01    VA_PA           // Virtual and physical address supported
>         0b10    RESERVED
>         0b11    VM_PA_ONLY      // Physical address only in VM

Why not, but I would name the last value PA_ONLY.

Thanks,
Alex
