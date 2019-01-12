From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH] mm: Introduce GFP_PGTABLE
Date: Sat, 12 Jan 2019 14:49:29 +0100
Message-ID: <ddd59fdc-3d8f-4015-e851-e7f099193a1b@c-s.fr>
References: <1547288798-10243-1-git-send-email-anshuman.khandual@arm.com>
 <20190112121230.GQ6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190112121230.GQ6310@bombadil.infradead.org>
Content-Language: fr
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matthew Wilcox <willy@infradead.org>, Anshuman Khandual <anshuman.khandual@arm.com>
Cc: mark.rutland@arm.com, mhocko@suse.com, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, christoffer.dall@arm.com, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu, aneesh.kumar@linux.ibm.com, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, linuxppc-dev@lists.ozlabs.org, steve.capper@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com, akpm@linux-foundation.org, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

CgpMZSAxMi8wMS8yMDE5IMOgIDEzOjEyLCBNYXR0aGV3IFdpbGNveCBhIMOpY3JpdMKgOgo+IE9u
IFNhdCwgSmFuIDEyLCAyMDE5IGF0IDAzOjU2OjM4UE0gKzA1MzAsIEFuc2h1bWFuIEtoYW5kdWFs
IHdyb3RlOgo+PiBBbGwgYXJjaGl0ZWN0dXJlcyBoYXZlIGJlZW4gZGVmaW5pbmcgdGhlaXIgb3du
IFBHQUxMT0NfR0ZQIGFzIChHRlBfS0VSTkVMIHwKPj4gX19HRlBfWkVSTykgYW5kIHVzaW5nIGl0
IGZvciBhbGxvY2F0aW5nIHBhZ2UgdGFibGUgcGFnZXMuCj4gCj4gRXhjZXB0IHRoYXQncyBub3Qg
dHJ1ZS4KPiAKPj4gKysrIGIvYXJjaC94ODYvbW0vcGd0YWJsZS5jCj4+IEBAIC0xMywxOSArMTMs
MTcgQEAgcGh5c19hZGRyX3QgcGh5c2ljYWxfbWFzayBfX3JvX2FmdGVyX2luaXQgPSAoMVVMTCA8
PCBfX1BIWVNJQ0FMX01BU0tfU0hJRlQpIC0gMTsKPj4gICBFWFBPUlRfU1lNQk9MKHBoeXNpY2Fs
X21hc2spOwo+PiAgICNlbmRpZgo+PiAgIAo+PiAtI2RlZmluZSBQR0FMTE9DX0dGUCAoR0ZQX0tF
Uk5FTF9BQ0NPVU5UIHwgX19HRlBfWkVSTykKPj4gLQo+PiAgICNpZmRlZiBDT05GSUdfSElHSFBU
RQo+IAo+IC4uLgo+IAo+PiAgIHB0ZV90ICpwdGVfYWxsb2Nfb25lX2tlcm5lbChzdHJ1Y3QgbW1f
c3RydWN0ICptbSkKPj4gICB7Cj4+IC0JcmV0dXJuIChwdGVfdCAqKV9fZ2V0X2ZyZWVfcGFnZShQ
R0FMTE9DX0dGUCAmIH5fX0dGUF9BQ0NPVU5UKTsKPj4gKwlyZXR1cm4gKHB0ZV90ICopX19nZXRf
ZnJlZV9wYWdlKEdGUF9QR1RBQkxFICYgfl9fR0ZQX0FDQ09VTlQpOwo+PiAgIH0KCkFzIGZhciBh
cyBJIGNhbiBzZWUsCgojZGVmaW5lIEdGUF9LRVJORUxfQUNDT1VOVCAoR0ZQX0tFUk5FTCB8IF9f
R0ZQX0FDQ09VTlQpCgpTbyB3aGF0J3MgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbjoKCihHRlBfS0VS
TkVMX0FDQ09VTlQgfCBfX0dGUF9aRVJPKSAmIH5fX0dGUF9BQ0NPVU5UCgphbmQKCihHRlBfS0VS
TkVMIHwgX19HRlBfWkVSTykgJiB+X19HRlBfQUNDT1VOVAoKQ2hyaXN0b3BoZQoKPiAKPiBJIHRo
aW5rIHg4NiB3YXMgdGhlIG9ubHkgb2RkIG9uZSBvdXQgaGVyZSwgYnV0IHlvdSdsbCBuZWVkIHRv
IHRyeSBhZ2FpbiAuLi4KPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBsaXN0CmxpbnV4LWFybS1rZXJuZWxA
bGlzdHMuaW5mcmFkZWFkLm9yZwpodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LWFybS1rZXJuZWwK
