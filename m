Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4FDC71155
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 11:02:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52382206CB
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 11:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52382206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D3E4B9C8;
	Tue,  1 Dec 2020 06:02:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7m5JPpzhch5G; Tue,  1 Dec 2020 06:02:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD964B9DC;
	Tue,  1 Dec 2020 06:02:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6B04BDF7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 04:38:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0a6JVdgEF5TW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 04:38:26 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBF034BDB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 04:38:25 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ClcTc5vX0z72pS;
 Tue,  1 Dec 2020 17:37:56 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 17:38:12 +0800
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <869dbc36-c510-fd00-407a-b05e068537c8@huawei.com>
 <875z5p6ayp.wl-maz@kernel.org>
From: luojiaxing <luojiaxing@huawei.com>
Message-ID: <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
Date: Tue, 1 Dec 2020 17:38:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <875z5p6ayp.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 01 Dec 2020 06:02:46 -0500
Cc: Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>, Shenming Lu <lushenming@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Ck9uIDIwMjAvMTEvMjggMTg6MTgsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiBTYXQsIDI4IE5v
diAyMDIwIDA3OjE5OjQ4ICswMDAwLAo+IGx1b2ppYXhpbmcgPGx1b2ppYXhpbmdAaHVhd2VpLmNv
bT4gd3JvdGU6Cj4+IEhpLCBzaGVubWluZwo+Pgo+Pgo+PiBJIGdvdCBmZXcgcXVlc3Rpb25zIGFi
b3V0IHRoaXMgcGF0Y2guCj4+Cj4+IEFsdGhvdWdoIGl0J3MgYSBiaXQgbGF0ZSBhbmQgbm90IHZl
cnkgYXBwcm9wcmlhdGUsIEknZCBsaWtlIHRvIGFzawo+PiBiZWZvcmUgeW91IHNlbmQgbmV4dCB2
ZXJzaW9uLgo+Pgo+PiBPbiAyMDIwLzExLzIzIDE0OjU0LCBTaGVubWluZyBMdSB3cm90ZToKPj4+
IEZyb206IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4KPj4+IFVwIHRvIG5v
dywgdGhlIGlycV9nZXRfaXJxY2hpcF9zdGF0ZSgpIGNhbGxiYWNrIG9mIGl0c19pcnFfY2hpcAo+
Pj4gbGVhdmVzIHVuaW1wbGVtZW50ZWQgc2luY2UgdGhlcmUgaXMgbm8gYXJjaGl0ZWN0dXJhbCB3
YXkgdG8gZ2V0Cj4+PiB0aGUgVkxQSSdzIHBlbmRpbmcgc3RhdGUgYmVmb3JlIEdJQ3Y0LjEuIFll
YWgsIHRoZXJlIGhhcyBvbmUgaW4KPj4+IHY0LjEgZm9yIFZMUElzLgo+Pgo+PiBJIGNoZWNrZWQg
dGhlIGludm9raW5nIHNjZW5hcmlvIG9mIGlycV9nZXRfaXJxY2hpcF9zdGF0ZSBhbmQgZm91bmQg
bm8KPj4gc2NlbmFyaW8gcmVsYXRlZCB0byB2TFBJLgo+Pgo+PiBGb3IgZXhhbXBsZSwgc3luY2hy
b25pemVfaXJxKCksIGl0IHBhc3MgSVJRQ0hJUF9TVEFURV9BQ1RJVkUgdG8gd2hpY2gsCj4+IHNv
IGluIHlvdXIgcGF0Y2gsIHlvdSB3aWxsIGRpcmVjdGx5IHJldHVybiBhbmQgb3RoZXIgaXMgZm9y
IHZTR0ksCj4+IEdJQ0RfSVNQRU5EUiwgR0lDRF9JQ1BFTkRSIGFuZCBzbyBvbi4KPiBZb3UgZG8g
cmVhbGlzZSB0aGF0IExQSXMgaGF2ZSBubyBhY3RpdmUgc3RhdGUsIHJpZ2h0PwoKCnllcywgSSBr
bm93CgoKPiBBbmQgdGhhdCBMUElzCj4gaGF2ZSBhIHJhZGljYWxseSBkaWZmZXJlbnQgcHJvZ3Jh
bW1pbmcgaW50ZXJmYWNlIHRvIHRoZSByZXN0IG9mIHRoZSBHSUM/CgoKSSBmb3VuZCBvdXQgdGhh
dCBteSBtYWlsYm94IHNvZnR3YXJlIGZpbHRlcmVkIG91dCB0aGUgb3RoZXIgdHdvIHBhdGNoZXMs
IAp3aGljaCBsZWQgbWUgdG8gbG9vayBhdCB0aGUgcGF0Y2ggYWxvbmUsIHNvIGl0IHdhcyB3ZWly
ZC4gSSBhbHJlYWR5IGdvdCAKdGhlIGFuc3dlciBub3cuCgoKPj4gVGhlIG9ubHkgb25lIEkgYW0g
bm90IHN1cmUgaXMgdmdpY19nZXRfcGh5c19saW5lX2xldmVsKCksIGlzIGl0IHlvdXIKPj4gcHVy
cG9zZSB0byBmaWxsIHRoaXMgY2FsbGJhY2ssIG9yIHNvbWUgc2NlbmFyaW9zIEkgZG9uJ3Qga25v
dyBhYm91dAo+PiB0aGF0IHVzZSB0aGlzIGNhbGxiYWNrLgo+IExQSXMgb25seSBvZmZlciBlZGdl
IHNpZ25hbGxpbmcsIHNvIHRoZSBjb25jZXB0IG9mICJsaW5lIGxldmVsIiBtZWFucwo+IGFic29s
dXRlbHkgbm90aGluZy4KPgo+Pgo+Pj4gV2l0aCBHSUN2NC4xLCBhZnRlciB1bm1hcHBpbmcgdGhl
IHZQRSwgd2hpY2ggY2xlYW5zIGFuZCBpbnZhbGlkYXRlcwo+Pj4gYW55IGNhY2hpbmcgb2YgdGhl
IFZQVCwgd2UgY2FuIGdldCB0aGUgVkxQSSdzIHBlbmRpbmcgc3RhdGUgYnkKPj4+IHBlZWtpbmcg
YXQgdGhlIFZQVC4gU28gd2UgaW1wbGVtZW50IHRoZSBpcnFfZ2V0X2lycWNoaXBfc3RhdGUoKQo+
Pj4gY2FsbGJhY2sgb2YgaXRzX2lycV9jaGlwIHRvIGRvIGl0Lgo+Pj4KPj4+IFNpZ25lZC1vZmYt
Ynk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4gU2lnbmVkLW9mZi1ieTog
U2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4+IC0tLQo+Pj4gICAgZHJpdmVy
cy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMgfCAzOCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwo+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKykKPj4+Cj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMgYi9kcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12My1pdHMuYwo+Pj4gaW5kZXggMGZlYzMxOTMxZTExLi4yODcwMDNjYWNh
YzcgMTAwNjQ0Cj4+PiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+Pj4g
KysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4+IEBAIC0xNjk1LDYgKzE2
OTUsNDMgQEAgc3RhdGljIHZvaWQgaXRzX2lycV9jb21wb3NlX21zaV9tc2coc3RydWN0IGlycV9k
YXRhICpkLCBzdHJ1Y3QgbXNpX21zZyAqbXNnKQo+Pj4gICAgCWlvbW11X2RtYV9jb21wb3NlX21z
aV9tc2coaXJxX2RhdGFfZ2V0X21zaV9kZXNjKGQpLCBtc2cpOwo+Pj4gICAgfQo+Pj4gICAgK3N0
YXRpYyBib29sIGl0c19wZWVrX3ZwdChzdHJ1Y3QgaXRzX3ZwZSAqdnBlLCBpcnFfaHdfbnVtYmVy
X3QKPj4+IGh3aXJxKQo+Pj4gK3sKPj4+ICsJaW50IG1hc2sgPSBod2lycSAlIEJJVFNfUEVSX0JZ
VEU7Cj4+PiArCXZvaWQgKnZhOwo+Pj4gKwl1OCAqcHQ7Cj4+PiArCj4+PiArCXZhID0gcGFnZV9h
ZGRyZXNzKHZwZS0+dnB0X3BhZ2UpOwo+Pj4gKwlwdCA9IHZhICsgaHdpcnEgLyBCSVRTX1BFUl9C
WVRFOwo+Pj4gKwo+Pj4gKwlyZXR1cm4gISEoKnB0ICYgKDFVIDw8IG1hc2spKTsKPj4KPj4gSG93
IGNhbiB5b3UgY29uZmlybSB0aGF0IHRoZSBpbnRlcnJ1cHQgcGVuZGluZyBzdGF0dXMgaXMgdGhl
IGxhdGVzdD8KPj4gSXMgaXQgcG9zc2libGUgdGhhdCB0aGUgaW50ZXJydXB0IHBlbmRpbmcgc3Rh
dHVzIGlzIHN0aWxsIGNhY2hlZCBpbgo+PiB0aGUgR0lDUiBidXQgbm90IHN5bmNocm9uaXplZCB0
byB0aGUgbWVtb3J5Lgo+IFRoYXQncyBhIGNvbnNlcXVlbmNlIG9mIHRoZSB2UEUgaGF2aW5nIGJl
ZW4gdW5tYXBwZWQ6Cj4KPiAiQSBWTUFQUCB3aXRoIHtWLEFsbG9jfT09ezAsMX0gY2xlYW5zIGFu
ZCBpbnZhbGlkYXRlcyBhbnkgY2FjaGluZyBvZgo+IHRoZSBWaXJ0dWFsIFBlbmRpbmcgVGFibGUg
YW5kIFZpcnR1YWwgQ29uZmlndXJhdGlvbiBUYWJsZSBhc3NvY2lhdGVkCj4gd2l0aCB0aGUgdlBF
SUQgaGVsZCBpbiB0aGUgR0lDLiIKCgpZZXMsIGluIGFkZGl0aW9uIHRvIHRoYXQsIGlmIGEgdlBF
IGlzIHNjaGVkdWxlZCBvdXQgb2YgdGhlIFBFLCB0aGUgY2FjaGUgCmNsZWFyaW5nIGFuZCB3cml0
ZS1iYWNrIHRvIFZQVCBhcmUgYWxzbyBwZXJmb3JtZWQsIEkgdGhpbmsuCgoKSG93ZXZlciwgSSBm
ZWVsIGEgbGl0dGVyIGNvbmZ1c2luZyB0byByZWFkIHRoaXMgY29tbWVudCBhdCBmaXJzdCAswqAg
CmJlY2F1c2UgaXQgaXMgbm90IG9ubHkgVk1BUFAgdGhhdCBjYXVzZXMgY2FjaGUgY2xlYXJpbmcu
CgpJIGRvbid0IGtub3cgd2h5IFZNQVBQIHdhcyBtZW50aW9uZWQgaGVyZSB1bnRpbCBJIGNoZWNr
IHRoZSBvdGhlciB0d28gCnBhdGNoZXMgKCJLVk06IGFybTY0OiBHSUN2NC4xOiBUcnkgdG8gc2F2
ZSBodyBwZW5kaW5nIHN0YXRlIGluIApzYXZlX3BlbmRpbmdfdGFibGVzIikuCgoKU28gSSB0aGlu
ayBtYXkgYmUgaXQncyBiZXR0ZXIgdG8gYWRkIHNvbWUgYmFja2dyb3VuZCBkZXNjcmlwdGlvbiBo
ZXJlLgoKClRoYW5rcwoKSmlheGluZwoKCj4KPiBBbiBpbXBsZW1lbnRhdGlvbiB0aGF0IHdvdWxk
bid0IGZvbGxvdyB0aGlzIHNpbXBsZSBydWxlIHdvdWxkIHNpbXBseQo+IGJlIHRvdGFsbHkgYnJv
a2VuLCBhbmQgdW5zdXBwb3J0ZWQuCj4KPiAJTS4KPgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
