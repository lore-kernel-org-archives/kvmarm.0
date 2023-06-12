Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0295882A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99BEC433EF;
	Mon, 12 Jun 2023 19:15:31 +0000 (UTC)
Date: Mon, 12 Jun 2023 20:15:29 +0100
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
Subject: Re: [PATCH v3 07/17] arm64: Use CPACR_EL1 format to set CPTR_EL2
 when E2H is set
Message-ID: <ZIdu0e857qPXPyZA@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-8-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:50PM +0100, Marc Zyngier wrote:
> When HCR_EL2.E2H is set, the CPTR_EL2 register takes the CPACR_EL1
> format. Yes, this is good fun.
> 
> Hack the bits of startup code that assume E2H=0 while setting up
> CPTR_EL2 to make them grok the CPTR_EL1 format.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
