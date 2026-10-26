Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041741;
	b=CPYE0TVJef+G80W/rTAbLHj8AUVj2KaIL5XQ1jiqqGZ29P2Bvsl0rQJXrve08ypdv10b
	 D1+LvfzGWqOE+PSbInIHhCQlLWglre8ZaMkyDPHdHCwW4RTZXsLP7xRZqlbvFhtt2mnnj
	 44YU681yPrz8LkWLj65g4XijKRkrCe7uiAPfAwlZ4AGv3cWyys+wlgL/frEOSHJtycDYN
	 7TBd2ArmyVyqEExqRQ+WFzHASjCj5fldMp7PVnAk3RQoDEUutv97Paj3pkSg2C/OAcpPQ
	 2DXDllF31bJnRErL2AbjqyZpCAusYU0YcHc+Qs3g4HxvaC6QTAwptmpvhOe1Ney1LWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041741;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9Q3+v3GR7ZhEH6o1z10j/nYGlQFCqSiOFWl4b/lYCXY=;
	b=sgjiVawSDmf6hLgNwfCC7O5I6mEWqs9FSkXuyW7qRTtcr9Xg39YwF+Jyj4fh8JGDNNVo
	 6m02bhjMqisgKhSNmG530NW5mMmuFLD8h+gFHIo3sRnQznZy9YPGoXXkd3qsTSedANZhT
	 TssR+5p78U728pNFcWUxwrVsm5ARoyFD3//E/I+g0m1xlQSvWw/STqG+3tZK41P6GJ6v5
	 eEfTubJyEwIlTek6wz5OxC5HLSIvvpPrZyS1rS1SGJVBDQxW3jVZvhJYZBCie3ge0Xy+b
	 lx6n+695e8zU0pgMiEOwOJu4J4HtIU32+vkJm8Foo7z2/3oNEEKnw80TNoTzK021lMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jz1aYOFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1DD606A31A;
	Mon, 26 Oct 2026 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jz1aYOFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901031F01825;
	Mon, 26 Oct 2026 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793041740;
	bh=9Q3+v3GR7ZhEH6o1z10j/nYGlQFCqSiOFWl4b/lYCXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jz1aYOFBJsbfbEPwQpmnRudtsa80TD5qRFNVVS7AgOHc5hvYzADRoZlGJEDhhBxmR
	 zCSsxcpMkiEnbpW3nOco7+Pbad36IMfT3gJihWaLaS0UW0IXmKx5UtUpW9LR5RbuiL
	 rFV9eFb9xaPHWFakuPr6xjhFFijS+Z4wCdD/n6vL5bHTsx9i43LBhtoQTe8da+tiAL
	 x1+XsFelr9T4yiOhM0UUZTIZWJijssSK19m/UG/o8hk4kMEils2nhc6TPrxN7cTa9N
	 BhdA8CIXZKSKmg29OjyRfDkheBjDC8mQM7v3rBaRNzPWCfhCTBMTT0LOm1iN6iErJ0
	 oeEMbzoiE6j2g==
Date: Mon, 26 Oct 2026 12:08:59 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Message-ID: <at-lSy7H-K60LhCB@kernel.org>
References: <20261026144413.441566-1-leo.bras@arm.com>
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
In-Reply-To: <20261026144413.441566-1-leo.bras@arm.com>

On Mon, Oct 26, 2026 at 02:44:06PM +0000, Leonardo Bras wrote:
> When HAFDBS is enabled (VTCR_EL2.{HA,HD}={1,1}), having a DBM bit allows 
> hardware to promote a non-writable page to writable by setting (S2AP[1]=1),
> without having to take a fault.
> 
> The reason for this patchset is to add the DBM bit when setting-up writable 
> pages, so the code is prepared for future patches that make use of 
> HDBSS/HACDBS to accelerate dirty-tracking. Write-bit detection still 
> happens based only in S2AP[1], so no change in that aspect.
> 
> Having DBM set on block entries is undesired, as we benefit from the first 
> fault for splitting it in PAGE_SIZE entries, which is the granularity used 
> to track the dirty pages in KVM. So introduce a new walker that, on top of 
> clearing S2AP[1] for every entry, also clear DBM for block entries.
> 
> Also introduce a new VCPU request to reload Stage2, as it will be needed on 
> future HDBSS/HAFDBS patchsets. 
> 
> Please let me know of what do you think!

I'm pretty sure I shared this feedback before, but patches that enable
DBM do not make sense in isolation. We need a single series that
contains the DBM enablement as well as the corresponding HDBSS support.

> Changes since RFCv1:
> - Dropped patch #5 on enabling HAFDBS on non-dirty-tracking guests, as it 
>   proved to be counter-productive on wrprotect, contrary to expectations
> - No more moving writable-bit to DBM. That does not seem to be the intended 
>   use. It makes sense and it's easier to convert code to new DBM approach.

Sorry, where was this concluded?

The abstract permission flags need to have a WRITE an DIRTY state, which
we then map to hardware based on the capabilities of the system.

!FEAT_HAFDBS:

	DIRTY	=> S2AP[1]
	WRITE	=> S2AP[1]

FEAT_HAFDBS:

	DIRTY	=> S2AP[1]
	WRITE	=> DBM

Beyond making the whole HAFDBS easy to reason about, I want this for
FEAT_S2PIE which reimagines bit 7 as a literal dirty bit that can be
managed by software or hardware.

Thanks,
Oliver
