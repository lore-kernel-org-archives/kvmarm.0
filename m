Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3422FC47088
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98F6D613D2
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98F6D613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14B814024F;
	Wed, 26 May 2021 11:06:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CmM3T8LQQZ1l; Wed, 26 May 2021 11:06:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD9940569;
	Wed, 26 May 2021 11:06:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 247AF4029C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KlPaFJZLUoDs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 11:06:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E404024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622041570;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EJpel+uDhX/kgRZr6JWUBJGv5HNhK9aHa7tgJEuNYsY=;
 b=Gp31hUr26WbzpAlPWu6/RGmK/lfPd/M5Zx8CZqJIZcX/lJHK6Ap5+WPj/7qX45kWT2JlwO
 tKbpj+vBlClcA61sQS4IKQEp7SxR1wYTlR7zQkYpojruyWZmTcGb8z9xxTD5k7yemLeVRu
 5uhh7Pid0xzy6H3SkqVwGF1tMFlmts0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-jKsLJlvwPX2JMs75ZUlJ5Q-1; Wed, 26 May 2021 11:06:06 -0400
X-MC-Unique: jKsLJlvwPX2JMs75ZUlJ5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD44800D62;
 Wed, 26 May 2021 15:06:03 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2C9A136F5;
 Wed, 26 May 2021 15:06:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests
 for TCG
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-4-alex.bennee@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <32ada1c7-bc49-db4f-c9cd-64839ffe93c9@redhat.com>
Date: Wed, 26 May 2021 17:05:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-4-alex.bennee@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgQWxleCwKCk9uIDUvMjUvMjEgNzoyNiBQTSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFdpdGgg
dGhlIHN1cHBvcnQgZm9yIFRDRyBlbXVsYXRlZCBHSUMgd2UgY2FuIGFsc28gdGVzdCB0aGVzZSBu
b3cuCj4gCj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8u
b3JnPgo+IENjOiBTaGFzaGkgTWFsbGVsYSA8c2hhc2hpLm1hbGxlbGFAbGluYXJvLm9yZz4KUmV2
aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KCkVyaWMKCj4gLS0t
Cj4gIGFybS91bml0dGVzdHMuY2ZnIHwgMiAtLQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlv
bnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYXJtL3VuaXR0ZXN0cy5jZmcgYi9hcm0vdW5pdHRlc3Rz
LmNmZwo+IGluZGV4IGY3NzZiNjYuLjFhMzk0MjggMTAwNjQ0Cj4gLS0tIGEvYXJtL3VuaXR0ZXN0
cy5jZmcKPiArKysgYi9hcm0vdW5pdHRlc3RzLmNmZwo+IEBAIC0xOTQsNyArMTk0LDYgQEAgYXJj
aCA9IGFybTY0Cj4gIFtpdHMtbWlncmF0aW9uXQo+ICBmaWxlID0gZ2ljLmZsYXQKPiAgc21wID0g
JE1BWF9TTVAKPiAtYWNjZWwgPSBrdm0KPiAgZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZl
cnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0aW9uJwo+ICBncm91cHMgPSBpdHMgbWlncmF0aW9u
Cj4gIGFyY2ggPSBhcm02NAo+IEBAIC0yMDIsNyArMjAxLDYgQEAgYXJjaCA9IGFybTY0Cj4gIFtp
dHMtcGVuZGluZy1taWdyYXRpb25dCj4gIGZpbGUgPSBnaWMuZmxhdAo+ICBzbXAgPSAkTUFYX1NN
UAo+IC1hY2NlbCA9IGt2bQo+ICBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0z
IC1hcHBlbmQgJ2l0cy1wZW5kaW5nLW1pZ3JhdGlvbicKPiAgZ3JvdXBzID0gaXRzIG1pZ3JhdGlv
bgo+ICBhcmNoID0gYXJtNjQKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
