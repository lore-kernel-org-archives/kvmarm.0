From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 6/7] ARM64: KVM: Support heterogeneous system
Date: Wed, 15 Mar 2017 15:06:33 +0100
Message-ID: <20170315140633.jtultotyihql7qlr@kamzik.brq.redhat.com>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-7-git-send-email-zhaoshenglong@huawei.com>
 <20170128145551.sknp447ieue56xgo@hawk.localdomain>
 <20170315115044.GO1277@cbox>
 <20170315125113.erfl2gk6fwmbccsn@kamzik.brq.redhat.com>
 <20170315133645.GQ1277@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A201E400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:05:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n02iGuDatMob for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Mar 2017 10:05:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95A5340019
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Mar 2017 10:05:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170315133645.GQ1277@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 15, 2017 at 02:36:45PM +0100, Christoffer Dall wrote:
> > If QEMU wants to know
> > whether or not the host it's running on is heterogeneous, then
> > it can just query sysfs, rather than ask KVM.
> > 
> 
> Can it?  Is this information available in a reliable way from userspace?

I don't know much (anything) about it, but, afaict, yes. See
https://lkml.org/lkml/2017/1/19/380

> > > I'm sure I missed some aspect of this discussion though.
> > 
> > Me too. As we discussed, it's probably time to try and hash out a fresh
> > design doc. It'd be good to get a clear design agreed upon before
> > returning to the patches.
> > 
> 
> Yes, it's on my list.

I'm happy to help with this, even to take a stab at the first draft. Just
let me know if you or Shannon prefer to do the draft yourselves. If you
don't have a preference, then I can start working on it pretty soon.

Thanks,
drew
