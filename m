Return-Path: <SRS0=6KZ/=XZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110ABC4360C
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 09:41:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 917B42196E
	for <kvmarm@archiver.kernel.org>; Mon, 30 Sep 2019 09:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 917B42196E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD0A4A4F7;
	Mon, 30 Sep 2019 05:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwyU9n081peL; Mon, 30 Sep 2019 05:41:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5EFB4A60B;
	Mon, 30 Sep 2019 05:41:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4AE34A60B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 05:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfO9EoEwdXry for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Sep 2019 05:41:27 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20FC54A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Sep 2019 05:41:27 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id E97985D9C003C37EE7BD;
 Mon, 30 Sep 2019 17:41:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 17:41:16 +0800
Subject: Re: [PATCH 20/35] irqchip/gic-v4.1: Allow direct invalidation of VLPIs
To: Marc Zyngier <maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-21-maz@kernel.org>
 <db01f956-bc53-b8a5-9406-15b889d717f0@huawei.com>
 <1c96d38da22a97b1fda94a940b60e345@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4ac7dddc-1ba8-52bf-e66e-bee9b3b79744@huawei.com>
Date: Mon, 30 Sep 2019 17:40:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1c96d38da22a97b1fda94a940b60e345@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Thomas Gleixner <tglx@linutronix.de>, Lorenzo
 Pieralisi <lorenzo.pieralisi@arm.com>, kvmarm@lists.cs.columbia.edu,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
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

T24gMjAxOS85LzMwIDE3OjIwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAxOS0wOS0yOCAw
MzowMiwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gT24gMjAxOS85LzI0IDI6MjUsIE1hcmMgWnluZ2ll
ciB3cm90ZToKPj4+IEp1c3QgbGlrZSBmb3IgSU5WQUxMLCBHSUN2NC4xIGhhcyBncm93biBhIFZQ
RS1hd2FyZSBJTlZMUEkgcmVnaXN0ZXIuCj4+PiBMZXQncyBwbHVtYiBpdCBpbiBhbmQgbWFrZSB1
c2Ugb2YgdGhlIERpcmVjdExQSSBjb2RlIGluIHRoYXQgY2FzZS4KPj4+IFNpZ25lZC1vZmYtYnk6
IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+PiAtLS0KPj4+IMKgIGRyaXZlcnMvaXJx
Y2hpcC9pcnEtZ2ljLXYzLWl0cy5jwqDCoCB8IDE5ICsrKysrKysrKysrKysrKysrLS0KPj4+IMKg
IGluY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0tZ2ljLXYzLmggfMKgIDEgKwo+Pj4gwqAgMiBmaWxl
cyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Pj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jIAo+Pj4gYi9kcml2ZXJzL2lycWNo
aXAvaXJxLWdpYy12My1pdHMuYwo+Pj4gaW5kZXggYjc5MWM5YmVkZGYyLi4zNDU5NWE3ZmNjY2Ig
MTAwNjQ0Cj4+PiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+Pj4gKysr
IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4+IEBAIC0xMjAwLDEzICsxMjAw
LDI3IEBAIHN0YXRpYyB2b2lkIHdhaXRfZm9yX3N5bmNyKHZvaWQgX19pb21lbSAqcmRiYXNlKQo+
Pj4gwqAgc3RhdGljIHZvaWQgZGlyZWN0X2xwaV9pbnYoc3RydWN0IGlycV9kYXRhICpkKQo+Pj4g
wqAgewo+Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX3ZscGlfbWFwICptYXAgPSBnZXRfdmxwaV9tYXAo
ZCk7Cj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBpdHNfY29sbGVjdGlvbiAqY29sOwo+Pj4gwqDCoMKg
wqDCoCB2b2lkIF9faW9tZW0gKnJkYmFzZTsKPj4+ICvCoMKgwqAgdTY0IHZhbDsKPj4+ICsKPj4+
ICvCoMKgwqAgaWYgKG1hcCkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHN0cnVjdCBpdHNfZGV2aWNl
ICppdHNfZGV2ID0gaXJxX2RhdGFfZ2V0X2lycV9jaGlwX2RhdGEoZCk7Cj4+PiArCj4+PiArwqDC
oMKgwqDCoMKgwqAgV0FSTl9PTighaXNfdjRfMShpdHNfZGV2LT5pdHMpKTsKPj4+ICsKPj4+ICvC
oMKgwqDCoMKgwqDCoCB2YWzCoCA9IEdJQ1JfSU5WTFBJUl9WOwo+Pj4gK8KgwqDCoMKgwqDCoMKg
IHZhbCB8PSBGSUVMRF9QUkVQKEdJQ1JfSU5WTFBJUl9WUEVJRCwgbWFwLT52cGUtPnZwZV9pZCk7
Cj4+PiArwqDCoMKgwqDCoMKgwqAgdmFsIHw9IEZJRUxEX1BSRVAoR0lDUl9JTlZMUElSX0lOVElE
LCBtYXAtPnZpbnRpZCk7Cj4+PiArwqDCoMKgIH0gZWxzZSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAg
dmFsID0gZC0+aHdpcnE7Cj4+PiArwqDCoMKgIH0KPj4+Cj4+PiDCoMKgwqDCoMKgIC8qIFRhcmdl
dCB0aGUgcmVkaXN0cmlidXRvciB0aGlzIExQSSBpcyBjdXJyZW50bHkgcm91dGVkIHRvICovCj4+
PiDCoMKgwqDCoMKgIGNvbCA9IGlycV90b19jb2woZCk7Cj4+Cj4+IEkgdGhpbmsgaXJxX3RvX2Nv
bCgpIG1heSBub3Qgd29yayB3aGVuIEdJQ3Y0LjEgVkxQSXMgYXJlIGludm9sdmVkIGluLgo+Pgo+
PiBpcnFfdG9fY29sKCkgZ2l2ZXMgdXMgY29sX21hcFtldmVudF0gYXMgdGhlIHRhcmdldCByZWRp
c3RyaWJ1dG9yLAo+PiBidXQgdGhlIGNvcnJlY3Qgb25lIGZvciBWTFBJcyBzaG91bGQgYmUgdmxw
aV9tYXBzW2V2ZW50XS0+dnBlLT5jb2xfaWR4Lgo+PiBUaGVzZSB0d28gYXJlIG5vdCBhbHdheXMg
cG9pbnRpbmcgdG8gdGhlIHNhbWUgcGh5c2ljYWwgUkQuCj4+IEZvciBleGFtcGxlLCBpZiBndWVz
dCBpc3N1ZXMgYSBNT1ZJIGFnYWluc3QgYSBWTFBJLCB3ZSB3aWxsIHVwZGF0ZSB0aGUKPj4gY29y
cmVzcG9uZGluZyB2bHBpX21hcC0+dnBlIGFuZCBpc3N1ZSBhIFZNT1ZJIG9uIElUUy4uLiBidXQg
bGVhdmUgdGhlCj4+IGNvbF9tYXBbZXZlbnRdIHVuY2hhbmdlZC4KPj4KPj4gY29sX21hcFtldmVu
dF0gdXN1YWxseSBkZXNjcmliZXMgdGhlIHBoeXNpY2FsIExQSSdzIENQVSBhZmZpbml0eSwgYnV0
Cj4+IHdoZW4gdGhpcyBwaHlzaWNhbCBMUEkgc2VydmVzIGFzIHNvbWV0aGluZyB3aGljaCB0aGUg
VkxQSSBpcyBiYWNrZWQgYnksCj4+IHdlIHRha2UgcmVhbGx5IGxpdHRsZSBjYXJlIG9mIGl0LsKg
IERpZCBJIG1pc3Mgc29tZXRoaW5nIGhlcmU/Cj4gCj4gWW91IGRpZG4ndCBtaXNzIGFueXRoaW5n
LCBhbmQgdGhpcyBpcyBpbmRlZWQgYW5vdGhlciBwcmV0dHkgYmFkIGJ1Zy4KPiBUaGUgY29sbGVj
dGlvbiBtYXBwaW5nIGlzIGNvbXBsZXRlbHkgdW51c2VkIHdoZW4gdGhlIExQSSBiZWNvbWVzIGEK
PiBWTFBJLCBhbmQgaXQgaXMgb25seSB0aGUgdnBlLT5jb2xfaWQgdGhhdCBtYXR0ZXJzICh3aGlj
aCBnZXRzIHVwZGF0ZWQKPiBvbiBWTU9WUCkuCj4gCj4gVGhpcyBzaG93cyB0aGF0IGlycV90b19j
b2woKSBpcyB0aGUgd3JvbmcgYWJzdHJhY3Rpb24sIGFuZCB3aGF0IHdlJ3JlCj4gaW50ZXJlc3Rl
ZCBpcyBzb21ldGhpbmcgdGhhdCBpcyBtb3JlIGxpa2UgJ2lycSB0byBjcHVpZCcsIGFsbG93aW5n
IHVzCj4gdG8gZGlyZWN0bHkgcG9pbnQgdG8gdGhlIHJpZ2h0IGRpc3RyaWJ1dG9yLgo+IAo+IFBs
ZWFzZSBzZWUgdGhlIHBhdGNoIEkganVzdCBwdXNoZWRbMV0sIHdoaWNoIGRvZXMgdGhhdC4KPiAK
PiBUaGFua3MsCj4gCj4gIMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4gWzFdIAo+IGh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hei9hcm0tcGxhdGZvcm1zLmdp
dC9jb21taXQvP2g9aXJxL2dpYy12NC4xLWRldmVsJmlkPWFmZjM2MzExM2ViMjZiNjg0MDEzNmI2
OWMyYzdkYjJlYTY5MWRiMjAgCgpZZXMsIEkgdGhpbmsgdGhpcyBtYWtlcyBzZW5zZS4KCgpUaGFu
a3MsCnplbmdodWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
