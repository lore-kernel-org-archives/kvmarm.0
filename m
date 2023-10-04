Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22F1BDC1
	for <kvmarm@lists.linux.dev>; Wed,  4 Oct 2023 16:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C4DC433C7;
	Wed,  4 Oct 2023 16:49:07 +0000 (UTC)
Date: Wed, 4 Oct 2023 17:49:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	dave.hansen@linux.intel.com, maz@kernel.org, oliver.upton@linux.dev,
	shuah@kernel.org, will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/20] arm64: context switch POR_EL0 register
Message-ID: <ZR2XgLsihUJHRePO@arm.com>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-6-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-6-joey.gouly@arm.com>

On Wed, Sep 27, 2023 at 03:01:08PM +0100, Joey Gouly wrote:
> +static void permission_overlay_switch(struct task_struct *next)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_HAS_S1POE)) {
> +		current->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);
> +		write_sysreg_s(next->thread.por_el0, SYS_POR_EL0);
> +	}
> +}

Does this need an ISB or is the POR_EL0 register write
self-synchronising?

-- 
Catalin
