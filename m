Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC53C3F2D2
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 17:59:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 199CC2072D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 17:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyX8P0Q4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 199CC2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CF94AEC5;
	Thu,  5 Mar 2020 12:59:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y2t-1OO4+XEt; Thu,  5 Mar 2020 12:59:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE724ACB7;
	Thu,  5 Mar 2020 12:59:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F6C4A959
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 12:59:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2m-RRElp+HaX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 12:59:32 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9D24A536
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 12:59:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583431171;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AjX8gnoueqBbmMKw0egA5SqCiGTGwQ5xjmXeuE6ZQV0=;
 b=dyX8P0Q4CY+GUkwKNHyBNmGKvDVpg7ICo2rEI87mJ17rcE/y0ul/mRoxSA7vELZWnykMRw
 bPYjfw0zyW1/42y7bfi08Y67fnzLLlTgcTrIFZYBoJkmDWJb1uvP5Q6dCVTmhpE6PdHQN7
 zX8x/nO68pjOwEtqVoyFCNrGt1RgcBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-LXPsODH5MC-yBzgezpdthA-1; Thu, 05 Mar 2020 12:59:22 -0500
X-MC-Unique: LXPsODH5MC-yBzgezpdthA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CD1E8017CC;
 Thu,  5 Mar 2020 17:59:20 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DCBE78D57C;
 Thu,  5 Mar 2020 17:59:16 +0000 (UTC)
From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 08/14] arm/arm64: ITS:
 its_enable_defaults
To: Andrew Jones <drjones@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-9-eric.auger@redhat.com>
 <20200207124108.wtgghuwoka42oj4i@kamzik.brq.redhat.com>
Message-ID: <242511fe-34e4-c9b9-631a-b360f58a3fa2@redhat.com>
Date: Thu, 5 Mar 2020 18:59:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200207124108.wtgghuwoka42oj4i@kamzik.brq.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On 2/7/20 1:41 PM, Andrew Jones wrote:
> On Tue, Jan 28, 2020 at 11:34:53AM +0100, Eric Auger wrote:
>> its_enable_defaults() is the top init function that allocates the
>> command queue and all the requested tables (device, collection,
>> lpi config and pending tables), enable LPIs at distributor level
>> and ITS level.
>>
>> gicv3_enable_defaults must be called before.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - introduce its_setup_baser in this patch
>> - squash "arm/arm64: ITS: Init the command queue" in this patch.
>> ---
>>  lib/arm/asm/gic-v3-its.h |  8 ++++
>>  lib/arm/gic-v3-its.c     | 89 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 97 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index 815c515..fe73c04 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -36,6 +36,8 @@ struct its_data {
>>  	void *base;
>>  	struct its_typer typer;
>>  	struct its_baser baser[GITS_BASER_NR_REGS];
>> +	struct its_cmd_block *cmd_base;
>> +	struct its_cmd_block *cmd_write;
>>  };
>>  
>>  extern struct its_data its_data;
>> @@ -88,10 +90,16 @@ extern struct its_data its_data;
>>  #define GITS_BASER_TYPE_DEVICE		1
>>  #define GITS_BASER_TYPE_COLLECTION	4
>>  
>> +
>> +struct its_cmd_block {
>> +	u64 raw_cmd[4];
>> +};
>> +
>>  extern void its_parse_typer(void);
>>  extern void its_init(void);
>>  extern int its_parse_baser(int i, struct its_baser *baser);
>>  extern struct its_baser *its_lookup_baser(int type);
>> +extern void its_enable_defaults(void);
>>  
>>  #else /* __arm__ */
>>  
>> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index 2c0ce13..d1e7e52 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -86,3 +86,92 @@ void its_init(void)
>>  		its_parse_baser(i, &its_data.baser[i]);
>>  }
>>  
>> +static void its_setup_baser(int i, struct its_baser *baser)
>> +{
>> +	unsigned long n = (baser->nr_pages * baser->psz) >> PAGE_SHIFT;
>> +	unsigned long order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
>> +	u64 val;
>> +
>> +	baser->table_addr = (u64)virt_to_phys(alloc_pages(order));
>> +
>> +	val = ((u64)baser->table_addr					|
>> +		((u64)baser->type	<< GITS_BASER_TYPE_SHIFT)	|
>> +		((u64)(baser->esz - 1)	<< GITS_BASER_ENTRY_SIZE_SHIFT)	|
>> +		((baser->nr_pages - 1)	<< GITS_BASER_PAGES_SHIFT)	|
>> +		(u64)baser->indirect	<< 62				|
>> +		(u64)baser->valid	<< 63);
> 
>  << GITS_BASER_INDIRECT
>  << GITS_BASER_VALID
Those are BIT()
        if (baser->indirect)
                val |= GITS_BASER_INDIRECT;
        if (baser->valid)
                val |= GITS_BASER_VALID;

> 
>> +
>> +	switch (baser->psz) {
>> +	case SZ_4K:
>> +		val |= GITS_BASER_PAGE_SIZE_4K;
>> +		break;
>> +	case SZ_16K:
>> +		val |= GITS_BASER_PAGE_SIZE_16K;
>> +		break;
>> +	case SZ_64K:
>> +		val |= GITS_BASER_PAGE_SIZE_64K;
>> +		break;
>> +	}
>> +
>> +	writeq(val, gicv3_its_base() + GITS_BASER + i * 8);
>> +}
>> +
>> +/**
>> + * init_cmd_queue: Allocate the command queue and initialize
>> + * CBASER, CREADR, CWRITER
>> + */
>> +static void its_cmd_queue_init(void)
>> +{
>> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
>> +	unsigned long order = fls(n);
>> +	u64 cbaser;
>> +
>> +	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
>> +
>> +	cbaser = ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	| GITS_CBASER_VALID);
>> +
>> +	writeq(cbaser, its_data.base + GITS_CBASER);
>> +
>> +	its_data.cmd_write = its_data.cmd_base;
>> +	writeq(0, its_data.base + GITS_CWRITER);
>> +}
>> +
>> +void its_enable_defaults(void)
>> +{
>> +	unsigned int i;
>> +
>> +	its_parse_typer();
>> +
>> +	/* Allocate BASER tables (device and collection tables) */
>> +	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
>> +		struct its_baser *baser = &its_data.baser[i];
>> +		int ret;
>> +
>> +		ret = its_parse_baser(i, baser);
>> +		if (ret)
>> +			continue;
> 
> Didn't we already parse typer and baser at its_init time? How/why would
> its_parse_baser fail? Should we assert when it does?
Yes we parsed them already so I can directly use
baser = &its_data.baser[i];

More generally I have simplified and only cares about the device 	and
collection baser now.
> 
>> +
>> +		switch (baser->type) {
>> +		case GITS_BASER_TYPE_DEVICE:
>> +			baser->valid = true;
>> +			its_setup_baser(i, baser);
>> +			break;
>> +		case GITS_BASER_TYPE_COLLECTION:
>> +			baser->valid = true;
>> +			its_setup_baser(i, baser);
>> +			break;
>> +		default:
>> +			break;
> 
> assert() ?
> 
>> +		}
>> +	}
>> +
>> +	/* Allocate LPI config and pending tables */
>> +	gicv3_lpi_alloc_tables();
>> +
>> +	its_cmd_queue_init();
>> +
>> +	for (i = 0; i < nr_cpus; i++)
>> +		gicv3_lpi_rdist_ctrl(i, true);
>> +
>> +	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
>> +}
>> -- 
>> 2.20.1
>>
>>
> 
> It's looking like we don't have a clean separation between its_init and
> its_enable_defaults. I'd expect its_init to do all the allocating of
> memory and its_enable_defaults to do all the write's to the device.
> We should only do its_init once and its_enable should be something
> we can do again (after a disable, on reset, etc.). Is that not possible
> with the ITS device?

I can moved the BASER device & collection table allocation, + the queue
init in its_init()

However gicv3_lpi_alloc_tables() must be called after
gicv3_enable_defaults as it uses the redist_base[] initialized there.

Thanks

Eric


> 
> Thanks,
> drew
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
