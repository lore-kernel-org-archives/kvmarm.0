Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CD2C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 11:24:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AB6B64FC6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 11:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB6B64FC6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E1C4B3D0;
	Fri,  5 Feb 2021 06:24:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8vLMIgNmmx0F; Fri,  5 Feb 2021 06:24:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64CEB4B3A6;
	Fri,  5 Feb 2021 06:24:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8684B3A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 06:24:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Izh9akVcSkSO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 06:24:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B49E14B37F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 06:24:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612524241;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1khU1C0GfELsGU0Fj00nuXnaZ6zgV1rmRJ0fb1z6uq4=;
 b=GxVN8G63NDFvkC33koKaVFwf7rr7c11UPgP4wja/EfYomIZuw/VguH/zcpySobz9TEHLbs
 q3YLgW8lJgINPfp69g3mF6Bu8cvpMC++6lCdRBYBPPZpXRbugrvIKyEeRdybU5+n1mqe5a
 WBDxjju9jsEyPgR3NcKLmBHqrRu9Jvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-YGIWRmuOO8-Sgup-V2dHqQ-1; Fri, 05 Feb 2021 06:23:57 -0500
X-MC-Unique: YGIWRmuOO8-Sgup-V2dHqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 744C8107ACC7;
 Fri,  5 Feb 2021 11:23:56 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08C3D60DA1;
 Fri,  5 Feb 2021 11:23:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 10/11] arm64: gic: its-trigger: Don't
 trigger the LPI while it is pending
To: Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
 <20210129163647.91564-11-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a3d1c79d-22d8-f1f0-f594-6ce616401950@redhat.com>
Date: Fri, 5 Feb 2021 12:23:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210129163647.91564-11-alexandru.elisei@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: andre.przywara@arm.com
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

Hi,

On 1/29/21 5:36 PM, Alexandru Elisei wrote:
> The its-trigger test checks that LPI 8195 is not delivered to the CPU while
> it is disabled at the ITS level. After that it is re-enabled and the test
> checks that the interrupt is properly asserted. After it's re-enabled and
> before the stats are examined, the test triggers the interrupt again, which
> can lead to the same interrupt being delivered twice: once after the
> configuration invalidation and before the INT command, and once after the
> INT command.
> 
> Add an explicit check that the interrupt has fired after the invalidation.
> Leave the check after the INT command to make sure the INT command still
> works for the now re-enabled LPI.
> 
> CC: Auger Eric <eric.auger@redhat.com>
> Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/gic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index af2c112336e7..8bc2a35908f2 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -802,6 +802,9 @@ static void test_its_trigger(void)
>  
>  	/* Now call the invall and check the LPI hits */
>  	its_send_invall(col3);
> +	lpi_stats_expect(3, 8195);
> +	check_lpi_stats("dev2/eventid=20 pending LPI is received");
> +
>  	lpi_stats_expect(3, 8195);
>  	its_send_int(dev2, 20);
>  	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
