Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73360C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 16:49:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF8584045D;
	Wed, 26 Jan 2022 11:49:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6W8G+NsU6Gva; Wed, 26 Jan 2022 11:49:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A57049F17;
	Wed, 26 Jan 2022 11:49:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364C149F0E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 11:49:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3dZjAt0wHsG6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 11:49:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B860240CDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 11:49:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21894D6E;
 Wed, 26 Jan 2022 08:49:45 -0800 (PST)
Received: from [10.1.196.218] (eglon.cambridge.arm.com [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0431F3F7D8;
 Wed, 26 Jan 2022 08:49:43 -0800 (PST)
Subject: Re: [PATCH 4/4] KVM: arm64: Workaround Cortex-A510's single-step and
 PAC trap errata
To: Marc Zyngier <maz@kernel.org>
References: <20220125153803.549084-1-james.morse@arm.com>
 <20220125153803.549084-5-james.morse@arm.com> <87mtjj7o7y.wl-maz@kernel.org>
 <711e16a1-c853-10e8-43d5-31890f0d4c7c@arm.com> <87k0en7jcw.wl-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <a28f54a5-47d2-651a-0a2f-4274ab9d5855@arm.com>
Date: Wed, 26 Jan 2022 16:49:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87k0en7jcw.wl-maz@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDI1LzAxLzIwMjIgMTg6MzYsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiBU
dWUsIDI1IEphbiAyMDIyIDE4OjE5OjQ1ICswMDAwLAo+IEphbWVzIE1vcnNlIDxqYW1lcy5tb3Jz
ZUBhcm0uY29tPiB3cm90ZToKPj4gT24gMjUvMDEvMjAyMiAxNjo1MSwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+Pj4gT24gVHVlLCAyNSBKYW4gMjAyMiAxNTozODowMyArMDAwMCwKPj4+IEphbWVzIE1v
cnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPiB3cm90ZToKPj4+Pgo+Pj4+IENvcnRleC1BNTEwJ3Mg
ZXJyYXR1bSAjMjA3NzA1NyBjYXVzZXMgU1BTUl9FTDIgdG8gYmUgY29ycnVwdGVkIHdoZW4KPj4+
PiBzaW5nbGUtc3RlcHBpbmcgYXV0aGVudGljYXRlZCBFUkVUIGluc3RydWN0aW9ucy4gQSBzaW5n
bGUgc3RlcCBpcwo+Pj4+IGV4cGVjdGVkLCBidXQgYSBwb2ludGVyIGF1dGhlbnRpY2F0aW9uIHRy
YXAgaXMgdGFrZW4gaW5zdGVhZC4gVGhlCj4+Pj4gZXJyYXR1bSBjYXVzZXMgU1BTUl9FTDEgdG8g
YmUgY29waWVkIHRvIFNQU1JfRUwyLCB3aGljaCBjb3VsZCBhbGxvdwo+Pj4+IEVMMSB0byBjYXVz
ZSBhIHJldHVybiB0byBFTDIgd2l0aCBhIGd1ZXN0IGNvbnRyb2xsZWQgRUxSX0VMMi4KPj4+Pgo+
Pj4+IEJlY2F1c2UgdGhlIGNvbmRpdGlvbnMgcmVxdWlyZSBhbiBFUkVUIGludG8gYWN0aXZlLW5v
dC1wZW5kaW5nIHN0YXRlLAo+Pj4+IHRoaXMgaXMgb25seSBhIHByb2JsZW0gZm9yIHRoZSBFTDIg
d2hlbiBFTDIgaXMgc3RlcHBpbmcgRUwxLiBJbiB0aGlzIGNhc2UKPj4+PiB0aGUgcHJldmlvdXMg
U1BTUl9FTDIgdmFsdWUgaXMgcHJlc2VydmVkIGluIHN0cnVjdCBrdm1fdmNwdSwgYW5kIGNhbiBi
ZQo+Pj4+IHJlc3RvcmVkLgoKPj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL2lu
Y2x1ZGUvaHlwL3N3aXRjaC5oIGIvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRj
aC5oCj4+Pj4gaW5kZXggMzMxZGQxMDgyMWRmLi45M2JmMTQwY2M5NzIgMTAwNjQ0Cj4+Pj4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRjaC5oCj4+Pj4gKysrIGIvYXJj
aC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRjaC5oCj4+Pj4gQEAgLTQ0MCw2ICs0NDIs
MjIgQEAgc3RhdGljIGlubGluZSBib29sIGZpeHVwX2d1ZXN0X2V4aXQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCB1NjQgKmV4aXRfY29kZSkKPj4+PiAgCQkJd3JpdGVfc3lzcmVnX2VsMihyZWFkX3N5
c3JlZ19lbDIoU1lTX0VMUikgLSA0LCBTWVNfRUxSKTsKPj4+PiAgCX0KPj4+PiAgCj4+Pj4gKwkv
Kgo+Pj4+ICsJICogQ2hlY2sgZm9yIHRoZSBjb25kaXRpb25zIG9mIENvcnRleC1BNTEwJ3MgIzIw
NzcwNTcuIFdoZW4gdGhlc2Ugb2NjdXIKPj4+PiArCSAqIFNQU1JfRUwyIGNhbid0IGJlIHRydXN0
ZWQsIGJ1dCBpc24ndCBuZWVkZWQgZWl0aGVyIGFzIGl0IGlzCj4+Pj4gKwkgKiB1bmNoYW5nZWQg
ZnJvbSB0aGUgdmFsdWUgaW4gdmNwdV9ncF9yZWdzKHZjcHUpLT5wc3RhdGUuCj4+Pj4gKwkgKiBE
aWQgd2UganVzdCB0YWtlIGEgUEFDIGV4Y2VwdGlvbiB3aGVuIGEgc3RlcCBleGNlcHRpb24gd2Fz
IGV4cGVjdGVkPwo+Pj4+ICsJICovCj4+Pj4gKwlpZiAoSVNfRU5BQkxFRChDT05GSUdfQVJNNjRf
RVJSQVRVTV8yMDc3MDU3KSAmJgo+Pj4KPj4+IG5pdDogd2UgY2FuIGRyb3AgdGhpcyBJU19FTkFC
TEVEKCkuLi4KPj4KPj4gSG1tbSwgSSB0aG91Z2h0IGRlYWQgY29kZSBlbGltaW5hdGlvbiB3YXMg
YSBnb29kIHRoaW5nIQo+PiBXaXRob3V0IHRoZSBjcHVfZXJyYXRhLmMgbWF0Y2gsICh3aGljaCBp
cyBhbHNvIGd1YXJkZWQgYnkgI2lmZGVmKSwKPj4gdGhlIGNhcCB3aWxsIG5ldmVyIGJlIHRydWUs
IGV2ZW4gaWYgYW4gYWZmZWN0ZWQgQ1BVIHNob3dlZCB1cC4gVGhpcwo+PiB3YXkgdGhlIGNvbXBp
bGVyIGtub3dzIGl0IGNhbiByZW1vdmUgYWxsIHRoaXMuCgo+IEkgZG9uJ3QgZGlzcHV0ZSB0aGF0
LiBIb3dldmVyLCBleHBlcmllbmNlIHNob3dzIHRoYXQgdGhlIG1vcmUgb2YgdGhlc2UKPiB3ZSBz
cHJpbmtsZSBhcm91bmQsIHRoZSBxdWlja2VyIHRoaXMgY29kZSBiaXRyb3RzIGFzIHdlIGRvbid0
IGJ1aWxkCj4gZm9yIGFsbCB0aGUgcG9zc2libGUgY29uZmlndXJhdGlvbnMuIEluIGdlbmVyYWws
IHdlIGhhcmRseSBoYXZlIGFueQo+IGRlcGVuZGVuY3kgb24gY29uZmlndXJhdGlvbiBzeW1ib2xz
LCBhbmQgcmVseSBvbiBzdGF0aWMga2V5cyBnb3QKPiB0aGluZ3Mgbm90IGJlIHRlcnJpYmx5IHN1
Y2t5LgoKSSdsbCByZW1vdmUgaXQgLSBidXQgSSdtIG5vdCBjb252aW5jZWQ6CgpJZiB0aGlzIHdl
cmUgaW4gYW4gI2lmZGVmIGJsb2NrLCBJIGFncmVlIHRoYXQgd291bGQgcHJldmVudCB0aGUgY29t
cGlsZXIgZnJvbSBldmVuIHNlZWluZwp0aGlzIGNvZGUsIGFuZCBpdCB3b3VsZCBjZXJ0YWlubHkg
Yml0cm90IGlmIHRoYXQgS2NvbmZpZyBpc24ndCBzZWxlY3RlZCwgYW5kIHdvdWxkIG5vdCBiZQpi
dWlsZC10ZXN0ZWQgcHJvcGVybHkgaW4gYWxsIHRoZSBiaXphcnJlIGNhc2VzIHRoYXQgb25seSBD
SSBzeXN0ZW1zIHRyeS4KCkJ1dCB0aGUgSVNfRU5BQkxFRCgpIHN0dWZmIGxldHMgdGhlIGNvbXBp
bGVyIGNhbiBzZWUgaW5zaWRlIHRoYXQgYmxvY2ssIGFuZCBtZWFucyB0aGUKY29tcGlsZXIgY2Fu
IGNoZWNrIHRoZSB0eXBlcyBldGMsIGJlZm9yZSBldmVudHVhbGx5IHJlbW92aW5nIGl0IGFzIHRo
ZSBjb25kaXRpb24gYmVjb21lcwoiaWYoZmFsc2UpIi4KCkZvciBleGFtcGxlOgp8CWlmIChJU19F
TkFCTEVEKENPTkZJR19BUk02NF9FUlJBVFVNXzIwNzcwNTcpKQp8CQlzeW5jaHJvbml6ZV92Y3B1
X3BzdGF0ZSg0Mik7CgpUaGlzIGZhaWxzIHRvIGNvbXBpbGUgcmVnYXJkbGVzcyBvZiB0aGUgdmFs
dWUgb2YgdGhlIEtjb25maWcgc3ltYm9sOgp8IEluIGZpbGUgaW5jbHVkZWQgZnJvbSBhcmNoL2Fy
bTY0L2t2bS9oeXAvdmhlL3N3aXRjaC5jOjc6CnwgLi9hcmNoL2FybTY0L2t2bS9oeXAvaW5jbHVk
ZS9oeXAvc3dpdGNoLmg6IEluIGZ1bmN0aW9uIOKAmHN5bmNocm9uaXplX3ZjcHVfcHN0YXRl4oCZ
Ogp8IC4vYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRjaC5oOjQxNToyNzogd2Fy
bmluZzogcGFzc2luZyBhcmd1bWVudCAxIG9mCnwg4oCYc3luY2hyb25pemVfdmNwdV9wc3RhdGXi
gJkgbWFrZXMgcG9pbnRlciBmcm9tIGludGVnZXIgd2l0aG91dCBhIGNhc3QgWy1XaW50LWNvbnZl
cnNpb25dCnwgICA0MTUgfCAgIHN5bmNocm9uaXplX3ZjcHVfcHN0YXRlKDQyKTsKfAp8IC4vYXJj
aC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRjaC5oOjQwNTo2MTogbm90ZTogZXhwZWN0
ZWQg4oCYc3RydWN0IGt2bV92Y3B1ICrigJkgYnV0CnwgYXJndW1lbnQgaXMgb2YgdHlwZSDigJhp
bnTigJkKfCAgNDA1IHwgc3RhdGljIGlubGluZSB2b2lkIHN5bmNocm9uaXplX3ZjcHVfcHN0YXRl
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0ICpleGl0X2NvZGUpCgpldGMuCgp8IGNhdCAuY29u
ZmlnIHwgZ3JlcCAyMDc3MDU3CnwgIyBDT05GSUdfQVJNNjRfRVJSQVRVTV8yMDc3MDU3IGlzIG5v
dCBzZXQKCgpJIGd1ZXNzIHlvdSdyZSB3b3JyaWVkIGFib3V0IGxpbmsgZXJyb3JzLgoKWy4uXQoK
Pj4+IE90aGVyIHRoYW4gdGhhdCwgSSdtIGhhcHB5IHRvIHRha2UgdGhlIHNlcmllcyBhcyBhIHdo
b2xlIEFTQVAsIGlmIG9ubHkKPj4+IGZvciB0aGUgdHdvIHByZXR0eSBlbWJhcnJhc3NpbmcgYnVn
IGZpeGVzLiBJZiB5b3UgY2FuIHJlc3BpbiBpdAo+Pj4gc2hvcnRseSBhbmQgYWRkcmVzcyB0aGUg
Y29tbWVudHMgYWJvdmUsIEknZCBsaWtlIGl0IGludG8gLXJjMi4KPj4KPj4gV2lsbCBkby4gU2hv
dXQgaWYgeW91IHN0cm9uZ2x5IGNhcmUgYWJvdXQgdGhlIElTX0VOQUJMRUQoKS4KPiAKPiBJJ2Qg
cmVhbGx5IGxpa2UgaXQgZ29uZS4gT3RoZXJ3aXNlLCBJJ2xsIG5ldmVyIGNvbXBpbGUgdGhhdCBj
b2RlLgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
