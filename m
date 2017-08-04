From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 16/16] KVM: arm64: Handle deferred SErrors consumed on
 guest exit
Date: Fri, 4 Aug 2017 15:12:36 +0200
Message-ID: <20170804131236.GC27784@cbox>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-17-james.morse@arm.com>
 <20170801131855.GH5176@cbox> <59835765.7020604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB33349C34
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:11:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9pJjkewYfEyE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Aug 2017 09:11:22 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9913E49C18
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 09:11:21 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id t201so19645942wmt.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Aug 2017 06:12:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <59835765.7020604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 03, 2017 at 06:03:33PM +0100, James Morse wrote:
> Hi Christoffer,
> 
> On 01/08/17 14:18, Christoffer Dall wrote:
> > On Fri, Jul 28, 2017 at 03:10:19PM +0100, James Morse wrote:
> >> On systems with VHE, the RAS extensions and IESB support, KVM gets an
> >> implicit ESB whenever it enters/exits a guest, because the host sets
> >> SCTLR_EL1.IESB.
> >>
> >> To prevent errors being lost, add code to __guest_exit() to read DISR_EL1,
> >> and save it in the kvm_vcpu_fault_info. Add code to handle_exit() to
> >> process this deferred SError. This data is in addition to the reason the
> >> guest exitted.
> > 
> > Two questions:
> > 
> > First, am I reading the spec incorrectly when it says "The implicit form
> > of Error Synchronization Barrier: [...] Has no effect on DISR_EL1 or
> > VDISR_EL2" and I understand this as we wouldn't actually read anything
> > from DISR_EL1 if we rely on the IESB?
> 
> (This is from section 2.4.5 Extension for barrier at exception entry and exit of
> DDI 0587A.)
> 
> Well spotted ... that's embarrassing!

Not at all, that spec is a little dense.

> 
> The DISR write is in the pseudocode's ESBOperation() which is not the same as
> ErrorSynchronizationBarrier(). Running an 'ESB' does both, but an IESB only does
> ErrorSynchronizationBarrier().
> 
> I think this distinction is because the CPU may know about RAS errors it hasn't
> yet made pending SErrors. (they must have to have a severity for the ESR by this
> point).
> 
> So IESB makes hidden RAS errors pending SErrors, it doesn't do what ESB does.
> 
> Yes, this means the DISR_EL1 check on kernel-entry and guest exit is useless.
> Given this the host kernel entry/exit can be simplified, probably getting rid of
> the SError over eret horror. I will need to re-think the KVM changes, (we may
> just need the ESR from the existing vaxorcism code).
> 
> 
> > Second, what if we have several SErrors, and one happens upon entering
> > the guest and another one happens when returning from the guest - do we
> > end up overwriting the DISR_EL1 by only looking at it during exit and
> > potentially miss errors?
> 
> There can only be one pending SError at a time, but if we have PSTATE.A set, a
> pending SError and a hidden RAS error, then ESB must have to pick one to defer,
> and IESB must have to discard one. I suspect the answer is 'implementation
> defined', but I will ask!
> 

As long as we're doing what we can, and we're not missing something that
the architecture gives us a way to retrieve, then that's probably the
best we can do.

> 
> >> Future patches may add a firmware-first callout from
> >> kvm_handle_deferred_serror() to decode CPER records populated by firmware,
> >> or call some arm64 arch code to process the RAS 'ERR' registers for
> >> kernel-first handling. Without either of these, we just make a judgement
> >> on the severity: corrected and restartable errors are ignored, all others
> >> result it an SError being given to the guest.
> > 
> > *in an* ?
> 
> 
> > Why do we give the remaining types of SErrors to the guest?
> 
> Just because that is what KVM does today.
> 
> > What would the kernel normally do for any other workload than running a VM when
> > discovering this type of error?
> 
> I'm trying to make that clearer! Today we 'kill the running task', if its the
> kernel, we would panic(). But because the CPU masks SError on exception entry,
> and we never touch PSTATE.A, its always masked in the kernel, so we take the
> SError and kill the next user space task that gets run.
> 
> We should panic() like we do in the early boot code if an SError was pending
> from firmware.
> 
> 
> Should the host panic because of an SError taken during a guest?, not
> necessarily. All the system registers are save/restored by world-switch, and the
> host doesn't depend on anything in guest memory. The host should be immune to
> any corruption that occurs while a guest was running.
> Gengdongjiu's example of device pass-through is the exception to this reasoning,
> I think we need a way for the host to contain/reset pass-through devices that
> trigger an SError.
> 

I'm not an expert on what can generate the SError.  If it's because the
guest misprogrammed a system register, then it makes sense to just tell
the guest.

However, if this could be related to corrupted memory, or a CPU fault,
or really any resource that the guest is using which can be used by the
host later on (memory, CPU, GIC, passthrough devices, ...) then it feels
a little dangerous to just signal the guest and carry on.

Thanks,
-Christoffer
