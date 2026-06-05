Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1BC47CC83
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649309; cv=fail; b=bHFa9UImqYSa3ZlPy1CllkjsUKDrbZlcfB1A1qb0WXktJ/7wrqRQ3XZNyH2RdV7Z72ghBabL+F2ErUBK9CXjxojDh+/7tPa6oinoHo8FjYAQFcZE1Dwj6iP00b91la39ehqjv3WFZFc1cRkE6y+yVeYdeINBrE0g1IP/xC25V1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649309; c=relaxed/simple;
	bh=U6znowo3xokV3z+eJO8QHB/zAdgFs9cvumFc/7sNvLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I9P6eAPJGV7RcK7vYEJig+Zk7oJUcJLRpBw28AKVqi8MxRsYpIO4xS1toFUVOUKsnP6CE/43uzZQ7Aptw0ywmQ0CLDwE2VFZMRchONT/uh6rH+BYHbf91sBSzw+JTJPxUpM6cDRQYWs2G+I18M3KyPkbYvtY0El2xBwMqF/F2uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VSUpfjwN; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yVVAe87B; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VSUpfjwN";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yVVAe87B"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLM854749;
	Fri, 5 Jun 2026 01:43:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=HRsZLtm1SD/FrQG94lxDHmhf+JkQNdncTSZ3m438Y
	zY=; b=VSUpfjwN2VazF8gTUuYVWV/yowcFWMvxe4mIee42iLR9e8GF+VGursqiM
	pYgz2Nn8jt5StikmYXvadY0oEiCnt3nlA0ylSkvh1NJe3dzG7rjvsT6u2AGY1fg3
	RY9VuP1d9t+2My0uQz/5hrayDNfyVP3iiU7SNnQnArl6SLRR1R8/onpwYla6JEk8
	Iqfw0oinwptAqTBcBMYhik7feduSdvK/rBXUoCbV7GAkmWPSn4wCFd7P6juxhNCt
	BjvQH74LQjS0QKxF/C5pDbxvnAFrrSAjK7yZs8VCkD5pw1FmrmZlkDeyDE+GRk/r
	PODZuI8Tj+guM/KYNKP35w0gU1O/Q==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqeiXg12lg7BWAFCPSpuj9X924dK85b3k6yfCkg+eK04fI9cOzZ5XA4BN47NO0JVIUml7IO2uNFULD/wdptqgW1P6ABtF32oxFBdknCI+ahU/tNQPw99QtLo224/qaR5iA1xvMzQmOs0XmYtQOY/RRastK3OqARJ8JKMdGmpPZUpbz94EQjtFTAHb8WrgIRMJd7C1Z4kvjwNvScEi+RMAe+U7jXNuOX5UYhJb59IiHnaIdFe8jlf+FBGjRNEsEEwKkCce7DU3vlHOI0+7mNCsVAx+It4zPmhfmwd4Wpzf2UK7uyF1H4cVgi6uXX6JEyZLLoKVus7TpzzkxY/uiZhEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRsZLtm1SD/FrQG94lxDHmhf+JkQNdncTSZ3m438YzY=;
 b=cx2y5Uc1rC67JDOTDKeu2pR/uvj8ZWc5xnEveCiYJgh3cN/aJIhAArRN4LJArEPUlTbkSewzXbqI9k+BHXDgWzWndUvyKmbEQxlt7hhc7lM8sgZVe0eNSSvJE7I6QklzvE8/fpOadmaCEFe1ITt6ukP4IEeXgIXz8vipRXS8fdf4//DP9uvkHXg9HC+gAY8qNrs8jYPQoaKEasr2sG2E7DWxph9RC/i9R/rdbl1HJfxPOMKQpCWJJOzAPfV4tIWmW1nT76qg2Jg9pL0Jd9dPha7xa87Geqg1icEGNxJYr4aKJvk8z+64PMHdwAyxVJa2LQ4TBkfo2epg7Oxjyi9XmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRsZLtm1SD/FrQG94lxDHmhf+JkQNdncTSZ3m438YzY=;
 b=yVVAe87BoWSNyHoBKqXpOp4+U5Uzmey4yCTH7JZRMqLJKBX2N88Hjd2gi0RtzFQJPyd/76EEQ/W3YQ27NHhtARI2U3mexchbdJsinhrOt2ye4VuHZbNUFqXrzvOqE76ixsurgr36UD0tTQHbwYsZAfZcukghL9V0ffykyLTlXIrvmJ5YEJNjNMiPCU2pQyuDzPe0fTuz103cKJgQWKfzMg9BJgnUsbW8LWPAiPL9vKCZAxyMGRxl6tbgAh8ODxIj2RSQLWdIrk3zgdvyxq++h9F2WN8eNMSkTKnpbVLJnCTtkU9SYCJJTsvfNM2/UFkzt13n2PrvaIZu7YaRGG2DLQ==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:09 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:09 +0000
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
Subject: [RFC PATCH v2 03/29] target/arm: Add MIDR, REVIDR, AIDR and extra ID regs to cpu-sysregs
Date: Fri,  5 Jun 2026 08:33:32 +0000
Message-ID: <20260605083358.1320563-4-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 75afd30d-dd96-4ca3-289d-08dec2de78af
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	it9nBHSLc21Fm9dGMJ3MOJv7onWOfAU4pHOdBqCJM5b00PUF+6NSE5IfSZJ/LLNmN6fcbgXdIGuHYgyx9mIV8VE0g88Vdx4EEyVHLNMHz2eROMYO8NNY8RVAcF4OHDooOhyjjeeBp9t1nzBFYXG1roYWdI8TaV6OF33rpAfUHCQsOtY0E+Hjv1TwbqLt0GM5wh0OZViJazOhqmIKamGLUXG3LHsKmkjHOxu2BAajFIl6q16O9SOmOSFFjU6eW0yinb+WR/YtO9qplcc0PtACisZG3vPnLTrG0Gkf0Jt8V10G5CgcJtW5rkZqRVgkifY+VIpRYNA0kXxMLtN41ydFnAMPZnaRQOHtPIfxU4A/Uemz1pqyfPVZxlHA3PQYWi8d9L0siGcsYmKBciTAe8wZvnzn/iryvWtzyhDynmJ1I8XYl8zlar7zIIn0en1jGJscJHlY1s+urg/pr1TLG8oAnSpYR/VueCWcRORbEgMOjR1WL9PGS6b/ydB2ORuaelCF2gC7JNrx+DZhjp2yUv+OuThSik1NYEEnK7YhuMP7KYzRIyCSnMNKme+zviOrxRXwZNnaC9PoMRbavjW78PL859wMw7Uv0KcVlrR9qpJT+LOjDGfjT/DlDIzpnimMP0iUwsfXY8K3FgG+V1+d2Fyx/7JgbQFiY55OmCm5sC7aPdG4zcxAzmgb8pAIunGYdRBH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P097PL2R2kXuzzOM3Q4Hkm+I/uP7TbacNGwZSijO4aMISiZf+QsT2oBAqf1/?=
 =?us-ascii?Q?A+0rtoYdm08uQ8e3gVYQr6GaUcCZPRMPpuAtAZGTbSo0r/W4U7Wo/aV50zSL?=
 =?us-ascii?Q?LTf8rxTaoJIWeAeALvMtFlhYxil5S1FOMKTL39t9KZxOHRyRTxY3AWL+Xk0U?=
 =?us-ascii?Q?WRYMM2YodpH25HcI+y78Z+eXRgad+WjCB8elVFVxRNuS9n70C5AK1Aq7kOdJ?=
 =?us-ascii?Q?HHI++KqR46dHnzBgeOvaqFQk6WacrSqESSQ/hwxdQUrlQkeARTCyufbWP9AL?=
 =?us-ascii?Q?G265y4MJp0zt61Mgjufvm6wkqXISKtZmQ9ymB9ea3af2fZ3Whd5r+b+QxMGg?=
 =?us-ascii?Q?ceN2/1+svFRoJGFyUZ+uhxEgd82jWEufmJqVBhAz0RUPl2Pm6WiCxJK/nB8h?=
 =?us-ascii?Q?YD/wnjIlyn7bY/X3YUQY/k/9O5gOu50VHsZa1enc7IZNkeNmYsal84ePLJzD?=
 =?us-ascii?Q?Ql6d2mR23m36TeRavC08av/JJwEONW7gBGves3P67JfuCHoNPftzaAaS/eed?=
 =?us-ascii?Q?jp1ZD/eSmMhBSgCHYWY87kqzYLS8HvLawiAkYJ69HPNCrLlhHFUTQ7rP/UXQ?=
 =?us-ascii?Q?GAlKPTa+u5XCaWs3G1+esPu++dKnOcvpPc1d7/sVHST/qqd/FOlw1hqtX1HV?=
 =?us-ascii?Q?y/pHLodOidWpDLmYnGPWhHrmErfn/Dma/KVUJA4FlBksNfoMFsV55CQlaq2q?=
 =?us-ascii?Q?3/v1/iBjJDmNj2H6jkqxB96gwZQZF2E1fkQSWycjX/cQImdsQk0DKPPSdDJQ?=
 =?us-ascii?Q?TxH/0eNWrx4GikY3Y7Zu83VGe+YeyfOMCM1qlCq6ElHZ4/VVEQsq1Aoyalpi?=
 =?us-ascii?Q?6+CXiPSOxBPFFEkrkWWu5lIrmXWKS405O2C+5TeqEmqjHLUaPSns8zAWQnef?=
 =?us-ascii?Q?zS9qUWHb/BVTje9X/NVSZdVFqUcXjIAHEgTWqeOYRuWgIFfa9g1rKLhIAdZZ?=
 =?us-ascii?Q?YQh6Xct01BMK05kedBID50w19m34UXsu4XyzVev72pr2E43X9A0JmFSPEUjb?=
 =?us-ascii?Q?3+iQrj7/f99v/0EUmP0PO214JUDUE65U8xL0OSweavC+tm25f4sjLzJ3vXy7?=
 =?us-ascii?Q?o9jRdWxyax0xre7TkXgDHk1QjTkxldtP+fHFm9eKyysAZeg3r0ZD5Zg58Hr1?=
 =?us-ascii?Q?o2URwezBDh2vv1l9qBOvpJgeyGea5CWyFVzu/EGkWimCLatdSI7kNfzlTssO?=
 =?us-ascii?Q?VYWCj9m7WjEvxo8fytfMY5hmRoh/KZN+j2fdA33uVWx0gntBbnUh0tlTk1vQ?=
 =?us-ascii?Q?Ot3RsEPxPsy3BAbsIt9UR7XRc2fNtGrhpzkMTTsfQzViCBYfKQeKjeAZkkfj?=
 =?us-ascii?Q?e5IHUdXZeRU3hWWQWRxHMo4tmz28oKfWfA8HmaXJBStP1Cb6G1ttF9xFr07O?=
 =?us-ascii?Q?FSDb1WmYPgyRfMgm1A07AHt8aSTbbHrESk3D6BeVIf6CmqK/q2M/CG+0JqhI?=
 =?us-ascii?Q?sWkerRzImCUoQljibkucD+BO8xdTNmIfPvVvohjJlR1E7VtDwDdaJJUIFaQQ?=
 =?us-ascii?Q?9TYW9T7OS/GD62mivGBQh4GX/C6g5YijlS5W1tWa606is/aMrCkuK0XgpzQW?=
 =?us-ascii?Q?QdbucoeV4aogsDaxa/yQPHXrZttiz3958NIanuzgid5GnupKkzpFxsxZy6Eo?=
 =?us-ascii?Q?pBuJzZlbNhdVZQKE4MwjxoW4VFRX46DStBvPEcVzQ29S7iNtopao4RvArC7e?=
 =?us-ascii?Q?wKDBqtPOyTJGxJLWAicy+Cu6+gqIzel0Z08LdCVInNsN3raFTBsxAbkk6OBZ?=
 =?us-ascii?Q?A7mewXm6YQVyoiw/m7q4QbTJ1wFBT1w=3D?=
X-Exchange-RoutingPolicyChecked:
	ec9a7xBTGnEqz+BDCYJmAqC2oKNgcMkluUCTGL/TvPa0zxthaCLeNL5Ft0CwqBV28+Q2d9Sq4eHDfBgN3EOm4kmXGqKDsMBBkNkOVbuP0myyeIJs8aqOF6t3vq2FN9mNJQ0NVZjMpJX2rPdCI/fBKWQbgrFVka98bw0lIDnLfgo7ruhdGvS/YWITOUPj3hTKRZPTN0LdB3+O/nhtPzWrJjrUDVMV2sYdbf5hH5sxjBTt1JWTAybRQ5Ju5lroUq68LrkK17QciB+4Nq4a9N00WDSX01X6O1UQqm9rjgCgVWcUPoe5ny3RJbPNaXUs1+UWoIFarsZAH5DzF87qJJ8iAg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75afd30d-dd96-4ca3-289d-08dec2de78af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:09.7686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hAmsB9TpfYO7vLVv3YC7ubrVA6iPiI4ebyd5htTSyWw7N0Z5882K+ZnL3SOMP5UTN4kVQNBB9+dFU7uH/OT0/5+u3mPXJOcLUoI4Q5rNjQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: 8smNUur44LHmL-xDh9kl6RChBgdgPP3w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXw0OZX3QxvEY9
 R2wcyvvSF0LZEedv9IV+2n/pJirXA4caYzmSCgz4GtOdXytxVnr1Zn7E4xuKYgkZ8r2+OeRh0BX
 1/2O2bpF8OPCvDdiG972HMfM0pzXApMPElQLXC1GZD7Fj77/Dd5YYy31a259PHFwNTl7eICxzAH
 L4nNxKx55vAnXr3gKMTe8qGekXu7fXm4F+sMklGvqWMmmAtR+EFrQVrl0OTYOZDUwga8QAP2VGY
 5Ny0IaWVM8HNosYp+GTwpYCT114zytFM4oaVx8g5BjBrOxiPzHnUKrxRn/x+j47SXNgMhJFuLVq
 +xjCUlTeATDtuFAAfknA6FBHvbVezi+ybbmsJH5tWSZZ0s4c8PY0y/aiqgaIgq2GB/VlSiSBLLj
 OrWQ02zZtXr+Jg3vdwR2slHL5faBgIIcFMuHqxoxziYP8j04qe9r0Xky6cDC95WG/KgAfEH3hQ4
 N+/Zvdh7oRsWzvEgXww==
X-Proofpoint-GUID: 8smNUur44LHmL-xDh9kl6RChBgdgPP3w
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c20 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=AygiQiBlhmlzjj3rpAAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Add entries for sysregs MIDR_EL1, REVIDR_EL1, AIDR_EL1,
ID_AA64FPFR0_EL1, and ID_AA64ISAR3_EL1 to cpu-sysregs.h.inc

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-sysregs.h.inc | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 3d1ed40f04..82a83d9d5c 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -41,3 +41,8 @@ DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
 DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
 DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(MIDR_EL1, 3, 0, 0, 0, 0)
+DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
-- 
2.52.0

