Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808EE53AB
	for <kvmarm@lists.linux.dev>; Wed, 15 Mar 2023 15:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9BCC4339C;
	Wed, 15 Mar 2023 15:34:49 +0000 (UTC)
Date: Wed, 15 Mar 2023 15:34:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/2] arm64: Add feature detection for fine grained traps
Message-ID: <ZBHlltJvTxUPUcnT@arm.com>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
 <20230301-kvm-arm64-fgt-v1-1-cfdf71ac67dc@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301-kvm-arm64-fgt-v1-1-cfdf71ac67dc@kernel.org>

On Mon, Mar 06, 2023 at 04:08:51PM +0000, Mark Brown wrote:
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
