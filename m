Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2804C43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:25:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3087224679
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3087224679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A417C4AC07;
	Fri, 20 Dec 2019 02:25:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J-a-9+K2rD5v; Fri, 20 Dec 2019 02:25:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D2B4A830;
	Fri, 20 Dec 2019 02:25:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E57244A7FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:25:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2rGhxNPYixRD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 02:25:45 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F4E24A50F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:25:45 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CC1CB548BD8CEBBBEDAE;
 Fri, 20 Dec 2019 15:25:41 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Dec 2019
 15:25:33 +0800
Subject: Re: [kvm-unit-tests PATCH 11/16] arm/arm64: ITS: Device and
 collection Initialization
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-12-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1f170d74-0ee5-6415-d84e-cd7de4d0f071@huawei.com>
Date: Fri, 20 Dec 2019 15:25:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191216140235.10751-12-eric.auger@redhat.com>
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

On 2019/12/16 22:02, Eric Auger wrote:
> Introduce an helper functions to register
> - a new device, characterized by its device id and the
>    max number of event IDs that dimension its ITT (Interrupt
>    Translation Table).  The function allocates the ITT.
> 
> - a new collection, characterized by its ID and the
>    target processing engine (PE).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> ---
>   lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++
>   lib/arm/gic-v3-its.c     | 46 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 66 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index ab639c5..245ef61 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -87,6 +87,9 @@
>   
>   #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
>   
> +#define GITS_MAX_DEVICES		8
> +#define GITS_MAX_COLLECTIONS		8
> +
>   struct its_typer {
>   	unsigned int ite_size;
>   	unsigned int eventid_bits;
> @@ -117,6 +120,17 @@ struct its_cmd_block {
>   	u64     raw_cmd[4];
>   };
>   
> +struct its_device {
> +	u32 device_id;	/* device ID */
> +	u32 nr_ites;	/* Max Interrupt Translation Entries */
> +	void *itt;	/* Interrupt Translation Table GPA */
> +};
> +
> +struct its_collection {
> +	u64 target_address;
> +	u16 col_id;
> +};
> +
>   struct its_data {
>   	void *base;
>   	struct its_typer typer;
> @@ -124,6 +138,10 @@ struct its_data {
>   	struct its_cmd_block *cmd_base;
>   	struct its_cmd_block *cmd_write;
>   	struct its_cmd_block *cmd_readr;
> +	struct its_device devices[GITS_MAX_DEVICES];
> +	u32 nb_devices;		/* Allocated Devices */
> +	struct its_collection collections[GITS_MAX_COLLECTIONS];
> +	u32 nb_collections;	/* Allocated Collections */

('nr_*' may be the more widely used one.)

>   };
>   
>   extern struct its_data its_data;
> @@ -140,6 +158,8 @@ extern u8 get_lpi_config(int n);
>   extern void set_pending_table_bit(int rdist, int n, bool set);
>   extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
>   extern void its_enable_defaults(void);
> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
> +extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
>   
>   #endif /* !__ASSEMBLY__ */
>   #endif /* _ASMARM_GIC_V3_ITS_H_ */
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index 9a51ef4..9906428 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -284,3 +284,49 @@ void its_enable_defaults(void)
>   
>   	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
>   }
> +
> +struct its_device *its_create_device(u32 device_id, int nr_ites)
> +{
> +	struct its_baser *baser;
> +	struct its_device *new;
> +	unsigned long n, order;
> +
> +	if (its_data.nb_devices >= GITS_MAX_DEVICES)
> +		report_abort("%s redimension GITS_MAX_DEVICES", __func__);
> +
> +	baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
> +	if (!baser)
> +		return NULL;
> +
> +	new = &its_data.devices[its_data.nb_devices];
> +
> +	new->device_id = device_id;
> +	new->nr_ites = nr_ites;
> +
> +	n = (baser->esz * nr_ites) >> PAGE_SHIFT;

baser->esz is GITS_BASER.Entry_Size, which indicates the size of
Device Table entry.
We're allocating ITT for this device now, shouldn't we use
its_data.typer.esz?


Thanks,
Zenghui

> +	order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
> +	new->itt = (void *)virt_to_phys(alloc_pages(order));
> +
> +	its_data.nb_devices++;
> +	return new;
> +}
> +
> +struct its_collection *its_create_collection(u32 col_id, u32 pe)
> +{
> +	struct its_collection *new;
> +
> +	if (its_data.nb_collections >= GITS_MAX_COLLECTIONS)
> +		report_abort("%s redimension GITS_MAX_COLLECTIONS", __func__);
> +
> +	new = &its_data.collections[its_data.nb_collections];
> +
> +	new->col_id = col_id;
> +
> +	if (its_data.typer.pta)
> +		new->target_address = (u64)gicv3_data.redist_base[pe];
> +	else
> +		new->target_address = pe << 16;
> +
> +	its_data.nb_collections++;
> +	return new;
> +}
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
