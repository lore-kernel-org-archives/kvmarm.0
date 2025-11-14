Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B7C307AD2
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763113055; cv=none; b=n7EGjNQUgSz/lFmSXxbnRA3mss7nlNwFZqxGwHXJqPCUw2RwgVvEdFpy5x74rRyoavozrfs5ccpPBMmmmuwJ7Pn46HeTeDyp2UWP5hqKO0XA9Z7SorgJY0Q+9GxzvyjNwAK6Vk/IijGRAFQX5I7uRRiEOZYjINJoEzdR3fF9wBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763113055; c=relaxed/simple;
	bh=jMayAiuXr4uJLVBXrajZ8ItHjuEufMqH59fcxhtrMU4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=V+QToyy7e6X6kT5SHPYg+i2Kvzv73IwQ7BoRGcF8SWZlcaTR+Mms9ERWP63kt7ULVloo8vTWODWlud7XQOD3NZK6GGDP8Yv3lkakymnKHSmvlT3Dc+1ztN+lZE/JiW0qlLHpO40bvT7ZmpWkXJ6xafe8bJV52o4PUZXjR5BneWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=XZaYKkvn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RhKSvZ/z; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="XZaYKkvn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RhKSvZ/z"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 33A0F1D00119;
	Fri, 14 Nov 2025 04:37:32 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 14 Nov 2025 04:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763113052;
	 x=1763199452; bh=soPqXnxmlCvPRKXbyW72z7/eSR3RnvsIJJJeiu3WxNI=; b=
	XZaYKkvnzXbl+K616mu3KywYGRPFf4lemWsF4R6HAj8GIJXRAMWsxEUjtvIy7o6X
	Qqw1H0Zyk1lMMOLouRKxzPgIodZveBiRz+eYgbLk+YQhxza/T7LWVi0XeIm1fL6y
	SEdwGvgN6oqNPdYo1mMPFjbzkywXx+AG9mKUPzV5o83TRpTLhFGKaVZGvEX/9a54
	upWXaz2zgI1z1oJau42wsiArYBpjSN+mLjmXsDkZQLOxRnJWEOc8kTyMxX9yuZIb
	cYKEwjaXGncAQdVsHB5KaKJLPEJI6zmG2mzHs6QysckO+OXssvWe80uGeXc040Ez
	fv1ivh0tuCDj8ngv62NJ5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763113052; x=
	1763199452; bh=soPqXnxmlCvPRKXbyW72z7/eSR3RnvsIJJJeiu3WxNI=; b=R
	hKSvZ/zjEOh3Gt5F3mIGsQK9FjZkibMCIJv13HZA0pGL9XRW6tve0qc3WWieqz9/
	98S5RCruS/b9/Gt8DYV15lhRhR+nwmmd9Fg+tqapS92KGfvN8ziP6PRkL06IqSMZ
	QGOku4MgtYAZVM4c4D8ve9OARJ/6Ya5cQBJcwQLSaiHw7ClE7DUhzbVrmS6Xz/Ar
	qCib+zlR2BOBht2AY5GvrVwdS5lK2AoSCB4j8RlgspLu2OklSV9TkSezkhWDNzns
	wSIhKizUmx7kCzGIBLMGyaJkFyGZ66gD2QfXPW5TbToXolnNLczWqRML6rJkSUGu
	Gkh7SNVph063qMcbvVH6Q==
X-ME-Sender: <xms:W_gWaXI0OiQ5UHBmOuB_fmLcBbLec-667X8vC3MJeXu2irRUyL5pUQ>
    <xme:W_gWaV-Ujci0l8P_upBBWVrrMs_tlM8eFo4FMvMjGaN629lBC0D8WwAzdCgzRR49c
    3cmwhR6rYbSSMKg2dGvqAtCoLXp3tyv2PGqsPXCSo0diT0MyU0qNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdelgeekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:W_gWaR-uy4htPZa4nGV_xz5fseSLAzF46ULPH1m4ZfAjg0Yzd_5KiQ>
    <xmx:W_gWaSZJZ7Emsz9uKR8Ys1YNxZm9rPGkK7o8Sst9beXjN6l-VO1I3w>
    <xmx:W_gWaS4sqDFW7YG3PICuSWFwNuMZItT-ZNYVMJBlE-kp1j6sS1yzFg>
    <xmx:W_gWafkWengLWJvoL__alMwekK3AdQ1wIzo8FFq5ARJ0MflOuEZl_Q>
    <xmx:XPgWaUWsuGJX-agTr_QIxB4AEOh8WSVjdKSSTC5vcPOviAKIIcUChm_4>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0EE85700054; Fri, 14 Nov 2025 04:37:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: ALjut8WcExBk
Date: Fri, 14 Nov 2025 10:37:09 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>, "Marc Zyngier" <maz@kernel.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, "Yicong Yang" <yangyccccc@gmail.com>,
 prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <113db0fb-d879-49d7-a5f2-7755558f29dd@app.fastmail.com>
In-Reply-To: <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
 <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
 <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
 <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Nov 14, 2025, at 10:25, Zhou Wang wrote:
> On 2025/11/14 0:26, Arnd Bergmann wrote:
>> 
>> Are you using a particular device, or are you trying to enable
>> the support in general? If you have a specific device you are
>> working on, does it use the PASID data or not?
>
> Many thanks for your careful explanation! I got the pointer here.
>
> We have a real device in our SoC, which supports LS64B/ST64B/ST64BV.
> For ST64BV, Our device just receives 64B data atomically, not interpret
> it with PASID data.

Ok, I see. So I assume this is either a kind of dedicated work queue
where the IOMMU PASID is set up in advance for the user MMIO area,
or it is a device that does not do any DMA at all, correct?

In this case, would the device also work correctly with ST64BV0 if
the ACCDATA register is fixed to a value of zero and you can only
use the upper 480 bits? Would it also work if there is an
unpredictable value in ACCDATA that may match the PASID of another
device used by the same process?

         Arnd
