Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE5020698
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 15:41:17 +0000 (UTC)
Date: Mon, 5 Jun 2023 15:41:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685979676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GoZGAOTBvlr1nlPErXnetSaPgiXMcLx2bMeCqDLA1dk=;
	b=PivUa3rReYTnWwK9qzsAl7TVQSXztMg4Tj2jSXkRklNXzzHrH9eEHLzBq1b1cu/7VjtJAQ
	r3iniQ+ra6KyqjFwT2g0zigWYeRj+dReKT6T78yu35CWbJtDe0fLF7Qt64ZoPF9/0vbLKn
	ibqWLX433iGoUtvLnqtuA/o+6gp4rm8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/11] KVM: arm64: initialize HCRX_EL2
Message-ID: <ZH4CFmwo+BBPMWiY@linux.dev>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-2-kristina.martsenko@arm.com>
 <ZHnzfhi2KCMPucQJ@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHnzfhi2KCMPucQJ@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 02, 2023 at 02:49:50PM +0100, Catalin Marinas wrote:
> On Tue, May 09, 2023 at 03:22:25PM +0100, Kristina Martsenko wrote:
> > ARMv8.7/9.2 adds a new hypervisor configuration register HCRX_EL2.
> > Initialize the register to a safe value (all fields 0), to be robust
> > against firmware that has not initialized it. This is also needed to
> > ensure that the register is reinitialized after a kexec by a future
> > kernel.
> > 
> > In addition, move SMPME setup over to the new flags, as it would
> > otherwise get overridden. It is safe to set the bit even if SME is not
> > (uniformly) supported, as it will write to a RES0 bit (having no
> > effect), and SME will be disabled by the cpufeature framework.
> > (Similar to how e.g. the API bit is handled in HCR_HOST_NVHE_FLAGS.)
> 
> This looks fine to me but I may have lost track of the VHE/nVHE code
> initialisation paths.
> 
> Marc/Oliver, are you ok with this patch (or this series in general)? I'd
> like to merge it through the arm64 tree.

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
