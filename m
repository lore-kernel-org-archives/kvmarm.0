Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD917AB7
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E89C433EF;
	Mon, 12 Jun 2023 16:59:41 +0000 (UTC)
Date: Mon, 12 Jun 2023 17:59:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 02/17] arm64: Prevent the use of
 is_kernel_in_hyp_mode() in hypervisor code
Message-ID: <ZIdO+vz57U4RiJ2J@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-3-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:45PM +0100, Marc Zyngier wrote:
> Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
> mistake. This helper only checks for CurrentEL being EL2, which
> is always true.
> 
> Make the compilation fail if using the helper in hypervisor context
> Whilst we're at it, flag the helper as __always_inline, which it
> really should be.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
