From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: ARM: PCI devices emulation broken with KVM due to cache issue
Date: Fri, 17 Apr 2015 11:29:10 +0200
Message-ID: <20150417092910.GI6186@cbox>
References: <CAGE1QJoXVDP_O0W9dRCsN+FBW3BEYn5gqiCvGh07CfadNp2kHw@mail.gmail.com>
 <552FDD13.4090006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9386E4DE40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 05:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cAbhtZq-LFsO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2015 05:21:05 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B84694DE3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 05:21:02 -0400 (EDT)
Received: by lbbqq2 with SMTP id qq2so78066935lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 02:28:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <552FDD13.4090006@redhat.com>
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
Cc: VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 16, 2015 at 06:02:27PM +0200, Paolo Bonzini wrote:
> =

> =

> On 16/04/2015 17:54, J=E9r=E9my Fangu=E8de wrote:
> > The guest kernel driver of the lsi device fails to enable it correctly
> > with a cache error:
> > [...]
> > sym53c8xx 0000:00:01.0: enabling device (0100 -> 0103)
> > sym0: <895a> rev 0x0 at pci 0000:00:01.0 irq 54
> > sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
> > CACHE TEST FAILED: chip wrote 2, host read 1.
> > sym0: CACHE INCORRECTLY CONFIGURED.
> > sym0: giving up ...
> > [...]
> =

> Note that this is just a failure in the driver self-test.  It has
> nothing to do with the processor cache (though there are other problems
> with PCI and the processor cache in KVM mode).
> =

> Do not use this QEMU device.  The emulation is incomplete and it's slow.
>  Use virtio-scsi or megasas instead.  Still, I'm not sure that would
> work with KVM; as far as I know, most work on the ARM PCI host bridge
> was done using UEFI firmware.
> =

I've been running a number of tests lately using virtio-net-pci and
virtio-blk-pci on XGene at it works like a charm.

-Christoffer
