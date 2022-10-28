Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD681841
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 00:38:34 +0000 (UTC)
Date: Fri, 28 Oct 2022 00:38:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666917512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C1BX7lhml2+zqjiHu3UCj3/w6pDSCf34usKTumXgNFM=;
	b=T79GI1toYxDNVx/ytLi/J222M7Ok73l6zejXrlbbTsUUPxl+lWFF8OlJnmecwEV7PJeCwC
	tyurX+E0JyGbfL+r65dJTQMA+2qvxq4oe3sZuTsBg4UlzT/KAN4jBqRzmplgFNuE+k72Wb
	yO/vN8cZ0xLeppMUa42V8IhEP2xqrQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 0/2] arm64/sme: Fix SMPRI_EL1 traps for KVM guests
Message-ID: <Y1skhMlaBoFfAZDH@google.com>
References: <20221027210441.814061-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027210441.814061-1-broonie@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 27, 2022 at 10:04:38PM +0100, Mark Brown wrote:
> When adding support for SME I missed management of traps for SMPRI_EL1
> in KVM guests.  This series adds that management, and also updates the
> documentation to help avoid such issues in future.
> 
> This was noticed due to Vincent Donnefort noticing that qemu has
> implemented support for SME virtualisation but not fine grained traps
> which was causing problems for qemu in nVHE mode since that already used
> fine grained traps with SME, the FGT registers are not implemented and
> UNDEF.  As a result of this change VHE will also be affected so a
> separate series "KVM: arm: Refuse to enable KVM on systems with SME but
> not FGT" has been sent which will ensure we don't run on such systems.
> 
> Mark Brown (2):
>   arm64: booting: Document our requirements for fine grained traps with
>     SME
>   KVM: arm64: Trap access to SMPRI_EL1 in VHE mode

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
