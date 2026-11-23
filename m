Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456255;
	b=iMEj5Vwoa3f5ky4lr6rkqicnjW5WI/4kyTMvc7YJHKzhUjjtRTL85btZpJZvtzIPsNnW
	 x72VBgm3lFXT1vOo0cz3VwcSFinuREbaFXJhfO84FrtJv4OB3wKltO4zsAv6i24cG1/sg
	 e5ekrG2B30t8Nh48v3OtG4lFZjdPA0tC4OncS6mL+o5xmdRXh2WomaehChvlIiftqHJkN
	 OzIMIe7PqeD8wOdA92bEkpkNC3iP653pwBmSUXIbYWUnr+mBxCsOCekLLmcD4/0MdXtGm
	 OwzUrztUbB5Kk4v0uD/NsUVxwuERMKxPETxU9k3ePIPzbVw/RgfXWjQ+lIKljDzUxMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456255;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BmdihYOxirTm+1eTZLfQO693ehUdXJrj7zcBiNWtsTU=;
	b=EI63RUyGy9TUVrDVSmQG04oVxXV9eQa/apzL6GLlMUutVogwyYZQIJZvPAoTne489k5Q
	 Jfsy67/6Q6Vg+DCLOB8mlT36pCx4ePiJWLnDuKbIyc48o0kmE5DuBeK/MquHGbG1wjhKp
	 ewHP0j7Ate5HmtjS++EXUwyQl6hijFYmBd0rP1LWxhLjwl6y+JAdLNJRQdPScAd72S/89
	 36pzyyDSpPm0L4lfQkykQVrQnoVcUdFaJ36xGc2ysVKujAhWT2bla938ETBicE53z6aN0
	 nPLDCFzQcVEMxaoMEeR35OY7AvN86qhaqhEfFxpVEiNyYKvnTGBXGfi79tiucOcj+XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSRmqnb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54937606A32E;
	Mon, 23 Nov 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nSRmqnb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654B31F000E1;
	Mon, 23 Nov 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795456254;
	bh=BmdihYOxirTm+1eTZLfQO693ehUdXJrj7zcBiNWtsTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nSRmqnb+fUbrWxvbElJY6njf1lvjAVkusLXLFpjaFxEgQ+kYXgZgf4ZMN68xKQ+YZ
	 ZDuOeDeOvEWuXxAdz4qv+/1uDMRZHkpDyX1hQ1mnfoWDZcWUddJmIEI6qTPdBUTbDg
	 awoNG1kWDag7/uPxC53z6rUsK6vHnGFypQu7hk2+cVKf5+sypF3nTrEcss5aYpXMw+
	 xoDcJp5Jg6FpDbcSSK1DeP6iO6/SlQUJfg6gEnYBS9hlbKJYlzvCxsOFMRDYGV3Chi
	 5TT1OusQZKg4Q+PiFJOYRjcC7vso4DnCTC4vreS0mgIU0gaaEptbrENdnfFZRF2lxm
	 Et+USmiUgrwyw==
Date: Mon, 23 Nov 2026 17:50:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Jia He <justin.he@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Message-ID: <awR4AzA5xeyNmz7i@gremlin>
References: <20261123150917.2679600-1-justin.he@arm.com>
 <20261123150917.2679600-2-justin.he@arm.com>
 <86eccbzcqh.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86eccbzcqh.wl-maz@kernel.org>

On Mon, Nov 23, 2026 at 05:20:06PM +0000, Marc Zyngier wrote:
> [+ Lorenzo]
>
> Hey Jia,
>
> On Mon, 23 Nov 2026 15:09:15 +0000,
> Jia He <justin.he@arm.com> wrote:
> >
> > KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as KVM_ARM_VCPU_INIT has
> > completed. On arm64, however, kvm->arch.sysreg_masks, the trap
> > configuration, vncr_tlb and nested vGIC state are only set up on the
> > first KVM_RUN in kvm_arch_vcpu_run_pid_change().
>
> I think I'm going to queue a patch disabling prefaulting immediately,
> and then we can fix this crap.

Ack, will prioritise looking through Jia's series.

>
> >
> > Running the full vcpu_load() path before then reads unsanitised guest
> > sysregs and touches uninitialised nested state: get_s2_mmu_nested()
> > populates nested_mmus[] from raw VTTBR_EL2/VTCR_EL2/HCR_EL2 values, FGT
> > and HCRX_EL2 are written before kvm_calculate_traps() has run, and
> > kvm_vgic_load() can enter vgic_v3_load_nested() early. In particular, if
> > userspace creates an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac cleared to 0
> > (so vncr_tlb is never allocated), sets HCR_EL2.NV=1 and an EL1 PSTATE,
> > and calls KVM_PRE_FAULT_MEMORY, kvm_vcpu_load_hw_mmu() queues
> > KVM_REQ_MAP_L1_VNCR_EL2. The next KVM_RUN then dereferences a NULL
> > vncr_tlb in kvm_map_l1_vncr() with preemption disabled and kvm->mmu_lock
> > held for read:
> >
> >   [   73.636014] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000078
> >   [   73.801972] pc : kvm_map_l1_vncr+0x48/0x2d0
> >   [   73.884820] Call trace:
> >   [   73.887253]  kvm_map_l1_vncr+0x48/0x2d0 (P)
> >   [   73.891422]  check_nested_vcpu_requests+0xb8/0x168
> >   [   73.896200]  check_vcpu_requests+0x2a0/0x428
> >   [   73.900458]  kvm_arch_vcpu_ioctl_run+0x2d8/0x6d8
> >   [   73.905062]  kvm_vcpu_ioctl+0x388/0xaf0
> >
> > KVM_PRE_FAULT_MEMORY still needs generic vcpu_load() to set
> > kvm_running_vcpu for dirty-ring tracking in mark_page_dirty_in_slot(),
> > but kvm_arch_vcpu_pre_fault_memory() only walks and populates
> > &kvm->arch.mmu and does not use any hardware vCPU state. Skip the arch
> > vcpu_load()/vcpu_put() callbacks until vcpu_has_run_once() is true. In
> > KVM_RUN, vcpu->pid is set under vcpu->mutex right after
> > kvm_arch_vcpu_run_pid_change() succeeds and before
> > kvm_arch_vcpu_ioctl_run() calls vcpu_load().
> >
> > Since kvm_running_vcpu can now be set without VHE state on the CPU, use
> > host_ctxt->__hyp_running_vcpu in VHE enter_vmid_context() (matching
> > nVHE)
>
> Can you clarify under which circumstances we end-up on the TLB
> invalidation path? Simply faulting things in should not result in
> invalidation. Unless we end-up with MMU notifiers firing?

Yeah I think the issue is that an enter_vmid_context() /
exit_vmid_context() pair flushing some other MMU could end up writing
the vCPU's (canonical) hw_mmu into VTTBR_EL2/VTCR_EL2 on exit, even
though it was never loaded in the first place.

But that would just get overwritten when next loaded anyway?

So I think it's probably the right change but makes no difference in
practice ATM?

>
> > and check vcpu_has_run_once() in vgic_maintenance_handler().
>
> I have similar questions here. It isn't obvious how you end-up getting
> a VGIC MI if you don't run and don't load the state on the CPU.

Yeah I don't think there is a way? Maybe this is just defensive?

>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo
