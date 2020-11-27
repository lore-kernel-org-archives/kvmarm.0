Return-Path: <SRS0=tVNh=FB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F03C2D0E4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 14:49:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96541221EB
	for <kvmarm@archiver.kernel.org>; Fri, 27 Nov 2020 14:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96541221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCBDB4BEC3;
	Fri, 27 Nov 2020 09:49:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZLCxNuURuYww; Fri, 27 Nov 2020 09:49:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE4A4BE15;
	Fri, 27 Nov 2020 09:49:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6D54BE15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 09:49:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WqleUqIzJnNZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2020 09:49:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B16D94BE06
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2020 09:49:13 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 382481516;
 Fri, 27 Nov 2020 06:49:13 -0800 (PST)
Received: from [10.37.12.49] (unknown [10.37.12.49])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34E3A3F70D;
 Fri, 27 Nov 2020 06:49:12 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To: Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fd32d075-c6a9-a869-14a9-2c29f41d3318@arm.com>
Date: Fri, 27 Nov 2020 14:50:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
Content-Language: en-US
Cc: andre.przywara@arm.com
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgWmhlbmdodWksCgpUaGFuayB5b3UgZm9yIGhhdmluZyBhIGxvb2sgYXQgdGhpcyEKCk9uIDEx
LzI2LzIwIDk6MzAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gT24gMjAyMC8xMS8yNSAyMzo1MSwg
QWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gVGhlIHJlYXNvbiBmb3IgdGhlIGZhaWx1cmUgaXMg
dGhhdCB0aGUgdGVzdCAiZGV2Mi9ldmVudGlkPTIwIG5vdyB0cmlnZ2Vycwo+PiBhbiBMUEkiIHRy
aWdnZXJzIDIgTFBJcywgbm90IG9uZS4gVGhpcyBiZWhhdmlvciB3YXMgcHJlc2VudCBiZWZvcmUg
dGhpcwo+PiBwYXRjaCwgYnV0IGl0IHdhcyBpZ25vcmVkIGJlY2F1c2UgY2hlY2tfbHBpX3N0YXRz
KCkgd2Fzbid0IGxvb2tpbmcgYXQgdGhlCj4+IGFja2VkIGFycmF5Lgo+Pgo+PiBJJ20gbm90IGZh
bWlsaWFyIHdpdGggdGhlIElUUyBzbyBJJ20gbm90IHN1cmUgaWYgdGhpcyBpcyBleHBlY3RlZCwg
aWYgdGhlCj4+IHRlc3QgaXMgaW5jb3JyZWN0IG9yIGlmIHRoZXJlIGlzIHNvbWV0aGluZyB3cm9u
ZyB3aXRoIEtWTSBlbXVsYXRpb24uCj4KPiBJIHRoaW5rIHRoaXMgaXMgZXhwZWN0ZWQsIG9yIG5v
dC4KPgo+IEJlZm9yZSBJTlZBTEwsIHRoZSBMUEktODE5NSB3YXMgYWxyZWFkeSBwZW5kaW5nIGJ1
dCBkaXNhYmxlZC4gT24KPiByZWNlaXZpbmcgSU5WQUxMLCBWR0lDIHdpbGwgcmVsb2FkIGNvbmZp
Z3VyYXRpb24gZm9yIGFsbCBMUElzIHRhcmdldGluZwo+IGNvbGxlY3Rpb24tMyBhbmQgZGVsaXZl
ciB0aGUgbm93IGVuYWJsZWQgTFBJLTgxOTUuIFdlJ2xsIHRoZXJlZm9yZSBzZWUKPiBhbmQgaGFu
ZGxlIGl0IGJlZm9yZSBzZW5kaW5nIHRoZSBmb2xsb3dpbmcgSU5UICh3aGljaCB3aWxsIHNldCB0
aGUKPiBMUEktODE5NSBwZW5kaW5nIGFnYWluKS4KPgo+PiBEaWQgc29tZSBtb3JlIHRlc3Rpbmcg
b24gYW4gQW1wZXJlIGVNQUcgKGZhc3Qgb3V0LW9mLW9yZGVyIGNvcmVzKSB1c2luZwo+PiBxZW11
IGFuZCBrdm10b29sIGFuZCBMaW51eCB2NS44LCBoZXJlJ3Mgd2hhdCBJIGZvdW5kOgo+Pgo+PiAt
IFVzaW5nIHFlbXUgYW5kIGdpYy5mbGF0IGJ1aWx0IGZyb20qbWFzdGVyKjogZXJyb3IgZW5jb3Vu
dGVyZWQgODY0IHRpbWVzCj4+IMKgwqAgb3V0IG9mIDEwODggcnVucy4KPj4gLSBVc2luZyBxZW11
OiBlcnJvciBlbmNvdW50ZXJlZCA4NTIgdGltZXMgb3V0IG9mIDEwMjcgcnVucy4KPj4gLSBVc2lu
ZyBrdm10b29sOiBlcnJvciBlbmNvdW50ZXJlZCA4MTY0IHRpbWVzIG91dCBvZiAxMDYwMiBydW5z
Lgo+Cj4gSWYgdmNwdS0zIGhhZG4ndCBzZWVuIGFuZCBoYW5kbGVkIExQSS04MTk1IGFzIHF1aWNr
bHkgYXMgcG9zc2libGUgKGUuZy4sCj4gdmNwdS0zIGhhZG4ndCBiZWVuIHNjaGVkdWxlZCksIHRo
ZSBmb2xsb3dpbmcgSU5UIHdpbGwgc2V0IHRoZSBhbHJlYWR5Cj4gcGVuZGluZyBMUEktODE5NSBw
ZW5kaW5nIGFnYWluIGFuZCB3ZSdsbCByZWNlaXZlIGl0ICpvbmNlKiBvbiB2Y3B1LTMuCj4gQW5k
IHdlIHdvbid0IHNlZSB0aGUgbWVudGlvbmVkIGZhaWx1cmUuCj4KPiBJIHRoaW5rIHdlIGNhbiBq
dXN0IGRyb3AgdGhlIChtZWFuaW5nbGVzcyBhbmQgY29uZnVzaW5nPykgSU5ULgoKSSB0aGluayBJ
IHVuZGVyc3RhbmQgeW91ciBleHBsYW5hdGlvbiwgdGhlIFZDUFUgdGFrZXMgdGhlIGludGVycnVw
dCBpbW1lZGlhdGVseQphZnRlciB0aGUgSU5WQUxMIGFuZCBiZWZvcmUgdGhlIElOVCwgYW5kIHRo
ZSBzZWNvbmQgaW50ZXJydXB0IHRoYXQgSSBhbSBzZWVpbmcgaXMKdGhlIG9uZSBjYXVzZWQgYnkg
dGhlIElOVCBjb21tYW5kLgoKSSB0cmllZCBtb2RpZnlpbmcgdGhlIHRlc3QgbGlrZSB0aGlzOgoK
ZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9naWMuYwppbmRleCA2ZTkzZGE4MGZlMGQuLjBl
ZjhjMTJlYTIzNCAxMDA2NDQKLS0tIGEvYXJtL2dpYy5jCisrKyBiL2FybS9naWMuYwpAQCAtNzYx
LDEwICs3NjEsMTcgQEAgc3RhdGljIHZvaWQgdGVzdF9pdHNfdHJpZ2dlcih2b2lkKQrCoMKgwqDC
oMKgwqDCoCB3bWIoKTsKwqDCoMKgwqDCoMKgwqAgY3B1bWFza19jbGVhcigmbWFzayk7CsKgwqDC
oMKgwqDCoMKgIGNwdW1hc2tfc2V0X2NwdSgzLCAmbWFzayk7Ci3CoMKgwqDCoMKgwqAgaXRzX3Nl
bmRfaW50KGRldjIsIDIwKTsKwqDCoMKgwqDCoMKgwqAgd2FpdF9mb3JfaW50ZXJydXB0cygmbWFz
ayk7CsKgwqDCoMKgwqDCoMKgIHJlcG9ydChjaGVja19hY2tlZCgmbWFzaywgMCwgODE5NSksCi3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiZGV2Mi9ldmVudGlk
PTIwIG5vdyB0cmlnZ2VycyBhbiBMUEkiKTsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkgaXMgcmVjZWl2ZWQi
KTsKKworwqDCoMKgwqDCoMKgIHN0YXRzX3Jlc2V0KCk7CivCoMKgwqDCoMKgwqAgd21iKCk7CivC
oMKgwqDCoMKgwqAgY3B1bWFza19jbGVhcigmbWFzayk7CivCoMKgwqDCoMKgwqAgY3B1bWFza19z
ZXRfY3B1KDMsICZtYXNrKTsKK8KgwqDCoMKgwqDCoCBpdHNfc2VuZF9pbnQoZGV2MiwgMjApOwor
wqDCoMKgwqDCoMKgIHdhaXRfZm9yX2ludGVycnVwdHMoJm1hc2spOworwqDCoMKgwqDCoMKgIHJl
cG9ydChjaGVja19hY2tlZCgmbWFzaywgMCwgODE5NSksICJkZXYyL2V2ZW50aWQ9MjAgdHJpZ2dl
cnMgYW4gTFBJIik7CsKgCsKgwqDCoMKgwqDCoMKgIHJlcG9ydF9wcmVmaXhfcG9wKCk7CsKgCkkg
cmVtb3ZlZCB0aGUgSU5UIGZyb20gdGhlIGluaXRpYWwgdGVzdCwgYW5kIGFkZGVkIGEgc2VwYXJh
dGUgb25lIHRvIGNoZWNrIHRoYXQKdGhlIElOVCBjb21tYW5kIHN0aWxsIHdvcmtzLiBUaGF0IGxv
b2tzIHRvIG1lIHRoYXQgcHJlc2VydmVzIHRoZSBzcGlyaXQgb2YgdGhlCm9yaWdpbmFsIHRlc3Qu
IEFmdGVyIGRvaW5nIHN0cmVzcyB0ZXN0aW5nIHRoaXMgaXMgd2hhdCBJIGdvdDoKCi0gd2l0aCBr
dm10b29sLCA0Nyw3MDkgaXRlcmF0aW9ucywgMjcgdGltZXMgdGhlIHRlc3QgdGltZWQgb3V0IHdo
ZW4gd2FpdGluZyBmb3IKdGhlIGludGVycnVwdCBhZnRlciBJTlZBTEwuCi0gd2l0aCBxZW11LCAx
NSw1MTEgaXRlcmF0aW9ucywgMjU4IHRpbWVzIHRoZSB0ZXN0IHRpbWVkIG91dCB3aGVuIHdhaXRp
bmcgZm9yIHRoZQppbnRlcnJ1cHQgYWZ0ZXIgSU5WQUxMLCBqdXN0IGxpa2Ugd2l0aCBrdm10b29s
LgoKSnVkZ2luZyBmcm9tIHRoZSBmYWN0IHRoYXQgdGhlcmUgaXMgYW4gb3JkZXIgb2YgbWFnbml0
dWRlIGxlc3MgZmFpbHVyZXMgd2l0aAprdm10b29sIHRoYW4gd2l0aCBxZW11LCBJJ20gbGVhbmlu
ZyB0b3dhcmRzIHNvbWUgcmFuZG9tIHRpbWluZyBpc3N1ZS4gSSB3aWxsIHRyeQppbmNyZWFzaW5n
IHRoZSB0aW1lb3V0IGZvciB3YWl0X2Zvcl9pbnRlcnJ1cHRzKCkgYW5kIHNlZSBpZiB0aGUgcmVz
dWx0cyBpbXByb3ZlCm92ZXIgdGhlIHdlZWtlbmQuCgpUaGFua3MsCkFsZXgKPgo+Cj4gVGhhbmtz
LAo+IFplbmdodWkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
