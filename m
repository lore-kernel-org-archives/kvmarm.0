Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6AAD5E
	for <kvmarm@lists.linux.dev>; Tue, 29 Nov 2022 19:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59DDC433C1;
	Tue, 29 Nov 2022 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669751575;
	bh=J1F2Q6Yb5LAAUS+mGAvNbWV55kglz5DVWB22nLbnzrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azPcrL26MA+/q6Ki1sfNoB6l3O+FYoS5JPS3HVzAV36vo1KcH7es9N97nVqop9401
	 bUxo4znU91Y3zaLmCJYfw2FNsuNMHL0LDjY+xA7VvYB8kScLm/faMDMgAZHTdj64HO
	 ecSQ7zlc4hcvoXYskZEQjEb619obqN7uk7arCQlLWyW6SL5UR7aRaviE2GL5Dp/usY
	 AnXc4SWMkPYGt2kuPJwDpA5N1XD5qQZ5xPjLzqFZ9GhM5+yULO1Hp1ky0DMsHN5gDO
	 uG102SKiVf/ZsrSAnlSAhIgv2HjvnBf16KekIWw+mzFuVuNXGQcE2JxT6+kV7va2tq
	 /opAu442Lk16w==
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Andre Przywara <andre.przywara@arm.com>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>
Subject: Re: [PATCH v5 0/8] arm64/sve: Clean up KVM integration and optimise syscalls
Date: Tue, 29 Nov 2022 19:52:45 +0000
Message-Id: <166973411736.1509628.9066833798546669515.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221115094640.112848-1-broonie@kernel.org>
References: <20221115094640.112848-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 15 Nov 2022 09:46:32 +0000, Mark Brown wrote:
> This patch series attempts to clarify the tracking of which set of
> floating point registers we save on systems supporting SVE, particularly
> with reference to KVM, and then uses the results of this clarification
> to improve the performance of simple syscalls where we return directly
> to userspace in cases where userspace is using SVE.
> 
> At present we track which register state is active by using the TIF_SVE
> flag for the current task which also controls if userspace is able to
> use SVE, this is reasonably straightforward if limiting but for KVM it
> gets a bit hairy since we may have guest state loaded in registers. This
> results in KVM modifying TIF_SVE for the VMM task while the guest is
> running which doesn't entirely help make things easy to follow. To help
> make things clearer the series changes things so that in addition to
> TIF_SVE we explicitly track both the type of registers that are
> currently saved in the task struct and the type of registers that we
> should save when we do so. TIF_SVE then solely controls if userspace
> can use SVE without trapping, it has no function for KVM guests and we
> can remove the code for managing it from KVM.
> 
> [...]

Applied to arm64 (for-next/sve-state), thanks!

[1/8] KVM: arm64: Discard any SVE state when entering KVM guests
      https://git.kernel.org/arm64/c/93ae6b01bafe
[2/8] arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
      https://git.kernel.org/arm64/c/baa8515281b3
[3/8] arm64/fpsimd: Have KVM explicitly say which FP registers to save
      https://git.kernel.org/arm64/c/deeb8f9a80fd
[4/8] arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
      https://git.kernel.org/arm64/c/62021cc36add
[5/8] arm64/fpsimd: Load FP state based on recorded data type
      https://git.kernel.org/arm64/c/a0136be443d5
[6/8] arm64/fpsimd: SME no longer requires SVE register state
      https://git.kernel.org/arm64/c/bbc6172eefdb
[7/8] arm64/sve: Leave SVE enabled on syscall if we don't context switch
      https://git.kernel.org/arm64/c/8c845e273104
[8/8] arm64/fp: Use a struct to pass data to fpsimd_bind_state_to_cpu()
      https://git.kernel.org/arm64/c/1192b93ba352

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
