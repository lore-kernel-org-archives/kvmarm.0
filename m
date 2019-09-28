Return-Path: <SRS0=ReDF=XX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1098C4360C
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 03:08:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C86920872
	for <kvmarm@archiver.kernel.org>; Sat, 28 Sep 2019 03:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C86920872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5882D4A72A;
	Fri, 27 Sep 2019 23:08:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Q4ywDZ8Sxtv; Fri, 27 Sep 2019 23:08:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 302EC4A773;
	Fri, 27 Sep 2019 23:08:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 704254A703
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 23:08:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynBGhTDM+0OB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 23:08:44 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC5064A702
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 23:08:44 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 9C14E220DCCF11C7AA3F;
 Sat, 28 Sep 2019 11:08:40 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 28 Sep 2019
 11:08:31 +0800
Subject: Re: [PATCH 24/35] irqchip/gic-v4.1: Add initial SGI configuration
From: Zenghui Yu <yuzenghui@huawei.com>
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-25-maz@kernel.org>
 <4ad002e2-1b3c-3420-98a5-0bedf067cfd9@huawei.com>
Message-ID: <c94061be-d029-69c8-d34f-4d21081d5aba@huawei.com>
Date: Sat, 28 Sep 2019 11:07:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <4ad002e2-1b3c-3420-98a5-0bedf067cfd9@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Thomas Gleixner <tglx@linutronix.de>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>
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

T24gMjAxOS85LzI4IDEwOjIwLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIE1hcmMsCj4gCj4gT24g
MjAxOS85LzI0IDI6MjUsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gVGhlIEdJQ3Y0LjEgSVRTIGhh
cyB5ZXQgYW5vdGhlciBuZXcgY29tbWFuZCAoVlNHSSkgd2hpY2ggYWxsb3dzCj4+IGEgVlBFLXRh
cmdldGVkIFNHSSB0byBiZSBjb25maWd1cmVkIChvciBoYXZlIGl0cyBwZW5kaW5nIHN0YXRlCj4+
IGNsZWFyZWQpLiBBZGQgc3VwcG9ydCBmb3IgdGhpcyBjb21tYW5kIGFuZCBwbHVtYiBpdCBpbnRv
IHRoZQo+PiBhY3RpdmF0ZSBpcnFkb21haW4gY2FsbGJhY2sgc28gdGhhdCBpdCBpcyByZWFkeSB0
byBiZSB1c2VkLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPgo+PiAtLS0KPj4gwqAgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmPCoMKgIHwg
ODggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4+IMKgIGluY2x1ZGUvbGludXgvaXJx
Y2hpcC9hcm0tZ2ljLXYzLmggfMKgIDMgKy0KPj4gwqAgMiBmaWxlcyBjaGFuZ2VkLCA5MCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNo
aXAvaXJxLWdpYy12My1pdHMuYyAKPj4gYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMu
Ywo+PiBpbmRleCA2OWMyNmJlNzA5YmUuLjUyMzRiOWVlZjhhZCAxMDA2NDQKPj4gLS0tIGEvZHJp
dmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2ly
cS1naWMtdjMtaXRzLmMKPiAKPiBbLi4uXQo+IAo+PiBAQCAtMzU3NCw2ICszNjI4LDM4IEBAIHN0
YXRpYyBzdHJ1Y3QgaXJxX2NoaXAgaXRzX3ZwZV80XzFfaXJxX2NoaXAgPSB7Cj4+IMKgwqDCoMKg
wqAgLmlycV9zZXRfdmNwdV9hZmZpbml0ecKgwqDCoCA9IGl0c192cGVfNF8xX3NldF92Y3B1X2Fm
ZmluaXR5LAo+PiDCoCB9Owo+PiArc3RhdGljIHN0cnVjdCBpdHNfbm9kZSAqZmluZF80XzFfaXRz
KHZvaWQpCj4+ICt7Cj4+ICvCoMKgwqAgc3RhdGljIHN0cnVjdCBpdHNfbm9kZSAqaXRzID0gTlVM
TDsKPj4gKwo+PiArwqDCoMKgIGlmICghaXRzKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBsaXN0X2Zv
cl9lYWNoX2VudHJ5KGl0cywgJml0c19ub2RlcywgZW50cnkpIHsKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKGlzX3Y0XzEoaXRzKSkKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gaXRzOwo+PiArwqDCoMKgwqDCoMKgwqAgfQo+PiArCj4+ICvCoMKgwqDCoMKg
wqDCoCAvKiBPb3BzPyAqLwo+PiArwqDCoMKgwqDCoMKgwqAgaXRzID0gTlVMTDsKPj4gK8KgwqDC
oCB9Cj4+ICsKPj4gK8KgwqDCoCByZXR1cm4gaXRzOwo+PiArfQo+PiArCj4+ICtzdGF0aWMgdm9p
ZCBpdHNfY29uZmlndXJlX3NnaShzdHJ1Y3QgaXJxX2RhdGEgKmQsIGJvb2wgY2xlYXIpCj4+ICt7
Cj4+ICvCoMKgwqAgc3RydWN0IGl0c192cGUgKnZwZSA9IGlycV9kYXRhX2dldF9pcnFfY2hpcF9k
YXRhKGQpOwo+PiArwqDCoMKgIHN0cnVjdCBpdHNfY21kX2Rlc2MgZGVzYzsKPj4gKwo+PiArwqDC
oMKgIGRlc2MuaXRzX3ZzZ2lfY21kLnZwZSA9IHZwZTsKPj4gK8KgwqDCoCBkZXNjLml0c192c2dp
X2NtZC5zZ2kgPSBkLT5od2lycTsKPj4gK8KgwqDCoCBkZXNjLml0c192c2dpX2NtZC5wcmlvcml0
eSA9IHZwZS0+c2dpX2NvbmZpZ1tkLT5od2lycV0ucHJpb3JpdHk7Cj4+ICvCoMKgwqAgZGVzYy5p
dHNfdnNnaV9jbWQuZW5hYmxlID0gdnBlLT5zZ2lfY29uZmlnW2QtPmh3aXJxXS5lbmFibGVkOwo+
PiArwqDCoMKgIGRlc2MuaXRzX3ZzZ2lfY21kLmdyb3VwID0gdnBlLT5zZ2lfY29uZmlnW2QtPmh3
aXJxXS5ncm91cDsKPj4gK8KgwqDCoCBkZXNjLml0c192c2dpX2NtZC5jbGVhciA9IGNsZWFyOwo+
PiArCj4+ICvCoMKgwqAgaXRzX3NlbmRfc2luZ2xlX3Zjb21tYW5kKGZpbmRfNF8xX2l0cygpLCBp
dHNfYnVpbGRfdnNnaV9jbWQsICZkZXNjKTsKPiAKPiBJIGNhbid0IGZvbGxvdyB0aGUgbG9naWMg
aW4gZmluZF80XzFfaXRzKCkuwqAgV2Ugc2ltcGx5IHVzZSB0aGUgZmlyc3QgSVRTCj4gd2l0aCBH
SUN2NC4xIHN1cHBvcnQsIGJ1dCB3aGF0IGlmIHRoZSB2UEUgaXMgbm90IG1hcHBlZCBvbiB0aGlz
IElUUz8KPiBXZSB3aWxsIGZhaWwgdGhlIHZhbGlkX3ZwZSgpIGNoZWNrIHdoZW4gYnVpbGRpbmcg
dGhpcyBjb21tYW5kIGFuZCB3aWxsCj4gaGF2ZSBubyBlZmZlY3Qgb24gSFcgaW4gdGhlIGVuZD8K
CkkgZ3Vlc3MgSSBmaW5kIHRoZSBhbnN3ZXIgaW4gcGF0Y2gjMzEgKCJFYWdlcmx5IHZtYXAgdlBF
cyIpLgoKSSBtaXNzZWQgdGhlIGltcG9ydGFudCBwb2ludCBpbiBHSUN2NC4xIHRoYXQgd2UgaGF2
ZSB0byBtYXAgdlBFcyBhdCBhbGwKdGltZXMgZm9yIFZTR0kgZGVsaXZlcnksIGFuZCB3ZSBjdXJy
ZW50bHkgY2hvb3NlIHRvIG1hcCB2UEVzIG9uIGFsbCBJVFNzCndoZW4gcmVxdWVzdGluZyBwZXIg
dlBFIGlycSAoaW5zdGVhZCBvZiBtYXBwaW5nIHRoZW0gb24gZGVtYW5kLCBiZWZvcmUKbWFwcGlu
ZyBWTFBJLCB3aGljaCBjb3VsZCBoYXBwZW4gYXQgYSBwcmV0dHkgbGF0ZSBzdGFnZSkuClNvIGl0
J3MgT0sgdG8gdXNlIHRoZSBmaXJzdCBHSUN2NC4xIElUUyB3aGVuIGNvbmZpZ3VyaW5nIFZTR0kg
Zm9yIHRoaXMKc3BlY2lmaWVkIHZQRSwgZ2l2ZW4gdGhhdCBpdCBpcyBhbHJlYWR5IG1hcHBlZCBv
biBhbGwgSVRTcy4KCgpUaGFua3MsCnplbmdodWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
