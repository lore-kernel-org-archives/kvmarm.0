From: Alexander Graf <agraf@suse.de>
Subject: Re: issues with emulated PCI MMIO backed by host memory under KVM
Date: Sat, 25 Jun 2016 09:15:51 +0200
Message-ID: <E4AD515B-A3F3-48E2-8D14-0A5FD1D35E8E@suse.de>
References: <CAKv+Gu8MWxUvySvsQW+DpohLLHSi8ZYm4o7gCE2a4q0iC=cuHA@mail.gmail.com>
 <CAKv+Gu_f6yFhLhe6NcrYMeBNLHPmNrRMbTCAt=f-ERwfbdZdgA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7389549B21
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 03:10:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VuZiVSxNPg8A for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jun 2016 03:10:53 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46D8B49B1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 03:10:52 -0400 (EDT)
In-Reply-To: <CAKv+Gu_f6yFhLhe6NcrYMeBNLHPmNrRMbTCAt=f-ERwfbdZdgA@mail.gmail.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



> Am 24.06.2016 um 20:16 schrieb Ard Biesheuvel <ard.biesheuvel@linaro.org>:
> 
>> On 24 June 2016 at 16:04, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> [...]
>> Note that this issue not only affects framebuffers on PCI cards, it
>> also affects emulated USB host controllers (perhaps Alex can remind us
>> which one exactly?)
> 
> Actually, looking at the QEMU source code, I am not able to spot the
> USB hcd emulation code that backs a PCI MMIO BAR using host memory,
> and in fact, the only instance I *can* find is vga-pci.c
> 
> @Alex: could you please explain which exact issue with USB emulation
> is suspected to be caused by this?

IIRC Linux put thhe usb rings into guest memory and mapped them as NC inside the guest. So the host will see stale data from the cache.


Alex
