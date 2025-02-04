Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BD720C029
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738678646; cv=fail; b=nOX00X5gMMVM0Kk0gFWmNFUYCI7xC2+L5IMZy9uYn8UddpFbq4VDaMrC1DCejSK5aOyC751hvAZGdGgnejtKM3LACbmXYqn4aDAfuva7kzbLdHt3WprG5WDP8Nw6b2hXn6Z9D1sS1KQeJ0kEpcjzbXSaCG0OYyIBBxCAW9N/K3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738678646; c=relaxed/simple;
	bh=KiR+/dujEim+Rtjw+bSGShVm49g//j0W16kjEblXX1g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oX6zGNUaH+stPaa7yKLq2kmnMGWR4azai9flCY7iK1GnwPMgKigd7Gom7sF0ww40zaoNHiYPPds/qnhIfNJ7X5+WkbSEPptO6qXRI1ubFPsX3yOKjfzLgRqzHO4fn6isN0NbW8ZByJox2eWHc/Ce0nujzJ1RAOvYGshWa/Q394M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=BxN/WWyT; arc=fail smtp.client-ip=40.107.21.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="BxN/WWyT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bv4pZ0ik2ZqvPLkT1DnDJdEeBfH2n5gUEpw+x4oa76w6xXn9nPpFetDZxNwtmv5NyEXxJkBWHjqiI68S+iDEIPE6+E80HY9e1mms7lNcH+rlyLK0PcyR78VV6Z1TuRhnJwMb5sCpzafQFVbHO/JHaIHsUUdeUdRwzksu6jV8b9yV9K/FasEvO7bGNR/SmjPxXbpS9BJbt0OVwsobprDmNZhW/G0cmyaFnIgBG9/F5rcLWp1Dq7NIuso6hDpjhwWIarwApNPRTD70KtzJGzYfCZYr+YsUPzcq8MQdDo2BJKpGckgSWtKv8Klvv6dENn7j6yQ5y7scxRj6j/mi8AAQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiR+/dujEim+Rtjw+bSGShVm49g//j0W16kjEblXX1g=;
 b=Mra5LlreBYAnKQJrsPydgY7A4fujtlxQ4oyduHKSE64WB0RssdLDldnfHyaxWBPv64X1x99kBzcXr0BV7hQZ1mvHeUjN/sFX/DQmSlcREFyf2m7J4iI+3uM8HgDx9Vlf7Ey0HrSZ4ozlt6FoTm3+iZOMVPA/bXouEpsX5HdsjxsmsrPYf52wtDR3hdnX8B5kmC0K9obpX5qtXEEEXe3LMC4U/gCPcPE2yKG3pFowvOOBEox5+Qa0nnwzlkFM3OtgvXjwA7gyQHDpVeaOAGCKY6gcwYXqiN3Wi9DW+nz6HL+44M/I+Hs6FvxwVb5M4s4i6dm0ssUAydjJJ/PRk9RZBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiR+/dujEim+Rtjw+bSGShVm49g//j0W16kjEblXX1g=;
 b=BxN/WWyTyE8Ge7JZKLYVan1rsz6l6P/TKZ6JIhi/KzOJ6+/eZLNuqUswYqSruQ0aSnk7REuQ62Ee0MhV2WOTyJeboQVW2w2gVvCkgjavcvnw/ke1Lsv6TgCsg0BJt1qeNm8g2wnnryVtYdpCb2X19+ICkx4vkkVxd5XWSgnPLBsYHZFzbaM1TW83Lq0RzOhmX8h2SEs0+BBDh51W1QesgbgKzOvQYJnAwAxVDmGbpuc/v6op5E/ud0QDFK8Rmj8EZBsve9cnmNZ8K8e7rZzosW1RQjhj6FNQ4SC0AQDv1GtkurmQ0Scnb+q9+9DdsIU5ikoCnP7mWIoj7uOMlDyVVw==
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com (2603:10a6:20b:5a2::12)
 by DB9PR03MB7676.eurprd03.prod.outlook.com (2603:10a6:10:2c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Tue, 4 Feb
 2025 14:17:21 +0000
Received: from AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803]) by AS8PR03MB9438.eurprd03.prod.outlook.com
 ([fe80::f90f:b790:a00:6803%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 14:17:21 +0000
From: Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Volodymyr Babchuk
	<Volodymyr_Babchuk@epam.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: timer: Always evaluate the need for a
 soft timer
Thread-Topic: [PATCH v2 1/3] KVM: arm64: timer: Always evaluate the need for a
 soft timer
Thread-Index: AQHbdvQTCJvKJ7ueekSETaeAVLfpXrM3MRgA
Date: Tue, 4 Feb 2025 14:17:21 +0000
Message-ID: <5f4fad90-426b-43bd-97bb-0d5e46630a52@epam.com>
References: <20250204110050.150560-1-maz@kernel.org>
 <20250204110050.150560-2-maz@kernel.org>
In-Reply-To: <20250204110050.150560-2-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB9438:EE_|DB9PR03MB7676:EE_
x-ms-office365-filtering-correlation-id: 71eba734-3587-4566-7fd6-08dd4526a3a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cWdoZGpWaGNCZU5sOGtCa2tzS0VPMnoyZkRmbFZJRTVYMVJCVncwVWR1QW1q?=
 =?utf-8?B?bUJ0OVpVTWpBQUkxTkRjUUhVdm5Zd1NTa1MyVGZ3OFVoNW1XRm4wcEJpVCta?=
 =?utf-8?B?RmxiMlNWT1VZMjlscFQzVW5ERmczazRUSFp3N3ZFelVuM01aR1lrSHp1SWxr?=
 =?utf-8?B?Y0hpaTBVWjc3SzNNa1dCbStNU1A5THVnT1BWSitaZDdiOUJDVWFMZng2K2Jp?=
 =?utf-8?B?cTlHTzlkcHBpZGJQOEJ3MVg2RlJ5eXBoMXIwN3E0U2F3dzdqVkF2eTdJeUo2?=
 =?utf-8?B?dW9GRUxWdmxPMkIxOFFsNU8wVTVFaEJpZ0VodzFPVXh3bHN1L3FSeWl0eE85?=
 =?utf-8?B?WXdmeEUzZm8xQlFnK0VUNVBHTlFUbkFxd1ZINUUvWXo1NmxDWHdwTVg4UnR3?=
 =?utf-8?B?V1MxMlFSTzltVVdMNDduNWFsa1pDMmFzak1KZ2p5L2tZbXo5WG90ZTZjUzZD?=
 =?utf-8?B?Y1V0WU1rZTNKMDBaZWk0Z3dOR0FLUlhyRmpEb2tlRS94SjhTY0krWXp3VDhy?=
 =?utf-8?B?ajNWMjJEeWNxTjlUUTVsS0EvMnd1a0k2Wkhtbjg0bDBzWGQybFc1eDE5aTA5?=
 =?utf-8?B?UnYvN204em9YdnpsZnArL3NHb1o4dFdzRTZMczcwOWo5QUpPUUhlM0ZKV25L?=
 =?utf-8?B?dmdQcXloaVZhOSsvZENFbzFPQW5XSnFIeGE5SmdCWVV3MVk0RmI1Z3lob3VZ?=
 =?utf-8?B?a3F5OVBtVDVML3hod3JwekdXNFpRRi8rN0llemkza0RvNlBBemplQ0JZV2tQ?=
 =?utf-8?B?ZzV6WDF2MzNqVWxSVERqdm1KOUt0WWMzSXI1YXQ3VWdnd0lMZGhmcmY4dU5K?=
 =?utf-8?B?OTR5SXZGVGlxZlFFZnhTdFlHdHBwSW1kR09hK1FXdytGemZVeCtZak9JUTBH?=
 =?utf-8?B?SEl4TDY3N2dzOGNFWGV2TmhyeDFBMlZIKzhxM3ZEZ0kydjVkQ3M3T1lDSnlW?=
 =?utf-8?B?RnQvajVHSkkzckFQNEI2Wld5OGRYSWU1YXV2bXhhMko1TTFFUUszUjdoRTlo?=
 =?utf-8?B?MjFxVDgydVE0aWs5N0d6OEtJczZDM1NuWFhqNDBnYmNqeXVudmdOdW15VHZy?=
 =?utf-8?B?MGVZV3JidGxGKzdYbFh5WmpoOHIwTjJuS1lweDcxaXNTNWtyZGRqOXNCUmVM?=
 =?utf-8?B?QmJ1S2xpTmUyTzFXem82UWk4UHhYb3NlcDE0Zlp6ZkhuRjI3WVB4cDM0STVD?=
 =?utf-8?B?VTIzZlNBNkNMQlp2WHRNbWFUQnUwOXdnZnZFVWJ6UEh6aEdPeHhkR0RIVFJr?=
 =?utf-8?B?NDdZZGhaWG4zaGoyaDNvVlBNL0xHaUlvUFJWUDlUVjROaWpzTElYNGVHZ0tM?=
 =?utf-8?B?TGdGRU1wRU1uMHh4c3N0NlNEeE8yMHRMQlhsYUdTYVJZQjI4cDBQM0ZKZ1RY?=
 =?utf-8?B?dkZSMnQ1U3pFUGRUTHQ5NFZSRDJ0b2VNWFpxUzI4SGdVNEswZXFhM2oveVh2?=
 =?utf-8?B?TGhvaHg1VmZVV1VQT1BpdTlGb0xQUVk0bWdGWEdVaVlIQ2R6QTFoVTBoTFZY?=
 =?utf-8?B?a2lEWXF2NHRSUENxM1YrbmtCVThmalQzMFZ0OVQ3eExGdUkyZ1RyclgzeHYr?=
 =?utf-8?B?ZDhWQndoRDBVbDlFakRNSC9URkZJN1Q0RlIvdlQzWXlReTFKVW42dWRVdUFU?=
 =?utf-8?B?TnQ1RGtqazBOYzkwc3I0SlZyU0w4UnJqTkgveTJ6c01wcjh3ZHZRTURsUVVw?=
 =?utf-8?B?U3JMOFZIRjRSdVFzbExzRVVLNWRkSE9CUTA4Ym5IbUVSWE45M0pWaS9TQURO?=
 =?utf-8?B?ZlZZRUFxallnbWdpS2IwdzQ0ZnRLaVk2dzE3bmJ1OWZUSnpMK2dVeDdZQzQ1?=
 =?utf-8?B?bThGN3V5M2tDRGJIT0hVNkVLWTJuZkVkK29WaW10S0V2MHJLdVdOcWMwUlFU?=
 =?utf-8?B?RTA0SjVCSzFETHNwbENEUXRLdjNyOGVQSlhhWkFEekVSNnMwVG81ZHBhQVE4?=
 =?utf-8?Q?iglXQeeUUbGz/oAf65X6fGMpTAOiYNsV?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB9438.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUNJSVZRbHdjbnJ0SHVmOHhka2c4MDlPRDFrOXZXNjVVOVlmblRabjhwV1Fl?=
 =?utf-8?B?UXQ0S21hREQ5dVlJdml0d0xIMTZpaDdrNjlLUEJwR0svZmJXQi9mWXBIZWcy?=
 =?utf-8?B?RzI1WEhyY2h0ZlkrekJJKzcxSitLKzdYSDVHaHpSTitPckJyNktIc0dZQkZF?=
 =?utf-8?B?S000STFYdWdoMGVhRVF0OXNWUWVNcVJiQStLRjRoeUZCSk5NdktMMjU4Um1W?=
 =?utf-8?B?K1FmM2RqQXg4dDYwTnBGYU1TRWV0eSs4QmYvajlrc3BYOXlwUXI1c1BVRWlH?=
 =?utf-8?B?ZnFTQ0pHYnczZUFuQmhvanB5ZE9wNmlNdEorZFNtTU50VE5jcEt1NG5vUlhD?=
 =?utf-8?B?WDdDakJPY1hNSUtBNmRycDJDZWJYbDQ3dU9MUlEzYnJwSDdlb09LV3VwOFda?=
 =?utf-8?B?bGxRb3JjSkpjUTRiVGlURVd4MjJMNEVlaUozVkNQdWpFdXRSN3prd1IwYTRM?=
 =?utf-8?B?WjBxZmxLVFpQcDJiZ1VEcGk1dVRzbEhtaHRaK1JjbzZ0WnV6OVAzWGtQNHF5?=
 =?utf-8?B?RXJ6V1Zub05hSHh4MVJoT09tQlNXclNmZHQ3dkNQU1VuazlXeWJFeXRJRDFz?=
 =?utf-8?B?V25BdlBJMXQ3aTRvNSszNklDQlpSS0VPVmYvRmtuK0hvNk0rZnFKTFcvM2FM?=
 =?utf-8?B?QnA5bmhCUmd3SVNWWEFXM1R0a2xjNlhqRk5vU2dNZlVoa21FWU1HMytUbEpR?=
 =?utf-8?B?b3hvY1dEczNGaXlnWUR3NURlU3FUWlgyWlJObElDNTJZRjRSUzZkNy9VeVpa?=
 =?utf-8?B?dU9FRFFTRk03eVhuU2d3dkdia3FOQmJhdzdiV0xqTy8rMGFoYW1CaEx4eXNF?=
 =?utf-8?B?VkR6ZTFmNzdYaHoyZ015aUR2Q2c5NXduRWhUNVVMaC9jSmttNE9WNkFnZ1Bq?=
 =?utf-8?B?ajBFSmtJVUdJcHZNdHJ5R2F5V2xkRzNYTW9VSmdkend0MGdLUm1tR3RTeFF4?=
 =?utf-8?B?QlFqNFpUUktuU2p4NEl6UTR0cTI3ZU9WdG9XVW9wTDdoSTlqd1l3WFhxM0VE?=
 =?utf-8?B?WmgzaWxqcVVJK0pIL1pxNzhJbG9zVVlLRFBhNHlIYlRGK3h5OS9nMTlmdmpF?=
 =?utf-8?B?d3loSGpQMEtIV0RUSmZxb2doZDdNWlFmTGMvbzlHamhXZVcreFdTdjBQMnlP?=
 =?utf-8?B?RWFKZDEwTFA1YU9LdE44T1BUellyOExyaVYxRWppcG9WN0QzbEZKM3kyUmFj?=
 =?utf-8?B?VlJOUEw5V1dBWVlkSmZGaVFXZVBBVmE0bDR6NkVJM2dEeS9JVm5WR3RnZFRw?=
 =?utf-8?B?L1k3T0tGTXpHcHpwcGdJaEd1d2JxRk5ZS1BJWUJZdk5VZVptM000OWlPKy9J?=
 =?utf-8?B?NGFXOVYrencza3BOeHF5K2JQUTJTZVc4dDdsWnNCVzBBZFBYQ0I4RlNxdlA5?=
 =?utf-8?B?NHl2WkhydTcrRUtoOVltSm1KM3BJS1l3cU5zcFoxMGJaWGdmYS9ra1phWEsw?=
 =?utf-8?B?NVhZckpGVG5QNVV3Z1BaME9DNEFsWThkdkY0Rzc3aTdFckFMMFJMSmZtYy9L?=
 =?utf-8?B?SUwzb0VSNkRrcm13Zm00TFVsM2hDcGk2YnI4WnZDaEJqMXNXOFJtNHBGcHN0?=
 =?utf-8?B?Ry9BK2ZLNDBYTFhoSlV2Wk02bXBYbjlWZjBjSGZGekV4WVYxb1Q1b0xlR0pS?=
 =?utf-8?B?S0VIOHZiSm5HVG0vaU1jUkVMMi9OcjdmSE9XQUVCOHFVcm9SZGorTFROWXZr?=
 =?utf-8?B?aXRSTTRZU0NNVUZnakpiL0pnYmZ1SllxdVFydEtPT1VTZTVNNFg5WGlVT3Ri?=
 =?utf-8?B?VlE4eW5IbVFldEk0cFl0dmhTSThsNG02T0MzNjFlbldVNDJKcjlvcHBwN01i?=
 =?utf-8?B?ZTR6Z2JsVFFFRFNCTGE0UU50TTRzN0w1bS9nTDRSQ0xBa3gzbmFScXl0TE01?=
 =?utf-8?B?UFJRdkExOGhnc2tPQk5pRjUrVjJvdXVOTE1TTkhJakJMejBrRVJZc3ZwakRJ?=
 =?utf-8?B?YUN4RHFCdVpzWlZZZTVhWGxlNi8rN3I1RjZtVTN1SnlqNmFQVS82N1VFNFBu?=
 =?utf-8?B?azcvWDhyeTFhL0IwelNLd2RJejJXcjEybzhMS2hCeGpFQVFVc0FCeUp1Qk8z?=
 =?utf-8?B?WnNlM0srUVlvaVBiUWNaeHRpVTd5UjB3L3NGQ1BzQmhUdjE0T0ZValMrNFg1?=
 =?utf-8?B?eEc1N0RNVGV3NEk1SXA2Y2VXY0tPV1Q3Z3A4cmRXVVlrYnFuNm5TNGQ5d2NS?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43F6077484D1A44283AE31B71EF82FF7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB9438.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71eba734-3587-4566-7fd6-08dd4526a3a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2025 14:17:21.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: faCPBXnu9aEly0kqkfsaAGmFSkCu/rdPi6q/p99we8ZwSTJ95FyecByP5EiUObzDNmqGZwiZmTYAMRSGVC+e86gFmpRonPTX135eCMrSWx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7676

SGVsbG8sIE1hcmMuDQoNCk9uIDIvNC8yNSAxMzowMCwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPiBX
aGVuIHVwZGF0aW5nIHRoZSBpbnRlcnJ1cHQgc3RhdGUgZm9yIGFuIGVtdWxhdGVkIHRpbWVyLCB3
ZSByZXR1cm4NCj4gZWFybHkgYW5kIHNraXAgdGhlIHNldHVwIG9mIGEgc29mdCB0aW1lciB0aGF0
IHJ1bnMgaW4gcGFyYWxsZWwNCj4gd2l0aCB0aGUgZ3Vlc3QuDQo+DQo+IFdoaWxlIHRoaXMgaXMg
T0sgaWYgd2UgaGF2ZSBzZXQgdGhlIGludGVycnVwdCBwZW5kaW5nLCBpdCBpcyBwcmV0dHkNCj4g
d3JvbmcgaWYgdGhlIGd1ZXN0IG1vdmVkIENWQUwgaW50byB0aGUgZnV0dXJlLiAgSW4gdGhhdCBj
YXNlLA0KPiBubyB0aW1lciBpcyBhcm1lZCBhbmQgdGhlIGd1ZXN0IGNhbiB3YWl0IGZvciBhIHZl
cnkgbG9uZyB0aW1lDQo+IChpdCB3aWxsIHRha2UgYSBmdWxsIHB1dC9sb2FkIGN5Y2xlIGZvciB0
aGUgc2l0dWF0aW9uIHRvIHJlc29sdmUpLg0KPg0KPiBUaGlzIGlzIHNwZWNpYWxseSB2aXNpYmxl
IHdpdGggRURLMiBydW5uaW5nIGF0IEVMMiwgYnV0IHN0aWxsDQo+IHVzaW5nIHRoZSBFTDEgdmly
dHVhbCB0aW1lciwgd2hpY2ggaW4gdGhhdCBjYXNlIGlzIGZ1bGx5IGVtdWxhdGVkLg0KPiBBbnkg
a2V5LXByZXNzIHRha2VzIGFnZXMgdG8gYmUgY2FwdHVyZWQsIGFzIHRoZXJlIGlzIG5vIFVBUlQN
Cj4gaW50ZXJydXB0IGFuZCBFREsyIHJlbGllcyBvbiBwb2xsaW5nIGZyb20gYSB0aW1lci4uLg0K
Pg0KPiBUaGUgZml4IGlzIHNpbXBseSB0byBkcm9wIHRoZSBlYXJseSByZXR1cm4uIElmIHRoZSB0
aW1lciBpbnRlcnJ1cHQNCj4gaXMgcGVuZGluZywgd2Ugd2lsbCBzdGlsbCByZXR1cm4gZWFybHks
IGFuZCBvdGhlcndpc2UgYXJtIHRoZSBzb2Z0DQo+IHRpbWVyLg0KPg0KPiBGaXhlczogNGQ3NGVj
ZmE2NDU4YiAoIktWTTogYXJtNjQ6IERvbid0IGFybSBhIGhydGltZXIgZm9yIGFuIGFscmVhZHkg
cGVuZGluZyB0aW1lciIpDQo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5l
bC5vcmc+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQoNCg0KVGVzdGVkLWJ5OiBEbXl0
cm8gVGVybGV0c2t5aSA8ZG15dHJvX3RlcmxldHNreWlAZXBhbS5jb20+DQoNCg0KPiAtLS0NCj4g
ICBhcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMgfCA0ICstLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS9hcmNoX3RpbWVyLmMgYi9hcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4g
aW5kZXggZDNkMjQzMzY2NTM2Yy4uMDM1ZTQzZjVkNGY5YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9h
cm02NC9rdm0vYXJjaF90aW1lci5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIu
Yw0KPiBAQCAtNDcxLDEwICs0NzEsOCBAQCBzdGF0aWMgdm9pZCB0aW1lcl9lbXVsYXRlKHN0cnVj
dCBhcmNoX3RpbWVyX2NvbnRleHQgKmN0eCkNCj4gICANCj4gICAJdHJhY2Vfa3ZtX3RpbWVyX2Vt
dWxhdGUoY3R4LCBzaG91bGRfZmlyZSk7DQo+ICAgDQo+IC0JaWYgKHNob3VsZF9maXJlICE9IGN0
eC0+aXJxLmxldmVsKSB7DQo+ICsJaWYgKHNob3VsZF9maXJlICE9IGN0eC0+aXJxLmxldmVsKQ0K
PiAgIAkJa3ZtX3RpbWVyX3VwZGF0ZV9pcnEoY3R4LT52Y3B1LCBzaG91bGRfZmlyZSwgY3R4KTsN
Cj4gLQkJcmV0dXJuOw0KPiAtCX0NCj4gICANCj4gICAJa3ZtX3RpbWVyX3VwZGF0ZV9zdGF0dXMo
Y3R4LCBzaG91bGRfZmlyZSk7DQo+ICAg
