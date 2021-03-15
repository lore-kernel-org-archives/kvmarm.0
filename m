Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F200C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:25:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E98E64E6B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E98E64E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1047F4B4FA;
	Mon, 15 Mar 2021 05:25:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EgjqiNiGC+8K; Mon, 15 Mar 2021 05:25:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0654B4A9;
	Mon, 15 Mar 2021 05:25:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF094B473
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1fVI6MzyFcuZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:25:39 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61DF74B44D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:25:39 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzWF960YzzrWjV;
 Mon, 15 Mar 2021 17:23:41 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 17:25:25 +0800
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
 <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
 <b03ec1e5447024f9f990377e2c28e84f@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <cd821431-52a7-d9a6-1468-8ce0c9446d85@huawei.com>
Date: Mon, 15 Mar 2021 17:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <b03ec1e5447024f9f990377e2c28e84f@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
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

T24gMjAyMS8zLzE1IDE3OjIwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMS0wMy0xNSAw
OToxMSwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+IE9uIDIwMjEvMy8xNSAxNjozMCwgTWFyYyBaeW5n
aWVyIHdyb3RlOgo+Pj4gT24gMjAyMS0wMy0xMyAwODozOCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+
Pj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4KPj4+PiBXaGVu
IHNldHRpbmcgdGhlIGZvcndhcmRpbmcgcGF0aCBvZiBhIFZMUEkgKHN3aXRjaCB0byB0aGUgSFcg
bW9kZSksCj4+Pj4gd2UgY2FuIGFsc28gdHJhbnNmZXIgdGhlIHBlbmRpbmcgc3RhdGUgZnJvbSBp
cnEtPnBlbmRpbmdfbGF0Y2ggdG8KPj4+PiBWUFQgKGVzcGVjaWFsbHkgaW4gbWlncmF0aW9uLCB0
aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIHJlc3RvcmVkCj4+Pj4gaW50byBrdm3igJlz
IHZnaWMgZmlyc3QpLiBBbmQgd2UgY3VycmVudGx5IHNlbmQgIklOVCtWU1lOQyIgdG8gdHJpZ2dl
cgo+Pj4+IGEgVkxQSSB0byBwZW5kaW5nLgo+Pj4+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1
aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcg
THUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4+PiAtLS0KPj4+PiDCoGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NC5jIHwgMTggKysrKysrKysrKysrKysrKysrCj4+Pj4gwqAxIGZpbGUgY2hh
bmdlZCwgMTggaW5zZXJ0aW9ucygrKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12NC5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+PiBp
bmRleCBhYzAyOWJhM2QzMzcuLjNiODJhYjgwYzJmMyAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NC5jCj4+Pj4gQEAgLTQ0OSw2ICs0NDksMjQgQEAgaW50IGt2bV92Z2ljX3Y0X3NldF9mb3J3
YXJkaW5nKHN0cnVjdCBrdm0gKmt2bSwgaW50IHZpcnEsCj4+Pj4gwqDCoMKgwqAgaXJxLT5ob3N0
X2lyccKgwqDCoCA9IHZpcnE7Cj4+Pj4gwqDCoMKgwqAgYXRvbWljX2luYygmbWFwLnZwZS0+dmxw
aV9jb3VudCk7Cj4+Pj4KPj4+PiArwqDCoMKgIC8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8K
Pj4+PiArwqDCoMKgIGlmIChpcnEtPnBlbmRpbmdfbGF0Y2gpIHsKPj4+PiArwqDCoMKgwqDCoMKg
wqAgdW5zaWduZWQgbG9uZyBmbGFnczsKPj4+PiArCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9
IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+Pj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElSUUNISVBfU1RBVEVfUEVORElORywK
Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpcnEt
PnBlbmRpbmdfbGF0Y2gpOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBXQVJOX1JBVEVMSU1JVChyZXQs
ICJJUlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsKPj4+PiArCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8q
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBDbGVhciBwZW5kaW5nX2xhdGNoIGFuZCBjb21tdW5p
Y2F0ZSB0aGlzIHN0YXRlCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBjaGFuZ2UgdmlhIHZnaWNf
cXVldWVfaXJxX3VubG9jay4KPj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqLwo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCByYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsKPj4+
PiArwqDCoMKgwqDCoMKgwqAgaXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7Cj4+Pj4gK8KgwqDC
oMKgwqDCoMKgIHZnaWNfcXVldWVfaXJxX3VubG9jayhrdm0sIGlycSwgZmxhZ3MpOwo+Pj4+ICvC
oMKgwqAgfQo+Pj4+ICsKPj4+PiDCoG91dDoKPj4+PiDCoMKgwqDCoCBtdXRleF91bmxvY2soJml0
cy0+aXRzX2xvY2spOwo+Pj4+IMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+Pgo+Pj4gVGhlIHJlYWQg
c2lkZSBvZiB0aGUgcGVuZGluZyBzdGF0ZSBpc24ndCBsb2NrZWQsIGJ1dCB0aGUgd3JpdGUgc2lk
ZSBpcy4KPj4+IEknZCByYXRoZXIgeW91IGxvY2sgdGhlIHdob2xlIHNlcXVlbmNlIGZvciBwZWFj
ZSBvZiBtaW5kLgo+Pgo+PiBEaWQgeW91IG1lYW4gdG8gbG9jayBiZWZvcmUgZW1pdHRpbmcgdGhl
IG1hcHBpbmcgcmVxdWVzdCwgT3IganVzdCBiZWZvcmUgcmVhZGluZwo+PiB0aGUgcGVuZGluZyBz
dGF0ZT8KPiAKPiBKdXN0IGJlZm9yZSByZWFkaW5nIHRoZSBwZW5kaW5nIHN0YXRlLCBzbyB0aGF0
IHdlIGNhbid0IGdldCBhIGNvbmN1cnJlbnQKPiBtb2RpZmljYXRpb24gb2YgdGhhdCBzdGF0ZSB3
aGlsZSB3ZSBtYWtlIHRoZSBpbnRlcnJ1cHQgcGVuZGluZyBpbiB0aGUgVlBUCj4gYW5kIGNsZWFy
aW5nIGl0IGluIHRoZSBlbXVsYXRpb24uCgpHZXQgaXQuIEkgd2lsbCBjb3JyZWN0IGl0IHJpZ2h0
IG5vdy4KClRoYW5rcywKU2hlbm1pbmcKCj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKg
IE0uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
