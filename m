Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013050.outbound.protection.outlook.com [52.101.72.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590DD3E92A0
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935566; cv=fail; b=kunfSCjvb2TauTRBMBvI4f+S168meQze5lUWaToEBY+Li22kFgO/XG31rQhbc9SFNjmHhcN7HikSIuRt9WEVBJzEszGg1uOJfroBj5nbhJgJx80jGJvGhbwdCrgc4qFfNiTSNGZTVY3rDUXJc1I8M6iZMrBWN05Tz0y7hTDOP5o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935566; c=relaxed/simple;
	bh=+KBjkRPkU1zI3s8Hio3H1SewMKkzcBm1UX3ngKu7Hlo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KRKJ/2TX7VzVjM9etT1rp4DouAgo1ug0V4nzhiSMrwodCtwY0RLUSn/nU7h/UfkDEpUDh3CVh+b6dGED6G4i6RNCyYvuTHj5fqKCrbVEm6ONFwZPuFuwGCvm26GA7qnttrNOi4jytKTLQgGgw/A7K/fa6APrZPyNCGJltoNAtrA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qu54PXQ5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qu54PXQ5; arc=fail smtp.client-ip=52.101.72.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qu54PXQ5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qu54PXQ5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wol0m8DomG36dC3FNwlI87CgVyOEYQ/oLrLFCcQYPVbmfNECoiR7fKSGEMg/A9gft5v5vAnU4yaX5vPb2YhZ+MTA4tAVCANVXqWzlz++v8ip0D+u/klOWogXiFwacrZa5xckaxpNA7C9Ej8Ud35TFnWxVszUfmfigW5keGN5wGNoTNiDM4CWMiiM7Vhj0gapIhtlJaGcmSRz2SogjP0SZJx6VbLIV5oUJasWZFLVa5t+ZaqAI3z8s85nVNq8vQ6N4qIeoAMhMHke+GMDeqIW0qMZXjCnHFsbn2UpgroHfYpIG0JaOnp4g+A/ubvcSSHG6OCMwBG5euF0NGCnFegr2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=Icj6QowLPD3DVoFH52SIcYRFoQig4/VHjFPb77kng3YLJvz1LI6gN/hpF/vGzkKkzm7vyzmYeNwJkSlg5FWXzZQUWvO7ftKyV+VIZ5QuOXUlVqVdXE3Wwad5mOPQq6wcPipoA5ZebFDe04PuCKLddUY3Nq9clShtq3uHnlSQRO1zrMc2RYdIX9e2erAsc3mQemYdDWtZnfAcKDNTUyDlTBrIfwBLXMn1oEL39172sDeI+pGS76vWymQ+H99hYAXcl/MD2XVCGNODfNSgf6+NuVQtpXbwU7MDA7rw3DEPQ7elTS6qHlUwSQkyc3t2ZVrDRiDAedVD+Oyvcupa9fyuVw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=qu54PXQ5lyDStkioEK8GJ0CzFAjZhB75YtMIzpFHk2XUqwcFp5f/8sPoFs5JC37s+A0DU5SOF+f5OnLLwPSQIfFRyHXW6jR1sjYwzOTemb7pkOXfQHNCOeqRQsK14SfDCRLa3/BBZLcHV2dOs2PrUev1t/q19buMXKOtoMenZh8=
Received: from AS4P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::9)
 by VI1PR08MB5501.eurprd08.prod.outlook.com (2603:10a6:803:138::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:36 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::e3) by AS4P189CA0008.outlook.office365.com
 (2603:10a6:20b:5d7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:52:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpFEpKUB88e/6hah62hgmrt/u31UDtKjxgh+PjsswGcoUI0xnXE2+5NRjsvnW0YEA5HUcjAeeDzVyMEGEbeBhoA3vGPyUhBqC0ixxodRMDQ4mF/dVLj5rGiohukYb/oDR/v6HLupXAiXjIBkdAugjRDS1oN/DqgTkfqbrLZQcePXj1fHtFx/xLUQKcQ9Y6raWg1drsfogkCMXfyFlrv2pLZLnPKnn/aIBPlp5mGU2AX92HlWkGW/oGjJrkmis/u7ULj5v+yS2ViCcQt+enNYyDolXBhPxi8zHaF9vOFil7ExF4iy9LH47or4wxoCgL+KgzDkjW0VXHvvr5MEY1YfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=e3ZQV+9IO47hOOnzEyhy/tlbPLDUlGvJGn12TQwaZaaZJLOxlWUMpfRsBmCWQgtBfo6vzIqQ6TwF3BWjUWHFxa31jN+/+vEFkcCC4/7fjEFnV8Gdn9/7W3EeoKV5gR0tsdjaqxmWhyU71q5czuYbTx+AWVnvRwee8xYa1fHHqWTGfA4DHpyjqd+li/3xE58AUcS7WKCIzY7Sx4nrh65alS61tPeYmyA6T6fRWkGAW8HqA+9y77yxeXsm11oZyzgrnvtLh0QV+hT4+A1RdzBKzHtsgSKicf1QIKe1fKk6PFPWQSMluyteWiHMUBIDZ0S7I56jE02EjShxuJaAQhVsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=qu54PXQ5lyDStkioEK8GJ0CzFAjZhB75YtMIzpFHk2XUqwcFp5f/8sPoFs5JC37s+A0DU5SOF+f5OnLLwPSQIfFRyHXW6jR1sjYwzOTemb7pkOXfQHNCOeqRQsK14SfDCRLa3/BBZLcHV2dOs2PrUev1t/q19buMXKOtoMenZh8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:32 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:51:32 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 07/41] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v7 07/41] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHct7hBVc290385v0u0usq/k5itZA==
Date: Thu, 19 Mar 2026 15:51:32 +0000
Message-ID: <20260319154937.3619520-8-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|AM4PEPF00027A69:EE_|VI1PR08MB5501:EE_
X-MS-Office365-Filtering-Correlation-Id: 812d489e-2317-4ac4-4497-08de85cf8a73
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 nrL3R2zfeXXPyyuquBXGuSEdcX2z9fqmIgJOgOJSHASRXEpxD0v5o1vqW9tnMSpMWUkbJpNoDGvbSRTqa//wny25K9G9V5fw7585YEkKXJt99cQYc9wSemWadWxRIhTxZJJ1bCBFYUoGMc4GBinF0YyK5SNisvcDYrep9+VSulDH1I25D0H44DS/qdzjB8OAT1VP/OqlSQOx70TnM46/6M8qjYB/+FuxQEibbwLvMvDifJlvOHUjkYgOqDK3lHusYtFr26qIGp8PZrsdgRPbxy1pUZ/SmvHfKMjDcCViPkZHc5rUBtS+JoMvHYEAk1HfZCWDr1GQg9cfe3tNCCDPjXwuHKnXw9oU/WejyGxt5bu4fCq+39NAV0xcB3WlFBH4LrL1NxP+Wfxyx+NPAbadjdXFRHGW6N095NWYHzk1SE40SDjIwYd9lKf6xFawNStBDHTUdlrdLIiK7ifGXrWrfERz0YwoiApC6LqbW+Na0NzgtDDe40RfDBCAmFyIPRgw2EhR3fI5uIxydu0PUZMR28JMVR7QOh0hDq4qIVxotrFdE2SaCoqG7mBLlrHZAELiiC8Y5NM7qZT5cuPGc1+j6Eyw8KnBkeyikJc7lSHktd2KW5qaVhvD/GjS7HHdeEADxnbXxFVZOXy5Sqzcrf8GQSLZqeV/5KITjPhlf6xpYSxS+CGXpW/Lm08+BNhbL9eDXSk/1D5inY3iV+YiwKeVq/IgMYlHbqGChq95fXmhRIQqxKY78Lg2xzR1egt50yrRFBW3tIMCPEeeEpnR1J0qVKlORVqWu+3POQkWipwZdzA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MrhzX+Dy6AJq++zlhG/QMJIm/gkVzp3/DSYhRH6ZeexdS0OKP3SucYsrU81RUuDtCyHcqphEw2rzfvYfEs5BWSN4EujVREEl61mRutzRyUGbvCuvKO6Z0qlMuT9eiKmqBb1oQUkhg6f6AB/XJh6tNln85+WVRIgIbLOEEh7tdgI2yf0NurwwrQDP7ckxQdbPwCvG5e3e6n589Sif7AwLhQ3hgEzk1UcpX7ji11mLt8xZtzW+orMQD5p9hQZn5zupWTsH8SROEt1fQUJX1y6vNbS90Au+eyzOaMGhrHwVuTGKJTdEL7oKoTEmgn+5/9xdqjZ839GryhGPAN5G/J0faw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e450143-a274-49da-144f-08de85cf645d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|14060799003|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X6hGtNXGsmbqMii1LEHpeWqOfxd71Div87JssORPi/GajOKx2ybLGbbolOgApFyeTcnJNtQ5IxIa7Fyqt/q9goPiQBkik9fstZtyH08YI7OO9ENzkfwGOcIdp2bRGRnC749vzM2HAagYzEGPX14afwmVMzifEHfDMjXkbrnpZB6ahjw9iE18QMnBZoOVBMriRJHUmHpQhlK1Rb0LgqjcSeAVg7AaS1WFBjOqorhygtbF0XDI2a8cU5+LPv1b860lubDeK9LLKM/IPr2qXxugYPg69G08qJ1Nruk5Dfyvgq3/WRvaPsH+/A6wKzGOxqIaIgl6QGAK9f8ouIgRjjbu0ObJvKqDa8ENoatDrivSQOBLhSuupG6C6PMDG0Hz7h5GSMsgkJszZXvuFH+BnyNtP06i94mQzt+MJRyQlmlaHudnkvAOKhDUbIrepBd2usSeOcf4jhJeZxG+z8Af8PbwyRpq1s5YhgTs53cpO3VPZQeVKzIxi+4UE82P7D8gZulSoAG1cRi5GEMn4qXKiDtk8jVIc7OoYGlEaypZbaLrETwTwlV1Y4im2tRmvxjbCLDBx2i+BRNWddpSGq+DsynoSB5hXb5TD7TJiXh6Zv3yETFjvN7OeKRdgSMvjowmF6U6/6r7+dqCAZpvpOdKSUZvFqKUoF8v0smBnjEuepjG02MN/Q3kRnKsWr5KCp3qr88I8norJUe21zagw35qL3W4jrJom1xKae8h5qLSiZsiRBAw6StTi6SdCcAszvA2m06lC88DgOl0BXzkmUCRYbo+lQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(14060799003)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DZB8mmEF7TWs23xXwc2tpcWEEJh7bPmXlR90QmwKiiEcbQ39udL4whdnTmAcgN3CQ23r5goaddfxOBIttNZAb3H+uBYDAMejH4ELo3v0DFpTi0OpGnP9XoY4zHPGoeq8/FAeAnQztxEQGto/2J4q0yK3Ksorn5YTFyh28M8x/StwTnJoyPQjBjar265c1tlaDUc3Kxvant09rdYaKOj4lLeJcf6LLv17uvJ9BJRmgb62AnZagn0qjS66AQhA9VWVn5J1teHwAEGJQRFk3/JJEbx79i+9qY8Kc/ReCbBN/M4Hy6iLrf+EvVXUKvbUvXbxiv7dBlU2uXbpdY8FvzLJs01iKdEyH/ivCTuE6sRN37xwkB0wxcyQve/bzOep2p2rAf36vd3e0pgjRgJfRG9+1TK1lzAY6PldIrA9pePUu/0LF/8njxwMwrznOhIiq/Y7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:52:35.9737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 812d489e-2317-4ac4-4497-08de85cf8a73
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5501

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index f4436ecc630cd..938cdb248f83c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1052,6 +1052,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1098,6 +1099,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
