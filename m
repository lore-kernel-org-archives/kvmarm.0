Return-Path: <SRS0=v4UO=24=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1249C33C99
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jan 2020 07:35:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 505AF2075A
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jan 2020 07:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="igcD6iqO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 505AF2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A683D4AE9C;
	Tue,  7 Jan 2020 02:35:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dS0-tBqlmK9Y; Tue,  7 Jan 2020 02:35:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6EA4AECA;
	Tue,  7 Jan 2020 02:35:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB0A4AECA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jan 2020 02:35:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JjoWhaLEJsj2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jan 2020 02:35:34 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B11364AE9C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jan 2020 02:35:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578382534;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=9MB1EpwF/3QQ/vJ0P9V4XwfNz1wYN5CHQ5mAOEIgsWc=;
 b=igcD6iqOM8T2TukFvz30JZooeK5i4+fssuKNLmen1Sjqt4jHOkX3+CEW3cCPtO5msGyFus
 xM2RsGSElGcU3sieVeDjuscDdvIg1ss6UbAfbHp9OCLK3nVxSlMFLKlhuwAGWCn1mHXOYT
 IM0BCaHYm6CQrJa4nKjMiS5lqm7DY8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-FdoqD2fZOFKOIrQZOzg5-w-1; Tue, 07 Jan 2020 02:35:27 -0500
X-MC-Unique: FdoqD2fZOFKOIrQZOzg5-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4DCB801E76;
 Tue,  7 Jan 2020 07:35:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-116.ams2.redhat.com [10.36.116.116])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89F8E1C4;
 Tue,  7 Jan 2020 07:35:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 01/16] libcflat: Add other size defines
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-2-eric.auger@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cab416f2-4e86-4cae-97e9-d78cfb7f2781@redhat.com>
Date: Tue, 7 Jan 2020 08:35:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191216140235.10751-2-eric.auger@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On 16/12/2019 15.02, Eric Auger wrote:
> Introduce additional SZ_256, SZ_8K, SZ_16K macros that will
> be used by ITS tests.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  lib/libcflat.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index ea19f61..7092af2 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -36,7 +36,10 @@
>  #define ALIGN(x, a)		__ALIGN((x), (a))
>  #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>  
> +#define SZ_256			(1 << 8)
>  #define SZ_4K			(1 << 12)
> +#define SZ_8K			(1 << 13)
> +#define SZ_16K			(1 << 14)
>  #define SZ_64K			(1 << 16)
>  #define SZ_2M			(1 << 21)
>  #define SZ_1G			(1 << 30)
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
