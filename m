Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13D4C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:22:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CB3260F46
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 14:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CB3260F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BA284B0CC;
	Mon, 25 Oct 2021 10:22:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vjoHTlflP+VM; Mon, 25 Oct 2021 10:22:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4708940762;
	Mon, 25 Oct 2021 10:22:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86DF54025B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:22:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DCaVm8ON6r4W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 10:22:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8668640256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 10:22:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635171734;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HpaqUtGVB++dG0RuCTiBEYznGy9v/KDIt/5yYlz7/xg=;
 b=AWDyRtmXaPlPbYzj8fAN5bBexxIM6tuTRoW6wwZGk+WGblmxKtG5MyTVuWylZenb9CA0CL
 i3pU9wOQo2Tirj2iPAchWCF5sByL4bwwPAHxREgMydhUAgJL4u0zMm8U0923aU6Y6Dtp1H
 x+tl8/aF8EeAZhDeHJmG5ZMxHB0IO/c=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-mOf0rRG4P4iESkMMFI3R0g-1; Mon, 25 Oct 2021 10:22:13 -0400
X-MC-Unique: mOf0rRG4P4iESkMMFI3R0g-1
Received: by mail-wr1-f69.google.com with SMTP id
 j12-20020adf910c000000b0015e4260febdso3245803wrj.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 07:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=HpaqUtGVB++dG0RuCTiBEYznGy9v/KDIt/5yYlz7/xg=;
 b=HC6K4nZMxAqzboWhDa5KDNiqR1dBflm1kpLJI4KIO1k7HKLEs9uNGQS67ENJMEIa0G
 sr8rI4a6yoAm2TSwj4LLw+Q10ldjzul+nvqzOgSXNKcqnFC2Q8jGErur9EYYfroqcnca
 13CdZsoNGRevAEYFBQEyePj07OBIXb6xDrLapnQBge7U93rlAcM5RTlZ+Yl1+12DWKze
 TUS1oDIT9/NhM1RjNp7KZs0+sL3hM69zRXZi0J9AJMLkZSI34QIlrRqFhCnFSQJKgtW/
 YZ2AabUUrvd6NoOHuWNZrXt6ffCxQjhLm575hYMqz1mN6SLtubhAri3TsH8rV+78rfzk
 t9GA==
X-Gm-Message-State: AOAM5303eHecbGGh3+bezC9yFiUag5h1FyPS4eB0/eMyUAYC7H3mAe5p
 wqAl8zHERCDryWhGjWJwlvY/JhPVQCbln8Gwp68Yt22Zulq+iKVT8oyesIToOjt9tHPXiPA8IX0
 opT1Zp/ReMldKM94fQS9kLJLg
X-Received: by 2002:adf:ef8f:: with SMTP id d15mr23887305wro.72.1635171731940; 
 Mon, 25 Oct 2021 07:22:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzadqpNa9sRFm6T5pRsCXL5a0VdPZvR+Z2HC9JjGJpxIRL6ejj2cNhckiUN6d6SszWigGu00w==
X-Received: by 2002:adf:ef8f:: with SMTP id d15mr23887262wro.72.1635171731758; 
 Mon, 25 Oct 2021 07:22:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id v6sm2568505wrx.17.2021.10.25.07.22.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 25 Oct 2021 07:22:10 -0700 (PDT)
Message-ID: <acea3c6d-49f4-ab5e-d9fe-6c6a8a665a46@redhat.com>
Date: Mon, 25 Oct 2021 16:22:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 37/43] KVM: SVM: Unconditionally mark AVIC as running
 on vCPU load (with APICv)
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Anup Patel <anup.patel@wdc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-38-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211009021236.4122790-38-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/10/21 04:12, Sean Christopherson wrote:
> +	/* TODO: Document why the unblocking path checks for updates. */

Is that a riddle or what? :)

Paolo

> +	if (kvm_vcpu_is_blocking(vcpu) &&
> +	    kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
> +		kvm_vcpu_update_apicv(vcpu);
> +
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			return;
> +	}
> +

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
