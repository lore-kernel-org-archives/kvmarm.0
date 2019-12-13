Return-Path: <SRS0=4/V8=2D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DD4C3F68F
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:13:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5513924671
	for <kvmarm@archiver.kernel.org>; Fri, 13 Dec 2019 21:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gf5bZUfC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5513924671
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D3C4A576;
	Fri, 13 Dec 2019 06:07:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6hZg2PtTLagm; Fri, 13 Dec 2019 06:07:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93AD24A7FF;
	Fri, 13 Dec 2019 06:07:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B97CE4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 06:06:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id adiWVbD1Deu6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Dec 2019 06:06:44 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C244A800
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Dec 2019 06:06:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576235204;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Crmf5u8UvQ4Fiv2iDfiUjbDLUFVVvKN850I3N8dlMLg=;
 b=gf5bZUfCKh2TE1I0UZmkYvlBnd9iNt3vlOcVRkhJ8nVWxsp++wfuaAGo+y/PH3jiAHzZJn
 IMrbb84SZtV00f3KLQF/8adq5nlkrDfboqUNbyqn+moJQeYjnFEQmXP2YDmHVMcD2EiF+O
 E71xYewy7yYCF7Dtqo2gDe7he7udonQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-12UsN48CPvy5oIC1W_oLig-1; Fri, 13 Dec 2019 06:06:41 -0500
X-MC-Unique: 12UsN48CPvy5oIC1W_oLig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DAD218B5FA9;
 Fri, 13 Dec 2019 11:06:39 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 494E560BE1;
 Fri, 13 Dec 2019 11:06:37 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
 collections
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20191213094237.19627-1-eric.auger@redhat.com>
 <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <604a28ab-3a4a-4b9f-a9fa-719edc915d0d@redhat.com>
Date: Fri, 13 Dec 2019 12:06:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d36b75e7-bd83-e501-3bd4-76bf0489c5ce@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

SGkgWmVuZ2h1aSwKCk9uIDEyLzEzLzE5IDExOjUzIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+IEhp
IEVyaWMsCj4gCj4gT24gMjAxOS8xMi8xMyAxNzo0MiwgRXJpYyBBdWdlciB3cm90ZToKPj4gU2F2
aW5nL3Jlc3RvcmluZyBhbiB1bm1hcHBlZCBjb2xsZWN0aW9uIGlzIGEgdmFsaWQgc2NlbmFyaW8u
IEZvcgo+PiBleGFtcGxlIHRoaXMgaGFwcGVucyBpZiBhIE1BUFRJIGNvbW1hbmQgd2FzIHNlbnQs
IGZlYXR1cmluZyBhbgo+PiB1bm1hcHBlZCBjb2xsZWN0aW9uLiBBdCB0aGUgbW9tZW50IHRoZSBD
VEUgZmFpbHMgdG8gYmUgcmVzdG9yZWQuCj4+IE9ubHkgY29tcGFyZSBhZ2FpbnN0IHRoZSBudW1i
ZXIgb2Ygb25saW5lIHZjcHVzIGlmIHRoZSByZGlzdAo+PiBiYXNlIGlzIHNldC4KPiAKPiBIYXZl
IHlvdSBhY3R1YWxseSBzZWVuIGEgcHJvYmxlbSBhbmQgdGhpcyBwYXRjaCBmaXhlZCBpdD8KCkl0
IGlzIG5vdCB3aXRoIGEgbGludXggZ3Vlc3QgYnV0IHdpdGgga3ZtLXVuaXQtdGVzdC4KCiBUbyBi
ZSBob25lc3QsCj4gSSdtIHN1cnByaXNlZCB0byBmaW5kIHRoYXQgd2UgY2FuIG1hcCBhIExQSSB0
byBhbiB1bm1hcHBlZCBjb2xsZWN0aW9uIDspCj4gKGFuZCBwcmV2ZW50IGl0IHRvIGJlIGRlbGl2
ZXJlZCB0byB2Y3B1IHdpdGggYW4gSU5UX1VOTUFQUEVEX0lOVEVSUlVQVAo+IGVycm9yLCB1bnRp
bCBzb21lb25lIGhhZCBhY3R1YWxseSBtYXBwZWQgdGhlIGNvbGxlY3Rpb24pLgo+IEFmdGVyIGEg
cXVpY2sgZ2xhbmNlIG9mIHNwZWMgKE1BUFRJKSwganVzdCBhcyB5b3Ugc2FpZCwgdGhpcyBpcyB2
YWxpZC4KPiAKPiBJZiBNYXJjIGhhcyBubyBvYmplY3Rpb24gdG8gdGhpcyBmaXgsIHBsZWFzZSBh
ZGQKPiAKPiBSZXZpZXdlZC1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+ClRo
YW5rIHlvdSBmb3IgdGhlIHJldmlldy4KCkVyaWMKPiAKPiAKPiBUaGFua3MsCj4gWmVuZ2h1aQo+
IAo+Pgo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY0LjExKwo+PiBGaXhlczogZWEx
YWQ1M2UxZTMxYSAoIktWTTogYXJtNjQ6IHZnaWMtaXRzOiBDb2xsZWN0aW9uIHRhYmxlCj4+IHNh
dmUvcmVzdG9yZSIpCj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVk
aGF0LmNvbT4KPj4gLS0tCj4+IMKgIHZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMgfCAzICsr
LQo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+
Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLWl0cy5jIGIvdmlydC9rdm0v
YXJtL3ZnaWMvdmdpYy1pdHMuYwo+PiBpbmRleCA5OGM3MzYwZDlmYjcuLjE3OTIwZDFiMzUwYSAx
MDA2NDQKPj4gLS0tIGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYwo+PiArKysgYi92aXJ0
L2t2bS9hcm0vdmdpYy92Z2ljLWl0cy5jCj4+IEBAIC0yNDc1LDcgKzI0NzUsOCBAQCBzdGF0aWMg
aW50IHZnaWNfaXRzX3Jlc3RvcmVfY3RlKHN0cnVjdCB2Z2ljX2l0cwo+PiAqaXRzLCBncGFfdCBn
cGEsIGludCBlc3opCj4+IMKgwqDCoMKgwqAgdGFyZ2V0X2FkZHIgPSAodTMyKSh2YWwgPj4gS1ZN
X0lUU19DVEVfUkRCQVNFX1NISUZUKTsKPj4gwqDCoMKgwqDCoCBjb2xsX2lkID0gdmFsICYgS1ZN
X0lUU19DVEVfSUNJRF9NQVNLOwo+PiDCoCAtwqDCoMKgIGlmICh0YXJnZXRfYWRkciA+PSBhdG9t
aWNfcmVhZCgma3ZtLT5vbmxpbmVfdmNwdXMpKQo+PiArwqDCoMKgIGlmICh0YXJnZXRfYWRkciAh
PSBDT0xMRUNUSU9OX05PVF9NQVBQRUQgJiYKPj4gK8KgwqDCoMKgwqDCoMKgIHRhcmdldF9hZGRy
ID49IGF0b21pY19yZWFkKCZrdm0tPm9ubGluZV92Y3B1cykpCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVJTlZBTDsKPj4gwqAgwqDCoMKgwqDCoCBjb2xsZWN0aW9uID0gZmluZF9jb2xs
ZWN0aW9uKGl0cywgY29sbF9pZCk7Cj4+Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
