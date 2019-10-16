Return-Path: <SRS0=103j=YJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C042AECE588
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:25:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C01120872
	for <kvmarm@archiver.kernel.org>; Wed, 16 Oct 2019 07:25:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izrUhR1m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C01120872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAEB64A9D2;
	Wed, 16 Oct 2019 03:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T4SU7knEm8QX; Wed, 16 Oct 2019 03:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C334A9C0;
	Wed, 16 Oct 2019 03:25:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6826D4A590
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WsxrZEWT4c3B for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Oct 2019 03:25:04 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B584D4A418
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 03:25:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571210704;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=S5d0V9S8ommJVGUrWAIephbxJ0dHyW1i5xgUqQkwiWw=;
 b=izrUhR1m9GQmr/R4nFLnw1JlaOYJZD0AYbmiLSOd6Bx70oxacKuavN2XZ+dkBfQt15YmZU
 0eOZX8LqBs6PfPNl1ZjtLW5dIE2PMLEZtCaHXjwHfEX0SgXm/20aoFygycI4I0uoqczrZH
 ZkPDPGwhEoK2P1ExnBOGoUAwGQx1NLg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-0XXoXNj4ORC7etWQJ-POiQ-1; Wed, 16 Oct 2019 03:25:00 -0400
Received: by mail-wr1-f71.google.com with SMTP id j2so2327302wrg.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Oct 2019 00:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=7pVDKMRb0iY8vtAwjOLtISUgtFuBYzCTEpSdAuatOfE=;
 b=SgC7DXzZ0ntCUvikTiFnsrvFmV/JgI9JwPfyZoReYluq+4vURhd9zIjJMFGcf/Kshq
 Ae6ZhH5DpD+0NYlbvIvL0Xezww6U4B/0aehasxhmQbkZgu8i30An08TNPfdHj+v8erey
 J+nz0NZ9jSTA4q3VMCP6y3WL3mkD09HOaE9Jkd5JoP9op1sV5SW3cswN/i8b9FZpkWKi
 tJeL9fIqfnHrWx178WMGnw8DSV5eFq1KnRraVr6Mct7KIIxInkpMee3ztt3U3HIojGF1
 m2PdiyVnuZbGRFDHYhCYCuX96XyVOdAsNLPxqum4vbEC7NhzXJeqTTmp9n5J32cxnz3z
 DI/g==
X-Gm-Message-State: APjAAAUDWvSGs2dfINzbkN6byqf9v0xARqNSz/lNGekXndidMZKRsPqc
 AwgSgLQUqdsHie1g2zj86gUL6cxGVpiDguLkqdW5AoprQlqUHqV2gW9R2PonlfUtSJEbZOqxCHy
 JiHAib/kGFyp56QXWC7qNHVRK
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925350wmt.108.1571210699180; 
 Wed, 16 Oct 2019 00:24:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw5Hnm/FlYZhsbogxc96HRPT50pfLfmeGENB2+vf8pJDNEMgxSNXlDgdpTAAP/g6kRKVCeDyw==
X-Received: by 2002:a1c:2d4d:: with SMTP id t74mr1925322wmt.108.1571210698895; 
 Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id f20sm1474636wmb.6.2019.10.16.00.24.54
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Oct 2019 00:24:58 -0700 (PDT)
Subject: Re: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
To: Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 sean.j.christopherson@intel.com, maz@kernel.org, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Date: Wed, 16 Oct 2019 09:24:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-5-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: 0XXoXNj4ORC7etWQJ-POiQ-1
X-Mimecast-Spam-Score: 0
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 15/10/19 12:48, Jianyong Wu wrote:
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 07e57a49d1e8..3597f1f27b10 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -1634,3 +1634,8 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
>  }
>  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
>  #endif
> +
> +bool is_arm_arch_counter(void *cs)
> +{
> +	return (struct clocksource *)cs == &clocksource_counter;
> +}

As Thomas pointed out, any reason to have a void * here?

However, since he didn't like modifying the struct, here is an
alternative idea:

1) add a "struct clocksource*" argument to ktime_get_snapshot

2) return -ENODEV if the argument is not NULL and is not the current
clocksource

3) move the implementation of the hypercall to
drivers/clocksource/arm_arch_timer.c, so that it can call
ktime_get_snapshot(&systime_snapshot, &clocksource_counter);

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
