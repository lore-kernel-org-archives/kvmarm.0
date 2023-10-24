Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC5721A08
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tAF4FrKS"
Date: Tue, 24 Oct 2023 09:22:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698139358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iQHrjam2voLfNM7Ldr1znGEGuCMfWMBUcs8WR9mD83Y=;
	b=tAF4FrKSXjarPxwHmKlimoCFuzzYK58GpnmGJMTnupIUrxXxHh/UH1SmwLPaWd25Lp990u
	E0Zwt0c1wKr87A3/It1Nu8FEAJOj7JtPvxsdA3BqUqYSwiIFteHPDzhbPPwQDcIHbJJyL4
	nK43fI4eFYu6mI8+wkkgs9vtf3gddic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
Message-ID: <ZTeM2RnMCRFoGsZd@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-5-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-5-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 20, 2023 at 09:40:44PM +0000, Raghavendra Rao Ananta wrote:

[...]

> +int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
> +{
> +	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);

This lockdep assertion is misleading. Readers of kvm_arch::arm_pmu *are
not* serialized by the config_lock.

-- 
Thanks,
Oliver
