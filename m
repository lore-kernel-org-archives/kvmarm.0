From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 32/56] KVM: arm/arm64: vgic-new: Add SGIPENDR register
 handlers
Date: Thu, 19 May 2016 16:09:54 +0200
Message-ID: <CAMJs5B-BbbKBH0Kkd-eu8=fdCQfxmYEhkPh+UcXZ0hemeCksLg@mail.gmail.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-33-git-send-email-andre.przywara@arm.com>
 <20160518131449.GI3827@cbox> <573C6EA6.90803@arm.com>
 <20160518135022.GL3827@cbox>
 <d2a62bb3-791a-b6d2-a41b-faa671f5e3f6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F0E413E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 10:06:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3wvfj7-YHLxa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 10:06:34 -0400 (EDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com
 [209.85.161.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7EA140FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 10:06:34 -0400 (EDT)
Received: by mail-yw0-f179.google.com with SMTP id g133so79011501ywb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 07:09:54 -0700 (PDT)
In-Reply-To: <d2a62bb3-791a-b6d2-a41b-faa671f5e3f6@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gVGh1LCBNYXkgMTksIDIwMTYgYXQgMzoyNSBQTSwgQW5kcmUgUHJ6eXdhcmEgPGFuZHJlLnBy
enl3YXJhQGFybS5jb20+IHdyb3RlOgo+IEhpLAo+Cj4gT24gMTgvMDUvMTYgMTQ6NTAsIENocmlz
dG9mZmVyIERhbGwgd3JvdGU6Cj4+IE9uIFdlZCwgTWF5IDE4LCAyMDE2IGF0IDAyOjMxOjE4UE0g
KzAxMDAsIEFuZHJlIFByenl3YXJhIHdyb3RlOgo+Pj4gSGksCj4+Pgo+Pj4gT24gMTgvMDUvMTYg
MTQ6MTQsIENocmlzdG9mZmVyIERhbGwgd3JvdGU6Cj4+Pj4gT24gTW9uLCBNYXkgMTYsIDIwMTYg
YXQgMTA6NTM6MjBBTSArMDEwMCwgQW5kcmUgUHJ6eXdhcmEgd3JvdGU6Cj4+Pj4+IEFzIHRoaXMg
cmVnaXN0ZXIgaXMgdjIgc3BlY2lmaWMsIGl0cyBpbXBsZW1lbnRhdGlvbiBsaXZlcyBlbnRpcmVs
eQo+Pj4+PiBpbiB2Z2ljLW1taW8tdjIuYy4KPj4+Pj4gVGhpcyByZWdpc3RlciBhbGxvd3Mgc2V0
dGluZyB0aGUgc291cmNlIG1hc2sgb2YgYW4gSVBJLgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5
OiBBbmRyZSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4KPj4+Pj4gUmV2aWV3ZWQt
Ynk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KPj4+Pj4g
LS0tCj4+Pj4+IENoYW5nZWxvZyBSRkMuLnYxOgo+Pj4+PiAtIHJlbW92ZSBJUlEgbG9jayBmcm9t
IHJlYWQgaGFuZGxlcgo+Pj4+PiAtIHVwZGF0ZSBwZW5kaW5nIGJpdCBvbiBzZXR0aW5nIHRoZSBm
aXJzdCAvIGNsZWFyaW5nIHRoZSBsYXN0IGJpdAo+Pj4+PiAtIHF1ZXVlIHZpcnR1YWwgSVJRIGlm
IG5lY2Vzc2FyeQo+Pj4+Pgo+Pj4+PiBDaGFuZ2Vsb2cgdjEgLi4gdjI6Cj4+Pj4+IC0gYWRhcHQg
dG8gbmV3IE1NSU8gZnJhbWV3b3JrCj4+Pj4+Cj4+Pj4+IENoYW5nZWxvZyB2MyAuLiB2NDoKPj4+
Pj4gLSBzcGVjaWZ5IGFjY2Vzc29yIHdpZHRoCj4+Pj4+Cj4+Pj4+ICB2aXJ0L2t2bS9hcm0vdmdp
Yy92Z2ljLW1taW8tdjIuYyB8IDYyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0KPj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQo+Pj4+Pgo+Pj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlv
LXYyLmMgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjIuYwo+Pj4+PiBpbmRleCBjODg0
ZTliLi4zOTI1ZDRjIDEwMDY0NAo+Pj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1t
aW8tdjIuYwo+Pj4+PiArKysgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjIuYwo+Pj4+
PiBAQCAtMTQ2LDYgKzE0Niw2NCBAQCBzdGF0aWMgdm9pZCB2Z2ljX21taW9fd3JpdGVfdGFyZ2V0
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPj4+Pj4gICAgfQo+Pj4+PiAgfQo+Pj4+Pgo+Pj4+PiAr
c3RhdGljIHVuc2lnbmVkIGxvbmcgdmdpY19tbWlvX3JlYWRfc2dpcGVuZChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsCj4+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdw
YV90IGFkZHIsIHVuc2lnbmVkIGludCBsZW4pCj4+Pj4+ICt7Cj4+Pj4+ICsgIHUzMiBpbnRpZCA9
IGFkZHIgJiAweDBmOwo+Pj4+Cj4+Pj4gaXMgdGhlcmUgYSByZWFzb24gd2h5IHdlIGNhbm5vdCB1
c2UgdGhlIG1hZ2ljIG1hY3JvIGhlcmU/Cj4+Pgo+Pj4gSSB3YXNuJ3Qgc3VyZSBhYm91dCB0aGlz
LCBiZWNhdXNlIGl0J3Mgbm90IGNvdmVyaW5nIGFsbCAxMDI0IGludGVycnVwdHMsCj4+PiBidXQg
anVzdCBTR0lzLCBzbyBpdCdzIGFsd2F5cyBmaXhlZCB0byAxNiBpbnRlcnJ1cHRzIMOhIDggYml0
cy4gVGhlCj4+PiBkZWZhdWx0IG1hc2sgd291bGQgYmUgdG9vIGJpZyBpbiB0aGlzIGNhc2UuCj4+
PiBJIGd1ZXNzIGl0IHdvdWxkIHdvcmsgYW55d2F5IGJlY2F1c2UgdGhpcyByZWdpb24gaXMgbGlt
aXRlZCB0byAxNiBieXRlcwo+Pj4gaW4gb3VyIGRlc2NyaXB0aW9uLCBzbyB3ZSBjb3VsZCB1c2Ug
dGhpcyBoZXJlIGFueXdheSB0byBtYWtlIGl0IG1vcmUKPj4+IGFsaWduZWQgd2l0aCB0aGUgb3Ro
ZXIgaGFuZGxlcnMsIG1heWJlIGFkZGluZyBhIGNvbW1lbnQgYWJvdXQgdGhlCj4+PiBkaWZmZXJl
bmNlPwo+Pj4KPj4gbWVoLCBlaXRoZXIgd2F5IHdvcmtzIGZvciBtZSBhY3R1YWxseSwgd2hhdGV2
ZXIgeW91IHByZWZlci4KPgo+IFNvIGZvciB0aGUgcmVjb3Jkczogd2UgY2FuJ3QgdXNlIHRoZSBt
YWNybyBoZXJlLCBzaW5jZSBpdCByZWxpZXMgb24KPiBtYXNraW5nIGFuZCB0aHVzIGEgY2VydGFp
biBhbGlnbm1lbnQsIHdoaWNoIHRoZSBTR0lQRU5EUiByZWdpc3RlcnMgZG8KPiBub3QgaGF2ZSAo
YmVpbmcgbWFwcGVkIHRvIDB4RjEwIGFuZCAweEYyMCwgcmVzcGVjdGl2ZWx5KS4gU28gdGhlCj4g
Y2FsY3VsYXRlZCBpbnRpZCB3b3VsZCBiZSBtdWNoIGhpZ2hlciB0aGFuIHRoZSBudW1iZXIgb2Yg
YWN0dWFsbHkKPiBhbGxvY2F0ZWQgaW50ZXJydXB0cyAtIHdpdGggYWxsIHRoZSBjb25zZXF1ZW5j
ZXMgOy0pCj4KQWgsIHllYWgsIGRpZG4ndCBzZWUgdGhhdCBvbmUgY29taW5nLiAgU29ycnkgZm9y
IG1ha2luZyB5b3Ugc3BlbmQgaGFsZgphIGRheSB0byBnaXZlIG1lIGFuIGFuc3dlciB0byBhIHNl
ZW1pbmdseSBpbm5vY2VudCBxdWVzdGlvbi4KCi1DaHJpc3RvZmZlcgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
