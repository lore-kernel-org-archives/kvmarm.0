Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076217F6
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:00:06 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689786004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypHKcOcXbRMJeyq5YUZhgTLY5/OHcBJWdyhyP80Pt/8=;
	b=rbc2JRMolrcFmcldjGb7puj0pf/IzslBDPqLkB8c7U+NF4yygahWzsOEWpa94kUPwkrUUk
	rOYL7blwepbgwRYWxGDrmTc5dfhPjwdUSbgGQSDjoyTzvT7uHEz1Q7y8kriUSTNx7QMgKc
	EivV9PPMWwd8wuY0DhGQQSO0quoii0A=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Allow pKVM on v1.0 compatible FF-A implementations
Date: Wed, 19 Jul 2023 16:59:53 +0000
Message-ID: <168978598644.4013597.17946430376522215922.b4-ty@linux.dev>
In-Reply-To: <20230718184537.3220867-1-oliver.upton@linux.dev>
References: <20230718184537.3220867-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 18 Jul 2023 18:45:37 +0000, Oliver Upton wrote:
> pKVM initialization fails on systems with v1.1+ FF-A implementations, as
> the hyp does a strict match on the returned version from FFA_VERSION.
> This is a stronger assertion than required by the specification, which
> requires minor revisions be backwards compatible with earlier revisions
> of the same major version.
> 
> Relax the check in hyp_ffa_init() to only test the returned major
> version. Even though v1.1 broke ABI, the expectation is that firmware
> incapable of using the v1.0 ABI return NOT_SUPPORTED instead of a valid
> version.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Allow pKVM on v1.0 compatible FF-A implementations
      https://git.kernel.org/kvmarm/kvmarm/c/84f686790321

--
Best,
Oliver
