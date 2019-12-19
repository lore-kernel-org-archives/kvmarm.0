Return-Path: <SRS0=v2jq=2J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CA2C43603
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 03:05:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA3032072B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 03:05:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA3032072B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31ABD4A59B;
	Wed, 18 Dec 2019 22:05:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VYRO5rcECr-2; Wed, 18 Dec 2019 22:05:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2CF4A597;
	Wed, 18 Dec 2019 22:05:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AA34A597
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 22:05:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nu7FvlFwk5Cn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 22:05:27 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2D6B4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 22:05:26 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id B8CCE53371AB78EB18E1;
 Thu, 19 Dec 2019 11:05:23 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 11:05:11 +0800
Subject: Re: [PATCH v2 13/36] irqchip/gic-v4.1: Don't use the VPE proxy if
 RVPEID is set
To: Marc Zyngier <maz@kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
 <20191027144234.8395-14-maz@kernel.org>
 <8514ccbe-814a-5bdd-3791-bdd65510ce68@huawei.com>
 <762f78e917ac501629729fcf7718178c@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <aba3b852-9ab9-c3b6-f19d-2bc18bd6566a@huawei.com>
Date: Thu, 19 Dec 2019 11:05:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <762f78e917ac501629729fcf7718178c@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, Jayachandran C <jnair@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDIwMTkvMTIvMTggMjI6MzksIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAy
MDE5LTExLTAxIDExOjA1LCBaZW5naHVpIFl1IHdyb3RlOgo+PiBIaSBNYXJjLAo+Pgo+PiBPbiAy
MDE5LzEwLzI3IDIyOjQyLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBUaGUgaW5mYW1vdXMgVlBF
IHByb3h5IGRldmljZSBpc24ndCB1c2VkIHdpdGggR0lDdjQuMSBiZWNhdXNlOgo+Pj4gLSB3ZSBj
YW4gaW52YWxpZGF0ZSBhbnkgTFBJIGZyb20gdGhlIERpcmVjdExQSSBNTUlPIGludGVyZmFjZQo+
Pj4gLSB0aGUgSVRTIGFuZCByZWRpc3RyaWJ1dG9ycyB1bmRlcnN0YW5kIHRoZSBsaWZlIGN5Y2xl
IG9mCj4+PiDCoMKgIHRoZSBkb29yYmVsbCwgc28gd2UgZG9uJ3QgbmVlZCB0byBlbmFibGUvZGlz
YWJsZSBpdCBhbGwKPj4+IMKgwqAgdGhlIHRpbWUKPj4+IFNvIGxldCdzIGVzY2FwZSBlYXJseSBm
cm9tIHRoZSBwcm94eSByZWxhdGVkIGZ1bmN0aW9ucy4KPj4+IFNpZ25lZC1vZmYtYnk6IE1hcmMg
WnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4+Cj4+IFJldmlld2VkLWJ5OiBaZW5naHVpIFl1IDx5
dXplbmdodWlAaHVhd2VpLmNvbT4KPj4KPj4+IC0tLQo+Pj4gwqAgZHJpdmVycy9pcnFjaGlwL2ly
cS1naWMtdjMtaXRzLmMgfCAyMyArKysrKysrKysrKysrKysrKysrKysrLQo+Pj4gwqAgMSBmaWxl
IGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyAKPj4+IGIvZHJpdmVycy9pcnFjaGlw
L2lycS1naWMtdjMtaXRzLmMKPj4+IGluZGV4IDIyMGQ0OTBkNTE2ZS4uOTk5ZTYxYTliMmMzIDEw
MDY0NAo+Pj4gLS0tIGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4+ICsrKyBi
L2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+PiBAQCAtMzA2OSw3ICszMDY5LDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCBpcnFfZG9tYWluX29wcyAKPj4+IGl0c19kb21haW5fb3Bz
ID0gewo+Pj4gwqAgLyoKPj4+IMKgwqAgKiBUaGlzIGlzIGluc2FuZS4KPj4+IMKgwqAgKgo+Pj4g
LSAqIElmIGEgR0lDdjQgZG9lc24ndCBpbXBsZW1lbnQgRGlyZWN0IExQSXMgKHdoaWNoIGlzIGV4
dHJlbWVseQo+Pj4gKyAqIElmIGEgR0lDdjQuMCBkb2Vzbid0IGltcGxlbWVudCBEaXJlY3QgTFBJ
cyAod2hpY2ggaXMgZXh0cmVtZWx5Cj4+PiDCoMKgICogbGlrZWx5KSwgdGhlIG9ubHkgd2F5IHRv
IHBlcmZvcm0gYW4gaW52YWxpZGF0ZSBpcyB0byB1c2UgYSBmYWtlCj4+PiDCoMKgICogZGV2aWNl
IHRvIGlzc3VlIGFuIElOViBjb21tYW5kLCBpbXBseWluZyB0aGF0IHRoZSBMUEkgaGFzIGZpcnN0
Cj4+PiDCoMKgICogYmVlbiBtYXBwZWQgdG8gc29tZSBldmVudCBvbiB0aGF0IGRldmljZS4gU2lu
Y2UgdGhpcyBpcyBub3QgZXhhY3RseQo+Pj4gQEAgLTMwNzcsOSArMzA3NywxOCBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGlycV9kb21haW5fb3BzIAo+Pj4gaXRzX2RvbWFpbl9vcHMgPSB7Cj4+PiDC
oMKgICogb25seSBpc3N1ZSBhbiBVTk1BUCBpZiB3ZSdyZSBzaG9ydCBvbiBhdmFpbGFibGUgc2xv
dHMuCj4+PiDCoMKgICoKPj4+IMKgwqAgKiBCcm9rZW4gYnkgZGVzaWduKHRtKS4KPj4+ICsgKgo+
Pj4gKyAqIEdJQ3Y0LjEgYWN0dWFsbHkgbWFuZGF0ZXMgdGhhdCB3ZSdyZSBhYmxlIHRvIGludmFs
aWRhdGUgYnkgCj4+PiB3cml0aW5nIHRvIGEKPj4+ICsgKiBNTUlPIHJlZ2lzdGVyLiBJdCBkb2Vz
bid0IGltcGxlbWVudCB0aGUgd2hvbGUgb2YgRGlyZWN0TFBJLCBidXQgCj4+PiB0aGF0J3MKPj4+
ICsgKiBnb29kIGVub3VnaC4gQW5kIG1vc3Qgb2YgdGhlIHRpbWUsIHdlIGRvbid0IGV2ZW4gaGF2
ZSB0byBpbnZhbGlkYXRlCj4+PiArICogYW55dGhpbmcsIHNvIHRoYXQncyBhY3R1YWxseSBwcmV0
dHkgZ29vZCEKPj4KPj4gSSBjYW4ndCB1bmRlcnN0YW5kIHRoZSBtZWFuaW5nIG9mIHRoaXMgbGFz
dCBzZW50ZW5jZS4gTWF5IEkgYXNrIGZvciBhbgo+PiBleHBsYW5hdGlvbj8gOikKPiAKPiBZZWFo
LCByZWFkaW5nIHRoaXMgbm93LCBpdCBmZWVscyBwcmV0dHkgY2x1bXN5LCBhbmQgb25seSByZW1v
dGVseQo+IGNvbm5lY3RlZCB0byB0aGUgcGF0Y2guCj4gCj4gV2hhdCBJJ20gdHJ5aW5nIHRvIHNh
eSBoZXJlIGlzIHRoYXQsIGFsdGhvdWdoIEdJQ3Y0LjEgZG9lc24ndCBoYXZlCj4gdGhlIGZ1bGwg
c3BlY3RydW0gb2YgdjQuMCBEaXJlY3RMUEkgKGl0IG9ubHkgYWxsb3dzIGEgc3Vic2V0IG9mIGl0
KSwKPiB0aGlzIHN1YnNldCBpcyBtb3JlIHRoZW4gZW5vdWdoIGZvciB1cy4gSGVyZSdzIHRoZSBy
YXRpb25hbDoKPiAKPiBXaGVuIGEgdlBFIGV4aXRzIGZyb20gdGhlIGh5cGVydmlzb3IsIHdlIGtu
b3cgd2hldGhlciB3ZSBuZWVkIHRvCj4gcmVxdWVzdCBhIGRvb3JiZWxsIG9yIG5vdCAoZGVwZW5k
aW5nIG9uIHdoZXRoZXIgd2UncmUgYmxvY2tpbmcgb24KPiBXRkkgb3Igbm90KS4gT24gR0lDdjQu
MCwgdGhpcyB0cmFuc2xhdGVzIGludG8gZW5hYmxpbmcgdGhlIGRvb3JiZWxsCj4gaW50ZXJydXB0
LCB3aGljaCBnZW5lcmF0ZXMgYW4gaW52YWxpZGF0aW9uIChjb3N0bHkpLiBBbmQgd2hlbmV2ZXIK
PiB3ZSd2ZSB0YWtlbiBhIGRvb3JiZWxsLCBvciBhcmUgc2NoZWR1bGVkIGFnYWluLCB3ZSBuZWVk
IHRvIHR1cm4KPiB0aGUgZG9vcmJlbGwgb2ZmIChpbnZhbGlkYXRpb24gYWdhaW4pLgo+IAo+IFdp
dGggdjQuMSwgd2UgY2FuIGp1c3Qgc2F5ICphdCBleGl0IHRpbWUqIHdoZXRoZXIgd2Ugd2FudCBk
b29yYmVsbHMKPiB0byBiZSBzdWJzZXF1ZW50bHkgZ2VuZXJhdGVkIChzZWUgaXRzX3ZwZV80XzFf
ZGVzY2hlZHVsZSgpIGFuZCB0aGUKPiByZXFfZGIgcGFyYW1ldGVyIGluIHRoZSBpbmZvIHN0cnVj
dHVyZSkuIFRoaXMgaXMgcGFydCBvZiBtYWtpbmcKPiB0aGUgdlBFIG5vbi1yZXNpZGVudCwgc28g
d2UgaGF2ZSAwIG92ZXJoZWFkIGF0IHRoaXMgc3RhZ2UuCgpHcmVhdCwgYW5kIGdldCBpdC4gVGhh
bmtzIGZvciB0aGlzIGNsZWFyIGV4cGxhbmF0aW9uIQoKClplbmdodWkKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
