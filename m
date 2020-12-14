Return-Path: <SRS0=YLka=FS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C503C1B0E3
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:56:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE9B92074B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:56:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE9B92074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 249464B5E8;
	Mon, 14 Dec 2020 07:56:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V0kGMuLbPfUf; Mon, 14 Dec 2020 07:56:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7824B5F0;
	Mon, 14 Dec 2020 07:56:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5074B5C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:56:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aQfKnO35qt5U for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Dec 2020 07:56:00 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8774B598
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:56:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607950560;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LStcWnrYVBS4YMoB7Kz3AAAbFjNBL/YMZWlSVmkr5VY=;
 b=KtzblyTQGe0HDZdNbmA8i4EIC3ir85y7hIcm8RWOmL1b740ozYDr8txIokI+6XrwiN6QqI
 UvCkLCT7jWrxB0lxbQOGYLqFaGnVkpkfSdUWnbbi1PGF3cs4h0CqKdlobI6DR95MrblJgJ
 9H031MgOwJ8X+cxmoMOkc/egwRFMIWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-gPWeCsjMOZq4HpO3VoR8Zg-1; Mon, 14 Dec 2020 07:55:56 -0500
X-MC-Unique: gPWeCsjMOZq4HpO3VoR8Zg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34A6659;
 Mon, 14 Dec 2020 12:55:55 +0000 (UTC)
Received: from [10.36.115.41] (ovpn-115-41.ams2.redhat.com [10.36.115.41])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85A935C1BB;
 Mon, 14 Dec 2020 12:55:53 +0000 (UTC)
Subject: Re: [PATCH 3/5] KVM: arm64: Move double-checked lock to
 kvm_vgic_map_resources()
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
 <20201201150157.223625-4-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <b686db4f-b520-6a33-4f09-d7c9cd024645@redhat.com>
Date: Mon, 14 Dec 2020 13:55:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201201150157.223625-4-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

Hi Alexandru,

On 12/1/20 4:01 PM, Alexandru Elisei wrote:
> kvm_vgic_map_resources() is called when a VCPU if first run and it maps all
> the VGIC MMIO regions. To prevent double-initialization, the VGIC uses the
> ready variable to keep track of the state of resources and the global KVM
> mutex to protect against concurrent accesses. After the lock is taken, the
> variable is checked again in case another VCPU took the lock between the
> current VCPU reading ready equals false and taking the lock.
> 
> The double-checked lock pattern is spread across four different functions:
> in kvm_vcpu_first_run_init(), in kvm_vgic_map_resource() and in
> vgic_{v2,v3}_map_resources(), which makes it hard to reason about and
> introduces minor code duplication. Consolidate the checks in
> kvm_vgic_map_resources(), where the lock is taken.
> 
> No functional change intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/arm.c            | 8 +++-----
>  arch/arm64/kvm/vgic/vgic-init.c | 6 ++++++
>  arch/arm64/kvm/vgic/vgic-v2.c   | 3 ---
>  arch/arm64/kvm/vgic/vgic-v3.c   | 3 ---
>  4 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9d69d2bf6943..65a5e89f5133 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -530,11 +530,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  		 * Map the VGIC hardware resources before running a vcpu the
>  		 * first time on this VM.
>  		 */
> -		if (unlikely(!vgic_ready(kvm))) {
> -			ret = kvm_vgic_map_resources(kvm);
> -			if (ret)
> -				return ret;
> -		}
> +		ret = kvm_vgic_map_resources(kvm);
> +		if (ret)
> +			return ret;
>  	} else {
>  		/*
>  		 * Tell the rest of the code that there are userspace irqchip
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 32e32d67a127..a2f4d1c85f00 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -428,7 +428,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	int ret = 0;
>  
> +	if (likely(vgic_ready(kvm)))
> +		return 0;
> +
>  	mutex_lock(&kvm->lock);
> +	if (vgic_ready(kvm))
> +		goto out;
> +
While we are at it, the setting of dist->ready may be moved in
kvm_vgic_map_resources() too.

Thanks

Eric
>  	if (!irqchip_in_kernel(kvm))
>  		goto out;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index ebf53a4e1296..7f38c1a93639 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -306,9 +306,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	int ret = 0;
>  
> -	if (vgic_ready(kvm))
> -		goto out;
> -
>  	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
>  	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
>  		kvm_err("Need to set vgic cpu and dist addresses first\n");
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9cdf39a94a63..35029c5cb0f1 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -500,9 +500,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  	int ret = 0;
>  	int c;
>  
> -	if (vgic_ready(kvm))
> -		goto out;
> -
>  	kvm_for_each_vcpu(c, vcpu, kvm) {
>  		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
