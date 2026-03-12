Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580E399373;
	Thu, 12 Mar 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330332; cv=none; b=s78v20aBZfQuIF3gHjX18+XqQ7GXR9eOuGDM2D3DuTvkvQpd5ANMJF9avMVAfR6nK42U1vB6F7P+5FN7g5PpisIP8JaEcTPBM6H4fcs8e9FJXwQwwnapPkPgt1VP6803GX3bwRvF3HqL19BBBlRnU8uGR5Ew2dbHZX7/QqsK/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330332; c=relaxed/simple;
	bh=r4ecxK7RLvhzWNftWFyOdBdmsz/jUx8HG/r0fLOrUSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCvrLcrW6g5nx5gSM5CkJ0Sp185iIJPFVFya4EpgTczFubPNgwtCqhHcDqHriJ5pcE8p1rFWwiakw6NT/uFVgSSJxma0PT3PEkhMuRci7erd+P7Z/EW1wg0GqkN6h4cDnINCt1cdW4DzWRjDbRKfgMydwyDd4QriGYiuzux/ZWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHjniYvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHjniYvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2892BC4CEF7;
	Thu, 12 Mar 2026 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773330332;
	bh=r4ecxK7RLvhzWNftWFyOdBdmsz/jUx8HG/r0fLOrUSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHjniYvnm/uMgZW6+uciOd+tGvW104oPd5LLDNdjH4ntpnEkE8H2yhnZRdvquGp9J
	 eex7rnhO9Rso97s5HrRgfrzXrgSvRGx9VR9RfbkP1/2J6tJL3bCZnKjnKnEJ3Mdisn
	 GFHEkhqcR+FgcpsDnsng+GIVEAmZTm5Ha0Jd5ERntJTrg2nYz/f/SJ0hyjLS8+2GFJ
	 WuRd8/eaneaqtbuEl0nz0s5ZUd6vzD+tYSCHtlDe62pQIxpLE6hjWIEoAuks4LXRVp
	 tVWvYx9DIQfzCv/atbf6imG1Sx1rhKJWqXeq1Fgen0fODBtD/N/8tgnaYH9fZJXC67
	 DKN8VTne4Byvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w0iE5-00000001KVA-2ccN;
	Thu, 12 Mar 2026 15:45:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>,
	Arnd Bergmann <arnd@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 1/3] KVM: arm64: fix include path for ring buffer implementation
Date: Thu, 12 Mar 2026 15:45:26 +0000
Message-ID: <177333027972.824271.5682048908167993643.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260312123601.625063-1-arnd@kernel.org>
References: <20260312123601.625063-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: vdonnefort@google.com, arnd@kernel.org, rostedt@goodmis.org, oupton@kernel.org, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 12 Mar 2026 13:35:42 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The simple_ring_buffer.c file is in the source tree rather than
> generated at build time, so the include path is wrong when using
> separate object trees:
> 
> arch/arm64/kvm/hyp/nvhe/trace.c:16:10: fatal error: simple_ring_buffer.c: No such file or directory
>    16 | #include "simple_ring_buffer.c"
> 
> [...]

Applied to next, thanks!

[2/3] tracing: add more symbols to whitelist
      commit: 7e4b6c94300e355a72670c5b896ccc26ac312c63
[3/3] KVM: arm64: tracing: add ftrace dependency
      commit: 9e5dd49de5d82401e92098c03e0a0e978ddd515a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


