Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805FC199E94
	for <kvmarm@lists.linux.dev>; Sun, 26 Oct 2025 21:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761515984; cv=none; b=a3zOIsIOM8Bt8sgts6SDTBz4c+vwfP4D2lq1Ny2iHVDJrvAXYCy+Yb2IXTgQoRJXAlUcE7DBBcUCTCp0bMz/MWXxuDPPSnRBLaqTVq/OMpnB9gDgHAiPAbTA+3+nsBxoRIKbTsPR4BTDqBMwZLh6UdpZAfTbfDTA85mRM0j2uzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761515984; c=relaxed/simple;
	bh=NMIC2f3FmP6aEaK7nS7QQdzf7ARsXk5IdrfdHBig0wM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=dsqXzs7txwVmSkL2BS+DoJ80EPncsRK2LECiG9TWHobmDk8JWDG7skVBMkM/j9B+BKyXKsLy1JXa9JN+++QmMBbegDpblE3WVgan6LXyDr+b/s/M7Dr8XCJcJ1/lfoESthiJ8QYIdZbq53ZfKogAnYT7N8XKT3e2EPs8bvNfJjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=hAo0u0bA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GApIMUUi; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="hAo0u0bA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GApIMUUi"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 7132D1D0015C;
	Sun, 26 Oct 2025 17:59:41 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Sun, 26 Oct 2025 17:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761515981;
	 x=1761602381; bh=XRnrRsIDJEiLy6OrhPfi11tioUfF5lggVjHVpqrBJ10=; b=
	hAo0u0bAB3Y+Banwr+1EwwkJpswakbLs5PIM1B7ByckvYb1W6TGPCa1DcFOIYE/i
	5AywfTAX44+ihJ7iVGMtEGOY5zs7yuefaL4cyCHqnWXqBjzKSUmUxFBuLoh8J0lf
	HiGLUs9uLsbBogViCvDTZ4eX+76L9hI0VBST5PCZPoVzAVqmf1W8tXY8unkA13FR
	em4WS//ABHydC0/q6mOPYpsDLxCgaj6WNnlel53YbwAQ6vtVFRAmokVOnc+YIoqJ
	XjOfrcnfWyyCzsp/3ddlb9Iw/wVnJhbmoJLHuUfyGO+8daBpgNY2+PxXuiGWrFmO
	hYtgKOkpxmp4iVquh5G/mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761515981; x=
	1761602381; bh=XRnrRsIDJEiLy6OrhPfi11tioUfF5lggVjHVpqrBJ10=; b=G
	ApIMUUidX08IJL/o2Jx58pCjGxFfTl37cTqbpzP8Qor/BKWLTcmw1MnrJM6QaB+E
	BwoeBYYj/sTrPeYAPwTOGMWmnW9a0kWNLwV0U3i42Ii0SKeiIT6lP7e2WWovHt8C
	QpPL7NzUzJ6X2I/30V5z0jxTIBs5qzOnNb5QbxosHWWFSoHmRUs/CrwyZ7N54gRI
	Xw20u/4Gf9ZtBtL+Hzr70kUjmoK4zIxxL/sR9M7tSlvXtTAbIkHjyLKiVO4JVnCh
	yxaAyJcfFGD3ThpXdeqbCyc5PYc8gUVRTwAxawD4zg5TbFh4GsuTxAdYIZPE2Uxx
	3kDAJEUFe+hOnQpj1Ei7Q==
X-ME-Sender: <xms:zJn-aMlLSCmnFHEjV0AjwE9GRahdlG3sXk67vSQfHDwzjw_sMmPmIA>
    <xme:zJn-aGquuY7EsddGNzDl5ODHg5tjec2p_vtzMMFYp3yWuHmgntrVEWskvR2FsbEsl
    XXGzPMF4zASKE3K3j9TBpYp62KW0PiD4ZRGORIQ_Qnn19GEDmDP9rE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheeivdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfefhheetffduvdfgieeghfejtedvkeetkeejfeekkeelffejteevvdeghffhiefh
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgt
    phhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrthgrlhhinh
    drmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehjohgvhidrghhouhhlhies
    rghrmhdrtghomhdprhgtphhtthhopehsuhiiuhhkihdrphhouhhlohhsvgesrghrmhdrtg
    homhdprhgtphhtthhopeihrghnghihtggttggttgesghhmrghilhdrtghomhdprhgtphht
    thhopehprhhimhgvrdiivghngheshhhishhilhhitghonhdrtghomhdprhgtphhtthhope
    ifrghnghiihhhouhdusehhihhsihhlihgtohhnrdgtohhmpdhrtghpthhtohepgihufigv
    ihehsehhuhgrfigvihdrtghomhdprhgtphhtthhopeihuhiivghnghhhuhhisehhuhgrfi
    gvihdrtghomhdprhgtphhtthhopehmrgiisehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:zJn-aKbia00TsXVbN5P9yZkxKyDhMHUFZO8jUv8TE5aY6IdKUjMgbA>
    <xmx:zJn-aKHwQtdJVmSw6l2ISaF57UiCVKym_01Gc2BvuxkpxWNPxWoeIQ>
    <xmx:zJn-aI39CrhbNVsFwrSP1kcJj8REGaTHILIb6MPYKZq0pvW4-Yao7w>
    <xmx:zJn-aGyWPN7k_uNMxkpGl3meMMToznXjEYJhhKAuTUC7oRnekPrVwQ>
    <xmx:zZn-aD76qmSJmoVgmKAEXmVN0fT4RkIRptKSso1e7WCun2raXpUjFim9>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 82BF4700054; Sun, 26 Oct 2025 17:59:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: A5O6iWOKQdXk
Date: Sun, 26 Oct 2025 22:59:20 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 "Yicong Yang" <yangyccccc@gmail.com>, prime.zeng@hisilicon.com,
 xuwei5@huawei.com
Message-Id: <5b71830a-3e4c-4fd8-99b2-a3eb62b05ac4@app.fastmail.com>
In-Reply-To: <c29c67ce-8457-2545-ac1c-9ef00b92c7e4@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <2a880d79-9205-45d1-8f8d-9f028e0bbfb2@app.fastmail.com>
 <c29c67ce-8457-2545-ac1c-9ef00b92c7e4@hisilicon.com>
Subject: Re: [PATCH v6 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Oct 25, 2025, at 10:42, Zhou Wang wrote:
> On 2025/10/25 0:22, Arnd Bergmann wrote:
>> On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:
>>>
>>> [1] 
>>> https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/
>> 
>> The patches all look reasonable to me, but I notice that you forgot
>> to add your signoff below Yicong's, so the Arm maintainers won't be
>> able to merge the series.>
>> If nobody else has any comments on this version, please resend in
>> a couple of days with your signoff added to each patch.
>
> I will add my signoff in next version. In fact, comparing with v5, 
> there is little
> change, so I did not add my signoff.

Ok. Note that the Signoff is also needed when you just forward
patches without any changes, see part c of the DCO at

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

       Arnd
