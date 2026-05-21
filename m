Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011021.outbound.protection.outlook.com [40.107.130.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D1525B0BF
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375579; cv=fail; b=AqM8KuuFgK7fdrE7agxcTPmZhgkkRz8cM/GzFUXLJLPCFnXFA7AQLtIDeBT32UOTg+p7Fu2Ver9dMrIzgQuUXGls+9+MVbKWVLwRX3uhNW5luLSjICQ6kYpd/r+oYQ8NxRSiX+7k5M1qEtayqtlmOhGpUTZZjhgqoNKQG92owuM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375579; c=relaxed/simple;
	bh=igEcbuD23SwiZhiwHNQQoLYRCSgsyC54ZATCFo47eB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mZ5VHeE31pHRzcrFokGan8AwPXncq0sfC4NEmKyj9ZyDPhdninubDVwtA0/Rcq6ihP7UDp7kDNwJrBBjXb4YP6k81x+k9RLevRKnRaTLqb3Z1qzM9JQA57B9Fp2+ATbnfeNWjwa7esftz/YdkQ3P8/IFyQT82ub2KZJn5EgRFcQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fvNkwLzy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fvNkwLzy; arc=fail smtp.client-ip=40.107.130.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fvNkwLzy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fvNkwLzy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OPa6WaHcVJZPtp4B5vrisTiB7GUDE4rMCkU9JANx/mEqVXQeHsKI9Bsy6K6p55Ii6MoY0MtoohQyVJ8H3HMySotwULG/1QkHMpn6+thf0RSJ6a6zRxnTW6IWLs0zNnGRCZiY963U1fu7bMNt2OA5WldFCmuEdPUIIwARWa1SNZMuHa7QUirYwHGXkLXEkHoSbe581YKpY1hc+koqaKfkQnpnIrNnS7QWMQxKqHd0MRU3ESGV0OmTD9fza4ELjylkgGuLnc7dVulGVMVL9yxZUu2SELO0oFZdHsDIavWcSZhVfkiE7yq3YYptPCa0RDISfRAVYKcnlFPzJJCIK2PQMg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q20eMfzvfqpOrd78Sj0vfazAg5y8zvb8gpLOq+hOjP4=;
 b=Avk697WP9h+g5S8WL+qNjxffch4MhQL6PrsYEVi8RYC5EG3sqIGDq2wK/r0JsStKZ2OSPxlwdGqriV4RBMt36aGqbA/a5F9tNbgD2I6CjCOYpWiylGuYdCO0S6koHL5cG8fpvmQb/poQvd2pl5Wf2m2sokBKX39RxVYpQPB/qCMcY7xkrjEa5SbXkTIG7nF1obYK71oigwSAK316VjdRDYGB+bBVXkVXaMKIu6cVOwhBmBDkwWkxYjRk4zj4mPdaVxz7lz4rZococxDHuKfnbQm8Q22GL7YEfEzRp0uCosHOVE5htBs5IEtMfoQNtD1R7B682AUtLI8R5wibjA3Fgw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q20eMfzvfqpOrd78Sj0vfazAg5y8zvb8gpLOq+hOjP4=;
 b=fvNkwLzyc3t4mAzC0p9b/joxeIgGN2yYMtYqIGIKfTah+WHC8U/QU5FaQty2wgPBbLCZglpjIWNdBWsycKTnKI88BPZQEW0RLIqziQbkkCvxyWrrA0N2zqhhsPWDrET3c010iU57psoeFZfUUou/fKxIH2q1mBVDLxun/fUEYaI=
Received: from DU2PR04CA0297.eurprd04.prod.outlook.com (2603:10a6:10:28c::32)
 by DBBPR08MB6316.eurprd08.prod.outlook.com (2603:10a6:10:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:59:31 +0000
Received: from DU6PEPF0000B620.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::e) by DU2PR04CA0297.outlook.office365.com
 (2603:10a6:10:28c::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B620.mail.protection.outlook.com (10.167.8.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:59:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7bQz/GWDKadnhixnKRK62icwqLlkoU8BmECQ1hAHYq6Y1hoCrFPSPNiAdAVM6X4dJSNZC1Q/82glRDI6F02QAOq0hoUovmfEKZ5tam76dzXsJFj+pW8PQZGyih6e9FIVcMHdqnGfZiVgXXDQU154yKz9w+3Q+GJODW8pcS0xKkH7TZjyWmQ5xP3trMjOaa27qBwRxh7t1BhNzqmuUxA8SKFSXe21teUerEns8DzRi9sji1cKKd2rjJIawhBN9ij3iJ6pgYxkSAcpzQdVHkNuRZSHvnFieHaOd6Z623Fk8eXIB4e0JLxOEPVnQO9pZTwa7WujSvq9Dn0WezcsWk/6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q20eMfzvfqpOrd78Sj0vfazAg5y8zvb8gpLOq+hOjP4=;
 b=lwj5yb4LH8CBLVskPeRLJCuTWIjmDBbqtIrBxlidsNyKNrrDejdbgskeX1uswmk75pJgwaQhUB1btWQX6ZQdvspUb2plI6gVEk89xMRwDJoI52xpEwzD/xPicMjpVlHohEHU29AveA53UtCRAObtlsjbuY8NUitxwhKbliYbG2wTuEG1rSof3kzPgsDOxivXb+Zwp2oE8Ydt6hVajKVbV5vy0IRMwLjmBMPpyTldBl2J0qUUHyaMlgJINP4/yR2P1gmNDbodbVyR5XcgbKtTiXqkpbtb2UAqKKWSPtZLosp5Q3OZY7FN68IsHMRei5l5MMy/mh+VEkqZ/eNn6dAKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q20eMfzvfqpOrd78Sj0vfazAg5y8zvb8gpLOq+hOjP4=;
 b=fvNkwLzyc3t4mAzC0p9b/joxeIgGN2yYMtYqIGIKfTah+WHC8U/QU5FaQty2wgPBbLCZglpjIWNdBWsycKTnKI88BPZQEW0RLIqziQbkkCvxyWrrA0N2zqhhsPWDrET3c010iU57psoeFZfUUou/fKxIH2q1mBVDLxun/fUEYaI=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DU0PR08MB9608.eurprd08.prod.outlook.com (2603:10a6:10:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:58:26 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:58:26 +0000
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
Subject: [PATCH v2 27/39] KVM: arm64: gic-v5: Track SPI state for in-flight
 SPIs
Thread-Topic: [PATCH v2 27/39] KVM: arm64: gic-v5: Track SPI state for
 in-flight SPIs
Thread-Index: AQHc6TJHcBqEEN9nJkekEXSXW9gZhw==
Date: Thu, 21 May 2026 14:58:26 +0000
Message-ID: <20260521144846.1899475-28-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DU0PR08MB9608:EE_|DU6PEPF0000B620:EE_|DBBPR08MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 83721976-3b95-4c97-fde9-08deb749900d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|38070700021|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 jkBlHY53hYAOLaBsPQrKwXwPmWg0E6TOCojWyaWegB6Ekh1ILLGbmQstl4TTz1H7YT2KblfwH+D+9r+TVffvaVMg/bC08EaJLWKMab91gUqGgiioamwjsNs2gyVP1oSa7cuUAm973W/OYKalK/PstpZzpDpuMp0btkrweUXusY0nsQNApc3M1gK/6vOQF3RxrSCTZyZ/Fc2kuv8XaNndY6mx2+PQcvE+ehSvMU++RSH1WvMkJqi1u3c0w8GVEZ4yFsydWOCSXNUZFlHdbVtBYeey3dHcsH2xnYkYiZUi5lCIcEzpDW1ga2n3p6DQ/MJFREPw2an6c1zySFxiETLUZsr2h6UnwUoZ3d1hEsUUnfHV8MOafk1qbMiu2IjneATKw7JSXEUfVICfsiGLb+hQ/9M2Xgf72wHxfgGryQjSQnu5Bpx4LrlL7qAmF5POHHVXA6p4TCIM8f78pl9qc50u2srwg2cFXv5DyP2b7SqYPOAeDAJBId+9mcnmUnHLtCrg7G26dS2GSkxjSvN2tGYx8x51jFjGZnq60jZUmyA//lv+C4GN2+mnlPWF7KWURbrBUaDVqREfymoBmOiJ5cV180WiEFAChpEc2TNXrX04R3ScD47mHSrrGlQxb9Jo2wxNd9/SCPwdVYc2WLm6lsL1fc9Y1jx5sS4FQaRgD9f5HN5oBD1J5H/pjN1kAbMk7P+ILTXoG0xUpPa1iuTxrvl3QThPZUsbL1+dLJzP5Kqg5yLbLVXtAPp29RIeaZJJohCQ
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(38070700021)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hUkium02GJM0JT6Y5W58RaVkscNulISwFEik6mmN8BVmi6BymjJ/5cv/RMJ4igjRdLhJsQQLH9cLQc7p33VKVH1XOH48RkaX2Z1GxHUTxdaIC0chb3BP0KORl0s3pJkWBZ+LAPgoJ10pfvNck5j3ayLDA7ohKcsHPmYWrN0ECgDiJfdWZEOlO+IxUvJr/PLMYoynDEOpksslJriQdgRtHd6m6BH1AyNxOY4qu0rldd+WTvkOdE84aGemrUkxGny+0AiO5Sw1SwiaXqGyblVjCFyH3SyCZeVF/r/l6Vz/TDC4CT+uf2El47vPlJBe4vx3mQkl30A8LyoP9PxCr7bkag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9608
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	54a1b8aa-bbd7-406c-629e-08deb7496986
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|376014|82310400026|22082099003|56012099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	ip9nuFThMmYO3U+lG/z6NtnVjiD6KUeA6c1A1PTQY9J2Zg8QYpa70+kBpwFU8XWcyb4l+H0/K4h3N5/7+IlI2RAukd/QC7B8wMcBI4BXJ0AuftZfgnZqjitspDZGk6ZwsG8REzm24dGe3n6nNznYvgcwldJn/26f8kWu2EBejol6kyWgPPb/bsjwUPRxatP3mJ5/YHBdrTxTecKVr4XO6eNh+jXu2aiQgsuseeA/YTGDtaUajZGJjlBXZuTYgYV4Nl9hqJLVWRvByGmw3TnSGAFi9Ko4ILOx+8xpg0ximCNuo610BJyiIIA7Vg8Jwolr/fxNyo6quHqUsk7raoD/BRBY1VHwWuNkeM7Q+PAnuty77dkKvjFaMU6y7eJDuh0FNwzbYprsIgXHFaEejuLJJUXY787yv+JC0MA4njfksMBjApUnRgZqHhwGPyZcj3F+dsGk0X82qLdnEag3aEJofgxNr1Do60gdyyJsztsL68deauoBz0GgcwSGLIBc+Pf2OUGzJ4q8W8iFDAo65drCY4NTVbfaBLG77pSiHwHTK3LJgOsiBQXZTamCnjNMfy3AnVjdb7WW1/IzcmQEMKIkoMj0itzb8wVhajwdSeBbsEgGxdC4Zr4XleDnfoegcVsGWaJHUC1X2/3wGiswzDh2LaSyQFHuotxRV2LtYOiWpGEd4oQGfFuhyRRlBetqDczSw7Nu/3Xy6fvHtwpOtisw3+xPht8Iukzr9qNG8BMLuVE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(376014)(82310400026)(22082099003)(56012099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gc8gxKYXkGyBOX7pNUtntC4BAp0CroERU68oEUkU5Q1nWytT0ZtN2uJDXmO6QnZ2nA8smzhQHts+KbiH+VEprViZ6Ii5GiP+PGJ9vZC7SND+F6hfuTaMRQrFdc06BoJPH0TnAHmP0/8mhsIxKwppSB+KPN3St+t46Y41AFt70S9Sk2GiTM3uB3sXq0Q9N28l3JJpXLG17ipjMEigKzJm7Lxd3LnkpsZGIgmc5k+tIfOa/Gtk0g8YcI/dlCXnHdt7liLwwrAf8FfdSkFNsri5IQIzdLTKCz5BL0+IkxCjZAq5L8tSB85YSwOBC7eB0mq/IYXpvwEutRf8LHKvQxD+yxmRnahjT1ODcVYOcu08ynMy+flW8OhT+NPsm7VdfbwCXj+Ng9rmpx/f+FfZ7pdiv2iFzk0JeTvhlkHnV6zDzm9OrwMTDVDtTvnyqVBuGu8K
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:59:30.9391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83721976-3b95-4c97-fde9-08deb749900d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6316

GICv5 interrupt state is largely managed by the hardware
itself. However, it is possible to register a notifier for the
deactivation of an SPI, and hence KVM is required to track when such
an SPI has been consumed by the guest in order to trigger the
notifier. This allows the code that registered the notifier to be
informed when an SPI has been consumed and deactivated by a guest, and
that the guest is ready to receive the next interrupt, if required.

As part of folding interrupt state for GICv5, which until now just
included PPIs, check the SPI state.  For each in-flight SPI (an SPI
that is on the VM's SPI AP list), use GIC VDRCFG to retrieve the state
of the SPI, and track the active and pending states to determine when
the SPI has been deactivated by the guest. This needs to happen on
*every* vcpu exit for *all* vcpus belonging to the VM whenever any SPI
is in flight. When no SPIs are in flight, no SPI state is queried.

When an SPI deactivation is detected, kvm_notify_acked_irq() is called
which triggers any registered notifiers for the SPI (and is a NOP,
otherwise). Additionally, the SPI itself is popped off the AP list.

NOTE: there is currently no way to query if an SPI has a notification
requirement or not. This could be optimised by introducing that and
only tracking the state of SPIs that actually have notifiers attached.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 59 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.h    |  2 +-
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 458afdbfe2938..5684b65fa9389 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -969,7 +969,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
  */
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+static void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	unsigned long *activer, *pendr;
@@ -1041,6 +1041,63 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 		    VGIC_V5_NR_PRIVATE_IRQS);
 }
=20
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *vgic_dist =3D &vcpu->kvm->arch.vgic;
+	struct vgic_irq *irq;
+
+	/* Sync back the guest PPI state to the KVM shadow state */
+	vgic_v5_fold_ppi_state(vcpu);
+
+	/*
+	 * For SPIs, which are on the global AP list, we synchronise their state
+	 * with the hardware state. If they have been deactivated, immediately
+	 * pop them off the list. The notifier is called without the SPI AP list
+	 * lock held to avoid deadlocks.
+	 */
+retry:
+	raw_spin_lock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+	list_for_each_entry(irq, &vgic_dist->vgic_v5_spi_ap_list_head, ap_list) {
+		bool pending;
+		u32 intid;
+		u64 icsr;
+
+		raw_spin_lock(&irq->irq_lock);
+
+		icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
+
+		irq->active =3D !!FIELD_GET(ICC_ICSR_EL1_Active, icsr);
+		pending =3D !!FIELD_GET(ICC_ICSR_EL1_Pending, icsr);
+
+		if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+			irq->pending_latch =3D pending;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(pending || irq->active))
+			irq->pending_latch =3D false;
+
+		/* Deactivated? */
+		if (!irq->active && !pending && !irq_is_pending(irq)) {
+			/* Use raw SPI index without type for the GSI */
+			intid =3D FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
+
+			/* And we're done with this SPI */
+			list_del(&irq->ap_list);
+			irq->vcpu =3D NULL;
+
+			raw_spin_unlock(&irq->irq_lock);
+			raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+
+			kvm_notify_acked_irq(vcpu->kvm, 0, intid);
+			vgic_put_irq(vcpu->kvm, irq);
+
+			goto retry;
+		}
+
+		raw_spin_unlock(&irq->irq_lock);
+	}
+	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d56e87a0d2acc..d628eea4cfa4e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -855,7 +855,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(vcpu->kvm)) {
-		vgic_v5_fold_ppi_state(vcpu);
+		vgic_v5_fold_irq_state(vcpu);
 		return;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 282278e4a6c19..7eef8ece52dde 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -372,7 +372,7 @@ int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
-void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
--=20
2.34.1
