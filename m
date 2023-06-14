Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C849C7F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 16:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4801C433C8;
	Wed, 14 Jun 2023 16:57:57 +0000 (UTC)
Date: Wed, 14 Jun 2023 17:57:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Work around Ampere1 erratum AC03_CPU_38
Message-ID: <ZInxk+75cYfP3N4S@arm.com>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609220104.1836988-1-oliver.upton@linux.dev>

On Fri, Jun 09, 2023 at 10:01:01PM +0000, Oliver Upton wrote:
> Small series to work around a CPU erratum on AmpereOne. While the
> implementation does not advertise support for FEAT_HAFDBS (due to
> another erratum), the associated control bits do not have RES0 behavior
> as required by the architecture.
> 
> Usage of HAFDBS at stage-1 is unaffected, since HA and HD are only
> enabled on implementations that advertise the feature. However, KVM
> relies on HA having RES0 semantics if the feature isn't implemented. The
> end result is that KVM enables a broken hardware access flag
> implementation that could lead to correctness issues.

Just curious, what's the correctness issue here? The access flag is
mostly indicative of which pages are old for swapping out/discarding.
It's not like the dirty state which would be dangerous if we get wrong.

-- 
Catalin
