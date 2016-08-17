From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v2 0/4] arm/arm64: vgic-new: Implement API for vGICv3
 live migration
Date: Wed, 17 Aug 2016 13:55:44 +0200
Message-ID: <20160817115544.GB5909@cbox>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
 <20160816173747.GH14088@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B82BC40F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:46:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aZmr1i6wkLuV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 07:46:18 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EF5D40F77
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 07:46:17 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id o80so227320032wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 04:53:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160816173747.GH14088@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 07:37:47PM +0200, Christoffer Dall wrote:
> Hi Vijaya,
> 
> On Tue, Aug 09, 2016 at 04:28:42PM +0530, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > 
> > This patchset adds API for saving and restoring
> > of VGICv3 registers to support live migration with new vgic feature.
> > This API definition is as per version of VGICv3 specification
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> > 
> > To test live migration with QEMU, use below patch series
> > https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg01444.html
> > 
> > The patch 3 & 4 are picked from the Pavel's previous implementation.
> > http://www.spinics.net/lists/kvm/msg122040.html
> > 
> > v1 => v2:
> >  - The init sequence change patch is no more required.
> >    Fixed in patch 2 by using static vgic_io_dev regions structure instead
> >    of using dynamic allocation pointer.
> >  - Updated commit message of patch 4.
> >  - Dropped usage of union to manage 32-bit and 64-bit access in patch 1.
> >    Used local variable for 32-bit access.
> >  - Updated macro __ARM64_SYS_REG and ARM64_SYS_REG in 
> >    arch/arm64/include/uapi/asm/kvm.h as per qemu requirements.
> > 
> I think you should have enough to go on by now for a new revision.  You
> can include the two patches I just sent with the series '[PATCH v2]
> Rework vgic_attr_regs_access' in the beginning of your series and then
> base your work on that, assuming nobody else screams about this.
> 
> If you use that approach, and you address the missing soft pending state
> etc. that Peter pointed out, then we should be ready for a detailed
> review.
> 
> Looking forward to the next version.
> 
FYI: I pushed the API doc and the refactoring patches to the 'queue'
branch of the kvmarm tree:

git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git

It would be good if you could base your patches on there for the next
revision.

Thanks,
-Christoffer
