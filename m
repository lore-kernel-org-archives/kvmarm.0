From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 13:36:34 +0200
Message-ID: <20150514113634.GS32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B885147A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:27:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LkIai4mqvEYs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:27:16 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B67351473
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:27:15 -0400 (EDT)
Received: by lagv1 with SMTP id v1so63127545lag.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:36:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55548777.9000702@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 01:31:03PM +0200, Paolo Bonzini wrote:
> 
> 
> On 14/05/2015 13:29, Christoffer Dall wrote:
> > > (It's probably worth looking at the documentation in the first hunk too,
> > > under the commit message.)
> > 
> > Why is this a hack/unintuitive?  Is the semantics of the QEMU PCI bus
> > not simply that MMIO regions are coherent?
> 
> Only until device assignment gets into the picture.
> 
Will UEFI have to deal with device assignment in any respect?

-Christoffer
