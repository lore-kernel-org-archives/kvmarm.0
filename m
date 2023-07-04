Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE64A2C
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 14:33:44 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCD7B1516;
	Tue,  4 Jul 2023 07:34:26 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C9103F73F;
	Tue,  4 Jul 2023 07:33:42 -0700 (PDT)
Date: Tue, 4 Jul 2023 15:33:39 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, tabba@google.com, qperret@google.com,
	will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Message-ID: <20230704143339.cqrvntq7rmmb2on3@bogus>
References: <20230530150845.2856828-1-smostafa@google.com>
 <20230704134136.a5znw4jupt5yp5kg@bogus>
 <ZKQqIYRrckLlXqkx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZKQqIYRrckLlXqkx@google.com>

Hi Mostafa,

On Tue, Jul 04, 2023 at 02:18:09PM +0000, Mostafa Saleh wrote:
> Hi Sudeep,
> 
> On Tue, Jul 04, 2023 at 02:41:36PM +0100, Sudeep Holla wrote:
> > On Tue, May 30, 2023 at 03:08:45PM +0000, Mostafa Saleh wrote:
> > > CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> > > However, the nvhe code doesn't make use of it as it doesn't map any
> > > pages with Guarded Page(GP) bit.
> > > 
> > > kvm pgtable code is modified to map executable pages with GP bit
> > > if BTI is enabled for the kernel.
> > > 
> > > At hyp init, SCTLR_EL2.BT is set to 1 to match EL1 configuration
> > > (SCTLR_EL1.BT1) set in bti_enable().
> > > 
> > > One difference between kernel and nvhe code, is that the kernel maps
> > > .text with GP while nvhe maps all the executable pages, this makes
> > > nvhe code need to deal with special initialization code coming from
> > > other executable sections (.idmap.text).
> > > For this we need to add bti instruction at the beginning of
> > > __kvm_handle_stub_hvc as it can be called by  __host_hvc through
> > > branch instruction(br) and unlike SYM_FUNC_START, SYM_CODE_START
> > > doesn’t add bti instruction at the beginning, and it can’t be modified
> > > to add it as it is used with vector tables.
> > > Another solution which is more intrusive is to convert
> > > __kvm_handle_stub_hvc to a function and inject “bti jc” instead of
> > > “bti c” in SYM_FUNC_START
> > >
> > 
> > I was chasing a bug in linux-next yesterday with protected nVHE(pKVM) and
> > cpuidle enabled. The system fails to boot. I just bisected the issue to this
> > patch and also saw this patch landed in the linus tree yesterday/today.
> 
> One of the challenges of BTI is that we need to add explicit BTI instructions
> for assembly code. I checked the code to make sure that nothing was missing,
> but maybe this is not the case.
> Can you please share more about the issue (is ESR a Branch Target Exception,
> call stack...) if possible.

I haven't debugged it any further, just reported it as soon as I bisected it.
Reverting this get back the booting system. I am not sure if anything is going
wrong when the CPU is entering suspend(highly unlikely in normal scenario but
I am not so sure with pKVM trapping these PSCI calls now) or when it is woken
up and resuming back. IIUC this now will happen via kvm_hyp_cpu_resume->
__kvm_hyp_init_cpu->___kvm_hyp_init. 

> Also, is this with CONFIG_ARM_PSCI_CPUIDLE?

Yes, basically the cpus can enter cpu_suspend which IIUC pKVM traps and
handle for the host.

> 
> > Not sure if this is something to do with the fact that pKVM skips to
> > __kvm_handle_stub_hvc in __host_hvc.

Sorry, my bad. I meant pKVM skips calling __kvm_handle_stub_hvc in __host_hvc
and jumps to __host_exit directly. Sorry for that, one wrong "to" changed the
whole meaning.

> __kvm_handle_stub_hvc is called from __host_hvc with "br x5"
> That's why "bti j" was added at the beginning of __kvm_handle_stub_hvc,
> so this should be fine.
>

Yes I saw that and understood that but I wanted to tell the above which went
horribly wrong before.

-- 
Regards,
Sudeep
