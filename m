Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288402;
	b=EfKmLH87qUGN8ZXfErd5gMGhbkJbloAIIq6vdEh3XBukAHqOMHw/I9GP3aEwlzwxFR1z
	 PxaiKtYuTWJJ1yCW4RtAQT0WeXHYr6JZu2VtyKP+f0aZN2henflAknHc6JcNUuEXFQpaP
	 Fso1LX9lCQ4HemdcBf2IDEFCdTWtqlCHSiyGFIhFtty71BvOdO/JF6FroQBg6IPysPt/u
	 RcyoDS/UtA7ZdgakT9xBUgWic2iWRCny5mVFN6lqLau56r1LHV7SUMC2iOr1RpAZKjci5
	 JGSwgDyrSM1XKhBYI0HVFWbKfKTYoHgeMhS5FR+SbhS9qvAYB81z5Zq+rbyibZFiPhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288402;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=YV+w23NqXtPUxzbWxdPwKnpLJ73OpZwUZwdP8XjSzow=;
	b=lq7wEqrsojiGui6NQDtkeF9u28CCcGwez3pODmYXGLaw/yhda5gZE25pschf5bwEwAgm
	 yYZMlZIVXe9lObf8+mp4hNkSKb78CzS03fNVk/6ldh/yJHyS1i1xQBDsp4/HbKwW5OPAR
	 U6divOWW1o1ok4uU2qCOFx0SdpBF1kcxgmsQgZOVquwzi09wgg2RFv6sckq/t+jleUhyi
	 j4DF/kBq4CpF8ueWxyR7yVp+UHT30btsVjau2sgFOdRWpOfBfyWbq8LmJHnvg4E3D9Lot
	 QJgM69KEJaBKEsPYuhLHp3AjnXw3Y9c4UqeB5XgGvRr4K2OnIExL3P++/uH3FqsAZ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JyiOShVY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E135D606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 15:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E135D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JyiOShVY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A780415A1;
	Thu, 29 Oct 2026 08:39:56 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86DD63F59E;
	Thu, 29 Oct 2026 08:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793288399; bh=u95ndNvigggwQi3q2TAN5S5kuUVT6f7RZYvAm5JASi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JyiOShVYAILhlWnkyYvD5iT4yzYZcgaleDs6rVnTCL0XV8eoq/EKzTkeMFkk7EzLe
	 VDykIKew6nPCqrzrFvebMQdYIjYQZgZuGgF3tMkvvHKjp3YaNK/kKA1mymjZ5ZhFkx
	 JMMcU8qmj+OR4wZPwHCR5UjOH1U+kf/+SH63Tnts=
Date: Thu, 29 Oct 2026 15:39:42 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jic23@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>, 
	James Clark <james.clark@linaro.org>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Thomas Huth <thuth@redhat.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <dhd5aaoxaeb43ili6bcr324gs5n7ziasssz4ttx6iprdso73at@jcwxs47m5wd6>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-5-weilin.chang@arm.com>
 <auM-TnZ0i_1G01ad@e143914.arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auM-TnZ0i_1G01ad@e143914.arm.com>

On Thu, Oct 29, 2026 at 12:38:38PM +0000, Joey Gouly wrote:
> On Thu, Sep 17, 2026 at 10:42:14PM +0100, Wei-Lin Chang wrote:
> > Feature dependencies of the fields in TCR_EL2 are extracted from
> > Registers.json of the BSD licenced AARCHMRS
> > (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).
> > 
> > Places where we slightly deviate from the above:
> > 
> >  - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only
> >    depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
> >    VMTE* definitions that we don't know the meaning of, as they aren't
> >    present in the ARM ARM yet.
> > 
> >  - Ignore TCR_EL2.DS's requirement of needing the effective value of
> >    TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
> >    and we don't have D128 support yet.
> > 
> >  - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
> >    from the json.
> 
> In the 2026-9 release, FEAT_ASID16 is now there for TCR_EL2.AS.
> Otherwise I think this matches the newer release.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks for the review!

I'm planning to update this series to the 2026-9 release and repost.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Joey

[...]
