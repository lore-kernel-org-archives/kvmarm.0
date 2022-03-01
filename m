Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8ABC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CADEA49EFD;
	Wed,  2 Mar 2022 09:04:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n2ZT+tiZcJ22; Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3C449EFE;
	Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 001A24965C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 14:03:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kzbLiJ4SWs32 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2022 14:03:36 -0500 (EST)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95768411C7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 14:03:36 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZUkMOT4vMnHvsrGqp9pmHEd4XXahrpwJE6UQR5gp6U+K3QeDSWk8ZUBqDqsdi5bQvpHrwtXKIYG2LY9R8Ei3Fpyjt4YspzW288aMX7/AQTDCd/FtRv6OSoxS+ETM0LZqMODIfTajpkJ+gZbkak9HSJzfES8BLXaq8GaNX2XFQD/olgG2soPEDxlTrFgcO8X0xCCFPDAlIrhowl3Gd0MbrVoPAyKC4lgoyTzCZtTobDnEn6ZMpBhjObeDxSwXvYaguLTiQy3on/nWPVl2wAKFrO2C+E5SFufUo0chL/WARUcJ/s6KefE0/oshIAWtekZUaUAVZ3AAHi3OQ1fRGhxoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzrLCSRRYsnezssXy8RWiCnUsQfHqrvm3jyvTkcmY6A=;
 b=M+C1OSGSgtaF/99NcwqEDHlMMI8Lb6HMX2vTBIrVcF5oIBcHi2STOKtSXVoOVNpSyUQ6mfgGakKvX1FjAe7jQwUJhu8Q6ttEubR9R/YLa7im1igzD0ha7+lkL/h/21J91jgpIBFXEtCoxyHEUZ3Q+g9KVBhKSCyl3wD5KJ0taPB2to18/d8BYMPT0Oez6DclkCX5gkYUnlXDRMXS7fqiPze9DVYZG3HrgsRg5bUJm6uCXs94aRUlUqPny2iO98VtsKyHamepHj5ubDfNgQkOK6IMcg6o0LaVicoe/ipEdFaR1q/w/UTahdc3W5A67gROmRPUJf8zfgJ1rkvjYGG2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzrLCSRRYsnezssXy8RWiCnUsQfHqrvm3jyvTkcmY6A=;
 b=iiaYHOWLY+XEwGGsY2/peaQK0AheI37r5ZFBG8uqpVgutY2ofYMlujG4iXVBB5IW7ipfDtKMOsksxjadfHwo11UthNYcedjk70Gu7V0GY8hTxeJ4rZjf5yoCxMoTsFT+Jv2eo82DFjAlVTey81bj9pI6JNAUYJrLrVd+K9d9DGhfX2TyCvVy10yjC73kQdyfDijmbL3NoCQD2wuROVahTtIGlgfiw7n1pt6f4bgu6QDpcmYfGsKRPSL0NrPcnOlrA9Jd+p7hGMUV19p3zBnhlEsdOefRuCLGkW9AuREiwZepZgOS8UOKRKMxcRmJ7vmUWC6AkR0u8Bw33AFPhcBhVw==
Received: from BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14)
 by BN8PR12MB3043.namprd12.prod.outlook.com (2603:10b6:408:65::26)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 1 Mar
 2022 19:03:33 +0000
Received: from BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32]) by BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 19:03:33 +0000
From: Eugene Huang <eugeneh@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: Timer delays in VM
Thread-Topic: Timer delays in VM
Thread-Index: AdgszUnmuyWPbbQDTHiT7yyfAge0rQAGT+yAAC1xtPA=
Date: Tue, 1 Mar 2022 19:03:33 +0000
Message-ID: <BYAPR12MB3192EFEBABB1B31D9751C931D9029@BYAPR12MB3192.namprd12.prod.outlook.com>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
 <667c9f084b2d38725369de60daef6d58@misterjones.org>
In-Reply-To: <667c9f084b2d38725369de60daef6d58@misterjones.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7e84748-7b8a-4739-e7e8-08d9fbb62ed6
x-ms-traffictypediagnostic: BN8PR12MB3043:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3043064554DDFDAFDC8CCA0FD9029@BN8PR12MB3043.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /x2pRgSWl1tcWHHd6O1JDGEsnIwhJhHtEpoApNUSgAkoOBrlvyEHVFileRO9qJdqrmpIUgY/GIC0oVtpzzTaZ9guuQ0q2ljFtv/2ZNdOU44FqZbhaFtlVaXSIU1W/Wya0UeF+azaD0tYf7DwUmAGQGbAqkWLQz6ew7Er0l0WHv65J05vMFJ3dfHG8ThTStX0F9WoRUO13rZ1V2m95V/gPZIJYgPAvTzYHj07wBaA/a19uHqdSj9Tum2T504Z0Ht+7buPGFhZMG62elO7EBt3nybLmpJK7XbwcSoZDFoaZXV0qxY0M6qJQctRqt6mT9aKgMnQ6xJNKYnHlA/zj/FaMMAr+KYXKkzxf6zo8E6mfqpzzBMl697e5NCz5rharIHIulNEoXAHmrBiqOV88HB7Ky4dDx3bAtmujJjWONG7diRWmxwlFErSzKPwAQ4+ox9jiZZOVeCe36zRVt4yjohqJeemA1ZQJ4XFbpymJOdgFUnTZKOzzbQmKGu6XVKydAYyMDHwu5m9jQkozW12ACdWaV4XJu38zJwCrl8f04MJLlZM+5CXbHUFt4zvPjyrPLyPie7BVMMrsfS4Jy8HLeAdiHI5PkiUG98Y+ruxdskiji7rJgOheWHZYoGmbGO77FEyHPW+kfUwJuK+hrsMNGFG8bKnApjsdsuh/r1iCQU8jCuiHa5UhGMP3vH9momAeOnvV8nA9frWQb3ChP+bdmTDxA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR12MB3192.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(76116006)(66946007)(66476007)(83380400001)(52536014)(66446008)(4326008)(64756008)(38100700002)(8676002)(2906002)(186003)(8936002)(26005)(3480700007)(5660300002)(33656002)(55016003)(71200400001)(38070700005)(6916009)(508600001)(316002)(86362001)(9686003)(6506007)(7696005)(122000001)(53546011);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlVzYUcxOE5NbUtHTkFuc3dDRVNzcjhQZVRPK1FpeGxJYXVoZFhsYzN2UWZl?=
 =?utf-8?B?aktjSzYyWnlmMXZVUTl6UkZaTTNBSkZnV2NWUXlOSXF0Q0JCVjE5Nk1xR1BO?=
 =?utf-8?B?QXdIa2grU1NwK0NySmFncFJtTHhwZEk4TmJvalgraVRDMWo2czJJWEtPK2x4?=
 =?utf-8?B?UktQS1lZNVBJOW01QXJ4SWJvVEgwbTQ0VzVNWnltR1JqbTl1b0poem41cytB?=
 =?utf-8?B?dDVBODY2akx2ZUZ3cFpSeTNHMG5kVCtZQWpjMXRhZ0V3M1Y0T25aWWpacEtQ?=
 =?utf-8?B?c3lUOHJVdHc0b3RmNEM2bkp1OW1WeTVyWmpxVUlGTVQwM2VzWHQ2WkpITHJS?=
 =?utf-8?B?OG95REdOTHc2NVBISGtBMTZPekVhWE1FZFN3VnBjMW5TZFVteGlHb3N6ellI?=
 =?utf-8?B?Z3ZMTHNuaWpJTEE5S1RpUWUzV3FjUDZQc3ZDOXRISUxUMVJCcTVua0V2c1Rw?=
 =?utf-8?B?cUNEcDB5d1J6MXBRVVkvNnFtT0RQUHRLLzRYdXROMzZOL3RvbncyOHVhYUZw?=
 =?utf-8?B?U2VuZmZIQW1FVEp5ZllOd1dyYW9xUHdCdWVUcUFKZHdJdmJ2SzUyaE9oOVoz?=
 =?utf-8?B?ZStEaGZyM1hORk8xZTQ5RTl2Vk51Mm0rNENwLzJyVWI5dUtPVWdtamlrYnpY?=
 =?utf-8?B?WmhCbTN3eU1PdFErTlEyRjNkdmlQNUh0Y25nY1QzUisraGQrOFc5MjFZU1hz?=
 =?utf-8?B?QVNzN2l0b2MrSVVOTVBKRXprSzVCemFsWTllL1M0TzJROENPMHdWM2RaakVQ?=
 =?utf-8?B?cGxHZXMxeUN4SEhYRGp3em9mYXppZ1NMU1JKQjh5WXpXY3N6empNdURpTFhM?=
 =?utf-8?B?RFNxUDNxZ2R0MDE1WXE3cGZPTU5qT1FxU0pGaXdZYitla3NyTHphZFY3eW1T?=
 =?utf-8?B?citSKzlseDNJSWtQMmdKVFI0NEVDbmZFSEtrZlZCRU8xWE11UzZiL0wzbzBL?=
 =?utf-8?B?K0t0Y3RSUHdSLzRLalk1ZWRuZTRCeGUwU3FLc0trL0lVb2kzVGtzcU8xTDBP?=
 =?utf-8?B?Qysxc0ZYUkhsQjJPNXZ6UE10UUV3RjJFSVlrdzlsVWFYekY2WVV1eXdmQWU4?=
 =?utf-8?B?a1c0ei9iRzBSVGk2dFQ5blFvZGU5V0EyOERBUnM4Y2N5a0xnK0Z0THpxalk5?=
 =?utf-8?B?bWR5cW1CclJiNUp3MU9QWjliVG1pOEx1VVdWaFJrdnJ6YVV1ZUF3cmNtbWVN?=
 =?utf-8?B?K01DeHhBNmNtamtyYlEvbzNzSW83amdRZWE0K1pHWnhKN3dzV080K29WcHU5?=
 =?utf-8?B?SmN0VFZIVnJYZ0NGcDJKWnM0SlYxUnFHMFZNTVNiNXdld2dOQnVHcFpsMXJ2?=
 =?utf-8?B?eTV3ZEo2RkZ0Z2hoQnovN3dvOG1LUWt4UEE3ZkpFcW5TVzlVVVJZUnRvaXFQ?=
 =?utf-8?B?ZTlwZHZsQmw4K2FPZWhOMmJtL0ppSFFzSkxGdGdyQXZ6dCt2cUtxRld1R09F?=
 =?utf-8?B?Q0VicTlCUXBrMVdIdXl5SC9MTUNFOGJVNFIxN3dsZnkwbWlTcEYwZW9aU2Ri?=
 =?utf-8?B?bzYzKzk2a2ZyMHB2TW1mU21KMjZuVXZzM2VoTTZjSThzZVU3NXVaRUw3ZkZi?=
 =?utf-8?B?ZTZGUjErNk1YdFZoZEl3VkJpNVJSME42YlZIZlM0K212dlg1NCtCNmR2RkVx?=
 =?utf-8?B?M2I2dk9Qbk9qcGJBMmtZTzU1K3dIQnlrN0FjdVE1RjN0a05OK093dTg1elhT?=
 =?utf-8?B?WWpvRTAwQnZPdDhyTThDaDM1aVhmNUZmTkM5SW5IZEIvVFJEUlBlQ0drNzVh?=
 =?utf-8?B?SUd0TE1UdlR1VjkrSmdQRWxzUnorQ3lMMzhBT2FSaytXUTBjcFRMRk9DWDlF?=
 =?utf-8?B?eDhKMmNvb2U5WWFVNE01c3B3L3NqZ2RGM2FlNUhJcE5HSVpISEwrSitDK3FH?=
 =?utf-8?B?czREVmFXVzVWMlRiNnNhSEFFQ3RmQVZRQWY4dVdJTkx0NkdSdkQwSUJzZXNN?=
 =?utf-8?B?V2tpSUdJbDlFSjhJVnQ0Vloyc2trVGNuYVFYRFU2UjZJeUk0MXJzQ3U4MFJX?=
 =?utf-8?B?UU9MbU1peU9ZT1JzSDZoTU45SlkzT0tuRi95U3lOb20xb1gwVUxaclJiYTNL?=
 =?utf-8?B?blEyNTU2aXc3akxVRVJ1cEl2RDFCRmg5QWs5RnBTRnl5R2lFZktaNmpSVEwr?=
 =?utf-8?B?RUg4eGZWRXNPaGFlakEwUTZ3S1NXOXdZZmJhRUU5NlBTeGdWVlNCd0swZDdM?=
 =?utf-8?Q?LqwTchO9wmrZMmnhmi80/K4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e84748-7b8a-4739-e7e8-08d9fbb62ed6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 19:03:33.6997 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Miokn/xEVlr2zz90fjWDJrdVwoUfHsesQZC0YzhldmBSNLD+vKbXthj/SJFD1xMtXu3ilttXYroa5HmqfBrYFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3043
X-Mailman-Approved-At: Wed, 02 Mar 2022 09:04:15 -0500
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

VGhhbmtzIE1hcmMgZm9yIHRoZSByZXBseS4gUGxlYXNlIHNlZSBpbmxpbmUgYmVsb3cgbWFya2Vk
IHdpdGggW0VIXS4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJj
IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEZlYnJ1YXJ5IDI4LCAy
MDIyIDE6MDMgUE0NCj4gVG86IEV1Z2VuZSBIdWFuZyA8ZXVnZW5laEBudmlkaWEuY29tPg0KPiBD
Yzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQ0KPiBTdWJqZWN0OiBSZTogVGltZXIgZGVs
YXlzIGluIFZNDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5r
cyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IFtQbGVhc2UgZG9uJ3Qgc2VuZCBIVE1MIGVtYWls
IGFuZCBzdGljayB0byBwbGFpbiB0ZXh0XQ0KPiANCj4gT24gMjAyMi0wMi0yOCAxODowMiwgRXVn
ZW5lIEh1YW5nIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4gSSBhbSBydW5uaW5nIHFlbXUgb24g
YW4gYXJtNjQgQ2VudE9TIGhvc3QuIEluc2lkZSBhIHVidW50dSBWTSwgYQ0KPiANCj4gSSBhc3N1
bWUgdGhhdCBieSB0aGlzIHlvdSBtZWFuIFFFTVUgYXMgdGhlIFZNTSBmb3IgYSBLVk0gZ3Vlc3Qs
IHJpZ2h0Pw0KDQpbRUhdIFllcy4NCg0KPiANCj4gPiBwcm9jZXNzIHJ1bnMgYSB0aW1lciBjcmVh
dGVkIHVzaW5nIHRpbWVyX3Q6DQo+ID4NCj4gPiBldi5zaWdldl9ub3RpZnlfZnVuY3Rpb24gPSBt
X2NhbGxiYWNrOw0KPiA+DQo+ID4g4oCmDQo+ID4NCj4gPiB0aW1lcl9jcmVhdGUoQ0xPQ0tfTU9O
T1RPTklDLCAmZXYsICZtX3RpbWVyX3QpOw0KPiA+DQo+ID4gVGhpcyB0aW1lciBzb21ldGltZXMg
aGFzIHNpZ25pZmljYW50IGRlbGF5cy4gRm9yIGV4YW1wbGUsIHRoZSA1MCBtcw0KPiA+IHRpbWVy
IGNhbiBoYXZlIGEgY2FsbGJhY2sgZGVsYXkgb2YgMTAwbXMuDQo+ID4NCj4gPiBJIGRpZCBhIGhv
c3Qga2VybmVsIHRyYWNlIGFuZCBzZWUgYSBsb3Qgb2YgV0Z4IGt2bV9leGl0cywgYW5kICB0aGUN
Cj4gPiBmb2xsb3dpbmcgZXZlbnRzIGJldHdlZW4ga3ZtX2V4aXQgYW5kIGt2bV9lbnRyeToNCj4g
Pg0KPiA+IGt2bV9leGl0DQo+ID4NCj4gPiBrdm1fd2Z4X2FybTY0DQo+ID4NCj4gPiBrdm1fZ2V0
X3RpbWVyX21hcA0KPiA+DQo+ID4gc2NoZWRfc3dpdGNoDQo+ID4NCj4gPiBrdm1fdGltZXJfc2F2
ZV9zdGF0ZQ0KPiA+DQo+ID4ga3ZtX3RpbWVyX3VwZGF0ZV9pcnENCj4gPg0KPiA+IHZnaWNfdXBk
YXRlX2lycV9wZW5kaW5nDQo+ID4NCj4gPiBrdm1fdGltZXJfcmVzdG9yZV9zdGF0ZQ0KPiA+DQo+
ID4ga3ZtX3ZjcHVfd2FrZXVwDQo+ID4NCj4gPiBrdm1fYXJtX3NldHVwX2RlYnVnDQo+ID4NCj4g
PiBrdm1fYXJtX3NldF9kcmVnMzINCj4gPg0KPiA+IGt2bV9lbnRyeQ0KPiANCj4gQWxsIG9mIHRo
aXMgaXMgcGVyZmVjdGx5IG5vcm1hbCAoZ3Vlc3QgaGl0cyBXRkkgZnJvbSBpdHMgaWRsZSBsb29w
LCBubyBpbnRlcnJ1cHQgaXMNCj4gcGVuZGluZywgdHJhcCB0byBFTDIsIHNjaGVkdWxlIG91dCwg
c2NoZWR1bGUgYmFjayBpbiwgcmVlbnRlciB0aGUgZ3Vlc3QpLg0KPiANCj4gPg0KPiA+IEkgaGF2
ZSB0aGUgZm9sbG93aW5nIHF1ZXN0aW9uczoNCj4gPg0KPiA+ICAgICAgICogV2h5IHRoZXJlIGFy
ZSBhIGxvdCBXRnggZXhpdHM/IElzIHRoZSB0aW1lciBkZXBlbmRlbnQgb24gaXQ/DQo+IA0KPiBU
aGF0J3MgbW9zdCBwcm9iYWJseSBiZWNhdXNlIHlvdXIgdmNwdSBnb2VzIGlkbGUgYW5kIGV4ZWN1
dGUgV0ZJIHRvIFdhaXQNCj4gRm9yIGFuIEludGVycnVwdC4gQXMgbm8gaW50ZXJydXB0IGlzIHBl
bmRpbmcsIHRoZSB2Y3B1IGV4aXRzIHNvIHRoYXQgdGhlIGhvc3QNCj4gY2FuIGRvIHNvbWV0aGlu
ZyB1c2VmdWwgdW50aWwgaXQgZ2V0cyBhbiBpbnRlcnJ1cHQgdGhhdCBpcyB0YXJnZXRlZCBhdCB0
aGUgdmNwdS4NCj4gT24gYW4gaWRsZSBWTSwgdGhpcyBwcm9iYWJseSBoYXBwZW5zIDEwMHMgb2Yg
dGltZXMgYSBzZWNvbmQuDQo+IA0KPiA+ICAgICAgICogRG9lcyB0aGlzIHRpbWVyIHJlbHkgb24g
a3ZtIHRpbWVyIGlycSBpbmplY3Rpb24/DQo+IA0KPiBZZXMuIEEgdGltZXIgaW50ZXJydXB0IGlz
IGFsd2F5cyBpbmplY3RlZCBpbiBTVy4gQnV0IHRoZSB0aW1lciBpbnRlcnJ1cHQgY2FuDQo+IGVp
dGhlciBjb21lIGZyb20gdGhlIEhXIHRpbWVyIGl0c2VsZiAodGhlIFZNIHdhcyBydW5uaW5nIHdo
aWxlIHRoZSB0aW1lcg0KPiBleHBpcmVkKSwgb3IgZnJvbSBhIFNXIHRpbWVyIHRoYXQgS1ZNIGFz
IHNldHVwIGlmIHRoZSBndWVzdCB3YXMgYmxvY2tlZCBvbg0KPiBXRkkuDQoNCjxFSD4gSGVyZSBm
b3IgYXJtNjQsIEVMMVZpcnR1YWwgVGltZXIgaXMgdXNlZC4gRUwxIFZpcnR1YWwgVGltZXIgaXMg
YSBIVyB0aW1lciwgY29ycmVjdD8NClRoZXJlIGlzIGFuIGFybXZ0aW1lciBpbXBsZW1lbnRhdGlv
biBpbiBRRU1VIDYuMSsuIERvZXMgdGhpcyBhcm12dGltZXIgbWFrZSBhIGRpZmZlcmVuY2U/DQoN
Cj4gDQo+ID4gICAgICAgKiBXaGF0IGNhbiBiZSBhbnkgcG9zc2libGUgY2F1c2VzIGZvciB0aGUg
dGltZXIgZGVsYXk/IEFyZSB0aGVyZQ0KPiA+IHNvbWUgbG9ja2luZyBtZWNoYW5pc21zIHdoaWNo
IGNhbiBjYXVzZSB0aGUgZGVsYXk/DQo+IA0KPiBUaGlzIGNvbXBsZXRlbHkgZGVwZW5kIG9uIGhv
dyBsb2FkZWQgeW91ciBob3N0IGlzLCB0aGUgcmVzcGVjdGl2ZSBwcmlvcml0aWVzDQo+IG9mIHRo
ZSB2YXJpb3VzIHByb2Nlc3NlcywgYW5kIGEgbWlsbGlvbiBvZiBvdGhlciB0aGluZ3MuDQo+IFRo
aXMgaXMgbm8gZGlmZmVyZW50IGZyb20gdGhlIHNhbWUgdXNlcnNwYWNlIHJ1bm5pbmcgb24gdGhl
IGhvc3QuDQo+IEl0IGFsc28gZGVwZW5kcyBvbiB0aGUgKmd1ZXN0KiBrZXJuZWwsIGJ5IHRoZSB3
YXkuDQoNCjxFSD4gT3VyIGd1ZXN0IGtlcm5lbCBpcyA1LjQuIEhvdyBpcyB0aGUgKmd1ZXN0KiBr
ZXJuZWwgaW52b2x2ZWQ/IENhbiB5b3UgZ2l2ZSBhbiBleGFtcGxlPyBEbyB5b3UgaGF2ZSBzdWdn
ZXN0aW9ucyBvbiB0aGUgZ3Vlc3Qga2VybmVsIHZlcnNpb24gYXMgd2VsbC4NCg0KPiANCj4gVGhl
cmUgYXJlIG9mIGNvdXJzZSBsb2NrcyBhbGwgb3ZlciB0aGUgcGxhY2UsIGJ1dCB0aGF0J3MgdGhl
IHZlcnkgbmF0dXJlIG9mIHRoZQ0KPiBiZWFzdC4NCj4gDQo+ID4gICAgICAgKiBXaGF0IHBhcmFt
ZXRlcnMgY2FuIHR1bmUgdGhpcyB0aW1lcj8NCj4gDQo+IE5vbmUuIFlvdSBtYXkgd2FudCB0byBj
aGVjayB3aGV0aGVyIHRoZSBkZWxheSBpcyBvYnNlcnZlZCB3aGVuIHRoZSBWTQ0KPiBoYXMgaGl0
IFdGSSBvciBub3QuDQoNCjxFSD4gWWVzLCBkZWxheSBpcyBvYnNlcnZlZCBhZnRlciB2bV9leGl0
IGJlY2F1c2Ugb2YgV0Z4IChub3Qgc3VyZSBXRkkgb3IgV0ZFKSBidXQgb25seSB3aGVuIG9uIGEg
ZGlmZmVyZW50IHZDUFUgaW4gdGhlIHNhbWUgVk0gc29tZSB3b3JrbG9hZCBpcyBzdGFydGVkLiBT
aW5jZSB3ZSBwaW4gdGhhdCB3b3JrbG9hZCB0byBpdHMgb3duIHZDUFUsIGluIHRoZW9yeSwgaXQg
c2hvdWxkIG5vdCBhZmZlY3QgdGhlIHRpbWluZyBvZiBhbm90aGVyIHZDUFUuDQoNCj4gDQo+IFlv
dSBhbHNvIGRvbid0IG1lbnRpb24gd2hhdCBob3N0IGtlcm5lbCB2ZXJzaW9uIHlvdSBhcmUgcnVu
bmluZy4NCj4gSW4gZ2VuZXJhbCwgcGxlYXNlIHRyeSBhbmQgcmVwcm9kdWNlIHRoZSBpc3N1ZSB1
c2luZyB0aGUgbGF0ZXN0IGtlcm5lbCB2ZXJzaW9uDQo+ICg1LjE2IGF0IHRoZSBtb21lbnQpLiBQ
bGVhc2UgYWxzbyBpbmRpY2F0ZSB3aGF0IEhXIHlvdSBhcmUgdXNpbmcuDQoNCjxFSD4gVHJpZWQg
NS4xNSBhbmQgNS40IGtlcm5lbHMuIEJvdGggaGF2ZSB0aGUgaXNzdWUuIERvIHlvdSB0aGluayA1
LjE2IGNhbiBtYWtlIGEgZGlmZmVyZW5jZT8gVGhlIEhXIGlzIGFuIEFtcGVyZSBBbHRyYSBzeXN0
ZW0uDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+ICAgICAgICAgIE0uDQo+IC0tDQo+IEphenogaXMg
bm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uDQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
