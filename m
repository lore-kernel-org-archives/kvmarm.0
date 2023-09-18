Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694A14AA5
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7AC433C8;
	Mon, 18 Sep 2023 10:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695033634;
	bh=mfTaBjYA8HHTuisBF3KK0QkdJTAjBxJvpOzzYrlDNk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i1auMnEBV0IIbkZj7b5zMuVtDCupKfx6QXVclJ9FEr5S9WDXQeP0VC3mvkhmYNjDa
	 SgVfoS8D+QD1Q0gtmekwcbCfhu7bNQdfJlUVOWLzUG740S6ZDHj3xiQwPTh70kumut
	 Js6JOvG/QXdHCbrBxIVbCtb9hmh5FpuaA9150V0rgcmPq2YhDQP3W/YiBYs8FDWP7x
	 o5P0zhjNNGdA+g57TMY4IcF6G0DnRNtiCjNEOPrccuh9GPn24m1ZXVLCBA2LIow+ip
	 7BBuIB7Xe5/YETeOeRs7BNKr3quCFEr6th+FnQSEpfr5rxavTD1YbOH9Myu32IY9rG
	 WtOTzy0M0XefA==
Date: Mon, 18 Sep 2023 11:40:28 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool v3 08/17] Add helpers to pause the VM from vCPU
 thread
Message-ID: <20230918104028.GA17744@willie-the-truck>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
 <20230802234255.466782-9-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802234255.466782-9-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Aug 02, 2023 at 11:42:46PM +0000, Oliver Upton wrote:
> Pausing the VM from a vCPU thread is perilous with the current helpers,
> as it waits indefinitely for a signal that never comes when invoked from
> a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
> working around the issue by explicitly marking the caller as paused
> before proceeding.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  include/kvm/kvm-cpu.h |  3 +++
>  kvm-cpu.c             | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 0f16f8d6e872..9a4901bf94ca 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
>  void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
>  void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
>  
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
> +
>  #endif /* KVM__KVM_CPU_H */
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 1c566b3f21d6..9adc9d4f7841 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -141,6 +141,22 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
>  	mutex_unlock(&task_lock);
>  }
>  
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> +{
> +	/*
> +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> +	 * signal exit.
> +	 */
> +	vcpu->paused = true;
> +	kvm__pause(vcpu->kvm);
> +}
> +
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> +{
> +	vcpu->paused = false;
> +	kvm__continue(vcpu->kvm);
> +}

Why is it safe to manipulate 'vcpu->paused' here without the pause_lock
held? Relatedly, how does this interact with the 'pause' and 'resume'
lkvm commands?

Will
