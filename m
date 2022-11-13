Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9176FDF
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 22:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F97CC433D6;
	Sun, 13 Nov 2022 22:00:32 +0000 (UTC)
Date: Sun, 13 Nov 2022 22:00:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/8] KVM: arm64: Discard any SVE state when entering
 KVM guests
Message-ID: <Y3Fo/HCw7iEQXGSB@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-2-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-2-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:14AM +0100, Mark Brown wrote:
> Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
> KVM has not tracked the host SVE state, relying on the fact that we
> currently disable SVE whenever we perform a syscall. This may not be true
> in future since performance optimisation may result in us keeping SVE
> enabled in order to avoid needing to take access traps to reenable it.
> Handle this by clearing TIF_SVE and converting the stored task state to
> FPSIMD format when preparing to run the guest.  This is done with a new
> call fpsimd_kvm_prepare() to keep the direct state manipulation
> functions internal to fpsimd.c.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
