Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AAC19509
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 13:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670DC433A7;
	Fri,  2 Jun 2023 13:51:56 +0000 (UTC)
Date: Fri, 2 Jun 2023 14:51:53 +0100
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
Subject: Re: [PATCH v2 03/11] KVM: arm64: switch HCRX_EL2 between host and
 guest
Message-ID: <ZHnz+Tgx8uHp5qmC@arm.com>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-4-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509142235.3284028-4-kristina.martsenko@arm.com>

On Tue, May 09, 2023 at 03:22:27PM +0100, Kristina Martsenko wrote:
> Switch the HCRX_EL2 register between host and guest configurations, in
> order to enable different features in the host and guest.
> 
> Now that there are separate guest flags, we can also remove SMPME from
> the host flags, as SMPME is used for virtualizing SME priorities and has
> no use in the host.
> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>

Same here, it could be good to have Marc/Oliver look at this.

-- 
Catalin
