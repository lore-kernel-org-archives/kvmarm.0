Return-Path: <SRS0=SHHE=UG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF61C28CC3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 06:53:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CEEE208C3
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jun 2019 06:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="F/Hv+9K1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CEEE208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5A294A4EA;
	Fri,  7 Jun 2019 02:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7AORxh2ELvUu; Fri,  7 Jun 2019 02:53:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1DB4A4DF;
	Fri,  7 Jun 2019 02:53:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D624A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 23:47:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4CA28MobKoLT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jun 2019 23:47:37 -0400 (EDT)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B8BF4A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jun 2019 23:47:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1559879257; x=1591415257;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=f7lUzX077j1bK+7o5EYCdBbsguKVU9Cl/73eEhYfufY=;
 b=F/Hv+9K1rip4ShMRQ0xBIoEBBC9AJp+TtVaTnxweQaO0GHiiVt4o1YfO
 RCIMiNMaNOjS6AKZur7GqwZsyzPlHlPsKMFBnImUGJEXRKVeaPCKN9ddy
 BH2UwrVJmuV5q6PPvIMzxWfvBAtZQQjMNZ2noHungzMn1g79wZ5D2+1ES w=;
X-IronPort-AV: E=Sophos;i="5.60,561,1549929600"; d="scan'208";a="405435519"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP;
 07 Jun 2019 03:47:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
 by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS
 id AE93FA2494; Fri,  7 Jun 2019 03:47:33 +0000 (UTC)
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 03:47:32 +0000
Received: from EX13D02UWC004.ant.amazon.com (10.43.162.236) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 7 Jun 2019 03:47:31 +0000
Received: from EX13D02UWC004.ant.amazon.com ([10.43.162.236]) by
 EX13D02UWC004.ant.amazon.com ([10.43.162.236]) with mapi id 15.00.1367.000;
 Fri, 7 Jun 2019 03:47:30 +0000
From: "Saidi, Ali" <alisaidi@amazon.com>
To: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
Thread-Topic: [PATCH 1/8] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
Thread-Index: AQHVHIi1OiXXp0Fy/EqmaDNzW4giDKaPOpGA
Date: Fri, 7 Jun 2019 03:47:29 +0000
Message-ID: <3698E5F4-6E33-4175-9EA0-7CB961705264@amazon.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-2-marc.zyngier@arm.com>
In-Reply-To: <20190606165455.162478-2-marc.zyngier@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.73]
Content-ID: <C746183BA199164FBEAB119812CB66A1@amazon.com>
MIME-Version: 1.0
Precedence: Bulk
X-Mailman-Approved-At: Fri, 07 Jun 2019 02:53:39 -0400
Cc: "Raslan, KarimAllah" <karahmed@amazon.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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

DQrvu79PbiA2LzYvMTksIDExOjU1IEFNLCAiTWFyYyBaeW5naWVyIiA8bWFyYy56eW5naWVyQGFy
bS5jb20+IHdyb3RlOg0KDQogICAgQWRkIHRoZSBiYXNpYyBkYXRhIHN0cnVjdHVyZSB0aGF0IGV4
cHJlc3NlcyBhbiBNU0kgdG8gTFBJDQogICAgdHJhbnNsYXRpb24gYXMgd2VsbCBhcyB0aGUgYWxs
b2NhdGlvbi9yZWxlYXNlIGhvb2tzLg0KICAgIA0KICAgIFRIZSBzaXplIG9mIHRoZSBjYWNoZSBp
cyBhcmJpdHJhcmlseSBkZWZpbmVkIGFzIDQqbnJfdmNwdXMuDQoNCkEgY2FjaGUgc2l6ZSBvZiA4
L3ZDUFUgc2hvdWxkIHJlc3VsdCBpbiBjYWNoZSBoaXRzIGluIG1vc3QgY2FzZXMgYW5kIDE2L3ZD
UFUgd2lsbCBwcmV0dHkgbXVjaCBhbHdheXMgcmVzdWx0IGluIGEgY2FjaGUgaGl0Lg0KDQpBbGkN
Cg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
