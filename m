Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B62C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:20:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78D8761439
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 11:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78D8761439
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E76AE4056A;
	Thu, 13 May 2021 07:20:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I8w6SoFCccgX; Thu, 13 May 2021 07:20:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA17F4B37B;
	Thu, 13 May 2021 07:20:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB6394B318
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:20:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lHlLH5+HfsJM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 07:20:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4EBC4056A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 07:20:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620904830;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gl58JM3qwCzTQk1/iD8HqqF6tQAH25wEwcXh1lA0IN4=;
 b=G7rxM+T51N5nYjRz5ixnpExRtzLFz1JLOawlSYfjC5tSlXZ7G4SyaP/xTtPFTd/uNCKIL8
 f9y3/UjEQrGGy/+yydDIfvyYSnj7VHQ6exn29ISdDSGSW3XYgj1+iJDQI3K4fsn0auXS0r
 DmH++yBwiCZVgWCVTESHWTewAoclSUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-6g6Cj2c2OHeKzi8X1tXwfQ-1; Thu, 13 May 2021 07:20:27 -0400
X-MC-Unique: 6g6Cj2c2OHeKzi8X1tXwfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED78180ED8E;
 Thu, 13 May 2021 11:20:25 +0000 (UTC)
Received: from [10.64.54.43] (vpn2-54-43.bne.redhat.com [10.64.54.43])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D0616EF48;
 Thu, 13 May 2021 11:20:23 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: selftests: Request PMU feature in get-reg-list
To: Marc Zyngier <maz@kernel.org>
References: <20210513130655.73154-1-gshan@redhat.com>
 <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5c72317d-2fff-e260-1806-31163e9f893b@redhat.com>
Date: Thu, 13 May 2021 23:20:49 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
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

T24gNS8xMy8yMSA5OjE0IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjAyMS0wNS0xMyAx
NDowNiwgR2F2aW4gU2hhbiB3cm90ZToKPj4gU2luY2UgdGhlIGZvbGxvd2luZyBjb21taXQsIFBN
VSByZWdpc3RlcnMgYXJlIGhpZGRlbiBmcm9tIHVzZXIgdW50aWwKPj4gaXQncyBleHBsaWNpdGx5
IHJlcXVlc3RlZCBieSBmZWVkaW5nIGZlYXR1cmUgKEtWTV9BUk1fVkNQVV9QTVVfVjMpLgo+PiBP
dGhlcndpc2UsIDc0IG1pc3NpbmcgUE1VIHJlZ2lzdGVycyBhcmUgbWlzc2luZyBhcyB0aGUgZm9s
bG93aW5nCj4+IGxvZyBpbmRpY2F0ZXMuCj4+Cj4+IMKgwqAgMTE2NjMxMTFjZDQ5ICgiS1ZNOiBh
cm02NDogSGlkZSBQTVUgcmVnaXN0ZXJzIGZyb20gdXNlcnNwYWNlIHdoZW4KPj4gbm90IGF2YWls
YWJsZSIpCj4+Cj4+IMKgwqAgIyAuL2dldC1yZWctbGlzdAo+PiDCoMKgIE51bWJlciBibGVzc2Vk
IHJlZ2lzdGVyczrCoMKgIDMwOAo+PiDCoMKgIE51bWJlciByZWdpc3RlcnM6wqDCoMKgwqDCoMKg
wqDCoMKgwqAgMjM4Cj4+Cj4+IMKgwqAgVGhlcmUgYXJlIDc0IG1pc3NpbmcgcmVnaXN0ZXJzLgo+
PiDCoMKgIFRoZSBmb2xsb3dpbmcgbGluZXMgYXJlIG1pc3NpbmcgcmVnaXN0ZXJzOgo+Pgo+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgQVJNNjRfU1lTX1JFRygzLCAwLCA5LCAxNCwgMSksCj4+IMKgwqDC
oMKgQVJNNjRfU1lTX1JFRygzLCAwLCA5LCAxNCwgMiksCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCA6Cj4+IMKgwqDCoMKgQVJNNjRfU1lTX1JFRygzLCAzLCAxNCwgMTUsIDcpLAo+Pgo+PiBU
aGlzIGZpeGVzIHRoZSBpc3N1ZSBvZiB3cm9uZ2x5IHJlcG9ydGVkIG1pc3NpbmcgUE1VIHJlZ2lz
dGVycyBieQo+PiByZXF1ZXN0aW5nIGl0IGV4cGxpY2l0bHkuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6
IEdhdmluIFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+Cj4+IC0tLQo+PiDCoHRvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS9hYXJjaDY0L2dldC1yZWctbGlzdC5jIHwgMiArKwo+PiDCoDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS9hYXJjaDY0L2dldC1yZWctbGlzdC5jCj4+IGIvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL2FhcmNoNjQvZ2V0LXJlZy1saXN0LmMKPj4gaW5kZXggNDg2OTMyMTY0Y2Yy
Li42YzZiZGM2ZjVkYzMgMTAwNjQ0Cj4+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2
bS9hYXJjaDY0L2dldC1yZWctbGlzdC5jCj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9hYXJjaDY0L2dldC1yZWctbGlzdC5jCj4+IEBAIC0zMTQsNiArMzE0LDggQEAgc3RhdGlj
IHZvaWQgY29yZV9yZWdfZml4dXAodm9pZCkKPj4KPj4gwqBzdGF0aWMgdm9pZCBwcmVwYXJlX3Zj
cHVfaW5pdChzdHJ1Y3Qga3ZtX3ZjcHVfaW5pdCAqaW5pdCkKPj4gwqB7Cj4+ICvCoMKgwqAgaW5p
dC0+ZmVhdHVyZXNbMF0gfD0gMSA8PCBLVk1fQVJNX1ZDUFVfUE1VX1YzOwo+PiArCj4+IMKgwqDC
oMKgIGlmIChyZWdfbGlzdF9zdmUoKSkKPj4gwqDCoMKgwqDCoMKgwqDCoCBpbml0LT5mZWF0dXJl
c1swXSB8PSAxIDw8IEtWTV9BUk1fVkNQVV9TVkU7Cj4+IMKgfQo+IAo+IFBsZWFzZSBzZWUgQW5k
cmV3J3Mgc2VyaWVzWzFdLCB3aGljaCBhY3R1YWxseSBkZWFscyB3aXRoIG9wdGlvbnMuCj4gCj4g
IMKgwqDCoMKgwqDCoMKgIE0uCj4gCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAy
MTA1MDcyMDA0MTYuMTk4MDU1LTEtZHJqb25lc0ByZWRoYXQuY29tCj4KClRoYW5rcywgTWFyYy4g
WWVzLCBEcmV3J3Mgc2VyaWVzIGFscmVhZHkgaGFkIHRoZSBmaXguClNvcnJ5IGFib3V0IHRoZSBu
b2lzZSBhbmQgcGxlYXNlIGlnbm9yZSB0aGlzLgoKVGhhbmtzLApHYXZpbgoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
