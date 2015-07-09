From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC v2 0/6] IRQ bypass manager and irqfd consumer
Date: Thu, 09 Jul 2015 10:06:35 -0600
Message-ID: <1436457995.1391.231.camel@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436289468.1391.89.camel@redhat.com> <20150709122805.GW18569@8bytes.org>
 <1436451223.1391.219.camel@redhat.com> <559E8771.9010401@redhat.com>
 <20150709153458.GX18569@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA9058479
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:55:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E8ieMf3QVlwv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 11:55:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9790058478
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:55:02 -0400 (EDT)
In-Reply-To: <20150709153458.GX18569@8bytes.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Joerg Roedel <joro@8bytes.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, marc.zyngier@arm.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, avi.kivity@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-07-09 at 17:34 +0200, Joerg Roedel wrote:
> On Thu, Jul 09, 2015 at 04:38:41PM +0200, Paolo Bonzini wrote:
> > >> On Tue, Jul 07, 2015 at 11:17:48AM -0600, Alex Williamson wrote:
> > > If we think that it's *only* a kvm-vfio interaction then we could add it
> > > to virt/kvm/vfio.c.  vfio could use symbol_get to avoid a module
> > > dependency and effectively disable the code path when not used with kvm.
> > > The reverse model of hosting it in vfio and using symbol_get from
> > > kvm-vfio would also work.  Do we really want to declare it to be
> > > kvm-vfio specific though?  Another option would be to simply host it
> > > under virt/lib with module dependencies for both vfio and kvm.
> > 
> > I wonder if in the future we may have some kind of driver-mediated
> > passthrough, e.g. for network drivers.  They might use the bypass
> > mechanism too.  So I think drivers/vfio is too restrictive.
> > 
> > virt/ right now only hosts KVM, but it could for example host lguest
> > too.  virt/lib/ is okay with me.
> 
> Yeah, virt/lib is probably the best choice.

I will make it so.  Thanks,

Alex
