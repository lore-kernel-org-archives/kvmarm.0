Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D7259C
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 10:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CEDC433D6;
	Mon, 14 Nov 2022 10:33:38 +0000 (UTC)
Date: Mon, 14 Nov 2022 10:33:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 8/8] arm64/fp: Use a struct to pass data to
 fpsimd_bind_state_to_cpu()
Message-ID: <Y3IZfgDCEoA6Rt2s@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-9-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-9-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:21AM +0100, Mark Brown wrote:
> For reasons that are unclear to this reader fpsimd_bind_state_to_cpu()
> populates the struct fpsimd_last_state_struct that it uses to store the
> active floating point state for KVM guests by passing an argument for
> each member of the structure. As the richness of the architecture increases
> this is resulting in a function with a rather large number of arguments
> which isn't ideal.
> 
> Simplify the interface by using the struct directly as the single argument
> for the function, renaming it as we lift the definition into the header.
> This could be built on further to reduce the work we do adding storage for
> new FP state in various places but for now it just simplifies this one
> interface.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

I think this looks cleaner.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
