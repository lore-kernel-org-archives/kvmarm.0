Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64260498928
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994034; cv=fail; b=DIZDWRYCNhQpw80a1k/JjXFbtPHPkDeqSr4QLmQNwr5gMJTnt/2Ch8f4+wX1gyXmYcyE/kde1sQ+h5FqjE/+YqtmqFG3rvD29sthUSf2oKWkE3NOVhUSnvydkUe4AwKlUEAO2lpOVyk/W2LIruNgA3tiIxJX13zzW+l9MyG1TwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994034; c=relaxed/simple;
	bh=E7cm7urKKiv/c631fRKrAkvWYxLvTcrzEGQ+bvHDrAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5RtHKPZZdeUutvH1FGhYxZdzDD1YSyEdKJ5MHhztD9iM4TIxTc+KdCSnA0VKLypDz86Mt1Pm6kgCjEQ6XX3ZQhjBOEBViF6zk7h5g+G/8LrVZwHWbHfL/Baklrsx14o9DV7chtROFG0yr2S9doAwGo592OsPBcWd4HmJCWuqCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OS2QUr/y; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=O/Zclaz/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OS2QUr/y";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="O/Zclaz/"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAhHpE857563;
	Mon, 21 Sep 2026 05:33:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=G380QeC2TQ+0Qf/QaJkVpr/OlsW37Yh9PxiB1osY2
	k0=; b=OS2QUr/ypFuh4GA9hJalKa7hTrBeu5RrtW0tW9L1xGyT1eLck0HkLFstw
	ptSzr3lWTPLoAUVs06iCUhMjr/ovP4ulMUSCiRkw8/Gr899B+K3xU55ffitrXwyi
	IEgL2/d2358FXkgkS9PesVV3C/KUqmvTrek84/7tCOP39EW2Z8QTmQ03PZ/A0wQV
	iW5sXgcFFcw+uze8h6jZmSW0dMy5DrW3Ceef/x1e8Xg5+Dce8+GLqyfLg0bsHPG6
	0wm1k0ONBTQIIoW2ZNWNob6Z2y8rQSASPmZkZdabr68zsytRVrkqQ9XuasjuuMwC
	lyBFD3lO2N3Rlv2FXQ+yvEOOa/Ixw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023104.outbound.protection.outlook.com [40.107.201.104])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gspa73jnu-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwE5EntIDJvFERDRjL7yJshEkHR3+O3kdcSesPkXHAwE2P7Vs/DJWvJGPLlJIuuajAvTEjwr9Ty29GXhaHB0XIyrnh0m3Nprv/u+b4DS0I8CwpNLn2ccwghhqIXPV5Ayt06TDqk9BU/I4SearY7q3eHy4TAjef5zK3MtQwIpm5Pav0CcxR8NVm0CVZO/uk0NlZa+aLWl2kZxCD5H3rQB6GNKsOsEz4fOtJTvNui8Ie0DwD6w37lkZZKVnTiNtwjbPQ68sVr+UZeixASkrUl0DIYhr1WVJf2XJRqe4ft/T/gq7tK/JmsLbu3EMapD8be5Zu9oML047BiffKhmFFiu+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G380QeC2TQ+0Qf/QaJkVpr/OlsW37Yh9PxiB1osY2k0=;
 b=RYPRa5TjfPxru+WxNi9QqeX+6h+XcHgeyPFBSOp93pMwWp/4uIIs58OBCOYtDcOyUYIBfzabTxN+Fr7yoQiXNQ4cFaABLlk5B0ranXg34i7GnIsFChEXwPrmKGo1bzIHlc6p3w0i86MGyn2B7WFDeuitpa71WBe9g02hTbIS/V7aMClIa3FsC9wsFNkQ9p2GgY2TGwoIOsmKKv/GAV17hL+sJ6PNXrO67u+NeFR0pPh1W+ibGaGBLHQj+nGaW57Mo+7G/MhibmS+Rgz1P+PaVaTBwzkUaSyFRQFsM9b2hWLbF2wmnpJl0No9YSs+KGgOVoqLtvGG5LgmSU1R0AJpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G380QeC2TQ+0Qf/QaJkVpr/OlsW37Yh9PxiB1osY2k0=;
 b=O/Zclaz/UNxG0YXi1TaVQTzsZkp3bmzFtZmkwWRPHO8kTkYxaXKPK6sL6hqihMuJzIdM9X86SPWQiCszI2zEBDzILdMRhL7kB3rJ0NoED/1aUcl0GismxKIHSannDumNAFyumpNIjYJ7mnEcNgf8OheqxJsWLCCCRLvogMczlDYK2EUje8pAj1WYSlv7lGw5iSbEEdei66MG1q/vc83IOrPjy5Kax6dW3AdD1ki6tkFcjL3kTfXyr0JQsmANKOt/6F1G8nKpYMNfNjJF5jqYlVFcC7aSJBBBpj9NOLJqHNUzWRpEltdXKx9NeuGaYHqca8a8ZeOaiGfo6B2ZCTiY8Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:23 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:23 +0000
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
Subject: [RFC PATCH v4 03/25] target/arm: move SYSREG_ prop infra to cpu64.c
Date: Mon, 21 Sep 2026 12:32:27 +0000
Message-ID: <20260921123249.1708067-4-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 988c9a87-70e4-46e4-5120-08df17dc8711
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	roEn0DikcVy0dJtl5O/qZXDPSE3giWUVHvPV7f8RTRynUc6xWr8bviBorXzLGEfxdk/+NwhaIRDsh/DUQpgAeeq9zN1hObB8bgBYua8seBYDdHF7HksXaZUtsaRTCOj/IgSJeYLPFEPKMCnJtcCS4hmzSUW0qrPlIh2F+wP83ds1MzrC+6AMORnnIVbvL8ZoYXoCBxm/bD0Olla4QpPEeipcFlfVJWQGOkUDnX2+AU1ZPQwKS3zbMMAssNYCW0hXIizl5KFwfSjTV5+pduGgDi3aql3RfpJQS3xTcaSMVFYE6EEInK9Z0ObeW4AKMC/naH3tPVeypwBC6J+wGO8zIbOXKRXKrT8vw2D9rQ5WnUL27EgfwIQSzak5zg852THISqk41IbKMdpYT3ZgnBUDMxJlAzfvjjH3Kse5H1gKzzagdWSpt3MYMtRcVG2HMboAlbL9F54fP8mmeC073SL2v9N2vtfRcRsYopzZj622Et9VmunhppzH6WwNJz9qYSd977vhNve4rgYSihGembSogprqvS9c1fpRonGfpFLYdrRsByactvkwn0eEVQRhG99pigy05T0oELeJ/3Cghog3Vq6I5sM0IXu7oc5JFpmkLNYnT2vYx1Ocf/IAlXJQoxaE/TWYP9GjLIdlt7G+41YKp4J0njeihEIjbu1D47Dybss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?POjKar/3id3abKZmnTG8hbOArRIAz6vIHFeS62Wu/1snaEy5L+wdlMVo/rVP?=
 =?us-ascii?Q?Brrzi0XTCM5BNnHMWF/Ymbd8TlBO5dAAdaxYGU1V8pZZhJCEg7sS+w5zDBBn?=
 =?us-ascii?Q?7kfjQpvMFlHcHvlLTOxXJa5SPPFylHULN8/7y3GaQwM3g9W0MxVy1m+YFY3w?=
 =?us-ascii?Q?lAYGPgPxMctDlcxnhpvaOTGu0cdZV52tPJNeKXJdJJM6IgoQ9H7p6BTx66NL?=
 =?us-ascii?Q?WBY7lEbkeDzExMj609OX7igEqETDIMzKIlAJ9I3CYs9NEMYpVkpwGFQTBqcb?=
 =?us-ascii?Q?R7mI61n4Ta2M8EFQkiPaZpqHSOpZvCcs+NgqHcrINB105YvR72kKDRbLGes1?=
 =?us-ascii?Q?XPOG1g3hKGu3cIc/6cMpZGL4FCPS/SE9Td8xfhcuYM3HYG3ncVWe/TnUVUva?=
 =?us-ascii?Q?TuxvhHKekIzLdG7uT9bvV6gVKCJWxg5NLMktqZZD4N5axOWZVZTzEolyKO4W?=
 =?us-ascii?Q?oWdWsvxNsebGA5Ce7thYcoc+4CU/Rn5pH+LSHCH9/FJW1TDvsqKQkdR/JdBv?=
 =?us-ascii?Q?lMiKpn5/rjOuG91RPPNL30FhM5X6LkX//+P219cbH+gQKeTXxaJWBhPR70vZ?=
 =?us-ascii?Q?63OdC+rEU97vI+gAQH/+2BLs+y+UO4WmDwNC8XqAngCTiqMm/Une3QPe2o3b?=
 =?us-ascii?Q?ZANApryBFYrwQFZHHwVhTD+h6pir0tUf5NyvzIxXohm6QbCRyWD4m0SNrBla?=
 =?us-ascii?Q?oPjtfzhO/tRZ4FBiCP266lJCseO3JsMgtJCZhujHa7BQaeGur2aY8YTUBEjP?=
 =?us-ascii?Q?+TopWsqGoJP1WcbmOblhnykU6J5Zv0zpQgUuWiulUK0H8Gq5+MO5tFgdLJ7+?=
 =?us-ascii?Q?OnUeKOfvpz/LDzVCTskGH09gKlKM26RBN3tl6LuT/zsV1xDohyHw/AeEseg7?=
 =?us-ascii?Q?fbL0KUTFlxAq1DZ8zv6b8DeiuBMN8cvk/zC/nP3JAFan1LRXHy7SboaKPVpk?=
 =?us-ascii?Q?066i5t+2Nb1qJV4Wv89S/s76cN+vG8eqlipnRW+i8LaIYYeKdVT3CYyqnHe4?=
 =?us-ascii?Q?ZR9XZ++WPMIHfBPWsgoG2mm6hB3dJ16Etj5xtY55F75luVVSIWpSeEDvh8Za?=
 =?us-ascii?Q?yDuaDIfiH3f+1CqcNQaycKcVyrAdsZhy3uiSy4sL7m2WGrP3He8mfLTBTFCU?=
 =?us-ascii?Q?vIMCsF0is25h9tSxU0bJCoaqgMA7re376JEV8qzVDmOFhymxGgd7jx/mG5Vy?=
 =?us-ascii?Q?ZEU7uj8Qq90RbddZdoZVD3CFL/pDy/k4WwvrPy4OYoNy015yVfHndgupXtIf?=
 =?us-ascii?Q?oxBJzR10W2zi+6RN5BGBH4HMQCbsEbkxwf9RX9Yf5mj0daoKdxYc3zSetu20?=
 =?us-ascii?Q?1Nq5kyYwozHgjXmWmX0SHzc+Ej3EQxJHFhm1KK9Rf6hhkl8PyBHE9tiuq1Aq?=
 =?us-ascii?Q?OHREB8kaurdEHm9mIxuWvr9Fmr8pm8bbDP77LayonVLaf4Qektp84ow6pk9d?=
 =?us-ascii?Q?3bBQEfal2q1/y2iIv1VJKfOBGmfkh+XUkc9Qups6VoNKSWJM0L/9uW0FLEeh?=
 =?us-ascii?Q?suC4MLGJRWBSSG4Z7+6USdxrgnVVkjyjjgEE4O2plajc/gucQludpG/UyOnw?=
 =?us-ascii?Q?WRbuoTYhIKOdNgB42MqgtBA3ZMggIcOv3lSrcIJoJn1uzPw+mEUpWj+t+iqC?=
 =?us-ascii?Q?j8c6V0G/fyBWQqp5zg0ERgAPDCHS6Xa9tx5Pjuoyz2Qpwh4aBuzIbltpE4mS?=
 =?us-ascii?Q?HV6qiSl2/ClnKR7Pa/jMFw9itxvPucLnrpfyJzdk3Mvqkbuzk+Wf72lNRfNX?=
 =?us-ascii?Q?80SdfCJhcWk32nizVYkZihLX2i1yIF8=3D?=
X-Exchange-RoutingPolicyChecked:
	ZTXo18hYA8RcSle/d/mqpFnQhSaQvsR/tNJ2nH7++BSYgcpABRb9o8JZVY79yCFgnRq8FmEIwOgVFe7Taodz/i1YeavLUXPcfwa36uFb0BPbz+5E4MJpCAqWsKDb8xoELYO/K3cwzPzKQbOqJbuxhO0C4vh76pj5Nbx2RCJmsQwm0x2/3vc9YRKxbM8H1WBc7JWb2j8+wD/zsAx/axikH75Oa57f+DqIsHM+mhz1yGiE78YLQPmhk+3ga1U1owkRDqNpP/2axDQ3m9/SEE3Z7T1jmfO5MKdgKMu+YcwnGI4DJoZoGbOYJlLqWXUX/ghe4P8NyKZykS4HcHgxY6IUKw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 988c9a87-70e4-46e4-5120-08df17dc8711
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:23.7319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNtx1hRPSZQwfWa69BXqXAxY1NKZJa71Swm4ApfqnjM7jhGFUPoXOTBQCUuOXteAciq2O7lVeDwN5hzua+Leh2PdqQNbs+4paIA4Markcjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=fPWsTpae c=1 sm=1 tr=0 ts=6ab1241e cx=c_pps
 a=0aASrZ1Sr5nz2ag1/hSaPw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22
 a=64Cc0HZtAAAA:8 a=z54jcO0Fx586IAOs294A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX4mulSCd1Gn58
 S5ALvSOBbaw5MRXxWeUV2yt1GFI78cqKtsoCPERBbJU2yuma8Dor0wS3s7aK7u2IGrofqltbjeN
 /ASEr6vAm+Z8FxyDLkRRGmb7WyebphE=
X-Proofpoint-GUID: pqhrJgYXlZWZ6c--ATAUvA7YuDzSigJA
X-Proofpoint-ORIG-GUID: pqhrJgYXlZWZ6c--ATAUvA7YuDzSigJA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfXzva8d6uMtWwB
 zOZhtp2EPkwm6VFY65zZMedPEI45FrfZaqFq/5fXycORHRBbSs5p8O+zufXcu9ygcF05m8N5WJX
 qr7F18vxvRfkvOJkwU8GC1WwsK887708zv6Jd4AMkEbmib1Vf+it8UFVKW9FK45rsoyYE1MGoKu
 cH+suHYpIhWtHzFLJY+8FejQXeyzaKtGjQVs2NHE0dgm+G1qjxsfEFJLv3Q6Jk9TodWrHpETQu+
 ONA7KuE2TVk0LdaqoILs8slb4ngF0PHgG3Y5AiWhwMmN+Iy9wjCUFGDQRtZgEio+KHf5w/ewiCF
 axpP8cnDlryvVm4BqxqDL6uyJ3dOdDYqaW09roSt6fQhGtFwrlX3ExlC1/EoLsCIU0GIQwmc9Mr
 18CeNLjLb5tP0BcQHvfzn4MS9kTfpGm0ig2PIjrZUOaGpnxnojFhWylpz/qF1MswCko2eWFOxoa
 qQZhAP/6CT/x5Ec0NPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

kvm_arm_expose_idreg_properties() no longer depends on KVM-specific
logic. Move it to cpu64.c as aarch64_add_idregs_properties() along with
all SYSREG_ property infra, making it accelerator-agnostic.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu64.c      | 101 +++++++++++++++++++++++++++++++++++++++-
 target/arm/internals.h  |   1 +
 target/arm/kvm.c        | 100 ---------------------------------------
 target/arm/kvm_arm.h    |  10 ----
 target/arm/trace-events |   4 +-
 5 files changed, 104 insertions(+), 112 deletions(-)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 3d522bf20d..7487b48cc9 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -38,6 +38,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpu-idregs.h"
+#include "trace.h"
 
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
@@ -644,6 +645,104 @@ static const Property arm_cpu_pauth_qarma3_property =
 static Property arm_cpu_pauth_qarma5_property =
     DEFINE_PROP_BOOL("pauth-qarma5", ARMCPU, prop_pauth_qarma5, false);
 
+#ifndef CONFIG_USER_ONLY
+static void set_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t old, value, mask;
+    int lower = field->shift;
+    int length = field->length;
+    int index = field->index;
+
+    if (!visit_type_uint64(v, name, &value, errp)) {
+        return;
+    }
+
+    if (length < 64 && value > ((1 << length) - 1)) {
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
+                   name, value, length);
+        return;
+    }
+
+    if (field->arch_vals) {
+        /* this field has some enum values */
+        for (int i = 0; i < field->arch_vals_count; i++) {
+            if (value == field->arch_vals[i]) {
+                goto valid;
+            }
+        }
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) does not match any "
+                   "arch valid enum value", name, value);
+        return;
+    }
+
+valid:
+
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = value << lower;
+    old = idregs[index];
+    idregs[index] = old & ~mask;
+    idregs[index] |= value;
+    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
+}
+
+static void get_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t value, mask;
+    int lower = field->shift;
+    int length = field->length;
+    int index = field->index;
+
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = (idregs[index] & mask) >> lower;
+    visit_type_uint64(v, name, &value, errp);
+    trace_get_sysreg_prop(name, value);
+}
+
+static void add_idregs_properties(Object *obj, ARM64SysReg *reg)
+{
+    int nb_sysreg_props = 0;
+
+    for (int i = 0; i < reg->fields_count; i++) {
+        ARM64SysRegField *field = &reg->fields[i];
+
+        /* skip reserved fields */
+        if (g_str_equal(field->name, "RES0") ||
+            g_str_equal(field->name, "RES1") ||
+            g_str_equal(field->name, "RAZ")) {
+            continue;
+        }
+
+        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
+                                          field->name);
+        object_property_add(obj, prop_name, "uint64",
+                            get_sysreg_prop, set_sysreg_prop, NULL, field);
+        g_free(prop_name);
+        nb_sysreg_props++;
+    }
+
+    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
+}
+
+void aarch64_add_idregs_properties(Object *obj)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        add_idregs_properties(obj, &arm64_id_regs[i]);
+    }
+}
+#endif
+
 void aarch64_add_pauth_properties(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -810,7 +909,7 @@ void aarch64_host_initfn(Object *obj)
     aarch64_add_sve_properties(obj);
 
     /* generate SYSREG properties */
-    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
+    aarch64_add_idregs_properties(obj);
 
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
diff --git a/target/arm/internals.h b/target/arm/internals.h
index f6b4e173a5..7c76ffea7d 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1813,6 +1813,7 @@ void aarch64_max_tcg_initfn(Object *obj);
 void aarch64_add_pauth_properties(Object *obj);
 void aarch64_add_sve_properties(Object *obj);
 void aarch64_add_sme_properties(Object *obj);
+void aarch64_add_idregs_properties(Object *obj);
 void aarch64_aa32_a57_init(ARMCPU *cpu, bool aa64_enabled);
 void aarch64_host_initfn(Object *obj);
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 2f6c090e43..d5155a3706 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -416,106 +416,6 @@ bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
     return true;
 }
 
-static void set_sysreg_prop(Object *obj, Visitor *v,
-                            const char *name, void *opaque,
-                            Error **errp)
-{
-    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
-    ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t *idregs = cpu->isar.idregs;
-    uint64_t old, value, mask;
-    int lower = field->shift;
-    int length = field->length;
-    int index = field->index;
-
-    if (!visit_type_uint64(v, name, &value, errp)) {
-        return;
-    }
-
-    if (length < 64 && value > ((1 << length) - 1)) {
-        error_setg(errp,
-                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
-                   name, value, length);
-        return;
-    }
-
-    if (field->arch_vals) {
-        /* this field has some enum values */
-        for (int i = 0; i < field->arch_vals_count; i++) {
-            if (value == field->arch_vals[i]) {
-                goto valid;
-            }
-        }
-        error_setg(errp,
-                   "idreg %s set value (0x%lx) does not match any "
-                   "arch valid enum value", name, value);
-        return;
-    }
-
-valid:
-
-    mask = MAKE_64BIT_MASK(lower, length);
-    value = value << lower;
-    old = idregs[index];
-    idregs[index] = old & ~mask;
-    idregs[index] |= value;
-    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
-}
-
-static void get_sysreg_prop(Object *obj, Visitor *v,
-                            const char *name, void *opaque,
-                            Error **errp)
-{
-    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
-    ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t *idregs = cpu->isar.idregs;
-    uint64_t value, mask;
-    int lower = field->shift;
-    int length = field->length;
-    int index = field->index;
-
-    mask = MAKE_64BIT_MASK(lower, length);
-    value = (idregs[index] & mask) >> lower;
-    visit_type_uint64(v, name, &value, errp);
-    trace_get_sysreg_prop(name, value);
-}
-
-static void
-add_idreg_field_properties(Object *obj, ARM64SysReg *reg)
-{
-    int nb_sysreg_props = 0;
-
-    for (int i = 0; i < reg->fields_count; i++) {
-        ARM64SysRegField *field = &reg->fields[i];
-
-        /* skip reserved fields */
-        if (g_str_equal(field->name, "RES0") ||
-            g_str_equal(field->name, "RES1") ||
-            g_str_equal(field->name, "RAZ")) {
-            continue;
-        }
-
-        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
-                                          field->name);
-        object_property_add(obj, prop_name, "uint64",
-                            get_sysreg_prop, set_sysreg_prop, NULL, field);
-        g_free(prop_name);
-        nb_sysreg_props++;
-    }
-
-    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
-}
-
-void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
-{
-    Object *obj = OBJECT(cpu);
-
-    for (int i = 0; i < NUM_ID_IDX; i++) {
-        ARM64SysReg *sysregdesc = &regs[i];
-        add_idreg_field_properties(obj, sysregdesc);
-    }
-}
-
 static void
 kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index aafb3cd232..997120966f 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -163,16 +163,6 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
  */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
 
-typedef struct ARM64SysReg ARM64SysReg;
-/**
- * kvm_arm_expose_idreg_properties:
- * @cpu: The CPU object to generate the properties for
- * @reg: registers from the host
- *
- * analyze the writable mask and generate properties for writable fields
- */
-void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
-
 /**
  * kvm_arm_steal_time_finalize:
  * @cpu: ARMCPU for which to finalize kvm-steal-time
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 7696a8ed40..bbf2e5dfa2 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,10 +15,12 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
+kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
+
+# cpu64.c
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
-kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.52.0

