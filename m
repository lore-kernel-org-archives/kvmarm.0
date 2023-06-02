Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56336111B8
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 13:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB5C433EF;
	Fri,  2 Jun 2023 13:49:53 +0000 (UTC)
Date: Fri, 2 Jun 2023 14:49:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/11] KVM: arm64: initialize HCRX_EL2
Message-ID: <ZHnzfhi2KCMPucQJ@arm.com>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-2-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509142235.3284028-2-kristina.martsenko@arm.com>

On Tue, May 09, 2023 at 03:22:25PM +0100, Kristina Martsenko wrote:
> ARMv8.7/9.2 adds a new hypervisor configuration register HCRX_EL2.
> Initialize the register to a safe value (all fields 0), to be robust
> against firmware that has not initialized it. This is also needed to
> ensure that the register is reinitialized after a kexec by a future
> kernel.
> 
> In addition, move SMPME setup over to the new flags, as it would
> otherwise get overridden. It is safe to set the bit even if SME is not
> (uniformly) supported, as it will write to a RES0 bit (having no
> effect), and SME will be disabled by the cpufeature framework.
> (Similar to how e.g. the API bit is handled in HCR_HOST_NVHE_FLAGS.)

This looks fine to me but I may have lost track of the VHE/nVHE code
initialisation paths.

Marc/Oliver, are you ok with this patch (or this series in general)? I'd
like to merge it through the arm64 tree.

Thanks.

-- 
Catalin
