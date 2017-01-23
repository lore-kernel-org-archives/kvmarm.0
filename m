From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 8/8] arm/arm64: Documentation: Update arm-vgic-v3.txt
Date: Mon, 23 Jan 2017 12:43:35 +0100
Message-ID: <20170123114335.GD15850@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-9-git-send-email-vijay.kilari@gmail.com>
 <7d82df18-debd-72e7-af6e-3816b8aaee85@redhat.com>
 <20170120195722.GJ13531@cbox>
 <CALicx6twCMrK8gb=zR1wt1eH-eiPDyA3=BnLPFy=22O5wW52ew@mail.gmail.com>
 <20170123112019.GC15850@cbox>
 <CALicx6vqdLvbYmbdQkqUns_v1O+RGq0EYpOEMNJAiBWTigM1Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E36E40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:43:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6+1KGJCdb8SN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 06:43:38 -0500 (EST)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5A844018B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 06:43:37 -0500 (EST)
Received: by mail-lf0-f43.google.com with SMTP id v186so91937595lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 03:43:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6vqdLvbYmbdQkqUns_v1O+RGq0EYpOEMNJAiBWTigM1Qw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 23, 2017 at 05:03:55PM +0530, Vijay Kilari wrote:
> On Mon, Jan 23, 2017 at 4:50 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Mon, Jan 23, 2017 at 04:22:39PM +0530, Vijay Kilari wrote:
> >> Hi Christoffer,
> >>
> >> In the document,
> >>
> >>     The mpidr field is used to specify which
> >>     redistributor is accessed.  The mpidr is ignored for the distributor.
> >>
> >> We still rely on MPIDR for KVM_DEV_ARM_VGIC_GRP_DIST_REGS to fetch
> >> vcpu info. So don't we need to remove this restriction?.
> >> Or force to use vcpu[0]?
> >
> > Does the data we return ever change if you supply a diferent MPIDR and
> > access a distributor register?  If not (and I don't think it should),
> > then the API is properly defined but the internal implementation should
> > not rely on the value provided by user space.
> 
> Data does not change. However the common uaccess code expects vcpu.
> 

Just use vcpu[0] if it's not worth refactoring then.

-Christoffer
