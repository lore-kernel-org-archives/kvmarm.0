Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9E256D
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 09:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A601C433B5;
	Mon, 14 Nov 2022 09:24:11 +0000 (UTC)
Date: Mon, 14 Nov 2022 09:24:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 5/8] arm64/fpsimd: Load FP state based on recorded
 data type
Message-ID: <Y3IJNwtVY+6MyH9k@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-6-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-6-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:18AM +0100, Mark Brown wrote:
> Now that we are recording the type of floating point register state we
> are saving when we write the register state out to memory we can use
> that information when we load from memory to decide which format to
> load, bringing TIF_SVE into line with what we saved rather than relying
> on TIF_SVE to determine what to load.
> 
> The SME state details are already recorded directly in the saved
> SVCR and handled based on the information there.
> 
> Since we are not changing any of the save paths there should be no
> functional change from this patch, further patches will make use of this
> to optimise and clarify the code.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
