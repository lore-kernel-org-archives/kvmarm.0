Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC51C48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:43:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52E18613EA
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:43:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52E18613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FFA4B096;
	Fri, 11 Jun 2021 08:43:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5szj42nm0aU; Fri, 11 Jun 2021 08:43:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87DB94A4E5;
	Fri, 11 Jun 2021 08:43:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CBF94A418
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E6M8nx5AA3mu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 08:43:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3FBA40256
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:43:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4245DD6E;
 Fri, 11 Jun 2021 05:43:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95AE53F73D;
 Fri, 11 Jun 2021 05:43:15 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.cs.columbia.edu
References: <20210608141141.997398-1-tabba@google.com>
Message-ID: <e32d28f3-4ba6-4b5d-a5a2-7362a4010583@arm.com>
Date: Fri, 11 Jun 2021 13:44:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi,

On 6/8/21 3:11 PM, Fuad Tabba wrote:
> Hi,
>
> This patch series adds support for restricting CPU features for protected VMs
> in KVM [1].
>
> Various feature configurations are allowed in KVM/arm64. Supporting all
> these features in pKVM is difficult, as it either involves moving much of
> the handling code to EL2, which adds bloat and results in a less verifiable
> trusted code base. Or it involves leaving the code handling at EL1, which
> risks having an untrusted host kernel feeding wrong information to the EL2
> and to the protected guests.
>
> This series attempts to mitigate this by reducing the configuration space,
> providing a reduced amount of feature support at EL2 with the least amount of
> compromise of protected guests' capabilities.
>
> This is done by restricting CPU features exposed to protected guests through
> feature registers. These restrictions are enforced by trapping register
> accesses as well as instructions associated with these features, and injecting
> an undefined exception into the guest if it attempts to use a restricted
> feature.
>
> The features being restricted (only for protected VMs in protected mode) are
> the following:
> - Debug, Trace, and DoubleLock
> - Performance Monitoring (PMU)
> - Statistical Profiling (SPE)
> - Scalable Vector Extension (SVE)
> - Memory Partitioning and Monitoring (MPAM)
> - Activity Monitoring (AMU)
> - Memory Tagging (MTE)
> - Limited Ordering Regions (LOR)
> - AArch32 State
> - Generic Interrupt Controller (GIC) (depending on rVIC support)
> - Nested Virtualization (NV)
> - Reliability, Availability, and Serviceability (RAS) above V1
> - Implementation-defined Features
>
> This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> ABI [1]. You can find the applied series here [2].

Since this is implementing the kernel side of an RFC userspace ABI, I'm going to
treat the series as an RFC also and not go into the individual patches.

What strikes me as odd is the fact that, as far as I can tell, you're duplicating
part of the kvm/sys_regs.c and kvm/handle_exit.c functionality in the nvhe code.
Why was this approach chosen instead of reusing the existing functions and adding
extra code to handle the protected VM case?

Another example of this is detecting when a host dropped to 32bit EL0, the comment
says that you don't trust the host to make the check. What exactly do you trust
the host to do at what point? I don't see this explained anywhere, it's possible
I've missed it.

I also think that registers that mostly don't change during the lifetime of the VM
(HCR_EL2, CPTR_EL2, MDCR_EL2) can be set by host when the VM becomes protected,
instead of fiddling with them at each world switch. Was there a particular reason
for changing them in __activate_traps_pvm() or was this just an implementation choice?

Thanks,

Alex

> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
>
> For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> https://www.youtube.com/watch?v=edqJSzsDRxk
>
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
