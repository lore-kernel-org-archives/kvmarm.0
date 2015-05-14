From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 13:38:38 +0200
Message-ID: <5554893E.4030105@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
 <20150514113634.GS32765@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 944EB51482
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:29:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I99HWZxa11Ar for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:29:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 68EE651476
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:29:43 -0400 (EDT)
In-Reply-To: <20150514113634.GS32765@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 14/05/2015 13:36, Christoffer Dall wrote:
> > > > (It's probably worth looking at the documentation in the first hunk too,
> > > > under the commit message.)
> > > 
> > > Why is this a hack/unintuitive?  Is the semantics of the QEMU PCI bus
> > > not simply that MMIO regions are coherent?
> > 
> > Only until device assignment gets into the picture.
> 
> Will UEFI have to deal with device assignment in any respect?

Why not?  For example you could do network boot from an assigned network
card.

In fact, anything that UEFI has to deal with, the OS has to deal with
too.  If you need a UEFI hack, chances are you need or will need a Linux
hack too.

Paolo
