Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021121.outbound.protection.outlook.com [52.101.62.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BDA6F06D
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729133848; cv=fail; b=gmb/zjDEL9Hxi/RcEmal4oEPWvbOHqriWGUcPtifyku+QBQs8eqG2WXYUq6qtqawko2STqsnWwmn4u9Moqfz0/L5a9X6KSobACZ8yDtWz75zTwqAOLTiuhTRTOvztJ7kGNO+yZq1FzeH968m9/koYSA06sq1OCnPJaDcTrAkXu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729133848; c=relaxed/simple;
	bh=mtSF8rmNFbI7p4+Q/p0R7kco+E5i8ggvbNHXorBhpu0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fAmsdWcrzCF91/G6Bjvk5U8tPHU+b2gdr+xy4t6BTo78wRpPzj+xLv8nAqsvUhTzlGU3ZUfglfNZAkTn93YitT+D3U5nUfVM922PtvVRz55OSpPNCAkLH5DuiTvzDg36EGWChHbA3iXtXi3HRkxYM4CDJqfBLZXujEa/nMd47wI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=moZhRguV; arc=fail smtp.client-ip=52.101.62.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="moZhRguV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V6WDiyYbO/H5BOuX3JDhXhLH6ct62B06a5kNMcNYXS1hAtB8oGsRek3ZSJqG+5REoWX/+fLNfHdHT2JcmTR5N+0FPacbzqNtkTYYcPuE4EQfddeXAf7kjQyA9I9AocSP1qJsQOjwj0iKM5NBW+q8Wx13k6u9Y9XaH5Vk1FtQYwIlqaGfsFUPxdP9w7zP9gVD5a3SrnwGFg3zS8VnWTziXh1fnvQkup0mlDKIZiJwAVG/DH67iRnVuXwjxNfdMuZRk6vk6/f2+sM/n3zYUCu3gP7vMZalBAinsviLCwH1JobtmCKpK6MGaFxGm/iNAIxD0T7iJhNZ3pilAtFmHLlK/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwq/F+shr8mQwoX1UJ8uenpyoxkt6o+goCHTb6Sqp1E=;
 b=h0b9dKIoZK8fiMTJ3h1BU2QPFQrHuAW79hDAnaLZ0T1OsGSYpL7Xwe8/UMRQI+DKS/5Fen9CK1+nuYCIQSAe6igtb2+U2KkuprI7gxmXlh1TEk9pK2LmCO37BIMkibY0/YBDFGQ7PNkrU+f7EC5vaa/2Wja07fP5IQiiTxY9kBX14o5Og72sIW1oXfzCdINnDCo33rNuK+YK4MtdikHi1yww5icmZ//x9pb1YU3RawVWER9t/5TUaIcMKV+aurxXoo35juvAh9fOQE2t+txgWeWilpjLxBEOuQvZHNE+8aXsNbRAzOvG2yahyCeWQTV7ulFhWfegDZvAgi65dpWC/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwq/F+shr8mQwoX1UJ8uenpyoxkt6o+goCHTb6Sqp1E=;
 b=moZhRguV4L9gLZYJQOKoSvvANNwhuogZzwxNnjjOE8TtCyPPiaVOqgjzU8MpsOloTBWW1BzmOZtpdzaoVJzdbGs87dU1pelo/JAzfdF2mugs+zq8rroy392UVhLf2kA1/4eV3TkGUl5Ydo5dO7YNSnPW9mNq10Rq3lREEn6Xxa8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from MW4PR01MB6228.prod.exchangelabs.com (2603:10b6:303:76::7) by
 SJ2PR01MB8436.prod.exchangelabs.com (2603:10b6:a03:567::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.34; Thu, 17 Oct 2024 02:57:21 +0000
Received: from MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba]) by MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba%7]) with mapi id 15.20.7982.033; Thu, 17 Oct 2024
 02:57:20 +0000
From: Ilkka Koskinen <ilkka@os.amperecomputing.com>
To: Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>
Subject: [PATCH v2] KVM: arm64: Fix shift-out-of-bounds bug
Date: Wed, 16 Oct 2024 19:57:01 -0700
Message-Id: <20241017025701.67936-1-ilkka@os.amperecomputing.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::26) To MW4PR01MB6228.prod.exchangelabs.com
 (2603:10b6:303:76::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6228:EE_|SJ2PR01MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2017b9-3427-4146-79e3-08dcee576b27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0yrAa1CIAkY/DdLVetAKaY9JbzXoR3rz22EGmMJ2DpjquopO38ubCOyh27bg?=
 =?us-ascii?Q?8+0oYT6/Lf1tv1BqEPP4n45Yz6U6Inx5ZWPI6oH1gQFE0zLbJex60gtzRxVf?=
 =?us-ascii?Q?m+ZEpFSkD3CAzrC7DC5oKUCKM4npbENN9X55EyLKJ/d4KKs7m48leym0/F0z?=
 =?us-ascii?Q?eTdt+1xwBSZWQPHbUQ6y9bNELZJ60i11XWxaim8z9vK99HcoAgkPLyOlqYp9?=
 =?us-ascii?Q?ZwR1Gme8yJV8V0o9HAVKu6HhK0A3bMDDPyUnz+C5Y9xPDzEoXQOhNUKHJO4Z?=
 =?us-ascii?Q?SrYoNrbFZVdCQbBnfrzXmw+8KIDiP85TMMtZbaAXcHEzw7sxIodzAexb6Q/Y?=
 =?us-ascii?Q?DNcQTXzq42oyvJcc197uj6wJ7f8PWaQT6VKqMpsZJ1w1IcpKyygzkEKQys2W?=
 =?us-ascii?Q?ZwsE7kkkqbIvDzIx+yqIbcyGVEAFWlMarRjJrityqg/5eir21wFtvaCujQlt?=
 =?us-ascii?Q?G56JgqA/Y7rEe0B8Pd/uhh5wrlaBJvejyCCsO0laLh+PcUUdGZH4IPuksJhk?=
 =?us-ascii?Q?PDkHXTGQAZwDfMRofBdA8CvBK3vAlLqRygqEH0GNwqmlRzJcwFV/qsD2ETYm?=
 =?us-ascii?Q?OisYn8UNcJYH901sL+eV6a4RVg8We6ubqR6zqi08v+TNFW151NldAg+boDTo?=
 =?us-ascii?Q?E7d+cBHTK57tAr37twTuCL8Ll5ZuLjUjXZolpL/g1sKtWys5JLH05mTKTMed?=
 =?us-ascii?Q?S6kqUCrftkgAtaOFcpyUxR1pYptl6dUWkvNPVmOy2YnWd1Rnyl4rt76BYXos?=
 =?us-ascii?Q?keVSgDBgsOfYpZRza2XBHk7SJj6qIc5y64kzZcEVA0ybydGBbGwU4X34yKsw?=
 =?us-ascii?Q?hhOwl7vqQ2JbbzF8EyLpB3/K5sKA7mEo6w0zHMefn/963LoMQbJllPr5Gm9U?=
 =?us-ascii?Q?zY5OxEbIk6fzeC1e52pBRwhNWL8YvHOsDEOAOZcwecTgSKXlfBQxHuctnGda?=
 =?us-ascii?Q?zP+19sg9UbUicZ/gr5bDWyY32VmLcqAownDfBAEnZURpwOge7ltqBShBWKz4?=
 =?us-ascii?Q?aMhg2FnC0OiziavwoD25TWB1ZNnXXQIZfmOLw+xVGudM32iRNqQT57C+5tYU?=
 =?us-ascii?Q?qcrpZrv0WnZ6zs9e8skvSATldvW72Mgcu56oNbXlwmtgGUR28UpL/LMqM026?=
 =?us-ascii?Q?BQrCSZk6EHnqTe/lXUwmq5OBnIFewfSF5ou14t4VL784RtHXB3tnEEROcAl3?=
 =?us-ascii?Q?4jXxvQ/YpQDf/J0HgDWPvoPwCKnbg8k5+dwP/UGGoZ6m+vFUOzQ261ykkLA/?=
 =?us-ascii?Q?IRgGTzfajv1NN5E4fo6wgfszAT13rVJDhRXxiAuqfbj3EdZSsadTEjNsS7LX?=
 =?us-ascii?Q?bFSITCl6WRCyNaeILWuCfXmW7AiDukWl896oQIYpGX5L80/HtFNLbk0upyqk?=
 =?us-ascii?Q?vYM//QU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6228.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?03mk8NQQC7fAQQ59Jy5MRcS/OAGwepvpk+KeoHH2JT2jTr2FLQtDKnObdnt+?=
 =?us-ascii?Q?Yb9O1Lqv0OPu/2T9XZggIysa74iAd9z4gfZaf9mwwIpCxCKpM8HNvpcXKlw4?=
 =?us-ascii?Q?AGc1fkJXxb7IkLVst+9e/TBKeaGr6M53YJsNLc3d541lmlUq2uTwjzUjUFWv?=
 =?us-ascii?Q?2EvP8xb01m9I/2DXCIDBB/1VOknmgCjBHQJJ+QdDAEyuXhqsAW1k+M9I/CKr?=
 =?us-ascii?Q?BEwluDU1hGAr9nOIvLi1abMUWpInR4WnsC5mv88Qzb0ohEcWfwGDI3bEH8Q0?=
 =?us-ascii?Q?EGUg+s3ZBLxxBxXda6do7P74oRKPndfpILm8BcQ8SPLf99glKvsbp4ruUY3K?=
 =?us-ascii?Q?ES8th8LtJDJlW0LsfdS6A6wMsol+AjNqj6RTRIe0/hAgoizOeQwfhIdh5Wxa?=
 =?us-ascii?Q?aJyiRUeS0vK6/wim0fz22gnFi9N+yx9WzoubpiUGy6D4JCbOzUZljWvLXeuA?=
 =?us-ascii?Q?NnVAkZn/SEJNfdXhnuHSQmQ2Ovcms5NCga0hnXL02yzpegU2VwdScSA8ey3z?=
 =?us-ascii?Q?BNcpuxlO8UuPXO7SX8H3dQTdDLR2Dm/tBCLg9D5Z75MxIdHjnY2AhxYedE/H?=
 =?us-ascii?Q?s9/ol0/C8AMBa0dpZjhflUio92fUa2drEzOnHxpYK4Rc0VExYwDouvBahHVT?=
 =?us-ascii?Q?zI5dT1mmg56vE7msBkZuFHQMzp9E5EKfAEOdVp+CjEAiYtaQgfiQ3TNrx515?=
 =?us-ascii?Q?pSL6ohUd6L5qXqMtlKhBcAx8exD8GbUD+UtLBVB3FVNlLWyACbCt/UkLAKIX?=
 =?us-ascii?Q?T+RT44GOOOIWFcJ6q0TUshbPEhK1eKknuLvIQJ0FKyAOSH/J8EL0bVZNILVF?=
 =?us-ascii?Q?9VYxijmipWDzBUGC5h2pB1Gz6/rD0fLVvWc/brN+mjyk+jNEzlfpZ+P0MET0?=
 =?us-ascii?Q?BCcVhkt7IDKbvCB9AwNFnd+nd0inplVmYXZJlZwPipVlX/Bc0liXf2tvqyez?=
 =?us-ascii?Q?6eOUKLzvhJ5CagEjRkVB6jey6j1aAHTzFzsmQuWG3hR31Sdnmfh7774//0/c?=
 =?us-ascii?Q?CTb3qkECpCbXhGTgpxTar1SWXthdN/AEXmm5LOHUIkIHewP2POFfOxoEA/TB?=
 =?us-ascii?Q?nRdfdpwfIMxHyrOItkin49Qnf5xuyQTKT1lTgNYrTBftACLBwc86NnwPv3Ua?=
 =?us-ascii?Q?x60SK1zT2VqZmCfXKHVbSV+3WSAsU/AGaiGEQkHQj2z2F+7j7Jot+00ar95Y?=
 =?us-ascii?Q?OPLdQ4/6D370ofbLp2TPofHsXdjNEVXflsxttmH6e0zmnJfpUvV9oDzmUARn?=
 =?us-ascii?Q?CGMpieefcrNDQGOyK/A+1LFSZUgMAf+7mdRzQo/4kOOs1KQjdUUylRXcDILZ?=
 =?us-ascii?Q?0NjgZrJ5oVlJeqiMu36wr1dL5wg8C902TQOtQsoqEVHTreov2gR/g3gJO7rU?=
 =?us-ascii?Q?54YNb2ukEilzciE6hvqoU3l4nZR+WYr+lWkYiGlCRop0lhPT4mKBt82elrim?=
 =?us-ascii?Q?S40W+zIw7WbemevAOEqpCrEIGmCtpUX9BvnQcMLvlBC/GJxFRoquKtdXH38w?=
 =?us-ascii?Q?5s39EFkeYNIPL9zHYlzWx1drJz9xPqoWXFgAiB8LxT49fELu4tbXNyTDrm7B?=
 =?us-ascii?Q?LIEAMP0eD4MkyumqIP9QyL7GpHmyKeLouR9IID1kQNAjlsmYwu9g+jvNx3jM?=
 =?us-ascii?Q?XX0E2njDhZbh+LH7DZ08zZY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2017b9-3427-4146-79e3-08dcee576b27
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6228.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 02:57:20.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X7/mwsRwYSNaSikZw+JPQDVduU5UAbnTHf/NzPWJ0AlzU9wOLJbTCKUlIzzoQBaq75HAFe3j4K2tf4RSsyRVfAH4PwZAtb1vJmZhkQ3lsQXi5toGG+i9YCt+rM8qdxX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8436

Fix a shift-out-of-bounds bug reported by UBSAN when running
VM with MTE enabled host kernel.

UBSAN: shift-out-of-bounds in arch/arm64/kvm/sys_regs.c:1988:14
shift exponent 33 is too large for 32-bit type 'int'
CPU: 26 UID: 0 PID: 7629 Comm: qemu-kvm Not tainted 6.12.0-rc2 #34
Hardware name: IEI NF5280R7/Mitchell MB, BIOS 00.00. 2024-10-12 09:28:54 10/14/2024
Call trace:
 dump_backtrace+0xa0/0x128
 show_stack+0x20/0x38
 dump_stack_lvl+0x74/0x90
 dump_stack+0x18/0x28
 __ubsan_handle_shift_out_of_bounds+0xf8/0x1e0
 reset_clidr+0x10c/0x1c8
 kvm_reset_sys_regs+0x50/0x1c8
 kvm_reset_vcpu+0xec/0x2b0
 __kvm_vcpu_set_target+0x84/0x158
 kvm_vcpu_set_target+0x138/0x168
 kvm_arch_vcpu_ioctl_vcpu_init+0x40/0x2b0
 kvm_arch_vcpu_ioctl+0x28c/0x4b8
 kvm_vcpu_ioctl+0x4bc/0x7a8
 __arm64_sys_ioctl+0xb4/0x100
 invoke_syscall+0x70/0x100
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x3c/0x158
 el0t_64_sync_handler+0x120/0x130
 el0t_64_sync+0x194/0x198

Fixes: 7af0c2534f4c ("KVM: arm64: Normalize cache configuration")
Cc: stable@vger.kernel.org
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 375052d8cd22..ff8c4e1b847e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1994,7 +1994,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 * one cache line.
 	 */
 	if (kvm_has_mte(vcpu->kvm))
-		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
+		clidr |= 2ULL << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
 
-- 
2.40.1

