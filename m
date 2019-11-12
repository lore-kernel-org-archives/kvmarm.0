Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7504FC17441
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 13:26:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0698D21925
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 13:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0698D21925
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4F44B19B;
	Tue, 12 Nov 2019 08:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qyC1zDdP7VRV; Tue, 12 Nov 2019 08:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32D374B19C;
	Tue, 12 Nov 2019 08:26:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCBC14B19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 08:26:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOBLDdxA541w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 08:26:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C984B191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 08:26:19 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CF2A30E;
 Tue, 12 Nov 2019 05:26:19 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 273F53F6C4;
 Tue, 12 Nov 2019 05:26:18 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 04/17] arm: gic: Support no IRQs test case
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-5-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
Date: Tue, 12 Nov 2019 13:26:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-5-andre.przywara@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

SGksCgpPbiAxMS84LzE5IDI6NDIgUE0sIEFuZHJlIFByenl3YXJhIHdyb3RlOgo+IEZvciBzb21l
IHRlc3RzIGl0IHdvdWxkIGJlIGltcG9ydGFudCB0byBjaGVjayB0aGF0IGFuIElSUSB3YXMgKm5v
dCoKPiB0cmlnZ2VyZWQsIGZvciBpbnN0YW5jZSB0byB0ZXN0IGNlcnRhaW4gbWFza2luZyBvcGVy
YXRpb25zLgo+Cj4gRXh0ZW5kIHRoZSBjaGVja19hZGRlZCgpIGZ1bmN0aW9uIHRvIHJlY29nbmlz
ZSBhbiBlbXB0eSBjcHVtYXNrIHRvCj4gZGV0ZWN0IHRoaXMgc2l0dWF0aW9uLiBUaGUgdGltZW91
dCBkdXJhdGlvbiBpcyByZWR1Y2VkLCBhbmQgdGhlICJubyBJUlFzCgpXaHkgaXMgdGhlIHRpbWVv
dXQgZHVyYXRpb24gcmVkdWNlZD8KCj4gdHJpZ2dlcmVkIiBjYXNlIGlzIGFjdHVhbGx5IHJlcG9y
dGVkIGFzIGEgc3VjY2VzcyBpbiB0aGlzIGNhc2UuCj4KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZSBQ
cnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4KPiAtLS0KPiAgYXJtL2dpYy5jIHwgMTAg
KysrKysrKystLQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQo+Cj4gZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9naWMuYwo+IGluZGV4IGExMTQw
MDkuLmVjYTkxODggMTAwNjQ0Cj4gLS0tIGEvYXJtL2dpYy5jCj4gKysrIGIvYXJtL2dpYy5jCj4g
QEAgLTY2LDkgKzY2LDEwIEBAIHN0YXRpYyB2b2lkIGNoZWNrX2Fja2VkKGNvbnN0IGNoYXIgKnRl
c3RuYW1lLCBjcHVtYXNrX3QgKm1hc2spCj4gIAlpbnQgbWlzc2luZyA9IDAsIGV4dHJhID0gMCwg
dW5leHBlY3RlZCA9IDA7Cj4gIAlpbnQgbnJfcGFzcywgY3B1LCBpOwo+ICAJYm9vbCBiYWQgPSBm
YWxzZTsKPiArCWJvb2wgbm9pcnFzID0gY3B1bWFza19lbXB0eShtYXNrKTsKPiAgCj4gIAkvKiBX
YWl0IHVwIHRvIDVzIGZvciBhbGwgaW50ZXJydXB0cyB0byBiZSBkZWxpdmVyZWQgKi8KClRoaXMg
Y29tbWVudCBuZWVkcyB1cGRhdGluZy4KCj4gLQlmb3IgKGkgPSAwOyBpIDwgNTA7ICsraSkgewo+
ICsJZm9yIChpID0gMDsgaSA8IChub2lycXMgPyAxNSA6IDUwKTsgKytpKSB7Cj4gIAkJbWRlbGF5
KDEwMCk7Cj4gIAkJbnJfcGFzcyA9IDA7Cj4gIAkJZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1KSB7
Cj4gQEAgLTg4LDcgKzg5LDcgQEAgc3RhdGljIHZvaWQgY2hlY2tfYWNrZWQoY29uc3QgY2hhciAq
dGVzdG5hbWUsIGNwdW1hc2tfdCAqbWFzaykKPiAgCQkJCWJhZCA9IHRydWU7Cj4gIAkJCX0KPiAg
CQl9Cj4gLQkJaWYgKG5yX3Bhc3MgPT0gbnJfY3B1cykgewo+ICsJCWlmICghbm9pcnFzICYmIG5y
X3Bhc3MgPT0gbnJfY3B1cykgewoKVGhpcyBjb25kaXRpb24gaXMgcHJldHR5IGhhcmQgdG8gcmVh
ZCAtIHdoYXQgeW91IGFyZSBkb2luZyBoZXJlIGlzIG1ha2luZyBzdXJlCnRoYXQgd2hlbiBjaGVj
a19hY2tlZCB0ZXN0cyB0aGF0IG5vIGlycXMgaGF2ZSBiZWVuIHJlY2VpdmVkLCB5b3UgZG8gdGhl
IGVudGlyZSBmb3IKbG9vcCBhbmQgd2FpdCB0aGUgZW50aXJlIHRpbWVvdXQgZHVyYXRpb24uIERp
ZCBJIGdldCB0aGF0IHJpZ2h0PwoKSG93IGFib3V0IHRoaXMgKGNvbXBpbGUgdGVzdGVkIG9ubHkp
OgoKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG5vaXJxcykKK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIFdhaXQgZm9yIHRoZSBlbnRpcmUg
dGltZW91dCBkdXJhdGlvbi4gKi8KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGNvbnRpbnVlOworCsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAo
bnJfcGFzcyA9PSBucl9jcHVzKSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmVwb3J0KCIlcyIsICFiYWQsIHRlc3RuYW1lKTsKwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoaSkKCj4gIAkJCXJlcG9ydCgiJXMi
LCAhYmFkLCB0ZXN0bmFtZSk7Cj4gIAkJCWlmIChpKQo+ICAJCQkJcmVwb3J0X2luZm8oInRvb2sg
bW9yZSB0aGFuICVkIG1zIiwgaSAqIDEwMCk7Cj4gQEAgLTk2LDYgKzk3LDExIEBAIHN0YXRpYyB2
b2lkIGNoZWNrX2Fja2VkKGNvbnN0IGNoYXIgKnRlc3RuYW1lLCBjcHVtYXNrX3QgKm1hc2spCj4g
IAkJfQo+ICAJfQo+ICAKPiArCWlmIChub2lycXMgJiYgbnJfcGFzcyA9PSBucl9jcHVzKSB7Cj4g
KwkJcmVwb3J0KCIlcyIsICFiYWQsIHRlc3RuYW1lKTsKCmJhZCBpcyB0cnVlIG9ubHkgd2hlbiBi
YWRfc2VuZGVyW2NwdV0gIT0gLTEgb3IgYmFkX2lycVtjcHVdICE9IC0xLCB3aGljaCBvbmx5IGdl
dApzZXQgaW4gdGhlIGlycSBvciBpcGkgaGFuZGxlc3IsIG1lYW5pbmcgd2hlbiB5b3UgZG8gZ2V0
IGFuIGludGVycnVwdC4gSWYgbnJfcGFzcwo9PSBucl9jcHVzIGFuZCBub2lycXMsIHRoZW4geW91
IHNob3VsZG4ndCBoYXZlIGdvdHRlbiBhbiBpbnRlcnJ1cHQuIEkgdGhpbmsgaXQncwpzYWZlIHRv
IHdyaXRlIGl0IGFzIHJlcG9ydCgiJXMiLCB0cnVlLCB0ZXN0bmFtZSkuIEkgdGhpbmsgYSBzaG9y
dCBjb21tZW50IGFib3ZlCmV4cGxhaW5pbmcgd2h5IHdlIGRvIHRoaXMgY2hlY2sgKHRpbWVvdXQg
ZXhwaXJlZCBhbmQgd2UgaGF2ZW4ndCBnb3R0ZW4gYW55CmludGVycnVwdHMpIHdvdWxkIGFsc28g
aW1wcm92ZSByZWFkYWJpbGl0eSBvZiB0aGUgY29kZSwgYnV0IHRoYXQncyB1cCB0byB5b3UuCgpU
aGFua3MsCkFsZXgKPiArCQlyZXR1cm47Cj4gKwl9Cj4gKwo+ICAJZm9yX2VhY2hfcHJlc2VudF9j
cHUoY3B1KSB7Cj4gIAkJaWYgKGNwdW1hc2tfdGVzdF9jcHUoY3B1LCBtYXNrKSkgewo+ICAJCQlp
ZiAoIWFja2VkW2NwdV0pCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
