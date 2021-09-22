Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13969C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 10:11:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89A1E61168
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 10:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 89A1E61168
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 078A840C88;
	Wed, 22 Sep 2021 06:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wpiQECMtL87r; Wed, 22 Sep 2021 06:11:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9DB4B089;
	Wed, 22 Sep 2021 06:11:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3751C40C88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 06:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CSRSI7iK8oud for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 06:11:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8F14064F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 06:11:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA1FF11B3;
 Wed, 22 Sep 2021 03:11:46 -0700 (PDT)
Received: from [10.57.95.67] (unknown [10.57.95.67])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F34A3F719;
 Wed, 22 Sep 2021 03:11:45 -0700 (PDT)
Subject: Re: [RFC PATCH v4 00/39] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
To: Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
 james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, linux-kernel@vger.kernel.org
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <963f68c8-b109-7ebb-751d-14ce46e3cdde@arm.com>
Date: Wed, 22 Sep 2021 11:11:44 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
Content-Language: en-GB
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 25/08/2021 17:17, Alexandru Elisei wrote:
> This is v4 of the SPE series posted at [1]. v2 can be found at [2], and the
> original series at [3].
> 
> Statistical Profiling Extension (SPE) is an optional feature added in
> ARMv8.2. It allows sampling at regular intervals of the operations executed
> by the PE and storing a record of each operation in a memory buffer. A high
> level overview of the extension is presented in an article on arm.com [4].
> 
> This is another complete rewrite of the series, and nothing is set in
> stone. If you think of a better way to do things, please suggest it.
> 
> 
> Features added
> ==============
> 
> The rewrite enabled me to add support for several features not
> present in the previous iteration:
> 
> - Support for heterogeneous systems, where only some of the CPUs support SPE.
>    This is accomplished via the KVM_ARM_VCPU_SUPPORTED_CPUS VCPU ioctl.
> 
> - Support for VM migration with the KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_STOP)
>    VCPU ioctl.
> 
> - The requirement for userspace to mlock() the guest memory has been removed,
>    and now userspace can make changes to memory contents after the memory is
>    mapped at stage 2.
> 
> - Better debugging of guest memory pinning by printing a warning when we
>    get an unexpected read or write fault. This helped me catch several bugs
>    during development, it has already proven very useful. Many thanks to
>    James who suggested when reviewing v3.
> 
> 
> Missing features
> ================
> 
> I've tried to keep the series as small as possible to make it easier to review,
> while implementing the core functionality needed for the SPE emulation. As such,
> I've chosen to not implement several features:
> 
> - Host profiling a guest which has the SPE feature bit set (see open
>    questions).
> 
> - No errata workarounds have been implemented yet, and there are quite a few of
>    them for Neoverse N1 and Neoverse V1.
> 
> - Disabling CONFIG_NUMA_BALANCING is a hack to get KVM SPE to work and I am
>    investigating other ways to get around automatic numa balancing, like
>    requiring userspace to disable it via set_mempolicy(). I am also going to
>    look at how VFIO gets around it. Suggestions welcome.
> 
> - There's plenty of room for optimization. Off the top of my head, using
>    block mappings at stage 2, batch pinning of pages (similar to what VFIO
>    does), optimize the way KVM keeps track of pinned pages (using a linked
>    list triples the memory usage), context-switch the SPE registers on
>    vcpu_load/vcpu_put on VHE if the host is not profiling, locking
>    optimizations, etc, etc.
> 
> - ...and others. I'm sure I'm missing at least a few things which are
>    important for someone.
> 
> 
> Known issues
> ============
> 
> This is an RFC, so keep in mind that almost definitely there will be scary
> bugs. For example, below is a list of known issues which don't affect the
> correctness of the emulation, and which I'm planning to fix in a future
> iteration:
> 
> - With CONFIG_PROVE_LOCKING=y, lockdep complains about lock contention when
>    the VCPU executes the dcache clean pending ops.
> 
> - With CONFIG_PROVE_LOCKING=y, KVM will hit a BUG at
>    kvm_lock_all_vcpus()->mutex_trylock(&vcpu->mutex) with more than 48
>    VCPUs.
> 
> This BUG statement can also be triggered with mainline. To reproduce it,
> compile kvmtool from this branch [5] and follow the instruction in the
> kvmtool commit message.
> 
> One workaround could be to stop trying to lock all VCPUs when locking a
> memslot and document the fact that it is required that no VCPUs are run
> before the ioctl completes, otherwise bad things might happen to the VM.
> 
> 
> Open questions
> ==============
> 
> 1. Implementing support for host profiling a guest with the SPE feature
> means setting the profiling buffer owning regime to EL2. While that is in
> effect,  PMBIDR_EL1.P will equal 1. This has two consequences: if the guest
> probes SPE during this time, the driver will fail; and the guest will be
> able to determine when it is profiled. I see two options here:

This doesn't mean the EL2 is owning the SPE. It only tells you that a
higher level EL is owning the SPE. It could as well be EL3. (e.g, 
MDCR_EL3.NSPB == 0 or 1). So I think this is architecturally correct,
as long as we trap the guest access to other SPE registers and inject
and UNDEF.


Thanks
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
