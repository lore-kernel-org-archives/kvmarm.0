Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0B4C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 07:16:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B205261163
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 07:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B205261163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FA04B08B;
	Wed,  8 Sep 2021 03:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id op8a5uPnUHLi; Wed,  8 Sep 2021 03:16:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41B704B0D0;
	Wed,  8 Sep 2021 03:16:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D37084B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 03:16:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSlTydGBGXxI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 03:16:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DABCC4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 03:16:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631085398;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QVcnxqH4ZqJw6GWyOzcoVHdPqx/ncSD3ywy2ZrdHJuQ=;
 b=KvbojsG32GyEWVEvaf63KxbUG+sut00DN+pkeB6b6QfltANjQHG+HQSMc4FteqNpCRV3GG
 nQPegm7w+pckl1qjsLTLEMRbZAEDYsdzEwSHz60iC0w+yeLFZR6xeIoaBz84ZPgCmtm6V9
 vsx0rtswVHUOOY5/6EMPNr+t6MqE1sA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-1C-_0LgUNaGfsGyLG_TMfA-1; Wed, 08 Sep 2021 03:16:37 -0400
X-MC-Unique: 1C-_0LgUNaGfsGyLG_TMfA-1
Received: by mail-wm1-f69.google.com with SMTP id
 u14-20020a7bcb0e0000b0290248831d46e4so501705wmj.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 00:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=QVcnxqH4ZqJw6GWyOzcoVHdPqx/ncSD3ywy2ZrdHJuQ=;
 b=PP0cCpDa3qC+lpN5yUvLuN5dv+tic7Ycw0l3zNQitDY8dD+kzaVJf5Xi87F8vz6T/a
 7kg/6sUfEVSfqpzOU3SH2wb5Qmk9J7DMZVOLWk42EvJhfkbWOKkHt0yOaQIxxtn/LIFE
 3SZUjTw6tM3VupcsHXhwlACBGFugi2QcSyXzmwRz3ymNJta/1ASZLTQjx4T+2jpLBQWc
 1cOmKScPcT4fhVoHmEiorbvC8EU2699xPQgds7wAvuMiSoevjZMQylmzkai1rktG8L2A
 LIypJX1OJY+9KTiKSyTPqkFzcXHAM91zWlzBQaEYbHY5fLU8tAunZwEw093/+ZOCVYn6
 HrUg==
X-Gm-Message-State: AOAM530G8VioMjsa2ufDisPWd9Hq8KPxDs/rLtm4pMVRc7uGRY/SDDsx
 lPFznDNJTOpXq7pGNRNQDWLhS+2gArslzV5tl2qm7UWZu8XVB9QNTYa1i5KZPplRz8I6nRoLT8p
 XTRs7tqWGCoqWERO3LnJAvzvC
X-Received: by 2002:a05:600c:3502:: with SMTP id
 h2mr2063432wmq.182.1631085396049; 
 Wed, 08 Sep 2021 00:16:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwylCkktON4n0tuWNbSRxevfGzWWZe7Oajxrq8VSijl8FtjLV0eusWXE2xNxDIPwLnilJrmvw==
X-Received: by 2002:a05:600c:3502:: with SMTP id
 h2mr2063409wmq.182.1631085395846; 
 Wed, 08 Sep 2021 00:16:35 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id n14sm1213320wrx.10.2021.09.08.00.16.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 08 Sep 2021 00:16:35 -0700 (PDT)
Subject: Re: [PATCH 1/3] hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE
 when creating scratch VM
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-2-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <a38b75a7-4f75-e42c-5804-6115e5d52394@redhat.com>
Date: Wed, 8 Sep 2021 09:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210822144441.1290891-2-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Marc,

On 8/22/21 4:44 PM, Marc Zyngier wrote:
> Although we probe for the IPA limits imposed by KVM (and the hardware)
> when computing the memory map, we still use the old style '0' when
> creating a scratch VM in kvm_arm_create_scratch_host_vcpu().
>
> On systems that are severely IPA challenged (such as the Apple M1),
> this results in a failure as KVM cannot use the default 40bit that
> '0' represents.
>
> Instead, probe for the extension and use the reported IPA limit
> if available.
>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  target/arm/kvm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index d8381ba224..cc3371a99b 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -70,12 +70,17 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
>                                        struct kvm_vcpu_init *init)
>  {
>      int ret = 0, kvmfd = -1, vmfd = -1, cpufd = -1;
> +    int max_vm_pa_size;
>  
>      kvmfd = qemu_open_old("/dev/kvm", O_RDWR);
>      if (kvmfd < 0) {
>          goto err;
>      }
> -    vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
> +    max_vm_pa_size = ioctl(kvmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +    if (max_vm_pa_size < 0) {
> +        max_vm_pa_size = 0;
> +    }
> +    vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
>      if (vmfd < 0) {
>          goto err;
>      }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
