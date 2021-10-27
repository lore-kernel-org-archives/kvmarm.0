Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803CBC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:57:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E70BF60724
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 14:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E70BF60724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67FFD4B172;
	Wed, 27 Oct 2021 10:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D-9Alsn-G0PC; Wed, 27 Oct 2021 10:57:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D3394B183;
	Wed, 27 Oct 2021 10:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 428464B121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tINoOjQd7qvE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 10:57:09 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4088B4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 10:57:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635346629;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1kiv1BZf6xFogujw6ml5Mx2cj+xKDQFeYDEEPX1GMOs=;
 b=A/5DhUG7viz9Q20XNQp3R6VBeocsmcHHxyZnXNKlXb2LeOhxQD3FBuD/IHfg64yyzpTE88
 Yd8E9nyDnQNDrL+TNML6kaLLWBbIi9CoNgujO3/B3q1sUlM+l6HfFeY3ZfaIrwEUtixyJM
 rsyKtuYm24TO6HmYojVtsAYztUdbfaM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-5Dimra96PXuPKvU3ewk6Qg-1; Wed, 27 Oct 2021 10:57:07 -0400
X-MC-Unique: 5Dimra96PXuPKvU3ewk6Qg-1
Received: by mail-ed1-f72.google.com with SMTP id
 h16-20020a05640250d000b003dd8167857aso2631179edb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 07:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1kiv1BZf6xFogujw6ml5Mx2cj+xKDQFeYDEEPX1GMOs=;
 b=3wxxo2QNOwEPdy0b9+//REUAR1hWTy2YwfnD5S8mkJ7eQGriH+Hv128v+9igYaDyud
 jbKyvuVz/y6qkr0vJX3ANzjGS8Fm+EFm9Rz5GUKl30dzOwC47NZ/DnSm9X9iDkQ8kp5y
 A/TuOaa3nftNKQJoIk/jGaugJ1KEJmjjFGP/gNPh9S44r/89cf2jkH4Qkz6rdy/reejS
 I+yFeVCHJsOLDLKxrnHNJwgWdNt9BNToKFBtWQzCeg6oqeUvLK8nortXIrPSHepda5l/
 j7FMbTD8BHgBVN2lAvNM6jayJTIo2TGkAjMw9MadDKCUxevIJjeQ2RoJFH0g3Ucx7Hir
 IsJA==
X-Gm-Message-State: AOAM533Xwd+W9PvJiLsx2MoJxObThBqOuAUC+zt07U0ra10XYODptj07
 CHVELMRrYmpze7hiiSW1cTnPoSfV9EC7SdgzxQ2py0Df6SUHVfRT7R7uxIl1xzmnYRLB7ao9/eu
 xabPClHSjsvqPtVuS9u8iyBzf
X-Received: by 2002:a17:907:7d94:: with SMTP id
 oz20mr38999419ejc.98.1635346626741; 
 Wed, 27 Oct 2021 07:57:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytn7bu+kBLh9LVQ/1pex7gMJDdz0Rr/buTYBO2a2VZJzJDbs6skZyshVLbERw1F1K5YyM70Q==
X-Received: by 2002:a17:907:7d94:: with SMTP id
 oz20mr38999381ejc.98.1635346626512; 
 Wed, 27 Oct 2021 07:57:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id t15sm67707ejx.75.2021.10.27.07.57.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Oct 2021 07:57:05 -0700 (PDT)
Message-ID: <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
Date: Wed, 27 Oct 2021 16:57:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
 <YXllGfrjPX1pVUx6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXllGfrjPX1pVUx6@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On 27/10/21 16:41, Sean Christopherson wrote:
> The other thing I don't like about having the WARN in the loop is that it suggests
> that something other than the vCPU can modify the NDST and SN fields, which is
> wrong and confusing (for me).

Yeah, I can agree with that.  Can you add it in a comment above the 
cmpxchg loop, it can be as simple as

	/* The processor can set ON concurrently.  */

when you respin patch 21 and the rest of the series?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
