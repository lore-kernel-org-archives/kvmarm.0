Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554746;
	b=KwhyhS2+5xERwfejFkDqc6IVqOb33u1KxCTtpIAEZW1iAx4kjd2ZH0g2+LZBvLEtHqh/
	 S0f2YptohNyrQWvA6nDnsYkK7TEkB3ZroR9gk7nlBETBsp99Z/wyyZwu0nlbqSB6aMpIz
	 cxyz9hZn4TzUWoisAmfMykV5IrCNds2GGKONPH70vnmfr6uMgbHvjGzmeS9cU4XOBsv+E
	 rMnqmuPVyT8q77Sslnw8voH4JnIR6EorH53h/tZEDLkGG55I6c/B6oG3MqtDxRXPGD7rb
	 cV8sXnXuUfbFaES5qgpEkUjhWDyye/xuQQBUYSpCjY2jLnuTDGh34MCDR4Lhm3eTkVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554746;
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
	bh=KitYZdpkNdKXmUM6/HLExXMDYSDQIBBH5MGAvVJEnLY=;
	b=GfQaslWjbUvYkv0d/9EzeYDnOx31cpsMRfpUvt+cK739vhxVFLN+E82u72Xo2+45QJRP
	 P9qnClrw0E7rs8Z4tQBRogkpNhuip2gONInWOVm6vWjdTzEnXLYkIKcujVreFY7l8Ecfw
	 XEUFWGqug09yH7wjAUARTP03CIxyZCwhbAtYuymGuyYByPAJCl0wDR+lQfMw8mcxWPMlO
	 0r9g0MbILjsjXeSIJgvjr8G7zgQjP1Q8NOFgkYki2sAXyEfQGTknQ+ZBpTCjiQyxnlHj7
	 EUp1uuxLm9k8CB0Z1H5n1/2IPpI9kJKIla8fvqUwgim9ypaIruSR046Af92o3RaSEAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="H/DImiL7";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.38
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F47606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F47606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=H/DImiL7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5QS2DgPwH8goe/l7eUlMFt/LpYoWRC+PK51542IHOqJHbpjH93lwbKD5N754nfBmD+kWDgzyHn0D5pS6XFGdrbI6ECeJohOWjjccfMPPUWcGPhLEnB7uuVkMTJ5/cYnHJkSVxMl6MyDKzmxNquM/3c7Mi9nIf0fp3a9yqbE+EkJjCu5RhY2MJzTLbLGN+crYTrIHEuBML2xxHvyBUmXf0mJA+0p8f6TcPbxHcUz3isaxx7fL14iwPJWTLUFWizU6fTfqWujZPa8xmJfmh9p+6tWma0cDrkucyV9IIXJaaBsgHL+YsS3Wf9dAAYaZrz/9Us9G0oG2Dq7Xq/MyXqR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KitYZdpkNdKXmUM6/HLExXMDYSDQIBBH5MGAvVJEnLY=;
 b=W+2u59qEV1+KwS1gqfJgLO5PG3Rt6IWh2aR/FByCxDLjMaC8P2YMLpony+So4W31Zu9xjb01oo9g12nJ8dLX0X6ewpjI89dHUVloepUFEy2U6xNhtRBmRJ7JH33GvJ0UNN8StvtZIfC/B49uB/i5WpktpZ/EIOvNSiblZ0lLpNYhFu6WPvqqa78YsWd+gdvYMhCULZb88LvLBtEk6EfVf0CN49ieSejG5HrEtJFm1o+rQ8GfhAQWdS+euMonTLiS4PYP7q3zHA2hCysHz0MqUjiNZ0YyO5239JCOEz0SwZuZHyJokO2HoquGf8MA2B1D9Ts8YRQsCkVWMXWbWM8lPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KitYZdpkNdKXmUM6/HLExXMDYSDQIBBH5MGAvVJEnLY=;
 b=H/DImiL7UilWv5HV6zDE2Q/8M3BcmbBgwTUHfQU2c0KY/VnEjKsoDl9FHpACegamqG+szIyAWCCIgpXhCWOvKEJFjxnBdf1BzjYwn+Nc54LaZ2ZFM1wGF5QJtxJIb7qlfhVTMpRYnNe1lBwYGKsLLnAHWH9TO3Y+7nkTiypGXlLJEloRfe9QXg/ehei42RDG2pQNnCFDKyDMrOhP3XFXT1brRMXamEgKwgRxY1N2bio29oh3qm9cT/kKDudUOa58Wwz+tFn+9g/CYND4unXkF1VcSi/MNdoYX+Papf49qdzEXZUuTfHB5x/aP4dhbL0hYNQb+KlnhlS8LjPyXiNIeQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by LV9PR12MB9784.namprd12.prod.outlook.com (2603:10b6:408:2ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 21:12:22 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 21:12:21 +0000
From: Nathan Chen <nathanc@nvidia.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Tom Matthias <tmatthias@nvidia.com>,
	Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Julian Miller <julianmiller@nvidia.com>
Subject: [RFC PATCH 1/6] KVM: arm64: nv: Allocate shadow S2 MMUs in blocks
Date: Tue, 24 Nov 2026 13:12:13 -0800
Message-ID: <20261124211218.2751086-2-nathanc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124211218.2751086-1-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:303:16d::20) To DM4PR12MB5390.namprd12.prod.outlook.com
 (2603:10b6:5:389::15)
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
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:EE_|LV9PR12MB9784:EE_
X-MS-Office365-Filtering-Correlation-Id: cf215416-50c4-40f2-3403-08df4a6fa136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|11063799006|56012099006|261021121427099003|261022075727099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	VD8+lmkT5t1m+/n/qDGew2idPcUl/vzV+eaUCGUQ8AgwThbf781cPJpceukg8PaNJupPnY1sgxKys6pibNrWAVevPPwwGQLS0nhs95BNKUW+H0iNZ5UnXLoyazXBWqseEtaCZZWOaqKXCLnRIgEM1VJ6gjrAqs3v97+9bx6mnkwKLq2tsOKrUNTk3hHv9lQXztGBq+X1IQ3TlJ2Ps4hNiP2bByEsUJBAS4UfuYA+qzqIiAGB1mtvZxDSDSYh9Yuq9/2QwPg6R2FN4p8WdMnGBP4YHRjDwfCyXqyBJMco5xSH99TGThwIfQVgmQjrnlRH8kcCvpwZvmMnRSOaRglLnew3HTHTtWOCaxjdFSJZxkCZOAvwBr2UuSmIY6SV7D9VFG+Z5bbE3T9cQ2U9QTHgVneNx6HYVm7TkSHLz8Y/A/7RWuiCa1B9Z694GYczRoUyCpdvEagajoOM0aHkFP9S+mOVBTe5HXLZstvB8jJ4EibgMegAqoTB08eXvF8I4XlO6YPL3tss7Ribi2MW0l+hYnNGG3h7qgDSEwF5EEK47o6ps9cuw0vQPCqtGjY6fjiUfs/IRM6/UKns9ifkyuQkko7hRQW3pGt9WZKQrrAXgx9kZvXkpsk+r00rmc8lzBR/F6fWHppIP191DRPpultNyjKfZVuuc85H/ya1VNCLGvc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(261021121427099003)(261022075727099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DHYYlSwvmlOMqKwyIWvVMG2kamWtdVJLQTboyny9Yuf4+u2/Nc//ooXX0LQS?=
 =?us-ascii?Q?bDfLxUSPqaatxyjkOJdlznrw8ohKl88LHlSHsFYQeH7CWI77Jhu7OF8EwcFu?=
 =?us-ascii?Q?LbmoMIF0KGeR7mzqU500Um+XJF3ryxzU5jktN0sT5mxlYKpkE4TFC9yOMZSM?=
 =?us-ascii?Q?5agzczKo3mADPxvQ64AbpQAMii4sTQo0oJ5ooQBh3mFshe2Jto3t6URGqdTX?=
 =?us-ascii?Q?g7XSSzLHltF7O/TYYnd7LTwGM3KELA9vAlXzEtfiH49UHe8MfO/pNO/w0Z1h?=
 =?us-ascii?Q?qBIJ1Ba8ss88fkPmPll7B8UQbxgIa9+VekRkz1XZuWrV84SFrRstSSAKhAcC?=
 =?us-ascii?Q?gNhLo6OfOIMs7IGsE1YhkQ0bVGJGhVYE8BVT2euHxrrn8v4DRpNfdjrfkuWg?=
 =?us-ascii?Q?bxFr+IdElXvtNN0OED5DobCoT99a97YW7F4ja1LVTfFbXMIifoYtacdh2pro?=
 =?us-ascii?Q?J2GpCL10PBGgsDo4k7I99O/nCc1+0kOYWXdTWXXt22ZsZo44PCkBd5f8m029?=
 =?us-ascii?Q?eYlKPlqR68qw5amlDP5aVBpwi/oZnyjCPgaQgfa8T2XTsuhPJRItedaXDmN7?=
 =?us-ascii?Q?Sg7rpfhFz6wMZ5S5jdw9IeUbRq3geQK1z78RfuKXAQ4+TEraB84ofdB9nDtX?=
 =?us-ascii?Q?/msFV6atvkUhOj7esAZ8mvOcewmloqBWRc9iuQf7mYkYO9FED+2PhZ3MWOP9?=
 =?us-ascii?Q?0xOe3ZVskI5I+OcieSpFsR87oigo22jufyAAe41ej6lJabbcQ5EvRdgF7D3M?=
 =?us-ascii?Q?0lOe1EsBshTn0If/G3jp78tHgc+AMSUImz4eDWO9l8wkYxaGxEx2N7Z+afIG?=
 =?us-ascii?Q?BkaF6f4Ah3xdATx/VIhVifCNjPn0RkbjvXoKDKiguOumz8knlbsVkTxZjIQK?=
 =?us-ascii?Q?ymq/YLJfPIANkrb4618++uLVa9VeQvQmQxUh8O6WJkJzxym9OpO9kGDu5QRA?=
 =?us-ascii?Q?Lv86kZib6ZttVwchWVss/UFEVgooC6d1tbB8Jdjqti7fX2erFsZX6gSdC3F4?=
 =?us-ascii?Q?2fVXrjHVvAEnpsz2/ypIEH2C8QEbOOyqc5EnrxFCnd5kw5a8fxZn+hUIFJUJ?=
 =?us-ascii?Q?EyhhrDoozWHn5FDrkyTWsqdMPu4+ANu7zAvswEa1rRTORaurgPhnRLZFriCh?=
 =?us-ascii?Q?eHcNO3j6FOZyYjj1i+ey+40aUuF+sWLZjQbQHW0KW2Mvigs1mDKfv3Oxcsrv?=
 =?us-ascii?Q?hf7mJ0aGutunEJJisMwlIS3IOZiQJFhAMHz9oZ/cH7WOQxRej22H9WXamXYI?=
 =?us-ascii?Q?mOQMAnWjxqrIlClSjM6iqvRmOK4R4HCJtQm4UaeLlwkzZ37G3tJCWNHjNtmi?=
 =?us-ascii?Q?JUitFsgpfWv45A6tv+SGMun8GRzCBAInhcEZWCN1I4TYya2XGhkR86ps2JpJ?=
 =?us-ascii?Q?FBURXdshtiniRxMBQMP0D5a/oGAdnH2cLHL/ECuWFz3xNfR39SM9B6m8p2JB?=
 =?us-ascii?Q?r1Egy+L8dpeuWdJ52XvA78nsi8TJbeSTPSQpZEO3r7bBQqPK/4xsXDMGNmIq?=
 =?us-ascii?Q?kM8OE//pg1gYdmjdhtWkB/owamx51+25ep8tzccraaJx6psL/SgwXxAzBcRG?=
 =?us-ascii?Q?7fNvnMfQC+Zjw6i0zziRWplUppPM+tBAOUZsSoXf1v9g0lSmpE68Ovq2s9LZ?=
 =?us-ascii?Q?uk5BmsrQSBfgXJLt2IIQ5DkWW6f520ggjgS6Ds8fP0a1LvcR2/5EqGE1OdcU?=
 =?us-ascii?Q?adHSHzdBwbrM0wKtsuInHb2KfZU4G1Wbr7ctdNpWW0fXbLdPMAV/ezldFIZd?=
 =?us-ascii?Q?qxY8SYIRdg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf215416-50c4-40f2-3403-08df4a6fa136
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:12:21.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5XOAoZ9xs/TtVmHK/ogN6KePYIgwGF9J4+2fUH6JNYB7vNwiSFVFq8afkGGKpWd7Ex+JovFTngU5ZLKYGoWKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9784

Shadow S2 MMUs are allocated S2_MMU_PER_VCPU at a time at vcpu init,
and kvm_destroy_nested() frees them by walking the pointer table with
that stride, as it assumes every allocation has the same size.

Allocate them through a helper that adds a block of any size to the
pool, and track the blocks on a list that kvm_destroy_nested() frees,
so that the pool can later grow by blocks of a different size.

The ptdump files of the new MMUs are created once they are published
in the table, rather than before.

No functional change otherwise.

Signed-off-by: Nathan Chen <nathanc@nvidia.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 +-
 arch/arm64/kvm/nested.c           | 84 ++++++++++++++++++++-----------
 2 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb130..ff5073b13338 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -430,10 +430,12 @@ struct kvm_arch {
 
 	/*
 	 * Stage 2 paging state for VMs with nested S2 using a virtual
-	 * VMID.
+	 * VMID. The MMUs are allocated in blocks tracked on
+	 * nested_mmu_blocks.
 	 */
 	struct kvm_s2_mmu **nested_mmus;
 	size_t nested_mmus_size;
+	struct list_head nested_mmu_blocks;
 	int nested_mmus_next;
 
 	/*
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28..7d78efee5296 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -47,8 +47,14 @@ struct vncr_tlb {
 #define S2_MMU_PER_VCPU		2
 #define S2_MMU_PER_VM		(KVM_MAX_VCPUS * S2_MMU_PER_VCPU)
 
+struct nested_s2_mmu_block {
+	struct list_head	list;
+	struct kvm_s2_mmu	mmus[];
+};
+
 int kvm_init_nested(struct kvm *kvm)
 {
+	INIT_LIST_HEAD(&kvm->arch.nested_mmu_blocks);
 	kvm->arch.nested_mmus = kvmalloc_objs(struct kvm_s2_mmu *,
 					      S2_MMU_PER_VM,
 					      GFP_KERNEL_ACCOUNT);
@@ -61,8 +67,10 @@ int kvm_init_nested(struct kvm *kvm)
 
 void kvm_destroy_nested(struct kvm *kvm)
 {
-	for (int i = 0; i < kvm->arch.nested_mmus_size; i+= S2_MMU_PER_VCPU)
-		kvfree(kvm->arch.nested_mmus[i]);
+	struct nested_s2_mmu_block *blk, *tmp;
+
+	list_for_each_entry_safe(blk, tmp, &kvm->arch.nested_mmu_blocks, list)
+		kvfree(blk);
 
 	kvm->arch.nested_mmus_size = 0;
 	kvfree(kvm->arch.nested_mmus);
@@ -83,6 +91,49 @@ static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	return kvm_init_stage2_mmu(kvm, mmu, kvm_get_pa_bits(kvm));
 }
 
+/* Add a block of @nr shadow S2 MMUs to the pool */
+static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr)
+{
+	size_t size = kvm->arch.nested_mmus_size;
+	struct nested_s2_mmu_block *blk;
+	int i, ret = 0;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	blk = kvzalloc_flex(*blk, mmus, nr, GFP_KERNEL_ACCOUNT);
+	if (!blk)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		ret = init_nested_s2_mmu(kvm, &blk->mmus[i]);
+		if (ret)
+			goto out_free;
+
+		blk->mmus[i].s2_mmu_idx = size + i;
+	}
+
+	scoped_guard(write_lock, &kvm->mmu_lock) {
+		for (i = 0; i < nr; i++)
+			kvm->arch.nested_mmus[size + i] = &blk->mmus[i];
+
+		kvm->arch.nested_mmus_size = size + nr;
+	}
+
+	list_add(&blk->list, &kvm->arch.nested_mmu_blocks);
+
+	for (i = 0; i < nr; i++)
+		kvm_nested_s2_ptdump_create_debugfs(&blk->mmus[i], size + i);
+
+	return 0;
+
+out_free:
+	while (i--)
+		kvm_free_stage2_pgd(&blk->mmus[i]);
+
+	kvfree(blk);
+	return ret;
+}
+
 int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -104,40 +155,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
 
 	if (num_mmus > kvm->arch.nested_mmus_size) {
-		struct kvm_s2_mmu *tmp;
-		int i, ret = 0;
-
-		tmp = kvzalloc_objs(*tmp, S2_MMU_PER_VCPU, GFP_KERNEL_ACCOUNT);
-		if (!tmp)
-			ret = -ENOMEM;
-
-		for (i = 0; !ret && i < S2_MMU_PER_VCPU; i++) {
-			ret = init_nested_s2_mmu(kvm, &tmp[i]);
-			if (ret)
-				break;
-		}
+		int ret = kvm_nested_add_s2_mmus(kvm, S2_MMU_PER_VCPU);
 
 		if (ret) {
-			while (--i >= 0)
-				kvm_free_stage2_pgd(&tmp[i]);
-
-			kvfree(tmp);
 			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 			vcpu->arch.ctxt.vncr_array = NULL;
 			return ret;
 		}
-
-		for (i = 0; i < S2_MMU_PER_VCPU; i++)
-			kvm_nested_s2_ptdump_create_debugfs(&tmp[i], i + kvm->arch.nested_mmus_size);
-
-		guard(write_lock)(&kvm->mmu_lock);
-
-		for (i = 0; i < S2_MMU_PER_VCPU; i++) {
-			tmp[i].s2_mmu_idx = i + kvm->arch.nested_mmus_size;
-			kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] = &tmp[i];
-		}
-
-		kvm->arch.nested_mmus_size += S2_MMU_PER_VCPU;
 	}
 
 	return 0;
-- 
2.43.0

