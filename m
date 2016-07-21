From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: VHE: Context switch MDSCR_EL1
Date: Thu, 21 Jul 2016 14:53:46 +0100
Message-ID: <20160721145346.470fea00@arm.com>
References: <1468933014-26966-1-git-send-email-marc.zyngier@arm.com>
 <20160721131720.GA32739@potion> <20160721142451.2ee990ce@arm.com>
 <20160721134937.GA4603@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C56C49B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 09:47:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tG3iuKfoJAPa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 09:47:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 332144998D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 09:47:38 -0400 (EDT)
In-Reply-To: <20160721134937.GA4603@potion>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Tirumalesh Chalamarla <Tirumalesh.Chalamarla@cavium.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gVGh1LCAyMSBKdWwgMjAxNiAxNTo0OTozOCArMDIwMApSYWRpbSBLcsSNbcOhxZkgPHJrcmNt
YXJAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+IDIwMTYtMDctMjEgMTQ6MjQrMDEwMCwgTWFyYyBaeW5n
aWVyOgo+ID4gT24gVGh1LCAyMSBKdWwgMjAxNiAxNToxNzoyMCArMDIwMAo+ID4gUmFkaW0gS3LE
jW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+IHdyb3RlOgo+ID4gCj4gPiBIaSBSYWRpbSwKPiA+
ICAgCj4gPj4gMjAxNi0wNy0xOSAxMzo1NiswMTAwLCBNYXJjIFp5bmdpZXI6ICAKPiA+PiA+IFRo
ZSBrcHJvYmUgZW5hYmxlbWVudCB3b3JrIGhhcyB1bmNvdmVyZWQgdGhhdCBjaGFuZ2VzIG1hZGUg
YnkKPiA+PiA+IGEgZ3Vlc3QgdG8gTURTQ1JfRUwxIHdlcmUgcHJvcGFnYXRlZCB0byB0aGUgaG9z
dCB3aGVuIFZIRSB3YXMKPiA+PiA+IGVuYWJsZWQsIGxlYWRpbmcgdG8gdW5leHBlY3RlZCBleGNl
cHRpb24gYmVpbmcgZGVsaXZlcmVkLgo+ID4+ID4gCj4gPj4gPiBNb3ZpbmcgdGhpcyByZWdpc3Rl
ciB0byB0aGUgbGlzdCBvZiByZWdpc3RlcnMgdGhhdCBhcmUgYWx3YXlzCj4gPj4gPiBjb250ZXh0
LXN3aXRjaGVkIGZpeGVzIHRoZSBpc3N1ZS4KPiA+PiA+IAo+ID4+ID4gRml4ZXM6IDljNmMzNTY4
MzI4NiAoImFybTY0OiBLVk06IFZIRTogU3BsaXQgc2F2ZS9yZXN0b3JlIG9mIHJlZ2lzdGVycyBz
aGFyZWQgYmV0d2VlbiBndWVzdCBhbmQgaG9zdCIpCj4gPj4gPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZyAjNC42Cj4gPj4gPiBSZXBvcnRlZC1ieTogVGlydW1hbGVzaCBDaGFsYW1hcmxhIDxU
aXJ1bWFsZXNoLkNoYWxhbWFybGFAY2F2aXVtLmNvbT4KPiA+PiA+IFRlc3RlZC1ieTogVGlydW1h
bGVzaCBDaGFsYW1hcmxhIDxUaXJ1bWFsZXNoLkNoYWxhbWFybGFAY2F2aXVtLmNvbT4KPiA+PiA+
IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Cj4gPj4g
PiAtLS0gICAgCj4gPj4gCj4gPj4gSSB3b3VsZCB0YWtlIHRoaXMgcGF0Y2ggdG8gNC43IGRpcmVj
dGx5IHRocm91Z2ggdGhlIG1haW4gdHJlZS4KPiA+PiBBcmUgeW91ciBwbGFucyBkaWZmZXJlbnQ/
ICAKPiA+IAo+ID4gSWYgeW91J3JlIGhhcHB5IHRvIHRha2UgaXQgbm93LCB0aGF0IHdvcmtzIGZv
ciBtZS4gIAo+IAo+IFRoZSBmaXggaXMgY2xlYXIsIHRlc3RlZCwgYW5kIHdvdWxkIGdvIHRvIDQu
Ny5zdGFibGUuICBCZXR0ZXIgdG8gaGF2ZSBpdAo+IGluIDQuNywgSU1PLgoKQWdyZWVkLgoKPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEkgY2Fu
IGVpdGhlciBzZW5kIGEKPiA+IFBSIHJpZ2h0IGF3YXksIG9yIHlvdSBjYW4gYXBwbHkgaXQgZGly
ZWN0bHksIHdoaWNoZXZlciB3b3JrcyBiZXN0IGZvcgo+ID4geW91LiAgCj4gCj4gSXQgaXMganVz
dCBvbmUgcGF0Y2ggc28gSSdsbCBhcHBseSBpdCBhbmQgc2VuZCBhIHB1bGwgcmVxdWVzdCB0byBM
aW51cwo+IG9uIFNhdHVyZGF5OyAgbGVzcyBjdW1tdWxhdGl2ZSB3b3JrIHRoYXQgd2F5LiA6KQoK
QnJpbGxpYW50LiBUaGFua3MgUmFkaW0uCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1
c3Qgc21lbGxzIGZ1bm55LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
