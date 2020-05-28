Return-Path: <SRS0=/xnR=7K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA7EC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 10:53:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE0A62088E
	for <kvmarm@archiver.kernel.org>; Thu, 28 May 2020 10:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K4Gmcpu0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE0A62088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AD854B235;
	Thu, 28 May 2020 06:53:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vzwQ3MiQrDNs; Thu, 28 May 2020 06:53:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 660E14B226;
	Thu, 28 May 2020 06:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37A414B21B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 06:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yok2-Q-WOULZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2020 06:53:34 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA654B0FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 06:53:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590663214;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=THROXU06O8NObD/CvI2mO/QZizA3BtE1Fcaww6HOCqQ=;
 b=K4Gmcpu0xt9wVskQeaubx0tdzWUgzog1eatW5IEGnF9WUl2W0kFfODCm/blDYrDzuQPnkN
 45i24GY0bXcjXj943DBWByrFdgfBMl8jvLm6Kw+EcCzbQ3hPnnEUwuMEwiI5V1mX+XZDps
 wHWJXRli/kNrkgjRC99sIcVpm0Sdon0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-Bbwm-2ihMNeAc_Z_lG8hDQ-1; Thu, 28 May 2020 06:53:29 -0400
X-MC-Unique: Bbwm-2ihMNeAc_Z_lG8hDQ-1
Received: by mail-ej1-f72.google.com with SMTP id i19so405615ejk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2020 03:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=THROXU06O8NObD/CvI2mO/QZizA3BtE1Fcaww6HOCqQ=;
 b=SI6aIQjrR4qLq6m1uxzH3+0NvoBVRGS34QiY6HENAUEh57wCbKlmeYodBmRhlH5ij8
 szeptgErUdGL0q/GyHEMfpwU/XUEmvNPNIgYFb4SwGVTXl7WcwDaWj4yudhDN33aOuuu
 wG/8xfnaRE18SD/EUcBiWwf61XJJPzXiaIJck/EvKhwSCfOSZtNmNnQ0U28sMkxkzEtX
 lKTE72UvghAvLFoGPG6eauoIVxgq/iQHBP7ezDHvKTgCBnAOJzzmH2fPQDePEBNaZkmg
 ZW6EzSYxUmk926evVBlVAyQscQc5zqmCUiVS8YZK5bHQhQYR3voIuIB/HcZhkJNXNtgd
 OV+Q==
X-Gm-Message-State: AOAM53136DyQ2WWzRBAwtsVya9gFuNk3agrQktPyyDi0b9qBZddHjUsG
 YXfPLOhb4MIKGcaZYYgoxEKzFmZuNDL06+M4mxDIYexO6mKXKZO2Hn5h6YRqS48iuKWqCvMXX2k
 iv1Jzayni/YC69Ycec8ywkTOs
X-Received: by 2002:aa7:d0cc:: with SMTP id u12mr2450279edo.385.1590663208746; 
 Thu, 28 May 2020 03:53:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxedx2WYnJYMDlOaUBBjXoew4r7E/DhBUsZ1oryjTyqUpxzgiFDrYyuhtNMmnqvf0J2iR/C7g==
X-Received: by 2002:aa7:d0cc:: with SMTP id u12mr2450257edo.385.1590663208543; 
 Thu, 28 May 2020 03:53:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8?
 ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
 by smtp.gmail.com with ESMTPSA id z20sm3835520ejb.68.2020.05.28.03.53.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 May 2020 03:53:28 -0700 (PDT)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8b09c298fab15e2629c65e8ee98a8a29@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59904c11-6965-510f-4848-bc1e91af49fd@redhat.com>
Date: Thu, 28 May 2020 12:53:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8b09c298fab15e2629c65e8ee98a8a29@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjgvMDUvMjAgMDk6MDMsIE1hcmMgWnluZ2llciB3cm90ZToKPiBUaGUgY3VycmVudCBzdGF0
ZSBvZiB0aGUgYXJjaGl0ZWN0dXJlIGRvZXNuJ3Qgc2VlbSB0byBsZWF2ZSBtdWNoIGxlZXdheSBp
bgo+IHRlcm1zIG9mIFNXIGNyZWF0aXZpdHkgaGVyZS4gWW91IGp1c3QgY2FuJ3QgYWxsb2NhdGUg
eW91ciBvd24gSVNTIGVuY29kaW5nCj4gd2l0aG91dCByaXNraW5nIGEgY2xhc2ggd2l0aCBmdXR1
cmUgcmV2aXNpb25zIG9mIHRoZSBhcmNoaXRlY3R1cmUuCj4gSXQgaXNuJ3QgZXZlbiBjbGVhciB3
aGV0aGVyIHRoZSB2YWx1ZSB5b3UgcHV0IHdvdWxkIHN0aWNrIGluIEVTUl9FTDEKPiBpZiBpdCBp
c24ndCBhIHZhbGlkIHZhbHVlIGZvciB0aGlzIENQVSAoc2VlIHRoZSBkZWZpbml0aW9uIG9mICdS
ZXNlcnZlZCcKPiBpbiB0aGUgQVJNIEFSTSkuCj4gCj4gQWxsb2NhdGluZyBzdWNoIGEgc3luZHJv
bWUgd291bGQgcmVxdWlyZSBmcm9tIEFSTToKPiAKPiAtIHRoZSBndWFyYW50ZWUgdGhhdCBubyBl
eGlzdGluZyBpbXBsZW1lbnRhdGlvbiwgaXJyZXNwZWN0aXZlIG9mIHRoZQo+IMKgIGltcGxlbWVu
dGVyLCBjYW4gY29wZSB3aXRoIHRoZSBJU1MgZW5jb2Rpbmcgb2YgeW91ciBjaG9pY2UsCj4gCj4g
LSB0aGUgd3JpdHRlbiBwcm9taXNlIGluIHRoZSBhcmNoaXRlY3R1cmUgdGhhdCBzb21lIEVDL0lT
UyB2YWx1ZXMKPiDCoCBhcmUgcmVzZXJ2ZWQgZm9yIFNXLCBhbmQgdGhhdCBwcm9taXNlIHRvIGFw
cGx5IHJldHJvc3BlY3RpdmVseS4KPiAKPiBUaGlzIGlzIHNvbWV3aGF0IHVubGlrZWx5IHRvIGhh
cHBlbi4KCldlbGwsIHRoYXQncyBhIGV1cGhlbWlzbSBwcm9iYWJseS4gIE9uIHg4NiB3ZSdyZSBz
b21ld2hhdCBsdWNreSB0aGF0CnRoZXJlJ3MgYW4gYXJjaGl0ZWN0dXJhbCB3YXkgZm9yIGluamVj
dGluZyBoeXBlcnZpc29yIHZtZXhpdCBkaXJlY3RseSBpbgp0aGUgZ3Vlc3QsIGFuZCB3ZSBjYW4g
cGlnZ3liYWNrIG9uIHRoYXQgZm9yIGFzeW5jIHBhZ2UgZmF1bHRzICh3aGljaCBhcmUKZXNzZW50
aWFsbHkgc3RhZ2UyIHBhZ2UgZmF1bHRzIHRoYXQgYXJlIHByb2Nlc3NlZCBieSB0aGUgZ3Vlc3Qp
LgoKSXMgaXQgcG9zc2libGUgdG8gcmV1c2UgRUwyIGV4Y2VwdGlvbiBjb2RlcyAvIHN5bmRyb21l
cyBzb21laG93PyAgKEkKaGF2ZW4ndCBjaGVja2VkIGluIHRoZSBBUk0gQVJNIHRoZSBkaWZmZXJl
bmNlcyBiZXR3ZWVuIHRoZSBFTDEgYW5kIEVMMgpzeW5kcm9tZSByZWdpc3RlcnMpLgoKUGFvbG8K
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
