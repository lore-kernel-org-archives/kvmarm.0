From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 6/7] ARM64: KVM: Support heterogeneous system
Date: Wed, 15 Mar 2017 15:42:57 +0100
Message-ID: <20170315144257.vgh3vf3k4avrbuot@kamzik.brq.redhat.com>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-7-git-send-email-zhaoshenglong@huawei.com>
 <20170128145551.sknp447ieue56xgo@hawk.localdomain>
 <20170315115044.GO1277@cbox>
 <20170315125113.erfl2gk6fwmbccsn@kamzik.brq.redhat.com>
 <20170315133645.GQ1277@cbox>
 <20170315140633.jtultotyihql7qlr@kamzik.brq.redhat.com>
 <CAFEAcA_O3282tyQwK=eAyc5EYPZdETE2RuZT0dnZ7NCEWwP9aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9540C40A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y85gctdfjVI5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 10:41:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E6B740A7F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:41:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_O3282tyQwK=eAyc5EYPZdETE2RuZT0dnZ7NCEWwP9aQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, wu.wubin@huawei.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 15, 2017 at 02:21:48PM +0000, Peter Maydell wrote:
> On 15 March 2017 at 14:06, Andrew Jones <drjones@redhat.com> wrote:
> > On Wed, Mar 15, 2017 at 02:36:45PM +0100, Christoffer Dall wrote:
> >> > If QEMU wants to know
> >> > whether or not the host it's running on is heterogeneous, then
> >> > it can just query sysfs, rather than ask KVM.
> >> >
> >>
> >> Can it?  Is this information available in a reliable way from userspace?
> >
> > I don't know much (anything) about it, but, afaict, yes. See
> > https://lkml.org/lkml/2017/1/19/380
> 
> AFAICT that won't work if the CPU you're trying to
> look at the ID registers for happens to be offline at
> the time you're looking at it.
>

Hmm, OK, but I think the jury is still out on whether QEMU even
needs to know this information. If we push the burden up to the
user/libvirt, than this information can be obtained [somehow] at
the higher level. The higher level can then choose to use generic,
if no vcpu affinity is desired, or, if one of the heterogeneous
cpu types is preferred for the vcpu's model, then it can also
ensure the vcpu is affined to the appropriate cpuset.

Thanks,
drew
