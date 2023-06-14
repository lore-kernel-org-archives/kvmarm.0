Received: from out-26.mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548E110966
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 16:05:28 +0000 (UTC)
Date: Wed, 14 Jun 2023 16:05:16 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>, nd@arm.com
Subject: Re: [PATCH kvmtool 00/21] arm64: Handle PSCI calls in userspace
Message-ID: <ZInlPE/J7W/FLX6P@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230614120503.GA3015626@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614120503.GA3015626@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

Hey Joey,

Thanks for the review and taking the patches for a spin.

On Wed, Jun 14, 2023 at 01:05:03PM +0100, Joey Gouly wrote:
> `kvm_cpu__configure_features` in kvmtool is failing because Linux returns an
> error if SVE was already finalised (arch/arm64/kvm/reset.c):
> 
> ```
> int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
> {
>         switch (feature) {
>         case KVM_ARM_VCPU_SVE:
>                 if (!vcpu_has_sve(vcpu))
>                         return -EINVAL;
> 
>                 if (kvm_arm_vcpu_sve_finalized(vcpu))
>                         return -EPERM; // <---- returns here
> 
>                 return kvm_vcpu_finalize_sve(vcpu);
>         }
> 
>         return -EINVAL;
> }
> ```
> 
> It's not immediately obvious to me why finalising SVE twice is an error.
> Changing that to `return 0;` gets the test passing, but not sure if there
> are other implications.

This is utterly mindless on my part, apologies. The SVE feature
shouldn't be finalised (again). I'll probably drop patch 8 altogether
and replace its usage with a direct call to KVM_ARM_VCPU_INIT.

-- 
Thanks,
Oliver
