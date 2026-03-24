Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2206D370D66
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774347441; cv=none; b=qKZ58YvtzAQOwK1zjC10IfeSEiftGaHMINwk3RRADoKRxqeABMqMvB60kj+5ywjSDQcp4I/ZIen3twk1RdzuQDNZ9pcjarxywGl9vmlUK/nnM70QMMjXuFA6zr+UjNk5gEzXT2sYniYlPGvcLTaZfpdT6FpQnAYxUjpSG8gDO2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774347441; c=relaxed/simple;
	bh=FgwY3Ilx024m3dxmjnW0YuUkB48q182fe75ELNHakoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z31K+7DUUltR5nPSahLaQmqEC+GyX3v5WIa5TUMZrWn+WI746PpUkiA3TeFDOmLiTvieFZus8x8XfOIT7nazdzO7fO1XdItc7dcwbH4kdmKGeaGzOOm+g+g3ui2UjJCAhYZwpej8+5hMC87Bd5p4KUQuLdJhgerD+ky5r6OZYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/MEmNMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/MEmNMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E1EC2BCB1;
	Tue, 24 Mar 2026 10:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774347440;
	bh=FgwY3Ilx024m3dxmjnW0YuUkB48q182fe75ELNHakoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/MEmNMXFlWqTubX7nYMdWouXUB2tPSb8GrSVuoXQbaNj1Di4CuRZdTer2CmWRVxY
	 u2kohqOAe6ct71CpttzWuMA3OmN4XRckIwPhTGYBhBy+uy238w1IBL6lChIZPWwL+B
	 QbM+fRMv/EOxvyMdd/xUXctfaTC9DCSv2n3HOCqfyhEOJiicez6ul7P0oOdvrIuS95
	 sBZ3BIAlgwILYcyzpMHs+0WNUqTwBz+ZnxCj10+fpE7lyFfIyuedZoPAi9vMXn95RB
	 v+lDNq8FLO8KhQ0dXLLybY+/p/Zc7lkfGFz9MeHbEP0Y1BvcgRABSa6uWXh7mXpjLT
	 RnMh1+KzFZA0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4yp4-0000000573T-2FfK;
	Tue, 24 Mar 2026 10:17:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
Date: Tue, 24 Mar 2026 10:17:15 +0000
Message-ID: <177434741588.3191556.11695580866498467770.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323174642.3183075-1-maz@kernel.org>
References: <20260323174642.3183075-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 23 Mar 2026 17:46:42 +0000, Marc Zyngier wrote:
> set_id_regs creates a GIC3 guest when possible, and then proceeds
> to write the ID registers as if they were not affected by the presence
> of a GIC. As it turns out, ID_AA64PFR1_EL1 is the proof of the
> contrary.
> 
> KVM now makes a point in exposing the GIC support to the guest,
> no matter what userspace says (userspace such as QEMU is known to
> write silly things at times).
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
      commit: 2b821a6205b8b7fa7f0486507a63a46a06562a2d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


