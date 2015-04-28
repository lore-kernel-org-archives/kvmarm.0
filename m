From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug,
 add SW break point support
Date: Tue, 28 Apr 2015 15:37:01 +0100
Message-ID: <87tww0qqh9.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <20150414082558.GS6186@cbox> <87y4li6hua.fsf@linaro.org>
 <20150427200407.GG23335@cbox>
 <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
 <87wq0wr6dd.fsf@linaro.org>
 <CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
 <20150428125645.GA4137@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A1E84ED37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 10:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2Pi36iJjb5j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 10:28:22 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3566B4ED32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 10:28:21 -0400 (EDT)
In-reply-to: <20150428125645.GA4137@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm-devel <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, "J. Kiszka" <jan.kiszka@siemens.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, Zhichao Huang <zhichao.huang@linaro.org>, Bharat Bhushan <r65777@freescale.com>, Paolo Bonzini <pbonzini@redhat.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

CkNocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoK
PiBPbiBUdWUsIEFwciAyOCwgMjAxNSBhdCAxMDozNDoxMkFNICswMTAwLCBQZXRlciBNYXlkZWxs
IHdyb3RlOgo+PiBPbiAyOCBBcHJpbCAyMDE1IGF0IDA5OjQyLCBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+IHdyb3RlOgo+PiA+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRl
bGxAbGluYXJvLm9yZz4gd3JpdGVzOgo+PiA+PiBEb2VzIHRoZSBrZXJuZWwgYWxyZWFkeSBoYXZl
IGEgY29udmVuaWVudGx5IGltcGxlbWVudGVkICJpbmplY3QKPj4gPj4gZXhjZXB0aW9uIGludG8g
Z3Vlc3QiIGx1bXAgb2YgY29kZT8gSWYgc28gaXQgbWlnaHQgYmUgbGVzcyBlZmZvcnQKPj4gPj4g
dG8gZG8gaXQgdGhhdCB3YXkgcm91bmQsIG1heWJlLgo+PiA+Cj4+ID4gU28geW91IHBvaW50ZWQg
b3V0IHdlIGNhbid0IGp1c3QgcmUtaW5qZWN0IHRoZSBleGNlcHRpb25zIHdlIGdldCBhcyB3ZQo+
PiA+IG5lZWQgdG8gbWFwIGZyb20gdGhpbmdzIGxpa2UgRVNSX0VMeF9FQ19XQVRDSFBUX0xPVyB0
bwo+PiA+IEVTUl9FTHhfRUNfV0FUQ0hQVF9DVVIgYmVmb3JlIHJlLWluamVjdGlvbi4KPj4gPgo+
PiA+IE9mIGNvdXJzZSBpZiBpdCBpcyBhcyBzaW1wbGUgYXMgbW9kaWZ5aW5nIHRoZSBFU1JfRUwx
IHJlZ2lzdGVyIGFuZAo+PiA+IHJldHVybmluZyArdmUgaW4gdGhlIGhhbmRsZV9leGl0IHBhdGgg
dGhlbiBJIGNhbiBkbyB0aGF0IGJ1dCBJIGFzc3VtZWQKPj4gPiBpZiBhbnkgb3RoZXIgd3Jhbmds
aW5nIG5lZWRzIGRvaW5nIGl0IHNob3VsZCBiZSBkb25lIGluIHVzZXJzcGFjZS4KPj4gCj4+IFdl
bGwsIHNvbWVib2R5J3MgZ290IHRvIGRvIGl0LCBhbmQgaXQncyB0aGUgc2FtZSBhbW91bnQgb2Yg
d29yawo+PiBlaXRoZXIgd2F5IChmaWRkbGluZyB3aXRoIEVTUiwgbWFraW5nIHN1cmUgd2UgZGly
ZWN0IHRoZSBndWVzdAo+PiB0byB0aGUgcmlnaHQgZXhjZXB0aW9uIHZlY3RvciBlbnRyeSBwb2lu
dCwgbWF5YmUgYSBmZXcgb3RoZXIKPj4gdGhpbmdzKS4KPj4gCj4gV2UgYWxyZWFkeSBoYXZlIGNv
ZGUgaW4gdGhlIGtlcm5lbCB0byBpbmplY3QgZGF0YS9pbnN0cnVjdGlvbiBhYm9ydHMsCj4gYnV0
IG5vdCBzdXJlIGhvdyBtdWNoIGJlbmVmaXQgdGhlcmUgaXMgaW4gcmUtdXNpbmcgdGhhdC4gIEl0
J3MgdXAgdG8geW91Cj4gcmVhbGx5LCBidXQgSSB0aGluayB0aGUga2VybmVsIGNvZGUgc2hvdWxk
IGJlIGNsZWFyIGFib3V0IHdoYXQgdGhlCj4gaW50ZW50aW9uIGlzIHNvIHRoYXQgd2UgZG9uJ3Qg
ZW5kIHVwIGluIGEgc2l0dWF0aW9uIHdoZXJlOiAoMSkgVGhlCj4gaW50ZW5kZWQgYmVoYXZpb3Ig
aXMgdW5jbGVhci92YWd1ZSwgYW5kICgyKSBpdCBkb2Vzbid0IGFjdHVhbGx5IHdvcmsgaW4KPiBw
cmFjdGljZSBzbyBub2JvZHkgY2FuIGZvbGxvdyB0aGUgY29kZS4KCkNlcnRhaW5seSB0aGVyZSBh
cmUgc29tZSBjYXNlcyB3aGVyZSB0aGUga2VybmVsIGRvZXNuJ3QgaGF2ZSBhbGwgdGhlCmluZm9y
bWF0aW9uLiBGb3IgZXhhbXBsZSBpdCBkb2Vzbid0IGtub3cgaWYgdGhlIHNvZnQgYnJlYWsgd2Fz
IGluc2VydGVkCmJ5IHRoZSBndWVzdCBvciB0aGUgaG9zdC4gVGhhdCB0byBtZSBmYXZvdXJzIHRo
ZSAibGV0IHVzZXJzcGFjZSBkZWFsCndpdGggdGhlIHVnbHkiIGFwcHJvYWNoLgoKLS0gCkFsZXgg
QmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
