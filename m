Return-Path: <SRS0=Cfin=4A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DA8C2BA83
	for <kvmarm@archiver.kernel.org>; Wed, 12 Feb 2020 11:19:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5201B2073C
	for <kvmarm@archiver.kernel.org>; Wed, 12 Feb 2020 11:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SA4SOaVG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5201B2073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9734ACFA;
	Wed, 12 Feb 2020 06:19:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1sX+1GNG0chj; Wed, 12 Feb 2020 06:19:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF6F74AE95;
	Wed, 12 Feb 2020 06:19:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E18A4ACF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Feb 2020 06:19:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fnwc4qIx7uKd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Feb 2020 06:19:22 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD494A65C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Feb 2020 06:19:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581506361;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YlLI5XVr5Wc9+pWx7tpAwQuz9CsmiC2eusgJFVPX+ck=;
 b=SA4SOaVGNmcyyD/EHIgQCWVpSyG8K/QHZNlQBvgJEq6YQ6aLnR7ToVksxkVhorILH+jepg
 y5ijf3Jzawb5aRHPwrEbL2qHfcHLxBrsj7mdj0TrkzQ6+AaoCWAbZlDfNDdop82LFGvMus
 9oW/5bxSppS4pAJQ9rJWLDPL0HHu2yE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-4OY5U2zXOqW8YBrwKJRdwQ-1; Wed, 12 Feb 2020 06:19:15 -0500
Received: by mail-wm1-f71.google.com with SMTP id y24so803789wmj.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Feb 2020 03:19:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=YlLI5XVr5Wc9+pWx7tpAwQuz9CsmiC2eusgJFVPX+ck=;
 b=ewZDO8e8TO1uLyer/UWjqdT9HWd4sTuaUYJUZZLnfcTl49ofUcItscIQx0xYISIxS5
 yUvxYa2v6dgIX6kkn84EEMUIHV7CJKZ+esbF4qaxlV4/tIL7Ebrp7mguXDe8qo8a6fm2
 DyZZqrNYVt2wcEr3DnOl0+j/UoVRWFB8TSfRCc/aj3Dt7RxI+Q0Q6SUSeGJWfMMgOANh
 F3iJFaR7naLTF+z4285FQeVuTGxigkoRdFqf7YfS4MrksVsrLD1xlw19LCNHj1lj30SJ
 WZTPn7oTll1h2AIxwJmysk2LDCDgzKFiC0099NBJASWTnnjK39gy8JU1NOm4f/EnB3c6
 uZHA==
X-Gm-Message-State: APjAAAVkF9qjiIlNPgU7mVLROHrR/yHiQjcbT2fGFrCVQ89Biy11aV8Z
 h1rRgataWZ6/VT00gFkFbL+FcVDhkLsojyZ+QE7JDLISZH49OM9iTiZt2y+nyM/qqv4FCABAUfT
 +237cmkflQq3yWwVoumWsJw7W
X-Received: by 2002:adf:f406:: with SMTP id g6mr14924816wro.189.1581506354121; 
 Wed, 12 Feb 2020 03:19:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqymfHc6RwQBr8SJa0qfwEJkhyZj1ibMcD/6wcX1Ufs9ioeURGiTMq4XoSDi3emuW5gMXLaYCg==
X-Received: by 2002:adf:f406:: with SMTP id g6mr14924770wro.189.1581506353668; 
 Wed, 12 Feb 2020 03:19:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9?
 ([2001:b07:6468:f312:652c:29a6:517b:66d9])
 by smtp.gmail.com with ESMTPSA id b13sm249477wrq.48.2020.02.12.03.19.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 12 Feb 2020 03:19:11 -0800 (PST)
Subject: Re: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20200207163410.31276-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34f68f45-1c09-d7bf-2f86-551d11a2274a@redhat.com>
Date: Wed, 12 Feb 2020 12:19:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207163410.31276-1-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: 4OY5U2zXOqW8YBrwKJRdwQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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

On 07/02/20 17:34, Marc Zyngier wrote:
> Accessing a per-cpu variable only makes sense when preemption is
> disabled (and the kernel does check this when the right debug options
> are switched on).
> 
> For kvm_get_running_vcpu(), it is fine to return the value after
> re-enabling preemption, as the preempt notifiers will make sure that
> this is kept consistent across task migration (the comment above the
> function hints at it, but lacks the crucial preemption management).
> 
> While we're at it, move the comment from the ARM code, which explains
> why the whole thing works.
> 
> Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.comz

Queued, thanks.

Paolo

> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 12 ------------
>  virt/kvm/kvm_main.c           | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d656ebd5f9d4..97fb2a40e6ba 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -179,18 +179,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> -/*
> - * This function will return the VCPU that performed the MMIO access and
> - * trapped from within the VM, and will return NULL if this is a userspace
> - * access.
> - *
> - * We can disable preemption locally around accessing the per-CPU variable,
> - * and use the resolved vcpu pointer after enabling preemption again, because
> - * even if the current thread is migrated to another CPU, reading the per-CPU
> - * value later will give us the same value as we update the per-CPU variable
> - * in the preempt notifier handlers.
> - */
> -
>  /* Must be called with irq->irq_lock held */
>  static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				 bool is_uaccess)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ae2d5c37b2..70f03ce0e5c1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4409,12 +4409,22 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  
>  /**
>   * kvm_get_running_vcpu - get the vcpu running on the current CPU.
> - * Thanks to preempt notifiers, this can also be called from
> - * preemptible context.
> + *
> + * We can disable preemption locally around accessing the per-CPU variable,
> + * and use the resolved vcpu pointer after enabling preemption again,
> + * because even if the current thread is migrated to another CPU, reading
> + * the per-CPU value later will give us the same value as we update the
> + * per-CPU variable in the preempt notifier handlers.
>   */
>  struct kvm_vcpu *kvm_get_running_vcpu(void)
>  {
> -        return __this_cpu_read(kvm_running_vcpu);
> +	struct kvm_vcpu *vcpu;
> +
> +	preempt_disable();
> +	vcpu = __this_cpu_read(kvm_running_vcpu);
> +	preempt_enable();
> +
> +	return vcpu;
>  }
>  
>  /**
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
