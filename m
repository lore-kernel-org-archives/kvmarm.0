Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2CEC33CA4
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 08:37:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24154206ED
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 08:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0s8glR5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24154206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC014B121;
	Fri, 10 Jan 2020 03:37:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05UNPoiunMJS; Fri, 10 Jan 2020 03:37:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 745594B182;
	Fri, 10 Jan 2020 03:37:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5974B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 03:37:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BXr6-1GJGcQh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 03:37:27 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6872F4B0D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 03:37:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578645447;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SEGdNnuJMmxq2nRffYFL3avciJRwxghn7a6DuxkSNjc=;
 b=i0s8glR5EMdHLdbYFlklxfK5yciOoYVZtmAyZtlnNLkARoGTJN6a3onuw82uF5aGHHktBD
 47kwdGZkKEjJMu40l7qZsyKSWelt/ufHEGLiTOmXf8py0qKUhPyZk1gJrb4wblKrJJiAqE
 7foTLYOcLxNm3CGAnBzxjGLbSTOSFI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-1Hhibq09NKSGSuiB0AkAYg-1; Fri, 10 Jan 2020 03:37:23 -0500
X-MC-Unique: 1Hhibq09NKSGSuiB0AkAYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89BF01800D6B;
 Fri, 10 Jan 2020 08:37:21 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA64560FA2;
 Fri, 10 Jan 2020 08:37:19 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Check hopefully the last
 DISCARD command error
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org
References: <20191225133014.1825-1-yuzenghui@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <f9997198-c990-d638-24d0-41d6280a9d8a@redhat.com>
Date: Fri, 10 Jan 2020 09:37:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191225133014.1825-1-yuzenghui@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

On 12/25/19 2:30 PM, Zenghui Yu wrote:
> DISCARD command error occurs if any of the following apply:
> 
>  - [ ... (those which we have already handled) ]
nit: I would remove the above and simply say the discard is supposed to
fail if the collection is not mapped to any target redistributor. If an
ITE exists then the ite->collection is non NULL. What needs to be
checked is its_is_collection_mapped().

By the way update_affinity_collection() also tests ite->collection. I
think this is useless or do I miss something?

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

>  - The EventID for the device is mapped to a collection that
>    has not been mapped to an RDbase using MAPC.
> 
> Let's take the unmapped collection case into account and report
> a DISCARD command error if it really happens.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 17920d1b350a..d53d34a33e35 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -839,9 +839,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>  	u32 event_id = its_cmd_get_id(its_cmd);
>  	struct its_ite *ite;
>  
> -
>  	ite = find_ite(its, device_id, event_id);
> -	if (ite && ite->collection) {
> +	if (ite && its_is_collection_mapped(ite->collection)) {
>  		/*
>  		 * Though the spec talks about removing the pending state, we
>  		 * don't bother here since we clear the ITTE anyway and the
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
