Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35BA3A9623;
	Fri, 18 Sep 2026 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737894; cv=none; b=a87STBIohCBVGWgdKOXdzfvQrH8qhEeuwv9bYofTB/CGdrWtKgsIgHMCAXPLlZrXtwi1/u1AY8npEYmpVrPvppO6hn6KrgOw79s4CUiKpmOHwA8V2/hLbE/AjUcAn4SRDeyBbHML41mA7ikX3EcKhAtUofxiHi7I7jsQ/kCn1Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737894; c=relaxed/simple;
	bh=MRhI0mI11kgaitYzy4CQ3MeHqnt7ExWsX2e8Zdl1MwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoD66Kduk0YWm3DewuYFuZFhZDMoBLdqVeihXCg9RrAS6XMuc2xH37b2RliJ+f6GV6lraGg+6SSzEKU936C0t1kc11QunxWdH1RjtjLYqdq9jhe9gGySijInBGQjx9s/I3AF2EGzMwHcpqTc+zNYN3fygwQqYs4g0M88TTswAT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wzio8KE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wzio8KE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3F91F000FF;
	Fri, 18 Sep 2026 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789737892;
	bh=MRhI0mI11kgaitYzy4CQ3MeHqnt7ExWsX2e8Zdl1MwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wzio8KE1T0CrR6QvBoc9JJCxsOYMCQdBWtoonLvp5/Yk4l2hj4W7Tw0Zxw1bpVZkD
	 OuvssS9SdIXaERnW9MTMcl+4iFICFTlG40sWIaM4YRSgF1EXYUXJy04QNNtsFC/YJL
	 H1UH3xWSe2XIRSrgh5LsbPE5u/TbesP0Q73b5XqP/WYiQnyctKAZ+xivA1g9yBx9SW
	 0A151U/kXxpqGU+ve0oqKlxqkhr4AwSeaw6cUNSz9AUllX5f5+bCc+BDmhHKoBaz0h
	 1w784+j28IoIHJ9YfQ7T7TpysUHNUG7iT9ShW6LI/i/0kHetnFwLSJrl9RkcOZRYGY
	 X3SYdGN6h8yLQ==
Date: Fri, 18 Sep 2026 14:24:46 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, oupton@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com, steven.price@arm.com,
	vdonnefort@google.com, qperret@google.com
Subject: Re: [PATCH v3 15/18] KVM: arm64: Reject host access to protected VM
 private state
Message-ID: <aq07ngt4hV2gcz7y@willie-the-truck>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-16-fuad.tabba@linux.dev>
 <86a4ph5fb9.wl-maz@kernel.org>
 <CA+EHjTzCQkeXQQcCDwABLR2w+NTmKTG3V6RSmhzYNayaoYXw3g@mail.gmail.com>
 <865x045mke.wl-maz@kernel.org>
 <aq0628Ci4pfEj0KG@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0628Ci4pfEj0KG@willie-the-truck>

On Fri, Sep 18, 2026 at 02:21:31PM +0100, Will Deacon wrote:
> In our recent investigation, it turned out that both kvmtool and crosvm
> were perfectly happy with ONE_REG returning an error in normal operation
> but we needed a handful of fixes for kvmtool [1] to handle things like
> the 'debug' command.

... and here's the link I forgot:

[1] https://lore.kernel.org/all/20260831192406.1341841-2-fuad.tabba@linux.dev/

Will
