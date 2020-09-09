Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8D9C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 18:08:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D4F121D7D
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 18:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V1NOsp83"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D4F121D7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 592FA4B40A;
	Wed,  9 Sep 2020 14:08:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tjhIBuoPn05Z; Wed,  9 Sep 2020 14:08:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 493434B42F;
	Wed,  9 Sep 2020 14:08:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08F14B386
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 14:08:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vZ5knBLdbCeL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 14:08:01 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 034564B37B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 14:08:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599674880;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VV6n2P1JqU0YPZMyUbTFLLb1CLWvWgHP/iQgdRcWwfw=;
 b=V1NOsp83tEFKmXZyMIva/sBwmy/IBsWjKhpd1cro8ayesXFzmZhWuVxxNmUG8zzZ4jvjcf
 m1w1UVDmAOmZPlbeDdubWIliLSfc+FCVrpBN10VB3E7PZ6gckqraQoI20A5y9sGu8JQhoN
 Mt/4eVIjERJYiFt1P4/K7pbGxhUJeH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-CWBp0t5cPr-iJtqldYOYXQ-1; Wed, 09 Sep 2020 14:07:56 -0400
X-MC-Unique: CWBp0t5cPr-iJtqldYOYXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E646E800683;
 Wed,  9 Sep 2020 18:07:54 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CF31002D67;
 Wed,  9 Sep 2020 18:07:52 +0000 (UTC)
Subject: Re: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in
 PCMEID{0,1}_EL1
To: Marc Zyngier <maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-5-maz@kernel.org>
 <735f5464-3a45-8dc0-c330-ac5632bcb4b4@redhat.com>
 <dde5292adce235bea39bc927c1256bc8@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <d492cf6d-6572-572e-ceb2-37eec99a9307@redhat.com>
Date: Wed, 9 Sep 2020 20:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <dde5292adce235bea39bc927c1256bc8@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, graf@amazon.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCk9uIDkvOS8yMCA3OjUwIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAyMDIwLTA5LTA5IDE4OjQzLCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBNYXJj
LAo+Pgo+PiBPbiA5LzgvMjAgOTo1OCBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gQXMgd2Ug
Y2FuIG5vdyBoaWRlIGV2ZW50cyBmcm9tIHRoZSBndWVzdCwgbGV0J3MgYWxzbyBhZGp1c3QgaXRz
IHZpZXcgb2YKPj4+IFBDTUVJRHswLDF9X0VMMSBzbyB0aGF0IGl0IGNhbiBmaWd1cmUgb3V0IHdo
eSBzb21lIGNvbW1vbiBldmVudHMgYXJlIG5vdAo+Pj4gY291bnRpbmcgYXMgdGhleSBzaG91bGQu
Cj4+IFJlZmVycmluZyB0byBteSBwcmV2aW91cyBjb21tZW50IHNob3VsZCB3ZSBmaWx0ZXIgdGhl
IGN5Y2xlIGNvdW50ZXIgb3V0Pwo+Pj4KPj4+IFRoZSBhc3R1dGUgdXNlciBjYW4gc3RpbGwgbG9v
ayBpbnRvIHRoZSBUUk0gZm9yIHRoZWlyIENQVSBhbmQgZmluZCBvdXQKPj4+IHRoZXkndmUgYmVl
biBjaGVhdGVkLCB0aG91Z2guIE5vYm9keSdzIHBlcmZlY3QuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1i
eTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+IC0tLQo+Pj4gwqBhcmNoL2FybTY0
L2t2bS9wbXUtZW11bC5jIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPj4+IMKg
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8wqAgNSArLS0tLQo+Pj4gwqBpbmNsdWRlL2t2bS9h
cm1fcG11LmjCoMKgwqDCoCB8wqAgNSArKysrKwo+Pj4gwqAzIGZpbGVzIGNoYW5nZWQsIDM1IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3BtdS1lbXVsLmMgYi9hcmNoL2FybTY0L2t2bS9wbXUtZW11bC5jCj4+PiBpbmRleCA2
N2E3MzFiYWZiYzkuLjA0NTg4NjBiYWRlMiAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQva3Zt
L3BtdS1lbXVsLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMKPj4+IEBAIC03
NjUsNiArNzY1LDM1IEBAIHN0YXRpYyBpbnQga3ZtX3BtdV9wcm9iZV9wbXV2ZXIodm9pZCkKPj4+
IMKgwqDCoMKgIHJldHVybiBwbXV2ZXI7Cj4+PiDCoH0KPj4+Cj4+PiArdTY0IGt2bV9wbXVfZ2V0
X3BtY2VpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJvb2wgcG1jZWlkMSkKPj4+ICt7Cj4+PiAr
wqDCoMKgIHVuc2lnbmVkIGxvbmcgKmJtYXAgPSB2Y3B1LT5rdm0tPmFyY2gucG11X2ZpbHRlcjsK
Pj4+ICvCoMKgwqAgdTY0IHZhbCwgbWFzayA9IDA7Cj4+PiArwqDCoMKgIGludCBiYXNlLCBpOwo+
Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoIXBtY2VpZDEpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCB2YWwg
PSByZWFkX3N5c3JlZyhwbWNlaWQwX2VsMCk7Cj4+PiArwqDCoMKgwqDCoMKgwqAgYmFzZSA9IDA7
Cj4+PiArwqDCoMKgIH0gZWxzZSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgdmFsID0gcmVhZF9zeXNy
ZWcocG1jZWlkMV9lbDApOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGJhc2UgPSAzMjsKPj4+ICvCoMKg
wqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoIWJtYXApCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIHZhbDsKPj4+ICsKPj4+ICvCoMKgwqAgZm9yIChpID0gMDsgaSA8IDMyOyBpICs9IDgpIHsK
Pj4gcy8zMi80Pwo+IAo+IEkgZG9uJ3QgdGhpbmsgc28sIHNlZSBiZWxvdy4KPiAKPj4KPj4gVGhh
bmtzCj4+Cj4+IEVyaWMKPj4+ICvCoMKgwqDCoMKgwqDCoCB1NjQgYnl0ZTsKPj4+ICsKPj4+ICvC
oMKgwqDCoMKgwqDCoCBieXRlID0gYml0bWFwX2dldF92YWx1ZTgoYm1hcCwgYmFzZSArIGkpOwo+
Pj4gK8KgwqDCoMKgwqDCoMKgIG1hc2sgfD0gYnl0ZSA8PCBpOwo+IAo+IEZvciBlYWNoIGl0ZXJh
dGlvbiBvZiB0aGUgbG9vcCwgd2UgcmVhZCBhIGJ5dGUgZnJvbSB0aGUgYml0bWFwCj4gKGhlbmNl
IHRoZSArPSA4IGFib3ZlKSwgYW5kIG9yciBpdCBpbnRvIHRoZSBtYXNrLiBUaGlzIG1ha2VzIDQK
PiBpdGVyYXRpb24gb2YgdGhlIGxvb3AuCj4gCj4gT3IgYW0gSSBtaXNzaW5nIHlvdXIgcG9pbnQg
ZW50aXJlbHk/CgpIdW0gbm8geW91J3JlIHJpZ2h0LiBTb3JyeSBmb3IgdGhlIG5vaXNlLgoKTG9v
a3MgZ29vZCB0byBtZToKClJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhh
dC5jb20+CgpFcmljCgoKPiAKPiBUaGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
