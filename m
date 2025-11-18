Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5770A302167
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451452; cv=none; b=rx7dMIOte6rflHmpB4Bf5S9LnR2mNMTWAKXsOvy8gL2EqQU2nmxrU331ih+z8/JKgH1EOJ/P59y0flLW+aE9mpfWZgmci8eMTfmXob77DxZ81ml/tWYO0TuolQJmEs4z83RPET+s3ubA6x8A0b3CbQsY5QfStSLpWOXuWDBLKfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451452; c=relaxed/simple;
	bh=TgjY5H4ZBxHrbzJ2bkYkhPqwYpjQ/oQZAih2ce8s0bw=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QG4zs7kHUDl229SdqP368hOX9pOXgW3JBlf06dq9n700gx8SWSiorA6xw1DrRHAb3ka+m2nfuvz1yBQZBPg3HqDMCk1HuyLOl3cc82INbbUfH3CyUWFszr3z2/DmBfLRu5rr5EqwSteaCDSuug7PzGtNX+gRwm0/3EPeDZp5NR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=XSg4GWDY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=wAOhs6fX; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="XSg4GWDY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wAOhs6fX"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0E00F7A014E;
	Tue, 18 Nov 2025 02:37:28 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 18 Nov 2025 02:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1763451447;
	 x=1763537847; bh=4QiRiDhSqT4fLCQcU+UjOzbWSkk4b4aDS7SspI0AxSc=; b=
	XSg4GWDYB9Qc+u3oG85yZVloU4ekvHAIszyIEGREWA9NJLV543yh51rMlIN4eeYr
	ODZP0w80+qPQqtXv1dJdictPjMMXsLpmtD7Hy013qaY5xK/k0Xb/ZBC7okEBGiy3
	IwQrltZZ5picL5oe6HmlLTYcMpXJ0VmxEmRkStkqiyxO4EM87KVKoWKmnp/Q/RGI
	JQTVa23WxrALPM7XcYxG+4f7ANtzULfG/Ps2O6Uz316F54reXtrUgUrt2InHdmV7
	yZg4x6QzXmrWT2xg3KE5+Hc1ZkdnejkoRnrls2dpV03iPkrpOwJujkH/ZGela2Q0
	sKL3xFxVy4U1r4xF05w1fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763451447; x=
	1763537847; bh=4QiRiDhSqT4fLCQcU+UjOzbWSkk4b4aDS7SspI0AxSc=; b=w
	AOhs6fXp32kzvOJeVWTEwCUEZiDWRgq89k6AX6VszCxGkoAbunAAPK3Gx13K6Y9a
	oCvUBIS/0m8EApXiPVi4A+YhJLivudy7dKl2LYR9DMUIUjGY93KwRCjE8TxUzCOW
	7gL2VaTEmNLKU8pOdpjHUqT+dwcj3QUd2oT8S5tGSwlFR88MC9sVyvvuKcRn/dh1
	+ucX1OExpS0sJyay4r1G2emxGRuMR5pAM5UFEyFLP6b2Lzy8pxhaY9kU0Tcfl8na
	sxoAgthuSsij6jkOUU6fYUZg5TtSQh7O8pUstQwAWr/5PvdinoDOBmPcm36c17ED
	BzsadMqFNjxZDK7yt8zhw==
X-ME-Sender: <xms:NyIcafPkiVxBWIcFP8mNGDVcSmwiKdY3gZVUC0i1Nm1XaSxJOWVRKA>
    <xme:NyIcaUyh---jACwC8JUwEE3Z0E5RW-4aCSOl0XUhZEzSH_1rVZ49ZzUk-LYUeiduW
    2xDb5rNk8PVP60re3uEsnn03l8CJoZKFyqwEdXUyR0E9lx03KHs9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvddtjeeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:NyIcafAE5K7piy_7UkKxsRmEjUfhifMC-QFmcZRL6tgiwTqew32kAA>
    <xmx:NyIcaSMGcA57DGzU4LL7i4SwQPEL7IqsTR6yaz4sTIYDBknLL2oCSg>
    <xmx:NyIcaefxZ0f0R3TYY_SP5CKdrtrOpjoLx7_7WJDQIWZxPFgDVk3fDw>
    <xmx:NyIcab58UbuA_BO8MqQFM9tEdVFDyLGqf_EuKblPqofMFrlM7_Fr-Q>
    <xmx:NyIcaVhjDqK7MTDlEnhSrpcM3onA7hiYDDY1g48yS6oDOIA3ZghxIPJH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 09734700054; Tue, 18 Nov 2025 02:37:27 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: ALjut8WcExBk
Date: Tue, 18 Nov 2025 08:36:56 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>, "Marc Zyngier" <maz@kernel.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, "Yicong Yang" <yangyccccc@gmail.com>,
 prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <f641d3f2-dac9-4a9e-92a4-0805e6561418@app.fastmail.com>
In-Reply-To: <6d6fad8d-e4e4-b973-6431-34a37003d363@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
 <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
 <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
 <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
 <113db0fb-d879-49d7-a5f2-7755558f29dd@app.fastmail.com>
 <6d6fad8d-e4e4-b973-6431-34a37003d363@hisilicon.com>
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 18, 2025, at 03:31, Zhou Wang wrote:
> On 2025/11/14 17:37, Arnd Bergmann wrote:
>> On Fri, Nov 14, 2025, at 10:25, Zhou Wang wrote:
>>> On 2025/11/14 0:26, Arnd Bergmann wrote:
>>>>
>>>> Are you using a particular device, or are you trying to enable
>>>> the support in general? If you have a specific device you are
>>>> working on, does it use the PASID data or not?
>>>
>>> Many thanks for your careful explanation! I got the pointer here.
>>>
>>> We have a real device in our SoC, which supports LS64B/ST64B/ST64BV.
>>> For ST64BV, Our device just receives 64B data atomically, not interpret
>>> it with PASID data.
>> 
>> Ok, I see. So I assume this is either a kind of dedicated work queue
>> where the IOMMU PASID is set up in advance for the user MMIO area,
>
> Yeah, it is something like you mentioned above. MMIO area is binded with
> a work queue, a PASID is set up in advance for this work queue.

Ok, thanks for confirming.

>> or it is a device that does not do any DMA at all, correct?
>> 
>> In this case, would the device also work correctly with ST64BV0 if
>> the ACCDATA register is fixed to a value of zero and you can only
>> use the upper 480 bits? Would it also work if there is an
>> unpredictable value in ACCDATA that may match the PASID of another
>> device used by the same process?
>
> We do not support ST64BV0, so above case will not happen. I think ST64BV0
> will trigger a illegal instruction exception in our system.

At least this does make it easier because on your system you would
never run into a situation where you want to support both your
internal device with st64bv and another device with st64bv0.

The easiest setup I can think of that still supports your machine
would look something like:

- have the kernel choose between st64bv and st64bv0 at early boot,
  based on platform configuration, use st64bv0 by default if
  available in hardware and not disabled in EL3, EL2 or kernel
  command line.
- Change pasid handling in iommu_sva_bind_device() so drivers
  have to explicitly request one of the modes before establishing
  a pasid, refuse this on incompatible systems, update the
  three existing callers (idxd, amdxdna, uacce) accordingly.
- on systems with st64bv but no st64bv0, enable st64bv for
  all CPUs at boot time to avoid context switch overhead, but
  forbid mapping shared hardware workqueues into userspace.
- postpone full support for st64bv0 until we have a device that
  actually uses this and can be tested. I think most of it is
  already there in the iommu code, but the ACCDATA setup needs
  to be integrated into the switch_mm()/__switch_to() code
  and possibly a trap handler like on x86.

In the current architecture, both FEAT_LS64_V and
FEAT_LS64_ACCDATA are optional, so you can continue to
produce CPUs that have the former but not the latter, and
the logic above will keep that working. However this breaks
if you ever want to support FEAT_LS64_ACCDATA in a later
CPU but keep the existing driver working with st64bv.

       Arnd
