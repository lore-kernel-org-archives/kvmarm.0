Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8113F39FE
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529633; cv=fail; b=rgcC2Hq5vyhUsAelq5HeGPgOun+rcYA2pLbSngu1f1cAL7mx9rSAi6TQT4nqgUdg/p8rLuDfGllZFtmvdlmbjXJmuyMMKzyeLhGy6aMwVRGEhHxVcrvRzrAgtgo+aKSMJ3jictbOqGqgvBV5rHhT9qPermTrUWYEJLxR5anOk1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529633; c=relaxed/simple;
	bh=XdHLKIjad6IabDbPsxaDspIvtmodh4uGxBpqtv35Jw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uciFbttN4tgrqDuVNfbK7DbzM42g4+RENa+crb4cT43LKvgiwen6KsJy9rBwJpSuH9NBvAGeC2DSy1ofVTcOLdOtFhdR8gXU4yaMRmhysYbZyGsk62Lx1C4YP5v3BAgV7dL9b39Nl0e4hICxy/F7CQxr/ZP7FsiviIKlsRT6eTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W2rc0Ss/; arc=fail smtp.client-ip=40.93.195.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W2rc0Ss/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYG0qQ5DBaj8tapTI/GupMu2mFoQT6VLR9qh/XCMe3lBTlGPXUL9iW8Kpp9FFM+hCBgmx6rJfcVPuZucIfvbnR4k2TQtvxxu2M5KaextaVxxHDdiiOlYZfOsyQ+h6qaD+JnRD8zx09/Uty0NH4SZf/yp0CUi/yxXYhizkMM9WfSXP2auk4PhMCz4jPN3ZVgmedMGxODXxkWsldmnsnfU4W85hbwaQwc8ZBzA53OquYHJtcMEwvGDw+epUeFOpqgXNj1X8Bdk3BfB1YraEwP5Uy5ER/MYmMpxfdRyCvYu2V4h7iwlWEV/cyvn8fhito4vHHiJUHN2nhyKkqv+M2lxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdHLKIjad6IabDbPsxaDspIvtmodh4uGxBpqtv35Jw8=;
 b=XaU/SBWnZ9MfY3fHJ0TJ/jemiFRuB6vanR+0OCuPrU2MTEm8B7fNHBrPWduPb3JJX/nZ9uh1ztpwTrv6KRDkWMg/S4qx0CdNWjlH6TBa55eud0/Yn1INjUjLBznYBwoqGSD2eO5fMxqB9NGJRmwzcFhZhomTszpLLZPo/Q6eOr1MLiITrGO6eBOJ0ZTr78rnMo+tx2RjRViLHaH9Q27LE0JDB7ussbyNwmqMa1+NRgH8iozvlOEVXZiPFGbUrANP7oiaQtOQycCYn4b2hDp7W0nus+E6lhQKkcRaNAGZDH5BmHOllI0UYpSZmzYuvU/8xi6/DjDPFCGO/fXblyhuhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdHLKIjad6IabDbPsxaDspIvtmodh4uGxBpqtv35Jw8=;
 b=W2rc0Ss/0T07j0bCMvhEPHXv88kP0/1trxscPUTVYyKAITJxVoaC1O/KF/NUwgmuXYBbxCM4EP045AC7ZpHU2tp5KgogcCF+6aSRrpktqpd95pp54G6H0EKFHRMsWShi34efdSlY+w77axo2Q7cMt00b3Mmohztge+c1cBm2alz9OcoO6e1/Dz3Beh+A8era0PX8WI4LoRtDwUHNh/IL8B7W1GIoIEBjLJa5DPRa5eU2+yaQT/4ujBfcYXoHjmcPWB4BD6dp8VOSr9x8PmMlJN1evjL/59H6oxCOEWlb8UFU1tKADsb6qaxwOdKQLXxYc1O3TTmZ0fVvNuoaQa3Elg==
Received: from SJ0PR12MB8614.namprd12.prod.outlook.com (2603:10b6:a03:47d::17)
 by PH8PR12MB7421.namprd12.prod.outlook.com (2603:10b6:510:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Mon, 15 Jun
 2026 13:20:24 +0000
Received: from SJ0PR12MB8614.namprd12.prod.outlook.com
 ([fe80::fe0a:6e6a:fe60:a43b]) by SJ0PR12MB8614.namprd12.prod.outlook.com
 ([fe80::fe0a:6e6a:fe60:a43b%3]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 13:20:22 +0000
From: Shameer Kolothum Thodi <skolothumtho@nvidia.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>,
	"yangjinqian1@huawei.com" <yangjinqian1@huawei.com>, "cohuck@redhat.com"
	<cohuck@redhat.com>, "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>, "sebott@redhat.com" <sebott@redhat.com>,
	"philmd@linaro.org" <philmd@linaro.org>
CC: "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"armbru@redhat.com" <armbru@redhat.com>, "berrange@redhat.com"
	<berrange@redhat.com>, "abologna@redhat.com" <abologna@redhat.com>,
	"jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: RE: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHc55OUFNuVI6hQDUOq6Vpq6dU4HrYp1UaggBDYeoCABRYMMA==
Date: Mon, 15 Jun 2026 13:20:22 +0000
Message-ID:
 <SJ0PR12MB86144469EE7E8DB47CD42961ABE62@SJ0PR12MB8614.namprd12.prod.outlook.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-5-eric.auger@redhat.com>
 <CH3PR12MB7548D1CA4348E04A14725645AB152@CH3PR12MB7548.namprd12.prod.outlook.com>
 <51ba045f-6ecf-4703-92c6-f362724c408e@redhat.com>
In-Reply-To: <51ba045f-6ecf-4703-92c6-f362724c408e@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR12MB8614:EE_|PH8PR12MB7421:EE_
x-ms-office365-filtering-correlation-id: 3344d306-2a1e-4c8c-7016-08decae0daf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|38070700021|22082099003|18002099003|4143699003|921020|6133799003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 hilFR9Acze/7uprDWdV6EpHtP0+L0R3lidG5kYxapOfsJNM/xiK9Jo43eOIxwoAXuE8JEhDr8d/WQjQUCGciTyJN/toNJNQ4xoy/MK1NEPiW/di9kR32IvNfF0uenMEEXzSgIznKABEd+9c/U+F1MUmnx2nem0XxBa4CHfBNMltJ0s/g9ATsg6KtKcois6uNc+5AWKfxyDeW1siIlluJNKpPf36cKPD6mFaNdqT5FdWVlcEQgDE3K8FeaFNYQadWEei1Q8OByEeC7AgL3h0nZpCBbrj2iw9RFAjUEXpugNP/JXwAdo1/tVJhKrDD/MAcuM06ECmNS+J/w52/S5ikQ8oE5lPFnrTmdOgPyalJsNR0Igzr0kgRobmRAJj8C9U2G9bnFOUpnCJlu4+kdCBCTb86oRVvXTNDWgAOWGHbmgp7+c1j5fe19/A1zA1FuNnSko9moeMfxUlT1fwSkmggrzAYjyY3Wqpla2ecFhHi5ACvv2bfolWQ0ycgKbMzFXpEo+f+gQNX4jVroriFy8+0yOoowu7ZNPq8K9aKLvnx1KZv/5rUzchOKwCx7SvxaH9puRhFheyLac3luCMCV+jw1UHZN/xQQoD6fVAmwUNl0Nk5KiShXchU5ZTQQVgzXeHC0BKKHyDZkn51jiIWG6xzLdXQ9fMdMs4o812Wa7qo/jQ5W9QcAznE7KEIcofn3cdCRmvMrspk5ZMONna+/yZtvtUo08Yk3WStdYAs9eXfS1SK0rKTaS3ziihWpb7DdTJMpvrTen4Kv70750vmMfcznw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB8614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(38070700021)(22082099003)(18002099003)(4143699003)(921020)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aFJKMEFDTXdoMFVyWGdKWFZLbmVDMFJvZUFKMVhVZ05yRUN5NG5tVVFCdlh4?=
 =?utf-8?B?a3M4aDJKb3JaRVhDQy9KTTNSSDNRUFlvdXpwOURIcU5ydmJtME0vTW1xSWJK?=
 =?utf-8?B?ZG52ME54aDZ5dGM2YnQxeGZtb093cmpsQnh4elNUVW05TCtkL3F2a0J5REdi?=
 =?utf-8?B?Mm5TOVM1N1dpdXBmbHNXbVlibWg5dGZDQTdHWW5iaHNWY0ZEelNHWS9Ba3JK?=
 =?utf-8?B?QUNHQ2huM3ZXcUZUUEVvTXo3NWkxR05ZRXl2RjFXeGdUdDlCSjBaTnpxcnk1?=
 =?utf-8?B?YVNZY1NKdG0xRFJwZjkrbXpTNVk0dkl1YlNIMmhWT1U5WXAvVlhaS1NMdHMz?=
 =?utf-8?B?c2kzdVRFNVQ5eW95SGt3K1cyL2tiUGJaNzYxT3FiQktXZXUxaXVZSmxUREpU?=
 =?utf-8?B?MlBFRmdkUHJiWTJCMVl6K3BQazlTLzI3TUNlZUdkU3JROTlyZlRDS1ZQWHlO?=
 =?utf-8?B?MXI1YmRvbGY1b1VKR3UyZzVwTUM2LzlaRGNSbWZad0laMXlYRGpBT1VlZzhE?=
 =?utf-8?B?OTNsa1dpczY4aXdYSWFXano3RUlNczcweWhLZnVWSDJRVDloV2ZXcnJPanI2?=
 =?utf-8?B?SkpBc3dONW5kVC96WEthVGpLREIrdkcrKzg5dE1pRWxIUkllOHRxNEdUK3kx?=
 =?utf-8?B?cjZOM1l5dU9wR25Fa215NGx2OWczQ2pTS3EvWW83MUM1eUdLYzhkUUZiYjk2?=
 =?utf-8?B?VlFSb1NDVmd1RSs4eFNWa3hSL0s1RGI4MU5rbEQzUi9xV0tlT0dXZWIraXNl?=
 =?utf-8?B?UXVhWlBHVzIzTnY0amlVTFJ6T1FmMHN3K3Z3K29ZRFk0ekR6a1p1aXA4cDFM?=
 =?utf-8?B?ZWVCWWE2TFRmVmZSSEV1Mlp0Mk5JeWt6THhGRjlhNnYzT2REWTNsRnBSZWZS?=
 =?utf-8?B?Yk0wVlBBaHVUZVBsNWdma0N1ZzNVMEhUNEpNSm1KVUpodDZkbTg3bjdhQ0tD?=
 =?utf-8?B?SVQvSm5JUHR3YVBvQXl2aE5RUDNNcnlBU0luYjBjeDdvZTJjWE1QZGJjcTVs?=
 =?utf-8?B?L2J5RkRUWldwZWlzSFd5UEtjTTdLNEdzZHZuaUlIQ3RCS1ppdUVJMkJrUmVz?=
 =?utf-8?B?c3BKakh1Ty85UkdNU3EvZEszQ0VreHpGL01Rell4Ti9hV2h2eStYdmNWenlZ?=
 =?utf-8?B?MEZmdGxIMStBYjBoSDE2aHdIQTVxeGdWVENnN2FkM3Zpd0cyUkkzT2NyeXY1?=
 =?utf-8?B?Q1lmd1F1QmlmR0hNMWFtUzZLWlJsQlJXbHA5WmdQSkI2aHRRa2xESHRFdXkx?=
 =?utf-8?B?UHo5R2lUbnNvN2VYbkhhWWREZER3UmZBVzdDL3lyclpmL0ZUZHp6ODFYbUxS?=
 =?utf-8?B?NE1ZZVJVaVpjdmk4dDdPK3FhNkVRSCtvV25takt0R2kra2NsNmRvdDhyYWZZ?=
 =?utf-8?B?Y2NJd2l6dm5KbGl2eVg3SWZlbDZ1MnFXTVJEMEdJSU0rcnMxZmNJZVpBd0hK?=
 =?utf-8?B?RUUxWXVmM3dISFh2OXA5Mm5tQm1zc2RaUlZ0QUJwWlF6TFZTYUJmdDhaL2Nk?=
 =?utf-8?B?Kzl6Uno5aUdZWWtQL1Q3MWVHYnZvQkR4SU5aRG4rdmYvYmdnYlBkQXlORGlt?=
 =?utf-8?B?Nll3MjcrUytvYkVkckc1VVBHbFpTdFhaWVNSdGNPTHNhYWhRMUtpVE5SZU1n?=
 =?utf-8?B?a1A5NVMxQzhBUCthaTgwZlpZWmJ3akxxWDlWSm9PQmVrbEt4WDFPVW9qRUZB?=
 =?utf-8?B?L253TUcwNmJEOVM1NkVaNnI3S0NCWGJDcEtjMWRGbm9GOE9pMEhscy9zVVlF?=
 =?utf-8?B?dU1HbldRWlhnTUlFRXRDQWoydHFQZU9ta25EaCs5VVlEOUhsL1gvTFZJVXNW?=
 =?utf-8?B?bzZVbDd4cUw3WmZTT3J4ZjNLUy9kSFFXNXo3MDFMbHJ0czB4UlJrMnI0K0R0?=
 =?utf-8?B?N0NoRzAvS0t0L0k0eW5PTGd4bWtlUVo1QlduK1c2dzZTVVRDTHZPV1k2TEt0?=
 =?utf-8?B?R3FGU1NqQWpPbG43R01OUHBGdVh5cjlrZFM3dUlzMkhFTkhQalRmY0RZaTFp?=
 =?utf-8?B?WVY3cTZHR3NiYjB6dm8xV0NSVmZBUk5wZEdEcVZvbWpwVlFScVlaYXpVVnlF?=
 =?utf-8?B?bEdtRmtZWS9CSnAxWTFjV3JHVGdWQ3hyeGZXTVAzSTR3bUZCUm41bjJEMHFv?=
 =?utf-8?B?Tmh6Y2M5YXFEdVFVUFZzME1XZWwrSjhyYzUvUjgwamFBTGUwVVUzbW1oM2xz?=
 =?utf-8?B?S1lNNDF0YUQ0OTl4alFKSmhsb0FCa0gybGN6NGRaTkFCZGNoUFlKRmU4VDBx?=
 =?utf-8?B?TXJ3RTA5WjI5Q21rNEpqUlBNTVI0cnlVRy9qQ0l1ZVZJS3RGOWFSQnJaL2NF?=
 =?utf-8?B?MTFoa0s1TGh2Mk9nMjdFOGtnOHQvakcyam1YRnRpbFphbEpsa1NnZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB8614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3344d306-2a1e-4c8c-7016-08decae0daf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2026 13:20:22.8122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQCD0zcl6sk7qxWCZSUYdKQRntxfPmLeNhYTfQjxNfNni9x1KKN2/9uNWsNBOZoWn3uN8p+2Yjhtz0uZ3tos0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7421

PiBPbiA2LzEvMjYgNDoyOCBQTSwgU2hhbWVlciBLb2xvdGh1bSBUaG9kaSB3cm90ZToNCj4gPiBI
aSBFcmljLA0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206
IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogMTkgTWF5IDIw
MjYgMTQ6MjcNCj4gPj4gVG86IGVyaWMuYXVnZXIucHJvQGdtYWlsLmNvbTsgZXJpYy5hdWdlckBy
ZWRoYXQuY29tOyBxZW11LQ0KPiA+PiBkZXZlbEBub25nbnUub3JnOyBxZW11LWFybUBub25nbnUu
b3JnOyBrdm1hcm1AbGlzdHMubGludXguZGV2Ow0KPiA+PiBwZXRlci5tYXlkZWxsQGxpbmFyby5v
cmc7IHNoYWp1LmFicmFoYW1AbnV0YW5peC5jb207DQo+ID4+IGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbTsgeWFuZ2ppbnFpYW4xQGh1YXdlaS5jb207DQo+ID4+IGNvaHVja0ByZWRoYXQuY29tOyBy
aWNoYXJkLmhlbmRlcnNvbkBsaW5hcm8ub3JnOyBzZWJvdHRAcmVkaGF0LmNvbTsNCj4gPj4gU2hh
bWVlciBLb2xvdGh1bSBUaG9kaSA8c2tvbG90aHVtdGhvQG52aWRpYS5jb20+Ow0KPiBwaGlsbWRA
bGluYXJvLm9yZw0KPiA+PiBDYzogbWF6QGtlcm5lbC5vcmc7IG9saXZlci51cHRvbkBsaW51eC5k
ZXY7IHBib256aW5pQHJlZGhhdC5jb207DQo+ID4+IGFybWJydUByZWRoYXQuY29tOyBiZXJyYW5n
ZUByZWRoYXQuY29tOyBhYm9sb2duYUByZWRoYXQuY29tOw0KPiA+PiBqZGVuZW1hckByZWRoYXQu
Y29tDQo+ID4+IFN1YmplY3Q6IFtQQVRDSCB2NSAwNC8xOF0gYXJtL2NwdTogQWRkIGluZnJhIHRv
IGhhbmRsZSBnZW5lcmF0ZWQgSUQNCj4gcmVnaXN0ZXINCj4gPj4gZGVmaW5pdGlvbnMNCj4gPj4N
Cj4gPj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNo
bWVudHMNCj4gPj4NCj4gPj4NCj4gPj4gVGhlIGtub3duIElEIHJlZ3MgYXJlIHBvcHVsYXRlZCBp
biBhIG5ldyBpbml0aWFsaXphdGlvbiBmdW5jdGlvbg0KPiA+PiBuYW1lZCBpbml0aWFsaXplX2Nw
dV9zeXNyZWdfcHJvcGVydGllcygpLiBUaGF0IGNvZGUgd2lsbCBiZQ0KPiA+PiBhdXRvbWF0aWNh
bGx5IGdlbmVyYXRlZCBmcm9tIEFBUkNITVJTIFJlZ2lzdGVycy5qc29uLiBGb3IgdGhlDQo+ID4+
IHRpbWUgYmVpbmcgbGV0J3MganVzdCBkZXNjcmliZSBhIHNpbmdsZSBpZCByZWcsIENUUl9FTDAu
IEluIHRoaXMNCj4gPj4gZGVzY3JpcHRpb24gd2Ugb25seSBjYXJlIGFib3V0IG5vbiBSRVMvUkFa
IGZpZWxkcywgaWUuIG5hbWVkIGZpZWxkcy4NCj4gPj4NCj4gPj4gVGhlIHJlZ2lzdGVycyBhcmUg
cG9wdWxhdGVkIGluIGFuIGFycmF5IGluZGV4ZWQgYnkgQVJNSURSZWdpc3RlcklkeA0KPiA+PiBh
bmQgdGhlaXIgZmllbGRzIGFyZSBhZGRlZCBpbiBhIHNvcnRlZCBsaXN0Lg0KPiA+Pg0KPiA+PiBT
aWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+ID4+IFNp
Z25lZC1vZmYtYnk6IENvcm5lbGlhIEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPg0KPiA+Pg0KPiA+
PiAtLS0NCj4gPj4NCj4gPj4gdjQgLT4gdjUNCj4gPj4gLSBpZmRlZiBUQVJHRVRfQVJNX0NQVV9J
RFJFR1NfSA0KPiA+PiAtIHMvZ19saXN0X2FwcGVuZC9nX2xpc3RfcHJlcGVuZA0KPiA+PiAtIHZv
aWQgYXJtNjRfc3lzcmVnX2FkZF9maWVsZCgpDQo+IA0KPiBFZmZlY3RpdmVseSB0aGUgd2hvbGUg
Y29tbWl0IGRlc2MgaXMgb3V0ZGF0ZWQgbm93IHRoYXQgSSBoYXZlIG1pZ3JhdGVkDQo+IHRvIEto
dXNoaXQgZGVzY3JpcHRpb24gb2YgaWRyZWdzIGFuZCB0aGVpciBmaWVsZHMuIE5vIG5lZWQgZm9y
IGxpc3Qgbm9yDQo+IA0KPiBhcm02NF9zeXNyZWdfYWRkX2ZpZWxkIGFueW1vcmUuDQo+IA0KPiBB
cnJheXMgYXJlIHBvcHVsYXRlZCBpbiBbUEFUQ0ggdjUgMDgvMThdIHRhcmdldC9hcm0vY3B1X2lk
cmVnczogZ2VuZXJhdGUNCj4gdGFibGVzIGZvciBBcm02NCBJRCByZWdpc3RlcnMgYW5kIGZpZWxk
cw0KPiBUaGlzIGlzIG11Y2ggbmljZXIuDQoNCkFoLi5Hb3QgaXQuDQoNClRoYW5rcywNClNoYW1l
ZXINCg==
