Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F9230BD9
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257897; cv=none; b=SmtOXi9aatBWhGV0BCdouA1avZhU6TkiTXlhRG7XTtw1gRZdKzM28hLpeqQhGUQ619XDGkUfcdhTTJpi5faJiLy9NEYa1rWobcTjdez2t9R9MyoYGPxcp6/PCS6NYJFJIhGPLwOVtqWM7SvT5tAOg5Cnmf61tJPV8QllzzpFhHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257897; c=relaxed/simple;
	bh=TYaR+AERe/jyoxjtOiO8cRkdloXrgpNGRy0Ir5nwNCM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RRWC4vTIbTBy7hEyPM0oTgb0anvGCRUEUkZ+wcZAcIlSN2nhBsEZG9przcdbVB/G3eXETs0KR9GLK/awTEyR/zWyQYGr4sLpFN3Hrj0ENdG0CReqf8ZJ20L3Dz/hc0SEqOeW+CBYSA1Md7/xTvggyhupLO7S6CCtIniJRvahRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=MXUBqTnh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PktqK9pE; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="MXUBqTnh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PktqK9pE"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B7C0F7A0126;
	Thu, 27 Nov 2025 10:38:13 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Thu, 27 Nov 2025 10:38:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764257893;
	 x=1764344293; bh=dxIWjPBGhLqirusiYQWh0zD4NLTdP1tL9Ws8Ps5bJY8=; b=
	MXUBqTnhL80pbDYq2c9mJSiDZKB/Spt/2KRmSohMbMLBYzn7otF6j01dJXJEhBp1
	MXfpZy9jLFGHAD2iBmJ9p3g0TBNntTSbqIcxlNtjcQ3VStgsglYyY1BHAII+ZcTJ
	8Aqptn7bMfnuIt6bR2aqkhWrZkSYUBS8z1EZ8fJdX4Io5CUzBphp1UYTM8NBObVR
	BGICDy2Aqrc/fCgXULFFTChJi/x8TgMVeaHSW1Z0fs2xshFn8jg1KE0Hiwr8LA+B
	l6M+0Lgxhjj7PDQMdir3QNKRsP/NsMddheX3WpgilRffYHgRqQ7eJ/JVpi1A10eN
	iv6QBFZlyVDozuR8giluSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764257893; x=
	1764344293; bh=dxIWjPBGhLqirusiYQWh0zD4NLTdP1tL9Ws8Ps5bJY8=; b=P
	ktqK9pETnOqgA2r+v36e69n6z5F2YQ5NWM7ovRmwMC5r4Tn3LArx/aRqdvVKNA1g
	JyxLKsOBI06lRumrdOt7p1J0zkkqGRBJObiNai6TwrwNSqHD0fyOBzOKoP5IhKRE
	uw0fuJDVHQ31IcwACcIbByaI1Pm79Destz5TQJYksfoSIEmN6Q9LamFerst73epd
	tyc3SUo5qlKPbIYXX92Z2upoqnttlcIh6WBH4zu2FOOuJenm6k+e6LiNQsfqzqIz
	A86pcsfP0HRyxZjulz988xiJLDuCoTbdSZ7iDJt72S0tzZeqLtKkBuSlXmI5HGZp
	28IUaX6p39fpL4NfIiR0g==
X-ME-Sender: <xms:ZHAoaaBWlmXvpPv8MSs-ViZuwv-5vqcOpaWW2n3TKVlm18jD_Jgfkw>
    <xme:ZHAoafV15cnWaaVHjIyBZanelgMUNTY9W5apUslvyTh-Rvm3UyED6mKlTrwCXAsth
    uG9WYWkiNqAWyUQnm4B2XWR_4TCa2RP5qAXoOm05Hcx1eU48japlDd2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejiedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtg
    hpthhtohepjhhovgihrdhgohhulhihsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihu
    khhirdhpohhulhhoshgvsegrrhhmrdgtohhmpdhrtghpthhtohephigrnhhghigttggttg
    gtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepphhrihhmvgdriigvnhhgsehhihhsihhl
    ihgtohhnrdgtohhmpdhrtghpthhtohepfigrnhhgiihhohhuudeshhhishhilhhitghonh
    drtghomhdprhgtphhtthhopeiguhifvghiheeshhhurgifvghirdgtohhmpdhrtghpthht
    ohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtohepmhgriieskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:ZHAoaa0iIW4tV2GHXtFQgKhm_O7xU6GoRLsemfjPg3GBWiNeiuhLjA>
    <xmx:ZHAoaZx9abQzh8TTJQhzI1BzhcKLhjvX2y74ZMESs0htQjKC6RNo7g>
    <xmx:ZHAoaWyGgiX8XUpfe1fWyhV5qufRD5R3P5upuBoU17fPr1NfHuiu9w>
    <xmx:ZHAoaV83rm6bglzYST8WmbJ1q9usejJR9paY01u8L4q_zls_HG29Lg>
    <xmx:ZXAoaWhRIC9dggdsX3mrSi7-resIy4q8QxAt_ZDkVDFlb0QUv_5JdlzM>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 52CABC40054; Thu, 27 Nov 2025 10:38:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: ALjut8WcExBk
Date: Thu, 27 Nov 2025 16:37:42 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>, "Marc Zyngier" <maz@kernel.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, "Yicong Yang" <yangyccccc@gmail.com>,
 prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <7d2ea8c6-e54f-4a57-843c-e0c6c33c02c5@app.fastmail.com>
In-Reply-To: <e6cffbce-7cd4-3fe3-a9bd-935efedaebd0@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
 <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
 <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
 <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
 <113db0fb-d879-49d7-a5f2-7755558f29dd@app.fastmail.com>
 <6d6fad8d-e4e4-b973-6431-34a37003d363@hisilicon.com>
 <f641d3f2-dac9-4a9e-92a4-0805e6561418@app.fastmail.com>
 <e6cffbce-7cd4-3fe3-a9bd-935efedaebd0@hisilicon.com>
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Nov 27, 2025, at 04:51, Zhou Wang wrote:
> On 2025/11/18 15:36, Arnd Bergmann wrote:
>> On Tue, Nov 18, 2025, at 03:31, Zhou Wang wrote:
>>
>> The easiest setup I can think of that still supports your machine
>> would look something like:
>> 
>> - have the kernel choose between st64bv and st64bv0 at early boot,
>>   based on platform configuration, use st64bv0 by default if
>>   available in hardware and not disabled in EL3, EL2 or kernel
>>   command line.
>> - Change pasid handling in iommu_sva_bind_device() so drivers
>>   have to explicitly request one of the modes before establishing
>>   a pasid, refuse this on incompatible systems, update the
>>   three existing callers (idxd, amdxdna, uacce) accordingly.
>> - on systems with st64bv but no st64bv0, enable st64bv for
>>   all CPUs at boot time to avoid context switch overhead, but
>>   forbid mapping shared hardware workqueues into userspace.
>> - postpone full support for st64bv0 until we have a device that
>>   actually uses this and can be tested. I think most of it is
>>   already there in the iommu code, but the ACCDATA setup needs
>>   to be integrated into the switch_mm()/__switch_to() code
>>   and possibly a trap handler like on x86.
>
> Hi Arnd,
>
> Sorry for late to reply, I double checked with our SoC and device
> colleagues, currently only st64b has been used in our system.
>
> So I think we could upstream FEAT_LS64 firstly as it seems easy
> to be merged. After this, we continue to discuss FEAT_LS64V and
> FEAT_LS64_ACCDATA solution if there is a real system need them.

As I understand it, using ST64B is usually more efficient than
ST64BV if you can use either, since it is a normal posted bus
transaction rather than a synchronous atomic. If that works for
you, I think what we should plan for is to let you use ST64B
on this particular hardware and never support ST64BV from
userspace, the same way we do it on Intel hardware with ENQCMD.

As there are already CPUs out there that do include ST64BV0,
I think we also want to support those soon. Not having to
support both ST64BV and ST64BV0 from userspace makes it a lot
easier, but I think we'd still want to only enable ST64BV0
on a per-task base when mapping a shared workqueued into the
user address space on a task that has an active mm->iommu_mm.

If that makes sense to you, I can try to come up with a
prototype based on your current patches to add the context
switching and enable logic.

      Arnd
