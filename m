From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm64: fix misleading comments in save/restore
Date: Thu, 04 Jun 2015 11:34:17 +0100
Message-ID: <557029A9.1010303@arm.com>
References: <1432806186-27993-1-git-send-email-alex.bennee@linaro.org>
 <20150604093436.GC7657@cbox> <55702205.7000908@arm.com>
 <87eglrbwr2.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A27C52ED3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:24:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fh+uyoOtwjVu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2015 06:24:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D62952D18
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 06:24:18 -0400 (EDT)
In-Reply-To: <87eglrbwr2.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDQvMDYvMTUgMTE6MjAsIEFsZXggQmVubsOpZSB3cm90ZToKPiAKPiBNYXJjIFp5bmdpZXIg
PG1hcmMuenluZ2llckBhcm0uY29tPiB3cml0ZXM6Cj4gCj4+IE9uIDA0LzA2LzE1IDEwOjM0LCBD
aHJpc3RvZmZlciBEYWxsIHdyb3RlOgo+Pj4gT24gVGh1LCBNYXkgMjgsIDIwMTUgYXQgMTA6NDM6
MDZBTSArMDEwMCwgQWxleCBCZW5uw6llIHdyb3RlOgo+Pj4+IFRoZSBlbHJfZWwyIGFuZCBzcHNy
X2VsMiByZWdpc3RlcnMgaW4gZmFjdCBjb250YWluIHRoZSBwcm9jZXNzb3Igc3RhdGUKPj4+PiBi
ZWZvcmUgZW50cnkgaW50byB0aGUgaHlwZXJ2aXNvciBjb2RlLgo+Pj4KPj4+IGJlIGNhcmVmdWwg
d2l0aCB5b3VyIHVzZSBvZiB0aGUgaHlwZXJ2aXNvciwgaW4gdGhlIEtWTSBkZXNpZ24gdGhlCj4+
PiBoeXBlcnZpc29yIGlzIHNwbGl0IGFjcm9zcyBFTDEgYW5kIEVMMi4KPiAKPiAiYmVmb3JlIGVu
dHJ5IGludG8gRUwyLiIKPiAKPj4+Cj4+Pj4gSW4gdGhlIGNhc2Ugb2YgZ3Vlc3Qgc3RhdGUgaXQK
Pj4+PiBjb3VsZCBiZSBpbiBlaXRoZXIgZWwwIG9yIGVsMS4KPj4+Cj4+PiB0cnVlCj4+Pgo+Pj4+
Cj4+Pj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3Jn
Pgo+Pj4+IC0tLQo+Pj4+ICBhcmNoL2FybTY0L2t2bS9oeXAuUyB8IDggKysrKy0tLS0KPj4+PiAg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAuUyBiL2FyY2gvYXJtNjQva3ZtL2h5cC5T
Cj4+Pj4gaW5kZXggZDc1NTkyMi4uMTk0MGE0YyAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0
L2t2bS9oeXAuUwo+Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2h5cC5TCj4+Pj4gQEAgLTUwLDgg
KzUwLDggQEAKPj4+PiAgCXN0cAl4MjksIGxyLCBbeDMsICM4MF0KPj4+PiAgCj4+Pj4gIAltcnMJ
eDE5LCBzcF9lbDAKPj4+PiAtCW1ycwl4MjAsIGVscl9lbDIJCS8vIEVMMSBQQwo+Pj4+IC0JbXJz
CXgyMSwgc3Bzcl9lbDIJCS8vIEVMMSBwc3RhdGUKPj4+PiArCW1ycwl4MjAsIGVscl9lbDIJCS8v
IFBDIGJlZm9yZSBoeXAgZW50cnkKPj4+PiArCW1ycwl4MjEsIHNwc3JfZWwyCQkvLyBwc3RhdGUg
YmVmb3JlIGh5cCBlbnRyeQo+Pj4+ICAKPj4+PiAgCXN0cAl4MTksIHgyMCwgW3gzLCAjOTZdCj4+
Pj4gIAlzdHIJeDIxLCBbeDMsICMxMTJdCj4+Pj4gQEAgLTgyLDggKzgyLDggQEAKPj4+PiAgCWxk
cgl4MjEsIFt4MywgIzE2XQo+Pj4+ICAKPj4+PiAgCW1zcglzcF9lbDAsIHgxOQo+Pj4+IC0JbXNy
CWVscl9lbDIsIHgyMCAJCQkJLy8gRUwxIFBDCj4+Pj4gLQltc3IJc3Bzcl9lbDIsIHgyMSAJCQkJ
Ly8gRUwxIHBzdGF0ZQo+Pj4+ICsJbXNyCWVscl9lbDIsIHgyMCAJCS8vIFBDIHRvIHJlc3RvcmUK
Pj4+PiArCW1zcglzcHNyX2VsMiwgeDIxIAkJLy8gcHN0YXRlIHRvIHJlc3RvcmUKPj4+Cj4+PiBJ
IGRvbid0IGZlZWwgbGlrZSAndG8gcmVzdG9yZScgaXMgbXVjaCBtb3JlIG1lYW5pbmdmdWwgaGVy
ZS4KPj4+Cj4+PiBJIHdvdWxkIGFjdHVhbGx5IHZvdGUgZm9yIHJlbW92aW4gdGhlIGNvbW1lbnRz
IGFsbCB0b2dldGhlciwgc2luY2Ugb25lCj4+PiBzaG91bGQgcmVhbGx5IHVuZGVyc3RhbmQgdGhl
IGNvZGUgYXMgb3Bwb3NlZCB0byB0aGUgY29tbWVudHMgd2hlbgo+Pj4gcmVhZGluZyB0aGlzIGtp
bmQgb2Ygc3R1ZmYuCj4+Pgo+Pj4gTWVoLCBJJ20gbm90IHN1cmUuICBZb3VyIHBhdGNoIGlzIGRl
ZmluaXRlbHkgYmV0dGVyIHRoYW4gZG9pbmcgbm90aGluZy4KPj4+Cj4+PiBNYXJjPwo+Pgo+PiBX
aGlsZSBJIGRlZmluaXRlbHkgYWdyZWUgdGhhdCBwZW9wbGUgc2hvdWxkIHBheSBtb3JlIGF0dGVu
dGlvbiB0byB0aGUKPj4gY29kZSByYXRoZXIgdGhhbiBibGluZGx5IHRydXN0aW5nIGNvbW1lbnRz
LCBJIHN0aWxsIHRoaW5rIHRoZXJlIGlzIHNvbWUKPj4gdmFsdWUgaW4gZGlzYW1iaWd1YXRpbmcg
dGhlIGV4Y2VwdGlvbiBlbnRyeS9yZXR1cm4sIGJlY2F1c2UgdGhpcyBiaXQgb2YKPj4gY29kZSBh
c3N1bWVzIHNvbWUgaW50aW1hdGUga25vd2xlZGdlIG9mIHRoZSBBUk12OCBleGNlcHRpb24gbW9k
ZWwuCj4+Cj4+IEFzIGZvciB0aGUgY29tbWVudHMgdGhlbXNlbHZlcywgSSdkIHJhdGhlciBoYXZl
IHNvbWUgd29yZGluZyB0aGF0Cj4+IGNsZWFybHkgaW5kaWNhdGUgdGhhdCB3ZSdyZSBkZWFsaW5n
IHdpdGggZ3Vlc3QgaW5mb3JtYXRpb24sIGkuZToKPj4KPj4gCW1ycwl4MjAsIGVscl9lbDIJCS8v
IEd1ZXN0IFBDCj4+IAltcnMJeDIxLCBzcHNyX2VsMgkJLy8gR3Vlc3QgcHN0YXRlCj4+Cj4+IChh
bmQgdGhlIHNhbWUgZm9yIHRoZSBleGNlcHRpb24gcmV0dXJuKS4gVGhlICJiZWZvcmUgaHlwIGVu
dHJ5IiBhbmQgInRvCj4+IHJlc3RvcmUiIGFyZSBub3QgcmVhbGx5IHVzZWZ1bCAoYWxsIHRoZSBy
ZWdpc3RlcnMgd2UgYXJlCj4+IHNhdmluZy9yZXN0b3JpbmcgZmFsbCBpbnRvIHRoZXNlIGNhdGVn
b3JpZXMpLiBXaGF0IEkgd2FudGVkIHRvIGNvbnZleQo+PiBoZXJlIHdhcyB0aGF0IGRlc3BpdGUg
dXNpbmcgYW4gRUwyIHJlZ2lzdGVyLCB3ZSBhcmUgZGVhbGluZyB3aXRoIGd1ZXN0Cj4+IHJlZ2lz
dGVycy4KPiAKPiBXaGljaCB3b3VsZCBiZSBncmVhdCBpdCB3ZSB3ZXJlLiBIb3dldmVyIHRoZSBj
b2RlIGlzIHVzZWQgdG8KPiBzYXZlL3Jlc3RvcmUgdGhlIGhvc3QgY29udGV4dCBhcyB3ZWxsIGFz
IHRoZSBndWVzdCBjb250ZXh0IGhlbmNlIG15Cj4gd2Vhc2VseSB3b3Jkcy4gCgpHYWhoaC4gWW91
J3JlIHJpZ2h0LiBJJ20gc3BlbmRpbmcgdG9vIG11Y2ggdGltZSBvbiB0aGUgVkhFIGNvZGUgdGhl
c2UKZGF5cy4gR3Vlc3MgSSdsbCBzdGljayB0byB0aGUgd2Vhc2VsIHdvcmRzIHRoZW4uIENhbiB5
b3UgcmVzcGluIGl0IHdpdGgKQ2hyaXN0b2ZmZXIncyBjb21tZW50IGFkZHJlc3NlZD8KClRoYW5r
cywKCglNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
