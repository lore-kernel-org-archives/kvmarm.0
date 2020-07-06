Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0553FC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 15:49:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8637320722
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 15:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8637320722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E330A4B3B1;
	Mon,  6 Jul 2020 11:49:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U++VBE-QuJTT; Mon,  6 Jul 2020 11:49:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2594B3F0;
	Mon,  6 Jul 2020 11:49:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 849574B3F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 11:49:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0sV7jPovVNx2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 11:49:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F89E4B3B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 11:49:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EC64C0A;
 Mon,  6 Jul 2020 08:49:11 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C2183F68F;
 Mon,  6 Jul 2020 08:49:09 -0700 (PDT)
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To: Marc Zyngier <maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
 <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
 <b3f34d53dfe8bc3c2b0838187fe12538@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7fae512d-a4a4-f66c-92c7-d3d3f7ebd488@arm.com>
Date: Mon, 6 Jul 2020 16:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b3f34d53dfe8bc3c2b0838187fe12538@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
 Dave Martin <Dave.Martin@arm.com>
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

SGkgTWFyYywKCk9uIDcvNi8yMCAxOjE3IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MC0wNi0yNSAxMzoxOSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gSGkgTWFyYywKPj4KPj4g
T24gNi8xNi8yMCA1OjE4IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBIaSBBbGV4YW5kcnUs
Cj4+PiBbLi5dCj4+Pj4+IFsuLl0KPj4+Pj4KPj4+Pj4gwqAvKioKPj4+Pj4gLSAqIGt2bV9hbGxv
Y19zdGFnZTJfcGdkIC0gYWxsb2NhdGUgbGV2ZWwtMSB0YWJsZSBmb3Igc3RhZ2UtMiB0cmFuc2xh
dGlvbi4KPj4+Pj4gLSAqIEBrdm06wqDCoMKgIFRoZSBLVk0gc3RydWN0IHBvaW50ZXIgZm9yIHRo
ZSBWTS4KPj4+Pj4gKyAqIGt2bV9pbml0X3N0YWdlMl9tbXUgLSBJbml0aWFsaXNlIGEgUzIgTU1V
IHN0cnVjcnVyZQo+Pj4+PiArICogQGt2bTrCoMKgwqAgVGhlIHBvaW50ZXIgdG8gdGhlIEtWTSBz
dHJ1Y3R1cmUKPj4+Pj4gKyAqIEBtbXU6wqDCoMKgIFRoZSBwb2ludGVyIHRvIHRoZSBzMiBNTVUg
c3RydWN0dXJlCj4+Pj4+IMKgICoKPj4+Pj4gwqAgKiBBbGxvY2F0ZXMgb25seSB0aGUgc3RhZ2Ut
MiBIVyBQR0QgbGV2ZWwgdGFibGUocykgb2Ygc2l6ZSBkZWZpbmVkIGJ5Cj4+Pj4+IC0gKiBzdGFn
ZTJfcGdkX3NpemUoa3ZtKS4KPj4+Pj4gKyAqIHN0YWdlMl9wZ2Rfc2l6ZShtbXUtPmt2bSkuCj4+
Pj4+IMKgICoKPj4+Pj4gwqAgKiBOb3RlIHdlIGRvbid0IG5lZWQgbG9ja2luZyBoZXJlIGFzIHRo
aXMgaXMgb25seSBjYWxsZWQgd2hlbiB0aGUgVk0gaXMKPj4+Pj4gwqAgKiBjcmVhdGVkLCB3aGlj
aCBjYW4gb25seSBiZSBkb25lIG9uY2UuCj4+Pj4+IMKgICovCj4+Pj4+IC1pbnQga3ZtX2FsbG9j
X3N0YWdlMl9wZ2Qoc3RydWN0IGt2bSAqa3ZtKQo+Pj4+PiAraW50IGt2bV9pbml0X3N0YWdlMl9t
bXUoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3MyX21tdSAqbW11KQo+Pj4+PiDCoHsKPj4+
Pj4gwqDCoMKgwqAgcGh5c19hZGRyX3QgcGdkX3BoeXM7Cj4+Pj4+IMKgwqDCoMKgIHBnZF90ICpw
Z2Q7Cj4+Pj4+ICvCoMKgwqAgaW50IGNwdTsKPj4+Pj4KPj4+Pj4gLcKgwqDCoCBpZiAoa3ZtLT5h
cmNoLnBnZCAhPSBOVUxMKSB7Cj4+Pj4+ICvCoMKgwqAgaWYgKG1tdS0+cGdkICE9IE5VTEwpIHsK
Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBrdm1fZXJyKCJrdm1fYXJjaCBhbHJlYWR5IGluaXRpYWxp
emVkP1xuIik7Cj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4+IMKg
wqDCoMKgIH0KPj4+Pj4gQEAgLTEwMjQsOCArMTA0MCwyMCBAQCBpbnQga3ZtX2FsbG9jX3N0YWdl
Ml9wZ2Qoc3RydWN0IGt2bSAqa3ZtKQo+Pj4+PiDCoMKgwqDCoCBpZiAoV0FSTl9PTihwZ2RfcGh5
cyAmIH5rdm1fdnR0YnJfYmFkZHJfbWFzayhrdm0pKSkKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gLUVJTlZBTDsKPj4+Pgo+Pj4+IFdlIGRvbid0IGZyZWUgdGhlIHBnZCBpZiB3ZSBnZXQg
dGhlIGVycm9yIGFib3ZlLCBidXQgd2UgZG8gZnJlZSBpdCBiZWxvdywgaWYKPj4+PiBhbGxvY2F0
aW5nIGxhc3RfdmNwdV9yYW4gZmFpbHMuIFNob3VsZG4ndCB3ZSBmcmVlIGl0IGluIGJvdGggY2Fz
ZXM/Cj4+Pgo+Pj4gV29ydGggaW52ZXN0aWdhdGluZy4gVGhpcyBjb2RlIGdldHMgbWFqb3JseSBy
ZXZhbXBlZCBpbiB0aGUgTlYgc2VyaWVzLCBzbyBpdCBpcwo+Pj4gbGlrZWx5IHRoYXQgSSBtaXNz
ZWQgc29tZXRoaW5nIGluIHRoZSBtaWRkbGUuCj4+Cj4+IFlvdSBkaWRuJ3QgbWlzcyBhbnl0aGlu
ZywgSSBjaGVja2VkIGFuZCBpdCdzIHRoZSBzYW1lIGluIHRoZSB1cHN0cmVhbQo+PiB2ZXJzaW9u
IG9mIEtWTS4KPj4KPj4ga3ZtX2FyY2hfaW5pdF92bSgpIHJldHVybnMgd2l0aCBhbiBlcnJvciBp
ZiB0aGlzIGZ1bmN0aW9ucyBmYWlscywgc28gaXQncyB1cCB0bwo+PiB0aGUgZnVuY3Rpb24gdG8g
ZG8gdGhlIGNsZWFuIHVwLiBrdm1fYWxsb2NfcGFnZXNfZXhhY3QoKSByZXR1cm5zIE5VTEwKPj4g
b24gZXJyb3IsIHNvCj4+IGF0IHRoaXMgcG9pbnQgd2UgaGF2ZSBhIHZhbGlkIGFsbG9jYXRpb24g
b2YgcGh5c2ljYWwgY29udGlndW91cyBwYWdlcy4KPj4gRmFpbGluZyB0bwo+PiBjcmVhdGUgYSBW
TSBpcyBub3QgYSBmYXRhbCBlcnJvciBmb3IgdGhlIHN5c3RlbSwgc28gSSdtIHRoaW5raW5nIHRo
YXQgbWF5YmUgd2UKPj4gc2hvdWxkIGZyZWUgdGhvc2UgcGFnZXMgZm9yIHRoZSByZXN0IG9mIHRo
ZSBzeXN0ZW0gdG8gdXNlLiBIb3dldmVyLCB0aGlzIGlzIGEKPj4gbWlub3IgaXNzdWUsIGFuZCB0
aGUgcGF0Y2ggaXNuJ3Qgc3VwcG9zZWQgdG8gbWFrZSBhbnkgZnVuY3Rpb25hbCBjaGFuZ2VzLCBz
byBpdAo+PiBjYW4gYmUgcHJvYmFibHkgYmUgbGVmdCBmb3IgYW5vdGhlciBwYXRjaCBhbmQgbm90
IGFkZCBtb3JlIHRvIGFuCj4+IGFscmVhZHkgYmlnIHNlcmllcy4KPgo+IENvb2wuIFdpbGwgeW91
IGJlIHBvc3Rpbmcgc3VjaCBwYXRjaD8KCkkgd2FzIGNvbnNpZGVyaW5nIG9uZSwgYnV0IHRoZW4g
SSByZWFsaXplZCB0aGVyZSdzIHNvbWV0aGluZyB0aGF0IEkgc3RpbGwgZG9uJ3QKdW5kZXJzdGFu
ZC4KCmFsbG9jX3BhZ2VzX2V4YWN0KCkgYWxsb2NhdGVzIDJeb3JkZXIgcGFnZXMgKHdoZXJlIDJe
b3JkZXIgcGFnZXMgPj0Kc3RhZ2UyX3BnZF9zaXplKCkpIHZpYSBfX2dldF9mcmVlX3BhZ2VzIC0+
IGFsbG9jX3BhZ2VzKCksIHRoZW4gaXQgZnJlZXMgdGhlCnVubmVlZGVkIHBhZ2VzIGF0IHRoZSAq
ZW5kKiBvZiB0aGUgYWxsb2NhdGlvbiBpbiBtYWtlX2FsbG9jX2V4YWN0KCkuIFNvIHRoZQpiZWdp
bm5pbmcgb2YgdGhlIGFsbG9jYXRlZCBwaHlzaWNhbCBhcmVhIHJlbWFpbnMgYWxpZ25lZCB0byAy
Xm9yZGVyIHBhZ2VzLCBhbmQKaW1wbGljaXRseSB0byBzdGFnZTJfcGdkX3NpemUoKS4KCkJ1dCBu
b3cgSSBjYW4ndCBmaWd1cmUgb3V0IHdoeSBrdm1fdnR0YnJfYmFkZHJfbWFzaygpIGlzbid0IHNp
bXBseSBkZWZpbmVkIGFzCn5zdGFnZTJfcGdkX3NpemUoKS4gSXMgaXQgcG9zc2libGUgZm9yIGt2
bV92dHRicl9iYWRkcl9tYXNrKCkgdG8gcmV0dXJuIGFuCmFsaWdubWVudCBsYXJnZXIgdGhhbiB0
aGUgc2l6ZSBvZiB0aGUgdGFibGU/IEkgY2FuJ3Qgc2VlbSB0byBmaW5kIGFueXRoaW5nIHRvIHRo
YXQKZWZmZWN0IGluIEFSTSBhcm0gKGJ1dCB0aGF0IGRvZXNuJ3QgbWVhbiB0aGF0IEkgZGlkbid0
IG1pc3MgYW55dGhpbmcpLgoKVGhhbmtzLApBbGV4Cl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
