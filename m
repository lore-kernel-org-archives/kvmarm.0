Received: from out-87.mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C61426E
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 19:52:57 +0000 (UTC)
Date: Fri, 28 Jul 2023 19:52:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690573975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQnXf4XQhMtZfBROiaMu1NxfovrLksRnYCtkHo8F1w0=;
	b=oZ81VoC3a5IgdTQygqqElR6r0AxdAOElqtYvotppOy3ruvmJ5NITRrT6CV2P7SvVrgCddn
	qiwEq0J+0FjYYl+WXmz3jsg6GaNbQ35Xw9szgkq7AqaN3d1jfSDW13dFzWX5ClJ0YjysA6
	0lU36L2w/JLq3ul0BQimzqJSvi5FEqs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform
 PMUVer systems
Message-ID: <ZMQckrDB7tg9gPfw@linux.dev>
References: <20230728181907.1759513-1-reijiw@google.com>
 <20230728181907.1759513-3-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728181907.1759513-3-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 28, 2023 at 11:19:04AM -0700, Reiji Watanabe wrote:
> Disallow userspace from configuring vPMU for guests on systems
> where the PMUVer is not uniform across all PEs.
> KVM has not been advertising PMUv3 to the guests with vPMU on
> such systems anyway, and such systems would be extremely
> uncommon and unlikely to even use KVM.

This doesn't actually disallow userspace from configuring a vPMU, it
only hides the KVM cap. kvm_host_pmu_init() will still insert the host
PMU instance in the list of valid PMUs, and there doesn't appear to be
any check against the static key anywhere on that path.

FWIW, this static key is actually responsible for indicating whether KVM
supports context switching the PMU between host/guest. While vPMU obviously
depends on that, the perf subsystem also allows the host to program events
to count while the guest is running.

I actually prefer where we flip the static key, as PMU context switching
depends on both KVM support as well as the PMU driver coming up successfully.
Instead, you could hoist the check against the sanitised PMU version into
kvm_host_pmu_init(), maybe something like:

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 560650972478..f6a0e558472f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -672,8 +672,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
-	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+	/*
+	 * Check the sanitised PMU version for the system, as KVM does not
+	 * support implementations where PMUv3 exists on a subset of CPUs.
+	 */
+	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
 		return;
 
 	mutex_lock(&arm_pmus_lock);

-- 
Thanks,
Oliver
