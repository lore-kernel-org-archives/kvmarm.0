From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Fri, 06 Jul 2018 10:20:04 +0100
Message-ID: <87d0w090vv.fsf@linaro.org>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <87h8lc93jc.fsf@linaro.org>
 <20180706090534.GD26019@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D087D49F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:07:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+aE5G7phJy7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jul 2018 05:07:33 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 961FB408B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jul 2018 05:07:33 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id 69-v6so13727165wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jul 2018 02:20:06 -0700 (PDT)
In-reply-to: <20180706090534.GD26019@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIEZyaSwgSnVs
IDA2LCAyMDE4IGF0IDA5OjIyOjQ3QU0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4KPj4g
RGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+IHdyaXRlczoKPj4KPj4gPHNuaXA+Cj4+
ID4KPj4gPiBUaGlzIHNlcmllcyBpcyBzb21ld2hhdCB0ZXN0ZWQgb24gQXJtIEp1bm8gcjAgYW5k
IHRoZSBBcm0gRmFzdCBNb2RlbAo+PiA+ICh3aXRoL3dpdGhvdXQgU1ZFIHN1cHBvcnQpLiAgYXJj
aC9hcm0gYnVpbGRzLCBidXQgSSd2ZSBub3QgYm9vdGVkCj4+ID4gaXQgLS0gb25seSBzb21lIHRy
aXZpYWwgcmVmYWN0b3JpbmcgaW4gdGhpcyBzZXJpZXMgYWZmZWN0cyBhcmNoL2FybS4KPj4KPj4g
Tm93IHRoYXQgUUVNVSBsaW51eC11c2VyIFNWRSBzdXBwb3J0IGlzIHByZXR0eSBtdWNoIGNvbXBs
ZXRlIHdlJ3ZlIGFsc28KPj4gZ290IHByZWxpbWluYXJ5IHBhdGNoZXMgZm9yIHN5c3RlbSBlbXVs
YXRpb24gbW9kZS4gSG93ZXZlciB3ZSBjdXJyZW50bHkKPj4gZG9uJ3QgaGF2ZSBWSEUgaW1wbGVt
ZW50ZWQgc28gSSBndWVzcyB3ZSBuZWVkIHRvIGRvIHRoYXQgZmlyc3QgYmVmb3JlIHdlCj4+IGNh
biB0ZXN0IHVuZGVyIFFFTVUuCj4KPiBRZW11IGNhbiB1c2UgdGhpcyBhcyBhIEtWTSBjbGllbnQg
d2l0aG91dCBpbnZhc2l2ZSBjaGFuZ2VzLCByaWdodD8KClllYWggZm9yIEtWTSB1c2UgdGhlcmUg
YXJlbid0IHJlYWxseSBhbnkgY2hhbmdlcy4KCj4gRm9yIGt2bXRvb2wsIGl0J3MganVzdCBhIHF1
ZXN0aW9uIG9mIGNoZWNraW5nL3NldHRpbmcgYSBmZWF0dXJlIGZsYWcKPiBpbiBLVk1fQVJNX1BS
RUZFUlJFRF9UQVJHRVQgYW5kIEtWTV9BUk1fVkNQVV9JTklULCBhbmQgKGV2ZW50dWFsbHkpCj4g
ZG9pbmcgYXQgaW9jdGwoKSB0byBzZXQgdGhlIHNldCBvZiBwZXJtaXR0ZWQgdmVjdG9yIGxlbmd0
aHMgKG5vdCB5ZXQsCj4gdGhpcyB3aWxsIGNvbWUgaW4gYSBmb2xsb3ctdXAgc2VyaWVzKS4KCkZv
ciB0aGUgbW9zdCBwYXJ0IGluIFFFTVUgd2l0aCBLVk0gd2UganVzdCB0cmVhdCB0aGUgbGlzdCBv
ZiByZWdpc3RlcnMKd2UgZ2V0IGZyb20gdGhlIE9TIGFzIGFuIG9wYXF1ZSBibG9iIG9mIHRoaW5n
cyB3ZSBzYXZlIHRvIG1lbW9yeSBhbmQKcGFzcyBiYWNrLgoKVGhlIENQVSBmZWF0dXJlcyBjb2Rl
IHdpbGwgcHJvYmFibHkgbmVlZCBhIGJpdCBvZiB0d2Vha2luZyBidXQgaXQgd2lsbApiZSBtaW5v
ci4gSSdtIG5vdCBzdXJlIHdoYXQgdGhlIGN1cnJlbnQgc3RhdHVzIG9mIGNyb3NzLWhvc3QgQ1BV
Cm1pZ3JhdGlvbiBpcyBhdCB0aGUgbW9tZW50IC0gdGhhdCB3YXMgbW9zdGx5IENocmlzdG9waGVy
J3MgaGVhZGFjaGUgdG8KdHJhY2sgOy0pCgpGb3IgdGhpbmdzIGxpa2UgZ2Ric3R1YiB3ZSBuZWVk
IHRvIGFkZCBhZGRpdGlvbmFsIGhhbmRsaW5nLiBJIHN1c3BlY3QgYXMKd2UgY3VycmVudGx5IGRv
bid0IGV4cGxpY2l0bHkgaGFuZGxlIHRoZSBTVkUgcmVnaXN0ZXJzIHRoZXkgd29uJ3Qgc2hvdwp1
cCAtIEkgYmVsaWV2ZSB0aGVyZSBhcmUgcHJvdG9jb2wgdXBkYXRlcyBmb3IgYmV0dGVyIGhhbmRs
aW5nIHRoZXNlCnJlZ2lzdGVycyBjb21pbmcuCgpJIHRoaW5rIG1pZ3JhdGlvbiBzaG91bGQgd29y
ayBvdXQgb2YgdGhlIGJveCBidXQgSSdkIG5lZWQgdG8gZG91YmxlCmNoZWNrLiBDZXJ0YWlubHkg
aXRzIGEgc3Ryb25nIGFyZ3VtZW50IGZvciBnZXR0aW5nIFZIRSBkb25lIGluIFRDRyBtb2RlCmFz
IHdlIGNhbiBleGVyY2lzZSBhIGxvdCBvZiB0aGUgY29tbW9uIGNvZGUuCgo+Cj4gQ2hlZXJzCj4g
LS0tRGF2ZQoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
