Received: from out-226.mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C5B6FDB
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 18:51:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675103446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSCOsA3l6Whj8D78VA9+MZnM9iSGeCkaTGiJhbHGKtw=;
	b=Sa3NAHBJGd/Y8jLn840YqKwTtbKLBb+HGNVenj0ef9CdXK0Xb9SKXXkhxcppxxvIqj4Yrr
	H3CXzdNBfsFGrymB0haGCirRyhAMkg4+dQChXLey9s5GsPiufKF0sKUZf0W7IxtfJ8Dc42
	QJUhj+sMPki3unPUtmcmR08P9SMD19Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: timer fixes and optimisations
Date: Mon, 30 Jan 2023 18:30:34 +0000
Message-Id: <167510336269.1083059.9962999448888534799.b4-ty@linux.dev>
In-Reply-To: <20230112123829.458912-1-maz@kernel.org>
References: <20230112123829.458912-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Jan 2023 12:38:26 +0000, Marc Zyngier wrote:
> Having been busy on the NV front the past few weeks, I collected a
> small set of fixes/improvements that make sense even outside of NV.
> 
> The first one is an interesting fix (actually a regression introduced
> by the initial set of NV-related patches) reported by Scott and
> Ganapatrao, where we fail to recognise that a timer that has fired
> doesn't need to fire again. And again.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/3] KVM: arm64: Don't arm a hrtimer for an already pending timer
      https://git.kernel.org/kvmarm/kvmarm/c/4d74ecfa6458
[2/3] KVM: arm64: Reduce overhead of trapped timer sysreg accesses
      https://git.kernel.org/kvmarm/kvmarm/c/fc6ee952cf00
[3/3] KVM: arm64: timers: Don't BUG() on unhandled timer trap
      https://git.kernel.org/kvmarm/kvmarm/c/ba82e06cf7f4

--
Best,
Oliver
