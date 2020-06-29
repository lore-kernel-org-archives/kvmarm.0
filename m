Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E177C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 23:15:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5C5020776
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 23:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PH2UAbck"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5C5020776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503014B556;
	Mon, 29 Jun 2020 19:15:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zy+u+pk2aj6F; Mon, 29 Jun 2020 19:15:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41ADF4B55B;
	Mon, 29 Jun 2020 19:15:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6F84B555
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 19:14:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xce57fS7uSoA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 19:14:58 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564474B4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 19:14:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593472498;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QuobGItmN+qgme7a3Zr/02Vhk75SasKIUkFfoJJyzUk=;
 b=PH2UAbckWU6SkLV6GraE+UtT2HnZp0uPWNehNlrVdnrSyvfkhycZdfaEa8KYcpB1Dnjp6U
 kAjCUmRVXVrKv1z5S5WmRNdve9HB+flP0IdbKkL0JYJOc7dioy4nEXYzViLvm0//JAg3iq
 5ShlNlRNceF65sT82FGVpxyZAvtLwhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-ix1sGDXINdq-LwvrlCZljg-1; Mon, 29 Jun 2020 19:14:51 -0400
X-MC-Unique: ix1sGDXINdq-LwvrlCZljg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E45451005512;
 Mon, 29 Jun 2020 23:14:49 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-102.bne.redhat.com
 [10.64.54.102])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E57B2857F;
 Mon, 29 Jun 2020 23:14:47 +0000 (UTC)
Subject: Re: [PATCH 1/2] kvm/arm64: Rename HSR to ESR
To: Marc Zyngier <maz@misterjones.org>, Mark Rutland <mark.rutland@arm.com>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-2-gshan@redhat.com>
 <20200629103208.GA59769@C02TD0UTHF1T.local>
 <9080c56e3f54d7661a57c5e2a771363f@misterjones.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <1cc51ce6-0e94-03e5-85e1-66d074bb50f4@redhat.com>
Date: Tue, 30 Jun 2020 09:14:44 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <9080c56e3f54d7661a57c5e2a771363f@misterjones.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gNi8zMC8yMCAzOjAwIEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMC0wNi0yOSAx
MTozMiwgTWFyayBSdXRsYW5kIHdyb3RlOgo+PiBPbiBNb24sIEp1biAyOSwgMjAyMCBhdCAwNzox
ODo0MFBNICsxMDAwLCBHYXZpbiBTaGFuIHdyb3RlOgo+Pj4ga3ZtL2FybTMyIGlzbid0IHN1cHBv
cnRlZCBzaW5jZSBjb21taXQgNTQxYWQwMTUwY2E0ICgiYXJtOiBSZW1vdmUKPj4+IDMyYml0IEtW
TSBob3N0IHN1cHBvcnQiKS4gU28gSFNSIGlzbid0IG1lYW5pbmdmdWwgc2luY2UgdGhlbi4gVGhp
cwo+Pj4gcmVuYW1lcyBIU1IgdG8gRVNSIGFjY29yZGluZ2x5LiBUaGlzIHNob3VsZG4ndCBjYXVz
ZSBhbnkgZnVuY3Rpb25hbAo+Pj4gY2hhbmdlczoKPj4+Cj4+PiDCoMKgICogUmVuYW1lIGt2bV92
Y3B1X2dldF9oc3IoKSB0byBrdm1fdmNwdV9nZXRfZXNyKCkgdG8gbWFrZSB0aGUKPj4+IMKgwqDC
oMKgIGZ1bmN0aW9uIG5hbWVzIHNlbGYtZXhwbGFuYXRvcnkuCj4+PiDCoMKgICogUmVuYW1lIHZh
cmlhYmxlcyBmcm9tIEBoc3IgdG8gQGVzciB0byBtYWtlIHRoZW0gc2VsZi1leHBsYW5hdG9yeS4K
Pj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+Pgo+
PiBBdCBhIGhpZ2gtbGV2ZWwsIEkgYWdyZWUgdGhhdCB3ZSBzaG91bGQgbW92ZSB0byB0aGUgYGVz
cmAgbmFtaW5nIHRvCj4+IG1hdGNoIHRoZSBhcmNoaXRlY3R1cmUgYW5kIG1pbmltaXplIHN1cnBy
aXNlLiBIb3dldmVyLCBJIHRoaW5rIHRoZXJlIGFyZQo+PiBzb21lIEFCSSBjaGFuZ2VzIGhlcmUs
IHdoaWNoICphcmUqIGZ1bmNpdG9uYWwgY2hhbmdlcywgYW5kIHRob3NlIG5lZWQgdG8KPj4gYmUg
YXZvaWRlZC4KPj4KPj4gWy4uLl0KPj4KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1
ZGUvdWFwaS9hc20va3ZtLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4+
IGluZGV4IGJhODViYjIzZjA2MC4uZDU0MzQ1NTczYTg4IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUv
dWFwaS9hc20va3ZtLmgKPj4+IEBAIC0xNDAsNyArMTQwLDcgQEAgc3RydWN0IGt2bV9ndWVzdF9k
ZWJ1Z19hcmNoIHsKPj4+IMKgfTsKPj4+Cj4+PiDCoHN0cnVjdCBrdm1fZGVidWdfZXhpdF9hcmNo
IHsKPj4+IC3CoMKgwqAgX191MzIgaHNyOwo+Pj4gK8KgwqDCoCBfX3UzMiBlc3I7Cj4+PiDCoMKg
wqDCoCBfX3U2NCBmYXI7wqDCoMKgIC8qIHVzZWQgZm9yIHdhdGNocG9pbnRzICovCj4+PiDCoH07
Cj4+Cj4+IFRoaXMgaXMgdXNlcnNwYWNlIEFCSSwgYW5kIGNoYW5naW5nIHRoaXMgKndpbGwqIGJy
ZWFrIHVzZXJzcGFjZS4gVGhpcwo+PiAqaXMqIGEgZnVuY3Rpb25hbCBjaGFuZ2UuCj4+Cj4+IE5B
SyB0byB0aGlzIHNwZWNpZmljYWxseS4gQXQgYmVzdCB0aGVzZSBzaG91bGQgYmUgYSBjb21tZW50
IGhlcmUgdGhhdAo+PiB0aGlzIGlzIG5hbWluZyBpcyBsZWdhY3ltIGJ1dCBtdXN0IHN0YXkgZm9y
IEFCSSByZWFzb25zLgo+Pgo+PiBbLi4uXQo+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL3RyYWNlX2FybS5oIGIvYXJjaC9hcm02NC9rdm0vdHJhY2VfYXJtLmgKPj4+IGluZGV4IDRj
NzEyNzBjYzA5Ny4uZWU0ZjY5MWIxNmZmIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0v
dHJhY2VfYXJtLmgKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3RyYWNlX2FybS5oCj4+PiBAQCAt
NDIsNyArNDIsNyBAQCBUUkFDRV9FVkVOVChrdm1fZXhpdCwKPj4+IMKgwqDCoMKgwqDCoMKgwqAg
X19lbnRyeS0+dmNwdV9wY8KgwqDCoMKgwqDCoMKgID0gdmNwdV9wYzsKPj4+IMKgwqDCoMKgICks
Cj4+Pgo+Pj4gLcKgwqDCoCBUUF9wcmludGsoIiVzOiBIU1JfRUM6IDB4JTA0eCAoJXMpLCBQQzog
MHglMDhseCIsCj4+PiArwqDCoMKgIFRQX3ByaW50aygiJXM6IEVTUl9FQzogMHglMDR4ICglcyks
IFBDOiAweCUwOGx4IiwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fcHJpbnRfc3ltYm9saWMo
X19lbnRyeS0+cmV0LCBrdm1fYXJtX2V4Y2VwdGlvbl90eXBlKSwKPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgIF9fZW50cnktPmVzcl9lYywKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fcHJpbnRf
c3ltYm9saWMoX19lbnRyeS0+ZXNyX2VjLCBrdm1fYXJtX2V4Y2VwdGlvbl9jbGFzcyksCj4+Cj4+
IExpa2V3aXNlLCBpc24ndCBhbGwgdGhlIHRyYWNlcG9pbnQgZm9ybWF0IHN0dWZmIEFCST8gSSdt
IG5vdCBjb21mb3J0YWJsZQo+PiB0aGF0IHdlIGNhbiBjaGFuZ2UgdGhpcy4KPiAKPiBUcmFjZXBv
aW50cyBhcmUgQUJJLCBhbmQgdGhleSBjYW5ub3QgY2hhbmdlLiBBcyBpdCBpcywgdGhpcyBwYXRj
aAo+IGlzbid0IGFjY2VwdGFibGUgKHRoZSB3b3JzZSBvZmZlbmRlciBiZWluZyB0aGUgdWFwaSBj
aGFuZ2UgdGhvdWdoKS4KPiAKClllcywgSSB3YXMgcmVsdWN0YW50IHRvIG1ha2UgdGhlIGNoYW5n
ZXMgcmVnYXJkaW5nIHRoZSB1YXBpL3RyYWNlcG9pbnQsCndoaWNoIGlzIHBhcnQgb2YgdGhlIEFC
SS4gSSB3aWxsIGRyb3AgdGhlIGNoYW5nZXMgaW4gdjIuCgpUaGFua3MsCkdhdmluCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
