From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 03/10] arm/arm64: smp: support more than
 8 cpus
Date: Mon, 06 Jun 2016 18:28:57 +0100
Message-ID: <87ziqygrae.fsf@linaro.org>
References: <20160606163238.GB23505@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C63412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 13:24:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ygoHfdbluqcc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2016 13:24:34 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0454410B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 13:24:34 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id m124so81612253wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2016 10:28:44 -0700 (PDT)
In-reply-to: <20160606163238.GB23505@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Ck1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+IHdyaXRlczoKCj4gT24gTW9uLCBK
dW4gMDYsIDIwMTYgYXQgMDU6MjI6NDlQTSArMDEwMCwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiBB
bmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4gd3JpdGVzOgo+PiA+ICsjZGVmaW5lIE1Q
SURSX0xFVkVMX1NISUZUKGxldmVsKSBcCj4+ID4gKwkoKCgxIDw8IGxldmVsKSA+PiAxKSA8PCAz
KQo+PiA+ICsjZGVmaW5lIE1QSURSX0FGRklOSVRZX0xFVkVMKG1waWRyLCBsZXZlbCkgXAo+PiA+
ICsJKChtcGlkciA+PiBNUElEUl9MRVZFTF9TSElGVChsZXZlbCkpICYgMHhmZikKPj4KPj4gRG9l
c24ndCBBZmYzIGJyZWFrIHRoaXMgbGl0dGxlIG1hY3JvPyBJdCBzaXRzIGF0IDMyOjM5IHdpdGgg
YSBnYXAgZm9yCj4+IE1ULCBSRVMwLCBVLCBSRVMxIGZvciBiaXRzIDI1OjMxCj4KPiBJdCB3b3Jr
cywgaXQncyBqdXN0IGEgbGl0dGxlIGJpdCBtYWdpYzoKCkFoaCB0aGUgbWFnaWMgd2FzIHRvbyBz
dWJ0bGUgZm9yIG15IGV5ZXMsIHBlcmhhcHMgYSBjb21tZW50IGZvciB0aGUKd2FyeS4KCj4KPiAo
Z2RiKSBwICgoKDEgPDwgMCkgPj4gMSkgPDwgMykKPiAkMSA9IDAKPiAoZ2RiKSBwICgoKDEgPDwg
MSkgPj4gMSkgPDwgMykKPiAkMiA9IDgKPiAoZ2RiKSBwICgoKDEgPDwgMikgPj4gMSkgPDwgMykK
PiAkMyA9IDE2Cj4gKGdkYikgcCAoKCgxIDw8IDMpID4+IDEpIDw8IDMpCj4gJDQgPSAzMgo+IChn
ZGIpCj4KPiBXZSBkbyB0aGUgc2FtZSBpbiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdXR5cGUu
aCBzaW5jZSBiMDU4NDUwZjM4YzMzN2QxCj4gKCJhcm02NDoga2VybmVsOiBhZGQgTVBJRFJfRUwx
IGFjY2Vzc29ycyBtYWNyb3MiKS4KCkkgc2VlIHRoZSB0cnV0aCBvZiBpdCA7LSkKPgo+IFRoYW5r
cywKPiBNYXJrLgoKCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
