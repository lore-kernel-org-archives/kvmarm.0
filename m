From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug,
 add stub KVM_SET_GUEST_DEBUG ioctl
Date: Tue, 14 Apr 2015 09:03:53 +0100
Message-ID: <87y4lvf85y.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
 <20150413121231.GO6186@cbox> <20150414083157.65733022@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A874CFE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:56:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eQetOCuzwcLK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 03:55:59 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A9B4CFDD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:55:58 -0400 (EDT)
In-reply-to: <20150414083157.65733022@thinkpad-w530>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmlkIEhpbGRlbmJyYW5kIDxkYWhpQGxpbnV4LnZuZXQuaWJtLmNvbT4gd3JpdGVzOgoKPj4g
T24gVHVlLCBNYXIgMzEsIDIwMTUgYXQgMDQ6MDg6MDJQTSArMDEwMCwgQWxleCBCZW5uw6llIHdy
b3RlOgo+PiA+IFRoaXMgY29tbWl0IGFkZHMgYSBzdHViIGZ1bmN0aW9uIHRvIHN1cHBvcnQgdGhl
IEtWTV9TRVRfR1VFU1RfREVCVUcKPj4gPiBpb2N0bC4gQ3VycmVudGx5IGFueSBvcGVyYXRpb24g
ZmxhZyB3aWxsIHJldHVybiBFSU5WQUwuIEFjdHVhbAo+PiA+IGZ1bmN0aW9uYWxpdHkgd2lsbCBi
ZSBhZGRlZCB3aXRoIGZ1cnRoZXIgcGF0Y2hlcy4KPj4gPiAKPj4gPiBTaWduZWQtb2ZmLWJ5OiBB
bGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Lgo+PiA+IAo+PiA+IC0tLQo+PiA+
IHYyCj4+ID4gICAtIHNpbXBsaWZpZWQgZm9ybSBvZiB0aGUgaW9jdGwgKHN0dWZmIHdpbGwgZ28g
aW50byBzZXR1cF9kZWJ1ZykKPj4gPiAKPj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92
aXJ0dWFsL2t2bS9hcGkudHh0IGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0Cj4+
ID4gaW5kZXggYjExMmVmYy4uMDZjNTA2NCAxMDA2NDQKPj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9u
L3ZpcnR1YWwva3ZtL2FwaS50eHQKPj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3Zt
L2FwaS50eHQKPj4gPiBAQCAtMjYwNCw3ICsyNjA0LDcgQEAgaGFuZGxlZC4KPj4gPiAgNC44NyBL
Vk1fU0VUX0dVRVNUX0RFQlVHCj4+ID4gIAo+PiA+ICBDYXBhYmlsaXR5OiBLVk1fQ0FQX1NFVF9H
VUVTVF9ERUJVRwo+PiA+IC1BcmNoaXRlY3R1cmVzOiB4ODYsIHMzOTAsIHBwYwo+PiA+ICtBcmNo
aXRlY3R1cmVzOiB4ODYsIHMzOTAsIHBwYywgYXJtNjQKPj4gPiAgVHlwZTogdmNwdSBpb2N0bAo+
PiA+ICBQYXJhbWV0ZXJzOiBzdHJ1Y3Qga3ZtX2d1ZXN0X2RlYnVnIChpbikKPj4gPiAgUmV0dXJu
czogMCBvbiBzdWNjZXNzOyAtMSBvbiBlcnJvcgo+PiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9r
dm0vYXJtLmMgYi9hcmNoL2FybS9rdm0vYXJtLmMKPj4gPiBpbmRleCA1NTYwZjc0Li40NDU5MzNk
IDEwMDY0NAo+PiA+IC0tLSBhL2FyY2gvYXJtL2t2bS9hcm0uYwo+PiA+ICsrKyBiL2FyY2gvYXJt
L2t2bS9hcm0uYwo+PiA+IEBAIC0xODMsNiArMTgzLDcgQEAgaW50IGt2bV92bV9pb2N0bF9jaGVj
a19leHRlbnNpb24oc3RydWN0IGt2bSAqa3ZtLCBsb25nIGV4dCkKPj4gPiAgCWNhc2UgS1ZNX0NB
UF9BUk1fUFNDSToKPj4gPiAgCWNhc2UgS1ZNX0NBUF9BUk1fUFNDSV8wXzI6Cj4+ID4gIAljYXNl
IEtWTV9DQVBfUkVBRE9OTFlfTUVNOgo+PiA+ICsJY2FzZSBLVk1fQ0FQX1NFVF9HVUVTVF9ERUJV
RzoKPj4gPiAgCQlyID0gMTsKPj4gPiAgCQlicmVhazsKPj4gCj4+IHNob3VsZG4ndCB5b3Ugd2Fp
dCB3aXRoIGFkdmVydGlzaW5nIHRoaXMgY2FwYWJpbGl0eSB1bnRpbCB5b3UndmUKPj4gaW1wbGVt
ZW50ZWQgc3VwcG9ydCBmb3IgaXQ/Cj4+IAo+Cj4gSSB0aGluayB0aGlzIHdvdWxkIHdvcmsgZm9y
IG5vdywgaG93ZXZlciBpdCdzIG5vdCB2ZXJ5IHByYWN0aWNhbAo+IC0gaW4gdGhlIGVuZCBvbmUg
aGFzIHRvIHNlbnNlIHdoaWNoIGRlYnVnIGZsYWdzIGFyZSBhY3R1YWxseSBzdXBwb3J0ZWQuCj4K
PiBRdWVzdGlvbiBpcyBpZiBoZSB3YW50cyB0byBhZGQgaW5pdGlhbCBzdXBwb3J0IGFuZCBleHRl
bmQgZnVuY3Rpb25hbGl0eSBhbmQKPiBmbGFncyB3aXRoIGVhY2ggcGF0Y2ggb3IgZW5hYmxlIHRo
ZSB3aG9sZSBzZXQgb2YgZmVhdHVyZXMgaW4gb25lIHNob3QgYXQgdGhlCj4gZW5kLgoKVGhpcyBp
cyB3aGF0IGluIGVmZmVjdCBJIHdhcyBkb2luZy4gVGVzdGluZyBlYWNoIGZlYXR1cmUgaW4gdHVy
biBhbmQKZW5zdXJpbmcgaXQgZmFpbGVkIGdyYWNlZnVsbHkgd2hlbiBrZXJuZWwgZmVhdHVyZXMg
d2hlcmUgbm90IHByZXNlbnQKKGJvdGggbWlzc2luZyB0aGUgY2FwYWJpbGl0eSBvciByZXR1cm5p
bmcgRUlOVkFMKS4KCj4gRG9pbmcgdGhlIGxhdHRlciBzZWVtcyBtb3JlIHByYWN0aWNhYmxlIHRv
IG1lIChlc3BlY2lhbGx5IGFzIHRoZSBkZWJ1ZyBmZWF0dXJlcwo+IGFyZSBhZGRlZCBpbiB0aGUg
c2FtZSBwYXRjaCBzZXJpZXMpLgoKV2VsbCBpbiBwcmFjdGljZSB0aGUgd2hvbGUgc2VyaWVzIHdp
bGwgZ28gaW4gdG9nZXRoZXIgc28gdGhpcyBpcyBvbmx5CnJlYWxseSByZWxldmFudCB0byB3aGF0
IGhhcHBlbnMgd2hlbiB5b3UgYmlzZWN0IHRoZSBzZXJpZXMuCgo+Cj4gRGF2aWQKCi0tIApBbGV4
IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
