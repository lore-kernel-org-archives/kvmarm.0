Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA72264AB
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 20:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773694067; cv=none; b=nhRlDuKf6BOJTr+vjGqAGQypu6OmjvB1a4UHJ6AVjeWuV22vusyGCt8/lEBB/n1bHVZMELXXqiPMORIFhyPKIWHAS1uGL8Qbvp5n3HgnPbIzqIiALeT+uLRjjnqBSdm6LVQtwjsCxoae8IQht9F3U+e7fLdc69p2TURtwokzKR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773694067; c=relaxed/simple;
	bh=AX9fT2oSg517IceT/q8HDTzyQi5c1ne+n3RBp9mWc7Q=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eRWJHaHsZLAbaFsDg0w2AXGRqLz5Xd+z4yLZVuPdP5/1HmR8QK3CfTpQ/fuGPNwAmkJJargfHRuxCOfDLJGhey4aeNvPHsQFLTLi3ZM/QYlj7FUo8cDZIGomjiegRNyJXsrgMKiftZNY58fLmhIvSG2UvQxNv6/7cR25pfJtnGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=MNxTpFZ/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ITAA7F2f; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="MNxTpFZ/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ITAA7F2f"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A03757A025C;
	Mon, 16 Mar 2026 16:47:44 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 16 Mar 2026 16:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773694064;
	 x=1773780464; bh=FNSB0OmNCsHutd2/rm2/wsbBMecbJTrq7L6nBbt+bSg=; b=
	MNxTpFZ/UsS4p60QstXXz9zhL8tXiMjXrrxYCIMNv5qSjOh2HAZXpMTBs0HPKwt3
	rsgS0VwcWWz+3KK3oidoh8zRjROIqsjcJgHT0FeQE9pgulX2OckHJo60LO+nUvbn
	N2X0hNfDXiI51Gt+gPGFbJcoSUg87uf3minDBK2tfjgDWhnS1lJXR2LatR5L96xE
	XW8alxaUrjQ6sAZ4CXD94/X2roVpLKqn3RW1p56VUQ1hxACbAyhSaYY2Mt2uilnJ
	5Ng+TDXOockgtc5vDAZa3RdHMqhZoZYG/Mn5zF9E37QqK+pdxA2L+2FkMWhKFVz8
	TE2vm1D0TYak0Sd5d7nVEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773694064; x=
	1773780464; bh=FNSB0OmNCsHutd2/rm2/wsbBMecbJTrq7L6nBbt+bSg=; b=I
	TAA7F2flc7KsEeUFMlwUgq5CgMkC76f6G5WPOOafPAfewHR440o2gqjWfjPP/Ii8
	/7mCEsfOtYo6z3lWdDp78fRi3P6j3B5L1DZzLwk+8VNhZPkMY/SKwKdsJAiHOHH/
	KK3aK+fBYczeSQHIB0jvSbkcOarQBv+aDzsYuFgL3l+7So+GoIXSApUW6K/6audK
	OByJ4zdhanbRLj0NDxkhL5FkqRepyUg09QBStVIeOGWkL9WpSN9tTrzhvChk6Y0b
	pvr6WZtgGP2xJP8vJCVg/ZIng12BbwyxiB8KFAOGwgvtGLC2YXx/+yTM7aFutoUr
	9+RCh/zvJ/HfS/YGi2V5Q==
X-ME-Sender: <xms:cGy4afv8Gogyadhbv7Envm_s5pL2rIflRDoyFVAzVSJahJUVbOummA>
    <xme:cGy4abQMuu_imXhut-goANbNaoLU9TP_yJ4u78QfivKYhgPDnIDiCIJEs9hWotuGN
    nfJ4uudQ8U1PtC9A0axJBkSDoq5mfh5Tx1BMNrpH28AJqu-GHKfzZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleelfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesrghnughrohhiugdrtghomhdprhgtph
    htthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohepvhguohhn
    nhgvfhhorhhtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehmrgiisehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepkhhvmhgrrhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinh
    hugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:cGy4aZVtLlik54fOeczX4BXl1Dm-yBv9WsmWlhllthZLp4n0xX5ZVA>
    <xmx:cGy4aTrm4c-dBFmUXp8Iv_Xzg9Az5z0N6URDfHAdOfTSUHc2F0qy1w>
    <xmx:cGy4aVR-WXV3HJL_mDHyIRLqDDeT4psDWxcstcImxuUjiQb5MHY4Lg>
    <xmx:cGy4ad08czohvKFatwdo7CzH-18aElXO5peJTL98E542jFFzqy-fjA>
    <xmx:cGy4adHirsLuOzt9gGs5gYgN8oJWJR44hYSIpJSZ1Gr6VGI1YWynnm3T>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id EF49670006A; Mon, 16 Mar 2026 16:47:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AI8tLlWNtG-B
Date: Mon, 16 Mar 2026 21:47:23 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Vincent Donnefort" <vdonnefort@google.com>,
 "Marc Zyngier" <maz@kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
 "Nathan Chancellor" <nathan@kernel.org>, linux-trace-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kernel-team@android.com
Message-Id: <6d40c8c0-f00a-4031-bd94-7c0a417eb0cf@app.fastmail.com>
In-Reply-To: <20260316092845.3367411-1-vdonnefort@google.com>
References: <20260316092845.3367411-1-vdonnefort@google.com>
Subject: Re: [PATCH v3] tracing: Generate undef symbols allowlist for
 simple_ring_buffer
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Mar 16, 2026, at 10:28, Vincent Donnefort wrote:
> Compiler and tooling-generated symbols are difficult to maintain
> across all supported architectures. Make the allowlist more robust by
> replacing the harcoded list with a mechanism that automatically detects
> these symbols.
>
> This mechanism generates a C function designed to trigger common
> compiler-inserted symbols.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>

Tested-by: Arnd Bergmann <arnd@arndb.de>

A few hundred randconfig builds in, I came across a single build failure
that you missed:

> +UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov 
> __sanitizer __tsan __ubsan __x86_indirect_thunk \
> +		      simple_ring_buffer \

This needs "__kmsan" as well, for these symbols:

                 U __msan_chain_origin
                 U __msan_get_context_state
                 U __msan_instrument_asm_store
                 U __msan_metadata_ptr_for_load_4
                 U __msan_metadata_ptr_for_load_8
                 U __msan_metadata_ptr_for_store_4
                 U __msan_metadata_ptr_for_store_8
                 U __msan_warning

     Arnd
