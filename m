Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0537C3F68F
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 10:20:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75B3F217BA
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 10:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCwvKUSC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B3F217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C6E4A4F7;
	Fri,  7 Feb 2020 05:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tOmecBPDHc1P; Fri,  7 Feb 2020 05:20:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 403A14A52E;
	Fri,  7 Feb 2020 05:20:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9E9A4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 05:19:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9SFM9xPdJnHK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 05:19:57 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E544A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 05:19:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581070797;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QklhyZ3eOvqYI3xX8Ml/lPO2oC5taM5lDrzZXHLl4Uo=;
 b=WCwvKUSC9bCwhXn49feUuH6+BwcRYGc9J4nwliaPrl2Pzd3VygmQm8kfP9mtYrcjFsIwQk
 Ds0LRYHEDiJIgCSmoK5f4X3M0NUia3slvSUF4FR2Ucbh1ouf05CeFRl19lA6eGDQRShJee
 0LYF0vUGxuzDY6TawkzKahy9UOrtcFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-gQwGD1EoOeK60f-Hj3qNbA-1; Fri, 07 Feb 2020 05:19:53 -0500
X-MC-Unique: gQwGD1EoOeK60f-Hj3qNbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60DFB1800D42;
 Fri,  7 Feb 2020 10:19:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A724A19C7F;
 Fri,  7 Feb 2020 10:19:46 +0000 (UTC)
Date: Fri, 7 Feb 2020 11:19:43 +0100
From: Andrew Jones <drjones@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 05/14] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200207101943.fuakoieafbroe7rw@kamzik.brq.redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-6-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200128103459.19413-6-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On Tue, Jan 28, 2020 at 11:34:50AM +0100, Eric Auger wrote:
> Detect the presence of an ITS as part of the GICv3 init
> routine, initialize its base address and read few registers
> the IIDR, the TYPER to store its dimensioning parameters.
> Also parse the BASER registers.
> 
> This is our first ITS test, belonging to a new "its" group.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - updated dates and changed author
> - squash "arm/arm64: ITS: Test BASER" into this patch but
>   removes setup_baser which will be introduced later.
> - only compile on aarch64
> - restrict the new test to aarch64
> 
> v1 -> v2:
> - clean GITS_TYPER macros and unused fields in typer struct
> - remove memory attribute related macros
> - remove everything related to memory attributes
> - s/dev_baser/coll_baser/ in report_info
> - add extra line
> - removed index filed in its_baser
> ---
>  arm/Makefile.arm64         |   1 +
>  arm/gic.c                  |  49 ++++++++++++++++++
>  arm/unittests.cfg          |   7 +++
>  lib/arm/asm/gic-v3-its.h   | 103 +++++++++++++++++++++++++++++++++++++
>  lib/arm/gic-v3-its.c       |  88 +++++++++++++++++++++++++++++++
>  lib/arm/gic.c              |  30 +++++++++--
>  lib/arm64/asm/gic-v3-its.h |   1 +
>  7 files changed, 274 insertions(+), 5 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm/gic-v3-its.c
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6d3dc2c..2571ffb 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -19,6 +19,7 @@ endef
>  cstart.o = $(TEST_DIR)/cstart64.o
>  cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
> +cflatobjs += lib/arm/gic-v3-its.o

If gic-v3-its.c will never be compiled for arm, then it should
probably go lib/arm64, not lib/arm. Same comment for all other
new source and header files. The only problem with that is...

>  
>  OBJDIRS += lib/arm64
>  
> diff --git a/arm/gic.c b/arm/gic.c
> index abf08c7..4d7dd03 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -16,6 +16,7 @@
>  #include <asm/processor.h>
>  #include <asm/delay.h>
>  #include <asm/gic.h>
> +#include <asm/gic-v3-its.h>

...here where we'd have to do

 #if defined(__aarch64__)
 #include <asm/gic-v3-its.h>
 #endif

which is ugly. However that can be avoided by adding an
empty lib/arm/asm/gic-v3-its.h file.


>  #include <asm/smp.h>
>  #include <asm/barrier.h>
>  #include <asm/io.h>
> @@ -518,6 +519,50 @@ static void gic_test_mmio(void)
>  		test_targets(nr_irqs);
>  }
>  
> +#if defined(__arm__)
> +
> +static void test_its_introspection(void) {}

 static void test_its_introspection(void)
 {
     report_abort(...);
 }

> +
> +#else /* __arch64__ */
> +
> +static void test_its_introspection(void)
> +{
> +	struct its_baser *dev_baser, *coll_baser;
> +	struct its_typer *typer = &its_data.typer;
> +
> +	if (!gicv3_its_base()) {
> +		report_skip("No ITS, skip ...");
> +		return;
> +	}
> +
> +	/* IIDR */
> +	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
> +	       "GITS_IIDR is read-only"),
> +
> +	/* TYPER */
> +	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
> +	       "GITS_TYPER is read-only");
> +
> +	report(typer->phys_lpi, "ITS supports physical LPIs");
> +	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
> +	report_info("ITT entry size = 0x%x", typer->ite_size);
> +	report_info("Bit Count: EventID=%d DeviceId=%d CollId=%d",
> +		    typer->eventid_bits, typer->deviceid_bits,
> +		    typer->collid_bits);
> +	report(typer->eventid_bits && typer->deviceid_bits &&
> +	       typer->collid_bits, "ID spaces");
> +	report_info("Target address format %s",
> +			typer->pta ? "Redist basse address" : "PE #");
> +
> +	dev_baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
> +	coll_baser = its_lookup_baser(GITS_BASER_TYPE_COLLECTION);
> +	report(dev_baser && coll_baser, "detect device and collection BASER");
> +	report_info("device baser entry_size = 0x%x", dev_baser->esz);
> +	report_info("collection baser entry_size = 0x%x", coll_baser->esz);
> +}
> +
> +#endif
> +
>  int main(int argc, char **argv)
>  {
>  	if (!gic_init()) {
> @@ -549,6 +594,10 @@ int main(int argc, char **argv)
>  		report_prefix_push(argv[1]);
>  		gic_test_mmio();
>  		report_prefix_pop();
> +	} else if (strcmp(argv[1], "its-introspection") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_its_introspection();
> +		report_prefix_pop();
>  	} else {
>  		report_abort("Unknown subtest '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index daeb5a0..ba2b31b 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -122,6 +122,13 @@ smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'active'
>  groups = gic
>  
> +[its-introspection]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'its-introspection'
> +groups = its
> +arch = arm64
> +
>  # Test PSCI emulation
>  [psci]
>  file = psci.flat
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> new file mode 100644
> index 0000000..815c515
> --- /dev/null
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -0,0 +1,103 @@
> +/*
> + * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
> + *
> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#ifndef _ASMARM_GIC_V3_ITS_H_
> +#define _ASMARM_GIC_V3_ITS_H_
> +
> +#ifndef __ASSEMBLY__

Doesn't look like you use the #else /* __ASSEMBLY__ */ side of this.
I'd leave out the #ifndef until we add defines we need to access
from assembler.

> +
> +struct its_typer {
> +	unsigned int ite_size;
> +	unsigned int eventid_bits;
> +	unsigned int deviceid_bits;
> +	unsigned int collid_bits;
> +	bool pta;
> +	bool phys_lpi;
> +	bool virt_lpi;
> +};
> +
> +struct its_baser {
> +	int type;
> +	size_t psz;
> +	int nr_pages;
> +	bool indirect;
> +	phys_addr_t table_addr;
> +	bool valid;
> +	int esz;
> +};
> +
> +#define GITS_BASER_NR_REGS              8
> +
> +struct its_data {
> +	void *base;
> +	struct its_typer typer;
> +	struct its_baser baser[GITS_BASER_NR_REGS];
> +};
> +
> +extern struct its_data its_data;
> +
> +#define gicv3_its_base()		(its_data.base)
> +
> +#if defined(__aarch64__)
> +
> +#define GITS_CTLR			0x0000
> +#define GITS_IIDR			0x0004
> +#define GITS_TYPER			0x0008
> +#define GITS_CBASER			0x0080
> +#define GITS_CWRITER			0x0088
> +#define GITS_CREADR			0x0090
> +#define GITS_BASER			0x0100
> +
> +#define GITS_TYPER_PLPIS                BIT(0)
> +#define GITS_TYPER_VLPIS		BIT(1)
> +#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
> +#define GITS_TYPER_IDBITS		GENMASK_ULL(8, 12)
> +#define GITS_TYPER_IDBITS_SHIFT         8
> +#define GITS_TYPER_DEVBITS		GENMASK_ULL(13, 17)
> +#define GITS_TYPER_DEVBITS_SHIFT        13
> +#define GITS_TYPER_PTA                  BIT(19)
> +#define GITS_TYPER_CIDBITS		GENMASK_ULL(32, 35)
> +#define GITS_TYPER_CIDBITS_SHIFT	32
> +#define GITS_TYPER_CIL			BIT(36)
> +
> +#define GITS_CTLR_ENABLE		(1U << 0)
> +
> +#define GITS_CBASER_VALID		(1UL << 63)
> +
> +#define GITS_BASER_VALID		BIT(63)
> +#define GITS_BASER_INDIRECT		BIT(62)
> +#define GITS_BASER_TYPE_SHIFT		(56)
> +#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
> +#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
> +#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
> +#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
> +#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGES_MAX		256
> +#define GITS_BASER_PAGES_SHIFT		(0)
> +#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
> +#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
> +#define GITS_BASER_TYPE_NONE		0
> +#define GITS_BASER_TYPE_DEVICE		1
> +#define GITS_BASER_TYPE_COLLECTION	4
> +
> +extern void its_parse_typer(void);
> +extern void its_init(void);
> +extern int its_parse_baser(int i, struct its_baser *baser);
> +extern struct its_baser *its_lookup_baser(int type);
> +
> +#else /* __arm__ */
> +
> +static inline void its_init(void) {}

Looks like the empty gic-v3-its.h I suggested creating above will actually
be useful. We can add stubs like this in it.

> +
> +#endif
> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* _ASMARM_GIC_V3_ITS_H_ */
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> new file mode 100644
> index 0000000..2c0ce13
> --- /dev/null
> +++ b/lib/arm/gic-v3-its.c
> @@ -0,0 +1,88 @@
> +/*
> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <asm/gic.h>
> +#include <alloc_page.h>
> +#include <asm/gic-v3-its.h>
> +
> +void its_parse_typer(void)
> +{
> +	u64 typer = readq(gicv3_its_base() + GITS_TYPER);
> +
> +	its_data.typer.ite_size = ((typer & GITS_TYPER_ITT_ENTRY_SIZE) >>
> +					GITS_TYPER_ITT_ENTRY_SIZE_SHIFT) + 1;
> +	its_data.typer.pta = typer & GITS_TYPER_PTA;
> +	its_data.typer.eventid_bits = ((typer & GITS_TYPER_IDBITS) >>
> +						GITS_TYPER_IDBITS_SHIFT) + 1;
> +	its_data.typer.deviceid_bits = ((typer & GITS_TYPER_DEVBITS) >>
> +						GITS_TYPER_DEVBITS_SHIFT) + 1;
> +
> +	if (typer & GITS_TYPER_CIL)
> +		its_data.typer.collid_bits = ((typer & GITS_TYPER_CIDBITS) >>
> +						GITS_TYPER_CIDBITS_SHIFT) + 1;

nit: please consider aligning like this

 ((typer & MASK) >>
  SHIFT) + 1;

Or, maybe better to macro it

 #define TYPER_FIELD(typer, mask, shift) (((type) & (mask) >> (shift)) + 1)

And, rather than have a bunch of 'its_data.typer's we could use an alias,
helping us stay within 120 chars.

 struct its_typer *t = &its_data.typer;

 t->ite_size = TYPER_FIELD(typer, GITS_TYPER_ITT_ENTRY_SIZE,
                           GITS_TYPER_ITT_ENTRY_SIZE_SHIFT);


> +	else
> +		its_data.typer.collid_bits = 16;
> +
> +	its_data.typer.virt_lpi = typer & GITS_TYPER_VLPIS;
> +	its_data.typer.phys_lpi = typer & GITS_TYPER_PLPIS;
> +}
> +
> +int its_parse_baser(int i, struct its_baser *baser)
> +{
> +	void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
> +	u64 val = readq(reg_addr);
> +
> +	if (!val) {
> +		memset(baser, 0, sizeof(*baser));
> +		return -1;
> +	}
> +
> +	baser->valid = val & GITS_BASER_VALID;
> +	baser->indirect = val & GITS_BASER_INDIRECT;
> +	baser->type = GITS_BASER_TYPE(val);
> +	baser->esz = GITS_BASER_ENTRY_SIZE(val);
> +	baser->nr_pages = GITS_BASER_NR_PAGES(val);
> +	baser->table_addr = val & GITS_BASER_PHYS_ADDR_MASK;
> +	switch (val & GITS_BASER_PAGE_SIZE_MASK) {
> +	case GITS_BASER_PAGE_SIZE_4K:
> +		baser->psz = SZ_4K;
> +		break;
> +	case GITS_BASER_PAGE_SIZE_16K:
> +		baser->psz = SZ_16K;
> +		break;
> +	case GITS_BASER_PAGE_SIZE_64K:
> +		baser->psz = SZ_64K;
> +		break;
> +	default:
> +		baser->psz = SZ_64K;
> +	}
> +	return 0;
> +}
> +
> +struct its_baser *its_lookup_baser(int type)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +		struct its_baser *baser = &its_data.baser[i];
> +
> +		if (baser->type == type)
> +			return baser;
> +	}
> +	return NULL;
> +}
> +
> +void its_init(void)
> +{
> +	int i;
> +
> +	if (!its_data.base)
> +		return;
> +
> +	its_parse_typer();
> +	for (i = 0; i < GITS_BASER_NR_REGS; i++)
> +		its_parse_baser(i, &its_data.baser[i]);
> +}
> +
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index aa9cb86..6b70b05 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -6,9 +6,11 @@
>  #include <devicetree.h>
>  #include <asm/gic.h>
>  #include <asm/io.h>
> +#include <asm/gic-v3-its.h>
>  
>  struct gicv2_data gicv2_data;
>  struct gicv3_data gicv3_data;
> +struct its_data its_data;
>  
>  struct gic_common_ops {
>  	void (*enable_defaults)(void);
> @@ -44,12 +46,13 @@ static const struct gic_common_ops gicv3_common_ops = {
>   * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
>   */
>  static bool
> -gic_get_dt_bases(const char *compatible, void **base1, void **base2)
> +gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base3)
>  {
>  	struct dt_pbus_reg reg;
> -	struct dt_device gic;
> +	struct dt_device gic, its;
>  	struct dt_bus bus;
> -	int node, ret, i;
> +	int node, subnode, ret, i, len;
> +	const void *fdt = dt_fdt();
>  
>  	dt_bus_init_defaults(&bus);
>  	dt_device_init(&gic, &bus, NULL);
> @@ -74,19 +77,35 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>  		base2[i] = ioremap(reg.addr, reg.size);
>  	}
>  
> +	if (base3 && !strcmp(compatible, "arm,gic-v3")) {

If base != NULL, then we could assert(strcmp(compatible, "arm,cortex-a15-gic") != 0)

> +		dt_for_each_subnode(node, subnode) {
> +			const struct fdt_property *prop;
> +
> +			prop = fdt_get_property(fdt, subnode, "compatible", &len);
> +			if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
> +				dt_device_bind_node(&its, subnode);
> +				ret = dt_pbus_translate(&its, 0, &reg);
> +				assert(ret == 0);
> +				*base3 = ioremap(reg.addr, reg.size);
> +				break;
> +			}
> +		}
> +
> +	}
> +
>  	return true;
>  }
>  
>  int gicv2_init(void)
>  {
>  	return gic_get_dt_bases("arm,cortex-a15-gic",
> -			&gicv2_data.dist_base, &gicv2_data.cpu_base);
> +			&gicv2_data.dist_base, &gicv2_data.cpu_base, NULL);
>  }
>  
>  int gicv3_init(void)
>  {
>  	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
> -			&gicv3_data.redist_bases[0]);
> +			&gicv3_data.redist_bases[0], &its_data.base);
>  }
>  
>  int gic_version(void)
> @@ -104,6 +123,7 @@ int gic_init(void)
>  		gic_common_ops = &gicv2_common_ops;
>  	else if (gicv3_init())
>  		gic_common_ops = &gicv3_common_ops;
> +	its_init();
>  	return gic_version();
>  }
>  
> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> new file mode 100644
> index 0000000..083cba4
> --- /dev/null
> +++ b/lib/arm64/asm/gic-v3-its.h
> @@ -0,0 +1 @@
> +#include "../../arm/asm/gic-v3-its.h"
> -- 
> 2.20.1
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
