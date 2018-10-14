From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Sun, 14 Oct 2018 20:57:22 +0800
Message-ID: <CAOLK0pxC9S7YzoC-YmE7bw2VyPEZfxZSCOW+hW+t3Mi8V6Y-RQ@mail.gmail.com>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
 <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
 <1BDC7949-CFED-46C2-9D05-42864B0AD0F0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1BDC7949-CFED-46C2-9D05-42864B0AD0F0@oracle.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: liran.alon@oracle.com
Cc: linux-mips@linux-mips.org, linux@armlinux.org, kvm <kvm@vger.kernel.org>, Radim Krcmar <rkrcmar@redhat.com>, catalin.marinas@arm.com, will.deacon@arm.com, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu, sthemmin@microsoft.com, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, benh@kernel.crashing.org, jhogan@kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, devel@linuxdriverproject.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, ralf@linux-mips.org, paul.burton@mips.com, Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

SGkgTGlyYW4gJiBUaG9tYXM6CiAgICAgICAgICAgICAgVGhhbmtzIGZvciB5b3VyIHJldmlldy4K
CgpPbiBTdW4sIE9jdCAxNCwgMjAxOCBhdCA1OjIwIFBNIExpcmFuIEFsb24gPGxpcmFuLmFsb25A
b3JhY2xlLmNvbT4gd3JvdGU6Cj4KPgo+Cj4gPiBPbiAxNCBPY3QgMjAxOCwgYXQgMTE6MTYsIFRo
b21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPiB3cm90ZToKPiA+Cj4gPiBPbiBTdW4s
IDE0IE9jdCAyMDE4LCBMaXJhbiBBbG9uIHdyb3RlOgo+ID4+PiBPbiAxMyBPY3QgMjAxOCwgYXQg
MTc6NTMsIGxhbnRpYW55dTE5ODZAZ21haWwuY29tIHdyb3RlOgo+ID4+Pgo+ID4+PiArCj4gPj4+
ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2F2YWlsYWJsZV9mbHVzaF90bGJfd2l0aF9yYW5nZSh2
b2lkKQo+ID4+PiArewo+ID4+PiArICAgcmV0dXJuIGt2bV94ODZfb3BzLT50bGJfcmVtb3RlX2Zs
dXNoX3dpdGhfcmFuZ2U7Cj4gPj4+ICt9Cj4gPj4KPiA+PiBTZWVtcyB0aGF0IGt2bV9hdmFpbGFi
bGVfZmx1c2hfdGxiX3dpdGhfcmFuZ2UoKSBpcyBub3QgdXNlZCBpbiB0aGlzIHBhdGNo4oCmCj4g
Pgo+ID4gV2hhdCdzIHdyb25nIHdpdGggdGhhdD8KPiA+Cj4gPiBJdCBwcm92aWRlcyB0aGUgaW1w
bGVtZW50YXRpb24gYW5kIGxhdGVyIHBhdGNoZXMgbWFrZSB1c2Ugb2YgaXQuIEl0J3MgYQo+ID4g
c2Vuc2libGUgd2F5IHRvIHNwbGl0IHBhdGNoZXMgaW50byBzbWFsbCwgc2VsZiBjb250YWluZWQg
ZW50aXRpZXMuCj4gPgo+ID4gVGhhbmtzLAo+ID4KPiA+ICAgICAgIHRnbHgKPiA+Cj4KPiBJIGd1
ZXNzIGl04oCZcyBhIG1hdHRlciBvZiB0YXN0ZSwgYnV0IEkgcHJlZmVyIHRvIG5vdCBhZGQgZGVh
ZC1jb2RlIGZvciBwYXRjaGVzCj4gaW4gb3JkZXIgZm9yIGVhY2ggY29tbWl0IHRvIGNvbXBpbGUg
bmljZWx5IHdpdGhvdXQgd2FybmluZ3Mgb2YgZGVjbGFyZWQgYW5kIHVudXNlZCBmdW5jdGlvbnMu
Cj4gSSB3b3VsZCBwcmVmZXIgdG8ganVzdCBhZGQgdGhpcyB1dGlsaXR5IGZ1bmN0aW9uIG9uIHRo
ZSBwYXRjaCB0aGF0IGFjdHVhbGx5IHVzZSBpdC4KPgo+IC1MaXJhbgo+CgpOb3JtYWxseSwgSSBh
bHNvIHByZWZlciB0byBwdXQgdGhlIGZ1bmN0aW9uIGRlZmluaXRpb24gaW50byB0aGUgcGF0Y2gK
d2hpY2ggdXNlIGl0LgpCdXQgdGhlIGZvbGxvd2luZyBwYXRjaCAiS1ZNOiBSZXBsYWNlIG9sZCB0
bGIgZmx1c2ggZnVuY3Rpb24gd2l0aCBuZXcKb25lIHRvIGZsdXNoIGEgc3BlY2lmaWVkIHJhbmdl
IgphbmQgb3RoZXIgcGF0Y2hlcyB3aGljaCB1c2UgbmV3IGZ1bmN0aW9ucyB3aWxsIGNoYW5nZSBh
IGxvdCBvZiBwbGFjZXMuCkl0J3Mgbm90IGZyaWVuZGx5IGZvciByZXZpZXcgYW5kCnNvIEkgc3Bs
aXQgdGhlbSBpbnRvIHBpZWNlcy4KLS0KQmVzdCByZWdhcmRzClRpYW55dSBMYW4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZGV2ZWwgbWFpbGluZyBsaXN0
CmRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmcKaHR0cDovL2RyaXZlcmRldi5saW51eGRyaXZl
cnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8vZHJpdmVyZGV2LWRldmVsCg==
