Return-Path: <SRS0=3/RW=4B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50057C2BA83
	for <kvmarm@archiver.kernel.org>; Thu, 13 Feb 2020 15:12:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5D1F2168B
	for <kvmarm@archiver.kernel.org>; Thu, 13 Feb 2020 15:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5D1F2168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F2094A522;
	Thu, 13 Feb 2020 10:12:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yuRrH9HQLC5h; Thu, 13 Feb 2020 10:12:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D794A598;
	Thu, 13 Feb 2020 10:12:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB99D4A522
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Feb 2020 10:12:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RUIOgnUqQXIX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Feb 2020 10:12:05 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 632064A500
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Feb 2020 10:12:05 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 87457483DF8DF9ECD8F4;
 Thu, 13 Feb 2020 23:11:59 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 23:11:52 +0800
Subject: Re: [PATCH v2 3/6] irqchip/gic-v4.1: Ensure L2 vPE table is allocated
 at RD level
To: Marc Zyngier <maz@kernel.org>
References: <20200206075711.1275-1-yuzenghui@huawei.com>
 <20200206075711.1275-4-yuzenghui@huawei.com>
 <2f6a27ac57aef9b948952c210c9a5882@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b1cdce3f-0c0e-8b78-0fe0-f4114190caa3@huawei.com>
Date: Thu, 13 Feb 2020 23:11:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2f6a27ac57aef9b948952c210c9a5882@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
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

SGkgTWFyYywKCk9uIDIwMjAvMi8xMyAyMjoyMiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gT24gMjAyMC0wMi0wNiAwNzo1NywgWmVuZ2h1aSBZdSB3cm90ZToKPj4gSW4g
R0lDdjQsIHdlIHdpbGwgZW5zdXJlIHRoYXQgbGV2ZWwyIHZQRSB0YWJsZSBtZW1vcnkgaXMgYWxs
b2NhdGVkCj4+IGZvciB0aGUgc3BlY2lmaWVkIHZwZV9pZCBvbiBhbGwgdjQgSVRTLCBpbiBpdHNf
YWxsb2NfdnBlX3RhYmxlKCkuCj4+IFRoaXMgc3RpbGwgd29ya3Mgd2VsbCBmb3IgdGhlIHR5cGlj
YWwgR0lDdjQuMSBpbXBsZW1lbnRhdGlvbiwgd2hlcmUKPj4gdGhlIG5ldyB2UEUgdGFibGUgaXMg
c2hhcmVkIGJldHdlZW4gdGhlIElUU3MgYW5kIHRoZSBSRHMuCj4+Cj4+IFRvIG1ha2UgaXQgZXhw
bGljaXQsIGxldCB1cyBpbnRyb2R1Y2UgYWxsb2NhdGVfdnBlX2wyX3RhYmxlKCkgdG8KPj4gbWFr
ZSBzdXJlIHRoYXQgdGhlIEwyIHRhYmxlcyBhcmUgYWxsb2NhdGVkIG9uIGFsbCB2NC4xIFJEcy4g
V2UncmUKPj4gbGlrZWx5IG5vdCBuZWVkIHRvIGFsbG9jYXRlIG1lbW9yeSBpbiBpdCBiZWNhdXNl
IHRoZSB2UEUgdGFibGUgaXMKPj4gc2hhcmVkIGFuZCAoTDIgdGFibGUgaXMpIGFscmVhZHkgYWxs
b2NhdGVkIGF0IElUUyBsZXZlbCwgZXhjZXB0Cj4+IGZvciB0aGUgY2FzZSB3aGVyZSB0aGUgSVRT
IGRvZXNuJ3Qgc2hhcmUgYW55dGhpbmcgKHNheSBTVlBFVCA9PSAwLAo+PiBwcmFjdGljYWxseSB1
bmxpa2VseSBidXQgYXJjaGl0ZWN0dXJhbGx5IGFsbG93ZWQpLgo+Pgo+PiBUaGUgaW1wbGVtZW50
YXRpb24gb2YgYWxsb2NhdGVfdnBlX2wyX3RhYmxlKCkgaXMgbW9zdGx5IGNvcGllZCBmcm9tCj4+
IGl0c19hbGxvY190YWJsZV9lbnRyeSgpLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBaZW5naHVpIFl1
IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4gLS0tCj4+IMKgZHJpdmVycy9pcnFjaGlwL2lycS1n
aWMtdjMtaXRzLmMgfCA4MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+PiDCoDEg
ZmlsZSBjaGFuZ2VkLCA4MCBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyAKPj4gYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12
My1pdHMuYwo+PiBpbmRleCAwZjFmZTU2Y2UwYWYuLmFlNGU3YjM1NWI0NiAxMDA2NDQKPj4gLS0t
IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPj4gKysrIGIvZHJpdmVycy9pcnFj
aGlwL2lycS1naWMtdjMtaXRzLmMKPj4gQEAgLTI0NDMsNiArMjQ0Myw3MiBAQCBzdGF0aWMgdTY0
IAo+PiBpbmhlcml0X3ZwZV9sMV90YWJsZV9mcm9tX3JkKGNwdW1hc2tfdCAqKm1hc2spCj4+IMKg
wqDCoMKgIHJldHVybiAwOwo+PiDCoH0KPj4KPj4gK3N0YXRpYyBib29sIGFsbG9jYXRlX3ZwZV9s
Ml90YWJsZShpbnQgY3B1LCB1MzIgaWQpCj4+ICt7Cj4+ICvCoMKgwqAgdm9pZCBfX2lvbWVtICpi
YXNlID0gZ2ljX2RhdGFfcmRpc3RfY3B1KGNwdSktPnJkX2Jhc2U7Cj4+ICvCoMKgwqAgdTY0IHZh
bCwgZ3BzeiwgbnBnOwo+PiArwqDCoMKgIHVuc2lnbmVkIGludCBwc3osIGVzeiwgaWR4Owo+PiAr
wqDCoMKgIHN0cnVjdCBwYWdlICpwYWdlOwo+PiArwqDCoMKgIF9fbGU2NCAqdGFibGU7Cj4+ICsK
Pj4gK8KgwqDCoCBpZiAoIWdpY19yZGlzdHMtPmhhc19ydnBlaWQpCj4+ICvCoMKgwqDCoMKgwqDC
oCByZXR1cm4gdHJ1ZTsKPj4gKwo+PiArwqDCoMKgIHZhbMKgID0gZ2l0c19yZWFkX3Zwcm9wYmFz
ZXIoYmFzZSArIFNaXzEyOEsgKyBHSUNSX1ZQUk9QQkFTRVIpOwo+IAo+IEhhdmluZyByZWJhc2Vk
IHRoZSByZXN0IG9mIHRoZSBHSUN2NC4xIHNlcmllcyBvbiB0b3Agb2YgLXJjMSwgSSd2ZSBoaXQg
YSAKPiBzbWFsbAo+IGlzc3VlIHJpZ2h0IGhlcmUuIEkgcnVuIGEgRlZQIG1vZGVsIHRoYXQgb25s
eSBzcGF3bnMgNCBDUFVzLCB3aGlsZSB0aGUgCj4gRFQgaGFzCj4gOCBvZiB0aGVtLiBUaGlzIG1l
YW5zIHRoYXQgb25saW5lX2NwdXMgPSA0LCBhbmQgcG9zc2libGVfY3B1cyA9IDguCj4gCj4gU28g
aW4gbXkgY2FzZSwgaGFsZiBvZiB0aGUgUkRzIGhhdmUgYmFzZSA9PSBOVUxMLCBhbmQgdGhpbmdz
IHN0b3AgcXVpY2tseS4KCkFoLCBzbyB0aGlzIG1heSBhbHNvIGJlIHdoeSB3ZSBjaGVjayAnIWJh
c2UnIGZvciBlYWNoIHBvc3NpYmxlIENQVSBpbgppbmhlcml0X3ZwZV9sMV90YWJsZV9mcm9tX3Jk
KCkuIEkgZGlkbid0IHRoaW5rIGFib3V0IGl0IGF0IHRoYXQgdGltZS4KCj4gCj4gSSBwbGFuIHRv
IHF1ZXVlIHRoZSBmb2xsb3dpbmc6Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9p
cnEtZ2ljLXYzLWl0cy5jIAo+IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMKPiBp
bmRleCBkODVkYzhkY2IwYWQuLjc2NTZiMzUzYTk1ZiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12My1pdHMuYwo+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYz
LWl0cy5jCj4gQEAgLTI1MjYsNiArMjUyNiwxMCBAQCBzdGF0aWMgYm9vbCBhbGxvY2F0ZV92cGVf
bDJfdGFibGUoaW50IGNwdSwgdTMyIGlkKQo+ICDCoMKgwqDCoCBpZiAoIWdpY19yZGlzdHMtPmhh
c19ydnBlaWQpCj4gIMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRydWU7Cj4gCj4gK8KgwqDCoCAv
KiBTa2lwIG5vbi1wcmVzZW50IENQVXMgKi8KPiArwqDCoMKgIGlmICghYmFzZSkKPiArwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIHRydWU7Cj4gKwo+ICDCoMKgwqDCoCB2YWzCoCA9IGdpY3JfcmVhZF92
cHJvcGJhc2VyKGJhc2UgKyBTWl8xMjhLICsgR0lDUl9WUFJPUEJBU0VSKTsKPiAKPiAgwqDCoMKg
wqAgZXN6wqAgPSBGSUVMRF9HRVQoR0lDUl9WUFJPUEJBU0VSXzRfMV9FTlRSWV9TSVpFLCB2YWwp
ICsgMTsKClRoYW5rcyBmb3IgZml4aW5nIHRoZSBzZWNvbmQgYnVnIGZvciB0aGlzIHBhdGNoIDot
KQoKClplbmdodWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
