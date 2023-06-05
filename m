Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8128E525E
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 12:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4EAC433EF;
	Mon,  5 Jun 2023 12:05:02 +0000 (UTC)
Date: Mon, 5 Jun 2023 13:04:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
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
Subject: Re: [PATCH v2 07/11] arm64: mops: handle MOPS exceptions
Message-ID: <ZH3Pa/Ct3XX613Yj@arm.com>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-8-kristina.martsenko@arm.com>
 <628463d5-b9df-51bd-8e1f-b0a41a928d85@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628463d5-b9df-51bd-8e1f-b0a41a928d85@redhat.com>

On Mon, Jun 05, 2023 at 07:43:27PM +0800, Shaoqin Huang wrote:
> Hi Kristina,
> 
> On 5/9/23 22:22, Kristina Martsenko wrote:
> > The memory copy/set instructions added as part of FEAT_MOPS can take an
> > exception (e.g. page fault) part-way through their execution and resume
> > execution afterwards.
> > 
> > If however the task is re-scheduled and execution resumes on a different
> > CPU, then the CPU may take a new type of exception to indicate this.
> > This is because the architecture allows two options (Option A and Option
> > B) to implement the instructions and a heterogeneous system can have
> > different implementations between CPUs.
> > 
> > In this case the OS has to reset the registers and restart execution
> > from the prologue instruction. The algorithm for doing this is provided
> > as part of the Arm ARM.
> 
> What is the Arm ARM? I'm not quite understand it.

The Arm Architecture Reference Manual:

https://developer.arm.com/documentation/ddi0487/latest

(the acronym we pretty well known among the arm/arm64 developers)

-- 
Catalin
