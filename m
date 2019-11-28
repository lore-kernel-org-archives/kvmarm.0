Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94188C432C0
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 19:23:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10F9221771
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 19:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="lnQ4ubIa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10F9221771
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5364AEBC;
	Thu, 28 Nov 2019 14:23:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A8g-fUekir00; Thu, 28 Nov 2019 14:23:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492454AEAB;
	Thu, 28 Nov 2019 14:23:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFCE4A7FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 13:30:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WQbEtLo-kAVB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 13:30:48 -0500 (EST)
Received: from smtp-fw-9101.amazon.com (smtp-fw-9101.amazon.com
 [207.171.184.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28EEA4A7F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 13:30:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1574965849; x=1606501849;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:mime-version: content-transfer-encoding;
 bh=YmvDKDae6K6GLbl+oWNmnzof6XHtLau20RExutHZUN0=;
 b=lnQ4ubIaXPDHzp0MzTVxbjpOaenPaevsJGUoKHmJmK6OG2fLsupk/3zt
 291Rfs1GGlii3rhbm24LSRZiC8e7t8hVbduypUEx7MW5Ei8CD+Gb2+Wvl
 wxcDRhXfSkRMk6csxNbDnrRFh8/q66+XgXtIzhyzeCXmWLIn/IIKeKZXA M=;
IronPort-SDR: 3wzWyfK1I+PdPFfr1PuKgOFC9g15z/SeIIaxhknZaXOZ1f/8xBc3m/LAhzSVcX+GG7jScWhYSo
 cZ73fthAIMPQ==
X-IronPort-AV: E=Sophos;i="5.69,254,1571702400"; 
   d="scan'208";a="2054927"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO
 email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
 by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP;
 28 Nov 2019 18:30:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
 by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS
 id AB2B222639F; Thu, 28 Nov 2019 18:30:36 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 18:30:27 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 28 Nov 2019 18:30:27 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Thu, 28 Nov 2019 18:30:27 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: "drjones@redhat.com" <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Thread-Topic: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Thread-Index: AQHVpgRfU2CAtVWY9kOuYtk+vjuC16eg2hIA
Date: Thu, 28 Nov 2019 18:30:27 +0000
Message-ID: <94CC1391-FCAF-4889-A234-911C66D6D334@amazon.de>
References: <20191128155515.19013-1-drjones@redhat.com>
In-Reply-To: <20191128155515.19013-1-drjones@redhat.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-ID: <CAC2895EC2160A46972AFA411FF05A7F@amazon.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 28 Nov 2019 14:23:35 -0500
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
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

DQoNCj4gQW0gMjguMTEuMjAxOSB1bSAxNzo1NiBzY2hyaWViICJkcmpvbmVzQHJlZGhhdC5jb20i
IDxkcmpvbmVzQHJlZGhhdC5jb20+Og0KPiANCj4g77u/U2luY2UgUUVNVSBjb21taXQgODNhZDk1
OTU3YzdlICgicGwwMzE6IEV4cG9zZSBSVENJQ1IgYXMgcHJvcGVyIFdDDQo+IHJlZ2lzdGVyIikg
dGhlIFBMMDMxIHRlc3QgZ2V0cyBpbnRvIGFuIGluZmluaXRlIGxvb3AuIE5vdyB3ZSBtdXN0DQo+
IHdyaXRlIGJpdCB6ZXJvIG9mIFJUQ0lDUiB0byBjbGVhciB0aGUgSVJRIHN0YXR1cy4gQmVmb3Jl
LCB3cml0aW5nDQo+IGFueXRoaW5nIHRvIFJUQ0lDUiB3b3VsZCB3b3JrLiBBcyAnMScgaXMgYSBt
ZW1iZXIgb2YgJ2FueXRoaW5nJw0KPiB3cml0aW5nIGl0IHNob3VsZCB3b3JrIGZvciBvbGQgUUVN
VSBhcyB3ZWxsLg0KPiANCj4gQ2M6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPg0KDQpSZXZp
ZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4NCg0KU29ycnkgZm9yIGlu
dHJvZHVjaW5nIGEgdGVzdCBjYXNlIG9uIGNvZGUgdGhhdCBJIHRoZW4gbW9kaWZ5LCB3aXRob3V0
IHVwZGF0aW5nIHRoZSB0ZXN0IGNhc2UgYXMgd2VsbCA6KQ0KDQpBbGV4DQoNCg0KPiAtLS0NCj4g
YXJtL3BsMDMxLmMgfCA0ICsrLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcm0vcGwwMzEuYyBiL2FybS9wbDAz
MS5jDQo+IGluZGV4IDFmNjNlZjEzOTk0Zi4uM2I3NWZkNjUzZTk2IDEwMDY0NA0KPiAtLS0gYS9h
cm0vcGwwMzEuYw0KPiArKysgYi9hcm0vcGwwMzEuYw0KPiBAQCAtMTQzLDggKzE0Myw4IEBAIHN0
YXRpYyB2b2lkIGlycV9oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KPiAgICAgICAgcmVw
b3J0KHJlYWRsKCZwbDAzMS0+cmlzKSA9PSAxLCAiICBSVEMgUklTID09IDEiKTsNCj4gICAgICAg
IHJlcG9ydChyZWFkbCgmcGwwMzEtPm1pcykgPT0gMSwgIiAgUlRDIE1JUyA9PSAxIik7DQo+IA0K
PiAtICAgICAgICAvKiBXcml0aW5nIGFueSB2YWx1ZSBzaG91bGQgY2xlYXIgSVJRIHN0YXR1cyAq
Lw0KPiAtICAgICAgICB3cml0ZWwoMHg4MDAwMDAwMFVMTCwgJnBsMDMxLT5pY3IpOw0KPiArICAg
ICAgICAvKiBXcml0aW5nIG9uZSB0byBiaXQgemVybyBzaG91bGQgY2xlYXIgSVJRIHN0YXR1cyAq
Lw0KPiArICAgICAgICB3cml0ZWwoMSwgJnBsMDMxLT5pY3IpOw0KPiANCj4gICAgICAgIHJlcG9y
dChyZWFkbCgmcGwwMzEtPnJpcykgPT0gMCwgIiAgUlRDIFJJUyA9PSAwIik7DQo+ICAgICAgICBy
ZXBvcnQocmVhZGwoJnBsMDMxLT5taXMpID09IDAsICIgIFJUQyBNSVMgPT0gMCIpOw0KPiAtLSAN
Cj4gMi4yMS4wDQo+IA0KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5
IDIzNyA4NzkKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
