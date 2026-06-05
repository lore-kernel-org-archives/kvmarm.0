Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63603CCFCF
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649069; cv=fail; b=D9vfEaw1ptHkG90NCHocOLBQXEK3jBB+TO/7QzmHnityCbvTVBajGreyMVYTxSLp84DWpsGq819RCzYPe4rSkXxeySb7S4Nwuz6YnXtkwLjkSxdRmiw4Y8mtI4DSljnEDkg1D5GfOV+D93IujL2tC1nI/cP7Yaq0bWR+mSC8Qv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649069; c=relaxed/simple;
	bh=vPWSGAtgN8cuN2Xl03pBZLnIH/icQIySz9MX/9l5nUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nMQuyrz0O2ml00w83ZVg2M/fnyeAKU77I4rChw4xvRNoULt7DGODVMRsNkRlAQ6KV4h186Im2wOFsACJ9A4zPqsPV7UIYpyF2KQ1lYrw5zuzl3ddFoxitFx9ywGQMM5iTaitpPB9OQgaUoA7+eUd9dZ2FAVilsUfVAe7XYV8jY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vA0L2G4m; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=d62z9RPn; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vA0L2G4m";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="d62z9RPn"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLT854749;
	Fri, 5 Jun 2026 01:43:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=3XV4NJhUaCN3lq/M/9yTF1zQguCEScBbIL6DSfEj4
	r4=; b=vA0L2G4mdF2T6UFpoMMWB24+x71XXQv+vBpWhgWOqIJgY8CW71QlD1g9c
	YtUfVcK3PEqgKNR1/lDcoXqyhJYaRJHPUMTXC9UGttoF0toUzdhj5LPdv+951s7U
	T6LPm6ZsCscQttDPM/UWKeWIzgwnM0m03m43dvWgQyMr3S4r8syvLaPlSmrBizbB
	EZ373tBWMWVEanZtqUhrCyk1fRzAihAaEFX32tma+dFfeZLPglh4v7/+eWbKOHSB
	KlAZ+7rbsXa5rgL2LiAA1hUPM1svyxxPAnKsbMvkP6xmB3V8Lk8Oq+4EORE7+RSj
	nTfgNHXBvX06vjTpC1dHlYEguL86Q==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-10
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PszZPpUD9QFlGdi540OohHpeT7HEu5aB2eQc6A+xrZXoN5jT2GbIHTZyWxoe/CVlzaxzB0q3WmPBj/AgZWQloFOBJeEBp1UXRCgNP4pxvR0jmak7GYK6gwlUsyfGhywImlkNe+lCYbPx9JH9NJumEnFxuT5/o1NUYtdH0D43JXs5yikSLPu4xdCzuYfqxGVMY2Cl3RPrf2ikdG4PbxsV2SCuCq06TvHFppBKTEo8Reg08kkSH2nHyjE50SDXHEPs/trnNtnZvmxweCgx0i/eIGk9LCDT3bEqeH+QlGpjRDDSIh3nNxIWws2xyg7OnzTS/2eAAYuMdDbjVxqRO6tJkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XV4NJhUaCN3lq/M/9yTF1zQguCEScBbIL6DSfEj4r4=;
 b=quVjOptrGNMiC45hqahUGdvJo33o9051ydo0rpvSxSlY9ztyjxjWedub40CS3tMiIeGGePzXb6YSb4wDNhHNcVYYV4lRSICm4nH+5STXhslVlreacMnwk0Q0tzFHVzb85nWv7cB2LdL1Lpr16Ng3KIrAwdlAS4FbA60G76k+exxbbB5EX6Eb3endofqHuQii6Uh5d4vieIS/vessyESczqEWCx00wlYtDvZ51dM67LbJ/w9P+TbGdi+T58C35qHk+mhxf6O7LX8TIaJXghBkI2Juq5PnPrUhF1T8BMd/AOmT7bxjznepfajYPS50BggqO/mhfr9ems8xoKraD1zoVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XV4NJhUaCN3lq/M/9yTF1zQguCEScBbIL6DSfEj4r4=;
 b=d62z9RPnr8jxqVMFZHz50LcaVeTrCKVbDPjM4O71SQ8zMZ6in0wjDQIgOB/uCBISbKbt2KPa3Usy6UUpQrIUTsggg9+SJ/zr5bQen8aKPw2GUlgQlKpWY2YUTDd6fVB8/b2+Dl823h/mZQaACTctxWfQ+zeJwi4EIZ0CxSo0e2DXtIUq2whjXbhzf6ZrjsyFz1YTY41DW5TM64l29pdi5mpYQj+jm1x/dqMiFKFQd1oWJKrtyBXEkmqGyknUPcsef90vh6NqG0R5JDhycZI+DBSp/65iA4Gk0E5COxXdcIqwj2NOo7B4zIq/vEE7atXL0dMbLSsHAVW55DCEmxAiFw==
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
Subject: [RFC PATCH v2 10/29] target/arm: Add named cpu model infra + graviton3 named model
Date: Fri,  5 Jun 2026 08:33:39 +0000
Message-ID: <20260605083358.1320563-11-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: cf7e11df-5fa7-4e56-e901-08dec2de7a51
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZWprTfINRbOROLYCHi6yEOEC8rMqlI+Xe+6vQ48iPTJbfu97CPaWkaArRkLf/q9Vtvia/8bPw8ASe1m3XHpzL+EFPIndAZHAPndEqmaz5XEhA6kjuV9zvWBO9hUNeeZP37b5CPzMgV0VEVsbmb4yAQtR1CdpNXWKyjV5f2EcT5OpcpohXC8/prh3FDqPm8s7zf+12zkmMc5Rmm7i/yERNV+W/o4pkseOOeTqG6XHGszBk8B9L18bqaubhowrZuk8PcHuS5KyLzjMpi3d6UOoGnGT3RZ2q8t9gJmVnU/uERLg8MCAiN0D00DaGj8LPZ9TAx2tZForMI25W2QGf8KLf7hQbHyU0BNjhDwxRhELR/F2Ll5r36HHG4Fv4ZD3vaWBeeufGPL3IFwYnNZHupw3ONlXH0gjfGNEQouDpahjtFDXnCeBYYymwbrcoYi/uR2dquM4XEAMtPQfY6N/bfddNai4+jN2f0TzihSlDMNfLP9neyRTjXpEhYfiTF7YbdY/0MwY+6tZP13HcF8wz+I+YHoMQ8p5IwSXaptxaFfwR1zbmL2XPhl/TdmIEEGJLA57R/RX3gfi6rlrjnZN11ZWXda9/a5130seH8nlPo2U8xjRfYpD8jd86+O+otkdnUQwm2qufJOkP9oZJoCvQ1YggttgUYfiRExTt+WygFaxltVMEaFrl7tqKFhH7Z35Ix3u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2WbwkxGYnYI9Vlz4Dm2pNMLmKRo+hd+VNi/lqp/wNzQmcccbmGO6BeFBCHvn?=
 =?us-ascii?Q?eJkv40L2qkkc4zFVjRJT6ybc3yXn7diXV/yWkxFs/a5P3tPbNF6WlaGE6ZA4?=
 =?us-ascii?Q?iTiMr4CP95mlZyAXvZqkOf6z7kVh/kWk4DsL1AK/Sb1AxesOdf6GJn7gL1LP?=
 =?us-ascii?Q?6ssLZLOkYvqHVuQTQZcBlkUCrUXmw5Ibdqv/eu/32pBQvLFsK/5mV6noWxY5?=
 =?us-ascii?Q?FkqupzYRqC9itx3SIRaWpHGMKQsx0ygpkNydOCXYdPTQyywx3TwkfkdQUx32?=
 =?us-ascii?Q?lJlJag3R9qpprhLnlxle7zqqs31WT44hXmkhYIYcHiLqm9vRXMBKBJSQQmcF?=
 =?us-ascii?Q?S/5/JIdYBtZzAzo1l5sHQw/vXBEFcULH6hUvuY8kl3iaBLZf0pqc4v9JiKQR?=
 =?us-ascii?Q?P/rygD+sWbHvdWm3JugvpiFCMnvL4xf0A90DrzuSdwVCD4zmdgXg9jcsqI9H?=
 =?us-ascii?Q?1+rGthz1swvv0ZeNnrFJJxS5/5oPd1e6HJibOPq3C6iZVJ6ECpQ6kbZ3q65t?=
 =?us-ascii?Q?g4cKS6XFjeJJlf0fTEDcjk+2Tl7PYpXLZPJhn5KfVfoLLb2zwbX4W/cP8dYR?=
 =?us-ascii?Q?ku4D+iV64HkxjYZeahZmgNRE+AcWdN6M7LwlhhCKb/toB5xgmc8EFbadiA1U?=
 =?us-ascii?Q?w1N1uTsWq8oGiDECKkpHqCIGgkjRGw8+l9GnkxYjM8hrWjnPEEwLgf00tiKF?=
 =?us-ascii?Q?8pzBUPsYMLa/uNniXj4JfruvwX57Co2LtfkXrPUTl0J6308dzpz2gf3gaPnx?=
 =?us-ascii?Q?wtNinZhGhamvCPwp0uz0SPeHsuWoeU6Ja+NI+m1gnfudZiF96WOyVRJETSZa?=
 =?us-ascii?Q?vX+B5zq+aAC97Aj0jypsAJw47sxPTXPl82asHxrd6Ny0WJ0Z+nesrNl5snHq?=
 =?us-ascii?Q?8tiSoCjALZVEDktuDwim95bMVfNo5I0caY+9yPEiqNPO3D1tkl5UwSA/BQU5?=
 =?us-ascii?Q?xC8XJ3it/IVqWs5fo3EO9hL1Jaq1hcZlQkasdb/dsVJGgDHr3SKNsvU9CpMz?=
 =?us-ascii?Q?lEKzLX+aFBXM3bakuGoNfZl0/iom4wr9S5rQs54m0xNqued1zbSh4EMiuMSl?=
 =?us-ascii?Q?cMduX6VsNCAA3C5r9xb3JAzoymQzDoXM1gE8+YSEEtW9CPqjCWbTZKFPdEWB?=
 =?us-ascii?Q?atoKvmft0dPZQfGBGAK1bIAjFE7/v/Xke/L+Ds8Y/Z6DDk0O5sODB2z1z4RE?=
 =?us-ascii?Q?XuqSwctjvsSTGQkIljTuE5A91xbPXueqa8mPNDy/ic0Y9Y2Jq8KAsoGtYziG?=
 =?us-ascii?Q?RcdfGvyoaPGFGFbuVVCnCamLpFqR4ExkVQIcj5SyHgWE4B+eLzlHPebgmErG?=
 =?us-ascii?Q?KcYAGbWRsEHb5xC9MRCK86GFCsqWS/riKA3j9wUN4ZGJWmXCJYbM8ku5sETX?=
 =?us-ascii?Q?XWMASwiRqP/ifhesFqiqeH5xLlhRo7wEYaiS4X7PYnSwGzfT2dd+l0FkoGnS?=
 =?us-ascii?Q?FySCgFEIo/jcjN+EQ+6dXi0QHm9ovbNQDbq5KtVQ2e0mHDq+SjH0vhx/ikzR?=
 =?us-ascii?Q?VYhbceYyl5sjBiZGLpLiCgpyFp3Ot09k+W/CocFrmNQdMrL/t4uuOPrO5CGc?=
 =?us-ascii?Q?5FWaY7bjD9HMyNbtR+W7fR/3otspd5Czl1hdUX2UcX1v9O09ZcFxg8U71fTQ?=
 =?us-ascii?Q?MiFjdZqmLwQ7B0OBSsivSwDcAFhjW8NEb3y9kKYR6gVj4g4RiWBvLRGjiKKK?=
 =?us-ascii?Q?WqxEXbxFE4kUWQUExGvPOPHMD6byipmDI+EDL9WRASDuItxTzPUcYiDVyXMH?=
 =?us-ascii?Q?hlFmEJqU3LS+yQQCYcGCjF4mIWZi/vg=3D?=
X-Exchange-RoutingPolicyChecked:
	fJqEtZsT7CErYiRH2dwjRC+m4VJeWCTHgP9b5qeKBaqX5Mwrfwz06QHcVp++kGpWEpAHnCuuekXZJ1cbIxdAMtyhQdoGHfBDtyq2CPJD4I+63LaVg/u/24H+FWB2/VfkdufNHSZgJug5BsLmI+5CtEDTidmS+dkqTl+EFi0CRZNljogILPeqacxHAOMi+akEuayX8j55Yl42HyPqJFs5RXdAfH/T1lp6bP5NnuHBtu2QHGiIV28Ps31+vJeAnEAZRRRz7WlYXGFrOzwym5t+gVuOaSZSwtDyVDI7oO/Az18GztEe0V2vh0FxvoIES1xO5LKqQ03l13/gt0+9DZuU3g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7e11df-5fa7-4e56-e901-08dec2de7a51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:12.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4ddGzPp42R/QwODi5DKQz+7yfg/VQgnsC8v6HJrNLnMY4B7Uc2hDUyw7/EGm845mO3V4vmcn0qeEniCSzhlWVIrXD4jFAA2EvBn3ZHhoxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: -bxBD4Ex7GsTLDOWudcunRvA47acnKIb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXxZ1i+CWxchu1
 9hIREnb8sMAmU56qek+AFwKIbcHsdagdhxB0ehrMOUxfdwVFuQLDjH/Cb4ATFAMAvY4BazbDz5H
 GhoBcQUsYEdvAnF9JGnDpCb1cdeKKwS/PXDV/qtTnqCvTETTOwyhtkcGxR3AlwabnAsVkz/Gr3q
 mbAyC1ZZWLSl3HSOGa9i02yWoSjfiL99/0qvmSM4oZVhhCy9aaJRnT2WcX1+fy5TM5klzm8lM26
 Wr+7MY8CkyfmI6B0JF8102NYkNuVPGKY9+hkd2HN40nWrp+ZaGrZBDm4V6eduN3cTSIOsLOnwdk
 X53U6yxdxuTE/dVLAYZoURbuzCiuCpdNb6HZg9LUqS5iuDK+f04MUQ1jKuw+BTL5ar1ImOppCt7
 DFDN/npHWlqYcL4fVHQ6Gy3R3VVNOQz8jRk/t7OQVTqOTP4qd6z8Im8ncjAxlpe51VH3VlmjJh+
 76VBrX/eqRhNGJ9LgUw==
X-Proofpoint-GUID: -bxBD4Ex7GsTLDOWudcunRvA47acnKIb
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c24 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=dlkhEnONpvMUmQseL1gA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Introduce a small named-CPU-model layer on top of the field-backed
property infrastructure. Each model is a flat table of (name, value)
overrides and a parent pointer. At instance-init, the parent chain is
walked root-first and every level's properties are applied via QOM,
so a child entry overrides its ancestors for the same name.

For example, the graviton3-v1 named model hierarchy is:
kvm-base-v1           KVM-imposed quirks (chain root)
  arm-v8_4-a-v1       ARMv8.4-A architectural mandate
    neoverse-v1-v1    Neoverse V1
      graviton3-v1    AWS Graviton3

arm-v8_4-a-v1:
  Only features mandated by the ARM ARM.

neoverse-v1-v1:
  Reference manual derived feature values for the reference core.
  Values differ from TRM values based on what was exposed to the guest
  with -cpu host.

graviton3-v1:
  SoC integration choices (crypto pin, cache hints, PAuth alg).

The model values are figured out from ID register dump visible to
QEMU with -cpu host on Graviton3 machine.

Model realization:
1. arm_idregs_reset_to_defaults: Reset cpu->isar.idregs[] to the default
                                 values.
2. Add all properties to the CPU Object
3. arm_realize_model_chain: Walk the parent chain from root first and
                            apply all the properties.

Realized model ID reg values will be written back to KVM in future
patch.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c               |   5 +
 target/arm/arm-cpu-models.c | 300 ++++++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-models.h |  35 +++++
 target/arm/meson.build      |   7 +-
 4 files changed, 345 insertions(+), 2 deletions(-)
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 10b1954382..b8695b9286 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -4069,6 +4069,11 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
             g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("host")));
         }
     }
+    if (kvm_enabled() && target_aarch64()) {
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
+    }
     g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max")));
 
     return vct;
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
new file mode 100644
index 0000000000..61d45619ba
--- /dev/null
+++ b/target/arm/arm-cpu-models.c
@@ -0,0 +1,300 @@
+/*
+ * ARM named CPU model definitions.
+ *
+ * Each model is defined as an array of MODEL_PROP macro, listing only
+ * the properties that DIFFER from the parent model.
+ *
+ * At realisation the parent chain is walked root-first and
+ * every level's props are applied via QOM, so the leaf's values
+ * naturally override its ancestors.
+ *
+ * Hierarchy:
+ *
+ *   kvm-base-v1                    KVM-imposed quirks (chain root)
+ *     arm-v8_4-a-v1                ARMv8.4-A architectural mandate
+ *       neoverse-v1-v1             Neoverse V1 (TRM 102649)
+ *         graviton3-v1             AWS Graviton3
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "system/kvm.h"
+#include "cpu.h"
+#include "internals.h"
+#include "kvm_arm.h"
+#include "arm-cpu-models.h"
+#include "arm-cpu-props.h"
+#include "cpu-idregs.h"
+
+#define MODEL_PROP_FIELD_STR  str
+#define MODEL_PROP_FIELD_BOOL b
+#define MODEL_PROP_FIELD_NUM  num
+
+#define MODEL_PROP(_name, _type, _value) \
+    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
+      .u.MODEL_PROP_FIELD_##_type = (_value) }
+
+#define MODEL_PROP_END  { .name = NULL }
+
+static const ArmModelPropValue kvm_base_v1_props[] = {
+    MODEL_PROP("el0_mode", STR, "aarch64"),
+    MODEL_PROP("el1_mode", STR, "aarch64"),
+    MODEL_PROP("el2_mode", STR, "off"),
+    MODEL_PROP("el3_mode", STR, "off"),
+    MODEL_PROP("feat_AMU", STR, "off"),
+    MODEL_PROP("feat_MPAM", STR, "0.0"),
+    MODEL_PROP("feat_NV", STR, "0.0"),
+    MODEL_PROP("feat_MTE_FRAC", STR, "async"),
+    MODEL_PROP("hw_prop_CCIDX", STR, "32"),
+
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue armv8_4_a_v1_props[] = {
+    MODEL_PROP("feat_CRC32", STR,  "on"),
+    MODEL_PROP("feat_ATOMIC", STR,  "on"),
+    MODEL_PROP("feat_HPDS", STR,  "on"),
+    MODEL_PROP("feat_LO", STR,  "on"),
+
+    MODEL_PROP("feat_DPB", STR,  "on"),
+    MODEL_PROP("feat_RAS", STR,  "1.0"),
+    MODEL_PROP("feat_PAN", STR,  "pan2"),
+    MODEL_PROP("feat_UAO", STR,  "on"),
+    MODEL_PROP("feat_CNP", STR,  "on"),
+    MODEL_PROP("feat_IESB", STR,  "on"),
+
+    MODEL_PROP("feat_DIT", STR,  "on"),
+    MODEL_PROP("feat_DBG", STR,  "v8p4"),
+    MODEL_PROP("feat_PMU", STR,  "v3p4"),
+    MODEL_PROP("feat_TS", STR,  "flagm"),
+    MODEL_PROP("feat_LRCPC", STR,  "lrcpc2"),
+    MODEL_PROP("feat_AT", STR,  "on"),
+    MODEL_PROP("hw_prop_IDS", STR,  "0x18"),
+
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue neoverse_v1_v1_props[] = {
+    MODEL_PROP("cpu_implementer", NUM, 0x41),
+    MODEL_PROP("cpu_variant", NUM, 0x1),
+    MODEL_PROP("cpu_architecture", NUM, 0xF),
+    MODEL_PROP("cpu_partnum", NUM, 0xD40),
+    MODEL_PROP("cpu_revision", NUM, 0x1),
+
+    MODEL_PROP("hw_prop_BRPS", NUM, 0x5),
+    MODEL_PROP("hw_prop_WRPs", NUM, 0x3),
+    MODEL_PROP("hw_prop_CTX_CMPs", NUM, 0x1),
+    MODEL_PROP("feat_DoubleLock", STR, "off"),
+
+    MODEL_PROP("feat_RDM", STR, "on"),
+    MODEL_PROP("feat_DP", STR, "on"),
+    MODEL_PROP("feat_FHM", STR, "on"),
+
+    MODEL_PROP("feat_DPB", STR, "dpb2"),
+    MODEL_PROP("feat_JSCVT", STR, "on"),
+    MODEL_PROP("feat_FCMA", STR, "on"),
+    MODEL_PROP("feat_BF16", STR, "on"),
+    MODEL_PROP("feat_DGH", STR, "on"),
+    MODEL_PROP("feat_I8MM", STR, "on"),
+
+    MODEL_PROP("feat_FP", STR, "fp16"),
+    MODEL_PROP("feat_AdvSIMD", STR, "fp16"),
+    MODEL_PROP("feat_RAS", STR, "1.1_base"),
+    MODEL_PROP("feat_CSV2", STR, "1.0"),
+    MODEL_PROP("feat_CSV3", STR, "on"),
+
+    MODEL_PROP("feat_SSBS", STR, "ssbs2"),
+
+    MODEL_PROP("hw_prop_PARANGE", STR, "48"),
+    MODEL_PROP("hw_prop_ASIDBITS", STR, "16"),
+    MODEL_PROP("feat_BIGEND", STR, "on"),
+    MODEL_PROP("feat_SNSMEM", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN4", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN16", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN64", STR, "on"),
+    MODEL_PROP("hw_prop_TGRAN4_2", STR, "tgran4"),
+    MODEL_PROP("hw_prop_TGRAN16_2", STR, "tgran16"),
+    MODEL_PROP("hw_prop_TGRAN64_2", STR, "tgran64"),
+
+    MODEL_PROP("feat_HAFDBS", STR, "dbm"),
+    MODEL_PROP("hw_prop_VMIDBITS", STR, "16"),
+    MODEL_PROP("feat_VH", STR, "on"),
+    MODEL_PROP("feat_HPDS", STR, "hpds2"),
+    MODEL_PROP("feat_XNX", STR, "on"),
+    MODEL_PROP("feat_SpecSEI", STR, "off"),
+
+    MODEL_PROP("hw_prop_FWB", STR, "on"),
+    MODEL_PROP("feat_BBM", STR, "2"),
+    MODEL_PROP("feat_EVT", STR, "ttlbxs"),
+
+    MODEL_PROP("feat_E2H0", STR, "on"),
+
+    MODEL_PROP("hw_prop_IMInline", NUM, 4),
+    MODEL_PROP("hw_prop_L1IP", STR, "pipt"),
+    MODEL_PROP("hw_prop_DMInline", NUM, 4),
+    MODEL_PROP("hw_prop_ERG", NUM, 4),
+    MODEL_PROP("hw_prop_CWG", NUM, 4),
+
+    MODEL_PROP("hw_prop_BS", NUM, 0x4),
+
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue graviton3_v1_props[] = {
+    MODEL_PROP("feat_AES", STR, "pmull"),
+    MODEL_PROP("feat_SHA1", STR, "on"),
+    MODEL_PROP("feat_SHA2", STR, "sha512"),
+    MODEL_PROP("feat_SHA3", STR, "on"),
+    MODEL_PROP("feat_SM3", STR, "on"),
+    MODEL_PROP("feat_SM4", STR, "on"),
+    MODEL_PROP("feat_RNDR", STR, "on"),
+
+    MODEL_PROP("hw_prop_IDC", BOOL, true),
+    MODEL_PROP("hw_prop_DIC", BOOL, true),
+
+    MODEL_PROP("cpu_revidr", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
+static const ArmNamedCpuModel arm_cpu_models[] = {
+    {
+        .name   = "kvm-base-v1",
+        .parent = NULL,
+        .props  = kvm_base_v1_props,
+    },
+    {
+        .name   = "arm-v8_4-a-v1",
+        .parent = "kvm-base-v1",
+        .props  = armv8_4_a_v1_props,
+    },
+    {
+        .name   = "neoverse-v1-v1",
+        .parent = "arm-v8_4-a-v1",
+        .props  = neoverse_v1_v1_props,
+    },
+    {
+        .name   = "graviton3-v1",
+        .parent = "neoverse-v1-v1",
+        .props  = graviton3_v1_props,
+    },
+};
+
+static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
+static const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        if (g_str_equal(arm_cpu_models[i].name, name)) {
+            return &arm_cpu_models[i];
+        }
+    }
+    return NULL;
+}
+
+static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
+                                  Error **errp)
+{
+    const ArmModelPropValue *pv;
+    ERRP_GUARD();
+
+    for (pv = props; pv->name; pv++) {
+        switch (pv->type) {
+        case ARM_MODEL_PROP_STR:
+            object_property_set_str(obj, pv->name, pv->u.str, errp);
+            break;
+        case ARM_MODEL_PROP_BOOL:
+            object_property_set_bool(obj, pv->name, pv->u.b, errp);
+            break;
+        case ARM_MODEL_PROP_NUM:
+            object_property_set_uint(obj, pv->name, pv->u.num, errp);
+            break;
+        default:
+            g_assert_not_reached();
+        }
+        if (*errp) {
+            error_prepend(errp, "property '%s': ", pv->name);
+            return;
+        }
+    }
+}
+
+static void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
+                                    Error **errp)
+{
+    const ArmNamedCpuModel *cur, *parent;
+    const ArmNamedCpuModel *chain[ARRAY_SIZE(arm_cpu_models)];
+    size_t depth = 0;
+    for (cur = model; cur; ) {
+        if (depth >= ARRAY_SIZE(chain)) {
+            error_setg(errp, "model '%s': parent chain too deep "
+                       "(possible cycle)", model->name);
+            return;
+        }
+        chain[depth++] = cur;
+
+        if (!cur->parent) {
+            break;
+        }
+        parent = arm_find_model(cur->parent);
+        if (!parent) {
+            error_setg(errp, "model '%s': unknown parent '%s'",
+                       cur->name, cur->parent);
+            return;
+        }
+        cur = parent;
+    }
+
+    while (depth--) {
+        arm_apply_model_props(obj, chain[depth]->props, errp);
+        if (*errp) {
+            return;
+        }
+    }
+}
+
+static void arm_named_cpu_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
+    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
+    if (!model) {
+        error_report("'%s' CPU model entry not found)",
+                     acc->info->name);
+        return;
+    }
+
+    if (!kvm_enabled()) {
+        error_report("'%s' CPU model requires KVM (-accel kvm)",
+                     acc->info->name);
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu);
+    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
+        return;
+    }
+
+    arm_idregs_reset_to_defaults(cpu);
+
+    aarch64_add_sve_properties(obj);
+    aarch64_add_pauth_properties(obj);
+    arm_add_cpu_props(obj);
+
+    arm_realize_model_chain(obj, model, &error_abort);
+}
+
+void arm_register_named_cpu_models(void)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
+        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
+        arm_cpu_register(&arm_named_cpu_infos[i]);
+    }
+}
+
+type_init(arm_register_named_cpu_models)
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
new file mode 100644
index 0000000000..297926e167
--- /dev/null
+++ b/target/arm/arm-cpu-models.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model definitions - public API.
+ */
+#ifndef ARM_CPU_MODELS_H
+#define ARM_CPU_MODELS_H
+
+#include "qapi/error.h"
+#include "qom/object.h"
+
+typedef enum ArmModelPropType {
+    ARM_MODEL_PROP_STR,
+    ARM_MODEL_PROP_BOOL,
+    ARM_MODEL_PROP_NUM,
+} ArmModelPropType;
+
+typedef struct ArmModelPropValue {
+    const char     *name;
+    ArmModelPropType type;
+    union {
+        bool            b;
+        uint64_t        num;
+        const char      *str;
+    } u;
+} ArmModelPropValue;
+
+typedef struct ArmNamedCpuModel {
+    const char              *name;
+    const char              *parent;
+    const ArmModelPropValue *props;
+} ArmNamedCpuModel;
+
+void arm_register_named_cpu_models(void);
+
+#endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index ae1c55c802..a7638f8778 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -12,7 +12,8 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c',
   'cpu-idregs.c',
-  'arm-cpu-props.c'
+  'arm-cpu-props.c',
+  'arm-cpu-models.c',
 ))
 
 arm_common_ss.add(files(
@@ -22,7 +23,9 @@ arm_common_ss.add(files(
 arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
+arm_system_ss.add(when: 'CONFIG_KVM',
+                  if_true: files('hyp_gdbstub.c',
+                                 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss.add(files('cpu.c'))
-- 
2.52.0

