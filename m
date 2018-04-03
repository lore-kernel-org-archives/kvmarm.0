From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 2/6] Disable instrumentation for some code
Date: Tue, 3 Apr 2018 12:30:42 +0100
Message-ID: <7837103a-bcf0-6b00-14d6-bd6b80649886__17790.4342221611$1522754986$gmane$org@arm.com>
References: <20180402120440.31900-1-liuwenliang@huawei.com>
 <20180402120440.31900-3-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4820405A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 07:22:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z6oyQXX0CQTF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Apr 2018 07:22:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C2C740357
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 07:22:31 -0400 (EDT)
In-Reply-To: <20180402120440.31900-3-liuwenliang@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Abbott Liu <liuwenliang@huawei.com>, aryabinin@virtuozzo.com, dvyukov@google.com, corbet@lwn.net, linux@armlinux.org.uk, christoffer.dall@linaro.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, f.fainelli@gmail.com, akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, pombredanne@nexb.com, ard.biesheuvel@linaro.org, vladimir.murzin@arm.com, alexander.levin@verizon.com, nicolas.pitre@linaro.org, tglx@linutronix.de, thgarnie@google.com, dhowells@redhat.com, keescook@chromium.org, arnd@arndb.de, geert@linux-m68k.org, tixy@linaro.org, julien.thierry@arm.com, mark.rutland@arm.com, james.morse@arm.com, zhichao.huang@linaro.org, jinb.park7@gmail.com, labbott@redhat.com, philip@cog.systems, grygorii.strashko@linaro.org, catalin.marinas@arm.com, opendmb@gmail.com, kirill.shutemov@linux.intel.com, kasan-dev@googlegroups.com, linux-doc@vger.ker
List-Id: kvmarm@lists.cs.columbia.edu

On 02/04/18 13:04, Abbott Liu wrote:
> From: Andrey Ryabinin <a.ryabinin@samsung.com>
> 
> Disable instrumentation for arch/arm/boot/compressed/*
> ,arch/arm/kvm/hyp/* and arch/arm/vdso/* because those
> code won't linkd with kernel image.
> 
> Disable kasan check in the function unwind_pop_register
> because it doesn't matter that kasan checks failed when
> unwind_pop_register read stack memory of task.
> 
> Reviewed-by: Russell King - ARM Linux <linux@armlinux.org.uk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Just because I replied to this patch doesn't mean you can stick my
Reviewed-by tag on it. Please drop this tag until I explicitly say that
you can add it (see Documentation/process/submitting-patches.rst,
section 11).

Same goes for patch 1.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
