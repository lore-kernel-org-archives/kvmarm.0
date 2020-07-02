Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFC0C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:36:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5265220885
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 12:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iUKGQ/Ex"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5265220885
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF3B4B59C;
	Thu,  2 Jul 2020 08:36:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K9wK-bw8euWt; Thu,  2 Jul 2020 08:36:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9811A4B5DE;
	Thu,  2 Jul 2020 08:36:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2A74B57B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:36:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DNqAIYFdRSqp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 08:36:36 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 289894B3FF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 08:36:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593693396;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eu+kJ7Ihi6JK3py5LXu63NgxsOOft47n07UKf0C3e2o=;
 b=iUKGQ/ExaGk+GFCDuMvQGeJvWn5/xmd4xPZCT5T2TmoAHCashdp0s6GDLszc2fbIe79Q+9
 sE8SvDK/ta1SvgeOLJzN+/8k87q4cXzzQyxgxspkb6mn90+VNhQXSaPvndfwshIZpwZY+A
 cfxmiUnUf87+xTfsV8PVkQSZbOw7PjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-e9ZQNIuSODy3s9yfzPHlpA-1; Thu, 02 Jul 2020 08:36:34 -0400
X-MC-Unique: e9ZQNIuSODy3s9yfzPHlpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C90BB107ACF8;
 Thu,  2 Jul 2020 12:36:32 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 983D773FD1;
 Thu,  2 Jul 2020 12:36:31 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To: Marc Zyngier <maz@kernel.org>, Jingyi Wang <wangjingyi11@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
Date: Thu, 2 Jul 2020 14:36:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fe9699e3ee2131fe800911aea1425af4@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

SGkgTWFyYywKCk9uIDcvMi8yMCAxMDoyMiBBTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIw
MjAtMDctMDIgMDQ6MDEsIEppbmd5aSBXYW5nIHdyb3RlOgo+PiBJZiBnaWN2NC4xKHNnaSBoYXJk
d2FyZSBpbmplY3Rpb24pIHN1cHBvcnRlZCwgd2UgdGVzdCBpcGkgaW5qZWN0aW9uCj4+IHZpYSBo
dy9zdyB3YXkgc2VwYXJhdGVseS4KPiAKPiBuaXQ6IGFjdGl2ZS1sZXNzIFNHSXMgYXJlIG5vdCBz
dHJpY3RseSBhIGZlYXR1cmUgb2YgR0lDdjQuMSAoeW91IGNvdWxkCj4gaW1hZ2luZSBhIEdJQyBl
bXVsYXRpb24gb2ZmZXJpbmcgdGhlIHNhbWUgdGhpbmcpLiBGdXJ0aGVybW9yZSwgR0lDdjQuMQo+
IGlzbid0IGFzIHN1Y2ggdmlzaWJsZSB0byB0aGUgZ3Vlc3QgaXRzZWxmIChpdCBvbmx5IHNlZXMg
YSBHSUN2MykuCgpCeSB0aGUgd2F5LCBJIGhhdmUganVzdCBkb3dubG9hZGVkIHRoZSBsYXRlc3Qg
R0lDIHNwZWMgZnJvbSB0aGUgQVJNCnBvcnRhbCBhbmQgSSBzdGlsbCBkbyBub3QgZmluZCB0aGUg
R0lDRF9DVExSX0VOQUJMRV9HMUEsCkdJQ0RfQ1RMUl9uQVNTR0lyZXEgYW5kIEdJQ0RfVFlQRVIy
X25BU1NHSWNhcC4gRG8gSSBtaXNzIHNvbWV0aGluZz8KClRoYW5rcwoKRXJpYwoKCj4gCj4gVGhh
bmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
