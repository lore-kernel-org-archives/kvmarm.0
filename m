Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2E175A8B
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 20:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773694112; cv=none; b=OBCehvLrevWDvQeeT9sXOpEQ6AYn0fgyXkFa4BLi8ghA4rPYX1AE/bAoq7A0xtsJECgRh0uHJjYUfP0reouHWv5OgAVFNsg4fCsqCP7u4e3phEYtoN9R+Qe85UXcATA+QhBcIjuJCKwZlaHu70pqu9g+BZivK5AVE5Bx9pFCNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773694112; c=relaxed/simple;
	bh=x8NNm0rddGrZ7s85S7W2N+d9fX6iL3lbEEnK5hkjNKo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tiR3Qy10od2gu3Cmlki5UuC2s/krZs98B0uI8nhaiwCIaZReX51Qvi/ljewPs+KeV+5ncHRxEcyekqH1yPpBlcPCQ9nXrTbVg7y/4QT1o2PxIKpvb4dIlboAGRP66XV0rcHu+55TivNXdeTr4tv9wX3gic+lR8zLyjIy0FRv1fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=uIiIp6zO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AwEHKZXD; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="uIiIp6zO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AwEHKZXD"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 512941D002B8;
	Mon, 16 Mar 2026 16:48:30 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 16 Mar 2026 16:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773694110;
	 x=1773780510; bh=x8NNm0rddGrZ7s85S7W2N+d9fX6iL3lbEEnK5hkjNKo=; b=
	uIiIp6zO9qCGMBGibtesO0gim8ZrdBCuce4UVGOO1Uz6pFoASjFvq+5mp/t0QkXg
	a75Q+9/lJ0uURpvFqWscMf+WqLy5ebANf9hPEF8kixrFXgMANRuEhDz46cstwouL
	j6850J+wlv4r93VY6mzTfoVb5aXSpqs1nsePu8Ms0WhBBEOBDEJGiLv4YstDu67E
	yJ4pQpp37OT0bzH/pHDKc/0pKOpM66AVhybHQZigOOrf0rPmEC9TBkgMsyeTpXT6
	wDQkfeciIchTW0s1KevaCF8KiQGn9znhaZLd/BCCjsr/vIj7TrRBe2sOGecjhPf4
	Chwcu+F9DwKslxNRTDMNRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773694110; x=
	1773780510; bh=x8NNm0rddGrZ7s85S7W2N+d9fX6iL3lbEEnK5hkjNKo=; b=A
	wEHKZXDZhmFUWNp9h2jdIMena7uSg4atmB9h/QStHrkdJVaJrUCXrbaWKaVfS+zg
	f8lTZZC57u/axrWxKI8y+wbwn6kPDaYXA4wtiJ0oLQBsDlA7NudPAtt3zzVom/T2
	UA6JldIOHpXDgKUoLCzMSRSrh+sJO8U8VJsYKpdJvFLpFXvtzBCIsZ3qA1dY0/Yq
	sXrxbIYnOBT8zfaazNVyD9tgO/b/GnGkNy8qDaAd80BD5iKAGUBKkJ+axFxPpCQu
	NVOFH10s7PefMorJaNy6jhMqES0WcEQ6A5PauLiTRTGeia/S0tq3WzK7vjuXJ226
	EZjLWdo95ijqu2+EIVtDg==
X-ME-Sender: <xms:nWy4aR7VccMPdS1ykxqNdp5D41VdLK2V-Tm2OU1Cd98VR8EWrmsB7Q>
    <xme:nWy4aZuFJ9RIseAEiiHwRGC7omhGZqyH4QJZ5vdkVOnFgB_VpX02qyNF_Fy8wdTQP
    Z7boMBwdUnfYJ6qtjN7p3d44_vKloXwbxWcao4hDU3XZAyy_BolgK8b>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleelfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesrghnughrohhiugdrtghomhdprhgtph
    htthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohepvhguohhn
    nhgvfhhorhhtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehmrgiisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepkhhvmhgrrhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinh
    hugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:nWy4afjBi4j62K6R8olGevV4cKPgJ9I6_9NXW0Guse9dtQogPcXjjw>
    <xmx:nmy4aWHGs-Z-gQIJFqR1rrSdnJBRpK5I-Ikh_HCjNx01qAiEPrKnwA>
    <xmx:nmy4ae_4DDKGk7rsTuo7j-kpGO7eGlCuN2WtTXwXxw2_Hsdk-WG92Q>
    <xmx:nmy4adyy6UPCRZKtJuzIstISSjmNq3AuznXtU00X-ocad3NjD7hlQQ>
    <xmx:nmy4aaR1HVn9WAg9E3SnMIB9e8LeEj0sXwPzEqytMe-M47oBbdx7mg8F>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DF26470006D; Mon, 16 Mar 2026 16:48:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AI8tLlWNtG-B
Date: Mon, 16 Mar 2026 21:48:09 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Vincent Donnefort" <vdonnefort@google.com>,
 "Marc Zyngier" <maz@kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
 "Nathan Chancellor" <nathan@kernel.org>, linux-trace-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kernel-team@android.com
Message-Id: <501b2810-db63-4aa2-ac22-d3f1a99e9bfa@app.fastmail.com>
In-Reply-To: <6d40c8c0-f00a-4031-bd94-7c0a417eb0cf@app.fastmail.com>
References: <20260316092845.3367411-1-vdonnefort@google.com>
 <6d40c8c0-f00a-4031-bd94-7c0a417eb0cf@app.fastmail.com>
Subject: Re: [PATCH v3] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 16, 2026, at 21:47, Arnd Bergmann wrote:
>
> This needs "__kmsan" as well, for these symbols:
>

"__msan" of course, not "__kmsan".
