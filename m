Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E69C43215
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 09:08:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6461C21770
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 09:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZjIURIA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6461C21770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7D624ACF4;
	Thu, 28 Nov 2019 04:08:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2a6-29YCr8N; Thu, 28 Nov 2019 04:08:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7004A5A0;
	Thu, 28 Nov 2019 04:08:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBBD4A598
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 04:08:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UptVannliUdV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 04:08:04 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86BED4A51C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 04:08:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574932084;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LQyMIOq1brhBX2bUMaM6TFXqa3RnBbkv7h2aLB1dU5Q=;
 b=aZjIURIAgqnnFOBTRzgdfzbCXPMm3XjOIqm2duT5Xpju3aKd0zGIPRrolt3Xnq1vnFC2qG
 K+rKieUUNPFca5giYKhoKhL23gVKhHSyPdw8gEagGVBfXZZkNf2iGlmrBJPV75pFYSPPcf
 WOSVAkaZCvNSYI7M3vMwqawoCZ9knvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-0ZLVFI1nP2WETMSLr2dzlg-1; Thu, 28 Nov 2019 04:08:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B577980183C;
 Thu, 28 Nov 2019 09:08:00 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 552426084E;
 Thu, 28 Nov 2019 09:07:54 +0000 (UTC)
Subject: Re: [PATCH] KVM: vgic: Use warpper function to lock/unlock all vcpus
 in kvm_vgic_create()
To: linmiaohe <linmiaohe@huawei.com>, maz@kernel.org, pbonzini@redhat.com,
 rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com,
 gregkh@linuxfoundation.org, will@kernel.org, andre.przywara@arm.com,
 tglx@linutronix.de
References: <1574910551-14351-1-git-send-email-linmiaohe@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <cdd7ef36-70ae-3e56-2ea3-48d7051991c3@redhat.com>
Date: Thu, 28 Nov 2019 10:07:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574910551-14351-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 0ZLVFI1nP2WETMSLr2dzlg-1
X-Mimecast-Spam-Score: 0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi,

On 11/28/19 4:09 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> Use warpper function lock_all_vcpus()/unlock_all_vcpus()
s/warpper/wrapper and also in the title.
> in kvm_vgic_create() to remove duplicated code dealing
> with locking and unlocking all vcpus in a vm.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index b3c5de48064c..53e3969dfb52 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -70,7 +70,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>   */
>  int kvm_vgic_create(struct kvm *kvm, u32 type)
>  {
> -	int i, vcpu_lock_idx = -1, ret;
> +	int i, ret;
>  	struct kvm_vcpu *vcpu;
>  
>  	if (irqchip_in_kernel(kvm))
> @@ -92,11 +92,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	 * that no other VCPUs are run while we create the vgic.
>  	 */
>  	ret = -EBUSY;
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!mutex_trylock(&vcpu->mutex))
> -			goto out_unlock;
> -		vcpu_lock_idx = i;
> -	}
> +	if (!lock_all_vcpus(kvm))
> +		return ret;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (vcpu->arch.has_run_once)
> @@ -125,10 +122,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
>  
>  out_unlock:
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> -		mutex_unlock(&vcpu->mutex);
> -	}
> +	unlock_all_vcpus(kvm);
>  	return ret;
>  }
>  
> 
Besides, looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
