From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH v2 0/7] KASan for arm
Date: Sat, 24 Mar 2018 12:24:22 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C00774B7@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA0A4A001
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 08:16:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JeUlO7bw1x1c for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Mar 2018 08:16:33 -0400 (EDT)
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67B5349FFF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 08:16:33 -0400 (EDT)
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
To: Dmitry Vyukov <dvyukov@google.com>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tixy@linaro.org" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "glider@google.com" <glider@google.com>, "afzal.mohd.ma@gmail.com" <afzal.mohd.ma@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Florian Fainelli <f.fainelli@gmail.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, aryab
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 19, 2018 at 16:44 , Dmitry Vyukov wrote:
>Hi Abbott,
>
>I've skimmed through the changes and they generally look good to me. I
>am not an expect in arm, so I did not look too closely on these parts
>(which is actually most of the changes).
>
>FWIW
>Acked-by: Dmitry Vyukov <dvyukov@google.com>
>
>Please also update set of supported archs at the top of
>Documentation/dev-tools/kasan.rst
>
>Thanks for working on upstreaming this!

Thanks for your review.
I will update set of supported archs just like this:
diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index f7a18f2..d92120d 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -12,7 +12,7 @@ KASAN uses compile-time instrumentation for checking every memory access,
 therefore you will need a GCC version 4.9.2 or later. GCC 5.0 or later is
 required for detection of out-of-bounds accesses to stack or global variables.

-Currently KASAN is supported only for the x86_64 and arm64 architectures.
+Currently KASAN is supported only for the x86_64, arm64 and arm architectures.
