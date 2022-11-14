Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B1A139B
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 10:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58EAC433D7;
	Mon, 14 Nov 2022 10:31:20 +0000 (UTC)
Date: Mon, 14 Nov 2022 10:31:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 7/8] arm64/sve: Leave SVE enabled on syscall if we
 don't context switch
Message-ID: <Y3IY9es/x1w8BZVL@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-8-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-8-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:20AM +0100, Mark Brown wrote:
> The syscall ABI says that the SVE register state not shared with FPSIMD
> may not be preserved on syscall, and this is the only mechanism we have
> in the ABI to stop tracking the extra SVE state for a process. Currently
> we do this unconditionally by means of disabling SVE for the process on
> syscall, causing userspace to take a trap to EL1 if it uses SVE again.
> These extra traps result in a noticeable overhead for using SVE instead
> of FPSIMD in some workloads, especially for simple syscalls where we can
> return directly to userspace and would not otherwise need to update the
> floating point registers. Tests with fp-pidbench show an approximately
> 70% overhead on a range of implementations when SVE is in use - while
> this is an extreme and entirely artificial benchmark it is clear that
> there is some useful room for improvement here.

If SVE is no longer in use, does the explicit SVE regs flushing cause
any noticeable overhead? I guess even if there's a small overhead, it's
only temporary until a context switch clears TIF_SVE again.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
