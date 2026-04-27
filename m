Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013045.outbound.protection.outlook.com [52.101.83.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C14D34EF0D
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306461; cv=fail; b=B5C52kplvTD+mdUxwDS0rT2SfMb6jpAXjSQ5oasrKc26IgUwG21yCuAPo1IDAWKKgp5jFWcwBBD1YnGcxHzkWehBFjem6Y3HAZQo5HRwa5s9/j2H2HBBagBmgrVUwxFALUvzWnT4yWk6W5Ec5YC9+ZqDozZHrYIGYY040QfcB8M=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306461; c=relaxed/simple;
	bh=4ez6Lxx0lCcnCcJADVHlrDMOsUz7PqSE2Amvz9V5Wyo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j+iFVWBPwf4PK2Pfv+r8I/1XQDRAmDxCyhtQT3iZmh1l58KFdERaUGM5B0LZpFPulJu+DZQ+mdKaPHg8cL+ieB4D38FHTW0Sweh0dCc1pmtZqiAiZKENWcEu7s8R0JjCq5kwgxuUdbVdh8Ye6Wg3Q4qc9lCmvD2O5sQYbuGlGLs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YXemTQV1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YXemTQV1; arc=fail smtp.client-ip=52.101.83.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YXemTQV1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YXemTQV1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WpkWRkUM4q+eSGkH7Tg+UhR89Oke8fUxDUkaQAAQGdadpv1QETZUCBkMWxAtiDCVe1CS6e3IyjZhH0eOB8pBkYS9tOdbWoUHkvx5B4ehc0mhanYkrFOpAF7zOh8GpeeYdL0mllDLiIwsKSDsMesudyVeKcmSx8e8M7KFQQs1FIKz6scB2t5ymXTMceMdQaDvz1rNkMtzgFUztQWOkDGKRcF1irNr/ZHaQTcVO9Aowklf86Fm1jeNe+hdqHle+cbXOVFXQm2Zi8Uk0HMfpyeWXmObmPL14kznMI+3wJWNvOYsXmudRK5dXwfTQKlU6GoRX6Fa0qDjzMY5gdJsQYEN7w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfNKcFWMAfobxL/rt+p6Hkf2JbOSUGGCVMysoA5lMwU=;
 b=oE4AKH5OfmnPPc8jW3nZqrHq9y7Yx/5p8yxB6+n6954dAyYtsD7R6sPZ9AJfEa7KxXQze97AldHyYN3n/U1rFlRn4dr7wkHwFDa7WZJ+U92Wvw0cMyRnZLqSL7Ym8k1AP8xfefRpf0A8vOepFtoOzjlQhFvNiZ3m7H1ov7vuLykf2erMj+f/+h3pQMPbD/f/A49kQCDz0lRwfPEQzGu8CiqpTK4NMj3H9nDJ94xYhKdDAyYaadxji9jiCZxqZ+V+0x/WodSoHks8autRVcG1B8Aey/CoaRL2rzTD8vZll39ZCRJ80Xho/35txHKRjphv5VrP8T+Q3K/iIAvA5EW6Cw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfNKcFWMAfobxL/rt+p6Hkf2JbOSUGGCVMysoA5lMwU=;
 b=YXemTQV1YX60rbroryXv3h1dktyjWHOlhVx+xQj2rFGgL/rZwd1QK9LyWsuIBmqloRGXOKcLmvS4SmPdb+e4hRF4e9fhEYoyEnUSxuhT1YM20LGoTFfkGiEqPVZLHSMaMdpJ4tm0Wwcr/EdEr3+MTN821OAGTj7GLixKyjTOHCs=
Received: from DU6P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::10)
 by AS4PR08MB8021.eurprd08.prod.outlook.com (2603:10a6:20b:584::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:14:15 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:540:cafe::49) by DU6P191CA0016.outlook.office365.com
 (2603:10a6:10:540::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18 via
 Frontend Transport; Mon, 27 Apr 2026 16:14:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9V3VjEijwTYHEVGuYgO9e8yRZIszu7twOAgMgPnBYY0+99/klcgqcWQkPv9r2shmvCVoQWh5fAMh9Vva6tZO1o6w10d2I0fxiPrIIPkEchyMFTDsHUCqn2R5cXrlcWEE4IN6CMYMkjvgooF4cK1prHFS1cO86pmknEmUUNRAQJN+lVcfpGhOtwHkkRvJvf4V2fa2l843dYZg/2VnqZxiWPiguKf54Vq/7rv0WC0pt3ziajMDljDdIFBd0veTxwYIlRghBnyicyhf15FI9nTJdT0m5SRfKENNPhGCTW7wIvH4kAXtq5zKDyLHNoEMHFuWdGHfYMz1/gaumR2eJ0mCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfNKcFWMAfobxL/rt+p6Hkf2JbOSUGGCVMysoA5lMwU=;
 b=f5jUkQ3pBr/LfAAR3AZPE7fHKoj3ttcQYbq9WuHWtleyTY5Cx3rfiJFHVRjkmfSLUvsj77KMN9MgcjQcQF+zbAxx+l2+BXPgLG9xE/LdKj31QJi2JCgAdBkUZ7vVhX5QBQ1NWXo0wVGjBlxBLkqmpfRl3Kvq17jZp/HPh2jANbuL9QwLL8J8IaPGabjM3Rtvd9TDlxYf+vB5QADTbBLgSjAhcQAEvkAVDzqhBgjh4LsoJqkbyvxJypFgTEttbCFGbmO79FLgUrh2ZtG6OAt0ZggsYrAYCs285A+NT9ED1cCuek0XZCldjBZURSEHH1Cu2TNBO4a388+vYBYGKmONbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfNKcFWMAfobxL/rt+p6Hkf2JbOSUGGCVMysoA5lMwU=;
 b=YXemTQV1YX60rbroryXv3h1dktyjWHOlhVx+xQj2rFGgL/rZwd1QK9LyWsuIBmqloRGXOKcLmvS4SmPdb+e4hRF4e9fhEYoyEnUSxuhT1YM20LGoTFfkGiEqPVZLHSMaMdpJ4tm0Wwcr/EdEr3+MTN821OAGTj7GLixKyjTOHCs=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by PAXPR08MB7383.eurprd08.prod.outlook.com (2603:10a6:102:22e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:13:12 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:13:12 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 21/43] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to
 UAPI
Thread-Topic: [PATCH 21/43] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS
 to UAPI
Thread-Index: AQHc1mC/u3hC0JaB00KSijRBzRBdww==
Date: Mon, 27 Apr 2026 16:13:12 +0000
Message-ID: <20260427160547.3129448-22-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|PAXPR08MB7383:EE_|DU6PEPF0000A7E4:EE_|AS4PR08MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: 9559ba76-624b-4efd-3472-08dea4780701
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 t1avznEpDCp7Mvu+Gj6ekWLqaInvu1nQG+yVtVLJlsCI39o+YQo3nEurO6NBmwWHuwRxQhyy5NICNx74quy/t2tXyArgkv19z6Dg12iNG4Dntf0sZIeFYjbOU4bOc3v8eMz/xysTRFwCQDSPaBTPIiq/T7fOYAUsuGepe5q8823Lrl426Si7A3lXpWbToaspwExpo+h+TfcR2RKNwSgwueqA2hXFMYpMaT0B0D9NkeTbFyMMy6kPq1/tcWz2jBtQMFXju890Q4PZMvCSWoPrg3EbPAY7bASBTQg6QbN5KWXlDwMHpXyFxPj4pf5W7N0QS2IUBbVX3p6Tz2m6yl0ZBekyTQVmCGfvvxvYvexFOto7f+ohnQMdI1HNCK76VbwnhpomAh7/cXmbGT24JGYuBzf0wU88e1OfX1lLS4J+bgP7oLL+T5OeZHlef9bAoMBOVXvkZjk4H9UF/zq/Kp/0xpWZha4l1ofeW2nLQnkk3oeHkJYCIEwsvCXs4Vs2FU5YcNgLJqWQWynH2caiIvtGGoJyU86hzsbqn1ERbFaqoPWri1wbzLKBiuQ3mLx1JM5YJGRtfqP5rhsibxRSdOZcl6zalLLfdH01Rp6xbvcPda26WuC4sQdTF7JZkTFJWAr4k2VQQBgzGU7dnqW2FvMrvO9DFyoMDmpzciA6Clv8Ktvf0kR4tDw6mUvkeyvj/SB+XnebsdU5gvX96Md0KnSoH3U5sji89PxaBZAqm8N8Tkz9co9LBo9JR8RcGLOhW5hT+ic49OyZUy7S5owXly4PPK4PcyPyEHVQNhDF/xtrEc8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 E9bbM5YSjrBKxex/7rDCRZ9EW9rG+rZamQexP7ZT16iWPGHrrC1eES1est9JFNWAeuKZIUq7GkkH8h6VhNlZzDoGkDwG8UXGe1Y+230IaGIIzeTUQiLWqZP8CX62AZz9S7gvY4ix4Ik5WY0zj98DMoh+sablZ4+N5ZG9hMx+mJynxUrFKrEbmCTBeetF5Q5NRypDvaNbPzlLwr/1iKorpJW8nut8dD36CACjdUy+IUexVqoOIgwGIpxwWJ4DnESGuhMCHm9ckZYvONVt0/3M4w8UP6pEmXXFJW/ijyPlnanjLNjqW8cWIAVWm5AVclP+lXfdnqvxmYmwK3Y+GP4xPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1bce02c5-2f4f-45b3-9cbe-08dea477e1c0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	v6cxuU00k9wDLJ/0QSpmOfrQggjcQPlVdfd2GzcXXNMSqkxAndPHKhINOs/9ZxBUll50fgnRU4UPPGrTYQgSoLzqyZF+pRXdkmEVj8iyfA48nEEL0iogp5iALWQY1mI7LB+z6hXi7XgeR3cg6g0gb4bO2C7IDUKdb8y7dKkHahYNfLTm5cBPOMp5XKmxnv9+Jz9TUn2BBs6Kbxwiw0xJ/myHfzTPYuKRjsUAdVXid/qvUVjphzrj4/G9oPXM9H1ThiYGk2ZFI1rb3ky/54uQcPI0i6Dy2kuMU0aC5D/gV9Uo0q9h3qbsHgEc6lGu1Q2JSXHmSIgpOOqtntqc2JZ+pDfwi1co0cTPBfwiEFqG3sRMWGoo+vjoi+REryzW3B4lRuj7tKJE9aeapoRdSk12o6PtBGpyW773AF+PsV4FsjlVRq1PIQF4kobzdFMq+A4k+x8+uZ8wi+5rHPIw4HF1+XCdvxqcbl8iafdJ/9c/Z4N5J8EvccTdDVc2LrDh932Q/H2WSxuF6HP8S+kMX0BjUY6yX8n3UOYBGrvu9aevBo0Ip7dUC/4DQccDDR84nvKIRXaJNs1wN9OaN6j3429MvqyPW4ZNIj9VmybUCIljN+RH6tkQ9Lo0+P61SfJTizvJNUoQ7u5c5WUtu112B6wzzvJE6S8QzLiyWl54isvKbWFPBQnsCiLNrJWmldfiKg7odortmCH71xScoeHfUCcNhQwNxVVSBeqhI2sa1FG0dD4olPW2szOlMhWAGEapT++Bem7yr7ILpgg8314zNBIRpQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TOdZHm+hQ7pI/WSTuD7iSnR++jRpYKP1rLKhlrPgmsjU7jKgwTHt5qa0URemjYI1S1ZfQsZjmaIyP37q7x+YcQNUZuaT1UPMzQA81L43zd2HlwwY1mN0K8b80tqF54pcYvUUoUAyMxbsQtFROAIUieSyNUO7u3Ni97QKFreo/FryVrXjWRITrNY33yb4GcXdhRhSmKkea8tzNbOKwZo59tlhTcftkKsRtgOZLly6gvdnBrviarg5x6z2FAGK7zSnRvrblDk4yYgnKzm5YRBSGK5j/5/LeZ3V0ZCOIf4v8OsceHfpAqre5VFX7J9f+iPTLjG+sdVIsDRftkEE2Gj7QrUXL2/xYvgLTTKh1hPxohymHkC9BGfmf8npwO6Ibydf2ODW+gdHbIfxzb9L8nKPBsj4vWR4QQrKbhfrDxY9vqUMOc6LcXe/W3QTZ0qS4Wwm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:14:15.2759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9559ba76-624b-4efd-3472-08dea4780701
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8021

Add an interface to set the address of the emulated IRS in GPA space
to the UAPI. As per the GICv5 specification, the IRS has one
CONFIG_FRAME and optionally one SETLPI_FRAME per interrupt
domain. Within a KVM VM we are only concerned with one interrupt
domain. Each of these frames is 64kB in size, so we reserve 2x64kB of
contiguous memory in the GPA space for a GICv5 IRS.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index 1c13bfa2d38aa..d1b2ca317f586 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -97,6 +97,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
--=20
2.34.1
