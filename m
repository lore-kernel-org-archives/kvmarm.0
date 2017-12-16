From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v5 04/13] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Sat, 16 Dec 2017 12:51:19 +0800
Message-ID: <720fa5cc-93a9-8844-c2f3-83116a724d1b@huawei.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-5-james.morse@arm.com>
 <79ccc7df-802b-e25c-05cf-b1ecc7c05569@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 341C949D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 23:48:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SFnVlCATnREW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 23:48:09 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6190F406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 23:48:08 -0500 (EST)
In-Reply-To: <79ccc7df-802b-e25c-05cf-b1ecc7c05569@huawei.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjAxNy8xMi8xNiAxMjowOCwgZ2VuZ2RvbmdqaXUgd3JvdGU6Cj4gT24gMjAxNy8xMi8xNSAy
Mzo1MCwgSmFtZXMgTW9yc2Ugd3JvdGU6Cj4+ICsJY2FzZSBFU1JfRUx4X0FFVF9VRVI6CS8qIFVu
Y29ycmVjdGVkIFJlY292ZXJhYmxlICovCj4+ICsJCS8qCj4+ICsJCSAqIFRoZSBDUFUgY2FuJ3Qg
bWFrZSBwcm9ncmVzcy4gVGhlIGV4Y2VwdGlvbiBtYXkgaGF2ZQo+PiArCQkgKiBiZWVuIGltcHJl
Y2lzZS4KPj4gKwkJICovCj4+ICsJCXJldHVybiB0cnVlOwo+ICAgICAgICAgRm9yIFJlY292ZXJh
YmxlIGVycm9yIChVRVIpLCB0aGUgZXJyb3IgaGFzIG5vdCBiZWVuICBzaWxlbnRseSBwcm9wYWdh
dGVkLAo+ICAgICAgICAgYW5kIGhhcyBub3QgYmVlbiBhcmNoaXRlY3R1cmFsbHkgY29uc3VtZWQg
YnkgdGhlIFBFLCBhbmQKPiAgICAgICAgIFRoZSBleGNlcHRpb24gaXMgcHJlY2lzZSBhbmQgUEUg
Y2FuIHJlY292ZXIgZXhlY3V0aW9uIGZyb20gdGhlIHByZWZlcnJlZCByZXR1cm4gYWRkcmVzcyBv
ZiB0aGUgZXhjZXB0aW9uLgo+ICAgICAgICAgc28gSSBkbyBub3QgdGhpbmsgaXQgc2hvdWxkIGJl
IHBhbmljIGhlcmUgaWYgdGhlIFNFcnJvciBjb21lIGZyb20gdXNlciBzcGFjZSBpbnN0ZWFkIG9m
IGNvbWluZyBmcm9tIGtlcm5lbCBzcGFjZS4KCkkgcGFzdGUgdGhlIHNwZWMgZGVmaW5pdGlvbiBm
b3IgdGhlIFJlY292ZXJhYmxlIGVycm9yIChVRVIpIHdoaWNoIGdvdCBmcm9tIFswXQoKUmVjb3Zl
cmFibGUgZXJyb3IgKFVFUikKVGhlIHN0YXRlIG9mIHRoZSBQRSBpcyBSZWNvdmVyYWJsZSBpZiBh
bGwgb2YgdGhlIGZvbGxvd2luZyBhcmUgdHJ1ZToK4oCUIFRoZSBlcnJvciBoYXMgbm90IGJlZW4g
c2lsZW50bHkgcHJvcGFnYXRlZC4K4oCUIFRoZSBlcnJvciBoYXMgbm90IGJlZW4gYXJjaGl0ZWN0
dXJhbGx5IGNvbnN1bWVkIGJ5IHRoZSBQRS4gKFRoZSBQRSBhcmNoaXRlY3R1cmFsIHN0YXRlIGlz
IG5vdCBpbmZlY3RlZC4pCuKAlCBUaGUgZXhjZXB0aW9uIGlzIHByZWNpc2UgYW5kIFBFIGNhbiBy
ZWNvdmVyIGV4ZWN1dGlvbiBmcm9tIHRoZSBwcmVmZXJyZWQgcmV0dXJuIGFkZHJlc3Mgb2YgdGhl
IGV4Y2VwdGlvbiwgaWYgc29mdHdhcmUgbG9jYXRlcyBhbmQgcmVwYWlycyB0aGUgZXJyb3IuClRo
ZSBQRSBjYW5ub3QgbWFrZSBjb3JyZWN0IHByb2dyZXNzIHdpdGhvdXQgZWl0aGVyIGNvbnN1bWlu
ZyB0aGUgZXJyb3Igb3Igb3RoZXJ3aXNlIG1ha2luZyB0aGUgZXJyb3IgdW5yZWNvdmVyYWJsZS4g
VGhlIGVycm9yIHJlbWFpbnMgbGF0ZW50IGluIHRoZSBzeXN0ZW0uCgpJZiBzb2Z0d2FyZSBjYW5u
b3QgbG9jYXRlIGFuZCByZXBhaXIgdGhlIGVycm9yLCBlaXRoZXIgdGhlIGFwcGxpY2F0aW9uIG9y
IHRoZSBWTSwgb3IgYm90aCwgbXVzdCBiZSBpc29sYXRlZCBieSBzb2Z0d2FyZS4KClswXQpodHRw
czovL3N0YXRpYy5kb2NzLmFybS5jb20vZGRpMDU4Ny9hL1JBUyUyMEV4dGVuc2lvbi1yZWxlYXNl
JTIwY2FuZGlkYXRlX21hcmNoXzI5LnBkZgoKPj4gKwoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
