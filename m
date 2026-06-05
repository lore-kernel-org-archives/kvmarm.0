Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB223D1CC1
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650527; cv=fail; b=YlsOUoiYkqCUGha+3KMvWG7Xx8VYvnkqRbU82+KSjlhaBD3Eyo7aDS6XFxt4bq1h0HFw0dl64b4aCLpMkqH9Oh0OoPr7KnEFkxR5iCj3VUGYsrC1RG7z+R2VQLPtJg2DHU6O6B1ZhVsEo2/nv6P6ACDE71+nO3GV87Qjxk1roRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650527; c=relaxed/simple;
	bh=yq4ho+KiNk9H2P1zE4hT55GEuOl5FcTDlopA9ZcpUlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rigdyE10gonZ/f7N233h2VGAgOkPxu8tCOlKdtT2MAxHJTcBIp7zBodLwVg1xo7ie0eQaKvkfex3G4HohmnaIWkTfdArTxMUvPe4bCCdw1toXbO+b+KTzgaHy5xJuexwNZlhB/ux0ogIUL+dyWap4VQm2E/gAUJjOpgVm5UizkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VfpD4ljI; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=C3swA+vg; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VfpD4ljI";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="C3swA+vg"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLS854749;
	Fri, 5 Jun 2026 01:43:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ZfW5OtIbsHhs+Su8dwgQ67EQ8B25FsGHHk49+l9J4
	Rc=; b=VfpD4ljIRuG1wmFheFctcuzTuUXuPJ4EY1EmT0/zrK09XyOWfu8gUaWgc
	uB9gnp/B8apc113EPaiJBA7GfAsqGe6rgZRCXMQuSiDM87fezMhL9V0ea2jtzJ52
	8dvMtDi8FRRgw1pPleU1YpcT0nldtXjVfBXODaF4v95sAETmInvgCpAGlEUeMiiv
	HDzf0ymm56+35u/g6IeuPV0PT8D9nhqZ24ieIW2WfL7YEPmjXEGWpsgJVku4zpUA
	9S+f3r9yy34LyWy99LWdzmBH7D+58xgOW9pgetlWn7WrZHgg6uve6mT560mnUhKD
	vxXSuyUVZTXF7yFfi2y+dMC5X9lZg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-9
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=endqdnWHiPnIx+kdHqdX0FaJPH2Tqj4M88gUlOADYcEdkD4QcKn+mcQBKEoNb3Wq8Wjic9LPoAJR1xrCeHrgwslnQZ4ywrTet0fwNgY4yq+d0rgApbU17xIAHFeadc/aood0GVkSGeaDrLfw2Z4l+JGVvkZ5THx9Xd1EcNlm20oE8oqmD1KAv4oIF+I30bMF8qWjCCv++zlSzs2SW9p4NoxLqKYRlZXuGPIVnRGpJXfu0Q5DEBHzUg3xb8YmeevjlVA6/oCveSk1LGGc96GwRtBYVj3WmMLQ3UwVWOxELsIDvC7IFEW26HMfwFYJL9dmuGqAryf8heoABbbNGIwVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfW5OtIbsHhs+Su8dwgQ67EQ8B25FsGHHk49+l9J4Rc=;
 b=wJYKni5d9hFlw8OBSLcdHwGoNAhBcze9eE5zBa3SQUaxPsLEevmUHDZuVlru3Xmh9unObdhktmw8I1e1eK1bncurMzGakeBfj/xhAh6ddXf9UPioep8CysU6UF81iV0dJSqTMJyZKvo20tBAGbjKjhvT9WXmAhHWK9xkqd09RcDyBM64x+2+gR0MhLc1QAZtostEBSCC9y5qH64+IxXOnv9gYjlsX22PjtnTS4WGbMbHi9mkt1dKZGmjfyslnzc9CG39bhZwQuH+4shgEXZgSHUffyEfTFkBqsWmsb8V7wQDKDErrcxvhwFNIF2u2QimImq72yMZPx4UgKEQ2EEZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfW5OtIbsHhs+Su8dwgQ67EQ8B25FsGHHk49+l9J4Rc=;
 b=C3swA+vgESeiaDrUDxr4n6hJEZelaufR/hDg+Cgr4B5CIF+EP3rdWgguWooc1pmoL1RLX/T0YnTxslY5oZl4aHpUMQP6VuFZ4kkbPaX2cqHBhl+iZoO8hdTZo4tXGjM+pngT8fku9bUi7hXIJJE2vsIpTaamQeUuAWYSEifUG5b95aSu81fLwy8cpig4OpRrA5V1rUs4PWzCeQWjD6O8jYg1O4pm8eJtpw48Wh5XZTobZ+asu6dyx1ZNsFjCf88Gg9e83gvtISSkpeYwSGg1oWeR0P/+8zpTFAEsjOEb7+frYsXBtQxIu0vbAhp9DmpZAj9Ys9CXidkCeMB0qaDVVw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:12 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:12 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Jinqian Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v2 08/29] target/arm: Add ID register field helper functions
Date: Fri,  5 Jun 2026 08:33:37 +0000
Message-ID: <20260605083358.1320563-9-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260605083358.1320563-1-khushit.shah@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:510:324::18) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 03241429-5bd6-49b6-7972-08dec2de79d3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DTtXRlODqd6FaUvczzWtgrighbnKDdXzYoEos9Mrwo2w1vpkOob2HA/og1MqFM33tyyOKOzqvfhZIYb1+qbFx53ceiczAX7rSuwJixqVi63zwyi6l6JNFstBmdrlEQicnb9ddaLdx/4Rrs7VXE0Uf2y4KX+puqj6E8JVWDgy5FibBKGn6g3LfemxnBMNsxkUImY/DQNf0fu4CmbRMpBPc0zdreKtphgheCcr1gbEJw19oRYRhasiI0rBhbYMcLMN3RNzO73k9GdOFqnbW+Daj1exIq8HkLCK5Kq+zJ0KCuT7S/oy0y2gggiVCYtfHpSL1VO9BbNsjoxyOonH/e0CH0M5zN4+XjR2v5uNCqOXT3N96i9L5mI2CtCNEpVcH3E+kKWzGIWwkejsG5xdpfc7taX/ORU4u3+EvUE1FFQ0Fh9a8SB153w2dTPultIFGCc8mvxJCxQdYl5sUz4h2resbgJzHzi/BU+0zAd1hNlRlY432vu5YjZsi+8KyMx7I+CRC6jyk0guoO9t9/RO2cv3B7c1HQODbi46392ekFhGaL7QrS8GaB/D4GIORV5Y0DU+Pf5KTxA1moON2sZ6Y4EGpNjRwNyR9gxEknlklPED3MvURwfmgGcQfdmJvaV2orJRbg/jQf0LhhiUd9x1KYDeGutpL1aODlF4Nmc1j1t7Y64eyqjW2WnziQu9Vrk0UXtp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S/YwS9XeX3EZxdkzlc2dMQEBQAY6IfjFOSLZTUh2TggXTMFpGDfymvufEcEv?=
 =?us-ascii?Q?BhXxDl1KMuEbdPz5nYEX7RpI9EBjh1wdq9zNS7Rw56IrfZ3rgCzJHAm5+3BC?=
 =?us-ascii?Q?Qo+8ZmjM+zo8FAlmENUAvfGEeJSTBO0JsYEPTqK72BREDNUntX1ekbiKS6Y3?=
 =?us-ascii?Q?NPVn3Wf4G23DIJxYO/mEGvfKDPyrTN5jckNGgLk61mg+oaealVxuugiIIadr?=
 =?us-ascii?Q?wnB1q87VqrZdOp1gRBUi6cHmPgRtfwSEVr56lQEzGeq1oUBdVBeTL7U5aFFZ?=
 =?us-ascii?Q?bUOsUDXaNp9sCnM/qndgSSbPKpj2ICJaVgzj/2o0vFzD0rz8T7Y5AQ6crZNX?=
 =?us-ascii?Q?6laMmIo3aRGPOnjyHpBiXacuI1jEqUNDkZvRqJJXN18PEfH5SzWORRms05bg?=
 =?us-ascii?Q?HYHPhtOdBHWQwDe5LmQuriFdXHQfJC4iz1JU6MGpAPHPaxd76M8EgZ13SIr8?=
 =?us-ascii?Q?tud1c5Y7kYHvhodcboyZXi7gwdlRUJpftED0AlfPM7weGHgiOpDLNJRV+ocW?=
 =?us-ascii?Q?TgNHJ9ei9ftpPrwSXJp0oAtngKX7ebJypJYDqBS+xSspDGdYwHj9E0cCy9Ny?=
 =?us-ascii?Q?smgTh3NaRQaI9tbkFjXwsWk2IhsOGX0oGBM4pYwO8exx3pVUcNmWtpcqvG32?=
 =?us-ascii?Q?63iNPnI47q5kWr35cjzPTcEBGYA/8u9xXzgtDZO2B52RYrFS+BK1ii5H5gVY?=
 =?us-ascii?Q?r6/oNZGG2bl9L86o6w+Kq+OpW+o+eNW+mFrr8/Wdl1MlpO/yImLsbOrFPWaZ?=
 =?us-ascii?Q?QlMDe5nIqnLBdWnd+QFUThahRHC4T2U/ubBk3PyPTYyQWhCdAATLrty4zYTH?=
 =?us-ascii?Q?LAaFHiny+hjcnP3MbZEF83gzGI+NdXluLmCBzE7X4aihP6UT8rEakCAfUoOn?=
 =?us-ascii?Q?GBblX9nLSmMd60MTHHA+uegIZT+QbxfXMvrDtuoLCzFd+nn645E8YqOfzoGF?=
 =?us-ascii?Q?pp85lU8eoCcjvYh1+ZpFfUHPdw/V5sKbdP9IJSsbCByaD5CO1THMKu9foVeU?=
 =?us-ascii?Q?0gCryCH95D3S6hrWZTk5eMyoeOdirv/8PuBHfJTI40Nb0bNdVSvgtXQpJA4N?=
 =?us-ascii?Q?6jSWkM4Uu5q3IzxTs2aJXo+L74uoICrCd+X+Bm+I87Ebg1iGLGEAV6l1F0mo?=
 =?us-ascii?Q?lxlxh0uHBXmMc0Lp6ByQWHa3rmV+d3TPtliCg2OBC9/U74ZpAgvaZwiyu+BK?=
 =?us-ascii?Q?78PHvw9Swosdqs0f0zbFZRt1fQ+JB3jlgggbbPGguG+q2jsQMQ5J1YuPhcWH?=
 =?us-ascii?Q?0oFXNQeANx8Uvkj5wOCitbXSecIHPck0Fl87DwH6ExrnFpBlX4CLggjU8lnL?=
 =?us-ascii?Q?tOtt5ei8AdyMEcZOT/hnDCC2pOmTcm7SN+cl3tppvnd4BTH4vc4XVgdDOtQr?=
 =?us-ascii?Q?jUJC5x+QIi14oVdcozNDJa+pzE+m36hfe5PZL3ehGZ3rZZPpiJPUCsZi25W+?=
 =?us-ascii?Q?dJ8mv/Ng4390SbsOMs1AWoQpH095yhqDqZf+ynn1H8JtJaTmYswQAf0kC3vy?=
 =?us-ascii?Q?O1ufgVv7fvGtrtH+Qim5RmDalHvb0OBhwyPe5D5AHdoX/ZTUhGjOMqVTeatu?=
 =?us-ascii?Q?G2CMg/dfVW02Y4katMWoOkKjYYfCE26fGRNCJWstKDJUkv5QXaFKEkZGZCOK?=
 =?us-ascii?Q?XHxOj/05+kX/ofE4sLHKqP+B4POX32YWSrpfkU5uJHyfacOY6CdfiE21Eoxo?=
 =?us-ascii?Q?Gu5yDBLqoFEF+GpasfyzTTIHkK8S4/1Pp0HQ95M6lp2YsqH6QxseF4Yp+JXt?=
 =?us-ascii?Q?Y7ydydlL7/I7CYvKcYcQdLP66gi34PU=3D?=
X-Exchange-RoutingPolicyChecked:
	mCpK5IIZ9N589GIzVSU7mBJG60+U9ljIYnLzewcmYqkMjuEOoXJYCAqNvW7MqnY6Z6rm4FkfWqbVLb/fd8gKza6RcbME4gHB6BulrvGU1kZN7UEPFSbrbdybKya+XyWQCjszBEPbNpHpI7T0pLqTVkLLJYRhmyIzYSqLwEd4fk/q5VeCx5B7jsBs76nMT4w63K3qyt2YuFvH0jYnV1QFmAdLQf3wAdjTSskK/a5BKtc+ycDcto4dr8O3NoNxw2/376v4ZQsNbMXbizMw4F78c3fvvPHrSUsS8lItX+7hygo48+oz7rOeZNIq3FCriAwpCy8QCkbWs34ATfMCyWYSnQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03241429-5bd6-49b6-7972-08dec2de79d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:11.7329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIXrB/DhGmy2kX38BHpKEhdOzNZmA6B4GO6Ws7xhp4ydhScYH8NuD3tQvRABk8mO21Aai3DKK5sZbSONIsnSsU7dfa3CryYXzhDI/gMw8TI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: f-2BgiJD5gIUB6bTTnkB223mJKuHc9rv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX4ExxihbRBNk5
 MucfXku/4Nvkq9QGfKfO5E81yPYLjVAeju6wEfNXXBYyEmHFpIjZmnOnXZR2XFIAPovj2ZK2xxO
 t0YKxD8M8DHhFezRypmRwRS9qegEpJGnOGCkOMii7E+mtzpP3P4NxChYai32wkk/TkMZkd9BhyN
 sgZwuBxgm3BK11Nh1XPK0pDPvwgBIclRwLgHvbfzb+/ce7JvYobckslOs8W5wFB5arlLhcjHRuL
 5iUOrr17Z98kcuHyrrA5GzXwkdwaUZCl4TKYbNdeJSMLslcyUc/S5+UyIYeEnhf/D1mFUU5IF8O
 WTcwNqf6qGG3HAxw4hphyP/z7rUTEnLMzO1qmifpJGkvzbGuCuTgeys1kqWa0XtGb2FZyOnYfzV
 dFyddq7vWRnIw/8n7wOXPQHO7w5iQ70j4flgmX38FQHMu83RQrpdNJB/cYK3i0GL0oyQx/+4+L9
 164+/Y76p5AOyUFdNmA==
X-Proofpoint-GUID: f-2BgiJD5gIUB6bTTnkB223mJKuHc9rv
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c23 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=slIbVy7XD4hZSBV9b_MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Add helpers in cpu-idregs.c for working with individual ID registers
and fields. This includes:
- read/write specific field.
- look up architectural value name for a given field value and vice
  versa.
- reset a field or ID register to it's default value.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-props.c | 246 +++++++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-props.h |   8 ++
 target/arm/cpu-idregs.c    | 119 ++++++++++++++++++
 target/arm/cpu-idregs.h    |  11 ++
 target/arm/cpu64.c         |   2 +-
 5 files changed, 385 insertions(+), 1 deletion(-)

diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 1c5d4c5727..d5900c0e23 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -18,12 +18,26 @@
     { .name = (prop_name), .type = ARM_PROP_##_type, \
       .u.field = ARM_FIELD_IDX(reg, fld) }
 
+#define ARM_SINGLE_FIELD_PROP_GS(prop_name, _type, reg, fld, _get, _set) \
+    { .name = (prop_name), .type = ARM_PROP_##_type, \
+      .u.field = ARM_FIELD_IDX(reg, fld),            \
+      .get = _get,                                   \
+      .set = _set }
+
 #define ARM_FRAC_PROP(prop_name, base_reg, base_fld, frac_reg, frac_fld, valid_vals) \
     { .name = (prop_name), .type = ARM_PROP_FRACTIONAL,                  \
       .u.frac.base_field = ARM_FIELD_IDX(base_reg, base_fld),            \
       .u.frac.frac_field = ARM_FIELD_IDX(frac_reg, frac_fld),            \
       .u.frac.vals = valid_vals }
 
+#define ARM_FRAC_PROP_GS(prop_name, b_reg, b_fld, f_reg, f_fld, valid_vals, _get, _set) \
+      { .name = (prop_name), .type = ARM_PROP_FRACTIONAL,                 \
+        .u.frac.base_field = ARM_FIELD_IDX(b_reg, b_fld),                 \
+        .u.frac.frac_field = ARM_FIELD_IDX(f_reg, f_fld),                 \
+        .u.frac.vals = valid_vals,                                        \
+        .get = _get,                                                      \
+        .set = _set }
+
 const ArmFracVal csv2_frac_vals[] = {
     { "0.0", 0, 0 },
     { "1.0", 1, 0 },
@@ -240,3 +254,235 @@ const ArmCpuPropDesc arm_cpu_props[] = {
     ARM_FRAC_PROP("feat_NV", ID_AA64MMFR2, NV, ID_AA64MMFR4, NV_FRAC, nv_frac_vals),
     { .name = NULL }
 };
+
+static const ArmCpuPropDesc *arm_find_prop(const char *name)
+{
+    const ArmCpuPropDesc *p;
+    for (p = arm_cpu_props; p->name; p++) {
+        if (g_str_equal(p->name, name)) {
+            return p;
+        }
+    }
+    return NULL;
+}
+
+static void arm_single_field_get(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                                 Visitor *v, const char *name, Error **errp)
+{
+    uint64_t value;
+    char *s;
+    bool b;
+
+    arm_idreg_field_read(&cpu->isar, p->u.field, &value);
+
+    switch (p->type) {
+    case ARM_PROP_STRING: {
+        s = g_strdup(arm_arch_val_name(p->u.field, value));
+
+        if (!s) {
+            error_setg(errp, "Property '%s': unknown value %" PRIu64,
+                       name, value);
+            return;
+        }
+        visit_type_str(v, name, &s, errp);
+        g_free(s);
+        break;
+    }
+    case ARM_PROP_BOOLEAN: {
+        b = value != 0;
+        visit_type_bool(v, name, &b, errp);
+        break;
+    }
+    case ARM_PROP_NUMERIC:
+        visit_type_uint64(v, name, &value, errp);
+        break;
+    default:
+        g_assert_not_reached();
+    }
+}
+
+static void arm_fractional_get(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                               Visitor *v, const char *name, Error **errp)
+{
+    uint64_t base_val, frac_val;
+    const ArmFracVal *val;
+    char *s;
+
+    arm_idreg_field_read(&cpu->isar, p->u.frac.base_field, &base_val);
+    arm_idreg_field_read(&cpu->isar, p->u.frac.frac_field, &frac_val);
+
+    for (val = p->u.frac.vals; val->name; val++) {
+        if (val->base_val == base_val && val->frac_val == frac_val) {
+            s = g_strdup(val->name);
+            visit_type_str(v, name, &s, errp);
+            g_free(s);
+            return;
+        }
+    }
+
+    error_setg(errp,
+               "Property '%s': unknown fractional value %" PRIu64
+               ".%" PRIu64, name, base_val, frac_val);
+}
+
+static void arm_cpu_prop_get(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const ArmCpuPropDesc *p = arm_find_prop(name);
+
+    if (!p) {
+        error_setg(errp, "Property %s not found", name);
+        return;
+    }
+
+    if (p->get) {
+        p->get(cpu, v, name, errp);
+        return;
+    }
+
+    switch (p->type) {
+    case ARM_PROP_STRING:
+    case ARM_PROP_BOOLEAN:
+    case ARM_PROP_NUMERIC:
+        arm_single_field_get(cpu, p, v, name, errp);
+        break;
+    case ARM_PROP_FRACTIONAL:
+        arm_fractional_get(cpu, p, v, name, errp);
+        break;
+    }
+}
+
+static void arm_single_field_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                                 Visitor *v, const char *name, Error **errp)
+{
+    uint64_t value;
+    char *str = NULL;
+    bool b;
+
+    switch (p->type) {
+    case ARM_PROP_STRING: {
+
+        if (!visit_type_str(v, name, &str, errp)) {
+            return;
+        }
+        if (!arm_arch_val_from_name(p->u.field, str, &value)) {
+            error_setg(errp, "Property '%s': invalid value '%s'", name, str);
+            g_free(str);
+            return;
+        }
+        g_free(str);
+        break;
+    }
+    case ARM_PROP_BOOLEAN: {
+
+        if (!visit_type_bool(v, name, &b, errp)) {
+            return;
+        }
+        value = b ? 1 : 0;
+        break;
+    }
+    case ARM_PROP_NUMERIC:
+        if (!visit_type_uint64(v, name, &value, errp)) {
+            return;
+        }
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    if (!arm_idreg_field_write(cpu, p->u.field, value, errp)) {
+        error_prepend(errp, "Property '%s': ", name);
+    }
+}
+
+static void arm_fractional_set(ARMCPU *cpu, const ArmCpuPropDesc *p,
+                               Visitor *v, const char *name, Error **errp)
+{
+    char *str = NULL;
+    const ArmFracVal *val;
+
+    if (!visit_type_str(v, name, &str, errp)) {
+        return;
+    }
+
+    for (val = p->u.frac.vals; val->name; val++) {
+        if (g_str_equal(val->name, str)) {
+            if (!arm_idreg_field_write(cpu, p->u.frac.base_field,
+                                       val->base_val, errp)) {
+                error_prepend(errp, "Property '%s': ", name);
+                g_free(str);
+                return;
+            }
+            if (!arm_idreg_field_write(cpu, p->u.frac.frac_field,
+                                       val->frac_val, errp)) {
+                error_prepend(errp, "Property '%s': ", name);
+            }
+            g_free(str);
+            return;
+        }
+    }
+
+    error_setg(errp, "Property '%s': invalid fractional value '%s'",
+               name, str);
+    g_free(str);
+}
+
+static void arm_cpu_prop_set(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const ArmCpuPropDesc *p = arm_find_prop(name);
+
+    if (!p) {
+        error_setg(errp, "Property %s not found", name);
+        return;
+    }
+
+    if (p->set) {
+        p->set(cpu, v, name, errp);
+        return;
+    }
+
+    switch (p->type) {
+    case ARM_PROP_STRING:
+    case ARM_PROP_BOOLEAN:
+    case ARM_PROP_NUMERIC:
+        arm_single_field_set(cpu, p, v, name, errp);
+        break;
+    case ARM_PROP_FRACTIONAL:
+        arm_fractional_set(cpu, p, v, name, errp);
+        break;
+    }
+}
+
+void arm_add_cpu_props(Object *obj)
+{
+    const char *type;
+    const ArmCpuPropDesc *p;
+
+    for (p = arm_cpu_props; p->name; p++) {
+        switch (p->type) {
+        case ARM_PROP_STRING:
+        case ARM_PROP_FRACTIONAL:
+            type = "string";
+            break;
+        case ARM_PROP_BOOLEAN:
+            type = "bool";
+            break;
+        case ARM_PROP_NUMERIC:
+            type = "number";
+            break;
+        default:
+            g_assert_not_reached();
+        }
+        object_property_add(obj, p->name, type,
+                            arm_cpu_prop_get, arm_cpu_prop_set,
+                            NULL, NULL);
+    }
+}
+
+const ArmCpuPropDesc *get_arm_cpu_props(void)
+{
+    return arm_cpu_props;
+}
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 2c9bca9d97..9ba3f4c100 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -11,6 +11,8 @@
 #define ARM_CPU_PROPS_H
 
 #include "cpu-idregs.h"
+#include "cpu.h"
+#include "qemu/typedefs.h"
 
 typedef enum ArmCpuPropType {
     ARM_PROP_STRING,
@@ -36,6 +38,12 @@ typedef struct ArmCpuPropDesc {
             const ArmFracVal *vals;
         } frac;
     } u;
+
+    void (*get)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
+    void (*set)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
 } ArmCpuPropDesc;
+void arm_add_cpu_props(Object *obj);
+
+const ArmCpuPropDesc *get_arm_cpu_props(void);
 
 #endif
diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 81661dfca5..ee6165622a 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -10,6 +10,9 @@
 #include "cpu.h"
 #include "cpu-idregs.h"
 #include "cpu-sysregs.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
+
 /*
  * Generate an array of architecturely defined values for each field
  * in arch-value format
@@ -123,3 +126,119 @@ const ArmIdRegFieldLoc arm_field_locs[ARM_FIELD__MAX] = {
 #undef IDREG_FIELD_START
 #undef IDREG_END
 #undef IDREG_START
+
+void arm_idreg_field_read(const ARMISARegisters *isar, ArmFieldIdx field,
+                          uint64_t *value)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint64_t reg_value = isar->idregs[reg_idx];
+    uint32_t shift = ARM_FIELD_SHIFT(field);
+    uint32_t length = ARM_FIELD_LENGTH(field);
+
+    *value = extract64(reg_value, shift, length);
+}
+
+bool arm_idreg_field_write(ARMCPU *cpu, ArmFieldIdx field, uint64_t value,
+                           Error **errp)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint64_t reg_value = cpu->isar.idregs[reg_idx];
+    uint32_t shift = ARM_FIELD_SHIFT(field);
+    uint32_t length = ARM_FIELD_LENGTH(field);
+    ArmIdReg *reg;
+    ArmIdRegField *fdesc;
+
+    if (length < 64 && value > ((1ULL << length) - 1)) {
+        reg = &arm_idregs[reg_idx];
+        fdesc = &reg->fields[ARM_FIELD_REG_FIELD(field)];
+
+        error_setg(errp, "value %" PRIu64 " is too large for field %s.%s",
+                   value, reg->name, fdesc->name);
+        return false;
+    }
+
+    cpu->isar.idregs[reg_idx] = deposit64(reg_value, shift,
+        length, value);
+    return true;
+}
+
+static const ArmIdRegField *arm_get_field_desc(ArmFieldIdx field)
+{
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+    uint16_t field_idx = ARM_FIELD_REG_FIELD(field);
+    return &arm_idregs[reg_idx].fields[field_idx];
+}
+
+const char *arm_arch_val_name(ArmFieldIdx field, uint64_t val)
+{
+    uint32_t i;
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    for (i = 0; i < f->arch_vals_count; i++) {
+        if (f->arch_vals[i].value == val && f->arch_vals[i].name) {
+            return f->arch_vals[i].name;
+        }
+    }
+    return NULL;
+}
+
+bool arm_arch_val_from_name(ArmFieldIdx field, const char *name,
+                            uint64_t *val)
+{
+    uint32_t i;
+    ArmIdRegArchVal *av;
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    for (i = 0; i < f->arch_vals_count; i++) {
+        av = &f->arch_vals[i];
+
+        if (av->name && g_ascii_strcasecmp(av->name, name) == 0) {
+            *val = av->value;
+            return true;
+        }
+    }
+    return false;
+}
+
+bool arm_field_is_idreg_any(ArmFieldIdx field)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+
+    return f->arch_vals_count == 1 &&
+           f->arch_vals[0].value == 0xffffffffUL &&
+           f->arch_vals[0].name == NULL;
+}
+
+void arm_idreg_field_reset_to_default(ARMCPU *cpu, ArmFieldIdx field)
+{
+    const ArmIdRegField *f = arm_get_field_desc(field);
+    ARMIDRegisterIdx reg_idx = ARM_FIELD_REG(field);
+
+    cpu->isar.idregs[reg_idx] = deposit64(cpu->isar.idregs[reg_idx],
+                                           f->shift, f->length,
+                                           f->default_val);
+}
+
+void arm_idregs_reset_to_defaults(ARMCPU *cpu)
+{
+    int i;
+    uint32_t j;
+    ArmIdReg *reg;
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        reg = &arm_idregs[i];
+
+        if (!reg->name) {
+            warn_report("target/arm: no field table for ID register slot"
+                        " %d; cpu->isar.idregs[%d] left at 0x%016"
+                        PRIx64, i,
+                        i, cpu->isar.idregs[i]);
+            continue;
+        }
+
+        cpu->isar.idregs[i] = 0;
+        for (j = 0; j < reg->fields_count; j++) {
+            arm_idreg_field_reset_to_default(cpu, reg->fields[j].idx);
+        }
+    }
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 37a87e6d0b..01d1b8f797 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -74,4 +74,15 @@ typedef struct ArmIdReg {
 } ArmIdReg;
 
 extern ArmIdReg arm_idregs[NUM_ID_IDX];
+
+void arm_idreg_field_read(const ARMISARegisters *isar, ArmFieldIdx field,
+                          uint64_t *value);
+bool arm_idreg_field_write(ARMCPU *cpu, ArmFieldIdx field,
+                           uint64_t value, Error **errp);
+const char *arm_arch_val_name(ArmFieldIdx field, uint64_t val);
+bool arm_arch_val_from_name(ArmFieldIdx field, const char *name,
+                            uint64_t *val);
+bool arm_field_is_idreg_any(ArmFieldIdx field);
+void arm_idreg_field_reset_to_default(ARMCPU *cpu, ArmFieldIdx field);
+void arm_idregs_reset_to_defaults(ARMCPU *cpu);
 #endif /* CPU_IDREGS_H */
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index a93ad2da5a..7fb3791643 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -37,7 +37,7 @@
 #include "hw/core/qdev-properties.h"
 #include "internals.h"
 #include "cpu-features.h"
-
+#include "arm-cpu-props.h"
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
     [NAME##_IDX] = SYS_##NAME,
-- 
2.52.0

