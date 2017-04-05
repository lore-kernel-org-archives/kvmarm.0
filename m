From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Wed, 5 Apr 2017 19:39:18 +0200
Message-ID: <20170405173918.GA27123@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0E4A40B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 13:37:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VzuuJo3BLPi4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 13:37:03 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B5ED40B40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 13:37:03 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id w11so23360796wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Apr 2017 10:39:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170405131049.GD6369@potion>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCBBcHIgMDUsIDIwMTcgYXQgMDM6MTA6NTBQTSArMDIwMCwgUmFkaW0gS3LEjW3DocWZ
IHdyb3RlOgo+IDIwMTctMDQtMDQgMTg6NDErMDIwMCwgQW5kcmV3IEpvbmVzOgo+ID4gT24gVHVl
LCBBcHIgMDQsIDIwMTcgYXQgMDU6MzA6MTRQTSArMDIwMCwgQ2hyaXN0b2ZmZXIgRGFsbCB3cm90
ZToKPiA+PiBPbiBGcmksIE1hciAzMSwgMjAxNyBhdCAwNjowNjo1MFBNICswMjAwLCBBbmRyZXcg
Sm9uZXMgd3JvdGU6Cj4gPj4gPiBGcm9tOiBSYWRpbSBLcsSNbcOhxZkgPHJrcmNtYXJAcmVkaGF0
LmNvbT4KPiA+PiA+IAo+ID4+ID4gQSBmaXJzdCBzdGVwIGluIHZjcHUtPnJlcXVlc3RzIGVuY2Fw
c3VsYXRpb24uCj4gPj4gCj4gPj4gQ291bGQgd2UgaGF2ZSBhIG5vdGUgaGVyZSBvbiB3aHkgd2Ug
bmVlZCB0byBhY2Nlc3MgdmNwdS0+cmVxdWVzdHMgdXNpbmcKPiA+PiBSRUFEX09OQ0Ugbm93Pwo+
ID4gCj4gPiBTdXJlLCBtYXliZSB3ZSBzaG91bGQgcHV0IHRoZSBub3RlIGFzIGEgY29tbWVudCBh
Ym92ZSB0aGUgcmVhZCBpbgo+ID4ga3ZtX3JlcXVlc3RfcGVuZGluZygpLiAgU29tZXRoaW5nIGxp
a2UKPiA+IAo+ID4gIC8qCj4gPiAgICogdmNwdS0+cmVxdWVzdHMgcmVhZHMgbWF5IGFwcGVhciBp
biBzZXF1ZW5jZXMgdGhhdCBoYXZlIHN0cmljdAo+ID4gICAqIGRhdGEgb3IgY29udHJvbCBkZXBl
bmRlbmNpZXMuICBVc2UgUkVBRF9PTkNFKCkgdG8gZW5zdXJlIHRoZQo+ID4gICAqIGNvbXBpbGVy
IGRvZXMgbm90IGRvIGFueXRoaW5nIHRoYXQgYnJlYWtzIHRoZSByZXF1aXJlZCBvcmRlcmluZy4K
PiA+ICAgKi8KPiA+IAo+ID4gUmFkaW0/Cj4gCj4gVXNlcyBvZiB2Y3B1LT5yZXF1ZXN0cyBzaG91
bGQgYWxyZWFkeSBoYXZlIGJhcnJpZXJzIHRoYXQgdGFrZSBjYXJlIG9mCj4gdGhlIG9yZGVyaW5n
LiAgSSB0aGluayB0aGUgbWFpbiByZWFzb24gZm9yIFJFQURfT05DRSgpIGlzIHRvIHRlbGwKPiBw
cm9ncmFtbWVycyB0aGF0IHJlcXVlc3RzIGFyZSBzcGVjaWFsLCBidXQgcHJlZGljdGFibGUuCgpJ
IGRvbid0IGtub3cgd2hhdCB0byBkbyB3aXRoICJzcGVjaWFsLCBidXQgcHJlZGljdGFibGUiLCB1
bmZvcnR1bmF0ZWx5LgpJbiBmYWN0LCBJIGRvbid0IGV2ZW4gdGhpbmsgSSBrbm93IHdoYXQgeW91
IG1lYW4uCgo+IAo+IFJFQURfT05DRSgpIGlzIG5vdCBuZWNlc3NhcnkgaW4gYW55IHVzZSBJJ20g
YXdhcmUgb2YsIGJ1dCB0aGVyZSBpcyBubwo+IGhhcm0gaW4gdGVsbGluZyB0aGUgY29tcGlsZXIg
dGhhdCB2Y3B1LT5yZXF1ZXN0cyBhcmUgd2hhdCB3ZSB0aGluayB0aGV5Cj4gYXJlIC4uLgoKSG1t
bSwgSSdtIGVxdWFsbHkgbG9zdC4KCj4gCj4gIC8qCj4gICAqIHZjcHUtPnJlcXVlc3RzIGFyZSBh
IGxvY2tsZXNzIHN5bmNocm9uaXphdGlvbiBtZWNoYW5pc20sIHdoZXJlCgppcyB0aGUgcmVxdWVz
dHMgYSBzeW5jaHJvbml6YXRpb24gbWVjaGFuaXNtPyAgSSB0aGluayBvZiBpdCBtb3JlIGFzIGEK
Y3Jvc3MtdGhyZWFkIGNvbW11bmljYXRpb24gcHJvdG9jb2wuCgo+ICAgKiBtZW1vcnkgYmFycmll
cnMgYXJlIG5lY2Vzc2FyeSBmb3IgY29ycmVjdCBiZWhhdmlvciwgc2VlCj4gICAqIERvY3VtZW50
YXRpb24vdmlydHVhbC9rdm0vdmNwdS1yZXF1ZXN0cy5yc3QuCj4gICAqCj4gICAqIFJFQURfT05D
RSgpIGlzIG5vdCBuZWNlc3NhcnkgZm9yIGNvcnJlY3RuZXNzLCBidXQgc2ltcGxpZmllcwo+ICAg
KiByZWFzb25pbmcgYnkgY29uc3RyaWN0aW5nIHRoZSBnZW5lcmF0ZWQgY29kZS4KPiAgICovCj4g
Cj4gSSBjb25zaWRlcmVkIFJFQURfT05DRSgpIHRvIGJlIHNlbGYtZG9jdW1lbnRpbmcuIDopCgpJ
IHJlYWxpemUgdGhhdCBJJ20gcHJvYmFibHkgdW51c3VhbGx5IHNsb3cgaW4gdGhpcyB3aG9sZSBh
cmVhLCBidXQgdXNpbmcKUkVBRF9PTkNFKCkgd2hlcmUgdW5uZWNlc3NhcnkgZG9lc24ndCBoZWxw
IG15IHJlYXNvbmluZywgYnV0IG1ha2VzIG1lCndvbmRlciB3aGljaCBwYXJ0IG9mIHRoaXMgSSBk
aWRuJ3QgdW5kZXJzdGFuZCwgc28gSSBkb24ndCBzZWVtIHRvIGFncmVlCndpdGggdGhlIHN0YXRl
bWVudCB0aGF0IGl0IHNpbXBsaWZpZXMgcmVhc29uaW5nLgoKUmVhbGx5LCBpZiB0aGVyZSBpcyBu
byByZWFzb24gdG8gdXNlIGl0LCBJIGRvbid0IHRoaW5rIHdlIHNob3VsZCB1c2UgaXQuClRvIG1l
LCBSRUFEX09OQ0UoKSBpbmRpY2F0ZXMgdGhhdCB0aGVyZSdzIHNvbWUgZmxvdyBpbiB0aGUgY29k
ZSB3aGVyZQppdCdzIGVzc2VudGlhbCB0aGF0IHRoZSBjb21waWxlciBkb2Vzbid0IGdlbmVyYXRl
IG11bHRpcGxlIGxvYWRzLCBidXQKdGhhdCB3ZSBvbmx5IHNlZSBhIG1vbWVudGFyeSBzaW5nbGUt
cmVhZCBzbmFwc2hvdCBvZiB0aGUgdmFsdWUsIGFuZCB0aGlzCmRvZXNuJ3Qgc2VlbSB0byBiZSB0
aGUgY2FzZS4KClRoYW5rcywKLUNocmlzdG9mZmVyCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
