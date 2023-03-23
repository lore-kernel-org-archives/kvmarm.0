Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E525AD2FB
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 22:48:39 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 632CD4B3;
	Thu, 23 Mar 2023 15:49:23 -0700 (PDT)
Received: from [192.168.122.164] (U203867.austin.arm.com [10.118.30.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27FE63F766;
	Thu, 23 Mar 2023 15:48:32 -0700 (PDT)
Message-ID: <b5afbc8d-e2cd-ce13-4089-e18339c14562@arm.com>
Date: Thu, 23 Mar 2023 17:48:29 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fix vcpu->mutex v. kvm->lock inversion
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
From: Jeremy Linton <jeremy.linton@arm.com>
In-Reply-To: <20230316211412.2651555-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/16/23 16:14, Oliver Upton wrote:
> As it so happens, lock ordering in KVM/arm64 is completely backwards.
> There's a significant amount of VM-wide state that needs to be accessed
> from the context of a vCPU. Until now, this was accomplished by
> acquiring the kvm->lock, but that cannot be nested within vcpu->mutex.
> 
> This series fixes the issue with some fine-grained locking for MP state
> and a new, dedicated mutex that can nest with both kvm->lock and
> vcpu->mutex.
> 
> Tested with kvmtool and QEMU scaled up to 64 vCPUs on a kernel w/
> lockdep enabled. Applies to kvmarm/next.

This set makes the reported lockdep error go away for me, it also 
appears to complete some basic kernel/kvm testing without error as well. So,

Tested-by: Jeremy Linton <jeremy.linton@arm.com>


Thanks,

> 
> v1: http://lore.kernel.org/kvmarm/20230308083947.3760066-1-oliver.upton@linux.dev
> 
> v1 -> v2:
>   - Add a dedicated lock for serializing writes to MP state
>   - Inform lockdep of acquisition order at time of VM/vCPU creation
>   - Plug a race with GIC creation (Sean)
>   - Use the config_lock in GIC ITS flows as well. There is now a single
>     (valid) use of kvm->lock when enabling MTE.
> 
> Oliver Upton (4):
>    KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
>    KVM: arm64: Avoid lock inversion when setting the VM register width
>    KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
>    KVM: arm64: Use config_lock to protect vgic state
> 
>   arch/arm64/include/asm/kvm_host.h     |  4 ++
>   arch/arm64/kvm/arm.c                  | 45 +++++++++++++++++++----
>   arch/arm64/kvm/guest.c                |  2 +
>   arch/arm64/kvm/hypercalls.c           |  4 +-
>   arch/arm64/kvm/pmu-emul.c             | 23 +++---------
>   arch/arm64/kvm/psci.c                 | 19 +++++-----
>   arch/arm64/kvm/reset.c                | 16 ++++----
>   arch/arm64/kvm/vgic/vgic-debug.c      |  8 ++--
>   arch/arm64/kvm/vgic/vgic-init.c       | 33 ++++++++++-------
>   arch/arm64/kvm/vgic/vgic-its.c        | 29 ++++++---------
>   arch/arm64/kvm/vgic/vgic-kvm-device.c | 53 ++++++++++++---------------
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  4 +-
>   arch/arm64/kvm/vgic/vgic-mmio.c       | 12 +++---
>   arch/arm64/kvm/vgic/vgic-v4.c         | 11 +++---
>   arch/arm64/kvm/vgic/vgic.c            |  2 +-
>   15 files changed, 146 insertions(+), 119 deletions(-)
> 

