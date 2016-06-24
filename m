From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Fri, 24 Jun 2016 20:16:50 +0200
Message-ID: <CAKv+Gu_f6yFhLhe6NcrYMeBNLHPmNrRMbTCAt=f-ERwfbdZdgA@mail.gmail.com>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774C049B49
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 14:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hSEmD4PGu2oW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2016 14:11:51 -0400 (EDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com
 [209.85.214.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CDC249B36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 14:11:50 -0400 (EDT)
Received: by mail-it0-f42.google.com with SMTP id g127so21339640ith.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2016 11:16:51 -0700 (PDT)
In-Reply-To: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Alexander Graf <agraf@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 June 2016 at 16:04, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
[...]
> Note that this issue not only affects framebuffers on PCI cards, it
> also affects emulated USB host controllers (perhaps Alex can remind us
> which one exactly?)

Actually, looking at the QEMU source code, I am not able to spot the
USB hcd emulation code that backs a PCI MMIO BAR using host memory,
and in fact, the only instance I *can* find is vga-pci.c

@Alex: could you please explain which exact issue with USB emulation
is suspected to be caused by this?

@team-RH: are there any other examples beyond VGA PCI where this is a problem?

Thanks,
Ard.
