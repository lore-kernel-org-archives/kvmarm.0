Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DFFC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D2D549F14;
	Wed,  2 Mar 2022 09:04:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NcBG3+QQDoS3; Wed,  2 Mar 2022 09:04:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D75A49F07;
	Wed,  2 Mar 2022 09:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5556D40BC0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 21:28:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E6ZIZVRMeHTu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2022 21:28:00 -0500 (EST)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE3FD40BBE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2022 21:27:59 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+et213zleL46oSkGgWLQ5dYwXnaJuLXspXOh7OrKtvguBHgq1v/p23PYYeeNk8wgE6fno4gKRex0gY9e+zUKF5HuRSq0RjllsauA4+T2Dr3Www21Cm+IpJu9y4PUcxxc73WWBIwPUzfU/yEWOwLgSsdVi1k/+7Q32XMXKG6DFNtjYOkIpt3Mmr9k3wwwnFJsT9d1BV46fOaebZqzSdqhLP/USi1vvJmVqp90KlawUiUhRwMbdHrUAXRjdJjSi+VRAVI/nXyRqyTXxJXnLQsknzRsvGuNmsgs7R73eaexrVQPgkJUt7KUkexCsCxww7S5gqveN5QlfTLyjCHFz2oeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsmXZeGIB68uufOtpVHVp9CFT8Cv03ELcnyiLhF4eBE=;
 b=QWXj9EHplDqqo9C0PrUSxYg7rhRaj2yWAwp5FgJLTTVoMNfIWbJIRavUep38y4Vkx4s49qWuDVHxPe7GzYkTAmEUJE4nIjiq9FG8G9lLTo5PKT2hN3ua4NchVGvwtlglKfNnX9Hw8S6RJ+94JdiWfgKBkogzcPGoZJVXIwnztb/7iucAxD7JMsz50kk6CicMJ88Obmc4Pyn4QISWTcMr5lArW8dw4iXpX25jCgvQAv60Do0C8kLrpSryS+jWoU27P6EBSqhjIt/sP6Vs99ZJ2zMdLUi1S3nbipq7UNXj4IQpxtgHX0Qu3TcPwRm837RGml+muQuQc/+xINck2IhyjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsmXZeGIB68uufOtpVHVp9CFT8Cv03ELcnyiLhF4eBE=;
 b=ps66cyEmmqIS0kQMKUYaiKdG+8k0r5T6fV87Ey3Xq+BROP+HPA42ehjKo2RyRAQN64FpuDgyrTwdRu6CwrkS0buchi0BF/F8DRtdmKM2CK9gFpOHUenVNzc5y0XNTYRByzO5XTUIj437/zsSo9BB6ca+NntXsVOIpx4XZXN/co3omrDGIQlM74mZPGsbWlVDfNIgxPjziit0Wz9TjkVIvf/m9tT0ULEmV/ujMb8mAHhtl21B3TpXUmTJ79gtoGv/DadyN+meMh73W5QMBOwXmLr2lz1ehI2vdkXmyyLId3cYxzjvLpROq97ks+bIMRPKonhbgYR/dKmfRoe/J0XTug==
Received: from BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14)
 by DM6PR12MB3627.namprd12.prod.outlook.com (2603:10b6:5:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 02:27:57 +0000
Received: from BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32]) by BYAPR12MB3192.namprd12.prod.outlook.com
 ([fe80::fdf5:3159:a592:7d32%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 02:27:57 +0000
From: Eugene Huang <eugeneh@nvidia.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: Timer delays in VM
Thread-Topic: Timer delays in VM
Thread-Index: AdgszUnmuyWPbbQDTHiT7yyfAge0rQAGT+yAAC1xtPAAECAskA==
Date: Wed, 2 Mar 2022 02:27:57 +0000
Message-ID: <BYAPR12MB3192DAC11FA1DD16652B5B23D9039@BYAPR12MB3192.namprd12.prod.outlook.com>
References: <BYAPR12MB31927AEB9D0A4068ED12826DD9019@BYAPR12MB3192.namprd12.prod.outlook.com>
 <667c9f084b2d38725369de60daef6d58@misterjones.org>
 <BYAPR12MB3192EFEBABB1B31D9751C931D9029@BYAPR12MB3192.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB3192EFEBABB1B31D9751C931D9029@BYAPR12MB3192.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1213d670-2ab4-4689-e26e-08d9fbf443c2
x-ms-traffictypediagnostic: DM6PR12MB3627:EE_
x-microsoft-antispam-prvs: <DM6PR12MB362721F283DD2DAFAA44C392D9039@DM6PR12MB3627.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 10413LMo3OnR3oW9bt1/tBLeNcrL30ftyqKcXyppWafdq8WlHXpzmuIhcnGrz85l4XaIYZltmKCh+CJIwQQp5IcqTkRqtiJt+IS8NZ5JfCzuOwwoNBE4ys+BcsbM8OZP/acG4g9heuzLAitNrU6a1l00dSoV9cpyYadHyyGzVqc3vAOltbNeA0BkBn5zhFYqNnfM94LV9edQLjW8I6n9vSn9eQYfzyq6um6N4JKK2Jgt71cFuz4zEAjzJLzOaj8UR8TJo9n5qXr8woZgtd314B3U03KKydV2rMn9G94meEj+HDmLzvLA8qHkMjLSq9mwDxRKRoBjHhZQUu6IUsdCKwMQYXt5fQU1PNokObDNdNV2cmdyeTnfHogjFX00K0GbbZHaiq6zUOYLquVUDAWp4Wg8TEYywH1RoemmKn9tzYxLTPKB2ZkLmLowSbtSXJqdmh2SsYOwU8OzoHP3jFLV6miKqLMgcrwZa6cIbdce913pkeltutz+0dTcWNJLSqvkM6ulQy9DICvDUqHDgd0mDX1cOjPKAAUv/zm7KGR4RhGn802ck5Hj3Y8yexjk2kMy0yRtWwUIryWDakqfM6DidJf5dwvb73IjeF2+OoEr0iqn8GYHjONOstemq/dXP0ZowzWacOL7io1UCJUxWtFDLysNNJF6Hdb+B10/63kgebYkgbJsilr8RHZ7aAa9EfANET6FUtptfqaY3OHxlXa7lw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BYAPR12MB3192.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(6506007)(38100700002)(53546011)(7696005)(33656002)(83380400001)(55016003)(508600001)(122000001)(71200400001)(6916009)(52536014)(8936002)(316002)(86362001)(9686003)(5660300002)(38070700005)(26005)(186003)(66476007)(8676002)(66946007)(76116006)(66556008)(64756008)(66446008)(3480700007)(4326008)(2906002);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0o0RW9tT2F5UkVXNXd1cUtOUmdDTHdVUFFRMDY3ZnR0U2NaZ2Zud1M5WEdR?=
 =?utf-8?B?UXcrRlBjVVVidnhuR1VrZXl1WFhLUUs0OWZLSVpyUkJvRWJucERuVXZraDJC?=
 =?utf-8?B?d1dWZjJmZ0F5UmhOTys5Y01YK0JqRVp2SkgydGl1WkcrZ2FKcVpRdGNLbFF5?=
 =?utf-8?B?VWNDcmpDZE1iWnBxWGtaZ0ZYV1p2TWdRSzhSWDFGcHlrR1hsankwSE9vL1cx?=
 =?utf-8?B?dlNmQXpwNktuRWNpOS83OUt1MldXaGxhVUd6NVlrNHF0Zkc4OXFZTk1rNnV4?=
 =?utf-8?B?MzFtZXRPRHJGOUFldEVBbVF5amVBVDc3VzBQSWRtRDg1R0haN2ZFQ01DWFZt?=
 =?utf-8?B?emx6U2hleEZVM2pMUmpsWjM1encyN2hUeVpzVUhaa2JOVWRaVEluanBEMjlI?=
 =?utf-8?B?elBrL24yL1FOS0JRdXNPeU4xYjZyV1VFWmdNWmhxSE84Mkxzay9TNWZhUjZC?=
 =?utf-8?B?SGRPb0NDVXlZczZ2N0hFNnVhMUFTbjFZSUFVVS9LNFpuK2ZJaDh1QUd3dXNt?=
 =?utf-8?B?aDVOTUJ0Q25kYTloajNBaExLenl5OExXeGhldElUclZBVTd1Q0lsUnZnYkc3?=
 =?utf-8?B?WHlQa2FiRlp6VmVWWUJYNnpLV2Q2TEEwUVJob1UwYTl5WFJZL2F1QWEwUWJJ?=
 =?utf-8?B?cGtSMk5USVI3QXR0VG5Fcmk4VHo3WTZhWUxJR0FMWDl0VTdSN3RZT1NmRitJ?=
 =?utf-8?B?Uk51R05LUmI3bXBRMURTUVNNdkQrSjhPT3JxU0NmS2owUnBuN3Z3dnhMdlVR?=
 =?utf-8?B?bUJlUER4WXRmRnhiYzRaQWhPaWlmNjl1bmJ6cCtXdEdzdzE5Vjc2Vy9oV2lh?=
 =?utf-8?B?bGJFZzVYSW9UZGNtakY4dTJVcFZqd2RHTVIzR0FxYkRvdytJV3JpeFJRbXFh?=
 =?utf-8?B?b3RQc0ZOb0hhUkJvUlQrNkxkMCtmQ0ZEcnp5U3BpVVd4M3VtM3hZeFhtYXVE?=
 =?utf-8?B?Q25CZmw2RGQ3SjVKMTFhWnhleWFjbGw0OU5SdlduQk5IL2Y5Q1hDQWxsTVpP?=
 =?utf-8?B?Y0I2OTZIelB4NkNwSzBvdlJWRHp0eUgyeEpZaUJqSXdVcThpaDNNbzkrekRj?=
 =?utf-8?B?eHdwWDEwSk54Y1BEZUtnc2ZxeGJXcGhvMDA0RGdYVHZCLzVWUkxsSGhhNEo3?=
 =?utf-8?B?N3A0TjJCVlptdER6V3FoWDZMdkRBZFFkUzc0dlpRSEYvVEI3WW9wNC9ONkI4?=
 =?utf-8?B?c21pN0djMEFNUFZWY2xZQjZka3d0MVhIZDNRYjNZdEpsMmhLNUxhYXZnMG9R?=
 =?utf-8?B?WEV4aitHMHNoU0xwT3kxQjBENUQrN21rUjJRRVZZR1pWa1ljaVBwY0ExSi8x?=
 =?utf-8?B?Rm1nM0JVdnVwT1liL2M4UUFFcVRPWDN1S054c1V3VklZVHU3TllJQ1ExUlhW?=
 =?utf-8?B?cmIzcGNDSXZsZXlubUZueVRPSllxczNPbHV5ZWt1TUwwalk3UVpuSUc3bUtI?=
 =?utf-8?B?dDBNdXRzeWdTWEcrL3N0TmRPMVpjUEtMblMzc1k0ZmVvMU5RTDF1WG5nSjNs?=
 =?utf-8?B?b01oUmZoUGoxUUhQTW5aZk5CSFJpTm9iek9nNldlVk51czVWM1h1bjZQU2dx?=
 =?utf-8?B?YVl4dHFLVk53MkZvQzF2Q3prMkdWQ0NGNjZ4Y1hqcmpUbzBZTG9EamJ4d0lP?=
 =?utf-8?B?UXNiVkZZK1lJdFZ0aE9mVFhlcVRSQmQyRUxMbStpMXFWbzk2Q2x5UVZNSXlP?=
 =?utf-8?B?VEUrTHNpR3dJRW53bm1hVG1sNnJUTzZ6T0dHZEUvZmpZOG1BNFpqcUdad0Jm?=
 =?utf-8?B?Z0x2UDVsNGZBaFB5Rzl6UFYzSXgrTDRmUUtNMlUzT0RhNU11Ymp3NGpHaitz?=
 =?utf-8?B?UVUzbEJ4cXZpeHB3UDBwRngvaHZOVExsQ0F2endCVnhPbVZSS2QxUVBNNE1M?=
 =?utf-8?B?TmFQSk9hcTFBMVNBbGRRcEhJeVZ3Yjl5dWNVWFh2bVc4V2IyTGRUSmRvMVNO?=
 =?utf-8?B?QXQyeHZWWm95SFQwS2Vqek0vYXkzclVlZDZHWUJCUGNzbDdLU1lHVFM0NEk2?=
 =?utf-8?B?ZEx5ckRMODc1dnl1d29tR1ZrNForcFVOSkFzVy9MaGJ4Nm9HbE5jWGxwbm80?=
 =?utf-8?B?TkxpcTlkK09GaE1KODJJajRmNUZuT1h1RGpMMjljVUJodGxmSGk0U3lqVDQv?=
 =?utf-8?B?MURnOFNCckZhYzBYSHhIakxtK1dPbUdWTTlDdFFWVXpNMlc5OTlRbkN2Z0pv?=
 =?utf-8?Q?5pbJ+uTYEKAhMKrhBugC4WU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1213d670-2ab4-4689-e26e-08d9fbf443c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 02:27:57.5667 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2K/LE41PJ6lylQCOsyiKQlKjZRqWJQ0YKuCsYTWvkNC0MBWbntQwko+kHOyyjs/bLukt/4vCrmWLP/AhEBKJ8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3627
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

VXBkYXRlOiB0cmllZCA1LjE2LjExIGtlcm5lbC4gU2FtZSBiZWhhdmlvci4NCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFdWdlbmUgSHVhbmcNCj4gU2VudDogVHVlc2Rh
eSwgTWFyY2ggMSwgMjAyMiAxMTowNCBBTQ0KPiBUbzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVs
Lm9yZz4NCj4gQ2M6IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUNCj4gU3ViamVjdDogUkU6
IFRpbWVyIGRlbGF5cyBpbiBWTQ0KPiANCj4gVGhhbmtzIE1hcmMgZm9yIHRoZSByZXBseS4gUGxl
YXNlIHNlZSBpbmxpbmUgYmVsb3cgbWFya2VkIHdpdGggW0VIXS4NCj4gDQo+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
Pg0KPiA+IFNlbnQ6IE1vbmRheSwgRmVicnVhcnkgMjgsIDIwMjIgMTowMyBQTQ0KPiA+IFRvOiBF
dWdlbmUgSHVhbmcgPGV1Z2VuZWhAbnZpZGlhLmNvbT4NCj4gPiBDYzoga3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQ0KPiA+IFN1YmplY3Q6IFJlOiBUaW1lciBkZWxheXMgaW4gVk0NCj4gPg0K
PiA+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1l
bnRzDQo+ID4NCj4gPg0KPiA+IFtQbGVhc2UgZG9uJ3Qgc2VuZCBIVE1MIGVtYWlsIGFuZCBzdGlj
ayB0byBwbGFpbiB0ZXh0XQ0KPiA+DQo+ID4gT24gMjAyMi0wMi0yOCAxODowMiwgRXVnZW5lIEh1
YW5nIHdyb3RlOg0KPiA+ID4gSGksDQo+ID4gPg0KPiA+ID4gSSBhbSBydW5uaW5nIHFlbXUgb24g
YW4gYXJtNjQgQ2VudE9TIGhvc3QuIEluc2lkZSBhIHVidW50dSBWTSwgYQ0KPiA+DQo+ID4gSSBh
c3N1bWUgdGhhdCBieSB0aGlzIHlvdSBtZWFuIFFFTVUgYXMgdGhlIFZNTSBmb3IgYSBLVk0gZ3Vl
c3QsIHJpZ2h0Pw0KPiANCj4gW0VIXSBZZXMuDQo+IA0KPiA+DQo+ID4gPiBwcm9jZXNzIHJ1bnMg
YSB0aW1lciBjcmVhdGVkIHVzaW5nIHRpbWVyX3Q6DQo+ID4gPg0KPiA+ID4gZXYuc2lnZXZfbm90
aWZ5X2Z1bmN0aW9uID0gbV9jYWxsYmFjazsNCj4gPiA+DQo+ID4gPiDigKYNCj4gPiA+DQo+ID4g
PiB0aW1lcl9jcmVhdGUoQ0xPQ0tfTU9OT1RPTklDLCAmZXYsICZtX3RpbWVyX3QpOw0KPiA+ID4N
Cj4gPiA+IFRoaXMgdGltZXIgc29tZXRpbWVzIGhhcyBzaWduaWZpY2FudCBkZWxheXMuIEZvciBl
eGFtcGxlLCB0aGUgNTAgbXMNCj4gPiA+IHRpbWVyIGNhbiBoYXZlIGEgY2FsbGJhY2sgZGVsYXkg
b2YgMTAwbXMuDQo+ID4gPg0KPiA+ID4gSSBkaWQgYSBob3N0IGtlcm5lbCB0cmFjZSBhbmQgc2Vl
IGEgbG90IG9mIFdGeCBrdm1fZXhpdHMsIGFuZCAgdGhlDQo+ID4gPiBmb2xsb3dpbmcgZXZlbnRz
IGJldHdlZW4ga3ZtX2V4aXQgYW5kIGt2bV9lbnRyeToNCj4gPiA+DQo+ID4gPiBrdm1fZXhpdA0K
PiA+ID4NCj4gPiA+IGt2bV93ZnhfYXJtNjQNCj4gPiA+DQo+ID4gPiBrdm1fZ2V0X3RpbWVyX21h
cA0KPiA+ID4NCj4gPiA+IHNjaGVkX3N3aXRjaA0KPiA+ID4NCj4gPiA+IGt2bV90aW1lcl9zYXZl
X3N0YXRlDQo+ID4gPg0KPiA+ID4ga3ZtX3RpbWVyX3VwZGF0ZV9pcnENCj4gPiA+DQo+ID4gPiB2
Z2ljX3VwZGF0ZV9pcnFfcGVuZGluZw0KPiA+ID4NCj4gPiA+IGt2bV90aW1lcl9yZXN0b3JlX3N0
YXRlDQo+ID4gPg0KPiA+ID4ga3ZtX3ZjcHVfd2FrZXVwDQo+ID4gPg0KPiA+ID4ga3ZtX2FybV9z
ZXR1cF9kZWJ1Zw0KPiA+ID4NCj4gPiA+IGt2bV9hcm1fc2V0X2RyZWczMg0KPiA+ID4NCj4gPiA+
IGt2bV9lbnRyeQ0KPiA+DQo+ID4gQWxsIG9mIHRoaXMgaXMgcGVyZmVjdGx5IG5vcm1hbCAoZ3Vl
c3QgaGl0cyBXRkkgZnJvbSBpdHMgaWRsZSBsb29wLCBubw0KPiA+IGludGVycnVwdCBpcyBwZW5k
aW5nLCB0cmFwIHRvIEVMMiwgc2NoZWR1bGUgb3V0LCBzY2hlZHVsZSBiYWNrIGluLCByZWVudGVy
DQo+IHRoZSBndWVzdCkuDQo+ID4NCj4gPiA+DQo+ID4gPiBJIGhhdmUgdGhlIGZvbGxvd2luZyBx
dWVzdGlvbnM6DQo+ID4gPg0KPiA+ID4gICAgICAgKiBXaHkgdGhlcmUgYXJlIGEgbG90IFdGeCBl
eGl0cz8gSXMgdGhlIHRpbWVyIGRlcGVuZGVudCBvbiBpdD8NCj4gPg0KPiA+IFRoYXQncyBtb3N0
IHByb2JhYmx5IGJlY2F1c2UgeW91ciB2Y3B1IGdvZXMgaWRsZSBhbmQgZXhlY3V0ZSBXRkkgdG8N
Cj4gPiBXYWl0IEZvciBhbiBJbnRlcnJ1cHQuIEFzIG5vIGludGVycnVwdCBpcyBwZW5kaW5nLCB0
aGUgdmNwdSBleGl0cyBzbw0KPiA+IHRoYXQgdGhlIGhvc3QgY2FuIGRvIHNvbWV0aGluZyB1c2Vm
dWwgdW50aWwgaXQgZ2V0cyBhbiBpbnRlcnJ1cHQgdGhhdCBpcw0KPiB0YXJnZXRlZCBhdCB0aGUg
dmNwdS4NCj4gPiBPbiBhbiBpZGxlIFZNLCB0aGlzIHByb2JhYmx5IGhhcHBlbnMgMTAwcyBvZiB0
aW1lcyBhIHNlY29uZC4NCj4gPg0KPiA+ID4gICAgICAgKiBEb2VzIHRoaXMgdGltZXIgcmVseSBv
biBrdm0gdGltZXIgaXJxIGluamVjdGlvbj8NCj4gPg0KPiA+IFllcy4gQSB0aW1lciBpbnRlcnJ1
cHQgaXMgYWx3YXlzIGluamVjdGVkIGluIFNXLiBCdXQgdGhlIHRpbWVyDQo+ID4gaW50ZXJydXB0
IGNhbiBlaXRoZXIgY29tZSBmcm9tIHRoZSBIVyB0aW1lciBpdHNlbGYgKHRoZSBWTSB3YXMgcnVu
bmluZw0KPiA+IHdoaWxlIHRoZSB0aW1lciBleHBpcmVkKSwgb3IgZnJvbSBhIFNXIHRpbWVyIHRo
YXQgS1ZNIGFzIHNldHVwIGlmIHRoZQ0KPiA+IGd1ZXN0IHdhcyBibG9ja2VkIG9uIFdGSS4NCj4g
DQo+IDxFSD4gSGVyZSBmb3IgYXJtNjQsIEVMMVZpcnR1YWwgVGltZXIgaXMgdXNlZC4gRUwxIFZp
cnR1YWwgVGltZXIgaXMgYSBIVw0KPiB0aW1lciwgY29ycmVjdD8NCj4gVGhlcmUgaXMgYW4gYXJt
dnRpbWVyIGltcGxlbWVudGF0aW9uIGluIFFFTVUgNi4xKy4gRG9lcyB0aGlzIGFybXZ0aW1lcg0K
PiBtYWtlIGEgZGlmZmVyZW5jZT8NCj4gDQo+ID4NCj4gPiA+ICAgICAgICogV2hhdCBjYW4gYmUg
YW55IHBvc3NpYmxlIGNhdXNlcyBmb3IgdGhlIHRpbWVyIGRlbGF5PyBBcmUNCj4gPiA+IHRoZXJl
IHNvbWUgbG9ja2luZyBtZWNoYW5pc21zIHdoaWNoIGNhbiBjYXVzZSB0aGUgZGVsYXk/DQo+ID4N
Cj4gPiBUaGlzIGNvbXBsZXRlbHkgZGVwZW5kIG9uIGhvdyBsb2FkZWQgeW91ciBob3N0IGlzLCB0
aGUgcmVzcGVjdGl2ZQ0KPiA+IHByaW9yaXRpZXMgb2YgdGhlIHZhcmlvdXMgcHJvY2Vzc2VzLCBh
bmQgYSBtaWxsaW9uIG9mIG90aGVyIHRoaW5ncy4NCj4gPiBUaGlzIGlzIG5vIGRpZmZlcmVudCBm
cm9tIHRoZSBzYW1lIHVzZXJzcGFjZSBydW5uaW5nIG9uIHRoZSBob3N0Lg0KPiA+IEl0IGFsc28g
ZGVwZW5kcyBvbiB0aGUgKmd1ZXN0KiBrZXJuZWwsIGJ5IHRoZSB3YXkuDQo+IA0KPiA8RUg+IE91
ciBndWVzdCBrZXJuZWwgaXMgNS40LiBIb3cgaXMgdGhlICpndWVzdCoga2VybmVsIGludm9sdmVk
PyBDYW4geW91DQo+IGdpdmUgYW4gZXhhbXBsZT8gRG8geW91IGhhdmUgc3VnZ2VzdGlvbnMgb24g
dGhlIGd1ZXN0IGtlcm5lbCB2ZXJzaW9uIGFzDQo+IHdlbGwuDQo+IA0KPiA+DQo+ID4gVGhlcmUg
YXJlIG9mIGNvdXJzZSBsb2NrcyBhbGwgb3ZlciB0aGUgcGxhY2UsIGJ1dCB0aGF0J3MgdGhlIHZl
cnkNCj4gPiBuYXR1cmUgb2YgdGhlIGJlYXN0Lg0KPiA+DQo+ID4gPiAgICAgICAqIFdoYXQgcGFy
YW1ldGVycyBjYW4gdHVuZSB0aGlzIHRpbWVyPw0KPiA+DQo+ID4gTm9uZS4gWW91IG1heSB3YW50
IHRvIGNoZWNrIHdoZXRoZXIgdGhlIGRlbGF5IGlzIG9ic2VydmVkIHdoZW4gdGhlIFZNDQo+ID4g
aGFzIGhpdCBXRkkgb3Igbm90Lg0KPiANCj4gPEVIPiBZZXMsIGRlbGF5IGlzIG9ic2VydmVkIGFm
dGVyIHZtX2V4aXQgYmVjYXVzZSBvZiBXRnggKG5vdCBzdXJlIFdGSSBvcg0KPiBXRkUpIGJ1dCBv
bmx5IHdoZW4gb24gYSBkaWZmZXJlbnQgdkNQVSBpbiB0aGUgc2FtZSBWTSBzb21lIHdvcmtsb2Fk
IGlzDQo+IHN0YXJ0ZWQuIFNpbmNlIHdlIHBpbiB0aGF0IHdvcmtsb2FkIHRvIGl0cyBvd24gdkNQ
VSwgaW4gdGhlb3J5LCBpdCBzaG91bGQgbm90DQo+IGFmZmVjdCB0aGUgdGltaW5nIG9mIGFub3Ro
ZXIgdkNQVS4NCj4gDQo+ID4NCj4gPiBZb3UgYWxzbyBkb24ndCBtZW50aW9uIHdoYXQgaG9zdCBr
ZXJuZWwgdmVyc2lvbiB5b3UgYXJlIHJ1bm5pbmcuDQo+ID4gSW4gZ2VuZXJhbCwgcGxlYXNlIHRy
eSBhbmQgcmVwcm9kdWNlIHRoZSBpc3N1ZSB1c2luZyB0aGUgbGF0ZXN0IGtlcm5lbA0KPiA+IHZl
cnNpb24NCj4gPiAoNS4xNiBhdCB0aGUgbW9tZW50KS4gUGxlYXNlIGFsc28gaW5kaWNhdGUgd2hh
dCBIVyB5b3UgYXJlIHVzaW5nLg0KPiANCj4gPEVIPiBUcmllZCA1LjE1IGFuZCA1LjQga2VybmVs
cy4gQm90aCBoYXZlIHRoZSBpc3N1ZS4gRG8geW91IHRoaW5rIDUuMTYgY2FuDQo+IG1ha2UgYSBk
aWZmZXJlbmNlPyBUaGUgSFcgaXMgYW4gQW1wZXJlIEFsdHJhIHN5c3RlbS4NCj4gDQo+ID4NCj4g
PiBUaGFua3MsDQo+ID4NCj4gPiAgICAgICAgICBNLg0KPiA+IC0tDQo+ID4gSmF6eiBpcyBub3Qg
ZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4NCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
