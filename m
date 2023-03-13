Received: from out-26.mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75478828
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 19:03:13 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678734191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eg1s/UHvVY8oZjii/NK613/5yHGvioFeV1O2ojnw3dk=;
	b=vBovC7IYoSHIuliWIuzkN54ze/EW7lQHB5AtvhpvJnNv/0ZSBJbgejLT32QT0zJb+EFUKa
	+OWMuuX44El47AEt85XpRXkmfCL3KgZ/eYxK4A6wyHv+8HOduAKgjeoB7IluwA2YNMZjtd
	uj4mEZYSziB52+jshZvkpQW3QH9iAf8=
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
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
Date: Mon, 13 Mar 2023 19:02:55 +0000
Message-Id: <167873416495.193819.13647538612732773300.b4-ty@linux.dev>
In-Reply-To: <20230313033234.1475987-1-reijiw@google.com>
References: <20230313033234.1475987-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 12 Mar 2023 20:32:34 -0700, Reiji Watanabe wrote:
> Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
> KVM saves the register value, including these bits.
> When userspace reads the register using KVM_GET_ONE_REG, KVM returns
> the saved register value as it is (the saved value might have these
> bits set).  This could result in userspace setting these bits on the
> destination during migration.  Consequently, KVM may end up resetting
> the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
> zero on the first KVM_RUN after migration.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
      https://git.kernel.org/kvmarm/kvmarm/c/f6da81f650fa

--
Best,
Oliver
