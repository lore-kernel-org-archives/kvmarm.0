Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798CBC10F27
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 14:50:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD0DD206BE
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 14:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMA0dl2R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD0DD206BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F69F4A4E1;
	Wed, 11 Mar 2020 10:50:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kPgoCKgfiWZn; Wed, 11 Mar 2020 10:50:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4266B4A49C;
	Wed, 11 Mar 2020 10:50:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3528E4A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 10:50:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w7pc0rBc1rXm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 10:50:29 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DF234A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 10:50:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583938228;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jsKkDSgyQz2pLGCyrcLc9VQw/vTQBxdYWH0tEharUX4=;
 b=KMA0dl2RUcu71p74VSTLGIKHCzx+Shl8OgC8o61o14sjtFsDUye9LDwHREIHac72+BKgHN
 DIftFelWD73i9bwLJsq5WjR/F0p8p+AfFTqjnbzB/4MkGvg3YIVe81uXhlQmmzBITWaDMi
 ZONuhOYgZ/gob6oN26V1Ca9PBZ2BpRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-5QHxOei5MXatAU_1bhWitw-1; Wed, 11 Mar 2020 10:50:24 -0400
X-MC-Unique: 5QHxOei5MXatAU_1bhWitw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36D458017DF;
 Wed, 11 Mar 2020 14:50:23 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B24C10013A1;
 Wed, 11 Mar 2020 14:50:18 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v6 06/13] arm/arm64: ITS: Introspection
 tests
To: Andrew Jones <drjones@redhat.com>
References: <20200311135117.9366-1-eric.auger@redhat.com>
 <20200311135117.9366-7-eric.auger@redhat.com>
 <20200311143331.yesdkxuobng3qzuu@kamzik.brq.redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <94f73aef-9898-d551-f440-5dff2c3d2a63@redhat.com>
Date: Wed, 11 Mar 2020 15:50:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200311143331.yesdkxuobng3qzuu@kamzik.brq.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Hi Drew,

On 3/11/20 3:33 PM, Andrew Jones wrote:
> On Wed, Mar 11, 2020 at 02:51:10PM +0100, Eric Auger wrote:
>> Detect the presence of an ITS as part of the GICv3 init
>> routine, initialize its base address and read few registers
>> the IIDR, the TYPER to store its dimensioning parameters.
>> Parse the BASER registers. As part of the init sequence we
>> also init all the requested tables.
>>
>> This is our first ITS test, belonging to a new "its" group.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v5 -> v6:
>> - fix some GENMASK_ULL and tabs
>>
>> v4 -> v5:
>> - Moved test_its_introspection() stub from
>>   lib/arm/asm/gic-v3-its.h back to arm/gic.c
>> - 32b its_init does report_abort()
>> - remove kerneldoc style comment
>> - remove alloc_lpi_tables from its_init()
>>
>> v3 -> v4:
>> - fixed some typos, refine trace msgs
>> - move its files to lib/arm64 instead of lib/arm
>> - create lib/arm/asm/gic-v3-its.h containing stubs
>> - rework gic_get_dt_bases
>> - rework baser parsing
>> - move table allocation to init routine
>> - use get_order()
>>
>> v2 -> v3:
>> - updated dates and changed author
>> - squash "arm/arm64: ITS: Test BASER" into this patch but
>>   removes setup_baser which will be introduced later.
>> - only compile on aarch64
>> - restrict the new test to aarch64
>>
>> v1 -> v2:
>> - clean GITS_TYPER macros and unused fields in typer struct
>> - remove memory attribute related macros
>> - remove everything related to memory attributes
>> - s/dev_baser/coll_baser/ in report_info
>> - add extra line
>> - removed index filed in its_baser
>> ---
>>  arm/Makefile.arm64         |  1 +
>>  arm/gic.c                  | 48 ++++++++++++++++++
>>  arm/unittests.cfg          |  7 +++
>>  lib/arm/asm/gic-v3-its.h   | 22 +++++++++
>>  lib/arm/gic.c              | 34 +++++++++++--
>>  lib/arm64/asm/gic-v3-its.h | 92 +++++++++++++++++++++++++++++++++++
>>  lib/arm64/gic-v3-its.c     | 99 ++++++++++++++++++++++++++++++++++++++
>>  7 files changed, 298 insertions(+), 5 deletions(-)
>>  create mode 100644 lib/arm/asm/gic-v3-its.h
>>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>>  create mode 100644 lib/arm64/gic-v3-its.c
>>
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index 6d3dc2c..60182ae 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -19,6 +19,7 @@ endef
>>  cstart.o = $(TEST_DIR)/cstart64.o
>>  cflatobjs += lib/arm64/processor.o
>>  cflatobjs += lib/arm64/spinlock.o
>> +cflatobjs += lib/arm64/gic-v3-its.o
>>  
>>  OBJDIRS += lib/arm64
>>  
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 2f904b0..649ed81 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -16,6 +16,7 @@
>>  #include <asm/processor.h>
>>  #include <asm/delay.h>
>>  #include <asm/gic.h>
>> +#include <asm/gic-v3-its.h>
>>  #include <asm/smp.h>
>>  #include <asm/barrier.h>
>>  #include <asm/io.h>
>> @@ -517,6 +518,49 @@ static void gic_test_mmio(void)
>>  		test_targets(nr_irqs);
>>  }
>>  
>> +#if defined(__arm__)
>> +
>> +static void test_its_introspection(void) {}
>> +
>> +#else /* __aarch64__ */
>> +
>> +static void test_its_introspection(void)
>> +{
>> +	struct its_baser *dev_baser = &its_data.device_baser;
>> +	struct its_baser *coll_baser = &its_data.coll_baser;
>> +	struct its_typer *typer = &its_data.typer;
>> +
>> +	if (!gicv3_its_base()) {
>> +		report_skip("No ITS, skip ...");
>> +		return;
>> +	}
>> +
>> +	/* IIDR */
>> +	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
>> +	       "GITS_IIDR is read-only"),
>> +
>> +	/* TYPER */
>> +	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
>> +	       "GITS_TYPER is read-only");
>> +
>> +	report(typer->phys_lpi, "ITS supports physical LPIs");
>> +	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
>> +	report_info("ITT entry size = 0x%x", typer->ite_size);
>> +	report_info("Bit Count: EventID=%d DeviceId=%d CollId=%d",
>> +		    typer->eventid_bits, typer->deviceid_bits,
>> +		    typer->collid_bits);
>> +	report(typer->eventid_bits && typer->deviceid_bits &&
>> +	       typer->collid_bits, "ID spaces");
>> +	report_info("Target address format %s",
>> +			typer->pta ? "Redist base address" : "PE #");
>> +
>> +	report(dev_baser && coll_baser, "detect device and collection BASER");
>> +	report_info("device table entry_size = 0x%x", dev_baser->esz);
>> +	report_info("collection table entry_size = 0x%x", coll_baser->esz);
>> +}
>> +
>> +#endif
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	if (!gic_init()) {
>> @@ -548,6 +592,10 @@ int main(int argc, char **argv)
>>  		report_prefix_push(argv[1]);
>>  		gic_test_mmio();
>>  		report_prefix_pop();
>> +	} else if (strcmp(argv[1], "its-introspection") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_introspection();
>> +		report_prefix_pop();
>>  	} else {
>>  		report_abort("Unknown subtest '%s'", argv[1]);
>>  	}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 017958d..23d378e 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -122,6 +122,13 @@ smp = $MAX_SMP
>>  extra_params = -machine gic-version=3 -append 'active'
>>  groups = gic
>>  
>> +[its-introspection]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +extra_params = -machine gic-version=3 -append 'its-introspection'
>> +groups = its
>> +arch = arm64
>> +
>>  # Test PSCI emulation
>>  [psci]
>>  file = psci.flat
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> new file mode 100644
>> index 0000000..2167099
>> --- /dev/null
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -0,0 +1,22 @@
>> +/*
>> + * ITS 32-bit stubs
>> + *
>> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This work is licensed under the terms of the GNU LGPL, version 2.
>> + */
>> +
>> +#ifndef _ASMARM_GIC_V3_ITS_H_
>> +#define _ASMARM_GIC_V3_ITS_H_
>> +
>> +/* dummy its_data struct to allow gic_get_dt_bases() call */
>> +struct its_data {
>> +	void *base;
>> +};
>> +
>> +static inline void its_init(void)
>> +{
>> +	report_abort("not supported on 32-bit");
> 
> This is supposed to be an assert_msg() (no report_* functions in lib
> code), but it should never fire anyway, because the test code should
> just not call its_init() on 32-bit arm. I.e. the assert is there not
> to report to test runners what's going on, but to stop developers
> from calling it when they shouldn't.
> 
> I can fix stuff like this up myself on merge to arm/queue though.
OK. Let's see if someone has other comments. In the positive I will respin.

Thanks

Eric
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
