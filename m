From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/14] arm64: Check for selected granule support
Date: Wed, 2 Sep 2015 12:19:07 +0200
Message-ID: <CAKv+Gu-eWRcFQkn_99WF_3H=u8qAAVis60SuegdxyeYK3v5QdQ@mail.gmail.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
	<1439465645-22584-13-git-send-email-suzuki.poulose@arm.com>
	<CAPvkgC3=S1BxdzZM4uUOmyXLjii48SMpCof6i6HdNeTG_fydfg@mail.gmail.com>
	<55CCAD73.7080702@arm.com>
	<20150813172946.GD4602@e104818-lin.cambridge.arm.com>
	<CAKv+Gu8vfsL+SFqgsXESfYC5a90-rnHbLqVFuOkvDXTt2b1E3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8vfsL+SFqgsXESfYC5a90-rnHbLqVFuOkvDXTt2b1E3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, Steve Capper <steve.capper@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 September 2015 at 11:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 13 August 2015 at 19:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On Thu, Aug 13, 2015 at 03:45:07PM +0100, Suzuki K. Poulose wrote:
>>> On 13/08/15 13:28, Steve Capper wrote:
>>> >On 13 August 2015 at 12:34, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
>>> >>  __enable_mmu:
>>> >>+       mrs     x1, ID_AA64MMFR0_EL1
>>> >>+       ubfx    x2, x1, #ID_AA64MMFR0_TGran_SHIFT, 4
>>> >>+       cmp     x2, #ID_AA64MMFR0_TGran_ENABLED
>>> >>+       b.ne    __no_granule_support
>>> >>         ldr     x5, =vectors
>>> >>         msr     vbar_el1, x5
>>> >>         msr     ttbr0_el1, x25                  // load TTBR0
>>> >>@@ -626,3 +643,8 @@ __enable_mmu:
>>> >>         isb
>>> >>         br      x27
>>> >>  ENDPROC(__enable_mmu)
>>> >>+
>>> >>+__no_granule_support:
>>> >>+       wfe
>>> >>+       b __no_granule_support
>>> >>+ENDPROC(__no_granule_support)
>>> >>--
>>> >>1.7.9.5
>>> >>
>>> >
>>> >Is is possible to tell the user that the kernel has failed to boot due
>>> >to the kernel granule being unsupported?
>>>
>>> We don't have anything up at this time. The "looping address" is actually a clue
>>> to the (expert) user. Not sure we can do something, until we get something like DEBUG_LL(?)
>>
>> No.
>>
>>> Or we should let it continue and end in a panic(?). The current situation can boot a
>>> multi-cluster system with boot cluster having the Tgran support(which doesn't make a
>>> strong use case though). I will try out some options and get back to you.
>>
>> If the boot CPU does not support 16KB pages, in general there isn't much
>> we can do since the console printing is done after we enabled the MMU.
>> Even mapping the UART address requires fixmap support and the PAGE_SIZE
>> is hard-coded in the kernel image. The DT is also mapped at run-time.
>>
>> While in theory it's possible to fall back to a 4KB page size just
>> enough to load the DT and figure out the early console, I suggest we
>> just live with the "looping address" clue.
>>
>
> Couldn't we allocate some flag bits in the Image header to communicate
> the page size to the bootloader?

Something like this perhaps?

------------8<---------------
diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 7d9d3c2286b2..13a8aaa9a6e9 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -104,7 +104,8 @@ Header notes:
 - The flags field (introduced in v3.17) is a little-endian 64-bit field
   composed as follows:
   Bit 0:       Kernel endianness.  1 if BE, 0 if LE.
-  Bits 1-63:   Reserved.
+  Bits 1-2:    Kernel page size.   0=unspecified, 1=4K, 2=16K, 3=64K
+  Bits 3-63:   Reserved.

 - When image_size is zero, a bootloader should attempt to keep as much
   memory as possible free for use by the kernel immediately after the
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 8fae0756e175..5def289bda84 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -47,7 +47,9 @@
 #define __HEAD_FLAG_BE 0
 #endif

-#define __HEAD_FLAGS   (__HEAD_FLAG_BE << 0)
+#define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
+
+#define __HEAD_FLAGS   (__HEAD_FLAG_BE << 0) | (__HEAD_FLAG_PAGE_SIZE << 1)

 /*
  * These will output as part of the Image header, which should be little-endian
