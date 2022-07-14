Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905D9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 11:34:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D29B54BE51;
	Fri, 15 Jul 2022 07:34:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@synopsys.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@synopsys.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YK+OVLcjhXwA; Fri, 15 Jul 2022 07:34:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BB7B4BE29;
	Fri, 15 Jul 2022 07:34:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EC34C5BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 07:33:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jUkiK8O-r65o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 07:33:09 -0400 (EDT)
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com
 [149.117.73.133])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFDE04C56A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 07:33:09 -0400 (EDT)
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com
 [10.192.0.82])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
 by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A955F40E42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
 t=1657798388; bh=CjKM7hoM7A3m6OtxbsTrSlbJz6UtwlXCXPxS3xa+XvY=;
 h=From:To:Subject:Date:From;
 b=S2cvdW0pvG75UAfkvnrs46OrY9mkHNE93gv6mT75wIHlBlWLHM1NxF9eKNGGEHAZe
 msZe128WVefH99OK1H10QMl68nmx8zsZCXnmN+D3r3IgDqLesiHHwTsMJPHrE8bsF6
 CSze5L/19ohmbTc7QVEaNu7LW5MVDpdHABrg/lhddMq38PCRgBXWfCr2XvPp716MyR
 hmZYnPwE+GkxePyLLzAiQUMMIj6Q/0+F8sGVzRMtltvVDQ4qugxXMSFTVonPIgGMnU
 IFv0yLGonYmXRQCX1epFRkplTFTjQuBnTVUvuD9RpEYvBqB7/A4rbKKMsBnwQVYVsg
 g3obXVeNNahrg==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com
 [10.202.1.139])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client CN "o365relay-in.synopsys.com",
 Issuer "Entrust Certification Authority - L1K" (verified OK))
 by mailhost.synopsys.com (Postfix) with ESMTPS id 51AA1A005E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:33:08 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (Client CN "mail.protection.outlook.com",
 Issuer "DigiCert Cloud Services CA-1" (verified OK))
 by o365relay-in.synopsys.com (Postfix) with ESMTPS id E471140030
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:33:07 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com;
 dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
 spf=pass smtp.mailfrom=tobies@synopsys.com
Authentication-Results: o365relay-in.synopsys.com; dkim=pass (1024-bit key;
 unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="HZvvGmBZ";
 dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btsC9A7T4FoTh6T86KVzX1AJEd5T3kh2kGNdcejqmK/YoaM4CnH4LcbkYaZnbxds/qccAW2ouEWCEwObHYF0XfTuZeZ5LDE6ohUIcp1yCS7g6UrAeTmGRGkUIwVtdzpoo+NjC6efGEILnLrLzYgnSO+ktMtexD16pIuQNfotDRQO+zb35BaDUEALxhjDCHEzAc4zFcu9O4k9UeLYma4CfilFTzgI9aFzFyRlRR1/vXdKKMTw06Zb7t1Au3eGvRHHCFFboPfBySUrK5UWs9SOGe5ChINCybkziVqwCaUCuNegYHb539l8GwmB1/B+iBmrQ4bhtP0sH+kDfJA4dqPtGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjKM7hoM7A3m6OtxbsTrSlbJz6UtwlXCXPxS3xa+XvY=;
 b=kP2T3OanKFUinZr+4YwP+aF+7EpUgeYrTCfyY1tTpVsviEs0PWda5VwLhaOpwH8MuzwdCmMs5FHBSWt6V1QLxKLsD63XK+CdKtn371Vlr3vwsXRz6+H9bHPkuZWx9rWJBios8TC9tK3tEKXVxN7ArtEWBF3AWpmyYFLwm7kt0OzqNkah4+NG+KpGP3e0xjgoD8HXqxaI6Q85tT9syGHYTSYy0C/XJyvxFt3TBTYVEnLZ6OhjAO7gkKe+C1HelE58mJ6cIwlqmvaeKEe9+DcLvfXnkMKToRpXYKyK34obMgeL6qkzFKxQHRuVvyrbq1Sc5F1FnVpcxPiWpGLLbfSn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjKM7hoM7A3m6OtxbsTrSlbJz6UtwlXCXPxS3xa+XvY=;
 b=HZvvGmBZqZUyLw25bPOeGy0HUfuZTg/GgkHSwbjz9wnpxtHmex+FL2OfLcVOliXoa1N4PI0uumX3cpb5N2i/IPk/hiAMQZ4mhfS4301XzUNxtTvM9SUJ3qE1IaiFEBkc4DpQtDg7BmeZidlJ+kHmEOEeub2LoUSCnAcWTPQgHic=
Received: from DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17)
 by CY4PR12MB1416.namprd12.prod.outlook.com (2603:10b6:903:44::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 11:33:04 +0000
Received: from DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::71d2:76ea:f7c5:86e1]) by DM4PR12MB5264.namprd12.prod.outlook.com
 ([fe80::71d2:76ea:f7c5:86e1%7]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 11:33:04 +0000
X-SNPS-Relay: synopsys.com
From: Stephan Tobies <Stephan.Tobies@synopsys.com>
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: re-injecting debug exceptions
Thread-Topic: re-injecting debug exceptions
Thread-Index: AdiXdLpiiPczKeniTrSoAFXBdiUjsA==
Date: Thu, 14 Jul 2022 11:33:04 +0000
Message-ID: <DM4PR12MB5264A1C31FE78B03A712EC0DB1889@DM4PR12MB5264.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5Lmh0bWwiIHA9ImM6XHVzZXJzXHRvYmllc1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWI3YzUyZWRmLTAzNjgtMTFlZC05ZTllLWFjNzRiMTcyYTQzOFxhbWUtdGVzdFxiN2M1MmVlMC0wMzY4LTExZWQtOWU5ZS1hYzc0YjE3MmE0Mzhib2R5Lmh0bWwiIHN6PSIzNTI1IiB0PSIxMzMwMjI3MTk4MjM1OTAzNjciIGg9ImJrczZzU296SnNaa0p0TjNPYVZVcDd3cllDZz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7aa9f09d-4200-4bab-59bd-08da658c9dce
x-ms-traffictypediagnostic: CY4PR12MB1416:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NqBDy2Nk8Gy9pgf5iJGJikmn1p81UpyobPVcEAiz527INTwqPxHi/wn64Tzw3etz1tnI2FcS8KYibIMVDAG6zy4ArCzbEj3X1u7Oo89EuMH0Ia47PuR4I6VaCu/j+mCUcym8OxZyJcSIUnuXeTfXzB02vO59y0R95G+sLxk2dv6g9qC7ING3YdlYWHU+W/6prbUTjqzmCdED3aNCnt+ukvr9/CVeMcQ/t8NBwIEo5imwn5veHWIzCKZEnnhI1D3GV3zGekXxNbgoX8rqGBWyGZEeJTWXF26QeX8fdNHeYoCFB5jLZw4T3MAi4M/+J19CfuQ7teYANXXLmmvB+pXFbbriDxgubM+KaFKhfwSwisibi87vnVpShS6GthSs9p5+HeGfcLUHSyWlmPSqVWmAJKhSB5SDr2heyhfspwym17K3o6hRSKuSadPL5bfak6oE/UJDTZwUNGy2DQfdo+L4sENPJvQp8AcO08fShzIBElbkebfUv5oPVugJE9AHfXdvsFyhn70ABoh66xtxvCpUBVednMzBwHFn8qY0kYgOEQ13glP9JLzJftq6Rz/l8xs5mC0ECwNdRW+qmMyDrc1sTSc+Ew64ZGfia8p+mFvhZBSFlNLpV5rkh9AmKKJa6s4859DhA33E5IPL+LDljQ2PyE23Wsi6WMAIelsyVEI668W0mI5MvvCbepgv+0Ru9cS29mLGfzjfRMGEC6XBzpjj81mf29ol4JfKzb67jcuaOapB9QZBH02qAKovBukaZzxuCHoTTyBuafSe6ATBx24RX4astLScLIIV7D/oNP7vIm98cOdxSAfKEmITNL6yBaDzCc+EpHa5CMAEtGYKbL+5eXWADMuGeLf4FyE98OATltk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM4PR12MB5264.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(39860400002)(366004)(346002)(136003)(376002)(55016003)(38070700005)(38100700002)(186003)(66574015)(122000001)(6916009)(316002)(8676002)(66476007)(76116006)(64756008)(66946007)(66446008)(66556008)(71200400001)(41300700001)(8936002)(52536014)(4744005)(9686003)(5660300002)(7696005)(6506007)(478600001)(33656002)(86362001)(166002)(3480700007)(2906002)(26005);
 DIR:OUT; SFP:1102; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?am1uamtOTDJYQk1idVV5MURQUkdBREtmZHYwS0hyQkhYZHJuaEZhN0ZrWTlt?=
 =?utf-8?B?bEN6dHQ2S0szeHl4YjNXRms2MzhhaXZ6ck4rQ01qTExFMnhPNGJJekN1aEZx?=
 =?utf-8?B?NjZsa0FMUmN2MGxUZkxxWXlaRTg3OXBCT0tSTWNaZmpXNjdZaTlCdmh2TndX?=
 =?utf-8?B?b3BlL25NM0RsYU5jaCttaGF6Zy9FbXdVcVZnaEdMWmMra2w0RnBWdlUyU1B4?=
 =?utf-8?B?V3AzYW9JVWJCTU9KY0M1czhGV1huYXJ3d3ZHTVgwUDJQK05zeHRISmtGWUtB?=
 =?utf-8?B?NkwrYVF5Uk9NeEtDdUFMRHk3bFd5NGsxTXJGeGxpOWE1Y3FFeE9HU2xldGtU?=
 =?utf-8?B?NWFEclcxZW50V0tyVjFoc3UxRHJPaXkwV3c3VmRpZTJ3SnRNRld6VjgrVFg2?=
 =?utf-8?B?bitBVlNDRjdmck50NitVZExSMndkZU00U2dnRHhpaFhhdmpZcmhOTmFPcHJs?=
 =?utf-8?B?c0RRVVl4QVlvSEVDaDdRN3Fha2c4TS9KNFRwcWhObHgxNmtZMk1tRVVMczBq?=
 =?utf-8?B?Vy9pN0dVTVRaUndzRVNsMER5aGRGNkZhUk03UlM5bmVqYUNTS21OalpZQmgw?=
 =?utf-8?B?ZlF6TUxFUHhDYmVmRlpxOHYzSDJSV2hWQnAzeFNvRGVab1dBRjhMeUlZRzVj?=
 =?utf-8?B?RTByeGpwcUV5RGNwRzc5WHNoZ1Zqb2FqcDJkK2YyWVhFa2M5cHJsZzU1cHYw?=
 =?utf-8?B?WE4veWlLemtqdEJFa1Z3SVQxTHFCOUZWWE9TRzc5YUdieTVnYWt2Znl4Zzhy?=
 =?utf-8?B?cUsyOVFSUG5ET214Sm0wUEpXWE9mM0ZSME14R2N3SkpyMGZhZW9aTmcycDdO?=
 =?utf-8?B?dnlJOG9vbEJqMkk2c0tCakE1eWVLbTA5QmhvM2RrbjlKZVhDV2dIZlpudGZT?=
 =?utf-8?B?cWlCYnYramZsamhacDRyeWI5VEJMNTlZa0plT3Buc2V5aGpod1dOQjJqU2lL?=
 =?utf-8?B?Q3R2UzhJRzY1WTdsbTgxd2o5VXhqVjdzMUpNNHBIdGdnNGJUeUN0KzQ2SklN?=
 =?utf-8?B?UjRXbVJKUDF4Si84SkhWczQ2MmJlSkVDL2Mzb1dUZ1hsOCtLTlR6RlBLU2ZO?=
 =?utf-8?B?UVhhTnp6cWRjWmcwMkhPelg1UjhjTnRhNlRkSUtoZzJFTGw5aTlLaGtaUUw4?=
 =?utf-8?B?RXl2NERmbjJZSVpnR0J5dFRadTFFWVhJVzRITkxJNExYR2c0d2FKTjNJT3Ew?=
 =?utf-8?B?WElkdWpJRUsrOE9ZcWRzZVBUQ3AvT1pzQmxPMUducUNlbjdMUTUvNmdyUTRv?=
 =?utf-8?B?TzJnVmpqM0lCb3MvZ2ErMjBqMEIvSlpKSXFwTmlnRkpaT2NOaVhvMW9EbTlZ?=
 =?utf-8?B?d2Z3Q1FDTFFzSG5WdnZTYStZWWFQMnViY3ZOVzZyT3JDUzBvSVhWQk1zb0Nt?=
 =?utf-8?B?WmxnK1pGOGt6aHJUNUlMS0xuQzZmczFJdlk5Rm1ZVWlpbVFTY2FmM1daSVpT?=
 =?utf-8?B?QWo4QmxhZWxvNi8yL2lxbkhib1Y5b2FuN1VjSDRqMUMxZGZucVhkOXVMcXFX?=
 =?utf-8?B?NHArdktrbnJ4cnI4VzNJUERYQnR3V2NCVlpiSUZ0bERLMHc2SFI2MW9oZlBh?=
 =?utf-8?B?TmlUVlBEQkpjMDF4RGdTaG85c3A2Sm9OMlhUZ2szQkVoNlpBN3dwRHRUNU83?=
 =?utf-8?B?VzdEWUZXcWx6Rks5WXlIMmV2aVllVlpIZUJCdTNYNFJsWDRtaXdxVUpZS1JM?=
 =?utf-8?B?eWQwcnQzMk1hdTRmSjJ3OVd4TUF2enpoTWZPclNWVzhNTlBKbFBjczBBeFUv?=
 =?utf-8?B?KzdaT3NKVi9icVQ0bm83VWttSjE5RWlUUWExclBXTGdGcjRwb0pXMWpwNTRx?=
 =?utf-8?B?SzllbCtzT2VaclN2RDlDL0xUa004aXQrdlJnc1JjbG1QaURmcE1IWFNkbmw2?=
 =?utf-8?B?djYwelZORFBFcGhOZUd6MzBTMUtJNmk4dnkxa2k0SW54UmxJMkdwRkpnT2NY?=
 =?utf-8?B?OHFYWTQrSmNZeHFJd0JRamVhMmtjNGlscEloZnluOFZzUUxKQzcrVDlXblp3?=
 =?utf-8?B?b1lDYWNrR1M2akZHYkxyV0xzek0rdm44bDUvMWwyNmlUaTBOWktaWXpiM1M2?=
 =?utf-8?B?QmhEcHlTL2pIaDlwL2hLQVVTZkdiQmEzZkVaVVhmOGtMc2c4YmZCdFV1YUxy?=
 =?utf-8?Q?kKKksc8EQnqMrSTy5m2Pso6Hi?=
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5264.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa9f09d-4200-4bab-59bd-08da658c9dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 11:33:04.3094 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54AvYJC0R3bOWKqtwzbR/BV+zlumPG0DALHCdJBcnsTCu+Re83Gt1Tjv/Znf9CD7EcX3KjopkoWzvn+5EkSopw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1416
X-Mailman-Approved-At: Fri, 15 Jul 2022 07:34:06 -0400
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
Content-Type: multipart/mixed; boundary="===============1662711302543880247=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1662711302543880247==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM4PR12MB5264A1C31FE78B03A712EC0DB1889DM4PR12MB5264namp_"

--_000_DM4PR12MB5264A1C31FE78B03A712EC0DB1889DM4PR12MB5264namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIGNvbW1lbnQgZm9yIGt2bV9oYW5kbGVfZ3Vlc3RfZGVidWcgKGh0dHBzOi8vZWxpeGlyLmJv
b3RsaW4uY29tL2xpbnV4L2xhdGVzdC9zb3VyY2UvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQu
YyNMMTA3KSBzdGF0ZXMgdGhhdCBpdCBpcyB1cCB0byB0aGUgdXNlcnNwYWNlIHRvIHJlLWluamVj
dCBkZWJ1ZyBleGNlcHRpb25zIGZvciB0aGUgZ3Vlc3Qgd2hlbiB0aGV5IGFyZSBub3Qg4oCcdXNl
ZOKAnSBieSB1c2Vyc3BhY2UuDQoNCk9uIHg4NiwgdGhpcyBpcyBhIGZhaXJseSBzaW1wbGUgcHJv
Y2VzcyB0aGF0IHVzZXMgS1ZNX1NFVF9WQ1BVX0VWRU5UUy4gRG9lcyB0aGlzIHdvcmsgc2ltaWxh
cmx5IG9uIEFSTT8gSXMgdGhlcmUgc29tZSBzYW1wbGUgY29kZSBvciBkZXNjcmlwdGlvbiB3aGlj
aCBzdGVwcyBhcmUgbmVjZXNzYXJ5IGZvciB0aGF0IHJlLWluamVjdGlvbj8gUUVNVSB1c2VzIGl0
cyBnZW5lcmljIGludGVycnVwdCBtYWNoaW5lcnksIHdoaWNoIG1ha2VzIGl0IGhhcmQgdG8gZGV0
ZXJtaW5lIHdoYXQgYXJlIHRoZSBuZWNlc3Nhcnkgc3RlcHMgdG8gcmUtaW5qZWN0IHRoZSBleGNl
cHRpb24gaW50byB0aGUgZ3Vlc3QuDQoNClRoYW5rcyBmb3IgeW91ciBhc3Npc3RhbmNlIQ0KDQpT
dGVwaGFuDQotLQ0KUHJpbmNpcGFsIEFyY2hpdGVjdCwgU3lub3BzeXMgR21iSCwgRC01MjA3MiBB
YWNoZW4NClNpdHogZGVyIEdlc2VsbHNjaGFmdDogQXNjaGhlaW0sIExhbmRrcmVpcyBNw7xuY2hl
biDigJMgUmVjaHRzZm9ybTogR21iSCAtIEFtdHNnZXJpY2h0IE3DvG5jaGVuIEhSQiA5MDk0OSDi
gJMgVkFULyBVU3QtbGQgTnIuIERFMTI5NDcwMzcwDQpHZXNjaMOkZnRzZsO8aHJlcjogICBHcmVn
b3IgV2lldGhhbGVyLCBQcm9mLiBEci4gQW5kcmVhcyBIb2ZmbWFubiwgTHVpc2EgRGlvZ28sIE9y
bGEgQW5uZSBNdXJwaHkNCg0K

--_000_DM4PR12MB5264A1C31FE78B03A712EC0DB1889DM4PR12MB5264namp_
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: base64

PGh0bWwgeG1sbnM6dj0idXJuOnNjaGVtYXMtbWljcm9zb2Z0LWNvbTp2bWwiIHhtbG5zOm89InVy
bjpzY2hlbWFzLW1pY3Jvc29mdC1jb206b2ZmaWNlOm9mZmljZSIgeG1sbnM6dz0idXJuOnNjaGVt
YXMtbWljcm9zb2Z0LWNvbTpvZmZpY2U6d29yZCIgeG1sbnM6bT0iaHR0cDovL3NjaGVtYXMubWlj
cm9zb2Z0LmNvbS9vZmZpY2UvMjAwNC8xMi9vbW1sIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv
VFIvUkVDLWh0bWw0MCI+DQo8aGVhZD4NCjxtZXRhIGh0dHAtZXF1aXY9IkNvbnRlbnQtVHlwZSIg
Y29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PXV0Zi04Ij4NCjxtZXRhIG5hbWU9IkdlbmVyYXRv
ciIgY29udGVudD0iTWljcm9zb2Z0IFdvcmQgMTUgKGZpbHRlcmVkIG1lZGl1bSkiPg0KPHN0eWxl
PjwhLS0NCi8qIEZvbnQgRGVmaW5pdGlvbnMgKi8NCkBmb250LWZhY2UNCgl7Zm9udC1mYW1pbHk6
IkNhbWJyaWEgTWF0aCI7DQoJcGFub3NlLTE6MiA0IDUgMyA1IDQgNiAzIDIgNDt9DQpAZm9udC1m
YWNlDQoJe2ZvbnQtZmFtaWx5OkNhbGlicmk7DQoJcGFub3NlLTE6MiAxNSA1IDIgMiAyIDQgMyAy
IDQ7fQ0KLyogU3R5bGUgRGVmaW5pdGlvbnMgKi8NCnAuTXNvTm9ybWFsLCBsaS5Nc29Ob3JtYWws
IGRpdi5Nc29Ob3JtYWwNCgl7bWFyZ2luOjBjbTsNCglmb250LXNpemU6MTEuMHB0Ow0KCWZvbnQt
ZmFtaWx5OiJDYWxpYnJpIixzYW5zLXNlcmlmOw0KCW1zby1mYXJlYXN0LWxhbmd1YWdlOkVOLVVT
O30NCmE6bGluaywgc3Bhbi5Nc29IeXBlcmxpbmsNCgl7bXNvLXN0eWxlLXByaW9yaXR5Ojk5Ow0K
CWNvbG9yOiMwNTYzQzE7DQoJdGV4dC1kZWNvcmF0aW9uOnVuZGVybGluZTt9DQpzcGFuLkVtYWls
U3R5bGUxNw0KCXttc28tc3R5bGUtdHlwZTpwZXJzb25hbC1jb21wb3NlOw0KCWZvbnQtZmFtaWx5
OiJDYWxpYnJpIixzYW5zLXNlcmlmOw0KCWNvbG9yOndpbmRvd3RleHQ7fQ0KLk1zb0NocERlZmF1
bHQNCgl7bXNvLXN0eWxlLXR5cGU6ZXhwb3J0LW9ubHk7DQoJZm9udC1mYW1pbHk6IkNhbGlicmki
LHNhbnMtc2VyaWY7DQoJbXNvLWZhcmVhc3QtbGFuZ3VhZ2U6RU4tVVM7fQ0KQHBhZ2UgV29yZFNl
Y3Rpb24xDQoJe3NpemU6NjEyLjBwdCA3OTIuMHB0Ow0KCW1hcmdpbjo3Mi4wcHQgNzIuMHB0IDcy
LjBwdCA3Mi4wcHQ7fQ0KZGl2LldvcmRTZWN0aW9uMQ0KCXtwYWdlOldvcmRTZWN0aW9uMTt9DQot
LT48L3N0eWxlPjwhLS1baWYgZ3RlIG1zbyA5XT48eG1sPg0KPG86c2hhcGVkZWZhdWx0cyB2OmV4
dD0iZWRpdCIgc3BpZG1heD0iMTAyNiIgLz4NCjwveG1sPjwhW2VuZGlmXS0tPjwhLS1baWYgZ3Rl
IG1zbyA5XT48eG1sPg0KPG86c2hhcGVsYXlvdXQgdjpleHQ9ImVkaXQiPg0KPG86aWRtYXAgdjpl
eHQ9ImVkaXQiIGRhdGE9IjEiIC8+DQo8L286c2hhcGVsYXlvdXQ+PC94bWw+PCFbZW5kaWZdLS0+
DQo8L2hlYWQ+DQo8Ym9keSBsYW5nPSJlbi1ERSIgbGluaz0iIzA1NjNDMSIgdmxpbms9IiM5NTRG
NzIiIHN0eWxlPSJ3b3JkLXdyYXA6YnJlYWstd29yZCI+DQo8ZGl2IGNsYXNzPSJXb3JkU2VjdGlv
bjEiPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iRU4tVVMiPlRoZSBjb21tZW50
IGZvciBrdm1faGFuZGxlX2d1ZXN0X2RlYnVnICg8YSBocmVmPSJodHRwczovL2VsaXhpci5ib290
bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2FyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmMj
TDEwNyI+aHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9hcmNo
L2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jI0wxMDc8L2E+KQ0KIHN0YXRlcyB0aGF0IGl0IGlzIHVw
IHRvIHRoZSB1c2Vyc3BhY2UgdG8gcmUtaW5qZWN0IGRlYnVnIGV4Y2VwdGlvbnMgZm9yIHRoZSBn
dWVzdCB3aGVuIHRoZXkgYXJlIG5vdCDigJx1c2Vk4oCdIGJ5IHVzZXJzcGFjZS48bzpwPjwvbzpw
Pjwvc3Bhbj48L3A+DQo8cCBjbGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJFTi1VUyI+PG86
cD4mbmJzcDs8L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFu
Zz0iRU4tVVMiPk9uIHg4NiwgdGhpcyBpcyBhIGZhaXJseSBzaW1wbGUgcHJvY2VzcyB0aGF0IHVz
ZXMgS1ZNX1NFVF9WQ1BVX0VWRU5UUy4gRG9lcyB0aGlzIHdvcmsgc2ltaWxhcmx5IG9uIEFSTT8g
SXMgdGhlcmUgc29tZSBzYW1wbGUgY29kZSBvciBkZXNjcmlwdGlvbiB3aGljaCBzdGVwcyBhcmUg
bmVjZXNzYXJ5IGZvciB0aGF0IHJlLWluamVjdGlvbj8gUUVNVSB1c2VzIGl0cyBnZW5lcmljIGlu
dGVycnVwdA0KIG1hY2hpbmVyeSwgd2hpY2ggbWFrZXMgaXQgaGFyZCB0byBkZXRlcm1pbmUgd2hh
dCBhcmUgdGhlIG5lY2Vzc2FyeSBzdGVwcyB0byByZS1pbmplY3QgdGhlIGV4Y2VwdGlvbiBpbnRv
IHRoZSBndWVzdC48bzpwPjwvbzpwPjwvc3Bhbj48L3A+DQo8cCBjbGFzcz0iTXNvTm9ybWFsIj48
c3BhbiBsYW5nPSJFTi1VUyI+PG86cD4mbmJzcDs8L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9
Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iRU4tVVMiPlRoYW5rcyBmb3IgeW91ciBhc3Npc3RhbmNl
ITxvOnA+PC9vOnA+PC9zcGFuPjwvcD4NCjxwIGNsYXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9
IkVOLVVTIj48bzpwPiZuYnNwOzwvbzpwPjwvc3Bhbj48L3A+DQo8cCBjbGFzcz0iTXNvTm9ybWFs
Ij48c3BhbiBsYW5nPSJFTi1VUyI+U3RlcGhhbjwvc3Bhbj48bzpwPjwvbzpwPjwvcD4NCjxwIGNs
YXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIiBzdHlsZT0iZm9udC1zaXplOjEwLjBw
dDttc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+LS0NCjxvOnA+PC9vOnA+PC9zcGFuPjwvcD4N
CjxwIGNsYXNzPSJNc29Ob3JtYWwiPjxzcGFuIGxhbmc9IkVOLVVTIiBzdHlsZT0iZm9udC1zaXpl
OjEwLjBwdDttc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+UHJpbmNpcGFsIEFyY2hpdGVjdCwg
U3lub3BzeXMgR21iSCwgRC01MjA3MiBBYWNoZW48bzpwPjwvbzpwPjwvc3Bhbj48L3A+DQo8cCBj
bGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJERSIgc3R5bGU9ImZvbnQtc2l6ZTo4LjBwdDtt
c28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+U2l0eiBkZXIgR2VzZWxsc2NoYWZ0OiBBc2NoaGVp
bSwgTGFuZGtyZWlzIE3DvG5jaGVuIOKAkyBSZWNodHNmb3JtOiBHbWJIIC0gQW10c2dlcmljaHQg
TcO8bmNoZW4gSFJCIDkwOTQ5IOKAkyBWQVQvIFVTdC1sZCBOci4gREUxMjk0NzAzNzA8L3NwYW4+
PHNwYW4gbGFuZz0iREUiIHN0eWxlPSJtc28tZmFyZWFzdC1sYW5ndWFnZTojMjAwMCI+PG86cD48
L286cD48L3NwYW4+PC9wPg0KPHAgY2xhc3M9Ik1zb05vcm1hbCI+PHNwYW4gbGFuZz0iREUiIHN0
eWxlPSJmb250LXNpemU6OC4wcHQ7bXNvLWZhcmVhc3QtbGFuZ3VhZ2U6IzIwMDAiPkdlc2Now6Rm
dHNmw7xocmVyOiZuYnNwOyAmbmJzcDtHcmVnb3IgV2lldGhhbGVyLCBQcm9mLiBEci4gQW5kcmVh
cyBIb2ZmbWFubiwgTHVpc2EgRGlvZ28sIE9ybGEgQW5uZSBNdXJwaHk8bzpwPjwvbzpwPjwvc3Bh
bj48L3A+DQo8cCBjbGFzcz0iTXNvTm9ybWFsIj48c3BhbiBsYW5nPSJlbi1ERSI+PG86cD4mbmJz
cDs8L286cD48L3NwYW4+PC9wPg0KPC9kaXY+DQo8L2JvZHk+DQo8L2h0bWw+DQo=

--_000_DM4PR12MB5264A1C31FE78B03A712EC0DB1889DM4PR12MB5264namp_--

--===============1662711302543880247==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1662711302543880247==--
