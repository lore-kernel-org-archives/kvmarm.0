Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217083D7A
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 19:03:08 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678734185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nhDlaUueHGYKKeFLc5exd84+NUtoJ3lDFXMNBz3LSdg=;
	b=m4hyEG7bkNHPf9cfMhgvuTwGGTmLhvenUVmRkirOI58QCTUKVnLHsV8nm/v1Bd8A5k1suQ
	FBoH8PqPKc8XVp3gtQAZzRAuTqoI9L7CArtNJp63DafE2z+c5AQIm05Py4WUMKl31E/5Za
	DY84kXCtIGCAUXdFrL2jKUCx2pD6xaQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Reiji Watanabe <reijiw@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	stable@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
Date: Mon, 13 Mar 2023 19:02:54 +0000
Message-Id: <167873416494.193819.9004317354249564385.b4-ty@linux.dev>
In-Reply-To: <20230313033208.1475499-1-reijiw@google.com>
References: <20230313033208.1475499-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 12 Mar 2023 20:32:08 -0700, Reiji Watanabe wrote:
> Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
> and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
> file and the current perf event counter value.
> 
> Values of vPMC registers are saved in sysreg files on certain occasions.
> These saved values don't represent the current values of the vPMC
> registers if the perf events for the vPMCs count events after the save.
> The current values of those registers are the sum of the sysreg file
> value and the current perf event counter value.  But, when userspace
> reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
> file value to userspace (not the sum value).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
      https://git.kernel.org/kvmarm/kvmarm/c/9228b26194d1

--
Best,
Oliver
