Return-Path: <SRS0=LlKa=VH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E77C74A30
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jul 2019 17:06:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5299820665
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jul 2019 17:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5299820665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D049B4A4E1;
	Wed, 10 Jul 2019 13:06:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FKdXoS-sFoAP; Wed, 10 Jul 2019 13:06:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B904A52E;
	Wed, 10 Jul 2019 13:06:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5CC4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jul 2019 13:06:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZMVbJnk6yVtJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jul 2019 13:06:35 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A7CD4A4C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jul 2019 13:06:35 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id v19so3028813wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jul 2019 10:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SuU894j2CqbQVv4bnyUW2+R4vG8fuhuKA/J00hF+rLg=;
 b=Ytl+p9rCWmmwz9hzar1pSPhaTFyAksG8czeooElS+WjYZa3MtzCQMQ/bK/WIf3oYbO
 Vv+3kvs3xcgI828XFlp8Oh4+GH0wfKERKNAQ0JYYAs1EfGdpIL8j2ttrhpgbBFuWHjba
 yP5MJVeNnKUwiMNlMl1Ov/dfkfzgWRaVZgDPU1eTRbHVWVE7CaAZmbhNjkLp4aa2Zn6g
 CMWzBsvVZPmkeGmEdFe802NoJYm4cSkXrT6VtjYsPwN5CZCE/KuON9ht0+3Of8nA02bR
 3gjGVS3FyGzph4v0qLwY3/qhTfr33Mp3elKXEyhZxh2joCyjf1YoW5t0kxetnNrbgR6r
 djFQ==
X-Gm-Message-State: APjAAAUeMF1Jgjp2P5S1bfDNXvuQwFmCeHBOoup2Qfi0lnyZXLuFVpIT
 7R4wbCvjzdKE5OTEEN6Flf6XeibKgFk=
X-Google-Smtp-Source: APXvYqxb+rtpI9aVwVTc6cdO7+RFuhsGOwpHABF0Jid8dPtXLKobZgZewcHJIAdGJh1w9sh7/ty/zA==
X-Received: by 2002:a1c:a01a:: with SMTP id j26mr6345399wme.112.1562778394142; 
 Wed, 10 Jul 2019 10:06:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab?
 ([2001:b07:6468:f312:d066:6881:ec69:75ab])
 by smtp.gmail.com with ESMTPSA id b203sm3130748wmd.41.2019.07.10.10.06.33
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Wed, 10 Jul 2019 10:06:33 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To: Andre Przywara <andre.przywara@arm.com>, Alexander Graf <graf@amazon.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
Date: Wed, 10 Jul 2019 19:06:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710180235.25c54b84@donnerap.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On 10/07/19 19:02, Andre Przywara wrote:
>> + * This test verifies whether the emulated PL031 behaves
>> correctly.
> ^^^^^^^^
> 
> While I appreciate the effort and like the fact that this actually
> triggers an SPI, I wonder if this actually belongs into
> kvm-unit-tests. After all this just test a device purely emulated in
> (QEMU) userland, so it's not really KVM related.
> 
> What is the general opinion on this? Don't we care about this
> hair-splitting as long as it helps testing? Do we even want to extend
> kvm-unit-tests coverage to more emulated devices, for instance
> virtio?

I agree that it would belong more in qtest, but tests in not exactly the
right place is better than no tests.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
