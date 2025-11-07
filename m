Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6C29DB99
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762507460; cv=none; b=tP69q8S4k6X2tXJK23xJPPFJFxgyrkEeBBg6cyps3v+s7pesJ1vMEB4H/k1q5lGbLRQdLOcOoWPF+HDhbbRQ12TYMrPJSjJ/wDdOzoU18gHAfNzsmbqxXtr20c5bacXR/VK3kn62p3LlJFcA8Ef8y6UeGyVbFqP8vGq2FPwdNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762507460; c=relaxed/simple;
	bh=WXLYZjdNIAc53cyvhoLCqBoT3xBsNGuA3UcfR+WehSA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=AOj1/WGWv0k8h3Adh0tbpRdg07el56w5bGoOzPDPy5FBN3zuMNjK36QwjLF3RwLnzF5pA5yfpWVdIc3HM9At053O4uDbK5jZT7yWOCOAo54+PZsl2FxBmlZqTJ71LqQjDHn7PTLFq5WKMpHtN/TUY7pNyhtk89/EruDzI4si2Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=o7GqnUda; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=P6aW9IrO; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="o7GqnUda";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P6aW9IrO"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AD5B47A013D;
	Fri,  7 Nov 2025 04:24:17 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 07 Nov 2025 04:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762507457;
	 x=1762593857; bh=WXLYZjdNIAc53cyvhoLCqBoT3xBsNGuA3UcfR+WehSA=; b=
	o7GqnUda6vT7iuHPMYl8EPY6mkA+YFnte+d0RWsIcvgDBpucHJR7b+PZB0tmDP4q
	RNN0MWn6+IR+SZfO4T5XWwkSM77zue6T0pvfYJtxJskPLOK2d15afuGuHsf7rous
	FFAq9PSzFwMZnurhboZei4M0Zcv/bfUCqXtkubVPDXxR+yGNvhdlLNqvFnOkNZ0g
	3+GKR50TfkEGwVRrVZkiOeu4TJMySxnnrLCl8+g0vnI3Yp3xfv9FF6HixbCtJxl7
	ANAN1Y0sUWwz8ibd6yIFAjgEh3FxhtMgCdkdOWb5/Tj4b3D/eqRzJhQjGvx3nWBG
	AbAQeYfSB4bGVetK2mKxqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762507457; x=
	1762593857; bh=WXLYZjdNIAc53cyvhoLCqBoT3xBsNGuA3UcfR+WehSA=; b=P
	6aW9IrOqvsFoFFL6lRZdeN4+DIUNr2lRpDW1gck+LH8W6hCkREykM1narI5ZFvB3
	hKXhb6ETNvw9DvQ88btJOcm2R+z3ULk5k95GgjAu/8+v0e4stYYVNs9maRRMWn5k
	OL7FzHdsJUObCvDwGno4cz0cobb7rw9z7GgtjKTwge0bW+thWWMmt3Xm7SkTbSLr
	t+McB4wRs4a8pHwkxiDYJukxP/BWkMvDOZE1ZiJ2tZ21Fx2T2rWhny80Eyy7xL6m
	e27UkkahD6FGI1Q946ZfRmgg22cEtd1PdZwtcq0PNghTA9fBf3NlVzVAQIeDnShU
	Wet75uUjlwIi1Ljfy1kFQ==
X-ME-Sender: <xms:wboNaTzlwxBdy25KrbgmilwYo9DpIGlP6Nhy7MZ499CoTRQPSeiQ5Q>
    <xme:wboNaWFWO1oS95K5fLtecKum3gxOA2HhC715ncZopGvIwvCFHjnJKlJiVIrueb4FN
    -dtIx0RbxXF2fruZLWnx4vt1YIWfsyz8tRsyGOta-tGTh3_fqF5SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeelvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtg
    hpthhtohepjhhovgihrdhgohhulhihsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihu
    khhirdhpohhulhhoshgvsegrrhhmrdgtohhmpdhrtghpthhtohephigrnhhghigttggttg
    gtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepphhrihhmvgdriigvnhhgsehhihhsihhl
    ihgtohhnrdgtohhmpdhrtghpthhtohepfigrnhhgiihhohhuudeshhhishhilhhitghonh
    drtghomhdprhgtphhtthhopeiguhifvghiheeshhhurgifvghirdgtohhmpdhrtghpthht
    ohephihuiigvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtohepmhgriieskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:wboNaQkK9BRr8iZsczj8x9KX8NboyLz8JDP29VSIW5fNZOxWm29FoQ>
    <xmx:wboNacin4kg4K_Hn1Rtcg3X3cHbcHzjS2rFQvGtxytYg2_0SeItpLw>
    <xmx:wboNaSgDjUEYGUsg6Jl7BEZ_VbAPo0IC5qnsZR-WH1NYJwia2Hm0ZQ>
    <xmx:wboNaWs7htAePw6k09arZlR3KG5kPP8-DAtQ4yLNj90U8c4dX0DHWw>
    <xmx:wboNaXnMXSdQRWJnW6gFNjexcT7L5e1CuEHktQQUv2fdDd_iDs2IqLoB>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 22D0F700054; Fri,  7 Nov 2025 04:24:17 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: A5KJubIeX4vZ
Date: Fri, 07 Nov 2025 10:23:56 +0100
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
Message-Id: <084ff83c-8bb7-45ea-9ae3-1d17be913c09@app.fastmail.com>
In-Reply-To: <20251107072127.448953-1-wangzhou1@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Nov 7, 2025, at 08:21, Zhou Wang wrote:
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
> - Add identifying and enabling in the cpufeature list
> - Expose the support of these features to userspace through HWCAP3 and cpuinfo
> - Add related hwcap test
> - Handle the trap of unsupported memory (normal/uncacheable) access in a VM
>
> A real scenario for this feature is that the userspace driver can make use of
> this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
> directly into the hardware.
>
> Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
> MMIO and the introduce of KVM_EXIT_ARM_LDST64B.

This all looks good to me now, no further comments from my side,
and I hope we can get this into the next kernel.

Thanks a lot for taking care of this!

Acked-by: Arnd Bergmann <arnd@arndb.de>
