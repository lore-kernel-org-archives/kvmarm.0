Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7752EC433B4
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 14:44:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AAAC9611C2
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 14:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAAC9611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA6D54B3D6;
	Mon,  3 May 2021 10:44:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WFcdsfLb2BCn; Mon,  3 May 2021 10:44:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9FD74B271;
	Mon,  3 May 2021 10:44:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8A94B271
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 10:44:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cTLeJ+NUTB0l for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 10:44:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC8F4B25E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 10:44:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620053079;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bl56Zu7+zy9TZvZXab3dG9cf65Q5oyc9UzIYD23qD4o=;
 b=D2fF/HEL+1ciYXkZ2MJ6BsOMG3EPFK0N0qDpEhwk7oFCOp5ojLWognEzpYMRkDbXagtws3
 Q4UnHsNpXdd98K5SZVex2kucRdz/vsfgIWpipquinR9PqkUhUEK4zyJxrv6pie6gHeusN0
 5U0jH9bTVL/fA+j8WUaMcKnWc92Q3MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-5OtKC6mePom9ceq1518erg-1; Mon, 03 May 2021 10:44:35 -0400
X-MC-Unique: 5OtKC6mePom9ceq1518erg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A85E100A24D;
 Mon,  3 May 2021 14:44:33 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com
 [10.3.113.225])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C8BF95C1D0;
 Mon,  3 May 2021 14:44:32 +0000 (UTC)
Date: Mon, 3 May 2021 08:44:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Vikram Sethi <vsethi@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210503084432.75e0126d@x1.home.shazbot.org>
In-Reply-To: <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
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
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

T24gTW9uLCAzIE1heSAyMDIxIDEzOjU5OjQzICswMDAwClZpa3JhbSBTZXRoaSA8dnNldGhpQG52
aWRpYS5jb20+IHdyb3RlOgoKPiA+IEZyb206IE1hcmsgS2V0dGVuaXMgPG1hcmsua2V0dGVuaXNA
eHM0YWxsLm5sPiAgCj4gPiA+IEZyb206IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+ICAK
PiAKPiBzbmlwCj4gPiA+IElmLCBieSBlbnVtZXJhdGluZyB0aGUgcHJvcGVydGllcyBvZiBQcmVm
ZXRjaGFibGUsIHlvdSBjYW4gc2hvdyB0aGF0Cj4gPiA+IHRoZXkgYXJlIGEgc3RyaWN0IHN1cGVy
c2V0IG9mIE5vcm1hbF9OQywgSSdtIG9uIGJvYXJkLiBJIGhhdmVuJ3Qgc2Vlbgo+ID4gPiBzdWNo
IGFuIGVudW1lcmF0aW9uIHNvIGZhci4KPiA+ID4gIAo+IHNuaXAKPiA+ID4gUmlnaHQsIHNvIHdl
IGhhdmUgbWFkZSBhIHNtYWxsIHN0ZXAgaW4gdGhlIGRpcmVjdGlvbiBvZiBtYXBwaW5nCj4gPiA+
ICJwcmVmZXRjaGFibGUiIG9udG8gIk5vcm1hbF9OQyIsIHRoYW5rcyBmb3IgdGhhdC4gV2hhdCBh
Ym91dCBhbGwgdGhlCj4gPiA+IG90aGVyIHByb3BlcnRpZXMgKHVuYWxpZ25lZCBhY2Nlc3Nlcywg
b3JkZXJpbmcsIGdhdGhlcmluZyk/ICAKPiA+ICAgCj4gUmVnYXJkaW5nIGdhdGhlcmluZy93cml0
ZSBjb21iaW5pbmcsIHRoYXQgaXMgYWxzbyBhbGxvd2VkIHRvIHByZWZldGNoYWJsZSBwZXIgUENJ
IHNwZWMKCkFzIG90aGVycyBoYXZlIHN0YXRlZCwgZ2F0aGVyL3dyaXRlIGNvbWJpbmluZyBpdHNl
bGYgaXMgbm90IHdlbGwKZGVmaW5lZC4KCj4gRnJvbSAxLjMuMi4yIG9mIDUvMCBiYXNlIHNwZWM6
Cj4gQSBQQ0kgRXhwcmVzcyBFbmRwb2ludCByZXF1ZXN0aW5nIG1lbW9yeSByZXNvdXJjZXMgdGhy
b3VnaCBhIEJBUiBtdXN0IHNldCB0aGUgQkFSJ3MgUHJlZmV0Y2hhYmxlIGJpdCB1bmxlc3MKPiB0
aGUgcmFuZ2UgY29udGFpbnMgbG9jYXRpb25zIHdpdGggcmVhZCBzaWRlLWVmZmVjdHMgb3IgbG9j
YXRpb25zIGluIHdoaWNoIHRoZSBGdW5jdGlvbiBkb2VzIG5vdCB0b2xlcmF0ZSB3cml0ZQo+IG1l
cmdpbmcuCgoid3JpdGUgbWVyZ2luZyIgIFRoaXMgaXMgYSB2ZXJ5IHNwZWNpZmljIHRoaW5nLCBw
ZXIgUENJIDMuMCwgMy4yLjY6CgogIEJ5dGUgTWVyZ2luZyDigJMgb2NjdXJzIHdoZW4gYSBzZXF1
ZW5jZSBvZiBpbmRpdmlkdWFsIG1lbW9yeSB3cml0ZXMKICAoYnl0ZXMgb3Igd29yZHMpIGFyZSBt
ZXJnZWQgaW50byBhIHNpbmdsZSBEV09SRC4KClRoZSBzZW1hbnRpY3Mgc3VnZ2VzdCBxdWFkd29y
ZCBzdXBwb3J0IGluIGFkZGl0aW9uIHRvIGR3b3JkLCBidXQgZG9uJ3QKcmVxdWlyZSBpdC4gIFdy
aXRlcyB0byBieXRlcyB3aXRoaW4gYSBkd29yZCBjYW4gYmUgbWVyZ2VkLCBidXQKZHVwbGljYXRl
IHdyaXRlcyBjYW5ub3QuCgpJdCBzZWVtcyBsaWtlIGFuIGV4dHJlbWVseSBsaWJlcmFsIGFwcGxp
Y2F0aW9uIHRvIHN1Z2dlc3QgdGhhdCB0aGlzIG9uZQp3cml0ZSBzZW1hbnRpYyBlbmNvbXBhc3Nl
cyBmdWxsIHdyaXRlIGNvbWJpbmluZyBzZW1hbnRpY3MsIHdoaWNoIGl0c2VsZgppcyBub3QgY2xl
YXJseSBkZWZpbmVkLgoKPiBGdXJ0aGVyIDcuNS4xLjIuMSBzYXlzICIgQSBGdW5jdGlvbiBpcyBw
ZXJtaXR0ZWQKPiB0byBtYXJrIGEgcmFuZ2UgYXMgcHJlZmV0Y2hhYmxlIGlmIHRoZXJlIGFyZSBu
byBzaWRlIGVmZmVjdHMgb24gcmVhZHMsIHRoZSBGdW5jdGlvbiByZXR1cm5zIGFsbCBieXRlcyBv
biByZWFkcyByZWdhcmRsZXNzIG9mCj4gdGhlIGJ5dGUgZW5hYmxlcywgYW5kIGhvc3QgYnJpZGdl
cyBjYW4gbWVyZ2UgcHJvY2Vzc29yIHdyaXRlcyBpbnRvIHRoaXMgcmFuZ2UxMzkgd2l0aG91dCBj
YXVzaW5nIGVycm9ycyIKPiAKPiBUaGUgInJlZ2FyZGxlc3Mgb2YgYnl0ZSBlbmFibGVzIiBzdWdn
ZXN0cyB0byBtZSB0aGF0IHVuYWxpZ25lZCBpcyBPSywgYXMgb25seSAKPiBjZXJ0YWluIGJ5dGUg
ZW5hYmxlcyBtYXkgYmUgc2V0LCB3aGF0IGRvIHlvdSB0aGluaz8KPiAKPiBTbyB0byBtZSBwcmVm
ZXRjaGFibGUgaW4gUENJZSBzcGVjIGFsbG93cyBmb3Igd3JpdGUgY29tYmluaW5nLCByZWFkIHdp
dGhvdXQKCklyb25pY2FsbHkgaGVyZSwgdGhlIGFib3ZlIFBDSSBzcGVjIHNlY3Rpb24gZGVmaW5p
bmcgd3JpdGUgbWVyZ2luZyBoYXMKc2VwYXJhdGUgc2VjdGlvbnMgZm9yICJjb21iaW5pbmciLCAi
bWVyZ2luZyIsIGFuZCAiY29sbGFwc2luZyIuICBPbmx5Cm1lcmdpbmcgaXMgaW5kaWNhdGVkIGFz
IGEgcmVxdWlyZW1lbnQgZm9yIHByZWZldGNoYWJsZSByZXNvdXJjZXMuCgo+IHNpZGVlZmZlY3Qg
KHByZWZldGNoL3NwZWN1bGF0aXZlIGFzIGxvbmcgYXMgdW5jYWNoZWQpLCBhbmQgdW5hbGlnbmVk
LiBSZWdhcmRpbmcKPiBvcmRlcmluZyBJIGRpZG4ndCBmaW5kIGEgc3RhdGVtZW50IG9uZSB3YXkg
b3Igb3RoZXIgaW4gUENJZSBwcmVmZXRjaGFibGUgZGVmaW5pdGlvbiwgYnV0Cj4gSSB0aGluayB0
aGF0IGdvZXMgYmV5b25kIHdoYXQgUENJZSBzYXlzIG9yIGRvZXNuJ3Qgc2F5IGFueXdheSBzaW5j
ZSByZW9yZGVyaW5nIGNhbiAKPiBhbHNvIGhhcHBlbiBpbiB0aGUgQ1BVLCBhbmQgc2luY2UgZHJp
dmVyIG11c3QgYmUgYXdhcmUgb2YgY29ycmVjdG5lc3MgaXNzdWVzIGluIGl0cyAKPiBwcm9kdWNl
ci9jb25zdW1lciBtb2RlbHMgaXQgd2lsbCBuZWVkIHRoZSByaWdodCBiYXJyaWVycyB3aGVyZSB0
aGV5IGFyZSByZXF1aXJlZCAKPiBmb3IgY29ycmVjdG5lc3MgYW55d2F5IChyZXF1aXJlZCBmb3Ig
dGhlIGRyaXZlci91c2Vyc3BhY2UgdG8gd29yayBvbiBob3N0IHcvIGlvcmVtYXBfd2MpLgoKQSBs
b3Qgb2YgaGFuZCB3YXZpbmcgaGVyZSwgaW1vLiAgVGhhbmtzLAoKQWxleAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
