Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E227E5
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 22:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645F0C433D6;
	Sun, 13 Nov 2022 22:31:02 +0000 (UTC)
Date: Sun, 13 Nov 2022 22:30:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 4/8] arm64/fpsimd: Stop using TIF_SVE to manage
 register saving in KVM
Message-ID: <Y3FwIiTI8TYp5AQc@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-5-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-5-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:17AM +0100, Mark Brown wrote:
> Now that we are explicitly telling the host FP code which register state
> it needs to save we can remove the manipulation of TIF_SVE from the KVM
> code, simplifying it and allowing us to optimise our handling of normal
> tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
> to_save to ensure we save the correct data for it.
> 
> There should be no functional or performance impact from this change.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
