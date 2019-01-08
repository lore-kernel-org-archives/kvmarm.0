From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 8 Jan 2019 13:20:54 +0100
Message-ID: <20190108122054.GP10769@e113682-lin.lund.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <20181218120226.GC25383@e113682-lin.lund.arm.com>
 <20190104153205.GA31479@edgewater-inn.cambridge.arm.com>
 <20190108101843.GH10769@e113682-lin.lund.arm.com>
 <20190108112512.GA56789@e119886-lin.cambridge.arm.com>
 <868szvbc64.wl-marc.zyngier@arm.com>
 <20190108120352.GN10769@e113682-lin.lund.arm.com>
 <b6a88173-56cb-dc20-37ce-6f1b352b60d8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <b6a88173-56cb-dc20-37ce-6f1b352b60d8@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, joro@8bytes.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Murray <andrew.murray@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 08, 2019 at 12:12:13PM +0000, Marc Zyngier wrote:
> On 08/01/2019 12:03, Christoffer Dall wrote:
> > On Tue, Jan 08, 2019 at 11:50:59AM +0000, Marc Zyngier wrote:
> >> On Tue, 08 Jan 2019 11:25:13 +0000,
> >> Andrew Murray <andrew.murray@arm.com> wrote:
> >>
> >> Hi Andrew,
> >>
> >>> My only doubt about this is as follows. If, on a KVM host you run this:
> >>>
> >>> perf stat -e cycles:H lkvm run ...
> >>>
> >>> then on the VHE host the cycles reported represents the entire non-guest cycles
> >>> associated with running the guest.
> >>>
> >>> On a !VHE, the cycles reported exclude EL2 (with or without this patch) and
> >>> thus you don't get a representation of all the non-guest cycles associated with
> >>> the guest. However without this patch you could at least still run:
> >>>
> >>> perf stat -e cycles:H -e cycles:h lkvm run ...
> >>>
> >>> and then add the two cycle counts together to get something comparative with
> >>> the VHE host.
> >>>
> >>> If the above patch represents the desired semantics, then perhaps we must count
> >>> both EL1 and *EL2* for !exclude_kernel on !VHE. In fact I think we should do
> >>> this anyway and remove a little complexity from armv8pmu_set_event_filter.
> >>> Thoughts?
> >>
> >> I'm not sure we should hide the architectural differences between VHE
> >> and !VHE. If you're trying to measure what is happening at in the
> >> hypervisor, you can't reason about it while ignoring the dual nature
> >> of !VHE.
> >>
> > 
> > How do you define hypervisor here?  Is that just the code that runs at
> > EL2 or also parts of KVM that runs at EL1?
> 
> I define it as "not a guest". Whatever is used to support a guest is the
> hypervisor.
> 
> > It remains unclear to me why you'd want to measure a subset of KVM,
> > which happens to run in EL2, in your host (and hypervisor-enabled)
> > kernel, and you are even precluded from measuring a comparable portion
> > of your implementation on other Arm systems (VHE).
> 
> Because I'm not trying to compare apples (VHE) and oranges (!VHE). My
> use-case for perf is to measure the impact of a change on a given
> implementation, and the more I can narrow the impact of that change, the
> better (specially when !VHE precludes the use of other techniques such
> as sampling).
> 

Fair enough.  I don't know if that's the only use case for perf we
should consider though.

> > Admittedly, I'm not at export in using perf, but I find this EL1/EL2
> > distinction out of place as it relates to exlude_kernel, exlude_user,
> > and exlude_hv.  Will we have a fourth Arm-specific flag which takes the
> > place of exclude_hv on PowerPC, which excludes an underlying hypervisor
> > when running a guest, should we ever support counting that in the
> > future?
> In all honestly, exclude_hv doesn't make much sense to me on a VHE
> system, unless you define an arbitrary cutting point where things are on
> one side or the other. As for a fourth flag, I have no idea.
> 

I think this all boils down to how these flags are interpreted and
represented to a user via tooling.  If these flags must be considered
in complete isolation on a particular system and architecture, then
fine, we can define it as whatever we want, giving us a little bit more
insight on where things happen on a !VHE system.

If we care about these flags representing similar semantics to other
architectures, then I contend that we are abusing the exclude_hv flag
today, and exclude_hv should only ever have an effect when set within
a guest, not in a host.


Thanks,

    Christoffer
