Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF222CA9EC3
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:29:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78C98214B2
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQb4u8cs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78C98214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67594A5BD;
	Tue, 29 Oct 2019 08:29:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1BSzophLpDzC; Tue, 29 Oct 2019 08:29:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B60424A7FD;
	Tue, 29 Oct 2019 08:29:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 387C14A557
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:29:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jkmP--D6zsYL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 08:29:44 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A89B4A542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:29:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1572352183;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=isE3WXtq6TdHNbe0eCrSyqXMPps4oLg4qOCvldTLLWc=;
 b=PQb4u8csqYgokGPJ+pAuNvs0jtrNIiVUznhmHMewx/W62qsi3ddwbsN2Gwy7kOojZrXRG4
 XIrFAybkOz6+qghRwJUnYdpal0/ZmrNXaVkH+mAMtO7V/U0WIuMUrvO9XXkvMKtBReL6es
 i5UjvELgbWAMHPMBDDX7zjgXtlVnw80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-5xRQ-dLzNiCOO_F_zL5VZg-1; Tue, 29 Oct 2019 08:29:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D0A801E64;
 Tue, 29 Oct 2019 12:29:38 +0000 (UTC)
Received: from [10.36.118.15] (unknown [10.36.118.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6906960C4B;
 Tue, 29 Oct 2019 12:29:34 +0000 (UTC)
Subject: Re: [PATCH 1/3] KVM: arm/arm64: vgic: Remove the declaration of
 kvm_send_userspace_msi()
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-2-yuzenghui@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <a38976ea-8c10-6fde-67a8-a25aa13c964e@redhat.com>
Date: Tue, 29 Oct 2019 13:29:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191029071919.177-2-yuzenghui@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 5xRQ-dLzNiCOO_F_zL5VZg-1
X-Mimecast-Spam-Score: 0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Zenghui,

On 10/29/19 8:19 AM, Zenghui Yu wrote:
> The callsite of kvm_send_userspace_msi() is currently arch agnostic.
> There seems no reason to keep an extra declaration of it in arm_vgic.h
> (we already have one in include/linux/kvm_host.h).
> 
> Remove it.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  include/kvm/arm_vgic.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index af4f09c02bf1..0fb240ec0a2a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -378,8 +378,6 @@ static inline int kvm_vgic_get_max_vcpus(void)
>  	return kvm_vgic_global_state.max_gic_vcpus;
>  }
>  
> -int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
> -
>  /**
>   * kvm_vgic_setup_default_irq_routing:
>   * Setup a default flat gsi routing table mapping all SPIs
> 

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
