Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA827B
	for <kvmarm@lists.linux.dev>; Sun, 30 Oct 2022 17:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8869C433C1;
	Sun, 30 Oct 2022 17:40:57 +0000 (UTC)
Date: Sun, 30 Oct 2022 17:40:54 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 1/2] arm64: booting: Document our requirements for
 fine grained traps with SME
Message-ID: <Y163JlsMgmrNgZZb@arm.com>
References: <20221027210441.814061-1-broonie@kernel.org>
 <20221027210441.814061-2-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027210441.814061-2-broonie@kernel.org>

On Thu, Oct 27, 2022 at 10:04:39PM +0100, Mark Brown wrote:
> With SME we require that fine grained traps on access to TPIDR2_EL0 and
> SMPRI_EL1 are disabled but did not document that fact. Add the relevant
> register bits.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
