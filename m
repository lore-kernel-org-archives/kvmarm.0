Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6636C00A89
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:58:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D882E2083B
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D882E2083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 167A74B560;
	Fri, 30 Oct 2020 11:58:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fr4Lq-UmHFOo; Fri, 30 Oct 2020 11:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB42D4B52C;
	Fri, 30 Oct 2020 11:58:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04324B4E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:58:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 88oi48NfAZR6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 11:58:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 206B54B4AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:58:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E07E30E;
 Fri, 30 Oct 2020 08:58:40 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8D9C3F719;
 Fri, 30 Oct 2020 08:58:39 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 3/5] arm64: spe: Add introspection
 test
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-4-alexandru.elisei@arm.com>
 <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <66ff5a16-1771-9423-9205-5aabb4635c1b@arm.com>
Date: Fri, 30 Oct 2020 15:59:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
Content-Language: en-US
Cc: pbonzini@redhat.com
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

Hi Eric,

On 10/30/20 3:29 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>>
>> Probe the DTB and the ID registers to get information about SPE, then
>> compare the register fields with the valid values as defined by ARM DDI
>> 0487F.b.
>>
>> SPE is supported only on AArch64, so make the test exclusive to the
>> arm64 architecture.
>>
>> [ Alexandru E: Removed aarch32 compilation support, added DTB probing,
>> 	reworded commit, mostly cosmetic changes to the code ]all those changes make sense to me.
> + spe_buffer not allocated in spe_probe() anymore.

Sure, will add that.

>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/Makefile.arm64 |   1 +
>>  lib/libcflat.h     |   1 +
>>  arm/spe.c          | 172 +++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg  |   7 ++
>>  4 files changed, 181 insertions(+)
>>  create mode 100644 arm/spe.c
>>
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index dbc7524d3070..94b9c63f0b05 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -30,6 +30,7 @@ OBJDIRS += lib/arm64
>>  tests = $(TEST_DIR)/timer.flat
>>  tests += $(TEST_DIR)/micro-bench.flat
>>  tests += $(TEST_DIR)/cache.flat
>> +tests += $(TEST_DIR)/spe.flat
>>  
>>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>>  
>> diff --git a/lib/libcflat.h b/lib/libcflat.h
>> index ec0f58b05701..37550c99ffb6 100644
>> --- a/lib/libcflat.h
>> +++ b/lib/libcflat.h
>> @@ -37,6 +37,7 @@
>>  #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>>  
>>  #define SZ_256			(1 << 8)
>> +#define SZ_2K			(1 << 11)
>>  #define SZ_4K			(1 << 12)
>>  #define SZ_8K			(1 << 13)
>>  #define SZ_16K			(1 << 14)
>> diff --git a/arm/spe.c b/arm/spe.c
>> new file mode 100644
>> index 000000000000..c199cd239194
>> --- /dev/null
>> +++ b/arm/spe.c
>> @@ -0,0 +1,172 @@
>> +/*
>> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Lesser General Public License version 2.1 and
>> + * only version 2.1 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
>> + * for more details.
>> + */
>> +#include <stdint.h>
>> +
>> +#include <bitops.h>
>> +#include <devicetree.h>
>> +#include <libcflat.h>
>> +
>> +#include <asm/gic.h>
>> +#include <asm/processor.h>
>> +#include <asm/sysreg.h>
>> +
>> +#define ID_AA64DFR0_PMSVER_SHIFT	32
>> +#define ID_AA64DFR0_PMSVER_MASK		0xf
>> +
>> +#define SYS_PMBIDR_EL1			sys_reg(3, 0, 9, 10, 7)
>> +#define SYS_PMBIDR_EL1_F_SHIFT		5
>> +#define SYS_PMBIDR_EL1_P_SHIFT		4
>> +#define SYS_PMBIDR_EL1_ALIGN_MASK	0xfUL
>> +#define SYS_PMBIDR_EL1_ALIGN_SHIFT	0
>> +
>> +#define SYS_PMSIDR_EL1			sys_reg(3, 0, 9, 9, 7)
>> +#define SYS_PMSIDR_EL1_FE_SHIFT		0
>> +#define SYS_PMSIDR_EL1_FT_SHIFT		1
>> +#define SYS_PMSIDR_EL1_FL_SHIFT		2
>> +#define SYS_PMSIDR_EL1_INTERVAL_SHIFT	8
>> +#define SYS_PMSIDR_EL1_INTERVAL_MASK	0xfUL
>> +#define SYS_PMSIDR_EL1_MAXSIZE_SHIFT	12
>> +#define SYS_PMSIDR_EL1_MAXSIZE_MASK	0xfUL
>> +#define SYS_PMSIDR_EL1_MAXSIZE_MASK	0xfUL
>> +#define SYS_PMSIDR_EL1_COUNTSIZE_SHIFT	16
>> +#define SYS_PMSIDR_EL1_COUNTSIZE_MASK	0xfUL
>> +
>> +struct spe {
>> +	uint32_t intid;
>> +	int min_interval;
>> +	int max_record_size;
>> +	int countsize;
>> +	bool fl_cap;
>> +	bool ft_cap;
>> +	bool fe_cap;
>> +	int align;
>> +};
>> +static struct spe spe;
>> +
>> +static int spe_min_interval(uint8_t interval)
>> +{
>> +	switch (interval) {
>> +	case 0x0:
>> +		return 256;
>> +	case 0x2:
>> +		return 512;
>> +	case 0x3:
>> +		return 768;
>> +	case 0x4:
>> +		return 1024;
>> +	case 0x5:
>> +		return 1536;
>> +	case 0x6:
>> +		return 2048;
>> +	case 0x7:
>> +		return 3072;
>> +	case 0x8:
>> +		return 4096;
>> +	default:
>> +		return 0;
>> +	}
>> +}
>> +
>> +static bool spe_probe(void)
>> +{
>> +	const struct fdt_property *prop;
>> +	const void *fdt = dt_fdt();
>> +	int node, len;
>> +	uint32_t *data;
>> +	uint64_t pmbidr, pmsidr;
>> +	uint64_t aa64dfr0 = get_id_aa64dfr0();
>> +	uint8_t pmsver, interval;
>> +
>> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,statistical-profiling-extension-v1");
>> +	assert(node >= 0);
>> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
>> +	assert(prop && len == 3 * sizeof(u32));
>> +
>> +	data = (u32 *)prop->data;
>> +	/* SPE interrupt is required to be a PPI. */
>> +	assert(fdt32_to_cpu(data[0]) == 1);
>> +	spe.intid = fdt32_to_cpu(data[1]);
>> +
>> +	pmsver = (aa64dfr0 >> ID_AA64DFR0_PMSVER_SHIFT) & ID_AA64DFR0_PMSVER_MASK;
>> +	if (!pmsver || pmsver > 2) {
>> +		report_info("Unknown SPE version: 0x%x", pmsver);
>> +		return false;
>> +	}
>> +
>> +	pmbidr = read_sysreg_s(SYS_PMBIDR_EL1);
>> +	if (pmbidr & BIT(SYS_PMBIDR_EL1_P_SHIFT)) {
>> +		report_info("Profiling buffer owned by higher exception level");
>> +		return false;
>> +	}
>> +
>> +	spe.align = (pmbidr >> SYS_PMBIDR_EL1_ALIGN_SHIFT) & SYS_PMBIDR_EL1_ALIGN_MASK;
> you can remove ">> SYS_PMBIDR_EL1_ALIGN_SHIFT" here and
> SYS_PMBIDR_EL1_ALIGN_SHIFT (0)

I prefer to keep it to match the way we extract the values for the other fields,
even though I realize it's unnecessary (the compiler will optimize it anyway).

>> +	spe.align = 1 << spe.align;
>> +
>> +	pmsidr = read_sysreg_s(SYS_PMSIDR_EL1);
>> +
>> +	interval = (pmsidr >> SYS_PMSIDR_EL1_INTERVAL_SHIFT) & SYS_PMSIDR_EL1_INTERVAL_MASK;
>> +	spe.min_interval = spe_min_interval(interval);
>> +
>> +	spe.max_record_size = (pmsidr >> SYS_PMSIDR_EL1_MAXSIZE_SHIFT) & \
>> +		      SYS_PMSIDR_EL1_MAXSIZE_MASK;
>> +	spe.max_record_size = 1 << spe.max_record_size;
>> +
>> +	spe.countsize = (pmsidr >> SYS_PMSIDR_EL1_COUNTSIZE_SHIFT) & \
>> +			SYS_PMSIDR_EL1_COUNTSIZE_MASK;
>> +
>> +	spe.fl_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FL_SHIFT);
>> +	spe.ft_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FT_SHIFT);
>> +	spe.fe_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FE_SHIFT);
> Why did you remove the report_info() section? I think those human
> readable info can be useful.

I made them part of the test. Since the architecture says they are 1, I think
making sure their value matches is more useful than printing something that the
architecture guarantees.

>> +
>> +	return true;
>> +}
>> +
>> +static void spe_test_introspection(void)
>> +{
>> +	report_prefix_push("spe-introspection");
> I see you moved this here. gic and pmu tests seem to leave them in the
> main, as done originally.

You're right, consistency is good, will put them in main before calling the test
function.

>> +
>> +	report(spe.align <= SZ_2K, "PMBIDR_E1.Align");
> good check added
>> +	report(spe.countsize == 0x2, "PMSIDR_EL1.CountSize");
>> +	report(spe.max_record_size >= 16 && spe.max_record_size <= 2048,
>> +			"PMSIDR_EL1 maximum record size");
>> +	report(spe.min_interval >= 256 && spe.min_interval <= 4096,
>> +			"PMSIDR_EL1 minimum sampling interval");
>> +	report(spe.fl_cap && spe.ft_cap && spe.fe_cap, "PMSIDR_EL1 sampling filters");
> indeed all bits read as 1 as the spec says. which is bit weird by the way.

I think they added the fields because the architects wanted the flexibility to
allow changes in the future.

Thanks,
Alex
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	if (!spe_probe()) {
>> +		report_skip("SPE not supported");
>> +		return report_summary();
>> +	}
>> +
>> +	printf("intid:           %u\n", PPI(spe.intid));
>> +	printf("align: 	         %d\n", spe.align);
>> +	printf("min_interval:    %d\n", spe.min_interval);
>> +	printf("max_record_size: %d\n", spe.max_record_size);
>> +
>> +	if (argc < 2)
>> +		report_abort("no test specified");
>> +
>> +	report_prefix_push("spe");
>> +
>> +	if (strcmp(argv[1], "spe-introspection") == 0)
>> +		spe_test_introspection();
>> +	else
>> +		report_abort("Unknown subtest '%s'", argv[1]);
>> +
>> +	return report_summary();
>> +}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index f776b66ef96d..ad10be123774 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -134,6 +134,13 @@ extra_params = -append 'pmu-overflow-interrupt'
>>  #groups = pmu
>>  #accel = tcg
>>  
>> +[spe-introspection]
>> +file = spe.flat
>> +groups = spe
>> +arch = arm64
>> +accel = kvm
>> +extra_params = -append 'spe-introspection'
>> +
>>  # Test GIC emulation
>>  [gicv2-ipi]
>>  file = gic.flat
>>
> Thanks
>
> Eric
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
