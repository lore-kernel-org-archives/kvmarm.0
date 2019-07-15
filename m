Return-Path: <SRS0=W8aC=VM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF59C7618A
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 04:04:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAA3620644
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 04:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAA3620644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02A214A3BF;
	Mon, 15 Jul 2019 00:04:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jrqa3VygBW9p; Mon, 15 Jul 2019 00:04:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F375C4A512;
	Mon, 15 Jul 2019 00:04:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DE584A4FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 00:04:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m9UYoUlhfNm8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 00:04:31 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1D5A4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 00:04:30 -0400 (EDT)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
 by Forcepoint Email with ESMTP id E4AF1F52F88BD7170A46;
 Mon, 15 Jul 2019 12:04:25 +0800 (CST)
Received: from DGGEMM424-HUB.china.huawei.com (10.1.198.41) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jul 2019 12:04:25 +0800
Received: from DGGEMM510-MBX.china.huawei.com ([169.254.12.26]) by
 dggemm424-hub.china.huawei.com ([10.1.198.41]) with mapi id 14.03.0439.000;
 Mon, 15 Jul 2019 12:04:20 +0800
From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
To: Linus Walleij <linus.walleij@linaro.org>, Florian Fainelli
 <f.fainelli@gmail.com>, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v6 1/6] ARM: Add TTBR operator for kasan_init
Thread-Topic: [PATCH v6 1/6] ARM: Add TTBR operator for kasan_init
Thread-Index: AdU6wdMFianDqtlpTa+Ta2pyAck5Eg==
Date: Mon, 15 Jul 2019 04:04:19 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C4B40D0A@dggemm510-mbx.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.57.90.243]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
 "mhocko@suse.com" <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 David Howells <dhowells@redhat.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Jonathan Corbet <corbet@lwn.net>, Daniel Lezcano <daniel.lezcano@linaro.org>,
 Russell King <linux@armlinux.org.uk>,
 "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
 bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>, Dmitry
 Vyukov <dvyukov@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Kees Cook <keescook@chromium.org>, Arnd
 Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 "philip@cog.systems" <philip@cog.systems>,
 "jinb.park7@gmail.com" <jinb.park7@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Nicolas Pitre <nico@fluxnic.net>, Greg KH <gregkh@linuxfoundation.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Linux Doc Mailing List <linux-doc@vger.kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Rob Landley <rob@landley.net>,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "thgarnie@google.com" <thgarnie@google.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Florian and Linus Walleij!
Thanks Florian for picking these patches up.
Thanks Linus Walleij for review these patches.

Yes, This patch is refactoring patch. But we need use set_ttbr0/get_ttbr0 
(in 0005-Initialize-the-mapping-of-KASan-shadow-memory.patch) which is define in 
This patch. So if we put this patch as a separate patch. It must be merge first. Or we need 
define set_ttbr0/get_ttbr0 in a temporary mode.

>Hi Florian!
>
>thanks for your patch!
>
> On Wed, July 3, 2019 at 5:04 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
>> From: Abbott Liu <liuwenliang@huawei.com>
>>
>> The purpose of this patch is to provide set_ttbr0/get_ttbr0 to 
>> kasan_init function. The definitions of cp15 registers should be in 
>> arch/arm/include/asm/cp15.h rather than 
>> arch/arm/include/asm/kvm_hyp.h, so move them.
>>
>> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
>> Reported-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>
>> +#include <linux/stringify.h>
>
>What is this for? I think it can be dropped.
>
>This stuff adding a whole bunch of accessors:
>
>> +static inline void set_par(u64 val)
>> +{
>> +       if (IS_ENABLED(CONFIG_ARM_LPAE))
>> +               write_sysreg(val, PAR_64);
>> +       else
>> +               write_sysreg(val, PAR_32); }
>
>Can we put that in a separate patch since it is not adding any users, so this is a pure refactoring patch for the current code?
>
>Yours,
>Linus Walleij
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
