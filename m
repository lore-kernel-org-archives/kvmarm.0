Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A380C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:32:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F17B60FDA
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F17B60FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9000F4A1A5;
	Tue, 10 Aug 2021 11:32:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C1cJy0oXkSQP; Tue, 10 Aug 2021 11:32:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C5140878;
	Tue, 10 Aug 2021 11:32:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5866840878
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:32:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YnbTpFGFxtjb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 11:32:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44F94086A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:32:03 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BEDCC60E97;
 Tue, 10 Aug 2021 15:32:02 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mDTjU-004675-NO; Tue, 10 Aug 2021 16:32:00 +0100
MIME-Version: 1.0
Date: Tue, 10 Aug 2021 16:32:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Define KVM_PHYS_SHIFT_MIN
In-Reply-To: <43c5ffa3-b3c5-9154-72b5-811eeb9ece8f@arm.com>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-6-git-send-email-anshuman.khandual@arm.com>
 <2dbeb2c329cfeb1ee9a7331683cdbc97@kernel.org>
 <43c5ffa3-b3c5-9154-72b5-811eeb9ece8f@arm.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <f6293361a98a6a9413643adeeb352f60@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

T24gMjAyMS0wOC0xMCAxNjoxOSwgQW5zaHVtYW4gS2hhbmR1YWwgd3JvdGU6Cj4gT24gOC8xMC8y
MSA2OjU5IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIDIwMjEtMDgtMTAgMDg6MDIsIEFu
c2h1bWFuIEtoYW5kdWFsIHdyb3RlOgo+Pj4gRHJvcCB0aGUgaGFyZCBjb2RlZCB2YWx1ZSBmb3Ig
dGhlIG1pbmltdW0gSVBBIHJhbmdlIGkuZSAzMiBiaXQuIAo+Pj4gSW5zdGVhZAo+Pj4gZGVmaW5l
IGEgbWFjcm8gS1ZNX1BIWVNfU0hJRlRfTUlOIHdoaWNoIGltcHJvdmVzIHRoZSBjb2RlIAo+Pj4g
cmVhZGFiaWxpdHkuCj4+PiAKPj4+IENjOiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+
Pj4gQ2M6IEphbWVzIE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPgo+Pj4gQ2M6IEFsZXhhbmRy
dSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4KPj4+IENjOiBTdXp1a2kgSyBQb3Vs
b3NlIDxzdXp1a2kucG91bG9zZUBhcm0uY29tPgo+Pj4gQ2M6IENhdGFsaW4gTWFyaW5hcyA8Y2F0
YWxpbi5tYXJpbmFzQGFybS5jb20+Cj4+PiBDYzogV2lsbCBEZWFjb24gPHdpbGxAa2VybmVsLm9y
Zz4KPj4+IENjOiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKPj4+IENjOiBr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cj4+PiBDYzogbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZwo+Pj4gU2lnbmVkLW9mZi1ieTogQW5zaHVtYW4gS2hhbmR1YWwgPGFuc2h1bWFuLmto
YW5kdWFsQGFybS5jb20+Cj4+PiAtLS0KPj4+IMKgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1f
bW11LmggfCAzICsrLQo+Pj4gwqBhcmNoL2FybTY0L2t2bS9yZXNldC5jwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfCAyICstCj4+PiDCoDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQo+Pj4gCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9r
dm1fbW11LmggCj4+PiBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX21tdS5oCj4+PiBpbmRl
eCBiNTJjNWM0YjlhM2QuLjcxNmY5OTk4MThkOSAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20va3ZtX21tdS5oCj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2
bV9tbXUuaAo+Pj4gQEAgLTE0MSw3ICsxNDEsOCBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHVu
c2lnbmVkIGxvbmcKPj4+IF9fa2Vybl9oeXBfdmEodW5zaWduZWQgbG9uZyB2KQo+Pj4gwqAgKiBX
ZSBjdXJyZW50bHkgc3VwcG9ydCB1c2luZyBhIFZNLXNwZWNpZmllZCBJUEEgc2l6ZS4gRm9yIGJh
Y2t3YXJkCj4+PiDCoCAqIGNvbXBhdGliaWxpdHksIHRoZSBkZWZhdWx0IElQQSBzaXplIGlzIGZp
eGVkIHRvIDQwYml0cy4KPj4+IMKgICovCj4+PiAtI2RlZmluZSBLVk1fUEhZU19TSElGVMKgwqDC
oCAoNDApCj4+PiArI2RlZmluZSBLVk1fUEhZU19TSElGVMKgwqDCoMKgwqDCoMKgICg0MCkKPj4+
ICsjZGVmaW5lIEtWTV9QSFlTX1NISUZUX01JTsKgwqDCoCAoMzIpCj4+PiAKPj4+IMKgI2RlZmlu
ZSBrdm1fcGh5c19zaGlmdChrdm0pwqDCoMKgwqDCoMKgwqAgVlRDUl9FTDJfSVBBKGt2bS0+YXJj
aC52dGNyKQo+Pj4gwqAjZGVmaW5lIGt2bV9waHlzX3NpemUoa3ZtKcKgwqDCoMKgwqDCoMKgIChf
QUMoMSwgVUxMKSA8PCAKPj4+IGt2bV9waHlzX3NoaWZ0KGt2bSkpCj4+PiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vcmVzZXQuYyBiL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKPj4+IGluZGV4
IGNiYTc4NzJkNjlhOC4uOGRjOGI0YjlkZTM3IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9r
dm0vcmVzZXQuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vcmVzZXQuYwo+Pj4gQEAgLTM2OSw3
ICszNjksNyBAQCBpbnQga3ZtX2FybV9zZXR1cF9zdGFnZTIoc3RydWN0IGt2bSAqa3ZtLCAKPj4+
IHVuc2lnbmVkCj4+PiBsb25nIHR5cGUpCj4+PiDCoMKgwqDCoCBwaHlzX3NoaWZ0ID0gS1ZNX1ZN
X1RZUEVfQVJNX0lQQV9TSVpFKHR5cGUpOwo+Pj4gwqDCoMKgwqAgaWYgKHBoeXNfc2hpZnQpIHsK
Pj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHBoeXNfc2hpZnQgPiBrdm1faXBhX2xpbWl0IHx8Cj4+
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwaHlzX3NoaWZ0IDwgMzIpCj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBwaHlzX3NoaWZ0IDwgS1ZNX1BIWVNfU0hJRlRfTUlOKQo+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+Pj4gwqDCoMKgwqAgfSBlbHNlIHsK
Pj4+IMKgwqDCoMKgwqDCoMKgwqAgcGh5c19zaGlmdCA9IEtWTV9QSFlTX1NISUZUOwo+PiAKPj4g
VGhpcyBpcyBub3QgYSBLVk0gcHJvcGVydHksIGJ1dCBhbiBhcmNoaXRlY3R1cmFsIG9uZS4gSWYg
eW91Cj4gCj4gQXJjaGl0ZWN0dXJhbCBwcm9wZXJ0eSB3aGljaCBzdWdnZXN0IHRoZSBtaW5pbXVt
IHBoeXNpY2FsIGFkZHJlc3Mgc2hpZnQKPiBzdXBwb3J0ZWQgb24gYSBwbGF0Zm9ybSwgYXMgaW5k
aWNhdGVkIHZpYSBJRF9BQTY0TU1GUjAuUEFSQU5HRSA9IDB4MCA/CgpUaGF0J3MgdGhlIG9uZS4K
CiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4u
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
