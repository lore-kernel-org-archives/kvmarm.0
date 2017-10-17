From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 24/28] arm64/sve: KVM: Hide SVE from CPU features
 exposed to guests
Date: Tue, 17 Oct 2017 15:29:36 +0100
Message-ID: <2c6d9aa4-f6a8-2c6b-4138-e07d773bf4a2@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-25-git-send-email-Dave.Martin@arm.com>
 <20171017135816.GF5886@lvm>
 <20171017140749.GW19485@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3093849D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:28:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLbjsj3VtWwM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 10:28:46 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A92C740638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:28:46 -0400 (EDT)
In-Reply-To: <20171017140749.GW19485@e103592.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, Christoffer Dall <cdall@linaro.org>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTcvMTAvMTcgMTU6MDcsIERhdmUgTWFydGluIHdyb3RlOgo+IE9uIFR1ZSwgT2N0IDE3LCAy
MDE3IGF0IDA2OjU4OjE2QU0gLTA3MDAsIENocmlzdG9mZmVyIERhbGwgd3JvdGU6Cj4+IE9uIFR1
ZSwgT2N0IDEwLCAyMDE3IGF0IDA3OjM4OjQxUE0gKzAxMDAsIERhdmUgTWFydGluIHdyb3RlOgo+
Pj4gS1ZNIGd1ZXN0cyBjYW5ub3QgY3VycmVudGx5IHVzZSBTVkUsIGJlY2F1c2UgU1ZFIGlzIGFs
d2F5cwo+Pj4gY29uZmlndXJlZCB0byB0cmFwIHRvIEVMMi4KPj4+Cj4+PiBIb3dldmVyLCBhIGd1
ZXN0IHRoYXQgc2VlcyBTVkUgcmVwb3J0ZWQgYXMgcHJlc2VudCBpbgo+Pj4gSURfQUE2NFBGUjBf
RUwxIG1heSBsZWdpdGltYXRlbHkgZXhwZWN0IHRoYXQgU1ZFIHdvcmtzIGFuZCB0cnkgdG8KPj4+
IHVzZSBpdC4gIEluc3RlYWQgb2Ygd29ya2luZywgdGhlIGd1ZXN0IHdpbGwgcmVjZWl2ZSBhbiBp
bmplY3RlZAo+Pj4gdW5kZWYgZXhjZXB0aW9uLCB3aGljaCBtYXkgY2F1c2UgdGhlIGd1ZXN0IHRv
IG9vcHMgb3IgZ28gaW50byBhCj4+PiBzcGluLgo+Pj4KPj4+IFRvIGF2b2lkIG1pc2xlYWRpbmcg
dGhlIGd1ZXN0IGludG8gYmVsaWV2aW5nIHRoYXQgU1ZFIHdpbGwgd29yaywKPj4+IHRoaXMgcGF0
Y2ggbWFza3Mgb3V0IHRoZSBTVkUgZmllbGQgZnJvbSBJRF9BQTY0UEZSMF9FTDEgd2hlbiBhCj4+
PiBndWVzdCBhdHRlbXB0cyB0byByZWFkIHRoaXMgcmVnaXN0ZXIuICBObyBzdXBwb3J0IGlzIGV4
cGxpY2l0bHkKPj4+IGFkZGVkIGZvciBJRF9BQTY0WkZSMF9FTDEgZWl0aGVyLCBzbyB0aGF0IGlz
IHN0aWxsIGVtdWxhdGVkIGFzCj4+PiByZWFkaW5nIGFzIHplcm8sIHdoaWNoIGlzIGNvbnNpc3Rl
bnQgd2l0aCBTVkUgbm90IGJlaW5nCj4+PiBpbXBsZW1lbnRlZC4KPj4+Cj4+PiBUaGlzIGlzIGEg
dGVtcG9yYXJ5IG1lYXN1cmUsIGFuZCB3aWxsIGJlIHJlbW92ZWQgaW4gYSBsYXRlciBzZXJpZXMK
Pj4+IHdoZW4gZnVsbCBLVk0gc3VwcG9ydCBmb3IgU1ZFIGlzIGltcGxlbWVudGVkLgo+Pj4KPj4+
IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgo+Pj4gUmV2
aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4+IENjOiBN
YXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgo+Pj4gLS0tCj4+PiAgYXJjaC9hcm02
NC9rdm0vc3lzX3JlZ3MuYyB8IDEyICsrKysrKysrKysrLQo+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAx
MSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4+PiBpbmRl
eCBiMWY3NTUyLi5hMGVlOWIwIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3Jl
Z3MuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+Pj4gQEAgLTIzLDYgKzIz
LDcgQEAKPj4+ICAjaW5jbHVkZSA8bGludXgvYnNlYXJjaC5oPgo+Pj4gICNpbmNsdWRlIDxsaW51
eC9rdm1faG9zdC5oPgo+Pj4gICNpbmNsdWRlIDxsaW51eC9tbS5oPgo+Pj4gKyNpbmNsdWRlIDxs
aW51eC9wcmludGsuaD4KPj4+ICAjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgo+Pj4gIAo+Pj4g
ICNpbmNsdWRlIDxhc20vY2FjaGVmbHVzaC5oPgo+Pj4gQEAgLTg5Nyw4ICs4OTgsMTcgQEAgc3Rh
dGljIHU2NCByZWFkX2lkX3JlZyhzdHJ1Y3Qgc3lzX3JlZ19kZXNjIGNvbnN0ICpyLCBib29sIHJh
eikKPj4+ICB7Cj4+PiAgCXUzMiBpZCA9IHN5c19yZWcoKHUzMilyLT5PcDAsICh1MzIpci0+T3Ax
LAo+Pj4gIAkJCSAodTMyKXItPkNSbiwgKHUzMilyLT5DUm0sICh1MzIpci0+T3AyKTsKPj4+ICsJ
dTY0IHZhbCA9IHJheiA/IDAgOiByZWFkX3Nhbml0aXNlZF9mdHJfcmVnKGlkKTsKPj4+ICAKPj4+
IC0JcmV0dXJuIHJheiA/IDAgOiByZWFkX3Nhbml0aXNlZF9mdHJfcmVnKGlkKTsKPj4+ICsJaWYg
KGlkID09IFNZU19JRF9BQTY0UEZSMF9FTDEpIHsKPj4+ICsJCWlmICh2YWwgJiAoMHhmVUwgPDwg
SURfQUE2NFBGUjBfU1ZFX1NISUZUKSkKPj4+ICsJCQlwcl9lcnJfb25jZSgia3ZtIFslaV06IFNW
RSB1bnN1cHBvcnRlZCBmb3IgZ3Vlc3RzLCBzdXBwcmVzc2luZ1xuIiwKPj4+ICsJCQkJICAgIHRh
c2tfcGlkX25yKGN1cnJlbnQpKTsKPj4KPj4gbml0OiBkb2VzIHRoaXMgcmVhbGx5IHF1YWxpZnkg
YXMgYW4gZXJyb3IgcHJpbnQ/Cj4gCj4gSSBoYXZlIG5vIHN0cm9uZyBvcGluaW9uIG9uIHRoaXM6
IG1heiBzdWdnZXN0ZWQgSSBzaG91bGQgYWRkIHRoaXMgLS0KPiBoaXMgY29uY2VybiB3YXMgdG8g
bWFrZSBpdCBkaWZmaWN1bHQgdG8gaWdub3JlLgo+IAo+IFRoaXMgaXMgdHJhbnNpdGlvbmFsOiB0
aGUgbWFpbiBwdXJwb3NlIGlzIHRvIGNpcmN1bXZlbnQgYnVnIHJlcG9ydHMgZnJvbQo+IHBlb3Bs
ZSB3aG8gZmluZCB0aGF0IFNWRSBkb2Vzbid0IHdvcmsgaW4gdGhlaXIgZ3Vlc3RzLCBpbiB0aGUg
aW50ZXJpbQo+IGJlZm9yZSBwcm9wZXIgS1ZNIHN1cHBvcnQgbGFuZHMgdXBzdHJlYW0uCj4gCj4g
TWFyYywgZG8geW91IHN0aWxsIGFncmVlIHdpdGggdGhpcyBwb3NpdGlvbj8KCkFzIGxvbmcgYXMg
dGhpcyBpcyB0cmFuc2l0aW9uYWwsIEknbSBPSyB3aXRoIHRoaXMuCgoJTS4KLS0gCkphenogaXMg
bm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
