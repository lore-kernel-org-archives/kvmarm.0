From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 04/12] KVM: x86: remove now unneeded include directory
 from Makefile
Date: Wed, 25 Mar 2015 18:41:55 -0300
Message-ID: <20150325214155.GD3649@amt.cnet>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
 <1427126309-11223-5-git-send-email-andre.przywara@arm.com>
 <5512EA00.2070105@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99B8B49AD0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 17:35:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ezKgjTXYRfF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 17:35:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 265B3497FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 17:35:15 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5512EA00.2070105@arm.com>
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

On Wed, Mar 25, 2015 at 05:01:52PM +0000, Marc Zyngier wrote:
> On 23/03/15 15:58, Andre Przywara wrote:
> > virt/kvm was never really a good include directory for anything else
> > than locally included headers.
> > With the move of iodev.h there is no need anymore to add this
> > directory the compiler's include path, so remove it from the x86 kvm
> > Makefile.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Paolo, Marcelo: can we have your Ack on this?
> 
> Thanks,
> 
> 	M.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
