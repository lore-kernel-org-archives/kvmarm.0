Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580A9C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 12:19:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D644D206C3
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 12:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D644D206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9434B4E0;
	Thu, 25 Jun 2020 08:19:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JFjD8S6-7ufj; Thu, 25 Jun 2020 08:19:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 116F44B4D3;
	Thu, 25 Jun 2020 08:19:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15F204B4D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 08:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9aiA+gjbqKGN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 08:19:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A866D4B4D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 08:19:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A0751FB;
 Thu, 25 Jun 2020 05:19:18 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 073353F73C;
 Thu, 25 Jun 2020 05:19:15 -0700 (PDT)
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To: Marc Zyngier <maz@kernel.org>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
 <9c0044564885d3356f76b55f35426987@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d3804b25-4ce4-b263-c087-d8e563f939ed@arm.com>
Date: Thu, 25 Jun 2020 13:19:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9c0044564885d3356f76b55f35426987@kernel.org>
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

SGkgTWFyYywKCk9uIDYvMTYvMjAgNToxOCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIEFs
ZXhhbmRydSwKPiBbLi5dCj4+PiBbLi5dCj4+Pgo+Pj4gwqAvKioKPj4+IC0gKiBrdm1fYWxsb2Nf
c3RhZ2UyX3BnZCAtIGFsbG9jYXRlIGxldmVsLTEgdGFibGUgZm9yIHN0YWdlLTIgdHJhbnNsYXRp
b24uCj4+PiAtICogQGt2bTrCoMKgwqAgVGhlIEtWTSBzdHJ1Y3QgcG9pbnRlciBmb3IgdGhlIFZN
Lgo+Pj4gKyAqIGt2bV9pbml0X3N0YWdlMl9tbXUgLSBJbml0aWFsaXNlIGEgUzIgTU1VIHN0cnVj
cnVyZQo+Pj4gKyAqIEBrdm06wqDCoMKgIFRoZSBwb2ludGVyIHRvIHRoZSBLVk0gc3RydWN0dXJl
Cj4+PiArICogQG1tdTrCoMKgwqAgVGhlIHBvaW50ZXIgdG8gdGhlIHMyIE1NVSBzdHJ1Y3R1cmUK
Pj4+IMKgICoKPj4+IMKgICogQWxsb2NhdGVzIG9ubHkgdGhlIHN0YWdlLTIgSFcgUEdEIGxldmVs
IHRhYmxlKHMpIG9mIHNpemUgZGVmaW5lZCBieQo+Pj4gLSAqIHN0YWdlMl9wZ2Rfc2l6ZShrdm0p
Lgo+Pj4gKyAqIHN0YWdlMl9wZ2Rfc2l6ZShtbXUtPmt2bSkuCj4+PiDCoCAqCj4+PiDCoCAqIE5v
dGUgd2UgZG9uJ3QgbmVlZCBsb2NraW5nIGhlcmUgYXMgdGhpcyBpcyBvbmx5IGNhbGxlZCB3aGVu
IHRoZSBWTSBpcwo+Pj4gwqAgKiBjcmVhdGVkLCB3aGljaCBjYW4gb25seSBiZSBkb25lIG9uY2Uu
Cj4+PiDCoCAqLwo+Pj4gLWludCBrdm1fYWxsb2Nfc3RhZ2UyX3BnZChzdHJ1Y3Qga3ZtICprdm0p
Cj4+PiAraW50IGt2bV9pbml0X3N0YWdlMl9tbXUoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3Zt
X3MyX21tdSAqbW11KQo+Pj4gwqB7Cj4+PiDCoMKgwqDCoCBwaHlzX2FkZHJfdCBwZ2RfcGh5czsK
Pj4+IMKgwqDCoMKgIHBnZF90ICpwZ2Q7Cj4+PiArwqDCoMKgIGludCBjcHU7Cj4+Pgo+Pj4gLcKg
wqDCoCBpZiAoa3ZtLT5hcmNoLnBnZCAhPSBOVUxMKSB7Cj4+PiArwqDCoMKgIGlmIChtbXUtPnBn
ZCAhPSBOVUxMKSB7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9lcnIoImt2bV9hcmNoIGFscmVh
ZHkgaW5pdGlhbGl6ZWQ/XG4iKTsKPj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7
Cj4+PiDCoMKgwqDCoCB9Cj4+PiBAQCAtMTAyNCw4ICsxMDQwLDIwIEBAIGludCBrdm1fYWxsb2Nf
c3RhZ2UyX3BnZChzdHJ1Y3Qga3ZtICprdm0pCj4+PiDCoMKgwqDCoCBpZiAoV0FSTl9PTihwZ2Rf
cGh5cyAmIH5rdm1fdnR0YnJfYmFkZHJfbWFzayhrdm0pKSkKPj4+IMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIC1FSU5WQUw7Cj4+Cj4+IFdlIGRvbid0IGZyZWUgdGhlIHBnZCBpZiB3ZSBnZXQgdGhl
IGVycm9yIGFib3ZlLCBidXQgd2UgZG8gZnJlZSBpdCBiZWxvdywgaWYKPj4gYWxsb2NhdGluZyBs
YXN0X3ZjcHVfcmFuIGZhaWxzLiBTaG91bGRuJ3Qgd2UgZnJlZSBpdCBpbiBib3RoIGNhc2VzPwo+
Cj4gV29ydGggaW52ZXN0aWdhdGluZy4gVGhpcyBjb2RlIGdldHMgbWFqb3JseSByZXZhbXBlZCBp
biB0aGUgTlYgc2VyaWVzLCBzbyBpdCBpcwo+IGxpa2VseSB0aGF0IEkgbWlzc2VkIHNvbWV0aGlu
ZyBpbiB0aGUgbWlkZGxlLgoKWW91IGRpZG4ndCBtaXNzIGFueXRoaW5nLCBJIGNoZWNrZWQgYW5k
IGl0J3MgdGhlIHNhbWUgaW4gdGhlIHVwc3RyZWFtIHZlcnNpb24gb2YgS1ZNLgoKa3ZtX2FyY2hf
aW5pdF92bSgpIHJldHVybnMgd2l0aCBhbiBlcnJvciBpZiB0aGlzIGZ1bmN0aW9ucyBmYWlscywg
c28gaXQncyB1cCB0bwp0aGUgZnVuY3Rpb24gdG8gZG8gdGhlIGNsZWFuIHVwLiBrdm1fYWxsb2Nf
cGFnZXNfZXhhY3QoKSByZXR1cm5zIE5VTEwgb24gZXJyb3IsIHNvCmF0IHRoaXMgcG9pbnQgd2Ug
aGF2ZSBhIHZhbGlkIGFsbG9jYXRpb24gb2YgcGh5c2ljYWwgY29udGlndW91cyBwYWdlcy4gRmFp
bGluZyB0bwpjcmVhdGUgYSBWTSBpcyBub3QgYSBmYXRhbCBlcnJvciBmb3IgdGhlIHN5c3RlbSwg
c28gSSdtIHRoaW5raW5nIHRoYXQgbWF5YmUgd2UKc2hvdWxkIGZyZWUgdGhvc2UgcGFnZXMgZm9y
IHRoZSByZXN0IG9mIHRoZSBzeXN0ZW0gdG8gdXNlLiBIb3dldmVyLCB0aGlzIGlzIGEKbWlub3Ig
aXNzdWUsIGFuZCB0aGUgcGF0Y2ggaXNuJ3Qgc3VwcG9zZWQgdG8gbWFrZSBhbnkgZnVuY3Rpb25h
bCBjaGFuZ2VzLCBzbyBpdApjYW4gYmUgcHJvYmFibHkgYmUgbGVmdCBmb3IgYW5vdGhlciBwYXRj
aCBhbmQgbm90IGFkZCBtb3JlIHRvIGFuIGFscmVhZHkgYmlnIHNlcmllcy4KClRoYW5rcywKQWxl
eApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
