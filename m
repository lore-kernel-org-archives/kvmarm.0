From: "Liuwenliang (Abbott Liu)" <liuwenliang@huawei.com>
Subject: Re: [PATCH 7/7] Enable KASan for arm
Date: Sat, 24 Mar 2018 13:55:37 +0000
Message-ID: <B8AC3E80E903784988AB3003E3E97330C007750D@dggemm510-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334304A012
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 09:48:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LfubuupulC7e for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Mar 2018 09:47:50 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A6194A001
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 09:47:50 -0400 (EDT)
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
To: kbuild test robot <lkp@intel.com>
Cc: "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>, "grygorii.strashko@linaro.org" <grygorii.strashko@linaro.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tixy@linaro.org" <tixy@linaro.org>, "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "dhowells@redhat.com" <dhowells@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "glider@google.com" <glider@google.com>, "afzal.mohd.ma@gmail.com" <afzal.mohd.ma@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "geert@linux-m68k.org" <geert@linu>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/20/2018 2:30 AM, kbuild test robot wrote:
>All errors (new ones prefixed by >>):
>
>   arch/arm/kernel/entry-common.S: Assembler messages:
>>> arch/arm/kernel/entry-common.S:85: Error: invalid constant (ffffffffb6e00000) after fixup

I'm sorry!
We need to add the fellowing code to solve the upper error:
> git diff
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index b7d0c6c..9b728c5 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -82,7 +82,8 @@ ret_fast_syscall:
        str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
        disable_irq_notrace                     @ disable interrupts
        ldr     r2, [tsk, #TI_ADDR_LIMIT]
-	cmp     r2, #TASK_SIZE
+	ldr		r1, =TASK_SIZE
+	cmp		r2, r1
        blne    addr_limit_check_failed
        ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
        tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
