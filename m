Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD5CC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Dec 2021 09:15:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ED784B108;
	Fri,  3 Dec 2021 04:15:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gNG-eA02OEl; Fri,  3 Dec 2021 04:15:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 708314B086;
	Fri,  3 Dec 2021 04:15:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DB04B0F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 04:15:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pu9sfNTu+pZH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 04:15:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32AD24B099
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 04:15:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638522909;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3nc4Ey+X4kWRDPDWq5nVY1VbND+pTe+vz1ZtHVDIYUk=;
 b=Pp6aOdl7hyC8M8F8mZK7cdaXL8g8QxtEBngB3t95P2uey3RfQZCQCuYCytdj5iHAGpdNn0
 60cZALlkFSbtV3N78YcLu4lo0GnrXYDfKwTqz0dP/G/t87JrkJTgnGoUZeVFWjcvuz7Xvp
 AkTWl8apqQBlV4pPCmiGpP1YN3QlR/Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-dsRX-cY2NTufTU8hAhaSIA-1; Fri, 03 Dec 2021 04:15:06 -0500
X-MC-Unique: dsRX-cY2NTufTU8hAhaSIA-1
Received: by mail-wr1-f72.google.com with SMTP id
 x17-20020a5d6511000000b0019838caab88so454918wru.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 01:15:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=3nc4Ey+X4kWRDPDWq5nVY1VbND+pTe+vz1ZtHVDIYUk=;
 b=g/WcwZGZj5A3paItpY74WBCG4mLLkxrLlp6pDrN4lz4+8QJWUadjjX647ajuDGw39i
 rhXVBw1rWVvraXUTytdiupgl/f7I08ge/Q2zlHyvcMCDnO67IebzeLXk+WuQbPeAbvHG
 zE5hhIy7+Cq1KFqIhbK7QLzUxgCdoWMOiIGOGCvxADfixWLWfPKvFkeaPaVgqZnvGOyE
 QJW0Dump627LS5mgI7LDMI56YsbabTIy5ZvITig7p6tTErN/hW+0gDUBgwgc5tcXduDe
 XKo8Aa1H/JvM9SDjsGIzFRe9hM13bHXxjSmaokHPblalFhE3CSANSrV4ArjEX3u0e0a0
 IrPQ==
X-Gm-Message-State: AOAM531TdLLhi+RILeowT9IX+z+PyZawfqISIMjOSZgEl57+aEcKBhpH
 cA4dNS3WyI1wpJyllFpIBNLRNJX1IUgq4SIIE/XMIsm9DdewyApqMCaFXry0ddUrBEROzC6tVyl
 cf6atCTJQYOzj86OMjuKxTeYm
X-Received: by 2002:a05:600c:3b28:: with SMTP id
 m40mr13509604wms.100.1638522905641; 
 Fri, 03 Dec 2021 01:15:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfK/HWbnbruqENFZNdyq5gKB9JqpDKvAJoRTk3unj3UQDU5eHOa7vfR1K5LYIz9ARMuFkAfA==
X-Received: by 2002:a05:600c:3b28:: with SMTP id
 m40mr13509581wms.100.1638522905487; 
 Fri, 03 Dec 2021 01:15:05 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
 by smtp.gmail.com with ESMTPSA id i17sm2157588wmq.48.2021.12.03.01.15.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 03 Dec 2021 01:15:05 -0800 (PST)
Message-ID: <2163c5df-0068-b66d-18d1-3b3cf72aa805@redhat.com>
Date: Fri, 3 Dec 2021 10:15:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v9 4/9] lib: add isaac prng library from
 CCAN
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
 pbonzini@redhat.com, drjones@redhat.com
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211202115352.951548-5-alex.bennee@linaro.org>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211202115352.951548-5-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, christoffer.dall@arm.com,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 "Timothy B . Terriberry" <tterribe@xiph.org>
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

T24gMDIvMTIvMjAyMSAxMi41MywgQWxleCBCZW5uw6llIHdyb3RlOgo+IEl0J3Mgb2Z0ZW4gdXNl
ZnVsIHRvIGludHJvZHVjZSBzb21lIHNvcnQgb2YgcmFuZG9tIHZhcmlhdGlvbiB3aGVuCj4gdGVz
dGluZyBzZXZlcmFsIHJhY2luZyBDUFUgY29uZGl0aW9ucy4gSW5zdGVhZCBvZiBlYWNoIHRlc3Qg
aW1wbGVtZW50aW5nCj4gc29tZSBoYWxmLWFyc2VkIFBSTkcgYnJpbmcgaW4gYSBhIGRlY2VudCBv
bmUgd2hpY2ggaGFzIGdvb2Qgc3RhdGlzdGljYWwKPiByYW5kb21uZXNzLiBPYnZpb3VzbHkgaXQg
aXMgZGV0ZXJtaW5pc3RpYyBmb3IgYSBnaXZlbiBzZWVkIHZhbHVlIHdoaWNoCj4gaXMgbGlrZWx5
IHRoZSBiZWhhdmlvdXIgeW91IHdhbnQuCj4gCj4gSSd2ZSBwdWxsZWQgaW4gdGhlIElTQUFDIGxp
YnJhcnkgZnJvbSBDQ0FOOgo+IAo+ICAgICAgaHR0cDovL2Njb2RlYXJjaGl2ZS5uZXQvaW5mby9p
c2FhYy5odG1sCj4gCj4gSSBzaGF2ZWQgb2ZmIHRoZSBmbG9hdCByZWxhdGVkIHN0dWZmIHdoaWNo
IGlzIGxlc3MgdXNlZnVsIGZvciB1bml0Cj4gdGVzdGluZyBhbmQgcmUtaW5kZW50ZWQgdG8gZml0
IHRoZSBzdHlsZS4gVGhlIG9yaWdpbmFsIGxpY2Vuc2Ugd2FzCj4gQ0MwIChQdWJsaWMgRG9tYWlu
KSB3aGljaCBpcyBjb21wYXRpYmxlIHdpdGggdGhlIExHUEwgdjIgb2YKPiBrdm0tdW5pdC10ZXN0
cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5v
cmc+Cj4gQ0M6IFRpbW90aHkgQi4gVGVycmliZXJyeSA8dHRlcnJpYmVAeGlwaC5vcmc+Cj4gQWNr
ZWQtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPgo+IE1lc3NhZ2UtSWQ6IDwy
MDIxMTExODE4NDY1MC42NjE1NzUtNi1hbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+IC0tLQo+ICAg
YXJtL01ha2VmaWxlLmNvbW1vbiB8ICAgMSArCj4gICBsaWIvcHJuZy5oICAgICAgICAgIHwgIDgy
ICsrKysrKysrKysrKysrKysrKysrKysKPiAgIGxpYi9wcm5nLmMgICAgICAgICAgfCAxNjIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiAgIDMgZmlsZXMgY2hh
bmdlZCwgMjQ1IGluc2VydGlvbnMoKykKPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIvcHJuZy5o
Cj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgbGliL3BybmcuYwpBY2tlZC1ieTogVGhvbWFzIEh1dGgg
PHRodXRoQHJlZGhhdC5jb20+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
