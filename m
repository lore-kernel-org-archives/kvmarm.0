Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75AFC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 05:48:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 425E522CE3
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 05:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 425E522CE3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98DDB4B311;
	Wed,  6 Jan 2021 00:48:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WTu-wPJlwdPI; Wed,  6 Jan 2021 00:48:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 761CA4B263;
	Wed,  6 Jan 2021 00:48:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697D14B263
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 00:48:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jaBye6-Ox+Ms for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 00:48:38 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7C4B4B259
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 00:48:37 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D9dgF5BZGz7Prp;
 Wed,  6 Jan 2021 13:47:37 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 13:48:22 +0800
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To: Marc Zyngier <maz@kernel.org>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
 <6f09084b32e239176b3f9b4b00874a51@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <b837b832-7085-c74d-3f9b-08335081f702@huawei.com>
Date: Wed, 6 Jan 2021 13:48:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <6f09084b32e239176b3f9b4b00874a51@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMS8xLzUgMTk6NDAsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTAxLTA1IDA5
OjEzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjEtMDEtMDQgMDg6MTYsIFNoZW5taW5n
IEx1IHdyb3RlOgo+Pj4gQWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJs
ZSBvZiBpbnRlcnJ1cHRpbmcsIGluIG9yZGVyCj4+PiB0byBzYXZlIHRoZSBpbmZvcm1hdGlvbiBv
ZiBhbGwgaW50ZXJydXB0cywgYmVzaWRlcyBmbHVzaGluZyB0aGUgcGVuZGluZwo+Pj4gc3RhdGVz
IGluIGt2beKAmXMgdmdpYywgd2UgYWxzbyB0cnkgdG8gZmx1c2ggdGhlIHN0YXRlcyBvZiBWTFBJ
cyBpbiB0aGUKPj4+IHZpcnR1YWwgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3
ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPj4+IHNhZmVseSB1bm1hcCB0aGUgdlBFcyBmaXJz
dC4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWku
Y29tPgo+Pj4gLS0tCj4+PiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIHwgNTggKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPj4+IMKgMSBmaWxlIGNoYW5nZWQsIDUy
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMK
Pj4+IGluZGV4IDljZGYzOWE5NGE2My4uYTU4Yzk0MTI3Y2IwIDEwMDY0NAo+Pj4gLS0tIGEvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy12My5jCj4+PiBAQCAtMSw2ICsxLDggQEAKPj4+IMKgLy8gU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IEdQTC0yLjAtb25seQo+Pj4KPj4+IMKgI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJt
LWdpYy12My5oPgo+Pj4gKyNpbmNsdWRlIDxsaW51eC9pcnEuaD4KPj4+ICsjaW5jbHVkZSA8bGlu
dXgvaXJxZG9tYWluLmg+Cj4+PiDCoCNpbmNsdWRlIDxsaW51eC9rdm0uaD4KPj4+IMKgI2luY2x1
ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+Cj4+PiDCoCNpbmNsdWRlIDxrdm0vYXJtX3ZnaWMuaD4KPj4+
IEBAIC0zNTYsNiArMzU4LDM4IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVz
KHN0cnVjdCBrdm0KPj4+ICprdm0sIHN0cnVjdCB2Z2ljX2lycSAqaXJxKQo+Pj4gwqDCoMKgwqAg
cmV0dXJuIDA7Cj4+PiDCoH0KPj4+Cj4+PiArLyoKPj4+ICsgKiBUaGUgZGVhY3RpdmF0aW9uIG9m
IHRoZSBkb29yYmVsbCBpbnRlcnJ1cHQgd2lsbCB0cmlnZ2VyIHRoZQo+Pj4gKyAqIHVubWFwcGlu
ZyBvZiB0aGUgYXNzb2NpYXRlZCB2UEUuCj4+PiArICovCj4+PiArc3RhdGljIHZvaWQgdW5tYXBf
YWxsX3ZwZXMoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPj4+ICt7Cj4+PiArwqDCoMKgIHN0cnVj
dCBpcnFfZGVzYyAqZGVzYzsKPj4+ICvCoMKgwqAgaW50IGk7Cj4+PiArCj4+PiArwqDCoMKgIGlm
ICgha3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmhhc19naWN2NF8xKQo+Pj4gK8KgwqDCoMKgwqDCoMKg
IHJldHVybjsKPj4+ICsKPj4+ICvCoMKgwqAgZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192bS5u
cl92cGVzOyBpKyspIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCBkZXNjID0gaXJxX3RvX2Rlc2MoZGlz
dC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7Cj4+PiArwqDCoMKgwqDCoMKgwqAgaXJxX2RvbWFpbl9k
ZWFjdGl2YXRlX2lycShpcnFfZGVzY19nZXRfaXJxX2RhdGEoZGVzYykpOwo+Pj4gK8KgwqDCoCB9
Cj4+PiArfQo+Pj4gKwo+Pj4gK3N0YXRpYyB2b2lkIG1hcF9hbGxfdnBlcyhzdHJ1Y3QgdmdpY19k
aXN0ICpkaXN0KQo+Pj4gK3sKPj4+ICvCoMKgwqAgc3RydWN0IGlycV9kZXNjICpkZXNjOwo+Pj4g
K8KgwqDCoCBpbnQgaTsKPj4+ICsKPj4+ICvCoMKgwqAgaWYgKCFrdm1fdmdpY19nbG9iYWxfc3Rh
dGUuaGFzX2dpY3Y0XzEpCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+Pj4gKwo+Pj4gK8Kg
wqDCoCBmb3IgKGkgPSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGRlc2MgPSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJx
KTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBpcnFfZG9tYWluX2FjdGl2YXRlX2lycShpcnFfZGVzY19n
ZXRfaXJxX2RhdGEoZGVzYyksIGZhbHNlKTsKPj4+ICvCoMKgwqAgfQo+Pj4gK30KPj4+ICsKPj4+
IMKgLyoqCj4+PiDCoCAqIHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyAtIFNhdmUgdGhlIHBl
bmRpbmcgdGFibGVzIGludG8gZ3Vlc3QgUkFNCj4+PiDCoCAqIGt2bSBsb2NrIGFuZCBhbGwgdmNw
dSBsb2NrIG11c3QgYmUgaGVsZAo+Pj4gQEAgLTM2NSwxNCArMzk5LDE4IEBAIGludCB2Z2ljX3Yz
X3NhdmVfcGVuZGluZ190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+Pj4gwqDCoMKgwqAgc3RydWN0
IHZnaWNfZGlzdCAqZGlzdCA9ICZrdm0tPmFyY2gudmdpYzsKPj4+IMKgwqDCoMKgIHN0cnVjdCB2
Z2ljX2lycSAqaXJxOwo+Pj4gwqDCoMKgwqAgZ3BhX3QgbGFzdF9wdHIgPSB+KGdwYV90KTA7Cj4+
PiAtwqDCoMKgIGludCByZXQ7Cj4+PiArwqDCoMKgIGludCByZXQgPSAwOwo+Pj4gwqDCoMKgwqAg
dTggdmFsOwo+Pj4KPj4+ICvCoMKgwqAgLyogQXMgYSBwcmVwYXJhdGlvbiBmb3IgZ2V0dGluZyBh
bnkgVkxQSSBzdGF0ZXMuICovCj4+PiArwqDCoMKgIHVubWFwX2FsbF92cGVzKGRpc3QpOwo+Pgo+
PiBXaGF0IGlmIHRoZSBWUEVzIGFyZSBub3QgbWFwcGVkIHlldD8gSXMgaXQgcG9zc2libGUgdG8g
c25hcHNob3QgYSBWTQo+PiB0aGF0IGhhcyBub3QgcnVuIGF0IGFsbD8KPiAKPiBNb3JlIHF1ZXN0
aW9uczogd2hhdCBoYXBwZW5zIHRvIHZTR0lzIHRoYXQgd2VyZSBtYXBwZWQgdG8gdGhlIFZQRXM/
Cj4gQ2FuIHRoZXkgc2FmZWx5IGJlIHJlc3RhcnRlZD8gVGhlIHNwZWMgaXMgbm90IHNheWluZyBt
dWNoIG9uIHRoZSBzdWJqZWN0LgoKU2luY2Ugd2UgaGF2ZSBhbHJlYWR5IHBhdXNlZCBhbGwgdkNQ
VXMsIHRoZXJlIHdvdWxkIGJlIG5vIG1vcmUgdlNHSXMgZ2VuZXJhdGVkLAphbmQgYWxzbyBubyB2
U0dJIHdvdWxkIGJlIGRlbGl2ZXJlZCB0byB0aGUgdlBFLiBBbmQgdGhlIHVubWFwcGluZyBvZiB0
aGUKdlBFIHdvdWxkIG5vdCBhZmZlY3QgdGhlIChhbHJlYWR5KSBzdG9yZWQgdlNHSSBzdGF0ZXMu
Li4gSSB0aGluayB0aGV5IGNvdWxkCmJlIHNhZmVseSByZXN0YXJ0ZWQuCgo+IAo+IE9uY2UgdGhl
IHVubWFwIGhhcyB0YWtlbiBwbGFjZSwgaXQgd29uJ3QgYmUgcG9zc2libGUgdG8gcmVhZCB0aGVp
ciBzdGF0ZQo+IHZpYSBHSUNSX1ZTR0lSUEVORCwgYW5kIG9ubHkgdGhlIG1lbW9yeSBzdGF0ZSBj
YW4gYmUgdXNlZC4gVGhpcyBwcm9iYWJseQo+IG5lZWRzIHRvIGJlIHRyYWNrZWQgYXMgd2VsbC4K
Clllcywgc2luY2Ugd2Ugd2lsbCBtYXAgdGhlIHZQRXMgYmFjaywgY291bGQgd2UgYXNzdW1lIHRo
YXQgdGhlIHNhdmluZyBvZiB0aGUKdkxQSSBhbmQgdlNHSSBzdGF0ZXMgaGFwcGVuIHNlcmlhbGx5
PyBJbiBmYWN0IHRoYXQncyB3aGF0IFFFTVUgZG9lcy4KCj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDC
oMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
