Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB64AA20;
	Thu,  1 Dec 2022 18:30:03 +0000 (UTC)
Date: Thu, 1 Dec 2022 18:29:51 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Message-ID: <Y4jyn+aMUGcaa6Ag@google.com>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867czbmlh1.wl-maz@kernel.org>
Message-ID: <20221201182951.ZtHotR1jy-MQqEWfsG9X6Hbj4aiWeTToixfji9N9gw4@z>

On Thu, Dec 01, 2022 at 11:06:50AM +0000, Marc Zyngier wrote:

[...]

> It would be a lot better to expose a virtual topology
> (one set, one way, one level). It would also save us from the CCSIDRX
> silliness.
> 
> The only complexity would be to still accept different topologies from
> userspace so that we can restore a VM saved before this virtual
> topology.

I generally agree that the reported topology is meaningless to
non-secure software.

However, with the cloud vendor hat on, I'm worried that inevitably some
customer will inspect the cache topology of the VM we've provided them
and complain.

Could we extend your suggestion about accepting different topologies to
effectively tolerate _any_ topology provided by userspace? KVM can
default to the virtual topology, but a well-informed userspace could
still provide different values to its guest. No point in trying to
babyproofing the UAPI further, IMO.

--
Thanks,
Oliver
