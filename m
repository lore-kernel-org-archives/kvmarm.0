Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCCBA3E
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 15:55:26 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680623724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rveLR/xMgdd42NYml6Br2i5T3+ij1eezzlv9OLDm9ps=;
	b=MCSttQfTASTgr2cFaO77Ktg62vc5o6WODh+5awdXCnscth56jqDXSc08J8dwhR1UQgSTPi
	L2MxRlmud8ytWzVboDIrY2FFWxDlX6ktnPwx1Zb9G5vejbIoCrriZkAdJJ6EZZP+ko4U84
	e3CZfRX51m0wd5hsXFbfvMVJse9KxAY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ricardo Koller <ricarkol@google.com>,
	Will Deacon <will@kernel.org>,
	stable@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: PMU: Restore the guest's EL0 event counting after migration
Date: Tue,  4 Apr 2023 15:55:01 +0000
Message-Id: <168062368624.2273324.12077737366076626485.b4-ty@linux.dev>
In-Reply-To: <20230329023944.2488484-1-reijiw@google.com>
References: <20230329023944.2488484-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 28 Mar 2023 19:39:44 -0700, Reiji Watanabe wrote:
> Currently, with VHE, KVM enables the EL0 event counting for the
> guest on vcpu_load() or KVM enables it as a part of the PMU
> register emulation process, when needed.  However, in the migration
> case (with VHE), the same handling is lacking, as vPMU register
> values that were restored by userspace haven't been propagated yet
> (the PMU events haven't been created) at the vcpu load-time on the
> first KVM_RUN (kvm_vcpu_pmu_restore_guest() called from vcpu_load()
> on the first KVM_RUN won't do anything as events_{guest,host} of
> kvm_pmu_events are still zero).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: PMU: Restore the guest's EL0 event counting after migration
      https://git.kernel.org/kvmarm/kvmarm/c/f9ea835e99bc

--
Best,
Oliver
