Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FBA477983
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649041; cv=fail; b=O05vQIcq5vQ4tzVNbHyVjWs+q+jhacA6KKCJ29N5S0ew4OEjCzNA4mg/gKUJl0/i5c98cORs7Noy4ky9yiclZf/rOnlZ2lo1AVWsO3LKePEplCkesj2rUunpTFpE/98NY8LxYK4+WP6PmBM/2Pb+7Lw9Lb3yyPQNdPUhpb9UGNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649041; c=relaxed/simple;
	bh=IQNGEhYlzZFBKl2PeQDkE+PUq187fNtT2MU/DL+ee2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BjAov8TnekJmv7pMsnKcYVUNreFIw86X4/adzBajjgjt6hh8uIjQ3X6u0hHR090eLEf87rJNyeWp4MwN7XJGv39d/iLNu474FSUjnmBMSDDd+rcoRIHzV8EN7kfA8siLK6/m5s474AWiddDfzaDcugT6LmKepNV7HF9PXctSksY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=AAAbjGtt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yhv+t21l; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="AAAbjGtt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yhv+t21l"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLK854749;
	Fri, 5 Jun 2026 01:43:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=MAJc1HSlhF42Nhair8GxtbMGy+jMY5MHL+2Mg0fEx
	hE=; b=AAAbjGtt3qc7gnfwVkuFVJMEdbOPoT+MX2u0jE5Jsm3ziOzgBIUDp4ZAJ
	YgAx2s92MCFK/TL31cxb/+d04C/cT9eENsH0356lfqtP6nZQAdBHu+wcqlav92Fv
	HRVVki8hlYyAxEbmTxLjePnGvNSjGNqtr0Ye5Y2o8zJ7TPuaJc0f95DOFKwzsr80
	AWTzP6Uj21lNdAKMd14vJL0QU6dHPSZlzBqWvFcx0jbR17+O+tMxUZreTC+wpdwl
	ECR6iCgMCmju+4F/Z1bSr4BqE58fYWq5vPrOrasLXVNLeoRbZWpmUWFz/PteWbDf
	27l7zdX4ZuJfiQQI3w9N7gT1aTo4A==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4y2OAFirDy1e7hgaGagU8H09bv3pwhoRq5qetdIxwTqOW+vSf//vbvoly8bBzERSADkGi7WTj7irv1Z6MfF5WWBqrPgSUBnN3pPZHEOl8Veh9ZSfZuqNJhW02HvRAvTQoh126BYi+jnkngbwOuOKOkNcImVe8kAB6vGHXU4dCqN/HSWEy0gw6pnnEkvhIFKW0WeRIxYpjTDK7r5qVcGcoV7S5VttQNwrHCne60iGXZgxxEusp6e1ld4PtL+JN2g9Dp+gKHRhu0+h1VMNG6Mesdjw5BrqUNkLFvKWKP/5cA9Mh9B1qpjp9OS84HKNjT6YhFF2r01p7W0H/iDcdhg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAJc1HSlhF42Nhair8GxtbMGy+jMY5MHL+2Mg0fExhE=;
 b=K2mWT/YTMK8Pj/b5CpdQBnaf25iFIhbPwolbReXRcsdLxzwe4uhuYZklDCEle7qYD48C9yRCJud2CXIoNqWVkhREhWKFa4IuHDa/py8ckwNhiu9WUsjLE+UA4OK7sSBJDLhZ2FtPc3dJgke0fyGj6a0LY3twVW2I/G59UFkhIWyLW0uhhfwkM5fqLIstBMTswdq5trW/ilVuJ4rH/hDFtu3sk/y1OmLA0LNRzTOpFHEvyObu3IKscEuWSOkWlPBxBsY3Jv1cdPf3aflbsfWwrxROhIxuQAKi+kgztCzqo9hr0R1ASx0Mdhd+zE1ktFABZmIQaAT/qpqiB1rJ5KkfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAJc1HSlhF42Nhair8GxtbMGy+jMY5MHL+2Mg0fExhE=;
 b=yhv+t21loZFZ4wbRV9z0vRpV/1+jtpr+Wn5DPdE8dD3gJCZB1cPR+GLjGMT3yA4/QjqtHr7FS2sO1fmk7lewqTCciZwH2ax2p7r8gzu84WnI2z9rVbsHQycpX9bvNOWX29AbIYiugqGfwHbZGfDWbw/Z1e+NtZ7AwKg0xa2mhttsliEnTkaBdmJx21+NBWMwrR7Fd4OwKAqptZBZ3cfRkSsewHsEkDNtxI2VMDCmR45BijJQJGySxnZ3MxKH8wS+TaedTtEC+rC16vPN1/x4WmZHzkVjw1hJnW9TE4QUt9uESjKTwFej/yC0c9Ur2en1q5/DW1A3uoXg8Mi8UGcGrg==
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
Subject: [RFC PATCH v2 01/29] target/arm: named_cpu_model: define containers for ID registers and fields
Date: Fri,  5 Jun 2026 08:33:30 +0000
Message-ID: <20260605083358.1320563-2-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7f7b3d35-7e5a-46a6-41fe-08dec2de7848
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BJMUozMqFutWhSdX6sLjdlUVkOMNX/94dlFAxxeKZClMTrD3yfAoCTdUKIGcBrUnoaKlToVlHmfML0//dCwY2ruCWB4T8Ka4uClZXlVNXxDTw7yM0BQY6EfP1mXfH12Au0i1zEQW30zfXS68FR6T1Rav24QwGNjFl1oGUfza3yq4xoBClp8jsInYf5OCTaxebybPCGZvRXhSE2BMpsuPfkBHAGzH6kX9d3mjETMdEF+ncvlv2Wo8F22LuP3NbeRz8OssIDfIFkmnVSCV5h5xRBOcoXHY/OlfR/xpFzpCt2nVXT5kT7jkDWX02Jx9mw0u7hHoVsvAnfwpcNXeOO6Koh2hNa01u/pOrzmXp/bbCYzW665rPQsged+zhytGqsLxyC785R3kWwT0k3mVhlvuh+OXZ0G5IeBo/3Qap35TlRe7Hjw4ecI/BBxezl5MUZLMnFTDMtd7RxaYwwdmN3i2MEy1S261gz5gB6sgKP+/83TbwHgM2ccD4CPK2kYA8pCSCXOWvLkF9lnQd0xQhaf+miaL3IRYtUbjdTTnrGZrrZJTltEP3v86cDcEVZu/JONF7K/+uff4Wu0khv7nvgsrX25FW7ZMxwo9JUsF1U+2ATlowOR5WVe5lwauwhPPKLeivAjZGTnpR+mfYcnzrFdXpxVNop2M99A5lUWM6NJiTkLc9F2p6qMqrnufvaKdNjTf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OYzi6E4cuy0Iiw1TcYCy0FhtDRWTvLsE+eIVO/mUQyc+O+lPbwQFMXSk2IbY?=
 =?us-ascii?Q?zg61b3UEscD+e0Y7+BLwF2+2M2SJ3u4AZdJCwWOb/dL0fGZzstNdztIp/1m1?=
 =?us-ascii?Q?DD1A5RKJ5fiLj2o5xCdApnkSC9K60rD5OaWnF62SQflBU3gkiAymBOVCmqwE?=
 =?us-ascii?Q?+ANq84wJUwSVs50uJJPdcejLVgsSyQVLLRCKpQDa72cVboFAVnNdSazYrJW8?=
 =?us-ascii?Q?wFeYo1122Q3AF6vRBIyiAvZYuP5eWRg9JR+Oo+7rpMwwUBW71blxgOMR3Puq?=
 =?us-ascii?Q?qrBGpc5UbQiM/+v9H46dp1fxpwvDAlZiXfdZmZ+s3+w/a6JwoAY3vqN5Axb4?=
 =?us-ascii?Q?OR0+rlU3zDZZlXtuti1Fuf4MbGyVps/G5YsKwCX6jzMIBRYYFnGhdSjAIVRn?=
 =?us-ascii?Q?zQL5Ni/RHxYLVH/8g0M5sQ6tlDrLWIbpnMav0hEaJsnTT+ZsrgMxtHqo568d?=
 =?us-ascii?Q?K3dhjHlS1s2kP2RFI6ZrYReUmPd3sZ6l0ARG5xxukaG0T6DskaKHAXe+GgZS?=
 =?us-ascii?Q?6rBWfrP9A2T65Kl1wTxG0Vr+rN2YUUCuXNxYVo8Co5NFXGary9tCXad+xQrb?=
 =?us-ascii?Q?bZfam7zrphIEqIKJHlFhkFWj5bH8VVx7HrAMd5IOw+KS/WuI0/NqUbTX9CfM?=
 =?us-ascii?Q?diVz1W+CE3vddJQLd+ox+1nbcA58JLGAeundCnYExTrIb1p6g4o73M7de4Zl?=
 =?us-ascii?Q?YfdFL3DvwGKfJDWC3jV4b7nZx2ypInKz+aZUfcBzUBxK7p5s9s1TgniPcqPK?=
 =?us-ascii?Q?I8cAlJBowxy6ubc02EkE9bygNj6Tc8569SFLhOLXPpST58ujdbPTseYCMwq1?=
 =?us-ascii?Q?wAXzf6IaXhvJ+Z7Kqm252O39cQftrn1Z3Ii0K0Cun/4RPZQR8Zx8ozVYwawP?=
 =?us-ascii?Q?dqfMnIVPbL4qtS7YEKSU8VBFwMSRhFVoqoNIDAhlVGqDE74KYXk8mP4IgZCo?=
 =?us-ascii?Q?0fd8gzYPrNH8jPAXLpqjXkBoPgsdK7bR2i2yxjehXq2WINHE+J1RpN5eNEpN?=
 =?us-ascii?Q?VNblbIuNHIYEzTc29+DF9q2u9CB1GPBa8SuG2EDUJRdY71Kp8OSY51ODcqS3?=
 =?us-ascii?Q?QwXMX/SHOmFWgflLQAP1517RQ/Ko+A/rg7DKCJ82ZsxodfPGTS0y4fQBDZPc?=
 =?us-ascii?Q?AlsZqZPz1z+97lawFuPTHIox1EtO4nJA1LuDp694C+ewEUMf4famDe5psa/6?=
 =?us-ascii?Q?I6R/+P76ct7W/u1bveN11idSHtsdwM/5AdffBpzwpF+9/qbbbhpab7VPrULD?=
 =?us-ascii?Q?jTWy3ANI2ZTl7zdO2njpqyd6ZjfUw54F//XlBZXJ9vGFklIgAyWKZDesi9Gr?=
 =?us-ascii?Q?On0BG+m7QWdS2veFvLDRkTIFathWRuL8x9qsqjr4FboNUw45PpgHJf2qkaKI?=
 =?us-ascii?Q?fpjss4v2n0mRk55IOL2NRYSvPgdyyvBMCMdseemac5dMHmmceAFsqmRniRbe?=
 =?us-ascii?Q?pq1ZfWXMfNWZxsD1PfzfvqOAIBXe5qTqRIT8SdNwaICSem9tXaqczNXAzGeO?=
 =?us-ascii?Q?0UN7faNvJErFCDvnq3cdjhMHzwGxkzMWVb4XBivIrhZ0FHRFqE7egQNlv8FH?=
 =?us-ascii?Q?j1tl+M8a5WAXJgsopbkDHAwxKDqZGmE9wHcmnKi9rvB7Z9arCleNGEFEjOsn?=
 =?us-ascii?Q?wEyrCrQO61agg7gdwjQJ13eagQAO443Wmk8PZsahJak2VAY+8GpqqTYNtpW1?=
 =?us-ascii?Q?L04RPMwqorX9nZpamA6T95CglMMSoOmio44VQ4JWlUTmtKZ9sMYObLZxKn3y?=
 =?us-ascii?Q?k8TzoaUPHNsRjvPGQGOJFdKo96E8Vw4=3D?=
X-Exchange-RoutingPolicyChecked:
	Sn3le/tfr6hQQTLlTFFc/71GPHsCwVEJXJe1aH2mAOMWZs9nyjWfqvelAm6buOH+YnuCYjFBfuyL1LNgo9bw4WKcd/Emui22P+/QNZYV+ifK63XTzFFVI28PtMTlaoC4Qy8hilKlzaBEWUybvdCYeCf+26kYOYnhjzIh/0kw3nvijleqNTXIxq7Bu50HPBZbZkSptge7M0J/l3ZJaAIq3A/WtyB6czWjWf6Bv+2CTEFrPyzou66Amk9MkKJFNjt+47N8PnbYyxm4Hnz5XJaQa9Jnm89hRKGW3p3jom4lY15elVZGO2rItqZSMaaemM9p5oPqDwZmcr5IjRK2hB+MvQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7b3d35-7e5a-46a6-41fe-08dec2de7848
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:09.1044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPwsKqxiP9s3Zkv8CFSNNwE6Ux1mp0WqmVk+cvjaXR7/e8piiO9kse5rxWbS28oEIhJQ+nJWvtd6KjeRibCH/luucWrGgP9q2LVtaUPwxdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: _6_hlpEpDPoNa6GCBknyb2xoMdOgV3dT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX0uHzNhQ3kG+A
 aSFxdMctQ344R7Ut4EeiwZzI0FVDHuVaR9UlVW01TaCDgsPqYsxCm2/eO0Z6y/Ja8e578SlR9+T
 Lks58PgzgdSLMVnH2mPomirlqnsyLgxPV/xTyVA7IFfWQw+x+NrIIbymx5wU202WknXmVjyKtOo
 Il/rhpFTGhqRVFjxbCWhQ6Haf9AXY9PS0/5I7Whz4MMAPqUl9UWqh9XzoV4N+8k19sN99KD77Up
 gr/ghD4uPalRhlyBGtkK25clAOoAvfKbHfzmJENCdSQZc051zYipumnkdHXAvFLMLurGdLPn1hK
 KTwcX5GDdoRwPrUjtkMZ98NstcNuBMu2tZxxk2Vrgj3Zkpj11KeLLUbUy4qWYmWQL4hRsnYNCaR
 tNr/umibYb1n83+aGx8X+16RUzSjbIiDgm7ZpSg7IYnuqGrkXMKtJgqeSPab6ncNu4rRL5YPGJc
 97yLFb0M4BdWzXaz+hg==
X-Proofpoint-GUID: _6_hlpEpDPoNa6GCBknyb2xoMdOgV3dT
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c1f cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=-fu_RHnTTDa4Pe3X_OAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Define data structures for mapping the ARM ID registers and ID register
fields.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..514ec39106
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,41 @@
+/*
+ *   ARM ID register field table declarations
+ *
+ *   SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef CPU_IDREGS_H
+#define CPU_IDREGS_H
+
+typedef enum ArmIdRegSafeRule {
+    IDREG_SAFE_LOWER,
+    IDREG_SAFE_HIGHER,
+    IDREG_SAFE_HIGHER_OR_ZERO,
+    IDREG_SAFE_SIGNED_LOWER,
+    IDREG_SAFE_EXACT,
+    IDREG_SAFE_ANY,
+} ArmIdRegSafeRule;
+
+typedef struct ArmIdRegArchVal {
+    uint64_t value;
+    const char *name;
+} ArmIdRegArchVal;
+
+typedef struct ArmIdRegField {
+    const char *name;
+    uint32_t shift;
+    uint32_t length;
+    ArmIdRegSafeRule safe_rule;
+    uint64_t default_val;
+    ArmIdRegArchVal *arch_vals;
+    uint32_t arch_vals_count;
+} ArmIdRegField;
+
+typedef struct ArmIdReg {
+    const char *name;
+    struct ArmIdRegField *fields;
+    uint32_t fields_count;
+} ArmIdReg;
+
+
+#endif /* CPU_IDREGS_H */
-- 
2.52.0

