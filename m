From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 13:29:10 +0200
Message-ID: <20150514112910.GR32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6971351467
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:19:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1nS+QUoCqGGI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:19:52 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D99DD5141C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:19:51 -0400 (EDT)
Received: by laat2 with SMTP id t2so62926125laa.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:28:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5554826E.1040706@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 01:09:34PM +0200, Laszlo Ersek wrote:
> On 05/14/15 12:30, Christoffer Dall wrote:
> > On Wed, May 13, 2015 at 01:31:51PM +0200, Andrew Jones wrote:
> >> Introduce a new memory region flag, KVM_MEM_UNCACHED, which is
> >> needed by ARM. This flag informs KVM that the given memory region
> >> is typically mapped by the guest as non-cacheable. KVM for ARM
> >> then ensures that that memory is indeed mapped non-cacheable by
> >> the guest, and also remaps that region as non-cacheable for
> >> userspace, allowing them both to maintain a coherent view.
> >>
> >> Changes since v1:
> >>  1) don't pin pages [Paolo]
> >>  2) ensure the guest maps the memory non-cacheable [me]
> >>  3) clean up memslot flag documentation [Christoffer]
> >> changes 1 and 2 effectively redesigned/rewrote v1. Find v1 here
> >> http://www.spinics.net/lists/kvm-arm/msg14022.html
> >>
> >> The QEMU series for v1 hasn't really changed. Only the linux
> >> header hack needed to bump KVM_CAP_UNCACHED_MEM from 107 to
> >> 116.  Find the series here
> >> http://www.spinics.net/lists/kvm-arm/msg14026.html
> >>
> >> Testing:
> >> This series still needs lots of testing, but I thought I'd
> >> kick it to the list early, as there's been recent interest
> >> in solving this problem, and I'd like to get test results
> >> and opinions on this approach from others sooner than later.
> >> I've tested with AAVMF (UEFI for AArch64 mach-virt guests).
> >> AAVMF has a kludge in it to avoid the coherency problem.
> > 
> > How does the 'kludge' work?
> 
> https://github.com/tianocore/edk2/commit/f9a8be42
> 
> (It's probably worth looking at the documentation in the first hunk too,
> under the commit message.)
> 
Why is this a hack/unintuitive?  Is the semantics of the QEMU PCI bus
not simply that MMIO regions are coherent?

-Christoffer
