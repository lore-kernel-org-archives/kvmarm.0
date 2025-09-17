Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011028.outbound.protection.outlook.com [52.101.65.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADD131960B
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 12:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113900; cv=fail; b=jXRkNxOYIC9VjcBb3lHD0kYfftHnVEuADHWeza0Ghr3gVqM3//gJQIECHFy0WicJRvGO600fFEqW8H1Wqi3Ja0o1NtUSMlJBjTUd3lR1n3KaN23kYIPeVNelB8mXjR/aQK5v2D3i4DrY7DVmfbMdi+z3UysQuHZrUgMkfLzkaWY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113900; c=relaxed/simple;
	bh=HrCoPBDc/vHm6sJG9RyTB+YY7SBIzlw8q9yRK9Zm+gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A12aVDqvUFe7bR8tG/nX4btLWW82y3DxG7YxCuyHrxrLyvZWEHkntTBzudCu+WslW52inyecq/kuT4wgfe8R/UFCcePHAsEX1SZuqg8qyYBWFjzVPgS04h8/ZWAqNyGSSwXVZ/OTb1tydR3aj5L4Pap8LOOEV0OzDZP6fIRm20Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cqwq9QHA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cqwq9QHA; arc=fail smtp.client-ip=52.101.65.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cqwq9QHA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cqwq9QHA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SxHs9eN3o5KZXXvgbBUf8Ei2L+uvqqWVEriW0Bv8urpeED72c+Nomnh9ueATrgqczbf67diOTLiT2b3AC9JhVjXXsTlqlLwcQvZspQvWpQNVkH3uj/AdzJkuN4ts13Rhbi+h50ryztEgRxveYWvm9EzvMTdaA1jv/jnPbVttmfp/RRrkr2nW8kdvlNMGH0jCctLgzU1OyncZKUq/xW/DRuj6G4P8nIFardCgRr02zVkIVF0w7YaSVoFKwTAwSMN0imb6YtK7viavHTrU9XOoCK8xvcKUZYb6/ssASPcodAw+GSq53FkkF9jrvwj/2FieA6EZg5nz8apFovPKKeF6cg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=byMlVl+VM/jf9H52vMnqvo855lXSJI5uhSv1DCM3QZg=;
 b=YSWTJ2OgtAjHUr66EUFuAJ/tWnjmJX2sPGAdce6iHPNcAisfK1sgf2m5hY9IoIKt/wLXuySzzT8mbx/Umsger5aoqIYkQDrN9C1fXROm3vxX603AaWTWqIhz7l/tYZyej/9uJq44DbeJGLttAMUy1ch81U1JgR3bPSeH827RuOcGDl4puOPB6y+ctaSs6yDPLzCuBvQZHqSfslrZLLsYpfO4ToCRv/2wxJpOVluvVG/022rqqU8qmrtdCLEMguehWWH3UYma/D7qcD6y5ATuaBFrupxnih1ZGyWqkLyaa2FDxwd/MxwuBEjL+Un4/GP4t+8d4CAceDOw3tIGx7uOvw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=byMlVl+VM/jf9H52vMnqvo855lXSJI5uhSv1DCM3QZg=;
 b=Cqwq9QHA0g5ckf67Adis3QDswSRUmYJV7/iluDi+CeI19XNeapJf1q2B9TnfPyIUeiSWiCY9k6KlOt6gJOn7a5IiHGmbFNOcbhi3jnRdo9+GlcmyXcQqkW+wiydPprY/0q2i5wsgRHeszcz061IpSecnLQA9sxXpfKZfwy8JOsA=
Received: from DU2PR04CA0044.eurprd04.prod.outlook.com (2603:10a6:10:234::19)
 by PR3PR08MB5708.eurprd08.prod.outlook.com (2603:10a6:102:84::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 12:58:11 +0000
Received: from DB1PEPF000509F7.eurprd02.prod.outlook.com
 (2603:10a6:10:234:cafe::1e) by DU2PR04CA0044.outlook.office365.com
 (2603:10a6:10:234::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Wed,
 17 Sep 2025 12:58:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F7.mail.protection.outlook.com (10.167.242.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Wed, 17 Sep 2025 12:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwrevWLd1smJACHWwQc33/WsvYEJJJeigEqbge8TyiUycBejK8XWDJl1fq50Xwz3uRcdl0tiSliSlc9DVKjf1shTguRjK4KHEsv+ju6DcFBly2cNA1K48yIoeyHiwskl5e7Zm55UuEXx/cQCGAiWp5i6DIYj2XeOZd8GSuGjNiMynbNfHr1dlzkqHlj6F+fm2otVUGzeUNXUOA1zC+rfAh/2Onhptk0GiJ6jGirxJWnLWQhnbZ/GWGhEcONlCguJRjhBGWeUloyQKAa2dMTtumaAAS+z/qa6t0hCLPx7qqGTTTuV5CAMyCBbxEUa0zYzLbquNWLk9GS5A7R9P/Cfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=byMlVl+VM/jf9H52vMnqvo855lXSJI5uhSv1DCM3QZg=;
 b=kPcEKuzTqdzJN6z0jMPrmPDgqIzdMGTP6vN/ejB61D0DkkrhL9kfQ5VvE1jUEP3fToKhXMC2438sdhp2a1uK5xjNZHgoTB4z+ZBWSRQu3Hrq5JiwgabaMmtV0B4F6c6nDS7JSo43Qgf8rJU64QI3vz+MuH/sVKE6EZkgnb6pys4u09+rIEXG+sGp7StTW+XqT+FP+zuZlfIthuw6yWvcPkeT0HxPjkg0aJ5DaQk1egDytpktwuW87qZ2+ciKZvpF8XdOG3TfDmxa2MRCixxybyXW8GnQJkVmV9gbc6j2bHDCMlBk/92EkpRWabaIJdHBOAronRYBftVjl4xQDk9GWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=byMlVl+VM/jf9H52vMnqvo855lXSJI5uhSv1DCM3QZg=;
 b=Cqwq9QHA0g5ckf67Adis3QDswSRUmYJV7/iluDi+CeI19XNeapJf1q2B9TnfPyIUeiSWiCY9k6KlOt6gJOn7a5IiHGmbFNOcbhi3jnRdo9+GlcmyXcQqkW+wiydPprY/0q2i5wsgRHeszcz061IpSecnLQA9sxXpfKZfwy8JOsA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM8PR08MB5586.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 12:57:38 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 12:57:37 +0000
Date: Wed, 17 Sep 2025 13:57:33 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMqwPYb53L+OwRfw@e129823.arm.com>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917110838.917281-6-yeoreum.yun@arm.com>
X-ClientProxiedBy: LO2P265CA0507.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM8PR08MB5586:EE_|DB1PEPF000509F7:EE_|PR3PR08MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: a6de652d-0818-4e50-97b7-08ddf5e9db1a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?nqB8tqvoyZMUPa6KaubvzeGY6KnDFyPgd57yd39l6Dx/SBLIuURrBoBsnmRZ?=
 =?us-ascii?Q?jxITmlo52vlFwPmJWknPV+ebe095Yy4cEp8kFtioD2WPdVKkqV7LUzHxfrmO?=
 =?us-ascii?Q?mWimXii9uzCBQ1+V48pIUhIzrqmAvMlH/VHav/Ja+nhTlGiDSzQ7LfvWuOzO?=
 =?us-ascii?Q?QHwyMRa8q/Xv7S5SwB/o5HC00ziktR3uSBo4jZFPj9SQYiFiRSTUQFUbxlj7?=
 =?us-ascii?Q?bPrXKoX16pSoPhlF/TmuR1IzSHkD9YTE3aZiUsrlUENLgh0ylz/xoiP5y8AH?=
 =?us-ascii?Q?zjNdblKzDf8UHi8Abw4tshghXSz5Fwd8YzcKnTttEMeM8ipEWcpubipphgtT?=
 =?us-ascii?Q?fzELfi3Wo80DixXaiEjry/gaJnamPfPhFN/r+jE5cpoRQ74xLd76uKYUmRfg?=
 =?us-ascii?Q?jRTPe0SIqPX0oGXtDw7Yj9KByJwFC/1I3PgwzdHESizsUHRlxAj4goYJ8Lmr?=
 =?us-ascii?Q?dkhCrF4zPKgZKLllwE83zqfCmMrnEZnKjPEbl7Y1um5p38fyqEx2CYGpjose?=
 =?us-ascii?Q?oFLmMC+qCFpgOwDXiROk1w2QE4TPP9qDWFL5N3FRmBzQYFlZbMU+/o4l9htJ?=
 =?us-ascii?Q?3LzE7+VLBdtHLJsc6izefIO3ynuSOXvY7pMQRMeN7EEEVNmQDY2E9dHITQWM?=
 =?us-ascii?Q?IT0wJnrsgwrxQSSDJ5I7KAsa8a6EcoKTJRnl6mOHVRdLFtZO5GYT2rmln5Fv?=
 =?us-ascii?Q?gGfYgamDfEY9UXJ5B3eEMy9k4kM07v45xIfpwTAMNr8P/A30PTO1luqeNfgS?=
 =?us-ascii?Q?B3OsjhT3S5N5OVNendqG0N3u3Uk92TDDED4Q0zSUlxRpu3SyrQbhEpj9HyKx?=
 =?us-ascii?Q?mBKePVGMGxbjk8dJBbOB3q7OrKbx2AW67kRR9Bg9Z6As1k8JqoFRrIrddnNc?=
 =?us-ascii?Q?d31r97vbrF0xVKprOI5/3ND3Qlrwrv9PrG6C6pfgYM61kTPFADJQs2rTDLIt?=
 =?us-ascii?Q?vVONN7LWvtImG7AyQ1pAQsxdfINs0ekj0tI6AKJ0PdCpp5F0WuGOs9SZFfFE?=
 =?us-ascii?Q?wV+TifCE7oECVj5D1m1NR090aK9Dqa7MF9UTi16sr6ovZoPnHdhXNbCnc0u6?=
 =?us-ascii?Q?xHB+YR1F5K81GJm66IjnJy9xWdJ/iOa+EteCoHcbnVrzOqgnQu7+ItgexsKM?=
 =?us-ascii?Q?wj8AWCgiUDNYdqLc4I3nLuHl7IUNF8cWcyMkG6N8YHV9hkOxUc7qep4TvYgU?=
 =?us-ascii?Q?MBeGXYRAfIb9cl2dfmIjQc9frOhSN7c1q/JMG9nCmEhMIZN8iyY+6amUuYBi?=
 =?us-ascii?Q?dMXheWIKtpJe8g01KEyNywFQAp+UxIp0qef8hOg/3f8otIw15IY5gziooiqj?=
 =?us-ascii?Q?rnkvquXuqWNc2UJ77uJoOQESvEgj1vlePQ5zm0XCora9pf/dvIRO28iEKh3m?=
 =?us-ascii?Q?2fXBhbzdjD9wH27HDt8gflEcdpDWNHF7fc0aAssXWW3ZstsXwrRNZT5U5KTb?=
 =?us-ascii?Q?njA6bTuyp7pOep6KbuXpXC4/E4n+4orLQETwGKzHivmZwD88HqqfLA=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5586
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	60ba0f3e-36a3-423c-b940-08ddf5e9c6c3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|7416014|14060799003|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mnjNBlFd+5yu7H/bBTtle12IXWU5w+H0IntXR3O/W4DCR0IV2D6UH3MhvFcM?=
 =?us-ascii?Q?QMjsFnMCo+hq6FfUxeaEZdsyCekMMMrHnNdBsWJ4GBiiiCas5SOWfmWFvVOQ?=
 =?us-ascii?Q?0SqR7pZwoGgX5bnNw4MaK79JW400z1U8miQ++ar3265VvnIlCOEp31tgQLYi?=
 =?us-ascii?Q?SfATdM73ac+zy/O5skRNQegFaZl1mr/DkOTJwKGKjtmnchdE1Ofvuxghz5sD?=
 =?us-ascii?Q?rCjAeeY2qqlKAwy3J+vH3xJp/6rqCJr2FW+KeFxz0Kaikw2Sa2BB4MlFKr6F?=
 =?us-ascii?Q?O/lR3P/2jVNaFX63COJ0vCgss41ePwtjd2cgq27xD3Thd2dkWRog5LB9+dnK?=
 =?us-ascii?Q?aidFioq+vKMlTcT2ETwd2tDPkgFmJVXHVjsiJa6GaizN6QGOPvtqF5+i4Yo0?=
 =?us-ascii?Q?K9gOnuZub9l9MysQBaghBpYuaIMytBEJZ3xJCRGvyad1Uljf5x/w8D9DNi5b?=
 =?us-ascii?Q?0ig4i/ck1/OzkChyjCONhENv5aY2/5L3MoynyFpvcE1PD8w6WXmwQlux96Ix?=
 =?us-ascii?Q?qoN+YMTILZSHYkELzhY8ay424FJh90hu2+RdskdrTw8T13AbuPI1vMAapUDQ?=
 =?us-ascii?Q?p2yLSDyFwLVOlzqMCoF5W76rP0ww3BcfQOmy9u7n8KGFdDPdqdnbw8S+cUFY?=
 =?us-ascii?Q?USjPQrW37Pfn5JdY7bxN+2wARIwWc+e6HYsC9Njv/iLgVyku0nsh6PEmqRiT?=
 =?us-ascii?Q?ak+me61yk883TPmN5aYNhQPZBOXPJaxAZzoOK5KZX46W2VyCcx7a9Lox8tpL?=
 =?us-ascii?Q?OYykB9NlDRrYIC/qPyCYThFEY6QxQU0ZfgJmQ7t6b6GPpdS0jHXrG6WpD+RM?=
 =?us-ascii?Q?5NP//uv3l31pRMIg67/7IghXnOD/NpTmtI/WBPUu4lQ/1HneUjJZrSL0hIuZ?=
 =?us-ascii?Q?xPgDBxBAYjEisT2HWgrE44YE1BhnmoQhqQhUPmLMEMnNPJZ+iuvNBcfH8j/g?=
 =?us-ascii?Q?tcLdkRfPjrMw5nb/FJGdQa4CdDF/eUGPZLjmH9Anq4zxNqtaEH2IjvI6NJWf?=
 =?us-ascii?Q?2c3zOASeGb9yaMRSF89hsAbAECAPB3YIV6fOHu3t+eRoRzyWLf7NLnKCLK3P?=
 =?us-ascii?Q?2bL71zqa+x6wOhv8tVn07B6AjTpNQC1822kHemsmGf45LOqUQCVLVWzLLXrw?=
 =?us-ascii?Q?qmjqpwwqwTcpLAdTWhC/NNIatyclsh2UyQbumu0OCWh/g9+8M99pfnB3mNTg?=
 =?us-ascii?Q?H3823miLNnZMrqbXzK5T0brJKoRadgRL5H3kS7Cdd5MhsTY3iMzurqXZgjvO?=
 =?us-ascii?Q?42Yspc8EyHdQijAbPUSoEWrW4UN9MsCp8alMHpS026SDg4a/fbSlzH1m6i8T?=
 =?us-ascii?Q?C4EsI7Zjd/7FIs/LkTNTBTdgarbiL0x8QFccWv/DjNeV/KEa3KX34fd06XZm?=
 =?us-ascii?Q?dJhrk9HQvq1SorpZL+iIvR9UmlZjW1jjxhB8Rhj1OAQI7thgxD1CRsLCsG9X?=
 =?us-ascii?Q?XXJX94pIIoxfCaY8g9ESIl+bf00azJUi0KQvHD1r75cfFiwS1sp6vIg+jskG?=
 =?us-ascii?Q?YGcyviTY9BYxDKQRvw12mWPvqoiGD44T/6H6VfDzsWlLfWjHsoJj+bB7tQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(7416014)(14060799003)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 12:58:10.7574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6de652d-0818-4e50-97b7-08ddf5e9db1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5708

Hi,

> +LSUI_FUTEX_ATOMIC_OP(add, ldtadd, al)
> +LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
> +LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
> +LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> +
> +static __always_inline int
> +__lsui_cmpxchg64(u64 __user *uaddr, u64 *oldval, u64 newval)
> +{
> +	int ret = 0;
> +
> +	asm volatile("// __lsui_cmpxchg64\n"
> +	__LSUI_PREAMBLE
> +"1:	casalt	%x2, %x3, %1\n"
> +"2:\n"
> +	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
> +	: "+r" (ret), "+Q" (*uaddr), "+r" (*oldval)
> +	: "r" (newval)
> +	: "memory");
> +
> +	return ret;
> +}
> +
> +static __always_inline int
> +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> +{
> +	u64 __user *uaddr_al;
> +	u64 oval64, nval64, tmp;
> +	static const u64 hi_mask = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ?
> +		GENMASK_U64(63, 32): GENMASK_U64(31, 0);
> +	static const u8 hi_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 32 : 0;
> +	static const u8 lo_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 0 : 32;
> +
> +	uaddr_al = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> +	if (get_user(oval64, uaddr_al))
> +		return -EFAULT;
> +
> +	if ((u32 __user *)uaddr_al != uaddr) {
> +		nval64 = ((oval64 & ~hi_mask) | ((u64)newval << hi_shift));
> +		oval64 = ((oval64 & ~hi_mask) | ((u64)oldval << hi_shift));
> +	} else {
> +		nval64 = ((oval64 & hi_mask) | ((u64)newval << lo_shift));
> +		oval64 = ((oval64 & hi_mask) | ((u64)oldval << lo_shift));
> +	}
> +
> +	tmp = oval64;
> +
> +	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> +		return -EFAULT;
> +
> +	if (tmp != oval64)
> +		return -EAGAIN;
> +
> +	*oval = oldval;
> +
> +	return 0;
> +}
> +

While I see the code I couldn't erase some suspicion
because of below questions...:

1. Suppose there is structure:

struct s_test {
  u32 futex;
  u32 others;
};

Before CPU0 executing casalt futex, CPU1 executes the store32_rel() on
others. Then, Can CPU0 can observe the CPU1's store32_rel()
since casalt operates with &futex, but CPU1 operates with &others.

CPU0                                          CPU1
...                                           store32_rel(&s_test->others);

/// can this see CPU1's modification?
casalt(..., ..., &s_test->futex);


2. Suppose there is structure:

struct s_test {
  u32 others;
  u32 futex;
};

Then, can below "ldtr" be reordered after casalt?


  ldtr(&s_test->futex);
  ...
  casalt(..., ..., &s_test->others);


I think the both cases can break the memory consistency unintensionaly
in the view of user...

Well, the dmb ish; could be solved the above problem before casalt,
However, It seems it's much better to return former ll/sc method...?

Thanks!


--
Sincerely,
Yeoreum Yun
