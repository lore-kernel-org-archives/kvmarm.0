From: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Thu, 7 May 2015 12:50:50 +0200
Message-ID: <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
 <20150506141249.GA6796@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F18D450BC8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 06:42:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tTbHrv1pGsZT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2015 06:42:22 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26A6250B99
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 06:42:21 -0400 (EDT)
Received: by wicmx19 with SMTP id mx19so10762454wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 May 2015 03:51:10 -0700 (PDT)
In-Reply-To: <20150506141249.GA6796@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "open list:Overall" <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCBNYXkgNiwgMjAxNSBhdCA0OjEyIFBNLCBDaHJpc3RvZmZlciBEYWxsCjxjaHJpc3Rv
ZmZlci5kYWxsQGxpbmFyby5vcmc+IHdyb3RlOgo+IEhpIErDqXLDqW15LAo+Cj4gT24gVHVlLCBN
YXkgMDUsIDIwMTUgYXQgMTE6MTM6MTFBTSArMDIwMCwgSsOpcsOpbXkgRmFuZ3XDqGRlIHdyb3Rl
Ogo+PiBUbyBtYWludGFpbiBjYWNoZSBjb2hlcmVuY3kgb24gQVJNLCB3ZSBtYXkgbmVlZCBhIG1l
Y2hhbmlzbSB0byBmbHVzaAo+PiB0aGUgZGF0YSBjYWNoZS4KPgo+IEluIGFkZGl0aW9uIHRvIGdl
bmVyYWxseSBqdXN0IG1ha2luZyB0aGlzIGZ1bmN0aW9uYWxpdHkgYXZhaWxhYmxlIChzZWUKPiBi
ZWxvdyksIGRvIHlvdSBoYXZlIGFuIGFjdHVhbCB1c2UgY2FzZSBpbiBtaW5kIGZvciB0aGlzPyAg
VG8gc29sdmUgdGhlCj4gVkdBIGlzc3VlLCBmb3IgZXhhbXBsZSwgd2UgYWxyZWFkeSBoYXZlIGEg
cGF0Y2ggc2VyaWVzIGZyb20gRHJldyB0cnlpbmcKPiB0byBhZGRyZXNzIHRoaXMuICBEb2VzIHRo
YXQgbm90IHdvcmsgZm9yIHlvdT8KPgo+IFRoZXJlIHdhcyBhIGxvbmcgZGlzY3Vzc2lvbiBhYm91
dCB0aGlzIGhlcmU6Cj4gaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvcGlwZXJtYWlsL2t2
bWFybS8yMDE1LUZlYnJ1YXJ5LzAxMzU5My5odG1sCj4KPiBEcmV3IHRoZW4gY3JlYXRlZCBhIHBh
dGNoIHNldCwgaGVyZToKPiBodHRwczovL2xpc3RzLm5vbmdudS5vcmcvYXJjaGl2ZS9odG1sL3Fl
bXUtZGV2ZWwvMjAxNS0wMy9tc2cwMTI1NC5odG1sCj4KPiBhbmQgcmVwbGllZCB0byBoaW1zZWxm
LCBoZXJlOgo+IGh0dHBzOi8vd3d3Lm1hcmMuaW5mby8/bD1hbmRyb2lkLXZpcnQmbT0xNDI2NzA1
MjM5MjkxMzImdz0zCj4KPiBXaGljaCBiYXNpY2FsbHkgc2F5cyB0aGF0IGhlIGRvZXNuJ3QgbGlr
ZSBoYXZpbmcgdG8gZG8gZmx1c2hlcyBhbGwgb3Zlcgo+IFFFTVUgKElJVUMpLCBzbyBoZSBzZW50
IHRoaXMgdmVyc2lvbiBpbnN0ZWFkOgo+IGh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L3Bp
cGVybWFpbC9rdm1hcm0vMjAxNS1NYXJjaC8wMTQwMjcuaHRtbAo+Cj4gV2hpY2ggaGUgbm93IHNh
aWQgaGUnZCByZXNwaW4uCgpJbiBmYWN0LCBJIHVzZWQgdGhpcyBpb2N0bCBpbiBwYWlycyB3aXRo
IHRoaXMgUUVNVSBwYXRjaCBzZXJpZXM6Cmh0dHBzOi8vbGlzdHMubm9uZ251Lm9yZy9hcmNoaXZl
L2h0bWwvcWVtdS1kZXZlbC8yMDE1LTA1L21zZzAwNDA3Lmh0bWwKTXkgY3VycmVudCB3b3JrIGRv
ZXNuJ3QgZG8gYW55dGhpbmcgYWJvdXQgdmdhIHJhbSwgc28gdmdhIGlzc3VlCnByb2JhYmx5IHN0
aWxsIHBlcnNpc3RzLCBidXQgaXQgc29sdmVzIG90aGVycyBpc3N1ZXMgd2l0aCBzb21lCmVtdWxh
dGVkIGRldmljZXMgKG1haW5seSBQQ0kpIHdoaWNoIHdlcmUgZmFpbGluZyBiZWZvcmUgYW5kIG5v
dyB3b3JrCmZpbmUgd2l0aCB0aGlzIHBhdGNoLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
