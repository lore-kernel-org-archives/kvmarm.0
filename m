Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B84C43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:55:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 004C720716
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 10:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 004C720716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E5564B22F;
	Mon, 30 Mar 2020 06:55:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yjgHH1alCGgP; Mon, 30 Mar 2020 06:55:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D46D4B1E3;
	Mon, 30 Mar 2020 06:55:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C27A44B1D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:55:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5A0PvGlDo1aA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 06:55:49 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A26B54B1B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 06:55:49 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 7C91EB38A8366729AFBE;
 Mon, 30 Mar 2020 18:55:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 18:55:37 +0800
Subject: Re: [kvm-unit-tests PATCH v7 12/13] arm/arm64: ITS: migration tests
To: Eric Auger <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-13-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4ae2e841-2558-133a-1d19-693dc6f34f60@huawei.com>
Date: Mon, 30 Mar 2020 18:55:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320092428.20880-13-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2020/3/20 17:24, Eric Auger wrote:
> This test maps LPIs (populates the device table, the collection table,
> interrupt translation tables, configuration table), migrates and make
> sure the translation is correct on the destination.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v4 -> v5:
> - move stub from header to arm/gic.c
> 
> v3 -> v4:
> - assert in its_get_device/collection if the id is not found
> ---
>   arm/gic.c                  | 58 ++++++++++++++++++++++++++++++++++----
>   arm/unittests.cfg          |  8 ++++++
>   lib/arm64/asm/gic-v3-its.h |  3 ++
>   lib/arm64/gic-v3-its.c     | 22 +++++++++++++++
>   4 files changed, 85 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 5f1e595..6ecfdbc 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -590,6 +590,7 @@ static void gic_test_mmio(void)
>   
>   static void test_its_introspection(void) {}
>   static void test_its_trigger(void) {}
> +static void test_its_migration(void) {}
>   
>   #else /* __aarch64__ */
>   
> @@ -658,13 +659,19 @@ static int its_prerequisites(int nb_cpus)
>   	return 0;
>   }
>   
> -static void test_its_trigger(void)
> +/*
> + * Setup the configuration for those mappings:
> + * dev_id=2 event=20 -> vcpu 3, intid=8195
> + * dev_id=7 event=255 -> vcpu 2, intid=8196
> + * LPIs ready to hit
> + */
> +static int its_setup1(void)
>   {
>   	struct its_collection *col3, *col2;
>   	struct its_device *dev2, *dev7;
>   
>   	if (its_prerequisites(4))
> -		return;
> +		return -1;
>   
>   	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>   	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
> @@ -675,14 +682,10 @@ static void test_its_trigger(void)
>   	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>   	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
>   
> -	report_prefix_push("int");
>   	/*
>   	 * dev=2, eventid=20  -> lpi= 8195, col=3
>   	 * dev=7, eventid=255 -> lpi= 8196, col=2
> -	 * Trigger dev2, eventid=20 and dev7, eventid=255
> -	 * Check both LPIs hit
>   	 */
> -
>   	its_send_mapd(dev2, true);
>   	its_send_mapd(dev7, true);
>   
> @@ -694,6 +697,22 @@ static void test_its_trigger(void)
>   
>   	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
>   	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
> +	return 0;
> +}
> +
> +static void test_its_trigger(void)
> +{
> +	struct its_collection *col3;
> +	struct its_device *dev2, *dev7;
> +
> +	if (its_setup1())
> +		return;
> +
> +	col3 = its_get_collection(3);
> +	dev2 = its_get_device(2);
> +	dev7 = its_get_device(7);
> +
> +	report_prefix_push("int");
>   
>   	lpi_stats_expect(3, 8195);
>   	its_send_int(dev2, 20);
> @@ -748,6 +767,29 @@ static void test_its_trigger(void)
>   	check_lpi_stats("no LPI after device unmap");
>   	report_prefix_pop();
>   }
> +
> +static void test_its_migration(void)
> +{
> +	struct its_device *dev2, *dev7;
> +
> +	if (its_setup1())
> +		return;
> +
> +	dev2 = its_get_device(2);
> +	dev7 = its_get_device(7);
> +
> +	puts("Now migrate the VM, then press a key to continue...\n");
> +	(void)getchar();
> +	report_info("Migration complete");
> +
> +	lpi_stats_expect(3, 8195);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 en PE #3 after migration");

typo: s/en PE #3/on PE #3/

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> +
> +	lpi_stats_expect(2, 8196);
> +	its_send_int(dev7, 255);
> +	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
> +}
>   #endif
>   
>   int main(int argc, char **argv)
> @@ -785,6 +827,10 @@ int main(int argc, char **argv)
>   		report_prefix_push(argv[1]);
>   		test_its_trigger();
>   		report_prefix_pop();
> +	} else if (!strcmp(argv[1], "its-migration")) {
> +		report_prefix_push(argv[1]);
> +		test_its_migration();
> +		report_prefix_pop();
>   	} else if (strcmp(argv[1], "its-introspection") == 0) {
>   		report_prefix_push(argv[1]);
>   		test_its_introspection();
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index b9a7a2c..480adec 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -136,6 +136,14 @@ extra_params = -machine gic-version=3 -append 'its-trigger'
>   groups = its
>   arch = arm64
>   
> +[its-migration]
> +file = gic.flat
> +smp = $MAX_SMP
> +accel = kvm
> +extra_params = -machine gic-version=3 -append 'its-migration'
> +groups = its migration
> +arch = arm64
> +
>   # Test PSCI emulation
>   [psci]
>   file = psci.flat
> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> index e1e42c3..412f438 100644
> --- a/lib/arm64/asm/gic-v3-its.h
> +++ b/lib/arm64/asm/gic-v3-its.h
> @@ -168,4 +168,7 @@ extern void __its_send_sync(struct its_collection *col, bool verbose);
>   #define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, false)
>   #define its_send_sync_nv(col)				__its_send_sync(col, false)
>   
> +extern struct its_device *its_get_device(u32 id);
> +extern struct its_collection *its_get_collection(u32 id);
> +
>   #endif /* _ASMARM64_GIC_V3_ITS_H_ */
> diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
> index f0a0381..c7755d9 100644
> --- a/lib/arm64/gic-v3-its.c
> +++ b/lib/arm64/gic-v3-its.c
> @@ -147,3 +147,25 @@ struct its_collection *its_create_collection(u32 col_id, u32 pe)
>   	its_data.nr_collections++;
>   	return new;
>   }
> +
> +struct its_device *its_get_device(u32 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_MAX_DEVICES; i++) {
> +		if (its_data.devices[i].device_id == id)
> +			return &its_data.devices[i];
> +	}
> +	assert(0);
> +}
> +
> +struct its_collection *its_get_collection(u32 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_MAX_COLLECTIONS; i++) {
> +		if (its_data.collections[i].col_id == id)
> +			return &its_data.collections[i];
> +	}
> +	assert(0);
> +}
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
