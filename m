Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB9CC43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:42:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E214C595;
	Thu, 14 Jul 2022 11:42:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2SEixgF9WM-y; Thu, 14 Jul 2022 11:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CE74C251;
	Thu, 14 Jul 2022 11:42:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0124C251
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:42:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QpV40rlVJs06 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:42:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F11544C21C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:42:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657813346;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VOgvUYIncXWnFhKR1hAi50QlDyggks7WiA8ZUF17MI0=;
 b=fg9Up3dG5BJ1rBLTfg42pxeIH9RhD5efYv7NVENMK3zOs3Cf/ibQ3VpTheIsbc4qr132GP
 XfYmmGzXhKxMQdxftaM7hzqv9j+DztAyLD4Bxv3MvZ2nrDEQQcSCcIuhXNDhjux03p3YFN
 dK9fZOaxWVNqdiQmyn4naGlB4CT0j0A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-qBX2xSaFOPSIyYYqruEUtw-1; Thu, 14 Jul 2022 11:42:25 -0400
X-MC-Unique: qBX2xSaFOPSIyYYqruEUtw-1
Received: by mail-ed1-f72.google.com with SMTP id
 y21-20020a056402359500b0043adf65d1a0so1732684edc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 08:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=VOgvUYIncXWnFhKR1hAi50QlDyggks7WiA8ZUF17MI0=;
 b=dRHXjE2+eowPKST1/1hhHg2qdJUhjee+HXsS/1zw6H2pVuQCCEnyyFEwBXS0C2U+tK
 NoLunO8KoKNQduHREwOVnEvY/MAo6/Sc2ltKq/pcKX/iFWs+qbE3VH+Ir6D5HucFcR5C
 BZPV6iQLq98EkzwqN8k2Dy6TlhN/P20qE/G55h/MVDm31RZUXnFN853dC2BgA8x/P+bX
 joVlBKFNDvgj5B78zbOpF3FUJ/6mRW23WBg0A5e8rhb45ZdxB1p0g60TbS+WZ9vfAQhO
 aZyqXl92/efwqbNOpCajxL8VhKftmmmwRVuRM+ipQNrngUczSK7KwmnXziHJhSBR9D9n
 0qXQ==
X-Gm-Message-State: AJIora/oA+BmXpfeOCT/oJ0NGuUcmmrCtCUbxsfRJJm+b1BJC2ViFxlH
 rjMxIBvVLHpL/ITLVWDXfAD/In/P26JHeRPzM/EyQJgcE8ykISSjFt2QJcg/7mZZpsjcNUXhF6i
 NZcMdnGy9Go33ao0gKA0vwzR2
X-Received: by 2002:aa7:d155:0:b0:43a:bc8d:8d75 with SMTP id
 r21-20020aa7d155000000b0043abc8d8d75mr13060085edo.322.1657813344365; 
 Thu, 14 Jul 2022 08:42:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s7gve3iab4X/ADupNn/dQIy8nWtHC/Qs9AINATQpnZItpmwgA4FIBPCDi8iL7P+4KWrXVlCg==
X-Received: by 2002:aa7:d155:0:b0:43a:bc8d:8d75 with SMTP id
 r21-20020aa7d155000000b0043abc8d8d75mr13060048edo.322.1657813344150; 
 Thu, 14 Jul 2022 08:42:24 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 v6-20020aa7d806000000b0043a754d53e5sm1231016edq.78.2022.07.14.08.42.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 14 Jul 2022 08:42:23 -0700 (PDT)
Message-ID: <a2ade925-89db-5d05-ba44-e3b77125032e@redhat.com>
Date: Thu, 14 Jul 2022 17:42:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
To: Sean Christopherson <seanjc@google.com>
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
 <YtA3s0VRj3x7vO7B@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtA3s0VRj3x7vO7B@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 mathieu.desnoyers@efficios.com, linux-kselftest@vger.kernel.org,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 7/14/22 17:35, Sean Christopherson wrote:
>> Can you check that smp_rmb() and smp_wmb() generate correct instructions on
>> arm64?
> 
> That seems like the most likely scenario (or a kernel bug), I distinctly remember
> the barriers provided by tools/ being rather bizarre.

Maybe we should bite the bait and use C11 atomics in tools/.  I've long 
planned an article "C11 atomics for kernel programmers", especially 
because this will also be an issue when Rust gets into the mix...

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
