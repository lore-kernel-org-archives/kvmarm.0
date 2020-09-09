Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4FEC43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:48:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C42A121D7D
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 17:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzG8y8Sw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C42A121D7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F21F4B46C;
	Wed,  9 Sep 2020 13:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jxrrFXSDEhAy; Wed,  9 Sep 2020 13:47:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E97114B42F;
	Wed,  9 Sep 2020 13:47:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDBBC4B42F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:47:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2fARBFM12bZW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 13:47:55 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01EF04B38B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 13:47:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599673674;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XFCgqV2JQrbSvgP4/1gEOGiL0mmT1yXZgdeORM1MY18=;
 b=FzG8y8Sw/u7saT7SYLDY+KiJ9SuGEIUZ2YDxJQm3ruevQcedHvySZ4MQIXsSCDjGT20eRC
 YcaO1NvQjUpI1RuRZD4icINJ3IzaOwmqKM/BhYRRz45P4mOvp+Ad0Dy2m6KcKdXb0NVngX
 5/TTRjCkDCble37gZIh0vhRTLtuJ6Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-1jwnak-iOtSzF1yoOJUeaQ-1; Wed, 09 Sep 2020 13:47:50 -0400
X-MC-Unique: 1jwnak-iOtSzF1yoOJUeaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CA38015DB;
 Wed,  9 Sep 2020 17:47:49 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 661A75C1DA;
 Wed,  9 Sep 2020 17:47:46 +0000 (UTC)
Subject: Re: [PATCH v3 5/5] KVM: arm64: Document PMU filtering API
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-6-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7a90830f-fa4f-9513-e55c-b932451a033d@redhat.com>
Date: Wed, 9 Sep 2020 19:47:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200908075830.1161921-6-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: kernel-team@android.com, graf@amazon.com,
 Robin Murphy <robin.murphy@arm.com>
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

Hi Marc,

On 9/8/20 9:58 AM, Marc Zyngier wrote:
> Add a small blurb describing how the event filtering API gets used.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 46 +++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index ca374d3fe085..203b91e93151 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -55,6 +55,52 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
>  virtual GIC implementation, this must be done after initializing the in-kernel
>  irqchip.
>  
> +1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
> +---------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address for a PMU event filter is a
> +             pointer to a struct kvm_pmu_event_filter
> +
> +:Returns:
> +
> +	 =======  ======================================================
> +	 -ENODEV: PMUv3 not supported or GIC not initialized
> +	 -ENXIO:  PMUv3 not properly configured or in-kernel irqchip not
> +	 	  configured as required prior to calling this attribute
> +	 -EBUSY:  PMUv3 already initialized
> +	 -EINVAL: Invalid filter range
> +	 =======  ======================================================
> +
> +Request the installation of a PMU event filter describe as follows:
> +
> +struct kvm_pmu_event_filter {
> +	__u16	base_event;
> +	__u16	nevents;
> +
> +#define KVM_PMU_EVENT_ALLOW	0
> +#define KVM_PMU_EVENT_DENY	1
> +
> +	__u8	action;
> +	__u8	pad[3];
> +};
> +
> +A filter range is defined as the range [@base_event, @base_event + @nevents[,
> +together with an @action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
> +first registered range defines the global policy (global ALLOW if the first
> +@action is DENY, global DENY if the first @action is ALLOW). Multiple ranges
> +can be programmed, and must fit within the event space defined by the PMU
> +architecture (10 bits on ARMv8.0, 16 bits from ARMv8.1 onwards).
> +
> +Note: "Cancelling" a filter by registering the opposite action for the same
> +range doesn't change the default action. For example, installing an ALLOW
> +filter for event range [0:10] as the first filter and then applying a DENY
> +action for the same range will leave the whole range as disabled.
> +
> +Restrictions: Event 0 (SW_INCR) is never filtered, as it doesn't count a
> +hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
> +isn't strictly speaking an event. Filtering the cycle counter is possible
> +using event 0x11 (CPU_CYCLES).
Oh I see here you did comment it in the uapi.

Thanks

Eric
> +
>  
>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>  =================================
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
