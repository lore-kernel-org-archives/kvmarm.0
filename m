From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 27 Mar 2019 18:16:22 +0000
Message-ID: <13ab02cf-db27-d604-6e5f-d276dec0779b@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
 <64505666-8a1f-cf64-7067-4b2dd53b0b40@arm.com>
 <da7091a9-01b2-bead-3777-972fbb293def@arm.com>
 <949327ae-081c-0964-3315-ac2695243b5f@arm.com>
 <536f518d-5425-cb94-3f64-4c56e5cd65c1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56AEB4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 14:16:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lBIdHDpF5N+J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 14:16:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD56D40A52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 14:16:26 -0400 (EDT)
In-Reply-To: <536f518d-5425-cb94-3f64-4c56e5cd65c1@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

SGkgQW1pdCwgS3Jpc3RpbmEsCgpPbiAyNy8wMy8yMDE5IDAzOjIxLCBBbWl0IERhbmllbCBLYWNo
aGFwIHdyb3RlOgo+IE9uIDMvMjYvMTkgMTE6MzEgUE0sIEtyaXN0aW5hIE1hcnRzZW5rbyB3cm90
ZToKPj4gT24gMjYvMDMvMjAxOSAwNDowMywgQW1pdCBEYW5pZWwgS2FjaGhhcCB3cm90ZToKPj4+
IE9uIDMvMjYvMTkgMTozNCBBTSwgS3Jpc3RpbmEgTWFydHNlbmtvIHdyb3RlOgo+Pj4+IE9uIDE5
LzAzLzIwMTkgMDg6MzAsIEFtaXQgRGFuaWVsIEthY2hoYXAgd3JvdGU6Cj4+Pj4+IEZyb206IE1h
cmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+Cj4+Pj4+Cj4+Pj4+IFdoZW4gcG9pbnRl
ciBhdXRoZW50aWNhdGlvbiBpcyBzdXBwb3J0ZWQsIGEgZ3Vlc3QgbWF5IHdpc2ggdG8gdXNlIGl0
Lgo+Pj4+PiBUaGlzIHBhdGNoIGFkZHMgdGhlIG5lY2Vzc2FyeSBLVk0gaW5mcmFzdHJ1Y3R1cmUg
Zm9yIHRoaXMgdG8gd29yaywgd2l0aAo+Pj4+PiBhIHNlbWktbGF6eSBjb250ZXh0IHN3aXRjaCBv
ZiB0aGUgcG9pbnRlciBhdXRoIHN0YXRlLgoKPj4+Pj4gK8KgwqDCoCBpZiAodGVzdF9iaXQoS1ZN
X0FSTV9WQ1BVX1BUUkFVVEhfQUREUkVTUywgdmNwdS0+YXJjaC5mZWF0dXJlcykgfHwKPj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIHRlc3RfYml0KEtWTV9BUk1fVkNQVV9QVFJBVVRIX0dFTkVSSUMsIHZj
cHUtPmFyY2guZmVhdHVyZXMpKSB7Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIFZlcmlmeSB0aGF0
IEtWTSBzdGFydHVwIG1hdGNoZXMgdGhlIGNvbmRpdGlvbnMgZm9yIHB0cmF1dGggKi8KPj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIGlmIChXQVJOX09OKCF2Y3B1X2hhc19wdHJhdXRoKHZjcHUpKSkKPj4+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+Pj4+ICvCoMKgwqAg
fQoKPj4gT25lIG1vcmUgdGhpbmcgLSBJIHRoaW5rIHRoZSBXQVJOX09OKCkgaGVyZSBzaG91bGQg
YmUgcmVtb3ZlZC4gT3RoZXJ3aXNlCj4+IGlmIHBhbmljX29uX3dhcm4gaXMgc2V0IHRoZW4gdXNl
cnNwYWNlIGNhbiBwYW5pYyB0aGUga2VybmVsLiBJIHRoaW5rCj4+IFdBUk5fT04gaXMgb25seSBm
b3IgaW50ZXJuYWwga2VybmVsIGVycm9ycyAoc2VlIGNvbW1lbnQgaW4KPj4gaW5jbHVkZS9hc20t
Z2VuZXJpYy9idWcuaCkuCj4gCj4gVGhlIGRvY3VtZW50YXRpb24gbWFrZXMgc2Vuc2Ugc28gaW4g
dGhpcyBjYXNlIGEgcHJfZXJyIGxpa2UgbWVzc2FnZSB3aWxsIHN1ZmZpY2UuCgooY291bGQgaXQg
YmUgYSBrdm1fZGVidWcoKSBhdCBtb3N0PykKCkRvIHdlIG5lZWQgdG8gcHJpbnQgYW55dGhpbmcg
YXQgYWxsPyBVc2VyLXNwYWNlIGFza2VkIHVzIGZvciBzb21ldGhpbmcgd2UgY2FuJ3QgZG8uCkZp
bGxpbmcgdXAgdGhlIGtlcm5lbCBsb2cgd2l0aCB1c2VyLXNwYWNlJ3MgbWlzdGFrZXMgbWFrZXMg
aXQgaGFyZGVyIHRvIGRlYnVnIHRoZSBrZXJuZWwKd2hlbiBzb21ldGhpbmcgZ29lcyB3cm9uZy4K
Cmt2bV9hcm1fcG11X3YzX2luaXQoKSByZXR1cm5zIC1FTk9ERVYgaWYgeW91IGFzayBpZiBmb3Ig
dGhlIFBNVSBhbmQgdGhlIHBsYXRmb3JtIGNhbid0CnN1cHBvcnQgaXQuIElzbid0IHRoZSByZXR1
cm5lZCBlcnJvciBlbm91Z2g/CgoKPiBCdHcKPiB0aGVyZSBpcyBvbmUgV0FSTiBpbiB0aGUgZnVu
Y3Rpb24ga3ZtX3NldF9pcGFfbGltaXQgaW4gdGhlIHNhbWUgZmlsZS4KClRoYXQgaXMgY2FsbGVk
IG9uY2UgdmlhIGt2bV9hcmNoX2luaXQoKSwgaXQgY2FuJ3QgYmUgdHJpZ2dlcmVkIHJlcGVhdGVk
bHkgZnJvbSB1c2VyLXNwYWNlLgoKClRoYW5rcywKCkphbWVzCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
