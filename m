Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C7D6FDC
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 16:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B87EC433EF;
	Fri, 17 Mar 2023 16:04:14 +0000 (UTC)
Date: Fri, 17 Mar 2023 16:04:12 +0000
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
Subject: Re: [PATCH 10/10] arm64: mops: allow disabling MOPS from the kernel
 command line
Message-ID: <ZBSPfBvvH8yfyiP7@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
 <20230216160012.272345-11-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216160012.272345-11-kristina.martsenko@arm.com>

On Thu, Feb 16, 2023 at 04:00:12PM +0000, Kristina Martsenko wrote:
> Make it possible to disable the MOPS extension at runtime using the
> kernel command line. This can be useful for testing or working around
> hardware issues.
> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>

Yeah, I think that's useful if we want to test new cortext strings
routines for example.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
