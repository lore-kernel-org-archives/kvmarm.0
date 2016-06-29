From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Wed, 29 Jun 2016 09:12:42 +0200
Message-ID: <1467184362.15123.49.camel@redhat.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <52f1a2e2-63c9-a5d2-9b78-7264923e04c4@redhat.com>
 <CAKv+Gu-5CffcgsWwOUpXukVQJaSxRtvHTFiQjf+OmG380iKWaA@mail.gmail.com>
 <40f24dbe-06bd-cb73-ae8c-af20930cb360@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D860C49B4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 03:07:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5JXUaKLHfv3R for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 03:07:32 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3DEB49B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 03:07:32 -0400 (EDT)
In-Reply-To: <40f24dbe-06bd-cb73-ae8c-af20930cb360@redhat.com>
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
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Di, 2016-06-28 at 15:32 +0200, Laszlo Ersek wrote:
> (adding Gerd)
> 
> On 06/28/16 15:14, Ard Biesheuvel wrote:
> 
> > In any case, reconciling software that requires a framebuffer with a
> > GPU emulation that does not expose one by design is going to be
> > problematic even without this issue. How is this supposed to work on
> > x86?
> 
> AFAIK:
> 
> "virtio-gpu-pci" is the device model without the framebuffer. It is good
> for secondary displays (i.e. those that you don't boot with, only use
> after the guest kernel starts up).
> 
> "virtio-vga" is the same, but it also has the legacy VGA framebuffer,
> hence it can be used for accommodating boot loaders. (Except it won't
> work for aarch64 KVM guests, because of $SUBJECT.)

Exactly.  virtio-vga is basically virtio-gpu-pci + stdvga combined.
Power-on default is vga mode.  It switches into virtio mode when the
guest configures a output using virtio commands.  It switches back to
vga mode on reset.

You can get a simple framebuffer by using the stdvga part of the device.
QemuVideoDxe does exactly that.  The linux kernel switches from vga mode
(efifb) to virtio mode when the virtio-gpu kms driver loads.

Of course virtio-vga in vga mode has exactly the same cache coherency
issues as stdvga on arm.  So, once the linux kernel with the virtio-gpu
is up'n'running everything is fine, but how to handle early bootloader
display isn't solved yet.

cheers,
  Gerd
