From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH V2] mm: Introduce GFP_PGTABLE
Date: Wed, 16 Jan 2019 14:47:16 +0100
Message-ID: <521d8511-4c87-49c6-de03-67a71d5bacca@c-s.fr>
References: <1547619692-7946-1-git-send-email-anshuman.khandual@arm.com>
 <20190116065703.GE24149@dhcp22.suse.cz>
 <20190116123018.GF6310@bombadil.infradead.org>
 <07d6a264-dccd-78ab-e8a9-2410bbef7b97@arm.com>
 <20190116131827.GH6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DE1F4A3AB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 08:47:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QcRcr1evn4g5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jan 2019 08:47:21 -0500 (EST)
Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C94424A3A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 08:47:21 -0500 (EST)
In-Reply-To: <20190116131827.GH6310@bombadil.infradead.org>
Content-Language: fr
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matthew Wilcox <willy@infradead.org>, Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, palmer@sifive.com, will.deacon@arm.com, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, aneesh.kumar@linux.ibm.com, linux@armlinux.org.uk, mingo@redhat.com, linux-arm-kernel@lists.infradead.org, rientjes@google.com, dave.hansen@linux.intel.com, greentime@andestech.com, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, vbabka@suse.cz, ard.biesheuvel@linaro.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

CgpMZSAxNi8wMS8yMDE5IMOgIDE0OjE4LCBNYXR0aGV3IFdpbGNveCBhIMOpY3JpdMKgOgo+IE9u
IFdlZCwgSmFuIDE2LCAyMDE5IGF0IDA2OjQyOjIyUE0gKzA1MzAsIEFuc2h1bWFuIEtoYW5kdWFs
IHdyb3RlOgo+PiBPbiAwMS8xNi8yMDE5IDA2OjAwIFBNLCBNYXR0aGV3IFdpbGNveCB3cm90ZToK
Pj4+IE9uIFdlZCwgSmFuIDE2LCAyMDE5IGF0IDA3OjU3OjAzQU0gKzAxMDAsIE1pY2hhbCBIb2Nr
byB3cm90ZToKPj4+PiBPbiBXZWQgMTYtMDEtMTkgMTE6NTE6MzIsIEFuc2h1bWFuIEtoYW5kdWFs
IHdyb3RlOgo+Pj4+PiBBbGwgYXJjaGl0ZWN0dXJlcyBoYXZlIGJlZW4gZGVmaW5pbmcgdGhlaXIg
b3duIFBHQUxMT0NfR0ZQIGFzIChHRlBfS0VSTkVMIHwKPj4+Pj4gX19HRlBfWkVSTykgYW5kIHVz
aW5nIGl0IGZvciBhbGxvY2F0aW5nIHBhZ2UgdGFibGUgcGFnZXMuIFRoaXMgY2F1c2VzIHNvbWUK
Pj4+Pj4gY29kZSBkdXBsaWNhdGlvbiB3aGljaCBjYW4gYmUgZWFzaWx5IGF2b2lkZWQuIEdGUF9L
RVJORUwgYWxsb2NhdGVkIGFuZAo+Pj4+PiBjbGVhcmVkIG91dCBwYWdlcyAoX19HRlBfWkVSTykg
YXJlIHJlcXVpcmVkIGZvciBwYWdlIHRhYmxlcyBvbiBhbnkgZ2l2ZW4KPj4+Pj4gYXJjaGl0ZWN0
dXJlLiBUaGlzIGNyZWF0ZXMgYSBuZXcgZ2VuZXJpYyBHRlAgZmxhZyBmbGFnIHdoaWNoIGNhbiBi
ZSB1c2VkCj4+Pj4+IGZvciBhbnkgcGFnZSB0YWJsZSBwYWdlIGFsbG9jYXRpb24uIERvZXMgbm90
IGNhdXNlIGFueSBmdW5jdGlvbmFsIGNoYW5nZS4KPj4+Pj4KPj4+Pj4gR0ZQX1BHVEFCTEUgaXMg
YmVpbmcgYWRkZWQgaW50byBpbmNsdWRlL2FzbS1nZW5lcmljL3BndGFibGUuaCB3aGljaCBpcyB0
aGUKPj4+Pj4gZ2VuZXJpYyBwYWdlIHRhYmUgaGVhZGVyIGp1c3QgdG8gcHJldmVudCBpdCdzIHBv
dGVudGlhbCBtaXN1c2UgYXMgYSBnZW5lcmFsCj4+Pj4+IGFsbG9jYXRpb24gZmxhZyBpZiBpbmNs
dWRlZCBpbiBpbmNsdWRlL2xpbnV4L2dmcC5oLgo+Pj4+Cj4+Pj4gSSBoYXZlbid0IHJldmlld2Vk
IHRoZSBwYXRjaCB5ZXQgYnV0IEkgYW0gd29uZGVyaW5nIHdoZXRoZXIgdGhpcyBpcwo+Pj4+IHJl
YWxseSB3b3J0aCBpdCB3aXRob3V0IGdvaW5nIGFsbCB0aGUgd2F5IGRvd24gdG8gdW5pZnkgdGhl
IGNvbW1vbiBjb2RlCj4+Pj4gYW5kIHJlbW92ZSBtdWNoIG1vcmUgY29kZSBkdXBsaWNhdGlvbi4g
T3IgaXMgdGhpcyBub3QgcG9zc2libGUgZm9yIHNvbWUKPj4+PiByZWFzb24/Cj4+Pgo+Pj4gRXhh
Y3RseSB3aGF0IEkgc3VnZ2VzdGVkIGRvaW5nIGluIHJlc3BvbnNlIHRvIHYxLgo+Pj4KPj4+IEFs
c28sIHRoZSBhcHByb2FjaCB0YWtlbiBoZXJlIGlzIGNyYXp5LiAgeDg2IGhhcyBhIGZlYXR1cmUg
dGhhdCBubyBvdGhlcgo+Pj4gYXJjaGl0ZWN0dXJlIGhhcyBib3RoZXJlZCB0byBpbXBsZW1lbnQg
eWV0IC0tIGFjY291bnRpbmcgcGFnZSB0YWJsZXMKPj4+IHRvIHRoZSBwcm9jZXNzLiAgWWV0IGlu
c3RlYWQgb2Ygc3ByZWFkaW5nIHRoYXQgZ29vZG5lc3MgdG8gYWxsIG90aGVyCj4+PiBhcmNoaXRl
Y3R1cmVzLCBBbnNodW1hbiBoYXMgZ29uZSB0byBtb3JlIGVmZm9ydCB0byBhdm9pZCBkb2luZyB0
aGF0Lgo+Pgo+PiBUaGUgYmFzaWMgb2JqZWN0aXZlIGZvciB0aGlzIHBhdGNoIGlzIHRvIGNyZWF0
ZSBhIGNvbW1vbiBtaW5pbXVtIGFsbG9jYXRpb24KPj4gZmxhZyB0aGF0IGNhbiBiZSB1c2VkIGJ5
IGFyY2hpdGVjdHVyZXMgYnV0IHRoYXQgc3RpbGwgYWxsb3dzIGFyY2hzIHRvIGFkZAo+PiBvbiBh
ZGRpdGlvbmFsIGNvbnN0cmFpbnRzIGlmIHRoZXkgc2VlIGZpdC4gVGhpcyBwYXRjaCBkb2VzIG5v
dCBpbnRlbmQgdG8KPj4gY2hhbmdlIGZ1bmN0aW9uYWxpdHkgZm9yIGFueSBhcmNoLgo+IAo+IEkg
ZGlzYWdyZWUgd2l0aCB5b3VyIG9iamVjdGl2ZS4gIE1ha2luZyBtb3JlIGNvZGUgY29tbW9uIGlz
IGEgZ3JlYXQgaWRlYSwKPiBidXQgdGhpcyBwYXRjaCBpcyB0b28gdW5hbWJpdGlvdXMuICBXZSBz
aG91bGQgYmUgaGVhZGluZyB0b3dhcmRzIG9uZSBvcgo+IHR3byBwYWdlIHRhYmxlIGFsbG9jYXRp
b24gZnVuY3Rpb25zIGluc3RlYWQgb2YgaGF2aW5nIGV2ZXJ5IGFyY2hpdGVjdHVyZSBkbwo+IGl0
cyBvd24gdGhpbmcuCj4gCj4gU28gc3RhcnQgdGhlcmUuICBNb3ZlIHRoZSB4ODYgZnVuY3Rpb24g
aW50byBjb21tb24gY29kZSBhbmQgY29udmVydCBvbmUKPiBvdGhlciBhcmNoaXRlY3R1cmUgdG8g
dXNlIGl0IHRvby4KCkFyZSB3ZSB0YWxraW5nIGFib3V0IHB0ZV9hbGxvY19vbmVfa2VybmVsKCkg
YW5kIHB0ZV9hbGxvY19vbmUoKSA/CgpJJ20gbm90IHN1cmUgeDg2IGZ1bmN0aW9uIGlzIHRoZSBi
ZXN0IGNvbW1vbiBvbmUsIGFzIGl0IHNlZW1zIHRvIAphbGxvY2F0ZSBhIG11bHRpcGxlIG9mIFBB
R0VfU0laRSBvbmx5LgoKU29tZSBhcmNoZXMgbGlrZSBwb3dlcnBjIHVzZSBwYWdldGFibGVzIHdo
aWNoIGFyZSBzbWFsbGVyIHRoYW4gYSBwYWdlLCAKZm9yIGluc3RhbmNlIHBvd2VycGMgOHh4IHVz
ZXMgNGsgcGFnZXRhYmxlcyBldmVuIHdpdGggMTZrIHBhZ2VzLCB3aGljaCAKbWVhbnMgYSBzaW5n
bGUgcGFnZSBjYW4gYmUgdXNlZCBieSA0IHBhZ2V0YWJsZXMuCgpUaGVyZWZvcmUsIEkgd291bGQg
c3VnZ2VzdCB0byBzdGFydCB3aXRoIHBvd2VycGMgZnVuY3Rpb25zLgoKQ2hyaXN0b3BoZQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
