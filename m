From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and
 arm64 debug
Date: Sun, 22 Oct 2017 09:44:18 +0200
Message-ID: <20171022074418.GA3805@cbox>
References: <20171020232525.7387-1-pbonzini@redhat.com>
 <20171021184545.2497-1-christoffer.dall@linaro.org>
 <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B13749D25
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Oct 2017 03:43:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OAoMoOtBLOz9 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Oct 2017 03:43:10 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02F6E40638
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Oct 2017 03:43:09 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id r68so4457526wmr.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Oct 2017 00:44:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGXu5jKJ2jPz2540ZLCwmcdVZxrgnhVPHs0uumiJm2o0ZgpVag@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kees Cook <keescook@chromium.org>
Cc: KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gU2F0LCBPY3QgMjEsIDIwMTcgYXQgMDg6MDY6MTBQTSAtMDcwMCwgS2VlcyBDb29rIHdyb3Rl
Ogo+IE9uIFNhdCwgT2N0IDIxLCAyMDE3IGF0IDExOjQ1IEFNLCBDaHJpc3RvZmZlciBEYWxsCj4g
PGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JvdGU6Cj4gPiBXZSBkbyBkaXJlY3QgdXNl
cmFjY2VzcyBjb3B5aW5nIHRvIHRoZSBrdm1fY3B1X2NvbnRleHQgc3RydWN0dXJlCj4gPiBlbWJl
ZGRlZCBpbiB0aGUga3ZtX3ZjcHVfYXJjaCBzdHJ1Y3R1cmUsIGFuZCB0byB0aGUgdmNwdSBkZWJ1
ZyByZWdpc3Rlcgo+ID4gc3RhdGUuICBFdmVyeXRoaW5nIGVsc2UgKHRpbWVyLCBQTVUsIHZnaWMp
IGdvZXMgdGhyb3VnaCBhIHRlbXBvcmFyeQo+ID4gaW5kaXJlY3Rpb24uCj4gCj4gQXJlIHRoZXNl
IGNvcGllcyBkb25lIHdpdGggYSBkeW5hbWljIHNpemU/IFRoZSBub3JtYWwgd2F5IHRoZXNlIGdl
dAo+IHdoaXRlbGlzdGVkIGlzIHZpYSBidWlsdGluX2NvbnN0IHNpemVzIG9uIHRoZSBjb3B5LiBM
b29raW5nIGF0Cj4gS1ZNX1JFR19TSVpFKCksIHRob3VnaCwgaXQgc2VlbXMgdGhhdCB3b3VsZCBi
ZSBhIGR5bmFtaWMgY2FsY3VsYXRpb24uCj4gCgpJdCdzIHN1cGVyIGNvbmZ1c2luZywgYnV0IGl0
J3MgYWN0dWFsbHkgc3RhdGljLgoKV2UgY2FuIG9ubHkgZ2V0IHRvIHRoZWUgZnVuY3Rpb25zIHZp
YSBrdm1fYXJtX3N5c19yZWdfZ2V0X3JlZygpIGFuZAprdm1fYXJtX3N5c19yZWdfc2V0X3JlZygp
LCBhbmQgdGhleSBib3RoIGRvCgoJaWYgKEtWTV9SRUdfU0laRShyZWctPmlkKSAhPSBzaXplb2Yo
X191NjQpKSIKCQlyZXR1cm4gLUVOT0VOVDsKClNvIHRoaXMgaXMgYWx3YXlzIGEgdTY0IGNvcHku
ICBIb3dldmVyLCBJIHRoaW5rIGl0J3MgbXVjaCBjbGVhcmVyIGlmIEkKcmV3cml0ZSB0aGVzZSB0
byB1c2UgZ2V0X3VzZXIoKSBhbmQgcHV0X3VzZXIoKS4gIHYyIGluY29taW5nLgoKPiA+IEZpeGlu
ZyBhbGwgYWNjZXNzZXMgdG8ga3ZtX2NwdV9jb250ZXh0IGlzIG1hc3NpdmVseSBpbnZhc2l2ZSwg
YW5kIHdlJ2QKPiA+IGxpa2UgdG8gYXZvaWQgdGhhdCwgc28gd2UgdGVsbCBrdm1faW5pdF91c2Vy
Y29weSB0byB3aGl0ZWxpc3QgYWNjZXNzZXMKPiA+IHRvIG91dCBjb250ZXh0IHN0cnVjdHVyZS4K
PiA+Cj4gPiBUaGUgZGVidWcgc3lzdGVtIHJlZ2lzdGVyIGFjY2Vzc2VzIG9uIGFybTY0IGFyZSBt
b2RpZmllZCB0byB3b3JrIHRocm91Z2gKPiA+IGFuIGluZGlyZWN0aW9uIGluc3RlYWQuCj4gPgo+
ID4gQ2M6IGtlcm5lbC1oYXJkZW5pbmdAbGlzdHMub3BlbndhbGwuY29tCj4gPiBDYzogS2VlcyBD
b29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+Cj4gPiBDYzogUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT4KPiA+IENjOiBSYWRpbSBLcsSNbcOhxZkgPHJrcmNtYXJAcmVkaGF0LmNv
bT4KPiA+IENjOiBNYXJjIFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgo+ID4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgo+
ID4gLS0tCj4gPiBUaGlzIGZpeGVzIEtWTS9BUk0gb24gdG9kYXkncyBsaW51eCBuZXh0IHdpdGgg
Q09ORklHX0hBUkRFTkVEX1VTRVJDT1BZLgo+ID4KPiA+IFRoZSBwYXRjaCBpcyBiYXNlZCBvbiBs
aW51eC1uZXh0IHBsdXMgUGFvbG8ncyB4ODYgcGF0Y2ggd2hpY2ggaW50cm9kdWNlcwo+ID4ga3Zt
X2luaXRfdXNlcmNvcHkuICBOb3Qgc3VyZSBob3cgdGhpcyBuZWVkcyB0byBnZXQgbWVyZ2VkLCBi
dXQgaXQgd291bGQKPiA+IHBvdGVudGlhbGx5IG1ha2Ugc2Vuc2UgZm9yIFBhb2xvIHRvIHB1dCB0
b2dldGhlciBhIHNldCBvZiB0aGUgcGF0Y2hlcwo+ID4gbmVlZGVkIGZvciB0aGlzLgo+IAo+IEkg
d2FzIHBsYW5uaW5nIHRvIGNhcnJ5IFBhb2xvJ3MgcGF0Y2hlcywgYW5kIEkgY2FuIHRha2UgdGhp
cyBvbmUgdG9vLgoKU291bmRzIGdvb2QgdG8gbWUuCgo+IElmIHRoaXMgcG9zZXMgYSBwcm9ibGVt
LCB0aGVuIEkgY291bGQganVzdCBkbyBhIHR3by1waGFzZSBjb21taXQgb2YKPiB0aGUgd2hpdGVs
aXN0aW5nIGNvZGUsIGxlYXZpbmcgdGhlIHZlcnkgbGFzdCBjb21taXQgKHdoaWNoIGVuYWJsZXMg
dGhlCj4gZGVmZW5zZSBmb3IgYW55dGhpbmcgbm90IHlldCB3aGl0ZWxpc3RlZCksIHVudGlsIHRo
ZSBLVk0gdHJlZXMgbGFuZC4KPiAKPiBXaGF0J3MgcHJlZmVycmVkPwoKQXNzdW1pbmcgdGhlcmUn
cyBhbiBhY2sgZnJvbSBNYXJjIFp5bmdpZXIgb24gdjIgb2YgdGhpcyBwYXRjaCwgSSBwcmVmZXIK
eW91IGp1c3QgdGFrZSB0aGVtIGFzIHBhcnQgb2YgeW91ciBzZXJpZXMuCgo+IAo+IFRoYW5rcyBm
b3IgbG9va2luZyBhdCB0aGlzIQo+IApObyBwcm9ibGVtLAotQ2hyaXN0b2ZmZXIKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
