From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 04/13] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Fri, 05 Jan 2018 18:28:46 +0000
Message-ID: <5A4FC3DE.3010907@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-5-james.morse@arm.com>
 <79ccc7df-802b-e25c-05cf-b1ecc7c05569@huawei.com>
 <720fa5cc-93a9-8844-c2f3-83116a724d1b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D795049DAD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jan 2018 13:26:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hNHm90au+cKq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jan 2018 13:26:29 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9C249D2B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jan 2018 13:26:29 -0500 (EST)
In-Reply-To: <720fa5cc-93a9-8844-c2f3-83116a724d1b@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SGkgZ2VuZ2RvbmdqaXUsCgpPbiAxNi8xMi8xNyAwNDo1MSwgZ2VuZ2RvbmdqaXUgd3JvdGU6Cj4g
T24gMjAxNy8xMi8xNiAxMjowOCwgZ2VuZ2RvbmdqaXUgd3JvdGU6Cj4+IE9uIDIwMTcvMTIvMTUg
MjM6NTAsIEphbWVzIE1vcnNlIHdyb3RlOgo+Pj4gKwljYXNlIEVTUl9FTHhfQUVUX1VFUjoJLyog
VW5jb3JyZWN0ZWQgUmVjb3ZlcmFibGUgKi8KPj4+ICsJCS8qCj4+PiArCQkgKiBUaGUgQ1BVIGNh
bid0IG1ha2UgcHJvZ3Jlc3MuIFRoZSBleGNlcHRpb24gbWF5IGhhdmUKPj4+ICsJCSAqIGJlZW4g
aW1wcmVjaXNlLgo+Pj4gKwkJICovCj4+PiArCQlyZXR1cm4gdHJ1ZTsKCj4+ICAgICAgICAgRm9y
IFJlY292ZXJhYmxlIGVycm9yIChVRVIpLCB0aGUgZXJyb3IgaGFzIG5vdCBiZWVuICBzaWxlbnRs
eSBwcm9wYWdhdGVkLAo+PiAgICAgICAgIGFuZCBoYXMgbm90IGJlZW4gYXJjaGl0ZWN0dXJhbGx5
IGNvbnN1bWVkIGJ5IHRoZSBQRSwgYW5kCj4+ICAgICAgICAgVGhlIGV4Y2VwdGlvbiBpcyBwcmVj
aXNlIGFuZCBQRSBjYW4gcmVjb3ZlciBleGVjdXRpb24gZnJvbSB0aGUgcHJlZmVycmVkIHJldHVy
biBhZGRyZXNzIG9mIHRoZSBleGNlcHRpb24uCgo+PiAgICAgICAgIHNvIEkgZG8gbm90IHRoaW5r
IGl0IHNob3VsZCBiZSBwYW5pYyBoZXJlIGlmIHRoZSBTRXJyb3IgY29tZSBmcm9tIHVzZXIgc3Bh
Y2UgaW5zdGVhZCBvZiBjb21pbmcgZnJvbSBrZXJuZWwgc3BhY2UuCgonY29taW5nIGZyb20nIGRv
ZXNuJ3QgbWVhbiBhbiBhd2Z1bCBsb3QgdW5sZXNzIHdlIGtub3cgd2hhdCB0aGUgZXJyb3IgaXMu
ClRvIHJlcGVhdCB0aGUgZWFybGllciBleGFtcGxlcywgaXQgY291bGQgYmUgYSBmYXVsdCBpbiB0
aGUgcGFnZSB0YWJsZXMsIG9yIHBhZ2VzCnNoYXJlZCBiZXR3ZWVuIHByb2Nlc3NlcywgZS5nLiB0
aGUgdmRzbyBkYXRhIHBhZ2UuCgpJIGRvbid0IHdhbnQgdGhpcyBjcnVkZSBwYW5pYy9jb250aW51
ZSB0byBjb25zaWRlciBhbnl0aGluZyBvdGhlciB0aGFuIHRoZSBFU1IuCkxldHMga2VlcCBpdCBj
cnVkZSwgaXRzIGEgc3RvcC1nYXA6IGJvdGgga2VybmVsLWZpcnN0IGFuZCBmaXJtd2FyZS1maXJz
dCBjYW4gZG8KYSBiZXR0ZXIgam9iIC0gdGhpcyBpcyBqdXN0IHNvbWUgZ2x1ZSB0byBob2xkIHRo
aW5ncyB0b2dldGhlciB1bnRpbCB3ZSBoYXZlCm9uZS9ib3RoIGltcGxlbWVudGVkLgoKClsuLi5d
Cgo+IFJlY292ZXJhYmxlIGVycm9yIChVRVIpCj4gVGhlIHN0YXRlIG9mIHRoZSBQRSBpcyBSZWNv
dmVyYWJsZSBpZiBhbGwgb2YgdGhlIGZvbGxvd2luZyBhcmUgdHJ1ZToKPiDigJQgVGhlIGVycm9y
IGhhcyBub3QgYmVlbiBzaWxlbnRseSBwcm9wYWdhdGVkLgo+IOKAlCBUaGUgZXJyb3IgaGFzIG5v
dCBiZWVuIGFyY2hpdGVjdHVyYWxseSBjb25zdW1lZCBieSB0aGUgUEUuIChUaGUgUEUgYXJjaGl0
ZWN0dXJhbCBzdGF0ZSBpcyBub3QgaW5mZWN0ZWQuKQo+IOKAlCBUaGUgZXhjZXB0aW9uIGlzIHBy
ZWNpc2UgYW5kIFBFIGNhbiByZWNvdmVyIGV4ZWN1dGlvbiBmcm9tIHRoZSBwcmVmZXJyZWQgcmV0
dXJuIGFkZHJlc3Mgb2YgdGhlIGV4Y2VwdGlvbiwgaWYgc29mdHdhcmUgbG9jYXRlcyBhbmQgcmVw
YWlycyB0aGUgZXJyb3IuCgoKSXQncyB0aGlzIGJpdCB0aGF0IG1hZGUgbWUgZXJyIG9uIHRoZSBz
aWRlIG9mIGNhdXRpb24vcGFuaWMoKToKCj4gVGhlIFBFIGNhbm5vdCBtYWtlIGNvcnJlY3QgcHJv
Z3Jlc3Mgd2l0aG91dCBlaXRoZXIgY29uc3VtaW5nIHRoZSBlcnJvciBvcgo+IG90aGVyd2lzZSBt
YWtpbmcgdGhlIGVycm9yIHVucmVjb3ZlcmFibGUuIFRoZSBlcnJvciByZW1haW5zIGxhdGVudCBp
biB0aGUgc3lzdGVtLgoKV2l0aG91dCBmaXJtd2FyZS1maXJzdCBvciBrZXJuZWwtZmlyc3Qgd2Ug
Y2FuJ3Qga25vdyB3aGVyZSB0aGUgZXJyb3IgaXMuIFdoYXQKc2hvdWxkIHdlIGRvPzoKCj4gSWYg
c29mdHdhcmUgY2Fubm90IGxvY2F0ZSBhbmQgcmVwYWlyIHRoZSBlcnJvciwgZWl0aGVyIHRoZSBh
cHBsaWNhdGlvbiBvciB0aGUKPiBWTSwgb3IgYm90aCwgbXVzdCBiZSBpc29sYXRlZCBieSBzb2Z0
d2FyZS4KCgpUaGFua3MsCgpKYW1lcwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
