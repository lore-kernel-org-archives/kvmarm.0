Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013061.outbound.protection.outlook.com [52.101.83.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9AD2C236C
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758552620; cv=fail; b=CqfB59x/M1rLappH0/noUJHpVJXsgKSKSO940t2FSWMUhTdCv5nVEfIhoXpcDaQxPmfxZjsz96HssrJWMsEmvnRm/ZE2lJ+3UnAsW5ey/jct5dkAWc2rEAM2sliQSUZu/rMSSQ10EjhPZb7EVlGlPPT2+IAD0PmOnu5F7gRu38A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758552620; c=relaxed/simple;
	bh=T2D2LjlmJOKvvLZlHGYU5XoYfnk2pesHJuhiRNDlS4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Uwz9HsLELOfZBsLW7qzyp+hntHqwEht/eSnhV7vuZcplohvysUKkpfzB2dRXivntewhUVTlDrZbox72ZLNl3Pp3RThMuRloXc/9nxRbOd8FS75mFuog6Li6/DeGBzevfxJ2lciVFRC9mb8uaLEK6gWKQspcS33pB9CGSHRgzYOk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GtNc0KnB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GtNc0KnB; arc=fail smtp.client-ip=52.101.83.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GtNc0KnB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GtNc0KnB"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vKFM+OIYh1gDopos7o/YaFQ+cWfp5BMtl/JbA3GgEIBdLlfaqLCZ24Y6z67oLe7Q/zI3Rd6iZ28QJqVAxMRRwhyfDHrz48g0VVWjn1HD3x0drRtnkA8+MtlNLC74BU7Fw3+t7yVoFoaDblM/BUC0R5smVJeJqXdOTvvUyi0pxOBKSRT0YJFFCob7nZESipEcjyStRB6dc47mfUx7GLXSQ3Fz7sjUctmghKDHzDmdEFxBs+jb5ieNJ6C0I9ZpVDt8oZRfuMbhKvBLIeoB0BV74v3aoEjLgvQiVl/KBUsffPQNo2uEWFl456m2+NcO9/Czf9E0okhpRk9XuWuQ4zgxhw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ic0EvWBjHYKqWQbDBG71xOwxqm/R1XLX0cgnze0doto=;
 b=Xy79SrBdd7yltmxnQm2KcHcAiXRyb5pDMP5uja7VfYy3bTl56YexgB7IdBlBY3vjIIgsKRZlQfeQ1ulVRFIWthey+CaaRDRkkToBY9PO8lLORz2Yys0fGyaUm2905CauDqVDE3X6lS/i7SvI5UMCDRLaD/7AFe7NfiKRQpM9JyqsbXuetijsH1XvZUQl6J+6GNOfun0e0vBuHs6r/sWykvSPgbnby/+ORMe611Huyl+ZVfdd/SeF4U6f39WxTS6ZMp3dRTudLmZ0JqWiJEnngMtVPU3QOS+RigEoE6DXH/Unvg4z0jq4IgCD6+xhUpfKD5+cjsIsjKw1t4iQWJMBOA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ic0EvWBjHYKqWQbDBG71xOwxqm/R1XLX0cgnze0doto=;
 b=GtNc0KnBhM3jF5e0Tu7YCAoBmhk8xlI3WNhcpuSrgrVArpQiIpQHaWgvr//SpaZIjMLspDxt9MENEVuLweIP5R0X5I/2bNYhzShR5syfarT3zQKoPzuLF07xiCGO55jx/CMTQn7diFEChuJ0K6e1Uxgng6das9HLxDq98hKe/e8=
Received: from DU7P250CA0003.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::30)
 by PAWPR08MB9783.eurprd08.prod.outlook.com (2603:10a6:102:2ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 14:50:12 +0000
Received: from DB1PEPF000509FF.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::a7) by DU7P250CA0003.outlook.office365.com
 (2603:10a6:10:54f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Mon,
 22 Sep 2025 14:50:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FF.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Mon, 22 Sep 2025 14:50:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i1AJwlJZtqvZWtNqLBgRrCFafrxVozdhEpy0CF3XcSso4RFa71c81phcPHqHitozEQCt0ObH9B3cE//XQl7Xf0rC5YXwOh0Gbue9w4lfiwote/ml5lLh/0IvETT313gqLh/J2v8rx1ZDzXbgsvTtuE0V9xKpfXNwx+rBT6QVKcdEpQtTQ5ycZbM8ZmOn+owOA0ynzikzJOtQW2O32S9UOnaOltyNB2KaxtjBJfK+PTcvT2yScfULbLzAREPzqqomyx7ZeWOxkqaG5Fz8zcp5LDhV29POZaDbpJj3T58lZDn09Koe37ArfD0uyD6mjlWEuLqTdcmit4ttYAj5mRl5Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ic0EvWBjHYKqWQbDBG71xOwxqm/R1XLX0cgnze0doto=;
 b=JchaJaFM7BQ6gG12qk6PypAbSo22IJwXX91WyMJ3Km7WjbYDwY/7OYY/Xn9qKV6MkM6A3g0FqawEpkV1sTaqSjWM9gtlp0hiO4KS822j6XCkzVGGBuzxqhnJa7iIwTxx1vcIoa07bHlHczyXTIWUeGKdQWvzTMS+8p3GD5Wj52r8zLhuIN0kVaHBb3wolAMsuiTA1Kbf0E3NjHslT/coBN3Uk7g+RVUSp/ytnEHDq8vacpmEKuMu/6/9t1t2go66lS4I6zAF6t6Y/NEntBk5vELP4bWMOQP47Sip3d5SWfP5b4ZeV/b5FbCndDGhDX11OK1PgtGTljEZErh4Hubytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ic0EvWBjHYKqWQbDBG71xOwxqm/R1XLX0cgnze0doto=;
 b=GtNc0KnBhM3jF5e0Tu7YCAoBmhk8xlI3WNhcpuSrgrVArpQiIpQHaWgvr//SpaZIjMLspDxt9MENEVuLweIP5R0X5I/2bNYhzShR5syfarT3zQKoPzuLF07xiCGO55jx/CMTQn7diFEChuJ0K6e1Uxgng6das9HLxDq98hKe/e8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU4PR08MB11574.eurprd08.prod.outlook.com
 (2603:10a6:10:627::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 14:49:40 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 14:49:39 +0000
Date: Mon, 22 Sep 2025 15:49:37 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/5] KVM: arm64: expose FEAT_LSUI to guest
Message-ID: <aNFiAZVT+XDCBX4r@e129823.arm.com>
References: <20250922102244.2068414-1-yeoreum.yun@arm.com>
 <20250922102244.2068414-3-yeoreum.yun@arm.com>
 <aNEkNF8rvb_e9DKd@finisterre.sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNEkNF8rvb_e9DKd@finisterre.sirena.org.uk>
X-ClientProxiedBy: LO4P265CA0267.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::7) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU4PR08MB11574:EE_|DB1PEPF000509FF:EE_|PAWPR08MB9783:EE_
X-MS-Office365-Filtering-Correlation-Id: c93f6f21-7514-4d88-7303-08ddf9e7556f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?ldyQjlx3aATMa82QKSaLkZMJSNKrE9Pl/2xp3i1zcsSm68IDpxvsXTo87NKn?=
 =?us-ascii?Q?am8WjwyIfAW0H8Y4IlvX3xn/GF8hyDmtvf+eQ1Be52HLdopJc4Tlr5uNW6l6?=
 =?us-ascii?Q?/Z7OgobqJlLGW+BlrfBmbhePfzkOjQYV+/VFlW+VQBCsAo3E6C83guoDc6vJ?=
 =?us-ascii?Q?k9C+2Caxl+65ju4tTcWeLV0MTFfITUOZIRs6X5QGw8/n2VW3Rk2KhV8N2yVf?=
 =?us-ascii?Q?tEP20RwZSZZWeEZwwBAWvLYLgfNjHjj8rXD6hK/L2+KSWKyqovtbOcFwiv15?=
 =?us-ascii?Q?N2xhfCeARWNnXdUr2QeeB6OMHZDTMDZFNOntCenXo3wxzZuUrF9DZ03k7fJ0?=
 =?us-ascii?Q?UV43heRKRjrzpNtwTWwi40zhn580/mD+sbrUzUNb6J4vzTERCHKpst/0Gl+o?=
 =?us-ascii?Q?GF4KC0DubRU/T4qpIMLs6OPjiPgpoGkdhIv/wMl/7quiWXBmEnrYnXLPzQ/R?=
 =?us-ascii?Q?hIRsGnB4zEBu2MoexppqSpXI1Ms0E7G/ELmjijr2MuXTtXXY2Edplom6LIFl?=
 =?us-ascii?Q?z3LONzAHDIr3nNN/DNIobbuwDMdBKbeVg1/XP1N1YP4pPJVUSpT9CMK5lEUo?=
 =?us-ascii?Q?AEwjwVElLqGE0lRAomJ9pql6i9nPtcZ8m2XyberewQTIU7V3NkJtwGM6yop8?=
 =?us-ascii?Q?raXwg805W48T9RVt4XY+TI/8dgw1V1DPQ/f1Oq8al/ppJKRp4GKFd+DInEwP?=
 =?us-ascii?Q?Tj3vSeD1Vu7etxsXF1+aeQZvfR/GbGsbCKg/2o9DGeCX7Sz9AA2MRBGKzlPW?=
 =?us-ascii?Q?xMoT37w7K7rjgFfM7ZSqq2JdgnZjgTKaaQgGQaF+CH6VWY7f/wYBWhKt54kW?=
 =?us-ascii?Q?QvNwqDdiXf/WmazKAMAkdCN9v2H7BsRs93KrzJe03Vl3QziYeiMF4UTFr1O/?=
 =?us-ascii?Q?HAVwdUAAqFyy0P6UuChBAcTNAPK5rkgA93QflqytsJ1qxSttBLMBuKJojdfu?=
 =?us-ascii?Q?x+Q6rChYQeGiGyy2Vm28gICuyeu61nrQ9EiktopLz4fIJNLNrN3+7SCeUBj0?=
 =?us-ascii?Q?+m2pqQH67RgDslpdUtJIB9vJBLI5esOtjyYxmqAm+Fbf9Pc7/wp7ThuHmad7?=
 =?us-ascii?Q?BqhfV+Wfnl8SZASnc3EovpOCCtNfR3UQIELjdpiS85mpawaA1AwOWGJZKp55?=
 =?us-ascii?Q?1JnPVo8Ir4QdMqlu6SkAZDHwqCBPb5Qw1EENAVFrr2l+seYOKwAK1aewVFew?=
 =?us-ascii?Q?EIJ45Oq+5KppQuGKgYzc8cIq9yhm6j7fMpWcECsvtizIOVJTKXnfYiGibYFB?=
 =?us-ascii?Q?QGOsZmYs9D6v5XV3qwGrftBS9sqVQ1C9K5Uwwa8cGFLoeA6rFCvUN2yHSGUg?=
 =?us-ascii?Q?U85GZ+/A70TzuYGLQypAnAavKSjNNDN7NUMRQqMpwK2JuFmEOJ52VUPk/YM0?=
 =?us-ascii?Q?VDbvZazYg/moqAf5TjLZGT5iE7NvAhNBcKnH0DVVW3Tv71WxfA=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11574
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	73df06fe-99a2-43e9-b99f-08ddf9e741ed
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4u7m4SWKmvLHBhIFfJH3tvP5+h2AqMPpHlTBmzCEXS31mRvtxjl/oQLrB1/Z?=
 =?us-ascii?Q?DqhHNzxaXs8BoFv90qhzsbbF7qgXCcHLxlc636GPAfAcNcZ1sE2YJ1Trbhmk?=
 =?us-ascii?Q?Wgnx4uIF1MbvCI7kg3qijc2q96/vRw1xTZ/mLoI+41kanxvMI3nM3OnOMeC4?=
 =?us-ascii?Q?ttGWMLtqXvFGUReFxqWJYrbeQWeTLJ8HgkCUE8OtIncaQUg7NQ6ul4B8K8pU?=
 =?us-ascii?Q?1ZIGCAd77+2qORxmhHYJt3YVwf5gjt5gb2c5ybzfLw8OKxBMM3x+PZMrFdZ0?=
 =?us-ascii?Q?/VIxC4AxUFwYRASOFQXXWgwDEiix0XpZlUZRS3OQobY8sf16GSCYXt78vkSO?=
 =?us-ascii?Q?J1n1Ae3qo5Ah2xtjOOjHJZt5wVA04t2sYVt2bzGD8TCiMVEqDA+IkS/OAHgn?=
 =?us-ascii?Q?pVI4oy5GRMHRMpiHDYjoA8wJWBRMEBmGWHdpcXhRKsrfm1VVIJsaOVcScrRa?=
 =?us-ascii?Q?DCRJEeYVy1kBn6G9JdYF3WoX5E5ofzc34o4M5XEw01wsFw5qlCWZwr7v9lWb?=
 =?us-ascii?Q?zrzHtRHyN7h72hh85n7Yk0UyXhFPItbI/4mSqxUYz5dc3wsH6ftKG+Q5LfF+?=
 =?us-ascii?Q?ksnb+iSvd9uKjr0B6NZoGH9tSAz5iiUVmedES51NdAY9MLN6134cWY9cKyfu?=
 =?us-ascii?Q?xP3o6+B9slM7eAwoWxcR4qgx5hnF7A2zuyTAqhM2E62L0zUh8HWYLenZbJZy?=
 =?us-ascii?Q?Kf4e/O0fQL2CJ/UHsNCNkyuYy1IIqmlTnLWeGfkRYF9JGXMaEIZo5OlwzRPB?=
 =?us-ascii?Q?2Gd8jI2IR3NXuw3XnA7sWj048McD7uFuI6naGckSOXMByEHJAaX4oM/hyvQN?=
 =?us-ascii?Q?8RDlFH7iiSVOex3tBk7+AECOEIUpdbJc5cfkztZ+tpGgPtuka+7KudmuKUeW?=
 =?us-ascii?Q?GTZpjmqInP5Data+m8I7cxXkR3wkFE/dBvJri3xmmyRwUnaFijVXcHqn7WM7?=
 =?us-ascii?Q?7IPfKtslVsldB09EM9vn4wYgOzn0E6PIJ9oZBcNvjMzwuP22eBW8wAUeiz9T?=
 =?us-ascii?Q?UYGx8VL3BJ6ooGkHH/X7wZv3EYzm3nBV38DdwjqOdiYo0rjKYFIWUZaBtBl3?=
 =?us-ascii?Q?XW5GGTQIBWCHRkQNU8mQlRhVc25sSrbYEWT/Ps3Ukjacp4rlGhlKRkU0Hotu?=
 =?us-ascii?Q?gf3WK+mkpMJgMD0ZD6rEq2RCZ0qeQh+db5e+kBIQMInsnfE1C09t048aNx1o?=
 =?us-ascii?Q?pSwnRLmRzXt6GAS4UwQPF2tV2mIviTkIEFtyxz35AdqFsFTMopjawQQu8uxV?=
 =?us-ascii?Q?vKqeQ0IfkpJABi0+sl9TIu79SGb6NAMS4w0FIE2NXobU/wwM4gW2qNc5wVTF?=
 =?us-ascii?Q?qt+DVYX2l+4yyDvAM7qOQh+ZVc+quMCJVzTb9u5D94tUHYYaivXrOM0kQu8r?=
 =?us-ascii?Q?K9r72tPtrG08b5hWengarLjdDu97j4sfPR2TJ4RBLgaT7TitMr3NxHrvPaYA?=
 =?us-ascii?Q?rnHnlGaMvVrQ5Kskogt+bAOXCHSb41KyPpvbY3Ck7G0Jrg1yVhlkAw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 14:50:12.1645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c93f6f21-7514-4d88-7303-08ddf9e7556f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9783

Hi Mark,

[...]
> >  	case SYS_ID_AA64ISAR3_EL1:
> > -		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX;
> > +		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX |
> > +		       ID_AA64ISAR3_EL1_LSUI;
>
> This should be added to set_id_regs, but ID_AA64ISAR3_EL1 isn't covered
> by that yet.  I posted a series for that the other day:
>
>    https://lore.kernel.org/r/20250920-kvm-arm64-id-aa64isar3-el1-v1-0-1764c1c1c96d@kernel.org

Thank to let me know missing to add kselftest feature for this.
I'll add it :)


--
Sincerely,
Yeoreum Yun
