Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B313440C0B;
	Thu,  7 Dec 2023 13:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF17C433C8;
	Thu,  7 Dec 2023 13:55:33 +0000 (UTC)
Date: Thu, 7 Dec 2023 13:55:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	dave.hansen@linux.intel.com, maz@kernel.org, oliver.upton@linux.dev,
	shuah@kernel.org, will@kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 05/25] arm64: context switch POR_EL0 register
Message-ID: <ZXHO0_ypVTUb392K@arm.com>
References: <20231124163510.1835740-1-joey.gouly@arm.com>
 <20231124163510.1835740-6-joey.gouly@arm.com>
 <ZWHiaTO6VUzHmbDB@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWHiaTO6VUzHmbDB@finisterre.sirena.org.uk>

On Sat, Nov 25, 2023 at 12:02:49PM +0000, Mark Brown wrote:
> On Fri, Nov 24, 2023 at 04:34:50PM +0000, Joey Gouly wrote:
> 
> > +static void flush_poe(void)
> > +{
> > +	if (system_supports_poe())
> > +		write_sysreg_s(POR_EL0_INIT, SYS_POR_EL0);
> > +}
> 
> Here we have no isb()...

My immediate thought was that we'd not care about the ISB here since
we'll have an ERET before getting to EL0. However, we may have some
LDTR/STTR populating the new process args page on exec which may, in
theory, pick up a stale POR_EL0.

-- 
Catalin
