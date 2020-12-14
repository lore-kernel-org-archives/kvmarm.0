Return-Path: <SRS0=YLka=FS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2944C4361B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:45:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2084820674
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2084820674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 534374B678;
	Mon, 14 Dec 2020 07:45:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wk6XsgRU7P3O; Mon, 14 Dec 2020 07:45:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F3574B5FB;
	Mon, 14 Dec 2020 07:45:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F274B5E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:45:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 60TuV01EzlSQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Dec 2020 07:45:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B06B4B5E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:45:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607949908;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HgKl30hdNs58tLBnfwElhUQsBYftP03Cs4Oe53JD1So=;
 b=H9qe6sRYgQcX9Z2rHz/HkD7JxzRnRnmFqWDWJ44T7sJEoM88LwIdhY2UTkr8GfaNMERS7b
 HXVrQsYhY8fIbBDZj/zxPhoTRa/XzlS6nJULwM/WipO85+PPvPDbfM6d/uCbfqbcpBQp8u
 ZtH6TI+NDwZKUGXcZSg1M8ctB/wEWS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-ICasYzZwOju_o0jWpqRldg-1; Mon, 14 Dec 2020 07:45:06 -0500
X-MC-Unique: ICasYzZwOju_o0jWpqRldg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D36C9801A9E;
 Mon, 14 Dec 2020 12:45:04 +0000 (UTC)
Received: from [10.36.115.41] (ovpn-115-41.ams2.redhat.com [10.36.115.41])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35BE210016F7;
 Mon, 14 Dec 2020 12:45:02 +0000 (UTC)
Subject: Re: [PATCH 2/5] KVM: arm64: arch_timer: Remove VGIC initialization
 check
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
 <20201201150157.223625-3-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <890505ec-7392-0857-a359-18261e2b63b3@redhat.com>
Date: Mon, 14 Dec 2020 13:45:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201201150157.223625-3-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> kvm_timer_enable() is called in kvm_vcpu_first_run_init() after
> kvm_vgic_map_resources() if the VGIC wasn't ready. kvm_vgic_map_resources()
> is the only place where kvm->arch.vgic.ready is set to true.
> 
> For a v2 VGIC, kvm_vgic_map_resources() will attempt to initialize the VGIC
> and set the initialized flag.
> 
> For a v3 VGIC, kvm_vgic_map_resources() will return an error code if the
> VGIC isn't already initialized.
> 
> The end result is that if we've reached kvm_timer_enable(), the VGIC is
> initialzed and ready and vgic_initialized() will always be true, so remove
> this check.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/arch_timer.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 32ba6fbc3814..2e0ca8bcc6ff 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1129,9 +1129,6 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	if (!irqchip_in_kernel(vcpu->kvm))
>  		goto no_vgic;
>  
> -	if (!vgic_initialized(vcpu->kvm))
> -		return -ENODEV;
> -
>  	if (!timer_irqs_are_valid(vcpu)) {
>  		kvm_debug("incorrectly configured timer irqs\n");
>  		return -EINVAL;
>
The only concern I have is if some future contributor forgets the
constraint. Maybe add a comment (as bug on is frown upon by scripts).

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
