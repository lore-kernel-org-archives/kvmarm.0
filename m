Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BF8C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 01:46:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D154206F4
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 01:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D154206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 929514BB17;
	Sun, 16 Aug 2020 21:46:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tQp0G2DJHgv3; Sun, 16 Aug 2020 21:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 815C64BA4E;
	Sun, 16 Aug 2020 21:46:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 239474BA4E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2020 21:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6vGfM9fmwd9u for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Aug 2020 21:46:28 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 159C04B69A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2020 21:46:28 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id C2D54D38E42019B5E021;
 Mon, 17 Aug 2020 09:46:24 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 17 Aug 2020
 09:46:18 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To: Marc Zyngier <maz@kernel.org>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
 <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
Date: Mon, 17 Aug 2020 09:46:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

T24gOC8xMS8yMDIwIDM6NDkgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIwLTA4LTEx
IDAyOjQ4LCBKaW5neWkgV2FuZyB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4gT24gOC81LzIwMjAg
ODoxMyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gT24gMjAyMC0wOC0wNSAxMjo1NCwgSmlu
Z3lpIFdhbmcgd3JvdGU6Cj4+Pj4gSGkgYWxsLAo+Pj4+Cj4+Pj4gQ3VycmVudGx5LCBrdm0tdW5p
dC10ZXN0cyBvbmx5IHN1cHBvcnQgR0lDdjMgdkxQSSBpbmplY3Rpb24uIE1heSBJIGFzawo+Pj4+
IGlzIHRoZXJlIGFueSBwbGFuIG9yIHN1Z2dlc3Rpb24gb24gY29uc3RydWN0aW5nIGlycSBieXBh
c3MgbWVjaGFuaXNtCj4+Pj4gdG8gdGVzdCB2TFBJIGRpcmVjdCBpbmplY3Rpb24gaW4ga3ZtLXVu
aXQtdGVzdHM/Cj4+Pgo+Pj4gSSdtIG5vdCBzdXJlIHdoYXQgeW91IGFyZSBhc2tpbmcgZm9yIGhl
cmUuIFZMUElzIGFyZSBvbmx5IGRlbGl2ZXJlZAo+Pj4gZnJvbSBhIEhXIGRldmljZSwgYW5kIHRo
ZSBvZmZsb2FkaW5nIG1lY2hhbmlzbSBpc24ndCB2aXNpYmxlIGZyb20KPj4+IHVzZXJzcGFjZSAo
eW91IGVpdGhlciBoYXZlIGFuIGVuYWJsZWQgR0lDdjQgaW1wbGVtZW50YXRpb24sIG9yCj4+PiB5
b3UgZG9uJ3QpLgo+Pj4KPj4+IFRoZXJlIGFyZSB3YXlzIHRvICp0cmlnZ2VyKiBkZXZpY2UgTVNJ
cyBmcm9tIHVzZXJzcGFjZSBhbmQgaW5qZWN0Cj4+PiB0aGVtIGluIGEgZ3Vlc3QsIGJ1dCB0aGF0
J3Mgb25seSBhIGRlYnVnIGZlYXR1cmUsIHdoaWNoIHNob3VsZG4ndAo+Pj4gYmUgZW5hYmxlZCBv
biBhIHByb2R1Y3Rpb24gc3lzdGVtLgo+Pj4KPj4+IMKgwqDCoMKgwqDCoMKgwqAgTS4KPj4KPj4g
U29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5Lgo+Pgo+PiBBcyBJIG1lbnRpb25lZCBiZWZvcmUsIHdl
IHdhbnQgdG8gYWRkIHZMUEkgZGlyZWN0IGluamVjdGlvbiB0ZXN0Cj4+IGluIEtVVCwgbWVhbndo
aWxlIG1lYXN1cmUgdGhlIGxhdGVuY3kgb2YgaGFyZHdhcmUgdkxQSSBpbmplY3Rpb24uCj4+Cj4+
IFN1cmUsIHZMUEkgaXMgdHJpZ2dlcmVkIGJ5IGhhcmR3YXJlLiBTaW5jZSBrZXJuZWwgc3VwcG9y
dHMgc2VuZGluZwo+PiBJVFMgSU5UIGNvbW1hbmQgaW4gZ3Vlc3QgdG8gdHJpZ2dlciB2TFBJLCBJ
IHdvbmRlciBpZiBpdCBpcyBwb3NzaWJsZQo+IAo+IFNvIGNhbiB0aGUgaG9zdC4KPiAKPj4gdG8g
YWRkIGFuIGV4dHJhIGludGVyZmFjZSB0byBtYWtlIGEgdkxQSSBoYXJkd2FyZS1vZmZsb2FkKGp1
c3QgYXMKPj4ga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKSBkb2VzKS4gSWYgc28sIHZnaWNf
aXRzX3RyaWdnZXJfbXNpKCkKPj4gY2FuIGluamVjdCB2TFBJIGRpcmVjdGx5IGluc3RlYWQgb2Yg
dXNpbmcgTFIuCj4gCj4gVGhlIGludGVyZmFjZSBleGlzdHMsIGl0IGlzIGluIGRlYnVnZnMuIEJ1
dCBpdCBtYW5kYXRlcyB0aGF0IHRoZQo+IGRldmljZSBleGlzdHMuIEFuZCBubywgSSBhbSBub3Qg
d2lsbGluZyB0byBhZGQgYW4gZXh0cmEgS1ZNIHVzZXJzcGFjZQo+IEFQSSBmb3IgdGhpcy4KPiAK
PiBUaGUgd2hvbGUgY29uY2VwdCBvZiBpbmplY3RpbmcgYW4gSU5UIHRvIG1lYXN1cmUgdGhlIHBl
cmZvcm1hbmNlCj4gb2YgR0lDdjQgaXMgc2xpZ2h0bHkgYm9ua2VycywgYWN0dWFsbHkuIE1vc3Qg
b2YgdGhlIGNvc3QgaXMgcGFpZAo+IG9uIHRoZSBpbmplY3Rpb24gcGF0aCAocXVldWluZyBhIHBh
aXIgb2YgY29tbWFuZCwgd2FpdGluZyB1bnRpbAo+IHRoZSBJVFMgd2FrZXMgdXAgYW5kIGdlbmVy
YXRlIHRoZSBzaWduYWwuLi4pLgo+IAo+IFdoYXQgeW91IHJlYWxseSB3YW50IHRvIG1lYXN1cmUg
aXMgdGhlIHRpbWUgZnJvbSBnZW5lcmF0aW9uIG9mCj4gdGhlIExQSSBieSBhIGRldmljZSB1bnRp
bCB0aGUgZ3Vlc3QgYWNrbm93bGVkZ2VzIHRoZSBpbnRlcnJ1cHQKPiB0byB0aGUgZGV2aWNlIGl0
c2VsZi4gYW5kIHRoaXMgY2FuIG9ubHkgYmUgaW1wbGVtZW50ZWQgaW4gdGhlCj4gZGV2aWNlLgo+
IAo+ICDCoMKgwqDCoMKgwqDCoCBNLgoKT0sgdW5kZXJzdG9vZC4gSSBqdXN0IHRob3VnaHQgbWVh
c3VyaW5nIHRoZSBsYXRlbmN5IG9mIHRoZSBwYXRoCmt2bS0+Z3Vlc3QgY2FuIGJlIHVzZWZ1bC4K
ClRoYW5rcywKSmluZ3lpCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
