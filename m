From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 02/12] KVM: move iodev.h from virt/kvm/ to include/kvm
Date: Wed, 25 Mar 2015 18:41:12 -0300
Message-ID: <20150325214112.GC3649@amt.cnet>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <1427126309-11223-3-git-send-email-andre.przywara@arm.com>
 <5512E992.1020800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D6149A69
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 17:34:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EreCww26QbZO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 17:34:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99C9049818
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 17:34:39 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5512E992.1020800@arm.com>
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
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 25, 2015 at 05:00:02PM +0000, Marc Zyngier wrote:
> On 23/03/15 15:58, Andre Przywara wrote:
> > iodev.h contains definitions for the kvm_io_bus framework. This is
> > needed both by the generic KVM code in virt/kvm as well as by
> > architecture specific code under arch/. Putting the header file in
> > virt/kvm and using local includes in the architecture part seems at
> > least dodgy to me, so let's move the file into include/kvm, so that a
> > more natural "#include <kvm/iodev.h>" can be used by all of the code.
> > This also solves a problem later when using struct kvm_io_device
> > in arm_vgic.h.
> > Fixing up the FSF address in the GPL header and a wrong include path
> > on the way.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Paolo, Marcelo: can we have your Ack on this?
> 
> Thanks,

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
