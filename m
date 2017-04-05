From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Wed, 5 Apr 2017 15:10:50 +0200
Message-ID: <20170405131049.GD6369@potion>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB2C40A80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 09:08:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLHP1tYJDtbZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 09:08:41 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 065F640905
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 09:08:40 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

MjAxNy0wNC0wNCAxODo0MSswMjAwLCBBbmRyZXcgSm9uZXM6Cj4gT24gVHVlLCBBcHIgMDQsIDIw
MTcgYXQgMDU6MzA6MTRQTSArMDIwMCwgQ2hyaXN0b2ZmZXIgRGFsbCB3cm90ZToKPj4gT24gRnJp
LCBNYXIgMzEsIDIwMTcgYXQgMDY6MDY6NTBQTSArMDIwMCwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+
PiA+IEZyb206IFJhZGltIEtyxI1tw6HFmSA8cmtyY21hckByZWRoYXQuY29tPgo+PiA+IAo+PiA+
IEEgZmlyc3Qgc3RlcCBpbiB2Y3B1LT5yZXF1ZXN0cyBlbmNhcHN1bGF0aW9uLgo+PiAKPj4gQ291
bGQgd2UgaGF2ZSBhIG5vdGUgaGVyZSBvbiB3aHkgd2UgbmVlZCB0byBhY2Nlc3MgdmNwdS0+cmVx
dWVzdHMgdXNpbmcKPj4gUkVBRF9PTkNFIG5vdz8KPiAKPiBTdXJlLCBtYXliZSB3ZSBzaG91bGQg
cHV0IHRoZSBub3RlIGFzIGEgY29tbWVudCBhYm92ZSB0aGUgcmVhZCBpbgo+IGt2bV9yZXF1ZXN0
X3BlbmRpbmcoKS4gIFNvbWV0aGluZyBsaWtlCj4gCj4gIC8qCj4gICAqIHZjcHUtPnJlcXVlc3Rz
IHJlYWRzIG1heSBhcHBlYXIgaW4gc2VxdWVuY2VzIHRoYXQgaGF2ZSBzdHJpY3QKPiAgICogZGF0
YSBvciBjb250cm9sIGRlcGVuZGVuY2llcy4gIFVzZSBSRUFEX09OQ0UoKSB0byBlbnN1cmUgdGhl
Cj4gICAqIGNvbXBpbGVyIGRvZXMgbm90IGRvIGFueXRoaW5nIHRoYXQgYnJlYWtzIHRoZSByZXF1
aXJlZCBvcmRlcmluZy4KPiAgICovCj4gCj4gUmFkaW0/CgpVc2VzIG9mIHZjcHUtPnJlcXVlc3Rz
IHNob3VsZCBhbHJlYWR5IGhhdmUgYmFycmllcnMgdGhhdCB0YWtlIGNhcmUgb2YKdGhlIG9yZGVy
aW5nLiAgSSB0aGluayB0aGUgbWFpbiByZWFzb24gZm9yIFJFQURfT05DRSgpIGlzIHRvIHRlbGwK
cHJvZ3JhbW1lcnMgdGhhdCByZXF1ZXN0cyBhcmUgc3BlY2lhbCwgYnV0IHByZWRpY3RhYmxlLgoK
UkVBRF9PTkNFKCkgaXMgbm90IG5lY2Vzc2FyeSBpbiBhbnkgdXNlIEknbSBhd2FyZSBvZiwgYnV0
IHRoZXJlIGlzIG5vCmhhcm0gaW4gdGVsbGluZyB0aGUgY29tcGlsZXIgdGhhdCB2Y3B1LT5yZXF1
ZXN0cyBhcmUgd2hhdCB3ZSB0aGluayB0aGV5CmFyZSAuLi4KCiAvKgogICogdmNwdS0+cmVxdWVz
dHMgYXJlIGEgbG9ja2xlc3Mgc3luY2hyb25pemF0aW9uIG1lY2hhbmlzbSwgd2hlcmUKICAqIG1l
bW9yeSBiYXJyaWVycyBhcmUgbmVjZXNzYXJ5IGZvciBjb3JyZWN0IGJlaGF2aW9yLCBzZWUKICAq
IERvY3VtZW50YXRpb24vdmlydHVhbC9rdm0vdmNwdS1yZXF1ZXN0cy5yc3QuCiAgKgogICogUkVB
RF9PTkNFKCkgaXMgbm90IG5lY2Vzc2FyeSBmb3IgY29ycmVjdG5lc3MsIGJ1dCBzaW1wbGlmaWVz
CiAgKiByZWFzb25pbmcgYnkgY29uc3RyaWN0aW5nIHRoZSBnZW5lcmF0ZWQgY29kZS4KICAqLwoK
SSBjb25zaWRlcmVkIFJFQURfT05DRSgpIHRvIGJlIHNlbGYtZG9jdW1lbnRpbmcuIDopCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
