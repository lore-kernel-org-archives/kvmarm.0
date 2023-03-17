Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327876AC0
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B585C433D2;
	Fri, 17 Mar 2023 15:09:35 +0000 (UTC)
Date: Fri, 17 Mar 2023 15:09:32 +0000
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
Subject: Re: [PATCH 06/10] KVM: arm64: hide MOPS from guests
Message-ID: <ZBSCrNxFPwZCEuVR@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
 <20230216160012.272345-7-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216160012.272345-7-kristina.martsenko@arm.com>

On Thu, Feb 16, 2023 at 04:00:08PM +0000, Kristina Martsenko wrote:
> As FEAT_MOPS is not supported in guests yet, hide it from the ID
> registers for guests.
> 
> The MOPS instructions are UNDEFINED in guests as HCRX_EL2.MSCEn is not
> set in HCRX_GUEST_FLAGS, and will take an exception to EL1 if executed.
> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
