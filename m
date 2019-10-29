Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8826CCA9EC3
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:49:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C537208E3
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 12:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYes92p0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C537208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 835574A5A8;
	Tue, 29 Oct 2019 08:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTnb1Qf98GB3; Tue, 29 Oct 2019 08:49:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54FD74A5BD;
	Tue, 29 Oct 2019 08:49:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 493244A59D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zQ1YdMcvFo0i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 08:49:23 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160554A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 08:49:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1572353362;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6BV4BcyOxaroiRY1nHh/W3bkCNLJ+ckD/r50Gn1yPT0=;
 b=TYes92p0H7fd2VFu+U+M2eu77wlbQnYZ0ej4bTRVTBXYvh6aWfiv72Bt+u/VbFhTINImZl
 1i+Zvhlao17RoXnXBm2RgtXbFO62ApQlG9tdm0gOI0m5gtgrhUHS9RWGqg2yKihaIdJM38
 mYfFxhyqm0WtniCGfwlhPsFbZq4qXyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-xZ4E5mL8OxaCghK5UyvDWg-1; Tue, 29 Oct 2019 08:49:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30293800C80;
 Tue, 29 Oct 2019 12:49:17 +0000 (UTC)
Received: from [10.36.118.15] (unknown [10.36.118.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3123F600C4;
 Tue, 29 Oct 2019 12:49:13 +0000 (UTC)
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Don't rely on the wrong pending
 table
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-4-yuzenghui@huawei.com> <86mudjykfa.wl-maz@kernel.org>
 <f8a30e65-7077-301a-1558-7fc504b5e891@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <e2141f6a-c530-46d5-d5d9-26806b02d55b@redhat.com>
Date: Tue, 29 Oct 2019 13:49:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <f8a30e65-7077-301a-1558-7fc504b5e891@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: xZ4E5mL8OxaCghK5UyvDWg-1
X-Mimecast-Spam-Score: 0
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

SGkgWmVuZ2h1aSwKCk9uIDEwLzI5LzE5IDE6MjcgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
TWFyYywKPiAKPiBPbiAyMDE5LzEwLzI5IDE3OjIzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9u
IFR1ZSwgMjkgT2N0IDIwMTkgMDc6MTk6MTkgKzAwMDAsCj4+IFplbmdodWkgWXUgPHl1emVuZ2h1
aUBodWF3ZWkuY29tPiB3cm90ZToKPj4+Cj4+PiBJdCdzIHBvc3NpYmxlIHRoYXQgdHdvIExQSXMg
bG9jYXRlIGluIHRoZSBzYW1lICJieXRlX29mZnNldCIgYnV0IHRhcmdldAo+Pj4gdHdvIGRpZmZl
cmVudCB2Y3B1cywgd2hlcmUgdGhlaXIgcGVuZGluZyBzdGF0dXMgYXJlIGluZGljYXRlZCBieSB0
d28KPj4+IGRpZmZlcmVudCBwZW5kaW5nIHRhYmxlcy7CoCBJbiBzdWNoIGEgc2NlbmFyaW8sIHVz
aW5nIGxhc3RfYnl0ZV9vZmZzZXQKPj4+IG9wdGltaXphdGlvbiB3aWxsIGxlYWQgS1ZNIHJlbHlp
bmcgb24gdGhlIHdyb25nIHBlbmRpbmcgdGFibGUgZW50cnkuCj4+PiBMZXQgdXMgdXNlIGxhc3Rf
cHRyIGluc3RlYWQsIHdoaWNoIGNhbiBiZSB0cmVhdGVkIGFzIGEgYnl0ZSBpbmRleCBpbnRvCj4+
PiBhIHBlbmRpbmcgdGFibGUgYW5kIGFsc28sIGNhbiBiZSB2Y3B1IHNwZWNpZmljLgo+Pj4KPj4+
IFNpZ25lZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4gLS0t
Cj4+Pgo+Pj4gSWYgdGhpcyBwYXRjaCBoYXMgZG9uZSB0aGUgcmlnaHQgdGhpbmcsIHdlIGNhbiBl
dmVuIGFkZCB0aGU6Cj4+Pgo+Pj4gRml4ZXM6IDI4MDc3MTI1MmMxYiAoIktWTTogYXJtNjQ6IHZn
aWMtdjM6Cj4+PiBLVk1fREVWX0FSTV9WR0lDX1NBVkVfUEVORElOR19UQUJMRVMiKQo+Pj4KPj4+
IEJ1dCB0byBiZSBob25lc3QsIEknbSBub3QgY2xlYXIgYWJvdXQgd2hhdCBoYXMgdGhpcyBwYXRj
aCBhY3R1YWxseQo+Pj4gZml4ZWQuCj4+PiBQZW5kaW5nIHRhYmxlcyBzaG91bGQgY29udGFpbiBh
bGwgemVyb3MgYmVmb3JlIHdlIGZsdXNoIHZnaWNfaXJxJ3MKPj4+IHBlbmRpbmcKPj4+IHN0YXR1
cyBpbnRvIGd1ZXN0J3MgUkFNICh0aGlua2luZyB0aGF0IGd1ZXN0IHNob3VsZCBuZXZlciB3cml0
ZSBhbnl0aGluZwo+Pj4gaW50byBpdCkuIFNvIHRoZSBwZW5kaW5nIHRhYmxlIGVudHJ5IHdlJ3Zl
IHJlYWQgZnJvbSB0aGUgZ3Vlc3QgbWVtb3J5Cj4+PiBzZWVtcyBhbHdheXMgYmUgemVyby4gQW5k
IHdlIHdpbGwgYWx3YXlzIGRvIHRoZSByaWdodCB0aGluZyBldmVuIGlmIHdlCj4+PiByZWx5IG9u
IHRoZSB3cm9uZyBwZW5kaW5nIHRhYmxlIGVudHJ5Lgo+Pj4KPj4+IEkgdGhpbmsgSSBtdXN0IGhh
dmUgc29tZSBtaXN1bmRlcnN0YW5kaW5nIGhlcmUuLi4gUGxlYXNlIGZpeCBtZS4KPj4KPj4gSSB0
aGluayB5b3UncmUgc3BvdCBvbiwgYW5kIGl0IGlzIHRoZSBjb2RlIG5lZWRzIGZpeGluZywgbm90
IHlvdSEgVGhlCj4+IHByb2JsZW0gaXMgdGhhdCB3ZSBvbmx5IHJlYWQgYSBieXRlIG9uY2UsIGly
cmVzcGVjdGl2ZSBvZiB0aGUgdmNwdSB0aGUKPj4gaW50ZXJydXB0cyBpcyByb3V0ZWQgdG8uIElm
IHdlIHN3aXRjaCB0byBhbm90aGVyIHZjcHUgZm9yIHRoZSBzYW1lCj4+IGJ5dGUgb2Zmc2V0LCB3
ZSBtdXN0IHJlbG9hZCBpdC4KPj4KPj4gVGhpcyBjYW4gYmUgZG9uZSBieSBlaXRoZXIgY2hlY2tp
bmcgdGhlIHZjcHUsIG9yIGJ5IHRyYWNraW5nIHRoZSBndWVzdAo+PiBhZGRyZXNzIHRoYXQgd2Ug
cmVhZCBmcm9tIChqdXN0IGxpa2UgeW91IGRvIGhlcmUpLgo+IAo+IG9rYXksIHRoZSByZW1haW5p
bmcgcXVlc3Rpb24gaXMgdGhhdCBpbiB2Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMoKToKPiAK
PiDCoMKgwqDCoHN0b3JlZCA9IHZhbCAmICgxVSA8PCBiaXRfbnIpOwo+IMKgwqDCoMKgaWYgKHN0
b3JlZCA9PSBpcnEtPnBlbmRpbmdfbGF0Y2gpCj4gwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4g
Cj4gwqDCoMKgwqBpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKQo+IMKgwqDCoMKgwqDCoMKgIHZhbCB8
PSAxIDw8IGJpdF9ucjsKPiDCoMKgwqDCoGVsc2UKPiDCoMKgwqDCoMKgwqDCoCB2YWwgJj0gfigx
IDw8IGJpdF9ucik7Cj4gCj4gRG8gd2UgcmVhbGx5IGhhdmUgYSBzY2VuYXJpbyB3aGVyZSBpcnEt
PnBlbmRpbmdfbGF0Y2g9PWZhbHNlIGFuZAo+IHN0b3JlZD09dHJ1ZSAoY29ycmVzcG9uZHMgdG8g
dGhlIGFib3ZlICJlbHNlIikgYW5kIHRoZW4gd2UgY2xlYXIKPiBwZW5kaW5nIHN0YXR1cyBvZiB0
aGlzIExQSSBpbiBndWVzdCBtZW1vcnk/Cj4gSSBjYW4gbm90IHRoaW5rIG91dCBvbmUgbm93LgoK
aWYgeW91IHNhdmUsIHJlc3RvcmUgYW5kIHNhdmUgYWdhaW4uIE9uIHRoZSAxc3Qgc2F2ZSB0aGUg
TFBJIG1heSBiZQpwZW5kaW5nLCBpdCBnZXRzIHN0b3JlZC4gT24gdGhlIHNlY29uZCBzYXZlIHRo
ZSBMUEkgbWF5IGJlIG5vdCBwZW5kaW5nCmFueW1vcmU/CgpUaGFua3MKCkVyaWMKPiAKPj4KPj4g
QSBzbWFsbCBjb21tZW50IGJlbG93Ogo+Pgo+Pj4gwqAgdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy12
My5jIHwgNiArKystLS0KPj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
djMuYyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtdjMuYwo+Pj4gaW5kZXggNWVmOTNlNTA0MWUx
Li43Y2QyZTJmODE1MTMgMTAwNjQ0Cj4+PiAtLS0gYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLXYz
LmMKPj4+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtdjMuYwo+Pj4gQEAgLTM2Myw4ICsz
NjMsOCBAQCBpbnQgdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhzdHJ1Y3Qga3ZtCj4+
PiAqa3ZtLCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkKPj4+IMKgIGludCB2Z2ljX3YzX3NhdmVfcGVu
ZGluZ190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+Pj4gwqAgewo+Pj4gwqDCoMKgwqDCoCBzdHJ1
Y3QgdmdpY19kaXN0ICpkaXN0ID0gJmt2bS0+YXJjaC52Z2ljOwo+Pj4gLcKgwqDCoCBpbnQgbGFz
dF9ieXRlX29mZnNldCA9IC0xOwo+Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgdmdpY19pcnEgKmlycTsK
Pj4+ICvCoMKgwqAgZ3BhX3QgbGFzdF9wdHIgPSAtMTsKPj4KPj4gVGhpcyBzaG91bGQgYmUgd3Jp
dHRlbiBhcwo+Pgo+PiDCoMKgwqDCoMKgIGdwYV90IGxhc3RfcHRyID0gfihncGFfdCkwOwo+IAo+
IFRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0Lgo+IAo+Pgo+Pj4gwqDCoMKgwqDCoCBpbnQgcmV0
Owo+Pj4gwqDCoMKgwqDCoCB1OCB2YWw7Cj4+PiDCoCBAQCAtMzg0LDExICszODQsMTEgQEAgaW50
IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCj4+PiDCoMKgwqDC
oMKgwqDCoMKgwqAgYml0X25yID0gaXJxLT5pbnRpZCAlIEJJVFNfUEVSX0JZVEU7Cj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgcHRyID0gcGVuZGJhc2UgKyBieXRlX29mZnNldDsKPj4+IMKgIC3CoMKg
wqDCoMKgwqDCoCBpZiAoYnl0ZV9vZmZzZXQgIT0gbGFzdF9ieXRlX29mZnNldCkgewo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGlmIChwdHIgIT0gbGFzdF9wdHIpIHsKPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldCA9IGt2bV9yZWFkX2d1ZXN0X2xvY2soa3ZtLCBwdHIsICZ2YWwsIDEpOwo+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkKPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGxhc3RfYnl0ZV9vZmZzZXQgPSBieXRlX29mZnNldDsKPj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGxhc3RfcHRyID0gcHRyOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0KPj4+IMKgIMKg
wqDCoMKgwqDCoMKgwqDCoCBzdG9yZWQgPSB2YWwgJiAoMVUgPDwgYml0X25yKTsKPj4KPj4gT3Ro
ZXJ3aXNlLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWUgKG5vIG5lZWQgdG8gcmVzcGluIGZvciB0aGUg
YWJvdmUKPj4gbml0KS4KPiAKPiBUaGFua3MsCj4gCj4gWmVuZ2h1aQo+IAo+IAo+IF9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gbGludXgtYXJtLWtlcm5l
bCBtYWlsaW5nIGxpc3QKPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKPiBo
dHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJu
ZWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
