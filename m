Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA91A2C80
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 23:29:56 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689377394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNGryzPV7X5DJb9geTTbeh3QSx81iDfZpYyrpveovg0=;
	b=rIHyLv+vD7XlO+ax06QekNKo0h+7BvHyw1Ui2kQvXADOJHjnhPOJ/J+id5OVN1ENIMa8RZ
	8B2ieWq0WOh47w4nJj+OSnAuGxAKb1soDHcSHd/C0Yf1hjYIXDFZbyEpYefx+0aON5zi/z
	H45pzN42CZPMizmQPofa6jVOuLsnmrw=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	rananta@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Reiji Watanabe <reijiw@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
Date: Fri, 14 Jul 2023 23:29:47 +0000
Message-ID: <168937738395.1784885.18035224079427608852.b4-ty@linux.dev>
In-Reply-To: <20230713221649.3889210-1-oliver.upton@linux.dev>
References: <20230713221649.3889210-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 13 Jul 2023 22:16:49 +0000, Oliver Upton wrote:
> The PMU event ID varies from 10 to 16 bits, depending on the PMU
> version. If the PMU only supports 10 bits of event ID, bits [15:10] of
> the evtCount field behave as RES0.
> 
> While the actual PMU emulation code gets this right (i.e. RES0 bits are
> masked out when programming the perf event), the sysreg emulation writes
> an unmasked value to the in-memory cpu context. The net effect is that
> guest reads and writes of PMEVTYPER<n>_EL0 will see non-RES0 behavior in
> the reserved bits of the field.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
      https://git.kernel.org/kvmarm/kvmarm/c/6d4f9236cd67

--
Best,
Oliver
