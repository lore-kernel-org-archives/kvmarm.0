Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FF8C10F0E
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 02:21:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A16E62084B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 02:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A16E62084B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2374A481;
	Tue,  9 Apr 2019 22:21:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 13+DjhciYvPT; Tue,  9 Apr 2019 22:21:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 189874A477;
	Tue,  9 Apr 2019 22:21:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4D14A447
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 22:21:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 35vyh27XNX8o for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 22:21:39 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B40E04A409
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 22:21:38 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id F3092206E0C8039C669D;
 Wed, 10 Apr 2019 10:21:33 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.408.0; Wed, 10 Apr 2019
 10:21:26 +0800
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
 <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
 <a9c084fb-0c84-e632-a192-b361773a0bc8@arm.com>
 <44ffad26-a407-4603-0bb6-145f7290adbe@huawei.com>
 <730c25b4-dbc5-8d8b-514c-4ed8641701ce@arm.com>
 <1b398e29-e2d5-2a58-b4ca-c72979a170d8@huawei.com>
 <520e277c-f096-a84b-8405-636b19e4cc46@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8bf8e863-93f5-ab44-c0aa-1ad23f91a016@huawei.com>
Date: Wed, 10 Apr 2019 10:20:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <520e277c-f096-a84b-8405-636b19e4cc46@arm.com>
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
Message-ID: <20190410022030.QAvWR4ocwdHv68GA-KFIumf7IdOctXQTVupEQ3ElOTc@z>

Ck9uIDIwMTkvNC85IDIyOjU5LCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+IEhpIFplbmdodWkK
PiAKPiBPbiAwNC8wOS8yMDE5IDA5OjA1IEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+Pgo+Pgo+PiBP
biAyMDE5LzQvOSAyOjQwLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+Pj4gSGkgWmVuaHVpLAo+
Pj4KPj4+IE9uIDA0LzA4LzIwMTkgMDQ6MTEgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4+Pj4gSGkg
U3V6dWtpLAo+Pj4+Cj4+Pj4gVGhhbmtzIGZvciB0aGUgcmVwbHkuCj4+Pj4KPj4+Cj4+PiAuLi4K
Pj4+Cj4+Pj4+PiBIaSBTdXp1a2ksCj4+Pj4+Pgo+Pj4+Pj4gV2h5IG5vdCBtYWtpbmcgdXNlIG9m
IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKT/CoCBMZXQgCj4+Pj4+PiBpdCBk
bwo+Pj4+Pj4gc29tZSBjaGVja3MgZm9yIHVzLgo+Pj4+Pj4KPj4+Pj4+IGZhdWx0X3N1cHBvcnRz
X3N0YWdlMl9odWdlX21hcHBpbmcoKSB3YXMgaW50ZW5kZWQgdG8gZG8gYSAqdHdvLXN0ZXAqCj4+
Pj4+PiBjaGVjayB0byB0ZWxsIHVzIHRoYXQgY2FuIHdlIGNyZWF0ZSBzdGFnZTIgaHVnZSBibG9j
ayBtYXBwaW5ncywgCj4+Pj4+PiBhbmQgdGhpcwo+Pj4+Pj4gY2hlY2sgaXMgYm90aCBmb3IgaHVn
ZXRsYmZzIGFuZCBUSFAuwqAgV2l0aCBjb21taXQgCj4+Pj4+PiBhODA4NjhmMzk4NTU0ODQyYjE0
LAo+Pj4+Pj4gd2UgcGFzcyBQQUdFX1NJWkUgYXMgIm1hcF9zaXplIiBmb3Igbm9ybWFsIHNpemUg
cGFnZXMgKHdoaWNoIAo+Pj4+Pj4gdHVybmVkIG91dAo+Pj4+Pj4gdG8gYmUgYWxtb3N0IG1lYW5p
bmdsZXNzKSwgYW5kIHVuZm9ydHVuYXRlbHkgdGhlIFRIUCBjaGVjayBubyBsb25nZXIKPj4+Pj4+
IHdvcmtzLgo+Pj4+Pgo+Pj4+PiBUaGF0cyBjb3JyZWN0Lgo+Pj4+Pgo+Pj4+Pj4KPj4+Pj4+IFNv
IHdlIHdhbnQgdG8gcmV3b3JrICpUSFAqIGNoZWNrIHByb2Nlc3MuwqAgWW91ciBwYXRjaCBmaXhl
cyB0aGUgZmlyc3QKPj4+Pj4+IGNoZWNraW5nLXN0ZXAsIGJ1dCB0aGUgc2Vjb25kIGlzIHN0aWxs
IG1pc3NlZCwgYW0gSSB3cm9uZz8KPj4+Pj4KPj4+Pj4gSXQgZml4ZXMgdGhlIHN0ZXAgZXhwbGlj
aXRseSBmb3IgdGhlIFRIUCBieSBtYWtpbmcgc3VyZSB0aGF0IHRoZSAKPj4+Pj4gR1BBIGFuZAo+
Pj4+PiB0aGUgSFZBIGFyZSBhbGlnbmVkIHRvIHRoZSBtYXAgc2l6ZS4KPj4+Pgo+Pj4+IFllcywg
SSB1bmRlcnN0YW5kIGhvdyB5b3VyIHBhdGNoIGhhZCBmaXhlZCB0aGUgaXNzdWUuwqAgQnV0IHdo
YXQgSSdtCj4+Pj4gcmVhbGx5IGNvbmNlcm5lZCBhYm91dCBoZXJlIGlzIHRoZSAqc2Vjb25kKiBj
aGVja2luZy1zdGVwIGluCj4+Pj4gZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygp
Lgo+Pj4+Cj4+Pj4gV2UgaGF2ZSB0byBjaGVjayBpZiB3ZSBhcmUgbWFwcGluZyBhIG5vbi1ibG9j
ayBhbGlnbmVkIG9yIG5vbi1ibG9jawo+Pj4+IHNpemVkIG1lbXNsb3QsIGlmIHNvLCB3ZSBjYW4g
bm90IGNyZWF0ZSBibG9jayBtYXBwaW5ncyBmb3IgdGhlIAo+Pj4+IGJlZ2lubmluZwo+Pj4+IGFu
ZCBlbmQgb2YgdGhpcyBtZW1zbG90LsKgIFRoaXMgaXMgd2hhdCB0aGUgc2Vjb25kIHBhcnQgb2YK
Pj4+PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKCkgaGFkIGRvbmUuCj4+Pj4K
Pj4+PiBJIGhhdmVuJ3Qgc2VlbiB0aGlzIGNoZWNraW5nLXN0ZXAgaW4geW91ciBwYXRjaCwgZGlk
IEkgbWlzcyBzb21ldGhpbmc/Cj4+Pj4KPj4+Cj4+PiBJIHNlZS4KPj4+Cj4+Pj4+IEkgZG9uJ3Qg
dGhpbmsgdGhpcyBjYWxscyBmb3IgYSBWTV9CVUdfT04oKS4gSXQgaXMgc2ltcGx5IGEgY2FzZSB3
aGVyZQo+Pj4+PiB0aGUgR1BBIGlzIG5vdCBhbGlnbmVkIHRvIEhWQSwgYnV0IGZvciBub3JtYWwg
Vk1BIHRoYXQgY291bGQgYmUgCj4+Pj4+IG1hZGUgVEhQLgo+Pj4+Pgo+Pj4+PiBXZSBoYWQgdGhp
cyBWTV9CVUdfT04oKSwgd2hpY2ggd291bGQgaGF2ZSBuZXZlciBoaXQgYmVjYXVzZSB3ZSB3b3Vs
ZAo+Pj4+PiBoYXZlIHNldCBmb3JjZV9wdGUgaWYgdGhleSB3ZXJlIG5vdCBhbGlnbmVkLgo+Pj4+
Cj4+Pj4gWWVzLCBJIGFncmVlLgo+Pj4+Cj4+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIFNraXAg
bWVtc2xvdHMgd2l0aCB1bmFsaWduZWQgSVBBIGFuZCB1c2VyIGFkZHJlc3MgKi8KPj4+Pj4+PiAr
wqDCoMKgwqDCoMKgwqAgaWYgKChnZm4gJiBtYXNrKSAhPSAocGZuICYgbWFzaykpCj4+Pj4+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOwo+Pj4+Pj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAocGZuICYgbWFzaykgewo+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICppcGFwICY9IFBNRF9NQVNLOwo+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGt2bV9yZWxlYXNlX3Bmbl9jbGVhbihwZm4pOwo+Pj4+Pj4+Cj4+Pj4+Pgo+Pj4+Pj4gLS0tOD4t
LS0KPj4+Pj4+Cj4+Pj4+PiBSZXdvcmsgZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGlu
ZygpLCBsZXQgaXQgY2hlY2sgVEhQIGFnYWluLgo+Pj4+Pj4KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6
IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4+Pj4gLS0tCj4+Pj4+PiDCoMKg
dmlydC9rdm0vYXJtL21tdS5jIHwgMTEgKysrKysrKysrKy0KPj4+Pj4+IMKgwqAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4+Pj4KPj4+Pj4+IGRpZmYg
LS1naXQgYS92aXJ0L2t2bS9hcm0vbW11LmMgYi92aXJ0L2t2bS9hcm0vbW11LmMKPj4+Pj4+IGlu
ZGV4IDI3Yzk1ODMuLjVlMWIyNTggMTAwNjQ0Cj4+Pj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vbW11
LmMKPj4+Pj4+ICsrKyBiL3ZpcnQva3ZtL2FybS9tbXUuYwo+Pj4+Pj4gQEAgLTE2MzIsNiArMTYz
MiwxNSBAQCBzdGF0aWMgYm9vbCAKPj4+Pj4+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21h
cHBpbmcoc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqbWVtc2xvdCwKPj4+Pj4+IMKgwqDCoMKgwqAg
dWFkZHJfZW5kID0gdWFkZHJfc3RhcnQgKyBzaXplOwo+Pj4+Pj4KPj4+Pj4+IMKgwqDCoMKgwqAg
LyoKPj4+Pj4+ICvCoMKgwqDCoCAqIElmIHRoZSBtZW1zbG90IGlzIF9ub3RfIGJhY2tlZCBieSBo
dWdldGxiZnMsIHRoZW4gY2hlY2sgaWYgaXQKPj4+Pj4+ICvCoMKgwqDCoCAqIGNhbiBiZSBiYWNr
ZWQgYnkgdHJhbnNwYXJlbnQgaHVnZXBhZ2VzLgo+Pj4+Pj4gK8KgwqDCoMKgICoKPj4+Pj4+ICvC
oMKgwqDCoCAqIEN1cnJlbnRseSBvbmx5IFBNRF9TSVpFIFRIUHMgYXJlIHN1cHBvcnRlZCwgcmV2
aXNpdCBpdCBsYXRlci4KPj4+Pj4+ICvCoMKgwqDCoCAqLwo+Pj4+Pj4gK8KgwqDCoCBpZiAobWFw
X3NpemUgPT0gUEFHRV9TSVpFKQo+Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIG1hcF9zaXplID0gUE1E
X1NJWkU7Cj4+Pj4+PiArCj4+Pj4+Cj4+Pj4+IFRoaXMgbG9va3MgaGFja2lzaC4gV2hhdCBpcyB3
ZSBzdXBwb3J0IFBVRF9TSVpFIGh1Z2UgcGFnZSBpbiB0aGUgCj4+Pj4+IGZ1dHVyZQo+Pj4+PiA/
Cj4+Pj4KPj4+PiBZZXMsIHRoaXMgbWlnaHQgbWFrZSB0aGUgY29kZSBhIGxpdHRsZSBkaWZmaWN1
bHQgdG8gdW5kZXJzdGFuZC4gQnV0IGJ5Cj4+Pj4gZG9pbmcgc28sIHdlIGZvbGxvdyB0aGUgc2Ft
ZSBsb2dpYyBiZWZvcmUgY29tbWl0IGE4MDg2OGYzOTg1NTQ4NDJiMTQsCj4+Pj4gdGhhdCBzYWlk
LCB3ZSBkbyB0aGUgdHdvLXN0ZXAgY2hlY2tpbmcgZm9yIG5vcm1hbCBzaXplIHBhZ2VzIGluCj4+
Pj4gZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygpLCB0byBkZWNpZGUgaWYgd2Ug
Y2FuIGNyZWF0ZSBUSFAKPj4+PiBtYXBwaW5ncyBmb3IgdGhlc2UgcGFnZXMuCj4+Pj4KPj4+PiBB
cyBmb3IgUFVEX1NJWkUgVEhQcywgdG8gYmUgaG9uZXN0LCBJIGhhdmUgbm8gaWRlYSBub3cgOigK
Pj4+Cj4+PiBIb3cgYWJvdXQgdGhlIGZvbGxvd2luZyBkaWZmID8KPj4+Cj4+PiBkaWZmIC0tZ2l0
IGEvdmlydC9rdm0vYXJtL21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+PiBpbmRleCA5N2I1
NDE3Li45OGU1Y2VjIDEwMDY0NAo+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4+PiArKysg
Yi92aXJ0L2t2bS9hcm0vbW11LmMKPj4+IEBAIC0xNzkxLDcgKzE3OTEsOCBAQCBzdGF0aWMgaW50
IHVzZXJfbWVtX2Fib3J0KHN0cnVjdCBrdm1fdmNwdSAKPj4+ICp2Y3B1LCBwaHlzX2FkZHJfdCBm
YXVsdF9pcGEsCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGN1cnJlbnRseSBzdXBwb3J0ZWQu
IFRoaXMgY29kZSB3aWxsIG5lZWQgdG8gYmUKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgICogdXBk
YXRlZCB0byBzdXBwb3J0IG90aGVyIFRIUCBzaXplcy4KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICovCj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKHRyYW5zcGFyZW50X2h1Z2VwYWdlX2FkanVzdCgm
cGZuLCAmZmF1bHRfaXBhKSkKPj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoZmF1bHRfc3VwcG9ydHNf
c3RhZ2UyX2h1Z2VfbWFwcGluZ3MobWVtc2xvdCwgaHZhLCAKPj4+IFBNRF9TSVpFKSAmJgo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHJhbnNwYXJlbnRfaHVnZXBhZ2VfYWRqdXN0KCZwZm4s
ICZmYXVsdF9pcGEpKQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm1hX3BhZ2VzaXpl
ID0gUE1EX1NJWkU7Cj4+PiDCoMKgwqDCoMKgIH0KPj4KPj4gSSB0aGluayB0aGlzIGlzIGdvb2Qg
ZW5vdWdoIGZvciB0aGUgaXNzdWUuCj4+Cj4+IChPbmUgbWlub3IgY29uY2VybjogV2l0aCB0aGlz
IGNoYW5nZSwgaXQgc2VlbXMgdGhhdCB3ZSBubyBsb25nZXIgbmVlZAo+PiAiZm9yY2VfcHRlIiBh
bmQgY2FuIGp1c3QgdXNlICJsb2dnaW5nX2FjdGl2ZSIgaW5zdGVhZC4gQnV0IHRoaXMgaXMgbm90
Cj4+IG11Y2ggcmVsYXRlZCB0byB3aGF0IHdlJ3JlIGZpeGluZy4pCj4gCj4gSSB3b3VsZCBzdGls
bCBsZWF2ZSB0aGUgZm9yY2VfcHRlIHRoZXJlIHRvIGF2b2lkIGNoZWNraW5nIGZvciBhIFRIUCBj
YXNlCj4gaW4gYSBzaXR1YXRpb24gd2hlcmUgd2UgZm9yY2VkIHRvIFBURSBsZXZlbCBtYXBwaW5n
IG9uIGEgaHVnZXBhZ2UgYmFja2VkCj4gVk1BLiBJdCB3b3VsZCBzZXJ2ZSB0byBhdm9pZCBhbm90
aGVyIGNoZWNrLgoKSGkgU3V6dWtpLAoKWWVzLCBJIGFncmVlLCB0aGFua3MuCgoKemVuZ2h1aQoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
