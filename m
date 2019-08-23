Return-Path: <SRS0=1Vfj=WT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33440C3A5A2
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 07:37:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4CBE22CE3
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 07:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4CBE22CE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBDF4A577;
	Fri, 23 Aug 2019 03:37:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n1n5ghlt63tK; Fri, 23 Aug 2019 03:37:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3B4D4A5EF;
	Fri, 23 Aug 2019 03:37:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FDE4A5E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 03:37:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id feV5AeLU83Ht for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Aug 2019 03:37:23 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A3294A577
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Aug 2019 03:37:23 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 31A7C308427C;
 Fri, 23 Aug 2019 07:37:22 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D6E4100194E;
 Fri, 23 Aug 2019 07:37:19 +0000 (UTC)
Subject: Re: Can we boot a 512U kvm guest?
To: Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
 qemu-arm@nongnu.org
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
 <d248e304-9004-02e6-d535-c69bc15d2b41@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <ad819f5c-e8b9-de10-8e88-946397c16716@redhat.com>
Date: Fri, 23 Aug 2019 09:37:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d248e304-9004-02e6-d535-c69bc15d2b41@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.40]); Fri, 23 Aug 2019 07:37:22 +0000 (UTC)
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
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

SGkgWmVuZ2h1aSwKT24gOC8yMy8xOSA0OjIxIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhpIEVy
aWMsCj4gCj4gT24gMjAxOS84LzIyIDE3OjA4LCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBaZW5n
aHVpLAo+Pgo+PiBPbiA4LzEzLzE5IDEwOjUwIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+Pj4gSGkg
Zm9sa3MsCj4+Pgo+Pj4gU2luY2UgY29tbWl0IGUyNTAyOGM4ZGVkMCAoIktWTTogYXJtL2FybTY0
OiBCdW1wIFZHSUNfVjNfTUFYX0NQVVMgdG8KPj4+IDUxMiIpLCB3ZSBzZWVtZWQgdG8gYmUgYWxs
b3dlZCB0byBib290IGEgNTEyVSBndWVzdC7CoCBCdXQgSSBmYWlsZWQgdG8KPj4+IHN0YXJ0IGl0
IHVwIHdpdGggdGhlIGxhdGVzdCBRRU1VLsKgIEkgZ3Vlc3MgdGhlcmUgYXJlIGF0IGxlYXN0ICp0
d28qCj4+PiByZWFzb25zIChsaW1pdGF0aW9ucykuCj4+Pgo+Pj4gRmlyc3QgSSBnb3QgYSBRRU1V
IGFib3J0Ogo+Pj4gwqDCoMKgwqDCoCJrdm1fc2V0X2lycTogSW52YWxpZCBhcmd1bWVudCIKPj4+
Cj4+PiBFbmFibGUgdGhlIHRyYWNlX2t2bV9pcnFfbGluZSgpIHVuZGVyIGRlYnVnZnMsIHdoZW4g
aXQgY29tZWQgd2l0aAo+Pj4gdmNwdS0yNTYsIEkgZ290Ogo+Pj4gwqDCoMKgwqDCoCJJbmplY3Qg
VU5LTk9XTiBpbnRlcnJ1cHQgKDMpLCB2Y3B1LT5pZHg6IDAsIG51bTogMjMsIGxldmVsOiAwIgo+
Pj4gYW5kIGt2bV92bV9pb2N0bF9pcnFfbGluZSgpIHJldHVybnMgLUVJTlZBTCB0byB1c2VyLXNw
YWNlLi4uCj4+Pgo+Pj4gU28gdGhlIHRoaW5nIGlzIHRoYXQgd2Ugb25seSBoYXZlIDggYml0cyBm
b3IgdmNwdV9pbmRleCBmaWVsZCAoWzIzOjE2XSkKPj4+IGluIEtWTV9JUlFfTElORSBpb2N0bC7C
oCBpcnFfdHlwZSBmaWVsZCB3aWxsIGJlIGNvcnJ1cHRlZCBpZiB3ZSBpbmplY3QgYQo+Pj4gUFBJ
IHRvIHZjcHUtMjU2LCB3aG9zZSB2Y3B1X2luZGV4IHdpbGwgdGFrZSA5IGJpdHMuCj4+Pgo+Pj4g
SSB0ZW1wb3JhcmlseSBwYXRjaGVkIHRoZSBLVk0gYW5kIFFFTVUgd2l0aCB0aGUgZm9sbG93aW5n
IGRpZmY6Cj4+Pgo+Pj4gLS0tODwtLS0KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1
ZGUvdWFwaS9hc20va3ZtLmgKPj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5o
Cj4+PiBpbmRleCA5NTUxNmE0Li4zOWEwZmIxIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9p
bmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9h
c20va3ZtLmgKPj4+IEBAIC0zMjUsMTAgKzMyNSwxMCBAQCBzdHJ1Y3Qga3ZtX3ZjcHVfZXZlbnRz
IHsKPj4+IMKgwqAjZGVmaW5lwqDCoCBLVk1fQVJNX1ZDUFVfVElNRVJfSVJRX1BUSU1FUsKgwqDC
oMKgwqDCoMKgIDEKPj4+Cj4+PiDCoMKgLyogS1ZNX0lSUV9MSU5FIGlycSBmaWVsZCBpbmRleCB2
YWx1ZXMgKi8KPj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfU0hJRlTCoMKgwqDCoMKgwqDC
oCAyNAo+Pj4gLSNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhm
Zgo+Pj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9TSElGVMKgwqDCoMKgwqDCoMKgIDI4Cj4+
PiArI2RlZmluZSBLVk1fQVJNX0lSUV9UWVBFX01BU0vCoMKgwqDCoMKgwqDCoCAweGYKPj4+IMKg
wqAjZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfU0hJRlTCoMKgwqDCoMKgwqDCoCAxNgo+Pj4gLSNk
ZWZpbmUgS1ZNX0FSTV9JUlFfVkNQVV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZgo+Pj4gKyNkZWZp
bmUgS1ZNX0FSTV9JUlFfVkNQVV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmYKPj4+IMKgwqAjZGVm
aW5lIEtWTV9BUk1fSVJRX05VTV9TSElGVMKgwqDCoMKgwqDCoMKgIDAKPj4+IMKgwqAjZGVmaW5l
IEtWTV9BUk1fSVJRX05VTV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmZmCj4+Pgo+Pj4gLS0tODwt
LS0KPj4+Cj4+PiBJdCBtYWtlcyB0aGluZ3MgYSBiaXQgYmV0dGVyLCBpdCBhbHNvIGltbWVkaWF0
ZWx5IEJSRUFLcyB0aGUgYXBpIHdpdGgKPj4+IG9sZCB2ZXJzaW9ucy4KPj4+Cj4+Pgo+Pj4gTmV4
dCBjb21lcyBvbmUgbW9yZSBRRU1VIGFib3J0ICh3aXRoIHRoZSAiZml4IiBhYm92ZSk6Cj4+PiDC
oMKgwqDCoMKgIkZhaWxlZCB0byBzZXQgZGV2aWNlIGFkZHJlc3M6IE5vIHNwYWNlIGxlZnQgb24g
ZGV2aWNlIgo+Pj4KPj4+IFdlIHJlZ2lzdGVyIHR3byBpbyBkZXZpY2VzIChyZF9kZXYgYW5kIHNn
aV9kZXYpIG9uIEtWTV9NTUlPX0JVUyBmb3IKPj4+IGVhY2ggcmVkaXN0cmlidXRvci4gNTEyIHZj
cHVzIHRha2UgMTAyNCBpbyBkZXZpY2VzLCB3aGljaCBpcyBiZXlvbmQgdGhlCj4+PiBtYXhpbXVt
IGxpbWl0YXRpb24gb2YgdGhlIGN1cnJlbnQga2VybmVsIC0gTlJfSU9CVVNfREVWUyAoMTAwMCku
Cj4+PiBTbyB3ZSBnZXQgYSBFTk9TUEMgZXJyb3IgaGVyZS4KPj4KPj4gRG8geW91IHBsYW4gdG8g
c2VuZCBhIHBhdGNoIGZvciBpbmNyZWFzaW5nIHRoZSBOUl9JT0JVU19ERVZTPyBPdGhlcndpc2UK
Pj4gSSBjYW4gZG8gaXQuCj4gCj4gWy4uLl0KPiAKPj4gWW91IG1lbnRpb25lZCB5b3Ugc3RhcnRl
ZCB3b3JraW5nIG9uIHRoZSBRRU1VIGZpeC4gRG8geW91IHBsYW4gdG8gc3VibWl0Cj4+IHBhdGNo
ZXMgdG8gdGhlIE1MIG9yIGRvIHlvdSB3YW50IG1lIHRvIGF0dGVtcHQgdG8gZml4IHRoZSBzaXR1
YXRpb24gb24KPj4gdXNlcnNwYWNlPwo+IEFjdHVhbGx5LCBJIGhhdmVuJ3Qgc3RhcnRlZCBhbnl0
aGluZyB5ZXQuwqAgSXQgd291bGQgYmUgZ3JlYXQgaWYgeW91IGNhbgo+IGhlbHAgdG8gZml4IHRo
aXMgaW4gUUVNVS7CoCBZZXMsIHBsZWFzZSBoZWxwLiA6KQo+IAo+IEFuZCBwbGVhc2UgY2MgbWUg
d2hlbiB5b3Ugc2VuZCB0aGUgcGF0Y2ggc28gdGhhdCBJIGNhbiBkbyBzb21lIHRlc3RzIGluCj4g
dGhlIGZyZWUgdGltZS4KU3VyZSwgSSB3aWxsIHdvcmsgb24gdGhpcy4KClRoYW5rcwoKRXJpYwo+
IAo+IAo+IE1hbnkgdGhhbmtzLAo+IHplbmdodWkKPiAKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
