From: Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH V4 2/15] KVM/MMU: Add tlb flush with range helper function
Date: Sun, 14 Oct 2018 12:20:00 +0300
Message-ID: <1BDC7949-CFED-46C2-9D05-42864B0AD0F0@oracle.com>
References: <20181013145406.4911-1-Tianyu.Lan@microsoft.com>
 <20181013145406.4911-3-Tianyu.Lan@microsoft.com>
 <4D709C3A-A91C-4CA7-922A-E77618EF21B4@oracle.com>
 <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <alpine.DEB.2.21.1810141014350.1438@nanos.tec.linutronix.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org, linux@armlinux.org, kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kvmarm@lists.cs.columbia.edu, lantianyu1986@gmail.com, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, devel@linuxdriverproject.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

Cgo+IE9uIDE0IE9jdCAyMDE4LCBhdCAxMToxNiwgVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0
cm9uaXguZGU+IHdyb3RlOgo+IAo+IE9uIFN1biwgMTQgT2N0IDIwMTgsIExpcmFuIEFsb24gd3Jv
dGU6Cj4+PiBPbiAxMyBPY3QgMjAxOCwgYXQgMTc6NTMsIGxhbnRpYW55dTE5ODZAZ21haWwuY29t
IHdyb3RlOgo+Pj4gCj4+PiArCj4+PiArc3RhdGljIGlubGluZSBib29sIGt2bV9hdmFpbGFibGVf
Zmx1c2hfdGxiX3dpdGhfcmFuZ2Uodm9pZCkKPj4+ICt7Cj4+PiArCXJldHVybiBrdm1feDg2X29w
cy0+dGxiX3JlbW90ZV9mbHVzaF93aXRoX3JhbmdlOwo+Pj4gK30KPj4gCj4+IFNlZW1zIHRoYXQg
a3ZtX2F2YWlsYWJsZV9mbHVzaF90bGJfd2l0aF9yYW5nZSgpIGlzIG5vdCB1c2VkIGluIHRoaXMg
cGF0Y2jigKYKPiAKPiBXaGF0J3Mgd3Jvbmcgd2l0aCB0aGF0PyAKPiAKPiBJdCBwcm92aWRlcyB0
aGUgaW1wbGVtZW50YXRpb24gYW5kIGxhdGVyIHBhdGNoZXMgbWFrZSB1c2Ugb2YgaXQuIEl0J3Mg
YQo+IHNlbnNpYmxlIHdheSB0byBzcGxpdCBwYXRjaGVzIGludG8gc21hbGwsIHNlbGYgY29udGFp
bmVkIGVudGl0aWVzLgo+IAo+IFRoYW5rcywKPiAKPiAJdGdseAo+IAkKCkkgZ3Vlc3MgaXTigJlz
IGEgbWF0dGVyIG9mIHRhc3RlLCBidXQgSSBwcmVmZXIgdG8gbm90IGFkZCBkZWFkLWNvZGUgZm9y
IHBhdGNoZXMKaW4gb3JkZXIgZm9yIGVhY2ggY29tbWl0IHRvIGNvbXBpbGUgbmljZWx5IHdpdGhv
dXQgd2FybmluZ3Mgb2YgZGVjbGFyZWQgYW5kIHVudXNlZCBmdW5jdGlvbnMuCkkgd291bGQgcHJl
ZmVyIHRvIGp1c3QgYWRkIHRoaXMgdXRpbGl0eSBmdW5jdGlvbiBvbiB0aGUgcGF0Y2ggdGhhdCBh
Y3R1YWxseSB1c2UgaXQuCgotTGlyYW4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmRldmVsIG1haWxpbmcgbGlzdApkZXZlbEBsaW51eGRyaXZlcnByb2pl
Y3Qub3JnCmh0dHA6Ly9kcml2ZXJkZXYubGludXhkcml2ZXJwcm9qZWN0Lm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2RyaXZlcmRldi1kZXZlbAo=
