Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14256C433E2
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:30:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A509D206E6
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 12:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A509D206E6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15AB54B3C8;
	Mon,  6 Jul 2020 08:30:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id shnqT11O2qjz; Mon,  6 Jul 2020 08:30:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C401F4B3D5;
	Mon,  6 Jul 2020 08:30:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4A44B3BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:30:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sn+kvL94RrqC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 08:30:53 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3630C4B3BA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 08:30:53 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 15E6C3BD7E845298C6D7;
 Mon,  6 Jul 2020 20:23:29 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 6 Jul 2020
 20:23:22 +0800
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To: Auger Eric <eric.auger@redhat.com>, <drjones@redhat.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
 <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
 <5a43242d-2c0b-d8d1-b12d-7436e7d03e52@huawei.com>
 <a4bcb265-90c9-d5f3-c353-85f876cd5472@redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <538f9053-a433-b85e-ee3a-93a5e2b7af8c@huawei.com>
Date: Mon, 6 Jul 2020 20:23:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a4bcb265-90c9-d5f3-c353-85f876cd5472@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

SGkgRXJpYywKCk9uIDcvMy8yMDIwIDM6NDUgUE0sIEF1Z2VyIEVyaWMgd3JvdGU6Cj4gSGkgSmlu
Z3lpLAo+IAo+IE9uIDcvMy8yMCA5OjQxIEFNLCBKaW5neWkgV2FuZyB3cm90ZToKPj4gSGkgRXJp
YywgRHJldywKPj4KPj4gT24gNy8yLzIwMjAgOTozNiBQTSwgQXVnZXIgRXJpYyB3cm90ZToKPj4+
IEhpIEppbmd5aSwKPj4+Cj4+PiBPbiA3LzIvMjAgNTowMSBBTSwgSmluZ3lpIFdhbmcgd3JvdGU6
Cj4+Pj4gVHJpZ2dlciBQUElzIGJ5IHNldHRpbmcgdXAgYSAxMG1zZWMgdGltZXIgYW5kIHRlc3Qg
dGhlIGxhdGVuY3kuCj4+Pgo+Pj4gc28gZm9yIGVhY2ggaXRlcmF0aW9uIHRoZSBhY2N1bXVsYXRl
ZCB2YWx1ZWQgaXMgMTAgbXMgKyBsYXRlbmN5LCByaWdodD8KPj4+IGFuZCB3aGF0IGlzIHByaW50
ZWQgYXQgdGhlIGVuZCBkb2VzIGluY2x1ZGUgdGhlIGFjY3VtdWxhdGVkIHBlcmlvZHMuCj4+PiBX
b3VsZG4ndCBpdCBtYWtlIHNlbnNlIHRvIGhhdmUgYSB0ZXN0LT5wb3N0KCkgdGhhdCBzdWJzdHJh
Y3QgdGhpcyB2YWx1ZS4KPj4+IFlvdSB3b3VsZCBuZWVkIHRvIHN0b3JlIHRoZSBhY3R1YWwgbnVt
YmVyIG9mIGl0ZXJhdGlvbnMuCj4+Pgo+Pj4gVGhhbmtzCj4+Pgo+Pj4gRXJpYwo+Pgo+PiBUaGF0
J3MgcmlnaHQsIHRoZSByZXN1bHQgaW5kaWNhdGVzIDEwbXMgKyBsYXRlbmN5LCB3aGljaCBpcyBh
IDEwbXNlYwo+PiB0aW1lciBhY3R1YWxseSBjb3N0cy4gSSB0aGluayB1c2luZyB0aGUgZGlmZmVy
ZW5jZSBpbnN0ZWFkIG9mIHRoZSB0b3RhbAo+PiB0aW1lIGNvc3QgY2FuIGJlIGEgbGl0dGxlIGNv
bmZ1c2luZyBoZXJlLiBNYXliZSB3ZSBjYW4gdXNlIHRlc3QtPnBvc3QoKQo+PiB0byBnZXQgdGhl
IGxhdGVuY3kgYW5kIHByaW50IGFuIGV4dHJhIHJlc3VsdCBpbiBsb2dzPyBEbyB5b3UgaGF2ZSBh
bnkKPj4gb3BpbmlvbnMgb24gdGhhdD8KPiAKPiBmb3Igb3RoZXIgaW50ZXJydXB0cyB5b3Ugb25s
eSBwcmludCB0aGUgbGF0ZW5jeSwgcmlnaHQ/IEhlcmUgaWYgSQo+IHVuZGVyc3RhbmQgY29ycmVj
dGx5IHlvdSB1c2UgdGhlIHRpbWVyIHRvIHRyaWdnZXIgdGhlIFBQSSBidXQgc3RpbGwgeW91Cj4g
Y2FyZSBhYm91dCB0aGUgbGF0ZW5jeSwgaGVuY2UgbXkgc3VnZ2VzdGlvbiB0byBvbmx5IHByaW50
IHRoZSBsYXRlbmN5Lgo+IAo+IFRoYW5rcwo+IAo+IEVyaWMKCk9rYXksIEkgd2lsbCBjcmVhdGUg
YSBzZXBhcmF0ZSBwYXRjaCB0byBleHRyYWN0IHRoZSB2dGltZXIgZGlmZmVyZW5jZQppbiB0aGUg
bmV4dCB2ZXJzaW9uLCB0aGFua3MgZm9yIHlvdSBzdWdnZXN0aW9uLgoKVGhhbmtzLApKaW5neWkK
Cj4+Cj4+IFRoYW5rcywKPj4gSmluZ3lpCj4+Cj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBKaW5n
eWkgV2FuZyA8d2FuZ2ppbmd5aTExQGh1YXdlaS5jb20+Cj4+Pj4gLS0tCj4+Pj4gIMKgIGFybS9t
aWNyby1iZW5jaC5jIHwgNTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0KPj4+PiAgwqAgMSBmaWxlIGNoYW5nZWQsIDU1IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKPj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcm0vbWljcm8tYmVuY2guYyBiL2FybS9t
aWNyby1iZW5jaC5jCj4+Pj4gaW5kZXggNGM5NjJiNy4uNjgyMjA4NCAxMDA2NDQKPj4+PiAtLS0g
YS9hcm0vbWljcm8tYmVuY2guYwo+Pj4+ICsrKyBiL2FybS9taWNyby1iZW5jaC5jCj4+Pj4gQEAg
LTIzLDggKzIzLDEzIEBACj4+Pj4gIMKgICNpbmNsdWRlIDxhc20vZ2ljLXYzLWl0cy5oPgo+Pj4+
ICDCoCDCoCAjZGVmaW5lIE5USU1FUyAoMVUgPDwgMTYpCj4+Pj4gKyNkZWZpbmUgTlRJTUVTX01J
Tk9SICgxVSA8PCA4KQo+Pj4+ICDCoCAjZGVmaW5lIE1BWF9OUyAoNSAqIDEwMDAgKiAxMDAwICog
MTAwMFVMKQo+Pj4+ICDCoCArI2RlZmluZSBJUlFfVlRJTUVSwqDCoMKgwqDCoMKgwqAgMjcKPj4+
PiArI2RlZmluZSBBUkNIX1RJTUVSX0NUTF9FTkFCTEXCoMKgwqAgKDEgPDwgMCkKPj4+PiArI2Rl
ZmluZSBBUkNIX1RJTUVSX0NUTF9JTUFTS8KgwqDCoCAoMSA8PCAxKQo+Pj4+ICsKPj4+PiAgwqAg
c3RhdGljIHUzMiBjbnRmcnE7Cj4+Pj4gIMKgIMKgIHN0YXRpYyB2b2xhdGlsZSBib29sIGlycV9y
ZWFkeSwgaXJxX3JlY2VpdmVkOwo+Pj4+IEBAIC0zMyw5ICszOCwxNiBAQCBzdGF0aWMgdm9pZCAo
KndyaXRlX2VvaXIpKHUzMiBpcnFzdGF0KTsKPj4+PiAgwqAgwqAgc3RhdGljIHZvaWQgZ2ljX2ly
cV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQo+Pj4+ICDCoCB7Cj4+Pj4gK8KgwqDCoCB1
MzIgaXJxc3RhdCA9IGdpY19yZWFkX2lhcigpOwo+Pj4+ICDCoMKgwqDCoMKgIGlycV9yZWFkeSA9
IGZhbHNlOwo+Pj4+ICDCoMKgwqDCoMKgIGlycV9yZWNlaXZlZCA9IHRydWU7Cj4+Pj4gLcKgwqDC
oCBnaWNfd3JpdGVfZW9pcihnaWNfcmVhZF9pYXIoKSk7Cj4+Pj4gK8KgwqDCoCBnaWNfd3JpdGVf
ZW9pcihpcnFzdGF0KTsKPj4+PiArCj4+Pj4gK8KgwqDCoCBpZiAoaXJxc3RhdCA9PSBJUlFfVlRJ
TUVSKSB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHdyaXRlX3N5c3JlZygoQVJDSF9USU1FUl9DVExf
SU1BU0sgfCBBUkNIX1RJTUVSX0NUTF9FTkFCTEUpLAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBjbnR2X2N0bF9lbDApOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpc2IoKTsK
Pj4+PiArwqDCoMKgIH0KPj4+PiAgwqDCoMKgwqDCoCBpcnFfcmVhZHkgPSB0cnVlOwo+Pj4+ICDC
oCB9Cj4+Pj4gIMKgIEBAIC0xODksNiArMjAxLDQ3IEBAIHN0YXRpYyB2b2lkIGxwaV9leGVjKHZv
aWQpCj4+Pj4gIMKgwqDCoMKgwqAgYXNzZXJ0X21zZyhpcnFfcmVjZWl2ZWQsICJmYWlsZWQgdG8g
cmVjZWl2ZSBMUEkgaW4gdGltZSwgYnV0Cj4+Pj4gcmVjZWl2ZWQgJWQgc3VjY2Vzc2Z1bGx5XG4i
LCByZWNlaXZlZCk7Cj4+Pj4gIMKgIH0KPj4+PiAgwqAgK3N0YXRpYyBib29sIHRpbWVyX3ByZXAo
dm9pZCkKPj4+PiArewo+Pj4+ICvCoMKgwqAgc3RhdGljIHZvaWQgKmdpY19pc2VuYWJsZXI7Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqAgZ2ljX2VuYWJsZV9kZWZhdWx0cygpOwo+Pj4+ICvCoMKgwqAgaW5z
dGFsbF9pcnFfaGFuZGxlcihFTDFIX0lSUSwgZ2ljX2lycV9oYW5kbGVyKTsKPj4+PiArwqDCoMKg
IGxvY2FsX2lycV9lbmFibGUoKTsKPj4+PiArCj4+Pj4gK8KgwqDCoCBnaWNfaXNlbmFibGVyID0g
Z2ljdjNfc2dpX2Jhc2UoKSArIEdJQ1JfSVNFTkFCTEVSMDsKPj4+PiArwqDCoMKgIHdyaXRlbCgx
IDw8IDI3LCBnaWNfaXNlbmFibGVyKTsKPj4+PiArwqDCoMKgIHdyaXRlX3N5c3JlZyhBUkNIX1RJ
TUVSX0NUTF9FTkFCTEUsIGNudHZfY3RsX2VsMCk7Cj4+Pj4gK8KgwqDCoCBpc2IoKTsKPj4+PiAr
Cj4+Pj4gK8KgwqDCoCBnaWNfcHJlcF9jb21tb24oKTsKPj4+PiArwqDCoMKgIHJldHVybiB0cnVl
Owo+Pj4+ICt9Cj4+Pj4gKwo+Pj4+ICtzdGF0aWMgdm9pZCB0aW1lcl9leGVjKHZvaWQpCj4+Pj4g
K3sKPj4+PiArwqDCoMKgIHU2NCBiZWZvcmVfdGltZXI7Cj4+Pj4gK8KgwqDCoCB1NjQgdGltZXJf
MTBtczsKPj4+PiArwqDCoMKgIHVuc2lnbmVkIHRyaWVzID0gMSA8PCAyODsKPj4+PiArwqDCoMKg
IHN0YXRpYyBpbnQgcmVjZWl2ZWQgPSAwOwo+Pj4+ICsKPj4+PiArwqDCoMKgIGlycV9yZWNlaXZl
ZCA9IGZhbHNlOwo+Pj4+ICsKPj4+PiArwqDCoMKgIGJlZm9yZV90aW1lciA9IHJlYWRfc3lzcmVn
KGNudHZjdF9lbDApOwo+Pj4+ICvCoMKgwqAgdGltZXJfMTBtcyA9IGNudGZycSAvIDEwMDsKPj4+
PiArwqDCoMKgIHdyaXRlX3N5c3JlZyhiZWZvcmVfdGltZXIgKyB0aW1lcl8xMG1zLCBjbnR2X2N2
YWxfZWwwKTsKPj4+PiArwqDCoMKgIHdyaXRlX3N5c3JlZyhBUkNIX1RJTUVSX0NUTF9FTkFCTEUs
IGNudHZfY3RsX2VsMCk7Cj4+Pj4gK8KgwqDCoCBpc2IoKTsKPj4+PiArCj4+Pj4gK8KgwqDCoCB3
aGlsZSAoIWlycV9yZWNlaXZlZCAmJiB0cmllcy0tKQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBjcHVf
cmVsYXgoKTsKPj4+PiArCj4+Pj4gK8KgwqDCoCBpZiAoaXJxX3JlY2VpdmVkKQo+Pj4+ICvCoMKg
wqDCoMKgwqDCoCArK3JlY2VpdmVkOwo+Pj4+ICsKPj4+PiArwqDCoMKgIGFzc2VydF9tc2coaXJx
X3JlY2VpdmVkLCAiZmFpbGVkIHRvIHJlY2VpdmUgUFBJIGluIHRpbWUsIGJ1dAo+Pj4+IHJlY2Vp
dmVkICVkIHN1Y2Nlc3NmdWxseVxuIiwgcmVjZWl2ZWQpOwo+Pj4+ICt9Cj4+Pj4gKwo+Pj4+ICDC
oCBzdGF0aWMgdm9pZCBodmNfZXhlYyh2b2lkKQo+Pj4+ICDCoCB7Cj4+Pj4gIMKgwqDCoMKgwqAg
YXNtIHZvbGF0aWxlKCJtb3YgdzAsICMweDRiMDAwMDAwOyBodmMgIzAiIDo6OiAidzAiKTsKPj4+
PiBAQCAtMjM2LDYgKzI4OSw3IEBAIHN0YXRpYyBzdHJ1Y3QgZXhpdF90ZXN0IHRlc3RzW10gPSB7
Cj4+Pj4gIMKgwqDCoMKgwqAgeyJpcGkiLMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXBpX3ByZXAs
wqDCoMKgIGlwaV9leGVjLMKgwqDCoMKgwqDCoMKgIE5USU1FUywKPj4+PiB0cnVlfSwKPj4+PiAg
wqDCoMKgwqDCoCB7ImlwaV9odyIswqDCoMKgwqDCoMKgwqAgaXBpX2h3X3ByZXAswqDCoMKgIGlw
aV9leGVjLAo+Pj4+IE5USU1FUyzCoMKgwqDCoMKgwqDCoCB0cnVlfSwKPj4+PiAgwqDCoMKgwqDC
oCB7ImxwaSIswqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBscGlfcHJlcCzCoMKgwqAgbHBpX2V4ZWMs
wqDCoMKgwqDCoMKgwqAgTlRJTUVTLAo+Pj4+IHRydWV9LAo+Pj4+ICvCoMKgwqAgeyJ0aW1lcl8x
MG1zIizCoMKgwqDCoMKgwqDCoCB0aW1lcl9wcmVwLMKgwqDCoCB0aW1lcl9leGVjLAo+Pj4+IE5U
SU1FU19NSU5PUizCoMKgwqAgdHJ1ZX0sCj4+Pj4gIMKgIH07Cj4+Pj4gIMKgIMKgIHN0cnVjdCBu
c190aW1lIHsKPj4+Pgo+Pj4KPj4+Cj4+PiAuCj4+Pgo+Pgo+IAo+IAo+IC4KPiAKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
