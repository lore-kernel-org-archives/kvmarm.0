Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21347C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:45:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F0A62073D
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 11:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8nEzMf7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0A62073D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2AE4AF0B;
	Mon, 20 Jan 2020 06:45:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XlueYZ7zPBP8; Mon, 20 Jan 2020 06:45:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032DF4AEF5;
	Mon, 20 Jan 2020 06:45:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73B14AE96
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 17:48:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r2nvHpLRRbpY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Jan 2020 17:48:07 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B705B4A531
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Jan 2020 17:48:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579474087;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Q8gG+1cgJTMe7mIrJCeKPohDJq4KgvzUnmCCGFTyYv0=;
 b=N8nEzMf7tOyvBMDn7lvEt1GdK6A3C3iFhNIOAUGKaBxG3gL5w8Csbi8tckZXtTlQondZqa
 bjT0bHTh0kxhA5pppiatlYuXPkatwi21o02XOaUrMqowqYrssWez+3GRZ7/LGT7rr/nEKZ
 1RmS2cHm1UFLRi6rIr7E5H2DnfZg7Xw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-yW7lfmG9NhS_66Jh5-G9Qg-1; Sun, 19 Jan 2020 17:48:03 -0500
X-MC-Unique: yW7lfmG9NhS_66Jh5-G9Qg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F96E10054E3;
 Sun, 19 Jan 2020 22:48:02 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-61.bne.redhat.com [10.64.54.61])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E612960BE2;
 Sun, 19 Jan 2020 22:47:59 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Drop the
 kvm_vgic_register_mmio_region()
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org
References: <20200119090604.398-1-yuzenghui@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <479f2e5f-80c4-37e1-8f3a-2f1197fddd51@redhat.com>
Date: Mon, 20 Jan 2020 09:47:57 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200119090604.398-1-yuzenghui@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mailman-Approved-At: Mon, 20 Jan 2020 06:45:32 -0500
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

On 1/19/20 8:06 PM, Zenghui Yu wrote:
> kvm_vgic_register_mmio_region() was introduced in commit 4493b1c4866a
> ("KVM: arm/arm64: vgic-new: Add MMIO handling framework") but never
> used, and even never implemented. Remove it to avoid confusing readers.
> 
> Reported-by: Haibin Wang <wanghaibin.wang@huawei.com>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---

Reviewed-by: Gavin Shan <gshan@redhat.com>

>   virt/kvm/arm/vgic/vgic-mmio.h | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 836f418f1ee8..5af2aefad435 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -98,11 +98,6 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
>   		.uaccess_write = uwr,					\
>   	}
>   
> -int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
> -				  struct vgic_register_region *reg_desc,
> -				  struct vgic_io_device *region,
> -				  int nr_irqs, bool offset_private);
> -
>   unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
>   
>   void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
