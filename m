Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569D54D8CE
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 07:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764918592; cv=none; b=FNWI0XP4qElCl5e3FCTfMKd3BrPUE9yJY91Y1wuK9VUDSfpQxCFPWTDBVFkYiO8BW930hgdws/aBhcF+8WZex/BzpASZYScVtmE3ONPL1hKX6vcKWKscdUSum2fP0qXdrVVLoslgAgQL20+qkg9olyzNKMkS896YuUNILTGfEyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764918592; c=relaxed/simple;
	bh=5rroxi3abUmGonf4pfj8UHKFzNzhHxxNOuDwgEGodAc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=t8pWfFfURkB0dvnMz/+He1u+tTPlwj1uT4sWgnqTRsAU7dFBH+ltzqam2p/O50kCkKV3IKV/C0SQgpRvpd7amAXAkvnrG/mq+bOCmiPlDlb+DVWg+/wFPBcIL3jug6t86yWCwopYPsE/7C2tRRvXmJp1q5kpYtXtl3KmOShm9Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=pR+SopcO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QFIYUk4G; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="pR+SopcO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QFIYUk4G"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1948614000C5;
	Fri,  5 Dec 2025 02:09:49 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Fri, 05 Dec 2025 02:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764918589;
	 x=1765004989; bh=QmdYGEfgv2myx16lov9/7CVEhKPUPcTa475udVNsp90=; b=
	pR+SopcOddt96sZj22fCQRcQZGiXPMJc1zI+6OnmaEa/FNXOtRTQYVgghdkMnoT9
	lGDOyhtVXbBHsg1c7sN061mgDTNsJDETDBCmTq5Z6Hi2E5UQS+hkf6SQ5oVYHAVX
	mq2ntKif5N15TvU1il6RcD/0chXcNHV2IpvNoVhGDu8vmYQBUHZKynkiR6U8d+IU
	ibP1S/u+Eol8BzTU12LLjO5o7eyXTiakzvSelRUhZN6ipAPDTuZQLUodJSMaG1hM
	AZr2CiO6rjmzBmQI6gJv/h00UVoPc3T/6xcgvUwli+FEUIdMyR3YqzLOreOjCgeS
	ySHOgyJKBFGIXbBF/jbTCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764918589; x=
	1765004989; bh=QmdYGEfgv2myx16lov9/7CVEhKPUPcTa475udVNsp90=; b=Q
	FIYUk4GKW6+hZsyUGKFBABL+SGjlfDwcCi2KK8CJcTd7pvD8izGkR1glwxBHTCT1
	XiwesSTZKCtbcVF9r5GI6SvnoISz6U19eBVKHkFI/qe9WyjsLN6thQ9lfzUjadM9
	AcnhQGpq8QukHm9miNWv+Vcc5UvRfnkNxdh6vTfeLmJw+lDHxKZMPMeqXHLsdOgv
	rhjNnrRwNKxP71P/9CASdSt6fgWwKWOhRyknlzoImYk5jUoojqF/ODhrSZjiuMXw
	iMK7T1RNc6uREuaNLNWGydIsxVEi0V2KknlFsY5ARq/WeVu2Usju25un3aD9msKz
	8oCmktTXtW9YTsEOrnnuw==
X-ME-Sender: <xms:O4UyaSzhdeTYAey0H6Uq4o1DYjrNzb4bkRpYygbI8vFjWq3BZV9xUA>
    <xme:O4UyaZE7ncY2zhBDt3TgVkfDfvSzjHEOKtLEAUyYzVrgHm5PK2E21KjiLM41q9Moc
    f5RLpQHfLLidnPE_NBbnl5SJmvHQDN00zJdeN2qogJOW-5iSkrTUjM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdejjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    ephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpth
    htohepjhhovgihrdhgohhulhihsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihukhhi
    rdhpohhulhhoshgvsegrrhhmrdgtohhmpdhrtghpthhtohephigrnhhghigttggttggtse
    hgmhgrihhlrdgtohhmpdhrtghpthhtohepphhrihhmvgdriigvnhhgsehhihhsihhlihgt
    ohhnrdgtohhmpdhrtghpthhtohepfigrnhhgiihhohhuudeshhhishhilhhitghonhdrtg
    homhdprhgtphhtthhopeiguhifvghiheeshhhurgifvghirdgtohhmpdhrtghpthhtohep
    hihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtohepmhgriieskhgvrh
    hnvghlrdhorhhg
X-ME-Proxy: <xmx:O4UyafngJPLFs7fyEnjKKoQ5kwNQARDl2dUNCDymmjbbGVUZHTeZTQ>
    <xmx:O4UyafjLCZ1lSQ9io6JMAgpThae_MzCOypWnRMo9pMWjH8H4KBjj4Q>
    <xmx:O4UyaZiL-jzcbGxYsahzlDsEZcfszIjx37SbMhK2uCWV48E61Aarsw>
    <xmx:O4UyaRvz_S024JAi1xJ1LN_4x9Qe8NtIVuKfk3qEhttj5JRCBZfCLg>
    <xmx:PYUyaelGkuw6dr-5gJWBTcBd3cWpIT97vnNbKVAqbOu5yDoZtgM3Zonl>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3DDDFC40054; Fri,  5 Dec 2025 02:09:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: ALjut8WcExBk
Date: Fri, 05 Dec 2025 08:09:18 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>, "Marc Zyngier" <maz@kernel.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, "Yicong Yang" <yangyccccc@gmail.com>,
 prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <007cc7c9-b466-4437-b113-cddd85599766@app.fastmail.com>
In-Reply-To: <734163cd-3692-3be2-9f2a-5364d9f5980c@hisilicon.com>
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
 <7d2ea8c6-e54f-4a57-843c-e0c6c33c02c5@app.fastmail.com>
 <734163cd-3692-3be2-9f2a-5364d9f5980c@hisilicon.com>
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Dec 5, 2025, at 07:47, Zhou Wang wrote:
> On 2025/11/27 23:37, Arnd Bergmann wrote:
>> On Thu, Nov 27, 2025, at 04:51, Zhou Wang wrote:
>> 
>> As I understand it, using ST64B is usually more efficient than
>> ST64BV if you can use either, since it is a normal posted bus
>> transaction rather than a synchronous atomic. If that works for
>> you, I think what we should plan for is to let you use ST64B
>> on this particular hardware and never support ST64BV from
>> userspace, the same way we do it on Intel hardware with ENQCMD.
>
> I missed the email as it has been filtered into other fold, my bad :(
> I think it works fine in our system. I planned to remove whole ST64BV
> support in next version, so what you suggested is not to export
> ST64BV to userspace?

Exactly: In line with how this works on x86, we'd always use
ST64B for userspace access to dedicated workqueues, or ST64BV0
for shared hardware workqueues, while ST64BV remains reserved
for in-kernel users.

>> As there are already CPUs out there that do include ST64BV0,
>> I think we also want to support those soon. Not having to
>> support both ST64BV and ST64BV0 from userspace makes it a lot
>> easier, but I think we'd still want to only enable ST64BV0
>> on a per-task base when mapping a shared workqueued into the
>> user address space on a task that has an active mm->iommu_mm.
>> 
>> If that makes sense to you, I can try to come up with a
>> prototype based on your current patches to add the context
>> switching and enable logic.
>
> I am OK with this, even though currently we do not have a real
> hardware to test ST64BV0 related codes.

Thanks for confirming!

        Arnd
