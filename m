Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F8E7F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 16:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBC3C433C8;
	Wed, 14 Jun 2023 16:58:52 +0000 (UTC)
Date: Wed, 14 Jun 2023 17:58:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38
 at stage-2
Message-ID: <ZInxyiDsyJRo2K9D@arm.com>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
 <20230609220104.1836988-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609220104.1836988-2-oliver.upton@linux.dev>

On Fri, Jun 09, 2023 at 10:01:02PM +0000, Oliver Upton wrote:
> AmpereOne has an erratum in its implementation of FEAT_HAFDBS that
> required disabling the feature on the design. This was done by reporting
> the feature as not implemented in the ID register, although the
> corresponding control bits were not actually RES0. This does not align
> well with the requirements of the architecture, which mandates these
> bits be RES0 if HAFDBS isn't implemented.
> 
> The kernel's use of stage-1 is unaffected, as the HA and HD bits are
> only set if HAFDBS is detected in the ID register. KVM, on the other
> hand, relies on the RES0 behavior at stage-2 to use the same value for
> VTCR_EL2 on any cpu in the system. Mitigate the non-RES0 behavior by
> leaving VTCR_EL2.HA clear on affected systems.
> 
> Cc: stable@vger.kernel.org
> Cc: D Scott Phillips <scott@os.amperecomputing.com>
> Cc: Darren Hart <darren@os.amperecomputing.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

For the non-KVM bits in here:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
