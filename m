Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011001.outbound.protection.outlook.com [40.107.74.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6F852F88
	for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752803445; cv=fail; b=mVKGGD6NTXMa3L4hiCs5mst0LI/asXpfA6WPczWPCXxx/mA/tQ89ZR/rEX0mTO1AW61FM5T70uYMR1pbzbm52WXLqPwn8pi0Q2gWDQuXewKkHEqzGuAOUxOTLJA3SjVbtElg3suNE/M4C6CvjBIixZUW9eCVsHzoxPjXrDGxg9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752803445; c=relaxed/simple;
	bh=HMHpNyC8t0xFHsa2gYG+VSveiB9aBT1NVIjrt0ylvjU=;
	h=Message-ID:To:From:Subject:Content-Type:Date:MIME-Version; b=ruRKhnHSn9dy4FRRRSvy09xN29UyqRiC2YKpK+cfh5OMZXg+9E35ZMKVRX6wBx0c+WWbxYMpzyAxPgAGr14OtG+jtQeZ3TiQB9eQX48Zjhkx2msLn/hJZsnRE355hsdlBkH57ht1FjqRA76ZJpMUvLpsoRq7rcz3PvqffbDRiaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=bonL7Qh+; arc=fail smtp.client-ip=40.107.74.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="bonL7Qh+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t5Sz4IstilbdHR+YoZXzBDZK+oQTstoTX28LVytH/bOLVexy93VeLK/5N6pR8YS0aLsdlKVLSE3BJxkMvo1uQKaP/bfT0546M2mef7/cg7PBB/9sN4L/R9YO/FhzHz/5gZD3zD3iSY2ONGyVakxCX+3CH0+FAj9+8Ny1GCDFWQP0/kUR4XYFQSOggIQ/2D5h0rXDD8iQ9b8g75RXwvNZL9bpiAsMkeW0MTAaJKYxlZK/XpzYQnbj5rND2fipTwQNwMLaXm2Y3uKyvDhvmafK3I1ya2yyl5wGbke0cW8HDU8KRzMGxP3DdqlvxV/mvIirsHE99DviOQ+II0SeacAvXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ee7eJcBav3b1/n/VzcVEBEbV4mETctuX9hjBZIXzAJI=;
 b=cQpagpwYFy/cng0PUQ5njhI9ggamCdLpGFypOHjKtYAqaleUW9cM+eX0VCvyCnCGq0M34vM3d/xjNEKIa/VpoCFRfhFkp3uQVdJ6XysHA0GkOsOHC11lchT/Ypde+YwyHINNbnMiDpHtHU4Y7IeET+PyzAMeFnvH1vEzPJcEZGItx65DvkbVHGw59ZWb6AUvMyFmAztKHV9FqO+XZwfmDGR9AFLHJqnaTP9AVI7tmi8EybGiM5aZNyOPi/yfePjik27jJ9TgNaVjJZknJjbsnfjhN02O25pJsYgGQNhbqPOD8fNkm5LsXK1GOowNS20WY/gfh13CN1c08lGbc+QJmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ee7eJcBav3b1/n/VzcVEBEbV4mETctuX9hjBZIXzAJI=;
 b=bonL7Qh+ljClejba76ANJH+zCw6jy3PX9J4eBBbd+cUQjN3OqU8ubJCZBbJE29df6LxZpU0qmoeLHwtjMwrkrvBdHg/97sZNj7+m18AkrWVVw9EFQwXLBIB8T9/lGpTk7W8AsFNX31avbvTOpreenNWFCpka5nEmo+52ywKB2F8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11) by TYRPR01MB12514.jpnprd01.prod.outlook.com
 (2603:1096:405:1aa::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Fri, 18 Jul
 2025 01:50:38 +0000
Received: from TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11]) by TYCPR01MB10914.jpnprd01.prod.outlook.com
 ([fe80::c568:1028:2fd1:6e11%5]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 01:50:38 +0000
Message-ID: <87o6ti5ksx.wl-kuninori.morimoto.gx@renesas.com>
To: rmk+kernel@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [resend][PATCH 2/2] arm64: kvm: trace_handle_exit: use string choices helper
Content-Type: text/plain; charset=US-ASCII
Date: Fri, 18 Jul 2025 01:50:38 +0000
X-ClientProxiedBy: TYAPR01CA0233.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::29) To TYCPR01MB10914.jpnprd01.prod.outlook.com
 (2603:1096:400:3a9::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB10914:EE_|TYRPR01MB12514:EE_
X-MS-Office365-Filtering-Correlation-Id: 8adbdbdf-274d-4603-8360-08ddc59d7ee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|7416014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?897QgRL/U4l0eyVVBZ1dYIH+IDzRrAjYE5VY8WKACh2tplcHxn9/z5/T2Wxl?=
 =?us-ascii?Q?YeLxJNBIm44f6r4bMIvBGvGGekchUAlSIjwNZYPha5iMFZKNlV2zv1kXoEuX?=
 =?us-ascii?Q?eWzqtgZnKSh8oDpe+Qjhtw7EWvAKqFbJuqSS3tOEPynTa1iqvjfscy0KM+EV?=
 =?us-ascii?Q?Luec2RXY/OS2J1kEgmLw9F8G1n58ll4b9lVXeBw2QIMEhmVE4MWDRbJz/Bqc?=
 =?us-ascii?Q?0R4KfiNGUpWU6fGQbHVyJM6U2yzDjBqlJZcJ9jm8qQ19BXISoLUlg/QFal/2?=
 =?us-ascii?Q?DibHlF38arHY/Un3diSnvJi3qw5OPwyfZ9/n32SYA2wuIHtABQnXdsC9amn6?=
 =?us-ascii?Q?66kc7+wvugA7IuMPLd9gH0PQBg7fxT4U1LqVl3ss/5PZIty8ZRUMex2Iw1CB?=
 =?us-ascii?Q?9jzCNaisUIyTjU7cYHBI+BVwfo9N+JmK+/p9POcYKCivt9nVgZNiW0ai0AsH?=
 =?us-ascii?Q?c5eajqR6H5ZUCEco4BhU6uddlnM0G1FBuLyaYNgxhH0EAZquo6nChHsICLiI?=
 =?us-ascii?Q?cHqU15waVMQ+dCZ/CR1orhHQZnN+0mD3bF+9OFHPdT6sKMZtRdrVYIXpwEF4?=
 =?us-ascii?Q?WKBqulMQRMXn30J1MOJ6L9L+TZ1vQDSCZ++NK1Kv6XP+PohVXNO36hs2PhJe?=
 =?us-ascii?Q?NitIHsVVpPRfy015OVSMwmom8D70VjzAx5rNcDAc+0S8KY4Olm1ATfyVf/Ch?=
 =?us-ascii?Q?X43KCVDc3iFMH8pC364Icu1qwDrBDrI30jPmHMwWPrjF5aevMNlaoJPxmg0U?=
 =?us-ascii?Q?A1rzuRftB2HlA2r/PIH1R0pVMXVflXiF0dW4L/0Sl4iOe72UH5a/yeizQ4kn?=
 =?us-ascii?Q?wq3OlqMwyb42cn3r8W/3PgWJhYcFXqo+BcqafinhveE9pz0+s8ENrHfuj//e?=
 =?us-ascii?Q?l4euTdQofDTJoTh9k1F5XXdGtV/4jmFjimj6rx8j+aJtn1kZ+hErSVBh71Qs?=
 =?us-ascii?Q?b0nZYwyDzShfUGDxS6OfoLsqaDBbopmNiZmifJBOH3fSZ4lLZflD5zE5Cy/b?=
 =?us-ascii?Q?uUff/oBmLGTVwR1D/pkjMhDAPucDQarf7nQIV4g2iS9XlNd5L7V3hFmWs8qE?=
 =?us-ascii?Q?sMrVx3EQXWJuyTDBZVETrbFqExoL6lMq9LHKItfbCXqIdITm7CnNo1DxNgH7?=
 =?us-ascii?Q?3u+D/Dx4mGkT8Lmz1D9IpGhGxRYkZJApN7/hauC0BLMY8XQ7ZPPV+Mx/Ojb+?=
 =?us-ascii?Q?Q9kInvvz9aiFEBgR6FKqkI6Ky+scOLIkQouEo8mo4bjJI3orxvifdT7iNn1B?=
 =?us-ascii?Q?wrqHEH+NFuFVvjiiZ1YsONR1VRUHAY0tZsLfkkBl/naheGLdpsLhEeGJf7JM?=
 =?us-ascii?Q?KWGExU41YQx4iPRBJg0jZx1IMT2YL5asuHGrKIos9djcH9CU7UoDKkg1bZSE?=
 =?us-ascii?Q?KqZIEVuBrVde/+cp8S52xRRa0Upj8Jhk6epMP0i3mhETHEQJE3JOw1m27ILP?=
 =?us-ascii?Q?hYOKIWeTGYQxCos9GYl/q6SbzohmBfpHry7BwNHKeG302X/Ov75UZOAieBzO?=
 =?us-ascii?Q?wcyUpwSspzjkOOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10914.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(7416014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UUKNFZrJz3aIXS/1R3tYVeNMaEd/atf42/q4rAJb+BVKHt1CCO0siM9DqSDV?=
 =?us-ascii?Q?VMBeZzq1SiP9elLUnXjdAFNCVbQlg9GfzwdAOKaYc4w/gvzT538OUZmxAGA0?=
 =?us-ascii?Q?cjK8PuxdYjWFvRci1nmh+bplMPBu6wgT5CBqXmuqmG1/dqtjQcM1SJaxmMxj?=
 =?us-ascii?Q?ci4uFFJa3OQhB1rH5PjwQNTPW6RodiXCvVX1HESe6TW3JLrIm0FUZU4tToaF?=
 =?us-ascii?Q?iDOM928FQQPF8WvfGwiaLe5LBY+W94WfDeNV45DNPEMxE71Bk9Pgfw8yWglq?=
 =?us-ascii?Q?vm565Q0LNf9D7e9qvPFzmVkgg+jMagVUTgB/Dj6jh9EXjfDA696d7nfm8Ws4?=
 =?us-ascii?Q?mpjmUqR1oJ3TEqJVgAs/0XNXYI2JH7+PtuG5rple0QnN5ALnrCHHZL3Q0U9+?=
 =?us-ascii?Q?2s70789xceb0Zk0/mNLT8JHV9pGfAurT2zGQx5Q1y0xxS1xNL2WtTbG1rFwt?=
 =?us-ascii?Q?NsXQCE5E+bESxqMAgySF/axw2O3UfiSRzHuWaQ1yXsvD5b9FdgCBB7wjvWNq?=
 =?us-ascii?Q?bZVkl6ketcJhFCRD4nQzvGrVFz1lZI6XvRqI7IWoESvB+ahO3LrResbhnc1F?=
 =?us-ascii?Q?i0KfzWw/xCySiaet44SLnsHNiM0GTMKtZ/+DQy0h0N9FqmWlAyhl6bTP2dSp?=
 =?us-ascii?Q?YEOtKskYNeAeXn0nXBnUgsV+kblcp0KfCVwxYpsFRcfFDKnG513AatDnZaxj?=
 =?us-ascii?Q?08Ulw87PP4o7Fgr37LhnsTqsbWwsE+N+qvi5ix/Mjdr8BeQjZ8c4i+DtPSJ8?=
 =?us-ascii?Q?cEOaeWM0vns2jDqEnBWZGf56vNlJqy9tvuhfoeBV/MLS2kFZa/XMMToOF4S5?=
 =?us-ascii?Q?3TjIUaMnoGquGCPoaWkAwE83hr0O7Haw3blGVjf9sQ609+UT1skvqtTLLYd/?=
 =?us-ascii?Q?wj1OlOYqkkOCpJjg5OK+7a9XFY8lHySSyJOXpQ85jeBlTUivbOZ6sle/ELmF?=
 =?us-ascii?Q?As+g6sJ+idBFLSsHAjsxf9gkqeCSngwqylJtnFHcVKyRw1sL1ScOmiJAt/A4?=
 =?us-ascii?Q?mivH92ypbN/oAaNqpz0wXPScPkYsgUxa6T94rH3l2v9yKs21GqN4VdChITcY?=
 =?us-ascii?Q?qwMM3nl171KEYqTsKjw93UsnS3gMXVR16pOsHVQx+T0IR8gtWd4cG38aU82F?=
 =?us-ascii?Q?o89+vLKEAIovgJlk4xUIbr/UkduwjZj2IQJCKt8/hSiRIbwKZbf8P67rFoyP?=
 =?us-ascii?Q?qiitxmaab9dV6MDPkfW6wjjuB+WkFszQZyHQBxvoDmUGsAWaSJ3AoHhQGrgx?=
 =?us-ascii?Q?erXMj25ZkQWDDC9iR/gy1IHuHlJSEYC+vDz+3y/pIIdtI6lEaqzKehQUyKe7?=
 =?us-ascii?Q?wtIEuNT+dP9PMii9vLm71SjUTFjfCWCqjuTLeJiCfnGN+GDU9GijJznCAC7m?=
 =?us-ascii?Q?SXf5cZ9R6tEO/5oi2S2dHj2rdBCiolDLtcaeyDPgja5TxIg+m70DWI1x10iE?=
 =?us-ascii?Q?cz5BZOjdXpI9kqDSKnf7w60tWMshpiCnLolSNEBLkpGdAUZhgw52uoqN6XXi?=
 =?us-ascii?Q?SO4XGc87toH9VygIR1OliHn9ko8xPbzXI/6a6MRYiFA0+ezcFeHifHKFpnHT?=
 =?us-ascii?Q?f+VlFez/fW6wjip7AONK9qWxsz91d7OKpGNiilxuDMkIMsx5CIOy1QOHDLB7?=
 =?us-ascii?Q?hnybiRBfvZjAMBLy/7Z4QXE=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adbdbdf-274d-4603-8360-08ddc59d7ee3
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 01:50:38.7074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FIasZbulHuF0IHUMSBALbEamhX3QfkuZSooorjSuhjl8izMn8YYG80NuyFpE+JUCtq31OqSI1PqlFYZ1cIeRzwg7y10D/RVKVbCQUGiv08shSZRu9wpGFTUqUUQ0n7J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB12514

We can use string choices helper, let's use it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 arch/arm64/kvm/trace_handle_exit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index f85415db7713..a7ab9a3bbed0 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -113,7 +113,7 @@ TRACE_EVENT(kvm_sys_access,
 		  __entry->vcpu_pc, __entry->name ?: "UNKN",
 		  __entry->Op0, __entry->Op1, __entry->CRn,
 		  __entry->CRm, __entry->Op2,
-		  __entry->is_write ? "write" : "read")
+		  str_write_read(__entry->is_write))
 );
 
 TRACE_EVENT(kvm_set_guest_debug,
-- 
2.43.0

