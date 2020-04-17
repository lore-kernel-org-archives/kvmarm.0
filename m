Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D65C2BB85
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 06:40:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C13B20771
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 06:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C13B20771
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A01C4B1C6;
	Fri, 17 Apr 2020 02:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QLE7BjmAia5R; Fri, 17 Apr 2020 02:40:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6A6B4B229;
	Fri, 17 Apr 2020 02:40:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B74284B1C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 02:40:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4vwIb+ieUd6q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 02:40:46 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B684B1AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 02:40:46 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CB58F782E7D097BE4BA6;
 Fri, 17 Apr 2020 14:40:42 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Apr 2020
 14:40:32 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-its: Fix memory leak on the error
 path of vgic_add_lpi()
To: Marc Zyngier <maz@kernel.org>
References: <20200414030349.625-1-yuzenghui@huawei.com>
 <20200414030349.625-3-yuzenghui@huawei.com>
 <610f2195-f85d-4beb-b711-47d63bb393d0@huawei.com>
 <2173e13527cc9578838f0364ad29f6cc@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <de03883a-179f-fbe5-e5f4-6138e5684660@huawei.com>
Date: Fri, 17 Apr 2020 14:40:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <2173e13527cc9578838f0364ad29f6cc@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
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

T24gMjAyMC80LzE3IDE6MjMsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIwLTA0LTE2IDAy
OjE3LCBaZW5naHVpIFl1IHdyb3RlOgo+PiBPbiAyMDIwLzQvMTQgMTE6MDMsIFplbmdodWkgWXUg
d3JvdGU6Cj4+PiBJZiB3ZSdyZSBnb2luZyB0byBmYWlsIG91dCB0aGUgdmdpY19hZGRfbHBpKCks
IGxldCdzIG1ha2Ugc3VyZSB0aGUKPj4+IGFsbG9jYXRlZCB2Z2ljX2lycSBtZW1vcnkgaXMgYWxz
byBmcmVlZC4gVGhvdWdoIGl0IHNlZW1zIHRoYXQgYm90aAo+Pj4gY2FzZXMgYXJlIHVubGlrZWx5
IHRvIGZhaWwuCj4+Pgo+Pj4gQ2M6IFplbmdydWFuIFllIDx5ZXplbmdydWFuQGh1YXdlaS5jb20+
Cj4+PiBTaWduZWQtb2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+
IC0tLQo+Pj4gwqAgdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYyB8IDggKysrKysrLS0KPj4+
IMKgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Pgo+
Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMgYi92aXJ0L2t2bS9h
cm0vdmdpYy92Z2ljLWl0cy5jCj4+PiBpbmRleCBkNTNkMzRhMzNlMzUuLjNjM2I2YTBmMmRjZSAx
MDA2NDQKPj4+IC0tLSBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMKPj4+ICsrKyBiL3Zp
cnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMKPj4+IEBAIC05OCwxMiArOTgsMTYgQEAgc3RhdGlj
IHN0cnVjdCB2Z2ljX2lycSAqdmdpY19hZGRfbHBpKHN0cnVjdCBrdm0gCj4+PiAqa3ZtLCB1MzIg
aW50aWQsCj4+PiDCoMKgwqDCoMKgwqAgKiB0aGUgcmVzcGVjdGl2ZSBjb25maWcgZGF0YSBmcm9t
IG1lbW9yeSBoZXJlIHVwb24gbWFwcGluZyB0aGUgCj4+PiBMUEkuCj4+PiDCoMKgwqDCoMKgwqAg
Ki8KPj4+IMKgwqDCoMKgwqAgcmV0ID0gdXBkYXRlX2xwaV9jb25maWcoa3ZtLCBpcnEsIE5VTEws
IGZhbHNlKTsKPj4+IC3CoMKgwqAgaWYgKHJldCkKPj4+ICvCoMKgwqAgaWYgKHJldCkgewo+Pj4g
K8KgwqDCoMKgwqDCoMKgIGtmcmVlKGlycSk7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IEVSUl9QVFIocmV0KTsKPj4+ICvCoMKgwqAgfQo+Pj4gwqDCoMKgwqDCoMKgwqAgcmV0ID0gdmdp
Y192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhrdm0sIGlycSk7Cj4+PiAtwqDCoMKgIGlmIChy
ZXQpCj4+PiArwqDCoMKgIGlmIChyZXQpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCBrZnJlZShpcnEp
Owo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBFUlJfUFRSKHJldCk7Cj4+PiArwqDCoMKg
IH0KPj4KPj4gTG9va2luZyBhdCBpdCBhZ2FpbiwgSSByZWFsaXplZCB0aGF0IHRoaXMgZXJyb3Ig
aGFuZGxpbmcgaXMgc3RpbGwgbm90Cj4+IGNvbXBsZXRlLiBNYXliZSB3ZSBzaG91bGQgdXNlIGEg
dmdpY19wdXRfaXJxKCkgaW5zdGVhZCBzbyB0aGF0IHdlIGNhbgo+PiBhbHNvIHByb3Blcmx5IGRl
bGV0ZSB0aGUgdmdpY19pcnEgZnJvbSBscGlfbGlzdC4KPiAKPiBZZXMsIHRoaXMgaXMgYSBtb3Jl
IGNvcnJlY3QgZml4IGluZGVlZC4gVGhlcmUgaXMgc3RpbGwgYSBiaXQgb2YgYSBiaXphcnJlCj4g
YmVoYXZpb3VyIGlmIHlvdSBoYXZlIHR3byB2Z2ljX2FkZF9scGkoKSByYWNpbmcgdG8gY3JlYXRl
IHRoZSBzYW1lIAo+IGludGVycnVwdCwKPiB3aGljaCBpcyBwcmV0dHkgZG9kZ3kgYW55d2F5IChp
dCBtZWFucyB3ZSBoYXZlIHR3byBNQVBJIGF0IHRoZSBzYW1lIAo+IHRpbWUuLi4pLgo+IFlvdSBl
bmQtdXAgd2l0aCByZS1yZWFkaW5nIHRoZSBzdGF0ZSBmcm9tIG1lbW9yeS4uLiBPaCB3ZWxsLgo+
IAo+PiBNYXJjLCB3aGF0IGRvIHlvdSB0aGluaz8gQ291bGQgeW91IHBsZWFzZSBoZWxwIHRvIGZp
eCBpdCwgb3IgSSBjYW4KPj4gcmVzZW5kIGl0Lgo+IAo+IEkndmUgZml4ZWQgaXQgYXMgc3VjaCAo
d2l0aCBhIGNvbW1lbnQgZm9yIGEgZ29vZCBtZWFzdXJlKToKPiAKPiBkaWZmIC0tZ2l0IGEvdmly
dC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMK
PiBpbmRleCAzYzNiNmEwZjJkY2UuLmMwMTJhNTJiMTlmNSAxMDA2NDQKPiAtLS0gYS92aXJ0L2t2
bS9hcm0vdmdpYy92Z2ljLWl0cy5jCj4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMu
Ywo+IEBAIC05NiwxNiArOTYsMTkgQEAgc3RhdGljIHN0cnVjdCB2Z2ljX2lycSAqdmdpY19hZGRf
bHBpKHN0cnVjdCBrdm0gCj4gKmt2bSwgdTMyIGludGlkLAo+ICDCoMKgwqDCoMKgICogV2UgImNh
Y2hlIiB0aGUgY29uZmlndXJhdGlvbiB0YWJsZSBlbnRyaWVzIGluIG91ciBzdHJ1Y3QgCj4gdmdp
Y19pcnEncy4KPiAgwqDCoMKgwqDCoCAqIEhvd2V2ZXIgd2Ugb25seSBoYXZlIHRob3NlIHN0cnVj
dHMgZm9yIG1hcHBlZCBJUlFzLCBzbyB3ZSByZWFkIGluCj4gIMKgwqDCoMKgwqAgKiB0aGUgcmVz
cGVjdGl2ZSBjb25maWcgZGF0YSBmcm9tIG1lbW9yeSBoZXJlIHVwb24gbWFwcGluZyB0aGUgTFBJ
Lgo+ICvCoMKgwqDCoCAqCj4gK8KgwqDCoMKgICogU2hvdWxkIGFueSBvZiB0aGVzZSBmYWlsLCBi
ZWhhdmUgYXMgaWYgd2UgY291bGRuJ3QgY3JlYXRlIHRoZSBMUEkKPiArwqDCoMKgwqAgKiBieSBk
cm9wcGluZyB0aGUgcmVmY291bnQgYW5kIHJldHVybmluZyB0aGUgZXJyb3IuCj4gIMKgwqDCoMKg
wqAgKi8KPiAgwqDCoMKgwqAgcmV0ID0gdXBkYXRlX2xwaV9jb25maWcoa3ZtLCBpcnEsIE5VTEws
IGZhbHNlKTsKPiAgwqDCoMKgwqAgaWYgKHJldCkgewo+IC3CoMKgwqDCoMKgwqDCoCBrZnJlZShp
cnEpOwo+ICvCoMKgwqDCoMKgwqDCoCB2Z2ljX3B1dF9pcnEoa3ZtLCBpcnEpOwo+ICDCoMKgwqDC
oMKgwqDCoMKgIHJldHVybiBFUlJfUFRSKHJldCk7Cj4gIMKgwqDCoMKgIH0KPiAKPiAgwqDCoMKg
wqAgcmV0ID0gdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhrdm0sIGlycSk7Cj4gIMKg
wqDCoMKgIGlmIChyZXQpIHsKPiAtwqDCoMKgwqDCoMKgwqAga2ZyZWUoaXJxKTsKPiArwqDCoMKg
wqDCoMKgwqAgdmdpY19wdXRfaXJxKGt2bSwgaXJxKTsKPiAgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gRVJSX1BUUihyZXQpOwo+ICDCoMKgwqDCoCB9Cj4gCj4gCj4gTGV0IG1lIGtub3cgaWYgeW91
IGFncmVlIHdpdGggdGhhdC4KCkFncmVlZC4gVGhhbmtzIGZvciB0aGUgZml4IQoKClplbmdodWkK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
