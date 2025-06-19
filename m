Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119EB22F75B;
	Thu, 19 Jun 2025 12:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750336625; cv=none; b=sCUfcOUBjLv6LCYeISo80OK5Cn11puFU56+tx3HszgXKctYEAVf9K+6DogWdlVWA5yX3oWGnA2IjsZg/z7KHXi62Bb4kQ+4FaMCf3H+XhynzF+ZiWjfvlDW8yuTHErSuLG+TL/EQM3nXQNwbD6TDNNmZgdHg9PEqzzDXfeSJHh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750336625; c=relaxed/simple;
	bh=5RsgnPconllRbfnixRhtoqpNREXw2H2Ipf16oI9O5rk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJiRRji28LzhPtaPqLpQWDolTJ6k2fyW66pTz2nR0GV8Q42JC2if/B7zKJxdDcOPIuBt9N0oMY1QOCIQgWe+qNmoxxlHlSUGstLIRUva3lZSf8i+/Irw4JnfhMyCKUe9JfSGZx8ZF9BMI2LmS0Y3tReawqE9J+0u6TkeTAtRtVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uw8uZTPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uw8uZTPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D063EC4CEEA;
	Thu, 19 Jun 2025 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750336624;
	bh=5RsgnPconllRbfnixRhtoqpNREXw2H2Ipf16oI9O5rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw8uZTPkzLcmoPvmUWRcnY7YFleRsMVDgyQsrOutK4c5a4rWBzvWibdqrc+zOLEGO
	 qk5vyYlgnJaIbY5H5eZYhCov9MtaKtbOzIAySgMU6NnhNzf6hscTgLHN2cCQnWItal
	 x+XPBVCpaXWPSOVzIC4VKRp4AJVOE4wBaI2gclPcZXCoHZk6pUCyrQ9xUZuKBq3tnw
	 CambOoBAwEODCJ+VCOLDeuYfpmS/qNXDveKKjqK8AzJPcAHUkAsstlTILlVITSTc6L
	 Mu6j6LMnRGe9Og6M35XpEQrnaM0N/N/EeEYTJ5khAaCgR686QjTjEZVfiCY4Ut2PMs
	 zhrnNG+z7AsfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uSEVq-008Ff6-Lj;
	Thu, 19 Jun 2025 13:37:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH 0/7] KVM: arm64: trap fixes and cleanup
Date: Thu, 19 Jun 2025 13:36:58 +0100
Message-Id: <175033660259.3069733.12635205080587210406.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, broonie@kernel.org, catalin.marinas@arm.com, kvmarm@lists.linux.dev, oliver.upton@linux.dev, stable@vger.kernel.org, tabba@google.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 17 Jun 2025 14:37:11 +0100, Mark Rutland wrote:
> This series fixes some issues with the way KVM manages traps in VHE
> mode, with some cleanups/simplifications atop.
> 
> Patch 1 fixes a theoretical issue with debug register manipulation,
> which has been around forever. This was found by inspection while
> working on other fixes.
> 
> [...]

Applied to fixes, thanks!

[1/7] KVM: arm64: VHE: Synchronize restore of host debug registers
      commit: cade3d57e456e69f67aa9894bf89dc8678796bb7
[2/7] KVM: arm64: VHE: Synchronize CPTR trap deactivation
      commit: 257d0aa8e2502754bc758faceceb6ff59318af60
[3/7] KVM: arm64: Reorganise CPTR trap manipulation
      commit: e62dd507844fa47f0fdc29f3be5a90a83f297820
[4/7] KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
      commit: 59e6e101a6fa542a365dd5858affd18ba3e84cb8
[5/7] KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fpsimd()
      commit: 186b58bacd74d9b7892869f7c7d20cf865a3c237
[6/7] KVM: arm64: Remove cpacr_clear_set()
      commit: 3a300a33e4063fb44c7887bec3aecd2fd6966df8
[7/7] KVM: arm64: VHE: Centralize ISBs when returning to host
      commit: 04c5355b2a94ff3191ce63ab035fb7f04d036869

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


