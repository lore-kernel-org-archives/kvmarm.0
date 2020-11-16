Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F894C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 13:10:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8884722240
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 13:10:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8884722240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81E704C084;
	Mon, 16 Nov 2020 08:10:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ispkSCY4qQAk; Mon, 16 Nov 2020 08:10:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFB14C145;
	Mon, 16 Nov 2020 08:10:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9814BF9E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 08:10:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ToS2u-sie8P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 08:10:07 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 808324BC91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 08:10:07 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CZTv61v1dzhbp6;
 Mon, 16 Nov 2020 21:09:54 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Nov 2020 21:09:53 +0800
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Forbid invalid userspace
 Redistributor accesses
To: Marc Zyngier <maz@kernel.org>
References: <20201113142801.1659-1-yuzenghui@huawei.com>
 <20201113142801.1659-2-yuzenghui@huawei.com>
 <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <584b7ff1-ecf2-b0ec-cea3-ccc29902f43a@huawei.com>
Date: Mon, 16 Nov 2020 21:09:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <724c43702b52aac0d3c9beb9604d1bfb@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDIwMjAvMTEvMTYgMTowNCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gT24gMjAyMC0xMS0xMyAxNDoyOCwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSXQn
cyBleHBlY3RlZCB0aGF0IHVzZXJzIHdpbGwgYWNjZXNzIHJlZ2lzdGVycyBpbiB0aGUgcmVkaXN0
cmlidXRvciAqaWYqCj4+IHRoZSBSRCBoYXMgYmVlbiBpbml0aWFsaXplZCBwcm9wZXJseS4gVW5m
b3J0dW5hdGVseSB1c2Vyc3BhY2UgY2FuIGJlIAo+PiBib2d1cwo+PiBlbm91Z2ggdG8gYWNjZXNz
IHJlZ2lzdGVycyBiZWZvcmUgc2V0dGluZyB0aGUgUkQgYmFzZSBhZGRyZXNzLCBhbmQgS1ZNCj4+
IGltcGxpY2l0bHkgYWxsb3dzIGl0ICh3ZSBoYW5kbGUgdGhlIGFjY2VzcyBhbnl3YXksIHJlZ2Fy
ZGxlc3Mgb2Ygd2hldGhlcgo+PiB0aGUgYmFzZSBhZGRyZXNzIGlzIHNldCkuCj4+Cj4+IEJhZCB0
aGluZyBoYXBwZW5zIHdoZW4gd2UncmUgaGFuZGxpbmcgdGhlIHVzZXIgcmVhZCBvZiBHSUNSX1RZ
UEVSLiBXZSBlbmQKPj4gdXAgd2l0aCBhbiBvb3BzIHdoZW4gZGVmZXJlbmNpbmcgdGhlIHVuc2V0
IHJkcmVnLi4uCj4+Cj4+IMKgwqDCoMKgZ3BhX3QgbGFzdF9yZGlzdF90eXBlciA9IHJkcmVnLT5i
YXNlICsgR0lDUl9UWVBFUiArCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHJkcmVnLT5mcmVl
X2luZGV4IC0gMSkgKiBLVk1fVkdJQ19WM19SRURJU1RfU0laRTsKPj4KPj4gRml4IHRoaXMgaXNz
dWUgYnkgaW5mb3JtaW5nIHVzZXJzcGFjZSB3aGF0IGhhZCBnb25lIHdyb25nICgtRU5YSU8pLgo+
IAo+IEknbSB3b3JyaWVkIGFib3V0IHRoZSAiaW1wbGljaXQiIGFzcGVjdCBvZiB0aGUgYWNjZXNz
IHRoYXQgdGhpcyBwYXRjaAo+IG5vdyBmb3JiaWRzLgo+IAo+IFRoZSBwcm9ibGVtIGlzIHRoYXQg
dGhlIGV4aXN0aW5nIGRvY3VtZW50YXRpb24gZG9lc24ndCBjb3ZlciB0aGlzIGNhc2UsID4gYW5k
IC1FTlhJTydzICJHZXR0aW5nIG9yIHNldHRpbmcgdGhpcyByZWdpc3RlciBpcyBub3QgeWV0IHN1
cHBvcnRlZCIKPiBpcyB3YXkgdG9vIHZhZ3VlLgoKSW5kZWVkLiBIb3cgYWJvdXQgY2hhbmdpbmcg
dG8KCiAgICAgLUVOWElPICBHZXR0aW5nIG9yIHNldHRpbmcgdGhpcyByZWdpc3RlciBpcyBub3Qg
eWV0IHN1cHBvcnRlZAogICAgICAgICAgICAgb3IgVkdJQyBub3QgcHJvcGVybHkgY29uZmlndXJl
ZCAoZS5nLiwgW1JlXURpc3RyaWJ1dG9yIGJhc2UKICAgICAgICAgICAgIGFkZHJlc3MgaXMgdW5r
bm93bikKCj4gVGhlcmUgaXMgYSBwcmVjZWRlbnQgd2l0aCB0aGUgSVRTLCBidXQgdGhhdCdzIAo+
IHVuZG9jdW1lbnRlZAo+IGFzIHdlbGwuIEFsc28sIGhvdyBhYm91dCB2Mj8gSWYgdGhhdCdzIHRo
ZSB3YXN5IHdlIGFyZSBnb2luZyB0byBmaXggdGhpcywKPiB3ZSBhbHNvIG5uZWQgdG8gYmVlZiB1
cCB0aGUgZG9jdW1lbnRhdGlvbi4KClN1cmUsIEkgcGxhbiB0byBkbyBzbyBhbmQgaG9wZSBpdCB3
b24ndCBicmVhayB0aGUgZXhpc3RpbmcgdXNlcnNwYWNlLgoKPiBPZiBjb3Vyc2UsIHRoZSBvdGhl
ciBob3JyaWJsZSB3YXkgdG8gYWRkcmVzcyB0aGUgaXNzdWUgaXMgdG8gcmV0dXJuIGEgdmFsdWUK
PiB0aGF0IGRvZXNuJ3QgaGF2ZSB0aGUgTGFzdCBiaXQgc2V0LCBzaW5jZSB3ZSBjYW4ndCBzeW50
aGV0aXNlIGl0LiBJdCAKPiBkb2Vzbid0Cj4gY2hhbmdlIHRoZSB1c2Vyc3BhY2UgQVBJLCBhbmQg
SSBjYW4gZXZlbiBmaW5kIHNvbWUgKGFkbWl0dGVkbHnCoCB0d2lzdGVkKQo+IGxvZ2ljIHRvIGl0
IChzaW5jZSB0aGVyZSBpcyBubyBiYXNlIGFkZHJlc3MsIHRoZXJlIGlzIG5vIGxhc3QgUkQuLi4p
LgoKSSdtIGZpbmUgd2l0aCBpdC4gQnV0IEknbSBhZnJhaWQgdGhhdCB0aGVyZSBtaWdodCBiZSBv
dGhlciBpc3N1ZXMgZHVlIHRvCnRoZSAidW5leHBlY3RlZCIgYWNjZXNzZXMgc2luY2UgSSBoYXZl
bid0IHRlc3RlZCB3aXRoIGFsbCByZWdpc3RlcnMgZnJvbQp1c2Vyc3BhY2UuCgpNeSB0YWtlIGlz
IHRoYXQgb25seSBpZiB0aGUgIltSZV1EaXN0cmlidXRvciBiYXNlIGFkZHJlc3MiIGlzIHNwZWNp
ZmllZAppbiB0aGUgc3lzdGVtIG1lbW9yeSBtYXAsIHdpbGwgdGhlIHVzZXItcHJvdmlkZWQga3Zt
X2RldmljZV9hdHRyLm9mZnNldAptYWtlIHNlbnNlLiBBbmQgd2UgY2FuIHRoZW4gaGFuZGxlIHRo
ZSBhY2Nlc3MgdG8gdGhlIHJlZ2lzdGVyIHdoaWNoIGlzCmRlZmluZWQgYnkgImJhc2UgYWRkcmVz
cyArIG9mZnNldCIuCgoKVGhhbmtzLApaZW5naHVpCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
