Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B716CC433C1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:41:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B86D3619BD
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 09:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86D3619BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA3F4B40B;
	Wed, 31 Mar 2021 05:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JqdnVaUuZHT7; Wed, 31 Mar 2021 05:41:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D563B4B40D;
	Wed, 31 Mar 2021 05:41:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7953E4B3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyPouQH5YJmi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 05:41:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9932D4B38F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 05:41:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617183670;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
 b=RI1K6Fssqt7hUlhyzbMKI4QBb13TuCj0sR1qxdT2zpsJX5eEBTwH41nrGg66jFIFLks5cj
 wCA6xSTfgSkES/2Pm4VJzUOZgswA9oFGBYwpb5jxIlH51xia4Lg1awqDbGr1lQIba67LE1
 H3Cr9eOiXaYTJa6fel6vf9JWsjenQoY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-QvUkYT_pPPSM7J-rXrPY1w-1; Wed, 31 Mar 2021 05:41:08 -0400
X-MC-Unique: QvUkYT_pPPSM7J-rXrPY1w-1
Received: by mail-ej1-f69.google.com with SMTP id k16so541356ejg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 02:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
 b=RxirGsRxPNqYy4xsro8BpYrbVrYvLFhKE7l/SI3q36CBbLEls9OiGXIIPtZQhezC8G
 l8K1NSMxjD3ddTgV6iwDqwzCfiOY4FnJ1yPUbb3jCNKawDBErzbSXBySNQZR5fOtYF1U
 i9LgcAzRNrOm+qSfeezXPbSsklplgICv7hCPpMnQFa815FdzQ+BAwiyM76kqS8Z/XZaq
 7l3jeWK6pwSPnSVjO8m6tPBFeiidN8C8O+vkdqPukRWKJ5nq9W+ThdkZR7zyIx2dXZVf
 CpdtzDNqJ3zrqtRTbTdARx9TJERDySmlxIONs8BKCV1k93zfV7PdRTOoeY3gxpCVJxfR
 WdGA==
X-Gm-Message-State: AOAM532XUURaeSeMp50RPfuy+CP1ceXGx5LmqZtqUM2cyDJe3gMb+6yu
 UBpKsh2w1kupqc2ug7xKLf1gedyCjWTWWmwxefpFk6RHTV/kler7Z7CNEIco5KJMh8x6zh2Lf9r
 wMqKUO6kJGGIF8ddmHGXCznNH
X-Received: by 2002:a17:906:2bc3:: with SMTP id
 n3mr2580939ejg.418.1617183667290; 
 Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSsS0Tsx00ZWZ0/lu50AT1LbGXR9x8m5wdROjQWRD+Wcg6SCBEWtjgSLJ9LavhsubZOMOLAQ==
X-Received: by 2002:a17:906:2bc3:: with SMTP id
 n3mr2580906ejg.418.1617183667053; 
 Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id t15sm1151761edc.34.2021.03.31.02.41.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 02:41:05 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To: Marc Zyngier <maz@kernel.org>
References: <20210326021957.1424875-1-seanjc@google.com>
 <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
 <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569a089e-471f-8182-cdb2-74188f0cc81d@redhat.com>
Date: Wed, 31 Mar 2021 11:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMzEvMDMvMjEgMTE6MzQsIE1hcmMgWnluZ2llciB3cm90ZToKPiAKPj4gUXVldWVkIGFuZCAx
LTkgYW5kIDE4LCB0aGFua3MuwqAgVGhlcmUncyBhIHNtYWxsIGlzc3VlIGluIHBhdGNoIDEwIHRo
YXQKPj4gcHJldmVudGVkIG1lIGZyb20gY29tbWl0dGluZyAxMC0xNSwgYnV0IHRoZXkgbW9zdGx5
IGxvb2sgZ29vZC4KPiAKPiBDYW4geW91IHBsZWFzZSBwdXNoIHRoZSByZXN1bHRpbmcgbWVyZ2Ug
c29tZXdoZXJlPwo+IAo+IEknbSBjb25jZXJuZWQgdGhhdCBpdCB3aWxsIGNvbmZsaWN0IGluIGlu
dGVyZXN0aW5nIHdheSB3aXRoIG90aGVyIHN0dWZmCj4gdGhhdCBpcyBvbiBpdHMgd2F5IG9uIHRo
ZSBhcm02NCBzaWRlLCBub3QgdG8gbWVudGlvYm4gdGhhdCB0aGlzIGhhc24ndAo+IGJlZW4gdGVz
dGVkIGF0IGFsbCBvbiBhbnl0aGluZyBidXQgeDg2IChhbmQgZ2l2ZW4gdGhlIHNlcmllcyB3YXMg
cG9zdGVkCj4gb24gRnJpZGF5LCB0aGF0J3MgYSBiaXQgb2YgYSBzaG9ydCBub3RpY2UpLgoKWWVz
LCBJIHdpbGwgcHVzaCBpdCBzaG9ydGx5IHRvIGt2bS9xdWV1ZS4gIE5vdGUgdGhhdCB0aGUgcGF0
Y2hlcyBJIGhhdmUgCnB1c2hlZCBhcmUgeDg2IG9ubHkgYXBhcnQgZnJvbSBjaGFuZ2VzIHRvIHRy
YWNlcG9pbnRzLiAgVGhlIHJlc3Qgd2lsbCAKY2VydGFpbmx5IG5lZWQgYSBsb3QgbW9yZSBiYWtp
bmcsIHdoaWNoIGlzIGFsc28gd2h5IEkgZ290IHJpZCBxdWlja2x5IG9mIAp0aGUgZWFzeSBvbmVz
LgoKUGFvbG8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
