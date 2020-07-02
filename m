Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3C6C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:32:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FDE5208B8
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FDE5208B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 918AD4B193;
	Thu,  2 Jul 2020 11:32:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jcdnA-lKVFHo; Thu,  2 Jul 2020 11:32:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6BA4B18B;
	Thu,  2 Jul 2020 11:32:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602F74B18B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:32:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNJ5f6dWR4Rm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 11:32:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DAF4B160
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:32:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B950E31B;
 Thu,  2 Jul 2020 08:32:25 -0700 (PDT)
Received: from [10.37.12.95] (unknown [10.37.12.95])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 686573F68F;
 Thu,  2 Jul 2020 08:32:24 -0700 (PDT)
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
To: maz@misterjones.org
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
 <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
Date: Thu, 2 Jul 2020 16:37:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

SGkgTWFyYwoKT24gMDcvMDEvMjAyMCAwNDo0MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9u
IDIwMjAtMDctMDEgMTU6MjAsIFN1enVraSBLIFBvdWxvc2Ugd3JvdGU6Cj4+IFdoZW4gdGhlIGhv
c3QgZG9lc24ndCBzdXBwb3J0IDMyYml0IGd1ZXN0cywgdGhlIGt2bXRvb2wgZmFpbHMKPj4gd2l0
aG91dCBhIHByb3BlciBtZXNzYWdlIG9uIHdoYXQgaXMgd3JvbmcuIGkuZSwKPj4KPj4gwqAkIGxr
dm0gcnVuIC1jIDEgSW1hZ2UgLS1hYXJjaDMyCj4+IMKgICMgbGt2bSBydW4gLWsgSW1hZ2UgLW0g
MjU2IC1jIDEgLS1uYW1lIGd1ZXN0LTEwNTYxOAo+PiDCoCBGYXRhbDogVW5hYmxlIHRvIGluaXRp
YWxpc2UgdmNwdQo+Pgo+PiBHaXZlbiB0aGF0IHRoZXJlIGlzIG5vIG90aGVyIGVhc3kgd2F5IHRv
IGNoZWNrIGlmIHRoZSBob3N0IHN1cHBvcnRzIDMyYml0Cj4+IGd1ZXN0cywgaXQgaXMgYWx3YXlz
IGdvb2QgdG8gcmVwb3J0IHRoaXMgYnkgY2hlY2tpbmcgdGhlIGNhcGFiaWxpdHksIAo+PiByYXRo
ZXIKPj4gdGhhbiBsZWF2aW5nIHRoZSB1c2VycyB0byBodW50IHRoaXMgZG93biBieSBsb29raW5n
IGF0IHRoZSBjb2RlIQo+Pgo+PiBBZnRlciB0aGlzIHBhdGNoOgo+Pgo+PiDCoCQgbGt2bSBydW4g
LWMgMSBJbWFnZSAtLWFhcmNoMzIKPj4gwqAgIyBsa3ZtIHJ1biAtayBJbWFnZSAtbSAyNTYgLWMg
MSAtLW5hbWUgZ3Vlc3QtMTA1Njk1Cj4+IMKgIEZhdGFsOiAzMmJpdCBndWVzdHMgYXJlIG5vdCBz
dXBwb3J0ZWQKPiAKPiBGYW5jeSEKPiAKPj4KPj4gQ2M6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5l
bC5vcmc+Cj4+IFJlcG9ydGVkLWJ5OiBTYW1pIE11amF3YXIgPHNhbWkubXVqYXdhckBhcm0uY29t
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBTdXp1a2kgSyBQb3Vsb3NlIDxzdXp1a2kucG91bG9zZUBhcm0u
Y29tPgo+PiAtLS0KPj4gwqBhcm0va3ZtLWNwdS5jIHwgNCArKysrCj4+IMKgMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJtL2t2bS1jcHUuYyBiL2Fy
bS9rdm0tY3B1LmMKPj4gaW5kZXggNTU0NDE0Zi4uMmFjZWNhZSAxMDA2NDQKPj4gLS0tIGEvYXJt
L2t2bS1jcHUuYwo+PiArKysgYi9hcm0va3ZtLWNwdS5jCj4+IEBAIC00Niw2ICs0NiwxMCBAQCBz
dHJ1Y3Qga3ZtX2NwdSAqa3ZtX2NwdV9fYXJjaF9pbml0KHN0cnVjdCBrdm0gKmt2bSwKPj4gdW5z
aWduZWQgbG9uZyBjcHVfaWQpCj4+IMKgwqDCoMKgwqDCoMKgwqAgLmZlYXR1cmVzID0gQVJNX1ZD
UFVfRkVBVFVSRV9GTEFHUyhrdm0sIGNwdV9pZCkKPj4gwqDCoMKgwqAgfTsKPj4KPj4gK8KgwqDC
oCBpZiAoa3ZtLT5jZmcuYXJjaC5hYXJjaDMyX2d1ZXN0ICYmCj4+ICvCoMKgwqDCoMKgwqDCoCAh
a3ZtX19zdXBwb3J0c19leHRlbnNpb24oa3ZtLCBLVk1fQ0FQX0FSTV9FTDFfMzJCSVQpKQo+IAo+
IENhbiB5b3UgcGxlYXNlIGNoZWNrIHRoYXQgdGhpcyBzdGlsbCBjb21waWxlcyBmb3IgMzJiaXQg
aG9zdD8KClllcywgaXQgZG9lcy4gSSBoYXZlIGJ1aWx0IHRoaXMgb24gYW4gYXJtMzIgcm9vdGZz
IHdpdGggbWFrZSBBUkNIPWFybS4KVGhlIGt2bS0+Y2ZnLmFyY2ggaXMgY29tbW9uIGFjcm9zcyBh
cm0vYXJtNjQgYW5kIGlzIGRlZmluZWQgaGVyZSA6Cgphcm0vaW5jbHVkZS9hcm0tY29tbW9uL2t2
bS1jb25maWctYXJjaC5oCgpBbmQgdGhlIGFhcmNoMzIgY29tbWFuZCBsaW5lIG9wdGlvbiBpcyBv
bmx5IGF2YWlsYWJsZSBvbiBhYXJjaDY0IGhvc3QuClNvIHRoaXMgaXMgc2FmZSBvbiBhbiBhcm0z
MiBob3N0LgoKPiAKPj4gK8KgwqDCoMKgwqDCoMKgIGRpZSgiMzJiaXQgZ3Vlc3RzIGFyZSBub3Qg
c3VwcG9ydGVkXG4iKTsKPj4gKwo+PiDCoMKgwqDCoCB2Y3B1ID0gY2FsbG9jKDEsIHNpemVvZihz
dHJ1Y3Qga3ZtX2NwdSkpOwo+PiDCoMKgwqDCoCBpZiAoIXZjcHUpCj4+IMKgwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIE5VTEw7Cj4gCj4gV2l0aCB0aGUgYWJvdmUgZGV0YWlsIGNoZWNrZWQsCj4gCj4g
QWNrZWQtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+CgpUaGFua3MKU3V6dWtpCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
