Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011064.outbound.protection.outlook.com [40.107.130.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1976F404BC1;
	Thu,  9 Jul 2026 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591005; cv=fail; b=rtn35HKtAsbOJ4pHQVDhMSasWFfWHAZnIE28XycOOE2iqr9yxznLgPRK+5LeSS156meeCtWOGgFxLfX7SofgBeq0cq7Dcz2R4X1wl4EpasIfRGrAj+TdzDw+KQIziDcEh0MAhYcQW5x8s4Dp95BokOAMjacnC77UHxeGiEniJhc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591005; c=relaxed/simple;
	bh=7DY+3dIQdQspEDZuuIGDcN9jPpYMEt5yb+sy0L9hlU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZW10sOQOMXYri37Vr8mZSDrKs4X+QwMasTo9+uJJ7Wv8Wxbsgo/BoF6UEAlBkYuvXNIRXhLUvpgWO7xpwVVAlmshtVe581JsKZ8SxfcSYRPbKWYwS4r9ML/TA00kh3oLeUgEXq7aC6CuKHpC6TmlSWcj55vsedvw0wEIZ0tv27c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k4H6ZPMV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k4H6ZPMV; arc=fail smtp.client-ip=40.107.130.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k4H6ZPMV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k4H6ZPMV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hNt+50nNSfse410PYizYirMvaw7gfYxnmOrzkKnrv49wIqqzEHv/uKvK57xFor+jXCpWR2Bh5TehAeWike7Wy2HMB66saAEE01FiYP2IEhMDKeKD8TV2bmk0M8G2Omzm6qhBhzqysXKJQX/8VN18ptt7z/cRtMi4aUQ5OSI8ILp7g0owbDxu1l2K0Qi8jzfigHUt5ro7QHiXozaoUtz2mIkkJRRWB4YTy9oH8Wly5qtzWTGcABcJ9203ezen0k85ogol2Cw6KisY/xNew5xSctPpwIIYiORTLMA2x4kYYSCh8gDRbujiqSj2xElc1PKN4P6bLdfCJl5+9RG6l6az8Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DY+3dIQdQspEDZuuIGDcN9jPpYMEt5yb+sy0L9hlU8=;
 b=Ub925B+6syukiyvph0rd2MVmPMrCfa23A/mvBMhNJP25EElI1NqXoZ7dbrzcl+PoJ8gdU9OxnP6D/Nvk/thAI2Gs5OYjq5eOob1LhhBWfZRlcOXG5Izi3JZIAcNI4YEF76cJRk4MOZh6MFlVgiMDLMCAsAfHJQHCSahMNLYDvDya0TPijx5Dyv/4RBe9dLfyxXUlJu7FWS4Xnpl5viCRamvV2biqNm+Q7wHBHAtBlpzbIuBoa+mFnLO4dpE4QXoshjSdhUn4H7s7dhWFO5U918qeytTW6KpHwF6O5NtBa9tUl05YJ6UypAAz8pmu2HQ5IOss27rIRumgNUIl2eYKUw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DY+3dIQdQspEDZuuIGDcN9jPpYMEt5yb+sy0L9hlU8=;
 b=k4H6ZPMVoDYvZU846tYlDR/a931jeqD4Rt8/uAT6NRbI3ZUeIdyHwtnD9mYK3ioLib4rj97+mONG7z2nCWvrj7oXw4hSchsjhcECaFn9NwNHVANgWjs8kC16iHQWtLRDXckzxIlvFMCYsPR9q4kuzzIDTHvs6RAVNkXtV/r+/1E=
Received: from DU6P191CA0067.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::9) by
 DU0PR08MB8929.eurprd08.prod.outlook.com (2603:10a6:10:464::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.8; Thu, 9 Jul 2026 09:56:37 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::c) by DU6P191CA0067.outlook.office365.com
 (2603:10a6:10:53e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.11 via Frontend Transport; Thu, 9
 Jul 2026 09:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Thu, 9 Jul 2026 09:56:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnD+JtTVB5ageR63me9T4yBs+jiKrNOvfpn+O1hmDR0xLKkTfGps8wBFrCO957PokjiQCAK8sKeQ9GVTr+/o5NVvJxn2Kq9OBAHXWnd14CH5Xgv4G8RMJv7LlxnseOOUdVoc8EMEb/TnfZE5I4QF2rZC9Fldr5A9aAVI6bYrtGGd5zTrZaFaO+aeLs2yqCuSYNB0JJIGPFJw3xCRZ0gWx2+iMGvJVX//2v5zXB0K3WuR3fUsMnaU5SvV/Nr5LD2RLiWjTqZhVkNibjXfBhh4PyJxSG6P1T+I/lC2NLb6Rtx1rzAijiF9hKaziQLhaM5vPb5zCPzQb2Bw4Q57g96+Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DY+3dIQdQspEDZuuIGDcN9jPpYMEt5yb+sy0L9hlU8=;
 b=S9Ys8X1Qgpg6d151BmpWh5EITvFyBlx/b8vUXWEDQLjJDqilPKzai0f119nVk05QtmjTMns46HEVD7V/Pwe1NJeZb4ILyp+WKg3jdhec/PoXp9YEnPkNI196MpTMrBtt4wZ+vlLO5lBBJ+BfuU7etcpvyt7uvi2+js/pqVeOpamjWtrKJqjy71eZ8Yg0JmdIrrgmOeGeqPUGrAQXw51ZlKq736VdJ40FCI9i5V7pk+mBSYBY20+P3GmMwfS8YDkePG79RRU2XSDqyetxQS9O+nfw+VZmoSO58WmgRffz0dr5bA0rqvuxAV7U/lLN5xc27SC8tSdSOjjjSksUTrZamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DY+3dIQdQspEDZuuIGDcN9jPpYMEt5yb+sy0L9hlU8=;
 b=k4H6ZPMVoDYvZU846tYlDR/a931jeqD4Rt8/uAT6NRbI3ZUeIdyHwtnD9mYK3ioLib4rj97+mONG7z2nCWvrj7oXw4hSchsjhcECaFn9NwNHVANgWjs8kC16iHQWtLRDXckzxIlvFMCYsPR9q4kuzzIDTHvs6RAVNkXtV/r+/1E=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10801.eurprd08.prod.outlook.com (2603:10a6:10:526::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 09:55:34 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Thu, 9 Jul 2026
 09:55:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 22/40] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v3 22/40] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHdCwU+3k/D9dKICkOOIQY/JbSQB7ZcAUoAgAj61YA=
Date: Thu, 9 Jul 2026 09:55:34 +0000
Message-ID: <679ac4f828fb6f3097f98ca8b92c7d61d843915b.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-23-sascha.bischoff@arm.com>
	 <20260703164743.3840F1F000E9@smtp.kernel.org>
In-Reply-To: <20260703164743.3840F1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10801:EE_|DB1PEPF000509FD:EE_|DU0PR08MB8929:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b2c610-fbf5-4a59-5e44-08dedda05dde
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|38070700021|4143699003|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 aAFfuBKvLziookMoaYaiWpK5zUbtKv3CFBEuIGpvKHZXEf0s6PNIxtcUMnaXf19ryOKanhNQmF1b206+kjSd3P/urPqsN+OibHae/ZEUpmdVIaRhOf+m8uo86Q3xflelFjrel+CJ3H/NubqVwUympXb9V/lzLwX3eqHLHjSjNTEZ3ubYQm2ldZzm23AF+W6GB6ZzFgQeJtQiRyjKV1I/opYTEcopsGkovTVoxz2nbGi2ovyfCgvjxk0BfzVh6q4dsPe4Svznb4jnVi8qloEJA7b0IFO3Ma3O3DRWchr/eLSB3Viy/UQYLOJo8hVWjXz9IBEQZ3Gafio9kIFZgEig96cpXhiB8djARZiXRJxklMTRkdH3mI51CPxRdLuMdW3UQsXmTpFYo0qggkNEui4L+mqFMBeZmkKdc2dJYjqs0VOYalbGAm6WoIs+v2yBn3G8Do2U9rBCB16tnIFs8nRAMk5diEhOZixrMskVnQImXtdWJ6s46lv1C6mWBA+c/Ztzsm17+Y3ddy6a/X0YVY5HRMbeqGMdF69e0xspXnR7c2f0LmzpS/dNVPYdnzWgo8hssgkh0V+LrrJiA6tsxy2c6Njh6GHyNVQIlxzeHUtiBN2uVoqigFH5CFUtMLXERf67y8wdbtyeqejFUp7+BK/la1vshc1jhxXFTsJciLl3V8VN9Pi9w9rW+EKQb6mZdWoIbI20+mH4CyEg7d4r2vAecIfuE7mwWZJmujXEqzUjxNQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(38070700021)(4143699003)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACB9B05D9053C2458B3A62BAB36E0C0B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 PypOnC5eELD9hr9t5eo9LgGofvY5yfjvRglI2DNz0vtAXjuCqjF3qHhusFkOUZgV61lCQhXJ6H5locvkLPfvSSKIrmQCHOLL2tYW+DBskXMO+dysFHKD0mr0z3xfzRwpKhII9S9UxlB6688vro/0wT5q79xgPnT7UZrV62LDa444enLo/r/4XXAkiuRSP/l6SV+RxatB8PoR+vX8WWuTsofnrsoUYR+ISnxlQkcG3AAdApFY7u/X9KUnI8EP9KobqQR4+v0ZzqrTDoWU6rMttIvbdFy69nQKpOfiSaxZd00pBsJViFlOrh6nCOOdeZ+Wm2vLQwClNmT3WDU38SS5+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10801
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	66a6f703-96e5-45af-ab48-08dedda0385b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|1800799024|23010399003|35042699022|82310400026|36860700016|18002099003|22082099003|11063799006|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vq5+NYUf/LXLNZI7lmPwlsarHJOGDPvluKRfxvxlUrsSl5KaheFb2PubKxWevDXnWP9nZZoQWJLVCPlwcLMLV6UWjsKx2zGy4073NIVtc126ySBzXRkal2823QWFpaEhYM9WQQFtHISIm6j+uzAE4om1tJPlZEz1EIcwFkct0zXeufHeZ7DL0ju7p8AmPROJFLrvgUUUnZeTbfvk1GOHm1Ll31lpaP+FTE5+7WQRXiPHnFGhV7QG4P6J4gbLIURCgmmLOTIvQIE4vwN85hbFQBdeCMaQ0a8ys+/IpphCOg34iNYO2Z3UryR/7t4q0aNvtO5GAYlKG3zCyL0eCFx1aauaI4a+bcK5E2PeHrECxdQ8E+oKvNiZQV0aS8x9EURaz8ukF+l0DPV1pR7yw0YiwKb9pXlhLb1HY8+ALfNwJO8zmOhRmj9vGGMdag8/u7QE51Gydep5lfaWedXRUXnlCHVHkoXbxFXwtYDu7r+ZAPPRBh7Cs1rXuy4wSUcyUcKXObUhsSKcDzxs912nKVjWagZxy5+UTr1YrB4m4s6BjjjIGsNs2o7bS7oPvY4ipkQMJtLQOsU2GZE86RvX8vvFfEHYSq+U3d6xU9UbGhxqDovW6h5cVtrZ3OMcMELU6vNAp0RsqElCHpKQEoDhFFhHfH5+T6AH2R0PWTt3cVGKef90D9gcnzLwB2mc1gK9xAtXoKZOXWojkn9YJ4nb9qJ13g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(1800799024)(23010399003)(35042699022)(82310400026)(36860700016)(18002099003)(22082099003)(11063799006)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZVpVeO/ZLNb9rpl4/42ZeFKGvDUlq4/lDKYAfztlT0XuiYtFrpw/2W5cSdECVrcE9UI//CNGmX67u72wBVb5SracrMrvXRU+OgvLulsjp/dFlmPfpQT/FKZ1i/xIQHqJbXDBDBDfcbLoY83oifkysgcAnEaJkyqMH82xblV1XzzTa/NHuzGA4NekFvD5RasOmJZm2TkW3vv8CeiVMztjcX1+XTot2JYk9UHjPuYyckFDRwiP0QROI1SEzrH8VZzTd4xwz1+IEP6pHaqzyq8F7/Y2fltIclsrcFKP4CVWGWfAXtbmWkQwtZcQimNKvCVqYrmzca6pyZPmsyyIZ4sulqI37BDC1BjUm2jWDvdP2/a/Y0DuszmE6mm2a0SBk/HybyMNANZf2tPaHGocUsYMRIdtPnxZV+YTWpGkoZg9PcVLEdGXoAnZDBw14Xit3OYu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 09:56:37.1420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b2c610-fbf5-4a59-5e44-08dedda05dde
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8929

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjQ3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVW5ib3VuZGVkIHVzZXItY29udHJvbGxlZCB2YWx1ZSBmb3IgR0lDdjUgYG5yX3NwaXNgIGFs
bG93cw0KPiB1cCB0byB+MzMuNSBtaWxsaW9uIFNQSXMsIGxlYWRpbmcgdG8gbWFzc2l2ZSBga2Nh
bGxvY2AvYGt6YWxsb2NgDQo+IGNhbGxzIGFuZCB0cmlnZ2VyaW5nIHBhZ2UgYWxsb2NhdG9yIHdh
cm5pbmdzIChgV0FSTl9PTl9PTkNFYCkuDQo+IC0tDQo+IA0KPiBjb21taXQgYWQ2NmMwYzcyNDY0
NDNmODczMzVjNWQxMDdiOWZjNzMzY2E3MmM2Yg0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBnaWMtdjU6IFJlZ2lz
dGVyIHRoZSBJUlMgSU9ERVYNCj4gDQo+IFRoaXMgcGF0Y2ggcmVnaXN0ZXJzIHRoZSBHSUN2NSBJ
UlMgSU9ERVYgYXMgcGFydCBvZg0KPiB2Z2ljX21hcF9yZXNvdXJjZXMuIEl0DQo+IGFsc28gYWxs
b3dzIHVzZXJzcGFjZSB0byBjb25maWd1cmUgdGhlIGFkZHJlc3Mgb2YgdGhlIGVtdWxhdGVkIElS
Uw0KPiBhbmQgc2V0DQo+IHRoZSBudW1iZXIgb2YgU1BJcyBoYW5kbGVkIGJ5IHRoZSBHSUN2NSBp
bXBsZW1lbnRhdGlvbi4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy1rdm0tZGV2aWNlLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2
aWNlLmMNCj4gPiBpbmRleCA5MGJlOTk0NDNkZjNiLi4yYmYxOTMwOTAyYjhlIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmMNCj4gPiArKysgYi9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMta3ZtLWRldmljZS5jDQo+IFsgLi4uIF0NCj4gPiBAQCAt
MjI0LDMxICsyMzIsNDggQEAgc3RhdGljIGludCB2Z2ljX3NldF9jb21tb25fYXR0cihzdHJ1Y3QN
Cj4gPiBrdm1fZGV2aWNlICpkZXYsDQo+IFsgLi4uIF0NCj4gPiArCQl9IGVsc2Ugew0KPiA+ICsJ
CQkvKg0KPiA+ICsJCQkgKiBHSUN2NSByZXBvcnRzIGEgbnVtYmVyIG9mIFNQSXMsIG5vdCBhDQo+
ID4gdG90YWwgbnVtYmVyIG9mDQo+ID4gKwkJCSAqIGludGVycnVwdHMuIFJlcXVpcmUgYSBtdWx0
aXBsZSBvZiAzMg0KPiA+IFNQSXMuDQo+ID4gKwkJCSAqLw0KPiA+ICsJCQlpZiAodmFsIDwgVkdJ
Q19WNV9ERUZBVUxUX05SX1NQSVMgfHwNCj4gPiArCQkJwqDCoMKgIHZhbCA+DQo+ID4gRklFTERf
TUFYKEdJQ1Y1X0lSU19JRFI1X1NQSV9SQU5HRSkgfHwNCj4gPiArCQkJwqDCoMKgICh2YWwgJiAz
MSkpDQo+ID4gKwkJCQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4g
RG9lcyB0aGlzIGFsbG93IGFuIHVucHJpdmlsZWdlZCB1c2Vyc3BhY2UgcHJvY2VzcyB0byB0cmln
Z2VyIG1hc3NpdmUNCj4gbWVtb3J5IGFsbG9jYXRpb25zIGFuZCBhIGtlcm5lbCB3YXJuaW5nPw0K
PiANCj4gVGhlIHZhbGlkYXRpb24gaGVyZSBsaW1pdHMgdmFsIHRvIHRoZSAyNS1iaXQgaGFyZHdh
cmUgbWF4aW11bSAoYXJvdW5kDQo+IDMzLjUNCj4gbWlsbGlvbiBTUElzKSByYXRoZXIgdGhhbiBh
IHNtYWxsZXIgc29mdHdhcmUtZGVmaW5lZCBsaW1pdCBsaWtlDQo+IFZHSUNfTUFYX1JFU0VSVkVE
Lg0KPiANCj4gTGF0ZXIsIHdoZW4ga3ZtX3ZnaWNfdjVfaXJzX2luaXQoKSBpcyBjYWxsZWQsIGl0
IGFsbG9jYXRlcyB0aGUgYXJyYXk6DQo+IA0KPiAJZGlzdC0+c3BpcyA9IGtjYWxsb2MobnJfc3Bp
cywgc2l6ZW9mKHN0cnVjdCB2Z2ljX2lycSksDQo+IAkJCcKgwqDCoMKgIEdGUF9LRVJORUxfQUND
T1VOVCk7DQo+IA0KPiBUaGlzIGNvdWxkIHJlcXVlc3Qgb3ZlciA0R0Igb2YgcGh5c2ljYWxseSBj
b250aWd1b3VzIG1lbW9yeS4NCj4gU2ltaWxhcmx5LA0KPiB2Z2ljX3Y1X2FsbG9jX2xpbmVhcl9p
c3QoKSBkb2VzIGEga3phbGxvYyBiYXNlZCBvbiBucl9zcGlzLCB3aGljaA0KPiBjb3VsZA0KPiBy
ZXF1ZXN0IHVwIHRvIDI1Nk1CLg0KPiANCj4gU2luY2UgdGhlc2UgYWxsb2NhdGlvbnMgZmFyIGV4
Y2VlZCBLTUFMTE9DX01BWF9TSVpFIGFuZCBkbyBub3QgdXNlDQo+IF9fR0ZQX05PV0FSTiBvciBr
dmNhbGxvYygpLCB3b3VsZCB0aGV5IHVuY29uZGl0aW9uYWxseSB0cmlnZ2VyIGENCj4gV0FSTl9P
Tl9PTkNFDQo+IGluIHRoZSBwYWdlIGFsbG9jYXRvciwgYWxsb3dpbmcgYSBob3N0LXNpZGUgZGVu
aWFsIG9mIHNlcnZpY2U/DQoNCk9LLCB0aGF0J3MgYSB2YWxpZCBwb2ludC4gRm9yIEdJQ3YzLCB3
ZSBpbXBvc2UgYSBtdWNoIGxvd2VyIGxpbWl0IG9uDQpTUElzLCBzbyB0aGlzIGlzIG5vdCBhbiBp
c3N1ZSB0aGVyZS4NCg0KQXMgdGhpbmdzIHN0YW5kLCB0aGVyZSBpcyBubyBwb2ludCBpbiBhbGxv
d2luZyB1c2Vyc3BhY2UgdG8gYWxsb2NhdGUgdXANCnRvIDI0LWJpdHMgd29ydGggb2YgU1BJcyAo
bm90IDI1LCBzbyB0aGF0J3MgYSBidWcgYW55aG93ISkgYXMgd2UgbGltaXQNCnRoZSBDUFUgSUYg
KHZpYSB0aGUgZW11bGF0ZWQgSUNDX0lEUjBfRUwxKSB0byAxNi1iaXRzIG9mIElEIHNwYWNlLg0K
DQpJJ3ZlIHVwZGF0ZWQgdGhpcyBhY2NvcmRpbmdseSB0byBsaW1pdCB0byAxNi1iaXRzIG9mIFNQ
SXMgLSA2NTUzNiAtDQp3aGljaCBnaXZlcyB1cyB0aGUgZm9sbG93aW5nIElTVCBzaXplcyBmb3Ig
U1BJczoNCg0KICA0LWJ5dGUgSVNURTogICA2NSw1MzYgKiA0ICA9IDI1NiBLQg0KICA4LWJ5dGUg
SVNURTogICA2NSw1MzYgKiA4ICA9IDUxMiBLQg0KICAxNi1ieXRlIElTVEU6ICA2NSw1MzYgKiAx
NiA9IDEgTUINCg0KVGhpcyBsb29rcyBtdWNoIG1vcmUgcmVhc29uYWJsZS4gQXJndWFibHkgdGhp
cyBjb3VsZCBiZSBmdXJ0aGVyDQpsaW1pdGVkLCBidXQgdGhpcyBpcyB0aGUgYWJzb2x1dGUgcmVh
c29uYWJsZSBtYXhpbXVtIGJhc2VkIG9uIHRoZQ0KbnVtYmVyIG9mIElEIGJpdHMgY29tbXVuaWNh
dGVkIHRvIHRoZSBndWVzdC4NCg0KPiANCj4gPiArDQo+ID4gKwkJCW11dGV4X2xvY2soJmRldi0+
a3ZtLT5hcmNoLmNvbmZpZ19sb2NrKTsNCj4gPiArCQkJaWYgKHZnaWNfaW5pdGlhbGl6ZWQoZGV2
LT5rdm0pIHx8IGRldi0NCj4gPiA+a3ZtLT5hcmNoLnZnaWMubnJfc3BpcykNCj4gPiArCQkJCXJl
dCA9IC1FQlVTWTsNCj4gPiArCQkJZWxzZQ0KPiA+ICsJCQkJZGV2LT5rdm0tPmFyY2gudmdpYy5u
cl9zcGlzID0gdmFsOw0KPiA+ICsJCQltdXRleF91bmxvY2soJmRldi0+a3ZtLT5hcmNoLmNvbmZp
Z19sb2NrKTsNCj4gPiArCQl9DQo+ID4gwqANCj4gPiDCoAkJcmV0dXJuIHJldDsNCj4gPiDCoAl9
DQo+IA0KVGhhbmtzLA0KU2FzY2hhDQo=
