Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113FAC282DA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 08:07:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9048E20663
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 08:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9048E20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8DB4A48B;
	Tue,  9 Apr 2019 04:07:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PDd3FGaSXz7Y; Tue,  9 Apr 2019 04:07:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3ABB4A47A;
	Tue,  9 Apr 2019 04:07:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4A24A452
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 04:07:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hyc6P4fRsC58 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 04:07:24 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B03D44A369
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 04:07:24 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 570CAE799314B82CC4BF;
 Tue,  9 Apr 2019 16:07:21 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Tue, 9 Apr 2019
 16:07:12 +0800
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
 <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
 <a9c084fb-0c84-e632-a192-b361773a0bc8@arm.com>
 <44ffad26-a407-4603-0bb6-145f7290adbe@huawei.com>
 <730c25b4-dbc5-8d8b-514c-4ed8641701ce@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1b398e29-e2d5-2a58-b4ca-c72979a170d8@huawei.com>
Date: Tue, 9 Apr 2019 16:05:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <730c25b4-dbc5-8d8b-514c-4ed8641701ce@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409080558.Xli6PtWVIXlQbz6mQyRAOn6zJrokh9JXoaazSTza2bw@z>

CgpPbiAyMDE5LzQvOSAyOjQwLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+IEhpIFplbmh1aSwK
PiAKPiBPbiAwNC8wOC8yMDE5IDA0OjExIFBNLCBaZW5naHVpIFl1IHdyb3RlOgo+PiBIaSBTdXp1
a2ksCj4+Cj4+IFRoYW5rcyBmb3IgdGhlIHJlcGx5Lgo+Pgo+IAo+IC4uLgo+IAo+Pj4+IEhpIFN1
enVraSwKPj4+Pgo+Pj4+IFdoeSBub3QgbWFraW5nIHVzZSBvZiBmYXVsdF9zdXBwb3J0c19zdGFn
ZTJfaHVnZV9tYXBwaW5nKCk/wqAgTGV0IGl0IGRvCj4+Pj4gc29tZSBjaGVja3MgZm9yIHVzLgo+
Pj4+Cj4+Pj4gZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygpIHdhcyBpbnRlbmRl
ZCB0byBkbyBhICp0d28tc3RlcCoKPj4+PiBjaGVjayB0byB0ZWxsIHVzIHRoYXQgY2FuIHdlIGNy
ZWF0ZSBzdGFnZTIgaHVnZSBibG9jayBtYXBwaW5ncywgYW5kIAo+Pj4+IHRoaXMKPj4+PiBjaGVj
ayBpcyBib3RoIGZvciBodWdldGxiZnMgYW5kIFRIUC7CoCBXaXRoIGNvbW1pdCBhODA4NjhmMzk4
NTU0ODQyYjE0LAo+Pj4+IHdlIHBhc3MgUEFHRV9TSVpFIGFzICJtYXBfc2l6ZSIgZm9yIG5vcm1h
bCBzaXplIHBhZ2VzICh3aGljaCB0dXJuZWQgb3V0Cj4+Pj4gdG8gYmUgYWxtb3N0IG1lYW5pbmds
ZXNzKSwgYW5kIHVuZm9ydHVuYXRlbHkgdGhlIFRIUCBjaGVjayBubyBsb25nZXIKPj4+PiB3b3Jr
cy4KPj4+Cj4+PiBUaGF0cyBjb3JyZWN0Lgo+Pj4KPj4+Pgo+Pj4+IFNvIHdlIHdhbnQgdG8gcmV3
b3JrICpUSFAqIGNoZWNrIHByb2Nlc3MuwqAgWW91ciBwYXRjaCBmaXhlcyB0aGUgZmlyc3QKPj4+
PiBjaGVja2luZy1zdGVwLCBidXQgdGhlIHNlY29uZCBpcyBzdGlsbCBtaXNzZWQsIGFtIEkgd3Jv
bmc/Cj4+Pgo+Pj4gSXQgZml4ZXMgdGhlIHN0ZXAgZXhwbGljaXRseSBmb3IgdGhlIFRIUCBieSBt
YWtpbmcgc3VyZSB0aGF0IHRoZSBHUEEgYW5kCj4+PiB0aGUgSFZBIGFyZSBhbGlnbmVkIHRvIHRo
ZSBtYXAgc2l6ZS4KPj4KPj4gWWVzLCBJIHVuZGVyc3RhbmQgaG93IHlvdXIgcGF0Y2ggaGFkIGZp
eGVkIHRoZSBpc3N1ZS7CoCBCdXQgd2hhdCBJJ20KPj4gcmVhbGx5IGNvbmNlcm5lZCBhYm91dCBo
ZXJlIGlzIHRoZSAqc2Vjb25kKiBjaGVja2luZy1zdGVwIGluCj4+IGZhdWx0X3N1cHBvcnRzX3N0
YWdlMl9odWdlX21hcHBpbmcoKS4KPj4KPj4gV2UgaGF2ZSB0byBjaGVjayBpZiB3ZSBhcmUgbWFw
cGluZyBhIG5vbi1ibG9jayBhbGlnbmVkIG9yIG5vbi1ibG9jawo+PiBzaXplZCBtZW1zbG90LCBp
ZiBzbywgd2UgY2FuIG5vdCBjcmVhdGUgYmxvY2sgbWFwcGluZ3MgZm9yIHRoZSBiZWdpbm5pbmcK
Pj4gYW5kIGVuZCBvZiB0aGlzIG1lbXNsb3QuwqAgVGhpcyBpcyB3aGF0IHRoZSBzZWNvbmQgcGFy
dCBvZgo+PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKCkgaGFkIGRvbmUuCj4+
Cj4+IEkgaGF2ZW4ndCBzZWVuIHRoaXMgY2hlY2tpbmctc3RlcCBpbiB5b3VyIHBhdGNoLCBkaWQg
SSBtaXNzIHNvbWV0aGluZz8KPj4KPiAKPiBJIHNlZS4KPiAKPj4+IEkgZG9uJ3QgdGhpbmsgdGhp
cyBjYWxscyBmb3IgYSBWTV9CVUdfT04oKS4gSXQgaXMgc2ltcGx5IGEgY2FzZSB3aGVyZQo+Pj4g
dGhlIEdQQSBpcyBub3QgYWxpZ25lZCB0byBIVkEsIGJ1dCBmb3Igbm9ybWFsIFZNQSB0aGF0IGNv
dWxkIGJlIG1hZGUgCj4+PiBUSFAuCj4+Pgo+Pj4gV2UgaGFkIHRoaXMgVk1fQlVHX09OKCksIHdo
aWNoIHdvdWxkIGhhdmUgbmV2ZXIgaGl0IGJlY2F1c2Ugd2Ugd291bGQKPj4+IGhhdmUgc2V0IGZv
cmNlX3B0ZSBpZiB0aGV5IHdlcmUgbm90IGFsaWduZWQuCj4+Cj4+IFllcywgSSBhZ3JlZS4KPj4K
Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIFNraXAgbWVtc2xvdHMgd2l0aCB1bmFsaWduZWQgSVBB
IGFuZCB1c2VyIGFkZHJlc3MgKi8KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICgoZ2ZuICYgbWFz
aykgIT0gKHBmbiAmIG1hc2spKQo+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
ZmFsc2U7Cj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocGZuICYgbWFzaykgewo+Pj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqaXBhcCAmPSBQTURfTUFTSzsKPj4+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3JlbGVhc2VfcGZuX2NsZWFuKHBmbik7Cj4+Pj4+Cj4+
Pj4KPj4+PiAtLS04Pi0tLQo+Pj4+Cj4+Pj4gUmV3b3JrIGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9o
dWdlX21hcHBpbmcoKSwgbGV0IGl0IGNoZWNrIFRIUCBhZ2Fpbi4KPj4+Pgo+Pj4+IFNpZ25lZC1v
ZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4+IC0tLQo+Pj4+IMKg
wqB2aXJ0L2t2bS9hcm0vbW11LmMgfCAxMSArKysrKysrKysrLQo+Pj4+IMKgwqAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdp
dCBhL3ZpcnQva3ZtL2FybS9tbXUuYyBiL3ZpcnQva3ZtL2FybS9tbXUuYwo+Pj4+IGluZGV4IDI3
Yzk1ODMuLjVlMWIyNTggMTAwNjQ0Cj4+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4+Pj4g
KysrIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+Pj4gQEAgLTE2MzIsNiArMTYzMiwxNSBAQCBzdGF0
aWMgYm9vbCAKPj4+PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKHN0cnVjdCBr
dm1fbWVtb3J5X3Nsb3QgKm1lbXNsb3QsCj4+Pj4gwqDCoMKgwqDCoCB1YWRkcl9lbmQgPSB1YWRk
cl9zdGFydCArIHNpemU7Cj4+Pj4KPj4+PiDCoMKgwqDCoMKgIC8qCj4+Pj4gK8KgwqDCoMKgICog
SWYgdGhlIG1lbXNsb3QgaXMgX25vdF8gYmFja2VkIGJ5IGh1Z2V0bGJmcywgdGhlbiBjaGVjayBp
ZiBpdAo+Pj4+ICvCoMKgwqDCoCAqIGNhbiBiZSBiYWNrZWQgYnkgdHJhbnNwYXJlbnQgaHVnZXBh
Z2VzLgo+Pj4+ICvCoMKgwqDCoCAqCj4+Pj4gK8KgwqDCoMKgICogQ3VycmVudGx5IG9ubHkgUE1E
X1NJWkUgVEhQcyBhcmUgc3VwcG9ydGVkLCByZXZpc2l0IGl0IGxhdGVyLgo+Pj4+ICvCoMKgwqDC
oCAqLwo+Pj4+ICvCoMKgwqAgaWYgKG1hcF9zaXplID09IFBBR0VfU0laRSkKPj4+PiArwqDCoMKg
wqDCoMKgwqAgbWFwX3NpemUgPSBQTURfU0laRTsKPj4+PiArCj4+Pgo+Pj4gVGhpcyBsb29rcyBo
YWNraXNoLiBXaGF0IGlzIHdlIHN1cHBvcnQgUFVEX1NJWkUgaHVnZSBwYWdlIGluIHRoZSBmdXR1
cmUKPj4+ID8KPj4KPj4gWWVzLCB0aGlzIG1pZ2h0IG1ha2UgdGhlIGNvZGUgYSBsaXR0bGUgZGlm
ZmljdWx0IHRvIHVuZGVyc3RhbmQuIEJ1dCBieQo+PiBkb2luZyBzbywgd2UgZm9sbG93IHRoZSBz
YW1lIGxvZ2ljIGJlZm9yZSBjb21taXQgYTgwODY4ZjM5ODU1NDg0MmIxNCwKPj4gdGhhdCBzYWlk
LCB3ZSBkbyB0aGUgdHdvLXN0ZXAgY2hlY2tpbmcgZm9yIG5vcm1hbCBzaXplIHBhZ2VzIGluCj4+
IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKSwgdG8gZGVjaWRlIGlmIHdlIGNh
biBjcmVhdGUgVEhQCj4+IG1hcHBpbmdzIGZvciB0aGVzZSBwYWdlcy4KPj4KPj4gQXMgZm9yIFBV
RF9TSVpFIFRIUHMsIHRvIGJlIGhvbmVzdCwgSSBoYXZlIG5vIGlkZWEgbm93IDooCj4gCj4gSG93
IGFib3V0IHRoZSBmb2xsb3dpbmcgZGlmZiA/Cj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2Fy
bS9tbXUuYyBiL3ZpcnQva3ZtL2FybS9tbXUuYwo+IGluZGV4IDk3YjU0MTcuLjk4ZTVjZWMgMTAw
NjQ0Cj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4gKysrIGIvdmlydC9rdm0vYXJtL21tdS5j
Cj4gQEAgLTE3OTEsNyArMTc5MSw4IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCAKPiBwaHlzX2FkZHJfdCBmYXVsdF9pcGEsCj4gIMKgwqDCoMKgwqDC
oMKgwqDCoCAqIGN1cnJlbnRseSBzdXBwb3J0ZWQuIFRoaXMgY29kZSB3aWxsIG5lZWQgdG8gYmUK
PiAgwqDCoMKgwqDCoMKgwqDCoMKgICogdXBkYXRlZCB0byBzdXBwb3J0IG90aGVyIFRIUCBzaXpl
cy4KPiAgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDCoMKgwqDCoMKgIGlmICh0cmFuc3Bh
cmVudF9odWdlcGFnZV9hZGp1c3QoJnBmbiwgJmZhdWx0X2lwYSkpCj4gK8KgwqDCoMKgwqDCoMKg
IGlmIChmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5ncyhtZW1zbG90LCBodmEsIFBN
RF9TSVpFKSAmJgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRyYW5zcGFyZW50X2h1Z2VwYWdl
X2FkanVzdCgmcGZuLCAmZmF1bHRfaXBhKSkKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZt
YV9wYWdlc2l6ZSA9IFBNRF9TSVpFOwo+ICDCoMKgwqDCoCB9CgpJIHRoaW5rIHRoaXMgaXMgZ29v
ZCBlbm91Z2ggZm9yIHRoZSBpc3N1ZS4KCihPbmUgbWlub3IgY29uY2VybjogV2l0aCB0aGlzIGNo
YW5nZSwgaXQgc2VlbXMgdGhhdCB3ZSBubyBsb25nZXIgbmVlZAoiZm9yY2VfcHRlIiBhbmQgY2Fu
IGp1c3QgdXNlICJsb2dnaW5nX2FjdGl2ZSIgaW5zdGVhZC4gQnV0IHRoaXMgaXMgbm90Cm11Y2gg
cmVsYXRlZCB0byB3aGF0IHdlJ3JlIGZpeGluZy4pCgoKdGhhbmtzLgoKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
