Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC989C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:38:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1760FBF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 15:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FE1760FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0EAB4B106;
	Wed, 27 Oct 2021 11:38:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v3UI0cJBOzGH; Wed, 27 Oct 2021 11:38:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5CA4B11E;
	Wed, 27 Oct 2021 11:38:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF8D4B105
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f2castJNNxbj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 11:38:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB1E4B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 11:38:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635349080;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bSqxXsSY7PzPPy6E5Cy05Nx/OdmHcN1STcnBEYyHdIs=;
 b=MbMxbXAupMhsOj7n1ORnzGUbt2FJk9mfhs1WY97br91xQhy2gI1grOuvQnxEp6LE0pzRZZ
 1ueNqOMlSarkjIx3XpEKw+UEb5n1ek2asuexqFwukbmOUCbHmkd+mobwHsmwa1bWXKCwn1
 2CRz2Zv9n8TOyxe7u0sslDWf0CgTm/E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-iugz8AH7OouCC77moaBZ5w-1; Wed, 27 Oct 2021 11:37:58 -0400
X-MC-Unique: iugz8AH7OouCC77moaBZ5w-1
Received: by mail-ed1-f71.google.com with SMTP id
 o22-20020a056402439600b003dd4f228451so2671634edc.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 08:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=bSqxXsSY7PzPPy6E5Cy05Nx/OdmHcN1STcnBEYyHdIs=;
 b=slDkcjT5QnxZjEqjbQWKmPLBZwKvYpssKUt/3sAd5ZA2dnaiUgXiD9kFFe3X7MQKlY
 CmJYkhLYLvUgLh+Xx7iA1zVPM4g+Z9BbCd/fTjFLtliZtqzyFTLbnNa+JmMdwRtcDMx+
 Kul+2B6VgwNe/UrZH1/Id3+EvJQtjS6IqsEB3IPOiWzNUxtTecSPhf1RAwGgEexACvpS
 sRcIbcoyD5bp0SodWYLtolB2/U7uFILXYwM0opvBBV8xX0dEbvkiwDrCFNZY3lgi8ToJ
 kFt8s+B0Rf6JoCdhpfl/fmhoMfmYeU9ShC493gvGoUaRWVUzLGlpN4T+/OHuyH03iltj
 8aPQ==
X-Gm-Message-State: AOAM5303LmAfNkIm9OyA2y1RIMYPKPi6NLceGZXV+/Hrs5ZqYQTtU/nF
 iL33V/QpxkA/L9SnUNr2KpOSwsjoj+hESOx+/Q1FEAuebVtSih/yZKh1oKMY45b3p4UVUBmAoZ1
 gkvlO+ZZMS9PnTFCeAPnt/ei8
X-Received: by 2002:a05:6402:520f:: with SMTP id
 s15mr19650578edd.376.1635349077541; 
 Wed, 27 Oct 2021 08:37:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcV3ajcrSuCCBMr6jO83QbO8KNKYMvLx5Z90JLfoEGGYsQl7acheIlREFbLHWM9uSofWHX3A==
X-Received: by 2002:a05:6402:520f:: with SMTP id
 s15mr19650552edd.376.1635349077353; 
 Wed, 27 Oct 2021 08:37:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id h7sm218074edt.37.2021.10.27.08.37.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Oct 2021 08:37:56 -0700 (PDT)
Message-ID: <5b8f554b-5bbc-e257-12d0-800ec82489d0@redhat.com>
Date: Wed, 27 Oct 2021 17:37:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
 <YXllGfrjPX1pVUx6@google.com>
 <ecec4d7d-13dd-c992-6648-3624d7c14c24@redhat.com>
 <YXlwH2vWILFS9QOG@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXlwH2vWILFS9QOG@google.com>
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

On 27/10/21 17:28, Sean Christopherson wrote:
> On Wed, Oct 27, 2021, Paolo Bonzini wrote:
>> On 27/10/21 16:41, Sean Christopherson wrote:
>>> The other thing I don't like about having the WARN in the loop is that it suggests
>>> that something other than the vCPU can modify the NDST and SN fields, which is
>>> wrong and confusing (for me).
>>
>> Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
>> loop, it can be as simple as
>>
>> 	/* The processor can set ON concurrently.  */
>>
>> when you respin patch 21 and the rest of the series?
> 
> I can definitely add a comment, but I think that comment is incorrect.

It's completely backwards indeed.  I first had "the hardware" and then 
shut down my brain for a second to replace it.

> So something like this?
> 
> 	/* ON can be set concurrently by a different vCPU or by hardware. */

Yes, of course.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
