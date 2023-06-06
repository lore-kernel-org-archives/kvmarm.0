Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE5619915
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 17:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2389C4339B;
	Tue,  6 Jun 2023 17:30:42 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v2 0/7] arm64/sysreg: More conversions to automatic generation
Date: Tue,  6 Jun 2023 18:30:41 +0100
Message-Id: <168607263650.1438384.7012874887740689575.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 23 May 2023 19:36:58 +0100, Mark Brown wrote:
> Continue working through the register defintions, converting them to
> automatic generation.
> 
> 

Applied to arm64 (for-next/sysreg), thanks!

[1/7] arm64/sysreg: Convert MDCCINT_EL1 to automatic register generation
      https://git.kernel.org/arm64/c/3def3387f755
[2/7] arm64/sysreg: Convert MDSCR_EL1 to automatic register generation
      https://git.kernel.org/arm64/c/103b88427bc5
[3/7] arm64/sysreg: Standardise naming of bitfield constants in OSL[AS]R_EL1
      https://git.kernel.org/arm64/c/187de7c2aad8
[4/7] arm64/sysreg: Convert OSLAR_EL1 to automatic generation
      https://git.kernel.org/arm64/c/31d504fce595
[5/7] arm64/sysreg: Convert OSDTRRX_EL1 to automatic generation
      https://git.kernel.org/arm64/c/7b416a162229
[6/7] arm64/sysreg: Convert OSDTRTX_EL1 to automatic generation
      https://git.kernel.org/arm64/c/42383388758a
[7/7] arm64/sysreg: Convert OSECCR_EL1 to automatic generation
      https://git.kernel.org/arm64/c/175cea665877

-- 
Catalin

