Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3E7F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 17:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A85BC433C9;
	Wed, 14 Jun 2023 17:19:07 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	broonie@kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.linux.dev,
	coresight@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 00/14] arm64/sysreg: Convert TRBE registers to automatic generation
Date: Wed, 14 Jun 2023 18:19:05 +0100
Message-Id: <168676313901.1670320.10279207705636079324.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230614065949.146187-1-anshuman.khandual@arm.com>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 14 Jun 2023 12:29:35 +0530, Anshuman Khandual wrote:
> This series converts TRBE registers to automatic generation, after renaming
> their fields as per the auto-gen tools format. Although the following field
> still renames in arch/arm64/include/asm/sysreg.h, as it cannot be converted
> (shares bits with other fields) in the tools format.
> 
> #define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
> #define TRBSR_EL1_BSC_SHIFT		0
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[01/14] arm64/sysreg: Rename TRBLIMITR_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/92b1efcd9d9d
[02/14] arm64/sysreg: Rename TRBPTR_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/e01e1737e348
[03/14] arm64/sysreg: Rename TRBBASER_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/90cdde836c43
[04/14] arm64/sysreg: Rename TRBSR_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/7bb948826610
[05/14] arm64/sysreg: Rename TRBMAR_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/b7c3a6eb4d2b
[06/14] arm64/sysreg: Rename TRBTRG_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/dae169fd63f3
[07/14] arm64/sysreg: Rename TRBIDR_EL1 fields per auto-gen tools format
        https://git.kernel.org/arm64/c/f170aa51e6c5
[08/14] arm64/sysreg: Convert TRBLIMITR_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/eee64165a54e
[09/14] arm64/sysreg: Convert TRBPTR_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/6669697733ca
[10/14] arm64/sysreg: Convert TRBBASER_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/cbaf0cf005f0
[11/14] arm64/sysreg: Convert TRBSR_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/46f3a5b01fd7
[12/14] arm64/sysreg: Convert TRBMAR_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/3077b1db9d57
[13/14] arm64/sysreg: Convert TRBTRG_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/a56035c95ec6
[14/14] arm64/sysreg: Convert TRBIDR_EL1 register to automatic generation
        https://git.kernel.org/arm64/c/f0d4627f6459

-- 
Catalin

