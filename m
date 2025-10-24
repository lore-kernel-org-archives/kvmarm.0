Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D180336ED9
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322983; cv=none; b=FBlkkqxKRbCSL8iIeAwwY7PXzrpPXbn35HFynzdISnh0KyAYMp9RDTU7y5oPw7vunAOxyPUEOt8FDD310wV3RhzYaGdhLhGVYMLSAvhXhQkzAZcbBVJHl4xnviPrLJJBHDKMtza4j3so556vgNp+r6LZt14PaPmx0I1dPBigY3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322983; c=relaxed/simple;
	bh=jYxSqWsZlopjDrjqw0dqRCdRWwD6wNfb4WN6sgvrsu0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=K1can8KFOBSrPkBAcxPkm0aLCfZeWSr+xUfthTrMPwa61jmggY1GvsRzEmjilrfOC/4RKLWOHz5UCBIAKRlA5A9aNXRe9KkxPuuPy6JDmBXQrSwt4tTB66r2spkV9tdwIxN+SzoM+0GsFj4cArUXgP4mzygV9RvODyNM4e0UfBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=s4YJwyaZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=elmRRgnH; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="s4YJwyaZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="elmRRgnH"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id ED3491D00110;
	Fri, 24 Oct 2025 12:22:59 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 24 Oct 2025 12:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761322979;
	 x=1761409379; bh=DdhUPldP4zQaOwb8ou7nonQrk2OnNL7FtKo4nPpwiLY=; b=
	s4YJwyaZoDeRAmz+4Zi93QOJIa7ho0+3jAz/zoTieCw51vCgx+6G1Kaf/AfUMRXQ
	QcXSl3mIPUzCBO6GVhT0h38p/IQZmklkXEAOXlthy1BDLonDK6A6SRyGKfWKqVSf
	vC8+p1qaEB1yOaJ+lkX1S5HaQGSRi+Q7wCk3grwNFIMq3ddnUEeXwcGLDioAqNnn
	07j9YSk4ka2TexFoubqstTpm3XkLQKw9L+GGxJOIeKosnObuHSkq936UvQkVO2AP
	5dyRMmB33TYXS2cVueqPqf7C9XwjP3HLxaK7700PYqeNXyxrkQnq7/OVXhCrjC85
	dF6ZWNQpdTTREUdpwmhlHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761322979; x=
	1761409379; bh=DdhUPldP4zQaOwb8ou7nonQrk2OnNL7FtKo4nPpwiLY=; b=e
	lmRRgnHHFPzjWe99eerQSD/j/swGMwry/iA41RoZy+dCD7OHjx+tdwvzX+DClO4E
	J7P/BpTPOPUPN7Yk3AyZSEcRcSeZ9w8mu/h9rgEv61nHr9ccjkzoRFmuVJu0l+7a
	4EEUgEYGdJ86TJ872HF1r/drm+XVyHlwGQlgkvumNxMw0FN3JvX0k51YUBxzMNaR
	5RbNFyqBDned+EWR7Ikqs1f10hJ5w0uLajqxSauBqnQ9eFpF8h2737+PiM8C4Og9
	/DHg8d7xYR9NK03bJuKeLUToQy+9omsNh+VCvW//TQ1wDyz9zhiQXtkTTgjJdd7m
	QPBgnraZYEQg5vdizYJ+g==
X-ME-Sender: <xms:46f7aOBboAbf66p0rTSEPQaRvd4MjDrOcEbUTyTJzk8_1hXZQUFWZQ>
    <xme:46f7aDUy4bLeYlYlNWAuPB9GJwVsrdMTqoktxQSqnEU9Ka1iUPCNgpZroNX3C-Gh2
    891WNvTI0tAYHGzV4KRGqZMuxm1TT1PymKGkHZE2iQ9ZlRQGX19sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeelkeduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:46f7aO1LYhs6chjIcT3tTeRkGwiH3nJll92OUYMsvhEV50j3pKQcRQ>
    <xmx:46f7aNyNN4tnrfuteXPQCyb94X9PA7aoXGA27BciNMiULxGQ5YOcJA>
    <xmx:46f7aKzx2DgByTIMBui6oOsj9MoLF4w9JX4GgKxuKuSsGvJVfLz12w>
    <xmx:46f7aJ9h1a2simyVgk_w-un_Sc2PfTu6NXZPYNTfEyyGuUO2XOsCkQ>
    <xmx:46f7aH3qHWtpSaKipncW3TJmsbjw47tOukGH69NwGCOuPp1Xrh0DjBvU>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4ED56700054; Fri, 24 Oct 2025 12:22:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: A5O6iWOKQdXk
Date: Fri, 24 Oct 2025 18:22:03 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <2a880d79-9205-45d1-8f8d-9f028e0bbfb2@app.fastmail.com>
In-Reply-To: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 0/7] Add support for FEAT_{LS64, LS64_V} and related tests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:
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
>
> As Yicong has left HiSilicon, I will help to continue to upstream this patchset.
>
> [1] 
> https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/

The patches all look reasonable to me, but I notice that you forgot
to add your signoff below Yicong's, so the Arm maintainers won't be
able to merge the series.

If nobody else has any comments on this version, please resend in
a couple of days with your signoff added to each patch.

     Arnd
