Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E273FC5DA;
	Mon, 15 Jun 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781534524; cv=none; b=ScFXAE5SUfnNOtKH33YnvzZ5s4S3FCywjYKFwID0w+dnlgbnh3kRQfLmx7p26MfUQsmXrXC0h0qYNAMq+HxBzCMExGzaAdvkefiSBuEIx63i68zMxUkjKyv4hhkMX+uIV7bXhYOj65rg5Q67vr+kVXTwroZqIbuU/WENcdsBRXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781534524; c=relaxed/simple;
	bh=WXmNN7eBg1kkTensusJOsEaKhj8nNZ8x4XGVisA/zQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FG/WghsdUVW7O+eaKvkV8tJxdXyDihpYsgJdriWnkGbyPlKFeVZvLWD4l/7XGQ+u1CMbugnohqMlyhkrt/HcsNPW0p+SDOMY8lXCrnbuChECjTS6LxR+nCEnJsLyP+UPVfkE5GZorUpQ/jaFXPC+3x3jEsXJZatyjRqjrudWWs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn6Hqzof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn6Hqzof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242B11F00A3D;
	Mon, 15 Jun 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781534522;
	bh=auW1SfhDQCopf2sqbS7z5c5X4NMG5lhVtX6nJa90VUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hn6HqzofiMp1J+MkJ22YKx6X41bjqOe4pc93PbjxEY658MVSZpgC5S5297ySbBD1e
	 6k/1tAxSWf8f+QouLflwIw21yUxKJvgKSPMJCyVr3uEKXqdpwnFcUrvgP7C4OGU4jO
	 TBqP2Rz5onP4JJL8s+wnWiMGILdcRV7heWWyNcbLyg+8MIOFY7aCNiOC4YRk8pJvxS
	 /ExiqY4iZPxlgfB9SSAPaJdM04rimCEj6whKSuJpLK6OVYlBDkO+3Qo4wNBz5Elae7
	 ocn69VmwJXqUMoDpS86H6nPAKBeCrzxDLh57XvRFwRsk1Du2D1z+qEPth3d3feL4oA
	 7TMkzvG2Kt1Rg==
Date: Mon, 15 Jun 2026 15:41:56 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
Message-ID: <ajAPNFDsQ63k_jAS@willie-the-truck>
References: <20260612113414.1022901-1-tabba@google.com>
 <ai_OevUNS-OACPm7@willie-the-truck>
 <CA+EHjTyMOoCLQ7d6+TgkrnOJF-PV9K-BKtb4CNuAg8p4gtg6wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyMOoCLQ7d6+TgkrnOJF-PV9K-BKtb4CNuAg8p4gtg6wg@mail.gmail.com>

On Mon, Jun 15, 2026 at 11:52:10AM +0100, Fuad Tabba wrote:
> On Mon, 15 Jun 2026 at 11:05, Will Deacon <will@kernel.org> wrote:
> >
> > On Fri, Jun 12, 2026 at 12:34:14PM +0100, Fuad Tabba wrote:
> > > When pKVM injects a synchronous exception into a protected guest, it
> > > re-enters without restoring the guest's EL1 sysregs and writes the EL1
> > > exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
> > > SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
> > > only in memory, so the guest's handler reads a stale SPSR_EL1 and
> > > restores the wrong PSTATE on eret.
> > >
> > > Write SPSR_EL1 alongside the other exception registers.
> > >
> > > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> > > Reported-by: sashiko <sashiko@sashiko.dev>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > index 8c3fbb413a06..1a7d5cd16d72 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
> > >
> > >       write_sysreg_el1(esr, SYS_ESR);
> > >       write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > > +     write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
> > >       write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > >       write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > >  }
> >
> > Is SPSR_EL1 not set in enter_exception64() using vcpu_cpsr(vcpu), which
> > *is* set here? I'm just a bit wary of the report, as I'd have expected
> > fireworks if we weren't initialising the guest's SPSR on the exception
> > injection path.
> 
> Yes, enter_exception64() sets SPSR_EL1, but only in memory:
> __vcpu_write_spsr() takes the nVHE path and calls
> __vcpu_assign_sys_reg(vcpu, SPSR_EL1, val), which writes
> vcpu->arch.ctxt.sys_regs[SPSR_EL1] without touching the hardware
> register.
> 
> In the normal nVHE entry path that memory value reaches hardware via
> __sysreg_restore_state_nvhe() before __guest_enter(). But
> inject_sync64() runs inside the fixup_guest_exit() loop, which
> re-enters the guest directly without a sysreg restore pass. ESR_EL1
> and ELR_EL1 are already written to hardware by hand for this reason
> but SPSR_EL1 was missed.

Ah, I see. Does that mean that all the in-memory updates performed by
enter_exception64() (e.g. the construction of the cpsr) are ignored too?

Will
