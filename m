Return-Path: <SRS0=yVTD=YW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A903CA9EAE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 22:52:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9951A20659
	for <kvmarm@archiver.kernel.org>; Tue, 29 Oct 2019 22:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIIWxBoi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9951A20659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E42444A4DF;
	Tue, 29 Oct 2019 18:52:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pn0+2x4nITVE; Tue, 29 Oct 2019 18:52:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D74E14AC65;
	Tue, 29 Oct 2019 18:52:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F074A4DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 18:52:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XmH-D3423yLR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Oct 2019 18:52:19 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8F684A4A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Oct 2019 18:52:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1572389539;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lYynz4GR5eOSd6n5cQs67I6ct64O6p/BlBconKMsNBU=;
 b=MIIWxBoirBnlE0UkaY7+21lWWgfwqrU1C1srhsh0d2B5fTVr5EB4MoCnuCA/Rbxmhvn1J/
 EAYUW074lZTm0F02ij8jutb7rdAQYgaGY5fywNWWDIR5rDHkKmGVCunIfbnYZHG4ZFyQs7
 W1OoUqcWY0FdYEth/I66N0D8k8MQXes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-Z8l-CFl_NJWBKFINNW_lsQ-1; Tue, 29 Oct 2019 18:52:15 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4F62800C80;
 Tue, 29 Oct 2019 22:52:13 +0000 (UTC)
Received: from [10.36.117.11] (ovpn-117-11.ams2.redhat.com [10.36.117.11])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE53119D70;
 Tue, 29 Oct 2019 22:52:10 +0000 (UTC)
From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: vgic: Don't rely on the wrong pending
 table
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20191029071919.177-1-yuzenghui@huawei.com>
 <20191029071919.177-4-yuzenghui@huawei.com> <86mudjykfa.wl-maz@kernel.org>
 <f8a30e65-7077-301a-1558-7fc504b5e891@huawei.com>
 <e2141f6a-c530-46d5-d5d9-26806b02d55b@redhat.com>
 <01638947-ce47-2e09-68f0-a95eb6e9b2d0@huawei.com>
Message-ID: <40c96640-49b3-942b-59f7-3f2f1592d8d6@redhat.com>
Date: Tue, 29 Oct 2019 23:52:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <01638947-ce47-2e09-68f0-a95eb6e9b2d0@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Z8l-CFl_NJWBKFINNW_lsQ-1
X-Mimecast-Spam-Score: 0
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

SGkgWmVuZ2h1aSwKCk9uIDEwLzI5LzE5IDI6MzEgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDE5LzEwLzI5IDIwOjQ5LCBBdWdlciBFcmljIHdyb3RlOgo+PiBPbiAx
MC8yOS8xOSAxOjI3IFBNLCBaZW5naHVpIFl1IHdyb3RlOgo+Pj4gb2theSwgdGhlIHJlbWFpbmlu
ZyBxdWVzdGlvbiBpcyB0aGF0IGluIHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcygpOgo+Pj4K
Pj4+IMKgwqDCoMKgwqBzdG9yZWQgPSB2YWwgJiAoMVUgPDwgYml0X25yKTsKPj4+IMKgwqDCoMKg
wqBpZiAoc3RvcmVkID09IGlycS0+cGVuZGluZ19sYXRjaCkKPj4+IMKgwqDCoMKgwqDCoMKgwqAg
Y29udGludWU7Cj4+Pgo+Pj4gwqDCoMKgwqDCoGlmIChpcnEtPnBlbmRpbmdfbGF0Y2gpCj4+PiDC
oMKgwqDCoMKgwqDCoMKgIHZhbCB8PSAxIDw8IGJpdF9ucjsKPj4+IMKgwqDCoMKgwqBlbHNlCj4+
PiDCoMKgwqDCoMKgwqDCoMKgIHZhbCAmPSB+KDEgPDwgYml0X25yKTsKPj4+Cj4+PiBEbyB3ZSBy
ZWFsbHkgaGF2ZSBhIHNjZW5hcmlvIHdoZXJlIGlycS0+cGVuZGluZ19sYXRjaD09ZmFsc2UgYW5k
Cj4+PiBzdG9yZWQ9PXRydWUgKGNvcnJlc3BvbmRzIHRvIHRoZSBhYm92ZSAiZWxzZSIpIGFuZCB0
aGVuIHdlIGNsZWFyCj4+PiBwZW5kaW5nIHN0YXR1cyBvZiB0aGlzIExQSSBpbiBndWVzdCBtZW1v
cnk/Cj4+PiBJIGNhbiBub3QgdGhpbmsgb3V0IG9uZSBub3cuCj4+Cj4+IGlmIHlvdSBzYXZlLCBy
ZXN0b3JlIGFuZCBzYXZlIGFnYWluLiBPbiB0aGUgMXN0IHNhdmUgdGhlIExQSSBtYXkgYmUKPj4g
cGVuZGluZywgaXQgZ2V0cyBzdG9yZWQuIE9uIHRoZSBzZWNvbmQgc2F2ZSB0aGUgTFBJIG1heSBi
ZSBub3QgcGVuZGluZwo+PiBhbnltb3JlPwo+IAo+IEkgYXNzdW1lIHlvdSBtZWFuIHRoZSAicmVz
dG9yZSIgYnkgdmdpY19pdHNfcmVzdG9yZV9pdGUoKS4KCnllcyB0aGF0J3Mgd2hhdCBJIG1lYW50
Cgo+IAo+IFdoaWxlIHJlc3RvcmluZyBhIExQSSwgd2Ugd2lsbCBzeW5jIHRoZSBwZW5kaW5nIHN0
YXR1cyBmcm9tIGd1ZXN0Cj4gcGVuZGluZyB0YWJsZSAoaW50byB0aGUgc29mdHdhcmUgcGVuZGlu
Z19sYXRjaCksIGFuZCBjbGVhciB0aGUKPiBjb3JyZXNwb25kaW5nIGJpdCBpbiBndWVzdCBtZW1v
cnkuCj4gU2VlIHZnaWNfdjNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMoKS4KPiAKPiBTbyBvbiB0
aGUgc2Vjb25kIHNhdmUsIHRoZSBMUEkgY2FuIGJlIG5vdCBwZW5kaW5nLCB0aGUgZ3Vlc3QgcGVu
ZGluZwo+IHRhYmxlIHdpbGwgYWxzbyBpbmRpY2F0ZSBub3QgcGVuZGluZy4KCllvdSdyZSByaWdo
dDsgSSBkaWQgbm90IHJlbWVtYmVyIHZnaWNfdjNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMgKGNh
bGxlZApmcm9tIHZnaWNfaXRzX3Jlc3RvcmVfaXRlL3ZnaWNfYWRkX2xwaSkgImNsZWFyZWQgdGhl
IGNvbnN1bWVkIGRhdGEiCig0NGRlOWQ2ODM4NDcgIEtWTTogYXJtNjQ6IHZnaWMtdjM6IHZnaWNf
djNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMpLgoKU28gZWZmZWN0aXZlbHkgYWZ0ZXIgcmVzdG9y
ZSB0aGUgcGVuZGluZyB0YWJsZSBpcyB6ZXJvZWQgYW5kIHRoZSBhYm92ZQpjb2RlIHNob3VsZCBi
ZSByZXdyaXR0YWJsZSBpbiBhIG1vcmUgc2ltcGxlIG1hbm5lciwgaWUuIGp1c3QgdXBkYXRlIHRo
ZQpieXRlIGluIGNhc2UgdGhlIHBlbmRpbmdfbGF0Y2ggaXMgc2V0LgoKTmV0aGVydGhlbGVzcyB5
b3VyIHBhdGNoIGluZGVlZCBmaXhlcyBhbiBhY3R1YWwgYnVnIGluZGVwZW5kZW50bHkgb24KdGhp
cyBjbGVhbnVwLCBpZS4gdGhlIHdyaXR0ZW4gYnl0ZSBtYXkgYmUgaW5jb3JyZWN0IGlmIExQSXMg
YmVsb25naW5nIHRvCnRoaXMgYnl0ZSB0YXJnZXQgZGlmZmVyZW50IFJESVNULgoKVGhhbmtzCgpF
cmljCj4gCj4gCj4gVGhhbmtzLAo+IFplbmdodWkKPiAKPiAKPiBfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IGxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBs
aXN0Cj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCj4gaHR0cDovL2xpc3Rz
LmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
