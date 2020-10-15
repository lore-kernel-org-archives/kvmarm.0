Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB84C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:35:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49C182222B
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kigb0xG1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49C182222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4124B6FC;
	Thu, 15 Oct 2020 09:35:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxZfKlyZQJid; Thu, 15 Oct 2020 09:35:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548914B69D;
	Thu, 15 Oct 2020 09:35:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E1454B648
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:35:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3UH-EkO8m9da for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 09:35:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0794B644
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:35:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1602768937;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2KO6fi08NfGByxXZfKo9I5VP3nl/DbBwbTw76hSITJQ=;
 b=Kigb0xG12JOJxDHARXsT8qwSW1tuOME470IYXUN+ksCR2o/Ab0RacctudqCVvYIjiiQZCB
 R0+CmI1pbGW4W5U3r6sVGH9i0PeJlPJohosTFW5lILsyxP0RikZYUV/Jn092yuKUmVTrL1
 obnQWdd42tcWtStJC90j7owr/liXYWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-t3pzo8Y2PzSqLcRVUCrWHg-1; Thu, 15 Oct 2020 09:35:31 -0400
X-MC-Unique: t3pzo8Y2PzSqLcRVUCrWHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 762AA5705E;
 Thu, 15 Oct 2020 13:35:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D088A76663;
 Thu, 15 Oct 2020 13:35:07 +0000 (UTC)
Date: Thu, 15 Oct 2020 15:35:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: Kernel patch cases qemu live migration failed.
Message-ID: <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
 <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>, xu910121@sina.com,
 qemu-devel <qemu-devel@nongnu.org>, "Dave.Martin" <dave.martin@arm.com>
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

T24gVGh1LCBPY3QgMTUsIDIwMjAgYXQgMTI6MjY6MTBQTSArMDEwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IEhpCj4gCj4gUGxlYXNlIGRvbid0IHVzZSBteSBhcm0uY29tIGFkZHJlc3MgYW55bW9y
ZSwgbm9ib2R5IHJlYWRzIGl0Li4uCj4gCj4gT24gMjAyMC0xMC0xNSAwNTowNiwg5byg5Lic5pet
IHdyb3RlOgo+ID4gSSdtIHNvIHNvcnJ5IGZvciBkaXN0dXJiaW5nIHlvdS4KPiA+IAo+ID4gV2hl
biBJIGFwcGx5IHRoaXMga2VybmVsIHBhdGNo77yaS1ZNOiBhcm02NC9zdmU6IFN5c3RlbSByZWdp
c3Rlcgo+ID4gY29udGV4dCBzd2l0Y2ggYW5kIGFjY2VzcyBzdXBwb3J0Cj4gPiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQv
Y29tbWl0L2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmM/aWQ9NzM0MzM3NjJmY2FlYjlkNTllODRk
Mjk5MDIxYzZiMTU0NjZjOTZkZAo+IAo+IFRoaXMgcGF0Y2ggd2FzIG9ubHkgaW50cm9kdWNlZCBp
biA1LjIsIGFuZCB3YXNuJ3Qgc3VwcG9zZWQgdG8gYmUKPiBiYWNrcG9ydGVkIHRvIGFueXRoaW5n
IGVsc2UuCgpBbGwgdXBzdHJlYW0gcGF0Y2hlcyBhcmUgYmFja3BvcnQgY2FuZGlkYXRlcy4gV2Vs
Y29tZSB0byBSSEVMIDotKQoKPiAKPiA+IHFlbXUgbGl2ZSBtaWdyYXRpb24gd2lsbCBmYWlsZWQg
d2l0aCBtZXNzYWdlc++8mgo+ID4gICAgICAgICAgICAgICDigItxZW11LWt2bTogSW52YWxpZCB2
YWx1ZSAyMzMgZXhwZWN0aW5nIHBvc2l0aXZlIHZhbHVlCj4gPiA8PSAyMzIKPiA+ICAgICAgICAg
ICAgICAgcWVtdS1rdm06IEZhaWxlZCB0byBsb2FkIGNwdTpjcHJlZ192bXN0YXRlX2FycmF5X2xl
bgo+ID4gTmV3IHZlcnNpb24ga2VybmVsICBleGNsdWRlIElEX0FBNjRaRlIwX0VMMSByZWdpc3Rl
ciB3aGVuIGhvc3Qgbm90Cj4gPiBzdXBwb3J0IFNWRSBmZWF0dXJlLAo+ID4gc28gcWVtdSBpb2N0
bCBrdm0oS1ZNX0dFVF9SRUdfTElTVCkgd2lsbCBub3QgY29udGFpbiBJRF9BQTY0WkZSMF9FTDEK
PiA+IHJlZ2lzdGVyLgo+ID4gCj4gPiBJJ20gdXNpbmcgQ2VudE9TIExpbnV4IGtlcm5lbCwgb2xk
IGtlcm5lbCB2ZXJzaW9u77yaNC4xOC4wLTgwLjExLmVsOAo+ID4gKG1pZ3JhdGlvbiBzb3VyY2Up
Cj4gPiAgICAgICBuZXcga2VybmVsIHZlcnNpb27vvJo0LjE4LjAtMTQ3LjUuZWw4IChtaWdyYXRp
b24gZGVzdGluYXRpb24pCj4gPiAKPiA+IENlbnRPUyBsaW51eCBrZXJuZWwgdmVyc2lvbiA0LjE4
LjAtMTExLmVsOCBhcHBsaWVkIHRoaXMgcGF0Y2guIFNvCj4gPiA0LjE4LjAtMTQ3LjUuZWw4IGFs
c28gYXBwbGllZCB0aGlzIHBhdGNoLgo+ID4gCj4gPiBNaWdyYXRpb24gc291cmNlIGFuZCBkZXN0
aW5hdGlvbiBob3N0cyBoYXZlIHRoZSBzYW1lIGhhcmR3YXJlLCBqdXN0Cj4gPiBrZXJuZWwgdmVy
c2lvbiBpcyBkaWZmZXJlbnQsCj4gPiBhbmQgdGhlIGhhcmR3YXJlIG9uIGVpdGhlciBzaWRlIG9m
IHRoZSBtaWdyYXRpb24gbm90IHN1cHBvcnQgU1ZFLgo+ID4gCj4gPiBJcyB0aGVyZSBzb21lIGdv
b2Qgc3VnZ2VzdGlvbnPvvIx3aGljaCBjYW4gbWFrZSBzdXJlIG9sZCB2ZXJzaW9uCj4gPiBrZXJu
ZWwgbGl2ZSBtaWdyYXRpb24gdG8gbmV3IHZlcnNpb24ga2VybmVsIHdpdGggcWVtdT8KPiAKPiBJ
WydtIGFmcmFpZCB5b3Ugc2hvdWxkIHRha2UgdGhpcyB3aXRoIHlvdXIgZGlzdHJpYnV0aW9uIG9m
Cj4gY2hvaWNlLCB1bmxlc3MgeW91IGNhbiByZXByb2R1Y2UgdGhlIHByb2JsZW0gd2l0aCBtYWlu
bGluZSBrZXJuZWxzLgoKSSdsbCBiZXQgdGhpcyByZXByb2R1Y2VzIHdoZW4gbWlncmF0aW5nIGZy
b20gYSBtYWlubGluZSBwcmUgU1ZFIHJlZ2lzdGVyCmZpbHRlcmluZyBrZXJuZWwgdG8gYSBtYWlu
bGluZSB0aGF0IGRvZXMgdGhlIGZpbHRlcmluZy4gSSBkb24ndCBoYXZlCnRpbWUgdG8gdGVzdCB0
aGF0IHRob3VnaC4KClRoYW5rcywKZHJldwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
