Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92251C352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 17:21:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A27721906
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 17:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A27721906
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A46344A6CB;
	Tue,  1 Oct 2019 13:21:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UPJGrz-i34uS; Tue,  1 Oct 2019 13:21:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CE04A5C5;
	Tue,  1 Oct 2019 13:21:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6584B4A676
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 13:21:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BnoSWW9IC8BB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 13:21:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09F374A530
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 13:21:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFFF2337;
 Tue,  1 Oct 2019 10:21:50 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFAB93F706;
 Tue,  1 Oct 2019 10:21:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Allow reporting non-ISV data aborts
 to userspace
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
References: <20190909121337.27287-1-christoffer.dall@arm.com>
 <20190909121337.27287-2-christoffer.dall@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <875463bb-caa7-f959-2ffa-7ae8eca04aff@arm.com>
Date: Tue, 1 Oct 2019 18:21:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190909121337.27287-2-christoffer.dall@arm.com>
Content-Language: en-GB
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Christoffer,

On 09/09/2019 13:13, Christoffer Dall wrote:
> For a long time, if a guest accessed memory outside of a memslot using
> any of the load/store instructions in the architecture which doesn't
> supply decoding information in the ESR_EL2 (the ISV bit is not set), the
> kernel would print the following message and terminate the VM as a
> result of returning -ENOSYS to userspace:
> 
>   load/store instruction decoding not implemented
> 
> The reason behind this message is that KVM assumes that all accesses
> outside a memslot is an MMIO access which should be handled by
> userspace, and we originally expected to eventually implement some sort
> of decoding of load/store instructions where the ISV bit was not set.

> However, it turns out that many of the instructions which don't provide
> decoding information on abort are not safe to use for MMIO accesses, and
> the remaining few that would potentially make sense to use on MMIO
> accesses, such as those with register writeback, are not used in
> practice.  It also turns out that fetching an instruction from guest
> memory can be a pretty horrible affair, involving stopping all CPUs on
> SMP systems, handling multiple corner cases of address translation in
> software, and more.  It doesn't appear likely that we'll ever implement
> this in the kernel.

> What is much more common is that a user has misconfigured his/her guest
> and is actually not accessing an MMIO region, but just hitting some
> random hole in the IPA space.  In this scenario, the error message above
> is almost misleading and has led to a great deal of confusion over the
> years.
> 
> It is, nevertheless, ABI to userspace, and we therefore need to
> introduce a new capability that userspace explicitly enables to change
> behavior.
> 
> This patch introduces KVM_CAP_ARM_NISV_TO_USER (NISV meaning Non-ISV)
> which does exactly that, and introduces a new exit reason to report the
> event to userspace.  User space can then emulate an exception to the
> guest, restart the guest, suspend the guest, or take any other
> appropriate action as per the policy of the running system.



> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..02501333f746 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4453,6 +4453,35 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
>  event/message pages and to enable/disable SynIC messages/events processing
>  in userspace.
>  
> +		/* KVM_EXIT_ARM_NISV */
> +		struct {
> +			__u64 esr_iss;
> +			__u64 fault_ipa;
> +		} arm_nisv;
> +
> +Used on arm and arm64 systems. If a guest accesses memory not in a memslot,
> +KVM will typically return to userspace and ask it to do MMIO emulation on its
> +behalf. However, for certain classes of instructions, no instruction decode
> +(direction, length of memory access) is provided, and fetching and decoding
> +the instruction from the VM is overly complicated to live in the kernel.
> +
> +Historically, when this situation occurred, KVM would print a warning and kill
> +the VM. KVM assumed that if the guest accessed non-memslot memory, it was
> +trying to do I/O, which just couldn't be emulated, and the warning message was
> +phrased accordingly. However, what happened more often was that a guest bug
> +caused access outside the guest memory areas which should lead to a more
> +mearningful warning message and an external abort in the guest, if the access
> +did not fall within an I/O window.
> +
> +Userspace implementations can query for KVM_CAP_ARM_NISV_TO_USER, and enable
> +this capability at VM creation. Once this is done, these types of errors will
> +instead return to userspace with KVM_EXIT_ARM_NISV, with the valid bits from
> +the HSR (arm) and ESR_EL2 (arm64) in the esr_iss field, and the faulting IPA
> +in the fault_ipa field. Userspace can either fix up the access if it's
> +actually an I/O access by decoding the instruction from guest memory (if it's
> +very brave) and continue executing the guest, or it can decide to suspend,
> +dump, or restart the guest.

Should we document which parts of instruction-emulation the VMM has to do?

For KVM_EXIT_MMIO, kvm looks after updating registers and advancing the PC and SS state
machine.

I can't see a kvm_skip_instr() in here, so the VMM has to do all of that stuff, including
any register post-increment, which is the reason we need the instruction in the first place.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
