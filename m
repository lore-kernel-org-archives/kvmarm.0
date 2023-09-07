Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093A61400E
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 20:27:20 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00FBCFEC;
	Thu,  7 Sep 2023 13:27:58 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A79733F766;
	Thu,  7 Sep 2023 13:27:18 -0700 (PDT)
Date: Thu, 7 Sep 2023 21:27:12 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values
Message-ID: <20230907202712.GA171716@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907153052.GD69899@e124191.cambridge.arm.com>
 <871qf9q25c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qf9q25c.wl-maz@kernel.org>

On Thu, Sep 07, 2023 at 07:17:03PM +0100, Marc Zyngier wrote:
> On Thu, 07 Sep 2023 16:30:52 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> 
> [...]
> 
> > Got a roughly similar perf improvement (about 28%).
> 
> Out of curiosity, on which HW?

I used QEMU emulation, but was told after posting this that QEMU is probably
not good to be used for perf measurments? Sorry about that. I can retry on Juno
tomorrow if that's of any use.

> 
> > Tested-by: Joey Gouly <joey.gouly@arm.com>
> 
> Thanks!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
