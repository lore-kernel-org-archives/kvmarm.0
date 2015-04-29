From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [RFC PATCH 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Wed, 29 Apr 2015 10:19:55 +0100
Message-ID: <CAFEAcA8782LF=m_L=iEqgkBAVThO2SxXOu74YaM3YQkvN_4owA@mail.gmail.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-1-git-send-email-drjones@redhat.com>
 <55409E4E.3090905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F12D74EEB7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 05:11:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BIjI8kfffMq0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 05:11:48 -0400 (EDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
 [209.85.213.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B44B4EEB5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 05:11:47 -0400 (EDT)
Received: by igblo3 with SMTP id lo3so111499307igb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 02:20:16 -0700 (PDT)
In-Reply-To: <55409E4E.3090905@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 April 2015 at 10:03, Alexander Graf <agraf@suse.de> wrote:
>
>
> On 18.03.15 20:10, Andrew Jones wrote:
>> Introduce a new memory region flag, KVM_MEM_UNCACHED, which
>> is needed by ARM. This flag informs KVM that the given memory
>> region is typically mapped by the guest as uncached. KVM for
>> ARM then maps that region as uncached for userspace as well,
>> in order to keep coherency.
>
> I finally managed to give this a spin and immediately ran into an
> unaligned access trap:
>
> [  116.509976] Unhandled fault: alignment fault (0x92000061) at
> 0x000003ffb1300000
>
> Program received signal SIGBUS, Bus error.
> [Switching to Thread 0x3ffb317ecb0 (LWP 1956)]
> 0x000003ffb685ed68 in memset () from /lib64/libc.so.6
> (gdb) bt
> #0  0x000003ffb685ed68 in memset () from /lib64/libc.so.6
> #1  0x000002aaaac013ec in memset (__len=<optimized out>, __ch=0,
> __dest=<optimized out>) at /usr/include/bits/string3.h:90
> #2  vbe_ioport_write_data (opaque=0x2aaabbd3600, addr=<optimized out>,
> val=65) at /usr/src/debug/qemu-2.3.0-rc4/hw/display/vga.c:739
> #3  0x000002aaaabe07dc in memory_region_write_accessor (mr=<optimized
> out>, addr=<optimized out>, value=<optimized out>, size=<optimized out>,
>     shift=<optimized out>, mask=<optimized out>) at
> /usr/src/debug/qemu-2.3.0-rc4/memory.c:430
> [...]

This appears to be because the KVM_MEM_UNCACHED flag
confusingly isn't marking the memory as Normal-Noncacheable
but as Device-nGnRnE (aka Strongly Ordered). You can't unalignedly
access Device memory (and so you can't use the usual userspace
memcpy, memset, etc).

Did we really want Device-nGnRnE memory here? If we did can
we have a less confusing name for the flag?

[for the non-ARM folk, nGnRnE == no gathering of accesses,
no reordering, no early-write-acknowledgement.]

thanks
-- PMM
