Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3D882A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE35C433D2;
	Mon, 12 Jun 2023 19:16:09 +0000 (UTC)
Date: Mon, 12 Jun 2023 20:16:06 +0100
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
Subject: Re: [PATCH v3 16/17] arm64: Allow arm64_sw.hvhe on command line
Message-ID: <ZIdu9mV5v7Wy7puI@arm.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609162200.2024064-17-maz@kernel.org>

On Fri, Jun 09, 2023 at 05:21:59PM +0100, Marc Zyngier wrote:
> Add the arm64_sw.hvhe=1 option to force the use of the hVHE mode
> in the hypervisor code only.
> 
> This enables the hVHE mode of operation when using KVM on VHE
> hardware.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
