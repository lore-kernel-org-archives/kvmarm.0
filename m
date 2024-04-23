Received: from fhigh4-smtp.messagingengine.com (fhigh4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FEC50279
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713860715; cv=none; b=P7DMp0csV+NGcEApwqt7iQtbvZtQb5x2EK9fmPqF/zB0BouhBos87yOD0oJOOZZjyO0b+bX3477J0sB2KK8onYh0etb4Eh9iOaBxTW//26Ub59GtJSsZCVRkY2x5R+IHI5TqyN55sodFZBvE6q1V0WTE6Qwi43AK8k7V36ZDCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713860715; c=relaxed/simple;
	bh=YOQwmEQ3OKYOltcTnTIuJveOsHYPT9RcReX5fldj/AU=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=asptqS1jo0gb6TJk9r4pqDmzQm77LMo098QcOCjFlFmG1V/U8C9sTHUE+Sq621YX1yzdttpoKG9Ip3y+IKO+qCGh45kaDMs0gvGU/oZU9Eoe/8t6J2YuPAdr+ZWJ7QpJfpsZhtQ9aZnCEafO1JGP6vwhkJZMWjcQlwAL3qVQIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=moPIfHvq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X1b0WsSl; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="moPIfHvq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X1b0WsSl"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 2AECB1140118;
	Tue, 23 Apr 2024 04:25:12 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 23 Apr 2024 04:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713860712; x=1713947112; bh=YOQwmEQ3OK
	YOltcTnTIuJveOsHYPT9RcReX5fldj/AU=; b=moPIfHvqDIJn/A5L0IBZa3RAmk
	RvXImpm5Owevp859N1gWIZhINTLqHtOm2qFTCU7mlpkA4Lv7+np85vHUOj2+Y5rY
	rXYEvWFRFP+bS9rT9YJrhrA0u4MVdt0HZp8YlH1pMXKjnhU244TB+kqFuWxpp+H9
	9zwjivqwZwsxIxN+mA5dkzkMtMqqMhUflmtP0LbhcVNm4jBNMmPe9L/Hb1MBApSs
	r+12OZfFfqZPntcC7+W1g4zJXX1/rJ+oPmiKT75PhmBiSNYiyQjZzMvZEdE7jr7K
	N+VhEQsekgADTkfGmMFLEcgM4rgS8cji7wF/nwhexaYQBBt6c9Pn8vUOzBvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713860712; x=1713947112; bh=YOQwmEQ3OKYOltcTnTIuJveOsHYP
	T9RcReX5fldj/AU=; b=X1b0WsSlIbZtsp0Prpz/nv+JW5g7EoUTVI6dtlKU+z1J
	xVkLTKipfeNEHJNUdAqI1+xGoB3VoRy4EolwkdGPaZDuua1i2FayB8vG/nqjhb4Z
	2OPvt9/uMSp/bXL2gZftEb2mvg/U2aIbrj0TVErzR6Z0/7Pd3VTfQMcmtv1Hp8w/
	wYiHWzCgcB2ih/DqFwvEHENLR879mvNAJDx+/yJoOuMrukCkw8qo4JLP1G2WTw8K
	LLnjE22L1hJyoHypdO/LjkXP4my/jmAtkwID/9osxhisGxNzQQh8TL5oZF5qeUVj
	AmaqP2zSPv9I7GAWjoRa7mN188Zd6Hd9gCuNR/ZB2g==
X-ME-Sender: <xms:Z3AnZgrqMT8aW9CfXXmcKlEzjeG0m2qdND5Z8jXJ0V45nyVZkprtxA>
    <xme:Z3AnZmq-s3XKyuLE-cCP8vax5oR-6qA7uMoBEultkl7V02mTr0dWN5BsbpS8NnOjV
    i6dVwqtgtSBfsOeNtI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudeluddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Z3AnZlOnswe4msVfogOlRQifCe6RL6hSjVWmaTBimyHq6zBk5PK9Ew>
    <xmx:Z3AnZn48Oi_XN--zu14y1xPNfjt38IrIV-abbHAQ6o9K2Nedj9KNZQ>
    <xmx:Z3AnZv65kLI3CRXRH2yhWwF_PEjM_CzCWx9Q5-X0Mul5_ITN7qZPnw>
    <xmx:Z3AnZngByEnwjNykQ57VW6iJLPPzwxYYKjihhtTRz2UTxmcUCw-Bwg>
    <xmx:aHAnZjhiwTTMUUPunisfRKemsPFHBvYdXM_tcj-iFTKLUx_3sWq1xpg6>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 71B22B6008D; Tue, 23 Apr 2024 04:25:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-386-g4cb8e397f9-fm-20240415.001-g4cb8e397
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <fa6c31c5-9334-4248-aa89-a0951f1b13c6@app.fastmail.com>
In-Reply-To: <20240422224849.2238222-1-maz@kernel.org>
References: <20240422224849.2238222-1-maz@kernel.org>
Date: Tue, 23 Apr 2024 10:24:49 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: "James Morse" <james.morse@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Oliver Upton" <oliver.upton@linux.dev>, "Zenghui Yu" <yuzenghui@huawei.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Joey Gouly" <joey.gouly@arm.com>,
 "Will Deacon" <will@kernel.org>,
 "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Linaro Kernel Functional Testing" <lkft@linaro.org>
Subject: Re: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old
 toolchains
Content-Type: text/plain

On Tue, Apr 23, 2024, at 00:48, Marc Zyngier wrote:
> We still support GCC 8.x, and it appears that this toolchain
> does not understand "pauth" as a valid architectural extension.
> After all, it's only been 8 years since ARMv8.3 was released...

Just to clarify: I'm fairly sure that all supported toolchains
support ARMv8.3 and PACGA, the problem with ".arch_extension pauth\n"
seems to be that it was retroactively made an optional
feature for earlier architecture versions a few years after
ARMv8.3, so most binutils versions we support understand
pacga as an armv8.3 feature but reject the pauth name for the
extension.

> This results in the NV ERETAx code breaking the build, as it relies
> on this extention to make use of the PACGA instruction.
>
> Work around it by hand-assembling the instruction using a mind-bending
> trick lifted from an old patch by Will. Magic.
>
> Fixes: e09faab353a6 ("KVM: arm64: nv: Add emulation for ERETAx instructions")
> Reported-by: Linaro Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I usually try to enclose these in a version check like
"#if CONFIG_AS_VERSION >= 22800" so we can be sure we clean them up
whenever the minimum version changes, but I assume you'll remember
this one.

Acked-by: Arnd Bergmann <arnd@arndb.de>
