Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDEEC43603
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 14:52:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4935C24249
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 14:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4935C24249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C014AE9F;
	Thu,  5 Dec 2019 09:52:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l9RITu4AkCwM; Thu,  5 Dec 2019 09:52:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBFC34AEA0;
	Thu,  5 Dec 2019 09:52:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AFD94AE9C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 09:52:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kybJVrLKGMmt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 09:52:29 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3B654A944
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 09:52:29 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1icsUV-0007qd-2u; Thu, 05 Dec 2019 15:52:27 +0100
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained =?UTF-8?Q?SW=5FINCR=20?=
 =?UTF-8?Q?counters?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Thu, 05 Dec 2019 14:52:26 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
Message-ID: <15507faca89a980056df7119e105e82a@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andrew.murray@arm.com, suzuki.poulose@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

T24gMjAxOS0xMi0wNSAxNDowNiwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBNYXJjLAo+Cj4gT24g
MTIvNS8xOSAxMDo0MyBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBIaSBFcmljLAo+Pgo+PiBP
biAyMDE5LTEyLTA0IDIwOjQ0LCBFcmljIEF1Z2VyIHdyb3RlOgo+Pj4gQXQgdGhlIG1vbWVudCBh
IFNXX0lOQ1IgY291bnRlciBhbHdheXMgb3ZlcmZsb3dzIG9uIDMyLWJpdAo+Pj4gYm91bmRhcnks
IGluZGVwZW5kZW50bHkgb24gd2hldGhlciB0aGUgbisxdGggY291bnRlciBpcwo+Pj4gcHJvZ3Jh
bW1lZCBhcyBDSEFJTi4KPj4+Cj4+PiBDaGVjayB3aGV0aGVyIHRoZSBTV19JTkNSIGNvdW50ZXIg
aXMgYSA2NGIgY291bnRlciBhbmQgaWYgc28sCj4+PiBpbXBsZW1lbnQgdGhlIDY0YiBsb2dpYy4K
Pj4+Cj4+PiBGaXhlczogODBmMzkzYTIzYmU2ICgiS1ZNOiBhcm0vYXJtNjQ6IFN1cHBvcnQgY2hh
aW5lZCBQTVUgCj4+PiBjb3VudGVycyIpCj4+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxl
cmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+PiAtLS0KPj4+IMKgdmlydC9rdm0vYXJtL3BtdS5jIHwg
MTYgKysrKysrKysrKysrKysrLQo+Pj4gwqAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vcG11LmMg
Yi92aXJ0L2t2bS9hcm0vcG11LmMKPj4+IGluZGV4IGMzZjhiMDU5ODgxZS4uN2FiNDc3ZGIyZjc1
IDEwMDY0NAo+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL3BtdS5jCj4+PiArKysgYi92aXJ0L2t2bS9h
cm0vcG11LmMKPj4+IEBAIC00OTEsNiArNDkxLDggQEAgdm9pZCBrdm1fcG11X3NvZnR3YXJlX2lu
Y3JlbWVudChzdHJ1Y3Qga3ZtX3ZjcHUKPj4+ICp2Y3B1LCB1NjQgdmFsKQo+Pj4KPj4+IMKgwqDC
oMKgIGVuYWJsZSA9IF9fdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ05URU5TRVRfRUwwKTsKPj4+IMKg
wqDCoMKgIGZvciAoaSA9IDA7IGkgPCBBUk1WOF9QTVVfQ1lDTEVfSURYOyBpKyspIHsKPj4+ICvC
oMKgwqDCoMKgwqDCoCBib29sIGNoYWluZWQgPSB0ZXN0X2JpdChpID4+IDEsIHZjcHUtPmFyY2gu
cG11LmNoYWluZWQpOwo+Pj4gKwo+Pgo+PiBJJ2QgcmF0aGVyIHlvdSB1c2Uga3ZtX3BtdV9wbWNf
aXNfY2hhaW5lZCgpIHJhdGhlciB0aGFuIG9wZW4tY29kaW5nCj4+IHRoaXMuIEJ1dCBzZWUgYmVs
b3c6Cj4+Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIGlmICghKHZhbCAmIEJJVChpKSkpCj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIHR5cGUg
PSBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWVFlQRVIwX0VMMCArIGkpCj4+PiBAQCAtNTAwLDgg
KzUwMiwyMCBAQCB2b2lkIGt2bV9wbXVfc29mdHdhcmVfaW5jcmVtZW50KHN0cnVjdCAKPj4+IGt2
bV92Y3B1Cj4+PiAqdmNwdSwgdTY0IHZhbCkKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZWcgPSBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSkgKyAxOwo+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IGxvd2VyXzMyX2JpdHMocmVnKTsKPj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsg
aSkgPSByZWc7Cj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXJlZykKPj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZWcpIC8qIG5vIG92ZXJmbG93ICovCj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgaWYgKGNoYWluZWQpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmVnID0gX192Y3B1X3N5c19yZWcodmNwdSwgUE1FVkNOVFIwX0VMMCArIGkgKyAxKSAKPj4+ICsg
MTsKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gbG93ZXJfMzJfYml0
cyhyZWcpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3Jl
Zyh2Y3B1LCBQTUVWQ05UUjBfRUwwICsgaSArIDEpID0gcmVnOwo+Pj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBpZiAocmVnKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAvKiBtYXJrIGFuIG92ZXJmbG93IG9uIGhpZ2ggY291bnRlciAqLwo+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTU9WU1NFVF9FTDApIHw9
IEJJVChpICsgMSk7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9IGVsc2Ugewo+Pj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBtYXJrIGFuIG92ZXJmbG93ICovCj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3ZjcHVfc3lzX3JlZyh2Y3B1LCBQTU9W
U1NFVF9FTDApIHw9IEJJVChpKTsKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0KPj4+IMKg
wqDCoMKgwqDCoMKgwqAgfQo+Pj4gwqDCoMKgwqAgfQo+Pj4gwqB9Cj4+Cj4+IEkgdGhpbmsgdGhl
IHdob2xlIGZ1bmN0aW9uIGlzIGEgYml0IG9mIGEgbWVzcywgYW5kIGNvdWxkIGJlIGJldHRlcgo+
PiBzdHJ1Y3R1cmVkIHRvIHRyZWF0IDY0Yml0IGNvdW50ZXJzIGFzIGEgZmlyc3QgY2xhc3MgY2l0
aXplbi4KPj4KPj4gSSdtIHN1Z2dlc3Rpbmcgc29tZXRoaW5nIGFsb25nIHRob3NlIGxpbmVzLCB3
aGljaCB0cmllcyB0bwo+PiBzdHJlYW1saW5lIHRoaW5ncyBhIGJpdCBhbmQga2VlcCB0aGUgZmxv
dyB1bmlmb3JtIGJldHdlZW4gdGhlCj4+IHR3byB3b3JkIHNpemVzLiBJTUhPLCBpdCBoZWxwcyBy
ZWFzb25uaW5nIGFib3V0IGl0IGFuZCBnaXZlcwo+PiBzY29wZSB0byB0aGUgQVJNdjguNSBmdWxs
IDY0Yml0IGNvdW50ZXJzLi4uIEl0IGlzIG9mIGNvdXJzZQo+PiBjb21wbGV0ZWx5IHVudGVzdGVk
Lgo+Cj4gTG9va3MgT0sgdG8gbWUgYXMgd2VsbC4gT25lIHJlbWFyayB0aG91Z2gsIGRvbid0IHdl
IG5lZWQgdG8gdGVzdCBpZiAKPiB0aGUKPiBuKzF0aCByZWcgaXMgZW5hYmxlZCBiZWZvcmUgaW5j
cmVtZW50aW5nIGl0PwoKSG1tbS4gSSdtIG5vdCBzdXJlLiBJIHRoaW5rIHdlIHNob3VsZCBtYWtl
IHN1cmUgdGhhdCB3ZSBkb24ndCBmbGFnCmEgY291bnRlciBhcyBiZWluZyBjaGFpbmVkIGlmIHRo
ZSBvZGQgY291bnRlciBpcyBkaXNhYmxlZCwgcmF0aGVyCnRoYW4gY2hlY2tpbmcgaXQgaGVyZS4g
QXMgbG9uZyBhcyB0aGUgb2RkIGNvdW50ZXIgaXMgbm90IGNoYWluZWQKKmFuZCogZW5hYmxlZCwg
d2Ugc2hvdWxkbid0IHRvdWNoIGl0LgoKQWdhaW4sIHVudGVzdGVkOgoKZGlmZiAtLWdpdCBhL3Zp
cnQva3ZtL2FybS9wbXUuYyBiL3ZpcnQva3ZtL2FybS9wbXUuYwppbmRleCBjZjM3MWY2NDNhZGUu
LjQ3MzY2ODE3Y2QyYSAxMDA2NDQKLS0tIGEvdmlydC9rdm0vYXJtL3BtdS5jCisrKyBiL3ZpcnQv
a3ZtL2FybS9wbXUuYwpAQCAtMTUsNiArMTUsNyBAQAogICNpbmNsdWRlIDxrdm0vYXJtX3ZnaWMu
aD4KCiAgc3RhdGljIHZvaWQga3ZtX3BtdV9jcmVhdGVfcGVyZl9ldmVudChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHU2NCAKc2VsZWN0X2lkeCk7CitzdGF0aWMgdm9pZCBrdm1fcG11X3VwZGF0ZV9w
bWNfY2hhaW5lZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCAKc2VsZWN0X2lkeCk7CgogICNk
ZWZpbmUgUEVSRl9BVFRSX0NGRzFfS1ZNX1BNVV9DSEFJTkVEIDB4MQoKQEAgLTI5OCw2ICsyOTks
NyBAQCB2b2lkIGt2bV9wbXVfZW5hYmxlX2NvdW50ZXJfbWFzayhzdHJ1Y3Qga3ZtX3ZjcHUgCip2
Y3B1LCB1NjQgdmFsKQogIAkJICogRm9yIGhpZ2ggY291bnRlcnMgb2YgY2hhaW5lZCBldmVudHMg
d2UgbXVzdCByZWNyZWF0ZSB0aGUKICAJCSAqIHBlcmYgZXZlbnQgd2l0aCB0aGUgbG9uZyAoNjRi
aXQpIGF0dHJpYnV0ZSBzZXQuCiAgCQkgKi8KKwkJa3ZtX3BtdV91cGRhdGVfcG1jX2NoYWluZWQo
dmNwdSwgaSk7CiAgCQlpZiAoa3ZtX3BtdV9wbWNfaXNfY2hhaW5lZChwbWMpICYmCiAgCQkgICAg
a3ZtX3BtdV9pZHhfaXNfaGlnaF9jb3VudGVyKGkpKSB7CiAgCQkJa3ZtX3BtdV9jcmVhdGVfcGVy
Zl9ldmVudCh2Y3B1LCBpKTsKQEAgLTY0NSw3ICs2NDcsOCBAQCBzdGF0aWMgdm9pZCBrdm1fcG11
X3VwZGF0ZV9wbWNfY2hhaW5lZChzdHJ1Y3QgCmt2bV92Y3B1ICp2Y3B1LCB1NjQgc2VsZWN0X2lk
eCkKICAJc3RydWN0IGt2bV9wbXUgKnBtdSA9ICZ2Y3B1LT5hcmNoLnBtdTsKICAJc3RydWN0IGt2
bV9wbWMgKnBtYyA9ICZwbXUtPnBtY1tzZWxlY3RfaWR4XTsKCi0JaWYgKGt2bV9wbXVfaWR4X2hh
c19jaGFpbl9ldnR5cGUodmNwdSwgcG1jLT5pZHgpKSB7CisJaWYgKGt2bV9wbXVfaWR4X2hhc19j
aGFpbl9ldnR5cGUodmNwdSwgcG1jLT5pZHgpICYmCisJICAgIGt2bV9wbXVfY291bnRlcl9pc19l
bmFibGVkKHZjcHUsIHBtYy0+aWR4KSkgewogIAkJLyoKICAJCSAqIER1cmluZyBwcm9tb3Rpb24g
ZnJvbSAhY2hhaW5lZCB0byBjaGFpbmVkIHdlIG11c3QgZW5zdXJlCiAgCQkgKiB0aGUgYWRqYWNl
bnQgY291bnRlciBpcyBzdG9wcGVkIGFuZCBpdHMgZXZlbnQgZGVzdHJveWVkCgpXaGF0IGRvIHlv
dSB0aGluaz8KCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxs
cyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
