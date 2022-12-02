Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A8110C;
	Fri,  2 Dec 2022 18:55:04 +0000 (UTC)
Date: Fri, 2 Dec 2022 18:54:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670007296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QF7YyY0zCO4x691PE+6++2gBpkKD4tpfGa6u+JeBMx4=;
	b=EXkS9mLpz+vLNs65I4j2M/dADkhs3aXj6C2J9/QQBDtzZvHcNqfe16I74H5FqC54X6IZh1
	vDlLk2ztWLvPpDhIQey3K7nj4r9t8dEgpELG+MGppVJXr0vTOFEn8BqpFWmyYmdKr0UKQZ
	7KgvNJRzvcj4Zw0lGfzfhiHCt5vdOM8=
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
Message-ID: <Y4pJ+wnzHv0Rpws+@google.com>
References: <20221201104914.28944-1-akihiko.odaki@daynix.com>
 <867czbmlh1.wl-maz@kernel.org>
 <Y4jyn+aMUGcaa6Ag@google.com>
 <87k03au36k.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k03au36k.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221202185451.ARBorN6ifJm02GbkE8vHogIvcgXXEfA-J2mgH2l7h2M@z>

On Thu, Dec 01, 2022 at 11:14:43PM +0000, Marc Zyngier wrote:
> On Thu, 01 Dec 2022 18:29:51 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > Could we extend your suggestion about accepting different topologies to
> > effectively tolerate _any_ topology provided by userspace? KVM can
> > default to the virtual topology, but a well-informed userspace could
> > still provide different values to its guest. No point in trying to
> > babyproofing the UAPI further, IMO.
> 
> I think this is *exactly* what I suggested. Any valid topology should
> be able to be restored, as we currently present the VM with any
> topology the host HW may have. This must be preserved.

Ah, I was narrowly reading into the conversation as it relates to the M2
implementation, my bad. SGTM :)

--
Thanks,
Oliver
