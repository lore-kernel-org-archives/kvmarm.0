From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH 1/7] 2 1-byte checks more safer for memory_is_poisoned_16
Date: Mon, 19 Mar 2018 01:02:34 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C0076F8D@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC68E405D1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Mar 2018 20:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id edURJCw2x8TE for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Mar 2018 20:56:24 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23669402D6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Mar 2018 20:56:16 -0400 (EDT)
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
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tixy@linaro.org" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "glider@google.com" <glider@google.com>, "afzal.mohd.ma@gmail.com" <afzal.mohd.ma@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, zhichao.huang@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Mar 18, 2018 at 21:21:20PM +0800, Russell King wrote:
>On Sun, Mar 18, 2018 at 08:53:36PM +0800, Abbott Liu wrote:
>> Because in some architecture(eg. arm) instruction set, non-aligned
>> access support is not very well, so 2 1-byte checks is more
>> safer than 1 2-byte check. The impact on performance is small
>> because 16-byte accesses are not too common.
>
>This is unnecessary:
>
>1. a load of a 16-bit quantity will work as desired on modern ARMs.
>2. Networking already relies on unaligned loads to work as per x86
>   (iow, an unaligned 32-bit load loads the 32-bits at the address
>   even if it's not naturally aligned, and that also goes for 16-bit
>   accesses.)
>
>If these are rare (which you say above - "not too common") then it's
>much better to leave the code as-is, because it will most likely be
>faster on modern CPUs, and the impact for older generation CPUs is
>likely to be low.

Thanks for your review.
OK, I am going to remove this patch in the next version.
