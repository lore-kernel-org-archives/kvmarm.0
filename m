From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 0/3] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Thu, 03 Dec 2015 13:53:14 +0300
Message-ID: <00cb01d12db8$cf9e8580$6edb9080$@samsung.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
 <56601407.7020407@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C15F5498E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 05:51:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mn0plJ6YTTw1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 05:51:46 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D300498CA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 05:51:45 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYS00I1J3KROK20@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 03 Dec 2015 10:53:15 +0000 (GMT)
In-reply-to: <56601407.7020407@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > The problem has been discovered by performing an operation
> >
> >  *((volatile int *)reg) = 0;
> >
> > which compiles as "str xzr, [xx]", and resulted in strange values being
> > written.
> 
> Interesting find. Which compiler is that?

$ aarch64-linux-gnu-gcc --version
aarch64-linux-gnu-gcc (Linaro GCC 2014.11) 4.9.3 20141031 (prerelease)
Copyright (C) 2014 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 This is from my colleague who actually hit the bug by his driver. And i can reproduce the issue with different compiler version
using the following small testcase:
--- cut ---
p.fedin@fedinw7x64 /cygdrive/d/Projects/Test
$ cat test.c
volatile int *addr;

int test_val(int val)
{
    *addr = val;
}

int test_zero(void)
{
    *addr = 0;
}

p.fedin@fedinw7x64 /cygdrive/d/Projects/Test
$ aarch64-unknown-linux-gnu-gcc -O2 -c test.c

p.fedin@fedinw7x64 /cygdrive/d/Projects/Test
$ aarch64-unknown-linux-gnu-objdump -d test.o

test.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <test_val>:
   0:   2a0003e2        mov     w2, w0
   4:   2a0103e0        mov     w0, w1
   8:   90000001        adrp    x1, 8 <test_val+0x8>
   c:   f9400021        ldr     x1, [x1]
  10:   b9000022        str     w2, [x1]
  14:   d65f03c0        ret

0000000000000018 <test_zero>:
  18:   90000001        adrp    x1, 8 <test_val+0x8>
  1c:   f9400021        ldr     x1, [x1]
  20:   b900003f        str     wzr, [x1]
  24:   d65f03c0        ret

p.fedin@fedinw7x64 /cygdrive/d/Projects/Test
$ aarch64-unknown-linux-gnu-gcc --version
aarch64-unknown-linux-gnu-gcc (GCC) 4.9.0
Copyright (C) 2014 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--- cut ---

 Isn't it legitimate to write from ZR to MMIO register?
 Another potential case is in our vgic-v3-switch.S:

	msr_s	ICH_HCR_EL2, xzr

 It's only because it is KVM code we have never discovered this problem yet. Somebody could write such a thing in some other place,
with some other register, which would be executed by KVM, and... boo...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
