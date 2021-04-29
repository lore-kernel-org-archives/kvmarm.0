Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529FAC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 10:45:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A61761418
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 10:45:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A61761418
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F684B341;
	Thu, 29 Apr 2021 06:45:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C8eZEYxJ0XhU; Thu, 29 Apr 2021 06:45:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 343B84B343;
	Thu, 29 Apr 2021 06:45:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F1664B331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 06:23:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Erf2axUwMfAU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 06:23:00 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A9CA4B2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 06:23:00 -0400 (EDT)
Received: from dggeml765-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FWBN64d9gzYc5p;
 Thu, 29 Apr 2021 18:20:38 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggeml765-chm.china.huawei.com (10.1.199.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 29 Apr 2021 18:22:56 +0800
Received: from [10.174.177.244] (10.174.177.244) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Apr 2021 18:22:55 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>
References: <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
 <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
Date: Thu, 29 Apr 2021 18:22:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YIpY8TXCSc7Lfa2Z@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 29 Apr 2021 06:45:06 -0400
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will
 Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Ck9uIDIwMjEvNC8yOSAxNDo1NywgTWlrZSBSYXBvcG9ydCB3cm90ZToKCj4+PiBEbyB5b3UgdXNl
IFNQQVJTTUVNPyBJZiB5ZXMsIHdoYXQgaXMgeW91ciBzZWN0aW9uIHNpemU/Cj4+PiBXaGF0IGlz
IHRoZSB2YWx1ZSBpZiBDT05GSUdfRk9SQ0VfTUFYX1pPTkVPUkRFUiBpbiB5b3VyIGNvbmZpZ3Vy
YXRpb24/Cj4+IFllcywKPj4KPj4gQ09ORklHX1NQQVJTRU1FTT15Cj4+Cj4+IENPTkZJR19TUEFS
U0VNRU1fU1RBVElDPXkKPj4KPj4gQ09ORklHX0ZPUkNFX01BWF9aT05FT1JERVIgPSAxMQo+Pgo+
PiBDT05GSUdfUEFHRV9PRkZTRVQ9MHhDMDAwMDAwMAo+PiBDT05GSUdfSEFWRV9BUkNIX1BGTl9W
QUxJRD15Cj4+IENPTkZJR19ISUdITUVNPXkKPj4gI2RlZmluZSBTRUNUSU9OX1NJWkVfQklUUyAg
ICAyNgo+PiAjZGVmaW5lIE1BWF9QSFlTQUREUl9CSVRTICAgIDMyCj4+ICNkZWZpbmUgTUFYX1BI
WVNNRU1fQklUUyAgICAgMzIKCgpXaXRoIHRoZSBwYXRjaCzCoCB0aGUgYWRkciBpcyBhbGlnbmVk
LCBidXQgdGhlIHBhbmljIHN0aWxsIG9jY3VycmVkLAoKbmV3IGZyZWUgbWVtb3J5IGxvZyBpcyBi
ZWxvdywKCm1lbWJsb2NrX2ZyZWU6IFsweGFmNDMwMDAwLTB4YWY0NGZmZmZdIG1lbV9pbml0KzB4
MTU4LzB4MjNjCgptZW1ibG9ja19mcmVlOiBbMHhhZjUxMDAwMC0weGFmNTNmZmZmXSBtZW1faW5p
dCsweDE1OC8weDIzYwptZW1ibG9ja19mcmVlOiBbMHhhZjU2MDAwMC0weGFmNTdmZmZmXSBtZW1f
aW5pdCsweDE1OC8weDIzYwptZW1ibG9ja19mcmVlOiBbMHhhZmQ5ODAwMC0weGFmZGM3ZmZmXSBt
ZW1faW5pdCsweDE1OC8weDIzYwptZW1ibG9ja19mcmVlOiBbMHhhZmRkODAwMC0weGFmZGZmZmZm
XSBtZW1faW5pdCsweDE1OC8weDIzYwptZW1ibG9ja19mcmVlOiBbMHhhZmUxODAwMC0weGFmZTdm
ZmZmXSBtZW1faW5pdCsweDE1OC8weDIzYwptZW1ibG9ja19mcmVlOiBbMHhhZmVlMDAwMC0weGFm
ZWZmZmZmXSBtZW1faW5pdCsweDE1OC8weDIzYwpfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAw
eDgwYTAzMDAwIC0gMHg4MGEwNDAwMCwgcGZuOiA4MGEwMyAtIDgwYTA0Cl9fZnJlZV9tZW1vcnlf
Y29yZSwgcmFuZ2U6IDB4ODBhMDgwMDAgLSAweDgwYjAwMDAwLCBwZm46IDgwYTA4IC0gODBiMDAK
X19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHg4MTJlODA1OCAtIDB4ODMwMDAwMDAsIHBmbjog
ODEyZTkgLSA4MzAwMApfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweDg1MDAwMDAwIC0gMHg4
NTYwMDAwMCwgcGZuOiA4NTAwMCAtIDg1NjAwCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4
ODZhMDAwMDAgLSAweDg3ZTAwMDAwLCBwZm46IDg2YTAwIC0gODdlMDAKX19mcmVlX21lbW9yeV9j
b3JlLCByYW5nZTogMHg4YmQwMDAwMCAtIDB4OGM1MDAwMDAsIHBmbjogOGJkMDAgLSA4YzUwMApf
X2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweDhlMzAwMDAwIC0gMHg4ZWQwMDAwMCwgcGZuOiA4
ZTMwMCAtIDhlZDAwCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4OTBkMDAwMDAgLSAweGFm
MmMwMDAwLCBwZm46IDkwZDAwIC0gYWYyYzAKX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhh
ZjQzMDAwMCAtIDB4YWY0NTAwMDAsIHBmbjogYWY0MzAgLSBhZjQ1MApfX2ZyZWVfbWVtb3J5X2Nv
cmUsIHJhbmdlOiAweGFmNTEwMDAwIC0gMHhhZjU0MDAwMCwgcGZuOiBhZjUxMCAtIGFmNTQwCl9f
ZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWY1NjAwMDAgLSAweGFmNTgwMDAwLCBwZm46IGFm
NTYwIC0gYWY1ODAKX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmQ5ODAwMCAtIDB4YWZk
YzgwMDAsIHBmbjogYWZkOTggLSBhZmRjOApfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFm
ZGQ4MDAwIC0gMHhhZmUwMDAwMCwgcGZuOiBhZmRkOCAtIGFmZTAwCl9fZnJlZV9tZW1vcnlfY29y
ZSwgcmFuZ2U6IDB4YWZlMTgwMDAgLSAweGFmZTgwMDAwLCBwZm46IGFmZTE4IC0gYWZlODAKX19m
cmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmVlMDAwMCAtIDB4YWZmMDAwMDAsIHBmbjogYWZl
ZTAgLSBhZmYwMApfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmZjgwMDAwIC0gMHhhZmY4
ZDAwMCwgcGZuOiBhZmY4MCAtIGFmZjhkCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZm
ZjIwMDAgLSAweGFmZmY0NTgwLCBwZm46IGFmZmYyIC0gYWZmZjQKX19mcmVlX21lbW9yeV9jb3Jl
LCByYW5nZTogMHhhZmZmZTAwMCAtIDB4YWZmZmUwZTAsIHBmbjogYWZmZmUgLSBhZmZmZQpfX2Zy
ZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmZmZlNGZjIC0gMHhhZmZmZTUwMCwgcGZuOiBhZmZm
ZiAtIGFmZmZlCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZmZmU2ZTQgLSAweGFmZmZl
NzAwLCBwZm46IGFmZmZmIC0gYWZmZmUKX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZm
ZThkYyAtIDB4YWZmZmU4ZTAsIHBmbjogYWZmZmYgLSBhZmZmZQpfX2ZyZWVfbWVtb3J5X2NvcmUs
IHJhbmdlOiAweGFmZmZlOTcwIC0gMHhhZmZmZTk4MCwgcGZuOiBhZmZmZiAtIGFmZmZlCl9fZnJl
ZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZmZmU5OTAgLSAweGFmZmZlOWEwLCBwZm46IGFmZmZm
IC0gYWZmZmUKX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmZTlhNCAtIDB4YWZmZmU5
YzAsIHBmbjogYWZmZmYgLSBhZmZmZQpfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmZmZl
YjU0IC0gMHhhZmZmZWI2MCwgcGZuOiBhZmZmZiAtIGFmZmZlCl9fZnJlZV9tZW1vcnlfY29yZSwg
cmFuZ2U6IDB4YWZmZmVjZjQgLSAweGFmZmZlZDAwLCBwZm46IGFmZmZmIC0gYWZmZmUKX19mcmVl
X21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmZWZjNCAtIDB4YWZmZmVmZDgsIHBmbjogYWZmZmYg
LSBhZmZmZQpfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGIwMjAwMDAwIC0gMHhjMDAwMDAw
MCwgcGZuOiBiMDIwMCAtIGIwMjAwCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4Y2MwMDAw
MDAgLSAweGRjYTAwMDAwLCBwZm46IGNjMDAwIC0gYjAyMDAKX19mcmVlX21lbW9yeV9jb3JlLCBy
YW5nZTogMHhkZTcwMDAwMCAtIDB4ZGVhMDAwMDAsIHBmbjogZGU3MDAgLSBiMDIwMApfX2ZyZWVf
bWVtb3J5X2NvcmUsIHJhbmdlOiAweGUwODAwMDAwIC0gMHhlMGMwMDAwMCwgcGZuOiBlMDgwMCAt
IGIwMjAwCl9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4ZjRiMDAwMDAgLSAweGY3MDAwMDAw
LCBwZm46IGY0YjAwIC0gYjAyMDAKX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhmZGEwMDAw
MCAtIDB4ZmZmZmZmZmYsIHBmbjogZmRhMDAgLSBiMDIwMAo+IEl0IHNlZW1zIHRoYXQgd2l0aCBT
UEFSU0VNRU0gd2UgZG9uJ3QgYWxpZ24gdGhlIGZyZWVkIHBhcnRzIG9uIHBhZ2VibG9jawo+IGJv
dW5kYXJpZXMuCj4KPiBDYW4geW91IHRyeSB0aGUgcGF0Y2ggYmVsb3c6Cj4KPiBkaWZmIC0tZ2l0
IGEvbW0vbWVtYmxvY2suYyBiL21tL21lbWJsb2NrLmMKPiBpbmRleCBhZmFlZmE4ZmM2YWIuLjE5
MjYzNjliNTJlYyAxMDA2NDQKPiAtLS0gYS9tbS9tZW1ibG9jay5jCj4gKysrIGIvbW0vbWVtYmxv
Y2suYwo+IEBAIC0xOTQxLDE0ICsxOTQxLDEzIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBmcmVlX3Vu
dXNlZF9tZW1tYXAodm9pZCkKPiAgIAkJICogZHVlIHRvIFNQQVJTRU1FTSBzZWN0aW9ucyB3aGlj
aCBhcmVuJ3QgcHJlc2VudC4KPiAgIAkJICovCj4gICAJCXN0YXJ0ID0gbWluKHN0YXJ0LCBBTElH
TihwcmV2X2VuZCwgUEFHRVNfUEVSX1NFQ1RJT04pKTsKPiAtI2Vsc2UKPiArI2VuZGlmCj4gICAJ
CS8qCj4gICAJCSAqIEFsaWduIGRvd24gaGVyZSBzaW5jZSB0aGUgVk0gc3Vic3lzdGVtIGluc2lz
dHMgdGhhdCB0aGUKPiAgIAkJICogbWVtbWFwIGVudHJpZXMgYXJlIHZhbGlkIGZyb20gdGhlIGJh
bmsgc3RhcnQgYWxpZ25lZCB0bwo+ICAgCQkgKiBNQVhfT1JERVJfTlJfUEFHRVMuCj4gICAJCSAq
Lwo+ICAgCQlzdGFydCA9IHJvdW5kX2Rvd24oc3RhcnQsIE1BWF9PUkRFUl9OUl9QQUdFUyk7Cj4g
LSNlbmRpZgo+ICAgCj4gICAJCS8qCj4gICAJCSAqIElmIHdlIGhhZCBhIHByZXZpb3VzIGJhbmss
IGFuZCB0aGVyZSBpcyBhIHNwYWNlCj4gICAKPgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
