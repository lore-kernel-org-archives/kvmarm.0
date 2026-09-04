Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E1A3F0ABB;
	Fri,  4 Sep 2026 19:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788550214; cv=none; b=f5FPJy8/N+6nmBWpsOSxydeIuOnnmXwMCsYXmgOnpzntVT7qA0/IiUAXqGVcr4Ao+yv/p08nBNcXPnUhCTu0tN5d6s6I5Y8c8ZvKfKWid733Lm5GjAa3ExduSRRy5Idqd78lyswYetbLjuUJXAWAEHJjQeq91olDBXTD8cvlUDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788550214; c=relaxed/simple;
	bh=L5xdWyhhEkT68Y92M4hUoXa3BEgmRj9nUDWReYu4rjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaGQPiqA2ee3Y90gh3rOqzU+wNwczquiqZrups+YGYsZ6YZ9D4c5CVwSJ1NXFF4Hw6VY85CIpnhzuyKtaaMjVkseUkU6xamlv2lRtkV2krGqJFS7HHJoCuWEolX2AUXBU6e3VXFoBMhxgwmnXOlZdVdOgHqzd3ESQmDvlwN69Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=mYVblt/m; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="mYVblt/m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=bvMB2U+mHvhYmKOUk84q4l4veB5CHun/Nhwbht5t0VQ=; b=mYVblt/mAAyra51VokhjYJJ8+R
	Hv9sXtOe4/wUH4oTSqF3FhDvJRum1cEQIwK7YL182MN8nPu4hHW6Sp3Qy2iVYUL2PIN3GgUDIrbeF
	RDKNBZ/7dsR7X+b6Muba4/D2gSaOJypIjLrv1t9lI39FUDjeykIG5HkyQFD9aV71JCCI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1x2Zbr-0034X3-H7; Fri, 04 Sep 2026 21:29:59 +0200
Date: Fri, 4 Sep 2026 21:29:59 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] arm64: kvm: fix repeated word 'is' in comment
Message-ID: <6e2ccf7b-f9c3-42ca-9d10-5a3a8819cf7a@lunn.ch>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
 <20260904122445.31163-4-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904122445.31163-4-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 05:54:42PM +0530, Hemanth Selam wrote:
> Drop the second 'is', reported by checkpatch.pl as a possible repeated
> word.  Only touches a comment, no code changes.

I hope you are really looking at the sentence, understanding the
sentence, and then modifying the sentence based on your understanding,
not just removing the duplicate to make checkpatch happy.

You really do need to engage brain.

You also should consider that this checkpatch warning has been around
a while. Many of the real problems have already been fixed, so there
is probably a high false positive rate for this check. So you need to
be extra careful, or you are going to make things worse, not better.

"The the in this sentence is the subject."

If you looked back in the archives maybe a month, there was somebody
who get flamed for getting this sort of checkpatch fixup badly wrong.

    Andrew
