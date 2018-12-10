From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 1/8] arm64: KVM: Make VHE Stage-2 TLB invalidation
 operations non-interruptible
Date: Mon, 10 Dec 2018 11:49:17 +0100
Message-ID: <20181210104917.GM30263@e113682-lin.lund.arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-2-marc.zyngier@arm.com>
 <20181210100356.GG30263@e113682-lin.lund.arm.com>
 <d9219768-bbef-5d51-3bb4-84cf35714a4d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C99BF4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:49:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fwoKKZLDvnXR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:49:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE474A214
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:49:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <d9219768-bbef-5d51-3bb4-84cf35714a4d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gTW9uLCBEZWMgMTAsIDIwMTggYXQgMTA6MjQ6MzFBTSArMDAwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IEhpIENocmlzdG9mZmVyLAo+IAo+IE9uIDEwLzEyLzIwMTggMTA6MDMsIENocmlzdG9m
ZmVyIERhbGwgd3JvdGU6Cj4gPiBPbiBUaHUsIERlYyAwNiwgMjAxOCBhdCAwNTozMToxOVBNICsw
MDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gPj4gQ29udHJhcnkgdG8gdGhlIG5vbi1WSEUgdmVy
c2lvbiBvZiB0aGUgVExCIGludmFsaWRhdGlvbiBoZWxwZXJzLCB0aGUgVkhFCj4gPj4gY29kZSAg
aGFzIGludGVycnVwdHMgZW5hYmxlZCwgbWVhbmluZyB0aGF0IHdlIGNhbiB0YWtlIGFuIGludGVy
cnVwdCBpbgo+ID4+IHRoZSBtaWRkbGUgb2Ygc3VjaCBhIHNlcXVlbmNlLCBhbmQgc3RhcnQgcnVu
bmluZyBzb21ldGhpbmcgZWxzZSB3aXRoCj4gPj4gSENSX0VMMi5UR0UgY2xlYXJlZC4KPiA+IAo+
ID4gRG8gd2UgaGF2ZSB0byBjbGVhciBUR0UgdG8gcGVyZm9ybSB0aGUgVExCIGludmFsaWRhdGlv
biwgb3IgaXMgdGhhdCBqdXN0Cj4gPiBhIHNpZGUtZWZmZWN0IG9mIHJlLXVzaW5nIGNvZGU/Cj4g
Cj4gV2UgcmVhbGx5IGRvIG5lZWQgdG8gY2xlYXIgVEdFLiBGcm9tIHRoZSBkZXNjcmlwdGlvbiBv
ZiBUTEJJIFZNQUxMRTFJUzoKPiAKPiA8cXVvdGU+Cj4gV2hlbiBFTDIgaXMgaW1wbGVtZW50ZWQg
YW5kIGVuYWJsZWQgaW4gdGhlIGN1cnJlbnQgU2VjdXJpdHkgc3RhdGU6Cj4g4oCUIElmIEhDUl9F
TDIue0UySCwgVEdFfSBpcyBub3QgezEsIDF9LCB0aGUgZW50cnkgd291bGQgYmUgdXNlZCB3aXRo
IHRoZQo+IGN1cnJlbnQgVk1JRCBhbmQgd291bGQgYmUgcmVxdWlyZWQgdG8gdHJhbnNsYXRlIHRo
ZSBzcGVjaWZpZWQgVkEgdXNpbmcKPiB0aGUgRUwxJjAgdHJhbnNsYXRpb24gcmVnaW1lLgo+IOKA
lCBJZiBIQ1JfRUwyLntFMkgsIFRHRX0gaXMgezEsIDF9LCB0aGUgZW50cnkgd291bGQgYmUgcmVx
dWlyZWQgdG8KPiB0cmFuc2xhdGUgdGhlIHNwZWNpZmllZCBWQSB1c2luZyB0aGUgRUwyJjAgdHJh
bnNsYXRpb24gcmVnaW1lLgo+IDwvcXVvdGU+Cj4gCj4gPiBBbHNvLCBkbyB3ZSBnZW5lcmFsbHkg
cGVyZm9ybSBUTEIgaW52YWxpZGF0aW9ucyBpbiB0aGUga2VybmVsIHdpdGgKPiA+IGludGVycnVw
dHMgZGlzYWJsZWQsIG9yIGlzIHRoaXMganVzdCBhIHJlc3VsdCBvZiBjbGVhcmluZyBUR0U/Cj4g
Cj4gVGhhdCdzIGRlZmluaXRlbHkgYSByZXN1bHQgb2YgY2xlYXJpbmcgVEdFLiBXZSBjb3VsZCBi
ZSB0YWtpbmcgYW4KPiBpbnRlcnJ1cHQgaGVyZSwgYW5kIGV4ZWN1dGUgYSB1c2VyIGFjY2VzcyBv
biB0aGUgYmFjayBvZiBpdCAocGVyZiB3aWxsCj4gaGFwcGlseSB3YWxrIGEgdXNlci1zcGFjZSBz
dGFjayBpbiB0aGF0IGNvbnRleHQsIGZvciBleGFtcGxlKS4gSGF2aW5nCj4gVEdFIGNsZWFyIGlu
IHRoYXQgY29udGV4dC4gQW4gYWx0ZXJuYXRpdmUgc29sdXRpb24gd291bGQgYmUgdG8KPiBzYXZl
L3Jlc3RvcmUgVEdFIG9uIGludGVycnVwdCBlbnRyeS9leGl0LCBidXQgdGhhdCdzIGEgYml0IG92
ZXJraWxsIHdoZW4KPiB5b3UgY29uc2lkZXIgaG93IHJhcmVseSB3ZSBpc3N1ZSBzdWNoIFRMQiBp
bnZhbGlkYXRpb24uCj4gCj4gPiBTb21laG93IEkgZmVlbCBsaWtlIHRoaXMgc2hvdWxkIGxvb2sg
bW9yZSBsaWtlIGp1c3QgYW5vdGhlciBUTEIKPiA+IGludmFsaWRhdGlvbiBpbiB0aGUga2VybmVs
LCBidXQgaWYgdGhlcmUncyBhIGdvb2QgcmVhc29uIHdoeSBpdCBjYW4ndAo+ID4gdGhlbiB0aGlz
IGlzIGZpbmUuCj4gCj4gVGhlIHJlc3Qgb2YgdGhlIFRMQiBpbnZhbGlkYXRpb24gaW4gdGhlIGtl
cm5lbCBkb2Vzbid0IG5lZWQgdG8KPiBzYXZlL3Jlc3RvcmUgYW55IGNvbnRleHQuIFRoZXkgYXBw
bHkgdG8gYSBzZXQgb2YgcGFyYW1ldGVycyB0aGF0IGFyZQo+IGFscmVhZHkgbG9hZGVkIG9uIHRo
ZSBDUFUuIFdoYXQgd2UgaGF2ZSBoZXJlIGlzIHN1YnN0YW50aWFsbHkgZGlmZmVyZW50Lgo+IAoK
VGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24gYW5kIEFybSBBUk0gcXVvdGUuICBJIGZhaWxlZCB0
byBmaW5kIHRoYXQgb24KbXkgb3duIHRoaXMgcGFydGljdWxhciBNb25kYXkgbW9ybmluZy4KCkFj
a2VkLWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGFybS5jb20+Cl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
