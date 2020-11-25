Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F005C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 11:22:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20A012075A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 11:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p47WRcWM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20A012075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6795F4B83D;
	Wed, 25 Nov 2020 06:22:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5dKiOm4v6Uao; Wed, 25 Nov 2020 06:22:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 108B14B910;
	Wed, 25 Nov 2020 06:22:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CA44B8D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 06:22:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GxmNGtQ8QuzT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 06:22:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 921C74B83D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 06:22:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 40E022075A;
 Wed, 25 Nov 2020 11:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606303319;
 bh=NGhfDhTdSFzCI6oQ1wbzlIayxC/tTwosQS2P3yXenWQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=p47WRcWMWwxaWI747Pz1wtJ+0ZeCgEvV8WyMa5y1EmivUDNNE72weWSGE2oaTAcCT
 MVB6IsWSz+/Wodh8P0VnJAlVuYhqsJMUrHqDEsr+PxysXr2pHS0WETaR98Ujy34leI
 LRzEI990PWLlSJbbrsZoVDkg+3kG2gIWfqGZZEB0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khss1-00DVv5-1g; Wed, 25 Nov 2020 11:21:57 +0000
MIME-Version: 1.0
Date: Wed, 25 Nov 2020 11:21:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 04/24] arm64: Move MAIR_EL1_SET to asm/memory.h
In-Reply-To: <20201125103137.iml7mqpzhylldvqy@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-5-dbrazdil@google.com> <87mtz85geh.wl-maz@kernel.org>
 <20201125103137.iml7mqpzhylldvqy@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <e6c9184c6ee986d134625932b4fa8e89@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-25 10:31, David Brazdil wrote:
> On Mon, Nov 23, 2020 at 01:52:54PM +0000, Marc Zyngier wrote:
>> On Mon, 16 Nov 2020 20:42:58 +0000,
>> David Brazdil <dbrazdil@google.com> wrote:
>> >
>> > KVM currently initializes MAIR_EL2 to the value of MAIR_EL1. In
>> > preparation for initializing MAIR_EL2 before MAIR_EL1, move the constant
>> > into a shared header file. Since it is used for EL1 and EL2, rename to
>> > MAIR_ELx_SET.
>> >
>> > Signed-off-by: David Brazdil <dbrazdil@google.com>
>> > ---
>> >  arch/arm64/include/asm/memory.h | 29 ++++++++++++++---------------
>> >  arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
>> >  arch/arm64/mm/proc.S            | 15 +--------------
>> >  3 files changed, 45 insertions(+), 29 deletions(-)
>> >
>> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
>> > index cd61239bae8c..8ae8fd883a0c 100644
>> > --- a/arch/arm64/include/asm/memory.h
>> > +++ b/arch/arm64/include/asm/memory.h
>> > @@ -13,6 +13,7 @@
>> >  #include <linux/const.h>
>> >  #include <linux/sizes.h>
>> >  #include <asm/page-def.h>
>> > +#include <asm/sysreg.h>
>> >
>> >  /*
>> >   * Size of the PCI I/O space. This must remain a power of two so that
>> > @@ -124,21 +125,6 @@
>> >   */
>> >  #define SEGMENT_ALIGN		SZ_64K
>> >
>> > -/*
>> > - * Memory types available.
>> > - *
>> > - * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
>> > - *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
>> > - *	      that protection_map[] only contains MT_NORMAL attributes.
>> > - */
>> > -#define MT_NORMAL		0
>> > -#define MT_NORMAL_TAGGED	1
>> > -#define MT_NORMAL_NC		2
>> > -#define MT_NORMAL_WT		3
>> > -#define MT_DEVICE_nGnRnE	4
>> > -#define MT_DEVICE_nGnRE		5
>> > -#define MT_DEVICE_GRE		6
>> > -
>> >  /*
>> >   * Memory types for Stage-2 translation
>> >   */
>> > @@ -152,6 +138,19 @@
>> >  #define MT_S2_FWB_NORMAL	6
>> >  #define MT_S2_FWB_DEVICE_nGnRE	1
>> >
>> > +/*
>> > + * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
>> > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
>> > + */
>> > +#define MAIR_ELx_SET							\
>> > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
>> > +
>> >  #ifdef CONFIG_ARM64_4K_PAGES
>> >  #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
>> >  #else
>> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> > index e2ef4c2edf06..24e773414cb4 100644
>> > --- a/arch/arm64/include/asm/sysreg.h
>> > +++ b/arch/arm64/include/asm/sysreg.h
>> > @@ -635,6 +635,34 @@
>> >  /* Position the attr at the correct index */
>> >  #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))
>> >
>> > +/*
>> > + * Memory types available.
>> > + *
>> > + * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
>> > + *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
>> > + *	      that protection_map[] only contains MT_NORMAL attributes.
>> > + */
>> > +#define MT_NORMAL		0
>> > +#define MT_NORMAL_TAGGED	1
>> > +#define MT_NORMAL_NC		2
>> > +#define MT_NORMAL_WT		3
>> > +#define MT_DEVICE_nGnRnE	4
>> > +#define MT_DEVICE_nGnRE		5
>> > +#define MT_DEVICE_GRE		6
>> > +
>> > +/*
>> > + * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal memory and
>> > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
>> > + */
>> > +#define MAIR_ELx_SET							\
>> > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
>> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
>> > +

Wait: You now have MAIR_ELx_SET defined at two locations. Surely that's
one too many.

>> >  /* id_aa64isar0 */
>> >  #define ID_AA64ISAR0_RNDR_SHIFT		60
>> >  #define ID_AA64ISAR0_TLB_SHIFT		56
>> > @@ -992,6 +1020,7 @@
>> >  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
>> >  #define SYS_MPIDR_SAFE_VAL	(BIT(31))
>> >
>> > +#ifndef LINKER_SCRIPT
>> 
>> This is terribly ugly. Why is this included by the linker script? Does
>> it actually define __ASSEMBLY__?
> 
> vmlinux.lds.S includes memory.h for PAGE_SIZE. And yes, linker scripts 
> are
> built with this rule:
> 
>       cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -U$(ARCH) \
> 	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<
> 
> I tried a few things and wasn't completely happy with any of them. I 
> think in
> the previous spin you suggested moving this constant to sysreg.h. That 
> works
> too but sysreg.h seems to have only architecture constants, memory.h 
> about a
> Linux-specific configuration, so I wanted to keep it here.

MAIR_ELx_SET isn't really Linux specific. Or rather, not more specific 
than
any of the other configurations we have. On the other hand, the S1 MT_* 
stuff
is totally arbitrary, and does fit in memory.h, together with the rest 
of
the indexes for the memory types.

I came up with the following patch on top of this series that seems to
compile without issue.

         M.

diff --git a/arch/arm64/include/asm/memory.h 
b/arch/arm64/include/asm/memory.h
index 8ae8fd883a0c..01685d81e9d4 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -13,7 +13,6 @@
  #include <linux/const.h>
  #include <linux/sizes.h>
  #include <asm/page-def.h>
-#include <asm/sysreg.h>

  /*
   * Size of the PCI I/O space. This must remain a power of two so that
@@ -139,17 +138,19 @@
  #define MT_S2_FWB_DEVICE_nGnRE	1

  /*
- * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal 
memory and
- * changed during __cpu_setup to Normal Tagged if the system supports 
MTE.
+ * Memory types available.
+ *
+ * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 
'or' in
+ *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
+ *	      that protection_map[] only contains MT_NORMAL attributes.
   */
-#define MAIR_ELx_SET							\
-	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
-	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
-	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
-	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
+#define MT_NORMAL		0
+#define MT_NORMAL_TAGGED	1
+#define MT_NORMAL_NC		2
+#define MT_NORMAL_WT		3
+#define MT_DEVICE_nGnRnE	4
+#define MT_DEVICE_nGnRE		5
+#define MT_DEVICE_GRE		6

  #ifdef CONFIG_ARM64_4K_PAGES
  #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
diff --git a/arch/arm64/include/asm/sysreg.h 
b/arch/arm64/include/asm/sysreg.h
index 24e773414cb4..c9534fba3afe 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -635,21 +635,6 @@
  /* Position the attr at the correct index */
  #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))

-/*
- * Memory types available.
- *
- * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 
'or' in
- *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
- *	      that protection_map[] only contains MT_NORMAL attributes.
- */
-#define MT_NORMAL		0
-#define MT_NORMAL_TAGGED	1
-#define MT_NORMAL_NC		2
-#define MT_NORMAL_WT		3
-#define MT_DEVICE_nGnRnE	4
-#define MT_DEVICE_nGnRE		5
-#define MT_DEVICE_GRE		6
-
  /*
   * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal 
memory and
   * changed during __cpu_setup to Normal Tagged if the system supports 
MTE.
@@ -1020,7 +1005,6 @@
  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
  #define SYS_MPIDR_SAFE_VAL	(BIT(31))

-#ifndef LINKER_SCRIPT
  #ifdef __ASSEMBLY__

  
	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
@@ -1138,6 +1122,5 @@
  })

  #endif
-#endif	/* LINKER_SCRIPT */

  #endif	/* __ASM_SYSREG_H */

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
