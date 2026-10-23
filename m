Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792732927;
	b=hVUlgL8cFWA31Yyleo3U9m+AZy2leAumM5yQVn3NxKVxO7OsqLJimLPX1Jb+BI7sKqqk
	 a4s92cteqcTNz23h6mzkx+7n7tODXjYu6qc3su5we73hvOfvRZT63/W58Q73ECJbg1n2R
	 I6410qG1Bjei+GvZHQQ3qNoeyAcNyJ6BSzb5zwFmvY+O/r64xv0cNR+er/OwSJxdxgcU+
	 hT5s1qgJZw//d7jqZJ6ZY18/1IgT3WEi/m1hwBIN6zP/+rowO8mlt9zDCRJ8UD2aJml7j
	 JRYoZNwnPoAC/tQj2ODMEZxfncbl9EdCcprK/H+e68DQAH3f082Ld9lAWtmM/Uhgcyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792732927;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5vc473LuvzH9UByDSBDHjw7Tmg59DDDp0A1iCafp2xc=;
	b=ndbz8wpcQAXH2d4vEEawuq8LDymBX39yPSpa5Lq7YE7T+y/7M7Mta5NwBFz9zWj1EGce
	 E2GlhZfRW6Edym9ezb/JYrdT/EvXtIzoVK9r9ATvLIywN6E0NGxIapvXJhxH9G0t2Gbnd
	 o5XyD3FSMig+2IRFULzfdgxzQ8HYM2mT7SWwd/HCEGBZNWhpzEa/0LvMgbAOI/qBpZzOH
	 4qBIVYRbyBPDG64wFrlZETDEZ2FyZwDFn1AwGgBys9QLINHOtwidV/jFW9s56pZ3d4qhJ
	 zyVxyNMr7welE7RhSs2t0/9XTlGvR/XHqmRq40UB3aPXXGGakCV2PCtG9Vuujw71N1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YV5o18Iz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.11
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F0606A323
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 05:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 455F0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YV5o18Iz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3Z5F/uDjJaIGoOdzpHnTn2kC28jLb6sgqWG0gi4Qf4Gx3NJ2M14IP4HfIhWgwPtE0xfKmuPWITSs3N6woPuM96bafRtLEncqC56dVrZh4RBWfTno3SbnV/UWHblpHysZZ4dwIw/glqgxzZPkAgrbm7RF9BhUlw0A6wGk4Aas8KD8nbcjc6ZPw24h2NYxs/0UA+W+mYW83loOTEqd7VDehHg0p/sh7tafjXAHDkCQ1rvuU8aB2+cYFqKTX2ACMm0/GgDNEYXBNyX6dwu0Vz2LyDIgB+XGL54Xmh0GVSChXPGErJL63EkM7+T126MDVZt0xqMGV2ZwQyXDP32Jlp9Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vc473LuvzH9UByDSBDHjw7Tmg59DDDp0A1iCafp2xc=;
 b=FVUqytApDZSqQUqCCza8QVSc2NqcprnG7uV7CdC2ahdwuLWm5TbB9b1st/g9wx8ezJG/C1hphiQyvD+yHY4MtbYvi0renfsDlmCsSbnwiF6oTDX4zlOyR7BAaqammLJL2+40lWM0RSNfSCVzfnA/D5LeD6NNJpNLEAivwod/S1A6i7HshGqkMeFCoaM3QJsKj58MowlJgZSKnoNX65gh4+mZdmBxgb0WNdYuoAtwA/96N99pHZDyQsJRjVPa/RH88TgITb3YLg/KCWerVv3+p6pvWhd1P6WiR2M3E9TTi45BPO+N0R+xGRNYnJR4SRjzRK6M8DdM3ocSnzf4LS35Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vc473LuvzH9UByDSBDHjw7Tmg59DDDp0A1iCafp2xc=;
 b=YV5o18IzK33gaGUQx2WFvN3AjO5k1GrZBAqoplPN5KueQrGFDPZ9lVCSaxDnXh0+Lhqz1bHd+zyq+ybBayYzdN709o1xEWtLrEwRafF8024ib8LFIwDjcTVs+7mpakxNJ88cjRuI3dLLbd3yTFhq8K3XiufxMHrMMUbW0ckY+iKm1yNBc5aKfHsKtt0pJyEp/3dzZfDtfPBJRvugzDZPoLCoxRqSoIZEOMi23DZoHImq6Tt2gTHGm+lJtl2BwEqT4dbovpK8O2yLzuCOWspAs7oXYJSQ8DIQUde+S5vn8F7cE5Y/P/jGZR6sXDCZqRUvIGp/0BJCWStLLSYEmerJRg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5201.namprd12.prod.outlook.com (2603:10b6:610:b8::21)
 by SAVPR12MB999168.namprd12.prod.outlook.com (2603:10b6:806:4e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 05:21:58 +0000
Received: from CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243]) by CH0PR12MB5201.namprd12.prod.outlook.com
 ([fe80::fa53:495c:c3d5:243%6]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 05:21:58 +0000
From: Deepak Gupta <deepagupta@nvidia.com>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	pbonzini@redhat.com,
	mchehab+huawei@kernel.org,
	jiaqiyan@google.com,
	oliver.upton@linux.dev
Subject: [PATCH v2 1/1] target/arm/kvm: handle KVM_EXIT_ARM_SEA and report BUS_MCEERR_AO
Date: Fri, 23 Oct 2026 05:21:48 +0000
Message-ID: <529fc7538b61d0d2ea9a984087ff1d616dd65624.1792728982.git.deepagupta@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1792728982.git.deepagupta@nvidia.com>
References: <cover.1792728982.git.deepagupta@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To CH0PR12MB5201.namprd12.prod.outlook.com
 (2603:10b6:610:b8::21)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5201:EE_|SAVPR12MB999168:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d14a8c8-e4ab-415e-ad8d-08df30c58f71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|261021123027099003|261022105027099003|261009223027099003|261022075727099003|56012099006|261021133027099003|11063799006|10067099003|18002099003|261021130227099003|6133799003|261021121427099003|261021135927099003|22082099003|261022113327099003|261022115727099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	bFp8OMyHrP6OqK/LwFOs/CC/kaW2qZepRSB4DcYknglMCLutP+15a+vPx7GU28YXL7sjg4yDS21yGm4D1NfMW0vFtGr4fKEwaxWAheIZewGomVkvZ3DhcifO723nvUY4uY0xE38gqLRLKtUFxrOXRaTj5zYTrs0/sFdLjV/NKxkjp01N2P/N88nLm3TDEb/jvhXOs3t9GF2k2FEzIpm4YgLBW8kjlE9l/QK+Na7++YIFD461j0nJFAC8JzgooyiBitaS7cysOLNakzGPKVYAp+drHE6BO5mGCuV07kuymyOLpPFzp7WLhmrlzQpx1Px0Lalwfwp/Z4nPIjFK/IeWN7jGRzFe+yl9i7mnL1AUuTHzYnR2Z3LOeMyBbWnN7bwDWHXao9bFwfeMdWuK62QRmNNql/tKqV6vFaRYD4Cq56Lq/C1iGAArkadKoN2Sah0UcirrDaACIgGtXRy4MmSvAWgbepgXiTwb/9B+EOzW1PemzusR3pPB+NWDIhyQL2RBvGUGcwjyizLaG4BRocbbHr+cRY/UrjoSvpkRKr/ZnFB06uij6BlQAdeFBTV4W7Wq8TjFzzB64qY1YYA1JSO/KXNI1cWVcdYnsII3IAEz9wsNo4ZPjDBlH3u+UdQGEOSG5KCR2iqeDcCCqN4zC6gflEd9Dyx/XC4j3UuRmHPTO1s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(261021123027099003)(261022105027099003)(261009223027099003)(261022075727099003)(56012099006)(261021133027099003)(11063799006)(10067099003)(18002099003)(261021130227099003)(6133799003)(261021121427099003)(261021135927099003)(22082099003)(261022113327099003)(261022115727099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TVl1XDdw2bZ+sLXZJh7o+cEe3F+RPf+GGNK4wBQvbJJsbBBL3sK4GN8KzdtQ?=
 =?us-ascii?Q?cCJ+GzWUZNxIWhCV5R2fqwUyRm2B1bUYiovxlQUEsyU/LxPfx8ajh87fzgec?=
 =?us-ascii?Q?ewu8siqb5i8BA7CSaYkwSvNxMs0lvi/Tr6VpO9t840V+uirJTxHWFdr2/7UA?=
 =?us-ascii?Q?hRb2Gwz8bsglDcuTKMxFD2fRVs+uFVe8UkM17uhEJhZCXEsDAGDqdX2KAVTe?=
 =?us-ascii?Q?E8IaM9dzDpBp44uLJW4qpIITKSr7W1CPESYCje1BKsk3mOIkjM8/DDO6tnl+?=
 =?us-ascii?Q?I9IVmXBd99ATmp3IaqpQclD/sQJuw7Q0GK/WInNUmaif4eCtyjL9wg/RJwdG?=
 =?us-ascii?Q?+IdQqMkyxYIEAI2Ukq50uns9quHX91Up8F5us/1IoQB5rPYgcWz9fqSEc0il?=
 =?us-ascii?Q?Pd2Ck68mjy8+ifxC7b0Q4Vzgi2tAvrrZgsjsgZDTY64XRfBXVLiXwFPgnTHu?=
 =?us-ascii?Q?HFzOfx8QcymNJQI+ZcP1U9wMMFyVhi2aHRSIWzgw/sF4spdPw+Vp5m5Rmv+I?=
 =?us-ascii?Q?j39RP/PtlfHoURWJgKFb9P/Go7DF8YuiM9Bp68jaAUbCU7TSedv8BnpYwWWF?=
 =?us-ascii?Q?o16cfMGzlgC8Z+iRI0YDwk1HmvXacMrTsBmBgrp01MsoLWCAa/kGRvejd91X?=
 =?us-ascii?Q?q75XDnK2Yf3EdRKd5J0uUQnqpLa4CBNLAhJLZ/Bov7piZJFBytyRyBatBB5j?=
 =?us-ascii?Q?bgD5g60uvBEYkF0Lx9r+ziNTeGMLg9m3FeI7EXfQLtaI1823joj+47DtUQyS?=
 =?us-ascii?Q?+fR8NS7reIuV5Yv+7zdEYtYcqr1ZiP25UjIW1SDLK8BRrxQNgpQvxQbGJtJ8?=
 =?us-ascii?Q?jT3ikhPCvFwqZ4wwlbiViEwkQdar5YecTYT9z/07vQitNJN7EUWlLFETjjV4?=
 =?us-ascii?Q?pJsiXd382e9pa+Zln4I5HllramSWkbmByPJ42xsQNGpdmTB341ShXYCAAmDq?=
 =?us-ascii?Q?4tFZPSRbFsNKMkxPjdV9zLBWKqAMSmh48ldlDWj8pXL/n9rb4IXkoLMdW1AO?=
 =?us-ascii?Q?CvKImwdzZ9ipEQPG99fiSmSiP/Uoq6KoRL/D4j9wQ3qGdBg8CB7fyI7Amllh?=
 =?us-ascii?Q?XLQ1NoetZtVC4CJ3rigwyDHmd/Fzyk044bAvucXUtsY/04tr0jCJE4EK4zsm?=
 =?us-ascii?Q?kXXw6289Juy1UnAprv8NB3T+fBM+QTMQZ7FPH3LpZ7rKWX4onH5puFPJi+9R?=
 =?us-ascii?Q?hFnB4IitYK1Hg8vjjJihW5zITWDjz1i3WOXcUDCG913Tz0jcRMrwvFA2Ht9E?=
 =?us-ascii?Q?MQQSPsdvsqxz3qBkSdJ86o/EXe1H+fytvjMteYJEUzVAG5F3qc8XZ7aHaSAA?=
 =?us-ascii?Q?YF8PoMGd2wby8Nn5fiouzkg41kICVPbfVszypcxRwQpmYmYOHjP2yYFc/XDT?=
 =?us-ascii?Q?Xwo4ErseyQ+IzvPQSISRMzHE4zQwW/dyEer1g1b0sGriiS15JXdMeBpp/7nk?=
 =?us-ascii?Q?UgF7aQW+wrxKOJdPug1MMuTIOy6Ck8AVN10Xri6ru5Q9SH0ktBzs1By2vuuh?=
 =?us-ascii?Q?pZ+Zp1r7oq8AqbKu6wB3pGnNyMLE8K0yuAjiMq3fPAUpZrtMTmJIcB9o0Q9l?=
 =?us-ascii?Q?zP31tFSumocGoAeB6j5EMcBemQ+H+jaDtSvTyON75XLM0K9mrx0Rpw3FJP4k?=
 =?us-ascii?Q?v+vDF7Bh1sD9Aofbd7xMYtF98p8BY3AYUzN9+7jiBgq/4uP9dYaMETEdlPZb?=
 =?us-ascii?Q?xz9CAoJmr9yT+ZKgLhd4LlodLM5Bzn6A6QNGR6D6PGo9tGWdETTCcok6lriG?=
 =?us-ascii?Q?DQHtekk2ag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d14a8c8-e4ab-415e-ad8d-08df30c58f71
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 05:21:58.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Af5ED1PcmnfLknEBEF57ZRz9GZ+KvAogX/EDB+VvwoAQgjuq26kordNK8yfUW/DyQ3+G428UzOASKaUgDS6n8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAVPR12MB999168

Linux 6.19 added KVM_CAP_ARM_SEA_TO_USER: a guest synchronous external
abort (SEA) that the host cannot attribute to a firmware-first (APEI)
error record is returned to userspace as KVM_EXIT_ARM_SEA instead of
being injected as a virtual SError. Linux guests treat that SError as
fatal, so on a host whose HEST has no SEA-notified GHES source every
guest-consumed memory error currently panics the guest.

Enable the capability when KVM offers it and handle the exit:

 - If the exit carries a guest physical address backed by guest RAM,
   mark the page for remapping on reset and record a memory error on
   the synchronous GHES source, as the BUS_MCEERR_AR SIGBUS path does.

 - Inject a synchronous external abort into the guest. KVM hands us
   ESR_EL2 sanitised to EC, IL, FnV, EA, CM, WnR, xFSC and SET, and
   FAR_EL2 when FnV is clear. Generalise kvm_inject_arm_sea() to take
   syndrome and FAR and pass them through, so the guest sees an
   instruction or data abort with the real fault status code and a
   valid FAR when the hardware provided one. The SIGBUS path keeps
   injecting the data abort with FnV set.

 - The exit may carry no address at all (FnV set, no HPFAR_EL2). The
   host's memory_failure() tells us the page later via BUS_MCEERR_AO,
   so far only acknowledged with a TODO: report it on the GED-notified
   GHES source so the guest offlines the page too. Machine types up to
   virt-10.1 have no such source; warn and drop the record there.
   Delivery is best effort: a record is also dropped, with a warning,
   while the guest has not acknowledged the previous one.

The exception is emulated with arm_cpu_do_interrupt() rather than via
KVM_SET_VCPU_EVENTS' ext_dabt_pending, which can only produce a data
abort with FAR taken from the last exit, while the exit may be an
instruction abort or have no valid FAR. The injection targets EL1, so
the capability is not enabled for VMs that expose EL2: a guest running
at EL2, or with HCR_EL2.TGE set, keeps KVM's SError until the injection
learns to target EL2. With ras=off the guest only gets the external
abort, still better than the SError. A host without the capability is
unaffected. A trace event records every exit.

Tested on an arm64 host whose HEST has only GSIV- and SDEI-notified
sources, injecting an uncorrectable memory error with EINJ into a page
mapped by a guest and consuming it from a guest process: without this
patch the guest panics with an SError; with it the process gets SIGBUS,
the guest marks the page hwpoison and stays up.

Link: https://lore.kernel.org/r/20251013185903.1372553-2-jiaqiyan@google.com
Signed-off-by: Deepak Gupta <deepagupta@nvidia.com>
---
v2: do not enable the cap for VMs that expose EL2 (enable moved to
    kvm_arch_init_vcpu()); "after 10.1" not "10.0" for the GED-notified
    GHES source; document best-effort BUS_MCEERR_AO delivery; clarify
    the kvm_inject_arm_sea() comment.

 target/arm/kvm.c        | 176 +++++++++++++++++++++++++++++++++++-----
 target/arm/trace-events |   1 +
 2 files changed, 158 insertions(+), 19 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3d905f8565..63d67511fb 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -38,6 +38,7 @@
 #include "hw/core/irq.h"
 #include "qapi/visitor.h"
 #include "qemu/log.h"
+#include "qemu/rcu.h"
 #include "hw/acpi/acpi.h"
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
@@ -52,6 +53,8 @@ static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
 
+static int kvm_arm_handle_sea(ARMCPU *cpu, struct kvm_run *run);
+
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
  * by asking the host kernel)
@@ -1599,6 +1602,10 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
             ret = EXCP_DEBUG;
         } /* otherwise return to guest */
         break;
+    case KVM_EXIT_ARM_SEA:
+        /* Guest SEA that the host could not claim through APEI */
+        ret = kvm_arm_handle_sea(cpu, run);
+        break;
     case KVM_EXIT_ARM_NISV:
         /* External DABT with no valid iss to decode */
         ret = kvm_arm_handle_dabt_nisv(cpu, run->arm_nisv.esr_iss,
@@ -2047,6 +2054,27 @@ int kvm_arch_init_vcpu(CPUState *cs)
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
 
+    /*
+     * Ask KVM to return a guest synchronous external abort that the host
+     * could not attribute to a firmware-first (APEI) error record as
+     * KVM_EXIT_ARM_SEA, instead of injecting an SError with an
+     * IMPLEMENTATION DEFINED syndrome into the guest. Linux guests treat
+     * that SError as fatal, so on a host whose HEST has no SEA-notified
+     * GHES source every guest-consumed memory error would otherwise be a
+     * guest kernel panic. See kvm_arm_handle_sea().
+     *
+     * Not when the VM exposes EL2: kvm_inject_arm_sea() delivers the abort
+     * to EL1, which is wrong for a guest running at EL2 or with HCR_EL2.TGE
+     * set. Such VMs keep KVM's SError until the injection learns to
+     * target EL2.
+     */
+    if (!cpu->has_el2 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_SEA_TO_USER)) {
+        if (kvm_vm_enable_cap(cs->kvm_state, KVM_CAP_ARM_SEA_TO_USER, 0)) {
+            warn_report_once("Failed to enable KVM_CAP_ARM_SEA_TO_USER cap");
+        }
+    }
+
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cpu);
     if (ret) {
@@ -2106,29 +2134,109 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
     return 0;
 }
 
-/* Callers must hold the iothread mutex lock */
-static void kvm_inject_arm_sea(CPUState *c)
+/*
+ * Inject a synchronous external abort into the guest, targeting EL1.
+ *
+ * @esr: the syndrome to present. Its EC selects an instruction or a data
+ *       abort; the EC variant is chosen here: the same-EL one when the
+ *       guest is already at the target EL, the lower-EL one otherwise.
+ *       IL and the ISS bits (FnV, EA, CM, WnR, xFSC, SET) are passed
+ *       through to the guest.
+ * @far: the faulting virtual address, only meaningful when ISS.FnV is 0.
+ *
+ * Callers must hold the BQL.
+ */
+static void kvm_inject_arm_sea(CPUState *c, uint32_t esr, uint64_t far)
 {
     ARMCPU *cpu = ARM_CPU(c);
     CPUARMState *env = &cpu->env;
-    uint32_t esr;
+    uint32_t ec = syn_get_ec(esr);
+    bool iabt = ec == EC_INSNABORT || ec == EC_INSNABORT_SAME_EL;
     bool same_el;
 
-    c->exception_index = EXCP_DATA_ABORT;
+    c->exception_index = iabt ? EXCP_PREFETCH_ABORT : EXCP_DATA_ABORT;
     env->exception.target_el = 1;
+    env->exception.vaddress = far;
 
-    /*
-     * Set the DFSC to synchronous external abort and set FnV to not valid,
-     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
-     */
     same_el = arm_current_el(env) == env->exception.target_el;
-    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
-
-    env->exception.syndrome = esr;
+    ec = (iabt ? EC_INSNABORT : EC_DATAABORT) + same_el;
+    env->exception.syndrome = syn_set_ec(esr, ec);
 
     arm_cpu_do_interrupt(c);
 }
 
+/*
+ * Handle KVM_EXIT_ARM_SEA: the guest took a synchronous external abort,
+ * typically by consuming a poisoned memory location, and the host kernel
+ * found no APEI error record to claim it with. Without
+ * KVM_CAP_ARM_SEA_TO_USER, KVM would inject a virtual SError here, which a
+ * Linux guest treats as fatal.
+ *
+ * Do what the BUS_MCEERR_AR SIGBUS path does: when the exit carries a guest
+ * physical address that is backed by guest RAM, remember the page so it is
+ * remapped on reset and record a memory error on the synchronous GHES
+ * source (if the machine has one, i.e. ras=on), so the guest's
+ * memory_failure() can isolate the page and kill only the affected task.
+ * Then inject a synchronous external abort that reflects the original one:
+ * the kernel hands us ESR_EL2 sanitised to EC, IL, FnV, EA, CM, WnR, xFSC
+ * and SET, which are exactly the fields that are meaningful at EL1, and the
+ * faulting virtual address when FnV is clear.
+ *
+ * kvm_arch_handle_exit() runs without the BQL; both the GHES update and
+ * arm_cpu_do_interrupt() need it.
+ */
+static int kvm_arm_handle_sea(ARMCPU *cpu, struct kvm_run *run)
+{
+    CPUState *cs = CPU(cpu);
+    uint64_t flags = run->arm_sea.flags;
+    uint64_t esr = run->arm_sea.esr;
+    uint64_t gva = run->arm_sea.gva;
+    hwaddr gpa = run->arm_sea.gpa;
+    ram_addr_t ram_addr = RAM_ADDR_INVALID;
+    AcpiGhesState *ags;
+
+    trace_kvm_arm_handle_sea(flags, esr, gva, gpa);
+
+    if (flags & KVM_EXIT_ARM_SEA_FLAG_GPA_VALID) {
+        MemoryRegion *mr;
+        hwaddr xlat, len = 1;
+
+        WITH_RCU_READ_LOCK_GUARD() {
+            mr = address_space_translate(&address_space_memory, gpa, &xlat,
+                                         &len, false, MEMTXATTRS_UNSPECIFIED);
+            if (memory_region_is_ram(mr)) {
+                ram_addr = memory_region_get_ram_addr(mr) + xlat;
+            }
+        }
+    }
+
+    bql_lock();
+    kvm_cpu_synchronize_state(cs);
+
+    ags = acpi_ghes_get_state();
+    if (ram_addr != RAM_ADDR_INVALID) {
+        kvm_hwpoison_page_add(ram_addr);
+        if (ags) {
+            Error *err = NULL;
+
+            if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC, gpa,
+                                         &err)) {
+                warn_reportf_err(err, "KVM_EXIT_ARM_SEA at GPA 0x%" HWADDR_PRIx
+                                 ": ", gpa);
+            }
+        } else {
+            warn_report_once("KVM_EXIT_ARM_SEA at GPA 0x%" HWADDR_PRIx
+                             " but the machine has no GHES (ras=off): the "
+                             "guest only gets an external abort", gpa);
+        }
+    }
+
+    kvm_inject_arm_sea(cs, esr, gva);
+    bql_unlock();
+
+    return 0;
+}
+
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
@@ -2525,19 +2633,49 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
-             * synchronize the state and inject an error.
-             *
-             * TODO: we currently don't tell the guest at all about
-             * BUS_MCEERR_AO. In that case we might either be being
-             * called synchronously from the vCPU thread, or a bit
-             * later from the main thread, so doing the injection of
-             * the error would be more complicated.
+             * synchronize the state and inject an error: a data abort
+             * with DFSC = synchronous external abort and FnV set, which
+             * tells the guest that FAR_ELx is UNKNOWN for this abort.
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
                 acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SYNC,
                                         paddr, &error_fatal);
-                kvm_inject_arm_sea(c);
+                kvm_inject_arm_sea(c, syn_data_abort_no_iss(0, 1, 0, 0, 0, 0,
+                                                            0x10), 0);
+                return;
+            }
+
+            /*
+             * BUS_MCEERR_AO: the host has retired a page of guest RAM that
+             * no vCPU was accessing at the time. We may be on a vCPU thread
+             * or on the main thread, in both cases under the BQL, so there
+             * is no vCPU to inject into. Instead record an action-optional
+             * memory error on the GED-notified GHES source, so the guest
+             * can offline the page as well. That source only exists with
+             * the HEST layout that reports its address to QEMU (virt
+             * machine versions after 10.1); with the older single-block
+             * layout the record would land in the synchronous source's
+             * block, unnoticed by the guest, and block the next
+             * synchronous record.
+             *
+             * Delivery is best effort: if the guest has not acknowledged
+             * the previous record on that source yet, this one is dropped
+             * with a warning rather than queued.
+             */
+            if (!ags->use_hest_addr) {
+                warn_report_once("BUS_MCEERR_AO at GPA 0x%" HWADDR_PRIx
+                                 ": this machine type has no GED-notified "
+                                 "GHES source, the guest is not told",
+                                 paddr);
+            } else {
+                Error *err = NULL;
+
+                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_QMP,
+                                             paddr, &err)) {
+                    warn_reportf_err(err, "BUS_MCEERR_AO at GPA 0x%"
+                                     HWADDR_PRIx ": ", paddr);
+                }
             }
             return;
         }
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..5c78d1255c 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_arm_handle_sea(uint64_t flags, uint64_t esr, uint64_t gva, uint64_t gpa) "KVM_EXIT_ARM_SEA flags 0x%"PRIx64" esr 0x%"PRIx64" gva 0x%"PRIx64" gpa 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

