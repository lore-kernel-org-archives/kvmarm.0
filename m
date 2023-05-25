Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041324EA9
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 21:41:49 +0000 (UTC)
Date: Thu, 25 May 2023 21:41:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685050907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7LZyVsixnYHBqqcygXbEeMudfYkIJ0LUQv8Zaxcpdd8=;
	b=nu5YGcV/j0wPRJrbn6CrAxnJcPrhTjgZJs+p1Ze06BO4708tnL/5Od+eckQEi5IIt1xviL
	QUhQRxri7yqX5v9BElAW+kapnReg1TQ2yBt49zRof9HwucBH0z3dT811cmXWJaGUqTfAy0
	eC3g2EAagTPOCHWiIGtoHk6dHMJnjqg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v2 0/7] arm64/sysreg: More conversions to automatic
 generation
Message-ID: <ZG/WF22mB4PiJdl4@linux.dev>
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 23, 2023 at 07:36:58PM +0100, Mark Brown wrote:
> Continue working through the register defintions, converting them to
> automatic generation.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v2:
> - Also convert OSECCR_EL1, OSDTRRX_EL1 and OSDTRTX_EL1 instead of
>   dropping them.
> - Link to v1: https://lore.kernel.org/r/20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org
> 
> ---
> Mark Brown (7):
>       arm64/sysreg: Convert MDCCINT_EL1 to automatic register generation
>       arm64/sysreg: Convert MDSCR_EL1 to automatic register generation
>       arm64/sysreg: Standardise naming of bitfield constants in OSL[AS]R_EL1
>       arm64/sysreg: Convert OSLAR_EL1 to automatic generation
>       arm64/sysreg: Convert OSDTRRX_EL1 to automatic generation
>       arm64/sysreg: Convert OSDTRTX_EL1 to automatic generation
>       arm64/sysreg: Convert OSECCR_EL1 to automatic generation

Besides the one comment I had:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

I imagine these will go through the arm64 tree right? The KVM diff is
miniscule.

-- 
Thanks,
Oliver
