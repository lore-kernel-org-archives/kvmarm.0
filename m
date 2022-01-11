Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75137C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 12:23:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E87CF4B245;
	Tue, 11 Jan 2022 07:23:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jQn0CcWLEgsI; Tue, 11 Jan 2022 07:23:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A1EC4B219;
	Tue, 11 Jan 2022 07:23:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8334E4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 07:23:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NpkKNRJzsdfx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 07:23:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCFD4B1F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 07:23:15 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0AEE1FB;
 Tue, 11 Jan 2022 04:23:14 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.1.156])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD14E3F774;
 Tue, 11 Jan 2022 04:23:12 -0800 (PST)
Date: Tue, 11 Jan 2022 12:23:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
Message-ID: <Yd12rvDxyIWzEXWc@FVFF77S0Q05N>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <YdR4N9QVYOzjowAb@FVFF77S0Q05N>
 <399d8805ca09f7d3c905b8c653abf60dd7141574.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <399d8805ca09f7d3c905b8c653abf60dd7141574.camel@redhat.com>
Cc: paulmck <paulmck@kernel.org>, maz <maz@kernel.org>,
 frederic <frederic@kernel.org>, Anup Patel <Anup.Patel@wdc.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVHVlLCBKYW4gMTEsIDIwMjIgYXQgMTI6MzI6MzhQTSArMDEwMCwgTmljb2xhcyBTYWVueiBK
dWxpZW5uZSB3cm90ZToKPiBIaSBNYXJrLAo+IAo+IE9uIFR1ZSwgMjAyMi0wMS0wNCBhdCAxNjoz
OSArMDAwMCwgTWFyayBSdXRsYW5kIHdyb3RlOgo+ID4gT24gRnJpLCBEZWMgMTcsIDIwMjEgYXQg
MDQ6NTQ6MjJQTSArMDEwMCwgUGFvbG8gQm9uemluaSB3cm90ZToKPiA+ID4gT24gMTIvMTcvMjEg
MTU6MzgsIE1hcmsgUnV0bGFuZCB3cm90ZToKPiA+ID4gPiBGb3IgZXhhbXBsZSBrdm1fZ3Vlc3Rf
ZW50ZXJfaXJxb2ZmKCkgY2FsbHMgZ3Vlc3RfZW50ZXJfaXJxX29mZigpIHdoaWNoIGNhbGxzCj4g
PiA+ID4gdnRpbWVfYWNjb3VudF9ndWVzdF9lbnRlcigpLCBidXQga3ZtX2d1ZXN0X2V4aXRfaXJx
b2ZmKCkgZG9lc24ndCBjYWxsCj4gPiA+ID4gZ3Vlc3RfZXhpdF9pcnFfb2ZmKCkgYW5kIHRoZSBj
YWxsIHRvIHZ0aW1lX2FjY291bnRfZ3Vlc3RfZXhpdCgpIGlzIG9wZW4tY29kZWQKPiA+ID4gPiBl
bHNld2hlcmUuIEFsc28sIGd1ZXN0X2VudGVyX2lycV9vZmYoKSBjb25kaXRpb25hbGx5IGNhbGxz
Cj4gPiA+ID4gcmN1X3ZpcnRfbm90ZV9jb250ZXh0X3N3aXRjaCgpLCBidXQgSSBjYW4ndCBpbW1l
ZGlhdGVseSBzcG90IGFueXRoaW5nIG9uIHRoZQo+ID4gPiA+IGV4aXQgc2lkZSB0aGF0IGNvcnJl
c3BvbmRlZCB3aXRoIHRoYXQsIHdoaWNoIGxvb2tzIHN1c3BpY2lvdXMuCj4gPiA+IAo+ID4gPiBy
Y3Vfbm90ZV9jb250ZXh0X3N3aXRjaCgpIGlzIGEgcG9pbnQtaW4tdGltZSBub3RpZmljYXRpb247
IGl0J3Mgbm90IHN0cmljdGx5Cj4gPiA+IG5lY2Vzc2FyeSwgYnV0IGl0IG1heSBpbXByb3ZlIHBl
cmZvcm1hbmNlIGEgYml0IGJ5IGF2b2lkaW5nIHVubmVjZXNzYXJ5IElQSXMKPiA+ID4gZnJvbSB0
aGUgUkNVIHN1YnN5c3RlbS4KPiA+ID4gCj4gPiA+IFRoZXJlJ3Mgbm8gYmVuZWZpdCBmcm9tIGRv
aW5nIGl0IHdoZW4geW91J3JlIGJhY2sgZnJvbSB0aGUgZ3Vlc3QsIGJlY2F1c2UgYXQKPiA+ID4g
dGhhdCBwb2ludCB0aGUgQ1BVIGlzIGp1c3QgcnVubmluZyBub3JtYWwga2VybmVsIGNvZGUuCj4g
PiAKPiA+IEkgc2VlLgo+ID4gCj4gPiBNeSBtYWluIGlzc3VlIGhlcmUgd2FzIGp1c3QgdGhhdCBp
dCdzIHJlYWxseSBkaWZmaWN1bHQgdG8gc2VlIGhvdyB0aGUKPiA+IGVudHJ5L2V4aXQgbG9naWMg
aXMgYmFsYW5jZWQsIGFuZCBJIHJlY2tvbiB3ZSBjYW4gc29sdmUgdGhhdCBieSBzcGxpdHRpbmcK
PiA+IGd1ZXN0X3tlbnRlcixleGl0fV9pcnFvZmYoKSBpbnRvIGhlbHBlciBmdW5jdGlvbnMgdG8g
aGFuZGxlIHRoZSB2dGltZQo+ID4gYWNjb3VudGluZyBzZXBhcmF0ZWx5IGZyb20gdGhlIGNvbnRl
eHQgdHJhY2tpbmcsIHNvIHRoYXQgYXJjaCBjb2RlIGNhbiBkbwo+ID4gc29tZXRoaW5nIGxpa2U6
Cj4gPiAKPiA+ICAgZ3Vlc3RfdGltaW5nX2VudGVyX2lycW9mZigpOwo+ID4gICAKPiA+ICAgZ3Vl
c3RfZXFzX2VudGVyX2lycW9mZigpOwo+ID4gICA8IGFjdHVhbGx5IHJ1biB2Q1BVIGhlcmUgPgo+
ID4gICBndWVzdF9lcXNfZXhpdF9pcnFvZmYoKTsKPiA+ICAgCj4gPiAgIDwgaGFuZGxlIHBlbmRp
bmcgSVJRcyBoZXJlID4KPiA+ICAgCj4gPiAgIGd1ZXN0X3RpbWluZ19leGl0X2lycW9mZigpOwo+
ID4gCj4gPiAuLi4gd2hpY2ggSSBob3BlIHNob3VsZCB3b3JrIGZvciBSSVNDLVYgdG9vLgo+ID4g
Cj4gPiBJJ3ZlIGhhZCBhIGdvLCBhbmQgSSd2ZSBwdXNoZWQgb3V0IGEgV0lQIHRvOgo+ID4gCj4g
PiAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hcmsv
bGludXguZ2l0L2xvZy8/aD1hcm02NC9rdm0vcmN1Cj4gCj4gSGFkIGEgbG9vayBhdCB0aGUgcGF0
Y2hlcyBhbmQgdGhleSBzZWVlbSBPSyB0byBtZS4KPiAKPiBUaGFua3MhCgpDb29sLgoKRldJVyBJ
IGhhdmUgYW4gdXBkYXRlZCB2ZXJzaW9uIGF0OgoKICBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9tYXJrL2xpbnV4LmdpdC9sb2cvP2g9a3ZtL2VudHJ5LXJl
d29yawoKLi4uIHdoaWNoIGlzIGxhcmdlbHkgdGhlIHNhbWUgYXBwcm9hY2gsIGJ1dCB0aGUgaGVs
cGVycyBnb3QgcmVuYW1lZCwgdGhlCmxvY2tkZXAvdHJhY2luZyBiaXRzIGdvdCBmaXhlZCwgYW5k
IEkndmUgYWxpZ25lZCBtaXBzLCByaXNjdiwgYW5kIHg4NiBvbiB0aGUKc2FtZSBhcHByb2FjaC4K
Ck9uY2UgSSBnZXQgYSBmcmVlIGhvdXIgb3Igc28gSSBpbnRlbmQgdG8gcmViYXNlIHRoYXQgYXRv
cCB2NS4xNiBhbmQgcG9zdCB0aGF0Cm91dC4gSSdsbCBzdGFydCBhIG5ldyB0aHJlYWQgd2l0aCB0
aGF0LCBhbmQgcm9wZSBpbiB0aGUgcmVsZXZhbnQgYXJjaAptYWludGFpbmVycyAoc2luY2UgZS5n
LiBJJ20gbm90IHN1cmUgd2hhdCB0byBkbyBmb3IgcHBjIGFuZCBzMzkwKS4KClRoYW5rcywKTWFy
ay4KCj4gCj4gLS0gCj4gTmljb2zDoXMgU8OhZW56Cj4gCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
