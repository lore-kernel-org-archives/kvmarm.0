Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1393AC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:12:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7304764EB2
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7304764EB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7E14B3E2;
	Mon, 15 Mar 2021 05:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c4lCjlFIL2a8; Mon, 15 Mar 2021 05:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B964B28A;
	Mon, 15 Mar 2021 05:12:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 788434B2C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:11:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZcnHK4F63B3u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:11:57 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BBB04B286
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:11:57 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzVwq3CxHzmXXD;
 Mon, 15 Mar 2021 17:09:31 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 17:11:45 +0800
Subject: Re: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210313083900.234-1-lushenming@huawei.com>
 <20210313083900.234-6-lushenming@huawei.com>
 <d9047922808df340feca2f257cfb8a3d@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <81fbadda-0489-ffc3-cb38-08e89871ec95@huawei.com>
Date: Mon, 15 Mar 2021 17:11:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <d9047922808df340feca2f257cfb8a3d@kernel.org>
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

T24gMjAyMS8zLzE1IDE2OjMwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMS0wMy0xMyAw
ODozOCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4+IEZyb206IFplbmdodWkgWXUgPHl1emVuZ2h1aUBo
dWF3ZWkuY29tPgo+Pgo+PiBXaGVuIHNldHRpbmcgdGhlIGZvcndhcmRpbmcgcGF0aCBvZiBhIFZM
UEkgKHN3aXRjaCB0byB0aGUgSFcgbW9kZSksCj4+IHdlIGNhbiBhbHNvIHRyYW5zZmVyIHRoZSBw
ZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNoIHRvCj4+IFZQVCAoZXNwZWNpYWxs
eSBpbiBtaWdyYXRpb24sIHRoZSBwZW5kaW5nIHN0YXRlcyBvZiBWTFBJcyBhcmUgcmVzdG9yZWQK
Pj4gaW50byBrdm3igJlzIHZnaWMgZmlyc3QpLiBBbmQgd2UgY3VycmVudGx5IHNlbmQgIklOVCtW
U1lOQyIgdG8gdHJpZ2dlcgo+PiBhIFZMUEkgdG8gcGVuZGluZy4KPj4KPj4gU2lnbmVkLW9mZi1i
eTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IFNo
ZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+Cj4+IC0tLQo+PiDCoGFyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12NC5jIHwgMTggKysrKysrKysrKysrKysrKysrCj4+IMKgMSBmaWxlIGNo
YW5nZWQsIDE4IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NC5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4gaW5kZXgg
YWMwMjliYTNkMzM3Li4zYjgyYWI4MGMyZjMgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NC5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+
IEBAIC00NDksNiArNDQ5LDI0IEBAIGludCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1
Y3Qga3ZtICprdm0sIGludCB2aXJxLAo+PiDCoMKgwqDCoCBpcnEtPmhvc3RfaXJxwqDCoMKgID0g
dmlycTsKPj4gwqDCoMKgwqAgYXRvbWljX2luYygmbWFwLnZwZS0+dmxwaV9jb3VudCk7Cj4+Cj4+
ICvCoMKgwqAgLyogVHJhbnNmZXIgcGVuZGluZyBzdGF0ZSAqLwo+PiArwqDCoMKgIGlmIChpcnEt
PnBlbmRpbmdfbGF0Y2gpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7
Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEt
Pmhvc3RfaXJxLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBJUlFDSElQX1NUQVRFX1BFTkRJTkcsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlycS0+cGVuZGluZ19sYXRjaCk7Cj4+ICvCoMKgwqDCoMKg
wqDCoCBXQVJOX1JBVEVMSU1JVChyZXQsICJJUlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsKPj4gKwo+
PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBDbGVhciBwZW5kaW5n
X2xhdGNoIGFuZCBjb21tdW5pY2F0ZSB0aGlzIHN0YXRlCj4+ICvCoMKgwqDCoMKgwqDCoMKgICog
Y2hhbmdlIHZpYSB2Z2ljX3F1ZXVlX2lycV91bmxvY2suCj4+ICvCoMKgwqDCoMKgwqDCoMKgICov
Cj4+ICvCoMKgwqDCoMKgwqDCoCByYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ss
IGZsYWdzKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGlycS0+cGVuZGluZ19sYXRjaCA9IGZhbHNlOwo+
PiArwqDCoMKgwqDCoMKgwqAgdmdpY19xdWV1ZV9pcnFfdW5sb2NrKGt2bSwgaXJxLCBmbGFncyk7
Cj4+ICvCoMKgwqAgfQo+PiArCj4+IMKgb3V0Ogo+PiDCoMKgwqDCoCBtdXRleF91bmxvY2soJml0
cy0+aXRzX2xvY2spOwo+PiDCoMKgwqDCoCByZXR1cm4gcmV0Owo+IAo+IFRoZSByZWFkIHNpZGUg
b2YgdGhlIHBlbmRpbmcgc3RhdGUgaXNuJ3QgbG9ja2VkLCBidXQgdGhlIHdyaXRlIHNpZGUgaXMu
Cj4gSSdkIHJhdGhlciB5b3UgbG9jayB0aGUgd2hvbGUgc2VxdWVuY2UgZm9yIHBlYWNlIG9mIG1p
bmQuCgpEaWQgeW91IG1lYW4gdG8gbG9jayBiZWZvcmUgZW1pdHRpbmcgdGhlIG1hcHBpbmcgcmVx
dWVzdCwgT3IganVzdCBiZWZvcmUgcmVhZGluZwp0aGUgcGVuZGluZyBzdGF0ZT8KClRoYW5rcywK
U2hlbm1pbmcKCj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
