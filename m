From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 11/13] KVM: arm64: Handle RAS SErrors from EL1 on guest
 exit
Date: Mon, 22 Jan 2018 18:18:54 +0000
Message-ID: <5A662B0E.7060305@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-12-james.morse@arm.com> <20180119192055.GH21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C84A149D9E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 13:16:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bgPdhF9CQMsE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jan 2018 13:15:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BDDE49D32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 13:15:59 -0500 (EST)
In-Reply-To: <20180119192055.GH21802@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 19/01/18 19:20, Christoffer Dall wrote:
> On Mon, Jan 15, 2018 at 07:39:04PM +0000, James Morse wrote:
>> We expect to have firmware-first handling of RAS SErrors, with errors
>> notified via an APEI method. For systems without firmware-first, add
>> some minimal handling to KVM.
>>
>> There are two ways KVM can take an SError due to a guest, either may be a
>> RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
>> or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.
>>
>> For SError that interrupt a guest and are routed to EL2 the existing
>> behaviour is to inject an impdef SError into the guest.
>>
>> Add code to handle RAS SError based on the ESR. For uncontained and
>> uncategorized errors arm64_is_fatal_ras_serror() will panic(), these
>> errors compromise the host too. All other error types are contained:
>> For the fatal errors the vCPU can't make progress, so we inject a virtual
>> SError. We ignore contained errors where we can make progress as if
>> we're lucky, we may not hit them again.
>>
>> If only some of the CPUs support RAS the guest will see the cpufeature
>> sanitised version of the id registers, but we may still take RAS SError
>> on this CPU. Move the SError handling out of handle_exit() into a new
>> handler that runs before we can be preempted. This allows us to use
>> this_cpu_has_cap(), via arm64_is_ras_serror().
> 
> Would it be possible to optimize this a bit later on by caching
> this_cpu_has_cap() in vcpu_load() so that we can use a single
> handle_exit function to process all exits?

If vcpu_load() prevents pre-emption between the guest-exit exception and the
this_cpu_has_cap() test then we wouldn't need a separate handle_exit().

But, if we support kernel-first RAS or firmware-first's NOTIFY_SEI we shouldn't
unmask SError until we've fed the guest-exit:SError into the RAS code. This
would also need the SError related handle_exit() calls to be separate/earlier.
(there was some verbiage on this in the cover letter).

(I started down the 'make handle_exit() non-preemptible', but WF{E,I}'s
kvm_vcpu_block()->schedule() and kvm_vcpu_on_spin()s use of kvm_vcpu_yield_to()
put an end to that).


In terms of caching this_cpu_has_cap() value, is this due to a performance
concern? It's all called behind 'exception_index == ARM_EXCEPTION_EL1_SERROR',
so we've already taken an SError out of the guest. Once its all put together
we're likely to have a pending signal for user-space.
'Corrected' (or at least ignorable) errors are going to be the odd one out, I
don't think we should worry about these!


Thanks,

James
