Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2124.outbound.protection.outlook.com [40.107.243.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35502144D9
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729108704; cv=fail; b=CRzcc3p5M96aWLdMQFf2yt/w+zdy2WtH57l9pfQ+OOrDk4SqbjQMRbeOx4BrLk5cKRx+iRXkr7madpYLqc+ziqduuMaTFGY/mlU83SxciWmAbfi8XTHOU0mFoyB86MCjKhJuYLyJ7PC+zcPxfrj79vL7SQ7IcUI46hifRMySerU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729108704; c=relaxed/simple;
	bh=AGyqDZ8FM+ZR5fYr+ElNTTT+yhF2s7+/Bq9cje014dM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=uR73b241RF1XGEAfMJCo7vKjJvcG6SeWt/AQGQlhei/+rz9a8LyUTeAlC97Fghy9tpOSbGFXxXY1PewZKbLTlhi6HjxFyo24kinrToRiYPLRawpgKa11ad3cs7exylzS7f2iiLVGQDsCOopbU6nFBxtJHqjDu7CNY5kCte8EAfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=vwQXbj2A; arc=fail smtp.client-ip=40.107.243.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="vwQXbj2A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzVnRdKya+PBYyEBxqfNk4U9yU7AbKYHG6Ui3SVDlQATIvQN8JUFsQv72BzeFUwfho5qmj8LCCXsT2Idd7i1FYfO8yV7XoxqQRhyv8GpyO/0P9aiApYHkp/tn6RftccwpcRLVDJOXHJkHuC7tow3ednIVrK7Zn2mkw103XWxyKLNfFsQWZsW1cdfwkD8aNZpAqZ+J9HXgShPooOjh/xofgnb0t8D3IPcIzB62Y85aGHMCd2R1ztzpxDxwS/LGb3C9GzjbcPoIICVLoexPTNcy9N5Gj9D+m1Xj8aLMVN+JjZDc3NmMIR6rbKhZIPuEfFXCpD95RtZU10p0R4JkFCkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S41wHjcTCIAk1TLxhGlH6wA7VNHrMPT43qwSHHS9sr8=;
 b=Dt1f/5r41DBTA4VVMQB2EyZs7iB85BttpMcXuF5v88Gw1s28BdObrgExc/WakTE3W6+dY2+NkcPFchEcdOJ5aqU31h6jBlgm7lhij6mLMuG+X5YaZgF1rLZBBNgxXOh1hDOfLbsM26ICgFiQg1Sond/PvJpx175jbt5ZY8SMP/tis4nMQRd8diRjJAMgDP7A2nP5SBvlY0KQoF77mBhg2q36qwbA51zwReNcv98M8E0rdTBsaSo0VZ4A7TFFNDUcs0GuD55/ZT8lLtzzu1V1Z9jcYqnd+pvmaZevdpfbnG5aL3e/qhgBLWFp0WQn/Px9RfBkgnz49FbewFW2iVXtVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S41wHjcTCIAk1TLxhGlH6wA7VNHrMPT43qwSHHS9sr8=;
 b=vwQXbj2AxNAdYxey1/KMV0o+huzME83qM0pKiSXBUqV08upasP184eIMrGDHHNz8Th2npJYvkoM+KEcDTCeOZsreTfapaSB2BIFU/l8q1hfTB/KC/cfIXr79oxDiABEw5xb8e4DAYCHpQnxWjbrcNivbAgbmr0VVNcS7beFoEU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from MW4PR01MB6228.prod.exchangelabs.com (2603:10b6:303:76::7) by
 LV8PR01MB8551.prod.exchangelabs.com (2603:10b6:408:193::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.27; Wed, 16 Oct 2024 19:58:19 +0000
Received: from MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba]) by MW4PR01MB6228.prod.exchangelabs.com
 ([fe80::13ba:df5b:8558:8bba%7]) with mapi id 15.20.7982.033; Wed, 16 Oct 2024
 19:58:19 +0000
From: Ilkka Koskinen <ilkka@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>,
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
Subject: [PATCH] KVM: arm64: Fix shift-out-of-bounds bug
Date: Wed, 16 Oct 2024 12:57:55 -0700
Message-Id: <20241016195755.65011-1-ilkka@os.amperecomputing.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0413.namprd03.prod.outlook.com
 (2603:10b6:610:11b::11) To MW4PR01MB6228.prod.exchangelabs.com
 (2603:10b6:303:76::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6228:EE_|LV8PR01MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b9d30e-3ad5-49bb-f109-08dcee1ce197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|7416014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?svK/Gb5H6l/sR7wGSgXZeOW40wJsfPMm1PilPtk8Mutwxeyt1FOtoqsHb9VS?=
 =?us-ascii?Q?/M3/xH3g3KZM3DPCZFGFppA1QqFGSTo8jsQYTKh+vxVH9OtItMkW/CFD+6Sz?=
 =?us-ascii?Q?uJnGU/CC3yPsDz4BKAEh+sOa13UJG9lo2I6YyDG6OdyZl5CsWy0oZDO0b6zX?=
 =?us-ascii?Q?+ORnJB/eGqazB3Kagzl4X+xLWjw/WvqwpPPyJttCgp+U8Ew6UEgFAstW2yRg?=
 =?us-ascii?Q?PxdEqP/OzIaFNQOpYq6uwl5+j/7WQivdEub8vbfBrCQ5E2sGYR9wfmKrjlt0?=
 =?us-ascii?Q?O8tvGYa4xal8tE5F+uEiPKdvmBHjpunuS9TEn1TdgVMb/5q5x2CU6gMc6zCL?=
 =?us-ascii?Q?lmzXrseWf6QUipeXLH1LFeB/cR4PufgWa3mgfcseTDmIrpd9NMPwPUzwJmSq?=
 =?us-ascii?Q?U4hnVC/zeOsnXTPAHraQw/KqnavYjlTyV/wCFuGQpgiYmBPUNZdaEADkl/hY?=
 =?us-ascii?Q?zCaO3cl6V5Mzkl2ActAvhjfGwlE07e5iiuoMFjN7U3FpvTvTYgwUB3ZHsGCM?=
 =?us-ascii?Q?5lz0gvFA9EL8GRcitBE+UmVV3pf2Idm+V/uGG+tWA4hyLDC/PgB8xrcdLKc/?=
 =?us-ascii?Q?kUxSKQfHcDO5uy29ccSAumfJ3nXwXu2sAg373ZiN/SoqMW4Xm+agwLodIB5d?=
 =?us-ascii?Q?BYir2qBgGEgTBaM7BZgX4Owkt8WNOX2S5WGgTqu/6+OK9qhhIXf2EpXKiz0G?=
 =?us-ascii?Q?im1QYluFL7ih08CovzwA7yluMP24eJehWjhE3lMwkOjoi7ujVCJWHd7nJaUh?=
 =?us-ascii?Q?l3CNFOfuUP47MvtqHwlyD2YeRr5a+bNH6yfNMIX8TGWWZLFDINEHThH6PoJO?=
 =?us-ascii?Q?03BdQf0pZcUsmSKx0RzDzzQSoBL+sHDNf6tHhF0P9jQGp4J0lngoR/L0NWXP?=
 =?us-ascii?Q?uqiC8dNaL7twRRa6/QSDAoAaFWLZ6xn7T/M0tg+4ENJ6bWIEszatYJOcf2me?=
 =?us-ascii?Q?3IYfEZrAiA541qXr1gzEFYVxosuRyvWyZ+TfJkirflHhnFsTBiaMZm/QFpwa?=
 =?us-ascii?Q?eBHEMXhFNxxlwB9KMUuSNuIa6ad8sVVh4vndiAxCihhlvBsDMTONf0NoBXdU?=
 =?us-ascii?Q?vVcijXAOZuTwbESjaEXGZW+6VFQeoeSFyq4+7r26BastOtdKL/rGkTzc/0wk?=
 =?us-ascii?Q?6WmXo5fN3gHqFYd0oT4mslL/j/BTEz92bOZmmEWt34kEB3Gq9xjiE6XSjwKv?=
 =?us-ascii?Q?J1FMq7qeja3KWAv3LTn3BwKaNlT/xUsDCgurftU9mNNziT9Ov0iJZDWjccYR?=
 =?us-ascii?Q?eeHKGViFvaipc8Onn2AiNDpCZzGaelnyDkr1AXxcqOdQXUaH+gYkVrRNB94F?=
 =?us-ascii?Q?mztUT8u/DC3/OKnoWoxeM2Pm511zxNerTRHzxtTCeUVOhQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6228.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(7416014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iBoi9KrIVP+30P9CvLrTTqz+ypoCw+11+TZaHWYhrMLRb7VjKapCcuNZgvF+?=
 =?us-ascii?Q?xjB2+Jor/CY96lsV6VDebOfGDSWJO5Nd33/ahR2ub6yZPhjmP7diaChFH/jr?=
 =?us-ascii?Q?UKYp0eMedOIwQXH5u3CxETm7HxbW4NsDuvDP+r330lX4QUA4ZeUJ/1G9Rsxw?=
 =?us-ascii?Q?MqBSQ6phb2Y+S0dUxGy2Gm8nam6GPxkJlEiZlD2NSUKfaRHGOUwEjytAbUFY?=
 =?us-ascii?Q?ZhpLyWwmdOyDyX1HT3DIRu/q8zZxxcB+TxI0+LERuuDzmtSw8zAe8BbVzCEv?=
 =?us-ascii?Q?za2P2dQLd9eXE8MFYFsceOw22xs2QC8chI4/Z/6h5pb1AUx3OijbOFL1x1Vr?=
 =?us-ascii?Q?HFOqLqvndcM0EBLJrQ9q40dITd5ru6Pt89drL3QL7PzYC9FFI7tsa6Fr3mOf?=
 =?us-ascii?Q?ZvU92QRfrAk48Ba5e0BPCCQEuOww5PSxpooog1odxStRTDBcNd51rP/Q3Pvk?=
 =?us-ascii?Q?qpjN/IqwK4FDMreIJIU6wCoNhLCwSaZ2mvgz9s4sXd6+ADrx6kRZZWD2+vbd?=
 =?us-ascii?Q?UNXddnRZTNngW5BUmbTiDnOoQdeOGNk6ucGR9zPBgDuQZREQuw0WGg3wlbhz?=
 =?us-ascii?Q?3P2S9fVPCJQ0g9kxaz0ztpDaCv6edo5Kt4Qj3+3fvsAm3XKwnbNgNfp3mlaa?=
 =?us-ascii?Q?cg25pO4VCB444gT7toMM+sNFCDK5dpBBam6X4Go6kgixbljSOykwQx7CCVJw?=
 =?us-ascii?Q?IIHAJ48O7JK8oLPglDXaLL7szAkY/Xs25SiDiRi2hzXC30U1rOePRXLx1ZxW?=
 =?us-ascii?Q?sikozlPSoR3vAjRBIvOqPCv67e3fXShFptET98LFfU+l6UkhOiOLbbfRY/5h?=
 =?us-ascii?Q?5APO+p3UwjI9phDDdUeQNqMjGKLAcYR3yk/9FchDhPYD17Xg5y3XawftEgiC?=
 =?us-ascii?Q?0Dl8Dig/3pdFcbSnFqkDNqW5IfaBR/Eqm/ZmQvNOKd0THdtzxMak9mhUm2uq?=
 =?us-ascii?Q?LqcUtj+pdEvTyyh9B/jqhClvzyvK416pfgYX0znIO/P1HiRO68phU71CH56d?=
 =?us-ascii?Q?2/D/J0GGhqUNd7LvC3PCeJyvPcUtrvI5AB+6JITXo5Z2br8KIfwnKHqnTXjP?=
 =?us-ascii?Q?BBF5UqmT1rZ3bj1phGPVJ44Q0HPCIsEtJcu3bnAqbFa3Rn2bibr+XvXiy2pj?=
 =?us-ascii?Q?/hLLvb1crM9DC6QxjFBXWJNFsJTsrE2IPOqVcH/HhIZeg3H/9E45poog46qp?=
 =?us-ascii?Q?i020NE0YX3iaPmycx30GlX3dceibmJ7ZSZU95qCRj3oaSaTY4xg3EVB82jjb?=
 =?us-ascii?Q?RyUPDGPpeaS3ue6XsDp5Ped4B40sBlDbEhPRZl3/bNuKmRjtrHzqmFer8Z59?=
 =?us-ascii?Q?4KI0bMmLLItj4GyyuWPgS2LK6HxFIMcYH08XMRt5tR6Cv1l2kkAhyZkErdml?=
 =?us-ascii?Q?f+zx08t3pkFT6Cf+YU2itEQwMVX3zednRXd9u1aeDUxe0TqXKTx8ereZE2Aq?=
 =?us-ascii?Q?hpQZe4KHQ60b7qpfHnmJPm2uObz9JPXGtDlf0Lr9cl07d870i7WANvgYPx47?=
 =?us-ascii?Q?eamUwV/DK1lHecGMkWq0XAj2UbPx1NcsTZo5RmkIKtWOVz2rILewB76jc5eQ?=
 =?us-ascii?Q?X9o3P1oOLXD7ST03XZ7sYwRqdb1qiLwfXGFDjb1T8nkRTLa31hR9Zay470tV?=
 =?us-ascii?Q?NhyYntKMUG3PHaS61Cnvz7Y=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b9d30e-3ad5-49bb-f109-08dcee1ce197
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6228.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 19:58:19.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xkbpZurQ2jaxq0ArM53iME24JXbIwI4AN5e1bam+r8wL6zuIeFWqa1RPGKz4bOcqEKPYRXo2pw88V1yrY+OJtg9emDtwWziyqlKgpD62EHCnpF0YQqueXtDK9UIoaEed
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8551

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
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 375052d8cd22..665c576faba3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1994,7 +1994,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 * one cache line.
 	 */
 	if (kvm_has_mte(vcpu->kvm))
-		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
+		clidr |= 2UL << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
 
-- 
2.40.1

