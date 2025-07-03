Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66638226CF8
	for <kvmarm@lists.linux.dev>; Thu,  3 Jul 2025 09:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751535638; cv=none; b=h1+Fzw1jTqTRlhrzU+iXHjHriYWeFBEhhaijf2Vh4c6LrB6uu9MfCc+0rLOa8oDSiN1oVXfrHM0XFKTwTHATQtwK0ECRnM4Pz7gR/xDc8RZDr3H4Eb7XadgZI61Fyc9oC1lmXbS1WSF9fIH1P4XTPkkxVq5+8Sz82spLHzbbvkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751535638; c=relaxed/simple;
	bh=V9a0E8RceAANb+Yuvv7Oj5gTG12x/beot48Z5f4hU4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDB7fPSsswVmnf7IZ/EeW5KMzwqFV731Mi+QTE3Q2EaK3V9jJQLle+1D/vqm35+iI288W8RxBsCeZOVm5I/Xuk6XH9gp7kQEh27xNvIP/wf2V5ZgXQmJZwvV7JF3apdRK/lqB/ld3wLxHAlDuk1Z6cRaoxP8yjqgV+alCcyCssE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIsHOjuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIsHOjuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395B5C4CEE3;
	Thu,  3 Jul 2025 09:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751535638;
	bh=V9a0E8RceAANb+Yuvv7Oj5gTG12x/beot48Z5f4hU4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIsHOjuDGZrX8q0UtuPMNzzLn9yMAxgPIv35rChjnRaLkVhGzkZ3MzRS729YAI/1W
	 Ij1j+DF0Ta63RmrfcQ/n2V6Azyo4zb4o5isMioJkXYLUHUgBHlW2Tr9G01gaewWOZJ
	 vnAQRd9ylNpwpX60paDbsVXA2i5T+8E01wurDZ6nL0oc8xS7mnoY068W6+BCyM7a8e
	 jRWvaOoIy/q/XGtk36HK3nphGKbcVmbIOy+MAq40eb2mBCMwMQ6rfVgKGhAXryFjoK
	 WZ9U9ADBBcLqaL0ptOuVAGc0Jso6+saFERSurKjEs+NvhBQOSHwL1CoyOtk4rT3PRb
	 +fFzI/J8+l0sg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uXGQl-00CFW0-VI;
	Thu, 03 Jul 2025 10:40:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	tabba@google.com,
	will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()
Date: Thu,  3 Jul 2025 10:40:30 +0100
Message-Id: <175153562298.946959.15144867841994544212.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250619134817.4075340-1-mark.rutland@arm.com>
References: <20250619134817.4075340-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, broonie@kernel.org, catalin.marinas@arm.com, kvmarm@lists.linux.dev, oliver.upton@linux.dev, tabba@google.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 19 Jun 2025 14:48:17 +0100, Mark Rutland wrote:
> Historically KVM hyp code saved the host's FPSIMD state into the hosts's
> fpsimd_state memory, and so it was necessary to map this into the hyp
> Stage-1 mappings before running a vCPU.
> 
> This is no longer necessary as of commits:
> 
> * fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state")
> * 8eca7f6d5100 ("KVM: arm64: Remove host FPSIMD saving for non-protected KVM")
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()
      commit: 42ce432522a17685f5a84529de49e555477c0a1f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


