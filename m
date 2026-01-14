Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B902396B80;
	Wed, 14 Jan 2026 10:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768387907; cv=none; b=fF9mya+jnUCQX9FagXctuLw7ct3LEIa3BfbFmAMF9N4YVc2r1TS6gg7IwWU0Z5M1STNlpPxweOJ8/mxw7KJBtA99uwKif9iuekYxY+YFmOF708IluWHX0j5+cNFFiv7A4+Lp5jJ51x2Tipk9BsQDmlnl8AMRaejfINmNRHhtjZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768387907; c=relaxed/simple;
	bh=wSQt6iTfo1UGib9b417yObSp4mmt++JkZhlLk3sAcGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TiDM3NlaryePmKtHfvrzFhVaVhWGEcFcBa26TwyZAE4haK4qnpgYOKdnxoiOFwRO5fmW5rWy6aBSMLUfC8I+61QoX0BmcrDDrpJZmi7wRDL3oZJldLOOhZX5SbNfk4Sic8ne1ysxenJuZouFeRil6VblVTG7WT7wViiEvoUZezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KT1EsKq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KT1EsKq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78BFC4CEF7;
	Wed, 14 Jan 2026 10:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768387906;
	bh=wSQt6iTfo1UGib9b417yObSp4mmt++JkZhlLk3sAcGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT1EsKq4HelA+9mqCbB0nP9Xaa0Hf7XYTqCB10k4v6RkHiy3yUOM0K7z2rMr87leR
	 a/7DzFDzFPi2QFab8nswo2tStijl9NcBUHqgi9Y6IVUrfvf3uSpGtNPfOAhg3PL0hG
	 1zahwuWUU+NxnEVqZeNWI19p7QvOyQMUnD6jWOdZY+T3CjqCj5E1qBS5FSaMvs4mKo
	 sFRxMw+918rCwWENRrgHu2hDLkj6eBUkjg1pKhV//UlMrcG7r3Tk/IBBNn3hVEOux9
	 j3t0DB9cx3/xhn/TonPHDRLI4OG2FaplvzL1wASd+BXlc762diEFlIEb+FNhkhpojj
	 ghR5Y3S01uxZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vfyTY-00000002975-0nDK;
	Wed, 14 Jan 2026 10:51:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Petteri Kangaslampi <pekangas@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v2 0/1] KVM: arm64: Calculate hyp VA size only once
Date: Wed, 14 Jan 2026 10:51:37 +0000
Message-ID: <176838788525.3448059.9914160373754507949.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113194409.2970324-1-pekangas@google.com>
References: <20260113194409.2970324-1-pekangas@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, pekangas@google.com, vdonnefort@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 13 Jan 2026 19:44:08 +0000, Petteri Kangaslampi wrote:
> All,
> 
> Here's a reworked fix to keep VA size calculations consistent between
> the MMU and layout initialization code paths.
> 
> Previously, if the kernel was configured with a VA size of less than
> 48 bits (like happens in our environment), the assumptions used to
> calculate hyp_physvirt_offset in kvm_compute_layout() and the code
> that determines the VA size used in the rest of the system (calculated
> in kvm_mmu_init()) would get out of sync. This could eventually result
> in mapping failures.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Calculate hyp VA size only once
      commit: 8e8eb10c107e67f22f87cd8c963d30ea73f04d5f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


