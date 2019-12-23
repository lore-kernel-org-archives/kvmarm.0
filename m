Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54067C2D0C0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 06:55:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA88620663
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 06:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA88620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340764AEE6;
	Mon, 23 Dec 2019 01:55:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IL91rmIDhEfZ; Mon, 23 Dec 2019 01:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE9D4AF29;
	Mon, 23 Dec 2019 01:55:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D085E4AEE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 01:54:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tCQbkGPAornb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 01:54:43 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF6314AF29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 01:51:05 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 48FF52AF828E5AFB0898;
 Mon, 23 Dec 2019 14:51:00 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Dec 2019
 14:50:53 +0800
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Handle GICR_PENDBASER.PTZ filed as
 RAZ
To: Marc Zyngier <maz@kernel.org>, <eric.auger@redhat.com>
References: <20191220111833.1422-1-yuzenghui@huawei.com>
 <71e3dcc00ad5ab8dffd732bfe7381705@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5f5f499a-d025-cc9f-66f3-37fe958df246@huawei.com>
Date: Mon, 23 Dec 2019 14:50:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <71e3dcc00ad5ab8dffd732bfe7381705@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

SGkgTWFyYywgRXJpYywKCk9uIDIwMTkvMTIvMjAgMjE6MDcsIE1hcmMgWnluZ2llciB3cm90ZToK
PiBPbiAyMDE5LTEyLTIwIDExOjE4LCBaZW5naHVpIFl1IHdyb3RlOgo+PiBBbHRob3VnaCBndWVz
dCB3aWxsIGhhcmRseSByZWFkIGFuZCB1c2UgdGhlIFBUWiAoUGVuZGluZyBUYWJsZSBaZXJvKQo+
PiBiaXQgaW4gR0lDUl9QRU5EQkFTRVIsIGxldCB1cyBlbXVsYXRlIHRoZSBhcmNoaXRlY3R1cmUg
c3RyaWN0bHkuCj4+IEFzIHBlciBJSEkgMDA2OUUgOS4xMS4zMCwgUFRaIGZpZWxkIGlzIFdPLCBh
bmQgcmVhZHMgYXMgMC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVp
QGh1YXdlaS5jb20+Cj4+IC0tLQo+Pgo+PiBOb3RpY2VkIHdoZW4gY2hlY2tpbmcgYWxsIGZpZWxk
cyBvZiBHSUNSX1BFTkRCQVNFUiByZWdpc3Rlci4KPj4gQnV0IF9ub3RfIHN1cmUgd2hldGhlciBp
dCdzIHdvcnRoIGEgZml4LCBhcyBMaW51eCBuZXZlciBzZXRzCj4+IHRoZSBQVFogYml0IGJlZm9y
ZSBlbmFibGluZyBMUEkgKHNldCBHSUNSX0NUTFJfRU5BQkxFX0xQSVMpLgo+Pgo+PiBBbmQgSSB3
b25kZXIgdW5kZXIgd2hpY2ggc2NlbmFyaW9zIGNhbiB0aGlzIGJpdCBiZSB3cml0dGVuIGFzIDEu
Cj4+IEl0IHNlZW1zIGRpZmZpY3VsdCBmb3Igc29mdHdhcmUgdG8gZGV0ZXJtaW5lIHdoZXRoZXIg
dGhlIHBlbmRpbmcKPj4gdGFibGUgY29udGFpbnMgYWxsIHplcm9zIHdoZW4gd3JpdGluZyB0aGlz
IGJpdC4KPiAKPiBUaGlzIGlzIGEgdXNlbGVzcyBIVyBvcHRpbWl6YXRpb24sIHdoZXJlIGl0IGNh
biBhdm9pZCByZWFkaW5nIHRoZQo+IHBlbmRpbmcgdGFibGUgdGhlIHZlcnkgZmlyc3QgdGltZSB5
b3Ugd3JpdGUgdG8gdGhpcyByZWdpc3RlciBpZgo+IGl0IGlzIHRvbGQgdGhhdCBpdCBpcyBhbGwg
emVyby4gQSBkZWNlbnQgSVRTIGltcGxlbWVudGF0aW9uCj4gYWxyZWFkeSBoYXMgYSBtZWNoYW5p
c20gdG8gZmluZCBvdXQgYWJvdXQgdGhlIHBlbmRpbmcgYml0cyBieQo+IGxvb2tpbmcgaW50byB0
aGUgSU1QREVGIGFyZWEgKHRoZSBmaXJzdCAxa0IpIG9mIHRoZSBwZW5kaW5nIHRhYmxlLgoKWWVh
aCwgQUZBSUNUIHRoaXMgaXMgd2hhdCBIaXNpbGljb24gaGFzIGFscmVhZHkgaW1wbGVtZW50ZWQg
dG9kYXkuCgo+IFBUWiBpcyBqdXN0IHlldCBhbm90aGVyIHdheSB0byBkbyB0aGUgc2FtZSB0aGlu
Zy4KPiAKPiBUaGlzIGNhbiBvbmx5IGhhcHBlbiBvbmNlIGluIHRoZSBsaWZldGltZSBvZiB0aGUg
c3lzdGVtICh3aGVuIGFsbG9jYXRpbmcKPiB0aGUgdGFibGUpLCBhbmQgTGludXggZG9lc24ndCBy
ZWFsbHkgY2FyZS4KCkkgbm93IGdldCBpdCwgdGhhbmtzIGZvciB0ZWFjaGluZyBtZSB0aGF0IQoK
PiBBcyB1c3VhbCwgdGhlIEdJQyBpcyBzZXR0aW5nCj4gdGhlIGxldmVsIG9mIHVzZWxlc3MgY29t
cGxleGl0eSBwcmV0dHkgaGlnaC4uLgo+IAo+Pgo+PiDCoHZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
bW1pby12My5jIHwgNSArKysrLQo+PiDCoDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
bW1pby12My5jCj4+IGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPj4gaW5kZXgg
N2RmZDE1ZGJiMzA4Li5lYmMyMTg4NDBmYzIgMTAwNjQ0Cj4+IC0tLSBhL3ZpcnQva3ZtL2FybS92
Z2ljL3ZnaWMtbW1pby12My5jCj4+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12
My5jCj4+IEBAIC00MTQsOCArNDE0LDExIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nCj4+IHZnaWNf
bW1pb19yZWFkX3BlbmRiYXNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ3BhX3QgYWRkciwgdW5zaWdu
ZWQgaW50IGxlbikKPj4gwqB7Cj4+IMKgwqDCoMKgIHN0cnVjdCB2Z2ljX2NwdSAqdmdpY19jcHUg
PSAmdmNwdS0+YXJjaC52Z2ljX2NwdTsKPj4gK8KgwqDCoCB1NjQgdmFsdWUgPSB2Z2ljX2NwdS0+
cGVuZGJhc2VyOwo+Pgo+PiAtwqDCoMKgIHJldHVybiBleHRyYWN0X2J5dGVzKHZnaWNfY3B1LT5w
ZW5kYmFzZXIsIGFkZHIgJiA3LCBsZW4pOwo+PiArwqDCoMKgIHZhbHVlICY9IH5HSUNSX1BFTkRC
QVNFUl9QVFo7Cj4+ICsKPj4gK8KgwqDCoCByZXR1cm4gZXh0cmFjdF9ieXRlcyh2YWx1ZSwgYWRk
ciAmIDcsIGxlbik7Cj4+IMKgfQo+Pgo+PiDCoHN0YXRpYyB2b2lkIHZnaWNfbW1pb193cml0ZV9w
ZW5kYmFzZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4gCj4gT3RoZXJ3aXNlIGxvb2tzIGdvb2Qu
IEknbGwgcXVldWUgaXQgd2l0aCBFcmljJ3MgY29ycmVjdGlvbgo+IHRvIHRoZSBzdWJqZWN0IGxp
bmUuCgpUaGFua3MgYm90aCBhbmQgTWVycnkgQ2hyaXN0bWFzIQoKWmVuZ2h1aQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
