From: David Hildenbrand <dahi@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug, add stub
 KVM_SET_GUEST_DEBUG ioctl
Date: Tue, 14 Apr 2015 08:31:57 +0200
Message-ID: <20150414083157.65733022@thinkpad-w530>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
 <20150413121231.GO6186@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 339C44CFDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 02:24:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NPhVvGTWU2f7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 02:24:15 -0400 (EDT)
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9531F4CFDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 02:24:15 -0400 (EDT)
Received: from /spool/local
 by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <dahi@linux.vnet.ibm.com>;
 Tue, 14 Apr 2015 07:32:02 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com
 (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
 by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 891661B08070
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 07:32:34 +0100 (BST)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com
 [9.149.37.212])
 by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t3E6W0x054132804
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:32:00 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t3E6VxFd026797
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 00:32:00 -0600
In-Reply-To: <20150413121231.GO6186@cbox>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

PiBPbiBUdWUsIE1hciAzMSwgMjAxNSBhdCAwNDowODowMlBNICswMTAwLCBBbGV4IEJlbm7DqWUg
d3JvdGU6Cj4gPiBUaGlzIGNvbW1pdCBhZGRzIGEgc3R1YiBmdW5jdGlvbiB0byBzdXBwb3J0IHRo
ZSBLVk1fU0VUX0dVRVNUX0RFQlVHCj4gPiBpb2N0bC4gQ3VycmVudGx5IGFueSBvcGVyYXRpb24g
ZmxhZyB3aWxsIHJldHVybiBFSU5WQUwuIEFjdHVhbAo+ID4gZnVuY3Rpb25hbGl0eSB3aWxsIGJl
IGFkZGVkIHdpdGggZnVydGhlciBwYXRjaGVzLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4
IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Lgo+ID4gCj4gPiAtLS0KPiA+IHYyCj4g
PiAgIC0gc2ltcGxpZmllZCBmb3JtIG9mIHRoZSBpb2N0bCAoc3R1ZmYgd2lsbCBnbyBpbnRvIHNl
dHVwX2RlYnVnKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2
bS9hcGkudHh0IGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0Cj4gPiBpbmRleCBi
MTEyZWZjLi4wNmM1MDY0IDEwMDY0NAo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2
bS9hcGkudHh0Cj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3ZtL2FwaS50eHQKPiA+
IEBAIC0yNjA0LDcgKzI2MDQsNyBAQCBoYW5kbGVkLgo+ID4gIDQuODcgS1ZNX1NFVF9HVUVTVF9E
RUJVRwo+ID4gIAo+ID4gIENhcGFiaWxpdHk6IEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHCj4gPiAt
QXJjaGl0ZWN0dXJlczogeDg2LCBzMzkwLCBwcGMKPiA+ICtBcmNoaXRlY3R1cmVzOiB4ODYsIHMz
OTAsIHBwYywgYXJtNjQKPiA+ICBUeXBlOiB2Y3B1IGlvY3RsCj4gPiAgUGFyYW1ldGVyczogc3Ry
dWN0IGt2bV9ndWVzdF9kZWJ1ZyAoaW4pCj4gPiAgUmV0dXJuczogMCBvbiBzdWNjZXNzOyAtMSBv
biBlcnJvcgo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2t2bS9hcm0uYyBiL2FyY2gvYXJtL2t2
bS9hcm0uYwo+ID4gaW5kZXggNTU2MGY3NC4uNDQ1OTMzZCAxMDA2NDQKPiA+IC0tLSBhL2FyY2gv
YXJtL2t2bS9hcm0uYwo+ID4gKysrIGIvYXJjaC9hcm0va3ZtL2FybS5jCj4gPiBAQCAtMTgzLDYg
KzE4Myw3IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0gKmt2
bSwgbG9uZyBleHQpCj4gPiAgCWNhc2UgS1ZNX0NBUF9BUk1fUFNDSToKPiA+ICAJY2FzZSBLVk1f
Q0FQX0FSTV9QU0NJXzBfMjoKPiA+ICAJY2FzZSBLVk1fQ0FQX1JFQURPTkxZX01FTToKPiA+ICsJ
Y2FzZSBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJVRzoKPiA+ICAJCXIgPSAxOwo+ID4gIAkJYnJlYWs7
Cj4gCj4gc2hvdWxkbid0IHlvdSB3YWl0IHdpdGggYWR2ZXJ0aXNpbmcgdGhpcyBjYXBhYmlsaXR5
IHVudGlsIHlvdSd2ZQo+IGltcGxlbWVudGVkIHN1cHBvcnQgZm9yIGl0Pwo+IAoKSSB0aGluayB0
aGlzIHdvdWxkIHdvcmsgZm9yIG5vdywgaG93ZXZlciBpdCdzIG5vdCB2ZXJ5IHByYWN0aWNhbAot
IGluIHRoZSBlbmQgb25lIGhhcyB0byBzZW5zZSB3aGljaCBkZWJ1ZyBmbGFncyBhcmUgYWN0dWFs
bHkgc3VwcG9ydGVkLgoKUXVlc3Rpb24gaXMgaWYgaGUgd2FudHMgdG8gYWRkIGluaXRpYWwgc3Vw
cG9ydCBhbmQgZXh0ZW5kIGZ1bmN0aW9uYWxpdHkgYW5kCmZsYWdzIHdpdGggZWFjaCBwYXRjaCBv
ciBlbmFibGUgdGhlIHdob2xlIHNldCBvZiBmZWF0dXJlcyBpbiBvbmUgc2hvdCBhdCB0aGUKZW5k
LgoKRG9pbmcgdGhlIGxhdHRlciBzZWVtcyBtb3JlIHByYWN0aWNhYmxlIHRvIG1lIChlc3BlY2lh
bGx5IGFzIHRoZSBkZWJ1ZyBmZWF0dXJlcwphcmUgYWRkZWQgaW4gdGhlIHNhbWUgcGF0Y2ggc2Vy
aWVzKS4KCkRhdmlkCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
