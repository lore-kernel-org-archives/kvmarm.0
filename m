Return-Path: <SRS0=p1b3=FE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B787DC63777
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 17:48:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1EAB206E3
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 17:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SI4ASiHF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1EAB206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0F94D4EC;
	Mon, 30 Nov 2020 12:48:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jvlQPn5ui6rz; Mon, 30 Nov 2020 12:48:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7FBD4D4ED;
	Mon, 30 Nov 2020 12:48:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E2A4D4E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 12:48:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LWltpjzNZIo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2020 12:48:32 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D924CC7B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 12:48:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1606758512;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pQ4WpiPqnnYL566UEzHdmnDQQhCQF6P/OZJyfbS45g8=;
 b=SI4ASiHFRGpUxWLHSOnRD0LDOv43iMcGpVl8OUsIPutT9zxEjWVGYqKyyoUSS8nA8oTelb
 MiXIBaw5PEBmE2GY4HwylZInk0ybU+vFHQSF73tA+OdQVZeTIuFwrk/iRpaMl+lKS4QFsf
 RMYttR5CEQgJCZm3CKdRSkk15whrLVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-fOZeDxu5PhmzgVVkZbmwww-1; Mon, 30 Nov 2020 12:48:29 -0500
X-MC-Unique: fOZeDxu5PhmzgVVkZbmwww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F11C7190A7A1;
 Mon, 30 Nov 2020 17:48:27 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 534425D6A8;
 Mon, 30 Nov 2020 17:48:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To: Zenghui Yu <yuzenghui@huawei.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <23be6c11-fd2e-0d41-df06-91d87cf1a465@redhat.com>
Date: Mon, 30 Nov 2020 18:48:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: andre.przywara@arm.com
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

SGkgQWxleGFuZHJ1LCBaZW5naHVpCk9uIDExLzI2LzIwIDEwOjMwIEFNLCBaZW5naHVpIFl1IHdy
b3RlOgo+IE9uIDIwMjAvMTEvMjUgMjM6NTEsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IFRo
ZSByZWFzb24gZm9yIHRoZSBmYWlsdXJlIGlzIHRoYXQgdGhlIHRlc3QgImRldjIvZXZlbnRpZD0y
MCBub3cgdHJpZ2dlcnMKPj4gYW4gTFBJIiB0cmlnZ2VycyAyIExQSXMsIG5vdCBvbmUuIFRoaXMg
YmVoYXZpb3Igd2FzIHByZXNlbnQgYmVmb3JlIHRoaXMKPj4gcGF0Y2gsIGJ1dCBpdCB3YXMgaWdu
b3JlZCBiZWNhdXNlIGNoZWNrX2xwaV9zdGF0cygpIHdhc24ndCBsb29raW5nIGF0IHRoZQo+PiBh
Y2tlZCBhcnJheS4KPj4KPj4gSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoZSBJVFMgc28gSSdtIG5v
dCBzdXJlIGlmIHRoaXMgaXMgZXhwZWN0ZWQsIGlmIHRoZQo+PiB0ZXN0IGlzIGluY29ycmVjdCBv
ciBpZiB0aGVyZSBpcyBzb21ldGhpbmcgd3Jvbmcgd2l0aCBLVk0gZW11bGF0aW9uLgo+IAo+IEkg
dGhpbmsgdGhpcyBpcyBleHBlY3RlZCwgb3Igbm90Lgo+IAo+IEJlZm9yZSBJTlZBTEwsIHRoZSBM
UEktODE5NSB3YXMgYWxyZWFkeSBwZW5kaW5nIGJ1dCBkaXNhYmxlZC4gT24KPiByZWNlaXZpbmcg
SU5WQUxMLCBWR0lDIHdpbGwgcmVsb2FkIGNvbmZpZ3VyYXRpb24gZm9yIGFsbCBMUElzIHRhcmdl
dGluZwo+IGNvbGxlY3Rpb24tMyBhbmQgZGVsaXZlciB0aGUgbm93IGVuYWJsZWQgTFBJLTgxOTUu
IFdlJ2xsIHRoZXJlZm9yZSBzZWUKPiBhbmQgaGFuZGxlIGl0IGJlZm9yZSBzZW5kaW5nIHRoZSBm
b2xsb3dpbmcgSU5UICh3aGljaCB3aWxsIHNldCB0aGUKPiBMUEktODE5NSBwZW5kaW5nIGFnYWlu
KS4KPiAKPj4gRGlkIHNvbWUgbW9yZSB0ZXN0aW5nIG9uIGFuIEFtcGVyZSBlTUFHIChmYXN0IG91
dC1vZi1vcmRlciBjb3JlcykgdXNpbmcKPj4gcWVtdSBhbmQga3ZtdG9vbCBhbmQgTGludXggdjUu
OCwgaGVyZSdzIHdoYXQgSSBmb3VuZDoKPj4KPj4gLSBVc2luZyBxZW11IGFuZCBnaWMuZmxhdCBi
dWlsdCBmcm9tKm1hc3Rlcio6IGVycm9yIGVuY291bnRlcmVkIDg2NCB0aW1lcwo+PiDCoMKgIG91
dCBvZiAxMDg4IHJ1bnMuCj4+IC0gVXNpbmcgcWVtdTogZXJyb3IgZW5jb3VudGVyZWQgODUyIHRp
bWVzIG91dCBvZiAxMDI3IHJ1bnMuCj4+IC0gVXNpbmcga3ZtdG9vbDogZXJyb3IgZW5jb3VudGVy
ZWQgODE2NCB0aW1lcyBvdXQgb2YgMTA2MDIgcnVucy4KPiAKPiBJZiB2Y3B1LTMgaGFkbid0IHNl
ZW4gYW5kIGhhbmRsZWQgTFBJLTgxOTUgYXMgcXVpY2tseSBhcyBwb3NzaWJsZSAoZS5nLiwKPiB2
Y3B1LTMgaGFkbid0IGJlZW4gc2NoZWR1bGVkKSwgdGhlIGZvbGxvd2luZyBJTlQgd2lsbCBzZXQg
dGhlIGFscmVhZHkKPiBwZW5kaW5nIExQSS04MTk1IHBlbmRpbmcgYWdhaW4gYW5kIHdlJ2xsIHJl
Y2VpdmUgaXQgKm9uY2UqIG9uIHZjcHUtMy4KPiBBbmQgd2Ugd29uJ3Qgc2VlIHRoZSBtZW50aW9u
ZWQgZmFpbHVyZS4KPiAKPiBJIHRoaW5rIHdlIGNhbiBqdXN0IGRyb3AgdGhlIChtZWFuaW5nbGVz
cyBhbmQgY29uZnVzaW5nPykgSU5ULgpZZXMgSSBhZ3JlZSB3aXRoIFplbmdodWksIHdlIGNhbiBy
ZW1vdmUgdGhlIElOVCBhbmQganVzdCBjaGVjayB0aGUKcGVuZGluZyBMUEkgc2V0IHdoaWxlIGRp
c2FibGVkIGV2ZW50dWFsbHkgaGl0cwoKVGhhbmtzCgpFcmljCj4gCj4gCj4gVGhhbmtzLAo+IFpl
bmdodWkKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
