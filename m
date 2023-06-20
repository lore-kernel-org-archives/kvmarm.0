Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2672514AB0
	for <kvmarm@lists.linux.dev>; Tue, 20 Jun 2023 13:16:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687266985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WlBu0U6xuA3SK1wikfKgcAofFHihUwWGX5QYHFIDCVE=;
	b=tDzwpGS8kTXCKSrJx2hvTeVnVr+pxLFVB60VJfkC21AWTT7SEct58nuvZdptoXPPZy6BpD
	F0f3Fljo/Yw/Qqi8MtqHW4W8BnuqxeQX1WqgXho8+mWl6Zh9OtxxQ9WJJNBzhm7+fFgbNE
	gqUkDZ/YQ+ORk49vFQxTxonmZRcTfRQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Darren Hart <darren@os.amperecomputing.com>,
	James Morse <james.morse@arm.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] KVM: arm64: Work around Ampere1 erratum AC03_CPU_38
Date: Tue, 20 Jun 2023 13:15:14 +0000
Message-ID: <168726686571.969669.5974268612822941910.b4-ty@linux.dev>
In-Reply-To: <20230609220104.1836988-1-oliver.upton@linux.dev>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 9 Jun 2023 22:01:01 +0000, Oliver Upton wrote:
> Small series to work around a CPU erratum on AmpereOne. While the
> implementation does not advertise support for FEAT_HAFDBS (due to
> another erratum), the associated control bits do not have RES0 behavior
> as required by the architecture.
> 
> Usage of HAFDBS at stage-1 is unaffected, since HA and HD are only
> enabled on implementations that advertise the feature. However, KVM
> relies on HA having RES0 semantics if the feature isn't implemented. The
> end result is that KVM enables a broken hardware access flag
> implementation that could lead to correctness issues.
> 
> [...]

Applied w/ an expanded description of what's wrong with the unadvertised
HAFDBS implementation, per Catalin's suggestion.

[1/3] arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2
      https://git.kernel.org/kvmarm/kvmarm/c/6df696cd9bc1
[2/3] KVM: arm64: Refactor HFGxTR configuration into separate helpers
      https://git.kernel.org/kvmarm/kvmarm/c/ce4a36225753
[3/3] KVM: arm64: Prevent guests from enabling HA/HD on Ampere1
      https://git.kernel.org/kvmarm/kvmarm/c/082fdfd13841

--
Best,
Oliver
