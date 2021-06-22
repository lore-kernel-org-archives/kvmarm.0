Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.8 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MIME_HTML_MOSTLY,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49554C2B9F4
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 08:03:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1C0661289
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 08:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1C0661289
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=outlook.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457AE4083E;
	Tue, 22 Jun 2021 04:03:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@outlook.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MAUm5nd9VrPZ; Tue, 22 Jun 2021 04:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7E2402BD;
	Tue, 22 Jun 2021 04:03:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30316407ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 22:33:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gFqkLwvc5esW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 22:33:52 -0400 (EDT)
Received: from APC01-PU1-obe.outbound.protection.outlook.com
 (mail-oln040092254055.outbound.protection.outlook.com [40.92.254.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1861D405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 22:33:50 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1VHCnUSJQcIrqG9Rv0NrWs1tOAaF6BV9ul3VpuUVZUytkbkEgslC+gB5wODs2GKdPd0HaN+drS0GRaXYi8xMBJRuI/90I2ePm/uefBkl3mFufTQgFFQ2afPpAcCb1ijq27HBZTtlgE6lESd8SsfFs+fRZ3RJ90WtYEC6dZuolH9z11dsltMhzU16YS+dU0IUa5TjyFKp+fdIvcTvlMG6453G72o3sYIcUytYCEnbc6eNK+EbBbD9aX2p40LD9m07DbcATEGgZuTQ9ojM59WyW6UL5laxs0uwV4lH5POY0fyfL8gurZ1mYCcOTvTj8TCkbBedd09lB8VJpDzZqB55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQ0nd6DYhefaKz953rgF725xfVuBwStIggsrIzkSOSE=;
 b=d+IaqiaqpuuPRMC5Fxtn5jGy+j+xH6GkAsxWWCVvGEVHJomXDAk19yc1YdP6ScrprvEIzrUJ3+R4mLK7twV0hQ4RgX49miKNcGlyOzsAid5XVX8hWES2zfg/V4twYsJKko9j9xZnASlrbuo7c8zSWcCldaDqsa/uidRMjvSHHSo9hl4VNAjkSequW3QlMMDgZwaxIBsaYGkAK7RU/qsT+G2YRp3PhjN+l2vXA1Dc0rojh/YD1i8ioeiYqY27EcebKANvuqZBMezR5XuDdCrMnI+GvFKNxA6WvjedTc4kxhCsM8MdEl/hfi4KhWFK3akJmtCAg4crpERsW+yxf0qymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQ0nd6DYhefaKz953rgF725xfVuBwStIggsrIzkSOSE=;
 b=pqbFrG9J/v91nTmkt5REIvS+HdkRhxYI2vDxVy58UDkoErTRncTznETeZ9BEOq/XW0m3sfTE6HK8x+AKn1ykYs8cM+AeIaYDohCDCqDTqELqnLukVn4iZijomZg7Qh5oCz8JhQphUtbudxH5WXVA4i/z1q8z2xrkmZlHmCBt0yTzfNAv+gU0yCQIZJTzFf7LfFx2IFDzelbhyqrT7IT6if7osEVx2cXk+ogSGvWoBYP6eAITuClmrSiVZe+mAQ5WJoYhILzkKnap/qkAweW/JjcdBUJvBOXbUwYALYa5SNHuSTDR+DolWNFVpKYAdQvDqGl1GGvxvplJhEalqur5AA==
Received: from PS2P216CA0042.KORP216.PROD.OUTLOOK.COM (2603:1096:300:1a::28)
 by PUZPR04MB4978.apcprd04.prod.outlook.com (2603:1096:301:b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Tue, 22 Jun
 2021 02:33:45 +0000
Received: from HK2APC01FT029.eop-APC01.prod.protection.outlook.com
 (2603:1096:300:1a:cafe::81) by PS2P216CA0042.outlook.office365.com
 (2603:1096:300:1a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Tue, 22 Jun 2021 02:33:45 +0000
Received: from OSZP286MB1136.JPNP286.PROD.OUTLOOK.COM (2a01:111:e400:7ebc::53)
 by HK2APC01FT029.mail.protection.outlook.com
 (2a01:111:e400:7ebc::195) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend
 Transport; Tue, 22 Jun 2021 02:33:44 +0000
Received: from OSZP286MB1136.JPNP286.PROD.OUTLOOK.COM
 ([fe80::f121:bc32:d11e:4022]) by OSZP286MB1136.JPNP286.PROD.OUTLOOK.COM
 ([fe80::f121:bc32:d11e:4022%5]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 02:33:44 +0000
From: =?gb2312?B?2Lfo6yCzwg==?= <yinhua_chen@outlook.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: KVM/ARM64: Booting KVM on FVP/fastmodels
Thread-Topic: KVM/ARM64: Booting KVM on FVP/fastmodels
Thread-Index: AQHXJJQFP+oFOKr+VkCj43E3/+OikqqcVB0AgBcQj62AAGibAIBsBZhi
Date: Tue, 22 Jun 2021 02:33:44 +0000
Message-ID: <OSZP286MB11361A5F1B4D592F54930F6F81099@OSZP286MB1136.JPNP286.PROD.OUTLOOK.COM>
References: <OSYPR01MB54317CECC49E872ACFD9D84B817E9@OSYPR01MB5431.jpnprd01.prod.outlook.com>
 <0bbea123-7bea-3a2e-70ae-30f43df3000e@arm.com>
 <OS0PR01MB54283E4CF20EF0D2E423E366814E9@OS0PR01MB5428.jpnprd01.prod.outlook.com>,
 <20210414095028.0bb75aaa@slackpad.fritz.box>
In-Reply-To: <20210414095028.0bb75aaa@slackpad.fritz.box>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-incomingtopheadermarker: OriginalChecksum:901D48E83638ED19531226FC88C01015E6B15BDEF0622243A677A3E0767A0B40;
 UpperCasedChecksum:07946719B2100831700F7F49EBF6F0DCA57B85105A4B743D433E3E196AD939FE;
 SizeAsReceived:7053; Count:44
x-tmn: [m6sp3vXT1j76MU1G4wasrYFjgnaSmS4J]
x-ms-publictraffictype: Email
x-incomingheadercount: 44
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 1d91ea15-152c-41c9-5c56-08d935262829
x-ms-traffictypediagnostic: PUZPR04MB4978:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nX7893L7mdmASL8tf7ivHGSjjKGqFjTxr+hAz4qW/BBHzdrmk6QtV3zAOYySHCq4oD5Rz7ZX4ka8kdGpq+fyjA0PcfyHH//emDlVy4OMRE9ErEauh/J1ilJEBnikfU560x9PaMYOEsZMCKjIPUflqkl3XhSvvmy1nXnZG3CR1qNXvNil8kb9GdEB4kOQf+G9RRsYTcRETBjHCbfyIk00S7AWBylHvWQpCek6yCy9F+h0uhVBUc80HKb5DXf7b13GNMBlREZ7tU1VFoAMc2yDLAbNgjtgNzBb00ryvokhmcmqCA8RHT363dyIzzt/OikCCXEGVt9BdtfjBuRuz973L55lbQQivukYje5xlElFMSe6gZFNVg1Lbt0zuhuLxrchmXuyZuItlB7UfAWSvd9JNry7ZApH8Cg0+qLCf1XhMNrLOusI39mqfjV/SNYYM09oo1fRSDU5ogR5vmoUAMUS5uirXBIDQhGvr9SBwoS43Zs=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: bJTgsCy9JuBJ3pQHt/hYb4albCrLyP1dTNWjgdJ1WnKOmMwSaCmNthq/ZBW0C36zHvUnVJ+cBzAag0quLNixlNQdDSX8xq1/r+mYrGb48JINf4JwQBQYO5ffMZ6yAO6abXJmF6+LLv3TBY6Ko5KNpw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-AuthSource: HK2APC01FT029.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d91ea15-152c-41c9-5c56-08d935262829
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 02:33:44.8076 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB4978
X-Mailman-Approved-At: Tue, 22 Jun 2021 04:03:05 -0400
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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
Content-Type: multipart/mixed; boundary="===============4766272633283426727=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4766272633283426727==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_OSZP286MB11361A5F1B4D592F54930F6F81099OSZP286MB1136JPNP_"

--_000_OSZP286MB11361A5F1B4D592F54930F6F81099OSZP286MB1136JPNP_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGkgQW5kcmUsDQoNCg0KDQpJIGZvbGxvdyB0aGUgZG9jdW1lbnQgaHR0cHM6Ly9naXQubGluYXJv
Lm9yZy9sYW5kaW5nLXRlYW1zL3dvcmtpbmcvYXJtL2FybS1yZWZlcmVuY2UtcGxhdGZvcm1zLmdp
dC9hYm91dC9kb2NzL2Jhc2VmdnAvdXNlci1ndWlkZS5yc3QsIGFuZCBJIGJ1aWxkIGEgTGludXgt
b24tRlZQIGVudmlyb25tZW50IHN1Y2Nlc3NmdWxseS4gSG93ZXZlciwgSSBzdGlsbCBjYW5ub3Qg
Ym9vdCBLVk0sIHRoZSBkZXRhaWxzIGFyZSBhcyBmb2xsb3dzOg0KDQoNCg0KMS5JIG1ha2Ugc3Vy
ZSB0aGF0IHR3byBjb25maWd1cmF0aW9uIGZpbGVzIGVuYWJsZSBLVk0gKEkgZ3Vlc3MgdGhlc2Ug
YXJlIHRoZSByaWdodCBjb25maWd1cmF0aW9uIGZpbGVzKSwgdGhleSBhcmUNCg0KbGF5ZXJzL21l
dGEtYXJtL21ldGEtYXJtLWJzcC9yZWNpcGVzLWtlcm5lbC9saW51eC9maWxlcy90YzAvZGVmY29u
ZmlnOkNPTkZJR19LVk09eQ0KDQpidWlsZC1wb2t5L3RtcC1wb2t5L3dvcmstc2hhcmVkL2Z2cC1i
YXNlL2tlcm5lbC1zb3VyY2UvYXJjaC9hcm02NC9jb25maWdzL2RlZmNvbmZpZzpDT05GSUdfS1ZN
PXkNCg0KDQoNCjIuSSBmb2xsb3cgdGhlIGRvY3VtZW50IGh0dHBzOi8vZ2l0LmxpbmFyby5vcmcv
bGFuZGluZy10ZWFtcy93b3JraW5nL2FybS9hcm0tcmVmZXJlbmNlLXBsYXRmb3Jtcy5naXQvYWJv
dXQvZG9jcy9iYXNlZnZwL3VzZXItZ3VpZGUucnN0LiBBZnRlciBidWlsZGluZyB0aGUgd2hvbGUg
c29mdHdhcmUgc3RhY2ssIEkgdHJ5IHNldmVyYWwgY29tbWFuZHMgYnV0IHRoZSByZXN1bHRzIHNo
b3cgdGhhdCBLVk0gZG9lcyBub3Qgd29yay4gVGhlIHNjcmVlbnNob3RzIGFyZSBzaG93biBhcyBm
b2xsb3dzW2NvbW1hbmRzXUkgdHJ5IHRocmVlIGNvbW1hbmRzLCAia3ZtLW9rIiwgImRtZXNnIHwg
Z3JlcCBLVk0iLCBhbmQgImdyZXAgLUUgLW8gJ3ZteHxzdm0nIC9wcm9jL2NwdWluZm8iLiBCdXQg
YWxsIG9mIHRoZW0gc2hvdyBuZWdhdGl2ZSByZXN1bHRzLg0KDQoNCg0KSSBndWVzcyBtYXliZSB0
aGUgcmVhc29uIGlzIHRoYXQgRlZQIGNvbmZpZ3VyYXRpb24gdXNlcyBhIEtWTS11bnN1cHBvcnQg
Q1BVLCBidXQgSSBkbyBub3Qga25vdyB0aGUgcmlnaHQgY29uZmlndXJhdGlvbiwgYW5kIHRoZSBG
VlAgZG9jdW1lbnRzIGRvIG5vdCBtZW50aW9uIGFueXRoaW5nIGFib3V0IEtWTS4NCg0KDQpBbmQg
dGhpcyBpcyB0aGUgRlZQIGJvb3RpbmcgY29tbWFuZCBpbiB0aGUgc2NyaXB0czoNCg0KPT09DQoN
Ci9GVlBfQmFzZV9SZXZDLTJ4QUVNdjhBDQoNCiAtQyBwY3RsLnN0YXJ0dXA9MC4wLjAuMA0KDQog
LUMgYnAuc2VjdXJlX21lbW9yeT0wDQoNCiAtQyBjbHVzdGVyMC5OVU1fQ09SRVM9MQ0KDQogLUMg
Y2x1c3RlcjEuTlVNX0NPUkVTPTENCg0KIC1DIGNhY2hlX3N0YXRlX21vZGVsbGVkPTANCg0KIC1D
IGJwLnBsMDExX3VhcnQwLnVudGltZWRfZmlmb3M9MQ0KDQogLUMgYnAucGwwMTFfdWFydDAudW5i
dWZmZXJlZF9vdXRwdXQ9MQ0KDQogLUMgYnAucGwwMTFfdWFydDAub3V0X2ZpbGU9dWFydDAtMTYy
NDMyODkzMjI3NDQzOTQ5Ny5sb2cNCg0KIC1DIGJwLnBsMDExX3VhcnQxLm91dF9maWxlPXVhcnQx
LTE2MjQzMjg5MzIyNzQ0Mzk0OTcubG9nDQoNCiAtQyBicC5zZWN1cmVmbGFzaGxvYWRlci5mbmFt
ZT08d29ya3NwYWNlPi9idWlsZC1wb2t5L3RtcC1wb2t5L2RlcGxveS9pbWFnZXMvZnZwLWJhc2Uv
YmwxLWZ2cC5iaW4NCg0KIC1DIGJwLmZsYXNobG9hZGVyMC5mbmFtZT08d29ya3NwYWNlPi9idWls
ZC1wb2t5L3RtcC1wb2t5L2RlcGxveS9pbWFnZXMvZnZwLWJhc2UvZmlwLWZ2cC5iaW4NCg0KIC1D
IGJwLmhvc3RicmlkZ2UuaW50ZXJmYWNlTmFtZT10YXAwDQoNCiAtQyBicC5zbXNjXzkxYzExMS5l
bmFibGVkPTENCg0KIC0tZGF0YSBjbHVzdGVyMC5jcHUwPTx3b3Jrc3BhY2U+L2J1aWxkLXBva3kv
dG1wLXBva3kvZGVwbG95L2ltYWdlcy9mdnAtYmFzZS9JbWFnZUAweDgwMDgwMDAwDQoNCiAtLWRh
dGEgY2x1c3RlcjAuY3B1MD08d29ya3NwYWNlPi9idWlsZC1wb2t5L3RtcC1wb2t5L2RlcGxveS9p
bWFnZXMvZnZwLWJhc2UvZnZwLWJhc2UtZ2ljdjMtcHNjaS1jdXN0b20uZHRiQDB4ODMwMDAwMDAN
Cg0KIC1DIGJwLnZlX3N5c3JlZ3MubW1iU2l0ZURlZmF1bHQ9MA0KDQogLUMgYnAudmVfc3lzcmVn
cy5leGl0X29uX3NodXRkb3duPTENCg0KIC1DIGJwLnZpcnRpb2Jsb2NrZGV2aWNlLmltYWdlX3Bh
dGg9PHdvcmtzcGFjZT4vYnVpbGQtcG9reS90bXAtcG9reS9kZXBsb3kvaW1hZ2VzL2Z2cC1iYXNl
L2NvcmUtaW1hZ2UtbWluaW1hbC1mdnAtYmFzZS5kaXNrLmltZw0KDQo9PT0NCg0KDQoNCklmIHlv
dSBjYW4gcHJvdmlkZSBhbnkga2luZCBvZiBoZWxwLCBJIGFwcHJlY2lhdGUgaXQgdmVyeSBtdWNo
Lg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KRnJvbTogQW5kcmUgUHJ6eXdh
cmEgPGFuZHJlLnByenl3YXJhQGFybS5jb20+DQpTZW50OiBXZWRuZXNkYXksIEFwcmlsIDE0LCAy
MDIxIDE2OjUwDQpUbzog2Lfo6yCzwiA8eWluaHVhX2NoZW5Ab3V0bG9vay5jb20+DQpDYzoga3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdSA8a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdT4N
ClN1YmplY3Q6IFJlOiBLVk0vQVJNNjQ6IEJvb3RpbmcgS1ZNIG9uIEZWUC9mYXN0bW9kZWxzDQoN
Ck9uIFdlZCwgMTQgQXByIDIwMjEgMDI6Mzc6MDcgKzAwMDANCti36Osgs8IgPHlpbmh1YV9jaGVu
QG91dGxvb2suY29tPiB3cm90ZToNCg0KPiBIaSwgQW5kcmUNCj4NCj4gRG8geW91IG1lYW4gdGhh
dCBpZiBJIGJvb3QgTGludXggb24gRlZQLCB0aGVuIEkgY2FuIHJ1biBLVk0gb24gRlZQPyBTaW5j
ZSBLVk0gaXMganVzdCBhIG1vZHVsZSBpbiBMaW51eD8NCg0KV2VsbCwgb24gQVJNIGl0J3Mgbm90
IGEga2VybmVsIG1vZHVsZSwgYnV0IGJ1aWx0LWluIHRvIHRoZSBrZXJuZWwNCmltYWdlLCBidXQg
eWVzOiBZb3UgY2FuIHJ1biBhbnkgbm9ybWFsIEtWTSBlbmFibGVkIGtlcm5lbCBvbg0KaXQuIFNv
IGp1c3QgdXNlIHRoZSBzYW1lIHJlY2lwZSB5b3Ugd291bGQgdXNlIG9uIGFueSBvdGhlciBzeXN0
ZW0gdG8NCnJ1biBLVk0gZ3Vlc3RzLg0KDQpDaGVlcnMsDQpBbmRyZQ0KDQo+IF9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fDQo+IEZyb206IEFuZHKopiBQcnp5d2FyYSA8YW5kcmUucHJ6
eXdhcmFAYXJtLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWFyY2ggMzAsIDIwMjEgMTg6MjINCj4g
VG86IHlpbmh1YV9jaGVuQG91dGxvb2suY29tIDx5aW5odWFfY2hlbkBvdXRsb29rLmNvbT47IGt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUgPGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU+
DQo+IFN1YmplY3Q6IFJlOiBLVk0vQVJNNjQ6IEJvb3RpbmcgS1ZNIG9uIEZWUC9mYXN0bW9kZWxz
DQo+DQo+IE9uIDI5LzAzLzIwMjEgMTM6MTMsIHlpbmh1YV9jaGVuQG91dGxvb2suY29tIHdyb3Rl
Og0KPg0KPiBIaSwNCj4NCj4gPiBJIHdhbnQgdG8gYm9vdCBLVk0gb24gc2ltdWxhdG9ycy4NCj4g
Pg0KPiA+IEkgZG9uJ3Qgd2FudCB0byB1c2UgUUVNVSBzaW5jZSBzb21lIGZlYXR1cmVzIGFyZSBv
bmx5IHN1cHBvcnRlZCBvbg0KPiA+IEZWUC9mYXN0bW9kZWxzIG5vdy4NCj4gPg0KPiA+IEhvd2V2
ZXIsIEkgY2Fubm90IGZpbmQgZG9jdW1lbnRzL2Jsb2dzL3dpa2kgYWJvdXQgYm9vdGluZyBLVk0g
b24NCj4gPiBGVlAvZmFzdG1vZGVscy4NCj4gPg0KPiA+IERvZXMgS1ZNIHN1cHBvcnQgcnVubmlu
ZyBvbiBGVlA/DQo+DQo+IFRoZSBGVlAgZW11bGF0ZXMgdGhlIGZ1bGwgYXJjaGl0ZWN0dXJlLCBp
bmNsdWRpbmcgYWxsIGV4Y2VwdGlvbiBsZXZlbHMNCj4gKHNvIGFsc28gRUwyKSwgYW5kIHRoZSB2
aXJ0dWFsaXphdGlvbiBzdXBwb3J0IG9mIHRoZSBHSUMgYW5kIHRoZSBHZW5lcmljDQo+IFRpbWVy
Lg0KPiBTbyB5ZXMsIHRoZSBtb2RlbHMgZnVsbHkgc3VwcG9ydCBLVk0gKG9yIGFueSBvdGhlciBo
eXBlcnZpc29yLCBmb3IgdGhhdA0KPiBtYXR0ZXIpLCBhbmQgYXJlIGluIGZhY3Qgb2Z0ZW4gdXNl
ZCBmb3IgZGV2ZWxvcGluZyBLVk0gc3VwcG9ydCBvZiBuZXcNCj4gaGFyZHdhcmUgZmVhdHVyZXMu
DQo+DQo+IFNvIHdoYXQgYXJlIHRoZSBwcm9ibGVtcyB0aGF0IHlvdSBhcmUgZmFjaW5nPyBKdXN0
IHJ1bm5pbmcgYSBrZXJuZWwgbGlrZQ0KPiB5b3Ugd291bGQgbm9ybWFsbHkgZG8gb24gdGhlIG1v
ZGVsIHNob3VsZCB3b3JrIG91dCBvZiB0aGUgYm94Lg0KPiBJZiB5b3UgZGVzY3JpYmUgeW91ciBz
ZXR1cCBhbmQgdGhlIGVycm9yIG1lc3NhZ2VzLCB3ZSBjYW4gcHJvYmFibHkgaGVscA0KPiB5b3Ug
YmV0dGVyLg0KPg0KPiBDaGVlcnMsDQo+IEFuZHJlDQo+DQo+ID4NCj4gPiBBcHByZWNpYXRlIGZv
ciB5b3VyIGhlbHAhDQo+ID4NCj4gPiBTaW5jZXJlbHksDQo+ID4gWWluaHVhDQo+ID4NCj4gPiBf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiA+IGt2bWFy
bSBtYWlsaW5nIGxpc3QNCj4gPiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1DQo+ID4gaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0NCj4gPg0K
Pg0KDQo=

--_000_OSZP286MB11361A5F1B4D592F54930F6F81099OSZP286MB1136JPNP_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">Hi=
<span>&nbsp;Andre,</span></span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">I =
follow the document<span>&nbsp;</span></span><a href=3D"https://git.linaro.=
org/landing-teams/working/arm/arm-reference-platforms.git/about/docs/basefv=
p/user-guide.rst" title=3D"" data-value=3D"https://git.linaro.org/landing-t=
eams/working/arm/arm-reference-platforms.git/about/docs/basefvp/user-guide.=
rst" class=3D"cuf-url forceOutputURL" rel=3D"noopener noreferrer" target=3D=
"_blank" style=3D"box-sizing:border-box;color:var(--lwc-brandTextLink,#005F=
B2);transition:color 0.1s linear 0s;cursor:pointer">https://git.linaro.org/=
landing-teams/working/arm/arm-reference-platforms.git/about/docs/basefvp/us=
er-guide.rst</a><span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizin=
g:border-box">,
 and I build a Linux-on-FVP environment successfully. However, I still cann=
ot boot KVM, the details are as follows:</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">1.=
I make sure that two configuration files enable KVM (I guess these are the =
right configuration files), they are</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">la=
yers/meta-arm/meta-arm-bsp/recipes-kernel/linux/files/tc0/defconfig:CONFIG_=
KVM=3Dy</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">bu=
ild-poky/tmp-poky/work-shared/fvp-base/kernel-source/arch/arm64/configs/def=
config:CONFIG_KVM=3Dy</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">2.=
I follow the document<span>&nbsp;</span></span><a href=3D"https://git.linar=
o.org/landing-teams/working/arm/arm-reference-platforms.git/about/docs/base=
fvp/user-guide.rst" title=3D"" data-value=3D"https://git.linaro.org/landing=
-teams/working/arm/arm-reference-platforms.git/about/docs/basefvp/user-guid=
e.rst" class=3D"cuf-url forceOutputURL" rel=3D"noopener noreferrer" target=
=3D"_blank" style=3D"box-sizing:border-box;color:var(--lwc-brandTextLink,#0=
05FB2);transition:color 0.1s linear 0s;cursor:pointer">https://git.linaro.o=
rg/landing-teams/working/arm/arm-reference-platforms.git/about/docs/basefvp=
/user-guide.rst</a><span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-si=
zing:border-box">.
 After building the whole software stack, I try several commands but the re=
sults show that KVM does not work. The screenshots are shown as follows</sp=
an><img alt=3D"commands" data-fileid=3D"0693t00000CBwipAAD" title=3D"comman=
ds" class=3D"slds-text-link--reset" style=3D"box-sizing:border-box;vertical=
-align:middle;max-width:100%;height:auto;cursor:pointer;margin:var(--lwc-sp=
acingXxSmall,0.25rem) 0;display:block;image-orientation:from-image;max-heig=
ht:360px" src=3D"https://services.arm.com/sfc/servlet.shepherd/version/rend=
itionDownload?rendition=3DTHUMB720BY480&amp;versionId=3D0683t00000C6sw1&amp=
;operationContext=3DCHATTER&amp;contentId=3D05T3t00000k66iA&amp;page=3D0"><=
span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">I
 try three commands, &quot;kvm-ok&quot;, &quot;dmesg | grep KVM&quot;, and =
&quot;grep -E -o 'vmx|svm' /proc/cpuinfo&quot;. But all of them show negati=
ve results.</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">I =
guess maybe the reason is that FVP configuration uses a KVM-unsupport CPU, =
but I do not know the right configuration, and the FVP documents do not men=
tion anything about KVM.</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box"><b=
r>
</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">An=
d this is the FVP booting command in the scripts:</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">=
=3D=3D=3D</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">/F=
VP_Base_RevC-2xAEMv8A&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C pctl.startup=3D0.0.0.0&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.secure_memory=3D0&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C cluster0.NUM_CORES=3D1&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C cluster1.NUM_CORES=3D1&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C cache_state_modelled=3D0&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.pl011_uart0.untimed_fifos=3D1&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.pl011_uart0.unbuffered_output=3D1 &nbsp; &nbsp; &nbsp; &nbsp;&nbs=
p;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.pl011_uart0.out_file=3Duart0-1624328932274439497.log &nbsp; &nbsp=
; &nbsp; &nbsp;&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.pl011_uart1.out_file=3Duart1-1624328932274439497.log&nbsp;</span>=
</p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.secureflashloader.fname=3D&lt;workspace&gt;/build-poky/tmp-poky/d=
eploy/images/fvp-base/bl1-fvp.bin&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.flashloader0.fname=3D&lt;workspace&gt;/build-poky/tmp-poky/deploy=
/images/fvp-base/fip-fvp.bin&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.hostbridge.interfaceName=3Dtap0&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.smsc_91c111.enabled=3D1&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;--data cluster0.cpu0=3D<span style=3D"background-color:rgb(255, 255, 25=
5);display:inline !important">&lt;workspace&gt;</span>/build-poky/tmp-poky/=
deploy/images/fvp-base/Image@0x80080000&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;--data cluster0.cpu0=3D<span style=3D"background-color:rgb(255, 255, 25=
5);display:inline !important">&lt;workspace&gt;</span>/build-poky/tmp-poky/=
deploy/images/fvp-base/fvp-base-gicv3-psci-custom.dtb@0x83000000&nbsp;</spa=
n></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.ve_sysregs.mmbSiteDefault=3D0&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.ve_sysregs.exit_on_shutdown=3D1&nbsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;-C bp.virtioblockdevice.image_path=3D<span style=3D"background-color:rg=
b(255, 255, 255);display:inline !important">&lt;workspace&gt;</span>/build-=
poky/tmp-poky/deploy/images/fvp-base/core-image-minimal-fvp-base.disk.img
<br>
</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">=
=3D=3D=3D</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">&n=
bsp;</span></p>
<p style=3D"box-sizing:border-box;margin:0px;color:rgb(51, 62, 72);font-fam=
ily:Lato;font-size:13px;background-color:rgb(255, 255, 255)">
<span dir=3D"ltr" class=3D"uiOutputText" style=3D"box-sizing:border-box">If=
 you can provide any kind of help, I appreciate it very much.</span></p>
<br>
</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Andre Przywara &lt;an=
dre.przywara@arm.com&gt;<br>
<b>Sent:</b> Wednesday, April 14, 2021 16:50<br>
<b>To:</b> =D8=B7=E8=EB =B3=C2 &lt;yinhua_chen@outlook.com&gt;<br>
<b>Cc:</b> kvmarm@lists.cs.columbia.edu &lt;kvmarm@lists.cs.columbia.edu&gt=
;<br>
<b>Subject:</b> Re: KVM/ARM64: Booting KVM on FVP/fastmodels</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Wed, 14 Apr 2021 02:37:07 +0000<br>
=D8=B7=E8=EB =B3=C2 &lt;yinhua_chen@outlook.com&gt; wrote:<br>
<br>
&gt; Hi, Andre<br>
&gt; <br>
&gt; Do you mean that if I boot Linux on FVP, then I can run KVM on FVP? Si=
nce KVM is just a module in Linux?<br>
<br>
Well, on ARM it's not a kernel module, but built-in to the kernel<br>
image, but yes: You can run any normal KVM enabled kernel on<br>
it. So just use the same recipe you would use on any other system to<br>
run KVM guests.<br>
<br>
Cheers,<br>
Andre<br>
&nbsp;<br>
&gt; ________________________________<br>
&gt; From: Andr=A8=A6 Przywara &lt;andre.przywara@arm.com&gt;<br>
&gt; Sent: Tuesday, March 30, 2021 18:22<br>
&gt; To: yinhua_chen@outlook.com &lt;yinhua_chen@outlook.com&gt;; kvmarm@li=
sts.cs.columbia.edu &lt;kvmarm@lists.cs.columbia.edu&gt;<br>
&gt; Subject: Re: KVM/ARM64: Booting KVM on FVP/fastmodels<br>
&gt; <br>
&gt; On 29/03/2021 13:13, yinhua_chen@outlook.com wrote:<br>
&gt; <br>
&gt; Hi,<br>
&gt; <br>
&gt; &gt; I want to boot KVM on simulators.<br>
&gt; &gt;<br>
&gt; &gt; I don't want to use QEMU since some features are only supported o=
n<br>
&gt; &gt; FVP/fastmodels now.<br>
&gt; &gt;<br>
&gt; &gt; However, I cannot find documents/blogs/wiki about booting KVM on<=
br>
&gt; &gt; FVP/fastmodels.<br>
&gt; &gt;<br>
&gt; &gt; Does KVM support running on FVP?&nbsp; <br>
&gt; <br>
&gt; The FVP emulates the full architecture, including all exception levels=
<br>
&gt; (so also EL2), and the virtualization support of the GIC and the Gener=
ic<br>
&gt; Timer.<br>
&gt; So yes, the models fully support KVM (or any other hypervisor, for tha=
t<br>
&gt; matter), and are in fact often used for developing KVM support of new<=
br>
&gt; hardware features.<br>
&gt; <br>
&gt; So what are the problems that you are facing? Just running a kernel li=
ke<br>
&gt; you would normally do on the model should work out of the box.<br>
&gt; If you describe your setup and the error messages, we can probably hel=
p<br>
&gt; you better.<br>
&gt; <br>
&gt; Cheers,<br>
&gt; Andre<br>
&gt; <br>
&gt; &gt;<br>
&gt; &gt; Appreciate for your help!<br>
&gt; &gt;<br>
&gt; &gt; Sincerely,<br>
&gt; &gt; Yinhua<br>
&gt; &gt;<br>
&gt; &gt; _______________________________________________<br>
&gt; &gt; kvmarm mailing list<br>
&gt; &gt; kvmarm@lists.cs.columbia.edu<br>
&gt; &gt; <a href=3D"https://lists.cs.columbia.edu/mailman/listinfo/kvmarm"=
>https://lists.cs.columbia.edu/mailman/listinfo/kvmarm</a><br>
&gt; &gt;&nbsp; <br>
&gt; <br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_OSZP286MB11361A5F1B4D592F54930F6F81099OSZP286MB1136JPNP_--

--===============4766272633283426727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4766272633283426727==--
