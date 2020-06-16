Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB025C433E1
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 15:58:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67C3721532
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 15:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C3721532
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7494B134;
	Tue, 16 Jun 2020 11:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pMSR1Jk3xeiA; Tue, 16 Jun 2020 11:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DEBC4B11F;
	Tue, 16 Jun 2020 11:58:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 858E54B11F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 11:58:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Vwb+xHA9VeU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 11:58:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9E6A4B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 11:58:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70E8A1F1;
 Tue, 16 Jun 2020 08:58:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A36E3F73C;
 Tue, 16 Jun 2020 08:58:29 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
Message-ID: <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
Date: Tue, 16 Jun 2020 16:59:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615132719.1932408-2-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

SGksCgpJTU8sIHRoaXMgcGF0Y2ggZG9lcyB0d28gZGlmZmVyZW50IHRoaW5nczogYWRkcyBhIG5l
dyBzdHJ1Y3R1cmUsIGt2bV9zMl9tbXUsIGFuZApjb252ZXJ0cyB0aGUgbWVtb3J5IG1hbmFnZW1l
bnQgY29kZSB0byB1c2UgdGhlIDQgbGV2ZWwgcGFnZSB0YWJsZSBBUEkuIEkgcmVhbGl6ZQppdCdz
IHBhaW5mdWwgdG8gY29udmVydCB0aGUgTU1VIGNvZGUgdG8gdXNlIHRoZSBwNGQgZnVuY3Rpb25z
LCBhbmQgdGhlbiBtb2RpZnkKZXZlcnl0aGluZyB0byB1c2Uga3ZtX3MyX21tdSBpbiBhIHNlcGFy
YXRlIHBhdGNoLCBidXQgSSBiZWxpZXZlIHNwbGl0dGluZyBpdCBpbnRvCjIgd291bGQgYmUgYmV0
dGVyIGluIHRoZSBsb25nIHJ1bi4gVGhlIHJlc3VsdGluZyBwYXRjaGVzIHdpbGwgYmUgc21hbGxl
ciBhbmQgYm90aAp3aWxsIGhhdmUgYSBiZXR0ZXIgY2hhbmNlIG9mIGJlaW5nIHJldmlld2VkIGJ5
IHRoZSByaWdodCBwZW9wbGUuCgpFaXRoZXIgd2F5LCB0aGVyZSB3ZXJlIHN0aWxsIHNvbWUgc3Vn
Z2VzdGlvbnMgbGVmdCBvdmVyIGZyb20gdjEsIEkgZG9uJ3Qga25vdyBpZgp0aGV5IHdlcmUgd2Vy
ZSB0b28gbWlub3Ivc3ViamVjdGl2ZSB0byBpbXBsZW1lbnQsIG9yIHRoZXkgd2VyZSBvdmVybG9v
a2VkLiBJJ2xsCnJlLXBvc3QgdGhlbSBoZXJlIGFuZCBJJ2xsIHRyeSB0byByZXZpZXcgdGhlIHBh
dGNoIGFnYWluIG9uY2UgSSBmaWd1cmUgb3V0IGhvdyB0aGUKcDRkIGNoYW5nZXMgZml0IGluLgoK
T24gNi8xNS8yMCAyOjI3IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gRnJvbTogQ2hyaXN0b2Zm
ZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBhcm0uY29tPgo+Cj4gQXMgd2UgYXJlIGFib3V0IHRv
IHJldXNlIG91ciBzdGFnZSAyIHBhZ2UgdGFibGUgbWFuaXB1bGF0aW9uIGNvZGUgZm9yCj4gc2hh
ZG93IHN0YWdlIDIgcGFnZSB0YWJsZXMgaW4gdGhlIGNvbnRleHQgb2YgbmVzdGVkIHZpcnR1YWxp
emF0aW9uLCB3ZQo+IGFyZSBnb2luZyB0byBtYW5hZ2UgbXVsdGlwbGUgc3RhZ2UgMiBwYWdlIHRh
YmxlcyBmb3IgYSBzaW5nbGUgVk0uCj4KPiBUaGlzIHJlcXVpcmVzIHNvbWUgcHJldHR5IGludmFz
aXZlIGNoYW5nZXMgdG8gb3VyIGRhdGEgc3RydWN0dXJlcywKPiB3aGljaCBtb3ZlcyB0aGUgdm1p
ZCBhbmQgcGdkIHBvaW50ZXJzIGludG8gYSBzZXBhcmF0ZSBzdHJ1Y3R1cmUgYW5kCj4gY2hhbmdl
IHByZXR0eSBtdWNoIGFsbCBvZiBvdXIgbW11IGNvZGUgdG8gb3BlcmF0ZSBvbiB0aGlzIHN0cnVj
dHVyZQo+IGluc3RlYWQuCj4KPiBUaGUgbmV3IHN0cnVjdHVyZSBpcyBjYWxsZWQgc3RydWN0IGt2
bV9zMl9tbXUuCj4KPiBUaGVyZSBpcyBubyBpbnRlbmRlZCBmdW5jdGlvbmFsIGNoYW5nZSBieSB0
aGlzIHBhdGNoIGFsb25lLgo+Cj4gUmV2aWV3ZWQtYnk6IEphbWVzIE1vcnNlIDxqYW1lcy5tb3Jz
ZUBhcm0uY29tPgo+IFtEZXNpZ25lZCBkYXRhIHN0cnVjdHVyZSBsYXlvdXQgaW4gY29sbGFib3Jh
dGlvbl0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxs
QGFybS5jb20+Cj4gQ28tZGV2ZWxvcGVkLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
Pgo+IFttYXo6IE1vdmVkIHRoZSBsYXN0X3ZjcHVfcmFuIGRvd24gdG8gdGhlIFMyIE1NVSBzdHJ1
Y3R1cmUgYXMgd2VsbF0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPgo+IC0tLQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaCAgfCAgIDcgKy0K
PiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDMyICsrKy0KPiAgYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1fbW11LmggIHwgIDE2ICstCj4gIGFyY2gvYXJtNjQva3ZtL2Fy
bS5jICAgICAgICAgICAgICB8ICAzNiArKy0tCj4gIGFyY2gvYXJtNjQva3ZtL2h5cC9zd2l0Y2gu
YyAgICAgICB8ICAgOCArLQo+ICBhcmNoL2FybTY0L2t2bS9oeXAvdGxiLmMgICAgICAgICAgfCAg
NTIgKysrLS0tCj4gIGFyY2gvYXJtNjQva3ZtL21tdS5jICAgICAgICAgICAgICB8IDI3OCArKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0KPiAgNyBmaWxlcyBjaGFuZ2VkLCAyMzMgaW5zZXJ0
aW9ucygrKSwgMTk2IGRlbGV0aW9ucygtKQo+Cj4gWy4uXQo+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4gaW5kZXggOTBjYjkwNTYxNDQ2
Li4zNjAzOTZlY2M2ZDMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vYXJtLmMKPiArKysg
Yi9hcmNoL2FybTY0L2t2bS9hcm0uYwoKVGhlcmUncyBzdGlsbCBvbmUgY29tbWVudCBpbiB0aGUg
ZmlsZSB0aGF0IHJlZmVycyB0byBhcmNoLnZtaWQ6CgpzdGF0aWMgYm9vbCBuZWVkX25ld192bWlk
X2dlbihzdHJ1Y3Qga3ZtX3ZtaWQgKnZtaWQpCnsKwqDCoMKgIHU2NCBjdXJyZW50X3ZtaWRfZ2Vu
ID0gYXRvbWljNjRfcmVhZCgma3ZtX3ZtaWRfZ2VuKTsKwqDCoMKgIHNtcF9ybWIoKTsgLyogT3Jk
ZXJzIHJlYWQgb2Yga3ZtX3ZtaWRfZ2VuIGFuZCBrdm0tPmFyY2gudm1pZCAqLwrCoMKgwqAgcmV0
dXJuIHVubGlrZWx5KFJFQURfT05DRSh2bWlkLT52bWlkX2dlbikgIT0gY3VycmVudF92bWlkX2dl
bik7Cn0KClRoZSBjb21tZW50IGNvdWxkIGJlIHJlcGhyYXNlZCB0byByZW1vdmUgdGhlIHJlZmVy
ZW5jZSB0byBrdm0tPmFyY2gudm1pZDogIk9yZGVycwpyZWFkIG9mIGt2bV92bWlkX2dlbiBhbmQg
a3ZtX3MyX21tdS0+dm1pZCIuCgo+IFsuLl0KPiAgCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0vbW11LmMKPiBpbmRleCA4YzAwMzVjYWI2YjYuLjRh
NDQzN2JlNGJjNSAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9tbXUuYwo+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL21tdS5jCj4KPiBbLi5dCj4gIAo+ICAvKioKPiAtICoga3ZtX2FsbG9jX3N0
YWdlMl9wZ2QgLSBhbGxvY2F0ZSBsZXZlbC0xIHRhYmxlIGZvciBzdGFnZS0yIHRyYW5zbGF0aW9u
Lgo+IC0gKiBAa3ZtOglUaGUgS1ZNIHN0cnVjdCBwb2ludGVyIGZvciB0aGUgVk0uCj4gKyAqIGt2
bV9pbml0X3N0YWdlMl9tbXUgLSBJbml0aWFsaXNlIGEgUzIgTU1VIHN0cnVjcnVyZQo+ICsgKiBA
a3ZtOglUaGUgcG9pbnRlciB0byB0aGUgS1ZNIHN0cnVjdHVyZQo+ICsgKiBAbW11OglUaGUgcG9p
bnRlciB0byB0aGUgczIgTU1VIHN0cnVjdHVyZQo+ICAgKgo+ICAgKiBBbGxvY2F0ZXMgb25seSB0
aGUgc3RhZ2UtMiBIVyBQR0QgbGV2ZWwgdGFibGUocykgb2Ygc2l6ZSBkZWZpbmVkIGJ5Cj4gLSAq
IHN0YWdlMl9wZ2Rfc2l6ZShrdm0pLgo+ICsgKiBzdGFnZTJfcGdkX3NpemUobW11LT5rdm0pLgo+
ICAgKgo+ICAgKiBOb3RlIHdlIGRvbid0IG5lZWQgbG9ja2luZyBoZXJlIGFzIHRoaXMgaXMgb25s
eSBjYWxsZWQgd2hlbiB0aGUgVk0gaXMKPiAgICogY3JlYXRlZCwgd2hpY2ggY2FuIG9ubHkgYmUg
ZG9uZSBvbmNlLgo+ICAgKi8KPiAtaW50IGt2bV9hbGxvY19zdGFnZTJfcGdkKHN0cnVjdCBrdm0g
Kmt2bSkKPiAraW50IGt2bV9pbml0X3N0YWdlMl9tbXUoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qg
a3ZtX3MyX21tdSAqbW11KQo+ICB7Cj4gIAlwaHlzX2FkZHJfdCBwZ2RfcGh5czsKPiAgCXBnZF90
ICpwZ2Q7Cj4gKwlpbnQgY3B1Owo+ICAKPiAtCWlmIChrdm0tPmFyY2gucGdkICE9IE5VTEwpIHsK
PiArCWlmIChtbXUtPnBnZCAhPSBOVUxMKSB7Cj4gIAkJa3ZtX2Vycigia3ZtX2FyY2ggYWxyZWFk
eSBpbml0aWFsaXplZD9cbiIpOwo+ICAJCXJldHVybiAtRUlOVkFMOwo+ICAJfQo+IEBAIC0xMDI0
LDggKzEwNDAsMjAgQEAgaW50IGt2bV9hbGxvY19zdGFnZTJfcGdkKHN0cnVjdCBrdm0gKmt2bSkK
PiAgCWlmIChXQVJOX09OKHBnZF9waHlzICYgfmt2bV92dHRicl9iYWRkcl9tYXNrKGt2bSkpKQo+
ICAJCXJldHVybiAtRUlOVkFMOwoKV2UgZG9uJ3QgZnJlZSB0aGUgcGdkIGlmIHdlIGdldCB0aGUg
ZXJyb3IgYWJvdmUsIGJ1dCB3ZSBkbyBmcmVlIGl0IGJlbG93LCBpZgphbGxvY2F0aW5nIGxhc3Rf
dmNwdV9yYW4gZmFpbHMuIFNob3VsZG4ndCB3ZSBmcmVlIGl0IGluIGJvdGggY2FzZXM/Cgo+IC0J
a3ZtLT5hcmNoLnBnZCA9IHBnZDsKPiAtCWt2bS0+YXJjaC5wZ2RfcGh5cyA9IHBnZF9waHlzOwo+
ICsJbW11LT5sYXN0X3ZjcHVfcmFuID0gYWxsb2NfcGVyY3B1KHR5cGVvZigqbW11LT5sYXN0X3Zj
cHVfcmFuKSk7Cj4gKwlpZiAoIW1tdS0+bGFzdF92Y3B1X3Jhbikgewo+ICsJCWZyZWVfcGFnZXNf
ZXhhY3QocGdkLCBzdGFnZTJfcGdkX3NpemUoa3ZtKSk7Cj4gKwkJcmV0dXJuIC1FTk9NRU07Cj4g
Kwl9Cj4KPiBbLi5dCgpUaGFua3MsCkFsZXgKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
