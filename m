Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301C3321E
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 18:32:20 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD40315BF;
	Tue,  4 Jul 2023 11:33:00 -0700 (PDT)
Received: from [10.1.37.129] (e126864.cambridge.arm.com [10.1.37.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2543F663;
	Tue,  4 Jul 2023 11:32:15 -0700 (PDT)
Message-ID: <4c92ceb6-34a2-3128-9b26-dd58e4d7612a@arm.com>
Date: Tue, 4 Jul 2023 19:32:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: arm64: Disable preemption in
 kvm_arch_hardware_enable()
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 isaku.yamahata@intel.com, seanjc@google.com, pbonzini@redhat.com,
 stable@vger.kernek.org
References: <20230703163548.1498943-1-maz@kernel.org>
From: Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <20230703163548.1498943-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/07/2023 17:35, Marc Zyngier wrote:
> Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> a guest is running results in a number of ugly splats as most
> of this code expects to run with preemption disabled, which isn't
> the case anymore.
> 
> While the context is preemptable, it isn't migratable, which should
> be enough. But we have plenty of preemptible() checks all over
> the place, and our per-CPU accessors also disable preemption.
> 
> Since this affects released versions, let's do the easy fix first,
> disabling preemption in kvm_arch_hardware_enable(). We can always
> revisit this with a more invasive fix in the future.
> 
> Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
> Cc: stable@vger.kernek.org # v6.3, v6.4

Typo here, didn't make it to the stable list (kernek.org -> kernel.org)

Kristina

