Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B233D6F
	for <kvmarm@lists.linux.dev>; Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040590; cv=none; b=U74ziGYMaDLw3r6P/SIqXk4q/Id2cS0vK2XZB3rWIKqmcP6o+k8Wf8GSd2QLVrUChohd132iqwjFp7oOQCo/bWHus4xJePbq7AaiE87cyPvBBOHcRDXY2na7A5EEvRC/Pi4R2IUV1wvytvo4hdLVyGsxo/wf8PDfxmRCUSaPO6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040590; c=relaxed/simple;
	bh=5BpRwTddsBFl6oqWFX7gfeQH8tja4Kaghtjo7PeB38k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvZXoryPyy0trFsBDCUbH57STloHeln0gLOxRRUeJE70AcEX/8yRSPHx0iwCRF8iG94BYdUErfS4cJ/ZnXpeW2JhsP8gKNO+UZUpmCHOWqSpWPXwcQ0uPLtioh7Sr0C3W48oLtR562OTcPLdnRm4tTsu0tTDbksXgse4nizRwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnZiiitc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnZiiitc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E15C16AAE;
	Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040590;
	bh=5BpRwTddsBFl6oqWFX7gfeQH8tja4Kaghtjo7PeB38k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnZiiitckm+zMMklN93i/ILolsBGbfeN5AAFjCWBuSUSfwHNiUI1Ud80JnQsun8LS
	 v5EIUhb1gVylmu6LoZSwLjEw8pAxmjhW/Qk6wHUvIFIpSl4/LESGKE+9sswIdOGH3r
	 Ns1OXMtsu8vgrToq7YWK46uSJtHTanDV4uPyghVZYk7kg2+LuezH15Ry71n+2rFTax
	 8l7qOAgVBgZwJsOK/p7aELVeySnCBtSG4GIGTGrAx8VR3SMweMoXE51+NMeSgS4aea
	 Ekfu4rPoN6kQOD0RgiYVcNukVdmZR3Qu1ZbnSrhrQYv9BeirmPBE+xlpTZtokXsY3O
	 uXGGdtRMVGMPw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
Date: Sat, 10 Jan 2026 02:22:43 -0800
Message-ID: <176804045760.916140.17170975850498325021.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107124600.2736328-1-maz@kernel.org>
References: <20260107124600.2736328-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 07 Jan 2026 12:46:00 +0000, Marc Zyngier wrote:
> We set PSTATE.PAN to 1 on exiting from a guest if PAN support has
> been compiled in and that it exists on the HW. However, this is not
> necessarily correct.
> 
> In a nVHE configuration, there is no notion of PAN at EL2, so setting
> PSTATE.PAN to anything is pointless.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
      https://git.kernel.org/kvmarm/kvmarm/c/86364832ba6f

--
Best,
Oliver
