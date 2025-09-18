Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011011.outbound.protection.outlook.com [52.101.70.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6F2FE592
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 09:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758186725; cv=fail; b=FYLSkAG1LPBCsT99FZWl/uZszOi/zGUrGO86gfTJ9kCcMLXZA33Y/vajVBleJAe06q36t3KKx8gBhpTsBpf9oeu+K+MpCjd8sbaC1wX1M9q5dmENrhycnUTt4rdYYTgCWXJsZrxXhJTJoHZr8T5Ry72qiQXpdsjTxJO1gXlWyX4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758186725; c=relaxed/simple;
	bh=XXB2dG6LeYeCVGXbOcd/L86nuXvyNA3pDghl0kuVeDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DBOVM68+cIT1BC+AcD6cf1YL+NHBRglqFqvTk+3OXyMRXnt4zE3qsjleubuv6P8FctlVR4KNh7OvY9jSEPBtccWkXnq6GK0KRvzJU1OlcozsKiyrJIY0HFX5w3ptcpdsrtPjtflDSZlLx82v1bixQh9CPstFMzXJYVICglxI9WQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YhCm0Us5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YhCm0Us5; arc=fail smtp.client-ip=52.101.70.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YhCm0Us5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YhCm0Us5"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cQ2qI9VnAVSMCQ+mC6bjoymxtPm65BGkyaC29AkHTQ2PuMPzpSIcz03UdKoCK5HzLawho4EdmMzKz68lRl1HnMjRco55e9fXhD/06WI79rQ+HaNGCqYPSO0H3LZM52zpa88ofZGH+eX70YNtKTEKcQjEy/WVG+LqPW3iaCmdcCZR7KB7oNhMXO6dCgFf05PmRQJBQOPuc8aVdcNpTyYopYVug4VuI2ITPlLI6et4mpy8h5qo3R1SKmiLdKOAQHpysTH806qZNp6hkfESzTe5oV4o+YbwYFIGO+1GIFlzCvRQLGvoj+AAz9b53UWKLhOLJToBDJ1+grTYdf0i/uJSMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRpsnlyh9RR02TMEXwYSS87r1gsTi3X06DXicCX4jzk=;
 b=PA4KhrQSqYrMsEOm882ZfKrqoNoWqrZV+m9Xon1PU02lBM0OS3BCwWeDSilH7445wFgQ9j50cDsaclDYTDt6ld6ZwINuwczUGioOlf6of2Bi9NNTGpehqysSDZkIhI/8b5CYRZlC8E/D5zIvTgryCSj+GkeN60IMN4uem8RF/xsX/A58Mqva0JJZQU6uWSRhnE5bAmPsq5MvEvVuQdKZOWBBxg9bYGqsRR1J3MnD4h/DG+6kMQvtCRX6werr6/DrXAW2UESHMo78Vih4A6xa8JvBeru4YM2fEQw/QncQVGNTny0vKParUjKwTDAqs8qNVJN0zQzQZDYgy5RqqzG7zw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRpsnlyh9RR02TMEXwYSS87r1gsTi3X06DXicCX4jzk=;
 b=YhCm0Us5QlRrG2caeX4xcIpAyW7aDVKDmnBFsqMxsc20ecW+9N69SPgt6wXZXEVn3lG4uyiWOXGT/GWc+MN2snLFxlDJlPY1RIXnbc2Gl94pSp6pxmZmlIFQ6SmujLGjR7MkgM8tgjc6kmypvQaa7oH14WhLRjfMM2UER/UYJ7w=
Received: from DB6PR0301CA0091.eurprd03.prod.outlook.com (2603:10a6:6:30::38)
 by VI1PR08MB5488.eurprd08.prod.outlook.com (2603:10a6:803:137::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 09:11:59 +0000
Received: from DB1PEPF000509F8.eurprd02.prod.outlook.com
 (2603:10a6:6:30:cafe::6) by DB6PR0301CA0091.outlook.office365.com
 (2603:10a6:6:30::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.20 via Frontend Transport; Thu,
 18 Sep 2025 09:11:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F8.mail.protection.outlook.com (10.167.242.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Thu, 18 Sep 2025 09:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=og1CPJ8FxBUT0GVP2yUP6tRMU67qk5fl1b/keouGBxzTdYJPH9dAuznN4E7wcvcl4IOxZHm/UH00TEPcIzFO3e89cOlWhZrVykjAKplsZeoLr3t4jNYZOYHVy76eLTOjBRxAHVzzXun5jq6fBgnF9/Fz3vfoe9lWS/VtXvwQevzasG33bhyyjxqSQxemeQU3F73iT/KK7PtZPMuUJcOT6n5cv30vUpOggIeTGAhmGj7dORRd2vBRtIM4pkvf889q5+hoDLenPhWKgPhiab8Bq8Tc/S88Lww0c2joPLdyENi/OhiUdAlDJbJftjRR0JEWEkbyNTmLqvyVVsOXNHr2Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRpsnlyh9RR02TMEXwYSS87r1gsTi3X06DXicCX4jzk=;
 b=sm++ChS1gcU9wOrkSb/Y+29UC1iUfQNYzKwzosu7HpU9B3Om7U8JJO+8Sa+GVjSjStDtvHiGEnMeR6mDN+I2qNOp9l93KGeaySRrwIx+EyYRdLfj4WgZ+NxNnOcR7Sy9LCjzJPyqJhSYaN8ocC7wSr72Qvx2X02GJkCy8jc5nwQebNT+TwMK/PEz5C1JgkeNvkwfAtob+D2p9HeE5rn2ffkKvWZHWyGNgZrnkQmdNejh9Nra7lWu7GspsfzOzvYjEkHq5SEiHhiX/KjlIkdipFIAAv1bJqAkiJmhxut3vftR0STa89Eu2XpTcq6NKVZNbCSpc8UulOQwnVr0vJWIxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRpsnlyh9RR02TMEXwYSS87r1gsTi3X06DXicCX4jzk=;
 b=YhCm0Us5QlRrG2caeX4xcIpAyW7aDVKDmnBFsqMxsc20ecW+9N69SPgt6wXZXEVn3lG4uyiWOXGT/GWc+MN2snLFxlDJlPY1RIXnbc2Gl94pSp6pxmZmlIFQ6SmujLGjR7MkgM8tgjc6kmypvQaa7oH14WhLRjfMM2UER/UYJ7w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB9915.eurprd08.prod.outlook.com
 (2603:10a6:150:3d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 09:11:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 09:11:24 +0000
Date: Thu, 18 Sep 2025 10:11:21 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMvMucuo7BS2y87S@e129823.arm.com>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
 <aMqx67lZZEgYW-x5@J2N7QTR9R3>
 <aMq5DbqsXj6vP7Xe@e129823.arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMq5DbqsXj6vP7Xe@e129823.arm.com>
X-ClientProxiedBy: LO4P123CA0143.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::22) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB9915:EE_|DB1PEPF000509F8:EE_|VI1PR08MB5488:EE_
X-MS-Office365-Filtering-Correlation-Id: 9221b7f0-a43f-4a57-67e1-08ddf6936c2a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?7pm0cS7TxEsqNT0I90uriyN7/N+q5feInZYES9FCnZUkdbKPRUT4SG7qNeGY?=
 =?us-ascii?Q?Qt0seR3sNcR4J5B3tToQoLr7wpk4EehqalpvpT1w84aZayWPzi5c/YD9bhKc?=
 =?us-ascii?Q?lHANl832kfDvjF/mpS/eCH+sj7LyLoDgok+zTjV0jQ2xZFTHNQK2HvXmkUda?=
 =?us-ascii?Q?8Pma/Ao7N+msxfmZmmVNcaFDfET5i+nIr5scRifVTLbB1n/aa7DPYpeMrY/w?=
 =?us-ascii?Q?dP0NDr0EEkLjcBSDBiwLe/c/fZeMrAg1cBZPRUeIiiSvsMuNiS+JCaK2+YOw?=
 =?us-ascii?Q?wfRggL/sOY6oy+wCQTNmDzJmn2rVLj7W733x9uV7g+G5bVLiW1vA0nY1ogW/?=
 =?us-ascii?Q?JUvm5jXHVaQD/OKDaxL6LsxEYxmZv0oktbCDleIQgj3eFNcmOj77TBcFOpjb?=
 =?us-ascii?Q?mAFyyBxmSrCFAvq1HKJ47Fy2pvaC2gSqeWi0DHLH0uroEld1BuK3630GJ+/O?=
 =?us-ascii?Q?uHhTSvRIi7AHXjlB3d7Vr90lP/Q9O0LF60QqZiZL4Sjs+HGkxtLNyLDgV6NT?=
 =?us-ascii?Q?4eA/mYzsZbabz7Q7NHsh8WQgxyxXc8a+MyulX5kmiapfmTROG7kAC4XUlmgc?=
 =?us-ascii?Q?fh6ST6nGEsa6ziv/ZGS028ue5oybPT070+Jd7n8nIV/aT68p+qwSlFWaJNoO?=
 =?us-ascii?Q?187t9Nic0cyWlLW/+bT85LhSpIHcydIyVPkygRMBs4n6eDmV8AqIw11vg+aa?=
 =?us-ascii?Q?IO2hoRUjWrdiWu46n/G4rdu3/fen8rFQ5NWV8HuF09tcnVnYXka82k3Z63aO?=
 =?us-ascii?Q?cfxgkiWDWSYDhJr7YJyRqoKcNE4PIuOVfgeiUwicCPVwMHaeglw0iphQrLuk?=
 =?us-ascii?Q?Ps2pCEVcjFBb3rKS6ifjQ1N866apyoeaRvCdaQyeQMOS1OutOziBf2q2gT2M?=
 =?us-ascii?Q?hkhWJoDvzxv5uBhc+yW8pnIuzBw9v5wx3JoJb2LHEtWiDe2PQ2GShtB811xe?=
 =?us-ascii?Q?PPlJ7swjWRXLOM1ZJbpuiPJyM1W2hwrfGD/km6xOvgHb11wpgIZVi+up87NP?=
 =?us-ascii?Q?EG22xl9bxsA6woIsgEbIWuUAb4EZ9zGUtjpCO4/QTklx2IbUOIAwr5d3bkfP?=
 =?us-ascii?Q?qbAxVW8MjoG0aZa199m6G0WBVQNoVOraFjDemOVR+nA2oGyp4UbPyUWlZA2E?=
 =?us-ascii?Q?lxByPpj7TMLxh4l6bkdOFZBQhk5WSeQisqnVwJzViun26vPHAlpov9EowGql?=
 =?us-ascii?Q?edY9Ct0TfiZGNdGULps8Xw1qaUBIjdQou/RykONI+y+Jin4TVVqZSeaOdfi4?=
 =?us-ascii?Q?tDF+mbCgt5vGxqxM2gGt33t6kWCe4D1hUlex+4ro558TdqFPWgSkyKlMhzBE?=
 =?us-ascii?Q?3ybnx9ZIdzKrcYr7jazdUGqJWCbnKAGemp2DbmS8tdZoNQiXb0+yodWYJFn9?=
 =?us-ascii?Q?+VROfHp11gJAr3Rrwm57NoLoKudOQ1Y8XHoVbjOZF30Sc2a/EdyPXlE/Vvkn?=
 =?us-ascii?Q?rMqxksparOc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB9915
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	40082fdb-ee90-4e5d-fc78-08ddf69356fe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|1800799024|376014|7416014|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WUCIVi3p2A1B0vCV/x0sCveAVbXq6I+QHknygJLjNhqkwaushLQqw5wOkQJ4?=
 =?us-ascii?Q?JPXVOsvYwGweZ6rOrspfIJG6jfiUT+5l/OzTEAbhjalOTtjl0dUBaCcvacAp?=
 =?us-ascii?Q?zuLrpgKmYrF0HjOH5V33mFzK9y60yeMNyvGIr5X9DfUcMmCbFzlCWBP6pVfq?=
 =?us-ascii?Q?9+9EohXdQ7rvPppiimDan1xhBgfcQ3Zto0yDEQTV48a9cQeAOE0nOvhFHj+T?=
 =?us-ascii?Q?fx4NvOPz2EIHwuIKnjpED63mD7twpJJiygsz4MB/e2NWX6SVjAGtPkoFaNlU?=
 =?us-ascii?Q?Edg27SZnxUp7QVbMohxglnVqmnvj0960ALS2IOtr22/gv9I5+DL9ONGjkb3a?=
 =?us-ascii?Q?ptQV9E82634yxComsG7AMyjDCBjZJh4WJILYGCgRw2A0Qfx6nk5JlYs2aiVV?=
 =?us-ascii?Q?9bJ1b2+y//h1WcUXqR/eIPqzy9v36XvvlY7edWtiwHmTzIKiVZwEWFrmLeCS?=
 =?us-ascii?Q?t6oHB2uUS+6PwyVWijL5cfR5VDe4+pQ9ULdXOkNGXYUGVeoA3qO2ZGhE2MZU?=
 =?us-ascii?Q?zOeTaES54scIw7fYa/63/w50mgxKjPWYygpmsEXkrINxmnV9PTa7khLu0aoj?=
 =?us-ascii?Q?p9VfCqrYGnsnrMOE/egQMfBp+RyrqmzaaIruDy98zAKp8+ltVmVpvyxCV5yF?=
 =?us-ascii?Q?REVpnWEzoCNaatEYeyW9zPclhDWmnXk26CpisDeRo5TlgYwW+uSWJ5TS7GUx?=
 =?us-ascii?Q?b5R5N0cnxuZGCm/RPzjvtoCEOBH851Grjy/3tygbqnv1XOE2Noel3QH+htBj?=
 =?us-ascii?Q?l9IJjMfJjcZ2kLAfGXjsQ5CM9QASxDJRWseby6SBKAnFGPMQZVTcCHRJOhJe?=
 =?us-ascii?Q?mzg/QE8JES361iVtokFRekILbKp1NS+WVRuPtcSQLV88UpUGN33nOs0z0rBu?=
 =?us-ascii?Q?SD2pMfTzwjr8pG86geEUcubMWZ93qxwW+p6plOwdIaRuS0YlDJeTJy79Phsv?=
 =?us-ascii?Q?h2WTGRimLyanIWGu4JilNsatUTDYCCIZjS+5U3lFSY7deOFPZ679rDS5N4Rd?=
 =?us-ascii?Q?j0SePU1j/HGyh49BlMqwEoDZvzJJTiBOeN5vyMrlijwZO8gTf+LTSUu+t0P8?=
 =?us-ascii?Q?Ii8WLUfiCwRpzmYChKHrrVtMQxK3k+G8sMrcWMVGYeDNEz5DhfeQoFpHCN+n?=
 =?us-ascii?Q?CDNVWjmbjcymKbK+lZDD46zymSG4dO3c03WdvOB7L5eqa7ZJ2J3Utg2qbAkP?=
 =?us-ascii?Q?qNuDwnMpBOPOJ0YQkeHQG6vw+9o0k1gKRzJqLPVkSW/g2XmDK1p1p9/ZHh0K?=
 =?us-ascii?Q?en3jLuM5rotUg/hDmp7Qjx2JDwPIFm6yJkPx2/qhS91Hm7T5v3CzAhkDlLhm?=
 =?us-ascii?Q?w2orCbFYacMQzP9hRA8QH+uMi5s9hAigirS2a16LG6SPJiJNfU5pI77969Wt?=
 =?us-ascii?Q?Y0HSQjhSfJqDexUulvF0j6tAxZHTnI3sEtOZMwqoAYSvwD6nlzqwY1UUyGd8?=
 =?us-ascii?Q?lT+Fnsn+CeTNO/cPpUvczJWwzDkzDkl3u8VJW7CkoyONZn4oba7rUi7bH9Yq?=
 =?us-ascii?Q?NUuNkgaMdd7F/dJiLbHJ9mdzB1v5t5QwaUrc?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(1800799024)(376014)(7416014)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 09:11:59.0721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9221b7f0-a43f-4a57-67e1-08ddf6936c2a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5488

Hi Mark,

[...]
> > > +	static const u64 hi_mask = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ?
> > > +		GENMASK_U64(63, 32): GENMASK_U64(31, 0);
> > > +	static const u8 hi_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 32 : 0;
> > > +	static const u8 lo_shift = IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) ? 0 : 32;
> > > +
> > > +	uaddr_al = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> > > +	if (get_user(oval64, uaddr_al))
> > > +		return -EFAULT;
> > > +
> > > +	if ((u32 __user *)uaddr_al != uaddr) {
> > > +		nval64 = ((oval64 & ~hi_mask) | ((u64)newval << hi_shift));
> > > +		oval64 = ((oval64 & ~hi_mask) | ((u64)oldval << hi_shift));
> > > +	} else {
> > > +		nval64 = ((oval64 & hi_mask) | ((u64)newval << lo_shift));
> > > +		oval64 = ((oval64 & hi_mask) | ((u64)oldval << lo_shift));
> > > +	}
> > > +
> > > +	tmp = oval64;
> > > +
> > > +	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> > > +		return -EFAULT;
> > > +
> > > +	if (tmp != oval64)
> > > +		return -EAGAIN;
> >
> > This means that we'll immediately return -EAGAIN upon a spurious failure
> > (where the adjacent 4 bytes have changed), whereas the LL/SC ops would
> > retry FUTEX_MAX_LOOPS before returning -EGAIN.
> >
> > I suspect we want to retry here (or in the immediate caller).
>
> Right. I've thought about it but at the time of writing,
> I return -EAGAIN immediately. Let's wait for other people's comments.

When I get step back, I found my thougt was wrong as you point out.

So, what about this?

static __always_inline int
__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
{
	u64 __user *uaddr64;
	bool futex_on_lo;
	int ret = -EAGAIN, i;
	u32 other, orig_other;
	union {
		struct futex_on_lo {
			u32 val;
			u32 other;
		} lo_futex;

		struct futex_on_hi {
			u32 other;
			u32 val;
		} hi_futex;

		u64 raw;
	} oval64, orig64, nval64;

	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
	futex_on_lo = (IS_ALIGNED((unsigned long)uaddr, sizeof(u64)) ==
			IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN));

	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
		if (get_user(oval64.raw, uaddr64))
			return -EFAULT;

		nval64.raw = oval64.raw;

		if (futex_on_lo) {
			oval64.lo_futex.val = oldval;
			nval64.lo_futex.val = newval;
		} else {
			oval64.hi_futex.val = oldval;
			nval64.hi_futex.val = newval;
		}

		orig64.raw = oval64.raw;

		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
			return -EFAULT;

		if (futex_on_lo) {
			oldval = oval64.lo_futex.val;
			other = oval64.lo_futex.other;
			orig_other = orig64.lo_futex.other;
		} else {
			oldval = oval64.hi_futex.val;
			other = oval64.hi_futex.other;
			orig_other = orig64.hi_futex.other;
		}

		if (other == orig_other) {
			ret = 0;
			break;
		}
	}

	if (!ret)
		*oval = oldval;

	return ret;
}

Unfortunately, if there was high competition on "other"
I think return -EAGAIN is the best efforts..

Am I missing something?

Thanks.

--
Sincerely,
Yeoreum Yun
