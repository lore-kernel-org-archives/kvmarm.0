Return-Path: <SRS0=CLkw=ZE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD04C17441
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 15:42:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6CF70214E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Nov 2019 15:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CF70214E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4624B1C6;
	Tue, 12 Nov 2019 10:42:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJX4vPtTZKUB; Tue, 12 Nov 2019 10:42:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB694B1BC;
	Tue, 12 Nov 2019 10:42:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2D24B1BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 10:42:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QgyO3gCZFOJw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Nov 2019 10:41:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5764B07B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Nov 2019 10:41:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D98611FB;
 Tue, 12 Nov 2019 07:41:58 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8DB03F534;
 Tue, 12 Nov 2019 07:41:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 08/17] arm: gic: Add simple SPI MP test
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones
 <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-9-andre.przywara@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f7f11075-4313-dfc7-2e70-07c37fb61531@arm.com>
Date: Tue, 12 Nov 2019 15:41:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-9-andre.przywara@arm.com>
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

SGksCgpXaGF0IGRvZXMgTVAgc3RhbmQgZm9yIGluIHRoZSBzdWJqZWN0PyBNdWx0aS1wcm9jZXNz
b3I/IEkgdGhpbmsgY2hhbmdpbmcgaXQgdG8gU01QCm1ha2VzIG1vcmUgc2Vuc2UsIGFzIHRoYXQg
aXMgYWxzbyBpbiB0aGUgdGVzdCBuYW1lIHRoYXQgeW91J3ZlIGFkZGVkLgoKT24gMTEvOC8xOSAy
OjQyIFBNLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToKPiBTaGFyZWQgUGVyaXBoZXJhbCBJbnRlcnJ1
cHRzIChTUEkpIGNhbiB0YXJnZXQgYSBzcGVjaWZpYyBDUFUuIFRlc3QgdGhpcwo+IGZlYXR1cmUg
Ynkgcm91dGluZyB0aGUgdGVzdCBTUEkgdG8gZWFjaCBvZiB0aGUgdkNQVXMsIHRoZW4gdHJpZ2dl
cmluZyBpdAo+IGFuZCBjb25maXJtIGl0cyByZWNlcHRpb24gb24gdGhhdCByZXF1ZXN0ZWQgY29y
ZS4KPgo+IFNpZ25lZC1vZmYtYnk6IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0u
Y29tPgo+IC0tLQo+ICBhcm0vZ2ljLmMgfCAzMSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystCj4gIDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4K
PiBkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCj4gaW5kZXggNjNhYTlmNC4uMzA0
YjdiOSAxMDA2NDQKPiAtLS0gYS9hcm0vZ2ljLmMKPiArKysgYi9hcm0vZ2ljLmMKPiBAQCAtNjIw
LDE2ICs2MjAsNDUgQEAgc3RhdGljIHZvaWQgc3BpX3Rlc3Rfc2luZ2xlKHZvaWQpCj4gIAljaGVj
a19hY2tlZCgibm93IGVuYWJsZWQgU1BJIGZpcmVzIiwgJmNwdW1hc2spOwo+ICB9Cj4gIAo+ICtz
dGF0aWMgdm9pZCBzcGlfdGVzdF9zbXAodm9pZCkKPiArewo+ICsJaW50IGNwdTsKPiArCWludCBj
b3JlcyA9IDE7Cj4gKwo+ICsJd2FpdF9vbl9yZWFkeSgpOwo+ICsJZm9yX2VhY2hfcHJlc2VudF9j
cHUoY3B1KSB7Cj4gKwkJaWYgKGNwdSA9PSBzbXBfcHJvY2Vzc29yX2lkKCkpCj4gKwkJCWNvbnRp
bnVlOwo+ICsJCXNwaV9jb25maWd1cmVfaXJxKFNQSV9JUlEsIGNwdSk7Cj4gKwkJaWYgKHRyaWdn
ZXJfYW5kX2NoZWNrX3NwaShOVUxMLCBJUlFfU1RBVF9JUlEsIGNwdSkpCj4gKwkJCWNvcmVzKys7
Cj4gKwkJZWxzZQo+ICsJCQlyZXBvcnRfaW5mbygiU1BJIGRlbGl2ZXJ5IGZhaWxlZCBvbiBjb3Jl
ICVkIiwgY3B1KTsKPiArCX0KPiArCXJlcG9ydCgiU1BJIGRlbGlldmVyZWQgb24gYWxsIGNvcmVz
IiwgY29yZXMgPT0gbnJfY3B1cyk7Cj4gK30KPiArCj4gIHN0YXRpYyB2b2lkIHNwaV9zZW5kKHZv
aWQpCj4gIHsKPiAgCWlycXNfZW5hYmxlKCk7Cj4gIAo+ICAJc3BpX3Rlc3Rfc2luZ2xlKCk7Cj4g
IAo+ICsJaWYgKG5yX2NwdXMgPiAxKQo+ICsJCXNwaV90ZXN0X3NtcCgpOwo+ICsKPiAgCWNoZWNr
X3NwdXJpb3VzKCk7Cj4gIAlleGl0KHJlcG9ydF9zdW1tYXJ5KCkpOwo+ICB9Cj4gIAo+ICtzdGF0
aWMgdm9pZCBzcGlfdGVzdCh2b2lkICpkYXRhIF9fdW51c2VkKQo+ICt7Cj4gKwlpZiAoc21wX3By
b2Nlc3Nvcl9pZCgpID09IDApCj4gKwkJc3BpX3NlbmQoKTsKPiArCWVsc2UKPiArCQlpcnFfcmVj
digpOwo+ICt9Cj4gKwo+ICBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4gIHsKPiAg
CWlmICghZ2ljX2luaXQoKSkgewo+IEBAIC02NjMsNyArNjkyLDcgQEAgaW50IG1haW4oaW50IGFy
Z2MsIGNoYXIgKiphcmd2KQo+ICAJCXJlcG9ydF9wcmVmaXhfcG9wKCk7Cj4gIAl9IGVsc2UgaWYg
KHN0cmNtcChhcmd2WzFdLCAiaXJxIikgPT0gMCkgewo+ICAJCXJlcG9ydF9wcmVmaXhfcHVzaChh
cmd2WzFdKTsKPiAtCQlzcGlfc2VuZCgpOwo+ICsJCW9uX2NwdXMoc3BpX3Rlc3QsIE5VTEwpOwoK
VGhpcyBpcyBhIGJpdCBzdHJhbmdlLiBZb3UgY2FsbCBvbl9jcHVzIGhlcmUsIHdoaWNoIG1lYW5z
IHlvdSBhc3N1bWUgdGhhdCB5b3UgaGF2ZQptb3JlIHRoYW4gb25lIENQVSwgYnV0IHRoZW4geW91
IGNoZWNrIGlmIHlvdSBoYXZlIG1vcmUgdGhhbiBvbmUgQ1BVIGluIHNwaV9zZW5kLAp3aGljaCBn
ZXRzIGV4ZWN1dGVkIG9uIENQVSAwLgoKSG93IGFib3V0IHRoaXMgaW5zdGVhZCAoY29tcGlsZSB0
ZXN0ZWQgb25seSk6CgpkaWZmIC0tZ2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCmluZGV4IDYz
YWE5ZjRhOWZkYS4uN2QyNDQzYjA2ZmZhIDEwMDY0NAotLS0gYS9hcm0vZ2ljLmMKKysrIGIvYXJt
L2dpYy5jCkBAIC02MjAsMTIgKzYyMCw0MiBAQCBzdGF0aWMgdm9pZCBzcGlfdGVzdF9zaW5nbGUo
dm9pZCkKwqDCoMKgwqDCoMKgwqAgY2hlY2tfYWNrZWQoIm5vdyBlbmFibGVkIFNQSSBmaXJlcyIs
ICZjcHVtYXNrKTsKwqB9CsKgCi1zdGF0aWMgdm9pZCBzcGlfc2VuZCh2b2lkKQorc3RhdGljIHZv
aWQgc3BpX3Rlc3Rfc21wKHZvaWQpCsKgewotwqDCoMKgwqDCoMKgIGlycXNfZW5hYmxlKCk7CivC
oMKgwqDCoMKgwqAgaW50IGNwdTsKK8KgwqDCoMKgwqDCoCBpbnQgY29yZXMgPSAxOworCivCoMKg
wqDCoMKgwqAgZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1KSB7CivCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChjcHUgPT0gc21wX3Byb2Nlc3Nvcl9pZCgpKQorwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7CivCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNtcF9ib290X3NlY29uZGFyeShjcHUsIGlycV9yZWN2KTsKK8KgwqDCoMKg
wqDCoCB9CivCoMKgwqDCoMKgwqAgd2FpdF9vbl9yZWFkeSgpOwrCoAorwqDCoMKgwqDCoMKgIGZv
cl9lYWNoX3ByZXNlbnRfY3B1KGNwdSkgeworwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAoY3B1ID09IHNtcF9wcm9jZXNzb3JfaWQoKSkKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOworwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzcGlfY29uZmlndXJlX2lycShTUElfSVJRLCBjcHUpOworwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAodHJpZ2dlcl9hbmRfY2hlY2tfc3BpKE5VTEwsIElSUV9TVEFUX0lSUSwgY3B1
KSkKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvcmVzKys7
CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVsc2UKK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlcG9ydF9pbmZvKCJTUEkgZGVsaXZlcnkgZmFpbGVk
IG9uIGNvcmUgJWQiLCBjcHUpOworwqDCoMKgwqDCoMKgIH0KK8KgwqDCoMKgwqDCoCByZXBvcnQo
IlNQSSBkZWxpZXZlcmVkIG9uIGFsbCBjb3JlcyIsIGNvcmVzID09IG5yX2NwdXMpOworfQorCitz
dGF0aWMgdm9pZCBzcGlfdGVzdCh2b2lkKQoreworwqDCoMKgwqDCoMKgIGlycXNfZW5hYmxlKCk7
CsKgwqDCoMKgwqDCoMKgIHNwaV90ZXN0X3NpbmdsZSgpOworwqDCoMKgwqDCoMKgIGlmIChucl9j
cHVzID09IDEpIHsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVwb3J0X3NraXAoIkF0
IGxlYXN0IDIgY3B1cyByZXF1aXJlZCB0byBydW4gdGhlIFNQSSBTTVAgdGVzdCIpOworwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKK8KgwqDCoMKgwqDCoCB9CisKK8KgwqDC
oMKgwqDCoCBzcGlfdGVzdF9zbXAoKTsKwqAKK291dDoKwqDCoMKgwqDCoMKgwqAgY2hlY2tfc3B1
cmlvdXMoKTsKwqDCoMKgwqDCoMKgwqAgZXhpdChyZXBvcnRfc3VtbWFyeSgpKTsKwqB9CkBAIC02
NjMsNyArNjkzLDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQrCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVwb3J0X3ByZWZpeF9wb3AoKTsKwqDCoMKgwqDCoMKgwqAg
fSBlbHNlIGlmIChzdHJjbXAoYXJndlsxXSwgImlycSIpID09IDApIHsKwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJlcG9ydF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgc3BpX3NlbmQoKTsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3BpX3Rlc3QoKTsKwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlcG9ydF9wcmVm
aXhfcG9wKCk7CsKgwqDCoMKgwqDCoMKgIH0gZWxzZSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXBvcnRfYWJvcnQoIlVua25vd24gc3VidGVzdCAnJXMnIiwgYXJndlsxXSk7CgpX
aGF0IGRvIHlvdSB0aGluaz8KClRoYW5rcywKQWxleAo+ICAJCXJlcG9ydF9wcmVmaXhfcG9wKCk7
Cj4gIAl9IGVsc2Ugewo+ICAJCXJlcG9ydF9hYm9ydCgiVW5rbm93biBzdWJ0ZXN0ICclcyciLCBh
cmd2WzFdKTsKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
