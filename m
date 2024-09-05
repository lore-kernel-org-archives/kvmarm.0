Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2047.outbound.protection.outlook.com [40.92.52.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6898172D
	for <kvmarm@lists.linux.dev>; Thu,  5 Sep 2024 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.52.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725517863; cv=fail; b=Sewm+O85IWFFuQN/4XXzz539uw7um9OrgT9am5mAjdKBNBcuZkzwX7+pmymkA1SZ2OzBmFFlV8TT2MMt+PAd6mdjHC0BcsgALn4MMCd71V2sSvwmEQM+Ike9Jnq5ZqEPF1y7nnc/VnvNrfvS3IxdkNZKpKPj2Zzvi4HyUjJx0a0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725517863; c=relaxed/simple;
	bh=2qJNjC7mWneFwgU8VInzXjeMeGlo0jhi+yyeAEWPtuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o2PUEFVVXiopr6rbqDhjudEdNr2DWmpozjuR1mIFd9bFnSIh/bWmcHjh6zajx3L5rPq+2hHSHzVxF7lYZAKnBjKv8aUcACJhDJLaXNTGTom1q7tU9E8AZe5NILmtVNYTbg/LBKcXbUYkF723K21BsG0ajRDyCRKMvwZTIz6ILgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=TkMB0ZSS; arc=fail smtp.client-ip=40.92.52.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="TkMB0ZSS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b5rU0o9mQppy3Ct6DqgsXX5+ksz1Nihj4kMmuJjbAMX/bxL4zmZwgqShFBWEDGxFv365qY1joRnI4omfqh9Djs7T5nkHL0Q0Ym/zJzP4erkcFya1BcLqLWQLev+1SbW29xfdiFpjtix6h22WoUyl887MmB4Zk7U/yeU+cXS98R6y9P1vTDNT4okUedIchNOkq68HmjAPUhWt+aziEPIUXFy4RA3WhfLeLp1YWWFqfUPeV7UjUjPZGMa5HTvVHJmq/9TveovWFnymJIRIBN1DB/7y5v1m+qX3S++j46jo2YjTXY2K8nadhgV8mzCmPKWHL7eooat0lw44dfU4Oos00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s3xJKmuSw2QwU7qJX4msvKuk4TbPFTdHvDwsgrDnWE=;
 b=YHrgbWCIU2r675QUV0SE5i8aXtoXm8+pd7Ac62JdMC6xdstR5BOYNCMU5HEKlqWs8ciNfsgVJJXwmMm43a/PjsE8N5P/RPWksDD6uSMIDMT0ZrVgidT3fh6cWyAAyGzvuUn07HHsg0Ml8FWHHD3qoZUek5vCi/zU7ZMNpo2AtED2WxxlO0sKt9orTC+P37IxflnBriyv6U5VMT/GHON6XQegxwbRJVhkeAKUAMZo1nBiSwep7J70RAuBhAkUO2+HElnn13ooTdyKXtsL/aWGHBHgNokNi2PCrZ3QHI5QFRmf5cVp9XriTvooU48QWYJKRXFNL2kyES/Nnyl2HrYhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s3xJKmuSw2QwU7qJX4msvKuk4TbPFTdHvDwsgrDnWE=;
 b=TkMB0ZSS1sLDCDwG22sxW891aS36VnLLoJaTz/AYPLgOSq2Jj83fmKEUjJzgPtUCVvyaO+jejyAjPNWoM0XGeRVgyPnuNQFM5kFjkNFgyiAGV2aDn9uifbNASacmsvRhVg88KadPfgjItf2pWrCs/6X2259Cb6OXks4mrQXonDnblNn6oV4QqV0RVIPDYuTIvmcMiB8FvzbC4kzK35F3YlEEq0/Fk0EevIEpPHcyo/NTE4cOjf1vUW9yPtz8yz5iVvyVC8vanZ4nDuybJmZaOEh5OtBtWum19sNp6Fe729eochSMTimMfJTXjzHjOzDg717z87C/2YqP/gbSbUt6kA==
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com (2603:1096:101:a6::7)
 by SEYPR04MB5737.apcprd04.prod.outlook.com (2603:1096:101:8b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 06:30:54 +0000
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4]) by SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4%4]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 06:30:54 +0000
From: qixiang.xu@outlook.com
To: maz@kernel.org,
	oliver.upton@linux.dev,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qxiang Xu <qixiang.xu@outlook.com>
Subject: [PATCH 0/1] KVM: arm64: Make nVHE ASLR conditional on cmdline nokaslr
Date: Thu,  5 Sep 2024 14:30:25 +0800
Message-ID:
 <SEZPR04MB6319DA388C85C7A7E13129CE9E9D2@SEZPR04MB6319.apcprd04.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905061659.3410362-1-qixiang.xu@outlook.com>
References: <20240905061659.3410362-1-qixiang.xu@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [agUejvEB6sA+Ns6IkMMR0Px5pUhf0/32]
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To SEZPR04MB6319.apcprd04.prod.outlook.com (2603:1096:101:a6::7)
X-Microsoft-Original-Message-ID:
 <20240905063026.3411766-1-qixiang.xu@outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR04MB6319:EE_|SEYPR04MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: e5726afd-87c0-493e-c6e6-08dccd744b71
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|5072599009|8060799006|15080799006|19110799003|3430499032|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	YOSsycq/tU0sMQxAaE7iAVxseWKNy5HO8gg7wD7nw5CxUR6dz+siskTR/K3RPJewhF/xn/rCkqMYXSCix5zErPzixGexLshVsN4GExOrp58ZJwjF96E4Ha2MSKgWUsiILq46mteLsXI7y376KPBSUj6nZTC3hTTEChKvz3dRrMJs7XfDC7lI570vHwf8MHUMQWn9xrZ5Ibc8TDFigwTyNkBq6gTuZHdv/u720BlTjh7SBVGHvlqXLZGZSxviS5ycS11clqw+FiETxZramkaAwmx+3NlHfJbgbLi4CdEtuJTg2ys1rwULjCkThhyrrOm6Q6sCgZb9efdkKmvGm8y7+lI/9h06DufW8Ay+5wz/Z6FdYQwaRX3lNJEhPguAC213P+9mfwDbhYojv6aZ8IV3sRSLju5IizibMtVh7MSoTlCbdpXeKMF8RhzHtdHy7AJRuzSs9ZEpptZSNYuZfu7sKFAApEd0yVfmsXPKSN9aYaaVLNAM6DRDMfjus95Xfya/TfSSkPTeArnVt8rs0TZo7pR5I6eunZnkBwZselYIWUgTtJkIjXyHCe5FBX8ECid+NQ2hzw73MFmV/5jkPLndUTlMaa41Qtfl3EekidmmRoSMGjL3Mx7qOIUilHt1JY+SqiU9jojiMuFuSTKnX4Xo9/PxitXmwBZoBpofU93NmM1ZtxrDDVokR6e8B6V/N/LuO+UHSiG+4e4sR9sNWr/dAlwaTzyfQKCyucHGDiyN1fo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X3OA+mOZypfraGYt+vv/OG+BRbADjpA+Lamjy1vbReJB2pRHSNHJdWnfBy/o?=
 =?us-ascii?Q?AYqR6C6O8Rf6M7Y42Ld7Mgm+ul6Dqwvbd0Gg94NIU0I9Mhsq12Sz4bkacVDY?=
 =?us-ascii?Q?+CTz1Y7id1qma1v9xoBh8xAEU9dyd33elFx3oc8tVjoVNxEHEw8FFG2d04tt?=
 =?us-ascii?Q?dcdLRnWVEeCAQjv78nZRk2nZtXKlmYENlMSOTEB6urW6kKvrCMp5CISwDvKz?=
 =?us-ascii?Q?ecz6cgiPAtiBgVJ1KPegZtRuIs2QlR/ecQ/CfrlyXmymxzRa6Y4ttnuI2jjj?=
 =?us-ascii?Q?adE2fxKiHl7Vbeg8BIB3zlNjOFlSuQkWfks+K1fznYh4psKzgudQCqOarGav?=
 =?us-ascii?Q?BEnrkmnKo73CUs/lmY1DmoIA+RNBVTO5X7Di8KVarMafEe1rdTLeWQDT+ebA?=
 =?us-ascii?Q?9T0jHnjuGlggBo8MMczxE7p6iDagAOPJJpteWBDewf5NQl/DuW6N9qhARKCJ?=
 =?us-ascii?Q?phM0nrolDZ1J8Q7WD9nWVeOGq5G0MrU0MGbGtt2v0qFvif/Qf2dPeM/I8CAL?=
 =?us-ascii?Q?VuJQgw7xscS6So3RnbliSjDfPRihDNccOLjrlO5AtpK54OiSjnVc9Z6wFpaM?=
 =?us-ascii?Q?nsXspN2CYkiLK4wKeRx1kGcQnRZ1tvkl3YzF8VaedihG1W961OqGQyeKL5Aq?=
 =?us-ascii?Q?AIGwzSr8gKL5aOyecyTb+VqnH7xPjK2+R9aCdP5zqKaSwZvWO594Ae8XElIu?=
 =?us-ascii?Q?aM3L+T2bHTyIndezqR+Voji+mHcGJmDocEbK6DV+22XFaz6p+uXJsspeWqNl?=
 =?us-ascii?Q?9CR4opeRvlfndoq20lOV5muvftqkwSx9ymM6dxInFg/7HH4bPLmrpeuihiVY?=
 =?us-ascii?Q?z4WTPIYhlqWuQWclv1DuzV/sLelLuPY0jvFljV7u6+A/oBeD4TskQd8OSDdA?=
 =?us-ascii?Q?dEJA+sEnFm6QGewSeIpWVw2QwIsrABs/qamzAJnMMSXnIKKIaIPZjHysw1l+?=
 =?us-ascii?Q?3y6L7ER9HXqvZQJNHOs6QWeAy2w1++UFqTHmj/1lOMJdj4OvpkA/HhM1SgYf?=
 =?us-ascii?Q?/nLk5yKhlBhrudf7PE+zHKKmW7iYckCxAUZuetGQSSqMDADFMh3eD9UNE1ow?=
 =?us-ascii?Q?5hqnXK+zI/lflXkQC8JMKN8rOoSzlvjgNHmJpnNIXmK2XtiZvDApc9HaXGwq?=
 =?us-ascii?Q?j+uSwY65dy/9vQ5h3Fos4iFIMejT4/PSb/I7XvK1zIGIEANjB9XfqYiwrusK?=
 =?us-ascii?Q?8OqPYey6dwpD/oxICpGqwtoiOOW7cNL7ijvrUqucYfGFZT3O1Zof9pIeSXE?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5726afd-87c0-493e-c6e6-08dccd744b71
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6319.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 06:30:54.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB5737

From: Qxiang Xu <qixiang.xu@outlook.com>

The nokaslr option in the kernel command line cannot disable the hyp VA
random tag. This patch allows nokaslr to also disable the use of a
random tag for hyp VA.

Qxiang Xu (1):
  KVM: arm64: Make nVHE ASLR conditional on nokaslr

 arch/arm64/kvm/va_layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.25.1

