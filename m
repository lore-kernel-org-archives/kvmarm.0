Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834C9C55185
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 14:10:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26FA62084D
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 14:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26FA62084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A15AA4B174;
	Wed, 22 Apr 2020 10:10:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ov+OkBI1lxN5; Wed, 22 Apr 2020 10:10:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A3524B0BF;
	Wed, 22 Apr 2020 10:10:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5DAB4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 10:10:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yikrovxMLz+i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 10:10:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64FFC4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 10:10:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D03EE30E;
 Wed, 22 Apr 2020 07:10:10 -0700 (PDT)
Received: from [10.37.12.172] (unknown [10.37.12.172])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EE293F68F;
 Wed, 22 Apr 2020 07:10:07 -0700 (PDT)
Subject: Re: [PATCH 01/26] KVM: arm64: Check advertised Stage-2 page size
 capability
To: maz@kernel.org
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-2-maz@kernel.org>
 <32cc9a60-1b47-f3f7-d18d-d39db397ea55@arm.com>
 <06c3b2c9b23beeeb224d263077299039@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <e6373f9c-8e6a-26c6-f4a8-d783a4349783@arm.com>
Date: Wed, 22 Apr 2020 15:14:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <06c3b2c9b23beeeb224d263077299039@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, gcherian@marvell.com, prime.zeng@hisilicon.com,
 catalin.marinas@arm.com, dave.martin@arm.com,
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

T24gMDQvMjIvMjAyMCAwMzowNyBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN1enVraSwK
PiAKPiBPbiAyMDIwLTA0LTIyIDE0OjQwLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+PiBIaSBN
YXJjLAo+Pgo+PiBPbiAwNC8yMi8yMDIwIDAxOjAwIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+
PiBXaXRoIEFSTXY4LjUtR1RHLCB0aGUgaGFyZHdhcmUgKG9yIG1vcmUgbGlrZWx5IGEgaHlwZXJ2
aXNvcikgY2FuCj4+PiBhZHZlcnRpc2UgdGhlIHN1cHBvcnRlZCBTdGFnZS0yIHBhZ2Ugc2l6ZXMu
Cj4+Pgo+Pj4gTGV0J3MgY2hlY2sgdGhpcyBhdCBib290IHRpbWUuCj4+Pgo+Pj4gU2lnbmVkLW9m
Zi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+IC0tLQo+Pj4gwqAgYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHzCoCAyICstCj4+PiDCoCBhcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL3N5c3JlZy5owqDCoCB8wqAgMyArKysKPj4+IMKgIGFyY2gvYXJtNjQva2VybmVs
L2NwdWZlYXR1cmUuY8KgwqDCoCB8wqAgOCArKysrKysrCj4+PiDCoCBhcmNoL2FybTY0L2t2bS9y
ZXNldC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDQwICsrKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0KPj4+IMKgIHZpcnQva3ZtL2FybS9hcm0uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8wqAgNCArLS0tCj4+PiDCoCA1IGZpbGVzIGNoYW5nZWQsIDUwIGluc2VydGlvbnMo
KyksIDcgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaCAKPj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
Cj4+PiBpbmRleCAzMmM4YTY3NWU1YTRhLi43ZGQ4ZmVmYTZhZWNkIDEwMDY0NAo+Pj4gLS0tIGEv
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4+PiArKysgYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4+IEBAIC02NzAsNyArNjcwLDcgQEAgc3RhdGljIGlubGlu
ZSBpbnQga3ZtX2FybV9oYXZlX3NzYmQodm9pZCkKPj4+IMKgIHZvaWQga3ZtX3ZjcHVfbG9hZF9z
eXNyZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4+PiDCoCB2b2lkIGt2bV92Y3B1X3B1dF9z
eXNyZWdzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Cj4+PiDCoCAtdm9pZCBrdm1fc2V0X2lwYV9s
aW1pdCh2b2lkKTsKPj4+ICtpbnQga3ZtX3NldF9pcGFfbGltaXQodm9pZCk7Cj4+PiDCoMKgwqAg
I2RlZmluZSBfX0tWTV9IQVZFX0FSQ0hfVk1fQUxMT0MKPj4+IMKgIHN0cnVjdCBrdm0gKmt2bV9h
cmNoX2FsbG9jX3ZtKHZvaWQpOwo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vc3lzcmVnLmggCj4+PiBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgKPj4+IGlu
ZGV4IGViYzYyMjQzMjgzMTguLjVkMTBjOTE0OGU4NDQgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3N5c3JlZy5oCj4+PiBAQCAtNjg2LDYgKzY4Niw5IEBACj4+PiDCoCAjZGVmaW5lIElEX0FBNjRa
RlIwX1NWRVZFUl9TVkUywqDCoMKgwqDCoMKgwqAgMHgxCj4+PiDCoMKgwqAgLyogaWRfYWE2NG1t
ZnIwICovCj4+PiArI2RlZmluZSBJRF9BQTY0TU1GUjBfVEdSQU40XzJfU0hJRlTCoMKgwqAgNDAK
Pj4+ICsjZGVmaW5lIElEX0FBNjRNTUZSMF9UR1JBTjY0XzJfU0hJRlTCoMKgwqAgMzYKPj4+ICsj
ZGVmaW5lIElEX0FBNjRNTUZSMF9UR1JBTjE2XzJfU0hJRlTCoMKgwqAgMzIKPj4+IMKgICNkZWZp
bmUgSURfQUE2NE1NRlIwX1RHUkFONF9TSElGVMKgwqDCoCAyOAo+Pj4gwqAgI2RlZmluZSBJRF9B
QTY0TU1GUjBfVEdSQU42NF9TSElGVMKgwqDCoCAyNAo+Pj4gwqAgI2RlZmluZSBJRF9BQTY0TU1G
UjBfVEdSQU4xNl9TSElGVMKgwqDCoCAyMAo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2Vy
bmVsL2NwdWZlYXR1cmUuYyAKPj4+IGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+
PiBpbmRleCA5ZmFjNzQ1YWE3YmIyLi45ODkyYTg0NWQwNmM5IDEwMDY0NAo+Pj4gLS0tIGEvYXJj
aC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+PiArKysgYi9hcmNoL2FybTY0L2tlcm5lbC9j
cHVmZWF0dXJlLmMKPj4+IEBAIC0yMDgsNiArMjA4LDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
YXJtNjRfZnRyX2JpdHMgCj4+PiBmdHJfaWRfYWE2NHpmcjBbXSA9IHsKPj4+IMKgIH07Cj4+PiDC
oMKgwqAgc3RhdGljIGNvbnN0IHN0cnVjdCBhcm02NF9mdHJfYml0cyBmdHJfaWRfYWE2NG1tZnIw
W10gPSB7Cj4+PiArwqDCoMKgIC8qCj4+PiArwqDCoMKgwqAgKiBQYWdlIHNpemUgbm90IGJlaW5n
IHN1cHBvcnRlZCBhdCBTdGFnZS0yIGFyZSBub3QgZmF0YWwuIFlvdQo+Pj4gK8KgwqDCoMKgICog
anVzdCBnaXZlIHVwIEtWTSBpZiBQQUdFX1NJWkUgaXNuJ3Qgc3VwcG9ydGVkIHRoZXJlLiBHbyBm
aXgKPj4+ICvCoMKgwqDCoCAqIHlvdXIgZmF2b3VyaXRlIG5lc3RpbmcgaHlwZXJ2aXNvci4KPj4+
ICvCoMKgwqDCoCAqLwo+Pj4gK8KgwqDCoCBBUk02NF9GVFJfQklUUyhGVFJfSElEREVOLCBGVFJf
Tk9OU1RSSUNULCBGVFJfRVhBQ1QsIAo+Pj4gSURfQUE2NE1NRlIwX1RHUkFONF8yX1NISUZULCA0
LCAxKSwKPj4+ICvCoMKgwqAgQVJNNjRfRlRSX0JJVFMoRlRSX0hJRERFTiwgRlRSX05PTlNUUklD
VCwgRlRSX0VYQUNULCAKPj4+IElEX0FBNjRNTUZSMF9UR1JBTjY0XzJfU0hJRlQsIDQsIDEpLAo+
Pj4gK8KgwqDCoCBBUk02NF9GVFJfQklUUyhGVFJfSElEREVOLCBGVFJfTk9OU1RSSUNULCBGVFJf
RVhBQ1QsIAo+Pj4gSURfQUE2NE1NRlIwX1RHUkFOMTZfMl9TSElGVCwgNCwgMSksCj4+Cj4+IE9u
ZSBtaW5vciBpc3N1ZSB3aXRoIHRoaXMgaXMsIGlmIHdlIGdldCBhIHN5c3RlbSB3aXRoIGNwdXMg
aGF2aW5nIHZhbHVlcwo+PiAwIGFuZCAyIChib3RoIG9mIHdoaWNoIGluZGljYXRlcyB0aGUgc3Rh
Z2UtMiBzdXBwb3J0KSwgd2UgbWlnaHQgcmVzZXQKPj4gdGhlIHZhbHVlIHRvIDEgZm9yIHRoZSBm
ZWF0dXJlIGluZGljYXRpbmcsIHdlIGRvbid0IHN1cHBvcnQgYW5kIGJsb2NrCj4+IEtWTS4gQnV0
LCB3ZSBjYW4gYmxhbWUgdGhlIG5lc3RpbmcgaHlwZXJ2aXNvciBmb3Igbm90IGVtdWxhdGluZyB0
aGlzIHRvCj4+ICgyKS4gRG8gd2UgbmVlZCBhIGNvbW1lbnQgdG8gbWFrZSB0aGlzIGV4cGxpY2l0
IGhlcmUgPwo+IAo+IFN1cmUuIEhvdyBhYm91dCBzb21ldGhpbmcgbGlrZToKPiAKPiAiVGhlcmUg
aXMgYSBzbWFsbCBjb3JuZXIgY2FzZSB3aGVyZSB0aGUgaHlwZXJ2aXNvciBjb3VsZCBleHBsaWNp
dGx5IAo+IGFkdmVydGlzZQo+ICDCoGEgZ2l2ZW4gZ3JhbnVsZSBzaXplIGF0IFN0YWdlLTIgKHZh
bHVlIDIpIG9uIHNvbWUgdkNQVXMsIGFuZCB1c2UgdGhlIAo+IGZhbGxiYWNrCj4gIMKgdG8gU3Rh
Z2UtMSAodmFsdWUgMCkgZm9yIG90aGVyIHZDUFVzLiBBbHRob3VnaCB0aGlzIGlzIG5vdCBmb3Ji
aWRkZW4gCj4gYnkgdGhlCj4gIMKgYXJjaGl0ZWN0dXJlLCBpdCBpbmRpY2F0ZXMgdGhhdCB0aGUg
aHlwZXJ2aXNvciBpcyBiZWluZyBzaWxseSAob3IgYnVnZ3kpLgo+ICDCoFdlIG1ha2Ugbm8gZWZm
b3J0IHRvIGNvcGUgd2l0aCB0aGlzIGFuZCBwcmV0ZW5kIHRoYXQgaWYgdGhlc2UgZmllbGRzIGFy
ZQo+ICDCoGluY29uc2lzdGVudCBhY3Jvc3MgdkNQVXMsIHRoZW4gaXQgaXNuJ3Qgd29ydGggdHJ5
aW5nIHRvIGJyaW5nIEtWTSB1cC4iCj4gCgpMb29rcyBmaW5lIHRvIG1lLgoKUmV2aWV3ZWQtYnk6
IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+Cl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
