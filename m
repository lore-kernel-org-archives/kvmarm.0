From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH roundup 2/4] ARM: KVM: avoid "HYP init code too big" error
Date: Tue, 10 Mar 2015 10:56:53 +0100
Message-ID: <CAKv+Gu9AkCmwToCKghrErUhNmOWwxPnAPq7NCOh6exb1H8NpGA@mail.gmail.com>
References: <1425652482-31411-1-git-send-email-ard.biesheuvel@linaro.org>
 <1425652482-31411-3-git-send-email-ard.biesheuvel@linaro.org>
 <20150309190947.GF8656@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B45248490
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2015 05:50:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPCMA8TVz2GU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Mar 2015 05:50:36 -0400 (EDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92B664848F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2015 05:50:36 -0400 (EDT)
Received: by iecsf10 with SMTP id sf10so6672391iec.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2015 02:56:53 -0700 (PDT)
In-Reply-To: <20150309190947.GF8656@n2100.arm.linux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

(resend with complete cc)

On 9 March 2015 at 20:09, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Mar 06, 2015 at 03:34:40PM +0100, Ard Biesheuvel wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> When building large kernels, the linker will emit lots of veneers
>> into the .hyp.idmap.text section, which causes it to grow beyond
>> one page, and that triggers the build error.
>>
>> This moves the section into .rodata instead, which avoids the
>> veneers and is safe because the code is not executed directly
>> but remapped by the hypervisor into its own executable address
>> space.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> [ardb: move the ALIGN() to .rodata as well, update log s/copied/remapped/]
>> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/kernel/vmlinux.lds.S | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index b31aa73e8076..2787eb8d3616 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -22,11 +22,15 @@
>>       ALIGN_FUNCTION();                                               \
>>       VMLINUX_SYMBOL(__idmap_text_start) = .;                         \
>>       *(.idmap.text)                                                  \
>> -     VMLINUX_SYMBOL(__idmap_text_end) = .;                           \
>> +     VMLINUX_SYMBOL(__idmap_text_end) = .;
>> +
>> +#define IDMAP_RODATA                                                 \
>> +     .rodata : {                                                     \
>
> We already have a .rodata section defined by RO_DATA().  Quite how this
> interacts with the existing .rodata section, I don't know, but it
> probably won't be right.  Have you checked what effect this has?
>

 Here's just the rodata lines from 'readelf -S vmlinux', with and
without the patch applied

[ 4] .rodata           PROGBITS        c0752000 552000 310620 00   A  0   0 64

[ 4] .rodata           PROGBITS        c0752000 552000 3106c0 00  AX  0   0 64

and there is only a single one, so it appears binutils is quite happy with this.

If the A -> AX bothers you, we could fold in the following hunk as well.

--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -52,7 +52,7 @@
  */

        .text
-       .pushsection    .hyp.idmap.text,"ax"
+       .pushsection    .hyp.idmap.text,"a"
        .align 5
 __kvm_hyp_init:
        .globl __kvm_hyp_init

which takes care of that.
