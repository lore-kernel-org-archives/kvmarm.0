Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA17EC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:37:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 619E5610F7
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 15:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 619E5610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0044B271;
	Tue,  9 Nov 2021 10:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NfkAcMp5hwQI; Tue,  9 Nov 2021 10:37:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8444B293;
	Tue,  9 Nov 2021 10:37:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF2E4B232
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:26:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BhZKp1n0aav9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Nov 2021 10:26:13 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 266C34B229
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Nov 2021 10:26:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636471572;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zPHOaPm18j2Z6M7uu1JTM0F6CYuFdr82KoODnjFlc9g=;
 b=guLbKUow6ZeXBVx/IsP92u9yi1pv3S28Mhwlzx9iudXC/XygJkkbNEu1QI3FgvJ3TugFl9
 H1j0tMgKab60OFe8fua+kWfcMnaRn2lPO8GuRtPMEp/snX67y67wBbhiiHjiANm8N4wGde
 8UUZeCVq/mtd1yrhj+9A2h3u6qxPBuY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-D9bdsbxAPoSQCtcCIOPVjQ-1; Tue, 09 Nov 2021 10:26:08 -0500
X-MC-Unique: D9bdsbxAPoSQCtcCIOPVjQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 h7-20020adfaa87000000b001885269a937so3765731wrc.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Nov 2021 07:26:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zPHOaPm18j2Z6M7uu1JTM0F6CYuFdr82KoODnjFlc9g=;
 b=LmrQi41XaeAR4RPxfvRWlhiYgk20my58kqpbe+WNflxmBJi3AM96yyIzrxmecvMXS2
 v2UH7gNFskYUmH1bjh6lIv6q0Z90xxKgbJQXa8n/FEiADaHavOdp1PO0igLbIbqhS0hC
 JQ9j8oZBEaaKqvNYSK8IH2SD9WwMcchOwe2EGDZH9KwCa7gKT8uO+yt0OyW61hVRyTKl
 YF7Sxm45Wo2wVG8AR+LR90vxpl47cWm13/5Z2AJrsKMd+N2qyW8i9p80XRhhRliV89iL
 HFp94RbQ80n2fVlOsiJ8sMGFUP8JGAfpDmf/E2XDfEEjoIr5F+avzEwNybvg0TcfSr0N
 6MrA==
X-Gm-Message-State: AOAM5326jKuVBw/AvlcxPAz+PFFNcjhcVGhyZ0X8Ytoe8xfxGzJt6XZE
 p1VWt0WWQbaypA96pXc5rKUK0AtNy/jG2/0BxyhKiPp5mfweypjYnsq74ec5YJ/sNGO5TvGM4R3
 au2XdK2CiB2MDfK/xvsPhdQVL
X-Received: by 2002:adf:b604:: with SMTP id f4mr10642694wre.111.1636471567757; 
 Tue, 09 Nov 2021 07:26:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyj4mW7KmawaErXG/bkbQYML4AiemLmaiJ6RS/NPf7ijkc4rvHOTmAvgZDTC52J+J9rIde5JQ==
X-Received: by 2002:adf:b604:: with SMTP id f4mr10642661wre.111.1636471567600; 
 Tue, 09 Nov 2021 07:26:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id l4sm19431635wrv.94.2021.11.09.07.26.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 09 Nov 2021 07:26:06 -0800 (PST)
Subject: Re: [PATCH v4 03/21] KVM: arm64: Support SDEI_VERSION hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-4-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <3160dd62-1d96-7dcb-e99a-7ac923abc2c7@redhat.com>
Date: Tue, 9 Nov 2021 16:26:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815001352.81927-4-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Tue, 09 Nov 2021 10:37:47 -0500
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

Hi Gavin

On 8/15/21 2:13 AM, Gavin Shan wrote:
> This supports SDEI_VERSION hypercall by returning v1.0.0 simply
s/This supports/Add Support. I think this is the prefered way to start
the commit msg. Here and elsewhere.
> when the functionality is supported on the VM and vCPU.
Can you explain when the functionality isn't supported on either. From
the infra patch I have the impression that an allocation failure is the
sole cause of lack of support?
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index ab330b74a965..aa9485f076a9 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -70,6 +70,22 @@ static void kvm_sdei_remove_vcpu_events(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static unsigned long kvm_sdei_hypercall_version(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	unsigned long ret = SDEI_NOT_SUPPORTED;
nit: I would remove ret local variable
> +
> +	if (!(ksdei && vsdei))
> +		return ret;
> +
> +	/* v1.0.0 */
> +	ret = (1UL << SDEI_VERSION_MAJOR_SHIFT);
> +
> +	return ret;
> +}
> +
>  int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u32 func = smccc_get_function(vcpu);
> @@ -78,6 +94,8 @@ int kvm_sdei_hypercall(struct kvm_vcpu *vcpu)
>  
>  	switch (func) {
>  	case SDEI_1_0_FN_SDEI_VERSION:
> +		ret = kvm_sdei_hypercall_version(vcpu);
> +		break;
>  	case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
>  	case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
>  	case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
> 

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
