Return-Path: <SRS0=IwiB=UI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6374FC28EBD
	for <kvmarm@archiver.kernel.org>; Sun,  9 Jun 2019 17:40:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1D13206BB
	for <kvmarm@archiver.kernel.org>; Sun,  9 Jun 2019 17:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1D13206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2E14A4A9;
	Sun,  9 Jun 2019 13:40:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vkzoiu1jCEK4; Sun,  9 Jun 2019 13:40:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD454A4BE;
	Sun,  9 Jun 2019 13:40:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6544A4BE
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Jun 2019 13:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pv+CCJ4LGzS8 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Jun 2019 13:40:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32AE94A4A9
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Jun 2019 13:40:26 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 4C8CD308218D;
 Sun,  9 Jun 2019 17:40:25 +0000 (UTC)
Received: from ultra.random (ovpn-120-29.rdu2.redhat.com [10.10.120.29])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA72119729;
 Sun,  9 Jun 2019 17:40:24 +0000 (UTC)
Date: Sun, 9 Jun 2019 13:40:24 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Reference count on pages held in secondary MMUs
Message-ID: <20190609174024.GA4785@redhat.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.47]); Sun, 09 Jun 2019 17:40:25 +0000 (UTC)
Cc: Jerome Glisse <jglisse@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hello,

On Sun, Jun 09, 2019 at 11:37:19AM +0200, Paolo Bonzini wrote:
> On 09/06/19 10:18, Christoffer Dall wrote:
> > In some sense, we are thus maintaining a 'hidden', or internal,
> > reference to the page, which is not counted anywhere.
> > 
> > I am wondering if it would be equally valid to take a reference on the
> > page, and remove that reference when unmapping via MMU notifiers, and if
> > so, if there would be any advantages/drawbacks in doing so?
> 
> If I understand correctly, I think the MMU notifier would not fire if
> you took an actual reference; the page would be pinned in memory and
> could not be swapped out.

MMU notifiers still fires, the refcount is simple and can be dropped
also in the mmu notifier invalidate and in fact Jerome also thinks
like me that we should eventually optimize away the FOLL_GET and not
take the refcount in the first place, but a whole different chapter is
dedicated on the set_page_dirty_lock crash on MAP_SHARED mappings
after long term GUP pins. So since you're looking into how to handle
the page struct in the MMU notifier it's worth mentioning the issues
related to set_page_dirty too.

To achieve the cleanest writeback fix to avoid crashes in
set_page_dirty_lock on long term secondary MMU mappings that supports
MMU notifier like KVM shadow MMU, the ideal is to mark the page dirty
before establishing a writable the mapping in the secondary MMU like
in the model below.

The below solution works also for those secondary MMU that are like a
TLB and if there are two concurrent invalidates on the same page
invoked at the same time (a potential problem Jerome noticed), you
don't know which come out first and you would risk to call
set_page_dirty twice, which would be still potentially kernel crashing
(even if only a theoretical issue like O_DIRECT). So the below model
will solve that and it's also valid for KVM/vhost accelleration,
despite KVM can figure out how to issue a single set_page_dirty call
for each spte that gets invalidated by concurrent invalidates on the
same page because it has shadow pagetables and it's not just a TLB.

  access = FOLL_WRITE|FOLL_GET

repeat:
  page = gup(access)
  put_page(page)

  spin_lock(mmu_notifier_lock);
  if (race with invalidate) {
    spin_unlock..
    goto repeat;
  }
  if (access == FOLL_WRITE)
    set_page_dirty(page)
  establish writable mapping in secondary MMU on page
  spin_unlock

The above solves the crash in set_page_dirty_lock without having to
modify any filesystem, it should work theoretically safer than the
O_DIRECT short term GUP pin.

With regard to KVM this should be enough, but we also look for a crash
avoidance solution for those devices that cannot support the MMU
notifier for short and long term GUP pins.

There's lots of work going on on linux-mm, to try to let those devices
support writeback in a safe way (also with stable pages so all fs
integrity checks will pass) using bounce buffer if a long term GUP pin
is detected by the filesystem. In addition there's other work to make
the short term GUP pin theoretically safe by delaying the writeback
for the short window the GUP pin is taken by O_DIRECT, so it becomes
theoretically safe too (currently it's only practically safe).

However I'm not sure if the long term GUP pins really needs to support
writeback.

To do a coherent snapshot without talking to the device so that it
stops writing to the whole mapping, one should write protect the
memory, but it can't be write protected without MMU notifier
support.. The VM already wrprotect the MAP_SHARED pages before writing
them out to provide stable pages, but that's just not going to work
with a long term GUP pin that mapped the page as writable in the
device.

To make a practical example: if the memory under long term GUP pin
would be a KVM guest physical memory mapped in MAP_SHARED with
vfio/iommu device assignment and if the device or iommu can't support
the MMU notifier, there's no value in the filesystem being able to
flush the guest physical memory to disk periodically, because if the
write-able GUP pin can't be dropped first, it's impossible to take a
coherent snapshot of the guest physical memory while the device can
still write anywhere in the KVM guest physical memory. Whatever gets
written by the complex logic that will do the bounce buffers would be
just useless for this use case. If the system crashed, you couldn't
possibly start a new guest and pretend that whatever got written was a
coherent snapshot of the guest physical memory. To take a coherent
snapshot KVM needs to tell the device to stop writing, and only then
flush the dirty data in the MAP_SHARED to disk, just calling mprotect
won't be enough because that won't get rid of the device writable
mapping associated with the long term GUP pin. But if it has to do
that, it can also tell the device to temporarily drop the iommu
mapping, drop all the GUP pins and to re-take the GUP pins and remap
the guest in the iommu only after the data already hit the disk, to
mark all pages dirty again. So I suppose lots of other use cases would
work like this.

If the data written by the device through the long term GUP pin,
doesn't need to be coherent (perhaps if the data is structured like a
rotating debug logfile) or if it's coherent down to the smallest size
the device can write with its DMA, then there would be some value in
being able to flush the data without stopping the device from writing
to it.

Overall it might be just enough to keep things simpler in the kernel
filesystems and define that long term GUP pins without MMU notifier,
don't ever get written to disk until the GUP pin is dropped, so all
GUP pin will work the same and the O_DIRECT solution can be applied to
long term GUP pins too. Any device requiring a long term GUP pin to
operate, requires some special setup with root capability so among the
other special things it does, its userland could also orchestrate
periodic unpinning, to flush the MAP_SHARED dirty data to disk, if the
data written by the device through the long term GUP pin cannot be
lost after a power loss or a kernel crash.

Either that or it'd be interesting to know exactly what are the uses
cases that requires long term GUP pinned MAP_SHARED pages to remain
writeback capable, to justify the additional kernel complexity that
such filesystem solution requires. Currently those same use cases would
tend to be kernel crashing, so I suppose they're not very common use
cases to begin with.

Thanks,
Andrea
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
