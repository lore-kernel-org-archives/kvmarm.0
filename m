Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1948BC2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E7C424655
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E7C424655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00FEC4AE94;
	Tue, 21 Jan 2020 18:18:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 35cmnOUWkbLe; Tue, 21 Jan 2020 18:18:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E184ACB8;
	Tue, 21 Jan 2020 18:18:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5838E4AC89
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 18:18:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tPgjgoIQ+7Su for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 18:18:35 -0500 (EST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B0844A541
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 18:18:35 -0500 (EST)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 21 Jan 2020 15:18:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; d="scan'208";a="227493488"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com)
 ([10.54.74.202])
 by orsmga003.jf.intel.com with ESMTP; 21 Jan 2020 15:18:33 -0800
Date: Tue, 21 Jan 2020 15:18:33 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 12/45] KVM: PPC: Allocate vcpu struct in common PPC code
Message-ID: <20200121231833.GB12692@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-13-sean.j.christopherson@intel.com>
 <20200120040412.GF14307@blackberry>
 <fcd2aaf1-6f6e-303a-d7c6-f6b0c0a4555c@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fcd2aaf1-6f6e-303a-d7c6-f6b0c0a4555c@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Greg Kurz <groug@kaod.org>,
 linux-arm-kernel@lists.infradead.org, James Hogan <jhogan@kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

T24gVHVlLCBKYW4gMjEsIDIwMjAgYXQgMTI6MDU6MDBQTSArMDEwMCwgUGFvbG8gQm9uemluaSB3
cm90ZToKPiBPbiAyMC8wMS8yMCAwNTowNCwgUGF1bCBNYWNrZXJyYXMgd3JvdGU6Cj4gPiBPbiBX
ZWQsIERlYyAxOCwgMjAxOSBhdCAwMTo1NDo1N1BNIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOgo+ID4+IE1vdmUgYWxsb2NhdGlvbiBvZiBhbGwgZmxhdm9ycyBvZiBQUEMgdkNQVXMg
dG8gY29tbW9uIFBQQyBjb2RlLiAgQWxsCj4gPj4gdmFyaWFudHMgZWl0aGVyIGFsbG9jYXRlICdz
dHJ1Y3Qga3ZtX3ZjcHUnIGRpcmVjdGx5LCBvciByZXF1aXJlIHRoYXQKPiA+PiB0aGUgZW1iZWRk
ZWQgJ3N0cnVjdCBrdm1fdmNwdScgbWVtYmVyIGJlIGxvY2F0ZWQgYXQgb2Zmc2V0IDAsIGkuZS4K
PiA+PiBndWFyYW50ZWUgdGhhdCB0aGUgYWxsb2NhdGlvbiBjYW4gYmUgZGlyZWN0bHkgaW50ZXJw
cmV0ZWQgYXMgYSAnc3RydWN0Cj4gPj4ga3ZtX3ZjcHUnIG9iamVjdC4KPiA+Pgo+ID4+IFJlbW92
ZSB0aGUgbWVzc2FnZSBmcm9tIHRoZSBidWlsZC10aW1lIGFzc2VydGlvbiByZWdhcmRpbmcgcGxh
Y2VtZW50IG9mCj4gPj4gdGhlIHN0cnVjdCwgYXMgY29tcGF0aWJpbGl0eSB3aXRoIHRoZSBhcmNo
IHVzZXJjb3B5IHJlZ2lvbiBpcyBubyBsb25nZXIKPiA+PiB0aGUgc29sZSBkZXBlbmRlbnQgb24g
J3N0cnVjdCBrdm1fdmNwdScgYmVpbmcgYXQgb2Zmc2V0IHplcm8uCj4gPj4KPiA+PiBTaWduZWQt
b2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwu
Y29tPgo+ID4gCj4gPiBUaGlzIGZhaWxzIHRvIGNvbXBpbGUgZm9yIEJvb2sgRSBjb25maWdzOgo+
ID4gCj4gPiAgIENDICAgICAgYXJjaC9wb3dlcnBjL2t2bS9lNTAwLm8KPiA+IC9ob21lL3BhdWx1
cy9rZXJuZWwva3ZtL2FyY2gvcG93ZXJwYy9rdm0vZTUwMC5jOiBJbiBmdW5jdGlvbiDigJhrdm1w
cGNfY29yZV92Y3B1X2NyZWF0ZV9lNTAw4oCZOgo+ID4gL2hvbWUvcGF1bHVzL2tlcm5lbC9rdm0v
YXJjaC9wb3dlcnBjL2t2bS9lNTAwLmM6NDY0Ojk6IGVycm9yOiByZXR1cm4gbWFrZXMgaW50ZWdl
ciBmcm9tIHBvaW50ZXIgd2l0aG91dCBhIGNhc3QgWy1XZXJyb3I9aW50LWNvbnZlcnNpb25dCj4g
PiAgIHJldHVybiB2Y3B1Owo+ID4gICAgICAgICAgXgo+ID4gY2MxOiBhbGwgd2FybmluZ3MgYmVp
bmcgdHJlYXRlZCBhcyBlcnJvcnMKPiA+IG1ha2VbM106ICoqKiBbL2hvbWUvcGF1bHVzL2tlcm5l
bC9rdm0vc2NyaXB0cy9NYWtlZmlsZS5idWlsZDoyNjY6IGFyY2gvcG93ZXJwYy9rdm0vZTUwMC5v
XSBFcnJvciAxCj4gPiAKPiA+IFRoZXJlIGlzIGEgInJldHVybiB2Y3B1IiBzdGF0ZW1lbnQgaW4g
a3ZtcHBjX2NvcmVfdmNwdV9jcmVhdGVfZTUwMCgpLAo+ID4gYW5kIGFub3RoZXIgaW4ga3ZtcHBj
X2NvcmVfdmNwdV9jcmVhdGVfZTUwMG1jKCksIHdoaWNoIGJvdGggbmVlZCB0byBiZQo+ID4gY2hh
bmdlZCB0byAicmV0dXJuIDAiLgo+ID4gCj4gPiAoQnkgdGhlIHdheSwgSSBkbyBhcHByZWNpYXRl
IHlvdSBmaXhpbmcgdGhlIFBQQyBjb2RlLCBldmVuIGlmIHRoZXJlCj4gPiBhcmUgc29tZSBlcnJv
cnMuKQo+IAo+IFNxdWFzaGVkOgoKVGhhbmtzIGZvciBjbGVhbmluZyB1cCBhZnRlciBtZSwgbm90
IGhhdmluZyB0byByZWJhc2UgYW5kIHJlc2VuZCB0aGlzCnNlcmllcyBtYWRlIG15IGRheSA6LSkg
Cgo+IGRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva3ZtL2U1MDAuYyBiL2FyY2gvcG93ZXJwYy9r
dm0vZTUwMC5jCj4gaW5kZXggOTZkOWNkZTNkMmUzLi5mNWRkMmM3YWRjZDQgMTAwNjQ0Cj4gLS0t
IGEvYXJjaC9wb3dlcnBjL2t2bS9lNTAwLmMKPiArKysgYi9hcmNoL3Bvd2VycGMva3ZtL2U1MDAu
Ywo+IEBAIC00NjEsNyArNDYxLDcgQEAgc3RhdGljIGludCBrdm1wcGNfY29yZV92Y3B1X2NyZWF0
ZV9lNTAwKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICAJCWdvdG8g
dW5pbml0X3RsYjsKPiAgCX0KPiAgCj4gLQlyZXR1cm4gdmNwdTsKPiArCXJldHVybiAwOwo+ICAK
PiAgdW5pbml0X3RsYjoKPiAgCWt2bXBwY19lNTAwX3RsYl91bmluaXQodmNwdV9lNTAwKTsKPiBk
aWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2t2bS9lNTAwbWMuYyBiL2FyY2gvcG93ZXJwYy9rdm0v
ZTUwMG1jLmMKPiBpbmRleCBhZWE1ODhmNzNiZjcuLjdjMGQzOTJmNjY3YSAxMDA2NDQKPiAtLS0g
YS9hcmNoL3Bvd2VycGMva3ZtL2U1MDBtYy5jCj4gKysrIGIvYXJjaC9wb3dlcnBjL2t2bS9lNTAw
bWMuYwo+IEBAIC0zMjcsNyArMzI3LDcgQEAgc3RhdGljIGludCBrdm1wcGNfY29yZV92Y3B1X2Ny
ZWF0ZV9lNTAwbWMoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUKPiAgCQln
b3RvIHVuaW5pdF90bGI7Cj4gIAl9Cj4gIAo+IC0JcmV0dXJuIHZjcHU7Cj4gKwlyZXR1cm4gMDsK
PiAgCj4gIHVuaW5pdF90bGI6Cj4gIAlrdm1wcGNfZTUwMF90bGJfdW5pbml0KHZjcHVfZTUwMCk7
Cj4gCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
