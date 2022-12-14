Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95167F;
	Wed, 14 Dec 2022 00:59:29 +0000 (UTC)
Date: Wed, 14 Dec 2022 00:59:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670979562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qbKxRIPYAhQPs9JSjFRsJUAAmMT3SmynUTp6Kob5aSA=;
	b=BJmn8mmJMMe4GC4cqN0JMmdIVim+izlQOZFM7XZq1llY0jN+dMVlj1H4EP4eIBEmXp8lYK
	MXbZuomcvx54TXdefIJEo1RVkbTUFi+HJtKiWnQoFfOhiWeNG5+ZIYpfylkQgVG/nu5OMS
	hIMZmFyTmHWQIDkc9Qi42jOvL1qPC/g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 0/3] KVM: arm64: Normalize cache configuration
Message-ID: <Y5kf5XDUb5En00BZ@google.com>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221211051700.275761-1-akihiko.odaki@daynix.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221214005917.OzP0ygKUJOlzFVDq_JJHkyARRvfLJ8QOojbmoXX2h5w@z>

Hi Akihiko,

On Sun, Dec 11, 2022 at 02:16:57PM +0900, Akihiko Odaki wrote:
> Before this change, the cache configuration of the physical CPU was
> exposed to vcpus. This is problematic because the cache configuration a
> vcpu sees varies when it migrates between vcpus with different cache
> configurations.
> 
> Fabricate cache configuration from arm64_ftr_reg_ctrel0.sys_val, which
> holds the CTR_EL0 value the userspace sees regardless of which physical
> CPU it resides on.
> 
> HCR_TID2 is now always set as it is troublesome to detect the difference
> of cache configurations among physical CPUs.
> 
> CSSELR_EL1 is now held in the memory instead of the corresponding
> phyisccal register as the fabricated cache configuration may have a
> cache level which does not exist in the physical CPU, and setting the
> physical CSSELR_EL1 for the level results in an UNKNOWN behavior.
> 
> CLIDR_EL1 and CCSIDR_EL1 are now writable from the userspace so that
> the VMM can restore the values saved with the old kernel.
> 
> Akihiko Odaki (3):
>   arm64/sysreg: Add CCSIDR2_EL1
>   arm64/cache: Move CLIDR macro definitions
>   KVM: arm64: Normalize cache configuration

Next time you do a respin can you please bump the version number? I.e.
the next version should be v3.

Additionally, it is tremendously helpful to reviewers if you can provide
(1) a summary of what has changed in the current revision and (2) a
lore.kernel.org link to the last series you mailed out.

--
Thanks,
Oliver
