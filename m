From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Tue, 28 Jun 2016 15:32:14 +0200
Message-ID: <40f24dbe-06bd-cb73-ae8c-af20930cb360@redhat.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <20160627091619.GB26498@cbox>
 <CAKv+Gu9u2f6+HLYMzqtkq0z=Xk5gTq=_11QvAKMaBZj_oRMwTA@mail.gmail.com>
 <20160627103421.GC26498@cbox>
 <52f1a2e2-63c9-a5d2-9b78-7264923e04c4@redhat.com>
 <CAKv+Gu-5CffcgsWwOUpXukVQJaSxRtvHTFiQjf+OmG380iKWaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CA549B55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:27:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M1gT1miY5QTg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 09:27:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 838DF49B54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 09:27:08 -0400 (EDT)
In-Reply-To: <CAKv+Gu-5CffcgsWwOUpXukVQJaSxRtvHTFiQjf+OmG380iKWaA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Gerd Hoffmann <kraxel@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

(adding Gerd)

On 06/28/16 15:14, Ard Biesheuvel wrote:

> In any case, reconciling software that requires a framebuffer with a
> GPU emulation that does not expose one by design is going to be
> problematic even without this issue. How is this supposed to work on
> x86?

AFAIK:

"virtio-gpu-pci" is the device model without the framebuffer. It is good
for secondary displays (i.e. those that you don't boot with, only use
after the guest kernel starts up).

"virtio-vga" is the same, but it also has the legacy VGA framebuffer,
hence it can be used for accommodating boot loaders. (Except it won't
work for aarch64 KVM guests, because of $SUBJECT.)

Thanks
Laszlo
