From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: Add ASM modifier for xN register operands
Date: Mon, 24 Apr 2017 18:22:51 +0100
Message-ID: <CAKv+Gu_Ms73qfFFjmhkwF9Rh2jBM6Cx9LfuSHPUnXv0GTR1z7w@mail.gmail.com>
References: <20170420183053.718-1-mka@chromium.org>
 <20170424170009.GT12323@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D8F40D9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 13:20:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qy2vrb9w4jGP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 13:20:04 -0400 (EDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com
 [209.85.223.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D6EC40D94
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 13:20:03 -0400 (EDT)
Received: by mail-io0-f179.google.com with SMTP id r16so192832394ioi.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 10:22:52 -0700 (PDT)
In-Reply-To: <20170424170009.GT12323@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Grant Grundler <grundler@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 April 2017 at 18:00, Will Deacon <will.deacon@arm.com> wrote:
> Hi Matthias,
>
> On Thu, Apr 20, 2017 at 11:30:53AM -0700, Matthias Kaehlcke wrote:
>> Many inline assembly statements don't include the 'x' modifier when
>> using xN registers as operands. This is perfectly valid, however it
>> causes clang to raise warnings like this:
>>
>> warning: value size does not match register size specified by the
>>   constraint and modifier [-Wasm-operand-widths]
>> ...
>> arch/arm64/include/asm/barrier.h:62:23: note: expanded from macro
>>   '__smp_store_release'
>>     asm volatile ("stlr %1, %0"
>
> If I understand this correctly, then the warning is emitted when we pass
> in a value smaller than 64-bit, but refer to %<n> without a modifier
> in the inline asm.
>
> However, if that's the case then I don't understand why:
>
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 0c00c87bb9dd..021e1733da0c 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -39,33 +39,33 @@
>>  #define __raw_writeb __raw_writeb
>>  static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
>>  {
>> -     asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
>> +     asm volatile("strb %w0, [%x1]" : : "rZ" (val), "r" (addr));
>
> is necessary. addr is a pointer type, so is 64-bit.
>
> Given that the scattergun nature of this patch implies that you've been
> fixing the places where warnings are reported, then I'm confused as to
> why a warning is generated for the case above.
>
> What am I missing?
>

AIUI, Clang now always complains for missing register width modifiers,
not just for placeholders that resolve to a 32-bit (or smaller)
quantity.
