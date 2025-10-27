Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64BB28682
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 06:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548306; cv=none; b=OjJ8vt7oyzTTa3N+06069mCr1ZK6drvOe1lFUlGU7nPBm0PJcZ+xfjCVDkH+/4w+PlP2bFzemd8cAD+Cq1AckKQDgUgJ86mv/LLwDBYgSto1WPn8lQPQ8oKMZLwPTPPxQaKzv2THVWs4FCgLrx0gGx81wsF3LnWwuaCs9w9r514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548306; c=relaxed/simple;
	bh=hDSiGNUZRyTvrOqWPBkaDmW457Wcg3lROhJN6dWvEHA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=AdH4SEcDoqE8ODJZvxdZXKT/lDVxkx4SDFwqCM/ku3TJfkavWKzH9JuWaEphPJsdvQJiaMkxLhq3SAAFLUbeUccJZ9SDM5Hxu5kgHMZUt5+b2Qted5h1aChgwcAWCmmTS+DANiyr3Rca5y9cXVgL1hUbaPtaCeAqKUkkSrs66zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=BA2jFPBp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MODKEAa0; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="BA2jFPBp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MODKEAa0"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 420237A00CD;
	Mon, 27 Oct 2025 02:58:22 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 27 Oct 2025 02:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761548302;
	 x=1761634702; bh=TmTyoUdAcbfsSgeatw+eIqzaDwggdz/+Vn7/9s4fE0w=; b=
	BA2jFPBp+gNQm0l4WpqAu5wAebGyS3bVNHqBoMQREqH9WvBF2dVOiVR2j3/ZSFGS
	Tc1O70rQI+XIMY2xFHvlBnoYXfRs1Jbs/cyi5fPtRqi0ABJeSo+MDX9KzF6ZAbKg
	g+hg7eJAnkayySALz3lbleji0XV9GowVh74yh7oPo/8V5MFlD5BRqGNFL6Wz8uk1
	4HgRxMzkTK8hy+qxRN7ZS33ET/HPlVu+737I/E2rnI9qZ6dqd4baFAigDjQO8bJF
	5ihEm4naY5Pct7lOYoTQCIt4PG+cFeAyPPajN4Uv9AVXq9aUu3+DAhEF3VR8dO3P
	zw8QtOE+vI5qh0kTd00gTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761548302; x=
	1761634702; bh=TmTyoUdAcbfsSgeatw+eIqzaDwggdz/+Vn7/9s4fE0w=; b=M
	ODKEAa072bS6j0c6+bHSScX4RxEVz4tgwYZIrDpv5E7kVIsG2Plyw5OFqvawewmE
	4XVQRZVvmfY+GcEwadyyVzMFMZfY3wIwx9uf7//3W72j895x3Saph7v1kpa0EH1v
	wrZWDXUCThJ83IT0dD0QjqL5PLgtdIGrgqIpNmKNUwXpTOLRU9s2KUPrb1L4xFUg
	4KyF2JDUPyoIo9RaBatG5+SMG2osp7wQM8j1s32ZlKckQT4ArVT6ESNZ0rtA7znM
	mFDxO/X50WwfEV8Bwhu0qPeBwQqDpHEIiRWNSYZYGbNOo+ACq8KdA4g3AWsUszXW
	kfxTMMLymKt1QaYcjICCg==
X-ME-Sender: <xms:DRj_aGuP5V2d4HYI-M89Zzot7TNitljCe5X2AMorox20krKLj5dH-A>
    <xme:DRj_aGQGyxU97X9_04LcgPv5I5hFRE7FXJjTBnYX7LGlm9W8_Wu9CCtr3DrEc6gZ0
    RC3rTxdfGK1lsKWenHXm0N-BRVUxmUXH3didFl1v5E6122_maq-RVE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejfeduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:DRj_aOgEvDebSyhu4vq3uQtubJuSE6HnsVv1KKq1_Wa5Bip2vyS6IA>
    <xmx:DRj_aLvSAGse4tHVN73fA7zEKkj4p4W9jFLSG0TW-ALkzmJOFs3KYA>
    <xmx:DRj_aJ-e_zSyLtPNZ0fvcrXZnyEyWUFWVYDERhSWcPTI4cMArvpX4Q>
    <xmx:DRj_aBZXs_NHb8N7DYpMT20ES0Tml5uypOYuzkKxSZuKhY5feJOo0g>
    <xmx:Dhj_aD_60EYjbJRj6S0X8ZFONRx8BxDT8kuu8id1WnT1PloT_ILQLk28>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6C3A0700054; Mon, 27 Oct 2025 02:58:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AmBleg0913uk
Date: Mon, 27 Oct 2025 07:57:39 +0100
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
Message-Id: <69c11f29-4cfa-4ec8-a9c7-f47337ac4c24@app.fastmail.com>
In-Reply-To: <0cdb8919-012e-c556-1082-63d44c6c7d97@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <20251024090819.4097819-8-wangzhou1@hisilicon.com>
 <e40ce220-e857-4ecf-985b-40407f99fcb3@app.fastmail.com>
 <752915f0-1085-b32e-f94c-c6c68dfa6cd4@hisilicon.com>
 <0cdb8919-012e-c556-1082-63d44c6c7d97@hisilicon.com>
Subject: Re: [PATCH v6 7/7] kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Oct 27, 2025, at 03:50, Zhou Wang wrote:
> On 2025/10/25 18:06, Zhou Wang wrote:
>> On 2025/10/25 0:18, Arnd Bergmann wrote:
>>> On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:
>>>
>>> Is ST64BV expected to cause SIGBUS here, or should it return the
>>> 0xffffffffffffffff output to indicate an unsupported memory area?
>> 
>> I think it should return 0xffffffffffffffff without an exception,
>
> My understanding above is wrong.
>
> As mentioned in C3.2.6 of ARM spec L.b:
>
> 1. "When the instructions access a memory type that is not one of the following,
>    a data abort for unsupported Exclusive or atomic access is generated"
>
> 2. "If the target memory location does not support the ST64BV or ST64BV0
>    instructions, then the register specified by <Xs> is set to 
> 0xFFFFFFFF_FFFFFFFF"
>
> Here the test code is the first case, so a fault should be triggered.

I see, my mistake.

     Arnd
