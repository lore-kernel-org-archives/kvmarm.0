Return-Path: <SRS0=Utlv=43=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47B2C18E5B
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:56:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D04220674
	for <kvmarm@archiver.kernel.org>; Tue, 10 Mar 2020 14:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fx9SAMIs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D04220674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9F54A500;
	Tue, 10 Mar 2020 10:56:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OeGjjvzrrsVO; Tue, 10 Mar 2020 10:56:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15AE94A49C;
	Tue, 10 Mar 2020 10:56:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F744A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:56:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOp1LdXYpTXD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Mar 2020 10:56:23 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A85C4A319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Mar 2020 10:56:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583852183;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F6Y9O3L6ux6zcyjxR98H17Ex0dxMm2pHA4GBIrRUtcw=;
 b=Fx9SAMIsXOanlte0TY5PpiAEXhzuF3byF7Iq6JwbYeXjGEgjJ8MOa+8EGgAOMcHanwrQs6
 C+L5F1dDbyYDipDwHhcvN1OSDm6+e5uHzTpJTZ91mx3rfaG53ZrxdtZJbDoqsXFs9jjymt
 lljEyQ7/m9/zYL4LSKeEQ8s5c99Vjaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-sfzD9SM5NJ6iyJlr4oKb0Q-1; Tue, 10 Mar 2020 10:56:19 -0400
X-MC-Unique: sfzD9SM5NJ6iyJlr4oKb0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47CA919067E1;
 Tue, 10 Mar 2020 14:56:17 +0000 (UTC)
Received: from [10.36.117.85] (ovpn-117-85.ams2.redhat.com [10.36.117.85])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6F5E5C28D;
 Tue, 10 Mar 2020 14:56:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add ITS tests
To: Zenghui Yu <yuzenghui@huawei.com>, Andrew Jones <drjones@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309115741.6stx5tpkb6s6ejzh@kamzik.brq.redhat.com>
 <20200309120012.xkgmlbvd5trm6ewk@kamzik.brq.redhat.com>
 <5cfe64d3-e609-cd1e-4f92-e24cf5f62c77@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <4a80c1d0-e33f-b1d9-c8d5-3a2fb01104db@redhat.com>
Date: Tue, 10 Mar 2020 15:56:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5cfe64d3-e609-cd1e-4f92-e24cf5f62c77@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMTAvMjAgMTE6MTggQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gT24g
MjAyMC8zLzkgMjA6MDAsIEFuZHJldyBKb25lcyB3cm90ZToKPj4gT24gTW9uLCBNYXIgMDksIDIw
MjAgYXQgMTI6NTc6NTFQTSArMDEwMCwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+Pj4gVGhpcyBsb29r
cyBwcmV0dHkgZ29vZCB0byBtZS4gSXQganVzdCBuZWVkcyBzb21lIHJlc3F1YXNoaW5nIGNsZWFu
dXBzLgo+Pj4gRG9lcyBBbmRyZSBwbGFuIHRvIHJldmlldz8gSSd2ZSBvbmx5IGJlZW4gcmV2aWV3
aW5nIHdpdGggcmVzcGVjdCB0bwo+Pj4gdGhlIGZyYW1ld29yaywgbm90IElUUy4gSWYgbm8gb3Ro
ZXIgcmV2aWV3cyBhcmUgZXhwZWN0ZWQsIHRoZW4gSSdsbAo+Pj4gcXVldWUgdGhlIG5leHQgdmVy
c2lvbi4KPj4KPj4gT29wcywgc29ycnkgWmVuZ2h1aSwgSSBmb3Jnb3QgdG8gYXNrIGlmIHlvdSds
bCBiZSByZXZpZXdpbmcgYWdhaW4gYXMKPj4gd2VsbC4KPiAKPiBJJ2QgbGlrZSB0byBoYXZlIGEg
bG9vayBhZ2FpbiB0aGlzIHdlZWsgaWYgdGltZSBwZXJtaXRzIDotKS7CoCBUaGFua3MKPiBmb3Ig
cmVtaW5kaW5nIG1lLgpJIGhhdmUganVzdCBzZW50OgoKW2t2bS11bml0LXRlc3RzIFBBVENIIHY1
IDAwLzEzXSBhcm0vYXJtNjQ6IEFkZCBJVFMgdGVzdHMKCndoZXJlIEkgdG9vayBsYXN0IERyZXcn
cyBjb21tZW50cwoKVGhhbmtzCgpFcmljCj4gCj4gCj4gWmVuZ2h1aQo+IAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
