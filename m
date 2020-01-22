Return-Path: <SRS0=OV02=3L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE2CC2D0DB
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 10:44:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9635F24689
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 10:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXkWgPRY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9635F24689
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E41974AC7C;
	Wed, 22 Jan 2020 05:44:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hI+cVyYs61wu; Wed, 22 Jan 2020 05:44:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D22FA4ACBA;
	Wed, 22 Jan 2020 05:44:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99DA94AC6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 05:44:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9nGgRErs1w2k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jan 2020 05:44:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A184A52C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jan 2020 05:44:09 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5FA0224688;
 Wed, 22 Jan 2020 10:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579689848;
 bh=U7baVMUBD0atkOvxVpY1i6OsBGZBdoYk6vMsLlamq5I=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ZXkWgPRYXC9AKBrp3Hlil++Z4lNFiEZjUjC/mAdr53vbH1Wtz8Z2quRd0RSkznGf0
 x8pQmO3goBhNl8wI7rTYrajTkOSfJXw0i+olU0Wb/ZD+Lm1lphPJtg9gDwREphdoRI
 WtwfN8MwqWIKnFv52fFI/Pcmwl9nOYFGbILW9ojY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iuDUU-000ipx-AG; Wed, 22 Jan 2020 10:44:06 +0000
MIME-Version: 1.0
Date: Wed, 22 Jan 2020 10:44:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] irqchip/gic-v3-its: Don't confuse get_vlpi_map() by
 writing DB config
In-Reply-To: <20200122085609.658-1-yuzenghui@huawei.com>
References: <20200122085609.658-1-yuzenghui@huawei.com>
Message-ID: <4aaaad3ae7367c5c932c430e18550d9e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, jason@lakedaemon.net,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: tglx@linutronix.de, kvmarm@lists.cs.columbia.edu, jason@lakedaemon.net,
 linux-kernel@vger.kernel.org
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

Hi Zenghui,

Thanks for this.

On 2020-01-22 08:56, Zenghui Yu wrote:
> When we're writing config for the doorbell interrupt, get_vlpi_map() 
> will
> get confused by doorbell's d->parent_data hack and find the wrong 
> its_dev
> as chip data and the wrong event.
> 
> Fix this issue by making sure no doorbells will be involved before 
> invoking
> get_vlpi_map(), which restore some of the logic in lpi_write_config().
> 
> Fixes: c1d4d5cd203c ("irqchip/gic-v3-its: Add its_vlpi_map helpers")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> 
> This is based on mainline and can't be directly applied to the current
> irqchip-next.
> 
>  drivers/irqchip/irq-gic-v3-its.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index e05673bcd52b..cc8a4fcbd6d6 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1181,12 +1181,13 @@ static struct its_vlpi_map
> *get_vlpi_map(struct irq_data *d)
> 
>  static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
>  {
> -	struct its_vlpi_map *map = get_vlpi_map(d);
>  	irq_hw_number_t hwirq;
>  	void *va;
>  	u8 *cfg;
> 
> -	if (map) {
> +	if (irqd_is_forwarded_to_vcpu(d)) {
> +		struct its_vlpi_map *map = get_vlpi_map(d);
> +
>  		va = page_address(map->vm->vprop_page);
>  		hwirq = map->vintid;

Shouldn't we fix get_vlpi_map() instead? Something like (untested):

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index e05673bcd52b..b704214390c0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1170,13 +1170,14 @@ static void its_send_vclear(struct its_device 
*dev, u32 event_id)
   */
  static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
  {
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	u32 event = its_get_event_id(d);
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+		u32 event = its_get_event_id(d);

-	if (!irqd_is_forwarded_to_vcpu(d))
-		return NULL;
+		return dev_event_to_vlpi_map(its_dev, event);
+	}

-	return dev_event_to_vlpi_map(its_dev, event);
+	return NULL;
  }

  static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)


Or am I missing the actual problem?

Overall, I'm starting to hate that ->parent hack as it's been the source
of a number of bugs.

The main issue is that the VPE hierarchy is missing one level (it has
no ITS domain, and goes directly from the VPE domain to the low-level
GIC domain). It means we end-up special-casing things, and that's never
good...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
