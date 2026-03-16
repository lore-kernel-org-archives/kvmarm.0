Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93090225403
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 11:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773659232; cv=none; b=PKCZFm1BbAAKfpJyxXu+zWUhPfMheRRYCoayj50pQV6faFRBCiL1vDbUl5phFS2mhq/PwYFfl/wyI8jfR0ZhMQLg3vrHQMj/9uZQvZMwiDPJfC43m5zvIdXHguc8LqdYTKQmoEnGwmTohgQzbbEQlIr+oSAs/aj6AG3KCcTVzJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773659232; c=relaxed/simple;
	bh=i75Sow8HbIIzo40/nDORZAgG9BkCyBQqwP12TlYBFh0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RnusGcsP+TlAX2T2ikuouPHs8fN5ElkHrOSK+W76sEg2q81KLDa56THe3Q9pw5tePxSo3KFkACwnkZALYccZcU87DB4DrxKgv6Lcg9FK7EKUSP5Bj5ps0LgiWx13bH4Vz4WQAYFisFHKEKuDAy96A8f3u+F3Q1gOxPCJa6U1IDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=OCtzI+jc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OaHR5HL8; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="OCtzI+jc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OaHR5HL8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id BC1EE1D00173;
	Mon, 16 Mar 2026 07:07:08 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 16 Mar 2026 07:07:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773659228;
	 x=1773745628; bh=9dx//F81mWE20PzYSKPFNzQ2OKwplNE8lg1nI8s1nsg=; b=
	OCtzI+jciKwvS8qqbWSKBRvNuYV+0QAQGEUclHpgy7CwSREujG6AXkQtlginrJ8I
	wg61hKhUwZMKmAw0BGo2Nr2q1AggNcMVuMLNj6dPh8hIWn7nH8zSKHMZF1k4kHD8
	EKULFXKBnBkyiJ+3SQK6pPre7b0wjWVBbd6H6G5DHRSWNC71iXPCNPcByGzTDrZH
	6o73oHGdLizf51NeIxck+tLFM9TYTUf7C4+N0XNTtVvkGIfxMag+BPsTld+LDx8v
	MbTt1zHgi90kCJU3Dakwy2qnUQpuJTcAKSZyY+1QiZBS797v0nyr6bl/A+VuqWt9
	t7hryqWZBfhUntF5kzbFLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773659228; x=
	1773745628; bh=9dx//F81mWE20PzYSKPFNzQ2OKwplNE8lg1nI8s1nsg=; b=O
	aHR5HL8CUTgFpEvJLOf7X4Is80p/75iWfHWgSMrHs7t4GWtzWs9rMNazF6r/VWT+
	4fByr8rc4VbfTfwXwA04PLMKVrB+Wfi+REkUM/xmTRyVElKMNul1NjjElG8eb3zz
	D/fR9Jg0Rmm5+rsnk1BsyaomskinxtcdX9/5Dpu3s+CIDZ63r5zAIEU49osvcvkD
	FpNhUrwKBxAmGMa0O1DEjtFUSW6U9RfwVNnFp4HWteWuqDFOwLTa0hwBOZglTOjl
	dhykYr8Z8AIjxjuqxfbmuFBiSqHZwst3E90cJIUeBIISSg+O5t8bNKdzmTLRpC71
	48gtrDNkIwtmNY5kMimLg==
X-ME-Sender: <xms:XOS3aXg8n76t3qkWCmrZ6griuCXJ6pa6eM08io4D_YwgFr06gIrM0Q>
    <xme:XOS3ae1iT-RXfi6Vkm5PWoM34xd5jenr9uGgyco4DP3xt_hUEpA92aPxWLRD0pKh-
    fraci1snqw9mlU-CMAl0aNks8vZnENO3PsRTAKyJ-w2PqMeFyZXJ3Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleekvddvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:XOS3adKoWY80LJwBVsLPemcQ4psi7lKhFsMjOaPWUfVk9OhqnaL5pA>
    <xmx:XOS3aTPtvqa3cICT0y8BPy1CvmPuRyrotMsNe62dv0-7zy7SrKJNqQ>
    <xmx:XOS3aVksReHTHh5oQJIYu1_Vnn8Cx8GyP7Wct4_tNGJdOZW3HTmUFw>
    <xmx:XOS3af7SwK6PaiOqMUZrsAigTf2kNSYszTLjKie8eiWBfVrj0sI3Sw>
    <xmx:XOS3aZ7Rf2TLjD6qJTlmtN75t9XbLo1t7NR8tKABOjfyhY15xxnH_ovR>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1894570006A; Mon, 16 Mar 2026 07:07:08 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: AI8tLlWNtG-B
Date: Mon, 16 Mar 2026 12:06:47 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Vincent Donnefort" <vdonnefort@google.com>,
 "Marc Zyngier" <maz@kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
 "Nathan Chancellor" <nathan@kernel.org>, linux-trace-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kernel-team@android.com
Message-Id: <22092b76-8384-4374-a9d7-9b1d0793d46e@app.fastmail.com>
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

Added to my randconfig build setup now, I'll let you know if
any regressions remain.

      Arnd
