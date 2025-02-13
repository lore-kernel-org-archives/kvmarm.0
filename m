Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3AA221569
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739449647; cv=none; b=mDOMa1QhUOexcRnyNcBfPG4H83JR5oRXf2g1fByuPagAAUDuNZ59I9GSO+vQWcIF3UXQJMBbOaAktxvJMtmZ+nNPFeqkCOLTGy1TsbEkzvFAZhW1zMrf78204nqAvrYkAwhJdznRbxbelDYtdcV/RPTTXlcxwktpuzVQP3hgcqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739449647; c=relaxed/simple;
	bh=2/ziptVSftJTxOiPxsAZHgMACpPrpG4kNt4SO8n64w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDit3Dw4UIonLga7QSPcMrRIEzQPg8Bsi8ytKSDyaAvWCTm5eCUkZEebRpuyK/SqPkyXH2LgJOiXwPbEmrGwK7TcmGk4yIlWgdXgqIDLKdlsgpKJAFP2+oYnsw0XklrmeMRwCJzRphk0ND7Dm8s9DU5qfiHYeGDHSZR9sNgzbS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A29571756;
	Thu, 13 Feb 2025 04:27:45 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C05E3F6A8;
	Thu, 13 Feb 2025 04:27:24 -0800 (PST)
Date: Thu, 13 Feb 2025 12:27:19 +0000
From: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 09/11] arm64: Handle BRBE booting requirements
Message-ID: <20250213122719.GE235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-9-1c1300802385@kernel.org>
 <20250212121046.GB235556@e132581.arm.com>
 <CAL_JsqK7eBmRKL0AC99hj5AipL4jki5rrhSvbZCbUxa0vnEKMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK7eBmRKL0AC99hj5AipL4jki5rrhSvbZCbUxa0vnEKMg@mail.gmail.com>

On Wed, Feb 12, 2025 at 03:21:46PM -0600, Rob Herring wrote:

[...]

> > > +  - If the kernel is entered at EL1 and EL2 is present:
> > > +
> > > +    - BRBCR_EL2.CC (bit 3) must be initialised to 0b1.
> > > +    - BRBCR_EL2.MPRED (bit 4) must be initialised to 0b1.
> >
> > Should clarify BRBCR_EL2.TS to be initialised to 0b00 ?  Arm ARM
> > claims the reset behaviour of the TS field is unknown value.  The
> > assembly code below actually has initializes the TS field as zero.
> 
> Humm, we don't currently care what it is initialized to because the
> timestamp is never used. We would care in the future if we use
> timestamps. Will 0b00 be the only correct value? I'm not sure.

In initializaton phase, if set BRBCR_EL2.TS = 0b00, then the timestamp
will be decided by BRBCR_EL1.TS.  I expect the BRBE driver will always
write BRBCR_EL1.TS.

Thanks,
Leo
