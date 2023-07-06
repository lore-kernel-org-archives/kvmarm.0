Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154AB8C17
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 16:23:16 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2C23D75;
	Thu,  6 Jul 2023 09:23:56 -0700 (PDT)
Received: from bogus (unknown [10.57.76.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 210013F762;
	Thu,  6 Jul 2023 09:23:11 -0700 (PDT)
Date: Thu, 6 Jul 2023 17:23:08 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Add missing BTI instructions
Message-ID: <20230706162308.kyeitspgfaqb6vgn@bogus>
References: <20230706152240.685684-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230706152240.685684-1-smostafa@google.com>

On Thu, Jul 06, 2023 at 03:22:40PM +0000, Mostafa Saleh wrote:
> Some bti instructions were missing from
> commit b53d4a272349 ("KVM: arm64: Use BTI for nvhe")
> 
> 1) kvm_host_psci_cpu_entry
> kvm_host_psci_cpu_entry is called from __kvm_hyp_init_cpu through "br"
> instruction as __kvm_hyp_init_cpu resides in idmap section while
> kvm_host_psci_cpu_entry is in hyp .text so the offset is larger than
> 128MB range covered by "b".
> Which means that this function should start with "bti j" instruction.
> 
> LLVM which is the only compiler supporting BTI for Linux, adds "bti j"
> for jump tables or by when taking the address of the block [1].
> Same behaviour is observed with GCC.
> 
> As kvm_host_psci_cpu_entry is a C function, this must be done in
> assembly.
> 
> Another solution is to use X16/X17 with "br", as according to ARM
> ARM DDI0487I.a RLJHCL/IGMGRS, PACIASP has an implicit branch
> target identification instruction that is compatible with
> PSTATE.BTYPE 0b01 which includes "br X16/X17"
> And the kvm_host_psci_cpu_entry has PACIASP as it is an external
> function.
> Although, using explicit "bti" makes it more clear than relying on
> which register is used.
> 
> A third solution is to clear SCTLR_EL2.BT, which would make PACIASP
> compatible PSTATE.BTYPE 0b11 ("br" to other registers).
> However this deviates from the kernel behaviour (in bti_enable()).
> 
> 2) Spectre vector table
> "br" instructions are generated at runtime for the vector table
> (__bp_harden_hyp_vecs).
> These branches would land on vectors in __kvm_hyp_vector at offset 8.
> As all the macros are defined with valid_vect/invalid_vect, it is
> sufficient to add "bti j" at the correct offset.
> 
> [1] https://reviews.llvm.org/D52867
> 
> Fixes: b53d4a272349 ("KVM: arm64: Use BTI for nvhe")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Reported-by: Sudeep Holla <sudeep.holla@arm.com>

Nothing change w.r.t cpu suspend-resume path in v2 anyways, but I assure
I tested this again just be absolutely sure and it still fixes the issue
I reported 😄, so

Tested-by: Sudeep Holla <sudeep.holla@arm.com>

-- 
Regards,
Sudeep
