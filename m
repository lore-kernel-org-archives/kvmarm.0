Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B332DFA27;
	Tue, 16 Sep 2025 07:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758006132; cv=none; b=OUjPRu1tQVlK4q19IdEYoh9NwDjm8pvD5pMRpUyipW8lUw/u9ajjM2z8xwVpb4yp+ATnUY2Sq5X5LMW5Vvz9FHUl2PXpKYSiSchU7jO/OYETbu3Y/HnnCls3hsEoAyCAWig9hOU+AqVtLfWjk4GoOjorCXDTMQqQPdK6ALfv+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758006132; c=relaxed/simple;
	bh=Xg8cBggfQSTGIB5U3BG0pRcKHTipkZUKcPEXbd4rZo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxp/NwMYwFClT1/aFZYrpVQYZkAChUivl2bj8bOVe5IQqc/jPMPmLV5090OBLKC714d7nGcjb7bSCKdsuYW61RqubqrMrI09S9GfKc67DqlYBes236IPndarE+VKp915InHCZGRQXltK36i8Caf0qEMXA/OJ5IovKTHz8JvvNrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C410DC4CEEB;
	Tue, 16 Sep 2025 07:02:09 +0000 (UTC)
Date: Tue, 16 Sep 2025 08:02:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMkLb6jPiSbzeRWL@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMh4q4-xAPHnaOul@willie-the-truck>

On Mon, Sep 15, 2025 at 09:35:55PM +0100, Will Deacon wrote:
> On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> > On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > So I think it would be better to keep the current LLSC implementation
> > > in LSUI.
> > 
> > I think the code would look simpler with LL/SC but you can give it a try
> > and post the code sample here (not in a new series).
> 
> If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
> then you can do all the shifting/masking in C and I don't reckon it's
> that bad. It means we (a) get rid of exclusives, which is the whole
> point of this and (b) don't have to mess around with PAN.

We get rid of PAN toggling already since FEAT_LSUI introduces
LDTXR/STTXR. But, I'm all for CAS if it doesn't look too bad. Easier
I think if we do a get_user() of a u64 and combine it with the futex u32
while taking care of CPU endianness. All in a loop. Hopefully the
compiler is smart enough to reduce masking/or'ing to fewer instructions.

-- 
Catalin
