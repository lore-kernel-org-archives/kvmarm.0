Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7468C43603
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7D65246AC
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7D65246AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 000474A59B;
	Fri, 13 Dec 2019 09:23:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fNrKwCRVvZ9C; Fri, 13 Dec 2019 09:23:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E58E54A8E0;
	Fri, 13 Dec 2019 09:23:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1BC4A7FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 09:23:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVElLD0hs20p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 09:23:01 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 121684A944
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 09:23:01 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 28B05E28028A971DDEF3;
 Fri, 13 Dec 2019 22:22:56 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 13 Dec 2019
 22:22:47 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
To: Marc Zyngier <maz@kernel.org>
References: <20191213094237.19627-1-eric.auger@redhat.com>
 <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
 <9e9e3ed65ddf40ab72528187089e0997@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <066e4f57-9f92-2bd6-130a-b3c8bb0dcfc4@huawei.com>
Date: Fri, 13 Dec 2019 22:22:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <9e9e3ed65ddf40ab72528187089e0997@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger.pro@gmail.com
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

SGkgTWFyYywKCk9uIDIwMTkvMTIvMTMgMTk6MjgsIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBa
ZW5naHVpLAo+IAo+IE9uIDIwMTktMTItMTMgMTA6NTMsIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhp
IEVyaWMsCj4+Cj4+IE9uIDIwMTkvMTIvMTMgMTc6NDIsIEVyaWMgQXVnZXIgd3JvdGU6Cj4+PiBT
YXZpbmcvcmVzdG9yaW5nIGFuIHVubWFwcGVkIGNvbGxlY3Rpb24gaXMgYSB2YWxpZCBzY2VuYXJp
by4gRm9yCj4+PiBleGFtcGxlIHRoaXMgaGFwcGVucyBpZiBhIE1BUFRJIGNvbW1hbmQgd2FzIHNl
bnQsIGZlYXR1cmluZyBhbgo+Pj4gdW5tYXBwZWQgY29sbGVjdGlvbi4gQXQgdGhlIG1vbWVudCB0
aGUgQ1RFIGZhaWxzIHRvIGJlIHJlc3RvcmVkLgo+Pj4gT25seSBjb21wYXJlIGFnYWluc3QgdGhl
IG51bWJlciBvZiBvbmxpbmUgdmNwdXMgaWYgdGhlIHJkaXN0Cj4+PiBiYXNlIGlzIHNldC4KPj4K
Pj4gSGF2ZSB5b3UgYWN0dWFsbHkgc2VlbiBhIHByb2JsZW0gYW5kIHRoaXMgcGF0Y2ggZml4ZWQg
aXQ/IFRvIGJlIGhvbmVzdCwKPj4gSSdtIHN1cnByaXNlZCB0byBmaW5kIHRoYXQgd2UgY2FuIG1h
cCBhIExQSSB0byBhbiB1bm1hcHBlZCBjb2xsZWN0aW9uIDspCj4+IChhbmQgcHJldmVudCBpdCB0
byBiZSBkZWxpdmVyZWQgdG8gdmNwdSB3aXRoIGFuIElOVF9VTk1BUFBFRF9JTlRFUlJVUFQKPj4g
ZXJyb3IsIHVudGlsIHNvbWVvbmUgaGFkIGFjdHVhbGx5IG1hcHBlZCB0aGUgY29sbGVjdGlvbiku
Cj4+IEFmdGVyIGEgcXVpY2sgZ2xhbmNlIG9mIHNwZWMgKE1BUFRJKSwganVzdCBhcyB5b3Ugc2Fp
ZCwgdGhpcyBpcyB2YWxpZC4KPiAKPiBZZXMsIHRoaXMgaXMgb25lIG9mIHRoZSAobWFueSkgb2Rk
IGJpdHMgaW4gdGhlIGFyY2hpdGVjdHVyZS4gQW5kIHRoZXJlIGlzCj4gYSBiaXphcnJlIHdvcmRp
bmcgaW4gdGhlIE1BUEMgZGVzY3JpcHRpb24gd2hlbiBWPTA6Cj4gCj4gIkJlaGF2aW9yIGlzIHVu
cHJlZGljdGFibGUgaWYgdGhlcmUgYXJlIGludGVycnVwdHMgdGhhdCBhcmUgbWFwcGVkIHRvIHRo
ZQo+IHNwZWNpZmllZCBjb2xsZWN0aW9uLCB3aXRoIHRoZSByZXN0cmljdGlvbiB0aGF0IGZ1cnRo
ZXIgdHJhbnNsYXRpb24gCj4gcmVxdWVzdHMKPiBmcm9tIHRoYXQgZGV2aWNlIGFyZSBpZ25vcmVk
LiIKPiAKPiBJdCBpcyByZWFsbHkgb2RkIHRoYXQ6Cj4gCj4gLSBpdCBpcyB1bnByZWRpY3RhYmxl
IHRvIHVubWFwIHRoZSBjb2xsZWN0aW9uIHdpdGggbWFwcGVkIGludGVycnVwdHMsCj4gIMKgIGJ1
dCBtYXBwaW5nIGludGVycnVwdHMgdG8gYW4gdW5tYXBwZWQgY29sbGVjdGlvbiBpcyBmaW5lCgpZ
ZXMsIGxvb2tzIG9kZC4uLiBXaXRob3V0IEVyaWMncyBwYXRjaCwgSSB3b24ndCBldmVuIG5vdGlj
ZSBpdC4KCkkgZ3Vlc3MgdGhhdCB1bm1hcHBpbmcgdGhlIGNvbGxlY3Rpb24gd2l0aCBtYXBwZWQg
aW50ZXJydXB0cyB3aWxsIG1ha2UKaXQgZGlmZmljdWx0IGZvciBIYXJkd2FyZSB0byBtYW5hZ2Ug
dGhvc2UgaW50ZXJydXB0cycgaW50ZXJuYWwgc3RhdGVzLApidXQgb25seSBhIGd1ZXNzLgoKPiAt
IHRoZSBub3Rpb24gb2YgImludGVycnVwdHMgZnJvbSB0aGF0IGRldmljZSIgZG9lc24ndCBtYXRj
aCBhbnkgb2YgdGhlCj4gIMKgIE1BUEMgcGFyYW1ldGVycwoKTG9va3MgbGlrZSBhIHdyaXRpbmcg
bWlzdGFrZSwgYSBiZXR0ZXIgc3RhdGVtZW50ICptaWdodCBiZSoKImZ1cnRoZXIgdHJhbnNsYXRp
b24gcmVxdWVzdHMgdGFyZ2V0aW5nIHRoYXQgSUNJRCBhcmUgaWdub3JlZCI/Cgo+IERvIHlvdSBo
YXRlIHRoZSBHSUMgYWxyZWFkeT8gOy0pCgpOb3QgeWV0ISAoSSdkIGxpa2UgdG8gY29udGludWUg
YmVpbmcgbWVzc2VkIHdpdGggR0lDIGFuZCBzZWUgd2hlbiBJCndpbGwgaGF0ZSBpdCA6KQoKPiAK
Pj4gSWYgTWFyYyBoYXMgbm8gb2JqZWN0aW9uIHRvIHRoaXMgZml4LCBwbGVhc2UgYWRkCj4+Cj4+
IFJldmlld2VkLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPiAKPiBUaGFu
a3MgZm9yIHRoYXQsIEkndmUgYXBwbGllZCBpdCB0byB0aGUgcGF0Y2ggYW5kIHdpbGwgcHVzaCBv
dXQKPiB0aGUgdXBkYXRlIGFzIHNvb24gYXMgcmEua2VybmVsLm9yZyBpcyByZWFjaGFibGUgYWdh
aW4uCgpUaGFua3MsClplbmdodWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
