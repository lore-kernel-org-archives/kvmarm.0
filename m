Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99B2C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jan 2022 11:50:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE0E4B0DB;
	Wed, 19 Jan 2022 06:50:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p+8okor4T0Rq; Wed, 19 Jan 2022 06:50:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5BF4B0BD;
	Wed, 19 Jan 2022 06:50:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8488A4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 06:50:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WQ-3ShY-YCiC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jan 2022 06:50:06 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2EAF49F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 06:50:05 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C93F161627;
 Wed, 19 Jan 2022 11:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C78C004E1;
 Wed, 19 Jan 2022 11:50:01 +0000 (UTC)
Date: Wed, 19 Jan 2022 11:49:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Message-ID: <Yef65ng6pQK5yZDa@arm.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
 <Yeazd1lLuYm4k3lH@arm.com>
 <207f800d1a67427a9771ffb06086365b@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <207f800d1a67427a9771ffb06086365b@huawei.com>
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jan 19, 2022 at 09:23:31AM +0000, Shameerali Kolothum Thodi wrote:
> > On Mon, Nov 22, 2021 at 12:18:40PM +0000, Shameer Kolothum wrote:
> > > =A0-TLA+ model. Modified the asidalloc model to incorporate the new
> > >   VMID algo. The main differences are,
> > > =A0 -flush_tlb_all() instead of local_tlb_flush_all() on rollover.
> > > =A0 -Introduced INVALID_VMID and vCPU Sched Out logic.
> > > =A0 -No CnP (Removed UniqueASIDAllCPUs & UniqueASIDActiveTask invaria=
nts).
> > > =A0 -Removed =A0UniqueVMIDPerCPU invariant for now as it looks like
> > >    because of the speculative fetching with flush_tlb_all() there
> > >    is a small window where this gets triggered. If I change the
> > >    logic back to local_flush_tlb_all(), UniqueVMIDPerCPU seems to
> > >    be fine. With my limited knowledge on TLA+ model, it is not
> > >    clear to me whether this is a problem with the above logic
> > >    or the VMID model implementation. Really appreciate any help
> > >    with the model.
> > >    The initial VMID TLA+ model is here,
> > >    https://github.com/shamiali2008/kernel-tla/tree/private-vmidalloc-=
v1
> > =

> > I only had a brief look at the TLA+ model and I don't understand why you
> > have a separate 'shed_out' process. It would run in parallel with the
> > 'sched' but AFAICT you can't really schedule a guest out while you are
> > in the middle of scheduling it in. I'd rather use the same 'sched'
> > process and either schedule in an inactive task or schedule out an
> > active one for a given CPU.
> > =

> > Also active_vmids[] for example is defined on the CPUS domain but you
> > call vcpu_sched_out() from a process that's not in the CPUS domain but
> > the SCHED_OUT one.
> =

> Many thanks for taking a look. My bad!. The 'sched_out' would indeed run =
in parallel
> and defeat the purpose. I must say I was really confused by the TLA+ synt=
ax and
> is still not very confident about it.

Yeah, it can be confusing. If you have time, you could give CBMC a try
and the 'spec' would be pretty close to your C version. Each CPU would
be modelled as a thread with an extra thread that simulates the
speculative TLB look-ups for all CPUS together with the asserts for the
invariants. The spinlocks would be pthread_mutexes.

> Based on the above suggestion, I have modified it as below,
> =

> \* vCPU is scheduled out by KVM
> macro vcpu_sched_out() {
>         active_kvm[self].task :=3D 0;
>         active_vmids[self] :=3D INVALID_VMID;
> }

Could you call cpu_switch_kvm(0, INVALID_VMID) instead? You could do
this directly below and avoid another macro. Well, whatever you find
clearer.

What confuses me is that your INVALID_VMID looks like a valid one: vmid
0, generation 1. Do you ensure that you never allocate VMID 0?

> \* About to run a Guest VM
> process (sched \in CPUS)
> {
> sched_loop:
>         while (TRUE) {
>                 with (t \in TASKS) {
>                         if (t # ActiveTask(self))
>                                 call kvm_arm_vmid_update(t);
>                         else
>                                 vcpu_sched_out();
>                 }
>         }
> }

Yes, that's what I meant.

> > The corresponding
> > UniqueASIDPerCPU meant that for any two TLB entries on a single CPU, if
> > they correspond to different tasks (pgd), they should have different
> > ASIDs. That's a strong requirement, otherwise we end up with the wrong
> > translation.
> =

> Yes, I understand that it is a strong requirement. Also, I thought this i=
s something
> that will trigger easily with the test setup I had with the real hardware=
. But testing
> stayed on for days, so I was not sure it is a problem with the TLA+ imple=
mentation
> or not.  =


Well, you'd have to check the TLA+ state trace and see how it got
there, whether the last state would be a valid one. It's either
something missing in the spec that the hardware enforces or the
algorithm is wrong and just hard to hit in practice. If this condition
is violated in hardware for a very brief period, e.g. due to some TLBI,
you'd not notice an issue under normal circumstances. But it's still
incorrect.

> > Why did you remove the CnP? Do we have this disabled for KVM guests?
> =

> I removed CnP related Invariants to simplify things for the first version=
. Also not sure
> what specific changes we need to do for CnP here. Do we still need that s=
witching to =

> global pg_dir to prevent any speculative reading? I didn't see that being=
 done in KVM =

> anywhere at the moment. Maybe I am missing something.

It make sense to ignore CnP for now. Maybe KVM doesn't even bother and
sets VTTBR_EL2.CnP to 0 (I haven't checked).

> On a side note, In my setup, the CnP=3DTRUE case for asidalloc.tla now fa=
ils with,
> "Error: Invariant TLBEmptyInvalPTE is violated.". Please check.

This was added later as part of try-to-unmap and I only checked this
with CnP =3D FALSE. I'll need to look into, it's possible that
flush_tlb_all() doesn't take into account that the pte is unmapped (as
cpu_switch_mm() does). I'll add a separate thread for speculative TLB
loads, it's easier to have them in one place. Thanks.

-- =

Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
