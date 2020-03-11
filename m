Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0DDC10F29
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 06:42:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A97732192A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 06:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A97732192A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 119244A4C0;
	Wed, 11 Mar 2020 02:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uMjTHHyuc5VY; Wed, 11 Mar 2020 02:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0DF4A4BE;
	Wed, 11 Mar 2020 02:42:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 137BE4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 02:42:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rWtKJrMMqgiP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 02:42:53 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43E834A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 02:42:53 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id EC7167B4F0923BCCC96B;
 Wed, 11 Mar 2020 14:42:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 14:42:39 +0800
Subject: Re: [kvm-unit-tests PATCH v5 05/13] arm/arm64: gicv3: Set the LPI
 config and pending tables
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-6-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
Date: Wed, 11 Mar 2020 14:42:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-6-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, thuth@redhat.com
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

Hi Eric,

On 2020/3/10 22:54, Eric Auger wrote:
> Allocate the LPI configuration and per re-distributor pending table.
> Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
> by default in the config table.
> 
> Also introduce a helper routine that allows to set the pending table
> bit for a given LPI.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - Moved some reformattings previously done in
>    "arm/arm64: ITS: its_enable_defaults", in this patch
> - added assert(!gicv3_redist_base()) in gicv3_lpi_alloc_tables()
> - revert for_each_present_cpu() change
> 
> v2 -> v3:
> - Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
>    and add _lpi prefix too
> 
> v1 -> v2:
> - remove memory attributes
> ---
>   lib/arm/asm/gic-v3.h | 15 +++++++++++++
>   lib/arm/gic-v3.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 68 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 47df051..064cc68 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -50,6 +50,15 @@
>   #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
>   	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
>   
> +#define GICR_PROPBASER_IDBITS_MASK	(0x1f)

Again this can be dropped, but not a problem.

> +
> +#define GICR_PENDBASER_PTZ		BIT_ULL(62)
> +
> +#define LPI_PROP_GROUP1			(1 << 1)
> +#define LPI_PROP_ENABLED		(1 << 0)
> +#define LPI_PROP_DEFAULT_PRIO		0xa0
> +#define LPI_PROP_DEFAULT		(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
> +
>   #include <asm/arch_gicv3.h>
>   
>   #ifndef __ASSEMBLY__
> @@ -66,6 +75,8 @@ struct gicv3_data {
>   	void *dist_base;
>   	void *redist_bases[GICV3_NR_REDISTS];
>   	void *redist_base[NR_CPUS];
> +	u8 *lpi_prop;
> +	void *lpi_pend[NR_CPUS];
>   	unsigned int irq_nr;
>   };
>   extern struct gicv3_data gicv3_data;
> @@ -82,6 +93,10 @@ extern void gicv3_write_eoir(u32 irqstat);
>   extern void gicv3_ipi_send_single(int irq, int cpu);
>   extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
>   extern void gicv3_set_redist_base(size_t stride);
> +extern void gicv3_lpi_set_config(int n, u8 val);
> +extern u8 gicv3_lpi_get_config(int n);

These two declarations can be dropped, and I think it's better to
move their macro implementations here (they're now in patch #7).
But also not a problem.

> +extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
> +extern void gicv3_lpi_alloc_tables(void);
>   
>   static inline void gicv3_do_wait_for_rwp(void *base)
>   {
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index feecb5e..d752bd4 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -5,6 +5,7 @@
>    */
>   #include <asm/gic.h>
>   #include <asm/io.h>
> +#include <alloc_page.h>
>   
>   void gicv3_set_redist_base(size_t stride)
>   {
> @@ -147,3 +148,55 @@ void gicv3_ipi_send_single(int irq, int cpu)
>   	cpumask_set_cpu(cpu, &dest);
>   	gicv3_ipi_send_mask(irq, &dest);
>   }
> +
> +#if defined(__aarch64__)
> +
> +/*
> + * alloc_lpi_tables - Allocate LPI config and pending tables
> + * and set PROPBASER (shared by all rdistributors) and per
> + * redistributor PENDBASER.
> + *
> + * gicv3_set_redist_base() must be called before
> + */
> +void gicv3_lpi_alloc_tables(void)
> +{
> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
> +	unsigned long order = fls(n);
> +	u64 prop_val;
> +	int cpu;
> +
> +	assert(!gicv3_redist_base());

I guess you wanted assert(gicv3_redist_base())? With this confirmed,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> +
> +	gicv3_data.lpi_prop = alloc_pages(order);
> +
> +	/* ID bits = 13, ie. up to 14b LPI INTID */
> +	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
> +
> +	for_each_present_cpu(cpu) {
> +		u64 pend_val;
> +		void *ptr;
> +
> +		ptr = gicv3_data.redist_base[cpu];
> +
> +		writeq(prop_val, ptr + GICR_PROPBASER);
> +
> +		gicv3_data.lpi_pend[cpu] = alloc_pages(order);
> +		pend_val = (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
> +		writeq(pend_val, ptr + GICR_PENDBASER);
> +	}
> +}
> +
> +void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
> +{
> +	u8 *ptr = gicv3_data.lpi_pend[rdist];
> +	u8 mask = 1 << (n % 8), byte;
> +
> +	ptr += (n / 8);
> +	byte = *ptr;
> +	if (set)
> +		byte |=  mask;
> +	else
> +		byte &= ~mask;
> +	*ptr = byte;
> +}
> +#endif /* __aarch64__ */
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
