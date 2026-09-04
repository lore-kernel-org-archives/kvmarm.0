Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013020.outbound.protection.outlook.com [40.107.159.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D6648BD56;
	Fri,  4 Sep 2026 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525471; cv=fail; b=eV2uV9fJwn8GT5BDh4+R3C/LqlABR8NPjRYJcPJZ2zWtAkVVfo3ER4+4fHVYE8mjKrm5f2PDkCvkm1fj7KltMcBhvyDGt7pE3HE9he20ZtF1b6ZvYnSmFtzd0Co+VomzE4CfwidNcfhhUUW+VusApqsKsgLXm/blwpSy11ISFlQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525471; c=relaxed/simple;
	bh=vDnI3lm65fMbvv+87t4lXugePst8My+pVuO7OQ2tUog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uss0UkwTVmeWchEcAThSMWktmZatFagkfAGms2xGdh2+tB+FxxxDRRUqjjp8rX8wE5i3QmRH0w83HBiJRmCqUNGgzu7CcApRTl0cVgKkKkkVEq18lWv/azQwTAFIWU4jPIzDNhMoRgeXaEkL9QyL9KnHzQzsgIjhG9cE4W/qE2s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UPO3gjxJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UPO3gjxJ; arc=fail smtp.client-ip=40.107.159.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UPO3gjxJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UPO3gjxJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PvYVxsi6nKn/znRJxlUI4B7XGLRRnLtgKJUNwqVFWdpBaHxystMrT+NfHBF580Fg5nsy8c1RBsFI4zekvUBj4pV5/Xn5CLEYzsgMxnq32ZPovKQnOKeP7DTG3U+Rj8w7joL20DdOrdtecpGY3Vmc9nj91k1w22NzDB7LCdrJOP89YIqXlpJDB9FIDXW4pdWaT5iv2xsPYDZHeYUtgvM4dEEzuDrfJx78Bp7AQqBanPjqKIbADdRs5gsWsKHrxVdXyuHG5eE6NOhHtk1H9mA0hcm8M+6UQNQaj3rimRx8pOZu/p9vR9y8slerInyzaNg5iE5DHd+yde9xa1vq+rvNUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDnI3lm65fMbvv+87t4lXugePst8My+pVuO7OQ2tUog=;
 b=eq7fngwBYCRWuVwqPb2qjBhfrxpfA9JpnvJA9bndPFP1PCAE/Re8/YtmzUybkDsK8SomDiQ2fUQ2ExkHXPVDzYPUbY3FGQfrVbgIOOdd3aI9Psnrlt1BSvT1uyL/iNPTa90PVdvQPRuW6rRmtlH5sgXhK/OYSK9gK8AwCBgh57N8zTgLCLw+X+2w8itnJic57tjl3FjQG22jUH9MXflZ4SK4yU1PRFWEuQVGwUd1KnUDvRNwUFLmxqSv/lEp1F3GQ/0l1/hsltk/K0z5vbq/rWs0ZSp4v7/PXr69GNVDwtw3GI1NhFc9XJuUrJNLzovxbkng8oedsiKyr6ykl7mNjg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDnI3lm65fMbvv+87t4lXugePst8My+pVuO7OQ2tUog=;
 b=UPO3gjxJd4ZNzMcA9lGCgcRitRFeLmw2Px1gVtRShYQ4a0fEmH4swEG1UFjG05Xv5LBmENhLnaLOefpBP1FkjufM6G+TR8/Poo0hRyqvAyZbj6GQhDET2HjQk6BAUZVS744NFeuY/PSC8WPxN43wsPwyJqVbD8Enn0AQ9R44hOQ=
Received: from OS6P279CA0156.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:39::19)
 by DB3PR08MB9133.eurprd08.prod.outlook.com (2603:10a6:10:43c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:37:44 +0000
Received: from CPH1EPF0000051E.eurprd04.prod.outlook.com
 (2603:10a6:e10:39:cafe::a0) by OS6P279CA0156.outlook.office365.com
 (2603:10a6:e10:39::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 12:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF0000051E.mail.protection.outlook.com (10.167.241.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 12:37:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPtyTYEnfxHD1A4+SglGGaTpc7S7UExAy/9NsZTJR6+FesD/WxVl9JFfVe9VDoFYo1e8xgaDL0hG/i/jLCSsrvKf350aygc7V/Ata5SzRn3SxDEno9nH1t0G7OWWH9FM+e5XKLT1EYDlvvmNuNfeZRHqjs5CSsS+0ANHxSsZTn2U2wPtzp5wPQ41HXT+42GxPBSRnwfEvMkfxllMp3HH4F0IPmyX6ZemRpYd+ayD0MFRXPXRnxywnWiJ6z+Bx8ovPsSN33gwORXPRuLEWPkcDgY2tZs2UiFrtv8Vwn4PuUNzoDWNMUT0depz/mxjlxCeaWTvx0PYaaEPQ2CIL30+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDnI3lm65fMbvv+87t4lXugePst8My+pVuO7OQ2tUog=;
 b=QdA2yWXs3KzQBSGaoKXaA1UHYkSx/dj81940PY0vch1pRsTsnRTjo9bv1VNjlx9DDENQU43drV+bREXIH08hTGNhjxUKeYY53jTafF00xFLL3E5gobUJ5Ri0f/02k5+eSsO4S7m9W5lZlKOrpn3qWJEp0w+PTAdeh+3q/nzQ/1USMd22iOixVkS6U6ORWLJe/z11mo/OMdE3ww9kf1RHrnEMcj8NNbndgWuQNB2Ri9oG7mBLpQOZ1oRtysQPKBaR09lfJ2KrJjBd5/DV4RBkT2GIrmRpujuiziT/+tYo4Ss+mDo7lAir1ZkVZZOioJMS154TX/gdmbA8UkygvrRLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDnI3lm65fMbvv+87t4lXugePst8My+pVuO7OQ2tUog=;
 b=UPO3gjxJd4ZNzMcA9lGCgcRitRFeLmw2Px1gVtRShYQ4a0fEmH4swEG1UFjG05Xv5LBmENhLnaLOefpBP1FkjufM6G+TR8/Poo0hRyqvAyZbj6GQhDET2HjQk6BAUZVS744NFeuY/PSC8WPxN43wsPwyJqVbD8Enn0AQ9R44hOQ=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GV2PR08MB9255.eurprd08.prod.outlook.com (2603:10a6:150:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 12:37:10 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 12:37:10 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v6 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Topic: [PATCH v6 07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
Thread-Index: AQHdPGHQ74/OFJmmoE+ghGrlQpzBDLa+WC2AgAADQgA=
Date: Fri, 4 Sep 2026 12:37:10 +0000
Message-ID: <14a47a452f68cd7d74a94551ace71048042c1309.camel@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
	 <20260904113404.4051341-8-sascha.bischoff@arm.com>
	 <20260904122530.607ED1F00A3D@smtp.kernel.org>
In-Reply-To: <20260904122530.607ED1F00A3D@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GV2PR08MB9255:EE_|CPH1EPF0000051E:EE_|DB3PR08MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b8fcf6c-3e9a-4215-69d3-08df0a815128
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|56012099006|4143699003|6133799003|11063799006|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 7B8ZmklPMrOtkQRZFkj1vrLSqP9yUElDZugABnseWENaKxtAE02R2ynLa4s44J36Z7tqySBupF3qWxChuO1OJyzxGUctJMAGnY0ahZe5RQMYVJgVlDzp6Xg2t360nQzdBOD78yIzdBCRiwbSvJUxU7CIHkUMTBIDjjR7P7+i+9Rp/kOjXBxkDm6xvl9qC4N/HLwtZZgdkTL8iVwJwEox9q+1i4BfVeMoNVYJRJotGKFkNd7QGPY0xMwatTLSeS4oHt9E8a+5pjJBwIJuI0PpJvmF0IRbaTGAguMQ+hkWBZyQxyy8R7uAnf0/A3TrGdJq2C7IAzgc71/6zgv7YC/Oq3s9EqwMsCSxuXWWLTI8D8PEw+wXazU/ZQxMBtzzPjAQGDypnbz1RHmjrQ8HjJYsocZvIeyYK5MQjMZfRr/lLNXb/a54Xc6EcCPjSo1rXZtSwhevVSoShvIyE4mKu1hzczsSZxsdJc9miPSI6lrYqGCKsKbJ+Y+K2wtAVOvVGBLKWesLQl2QlZbzEGCAJMm+6reic3mHRHzv8Uf9S59Jn5eNoT0XN8oeaHvTGuCDfkTfkKudzbAvPMzSVGIO77FPwoAcqG1xE2X398CSz5JkvL1oqsYW4WHIemjE62RyOrs825iBVoDX7KLPQb4j9uR8q3bi/g3BfvfuINwY/EhADmHG3jiTmlLhUuqgb/l26VNMSi01h77lHrw0JR2x57KOsQR+y4bM1ESdHEUTWoKucl8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(56012099006)(4143699003)(6133799003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ADA66326A760040A7ADB46D3374A673@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sE1AfBkrd5gO3XudaUm/CTqpJJzeXA1V/LSfmn1aEkRj+z3NykqCgNimhIupOEGwveBNhKkgQuKH8EpdkYZop8177/zP0mrKMglLRfK872ziLAj6YeZK//fEwD399Nba2Zd24rCPK8jfzyUGskqETLGc9xMCcL/cZFf6rM59zAoAPbqXFgndanPEJqKXQJti4Q84JLDrr5gk9okXzQu4dO2C2J8rlgyC/02Ts2jP+KEEZ/UhJiT/aunRXPsLfoJSPWPUW+GKrBCjrWwMa6Ws3gCx/MnIRsr/IVpecf3MAx+A8D8gr7CRXGaEhXjqRLe0wx+Q0P+xM9xpp4P4AXXC+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9255
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF0000051E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e1a21425-8758-40f7-b2ad-08df0a813d22
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|23010399003|14060799003|36860700016|1800799024|82310400026|376014|6133799003|22082099003|18002099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	CTORaqzE42XqAxtim7jbHMXWHr38bAd3ViA8zitgzY0vi4JYUhmfuvvZiWRHNau4xOpTs0HruZ8YSUZMWPOP4uIJmrb0K28yOupvBixKKibis4xtZdJoQC0HrLlgBZomkr3+rE3V0PKYHjE0z2Ec/U06dQBlu5rakVzHwPrYfgYWW2GymXfe4jAMyj+Yk6Ib8hpTSrcr1OTJf+pQqCAj3OlD8TJmjCX/dda2gjHTBQDmRmplL652tGpfT4o3ZJfl9EMbD/jiRWHSGRyc8cpf/1+0yfsiI6dvCRyGPj94n0//2WrfJ5kyDb+W/pgzjqvhuaRvANNyC+VQ7RIFkdg6gyXWLwXeNLRrvvKacU5B5nsCvJMh2YwQ5u1K9/GL8hcBp5I46vPOFIO87eFn2BF+/aQVzHGs1yoGRWxCzYk7oTlUD2m9hv06eYWsMrkk8jKDXOCCVvpB/IDUyVYL7ILWB4U3dNtdagEleVGBd3StLlpuqNPLOC1W/p9L3tkmG5LSHQMtcQKbb8zBUT2Np/H4RtF8eax0BNng/NFo6nPEFJBl9RlllFznC8jRahjNmP0MBLWv7LVwt/x4xWcd2X5sfGm915i0iqzVt5pJSTnqioV+2/bN2FV44z/Ji6mGF+6PIqpj0M5AjUjy7dDJFtl60bwAmJbNRoETlnxCtS9ho7U=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(23010399003)(14060799003)(36860700016)(1800799024)(82310400026)(376014)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TWqm252uqEg6ernWW9PfR3KS9+OxHkRd5MVWQ7a5Z+oi+4dABF5YSgCbuRmmIB1chjQ6Vwwci1Tz6AaLXWjVzzg4MH8MXCTdtGPS6RQ6Y8nSqYL3QWeBTT1JPJfPsBjHsU6RzK4wAl5Er9BU4ND3Eae45joLY0AkMoHe1V2COjZ2VfJeoPyw82/8bjnxCnAEwq8ZhI63JRyJVxY1YQeaaC+OetEnwUOx6NSzcWgSR/PFlWXS9QtT92TXUWj2JNZNiX9AqunnSQKD4ZhynJtkSypxsR9b2C+YTSyuXOR4b69YjUzckgs+89RQtFdh18RLAr8mtT9JEZK2PQdRNnMT8KNIlxYeRoU+6PuTj6lLgcftApMYpzxXH1wPf67qpUywj3stid0YzFqWNha1pXDom/1lLYwLy5pYK18/kgUZ0TWp570wj2xVpookRjKbswYe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 12:37:43.7147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8fcf6c-3e9a-4215-69d3-08df0a815128
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF0000051E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9133

T24gRnJpLCAyMDI2LTA5LTA0IGF0IDEyOjI1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gSW50ZWdlciB0cnVuY2F0aW9uIGluIHZnaWNfdjVfaXJzX3ZwZWRfc2l6ZSBhbmQNCj4gdmdp
Y192NV9pcnNfdm1kX3NpemUgY2FuIGxlYWQgdG8gemVyby1zaXplZCBhbGxvY2F0aW9ucyBhbmQg
aG9zdA0KPiBtZW1vcnkgY29ycnVwdGlvbi4NCj4gLS0NCj4gDQo+IGNvbW1pdCAwNGIwMjdkM2Iz
ODgxMDc1NDljOWU5NDU3YzBlOThlODVjYTcyYmEzDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2Zm
IDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTogQ2Fj
aGUgaG9zdCBJUlMgSUQgcmVnaXN0ZXJzDQo+IA0KPiBUaGlzIGNvbW1pdCBjYWNoZXMgdGhlIEdJ
Q3Y1IElSUyBJRCByZWdpc3RlcnMgKElSU19JRFIyLCBJUlNfSURSMywNCj4gSVJTX0lEUjQpDQo+
IGluc3RlYWQgb2YgZXh0cmFjdGluZyB0aGVpciBpbmRpdmlkdWFsIGZpZWxkcyBpbnRvDQo+IGt2
bV92Z2ljX2dsb2JhbF9zdGF0ZS4gSXQNCj4gYWxzbyBpbnRyb2R1Y2VzIGFjY2Vzc29yIGhlbHBl
cnMgdG8gZGVyaXZlIGNhcGFiaWxpdGllcyBkaXJlY3RseSBmcm9tDQo+IHRoZXNlDQo+IGNhY2hl
ZCByZWdpc3RlcnMuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5o
IGIvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaA0KPiA+IGluZGV4IDA4NmI3NTc4ZTVmMzMuLmM4MmFh
N2M5ZTNmMzIgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9rdm0vYXJtX3ZnaWMuaA0KPiA+ICsr
KyBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4gWyAuLi4gXQ0KPiA+IEBAIC02MjcsNiArNjQz
LDY1IEBAIGludCB2Z2ljX3Y0X2xvYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gWyAuLi4g
XQ0KPiA+ICtzdGF0aWMgaW5saW5lIHUxNiB2Z2ljX3Y1X2lyc192bWRfc2l6ZShjb25zdCBzdHJ1
Y3QNCj4gPiB2Z2ljX3Y1X2lyc19jYXBzICpjYXBzKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIShjYXBz
LT5pZHIzICYgR0lDVjVfSVJTX0lEUjNfVk1EKSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+
ID4gKwlyZXR1cm4gQklUKEZJRUxEX0dFVChHSUNWNV9JUlNfSURSM19WTURfU1osIGNhcHMtPmlk
cjMpKTsNCj4gPiArfQ0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBXaWxsIHRoaXMgcmV0dXJu
IHR5cGUgdHJ1bmNhdGUgdGhlIGRlc2NyaXB0b3Igc2l6ZSB0byAwPw0KPiANCj4gVGhlIGhhcmR3
YXJlIGZpZWxkIEdJQ1Y1X0lSU19JRFIzX1ZNRF9TWiBpcyA2IGJpdHMsIGFsbG93aW5nIHZhbHVl
cw0KPiB1cCB0byA2My4NCj4gSWYgdGhlIGhvc3QgaGFyZHdhcmUgcHJvdmlkZXMgYSBzaXplIHNo
aWZ0ID49IDE2LCBCSVQoKSB3aWxsIHByb2R1Y2UNCj4gYSB2YWx1ZQ0KPiA+ID0gNjU1MzYuIENh
c3RpbmcgdGhpcyB0byB1MTYgdHJ1bmNhdGVzIGl0IHRvIDAuDQoNCk5vOiBUaGUgbWluaW11bSB2
YWxpZCB2YWx1ZSBmb3IgdGhpcyBmaWVsZCBpcyAzIGFuZCB0aGUgbWF4aW11bSB2YWxpZA0KdmFs
dWUgaXMgMTIuDQoNCj4gDQo+IFdoZW4gdmdpY192NV9wcm9iZSgpIHVzZXMgdGhpcyBzaXplIHRv
IGFsbG9jYXRlIHRoZSBkZXNjcmlwdG9yDQo+IHRhYmxlcywgYQ0KPiAwLWJ5dGUgYWxsb2NhdGlv
biByZXN1bHRzIGluIGEgWkVST19TSVpFX1BUUi4gS1ZNIHdpbGwgdGhlbiBwcm9ncmFtDQo+IHZp
cnRfdG9fcGh5cyhaRVJPX1NJWkVfUFRSKSBpbnRvIHRoZSBob3N0IEdJQyBoYXJkd2FyZSwgd2hp
Y2ggY2FuDQo+IGNhdXNlDQo+IGhvc3QgcGh5c2ljYWwgbWVtb3J5IGNvcnJ1cHRpb24gd2hlbiB0
aGUgaGFyZHdhcmUgYWNjZXNzZXMgaXQuDQo+IA0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSB1
MTYgdmdpY192NV9pcnNfdnBlZF9zaXplKGNvbnN0IHN0cnVjdA0KPiA+IHZnaWNfdjVfaXJzX2Nh
cHMgKmNhcHMpDQo+ID4gK3sNCj4gPiArCXJldHVybiBCSVQoRklFTERfR0VUKEdJQ1Y1X0lSU19J
RFI0X1ZQRURfU1osIGNhcHMtPmlkcjQpKTsNCj4gPiArfQ0KPiANCj4gW1NldmVyaXR5OiBIaWdo
XQ0KPiBDYW4gdGhlIHNhbWUgdHJ1bmNhdGlvbiBvY2N1ciBoZXJlPw0KPiANCj4gU2ltaWxhciB0
byB0aGUgVk1EIHNpemUgYWJvdmUsIEdJQ1Y1X0lSU19JRFI0X1ZQRURfU1ogaXMgYSA2LWJpdA0K
PiBmaWVsZC4gSWYNCj4gdGhlIGhhcmR3YXJlIHJlcG9ydHMgYSBzaGlmdCA+PSAxNiwgQklUKCkg
cHJvZHVjZXMgYSB2YWx1ZSB0aGF0DQo+IHRydW5jYXRlcw0KPiB0byAwIGluIGEgdTE2IHJldHVy
biB0eXBlLCBsZWFkaW5nIHRvIHRoZSBzYW1lIHplcm8tc2l6ZWQgYWxsb2NhdGlvbg0KPiBpc3N1
ZQ0KPiB3aGVuIHByb2dyYW1taW5nIHRoZSBWaXJ0dWFsIFBFIERlc2NyaXB0b3Igc2l6ZS4NCg0K
Tm86IFRoZSBtaW5pbXVtIHZhbGlkIHZhbHVlIGZvciB0aGlzIGZpZWxkIGlzIDMgYW5kIHRoZSBt
YXhpbXVtIHZhbGlkDQp2YWx1ZSBpcyAxMi4NCj4gDQo+ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5l
IHUzMiB2Z2ljX3Y1X2lyc19tYXhfdnBlcyhjb25zdCBzdHJ1Y3QNCj4gPiB2Z2ljX3Y1X2lyc19j
YXBzICpjYXBzKQ0KPiA+ICt7DQo+IFsgLi4uIF0NCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
