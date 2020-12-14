Return-Path: <SRS0=YLka=FS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2072DC4361B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:59:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A686207A0
	for <kvmarm@archiver.kernel.org>; Mon, 14 Dec 2020 12:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A686207A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7482F4B619;
	Mon, 14 Dec 2020 07:59:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0CGvVU5WZuxJ; Mon, 14 Dec 2020 07:59:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F804B635;
	Mon, 14 Dec 2020 07:59:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12BF4B619
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:59:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z-f6wme6lH+l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Dec 2020 07:59:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2CF4B615
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Dec 2020 07:59:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607950782;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LbWlPR4e2R+xdL7kYaKAr971s7EDt6mhkPR+va2M47U=;
 b=QjLy5gd8pO0Uz6jbXGYezL/nqnILs4XBhJhgLotv3RFDXzIxZgwCoWG5TnQYh0/3TxYUwt
 fZ++K0ja3hfnYxZdFTikk9eM/7691vj9NUw9YKIonCqaD5YtSAraA3vsjCB5iFridsnPyQ
 131J9DMQSOLBO963NNCDKduwKc0fHOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-mgf3YY5ZMia9cujTNIKabQ-1; Mon, 14 Dec 2020 07:59:38 -0500
X-MC-Unique: mgf3YY5ZMia9cujTNIKabQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46EAB801817;
 Mon, 14 Dec 2020 12:59:36 +0000 (UTC)
Received: from [10.36.115.41] (ovpn-115-41.ams2.redhat.com [10.36.115.41])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 860D55D9D0;
 Mon, 14 Dec 2020 12:59:34 +0000 (UTC)
Subject: Re: [PATCH 4/5] KVM: arm64: Update comment in kvm_vgic_map_resources()
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
References: <20201201150157.223625-1-alexandru.elisei@arm.com>
 <20201201150157.223625-5-alexandru.elisei@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <8a57fd41-d707-d88e-dd00-ac643acfd7c0@redhat.com>
Date: Mon, 14 Dec 2020 13:59:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201201150157.223625-5-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> vgic_v3_map_resources() returns -EBUSY if the VGIC isn't initialized,
> update the comment to kvm_vgic_map_resources() to match what the function
> does.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index a2f4d1c85f00..8942b2191bcf 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -419,7 +419,8 @@ int vgic_lazy_init(struct kvm *kvm)
>   * Map the MMIO regions depending on the VGIC model exposed to the guest
>   * called on the first VCPU run.
>   * Also map the virtual CPU interface into the VM.
> - * v2/v3 derivatives call vgic_init if not already done.
> + * v2 calls vgic_init if not already done.
nit: s/vgic_init/vgic_init()?
> + * v3 and derivatives return an error if the VGIC is not initialized.
>   * vgic_ready() returns true if this function has succeeded.
>   * @kvm: kvm struct pointer
>   */
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
