Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03536C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 08:34:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 65F0665285
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 08:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65F0665285
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7E034B521;
	Tue,  9 Mar 2021 03:34:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CgaPFE1-MY1N; Tue,  9 Mar 2021 03:34:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA22C4B4AD;
	Tue,  9 Mar 2021 03:34:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2900E4B417
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 03:34:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vYpUjR8hqApy for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 03:34:49 -0500 (EST)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25EC24B386
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 03:34:49 -0500 (EST)
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DvpN94kWnz1436s;
 Tue,  9 Mar 2021 16:31:53 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 9 Mar 2021 16:34:44 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 16:34:44 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing
 tables into a block
To: Will Deacon <will@kernel.org>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-3-wangyanan55@huawei.com>
 <20210308163454.GA26561@willie-the-truck>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <8a947c73-16e9-7ca7-c185-d4c951938505@huawei.com>
Date: Tue, 9 Mar 2021 16:34:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210308163454.GA26561@willie-the-truck>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

Ck9uIDIwMjEvMy85IDA6MzQsIFdpbGwgRGVhY29uIHdyb3RlOgo+IE9uIE1vbiwgSmFuIDI1LCAy
MDIxIGF0IDEwOjEwOjQ0UE0gKzA4MDAsIFlhbmFuIFdhbmcgd3JvdGU6Cj4+IEFmdGVyIGRpcnR5
LWxvZ2dpbmcgaXMgc3RvcHBlZCBmb3IgYSBWTSBjb25maWd1cmVkIHdpdGggaHVnZSBtYXBwaW5n
cywKPj4gS1ZNIHdpbGwgcmVjb3ZlciB0aGUgdGFibGUgbWFwcGluZ3MgYmFjayB0byBibG9jayBt
YXBwaW5ncy4gQXMgd2Ugb25seQo+PiByZXBsYWNlIHRoZSBleGlzdGluZyBwYWdlIHRhYmxlcyB3
aXRoIGEgYmxvY2sgZW50cnkgYW5kIHRoZSBjYWNoZWFiaWxpdHkKPj4gaGFzIG5vdCBiZWVuIGNo
YW5nZWQsIHRoZSBjYWNoZSBtYWludGVuYW5jZSBvcHJlYXRpb25zIGNhbiBiZSBza2lwcGVkLgo+
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBZYW5hbiBXYW5nIDx3YW5neWFuYW41NUBodWF3ZWkuY29tPgo+
PiAtLS0KPj4gICBhcmNoL2FybTY0L2t2bS9tbXUuYyB8IDEyICsrKysrKysrKy0tLQo+PiAgIDEg
ZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS9tbXUuYyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4+IGlu
ZGV4IDhlODU0OWVhMWQ3MC4uMzdiNDI3ZGNiYzRmIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0
L2t2bS9tbXUuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS9tbXUuYwo+PiBAQCAtNzQ0LDcgKzc0
NCw3IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBw
aHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4+ICAgewo+PiAgIAlpbnQgcmV0ID0gMDsKPj4gICAJYm9v
bCB3cml0ZV9mYXVsdCwgd3JpdGFibGUsIGZvcmNlX3B0ZSA9IGZhbHNlOwo+PiAtCWJvb2wgZXhl
Y19mYXVsdDsKPj4gKwlib29sIGV4ZWNfZmF1bHQsIGFkanVzdF9odWdlcGFnZTsKPj4gICAJYm9v
bCBkZXZpY2UgPSBmYWxzZTsKPj4gICAJdW5zaWduZWQgbG9uZyBtbXVfc2VxOwo+PiAgIAlzdHJ1
Y3Qga3ZtICprdm0gPSB2Y3B1LT5rdm07Cj4+IEBAIC04NzIsMTIgKzg3MiwxOCBAQCBzdGF0aWMg
aW50IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgcGh5c19hZGRyX3QgZmF1
bHRfaXBhLAo+PiAgIAkJbWFya19wYWdlX2RpcnR5KGt2bSwgZ2ZuKTsKPj4gICAJfQo+PiAgIAo+
PiAtCWlmIChmYXVsdF9zdGF0dXMgIT0gRlNDX1BFUk0gJiYgIWRldmljZSkKPj4gKwkvKgo+PiAr
CSAqIFRoZXJlIGlzIG5vIG5lY2Vzc2l0eSB0byBwZXJmb3JtIGNhY2hlIG1haW50ZW5hbmNlIG9w
ZXJhdGlvbnMgaWYgd2UKPj4gKwkgKiB3aWxsIG9ubHkgcmVwbGFjZSB0aGUgZXhpc3RpbmcgdGFi
bGUgbWFwcGluZ3Mgd2l0aCBhIGJsb2NrIG1hcHBpbmcuCj4+ICsJICovCj4+ICsJYWRqdXN0X2h1
Z2VwYWdlID0gZmF1bHRfZ3JhbnVsZSA8IHZtYV9wYWdlc2l6ZSA/IHRydWUgOiBmYWxzZTsKPiBu
aXQ6IHlvdSBkb24ndCBuZWVkIHRoZSAnPyB0cnVlIDogZmFsc2UnIHBhcnQKPgo+IFRoYXQgc2Fp
ZCwgeW91ciBwcmV2aW91cyBwYXRjaCBjaGVja3MgZm9yICdmYXVsdF9ncmFudWxlID4gdm1hX3Bh
Z2VzaXplJywKPiBzbyBJJ20gbm90IHN1cmUgdGhlIGxvY2FsIHZhcmlhYmxlIGhlbHBzIGFsbCB0
aGF0IG11Y2ggaGVyZSBiZWNhdXNlIGl0Cj4gb2JzY3VyZXMgdGhlIHNpemUgY2hlY2tzIGluIG15
IG9waW5pb24uIEl0IHdvdWxkIGJlIG1vcmUgc3RyYWlnaHQtZm9yd2FyZAo+IGlmIHdlIGNvdWxk
IHN0cnVjdHVyZSB0aGUgbG9naWMgYXM6Cj4KPgo+IAlpZiAoZmF1bHRfZ3JhbnVsZSA8IHZtYV9w
YWdlc2l6ZSkgewo+Cj4gCX0gZWxzZSBpZiAoZmF1bHRfZ3JhbnVsZSA+IHZtYV9wYWdlX3NpemUp
IHsKPgo+IAl9IGVsc2Ugewo+Cj4gCX0KPgo+IFdpdGggc29tZSBjb21tZW50cyBkZXNjcmliaW5n
IHdoYXQgd2UgY2FuIGluZmVyIGFib3V0IHRoZSBtZW1jYWNoZSBhbmQgY2FjaGUKPiBtYWludGVu
YW5jZSByZXF1aXJlbWVudHMgZm9yIGVhY2ggY2FzZS4KVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rp
b24gaGVyZSwgV2lsbC4KQnV0IEkgaGF2ZSByZXNlbnQgYW5vdGhlciBuZXdlciBzZXJpZXMgWzFd
IChLVk06IGFybTY0OiBJbXByb3ZlIAplZmZpY2llbmN5IG9mIHN0YWdlMiBwYWdlIHRhYmxlKQpy
ZWNlbnRseSwgd2hpY2ggaGFzIHRoZSBzYW1lIHRoZW1lIGJ1dCBkaWZmZXJlbnQgc29sdXRpb25z
IHRoYXQgSSB0aGluayAKYXJlIGJldHRlci4KWzFdIApodHRwczovL2xvcmUua2VybmVsLm9yZy9s
a21sLzIwMjEwMjA4MTEyMjUwLjE2MzU2OC0xLXdhbmd5YW5hbjU1QGh1YXdlaS5jb20vCgpDb3Vs
ZCB5b3UgcGxlYXNlIGNvbW1lbnQgb24gdGhhdCBzZXJpZXMgP8KgIEkgdGhpbmsgaXQgY2FuIGJl
IGZvdW5kIGluIAp5b3VyIGluYm94IDopLgoKVGhhbmtzLAoKWWFuYW4KPgo+IFdpbGwKPiAuCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
