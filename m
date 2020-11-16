Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7C1C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 17:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38BC3222EC
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 17:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggVwgSeW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38BC3222EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFE24B88B;
	Mon, 16 Nov 2020 12:46:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fsIWEyCHXhGB; Mon, 16 Nov 2020 12:46:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D93C4BD21;
	Mon, 16 Nov 2020 12:46:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C33114B88B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:46:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fpLl+cEzrM+8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 12:46:40 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96C44BD19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:46:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605548800;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K3SZrwFy94uqqUNynXuBp4m3e29h27rqR4XdQ73aJwA=;
 b=ggVwgSeWK4NPYBVTvO86FMyXhkSMMbje9DdFd56kdm/GNzDLugXItlwvZGOIkNJbedbLzX
 Gc02nVFfTNyryVAl33S4xBu7rL2rUNP8u8+PTQC5oVpHm96t7msFGCX/ORDktXxMPK7XKx
 zwVK/UaNkypG3BgdMGMjySY3b8weAyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-Fs1SYoHcM8y6DcdAEDrZqg-1; Mon, 16 Nov 2020 12:46:36 -0500
X-MC-Unique: Fs1SYoHcM8y6DcdAEDrZqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99F5B803F44;
 Mon, 16 Nov 2020 17:46:34 +0000 (UTC)
Received: from gondolin (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 866176BF6B;
 Mon, 16 Nov 2020 17:46:32 +0000 (UTC)
Date: Mon, 16 Nov 2020 18:46:29 +0100
From: Cornelia Huck <cohuck@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] memory: Skip dirty tracking for un-migratable memory
 regions
Message-ID: <20201116184629.7455b82a.cohuck@redhat.com>
In-Reply-To: <20201116132210.1730-1-yuzenghui@huawei.com>
References: <20201116132210.1730-1-yuzenghui@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: qemu-devel@nongnu.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
 qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Mon, 16 Nov 2020 21:22:10 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> It makes no sense to track dirty pages for those un-migratable memory
> regions (e.g., Memory BAR region of the VFIO PCI device) and doing so
> will potentially lead to some unpleasant issues during migration [1].
> 
> Skip dirty tracking for those regions by evaluating if the region is
> migratable before setting dirty_log_mask (DIRTY_MEMORY_MIGRATION).
> 
> [1] https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg03757.html
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  softmmu/memory.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index 71951fe4dc..aa393f1bb0 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -1806,7 +1806,10 @@ bool memory_region_is_ram_device(MemoryRegion *mr)
>  uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>  {
>      uint8_t mask = mr->dirty_log_mask;
> -    if (global_dirty_log && (mr->ram_block || memory_region_is_iommu(mr))) {
> +    RAMBlock *rb = mr->ram_block;
> +
> +    if (global_dirty_log && ((rb && qemu_ram_is_migratable(rb)) ||
> +                             memory_region_is_iommu(mr))) {
>          mask |= (1 << DIRTY_MEMORY_MIGRATION);
>      }
>      return mask;

Looks reasonable.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
