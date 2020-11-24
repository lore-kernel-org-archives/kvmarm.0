Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DAEC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 03:19:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DC8220857
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 03:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DC8220857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 666904BCA7;
	Mon, 23 Nov 2020 22:19:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w8xqMzaNVu9j; Mon, 23 Nov 2020 22:19:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C13E4BCBF;
	Mon, 23 Nov 2020 22:19:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C52584BCBA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 22:19:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZ1LhtDNdbEq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 22:19:20 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D54BD4BCA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 22:19:19 -0500 (EST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cg8PX6vM9z725D;
 Tue, 24 Nov 2020 11:18:56 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 11:19:12 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
 <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
Message-ID: <5647a73c-f05f-5c71-4ada-7837094f4999@huawei.com>
Date: Tue, 24 Nov 2020 11:19:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
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

SGkgTWFyYywKCkdlbnRsZSBwaW5nLCBjb3VsZCB5b3UgcGxlYXNlIGdpdmUgc29tZSBjb21tZW50
cyBvbiB0aGlzIHBhdGNoIG9yIHRoZQpjdXJyZW50IHRlc3QgcmVzdWx0cz8gVGhhbmtzIGluIGFk
dmFuY2UuCgpUaGFua3MsCkppbmd5aQoKT24gMTEvMTMvMjAyMCAzOjU0IFBNLCBKaW5neWkgV2Fu
ZyB3cm90ZToKPiBIaSBhbGzvvIwKPiAKPiBTb3JyeSBmb3IgdGhlIGRlbGF5LiBJIGhhdmUgYmVl
biB0ZXN0aW5nIHRoZSBUV0VEIGZlYXR1cmUgcGVyZm9ybWFuY2UKPiBsYXRlbHkuIFdlIHNlbGVj
dCB1bml4YmVuY2ggYXMgdGhlIGJlbmNobWFyayBmb3Igc29tZSBpdGVtcyBvZiBpdCBpcyAKPiBs
b2NrLWludGVuc2l2ZShmc3RpbWUvZnNidWZmZXIvZnNkaXNrKS4gV2UgcnVuIHVuaXhiZW5jaCBv
biBhIDQtVkNQVQo+IFZNLCBhbmQgYmluZCBldmVyeSB0d28gVkNQVXMgb24gb25lIFBDUFUuIEZp
eGVkIFRXRUQgdmFsdWUgaXMgdXNlZCBhbmQgCj4gaGVyZSBpcyB0aGUgcmVzdWx0Lgo+IAo+ICDC
oMKgwqDCoCB0d2VkX3ZhbHVlICB8IGZzdGltZcKgwqDCoCAgfCBmc2J1ZmZlcsKgIHwgZnNkaXNr
Cj4gIMKgwqDCoCAtLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tKy0t
LS0tLS0tLS0tLQo+ICDCoMKgwqDCoCBkaXNhYmxlwqDCoCB8IDE2LjDCoMKgwqDCoCAgfCAxNC4x
wqDCoMKgIHwgMTguMAo+ICDCoMKgwqDCoCAwwqDCoMKgwqDCoCB8IDE2LjPCoMKgwqDCoCAgfCAx
My41wqDCoMKgIHwgMTcuMgo+ICDCoMKgwqDCoCAxwqDCoMKgwqDCoCB8IDE3LjXCoMKgwqDCoCAg
fCAxNC43wqDCoMKgIHwgMTcuNAo+ICDCoMKgwqDCoCAywqDCoMKgwqDCoCB8IDE3LjPCoMKgwqDC
oCAgfCAxNS4zwqDCoMKgIHwgMTguMAo+ICDCoMKgwqDCoCAzwqDCoMKgwqDCoCB8IDE3LjfCoMKg
wqDCoCAgfCAxNS4ywqDCoMKgIHwgMTguOQo+ICDCoMKgwqDCoCA0wqDCoMKgwqDCoCB8IDE3LjnC
oMKgwqDCoCAgfCAxNC4zwqDCoMKgIHwgMTguMgo+ICDCoMKgwqDCoCA1wqDCoMKgwqDCoCB8IDE3
LjLCoMKgwqDCoCAgfCAxNC4xwqDCoMKgIHwgMTkuMAo+ICDCoMKgwqDCoCA2wqDCoMKgwqDCoCB8
IDUuOMKgwqDCoMKgICAgfCA0LjLCoMKgwqAgIHwgNS43Cj4gIMKgwqDCoMKgIDfCoMKgwqDCoMKg
IHwgNi4ywqDCoMKgwqDCoCB8IDUuNsKgwqDCoCAgfCAxMi44Cj4gCj4gTm90ZToKPiBmc3RpbWU6
IEZpbGUgQ29weSAxMDI0IGJ1ZnNpemUgMjAwMCBtYXhibG9ja3MKPiBmc2J1ZmZlcjogRmlsZSBD
b3B5IDI1NiBidWZzaXplIDUwMCBtYXhibG9ja3MKPiBmc2Rpc2s6IEZpbGUgQ29weSA0MDk2IGJ1
ZnNpemUgODAwMCBtYXhibG9ja3MKPiBUaGUgaW5kZXggb2YgdW5peGJlbmNoLCBoaWdoZXIgaXMg
YmV0dGVyLgo+IAo+IEl0IGlzIHNob3duIHRoYXQsIGNvbXBhcmVkIHRvIHRoZSBjaXJjdW1zdGFu
Y2UgdGhhdCBUV0VEIGlzIGRpc2FibGVkLAo+IGxvY2staW50ZW5zaXZlIHRlc3RpbmcgaXRlbXMg
aGF2ZSBiZXR0ZXIgcGVyZm9ybWFuY2UgaWYgYW4gYXBwcm9wcmlhdGUKPiBUV0VEIHZhbHVlIGlz
IHNldCh1cCB0byA1LjYlfjExLjklKS4gTWVhbndoaWxlLCB0aGUgY29tcGxldGUgdW5peGJlbmNo
Cj4gdGVzdCBpcyBydW4gdG8gcHJvdmUgdGhhdCBvdGhlciB0ZXN0aW5nIGl0ZW1zIGFyZSBub3Qg
c2Vuc2l0aXZlIHRvIHRoaXMKPiBwYXJhbWV0ZXIuCj4gCj4gVGhhbmtzCj4gSmluZ3lpCj4gCj4g
T24gOS8yOS8yMDIwIDU6MTcgUE0sIEppbmd5aSBXYW5nIHdyb3RlOgo+PiBUV0UgRGVsYXkgaXMg
YW4gb3B0aW9uYWwgZmVhdHVyZSBpbiBBUk12OC42IEV4dGVudGlvbnMuIFRoZXJlIGlzIGEKPj4g
cGVyZm9ybWFuY2UgYmVuZWZpdCBpbiB3YWl0aW5nIGZvciBhIHBlcmlvZCBvZiB0aW1lIGZvciBh
biBldmVudCB0bwo+PiBhcnJpdmUgYmVmb3JlIHRha2luZyB0aGUgdHJhcCBhcyBpdCBpcyBjb21t
b24gdGhhdCBldmVudCB3aWxsIGFycml2ZQo+PiDigJxxdWl0ZSBzb29u4oCdIGFmdGVyIGV4ZWN1
dGluZyB0aGUgV0ZFIGluc3RydWN0aW9uLgo+Pgo+PiBUaGlzIHNlcmllcyBhZGRzIHN1cHBvcnQg
Zm9yIFRXRUQgZmVhdHVyZSBhbmQgaW1wbGVtZW50cyBUV0UgZGVsYXkKPj4gdmFsdWUgZHluYW1p
YyBhZGp1c3RtZW50Lgo+Pgo+PiBUaGFua3MgZm9yIFNoYW1lZXIncyBhZHZpY2Ugb24gdGhpcyBz
ZXJpZXMuIFRoZSBmdW5jdGlvbiBvZiB0aGlzIHBhdGNoCj4+IGhhcyBiZWVuIHRlc3RlZCBvbiBU
V0VEIHN1cHBvcnRlZCBoYXJkd2FyZSBhbmQgdGhlIHBlcmZvcm1hbmNlIG9mIGl0IGlzCj4+IHN0
aWxsIG9uIHRlc3QsIGFueSBhZHZpY2Ugd2lsbCBiZSB3ZWxjb21lZC4KPj4KPj4gSmluZ3lpIFdh
bmcgKDIpOgo+PiDCoMKgIEtWTTogYXJtNjQ6IE1ha2UgdXNlIG9mIFRXRUQgZmVhdHVyZQo+PiDC
oMKgIEtWTTogYXJtNjQ6IFVzZSBkeW5hbWljIFRXRSBEZWxheSB2YWx1ZQo+Pgo+PiBaZW5ncnVh
biBZZSAoMik6Cj4+IMKgwqAgYXJtNjQ6IGNwdWZlYXR1cmU6IFRXRUQgc3VwcG9ydCBkZXRlY3Rp
b24KPj4gwqDCoCBLVk06IGFybTY0OiBBZGQgdHJhY2UgZm9yIFRXRUQgdXBkYXRlCj4+Cj4+IMKg
IGFyY2gvYXJtNjQvS2NvbmZpZ8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8
IDEwICsrKysrCj4+IMKgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1Y2Fwcy5owqDCoMKgwqAg
fMKgIDMgKy0KPj4gwqAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXJtLmjCoMKgwqDCoCB8
wqAgNSArKysKPj4gwqAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fZW11bGF0ZS5oIHwgMzgg
KysrKysrKysrKysrKysrKysrCj4+IMKgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aMKgwqDCoCB8IDE5ICsrKysrKysrLQo+PiDCoCBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL3ZpcnQu
aMKgwqDCoMKgwqDCoMKgIHzCoCA4ICsrKysKPj4gwqAgYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVh
dHVyZS5jwqDCoMKgwqDCoMKgIHwgMTIgKysrKysrCj4+IMKgIGFyY2gvYXJtNjQva3ZtL2FybS5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA1OCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrCj4+IMKgIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmPCoMKgwqDCoMKgwqDC
oMKgIHzCoCAyICsKPj4gwqAgYXJjaC9hcm02NC9rdm0vdHJhY2VfYXJtLmjCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDIxICsrKysrKysrKysKPj4gwqAgMTAgZmlsZXMgY2hhbmdlZCwgMTc0IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
