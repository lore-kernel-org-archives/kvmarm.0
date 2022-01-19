Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C27C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jan 2022 09:23:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F6149E35;
	Wed, 19 Jan 2022 04:23:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+wUOLpNwpc4; Wed, 19 Jan 2022 04:23:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 571D44B08B;
	Wed, 19 Jan 2022 04:23:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0DE4AC78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 04:23:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UXN7gwsc5Lnv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jan 2022 04:23:35 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2ABDC49E35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 04:23:35 -0500 (EST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jf0VK0HwYz67n9B;
 Wed, 19 Jan 2022 17:20:25 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 10:23:32 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 09:23:32 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Wed, 19 Jan 2022 09:23:31 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: RE: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Thread-Topic: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Thread-Index: AQHX35sqG4N0fL5BTkOeJNZZBpVcWaxpD9KAgAFUH+A=
Date: Wed, 19 Jan 2022 09:23:31 +0000
Message-ID: <207f800d1a67427a9771ffb06086365b@huawei.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
 <Yeazd1lLuYm4k3lH@arm.com>
In-Reply-To: <Yeazd1lLuYm4k3lH@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.100]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
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

Hi Catalin,

> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: 18 January 2022 12:33
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; will@kernel.org;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; qperret@google.com; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
> =

> Hi Shameer,
> =

> On Mon, Nov 22, 2021 at 12:18:40PM +0000, Shameer Kolothum wrote:
> > =A0-TLA+ model. Modified the asidalloc model to incorporate the new
> >   VMID algo. The main differences are,
> > =A0 -flush_tlb_all() instead of local_tlb_flush_all() on rollover.
> > =A0 -Introduced INVALID_VMID and vCPU Sched Out logic.
> > =A0 -No CnP (Removed UniqueASIDAllCPUs & UniqueASIDActiveTask
> invariants).
> > =A0 -Removed =A0UniqueVMIDPerCPU invariant for now as it looks like
> >    because of the speculative fetching with flush_tlb_all() there
> >    is a small window where this gets triggered. If I change the
> >    logic back to local_flush_tlb_all(), UniqueVMIDPerCPU seems to
> >    be fine. With my limited knowledge on TLA+ model, it is not
> >    clear to me whether this is a problem with the above logic
> >    or the VMID model implementation. Really appreciate any help
> >    with the model.
> >    The initial VMID TLA+ model is here,
> >    https://github.com/shamiali2008/kernel-tla/tree/private-vmidalloc-v1
> =

> I only had a brief look at the TLA+ model and I don't understand why you
> have a separate 'shed_out' process. It would run in parallel with the
> 'sched' but AFAICT you can't really schedule a guest out while you are
> in the middle of scheduling it in. I'd rather use the same 'sched'
> process and either schedule in an inactive task or schedule out an
> active one for a given CPU.
> =

> Also active_vmids[] for example is defined on the CPUS domain but you
> call vcpu_sched_out() from a process that's not in the CPUS domain but
> the SCHED_OUT one.

Many thanks for taking a look. My bad!. The 'sched_out' would indeed run in=
 parallel
and defeat the purpose. I must say I was really confused by the TLA+ syntax=
 and
is still not very confident about it.

Based on the above suggestion, I have modified it as below,

\* vCPU is scheduled out by KVM
macro vcpu_sched_out() {
        active_kvm[self].task :=3D 0;
        active_vmids[self] :=3D INVALID_VMID;
}
....

\* About to run a Guest VM
process (sched \in CPUS)
{
sched_loop:
        while (TRUE) {
                with (t \in TASKS) {
                        if (t # ActiveTask(self))
                                call kvm_arm_vmid_update(t);
                        else
                                vcpu_sched_out();
                }
        }
}

Please let me know if this is ok.

> Regarding UniqueVMIDPerCPU, I think we need to figure out why it
> happens. The fact that flush_tlb_all() was made to simulate the
> speculative TLB loads is not relevant. In a different spec I have,
> arm64kpti.tla, I just used another process that invokes an update_tlbs()
> macro so that it can happen at any time. I didn't bother to update the
> ASID spec in a similar way but it may be useful.

Ok. I will take a look at that and try that.

 The corresponding
> UniqueASIDPerCPU meant that for any two TLB entries on a single CPU, if
> they correspond to different tasks (pgd), they should have different
> ASIDs. That's a strong requirement, otherwise we end up with the wrong
> translation.

Yes, I understand that it is a strong requirement. Also, I thought this is =
something
that will trigger easily with the test setup I had with the real hardware. =
But testing
stayed on for days, so I was not sure it is a problem with the TLA+ impleme=
ntation
or not.  =


> =

> Why did you remove the CnP? Do we have this disabled for KVM guests?

I removed CnP related Invariants to simplify things for the first version. =
Also not sure
what specific changes we need to do for CnP here. Do we still need that swi=
tching to =

global pg_dir to prevent any speculative reading? I didn't see that being d=
one in KVM =

anywhere at the moment. Maybe I am missing something.

On a side note, In my setup, the CnP=3DTRUE case for asidalloc.tla now fail=
s with,
"Error: Invariant TLBEmptyInvalPTE is violated.". Please check.

Thanks,
Shameer =


> --
> Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
