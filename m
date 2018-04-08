From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH v3 2/6] Disable instrumentation for some code
Date: Sun, 8 Apr 2018 01:38:05 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C0077F5D@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFE6402D6
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 Apr 2018 21:29:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R18fMqOOpGcz for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 Apr 2018 21:29:37 -0400 (EDT)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA32D49F87
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 Apr 2018 21:29:36 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "julien.thierry@arm.com" <julien.thierry@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tixy@linaro.org" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 03, 2018 at 19:39, Russell King - ARM Linux:
>On Tue, Apr 03, 2018 at 12:30:42PM +0100, Marc Zyngier wrote:
>> On 02/04/18 13:04, Abbott Liu wrote:
>> > From: Andrey Ryabinin <a.ryabinin@samsung.com>
>> > 
>> > Disable instrumentation for arch/arm/boot/compressed/*
>> > ,arch/arm/kvm/hyp/* and arch/arm/vdso/* because those
>> > code won't linkd with kernel image.
>> > 
>> > Disable kasan check in the function unwind_pop_register
>> > because it doesn't matter that kasan checks failed when
>> > unwind_pop_register read stack memory of task.
>> > 
>> > Reviewed-by: Russell King - ARM Linux <linux@armlinux.org.uk>
>> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> 
>> Just because I replied to this patch doesn't mean you can stick my
>> Reviewed-by tag on it. Please drop this tag until I explicitly say that
>> you can add it (see Documentation/process/submitting-patches.rst,
>> section 11).
>> 
>> Same goes for patch 1.
>
>Same goes for that reviewed-by line for me.  From my records, I never
>even looked at patch 2 from the first posting, and I don't appear to
>have the second posting in my mailbox (it's probably been classed as
>spam by dspam.)  So these reviewed-by lines seem to be totally
>misleading.

Thank Marc Zyngier and Russell King.
I have read Documentation/process/submitting-patches.rst and understand
it now. I will change it in the next version.
