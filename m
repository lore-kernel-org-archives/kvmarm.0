Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739131863C
	for <kvmarm@lists.linux.dev>; Wed,  8 May 2024 06:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715148904; cv=none; b=Jtb2tOLHyLHo7rE2uUm6m/IimBs9mkvvxU77HzH5gODZntfbeczJvINolubHaBJumG31hFkxtqxiq8Mk/naVl4v33OIh+V5xmAbudUQSmYhU0AyOmQGbRTUGC0kJ2h8f79D4ATnt5YSfCwd8GECMbhBd1+U/bel0P0sBkDDA82g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715148904; c=relaxed/simple;
	bh=mtDSMsUtt/3idd5pUySzpyO3AgWMdWbZDxRSF6AbJBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2a8kv8kYRyMUPwZtIvmIQhShQ9yZgI/1LS+k6CGlo1CJYuGH4dlBlNYWXoVHe04i0Qf149OC5V8mLZlYRDbkyhN38qHkLsGW8zj7Q9lCHAo3Nba3XeZ9GVxWNg/AobOcHW+yPyRWutqjBblZU0x/mF57yxzHnjMLu/uhkPiBM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuIupcO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuIupcO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F0C113CC;
	Wed,  8 May 2024 06:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715148904;
	bh=mtDSMsUtt/3idd5pUySzpyO3AgWMdWbZDxRSF6AbJBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuIupcO3aaxWnq1LTzYkk8pn0Cw0PHZP0gJULijgjEqKjyjsD+xfDMS6ckT3/PBYj
	 VHQpCRCRrfiiTdHsFYcLN1bbrVHoHUP5DJ6GLbiVmoY6M+ZAq5kxpsjp7NzQTbEfT6
	 bRUlI8bpDeADmNN2uzXfuGWmj4L9vEHMtN9ClpQW64kNgw8F5/qLsLPkNWci99IdAy
	 k3z/f/u46e0x4MwmMmRzutqBH+/ZL1pvlmHM/jBfgQJymmbJRKk8XEYHAs+Ifpovnb
	 tN9HFC6I255YtMYVqACRtC70kSxEXdabCFlaF1AEOnuFW7i8Cf0HGcV3UaKu8xQRsZ
	 GCv2vMV7ZECiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s4aZx-00BWzA-J9;
	Wed, 08 May 2024 07:15:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 0/2] Tweaks to the kvm-arm.mode= early cmdline parsing
Date: Wed,  8 May 2024 07:14:37 +0100
Message-Id: <171514886680.3505388.521926073176640387.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240501163400.15838-1-will@kernel.org>
References: <20240501163400.15838-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, will@kernel.org, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 May 2024 17:33:58 +0100, Will Deacon wrote:
> Here are a couple of tweaks to the early parsing of the 'kvm-arm.mode='
> cmdline option so that:
> 
>   1. kvm-arm.mode=nvhe overrides an earlier arm64_sw.hvhe=1 option
>   2. Protected KVM initialises in hVHE if VH is available in the CPU
> 
> This is useful for Android, where we'd like the default cmdline to work
> on all CPUs (i.e. with and without VH) but using hVHE by default where
> available and finally allowing nVHE to be forced by the bootloader
> appending additional arguments.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Fix hvhe/nvhe early alias parsing
      commit: 3c142f9d02b992aec5d96b82917e4cc07850c4df
[2/2] KVM: arm64: Use hVHE in pKVM by default on CPUs with VHE support
      commit: 5053c3f0519cd4c746577e3a6a7756f7c04b03dd

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


