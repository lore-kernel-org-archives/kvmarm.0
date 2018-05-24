From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 04/14] arm64: Add ARCH_WORKAROUND_2 probing
Date: Thu, 24 May 2018 12:39:35 +0100
Message-ID: <20180524113933.GA8689@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-5-marc.zyngier@arm.com>
 <6c3e7b31-0bb6-353b-1b82-7ebdf3be1323@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c3e7b31-0bb6-353b-1b82-7ebdf3be1323@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 10:58:43AM +0100, Suzuki K Poulose wrote:
> On 22/05/18 16:06, Marc Zyngier wrote:
> >As for Spectre variant-2, we rely on SMCCC 1.1 to provide the
> >discovery mechanism for detecting the SSBD mitigation.
> >
> >A new capability is also allocated for that purpose, and a
> >config option.
> >
> >Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> 
> >+static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
> >+				    int scope)
> >+{
> >+	struct arm_smccc_res res;
> >+	bool supported = true;
> >+
> >+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
> >+
> >+	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
> >+		return false;
> >+
> >+	/*
> >+	 * The probe function return value is either negative
> >+	 * (unsupported or mitigated), positive (unaffected), or zero
> >+	 * (requires mitigation). We only need to do anything in the
> >+	 * last case.
> >+	 */
> >+	switch (psci_ops.conduit) {
> >+	case PSCI_CONDUIT_HVC:
> >+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> >+				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
> >+		if ((int)res.a0 != 0)
> >+			supported = false;
> >+		break;
> >+
> >+	case PSCI_CONDUIT_SMC:
> >+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> >+				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
> >+		if ((int)res.a0 != 0)
> >+			supported = false;
> >+		break;
> >+
> >+	default:
> >+		supported = false;
> >+	}
> >+
> >+	if (supported) {
> >+		__this_cpu_write(arm64_ssbd_callback_required, 1);
> >+		do_ssbd(true);
> >+	}
> 
> 
> Marc,
> 
> As discussed, we have minor issue with the "corner case". If a CPU
> is hotplugged in which requires the mitigation, after the system has
> finalised the cap to "not available", the CPU could go ahead and
> do the "work around" as above, while not effectively doing anything
> about it at runtime for KVM guests (as thats the only place where
> we rely on the CAP being set).
> 
> But, yes this is real corner case. There is no easy way to solve it
> other than
> 
> 1) Allow late modifications to CPU hwcaps
> 
> OR
> 
> 2) Penalise the fastpath to always check per-cpu setting.

Shouldn't we just avoid bring up CPUs that require the mitigation after
we've finalised the capability to say that it's not required? Assuming this
is just another issue with maxcpus=, then I don't much care for it.

Will
