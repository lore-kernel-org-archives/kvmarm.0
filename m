Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7951F8AD4
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736335812; cv=none; b=aJRLJwpB9Be1+njoeCGhBPQDpbzHrHF3HKhxEINte5Q2a+6qH9jxILiFeUkdVM3NDnF6UDnVVL+bz5aeaW/AfN+kfZu2P4vqE+64RascNFe/tr/gQNhc3Jd88cRISizxckoWfxkdwpidFWhhAxtLlEJ+Pkg7MWJ/AX24NmYYE2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736335812; c=relaxed/simple;
	bh=DL3L7wjt7m6xdNDVzlXZ9DBHuhuce+VBHCyYTQJC1Ww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4Z21f4fEjc7u/GycaHOG42PJXxtcf7r0m6SeSL/L4etLh7F20fds6Ai2+kZ+YmSv1bTzCn0HvRJigW17x8B0vrGyiv09D3/FFI83yRY+1qG9jrHeV5FfCCaRP1CihX98T437VsJ4nyNl5NfCcJzCoCAbTpTrKEmQgtM7UjQUV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVDm1pnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVDm1pnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3543C4CEDD;
	Wed,  8 Jan 2025 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736335811;
	bh=DL3L7wjt7m6xdNDVzlXZ9DBHuhuce+VBHCyYTQJC1Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVDm1pnX1RQb4afCymYc5xUYmMusPfPRyUVEqW6Dr/4Jt3o3Nittan7+T6aZqsW2V
	 xT9ig9U3fNXGbszcP+dptmHQZOQf2TMarjcHf7QbpTAd9phMefFyMT0lveVLZ6hzfc
	 hpNBttVCZNrT6iFDF/lTPoXm9Y+Q6UOcNK2sW/P6VGrkhfVGGl4o4/dAf3IArq/yCo
	 zR6x5OWbWmdULLoGoAJqvlEJ6Oo8Q5EkrZWsWuIoy1+fhkueUqOET3WkyuBAbyZE36
	 EGYvH09pQHuOMEZK8hLO4D9TwG+bbN9gxa7t+7x61kCFoe1HGzEy8EZKCGnQm8nMNA
	 fKfusmfMNJmAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tVUGG-00A7YQ-HV;
	Wed, 08 Jan 2025 11:30:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	zenghui.yu@linux.dev,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: Fix nVHE stacktrace VA bits mask
Date: Wed,  8 Jan 2025 11:30:05 +0000
Message-Id: <173633579701.13074.16597350364665610752.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250107112821.416591-1-vdonnefort@google.com>
References: <20250107112821.416591-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, vdonnefort@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, zenghui.yu@linux.dev, kvmarm@lists.linux.dev, kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Jan 2025 11:28:21 +0000, Vincent Donnefort wrote:
> The hypervisor VA space size depends on both the ID map's
> (IDMAP_VA_BITS) and the kernel stage-1 (VA_BITS). However, the
> hypervisor stacktrace decoding is solely relying on VA_BITS. This is
> especially an issue when VA_BITS < IDMAP_VA_BITS (i.e. VA_BITS is
> 39-bit): the hypervisor may have addresses bigger than the stacktrace is
> masking.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix nVHE stacktrace VA bits mask
      commit: 68344037b764401f751c66661c53334ea1e15324

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


