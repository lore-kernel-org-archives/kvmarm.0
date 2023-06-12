Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF4882A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC5AC433D2;
	Mon, 12 Jun 2023 19:14:38 +0000 (UTC)
Date: Mon, 12 Jun 2023 20:14:35 +0100
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
Subject: Re: [PATCH v3 06/17] arm64: Allow EL1 physical timer access when
 running VHE
Message-ID: <ZIdum4tmkM8/COxv@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-7-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:49PM +0100, Marc Zyngier wrote:
> To initialise the timer access from EL2 when HCR_EL2.E2H is set,
> we must make use the CNTHCTL_EL2 formap used is appropriate.
> 
> This amounts to shifting the timer/counter enable bits by 10
> to the left.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
