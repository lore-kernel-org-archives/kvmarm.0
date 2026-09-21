Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E33264EA
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994038; cv=fail; b=H/05+/8oO8uO6N3Na6qxY1qRL7YrMw84ymNNiRXAg86d27Bo9JO2v53n7DCQm97scdcQIObrpYLNTpoo8w29DCSw4t3Djki0+5jdDrt7q/PfyxO3CZSygZaLc/sJSote4/zTB08O24Zx4H2uaP3RjBs+jsxrZLs9LQlHh9GDaU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994038; c=relaxed/simple;
	bh=amdPKk0clWtaxZYwxdZAahjNB1NycoQbciP2emZT5T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rqcjk6lkFf7GJuBceSjryTUAM38FKDZylVS2xDjxH4LjfuvRqKQeIiKgEXKHU9VbOO28Am6r5rYJhK7tEOKJ9NvlHVqaTTm/NGvU2E1bKn97hASxXSQRij4zBFopdZ57tNk0lgFAc4Snzd1ynJyIsSOEENSPR4L0kvPMHo3rcgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=b/xlTAgv; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=L1Beays7; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="b/xlTAgv";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="L1Beays7"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhSBs932490;
	Mon, 21 Sep 2026 05:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tpg4UfrkqHrIYs8+kzXIp2L9JVuzrbyVyG5fgyqp8
	4o=; b=b/xlTAgvkVwj9Rb4JAgLarOtWjUBUbzrKIzdH1WKW9xVKpn8d08zF1Weo
	E+wmvrMReunYXoMq4rXhaSfCBONvxsG7liwt/uRwvIrOj/67VFKTqvOFj4Z2leT3
	m5RmExJ2loB49Obe7PFBMysLMT/Y4gkd8bH/L38+r9u7/ZGNn3Wtxi6kq9yQMy4/
	M6bOpD+4TTKpUr8F5m170jSm6OTylS4pI7OISTQx8rHVM9CZY0bZ51qKt1/ZHAWw
	c3D+DqMkzXE+JOo00c3Oa93vclW0b8Tn4orr6zWwo7s7e9u0B6Uwpwl3esapHE7w
	vwP2CN6Elo5p4rAY/wb30Wayd+eXg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022095.outbound.protection.outlook.com [52.101.43.95])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gssxwkc93-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fg47ily1TxfY13DlmlHTcmpmxCg4M9QsmZzJTnIZCxjFLkSUiEZ1MLlzpE6ur91pKVRaPnmDBqPSuMsiCWOicLgzmQSAjm3UKg149sTkL2DHfdhrxsQFkcpboElLle+94puBbgu3nbv9YIgNJLoGmofqnM1nYkJTT3f4rEz3qFnJKptJM24pAmCC1DDxrYVJPbcSyielAzP38/m/UJEu9U2Tin0dBRqABYbBl6C5KeTqW8t20tqCm8oEGq+B15GLxGQol67EAjty+xvYV1G22BGylsfWNGMZdB1g5nYSEDHEQoqWf7A7/iqdfNosBqsLOrE88tjtN4B2gzGS3EptvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tpg4UfrkqHrIYs8+kzXIp2L9JVuzrbyVyG5fgyqp84o=;
 b=X10nK0TfujYJfPyDsCyYrbBzUTOHHbbMaI0OkRZzwy2BYxrQdcByPjUQ1aYCfUsYTxLgpuay0xvAAO1jHr8qaQ1aqc99X+nTZWvd3Gk9GflyNImpQLUKA42XEm7jC/eP++CkAeRKds5OIZkGwTktO0ni1RSz1GP/9OdABH2D3UgWreXOt36GbSEzomInBvivM9WIpP82L6SbvCwqC1+QNMyOOZB2a0PqAFosaiJF59mM3s7aBBSrkb+tGh8JvPxBJYiuLNlQCVu3fYcofW51Pc+9TYvyg89j7scF+T/32QzL/Z7bBpqYEqdAKAvic34l1RTvBSuvmd7e9F0NoIH5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpg4UfrkqHrIYs8+kzXIp2L9JVuzrbyVyG5fgyqp84o=;
 b=L1Beays7lEVh7gb7ThfipqYGImrn5xmCFm1HWDUxScBFIzpy76A7tFKtb4Vg11Q+7kRr/DWvB1jS1cVhjadG4d9vEFvc0w8+OtoWTLVaZarDRD6fghQWyAkLPWZGltOzM3LeOAGn2WGF7XkSqRwCzBxf/RoalzZUxrxpXduXRNE0BzDOIZWwMKzTZypjIXIBSXEcn4JNSxukhhG1hnJl6lI+xG7X+sL5Wkj99qXQAg36GglOq4YxtMAQU38YYjS7d5EMuqKusFLmMgCvNsuy8smzgilzQjel/Ka6IiKWQAashTg2Z8PuCs2l8TOezhK2cyLT6K8lQwmaTxixGoVU3w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6868.namprd02.prod.outlook.com (2603:10b6:a03:234::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 12:33:38 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:38 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 20/25] target/arm/kvm: compute host-supported values for ID register fields
Date: Mon, 21 Sep 2026 12:32:44 +0000
Message-ID: <20260921123249.1708067-21-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: 397cc356-9a5c-4766-519a-08df17dc8fde
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|10067099003|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Z4xUpAp+1OwnlQgx/HW8OKfq6ZmoDd/PT+gC9Do7Fb9BPmuXLMlSixjxwRsOqxMWOnQczmqu/JuX7fA8skL0GnTbHnJbckw0vsTVevCdUnk1gwPx8rUMb/x0rrXeCJqAjdrerg4uyhudjsNTGv42+Xg7UGMNh9QqqVQog7o7r3g+Fe/a1tnzp1P0lOA8mwowr5H+DDfVaRcORgrshsXg29VAreJOf6MbPsnWuBDe/5bUBszBmeGIUVTSJwONWt2Me1tNkdZlx9ztpsyUy4ksdy2gnrSBZeOWzKMAXCMVsiH6qxFHOvAIP1Fy/59bvDPo4UD2fgZtVfsmjXnbhUczroNSS0tb0ShVlSfA3RcPlaFwMHMzS44zMzYh8O5R/6SThFuh9QDUKCee32E0ra+mKg0m9ycSflNXreIW0+mAaz+mZuqmj/a2BvLgd5rUvjkTDAUvZ2Hf/JVoq9Dv4iWDdU5g80EKbaDVWZLqH7coRKQxVcGXExC9gtNmaENv+dHfx4v3t2liGwHgrejM+3NSpQMOruwlEOfe/fC9Vl+9KcJIf0bduX805X8loX45UL9lhTD+lP+L5681eFr3+mZjOtE5ifoMm7JIFlGykSkFIjV9KiRjYQQzRGO+bQmbqsqltD7XueWU9coUi7nEAv3LhcWGgI4N1JG8GfV/DoAR5+A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3U2x9C6RgrvvVPD86g/x/yQQbGImJpgSNXqLD+rawlGMORczSDDGzimNU0Yx?=
 =?us-ascii?Q?RAZ1dvpRepRL0Oiuj37P9Si4sSnUOEJpuX6apbyB1u53einE+qEF8tP/UCFf?=
 =?us-ascii?Q?HDYRlfj5ssnqJs1og3md1cZ0JXnRoqOlLhHSZOpR2Y/PCrjMQMCS8U/2cyzO?=
 =?us-ascii?Q?3hyzrIwEQ6JWT47vNmZeD4KgaZ04+GuJDDMqcuF6pYUl1iIRAetJUrlPMCR0?=
 =?us-ascii?Q?CQWWzRVvzMuft8uT5On1AT7NZvZAH1eWGwopS8XYOi12Gj5K1xvxdMx4j6vq?=
 =?us-ascii?Q?/nDBoQ1CDdTeVh3i8eD13Gt//KyEzzTbbSl5iDmXTPrL+qUcMzdX6AcKCttL?=
 =?us-ascii?Q?iyAC505Bmo+B0/39yAndQLYbxUqmCsyvEFg3dRx+mleXjTv0H2TZptru1/t9?=
 =?us-ascii?Q?saHh4JeAoQmpfwsvgMcq+kOA3o8RS+qwgJAfZLH87c9+bhkx9bQERSoCL/0H?=
 =?us-ascii?Q?o30lnfJr8kxlPWPU8hCkBm6BRcm/rv09He30KLnTgEd1yN2VftZcgY6EQ34g?=
 =?us-ascii?Q?/jdMm2dE5+HjeKeOPdNI5MpH51E3jnvL2AApEVZq4lpk2Vdf2QyUR0y7GkEu?=
 =?us-ascii?Q?HNfVJ3e4s8DI9jYv/cZ3jf87uKKg0sLcuCRbT4IHlq1HQBgxmv3yWyWw2kv/?=
 =?us-ascii?Q?mG4sPoBPlcawtwPH1R72xk3Pvy/4BuYkX3CJ9ywuCSQ1XmJKZl9Q1r7S3Q9I?=
 =?us-ascii?Q?D4e8zEzj4k+QeMGmTJpfYrmpaYs2141R38KQhP1wHWsQf/ZNcMZtgWuiwvCy?=
 =?us-ascii?Q?IcVGEoi2jebMuIkglyJXQD5C0YZEyZyY8RasVUtQzrOybNfcKCzmjLYlc6MO?=
 =?us-ascii?Q?bl2bq+WWfT5Aew6wtBH0W907sSl8oGwpBwjrED05BmIy9v9IhBldb9FQF5o8?=
 =?us-ascii?Q?C5zmpFCjE4Gc9bkcgyoGBGp3qUC5+V+QmrXIfyD5jM6k/muFoVlJ1QDOPmLD?=
 =?us-ascii?Q?mCNwxWI3WSs1CdY+R3kuakkqFIsevzG5LzyF71nrfRCqy9MlcUh0aZWcyqjq?=
 =?us-ascii?Q?lOzfBxbzGSn76QdMIhLKFHN/oU+na4gq9KsNZnIXyMbmh/EEQNu973vLzINS?=
 =?us-ascii?Q?CQGC7k7c7663t4vJvPl3P9QGF2JH39uofHWD4TXm6W8leqgFVNRpDfh25N5p?=
 =?us-ascii?Q?0gW3SyUM+C2aWspJWqjA9A8Jp8qcNxVsrRmmETh05BNLkhH4mCR8bQT1FGF2?=
 =?us-ascii?Q?kLvc3cbJi4AORZ75yBhW+41jN/drLm4ons6g1rf4RSQg+GYyGfUKDr1MamiZ?=
 =?us-ascii?Q?KoRDW/qGY06zvsErUPAmYr/kzUlAJ64zLY9HlZCWEEnjSSRWg0sWwCbSI/6X?=
 =?us-ascii?Q?XEFhADQyfaJQ2wJ0tOyr88oOK0PaU4RO6XixUbw10pGjMvnDsS0w6fx3Orzo?=
 =?us-ascii?Q?Z3IQaHwnaMFWK+vSkeAjwdA9s4cYipaP+MMWiK7ZVnh67aSvrOBon11Zu8M7?=
 =?us-ascii?Q?odyT9bG/+sG7zr1padb9jLtM4OaEhrXzAjPs4s3TIH6p4KZOL9CTFVAcz/Kq?=
 =?us-ascii?Q?rE8OK1U3zOu5rpmE2HmNJt0lecgw/JHai6w/ObPzBckhFkGeM0yqgd7rkKiG?=
 =?us-ascii?Q?tZ6Wf9doEiRm+3B6/hZzcYolMHpksl7eTacP6zlEIGiJm0o0GkctsgOx0p8P?=
 =?us-ascii?Q?Spo+YECnZhLYArHEfHKjN+4IuKFmSfdl14sS7XHc8jpUZJqYs9Cy01LjdZB7?=
 =?us-ascii?Q?eKPR/c9vK0MFu7odhqa7b7FwKkTdtciidpEyN9yQnO2dWaWeBKfey19pD6Fo?=
 =?us-ascii?Q?N5Y+LkcRucQywG6jMuCsERAla8d2aJE=3D?=
X-Exchange-RoutingPolicyChecked:
	jVz+sUz412dZc8VQFgJg+c93w6Wwxwb6x5Wl3yJpNNu9J7VfyB+xz8NymxQbQRpPa7hfyCSY7hyFHq6N3sx0RPjPSZQHkt3sUqxR/TBeuzNmfu7+R5wZxxQFTyCd9AymdMbHEBAEkpRMBrZH0EYA4jFdcwJdZ38Yc2ADLoZIB8BReyOVFwx+MPLHOjma3NkN/qc3jEwayg0ldQiVCxQZrLzujLN4BZ8SeV+JNXMYa7NFxbY+N/U6GZjiV5fNwkSbMk2aaC52KST3qckZdG5QGBUSD8ad/tM9wveBTyj9re2p+R3ZaxEud18QQQSYA9k3/AJo+EbDbMfxsHwVFxvIWA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397cc356-9a5c-4766-519a-08df17dc8fde
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:38.5375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANX1PM+3o8fO73Bs/oikEWm7nPf9bdChG7x1rJXFG2iPXpl3xUrlUaFxl+5xEuAaLuRLAqFapkmNZHfVsyE51VA7vLGqdNxQ3vGPOfOL4bU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6868
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX3Ac+G29iMg05
 jaR/IJZr3uZ4deicsjFp/6T4bd/R3Dh3fFAfvtBBJGVqdER4yvjPyyHW5NOuSInnYH2A75w/doQ
 9bCMRGs48dNU7gr9hV+Twnz3kVn3S2U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX8mVNz/R+LbE7
 ajXmp+9woeKMqIQWG8bljxaTlpnIW0kY5ogNo0Oop0+ZrdULpHfHub3JTHjpJjshIsAl2yHbH0O
 7KQoSMM05ncxOo1c00XZFxLHJxvONASuh5AkpHNhALHC0ApD2OoCLAH+fAJEY/IEE+H03IV5tLv
 CfgAMh5M0KAVbALHpZcGTqM8GdcYocFVKfIA+9nlQ4eIQW38qcu0zRdIjNw0TdyAhr9uMvBWj+g
 48hBFX+s/odm2OEThtGZu7gZ/pbyYqSG8WHfx6xm6bJ2DP1dUOm0Y8MrpTeanQALqfTwPnXxG4P
 lnOnDGMH/RhMdrHeiugMzcN66dVbOaaobu/XoWtwqa6HNnT6ie4X1MSWNkZPGbsjWVvd9jk2aGa
 JxZ329Xl1EJu9AZgRSdJnZlPIplvSkvOHHIgJjg17UwhWUHQT+Gr3GvkPPzEENVk1xjdI04FQci
 fFYVKR5jwAxQ1tLMRaQ==
X-Proofpoint-ORIG-GUID: Eq5is1XjvfqIrfBd3YNpqoAWjUaHVkBd
X-Proofpoint-GUID: Eq5is1XjvfqIrfBd3YNpqoAWjUaHVkBd
X-Authority-Analysis: v=2.4 cv=fphJ914f c=1 sm=1 tr=0 ts=6ab12423 cx=c_pps
 a=kkxl9DAbGs3C2F6ePkv26A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=g3_KJovKdQ1qFWqhGEgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add kvm_arm_field_get_supported_values() which, for a given ID register
field, builds the set of values KVM allows it to take on the given host.

Non-writable fields are pinned to the host value. Writable fields follow
their per-field constraints. This function must be updated when KVM
starts exposing a new writable field that is not lower-safe; hence the
special handling of TGranX_2/SpecSEI/L1Ip/MIDR/REVIDR/AIDR.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

--------
Note:
- We should have an authoritative static list of "writable" fields in
  QEMU.
---
 target/arm/kvm-stub.c |  7 +++
 target/arm/kvm.c      | 99 +++++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h  | 28 ++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index d263adc921..c9cd47bf47 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -144,3 +144,10 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
+                                        const ARMISARegisters *host_isar,
+                                        ArmFieldValueSet **value_set)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6f704c0509..77b1bcdf55 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1324,6 +1324,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static bool arm_field_is_signed(const ARM64SysRegField *field)
+{
+    return field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4")    ||
+           field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64")   ||
+           field_matches(field, ID_MMFR0_EL1_IDX, "InnerShr")      ||
+           field_matches(field, ID_MMFR0_EL1_IDX, "OuterShr")      ||
+           field_matches(field, ID_AA64DFR0_EL1_IDX, "DoubleLock") ||
+           field_matches(field, ID_AA64DFR0_EL1_IDX, "PMUVer")     ||
+           field_matches(field, ID_DFR0_EL1_IDX, "PerfMon")        ||
+           field_matches(field, ID_AA64PFR1_EL1_IDX, "MTE_frac")   ||
+           field_matches(field, ID_AA64MMFR4_EL1_IDX, "E2H0")      ||
+           field_matches(field, ID_DFR1_EL1_IDX, "MTPMU")          ||
+           field_matches(field, ID_AA64PFR0_EL1_IDX, "FP")         ||
+           field_matches(field, ID_AA64PFR0_EL1_IDX, "AdvSIMD");
+}
+
+static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
+{
+    ArmFieldRange r = { .min = min, .max = max };
+    g_array_append_val(ranges, r);
+}
+
+void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
+                                        const ARMISARegisters *host_isar,
+                                        ArmFieldValueSet **value_set)
+{
+    bool is_signed = arm_field_is_signed(field);
+    uint64_t host = extract64(host_isar->idregs[field->index],
+                              field->shift, field->length);
+    GArray *ranges = g_array_new(false, false, sizeof(ArmFieldRange));
+
+    /* A non-writable field can only ever hold the host value. */
+    if (!arm_field_is_writable(field)) {
+        ranges_add(ranges, host, host);
+        goto done;
+    }
+
+    if (field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4_2")  ||
+        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran16_2") ||
+        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64_2")) {
+        /* Either support the host value or the "off" value */
+        ranges_add(ranges, host, host);
+        if (host != 1) { /* 1 = "off" */
+            ranges_add(ranges, 1, 1);
+        }
+    } else if (field_matches(field, CTR_EL0_IDX, "L1Ip")) {
+        /* Only safe to downgrade to VIPT, other values are reserved. */
+        ranges_add(ranges, host, host);
+        if (host != 2) { /* 2 = "VIPT" */
+            ranges_add(ranges, 2, 2);
+        }
+    } else if (field_matches(field, ID_AA64MMFR1_EL1_IDX, "SpecSEI") ||
+               field_matches(field, ID_MMFR4_EL1_IDX, "SpecSEI")) {
+        /* It is safe to upgrade SpecSEI to 1, other values are reserved. */
+        ranges_add(ranges, host, host);
+        if (host != 1) {
+            ranges_add(ranges, 1, 1);
+        }
+    } else if (field->index == MIDR_EL1_IDX ||
+               field->index == REVIDR_EL1_IDX ||
+               field->index == AIDR_EL1_IDX) {
+        /*
+         * No restriction on value that can be set for implementation ID
+         * registers fields.
+         */
+        uint64_t max = 0;
+        if (field->length == 64) {
+            max = ~0ULL;
+        } else {
+            max = (1ULL << field->length) - 1;
+        }
+        ranges_add(ranges, 0, max);
+    } else {
+        /*
+         * After handling the special cases, other writable fields are
+         * either lower-safe or signed lower-safe.
+         */
+        if (field->arch_vals_count) {
+            for (uint32_t i = 0; i < field->arch_vals_count; i++) {
+                uint64_t av = field->arch_vals[i];
+                int64_t v = is_signed ?
+                    sextract64(av, 0, field->length) : (int64_t)av;
+                int64_t hv = is_signed ?
+                    sextract64(host, 0, field->length) : (int64_t)host;
+                if (v <= hv) {
+                    ranges_add(ranges, av, av);
+                }
+            }
+        } else {
+            g_assert(!is_signed); /* No signed field with no arch vals */
+            ranges_add(ranges, 0, host);
+        }
+    }
+done:
+    *value_set = g_new0(ArmFieldValueSet, 1);
+    (*value_set)->n_ranges = ranges->len;
+    (*value_set)->ranges = (ArmFieldRange *)g_array_free(ranges, false);
+}
+
 static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
 {
     /*
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 4e563fab96..9481e56412 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -175,6 +175,34 @@ int kvm_arm_read_sys_reg64(int fd, uint64_t *val,
  */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
 
+typedef struct ARM64SysReg ARM64SysReg;
+typedef struct ARM64SysRegField ARM64SysRegField;
+typedef struct ARMISARegisters ARMISARegisters;
+
+typedef struct ArmFieldRange {
+    uint64_t min;
+    uint64_t max;
+} ArmFieldRange;
+
+typedef struct ArmFieldValueSet {
+    ArmFieldRange *ranges;
+    size_t n_ranges;
+} ArmFieldValueSet;
+
+/**
+ * kvm_arm_field_get_supported_values:
+ * @field: The field to get the supported values for
+ * @host_isar: The host ISAR registers
+ * @value_set: The set of supported values for the @field
+ *
+ * Will be allocated and filled in with the supported values for the @field
+ * based on the host_isar and whether the field is writable or not.
+ * The caller must free the value_set.
+ */
+void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
+                                        const ARMISARegisters *host_isar,
+                                        ArmFieldValueSet **value_set);
+
 /**
  * kvm_arm_steal_time_finalize:
  * @cpu: ARMCPU for which to finalize kvm-steal-time
-- 
2.52.0

