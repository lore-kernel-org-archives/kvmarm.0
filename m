From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/8] arm64: KVM: Make VHE Stage-2 TLB invalidation
 operations non-interruptible
Date: Mon, 10 Dec 2018 10:24:31 +0000
Message-ID: <d9219768-bbef-5d51-3bb4-84cf35714a4d@arm.com>
References: <20181206173126.139877-1-marc.zyngier@arm.com>
 <20181206173126.139877-2-marc.zyngier@arm.com>
 <20181210100356.GG30263@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721F04A329
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:24:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lv+63uZWlbvE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:24:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39B674A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:24:35 -0500 (EST)
In-Reply-To: <20181210100356.GG30263@e113682-lin.lund.arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

SGkgQ2hyaXN0b2ZmZXIsCgpPbiAxMC8xMi8yMDE4IDEwOjAzLCBDaHJpc3RvZmZlciBEYWxsIHdy
b3RlOgo+IE9uIFRodSwgRGVjIDA2LCAyMDE4IGF0IDA1OjMxOjE5UE0gKzAwMDAsIE1hcmMgWnlu
Z2llciB3cm90ZToKPj4gQ29udHJhcnkgdG8gdGhlIG5vbi1WSEUgdmVyc2lvbiBvZiB0aGUgVExC
IGludmFsaWRhdGlvbiBoZWxwZXJzLCB0aGUgVkhFCj4+IGNvZGUgIGhhcyBpbnRlcnJ1cHRzIGVu
YWJsZWQsIG1lYW5pbmcgdGhhdCB3ZSBjYW4gdGFrZSBhbiBpbnRlcnJ1cHQgaW4KPj4gdGhlIG1p
ZGRsZSBvZiBzdWNoIGEgc2VxdWVuY2UsIGFuZCBzdGFydCBydW5uaW5nIHNvbWV0aGluZyBlbHNl
IHdpdGgKPj4gSENSX0VMMi5UR0UgY2xlYXJlZC4KPiAKPiBEbyB3ZSBoYXZlIHRvIGNsZWFyIFRH
RSB0byBwZXJmb3JtIHRoZSBUTEIgaW52YWxpZGF0aW9uLCBvciBpcyB0aGF0IGp1c3QKPiBhIHNp
ZGUtZWZmZWN0IG9mIHJlLXVzaW5nIGNvZGU/CgpXZSByZWFsbHkgZG8gbmVlZCB0byBjbGVhciBU
R0UuIEZyb20gdGhlIGRlc2NyaXB0aW9uIG9mIFRMQkkgVk1BTExFMUlTOgoKPHF1b3RlPgpXaGVu
IEVMMiBpcyBpbXBsZW1lbnRlZCBhbmQgZW5hYmxlZCBpbiB0aGUgY3VycmVudCBTZWN1cml0eSBz
dGF0ZToK4oCUIElmIEhDUl9FTDIue0UySCwgVEdFfSBpcyBub3QgezEsIDF9LCB0aGUgZW50cnkg
d291bGQgYmUgdXNlZCB3aXRoIHRoZQpjdXJyZW50IFZNSUQgYW5kIHdvdWxkIGJlIHJlcXVpcmVk
IHRvIHRyYW5zbGF0ZSB0aGUgc3BlY2lmaWVkIFZBIHVzaW5nCnRoZSBFTDEmMCB0cmFuc2xhdGlv
biByZWdpbWUuCuKAlCBJZiBIQ1JfRUwyLntFMkgsIFRHRX0gaXMgezEsIDF9LCB0aGUgZW50cnkg
d291bGQgYmUgcmVxdWlyZWQgdG8KdHJhbnNsYXRlIHRoZSBzcGVjaWZpZWQgVkEgdXNpbmcgdGhl
IEVMMiYwIHRyYW5zbGF0aW9uIHJlZ2ltZS4KPC9xdW90ZT4KCj4gQWxzbywgZG8gd2UgZ2VuZXJh
bGx5IHBlcmZvcm0gVExCIGludmFsaWRhdGlvbnMgaW4gdGhlIGtlcm5lbCB3aXRoCj4gaW50ZXJy
dXB0cyBkaXNhYmxlZCwgb3IgaXMgdGhpcyBqdXN0IGEgcmVzdWx0IG9mIGNsZWFyaW5nIFRHRT8K
ClRoYXQncyBkZWZpbml0ZWx5IGEgcmVzdWx0IG9mIGNsZWFyaW5nIFRHRS4gV2UgY291bGQgYmUg
dGFraW5nIGFuCmludGVycnVwdCBoZXJlLCBhbmQgZXhlY3V0ZSBhIHVzZXIgYWNjZXNzIG9uIHRo
ZSBiYWNrIG9mIGl0IChwZXJmIHdpbGwKaGFwcGlseSB3YWxrIGEgdXNlci1zcGFjZSBzdGFjayBp
biB0aGF0IGNvbnRleHQsIGZvciBleGFtcGxlKS4gSGF2aW5nClRHRSBjbGVhciBpbiB0aGF0IGNv
bnRleHQuIEFuIGFsdGVybmF0aXZlIHNvbHV0aW9uIHdvdWxkIGJlIHRvCnNhdmUvcmVzdG9yZSBU
R0Ugb24gaW50ZXJydXB0IGVudHJ5L2V4aXQsIGJ1dCB0aGF0J3MgYSBiaXQgb3ZlcmtpbGwgd2hl
bgp5b3UgY29uc2lkZXIgaG93IHJhcmVseSB3ZSBpc3N1ZSBzdWNoIFRMQiBpbnZhbGlkYXRpb24u
Cgo+IFNvbWVob3cgSSBmZWVsIGxpa2UgdGhpcyBzaG91bGQgbG9vayBtb3JlIGxpa2UganVzdCBh
bm90aGVyIFRMQgo+IGludmFsaWRhdGlvbiBpbiB0aGUga2VybmVsLCBidXQgaWYgdGhlcmUncyBh
IGdvb2QgcmVhc29uIHdoeSBpdCBjYW4ndAo+IHRoZW4gdGhpcyBpcyBmaW5lLgoKVGhlIHJlc3Qg
b2YgdGhlIFRMQiBpbnZhbGlkYXRpb24gaW4gdGhlIGtlcm5lbCBkb2Vzbid0IG5lZWQgdG8Kc2F2
ZS9yZXN0b3JlIGFueSBjb250ZXh0LiBUaGV5IGFwcGx5IHRvIGEgc2V0IG9mIHBhcmFtZXRlcnMg
dGhhdCBhcmUKYWxyZWFkeSBsb2FkZWQgb24gdGhlIENQVS4gV2hhdCB3ZSBoYXZlIGhlcmUgaXMg
c3Vic3RhbnRpYWxseSBkaWZmZXJlbnQuCgpUaGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRl
YWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
