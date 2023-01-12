Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAE279F8
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 17:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3D6C433EF;
	Thu, 12 Jan 2023 17:50:05 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] arm64/sysreg: ISR register conversions
Date: Thu, 12 Jan 2023 17:50:03 +0000
Message-Id: <167354578784.3644325.3495838282675045749.b4-ty@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
References: <20221208-arm64-isr-el1-v2-0-89f7073a1ca9@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 27 Dec 2022 17:05:03 +0000, Mark Brown wrote:
> This series pulls the generated sysreg updates out of the previously
> posted series for NMI support then adds an incremental patch on top of
> that using the generated constant for ISR_EL1.A in the KVM entry code
> suggested by Marc Zyngier.  This should hopefully help these progress
> without getting tied up by the more involved NMI rework (and cut down
> the size of that series if they do get merged).
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[1/3] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
      https://git.kernel.org/arm64/c/541826afb2c7
[2/3] arm64/sysreg: Add definition of ISR_EL1
      https://git.kernel.org/arm64/c/df5f1775aab2
[3/3] KVM: arm64: Use symbolic definition for ISR_EL1.A
      https://git.kernel.org/arm64/c/1abf363d085c

-- 
Catalin

