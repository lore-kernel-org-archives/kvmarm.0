Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF3E6AC0
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 15:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D489C4339B;
	Fri, 17 Mar 2023 15:07:40 +0000 (UTC)
Date: Fri, 17 Mar 2023 15:07:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] arm64: mops: document boot requirements for MOPS
Message-ID: <ZBSCObGmIXjyeMA6@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
 <20230216160012.272345-5-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216160012.272345-5-kristina.martsenko@arm.com>

On Thu, Feb 16, 2023 at 04:00:06PM +0000, Kristina Martsenko wrote:
> +  For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HCRX_EL2.MSCEn (bit 11) must be initialised to 0b1.
> +
> +    - HCRX_EL2.MCE2 (bit 10) must be initialised to 0b0.

Regarding MCE2, does EL1 actually care if EL2 wants to handle all the
memcpy/memset exceptions? There may even be a valid case to do this at
EL2 if you run a guest that uses these instructions but has no clue on
how to deal with the specific exception like WrongOption.

-- 
Catalin
