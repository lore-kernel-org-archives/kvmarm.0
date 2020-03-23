Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E067FC3F2CD
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 12:40:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73AC620663
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 12:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73AC620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE69F4B09A;
	Mon, 23 Mar 2020 08:40:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E-ZsADer+rdh; Mon, 23 Mar 2020 08:40:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB0D4B09B;
	Mon, 23 Mar 2020 08:40:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6045A4A534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:40:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2RqxvhSkTXgJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 08:40:23 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD3584A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 08:40:22 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 63E252ECE21C08DF8A96;
 Mon, 23 Mar 2020 20:40:18 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 20:40:11 +0800
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To: Marc Zyngier <maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
 <256b58a9679412c96600217f316f424f@kernel.org>
 <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
 <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <49fedfb3-ea4a-a18b-f453-86f43be7f18f@huawei.com>
Date: Mon, 23 Mar 2020 20:40:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
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

SGkgTWFyYywKCk9uIDIwMjAvMy8yMyAxNjoyNSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gWy4uLl0KPiAKPj4+IEFuZCBhY3R1YWxseSwgbWF5YmUgd2UgY2FuIGhhbmRs
ZSB0aGF0IHByZXR0eSBjaGVhcGx5LiBJZiB1c2Vyc3BhY2UKPj4+IHRyaWVzIHRvIHJlc3RvcmUg
R0lDRF9UWVBFUjIgdG8gYSB2YWx1ZSB0aGF0IGlzbid0IHdoYXQgS1ZNIGNhbgo+Pj4gb2ZmZXIs
IHdlIGp1c3QgcmV0dXJuIGFuIGVycm9yLiBFeGFjdGx5IGxpa2Ugd2UgZG8gZm9yIEdJQ0RfSUlE
Ui4KPj4+IEhlbmNlIHRoZSBmb2xsb3dpbmcgcGF0Y2g6Cj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL3Zp
cnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jIAo+Pj4gYi92aXJ0L2t2bS9hcm0vdmdpYy92
Z2ljLW1taW8tdjMuYwo+Pj4gaW5kZXggMjhiNjM5ZmQxYWJjLi5lNzJkY2M0NTQyNDcgMTAwNjQ0
Cj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+Pj4gKysrIGIvdmly
dC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPj4+IEBAIC0xNTYsNiArMTU2LDcgQEAgc3Rh
dGljIGludCB2Z2ljX21taW9fdWFjY2Vzc193cml0ZV92M19taXNjKHN0cnVjdCAKPj4+IGt2bV92
Y3B1ICp2Y3B1LAo+Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0ID0gJnZjcHUt
Pmt2bS0+YXJjaC52Z2ljOwo+Pj4KPj4+IMKgwqDCoMKgwqAgc3dpdGNoIChhZGRyICYgMHgwYykg
ewo+Pj4gK8KgwqDCoCBjYXNlIEdJQ0RfVFlQRVIyOgo+Pj4gwqDCoMKgwqDCoCBjYXNlIEdJQ0Rf
SUlEUjoKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodmFsICE9IHZnaWNfbW1pb19yZWFkX3Yz
X21pc2ModmNwdSwgYWRkciwgbGVuKSkKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiAtRUlOVkFMOwo+Pj4KPj4+IEJlaW5nIGEgUk8gcmVnaXN0ZXIsIHdyaXRpbmcgc29tZXRo
aW5nIHRoYXQgaXNuJ3QgY29tcGF0aWJsZSB3aXRoIHRoZQo+Pj4gcG9zc2libGUgYmVoYXZpb3Vy
IG9mIHRoZSBoeXBlcnZpc29yIHdpbGwganVzdCByZXR1cm4gYW4gZXJyb3IuCj4+Cj4+IFRoaXMg
aXMgcmVhbGx5IGEgbmljZSBwb2ludCB0byBhZGRyZXNzIG15IGNvbmNlcm4hIEknbSBoYXBweSB0
byBzZWUKPj4gdGhpcyBpbiB2NiBub3cuCj4+Cj4+Pgo+Pj4gV2hhdCBkbyB5b3UgdGhpbms/Cj4+
Cj4+IEkgYWdyZWVkIHdpdGggeW91LCB3aXRoIGEgYml0IG5lcnZvdXMgdGhvdWdoLiBTb21lIG9s
ZCBndWVzdHMgKHdoaWNoCj4+IGhhdmUgbm8ga25vd2xlZGdlIGFib3V0IEdJQ3Y0LjEgdlNHSXMg
YW5kIGRvbid0IGNhcmUgYWJvdXQgbkFTU0dJY2FwCj4+IGF0IGFsbCkgd2lsbCBhbHNvIGZhaWwg
dG8gbWlncmF0ZSBmcm9tIEEgdG8gQiwganVzdCBiZWNhdXNlIG5vdyB3ZQo+PiBwcmVzZW50IHR3
byBkaWZmZXJlbnQgKHVudXNlZCkgR0lDRF9UWVBFUjIgcmVnaXN0ZXJzIHRvIHRoZW0uCj4+Cj4+
IElzIGl0IGEgbGl0dGxlIHVuZmFpciB0byB0aGVtIDotKSA/Cj4gCj4gSSBuZXZlciBwcmV0ZW5k
ZWQgdG8gYmUgZmFpciEgOy0pCj4gCj4gSSdtIGhhcHB5IHRvIHByZXZlbnQgbWlncmF0aW5nIGZy
b20gYSB2NC4xIHN5c3RlbSAoQSkgdG8gYSB2NC4wCj4gc3lzdGVtIChCKS4gQXMgc29vbiBhcyB0
aGUgZ3Vlc3QgaGFzIHJ1biwgaXQgaXNuJ3Qgc2FmZSB0byBkbyBzbwo+IChpdCBtYXkgaGF2ZSBy
ZWFkIFRZUEVSMiwgYW5kIG5vdyBrbm93cyBhYm91dCB2U0dJcykuIFdlICpjb3VsZCoKPiB0cmFj
ayB0aGlzIGFuZCBmaW5kIHdheXMgdG8gbWlncmF0ZSB0aGlzIHN0YXRlIGFzIHdlbGwsIGJ1dCBp
dAo+IGZlZWxzIGZyYWdpbGUuCj4gCj4gTWlncmF0aW5nIGZyb20gQiB0byBBIGlzIG1vcmUgYXBw
ZWFsaW5nLiBJdCBzaG91bGQgYmUgcG9zc2libGUgdG8KPiBkbyBzbyB3aXRob3V0IG11Y2ggZGlm
ZmljdWx0eSAoanVzdCBjaGVjayB0aGF0IHRoZSBuQVNTR0ljYXAgYml0Cj4gaXMgZWl0aGVyIDAg
b3IgZXF1YWwgdG8gS1ZNJ3MgdmlldyBvZiB0aGUgY2FwYWJpbGl0eSkuCj4gCj4gQnV0IG92ZXJh
bGwgSSBzZXJpb3VzbHkgZG91YnQgd2UgY2FuIGVhc2lseSBtaWdyYXRlIGd1ZXN0cyBhY3Jvc3MK
PiB2ZXJ5IGRpZmZlcmVudCBIVy4gV2UndmUgYmVlbiB0YWxraW5nIGFib3V0IHRoaXMgZm9yIHll
YXJzLCBhbmQKPiB3ZSBzdGlsbCBkb24ndCBoYXZlIGEgZ29vZCBzb2x1dGlvbiBmb3IgaXQgZ2l2
ZW4gdGhlIGRpdmVyc2l0eQo+IG9mIHRoZSBlY29zeXN0ZW0uLi4gOi0vCgpGYWlyIGVub3VnaC4g
VGhhbmtzIGZvciB5b3VyIGRldGFpbGVkIGV4cGxhbmF0aW9uIQoKClplbmdodWkKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
