Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCB5C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 23:55:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C62020722
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 23:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kbt7jJ+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C62020722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B66B4B190;
	Wed,  2 Sep 2020 19:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eawRZy0kzp+m; Wed,  2 Sep 2020 19:55:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4294B197;
	Wed,  2 Sep 2020 19:55:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F4F4B18F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 19:55:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gTVt5-8Bcu0b for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 19:55:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA294B18D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 19:55:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599090924;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nXXJmhuNYVScNy3g0Roq4BWySeKqVQgn7sLEndwOHXY=;
 b=Kbt7jJ+jW0MDAxX6dOn7IhPtfb1ZSYxAbCnVctlZP8AOyMzRxTQCh1N+IHNKsBvGErAFGT
 +jFVPCrykguYb9pzirmInVAOjy3bXEBJH+dh0wuaUrDvGtBdSGI1OGUrCrbC/q7PmSNipV
 1PHWwwVQtoOu7ha7NkfQFlVRL2u/HJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-DlEINzXLNdiO7rJBXriR6Q-1; Wed, 02 Sep 2020 19:55:20 -0400
X-MC-Unique: DlEINzXLNdiO7rJBXriR6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2961DE03;
 Wed,  2 Sep 2020 23:55:19 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1E8B5C1C4;
 Wed,  2 Sep 2020 23:55:13 +0000 (UTC)
Subject: Re: [PATCH] arm64/kvm: Fix zapping stage2 page table wrongly
To: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>
References: <20200822024444.28132-1-gshan@redhat.com>
 <dbd37825-9f3b-1911-cba5-03099250dc7e@arm.com>
 <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <3dc0bb34-d0cf-1848-d4a7-9b5c6f152297@redhat.com>
Date: Thu, 3 Sep 2020 09:55:09 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <9bcb88aff4fbacfad28d13234681bc2f@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, shan.gavin@gmail.com
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

SGkgTWFyYywKCk9uIDkvMi8yMCA5OjEwIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAy
MC0wOS0wMiAxMTo1OSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKClsuLi5dCgo+IAo+ICBGcm9t
IDJhMzQ1YTgyNmE0N2Y5MDYxYmIzNzA0NWExZDg5ZWE1NGI1MWZiODAgTW9uIFNlcCAxNyAwMDow
MDowMCAyMDAxCj4gRnJvbTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPiBEYXRlOiBX
ZWQsIDIgU2VwIDIwMjAgMTE6MTg6MjkgKzAxMDAKPiBTdWJqZWN0OiBbUEFUQ0hdIEtWTTogYXJt
NjQ6IERvIG5vdCB0cnkgdG8gbWFwIFBVRHMgd2hlbiB0aGV5IGFyZSBmb2xkZWQgaW50bwo+ICDC
oFBNRAo+IAo+IEZvciB0aGUgb2JzY3VyZSBjYXNlcyB3aGVyZSBQTUQgYW5kIFBVRCBhcmUgdGhl
IHNhbWUgc2l6ZQo+ICg2NGtCIHBhZ2VzIHdpdGggNDJiaXQgVkEsIGZvciBleGFtcGxlLCB3aGlj
aCByZXN1bHRzIGluIG9ubHkKPiB0d28gbGV2ZWxzIG9mIHBhZ2UgdGFibGVzKSwgd2UgY2FuJ3Qg
bWFwIGFueXRoaW5nIGFzIGEgUFVELAo+IGJlY2F1c2UgdGhlcmUgaXMuLi4gZXJtLi4uIG5vIFBV
RCB0byBzcGVhayBvZi4gRXZlcnl0aGluZyBpcwo+IGVpdGhlciBhIFBNRCBvciBhIFBURS4KPiAK
PiBTbyBsZXQncyBvbmx5IHRyeSBhbmQgbWFwIGEgUFVEIHdoZW4gaXRzIHNpemUgaXMgZGlmZmVy
ZW50IGZyb20KPiB0aGF0IG9mIGEgUE1ELgo+IAo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
Cj4gRml4ZXM6IGI4ZTBiYTdjOGJlYSAoIktWTTogYXJtNjQ6IEFkZCBzdXBwb3J0IGZvciBjcmVh
dGluZyBQVUQgaHVnZXBhZ2VzIGF0IHN0YWdlIDIiKQo+IFJlcG9ydGVkLWJ5OiBHYXZpbiBTaGFu
IDxnc2hhbkByZWRoYXQuY29tPgo+IFJlcG9ydGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4KPiAtLS0KPiAgwqBhcmNoL2FybTY0L2t2bS9tbXUuYyB8IDIgKy0KPiAgwqAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPiAKCkl0IHdvcmtlZCBmb3IgbWUg
ZWl0aGVyOgoKUmV2aWV3ZWQtYnk6IEdhdmluIFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+ClRlc3Rl
ZC1ieTogR2F2aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KCj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL21tdS5jIGIvYXJjaC9hcm02NC9rdm0vbW11LmMKPiBpbmRleCBiYTAwYmNjMGM4
ODQuLmMzYTkyZmE1MzdmZCAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0L2t2bS9tbXUuYwo+ICsr
KyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4gQEAgLTE5NzAsNyArMTk3MCw3IEBAIHN0YXRpYyBp
bnQgdXNlcl9tZW1fYWJvcnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBwaHlzX2FkZHJfdCBmYXVs
dF9pcGEsCj4gIMKgwqDCoMKgwqDCoMKgwqAgKGZhdWx0X3N0YXR1cyA9PSBGU0NfUEVSTSAmJgo+
ICDCoMKgwqDCoMKgwqDCoMKgwqAgc3RhZ2UyX2lzX2V4ZWMobW11LCBmYXVsdF9pcGEsIHZtYV9w
YWdlc2l6ZSkpOwo+IAo+IC3CoMKgwqAgaWYgKHZtYV9wYWdlc2l6ZSA9PSBQVURfU0laRSkgewo+
ICvCoMKgwqAgaWYgKFBVRF9TSVpFICE9IFBNRF9TSVpFICYmIHZtYV9wYWdlc2l6ZSA9PSBQVURf
U0laRSkgewo+ICDCoMKgwqDCoMKgwqDCoMKgIHB1ZF90IG5ld19wdWQgPSBrdm1fcGZuX3B1ZChw
Zm4sIG1lbV90eXBlKTsKPiAKPiAgwqDCoMKgwqDCoMKgwqDCoCBuZXdfcHVkID0ga3ZtX3B1ZF9t
a2h1Z2UobmV3X3B1ZCk7CgpUaGFua3MsCkdhdmluCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
