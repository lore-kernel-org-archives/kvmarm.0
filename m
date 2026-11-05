Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906921;
	b=nrr7/7CmXHGHL/LtHsumNFeC0lJTyu8LC+c5k8mPbjIU5/y1INIyaIUAzhLqLl8R/ezj
	 gsdcryqfih7IgfizkLwIi7QYvfiCUg2Y+qFcXFMukhOhJVPqdbKlc39QuVNxqV3vfLTK7
	 B7J3K/V2BzTd9M2+5TbzQ0iUZZ8yPTNVtOKBpuBOSCXL71/w4ZoN8P0pIVUswbvNHuMCc
	 aFnCDJsSYVBQWR76Xj+SfyEdm9XmccPwoWb0qYwCI1CD7gTFXVmXBgJilMVvO/8eyPcuT
	 KhqqmvF22S/jbXjniZRXsyECS7wGr0Ycwo3SOywJt1rEGFn6ikFXPvGqNS5TeVEFG1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906921;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kKaE2yjUItddwayqhFLc6/VrDJxfB6w63CQjP5urAJw=;
	b=YDkcjK252rshmJZdHSK4Z0fmV9FTzebY+yZDtT10hOtz8X/ftsctJqJlEKinNjklA8GJ
	 eK5Ey0BPox3Q5pJGo+U1jq3Nj1yu3wyWqw7AeYFvEfgpqy94ThL7vAbdyiyeHx8ZJnnwp
	 qKFJkAQLP3C7SeTqCcIUo246bbrp5ujfEU+OCDdmDB+38X8U6YcacFXMcJZCVwjtbaTN/
	 kP4tU2K4H2GSVSNaKQEtQjfH1iybEWfFxoUG6snGQD93YL+1/KW3VgNaYw56WSSDsH6Iy
	 /WJ69qTs4SmPIOG55XQhrES0XlFsblr452rhMOgDfgEWzOcr4EQRxhV76i9daP8P/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S01wnnpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8751606A326;
	Thu,  5 Nov 2026 19:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S01wnnpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E752F1F000C1;
	Thu,  5 Nov 2026 19:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906920;
	bh=kKaE2yjUItddwayqhFLc6/VrDJxfB6w63CQjP5urAJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S01wnnpfdcAvDRxUlG2/kuPzRhJwbOeTPHsEO0h1aRJnt2K1f991HVV8siyFWIa+2
	 7HpudfOQAGdVO7y6m9VBb5MKMlQHjlTCNSE+EllC147SHXC+kirGOhWz68m6QMxGVq
	 Kgx5o58Ho2Kfm7ADlJSI61TjnU/6ozzQouA9PbH38QTLSNr7j6kp6T3zfS3hyx64Dm
	 9vyGrPEIhO0RXjzwJxm9IHYsE2QOcY5IpYnN8Gqa2yVcB75aMPaV/kZhNtMtK9wAeH
	 36XpSG6NvM7Yl7LLf2blUsKT51bzsErXa24mf9BOu+QTtdnDoSRDCzLJ1YlT37OVjt
	 818FZjm26ttmg==
Date: Thu, 5 Nov 2026 19:28:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <auzYnfOQeB44niFy@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <auy-TwnMbIn-r2xl@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy-TwnMbIn-r2xl@gremlin>

On Thu, Nov 05, 2026 at 05:47:45PM +0000, Lorenzo Stoakes (ARM) wrote:
> Hi Alex,
>
> I've gone through all of the patches now, thank you for your patience with
> the review :)
>
> So there are various dependencies/architectural decisions that need to be
> made here to go from RFC -> non-RFC:
>
> 1. The 'Ignore MMU notifiers for guest_memfd-only memslots' patch [0] is a
>    hard dependency for the series. I chased over there, hopefully we can
>    get something landed there.

Sean has kindly put together a patch for this, which is now very simplified
given that a dependent fix has landed, so that's good news on that one :)

https://lore.kernel.org/all/auzSxEsGAcm3MYtN@google.com/

--
Cheers, Lorenzo
