Return-Path: <SRS0=Rb5J=J7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819C0C43461
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 18:03:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 001E7610EA
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 18:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 001E7610EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B3ED4B4E8;
	Tue,  4 May 2021 14:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BsqR2RZ+m9k7; Tue,  4 May 2021 14:03:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 104EB4B380;
	Tue,  4 May 2021 14:03:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ED3C4B380
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 14:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qwLchIHKuUhS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 May 2021 14:03:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3C84B2E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 14:03:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620151434;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=crIjxSKc9RicXz5uU0iWJNjyfJ75605vwRv4rA88bAc=;
 b=gpHXQycL4j1chUFogkUq3N3XYM51I0LG5ZdwWX48Dko7I3NabRp6/taOl6StPF0HX8x6C5
 XSH7sSZm7qvFLMfppTaOkjF2+mlpSe6pyKJrVzhb5u8HomiNge0XTT1ZE5B7Dir4tc6MKo
 O8Gr3kxW2y6wLmNaY0/qiEoM7lQJuWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-UeGCIxtyO5OSuVhwk3SZ8A-1; Tue, 04 May 2021 14:03:51 -0400
X-MC-Unique: UeGCIxtyO5OSuVhwk3SZ8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE4AA107ACED;
 Tue,  4 May 2021 18:03:49 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0F9921002388;
 Tue,  4 May 2021 18:03:49 +0000 (UTC)
Date: Tue, 4 May 2021 12:03:48 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Vikram Sethi <vsethi@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210504120348.2eec075b@redhat.com>
In-Reply-To: <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
 <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 Jason Sequeira <jsequeira@nvidia.com>, "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Mark Kettenis <mark.kettenis@xs4all.nl>
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

T24gTW9uLCAzIE1heSAyMDIxIDIyOjAzOjU5ICswMDAwClZpa3JhbSBTZXRoaSA8dnNldGhpQG52
aWRpYS5jb20+IHdyb3RlOgoKPiBIaSBBbGV4LAo+ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxh
bGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4KPiA+IE9uIE1vbiwgMyBNYXkgMjAyMSAxMzo1OTo0
MyArMDAwMAo+ID4gVmlrcmFtIFNldGhpIDx2c2V0aGlAbnZpZGlhLmNvbT4gd3JvdGU6ICAKPiA+
ID4gPiBGcm9tOiBNYXJrIEtldHRlbmlzIDxtYXJrLmtldHRlbmlzQHhzNGFsbC5ubD4gIAo+ID4g
PiA+ID4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4gIAo+ID4gPgo+ID4gPiBz
bmlwICAKPiA+ID4gPiA+IElmLCBieSBlbnVtZXJhdGluZyB0aGUgcHJvcGVydGllcyBvZiBQcmVm
ZXRjaGFibGUsIHlvdSBjYW4gc2hvdwo+ID4gPiA+ID4gdGhhdCB0aGV5IGFyZSBhIHN0cmljdCBz
dXBlcnNldCBvZiBOb3JtYWxfTkMsIEknbSBvbiBib2FyZC4gSQo+ID4gPiA+ID4gaGF2ZW4ndCBz
ZWVuIHN1Y2ggYW4gZW51bWVyYXRpb24gc28gZmFyLgo+ID4gPiA+ID4gIAo+ID4gPiBzbmlwICAK
PiA+ID4gPiA+IFJpZ2h0LCBzbyB3ZSBoYXZlIG1hZGUgYSBzbWFsbCBzdGVwIGluIHRoZSBkaXJl
Y3Rpb24gb2YgbWFwcGluZwo+ID4gPiA+ID4gInByZWZldGNoYWJsZSIgb250byAiTm9ybWFsX05D
IiwgdGhhbmtzIGZvciB0aGF0LiBXaGF0IGFib3V0IGFsbAo+ID4gPiA+ID4gdGhlIG90aGVyIHBy
b3BlcnRpZXMgKHVuYWxpZ25lZCBhY2Nlc3Nlcywgb3JkZXJpbmcsIGdhdGhlcmluZyk/ICAKPiA+
ID4gPiAgCj4gPiA+IFJlZ2FyZGluZyBnYXRoZXJpbmcvd3JpdGUgY29tYmluaW5nLCB0aGF0IGlz
IGFsc28gYWxsb3dlZCB0bwo+ID4gPiBwcmVmZXRjaGFibGUgcGVyIFBDSSBzcGVjICAKPiA+IAo+
ID4gQXMgb3RoZXJzIGhhdmUgc3RhdGVkLCBnYXRoZXIvd3JpdGUgY29tYmluaW5nIGl0c2VsZiBp
cyBub3Qgd2VsbCBkZWZpbmVkLgo+ID4gICAKPiA+ID4gRnJvbSAxLjMuMi4yIG9mIDUvMCBiYXNl
IHNwZWM6Cj4gPiA+IEEgUENJIEV4cHJlc3MgRW5kcG9pbnQgcmVxdWVzdGluZyBtZW1vcnkgcmVz
b3VyY2VzIHRocm91Z2ggYSBCQVIgbXVzdAo+ID4gPiBzZXQgdGhlIEJBUidzIFByZWZldGNoYWJs
ZSBiaXQgdW5sZXNzIHRoZSByYW5nZSBjb250YWlucyBsb2NhdGlvbnMKPiA+ID4gd2l0aCByZWFk
IHNpZGUtZWZmZWN0cyBvciBsb2NhdGlvbnMgaW4gd2hpY2ggdGhlIEZ1bmN0aW9uIGRvZXMgbm90
IHRvbGVyYXRlICAKPiA+IHdyaXRlIG1lcmdpbmcuCj4gPiAKPiA+ICJ3cml0ZSBtZXJnaW5nIiAg
VGhpcyBpcyBhIHZlcnkgc3BlY2lmaWMgdGhpbmcsIHBlciBQQ0kgMy4wLCAzLjIuNjoKPiA+IAo+
ID4gICBCeXRlIE1lcmdpbmcg4oCTIG9jY3VycyB3aGVuIGEgc2VxdWVuY2Ugb2YgaW5kaXZpZHVh
bCBtZW1vcnkgd3JpdGVzCj4gPiAgIChieXRlcyBvciB3b3JkcykgYXJlIG1lcmdlZCBpbnRvIGEg
c2luZ2xlIERXT1JELgo+ID4gCj4gPiBUaGUgc2VtYW50aWNzIHN1Z2dlc3QgcXVhZHdvcmQgc3Vw
cG9ydCBpbiBhZGRpdGlvbiB0byBkd29yZCwgYnV0IGRvbid0Cj4gPiByZXF1aXJlIGl0LiAgV3Jp
dGVzIHRvIGJ5dGVzIHdpdGhpbiBhIGR3b3JkIGNhbiBiZSBtZXJnZWQsIGJ1dCBkdXBsaWNhdGUK
PiA+IHdyaXRlcyBjYW5ub3QuCj4gPiAKPiA+IEl0IHNlZW1zIGxpa2UgYW4gZXh0cmVtZWx5IGxp
YmVyYWwgYXBwbGljYXRpb24gdG8gc3VnZ2VzdCB0aGF0IHRoaXMgb25lIHdyaXRlCj4gPiBzZW1h
bnRpYyBlbmNvbXBhc3NlcyBmdWxsIHdyaXRlIGNvbWJpbmluZyBzZW1hbnRpY3MsIHdoaWNoIGl0
c2VsZiBpcyBub3QKPiA+IGNsZWFybHkgZGVmaW5lZC4KPiA+ICAKPiBUYWxraW5nIHRvIG91ciBQ
Q0llIFNJRyByZXByZXNlbnRhdGl2ZSwgUENJZSBzd2l0Y2hlcyBhcmUgbm90IGFsbG93ZWQgZG8g
YW55IG9mIHRoZSBieXRlCj4gTWVyZ2luZy9jb21iaW5pbmcgZXRjIGFzIGRlZmluZWQgaW4gdGhl
IFBDSSBzcGVjLCBhbmQgcGVyIGEgcmF0aGVyIHBvb3JseQo+IHdvcmRlZCBJbXBsZW1lbnRhdGlv
biBub3RlIGluIHRoZSBzcGVjIHNheXMgdGhhdCBubyBrbm93biBQQ0llIEhvc3QgQnJpZGRnZXMv
Um9vdCAKPiBwb3J0cyBkbyBpdCBlaXRoZXIuIAo+IFNvIGZvciBQQ0llIHdlIGRvbid0IHRoaW5r
IGJlbGlldmUgdGhlcmUgaXMgYW55IGJ5dGUgbWVyZ2luZyB0aGF0IGhhcHBlbnMgaW4gdGhlIFBD
SWUKPiBmYWJyaWMgc28gaXQncyByZWFsbHkgYSBtYXR0ZXIgb2Ygd2hhdCBoYXBwZW5zIGluIHRo
ZSBDUFUgY29yZSBhbmQgaW50ZXJjb25uZWN0Cj4gYmVmb3JlIGl0IGdldHMgdG8gdGhlIFBDSWUg
aGllcmFyY2h5LgoKWWVzLCBidXQgbWVyZ2VkIHdyaXRlcywgbm8gbWF0dGVyIHdoZXJlIHRoZXkg
aGFwcGVuLCBhcmUgc3RpbGwgdGhlIG9ubHkKdHlwZSBvZiB3cml0ZSBjb21iaW5pbmcgdGhhdCBh
IHByZWZldGNoYWJsZSBCQVIgb24gYW4gZW5kcG9pbnQgaXMKcmVxdWlyZWQgdG8gc3VwcG9ydC4K
Cj4gU3RlcHBpbmcgYmFjayBmcm9tIHRoaXMgcGF0Y2hzZXQsIGRvIHlvdSBhZ3JlZSB0aGF0IGl0
IGlzIGRlc2lyYWJsZSB0byBzdXBwb3J0Cj4gV3JpdGUgY29tYmluaW5nIGFzIHVuZGVyc3Rvb2Qg
YnkgaW9yZW1hcF93YyB0byB3b3JrIGluIGFsbCBJU0EgZ3Vlc3RzIGluY2x1ZGluZwo+IEFSTXY4
PwoKWWVzLCBhIHVzZXJzcGFjZSB2ZmlvIGRyaXZlciBzaG91bGQgYmUgYWJsZSB0byB0YWtlIGFk
dmFudGFnZSBvZiB0aGUKaGFyZHdhcmUgY2FwYWJpbGl0aWVzLiAgSSB0aGluayB3aGVyZSB3ZSBk
aXNhZ3JlZSBpcyB3aGV0aGVyIGl0J3MKdW5pdmVyc2FsbHkgc2FmZSB0byBhc3N1bWUgd3JpdGUg
Y29tYmluaW5nIGJhc2VkIG9uIHRoZSBQQ0kKcHJlZmV0Y2hhYmxlIGNhcGFiaWxpdHkgb2YgYSBC
QVIuICBJZiB0aGF0J3Mgc29tZXRoaW5nIHRoYXQgY2FuIGJlCmFzc3VtZWQgdW5pdmVyc2FsbHkg
Zm9yIEFSTXY4IGJhc2VkIG9uIHRoZSBhcmNoaXRlY3R1cmUgc3BlY2lmaWNhdGlvbgpjb21wYXRp
YmlsaXR5IHdpdGggdGhlIFBDSSBkZWZpbml0aW9uIG9mIGEgcHJlZmV0Y2hhYmxlIEJBUiwgdGhl
biBJCndvdWxkIGV4cGVjdCBhIGhlbHBlciBzb21ld2hlcmUgaW4gYXJjaCBjb2RlIHRoYXQgcmV0
dXJucyB0aGUgcmlnaHQKcGFnZSBwcm90ZWN0aW9uIGZsYWdzLCBzbyB0aGF0IGFyY2ggbWFpbnRh
aW5lcnMgZG9uJ3QgbmVlZCB0byBzY291cgpkZXZpY2UgZHJpdmVycyBmb3IgYXJjaGl0ZWN0dXJl
IGhhY2tzLiAgT3RoZXJ3aXNlLCBpdCBuZWVkcyB0byBiZQpleHBvc2VkIHRocm91Z2ggdGhlIHZm
aW8gdUFQSSB0byBhbGxvdyB0aGUgdXNlcnNwYWNlIGRldmljZSBkcml2ZXIKaXRzZWxmIHRvIHNl
bGVjdCB0aGVzZSBzZW1hbnRpY3MuCgo+IFlvdSBub3RlIHRoYXQgeDg2IHZpcnR1YWxpemF0aW9u
IGRvZXNuJ3QgaGF2ZSB0aGlzIGlzc3VlLCBidXQgS1ZNLUFSTSBkb2VzCj4gYmVjYXVzZSBLVk0g
bWFwcyBhbGwgZGV2aWNlIEJBUnMgYXMgRGV2aWNlIE1lbW9yeSB0eXBlIG5HblJFIHdoaWNoIAo+
IGRvZXNuJ3QgYWxsb3cgaW9yZW1hcF93YyBmcm9tIHdpdGhpbiB0aGUgZ3Vlc3QgdG8gZ2V0IHRo
ZSBhY3R1YWwgc2VtYW50aWNzIGRlc2lyZWQuCj4gCj4gTWFyYyBhbmQgb3RoZXJzIGhhdmUgc3Vn
Z2VzdGVkIHRoYXQgdXNlcnNwYWNlIHNob3VsZCBwcm92aWRlIHRoZSBoaW50cy4gQnV0IHRoZQo+
IHF1ZXN0aW9uIGlzIGhvdyB3b3VsZCBxZW11IHZmaW8gZG8gdGhpcyBlaXRoZXI/IFdlIHdvdWxk
IGJlIHN0dWNrIGluIHRoZSBzYW1lCj4gYXJndW1lbnRzIGFzIGhlcmUsIGFzIHRvIHdoYXQgaXMg
dGhlIGNvcnJlY3Qgd2F5IHRvIGRldGVybWluZSB0aGUgZGVzaXJlZCBhdHRyaWJ1dGVzCj4gZm9y
IGEgZ2l2ZW4gQkFSIHN1Y2ggdGhhdCBldmVudHVhbGx5IHdoZW4gYSBkcml2ZXIgaW4gdGhlIGd1
ZXN0IGFza3MgZm9yCj4gaW9yZW1hcF93YyBpdCBhY3R1YWxseSBoYXMgYSBjaGFuY2Ugb2Ygd29y
a2luZyBpbiB0aGUgZ3Vlc3QsIGluIGFsbCBJU0FzLiAKPiBEbyB5b3UgaGF2ZSBhbnkgc3VnZ2Vz
dGlvbnMgb24gaG93IHRvIG1ha2UgcHJvZ3Jlc3MgaGVyZT8KCldlIGRvIG5lZWQgc29tZSB3YXkg
Zm9yIHVzZXJzcGFjZSBkcml2ZXJzIHRvIGFsc28gbWFrZSB1c2Ugb2YgV0MKc2VtYW50aWNzLCB0
aGVyZSB3ZXJlIHNvbWUgZGlzY3Vzc2lvbnMgaW4gdGhlIHBhc3QsIEkgdGhpbmsgb3RoZXJzIGhh
dmUKcmVmZXJlbmNlZCB0aGVtIGFzIHdlbGwsIGJ1dCBub3RoaW5nIGhhcyBiZWVuIHByb3Bvc2Vk
IGZvciBhIHZmaW8gQVBJLgoKSWYgd2UgaGFkIHRoYXQgQVBJLCBRRU1VIGRlY2lkaW5nIHRvIHVu
aXZlcnNhbGx5IGVuYWJsZSBXQyBmb3IgYWxsCnZmaW8gcHJlZmV0Y2hhYmxlIEJBUnMgc2VlbXMg
b25seSBtYXJnaW5hbGx5IGJldHRlciB0aGFuIHRoaXMgYXBwcm9hY2guClVsdGltYXRlbHkgdGhl
IG1hcHBpbmcgc2hvdWxkIGJlIGJhc2VkIG9uIHRoZSBndWVzdCBkcml2ZXIgc2VtYW50aWNzLAph
bmQgaWYgeW91IGRvbid0IGhhdmUgYW55IHZpc2liaWxpdHkgdG8gdGhhdCBvbiBLVk0vYXJtIGxp
a2Ugd2UgaGF2ZSBvbgpLVk0veDg2LCB0aGVuIGl0IHNlZW1zIGxpa2UgdGhlcmUncyBub3RoaW5n
IHRvIHRyaWdnZXIgYSB2ZmlvIEFQSSBoZXJlCmFueXdheS4KCklmIHRoYXQncyB0aGUgY2FzZSwg
SSdkIHByb2JhYmx5IGdvIGJhY2sgdG8gbGV0dGluZyB0aGUgYXJjaC9hcm02NCBmb2xrcwpkZWNs
YXJlIHRoYXQgV0MgaXMgY29tcGF0aWJsZSB3aXRoIHRoZSBkZWZpbml0aW9uIG9mIFBDSSBwcmVm
ZXRjaGFibGUKYW5kIGV4cG9ydCBzb21lIHNvcnQgb2YgcGdwcm90X3BjaV9wcmVmZXRjaGFibGUo
KSBoZWxwZXIgd2hlcmUgdGhlCmRlZmF1bHQgd291bGQgYmUgdG8gI2RlZmluZSBpdCBhcyBwZ3By
b2Nfbm9uY2FjaGVkKCkgI2lmbmRlZiBieSB0aGUKYXJjaC4KCj4gQSBkZXZpY2Ugc3BlY2lmaWMg
bGlzdCBvZiB3aGljaCBCQVJzIGFyZSBPSyB0byBhbGxvdyBpb3JlbWFwX3djIGZvciBzZWVtcyB0
ZXJyaWJsZQo+IGFuZCBJJ20gbm90IHN1cmUgaWYgYSBjb21tYW5kbGluZSBxZW11IG9wdGlvbiBp
cyBhbnkgYmV0dGVyLiBJcyB0aGUgdXNlciBvZiBkZXZpY2UgCj4gYXNzaWdubWVudC9zeXNhZG1p
biBzdXBwb3NlZCB0byBrbm93IHdoaWNoIEJBUiBvZiB3aGljaCBkZXZpY2UgaXMgT0sgdG8gYWxs
b3cgCj4gaW9yZW1hcF93YyBmb3I/CgpObywgYSBkZXZpY2Ugc3BlY2lmaWMgdXNlcnNwYWNlIGRy
aXZlciBzaG91bGQga25vdyBzdWNoIGRldmljZQpzZW1hbnRpY3MsIGJ1dCBRRU1VIGlzIG5vdCBz
dWNoIGEgZHJpdmVyLiAgQnVyZGVuaW5nIHRoZSBoeXBlcnZpc29yCnVzZXIvYWRtaW4gaXMgbm90
IGEgZ29vZCBzb2x1dGlvbiBlaXRoZXIuICBJJ2QgbGVhbiBvbiBLVk0vYXJtNjQgZm9sa3MKdG8g
a25vdyBob3cgdGhlIGd1ZXN0IGRyaXZlciBzZW1hbnRpY3MgY2FuIGJlIGV4cG9zZWQgdG8gdGhl
Cmh5cGVydmlzb3IuICBUaGFua3MsCgpBbGV4CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
