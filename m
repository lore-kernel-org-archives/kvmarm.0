From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 27 Mar 2019 08:51:09 +0530
Message-ID: <536f518d-5425-cb94-3f64-4c56e5cd65c1@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
 <64505666-8a1f-cf64-7067-4b2dd53b0b40@arm.com>
 <da7091a9-01b2-bead-3777-972fbb293def@arm.com>
 <949327ae-081c-0964-3315-ac2695243b5f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9D44A3EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 23:21:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o1mR+2mgqUEx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 23:21:16 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C544A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 23:21:16 -0400 (EDT)
In-Reply-To: <949327ae-081c-0964-3315-ac2695243b5f@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAzLzI2LzE5IDExOjMxIFBNLCBLcmlzdGluYSBNYXJ0c2Vua28gd3JvdGU6Cj4gT24gMjYv
MDMvMjAxOSAwNDowMywgQW1pdCBEYW5pZWwgS2FjaGhhcCB3cm90ZToKPj4gSGksCj4+Cj4+IE9u
IDMvMjYvMTkgMTozNCBBTSwgS3Jpc3RpbmEgTWFydHNlbmtvIHdyb3RlOgo+Pj4gT24gMTkvMDMv
MjAxOSAwODozMCwgQW1pdCBEYW5pZWwgS2FjaGhhcCB3cm90ZToKPj4+PiBGcm9tOiBNYXJrIFJ1
dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPgo+Pj4+Cj4+Pj4gV2hlbiBwb2ludGVyIGF1dGhl
bnRpY2F0aW9uIGlzIHN1cHBvcnRlZCwgYSBndWVzdCBtYXkgd2lzaCB0byB1c2UgaXQuCj4+Pj4g
VGhpcyBwYXRjaCBhZGRzIHRoZSBuZWNlc3NhcnkgS1ZNIGluZnJhc3RydWN0dXJlIGZvciB0aGlz
IHRvIHdvcmssIHdpdGgKPj4+PiBhIHNlbWktbGF6eSBjb250ZXh0IHN3aXRjaCBvZiB0aGUgcG9p
bnRlciBhdXRoIHN0YXRlLgo+Pj4KPj4+IFsuLi5dCj4+Pgo+Pj4+ICvCoMKgwqAgaWYgKHRlc3Rf
Yml0KEtWTV9BUk1fVkNQVV9QVFJBVVRIX0FERFJFU1MsIHZjcHUtPmFyY2guZmVhdHVyZXMpIHx8
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHRlc3RfYml0KEtWTV9BUk1fVkNQVV9QVFJBVVRIX0dFTkVS
SUMsIHZjcHUtPmFyY2guZmVhdHVyZXMpKSB7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIFZlcmlm
eSB0aGF0IEtWTSBzdGFydHVwIG1hdGNoZXMgdGhlIGNvbmRpdGlvbnMgZm9yIHB0cmF1dGggKi8K
Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKFdBUk5fT04oIXZjcHVfaGFzX3B0cmF1dGgodmNwdSkp
KQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+Pj4+ICvCoMKg
wqAgfQo+Pj4KPj4+IEkgdGhpbmsgdGhpcyBub3cgbmVlZHMgdG8gaGF2ZSAiZ290byBvdXQ7IiBp
bnN0ZWFkIG9mICJyZXR1cm4gLUVJTlZBTDsiLAo+Pj4gc2luY2UgNS4xLXJjWCBjb250YWlucyBj
b21taXQgZTc2MWE5MjdiYzlhICgiS1ZNOiBhcm0vYXJtNjQ6IFJlc2V0IHRoZQo+Pj4gVkNQVSB3
aXRob3V0IHByZWVtcHRpb24gYW5kIHZjcHUgc3RhdGUgbG9hZGVkIikgd2hpY2ggY2hhbmdlZCBz
b21lIG9mCj4+PiB0aGlzIGNvZGUuCj4+IG9rIG1pc3NlZCB0aGUgY2hhbmdlcyBmb3IgdGhpcyBj
b21taXQuCj4gCj4gT25lIG1vcmUgdGhpbmcgLSBJIHRoaW5rIHRoZSBXQVJOX09OKCkgaGVyZSBz
aG91bGQgYmUgcmVtb3ZlZC4gT3RoZXJ3aXNlCj4gaWYgcGFuaWNfb25fd2FybiBpcyBzZXQgdGhl
biB1c2Vyc3BhY2UgY2FuIHBhbmljIHRoZSBrZXJuZWwuIEkgdGhpbmsKPiBXQVJOX09OIGlzIG9u
bHkgZm9yIGludGVybmFsIGtlcm5lbCBlcnJvcnMgKHNlZSBjb21tZW50IGluCj4gaW5jbHVkZS9h
c20tZ2VuZXJpYy9idWcuaCkuCgpUaGUgZG9jdW1lbnRhdGlvbiBtYWtlcyBzZW5zZSBzbyBpbiB0
aGlzIGNhc2UgYSBwcl9lcnIgbGlrZSBtZXNzYWdlIAp3aWxsIHN1ZmZpY2UuIEJ0dyB0aGVyZSBp
cyBvbmUgV0FSTiBpbiB0aGUgZnVuY3Rpb24ga3ZtX3NldF9pcGFfbGltaXQgaW4gCnRoZSBzYW1l
IGZpbGUuCgpUaGFua3MsCkFtaXQgRAo+IAo+IFRoYW5rcywKPiBLcmlzdGluYQo+IApfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
