Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013030.outbound.protection.outlook.com [40.107.159.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08632EEE88
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094760; cv=fail; b=fV/qHEWPnyCu78RSLsT85FEInR/5TZqlu/InIj2E67hyq8Zh7J8eG+zddXcNrD+iiPAtuUs1hXtftC63yIrxvnHG15YF3ms5o+629Z6qpU2TO4ODTCYphcpTvUhxTZbaPqC4PUf486S35bUbHaKhAHUOC8b+s1YOpJLXp28BTzc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094760; c=relaxed/simple;
	bh=IIeueMwAm3FXji9OcjTIAIqVp09tIPEzHSAPQedVoz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dodcbiSa827B6vT0S6/MIR6t2SLBAI3oeRBT5O/2ieMKjpZqSDGRYWewbRd7grlkYV7fI67PakeLbC8mIA7IEC5lEjYjw36aDhy7hRdPfaeHjfjzeelHFxDqKAacwrMkJHOol2HsfZEUdzwcJgT7RF1xeCRGM23KruLgl73k/jU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hdLxvgiJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hdLxvgiJ; arc=fail smtp.client-ip=40.107.159.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hdLxvgiJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hdLxvgiJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SPvPsC8R6wQyYv7yBfVxjxuDIVaTr5syvPtKGfknbWyaECiVvcUYqq5KnyBOTFhCXo7sHkaoQ/iXpUuFglk5BwHTBYnVksHH41vJmeFJ3ufG8ZAtbCAKFFijRWVD8UyLZCpba6bGSL7ZlcbCQOyWvUmh5bfIWt+xkBl8uKarUSVMUWTPww5aJ3MRqkZEw17kwIR4pBwTLzguSmfJnRA+AKe+35u3ZahXJgs5QdIqwwZvdGWLKKfkMUjUdZwGzj0z4PljEVaJEPqX4O4MP94K2w1I7tehNkz0prOmJVDlgxYp1A80uRJtYIIVwTSu2r3Ntn/rUx3jqKYbQT0CjPy42g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oejN9xo89jRgWpOIyI5y9XUTyc1brn4mRwxu3t0/YM=;
 b=fMEFi42d6cPUxN6WFhZ1HtAyevThXEXZ4XAFS80hyajNj5ZI/uT4BZ8lsGuhl5InC08+/yy1Kr5TqVkKc4ywCcEtXukDVlhbq/wzLqKXn/GH9a42PGDgOIw9lBEQzA30jhYHAmomk3SXxlosZTofTygVMDQJmqJZrNGa4iO5ldGMkvFNOrBAu4+RCTWH5CUfAvASQPmgxQcgcJPbQ51//EYZwqO8FNdBhja6khoq4j7sYFbZKSG2sZ21Mk8ZigFM/U6O4jkYZ58Lh6W4Pot61UEsnHXLJq0Ve1j+8BkCKDDEXcaQOPGxar5zccm0sZvWicmfavUvYdD8ZfAb0987EQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oejN9xo89jRgWpOIyI5y9XUTyc1brn4mRwxu3t0/YM=;
 b=hdLxvgiJCS8sT1snJFBghnqQYR0meNADlUJAWmqlYyHgrGigfE5Jt1Dj4xxblAk2DCfTYqiCHBlIEhAQ2MGmXvtupL0ftYaFFQPgkFWebSql/YMMn9RblySixrQzruP3Q+40jDOt7HLVFCZQALEqTHE1xlhzT5/9UeiQ4DxwlgY=
Received: from AS9P251CA0023.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:50f::19)
 by AS8PR08MB9930.eurprd08.prod.outlook.com (2603:10a6:20b:564::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:05:49 +0000
Received: from AMS1EPF00000043.eurprd04.prod.outlook.com
 (2603:10a6:20b:50f:cafe::6a) by AS9P251CA0023.outlook.office365.com
 (2603:10a6:20b:50f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000043.mail.protection.outlook.com (10.167.16.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czG2jBD+ZSvL5nCfl39wrNiAaQaWcz4VlpfsZrWr5fVteU5xopMBRt65vXE5JZIPB1ZPj5Q8L4PN86k9+xWNtPPAmCFc0XppRMLdJO8KaJOlSZAQTZKxKrxxwHYFGNsJg5K2VxQDi/+1WBOwWID2TeK+L2erbok8QJvRfztjf4Ug2jSdUe7C6keEH2O6MTBC4btFhfOjyWNfLIgRhG5FiuaHX4Kl5uov0dP4x88/gqPSV8NT5HUezuKqoBbqEKHyN9jUmHL3Qk+QniGPjKZmiTtXl8w+l+fp5D6eYp5vTFaTpXT63oE+bwYlsN+TpjPWYiR4lRuda99C3o+Y+ArXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oejN9xo89jRgWpOIyI5y9XUTyc1brn4mRwxu3t0/YM=;
 b=hqObdZo3TvJQpmj3irQCXs6rwgXJ8FqkFra/C+27UYTkjsRmYSsX2QVRHnA5PTR+7xsnT66fcuM7kgnt+eMAtZNzOfZS/ZnhP8ivPhTPdxtFSx7DWYLvXVNqhE4bkYJf8oegRf6VtzLoKxvUSt9oI9pYVck3MQTBcGh667PTytNxs+44FsL9+sdTf3M28csh89XIJlsPrhisNySaxAnQkgJE/0AabheZriiY8q++jMC1wh8UqkgM9zWLGebexIXZvNr4vW66VqaQJ6tLZ0syNCpJE48aYNNO1sjD5DoSh6yUwsitbmV023VlX2JOHESM0rxsjm9PzP4yCAJSUQVnYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oejN9xo89jRgWpOIyI5y9XUTyc1brn4mRwxu3t0/YM=;
 b=hdLxvgiJCS8sT1snJFBghnqQYR0meNADlUJAWmqlYyHgrGigfE5Jt1Dj4xxblAk2DCfTYqiCHBlIEhAQ2MGmXvtupL0ftYaFFQPgkFWebSql/YMMn9RblySixrQzruP3Q+40jDOt7HLVFCZQALEqTHE1xlhzT5/9UeiQ4DxwlgY=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:04:47 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:04:47 +0000
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
Subject: [PATCH v3 28/40] KVM: arm64: gic: Introduce set_pending_state() to
 irq_op
Thread-Topic: [PATCH v3 28/40] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Index: AQHdCwWrudM9cYv8eE6kCJE/p9t1ow==
Date: Fri, 3 Jul 2026 16:04:47 +0000
Message-ID: <20260703154811.3355680-29-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|AMS1EPF00000043:EE_|AS8PR08MB9930:EE_
X-MS-Office365-Filtering-Correlation-Id: a967678a-40ea-44ca-814d-08ded91cf362
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|56012099006|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 lbTZqmoTL5L71UnRa5afbWflW10wa/5wKBbN1i8JXUcaRC75eBXn8wq5A0oc6djpF0ZYhUlS8QpkIi2Ay4AapYSlDsIZVkK41oWrmNK/4ltk14gNn5wW7eOuP/nKEW84kvkxNnw+Qni52SybGgOZlRTO/bRcfi06ynSjTdicuelYNSysaCcWrje3ZLQQhht/3JCKaaInuAiLHTMbz/o9fJPw/MSTlxHEvUTPqcnlf4DNHBzeRPcjTAoAq8cRfrHV5ry6WB47nkA8nvrbABzMtESm93+tg+xHGDpHpHu6yRVK2R2LkmTS0f7Mb8SVrghFOl1n20P/zr7GpKa2flJLQ4zsL22hLhanahIFYKGWfoBGnhbRbhlRGz628db4xKZ45cXVM5L2/tB0UX5AuFZIspqsx7hVjz2W90vEvZbM9RJht2Ln7e+CSbENM8m9shBha7KyqtaaREY7N+2F7uKIbd2SwRL8J4AXL3FPPRvI46lsS+u5nRBm7GbTzWdvmDnLCW2P0A7gPreRU0ItI7M6bPgwpkyA7D2fGAsDKI9b5wxPYzGIXorh0T9RrSbiGISLIL2Kw3VqEgUl75YQSGfakR5/vy/htOTXepeD4GFZ04d1AU1TUNUGvTSp6ARvHQWD9Yre+XNszgiAtuoSYtOLY7Zo5f3ciaBNBWAPz5rAv3KW8UYOxaZrsH5GY9qXm20ZhkL1YY5384asmFyMTDsWwrjvklTmDoPEjbPdcJJeUZA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 WwUp8bP3M+G5WmTGNp8BsFyiLq1/0GTEo/GEAPbIUu1EJ+XXh2XVmrpvu00hmGsxcONdwSnsftEk7gowJ66vwFYjorxWh0JBdN100sVKdYqguaSlhFfQl7rBezzVd0TETNbuzfMS1SborSkaUkEwH3b2nr9vwxGTGuO3Arxmi7syd8Tekeb50PwHIRfSDCCA/81vgSobfmfs9tCM2psFzahfxE/Tfg9qTyy4a0pnZR+y402o0nyMRsN+eb5nxYGpf4ZQNkXQ282TmHt+IXM7CC8v9pThj4GwwmYBbXhjMzQQWAZuug9/xiZ9mPCjFIsDu1PhevQLWKMtnpegQANbkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5aae6661-dd49-46d0-ea1b-08ded91cce27
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|14060799003|82310400026|23010399003|35042699022|22082099003|18002099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	4HrVZyYpRPwtg0yuKnuFWpMwo2hMY9WzwSqtHSpvzkQtI8NEixvTCmmja+h1Tma4OlhWVcSqKI8ljv01w17a/aANGZn2VpJpu8u99u5uk2aIAAbmfQ6qnki+e4GP4ox4IepDb2690yIyUTbifl2E6DRXzg44iRhouuIq0eP1p4OKlDDp+ULrD8M7XQcQj1XJ8pLTbp1VXTr5i+oC92DM4d9hKKYW9uYuIr9fXvldwdpk0uzuqmPhPkfa1MmWYn2o02rrqC/N2vqXdBjtNmaJNwzNBYZPbLA9PvSK27IcG1sQkjrE6Stp5o1WD2xJGSre9BZ3wO9y7z3dG+qH7vtZxRRKNnpipDLl3DcLny38ZJp1NjeQilBNb4odsz0WpofSHM0+U73pkWmVFjvEtaoGU64j3jeIkh3giRh5S+kYsPzZXtc7fc6npwSVoKOWkqlJKe5RGcO7o7IeDgOCgZNNv9UYfFeNpUn3zfXXGzLzaCJQLltuw5cInEtBDN3JvcetoSw8f+XFwAzxoz7MVQOerXaXAtoiBt8ZAXWaFwg1v76mxeErbtUe0JjhNCYhxWzevVrWbEhXOvm5G5L9zFD7iMS9LV4dAU02tY/KBCbuqijdHK6cjMHB0NsPYOJh1fz/1JI7WQ6ZW85OlNtFMehU/RiVigoePwfwc0wWjL3DK+3G1Nm8JKbwV6cSe12tFBZJpxMmW+DbE8iA9bkkkzMdMw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(14060799003)(82310400026)(23010399003)(35042699022)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IYdny5CN87SLYELCUfW+9Vwqlo+VsnW3T3IEE6Wn51CCCwuhyMQwOdQnppd5OGIfLgnJN4YmXFxnTzEhISy7txc54vQIR6jZfY9G8MyFieI5EThGGT4qwo+4zR2QbCR/a85KNhr6l/GJByH+6hpnOYS6BSGd/fFr3uEbJZG2GxlbENUNG+E7ZFuVW5Q73Qj1slZ7AG0BDKCEy7UpaT9eUQKukaWkMA5z8nzvrSN8kQOu+NvxEo/vevfQH0GMHOD8whTUwqT7DtlxYp1RCY9aw/Yk6bLotoMUK/cVDRVHiA+rlruWfW3sxNIkDdJFvwEoMH1ORfHU0Tzv9AJ+0nAEizjnQZDeozHN5ytl15dK+osWvmA1SOKn3omgsPWYi2vDoKWIOjXN/esKKvh6IVOyBXcGs0iHHcWvQ1fpXEBy/JszAaoy5OreSLmilW7GYTdE
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:05:49.7773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a967678a-40ea-44ca-814d-08ded91cf362
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000043.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9930

There are times, such as with GICv5 SPIs and LPIs, where the hardware
itself manages parts of the interrupt lifecycle. This means that
pending state can be directly communicated to the hardware instead of
being represented only in the VGIC shadow state.

In order to accommodate cases where the hardware handles pending state
directly, add a new set_pending_state() function pointer to
irq_ops. The intent is for this to be used after the VGIC shadow
pending state has changed, allowing the backend to mirror the updated
state into hardware.

This new function is plumbed into kvm_vgic_inject_irq(), and is only
called if irq_ops are provided and this function pointer is explicitly
set. In the general case, this has no effect.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8b15938464ab9..ee7fc0c7104e6 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -563,6 +563,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d4b0e7e3edf26..f9f58ca793707 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -250,6 +250,12 @@ struct irq_ops {
 	 */
 	bool (*get_input_level)(int vintid);
=20
+	/*
+	 * Function pointer to directly update hardware pending state after the
+	 * VGIC shadow pending state has changed.
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
 	/*
 	 * Function pointer to override the queuing of an IRQ.
 	 */
--=20
2.34.1
