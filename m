Return-Path: <SRS0=Qc2f=YI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B573AECE59D
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 22:36:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D65E2067B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 22:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DwvqdxmA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D65E2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97D314A9BF;
	Tue, 15 Oct 2019 18:36:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oUaTkVHJouE7; Tue, 15 Oct 2019 18:36:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A26784A98A;
	Tue, 15 Oct 2019 18:36:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C13A4A98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 18:36:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id esWRSYl2OLsD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 18:36:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B258B4A8CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 18:36:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571179006;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=wSh+n+8u5QLmMxe2hYGq+Rqu0J/BQ5npWNcVhzyY+e4=;
 b=DwvqdxmAIq1tPxrBzakC8cnsu57armpiMvMNOhTjTXk6TIaODHzknS9tMnRxJ6vMwHs/zo
 sewvryoICqcsFJL+Dmzg/tIBEKQ3GhURgSnk4MffH/QeIIwsDT4AjD6rb36ythNby5d9mt
 2vBa42qMEAsMjnWko56GmI6Gd4lEO7o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-nEWh97BWMBSLeRCwOcUzuA-1; Tue, 15 Oct 2019 18:36:44 -0400
Received: by mail-wr1-f72.google.com with SMTP id j2so1845844wrg.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 15:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=lwwAcBIi9gz4rDVsHFX2Q7ZJ02GG7jdgtvkZrgQZWFY=;
 b=Q8bsDzQNW0cXvxwg/fN8pMecYxYRY5SXqT2Cbd5vdvydTmYA/hQWJFfdbncBeuPcLt
 kho2z048B/KT/MsfRyU4uTpOwK1D+h+vrz2zrjAQHWoHv4+nz049QZGoBJJqy2kqysq6
 4D5DZQuYjr2JqQig97hLeQRyKi8/l1YtKrg94/WRsQRx16PL+bneZHBb23JnUJXFG5hr
 HSGvFDJnRf6wH4KAFkCES8w/y1FKxlA55JsJT1XUW3Rs0SOTxW+QTrkfc7QrJb98z9yk
 2jO+S4+9rbJ3Ntt4hdISUfpb6rUXzRftA/AF/qh/1hs1qV6cSAF2pMh6SzaHkfMvlNbM
 o/Og==
X-Gm-Message-State: APjAAAUquvWYXrN46+lGgROgTLzpTnrlOARlyxcaO18roxrNl6tyewrx
 cEpS9crpFE9VlkpH2fZXCrlYbPYuFUBpEkcmfSKx0rUzlyUo+w5VtqnDO4UGKcCfIonJKi7N6pN
 zdWeAjbqVxafYdk+1gVBW28A8
X-Received: by 2002:a05:600c:3cb:: with SMTP id
 z11mr537737wmd.134.1571179003422; 
 Tue, 15 Oct 2019 15:36:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyR41EszL4/UT/53Ec9vQZG6o/Omkzfs8QOJ0pfXMxxw7MFiXPeS9FywecPK4MHNGK9zwKlCQ==
X-Received: by 2002:a05:600c:3cb:: with SMTP id
 z11mr537711wmd.134.1571179003137; 
 Tue, 15 Oct 2019 15:36:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id c18sm20828908wrv.10.2019.10.15.15.36.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Oct 2019 15:36:42 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
To: Thomas Gleixner <tglx@linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
 <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aa1ec910-b7b6-2568-4583-5fa47aac367f@redhat.com>
Date: Wed, 16 Oct 2019 00:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: nEWh97BWMBSLeRCwOcUzuA-1
X-Mimecast-Spam-Score: 0
Cc: justin.he@arm.com, kvm@vger.kernel.org, maz@kernel.org,
 richardcochran@gmail.com, Jianyong Wu <jianyong.wu@arm.com>,
 linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
 yangbo.lu@nxp.com, john.stultz@linaro.org, netdev@vger.kernel.org, nd@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On 15/10/19 22:13, Thomas Gleixner wrote:
> On Tue, 15 Oct 2019, Paolo Bonzini wrote:
>> On 15/10/19 12:48, Jianyong Wu wrote:
>>>  
>>>
>>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> You're sure about having reviewed that in detail?

I did review the patch; the void* ugliness is not in this one, and I do
have some other qualms on that one.

> This changelog is telling absolutely nothing WHY anything outside of the
> timekeeping core code needs access to the current clocksource. Neither does
> it tell why it is safe to provide the pointer to random callers.

Agreed on the changelog, but the pointer to a clocksource is already
part of the timekeeping external API via struct system_counterval_t.
get_device_system_crosststamp for example expects a clocksource pointer
but provides no way to get such a pointer.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
