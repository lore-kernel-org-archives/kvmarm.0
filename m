From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v7 7/7] KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
Date: Fri, 22 Jul 2016 15:39:37 +0200
Message-ID: <20160722133937.GA11512@potion>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-8-git-send-email-eric.auger@redhat.com>
 <20160721163341.GE32739@potion>
 <9fa6bc46-6711-5825-48a3-1de5262ee34f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 725FC49B51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 09:33:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cuf5TG1qGWgW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 09:33:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9D3449B42
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 09:33:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <9fa6bc46-6711-5825-48a3-1de5262ee34f@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

MjAxNi0wNy0yMSAyMzoxMCswMjAwLCBBdWdlciBFcmljOgo+IE9uIDIxLzA3LzIwMTYgMTg6MzMs
IFJhZGltIEtyxI1tw6HFmSB3cm90ZToKPj4gMjAxNi0wNy0xOCAxMzoyNSswMDAwLCBFcmljIEF1
Z2VyOgo+Pj4gSWYgdGhlIElUUyBtb2RhbGl0eSBpcyBub3QgYXZhaWxhYmxlLCBsZXQncyBzaW1w
bHkgc3VwcG9ydCBNU0kKPj4+IGluamVjdGlvbiBieSB0cmFuc2Zvcm1pbmcgdGhlIE1TSS5kYXRh
IGludG8gYW4gU1BJIElELgo+Pj4KPj4+IFRoaXMgYmVjb21lcyBwb3NzaWJsZSB0byB1c2UgS1ZN
X1NJR05BTF9NU0kgaW9jdGwgYW5kIE1TSQo+Pj4gcm91dGluZyBmb3IgYXJtIHRvby4KPj4+Cj4+
PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Pgo+
Pj4gLS0tCj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pcnFmZC5jIGIv
dmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pcnFmZC5jCj4+PiArc3RhdGljIGludCB2Z2ljX3YybV9p
bmplY3RfbXNpKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9tc2kgKm1zaSkKPj4+ICt7Cj4+
PiArCWlmIChtc2ktPmZsYWdzICYgS1ZNX01TSV9WQUxJRF9ERVZJRCkKPj4+ICsJCXJldHVybiAt
RUlOVkFMOwo+Pj4gKwlpZiAoIXZnaWNfdmFsaWRfc3BpKGt2bSwgbXNpLT5kYXRhKSkKPj4+ICsJ
CXJldHVybiAtRUlOVkFMOwo+Pj4gKwo+Pj4gKwlyZXR1cm4ga3ZtX3ZnaWNfaW5qZWN0X2lycShr
dm0sIDAsIG1zaS0+ZGF0YSwgMSk7Cj4+IAo+PiBIbSwgdGhpcyBpc24ndCB2ZXJ5IE1TSSByZWxh
dGVkIC4uLgo+PiAKPj4gYXJtIGFscmVhZHkgaGFzIEtWTV9JUlFfTElORS9rdm1fdm1faW9jdGxf
aXJxX2xpbmUgd2l0aAo+PiBLVk1fQVJNX0lSUV9UWVBFX1NQSSB0aGF0IGRvZXMKPj4gICBrdm1f
dmdpY19pbmplY3RfaXJxKGt2bSwgMCwgaXJxX251bSwgbGV2ZWwpCj4+IAo+PiBJcyB0aGF0IGlu
dGVyZmFjZSBsYWNraW5nPwo+IAo+IFlvdSBtZWFuIEtWTV9TSUdOQUxfTVNJPyBXZWxsIGF0IFFF
TVUgbGV2ZWwsIGZvciBBUk0vQVJNNjQgaXMgZG9lc24ndC4KCk5vLCBJIG1lYW50IEtWTV9JUlFf
TElORSwgdGhlIG9uZSB0aGF0IGlzIHVzZWQgdG8gZGVsaXZlciBTUEkgdG9kYXkuCk9yIGlzbid0
IGl0PwoKPiBGb3Iga3ZtLXRvb2xzIEkgZ3Vlc3MsIEFuZHJlIG1hbmFnZXMgd2l0aG91dC4KPiAK
PiBNeSBmaXJzdCBmZWVsaW5nIHdhcyBpdCBpcyBwYXJ0IG9mIHRoZSBLVk0gQVBJIGFuZCB3ZSBj
YW4gaW1wbGVtZW50IGl0Cj4gZWFzaWx5IGZvciBHSUN2Mk0sIGFzIHdlIGRvIGZvciBHSUN2MyBJ
VFMgLiBUaGlzIGNhbiBhdm9pZCBhIHVzZXIgYXBwIHRvCj4gZG8gd2hhdCBRRU1VIGltcGxlbWVu
dHMgYXMgImt2bV9nc2lfZGlyZWN0X21hcHBpbmciIGFuZCBtYW5hZ2UgdGhlCj4gdHJhbnNsYXRp
b24gaW50byB0aGUgc2VtYW50aWMgb2YgdGhlIEFSTSBHU0kuCgpJIHRoaW5rIHRoYXQgcmV1c2lu
ZyBLVk1fU0lHTkFMX01TSSBhbmQgS1ZNX0lSUV9ST1VUSU5HX01TSSBmb3IgU1BJIGlzCnVuZm9y
dHVuYXRlLgoKU1BJIG9ubHkgdXNlcyBtc2kuZGF0YSwgd2hpY2ggbWFrZXMgcmVtYWluaW5nIGZp
ZWxkcyBpbiB0aGUgbXNpIHN0cnVjdAphcmJpdHJhcnkgYW5kIFs1LzddIGRlZmluZWQgS1ZNX0lS
UV9ST1VUSU5HX0lSUUNISVAgZm9yIFNQSSwgc28gdHdvCnJvdXRlIHR5cGVzIG5vdyBkbyB0aGUg
c2FtZSwgYnV0IG9ubHkgc29tZXRpbWVzICh3aXRob3V0IElUUyksIHdoaWNoCm1ha2VzIHRoZSBz
aXR1YXRpb24gZXZlbiBsZXNzIHVuZGVyc3RhbmRhYmxlIC4uLgoKRGVsaXZlcmluZyBTUEkgYXMg
S1ZNX0lSUV9ST1VUSU5HX0lSUUNISVAgc2VlbXMgbW9yZSBzZW5zaWJsZSBhbmQgaWYgd2UKd2Fu
dGVkIGFkLWhvYyBkZWxpdmVyeSBvZiBLVk1fSVJRX1JPVVRJTkdfSVJRQ0hJUCwgdGhlbiBJIHdv
dWxkIHByZWZlciBhCm5ldyBpbnRlcmZhY2UgdG8gdHdvIGRpZmZlcmVudCBtZWFuaW5ncyBmb3Ig
S1ZNX1NJR05BTF9NU0k6CktWTV9TSUdOQUxfTVNJIHdhcyBjcmVhdGVkIGJlY2F1c2Ugd2UgZGlk
bid0IGhhdmUgYW55dGhpbmcgdGhhdCBjb3VsZAppbmplY3QgYW4gaW50ZXJydXB0IHdpdGhvdXQg
c2V0dGluZyB1cCBhIHJvdXRlIHdpdGggS1ZNX1NFVF9HU0lfUk9VVElORwphbmQgd2UgYXJlIHN0
aWxsIG1pc3NpbmcgYSBnZW5lcmljIGludGVyZmFjZSB0byBkbyB0aGF0LgoKPiBCdXQgV2VsbCwg
aWYgeW91IHByZWZlciB3ZSBkbyBub3QgaW1wbGVtZW50IGl0IGZvciBHSUN2Mk0sIHNpbmNlCj4g
Y29uc2lkZXJlZCBhcyBmYXIgZmV0Y2hlZCBJIGNhbiByZW1vdmUgdGhpcyBwYXRjaC4KCkkgZG8s
IHRoYW5rcy4gIERvY3VtZW50YXRpb24gaW4gWzYvN10gd2FzIGFoZWFkIGFuZCBuZWVkcyBjaGFu
Z2luZyB0aGVuLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
