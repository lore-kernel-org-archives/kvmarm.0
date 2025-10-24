Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B1A1E9B37
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761322752; cv=none; b=R2W6RMfOhZlSRnEfqnCNujYgpeS9VdEGcMOkViJsXkL5h7JHH6ZxFvwdKsHCkmRK6S8Ldd4f+4tf6fZ6pdRg2vXONEBbchb0cat5DSY01QjmGXpW2bDMOWvowYfYhQChQ6j7IkcPrB+m1oTPgiKtXsr7h0gOvEzVfCm9YOifrmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761322752; c=relaxed/simple;
	bh=Yg9+HfgxCP7OY3GdXZf7eHifJhdW6qKNd9sza6Oifww=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hzbFkayHMF587FQdayLaYaq4UOJihaAAtNURgrnOshGciXaJZNZXKxYJXooNNFPuwfSNCIumoK9GkbPQ9HRjcRW+fSdKlp14oSRu9ZqZqIPN6SGJMS4241BXEiqSF2bsGLnPyuT7QzLNLyyw1rHZ4kkaW6ANI74EN9XA2DTYbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Daw8D9gA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ekTc0xt+; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Daw8D9gA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ekTc0xt+"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4DF217A01BC;
	Fri, 24 Oct 2025 12:19:09 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 24 Oct 2025 12:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761322749;
	 x=1761409149; bh=/B9j9u5CYOzjuk3WgYBkiy0d65YUT+VZg4FbCq3cE+U=; b=
	Daw8D9gAqV1dR2nEcCsSSatqEzcQKAbQ56KUfgCxojvcHFRRgpCLtAptogEsdNLc
	G5f95sSs1CWJs7FGwt9a8Luox4N51C2QeqkGuWX43FBNx5MVgKvZiIBoDFsArJNn
	Wm8aUU1hXzcqVOx/XOdWdnoB37BOrgVoBniV00ICtCci9Nwr7tY5VfrzQyTsAbHu
	Kx6hPLE7w6BUybg4LW+GVWXjd3i5jd8E60FDatbN6kj2kHV9M3tCFM1DQCUBSJKB
	Bz98OP8zQrolLzdfBaOrca5UzPQr1BTsZ2HRljAcY79SsAHgQB757p3UmeqTvT1U
	6iZ+7yQSbRDNNzNMLkuaPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761322749; x=
	1761409149; bh=/B9j9u5CYOzjuk3WgYBkiy0d65YUT+VZg4FbCq3cE+U=; b=e
	kTc0xt+yhX628LsWHGPyqqLITkkSDoZ4pbpWgy+1+h3ni6P+uCy8GNGrioZjAk3N
	Q9G5f5/4hArGUtB3wg5CYcfafsXQOA/bSsAz3nFBNLh/JFiLZk4avX9UJX8fIXxp
	XWYEXpkin8T4Jv5TrkukvVeanY0uFKAqP1HieuhKY45WBE5QswVk3zmPpFlwvcCv
	KEjxzPMcymcle2NF6TdzmRDm4prkF7BhxZmvsb8M2ff8YTg57ef30VgxN044ekO3
	ZLPAWaGsXUekr9SGrR5PCNetPK0Gs4JT0w5oYbueJ7EMA0PJpAiEXhTkr8vDuFNp
	Ul7dajft6HmjtIydrwMiQ==
X-ME-Sender: <xms:_Kb7aFuPJD4a19HluDNkTB-z1MSw7oOcSQeS3nMU5z6OGDnWQ8reFg>
    <xme:_Kb7aJSfzzvpFvW9IKG8ndYKhLWYzjAXG8z_5d4MLS8_yRcReqC6nrNK6FC8Xb76Y
    t7YLB4xovJvIRcMPDyBqEGa1TBevtf1_szfueT7L9yPqLPPffT-7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeelkedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:_Kb7aNgfg33TYPPQEyJ0-ZH69Y3tbEngvsHIH6ujODsiDk14uhQa_w>
    <xmx:_Kb7aOvqOvi05xG9lCJDIFmxiAtBtuYHnH8lAuyLDesJJQsRByKg6Q>
    <xmx:_Kb7aA8Lt3Rwu4079IcGrTslskFUByRavFV9pGmSKVRGMlXSFkyuvA>
    <xmx:_Kb7aMYiefd54-VoqF8RXDQq178ER7g49XrzMdG39UhdZraHxl6MEg>
    <xmx:_ab7aO9P9blqNtpe3J54rkmS_gS89AmVEZp5HFM5eHqCLo5Azqqi6jro>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5C20B700054; Fri, 24 Oct 2025 12:19:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AmBleg0913uk
Date: Fri, 24 Oct 2025 18:18:18 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <e40ce220-e857-4ecf-985b-40407f99fcb3@app.fastmail.com>
In-Reply-To: <20251024090819.4097819-8-wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <20251024090819.4097819-8-wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 7/7] kselftest/arm64: Add HWCAP test for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:

> +static void ls64_sigill(void)
> +{
> +	struct sigaction ign, old;
> +	char src[64] __aligned(64) = { 1 };
> +
> +	/*
> +	 * LS64, LS64_V require target memory to be Device/Non-cacheable (if
> +	 * FEAT_LS64WB not supported) and the completer supports these
> +	 * instructions, otherwise we'll receive a SIGBUS. Since we are only
> +	 * testing the ABI here, so just ignore the SIGBUS and see if we can
> +	 * execute the instructions without receiving a SIGILL. Restore the
> +	 * handler of SIGBUS after this test.
> +	 */
> +	ign.sa_sigaction = ignore_signal;
> +	ign.sa_flags = SA_SIGINFO | SA_RESTART;
> +	sigemptyset(&ign.sa_mask);
> +	sigaction(SIGBUS, &ign, &old);
> +
> +	register void *xn asm ("x8") = src;
> +	register u64 xt_1 asm ("x0");
> +	register u64 __maybe_unused xt_2 asm ("x1");
> +	register u64 __maybe_unused xt_3 asm ("x2");
> +	register u64 __maybe_unused xt_4 asm ("x3");
> +	register u64 __maybe_unused xt_5 asm ("x4");
> +	register u64 __maybe_unused xt_6 asm ("x5");
> +	register u64 __maybe_unused xt_7 asm ("x6");
> +	register u64 __maybe_unused xt_8 asm ("x7");
> +
> +	/* LD64B x0, [x8] */
> +	asm volatile(".inst 0xf83fd100" : "=r" (xt_1) : "r" (xn));

Relying on the __maybe_unused register declaration seems a little
fragile, can you change this so that the inline asm specifies
all of the registers correctly as input/output arguments?

> +static void ls64_v_sigill(void)
> +{
> +	struct sigaction ign, old;
> +	char dst[64] __aligned(64);
> +
> +	/* See comment in ls64_sigill() */
> +	ign.sa_sigaction = ignore_signal;
> +	ign.sa_flags = SA_SIGINFO | SA_RESTART;
> +	sigemptyset(&ign.sa_mask);
> +	sigaction(SIGBUS, &ign, &old);
> +
> +	register void *xn asm ("x8") = dst;
> +	register u64 xt_1 asm ("x0") = 1;
> +	register u64 __maybe_unused xt_2 asm ("x1") = 2;
> +	register u64 __maybe_unused xt_3 asm ("x2") = 3;
> +	register u64 __maybe_unused xt_4 asm ("x3") = 4;
> +	register u64 __maybe_unused xt_5 asm ("x4") = 5;
> +	register u64 __maybe_unused xt_6 asm ("x5") = 6;
> +	register u64 __maybe_unused xt_7 asm ("x6") = 7;
> +	register u64 __maybe_unused xt_8 asm ("x7") = 8;
> +	register u64 st   asm ("x9");
> +
> +	/* ST64BV x9, x0, [x8] */
> +	asm volatile(".inst 0xf829b100" : "=r" (st) : "r" (xt_1), "r" (xn));
> +
> +	sigaction(SIGBUS, &old, NULL);

Is ST64BV expected to cause SIGBUS here, or should it return the
0xffffffffffffffff output to indicate an unsupported memory area?

     Arnd
