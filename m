From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH RFC 6/7] ARM64: KVM: Support heterogeneous system
Date: Wed, 15 Mar 2017 14:49:09 +0000
Message-ID: <20170315144909.GB9404@leverpostej>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-7-git-send-email-zhaoshenglong@huawei.com>
 <20170128145551.sknp447ieue56xgo@hawk.localdomain>
 <20170315115044.GO1277@cbox>
 <20170315125113.erfl2gk6fwmbccsn@kamzik.brq.redhat.com>
 <20170315133645.GQ1277@cbox>
 <20170315140633.jtultotyihql7qlr@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 987EF40625
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:47:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4R8EEpFbUXAt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 10:47:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31A4405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:47:47 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170315140633.jtultotyihql7qlr@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, Christoffer Dall <cdall@linaro.org>, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 15, 2017 at 03:06:33PM +0100, Andrew Jones wrote:
> On Wed, Mar 15, 2017 at 02:36:45PM +0100, Christoffer Dall wrote:
> > > If QEMU wants to know
> > > whether or not the host it's running on is heterogeneous, then
> > > it can just query sysfs, rather than ask KVM.
> > > 
> > 
> > Can it?  Is this information available in a reliable way from userspace?
> 
> I don't know much (anything) about it, but, afaict, yes. See
> https://lkml.org/lkml/2017/1/19/380

The "capacity" of a CPU does *not* tell you if your system is
hetereogeneous. Two vastly different CPU implementations can stumble
upon the same capacity, and two identical implementations could be
assigned close but not identical capacities.

The "capacity" is purely a scheduler heuristic, and should not be relied
upon for functional correctness.

We have a sysfs interface to see the MIDR and REVIDR of (online) CPUs,
which can tell you. See Documentation/arm64/cpu-feature-registers.txt.

Whether a system is heterogeneous can change at runtime, as CPUs can be
brought online very late (e.g. if booted with maxcpus capped, or if we
get "real" hotplug in future).

Thanks,
Mark.
