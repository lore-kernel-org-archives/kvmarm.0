Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF14D3218A7
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032181; cv=fail; b=j2jZODeVTzVEkkxriWj0yJpqkH0RnoAwvIK9k/PXps7Jww8hPWC7f4UG2X2gfAaLwrZm20fRsTmx2Q7W8lO2Q/LFZwvpPWPjw6bvBj7LAhKsyzmLs+9AgZQlKye8bbRzqsLlU8gl/m8krIldUT2QkJ7H+BR/13vRCKmve0k4iUc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032181; c=relaxed/simple;
	bh=+VuAsUwJK1cSv/Vv8PPIfiyO4TYXyrgOCOIVgQnDW3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W4k5zkEXnjdeBdZnZCmHz0HRyfY/Cw2H/OCDJF1MZ0jErYJx9gJfLu696BG9gOFMwZc7CnN63wTbTf1kndU5U8obNo6KBWHc0qhrK1nLVaR4oaN04p6RDLIbYFZUggQaajVcHRustR0slC19ewkJKxxg6XtfXzVmo98k+f7hjm0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DDGLUInl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DDGLUInl; arc=fail smtp.client-ip=52.101.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DDGLUInl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DDGLUInl"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E7kSt14wKefj75ZMGWJriHpIucMuKNmQCO/MgckJRJaXa/03V5HZ7IlmPBf/pzvbF+Kk0PD1iotSl5XzmCQYGEFpJ9p2ZENF1VP023M+G+nVU6gKtWNsz2FYPL6ccsptLsdfERMvsxQ1H2GXAymXrx0Gk7dVG1wU8Pk3lroUExHK/YVezc3RcqHPpDQH4iCg3R9zGUlqQXxJPVM4h4LlxDg7DSaYHkzKVu4V0S9oi3L8r7b94B9gtbV7hY75ymF0nIhTQfH28ZU38DdETO/BKihkjp/yVXJDNtSGjw71hhr4FlPJDGUBCbbSm/xkTemj9P4yTSsNbjq3ZG+4buWIMg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qo1Lo2QtAlaH+/HEEAdlQca2AgE1bR5iYAUOvNKzACg=;
 b=K1JxDFe0NGx7cSbAgLTMqKAQqSmi6/Gc2h71hzFwZhw+9b1mih4qBats4lrBAILsfxcEstdN0DlPwFxLlQBOzES00Q9titcoq0JEGxQbbKwB/Dg/cHdhT4Hq2mQxLz4GTU09N2cVuDiv29fFwjEN38nDSreuptDGKV7IGKe0Q9upsW3tzgFuEDH8EpAZEowonK3OzCvln53xK75j0mfNKIc/zHzdE6KCtQ3M0VJXudQ3FMYUEUuCxAYJp2P0q2QyuxqQVsP/uR31EY2BDIaqv9BhZiHVXjn/UCNgkXyUJIYD/ErGiiftuSybd2tp3B5BAWpPVrR5CAlzeZMfpweTjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qo1Lo2QtAlaH+/HEEAdlQca2AgE1bR5iYAUOvNKzACg=;
 b=DDGLUInlibyRyMxhufguyAIAtZTDZX9JUdoydwWePqI236zCWalGnRVi8I0j/us11zeT8lmi/Jvc1RHypGxh+PnpYiFRt/642g3Y+4fFOAf/W42Jm/GNgIq+bCv04ewotxCsigesZFeDCFcAfSX3jcquep2NjJEPix10CVvlncc=
Received: from DUZPR01CA0192.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::15) by PAXPR08MB7365.eurprd08.prod.outlook.com
 (2603:10a6:102:225::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 14:16:14 +0000
Received: from DB5PEPF00014B98.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::a4) by DUZPR01CA0192.outlook.office365.com
 (2603:10a6:10:4b6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12 via Frontend Transport; Tue,
 16 Sep 2025 14:16:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B98.mail.protection.outlook.com (10.167.8.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 14:16:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xH7A+OZDHkjdwMypstr4CV4ciWWDr9GJppoS+qnyvWRs+oXHPWh6uLibV8J7LHp18aslHn7q2t3/H7+wYYvc+/lTHG5lx/+um/i221Bb70BOfrA8JqcuDb68dEOkmm3CNLj7bJ2EhdzZid/9gxlYFAh7Vv6hIrxV5nW2qqv+t0wAewsaW5/KQkS4OdT+rJVAARdZIdDjDw8P+fKeljugIv+nuo8eTg5/2MYOZMQ6jeThzeKpuq5MW6meDfiMof9GnashNgumeeabnd8j1tOZ+XPz8S9fQOJBrTi5e7vnvbA0oBhSOHQbCCe+WpUcIb8F+v51XYHej/C8FGOICKx+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qo1Lo2QtAlaH+/HEEAdlQca2AgE1bR5iYAUOvNKzACg=;
 b=t0y1ETUjUrkg/mAtgQ/JbiZBwxqLA3FmL8O15RXEz/KjBx3imOPXnoVt/W+NayPRLPURwVknQ2s7MdaatLgtHzz5RBDz500TKdX5QMKDlTI8hzJUel5xHs57ZxMaa29M9MUO0Fu5ziXtCIYOIMbv2r9x6iTBoEA0NZnJB+41BuEDuXgK2q7uUKv+ZiXcF67BdocEOh2IOetf2JKZ8uNTAueTUPt5IQC+7SJBJ0Ib/yDXWwpCKci+pBD9qcFZJ+IeZMClkrl9LZV5B+RYZmpEIbxjsihumsWg9aLDyATw3w+ph6tO/IOSzX39Unjb6x38ibd/jyXEMvww1VtBQObUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qo1Lo2QtAlaH+/HEEAdlQca2AgE1bR5iYAUOvNKzACg=;
 b=DDGLUInlibyRyMxhufguyAIAtZTDZX9JUdoydwWePqI236zCWalGnRVi8I0j/us11zeT8lmi/Jvc1RHypGxh+PnpYiFRt/642g3Y+4fFOAf/W42Jm/GNgIq+bCv04ewotxCsigesZFeDCFcAfSX3jcquep2NjJEPix10CVvlncc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB6572.eurprd08.prod.outlook.com
 (2603:10a6:10:252::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 14:15:39 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 14:15:39 +0000
Date: Tue, 16 Sep 2025 15:15:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMlxCB1Ob22kagbQ@e129823.arm.com>
References: <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMlcf5oUNZU65u_I@J2N7QTR9R3.cambridge.arm.com>
 <aMllyaObyciHEEFX@e129823.arm.com>
 <aMlp_Covl57nnVoe@J2N7QTR9R3.cambridge.arm.com>
 <aMls+MSR33BRrCMA@e129823.arm.com>
 <aMlvDVfeztaVyOnL@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMlvDVfeztaVyOnL@J2N7QTR9R3.cambridge.arm.com>
X-ClientProxiedBy: LO6P123CA0060.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::20) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB6572:EE_|DB5PEPF00014B98:EE_|PAXPR08MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: e31d5fa6-b0ab-4eb8-4d3e-08ddf52b9765
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?MeTQ0sefc2iukQnHw+rTS2wypidHe+Sym/W6bX39Im0q74aS7dcSB14x0MYF?=
 =?us-ascii?Q?FVShgvi0OPpjhnTOZd3AoO5hzQkRUDv/8lY2stxSgZFGK7PNjRs5o98L8zQ/?=
 =?us-ascii?Q?qPR9itGHhwXx1KZERnrx1Wm2d8qgA0dOUFPIY6r9ZSwf9rRKLZZZaFQOwy5p?=
 =?us-ascii?Q?/as+G5ALNzSGaTeIvupMwn1luPHDnKi2JV0haUslSK3RHA+qva+mxGKwZ9S/?=
 =?us-ascii?Q?BX6Zftjxk4fGg4K3UW4fimuT1F1NyyX1RjvSDnW94AlzrEZvbQ9rlKYWY1A4?=
 =?us-ascii?Q?cFQ+J2o4YD87flUlYQuGge7+aMZrwX3vfmdMa2lbX2vb6Q8A0YrGgHqm7A+y?=
 =?us-ascii?Q?6CR5Eedze5PppHo47SYTb+2dOlusauFJSBDDUbz2nSOrMNZ+8IMuSoofmahR?=
 =?us-ascii?Q?Uz+0lQpCcvHUAapdOXsxO5MUX8mfS69P8q1QvLrzcTbeShZ6PB1iaR0q614V?=
 =?us-ascii?Q?3NmyHB9CHr6UQuK3JvGru24pGdZaW796vi3LAc8TPPcAL01najcpEVG26zGo?=
 =?us-ascii?Q?P2uYRclzoQ+tnUOgILQORue13rNVrpGKuTK0pAsd7Vg2DDPRfl1sM6zkeFiS?=
 =?us-ascii?Q?WFDOmQHUsdiwxAwRs/wdFC7PQ1bT8G00UKBAwrxNw9SRARjKW1ibhpE+GV99?=
 =?us-ascii?Q?1R0tYcZ/bcVCjD621px5xe810bEGjLP+6o6UcKwAO2dLX9BvMfvIrG1rTPKM?=
 =?us-ascii?Q?xIzNfJLlDmgaT3Pz91kn5/7aLBIxXvpMEo26Uk4n8OLQ2Sm+sWkaevEIxfOO?=
 =?us-ascii?Q?iLh99r5mW5/uivzga2Xv2GpTFVqE2mIMe1CtoLO163he7eaUUI1eqnhjQcVP?=
 =?us-ascii?Q?z0Rq+a1C1IqlyJBe9tmmeRA44toqsbiKZwsRAcYgQKfr1wxVPJEYiDeA4mXq?=
 =?us-ascii?Q?EaidkasAr3aai8G4VY8ULQ/0xXTtXzf9/SXPZFPNTGYpLfnRW9xQwBzCLqT8?=
 =?us-ascii?Q?18L7czTvRLlSUUiwjM+Po1pB76HDBMYPrpuCDU/7pGENLwxmo7fhxRTBMeyl?=
 =?us-ascii?Q?LKtF0/6QZIqNbmmHpTqrqyEzDs7ocJU6SLLW1X1l0Eh+MjgI8pKfkB0le+Tw?=
 =?us-ascii?Q?sTvlfOqFJ63Bv5vc463FJWcZrOJKwSmZ+b8v0AqI3NZjA8m4G10DbFt8Pacv?=
 =?us-ascii?Q?6srx6A0QZwbWMLaro9jJbPBklE2XKfkAlY7Azo0cKJkYODDczr8fPpCv8Tf3?=
 =?us-ascii?Q?z+VPYNfPyC/UNZ8yd4LRtl1ySxSE+ovA/cxzSq2ZMAV8oUwQP2wvYTPV0YW7?=
 =?us-ascii?Q?svFdw9orwt789xGWsdaQmNEcKfMNJjg1q4OQEBeYk0LXddDjTxXv8bTndY9V?=
 =?us-ascii?Q?mI/qAVQKmVEaDi2lm/5NyBDF+ge8rN1r/s2gKWcj7VoAhe8WTLeL0yqNwqGD?=
 =?us-ascii?Q?ZH5rgxruSgws2rpnyO+krWdSj5UyShLQAUwIYbSPtBrLvzlyMaq8S/C+JRbu?=
 =?us-ascii?Q?UwwdiFAX070=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6572
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0a0a5ec6-3f90-452c-693d-08ddf52b8385
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DIYjWHbGkjwYRSUiJXlu0OBA9t0iAv1fCRL0jT0WlFP7y0omsb8xRUV8kBap?=
 =?us-ascii?Q?N6MJ14H+BWdxsiJVQqWuNnuToPtdkJCyM8XTPw3VRs1q3ffNXtQ7K3gxcKo7?=
 =?us-ascii?Q?FliFjLM6NFmZ+6bLhn4gk25SSaJzkZrMEkhY2cM8u0NmUha3j6cIrstwKCt+?=
 =?us-ascii?Q?WteCyPof9jedh0SxXL33T6ivG7uqxSyEOZcIIHcNoYcmwXWzsfoE+GY/MZQk?=
 =?us-ascii?Q?OxaGbxKj8LsGH9tA2eRAb3AZ4pSRu5e8rz/2S8GQS9MBWVXmn6HQlagHK1ci?=
 =?us-ascii?Q?mUHiqWmTwKZdH9M0K7vg15IRbsFJ721y60RnP1/sFd4Vtt3EBtViwSy4xfoF?=
 =?us-ascii?Q?GgE1xWJNLWmdZweJGbOay9FrdVDC7HTYjkl9Dm7lwh7Fiyl9+Ycf0IyIXubX?=
 =?us-ascii?Q?WJxzrB978xeUcASa+xzyyQse1QSHdLm+T5WRdzfg/RYv4vghWv+aCZ5DBKOp?=
 =?us-ascii?Q?sNRGurQakxj//uK7XdWSm7zumcCvjYtqOXNKxl1NNVvqlkl7ca7C4Ojf5WlU?=
 =?us-ascii?Q?9/SPGV0y53WcpTae3sqQzMAyziGliIMnEnxXpmUZ8uBRRnkcPxL1foNGF5oT?=
 =?us-ascii?Q?c8EVJrsGCpztn0OxZiDq9mWTkPo1KoVlGLX7tgUNxDohbjuGPD61I0R3Pys2?=
 =?us-ascii?Q?feHf5ZX3aMhdzqG78E5xtVUNw3gmPyN1Cn0SM801bBKy9ahK85Z+HtVwsIAP?=
 =?us-ascii?Q?wMyqOUJyJ6qmTKizZBaup32fe3YWW8kFVXcEBGTvxUzPg6gCojHVfaey8umb?=
 =?us-ascii?Q?bNmwiW+9vLQb6ncB3a1Px2EVuiEbiMnRZCvtbqGRGMT0heh0HiC7OY3f1Gxh?=
 =?us-ascii?Q?uKgqnxMLNjynr9L62iFjsJPC7HnZkXgLq7oo+Bf2L6AIY8tSl6P2fRRYtXAV?=
 =?us-ascii?Q?V5wsGxahQ5tpdEm9gPtKPt7+bEh1GMaIeq/G/PR8ObgAdWtOe+cqLkRI0NUb?=
 =?us-ascii?Q?9uEEZ1kfDbV/yj6TJdUo9qAgRShvxUIaeTx+OyOdP6jLjOjsIxlad65OD9RC?=
 =?us-ascii?Q?Xr+FbqJRJPQaBrXkHvL9z+2lJ56h67puKs6p2W/JC9KK3Was2YUuzLkVpzCc?=
 =?us-ascii?Q?IhPhLOkHb4LhDm0e3AOxEN4UimS2jYrKBTRArPdu1hvaZljIaL8phnd155Kh?=
 =?us-ascii?Q?7wsuJg8n7qSpfaGEoPEhTcmBoGR/lavVmffOWcKjEUKLZfMoGI2aTefNmocs?=
 =?us-ascii?Q?wTsa2zApVRsKvYjLoMad+GHHl17kSsKhsAnuNiyzwmsZ6+y6UyDkrAerQFq4?=
 =?us-ascii?Q?cUsLo17h7Y7fv0xkx8/7tYCuMd9A+4w4Wyywx1owbcRoUlaqaJbXp/ffE1yq?=
 =?us-ascii?Q?DgmlAUh29uke7VuQvA6WY3DqLUi0iBelsM6rzyXMLOnnzW9TMae9SbF9ikfW?=
 =?us-ascii?Q?CCgcTRRdiachiHo+KC79DhhSWv+Y2t0yLgvPQSiqiv8VbSBaVs4GlcHq18MZ?=
 =?us-ascii?Q?+tEPvf9tApRXQlvj67UYj3WosLNTbAqeuw3+oMwStpGlmsPYCv2olUQ7wwHG?=
 =?us-ascii?Q?KNoK8c4ppb+rlPQ0ip3xcN6wZp2QjmCzdY6l?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 14:16:12.7806
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e31d5fa6-b0ab-4eb8-4d3e-08ddf52b9765
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B98.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7365

On Tue, Sep 16, 2025 at 03:07:09PM +0100, Mark Rutland wrote:
> On Tue, Sep 16, 2025 at 02:58:16PM +0100, Yeoreum Yun wrote:
> > Hi Mark,
> >
> > [...]
> > > > I think it's enough to use usafe_get_user() instead of get_user() in here
> > > > since when FEAT_LSUI enabled, it doeesn't need to call
> > > > uaccess_ttbr0_enable()/disable().
> > >
> > > Regardless of uaccess_ttbr0_enable() and uaccess_ttbr0_disable()
> > > specifically, API-wise unsafe_get_user() is only supposed to be called
> > > between user_access_begin() and user_access_end(), and there's some
> > > stuff we probably want to add there (e.g. might_fault(), which
> > > unsafe_get_user() lacks today).
> > >
> > > Do we call those?
> >
> > Yes when you're available.
> > As you mention, the difference seems might_fault(),
> > But I'm not sure whether that would be a reason to validate to use
> > get_user() instead of unsafe_get_user() taking a increase of instruction
> > of "nop" -- uaccess_ttbr0_enable()/disable() in LSUI
> > except the reason for DEUBG purpose.
>
> I think the practical impact of those NOPs is going to be neglible, and
> not worth optimizing for unless/until we have data demonstrating
> otherwise.
>
> If we want to strictly avoid those NOPs, I think that we should do a
> more general cleanup, and e.g. have variants of user_access_begin() and
> user_access_end() that do not mess with TTBR0. I don't think we need to
> do that for this series.
>
> For now, I think that you should either:
>
> * Use get_user().
>
> * Use user_access_begin() .. user_access_end() wrapping both
>   unsafe_get_user() and the user cmpxchg.

Understood. I'll use get_user() in this series after
getting some more comments from other about C version which I sent
before your suggestion (Sorry to miss your email before I sent).

Thanks :D

--
Sincerely,
Yeoreum Yun
