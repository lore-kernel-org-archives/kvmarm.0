Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D387BC4332E
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 08:11:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C58420736
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 08:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C58420736
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B445F4B085;
	Mon, 23 Mar 2020 04:11:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1w7P6d6eaN6; Mon, 23 Mar 2020 04:11:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B624B09A;
	Mon, 23 Mar 2020 04:11:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 228834B09A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 04:11:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id elTLb5cRNnZI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 04:11:19 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F14AA4A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 04:11:18 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CDDB242FB3B17C38F76B;
 Mon, 23 Mar 2020 16:11:09 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 16:11:02 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
 <256b58a9679412c96600217f316f424f@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
Date: Mon, 23 Mar 2020 16:11:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <256b58a9679412c96600217f316f424f@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert
 Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDIwMjAvMy8yMCAxNzowMSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gT24gMjAyMC0wMy0yMCAwMzo1MywgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSGkg
TWFyYywKPj4KPj4gT24gMjAyMC8zLzE5IDIwOjEwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4g
QnV0IEkgd29uZGVyIHRoYXQgc2hvdWxkIHdlIHVzZSBuYXNzZ2lyZXEgdG8gKm9ubHkqIGtlZXAg
dHJhY2sgd2hhdAo+Pj4+IHRoZSBndWVzdCBoYWQgd3JpdHRlbiBpbnRvIHRoZSBHSUNEX0NUTFIu
bkFTU0dJcmVxLsKgIElmIG5vdCwgd2UgbWF5Cj4+Pj4gbG9zZSB0aGUgZ3Vlc3QtcmVxdWVzdCBi
aXQgYWZ0ZXIgbWlncmF0aW9uIGFtb25nIGhvc3RzIHdpdGggZGlmZmVyZW50Cj4+Pj4gaGFzX2dp
Y3Y0XzEgc2V0dGluZ3MuCj4+Pgo+Pj4gSSdtIHVuc3VyZSBvZiB3aGF0IHlvdSdyZSBzdWdnZXN0
aW5nIGhlcmUuIElmIHVzZXJzcGFjZSB0cmllcyB0byBzZXQKPj4+IEdJQ0RfQ1RMUi5uQVNTR0ly
ZXEgb24gYSBub24tNC4xIGhvc3QsIHRoaXMgYml0IHdpbGwgbm90IGxhdGNoLgo+Pgo+PiBUaGlz
IGlzIGV4YWN0bHkgd2hhdCBJICp3YXMqIGNvbmNlcm5pbmcgYWJvdXQuCj4+Cj4+PiBVc2Vyc3Bh
Y2UgY2FuIGNoZWNrIHRoYXQgYXQgcmVzdG9yZSB0aW1lLiBPciB3ZSBjb3VsZCBmYWlsIHRoZQo+
Pj4gdXNlcnNwYWNlIHdyaXRlLCB3aGljaCBpcyBhIGJpdCBvZGQgKHRoZSBiaXQgaXMgb3RoZXJ3
aXNlIFJFUzApLgo+Pj4KPj4+IENvdWxkIHlvdSBjbGFyaWZ5IHlvdXIgcHJvcG9zYWw/Cj4+Cj4+
IExldCdzIGFzc3VtZSB0d28gaG9zdHMgYmVsb3cuICdoYXNfZ2ljdjRfMScgaXMgdHJ1ZSBvbiBo
b3N0LUEgd2hpbGUKPj4gaXQgaXMgZmFsc2Ugb24gaG9zdC1CIGJlY2F1c2Ugb2YgbGFjayBvZiBI
VyBzdXBwb3J0IG9yIHRoZSBrZXJuZWwKPj4gcGFyYW1ldGVyICJrdm0tYXJtLnZnaWNfdjRfZW5h
YmxlPTAiLgo+Pgo+PiBJZiB3ZSBtaWdyYXRlIGd1ZXN0IHRocm91Z2ggQS0+Qi0+QSwgd2UgbWF5
IGVuZC11cCBsb3NlIHRoZSBpbml0aWFsCj4+IGd1ZXN0LXJlcXVlc3QgIm5BU1NHSXJlcT0xIiBh
bmQgZG9uJ3QgdXNlIGRpcmVjdCB2U0dJIGRlbGl2ZXJ5IGZvcgo+PiB0aGlzIGd1ZXN0IHdoZW4g
aXQncyBtaWdyYXRlZCBiYWNrIHRvIGhvc3QtQS4KPiAKPiBNeSBwb2ludCBhYm92ZSBpcyB0aGF0
IHdlIHNob3VsZG4ndCBhbGxvdyB0aGUgQS0+QiBtaWdyYXRpb24gdGhlIGZpcnN0Cj4gcGxhY2Us
IGFuZCBmYWlsIGl0IGFzIHF1aWNrbHkgYXMgcG9zc2libGUuIFdlIGRvbid0IGtub3cgd2hhdCB0
aGUgZ3Vlc3QKPiBoYXMgb2JzZXJ2ZWQgaW4gdGVybXMgb2YgR0lDIGNhcGFiaWxpdHksIGFuZCBp
dCBtYXkgbm90IGhhdmUgZW5hYmxlZCB0aGUKPiBuZXcgZmxhdm91ciBvZiBTR0lzIGp1c3QgeWV0
LgoKSW5kZWVkLiBJIGRpZG4ndCByZWFsaXplIGl0LgoKPiAKPj4gVGhpcyBjYW4gYmUgImZpeGVk
IiBieSBrZWVwIHRyYWNrIG9mIHdoYXQgZ3Vlc3QgaGFkIHdyaXR0ZW4gaW50bwo+PiBuQVNTR0ly
ZXEuIEFuZCB3ZSBuZWVkIHRvIGV2YWx1YXRlIHRoZSBuZWVkIGZvciB1c2luZyBkaXJlY3QgdlNH
SQo+PiBmb3IgYSBzcGVjaWZpZWQgZ3Vlc3QgYnkgJ2hhc19naWN2NF8xICYmIG5hc3NnaXJlcScu
Cj4gCj4gSXQgZmVlbHMgb2RkLiBJdCBtZWFucyB3ZSBoYXZlIG1vcmUgc3RhdGUgdGhhbiB0aGUg
SFcgbm9ybWFsbHkgaGFzLgo+IEkgaGF2ZSBhbiBhbHRlcm5hdGl2ZSBwcm9wb3NhbCwgc2VlIGJl
bG93Lgo+IAo+PiBCdXQgaWYgaXQncyBleHBlY3RlZCB0aGF0ICJpZiB1c2Vyc3BhY2UgdHJpZXMg
dG8gc2V0IG5BU1NHSXJlcSBvbgo+PiBhIG5vbi00LjEgaG9zdCwgdGhpcyBiaXQgd2lsbCBub3Qg
bGF0Y2giLCB0aGVuIHRoaXMgc2hvdWxkbid0IGJlCj4+IGEgcHJvYmxlbSBhdCBhbGwuCj4gCj4g
V2VsbCwgdGhhdCBpcyB0aGUgc2VtYW50aWNzIG9mIHRoZSBSRVMwIGJpdC4gSXQgYXBwbGllcyBm
cm9tIGJvdGgKPiBndWVzdCBhbmQgdXNlcnNwYWNlLgo+IAo+IEFuZCBhY3R1YWxseSwgbWF5YmUg
d2UgY2FuIGhhbmRsZSB0aGF0IHByZXR0eSBjaGVhcGx5LiBJZiB1c2Vyc3BhY2UKPiB0cmllcyB0
byByZXN0b3JlIEdJQ0RfVFlQRVIyIHRvIGEgdmFsdWUgdGhhdCBpc24ndCB3aGF0IEtWTSBjYW4K
PiBvZmZlciwgd2UganVzdCByZXR1cm4gYW4gZXJyb3IuIEV4YWN0bHkgbGlrZSB3ZSBkbyBmb3Ig
R0lDRF9JSURSLgo+IEhlbmNlIHRoZSBmb2xsb3dpbmcgcGF0Y2g6Cj4gCj4gZGlmZiAtLWdpdCBh
L3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jIAo+IGIvdmlydC9rdm0vYXJtL3ZnaWMv
dmdpYy1tbWlvLXYzLmMKPiBpbmRleCAyOGI2MzlmZDFhYmMuLmU3MmRjYzQ1NDI0NyAxMDA2NDQK
PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+ICsrKyBiL3ZpcnQva3Zt
L2FybS92Z2ljL3ZnaWMtbW1pby12My5jCj4gQEAgLTE1Niw2ICsxNTYsNyBAQCBzdGF0aWMgaW50
IHZnaWNfbW1pb191YWNjZXNzX3dyaXRlX3YzX21pc2Moc3RydWN0IAo+IGt2bV92Y3B1ICp2Y3B1
LAo+ICDCoMKgwqDCoCBzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0ID0gJnZjcHUtPmt2bS0+YXJjaC52
Z2ljOwo+IAo+ICDCoMKgwqDCoCBzd2l0Y2ggKGFkZHIgJiAweDBjKSB7Cj4gK8KgwqDCoCBjYXNl
IEdJQ0RfVFlQRVIyOgo+ICDCoMKgwqDCoCBjYXNlIEdJQ0RfSUlEUjoKPiAgwqDCoMKgwqDCoMKg
wqDCoCBpZiAodmFsICE9IHZnaWNfbW1pb19yZWFkX3YzX21pc2ModmNwdSwgYWRkciwgbGVuKSkK
PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+IAo+IEJlaW5nIGEg
Uk8gcmVnaXN0ZXIsIHdyaXRpbmcgc29tZXRoaW5nIHRoYXQgaXNuJ3QgY29tcGF0aWJsZSB3aXRo
IHRoZQo+IHBvc3NpYmxlIGJlaGF2aW91ciBvZiB0aGUgaHlwZXJ2aXNvciB3aWxsIGp1c3QgcmV0
dXJuIGFuIGVycm9yLgoKVGhpcyBpcyByZWFsbHkgYSBuaWNlIHBvaW50IHRvIGFkZHJlc3MgbXkg
Y29uY2VybiEgSSdtIGhhcHB5IHRvIHNlZQp0aGlzIGluIHY2IG5vdy4KCj4gCj4gV2hhdCBkbyB5
b3UgdGhpbms/CgpJIGFncmVlZCB3aXRoIHlvdSwgd2l0aCBhIGJpdCBuZXJ2b3VzIHRob3VnaC4g
U29tZSBvbGQgZ3Vlc3RzICh3aGljaApoYXZlIG5vIGtub3dsZWRnZSBhYm91dCBHSUN2NC4xIHZT
R0lzIGFuZCBkb24ndCBjYXJlIGFib3V0IG5BU1NHSWNhcAphdCBhbGwpIHdpbGwgYWxzbyBmYWls
IHRvIG1pZ3JhdGUgZnJvbSBBIHRvIEIsIGp1c3QgYmVjYXVzZSBub3cgd2UKcHJlc2VudCB0d28g
ZGlmZmVyZW50ICh1bnVzZWQpIEdJQ0RfVFlQRVIyIHJlZ2lzdGVycyB0byB0aGVtLgoKSXMgaXQg
YSBsaXR0bGUgdW5mYWlyIHRvIHRoZW0gOi0pID8KCgpUaGFua3MsClplbmdodWkKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
