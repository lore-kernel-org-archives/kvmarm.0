Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8763B7B
	for <kvmarm@lists.linux.dev>; Sun, 30 Oct 2022 17:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C79C433C1;
	Sun, 30 Oct 2022 17:44:42 +0000 (UTC)
Date: Sun, 30 Oct 2022 17:44:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 0/2] KVM: arm: Refuse to enable KVM on systems with
 SME but not FGT
Message-ID: <Y164B4m50JW6Y0hA@arm.com>
References: <20221027205246.812586-1-broonie@kernel.org>
 <8735b6hmxo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735b6hmxo.wl-maz@kernel.org>

On Sat, Oct 29, 2022 at 12:46:43PM +0100, Marc Zyngier wrote:
> On Thu, 27 Oct 2022 21:52:44 +0100,
> Mark Brown <broonie@kernel.org> wrote:
> > 
> > The architecture requires that any system which implements SME also has
> > fine grained traps since SME is a v9.2 feature, meaning that v8.7 must be
> > implemented, and FGT is mandatory from v8.6. SME relies on fine grained
> > traps to control access to SMPRI_EL1 and in nVHE mode to TPIDR2_EL0,
> > without traps SMPRI_EL1.Priority and TPIDR2_EL0 can be used as side
> > channels. 
> > 
> > This series adds support for detecting FGT and refuses to allow KVM to
> > be used in architecturally invalid configurations which have SME but not
> > FGT, without detection the issue presents as faults due to EL2
> > attempting to access the FGT registers which isn't obvious to users.
> > Currently fine grained traps are only used in nVHE but but a series
> > "arm64/sme: Fix SMPRI_EL1 traps for KVM guests" sent along with this
> > will add usage for VHE mode too making the issue more pressing.
> 
> I think this goes the wrong way around. SME without FGT is invalid,
> and yet you keep SME around and device to kill virtualisation support.
> 
> I'd rather it is SME that gets disabled when the kernel boots at EL2.

I agree, I rather we did it the other way around.

-- 
Catalin
