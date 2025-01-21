Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104271B85CA
	for <kvmarm@lists.linux.dev>; Tue, 21 Jan 2025 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737448867; cv=none; b=Rto+hxMl/S4FmrQEmpigxKFzxVzfeD/iwqA6ZrM1gUKdh+mfGR1dIBHqcUY36l6K9ho48uE44/CBLXnOQzq60MR/O8TqiUjd7tsKYJkFAI5AVK/ZVmKHyIWYFpv0b/+iG88Ewuyl9BkbCltWqSqF4HpK1udtSugOzNSTuG/xKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737448867; c=relaxed/simple;
	bh=ly915CsFIVxI/p5+bfchBNsCBHutAPPsxgSvZwYY+io=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGh42w/03O/yPIJAUrsqCPXSyUNxCwp41H/K+aPn3nrtoEECqBexMmzbJtgT2B6T3dMWhugl1vBRZOt/Q32IWlV8pmISHApp2w2+ptbshT9BO4+Lejp5PBW8fhcgcXQrB1ZFG+hfqdyxzNtY5VyR4hNlgCNBl9mKOH2QOhFZh5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GM3Jc218; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GM3Jc218"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78028C4CEDF;
	Tue, 21 Jan 2025 08:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737448866;
	bh=ly915CsFIVxI/p5+bfchBNsCBHutAPPsxgSvZwYY+io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GM3Jc218irhc3CXpNOYXaoLuY8Q4UuQBItakNCpI1IFBYH5En3E5+jChedYEyXGvX
	 PFJsHKv/0OwECreHK2xmnGT7iX+Itwematkp5ouhBv4rY1YpqiNf9uf6Eo5rtWE5SM
	 11T7I5AeFyjtvQP8oa+FcFjJknyBXgVpyGtjXJhChLcY3Tjuvs8CzVVZoGiZj+0ObI
	 oet50BNFLHUk9/M1duPCFG0vUdwHlNtxH/IhiYqWKRskol5fskHjfYvUPu+j8Iw4/I
	 8fpwFkQrMSNndgsm23AIhStCZFAidumWChO1Atgmr+CyghJtnFeSuNXRO9RJIZ7xMc
	 JC/JEm0BRRWMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ta9ol-00E0J4-5G;
	Tue, 21 Jan 2025 08:41:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Lokesh Vutla <lokeshvutla@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	sachinparekh@google.com
Subject: Re: [PATCH v2] KVM: arm64: Flush hyp bss section after initialization of variables in bss
Date: Tue, 21 Jan 2025 08:40:50 +0000
Message-Id: <173744884188.1663521.13719944692301643191.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250121044016.2219256-1-lokeshvutla@google.com>
References: <20250121044016.2219256-1-lokeshvutla@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, tabba@google.com, lokeshvutla@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, sachinparekh@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 21 Jan 2025 04:40:16 +0000, Lokesh Vutla wrote:
> To determine CPU features during initialization, the nVHE hypervisor
> utilizes sanitized values of the host's CPU features registers. These
> values, stored in u64 idaa64*_el1_sys_val variables are updated by the
> kvm_hyp_init_symbols() function at EL1. To ensure EL2 visibility with
> the MMU off, the data cache needs to be flushed after these updates.
> However, individually flushing each variable using
> kvm_flush_dcache_to_poc() is inefficient.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Flush hyp bss section after initialization of variables in bss
      commit: 9bcbb6104a344d3526e185ee1e7b985509914e90

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


