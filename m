Return-Path: <SRS0=vgt5=3C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B5EC33CAE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 17:49:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4019207FF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 17:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFY7Qmbh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4019207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F1DC4AEB1;
	Mon, 13 Jan 2020 12:49:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pxyK6rm+aMci; Mon, 13 Jan 2020 12:49:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2584AF1D;
	Mon, 13 Jan 2020 12:49:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492C44AEB1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 12:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IMtsBS-uuaDg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jan 2020 12:49:06 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 305F14AEA3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 12:49:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578937745;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Krn8eTbGp+NAIkYd15sSRQJqhL1ATwvj/bxJG4KzDzo=;
 b=dFY7QmbhNoGiyv7sB9fo1po8kmMpCkqCMxwApv/GUElkJoEDmU9Qd6OX8l3LpHE6zzaan5
 9ytq9fgJvq9a33vCjlEryWX28VPN10cFo9FdbS/wmOI4Muuc99b0H74/Zti/cTTJluoVm2
 KXwhOxd4c7zNqQ9j3p4VEkHy/mmDTY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-E-JWcLG5Oiyb6WhIBil_SQ-1; Mon, 13 Jan 2020 12:49:02 -0500
X-MC-Unique: E-JWcLG5Oiyb6WhIBil_SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF8C5107BAA5;
 Mon, 13 Jan 2020 17:49:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE8680890;
 Mon, 13 Jan 2020 17:48:55 +0000 (UTC)
Date: Mon, 13 Jan 2020 18:48:53 +0100
From: Andrew Jones <drjones@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 11/16] arm/arm64: ITS: Device and
 collection Initialization
Message-ID: <20200113174853.s23dwrpquqvqpxxi@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-12-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-12-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

On Fri, Jan 10, 2020 at 03:54:07PM +0100, Eric Auger wrote:
> Introduce an helper functions to register
> - a new device, characterized by its device id and the
>   max number of event IDs that dimension its ITT (Interrupt
>   Translation Table).  The function allocates the ITT.
> 
> - a new collection, characterized by its ID and the
>   target processing engine (PE).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v2 -> v3:
> - s/nb_/nr_
> ---
>  lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++
>  lib/arm/gic-v3-its.c     | 46 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index 0e31848..0497a78 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -55,6 +55,9 @@
>  #define GITS_BASER_TYPE_DEVICE		1
>  #define GITS_BASER_TYPE_COLLECTION	4
>  
> +#define GITS_MAX_DEVICES		8
> +#define GITS_MAX_COLLECTIONS		8
> +
>  struct its_typer {
>  	unsigned int ite_size;
>  	unsigned int eventid_bits;
> @@ -79,12 +82,27 @@ struct its_cmd_block {
>  	u64     raw_cmd[4];
>  };
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
>  struct its_data {
>  	void *base;
>  	struct its_typer typer;
>  	struct its_baser baser[GITS_BASER_NR_REGS];
>  	struct its_cmd_block *cmd_base;
>  	struct its_cmd_block *cmd_write;
> +	struct its_device devices[GITS_MAX_DEVICES];
> +	u32 nr_devices;		/* Allocated Devices */
> +	struct its_collection collections[GITS_MAX_COLLECTIONS];
> +	u32 nr_collections;	/* Allocated Collections */
>  };
>  
>  extern struct its_data its_data;
> @@ -101,6 +119,8 @@ extern u8 get_lpi_config(int n);
>  extern void set_pending_table_bit(int rdist, int n, bool set);
>  extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
>  extern void its_enable_defaults(void);
> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
> +extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_V3_ITS_H_ */
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index f488cca..88c08ee 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -257,3 +257,49 @@ void its_enable_defaults(void)
>  
>  	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
>  }
> +
> +struct its_device *its_create_device(u32 device_id, int nr_ites)
> +{
> +	struct its_baser *baser;
> +	struct its_device *new;
> +	unsigned long n, order;
> +
> +	if (its_data.nr_devices >= GITS_MAX_DEVICES)
> +		report_abort("%s redimension GITS_MAX_DEVICES", __func__);
> +
> +	baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
> +	if (!baser)
> +		return NULL;
> +
> +	new = &its_data.devices[its_data.nr_devices];
> +
> +	new->device_id = device_id;
> +	new->nr_ites = nr_ites;
> +
> +	n = (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
> +	order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
> +	new->itt = (void *)virt_to_phys(alloc_pages(order));
> +
> +	its_data.nr_devices++;
> +	return new;
> +}
> +
> +struct its_collection *its_create_collection(u32 col_id, u32 pe)
> +{
> +	struct its_collection *new;
> +
> +	if (its_data.nr_collections >= GITS_MAX_COLLECTIONS)
> +		report_abort("%s redimension GITS_MAX_COLLECTIONS", __func__);
> +
> +	new = &its_data.collections[its_data.nr_collections];
> +
> +	new->col_id = col_id;
> +
> +	if (its_data.typer.pta)
> +		new->target_address = (u64)gicv3_data.redist_base[pe];
> +	else
> +		new->target_address = pe << 16;
> +
> +	its_data.nr_collections++;
> +	return new;
> +}
> -- 
> 2.20.1
>

Please replace the if (cond) report_abort(...)'s with assert_msg(cond, ...)'s.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
