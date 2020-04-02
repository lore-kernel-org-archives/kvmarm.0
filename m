Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06790C43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 12:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8877E20757
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 12:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8877E20757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC54B4B163;
	Thu,  2 Apr 2020 08:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id blZgPko854kZ; Thu,  2 Apr 2020 08:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5ACD4B136;
	Thu,  2 Apr 2020 08:41:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373C14A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 08:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WlyapGRxnLmF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 08:40:57 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E7964A51D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 08:40:56 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id D905A6F00FF2ADCB7EC9;
 Thu,  2 Apr 2020 20:40:49 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 20:40:43 +0800
Subject: Re: [kvm-unit-tests PATCH v7 10/13] arm/arm64: ITS: INT functional
 tests
To: Auger Eric <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-11-eric.auger@redhat.com>
 <f7f1d7c4-2321-9123-2394-528af737bfa7@huawei.com>
 <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <114f8bba-a1e0-0367-a1b4-e875718d8dba@huawei.com>
Date: Thu, 2 Apr 2020 20:40:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <fa4e14f6-20ee-982f-0eda-74b101cddf7a@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgRXJpYywKCk9uIDIwMjAvNC8yIDE2OjUwLCBBdWdlciBFcmljIHdyb3RlOgo+IEhpIFplbmdo
dWksCj4gCj4gT24gMy8zMC8yMCAxMjo0MyBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSGkgRXJp
YywKPj4KPj4gT24gMjAyMC8zLzIwIDE3OjI0LCBFcmljIEF1Z2VyIHdyb3RlOgo+Pj4gVHJpZ2dl
cnMgTFBJcyB0aHJvdWdoIHRoZSBJTlQgY29tbWFuZC4KPj4+Cj4+PiB0aGUgdGVzdCBjaGVja3Mg
dGhlIExQSSBoaXRzIHRoZSByaWdodCBDUFUgYW5kIHRyaWdnZXJzCj4+PiB0aGUgcmlnaHQgTFBJ
IGludGlkLCBpZS4gdGhlIHRyYW5zbGF0aW9uIGlzIGNvcnJlY3QuCj4+Pgo+Pj4gVXBkYXRlcyB0
byB0aGUgY29uZmlnIHRhYmxlIGFsc28gYXJlIHRlc3RlZCwgYWxvbmcgd2l0aCBpbnYKPj4+IGFu
ZCBpbnZhbGwgY29tbWFuZHMuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPgo+Pgo+PiBbLi4uXQo+Pgo+PiBTbyBJJ3ZlIHRlc3RlZCB0aGlz
IHNlcmllcyBhbmQgZm91bmQgdGhhdCB0aGUgIklOVCIgdGVzdCB3aWxsIHNvbWV0aW1lcwo+PiBm
YWlsLgo+Pgo+PiAibm90IG9rIDEyIC0gZ2ljdjM6IGl0cy1taWdyYXRpb246IGRldjIvZXZlbnRp
ZD0yMCB0cmlnZ2VycyBMUEkgODE5NSBlbgo+PiBQRSAjMyBhZnRlciBtaWdyYXRpb24KPj4gbm90
IG9rIDEzIC0gZ2ljdjM6IGl0cy1taWdyYXRpb246IGRldjcvZXZlbnRpZD0yNTUgdHJpZ2dlcnMg
TFBJIDgxOTYgb24KPj4gUEUgIzIgYWZ0ZXIgbWlncmF0aW9uIgo+Pgo+PiAgRnJvbSBsb2dzOgo+
PiAiSU5GTzogZ2ljdjM6IGl0cy1taWdyYXRpb246IE1pZ3JhdGlvbiBjb21wbGV0ZQo+PiBJTlQg
ZGV2X2lkPTIgZXZlbnRfaWQ9MjAKPj4gSU5GTzogZ2ljdjM6IGl0cy1taWdyYXRpb246IE5vIExQ
SSByZWNlaXZlZCB3aGVyZWFzIChjcHVpZD0zLAo+PiBpbnRpZD04MTk1KSB3YXMgZXhwZWN0ZWQK
Pj4gRkFJTDogZ2ljdjM6IGl0cy1taWdyYXRpb246IGRldjIvZXZlbnRpZD0yMCB0cmlnZ2VycyBM
UEkgODE5NSBlbiBQRSAjMwo+PiBhZnRlciBtaWdyYXRpb24KPj4gSU5UIGRldl9pZD03IGV2ZW50
X2lkPTI1NQo+PiBJTkZPOiBnaWN2MzogaXRzLW1pZ3JhdGlvbjogTm8gTFBJIHJlY2VpdmVkIHdo
ZXJlYXMgKGNwdWlkPTIsCj4+IGludGlkPTgxOTYpIHdhcyBleHBlY3RlZAo+PiBGQUlMOiBnaWN2
MzogaXRzLW1pZ3JhdGlvbjogZGV2Ny9ldmVudGlkPTI1NSB0cmlnZ2VycyBMUEkgODE5NiBvbiBQ
RSAjMgo+PiBhZnRlciBtaWdyYXRpb24iCj4+Cj4+PiArc3RhdGljIHZvaWQgY2hlY2tfbHBpX3N0
YXRzKGNvbnN0IGNoYXIgKm1zZykKPj4+ICt7Cj4+PiArwqDCoMKgIGJvb2wgcGFzcyA9IGZhbHNl
Owo+Pj4gKwo+Pj4gK8KgwqDCoCBtZGVsYXkoMTAwKTsKPj4KPj4gQWZ0ZXIgY2hhbmdpbmcgdGhp
cyB0byAnbWRlbGF5KDEwMDApJywgdGhlIGFib3ZlIGVycm9yIGRvZXNuJ3Qgc2hvdyB1cAo+PiBh
bnltb3JlLiBCdXQgaXQgc291bmRzIHN0cmFuZ2UgdGhhdCAxMDBtcyBpcyBub3QgZW5vdWdoIHRv
IGRlbGl2ZXIgYQo+PiBzaW5nbGUgTFBJLiBJIGhhdmVuJ3QgZGlnIGl0IGZ1cnRoZXIgYnV0IHdp
bGwgZ2V0IGJhY2sgaGVyZSBsYXRlci4KPiAKPiBEaWQgeW91IGZpbmQgc29tZSB0aW1lIHRvIGlu
dmVzdGlnYXRlIHRoaXMgaXNzdWUuIENoYW5naW5nIDEwMCB0byAxMDAwCj4gaGFzIGEgaHVnZSBp
bXBhY3Qgb24gdGhlIG92ZXJhbGwgdGVzdCBkdXJhdGlvbiBhbmQgSSBkb24ndCB0aGluayBpdCBp
cwo+IHNlbnNpYmxlLiBDb3VsZCB5b3Ugc2VlIHdoYXQgaXMgeW91ciBtaW5pbWFsIHZhbHVlIHRo
YXQgcGFzcyB0aGUgdGVzdHM/CgpJIGNhbiByZXByb2R1Y2UgdGhpcyBpc3N1ZSB3aXRoIGEgdmVy
eSAqbG93KiBwcm9iYWJpbGl0eSBzbyBJIGZhaWxlZAp0byBpbnZlc3RpZ2F0ZSBpdCA6LSguICAo
SXQgbWlnaHQgYmVjYXVzZSB0aGUgTFBJIHdhcyBkZWxpdmVyZWQgdG8gYQpidXN5IHZjcHUuLi4p
CgpZb3UgY2FuIGxlYXZlIGl0IGFzIGl0IGlzIHVudGlsIHNvbWVvbmUgZWxzZSBjb21wbGFpbiBh
Ym91dCBpdCBhZ2Fpbi4KT3IgdGFrZSB0aGUgc2ltaWxhciBhcHByb2FjaCBhcyBjaGVja19hY2tl
ZCgpIC0gd2FpdCB1cCB0byA1cyBmb3IgdGhlCmludGVycnVwdCB0byBiZSBkZWxpdmVyZWQsIGFu
ZCBiYWlsIG91dCBhcyBzb29uIGFzIHdlIHNlZSBpdC4KCgpUaGFua3MsClplbmdodWkKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
