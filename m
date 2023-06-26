Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB275125AA
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 20:52:54 +0000 (UTC)
Date: Mon, 26 Jun 2023 20:52:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687812772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X1L5ZJ3PrRKoApzZhudFyrD6ET1z6DiDInN2mn2qOoA=;
	b=av6vlVmWwH6Lmd2qCNew8YvpUoDOiGhnuZg5NYkW0fVMhEJGKEF1ML4mve6cyO4xGHvlEI
	4K1bAe1c3yvOeYTlymxOebdimsN1DbmlfWnIT1PdorkycXiZI0JrK7TjI+vUS0PVtquXnd
	g0nRwzgIZRzd80BTuICSOMXIcQRi/b0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
Message-ID: <ZJn6niA1RgAqu7DC@linux.dev>
References: <20230607194554.87359-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607194554.87359-1-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

On Wed, Jun 07, 2023 at 07:45:50PM +0000, Jing Zhang wrote:
> 
> This patch series enable userspace writable for below idregs:
> ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.
> 
> It is based on below series [2] which add infrastructure for writable idregs.

Could you implement some tests for these changes? We really need to see
that userspace is only allowed to select a subset of features that're
provided by the host, and that the CPU feature set never exceeds what
the host can support.

Additionally, there are places in the kernel where we use host ID
register values for the sake of emulation (DBGDIDR, LORegion). These
both should instead be using the _guest_ ID register values.

-- 
Thanks,
Oliver
