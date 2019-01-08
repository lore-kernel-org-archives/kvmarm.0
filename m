From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 8 Jan 2019 13:03:52 +0100
Message-ID: <20190108120352.GN10769@e113682-lin.lund.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <20181218120226.GC25383@e113682-lin.lund.arm.com>
 <20190104153205.GA31479@edgewater-inn.cambridge.arm.com>
 <20190108101843.GH10769@e113682-lin.lund.arm.com>
 <20190108112512.GA56789@e119886-lin.cambridge.arm.com>
 <868szvbc64.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A8D4A43C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 07:03:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fD5ufNO5entR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jan 2019 07:03:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCBC34A430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 07:03:54 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <868szvbc64.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, joro@8bytes.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 08, 2019 at 11:50:59AM +0000, Marc Zyngier wrote:
> On Tue, 08 Jan 2019 11:25:13 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> 
> Hi Andrew,
> 
> > My only doubt about this is as follows. If, on a KVM host you run this:
> > 
> > perf stat -e cycles:H lkvm run ...
> > 
> > then on the VHE host the cycles reported represents the entire non-guest cycles
> > associated with running the guest.
> > 
> > On a !VHE, the cycles reported exclude EL2 (with or without this patch) and
> > thus you don't get a representation of all the non-guest cycles associated with
> > the guest. However without this patch you could at least still run:
> > 
> > perf stat -e cycles:H -e cycles:h lkvm run ...
> > 
> > and then add the two cycle counts together to get something comparative with
> > the VHE host.
> > 
> > If the above patch represents the desired semantics, then perhaps we must count
> > both EL1 and *EL2* for !exclude_kernel on !VHE. In fact I think we should do
> > this anyway and remove a little complexity from armv8pmu_set_event_filter.
> > Thoughts?
> 
> I'm not sure we should hide the architectural differences between VHE
> and !VHE. If you're trying to measure what is happening at in the
> hypervisor, you can't reason about it while ignoring the dual nature
> of !VHE.
> 

How do you define hypervisor here?  Is that just the code that runs at
EL2 or also parts of KVM that runs at EL1?

It remains unclear to me why you'd want to measure a subset of KVM,
which happens to run in EL2, in your host (and hypervisor-enabled)
kernel, and you are even precluded from measuring a comparable portion
of your implementation on other Arm systems (VHE).

Admittedly, I'm not at export in using perf, but I find this EL1/EL2
distinction out of place as it relates to exlude_kernel, exlude_user,
and exlude_hv.  Will we have a fourth Arm-specific flag which takes the
place of exclude_hv on PowerPC, which excludes an underlying hypervisor
when running a guest, should we ever support counting that in the
future?


Thanks,

    Christoffer
