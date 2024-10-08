Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1EF18CC12;
	Tue,  8 Oct 2024 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389134; cv=none; b=BX0UUzX0aMXoVl/QjEX3pWdl+iNJjO8ucAJp9LhY8ZJSgbd6bW2p8kiefaNgN3F7W2q8LLO/VWdRHeDMI+Dk8L0fqNjBgKWgvi1LkeZdFZDzrWiV/wv0KPBturwp2yf4NpAqp+LQ6bv8+ToiEkL9aZzWbiAXbiuTlBnsi1YSznw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389134; c=relaxed/simple;
	bh=FzhG8txh91SiqhRWcLB+yGiyTCgay6J723Fzbpcn0Mw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzYSxqbHvHd93bq5pgWii6c8Sm7c+oAbJLVkAxpVmgHm5AGpuoLmH2O1ElugjPmPQLUOjv2N9oxuQuhu42JTT4xgN170m84fJcXoctjN7I78oYGqI30TKaFn2fes6J9O+ZHmo9s1odBKMvGyGSIwz4yc6jC1/AcVvC3StkPkYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpPskTmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpPskTmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8591BC4CECC;
	Tue,  8 Oct 2024 12:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728389133;
	bh=FzhG8txh91SiqhRWcLB+yGiyTCgay6J723Fzbpcn0Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpPskTmBfRKZiyq8Mo4xXyPH7B1kuBMml08LHWtJ7rZ4Ncxwv/0cIFPvuYNvW5tqs
	 ydMVUBs7RAPefxcWtVnTnAlQyu3RvTHhWajB41e4StvfaHzMFze1AoVeYonSSv6DvR
	 2QxLudM78ZJr4TjX9jSh4i0s9T7FhCd+CwnZTkUE04VjLf6vxHrVcob/KWJKhkJ5pX
	 Sld+gAV5S/TafFm0KKE0eXrkN8VlrP0exJvp8l1+GrU3Ud6x/90qKpAPeIV64S9crk
	 lNjhRxCiYJS1G7SwtMqnvG1lHMi2e+oyEGi2SM308B8eGlV4B9pzm9X+1hT9f/6W0V
	 FSkMScWUe2vGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sy8y3-001LZr-Aa;
	Tue, 08 Oct 2024 13:05:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Expose S1PIE to guests
Date: Tue,  8 Oct 2024 13:05:06 +0100
Message-Id: <172838909377.2973199.1800004411282271028.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241005-kvm-arm64-fix-s1pie-v1-1-5901f02de749@kernel.org>
References: <20241005-kvm-arm64-fix-s1pie-v1-1-5901f02de749@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 05 Oct 2024 00:19:37 +0100, Mark Brown wrote:
> Prior to commit 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
> we just exposed the santised view of ID_AA64MMFR3_EL1 to guests, meaning
> that they saw both TCRX and S1PIE if present on the host machine. That
> commit added VMM control over the contents of the register and exposed
> S1POE but removed S1PIE, meaning that the extension is no longer visible
> to guests. Reenable support for S1PIE with VMM control.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Expose S1PIE to guests
      commit: d4a89e5aee23eaebdc45f63cb3d6d5917ff6acf4

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


