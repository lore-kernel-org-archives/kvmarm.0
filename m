Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55474C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 12:33:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B0C49B0E;
	Tue, 18 Jan 2022 07:33:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Euftzl3NIjNV; Tue, 18 Jan 2022 07:33:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452E649AFD;
	Tue, 18 Jan 2022 07:33:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F3D49AFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 07:33:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m9lJvAlzzwSu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 07:33:03 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 899D040B68
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 07:33:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC7B613EA;
 Tue, 18 Jan 2022 12:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF26C00446;
 Tue, 18 Jan 2022 12:32:58 +0000 (UTC)
Date: Tue, 18 Jan 2022 12:32:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Message-ID: <Yeazd1lLuYm4k3lH@arm.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
Cc: jean-philippe@linaro.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, jonathan.cameron@huawei.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Shameer,

On Mon, Nov 22, 2021 at 12:18:40PM +0000, Shameer Kolothum wrote:
> =A0-TLA+ model. Modified the asidalloc model to incorporate the new
>   VMID algo. The main differences are,
> =A0 -flush_tlb_all() instead of local_tlb_flush_all() on rollover.
> =A0 -Introduced INVALID_VMID and vCPU Sched Out logic.
> =A0 -No CnP (Removed UniqueASIDAllCPUs & UniqueASIDActiveTask invariants).
> =A0 -Removed =A0UniqueVMIDPerCPU invariant for now as it looks like
>    because of the speculative fetching with flush_tlb_all() there
>    is a small window where this gets triggered. If I change the
>    logic back to local_flush_tlb_all(), UniqueVMIDPerCPU seems to
>    be fine. With my limited knowledge on TLA+ model, it is not
>    clear to me whether this is a problem with the above logic
>    or the VMID model implementation. Really appreciate any help
>    with the model.
>    The initial VMID TLA+ model is here,
>    https://github.com/shamiali2008/kernel-tla/tree/private-vmidalloc-v1

I only had a brief look at the TLA+ model and I don't understand why you
have a separate 'shed_out' process. It would run in parallel with the
'sched' but AFAICT you can't really schedule a guest out while you are
in the middle of scheduling it in. I'd rather use the same 'sched'
process and either schedule in an inactive task or schedule out an
active one for a given CPU.

Also active_vmids[] for example is defined on the CPUS domain but you
call vcpu_sched_out() from a process that's not in the CPUS domain but
the SCHED_OUT one.

Regarding UniqueVMIDPerCPU, I think we need to figure out why it
happens. The fact that flush_tlb_all() was made to simulate the
speculative TLB loads is not relevant. In a different spec I have,
arm64kpti.tla, I just used another process that invokes an update_tlbs()
macro so that it can happen at any time. I didn't bother to update the
ASID spec in a similar way but it may be useful. The corresponding
UniqueASIDPerCPU meant that for any two TLB entries on a single CPU, if
they correspond to different tasks (pgd), they should have different
ASIDs. That's a strong requirement, otherwise we end up with the wrong
translation.

Why did you remove the CnP? Do we have this disabled for KVM guests?

-- =

Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
