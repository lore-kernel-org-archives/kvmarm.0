From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v6 4/6] KVM: arm/arm64: enable irqchip routing
Date: Thu, 14 Jul 2016 11:36:12 +0200
Message-ID: <ac188535-d3be-f732-891a-1d0a248349e6@redhat.com>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
 <1467794875-5237-5-git-send-email-eric.auger@redhat.com>
 <20160707172052.5weyrjus3i3mgzik@hawk.localdomain>
 <11b05e3b-f3fd-aae3-b1e7-6ca9836cfc97@redhat.com>
 <20160708085233.qjptxd4qh7ukbgl3@hawk.localdomain>
 <20160708205543.GC10741@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51BD49B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 05:30:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjZ5BO1cSEIE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2016 05:30:23 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E23E49B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 05:30:23 -0400 (EDT)
In-Reply-To: <20160708205543.GC10741@potion>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

SGkgRHJldywgUmFkaW0sCgpPbiAwOC8wNy8yMDE2IDIyOjU1LCBSYWRpbSBLcsSNbcOhxZkgd3Jv
dGU6Cj4gMjAxNi0wNy0wOCAxMDo1MiswMjAwLCBBbmRyZXcgSm9uZXM6Cj4+IE9uIEZyaSwgSnVs
IDA4LCAyMDE2IGF0IDEwOjE2OjUzQU0gKzAyMDAsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+PiBPbiAw
Ny8wNy8yMDE2IDE5OjIwLCBBbmRyZXcgSm9uZXMgd3JvdGU6Cj4+Pj4gT24gV2VkLCBKdWwgMDYs
IDIwMTYgYXQgMTA6NDc6NTNBTSArMDIwMCwgRXJpYyBBdWdlciB3cm90ZToKPj4+Pj4gZGlmZiAt
LWdpdCBhL3ZpcnQva3ZtL2lycWNoaXAuYyBiL3ZpcnQva3ZtL2lycWNoaXAuYwo+Pj4+PiBAQCAt
MjksNyArMjksOSBAQAo+Pj4+PiAgI2luY2x1ZGUgPGxpbnV4L3NyY3UuaD4KPj4+Pj4gICNpbmNs
dWRlIDxsaW51eC9leHBvcnQuaD4KPj4+Pj4gICNpbmNsdWRlIDx0cmFjZS9ldmVudHMva3ZtLmg+
Cj4+Pj4+ICsjaWYgIWRlZmluZWQoQ09ORklHX0FSTSkgJiYgIWRlZmluZWQoQ09ORklHX0FSTTY0
KQo+Pj4+PiAgI2luY2x1ZGUgImlycS5oIgo+Pj4+PiArI2VuZGlmCj4+Pj4KPj4+PiBJbnN0ZWFk
IG9mIGRvaW5nIHRoaXMsIHNob3VsZG4ndCB3ZSBhZGQgYXJjaC9hcm1bNjRdL2t2bS9pcnEuaCBm
aWxlcy4KPj4+PiBQcm9iYWJseSBhIHNpbXBsZSBvbmUgbGlrZSAuL2FyY2gvczM5MC9rdm0vaXJx
LmggPwo+Pj4KPj4+IFdlbGwgSSBjb25zaWRlcmVkIHRoaXMgc29sdXRpb24gaW4gdGhlIHBhc3Qg
YnV0IEkgZGlkIG5vdCBmaW5kIG11Y2ggdG8KPj4+IHB1dCB0aGVyZSAoaXQgd2FzIGV2ZW4gdm9p
ZCkuIHR5cGljYWxseSBpcnFjaGlwX2luX2tlcm5lbCBpcyBpbgo+Pj4gaW5jbHVkZS9rdm0vYXJt
X3ZnaWMuaCBzaW5jZSB0aGUgbWFjcm8gY2FuIGJlIHNoYXJlZCBiZXR3ZWVuIGFybS9hcm02NC4K
Pj4KPj4gSSB0aGluayBJJ2QgcHJlZmVyIGEgbmVhcmx5IGVtcHR5IGZpbGUgdG8gdGhlICNpZmRl
ZidzLCBidXQgUGFvbG8gYW5kCj4+IFJhZGltIHNob3VsZCBjaGltZSBpbi4KPiAKPiBJIGNvbmN1
ciwgaGlkaW5nIHVnbGluZXNzIGluIGhlYWRlciBmaWxlcyBpcyB3aGF0IHdlIHN0cml2ZSBmb3Iu
Cj4gCj4gVGhlIGZpbGVzIGNvdWxkICNpbmNsdWRlIDxpbmNsdWRlL2t2bS9hcm1fdmdpYy5oPiwg
d2hpY2ggbWlnaHQgbWFrZQo+IHRoZWlyIGV4aXN0ZW5jZSBlYXNpZXIgdG8gdW5kZXJzdGFuZC4K
PiAKT2sgSSB3aWxsIGludHJvZHVjZSBpcnEuaCB3aGljaCBzdWNoIGluY2x1c2lvbiBvbiBBUk0v
QVJNNjQuCgpUaGFua3MKCkVyaWMKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
