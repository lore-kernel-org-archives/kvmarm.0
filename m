Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60788CA9EAE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:17:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D936020717
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCso8YSQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D936020717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38F4B4A955;
	Tue, 29 Oct 2019 08:17:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2RPfi1Nxlv9O; Tue, 29 Oct 2019 08:17:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7B94A557;
	Tue, 29 Oct 2019 08:17:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 196134A557
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:17:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d45+UqIG2dmb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 08:17:20 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23F954A52E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:17:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1572351439;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=c5TVCYf2MyQ5m7UVpCqBCLIUTH2CBfxMSLxMHSp3UXw=;
 b=gCso8YSQKB2mbv431nmp+frf4w9LlzMZOobkUSCWl3MDrh8dZ8jzJxlCx38AK+/WbY4K0I
 edSxoWzpf/Ej+aGgACN58tAQ116KAEnbpXiQ0oGIZvXtOB3H2ibQTFppiyOS/mOAKek5mm
 IAv7a/tgOu48TGpjonSmZeoABPGyF8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-1I3Ni04hMhG__5_pXeNLHQ-1; Tue, 29 Oct 2019 08:17:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29E9C107AD28;
 Tue, 29 Oct 2019 12:17:14 +0000 (UTC)
Received: from [10.36.118.15] (unknown [10.36.118.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 728CC600C4;
 Tue, 29 Oct 2019 12:17:10 +0000 (UTC)
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Don't rely on the wrong pending
 table
To: Zenghui Yu <yuzenghui@huawei.com>, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-4-yuzenghui@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <5e4d1a2f-7107-efe3-9dde-626662e31ac5@redhat.com>
Date: Tue, 29 Oct 2019 13:17:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191029071919.177-4-yuzenghui@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 1I3Ni04hMhG__5_pXeNLHQ-1
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

Hi Zenghui, Marc,

On 10/29/19 8:19 AM, Zenghui Yu wrote:
> It's possible that two LPIs locate in the same "byte_offset" but target
> two different vcpus, where their pending status are indicated by two
> different pending tables.  In such a scenario, using last_byte_offset
> optimization will lead KVM relying on the wrong pending table entry.
> Let us use last_ptr instead, which can be treated as a byte index into
> a pending table and also, can be vcpu specific.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
> 
> If this patch has done the right thing, we can even add the:
> 
> Fixes: 280771252c1b ("KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES")
> 
> But to be honest, I'm not clear about what has this patch actually fixed.
> Pending tables should contain all zeros before we flush vgic_irq's pending
> status into guest's RAM (thinking that guest should never write anything
> into it). So the pending table entry we've read from the guest memory
> seems always be zero. And we will always do the right thing even if we
> rely on the wrong pending table entry.
> 
> I think I must have some misunderstanding here... Please fix me.
> 
>  virt/kvm/arm/vgic/vgic-v3.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 5ef93e5041e1..7cd2e2f81513 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -363,8 +363,8 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>  int vgic_v3_save_pending_tables(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> -	int last_byte_offset = -1;
>  	struct vgic_irq *irq;
> +	gpa_t last_ptr = -1;
>  	int ret;
>  	u8 val;
>  
> @@ -384,11 +384,11 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
>  		bit_nr = irq->intid % BITS_PER_BYTE;
>  		ptr = pendbase + byte_offset;
>  
> -		if (byte_offset != last_byte_offset) {
> +		if (ptr != last_ptr) {
>  			ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>  			if (ret)
>  				return ret;
> -			last_byte_offset = byte_offset;
> +			last_ptr = ptr;
>  		}
>  
>  		stored = val & (1U << bit_nr);
> 
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks for fixing this.

Eric


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
