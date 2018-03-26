From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH v2 0/7] KASan for arm
Date: Mon, 26 Mar 2018 01:13:45 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C0077579@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA9E49F7E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Mar 2018 21:06:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7tsm3q1x4WWr for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Mar 2018 21:05:48 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1211249EA2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Mar 2018 21:05:48 -0400 (EDT)
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
To: Joel Stanley <joel@jms.id.au>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "glider@google.com" <glider@google.com>, Afzal Mohammed <afzal.mohd.ma@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Florian Fainelli <f.fainelli@gmail.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, Russell King <linux@armlinux.org.uk>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, "zhichao.huang@linaro.org" <zhi>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 March 2018 at 7:59, Joel Stanley  <joel.stan@gmail.com> wrote:
>On 18 March 2018 at 23:23, Abbott Liu <liuwenliang@huawei.com> wrote:
>
>>    These patches add arch specific code for kernel address sanitizer 
>> (see Documentation/kasan.txt).
>
>Thanks for implementing this. I gave the series a spin on an ASPEED
>ast2500 (ARMv5) system with aspeed_g5_defconfig.
>
>It found a bug in the NCSI code (https://github.com/openbmc/linux/issues/146).
>
>Tested-by: Joel Stanley <joel@jms.id.au>
>
>Cheers,
>
>Joel

Thanks for your test.
