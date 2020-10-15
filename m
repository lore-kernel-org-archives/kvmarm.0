Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EF9C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:26:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2C5B2222B
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWa9nRsS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2C5B2222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7D64B665;
	Thu, 15 Oct 2020 09:26:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GTjxH9mGHeEn; Thu, 15 Oct 2020 09:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B16554B6ED;
	Thu, 15 Oct 2020 09:26:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1DE24B665
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05LtOPs1xbEP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 09:26:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4164B134
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:26:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1602768401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9+++Y27GlKLWEVEq2S9REbyh2iJra991JQ1AQaWmzEM=;
 b=MWa9nRsS+XsgH0zmAOLGutvEn2hYoCZa9lbCv5y3G4BCRVhUUScGikWNMFyOo2w1nValFG
 Hyyr5/BPkcGX2oBzDLGuB6X8vOwmOGQ2O8+A6dl+2yreHme2j8dAvW8q4k0c0O6bdEYkXL
 t2YhpB4GbT5DDp/izM+3SYPw6yZrBhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-55PDe9xzPA6jCYTWpz_o8A-1; Thu, 15 Oct 2020 09:26:37 -0400
X-MC-Unique: 55PDe9xzPA6jCYTWpz_o8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815F710AC943;
 Thu, 15 Oct 2020 13:26:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9642B76674;
 Thu, 15 Oct 2020 13:26:32 +0000 (UTC)
Date: Thu, 15 Oct 2020 15:26:29 +0200
From: Andrew Jones <drjones@redhat.com>
To: =?utf-8?B?5byg5Lic5pet?= <xu910121@sina.com>
Subject: Re: Kernel patch cases qemu live migration failed.
Message-ID: <20201015132629.n4k5k7wdruclcrev@kamzik.brq.redhat.com>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
MIME-Version: 1.0
In-Reply-To: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: "marc.zyngier" <marc.zyngier@arm.com>, qemu-devel <qemu-devel@nongnu.org>,
 "Dave.Martin" <dave.martin@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gVGh1LCBPY3QgMTUsIDIwMjAgYXQgMTI6MDY6MzlQTSArMDgwMCwg5byg5Lic5petIHdyb3Rl
Ogo+IEknbSBzbyBzb3JyeSBmb3IgZGlzdHVyYmluZyB5b3UuV2hlbiBJIGFwcGx5IHRoaXMga2Vy
bmVsIHBhdGNo77yaS1ZNOiBhcm02NC9zdmU6IFN5c3RlbSByZWdpc3RlciBjb250ZXh0IHN3aXRj
aCBhbmQgYWNjZXNzIHN1cHBvcnRodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0L2FyY2gvYXJtNjQva3ZtL3N5c19y
ZWdzLmM/aWQ9NzM0MzM3NjJmY2FlYjlkNTllODRkMjk5MDIxYzZiMTU0NjZjOTZkZHFlbXUgbGl2
ZSBtaWdyYXRpb24gd2lsbCBmYWlsZWQgd2l0aCBtZXNzYWdlc++8miAgICAgICAgICAgICAg4oCL
cWVtdS1rdm06IEludmFsaWQgdmFsdWUgMjMzIGV4cGVjdGluZyBwb3NpdGl2ZSB2YWx1ZSA8PSAy
MzIgICAgICAgICAgICAgIHFlbXUta3ZtOiBGYWlsZWQgdG8gbG9hZCBjcHU6Y3ByZWdfdm1zdGF0
ZV9hcnJheV9sZW5OZXcgdmVyc2lvbiBrZXJuZWwgIGV4Y2x1ZGUgSURfQUE2NFpGUjBfRUwxIHJl
Z2lzdGVyIHdoZW4gaG9zdCBub3Qgc3VwcG9ydCBTVkUgZmVhdHVyZSwgc28gcWVtdSBpb2N0bCBr
dm0oS1ZNX0dFVF9SRUdfTElTVCkgd2lsbCBub3QgY29udGFpbiBJRF9BQTY0WkZSMF9FTDEgcmVn
aXN0ZXIuCj4gSSdtIHVzaW5nIENlbnRPUyBMaW51eCBrZXJuZWwsIG9sZCBrZXJuZWwgdmVyc2lv
bu+8mjQuMTguMC04MC4xMS5lbDggKG1pZ3JhdGlvbiBzb3VyY2UpCQkJCQkgICAgIG5ldyBrZXJu
ZWwgdmVyc2lvbu+8mjQuMTguMC0xNDcuNS5lbDggKG1pZ3JhdGlvbiBkZXN0aW5hdGlvbikKPiBD
ZW50T1MgbGludXgga2VybmVsIHZlcnNpb24gNC4xOC4wLTExMS5lbDggYXBwbGllZCB0aGlzIHBh
dGNoLiBTbyA0LjE4LjAtMTQ3LjUuZWw4IGFsc28gYXBwbGllZCB0aGlzIHBhdGNoLgo+IE1pZ3Jh
dGlvbiBzb3VyY2UgYW5kIGRlc3RpbmF0aW9uIGhvc3RzIGhhdmUgdGhlIHNhbWUgaGFyZHdhcmUs
IGp1c3Qga2VybmVsIHZlcnNpb24gaXMgZGlmZmVyZW50LCBhbmQgdGhlIGhhcmR3YXJlIG9uIGVp
dGhlciBzaWRlIG9mIHRoZSBtaWdyYXRpb24gbm90IHN1cHBvcnQgU1ZFLgo+ICBJcyB0aGVyZSBz
b21lIGdvb2Qgc3VnZ2VzdGlvbnPvvIx3aGljaCBjYW4gbWFrZSBzdXJlIG9sZCB2ZXJzaW9uIGtl
cm5lbCBsaXZlIG1pZ3JhdGlvbiB0byBuZXcgdmVyc2lvbiBrZXJuZWwgd2l0aCBxZW11P1RoYW5r
cyBhIGxvdC4KCkFSTSBLVk0gZ3Vlc3RzIG11c3QgYmUgcnVuIHdpdGggQ1BVIGhvc3QgcGFzc3Ro
cm91Z2guIFRoaXMgbWVhbnMgdGhlCmhvc3QgaGFyZHdhcmUgYW5kIGhvc3Qga2VybmVsIHZlcnNp
b25zIG11c3QgYmUgaWRlbnRpY2FsIGluIG9yZGVyCnRvIGd1YXJhbnRlZSBzdWNjZXNzZnVsIG1p
Z3JhdGlvbnMuCgpUaGF0IHNhaWQsIHVwZ3JhZGluZyB0aGUgaG9zdCBrZXJuZWwgd2l0aG91dCBz
aHV0dGluZyBkb3duIHRoZSBndWVzdHMKaXMgYSByZWFzb25hYmxlIHRoaW5nIHRvIHRyeS4gVW5m
b3J0dW5hdGVseSwgaW4gdGhpcyBjYXNlLCB0aGUgb25seQp3YXkgdG8gZG8gaXQgd291bGQgYmUg
dG8gaGFjayBRRU1VIG9uIHRoZSBkZXN0aW5hdGlvbiB0byBhbGxvdyB0aGlzCmV4dHJhIHJlZ2lz
dGVyIGluIEtWTV9HRVRfUkVHX0xJU1QuIEl0IHNob3VsZCBiZSBoYXJtbGVzcywgYXMgaXQncwpu
b3QgdXNlZC4gQWxsb3dpbmcgaXQgaXMgc2ltaWxhciB0byBhbGxvd2luZyB0aGUgZGVzdGluYXRp
b24gdG8gaGF2ZQphIGxhcmdlciBudW1iZXIgb2YgcmVnaXN0ZXJzIHRoYW4gdGhlIHNvdXJjZSBp
biBLVk1fR0VUX1JFR19MSVNUICh3aGljaAppcyB3aHkgdGhlIGZhaWxpbmcgdGVzdCBpcyA8PSwg
bm90ID09KS4KCkkgd291bGRuJ3QgcG9zdCBhIHJlYWwgcGF0Y2ggdG8gcmVzb2x2ZSB0aGlzIGlz
c3VlLCB0aG91Z2gsIGFzIGV2ZXJ5dGhpbmcKaXMgd29ya2luZyBhcyBleHBlY3RlZC4gVGhlIGZh
aWxpbmcgdGVzdCBpcyBmYWlsaW5nIGJlY2F1c2UgaXQgZGV0ZWN0ZWQKYSByaXNreSBtaWdyYXRp
b24uIEFuZCwgS1ZNJ3MgZmlsdGVyaW5nIG9mIHJlZ2lzdGVycyBmcm9tIEtWTV9HRVRfUkVHX0xJ
U1QKaXMgYWxzbyBjb3JyZWN0LCBldmVuIGlmIHByZXZpb3VzIEtWTSB2ZXJzaW9ucyBkaWRuJ3Qg
ZG8gdGhhdC4gV2l0aCBDUFUKbW9kZWxzIHlvdSBjb3VsZCByZXF1ZXN0IHRoZSByZWcgbGlzdCBm
b3IgYSBwYXJ0aWN1bGFyIG1vZGVsIGFuZCBleHBlY3QKaXQgdG8gYmUgdGhlIHNhbWUgYWNyb3Nz
IGFsbCBrZXJuZWwgdmVyc2lvbnMgdGhhdCBzdXBwb3J0IGl0LCBidXQgd2UKZG9uJ3QgaGF2ZSB0
aG9zZS4KClRoYW5rcywKZHJldwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
