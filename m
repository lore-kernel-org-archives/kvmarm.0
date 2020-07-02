Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C638CC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:42:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D44220899
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTAeST4K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D44220899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D388F4B5E6;
	Thu,  2 Jul 2020 09:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dhgCD9n5xxUm; Thu,  2 Jul 2020 09:42:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5665E4B55C;
	Thu,  2 Jul 2020 09:42:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7014B545
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vLUbxSBcfh3S for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:42:30 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B000D4B421
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:42:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593697350;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9MNOdxawbqCNhNwGOQIC2Aifh6aq6wqhAa3zMjCE53g=;
 b=eTAeST4KHJwac3W8YssmUg5l9r3nmuKgFjAt7p5SOIqyzIWYFH9s7P+QxpmGH7XBqY5jut
 AtSTKsEftKZAKNpBg0XbNdDw24ucY3dT6mk29sKKCMY60hLDLBJ4LJn7PWmtGbN+eQ7QH6
 eq3UaryNAhnZoZ0RpP4AtMxmRivdRiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-4XjQd4sqMCGNhL6LvNKvMQ-1; Thu, 02 Jul 2020 09:42:28 -0400
X-MC-Unique: 4XjQd4sqMCGNhL6LvNKvMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB3BA1083E82;
 Thu,  2 Jul 2020 13:42:26 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D7D679257;
 Thu,  2 Jul 2020 13:42:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Marc Zyngier <maz@kernel.org>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
 <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <69a37427-7e93-3411-f61c-50525a0ca3e1@redhat.com>
Date: Thu, 2 Jul 2020 15:42:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <05a3da5fa35568606e55eb6428ce91d8@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDcvMi8yMCAzOjA4IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAyMDIwLTA3LTAyIDEzOjU3LCBBdWdlciBFcmljIHdyb3RlOgo+PiBIaSBKaW5n
eWksCj4+Cj4+IE9uIDcvMi8yMCA1OjAxIEFNLCBKaW5neWkgV2FuZyB3cm90ZToKPj4+IElmIGdp
Y3Y0LjEoc2dpIGhhcmR3YXJlIGluamVjdGlvbikgc3VwcG9ydGVkLCB3ZSB0ZXN0IGlwaSBpbmpl
Y3Rpb24KPj4+IHZpYSBody9zdyB3YXkgc2VwYXJhdGVseS4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5
OiBKaW5neWkgV2FuZyA8d2FuZ2ppbmd5aTExQGh1YXdlaS5jb20+Cj4+PiAtLS0KPj4+IMKgYXJt
L21pY3JvLWJlbmNoLmPCoMKgwqAgfCA0NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKystLS0tLQo+Pj4gwqBsaWIvYXJtL2FzbS9naWMtdjMuaCB8wqAgMyArKysKPj4+IMKg
bGliL2FybS9hc20vZ2ljLmjCoMKgwqAgfMKgIDEgKwo+Pj4gwqAzIGZpbGVzIGNoYW5nZWQsIDQ0
IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4+Pgo+Pj4gZGlmZiAtLWdpdCBhL2FybS9t
aWNyby1iZW5jaC5jIGIvYXJtL21pY3JvLWJlbmNoLmMKPj4+IGluZGV4IGZjNGQzNTYuLjgwZDhk
YjMgMTAwNjQ0Cj4+PiAtLS0gYS9hcm0vbWljcm8tYmVuY2guYwo+Pj4gKysrIGIvYXJtL21pY3Jv
LWJlbmNoLmMKPj4+IEBAIC05MSw5ICs5MSw0MCBAQCBzdGF0aWMgdm9pZCBnaWNfcHJlcF9jb21t
b24odm9pZCkKPj4+IMKgwqDCoMKgIGFzc2VydChpcnFfcmVhZHkpOwo+Pj4gwqB9Cj4+Pgo+Pj4g
LXN0YXRpYyB2b2lkIGlwaV9wcmVwKHZvaWQpCj4+PiArc3RhdGljIGJvb2wgaXBpX3ByZXAodm9p
ZCkKPj4gQW55IHJlYXNvbiB3aHkgdGhlIGJvb2wgcmV0dXJuZWQgdmFsdWUgaXMgcHJlZmVycmVk
IG92ZXIgdGhlIHN0YW5kYXJkCj4+IGludD8KPj4+IMKgewo+Pj4gK8KgwqDCoCB1MzIgdmFsOwo+
Pj4gKwo+Pj4gK8KgwqDCoCB2YWwgPSByZWFkbCh2Z2ljX2Rpc3RfYmFzZSArIEdJQ0RfQ1RMUik7
Cj4+PiArwqDCoMKgIGlmIChyZWFkbCh2Z2ljX2Rpc3RfYmFzZSArIEdJQ0RfVFlQRVIyKSAmIEdJ
Q0RfVFlQRVIyX25BU1NHSWNhcCkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHZhbCAmPSB+R0lDRF9D
VExSX0VOQUJMRV9HMUE7Cj4+PiArwqDCoMKgwqDCoMKgwqAgdmFsICY9IH5HSUNEX0NUTFJfbkFT
U0dJcmVxOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIHdyaXRlbCh2YWwsIHZnaWNfZGlzdF9iYXNlICsg
R0lDRF9DVExSKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCB2YWwgfD0gR0lDRF9DVExSX0VOQUJMRV9H
MUE7Cj4+PiArwqDCoMKgwqDCoMKgwqAgd3JpdGVsKHZhbCwgdmdpY19kaXN0X2Jhc2UgKyBHSUNE
X0NUTFIpOwo+PiBXaHkgZG8gd2UgbmVlZCB0aGlzIEcxQSBkYW5jZT8KPiAKPiBCZWNhdXNlIGl0
IGlzbid0IGxlZ2FsIHRvIGNoYW5nZSB0aGUgU0dJIGJlaGF2aW91ciB3aGVuIGdyb3VwcyBhcmUg
ZW5hYmxlZC4KPiBZZXMsIGl0IGlzIGRlc2NyaWJlZCBpbiB0aGlzIGJpdCBvZiBkb2N1bWVudGF0
aW9uIG5vYm9keSBoYXMgYWNjZXNzIHRvLgoKT0sgdGhhbmsgeW91IGZvciB0aGUgZXhwbGFuYXRp
b24uIEppbmd5aSwgbWF5YmUgYWRkIGEgY29tbWVudCB0byBhdm9pZAp0aGUgcXVlc3Rpb24gYWdh
aW4gOy0pCgpUaGFua3MKCkVyaWMKPiAKPiBBbmQgdGhpcyBjb2RlIG5lZWRzIHRvIHRyYWNrIFJX
UCBvbiBkaXNhYmxpbmcgR3JvdXAtMS4KPiAKPiDCoMKgwqDCoMKgwqDCoCBNLgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlz
dAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEu
ZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
