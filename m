From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm: warning at virt/kvm/arm/vgic.c:1468
Date: Sun, 15 Feb 2015 13:37:15 +0000
Message-ID: <87wq3je1o4.fsf@why.wild-wind.fr.eu.org>
References: <54D714B9.6090106@web.de> <20150213044613.GA47577@lvm>
 <87k2zms4ub.fsf@linaro.org> <87iof6s3o7.fsf@linaro.org>
 <54E05E8A.5020109@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C943745993
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Feb 2015 08:32:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f0gQ8WjF3lHs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Feb 2015 08:32:23 -0500 (EST)
Received: from usa-sjc-mx-foss1.foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B97A74579A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Feb 2015 08:32:23 -0500 (EST)
In-Reply-To: <54E05E8A.5020109@web.de> (Jan Kiszka's message of "Sun, 15 Feb
 2015 08:53:30 +0000")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

T24gU3VuLCBGZWIgMTUgMjAxNSBhdCAgODo1MzozMCBhbSBHTVQsIEphbiBLaXN6a2EgPGphbi5r
aXN6a2FAd2ViLmRlPiB3cm90ZToKPiBPbiAyMDE1LTAyLTEzIDA3OjUzLCBBbGV4IEJlbm7DqWUg
d3JvdGU6Cj4+IAo+PiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+IHdyaXRl
czoKPj4gCj4+PiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5vcmc+
IHdyaXRlczoKPj4gPHNuaXA+Cj4+Pj4gT24gU3VuLCBGZWIgMDgsIDIwMTUgYXQgMDg6NDg6MDlB
TSArMDEwMCwgSmFuIEtpc3prYSB3cm90ZToKPj4gPHNuaXA+Cj4+Pj4+IEJUVywgS1ZNIHRyYWNp
bmcgc3VwcG9ydCBvbiBBUk0gc2VlbXMgbGlrZSBpdCByZXF1aXJlcyBzb21lIGNhcmUuIEUuZy46
Cj4+Pj4+IGt2bV9leGl0IGRvZXMgbm90IHJlcG9ydCBhbiBleGl0IHJlYXNvbi4gVGhlIGluLWtl
cm5lbCB2Z2ljIGFsc28gc2VlbXMKPj4+Pj4gdG8gbGFjayBpbnN0cnVtZW50YXRpb24uIFVuZm9y
dHVuYXRlLiBUcmFjaW5nIGlzIHVzdWFsbHkgdGhlIGZpcnN0IHN0b3AKPj4+Pj4gd2hlbiBLVk0g
aXMgc3R1Y2sgb24gYSBndWVzdC4KPj4+Pgo+Pj4+IEkga25vdywgdGhlIGV4aXQgcmVhc29uIGlz
IG9uIG15IHRvZG8gbGlzdCwgYW5kIEFsZXggQiBpcyBzaXR0aW5nIG9uCj4+Pj4gdHJhY2UgcGF0
Y2hlcyBmb3IgdGhlIGdpYy4gIENvbWluZyBzb29uIHRvIGEgZ2l0IHJlcG8gbmVhciB5b3VyLgo+
Pj4KPj4+IEZvciB0aGUgaW1wYXRpZW50IHRoZSByYXcgcGF0Y2hlcyBhcmUgaW46Cj4+Pgo+Pj4g
Z2l0LmxpbmFyby5vcmcvcGVvcGxlL2FsZXguYmVubmVlL2xpbnV4LmdpdAo+Pj4gbWlncmF0aW9u
L3YzLjE5LXJjNy1pbXByb3ZlLXRyYWNpbmcKPj4gCj4+IE9LIHRyeSB0cmFjaW5nL2t2bS1leGl0
LWVudHJ5IGZvciBzb21ldGhpbmcgY2xlYW5lci4KPgo+IERvZXNuJ3QgYnVpbGQgZm9yIEFSTSAo
dmNwdV9zeXNfcmVnIGlzIEFSTTY0LW9ubHkgc28gZmFyKS4KPgo+IEJ1dCB0aGUgdmFsdWVzIHRy
YWNlZCBzZWVtIHVzZWZ1bC4gV2VpIEh1YW5nJ3MgcGF0Y2ggaW4ga3ZtLmdpdCBxdWV1ZQo+IHRy
YWNlcyB0aGUgZXhjZXB0aW9uIGNsYXNzLCBidXQgdW5mb3J0dW5hdGVseSBub3RoaW5nIGVsc2Uu
IFdoZW4gd291bGQKPiB3ZSBuZWVkIHRoYXQgY2xhc3M/IERvIHdlIG5lZWQgaXQgYXQgYWxsPwo+
Cj4gSW4gYW55IGNhc2UsIHBsZWFzZSBhZGQgc3ltYm9saWMgcHJpbnRpbmcgb2YgdGhlIG1hZ2lj
IHZhbHVlcyB3aGVuZXZlcgo+IHBvc3NpYmxlLCBqdXN0IGxpa2Ugb24geDg2Lgo+Cj4gSSdtIG5v
dyB0aHJvd2luZyB0cmFjZV9wcmludGsgYXQgbXkgYnJva2VuIEtWTS4gQWxyZWFkeSBmb3VuZCBv
dXQgdGhhdCBJCj4gZ2V0IEFSTV9FWENFUFRJT05fSVJRIGV2ZXJ5IGZldyAxMCDCtXMuIE5vdCBz
ZWVpbmcgYW55IGlycV8qIHRyYWNlcywKPiB0aG91Z2guIFdlaXJkLgoKVGhpcyB2ZXJ5IG11Y2gg
bG9va3MgbGlrZSBhIHNjcmVhbWluZyBpbnRlcnJ1cHQuIEF0IHN1Y2ggYSByYXRlLCBubwp3b25k
ZXIgeW91ciBWTSBtYWtlIG11Y2ggcHJvZ3Jlc3MuIENhbiB5b3UgZmluZCBvdXQgd2hpY2ggaW50
ZXJydXB0IGlzCnNjcmVhbWluZyBsaWtlIHRoaXM/IExvb2tpbmcgYXQgR0lDQ19IUFBJUiBzaG91
bGQgaGVscCwgYnV0IHlvdSdsbCBoYXZlCnRvIG1hcCB0aGUgQ1BVIGludGVyZmFjZSBpbiBIWVAg
YmVmb3JlIGJlaW5nIGFibGUgdG8gYWNjZXNzIGl0IHRoZXJlLgoKRG8geW91IGhhdmUgYW4gZm9y
bSBvZiBwb3dlci1tYW5hZ2VtZW50IG9uIHRoaXMgc3lzdGVtPwoKVGhhbmtzLAoKICAgICAgICBN
LgotLSAKV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBv
c3NpYmxlLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
