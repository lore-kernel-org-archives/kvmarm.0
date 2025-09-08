Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDD81EB5CE;
	Mon,  8 Sep 2025 14:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757342346; cv=none; b=OYAb3YacP1qUXvrqjsCpOGcrNVJHOzhSX0SsqBp+SkUEy1vuZTddNTgvAU5aT50/nyAVRznErz91TcW3lp0KMK+UAjV+9Lobfz5qVdR48+gTrBSF0xvtyorn7TOOtZ7m/Qw+Z6l5OeL6DbKYnD3qfqMyaOGL0CdoOL0StDt2Gv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757342346; c=relaxed/simple;
	bh=fo3RLTyhb+adys/SOtTG9n/0o2IcMmVHW/wAiLg65MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8ncuFHGawSOg4M9DHmeneQ2a6TOyRDZplurodwMc5YH03bHIm8IqGceWZLjHNRJXBZCtm4sufUWg7PUXllSA9UC7zRe2awB96/PqbdnaKhoSAoEFttHkQrY/LNWSYRUaWZ0jX5zi6mw7McOT5dHGGAlQh2HtjNODzH0XbdphWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OaFddIXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OaFddIXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37243C4CEF1;
	Mon,  8 Sep 2025 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757342345;
	bh=fo3RLTyhb+adys/SOtTG9n/0o2IcMmVHW/wAiLg65MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OaFddIXhCb8Zkuv1OCwkv/5KJxiaVgnjZNWZfU8ZYPk7HN3HSoGx1Yz2hC2r6SmkM
	 Di/FLf4YoVLva7I+yJz0T8DpJI0uoj+e3oDBtVoMNNFcDOMdGvLAHr1vXi9XdGk2X8
	 6SHdAQTigoo/DYXLWctawGcRUNOWZNBSegktWxWJNY91a0wKPqyirR5f7DWakD6arQ
	 nPqaM4RvzKly1uty/z1/TLcnwLfnN3+menpmIa+pz+iO4thhN0wPQFOFKInOJrYT/6
	 HiX5BaNpy+pcjG+K4xjIga+w7XT76EdxIvhpoO1X6y8PU/BJ/Ixd3DHQ2usn5mxlf7
	 pHBcCb8CZyiGA==
Date: Mon, 8 Sep 2025 15:38:58 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v11 2/6] KVM: arm64: Use SMCCC 1.2 for FF-A
 initialization and in host handler
Message-ID: <aL7qghmPfM3NMyMz@willie-the-truck>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
 <20250820-virtio-msg-ffa-v11-2-497ef43550a3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820-virtio-msg-ffa-v11-2-497ef43550a3@google.com>

On Wed, Aug 20, 2025 at 01:10:06AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> SMCCC 1.1 and prior allows four registers to be sent back as a result
> of an FF-A interface. SMCCC 1.2 increases the number of results that can
> be sent back to 8 and 16 for 32-bit and 64-bit SMC/HVCs respectively.
> 
> FF-A 1.0 references SMCCC 1.2 (reference [4] on page xi) and FF-A 1.2
> explicitly requires SMCCC 1.2 so it should be safe to use this version
> unconditionally. Moreover, it is simpler to implement FF-A features
> without having to worry about compatibility with SMCCC 1.1 and older.
> 
> SMCCC 1.2 requires that SMC32/HVC32 from aarch64 mode preserves x8-x30
> but given that there is no reliable way to distinguish 32-bit/64-bit
> calls, we assume SMC64 unconditionally. This has the benefit of being
> consistent with the handling of calls that are passed through, i.e., not
> proxied. (A cleaner solution will become available in FF-A 1.3.)
> 
> Update the FF-A initialization and host handler code to use SMCCC 1.2.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
>  arch/arm64/kvm/hyp/nvhe/ffa.c    | 193 +++++++++++++++++++++++++--------------
>  2 files changed, 125 insertions(+), 69 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
