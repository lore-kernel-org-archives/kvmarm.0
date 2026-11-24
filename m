Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554751;
	b=XV0M4VWYzzJVoBlRIdsSZzML8SC2/aMwggQ0Tw4ZAZxw0+QG3Kis0k5cNo5uu8qGKXQa
	 0WSHOXruMd9IFlqRaUf7uTWEpi+43ZdJyd3MTh2Q3njvwqXzYN0cGWbW1ncOJsFaswbtG
	 w5+SFpBoUpzre3xmcPGGeOpbv0Me13tZxJyNT3+1RpKqwsY1oJMQKSzfV3grQaqetoSua
	 BFKC9KAl1eHIs6GbPioRfBimY5Qde/ff3J3YqOWwdrdyiyIGeqlDMDRRJmSxzaQKoDeMp
	 BlZr0IPPTfDrRcftVV+90pG3AfqQKiZ8Bct4Eto7HDx4/5QCRP54WVHlhxTWfDpgDMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554751;
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
	bh=nPQxHVd8Hd9LuG2BowK9hjiuzm6n8cntZXe8OTIfcyM=;
	b=G7csYcb3/pFPrqRWXY54l8O4FyTjgHjJmydDAcg1phLboRwc7CHwo8y2bktSmu6CG4P5
	 yFiQYLtDZqfpYtWG4z807l6fC03FfPUMVJ6yiRBewB+HgTx6Bu3sT00bb1q2OjnnPwsn2
	 cI9MYn1zH+khQTj6X1WDy1tmswsHaJiymrYlO9MAEipe7mb9TQdQrqPXmCSreVJfPpsqq
	 dGulldYJnXA4CiCCIISDE6VfqH2Bdy+3rPNMzHug3tckoW/QJRcRaHoMSGwwim2CLvKxX
	 fokDXDzB4MaPef++0XSz3T0db9gAp6fTl3Ll0ddeF2mT+jpNszrVpmlfaqraPj4cGVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TftbQ80E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E34606A32D
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48E34606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TftbQ80E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ww87Potlw7TnIpBmMR1AW8uQkcVR32ejoiwFOcS9yh+QHK8sdJnAHn0GlnInFqYU0WOlaIdAhzJQigS43RguN10dUDnhNBIo7/VmhgmaWVW/kjMx256T5kFthPfvLiU6zcG21iMyxeSDl9j7n9vvMnKkIuOqPSnJxoKDE4eENXqxkvDO+He3DdpVeTf9wpIPy0Y1V1TgHGomzjbZJW8TbPU6YPrw5QbjF9Ew1mi00/VNZzQoGWRruTB+RvUU1SijR5ZyaQLmnFbpp46lPFoNeptg/sOHaNdPP5QEdUY4Eak7AVXTCluunK9KLnwpaYTFGQZohj/Du+YWe+R1YRB8LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPQxHVd8Hd9LuG2BowK9hjiuzm6n8cntZXe8OTIfcyM=;
 b=QrbTE0Goa9hQJC6fiZW8ZAfCveAqJlxRySphm5nJnn/qYiFazcUjOWfUyxUVxadcOHMqliTrcJx2py0hMPoXeefM4Yak/XYL9M8EasX2/3kYc/0o6w0Sy2l+YPlpauput64OtyM0qYJ+xOlPFpVwTO0eB0Z/WUD6X04AaaTzn1pdDkD5Iy4C43/PImoDJvJEksNxTMNb7Ld3RQAdLhBnA9Qh5OLx94Q52r6WwuY74eCl15hrp8VMni1J/jLM13xWWsIonIWdhbhzxO5vP2Nt+Y0gayVm6vh07VnldnvKUrBsaeDaJ5NZ70ROiQfKflljBNRqPUHotoE7GEIEvr21MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPQxHVd8Hd9LuG2BowK9hjiuzm6n8cntZXe8OTIfcyM=;
 b=TftbQ80ET6NFUrdSCrrwWc5rABOk4MwlP9M+vDx4ZWKtGoimrLx8GHXME5/8OAkJJyxBuELb1EkGdbdW81zrWDbtY9pzZt5pscbREqXXIpJvPstApmIfXXcOR2R4mTfVPx4KAu+HgmqS/VQxMlvynzOVlaqcmbqWhFPGf5RCpvlZrTlD3tMgBsiysqdHivp74VYjTXB7LPEGvxVxAIQU2TXhz3eoQAMjPtHae3JqAZa1aDIQDj+5ajEgWsU7mMsbwrhm6CT89HSdbQ5pP3+4XJpMDyjsZWgLdyl33x6xhOT3CzIdKgGSUMp/OUcrlKn4E0sOHEfX819C6oHs8qECcw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by LV9PR12MB9784.namprd12.prod.outlook.com (2603:10b6:408:2ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 21:12:29 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 21:12:28 +0000
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
Subject: [RFC PATCH 5/6] KVM: arm64: nv: Park grown MMUs on ALLE1 and reactivate them on demand
Date: Tue, 24 Nov 2026 13:12:17 -0800
Message-ID: <20261124211218.2751086-6-nathanc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124211218.2751086-1-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:303:16d::23) To DM4PR12MB5390.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7d665eff-5b7f-4098-3190-08df4a6fa56f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261028144727099003|10067099003|11063799006|56012099006|261021121427099003|261022105027099003|261026140227099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	S4br2rxnR3AEfudkRtHFYWOxfEly/beuALRG4qY1AoSupqEtuRgPWgBLmj+qtW+U+mCmxN3PtBR/asDRlGRPjPlpyrrn5NI1jEyDdHmQomxEVAEJFHPYcNB77GgXd5FgY15IoOrmlJgHE+axE2HEqfMWk2k4EzqbUptpHutaMGDkkoC0HQyA6055FXDcmhy3Lbnay0qKdyp7BtE4o1Pv/Nu7kiFho3cVo8/HytUgmv6TjyEsYbH9DSorl3GwuZMiawl5UVYmWkTp0pNakNRA25YCj6VQshxxZ9HXiWeonNeZBEAFMzggx855zV+ca1V3cyjjqp8b8nV8f4R8d3WhrVG1ur2XC2RhPBHDnajdD6mm6bWgdX66NfUPTU1aN9Wf7cI1kqdtvxQbHEDKrxnBkJ5VNK5SYnnM5SbRHaW6Szyc7dhQ8FFp6qVZJOYL1hIaaNdYihu9IeAT4ikQSHStaBRAoBD9l1Lfkv5nStCRdaN+p/HQtBO6P7as1gYHdwxCI6CcCZXBTGXt2VHFqXDAMmVBRoYB36EQ1hKmV6pSmY3dCybsVtZ0Q/WcfGVu2FoLQ8Z8b8pvdlzij7GrRPUX96aJWT/X9ssNjdfN0I9u+iggsvtrHR8wmL1xZs3+3hMC1kQFFNtYbt73WNpKCwU1SADBe72UL2/XvsHtfra4PRg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261028144727099003)(10067099003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261026140227099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N/11zJ8BBmZfsbyUre6pDqdEJQzUvLWtKCA/jLedx+YnkNt18B76LbiP6bwR?=
 =?us-ascii?Q?ivlLW7kgXTQPmA8KBlVzCGyFoNZ1Sd7Sctj9qcsFCe4KXyRC9YEaRDd2ai7C?=
 =?us-ascii?Q?oOewVjbDJ0mt4kUMYXPhgXL3udcPL9a5Ohwm8TGi9KuSduXFKsRLzJlNH+rE?=
 =?us-ascii?Q?WDtEHT5Z9GdBXXH+3gxJB7qKneVj8KryE79fEsewqMa6+uXNimRY/E3JPOEB?=
 =?us-ascii?Q?7HtzbQHaJl1CLFvxNnsrL8VL//9E471n8Oiibyq17mDNfPaUFu/+Y0YeYSt3?=
 =?us-ascii?Q?XAxznO1SS+Xn6+qPubLBCi157mX/rVzpQak87zQ3zKP5iAknY3Puuk/S2KUv?=
 =?us-ascii?Q?RJnki92L+sWGfpVOiuauYNQS9wpfkSkb83I5QM2PlJ1RAeUb3e+QesqFBnWj?=
 =?us-ascii?Q?V2D1QBso7DsHY1yQSdJnR2QrnZSthOMzf8Vcf+ADhlz05HUCZX4s8Zc6A0Ax?=
 =?us-ascii?Q?OPvb9o1dpmN9JotmR+d7xhYEkuA9cKFUA2d+3TcRVjNI8NSpvHHUuoYNnJrM?=
 =?us-ascii?Q?NyRyAQ0wJoesYJAg14Z7MnTO7zw7vAuCFrkcF3B7/b+0DirJ2ubqcRWbxHdM?=
 =?us-ascii?Q?oMnkZbgo1aHN4NFulG0LmdB5XU8iePfac5qPktumxdF53SXFlIOSRnowGbor?=
 =?us-ascii?Q?ygY2l50Od6EhnGAwkmUpZtlguqXSCWLBqiu+WP/PKXvXXPgaCrVgsCawR6su?=
 =?us-ascii?Q?3V0i/tl92/MNWDr/2odmmOfFQK9XXELrofnX0dml8Co2+CeB4FW1In1N00uJ?=
 =?us-ascii?Q?HDbFV83QkSv7eQNnoS6T5mY+IpMt2jAC5u2qjQw/2xuL0VHm3IRkkYu+9yzL?=
 =?us-ascii?Q?mazBrmqj237pJrlLSbDtLcTuRHl2zL+NMMGpjFtVdZy71jdoW6/Zh6Wa/WKr?=
 =?us-ascii?Q?VSBUaEqy81VEgZIilXTG8iKWOrXEGknv3qh3BwOe7Wi0Dm/RtY5mN1R7EtmV?=
 =?us-ascii?Q?lKxC2+UoScSo2xGZ/PGe08chPKSEaS6Em4PGXzAzbSAvgMa4dEoR0FTRi6iV?=
 =?us-ascii?Q?C9I4aZhIbLU+nIU1dV83o6XYXYs0KXwchzqwYWfSj94cIogQ/7S9CQ6YTQAR?=
 =?us-ascii?Q?iUZwxVsWOD0y77z8qeh579lKC878qijkFzNWxXezJH5d6SwsHu78YfgEfs9O?=
 =?us-ascii?Q?NkWiz6L2iGrXUrlWboYc1UliZTP2H30YgTJ3RbAT6F8lTPBlegOLd2EevBq5?=
 =?us-ascii?Q?qD6XD+joXzlknayyKubzDh4UBnqa/OyTHVl58ro6xts5/jvL39+4+9WQR0W6?=
 =?us-ascii?Q?GqE0ezrmJc91kiFO/MNwIJIxm9xp/S28KIH0oE9+myFjyecJtfsW0acbJ7d8?=
 =?us-ascii?Q?cp4dW+QVRx3HH7Sl7M3fos9Leq8Gq0OFW+QfGbGuGafc0/rwiYuNbo2tEDnO?=
 =?us-ascii?Q?J2FOiltJLVTu0yfkoIyggaio5i7g1yM9GCQw6zNFSE2U4L9AUDfNcXFBk0Rp?=
 =?us-ascii?Q?SiIjsGANlaCDYUSlcYguOo3bCubRpi7QxZNcTS9bI551jdhVSyrJU9gHJxsj?=
 =?us-ascii?Q?lufRDN35C2BUVaj66oqbwdSkxPCRRF/hA4bey3HK2wz7vYTNB/2sgJRnBjtg?=
 =?us-ascii?Q?g9F979NdASe2UKIzGvB4eqEy3/xwrUKPdP60X81bsS+YvI29lSqRRbvzyCcK?=
 =?us-ascii?Q?shzfr1OvlFvuSNL/xFcfhYMkt9q6ugo59Q8M1W48hC7Ta/Xx2tS9JUb+amK4?=
 =?us-ascii?Q?4KAPoRMMQO7xuKXt+6EtkoGeZJ3mMYs873AKNcU6fcJIAvYT3iB8LoKMhlGZ?=
 =?us-ascii?Q?GrNbnggWBA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d665eff-5b7f-4098-3190-08df4a6fa56f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:12:28.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XewKu2g4qj/pWFw6qLcTTgWJN31rbu67WQmxCXqNFYBygvC47/8a/3owSKMwByNQRseky5VynYqXUJZp93SYOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9784

Grown shadow S2 MMUs only return to the host budget when their VM is
destroyed, so a guest hypervisor that once ran many nested VMs keeps
holding the budget after they are gone.

Park the grown MMUs that are unreferenced and still empty after a guest
TLBI ALLE1, returning them to the budget. A later grow reactivates
parked MMUs before allocating new ones.

Signed-off-by: Nathan Chen <nathanc@nvidia.com>
---
 arch/arm64/include/asm/kvm_host.h   |  13 +++-
 arch/arm64/include/asm/kvm_nested.h |   1 +
 arch/arm64/kvm/nested.c             | 113 +++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c           |   1 +
 4 files changed, 118 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9307b86285a5..c0b9cd60dbe6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -329,6 +329,15 @@ struct kvm_s2_mmu {
 	/* Used since the victim search last went past it, under mmu_lock */
 	bool	accessed;
 
+	/*
+	 * Added by growing the pool, and returned to the host budget by
+	 * parking it (invalid and unmapped) once unused. A parked MMU is
+	 * never picked by the victim search until a grow reactivates it.
+	 * Both under mmu_lock.
+	 */
+	bool	grown;
+	bool	parked;
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
@@ -441,8 +450,10 @@ struct kvm_arch {
 	size_t nested_mmus_size;
 	size_t nested_mmus_capacity;
 	struct list_head nested_mmu_blocks;
-	/* Grown MMUs, counted in the host budget, under mmu_lock */
+	/* Grown MMUs not parked, counted in the host budget, under mmu_lock */
 	unsigned int nested_mmus_grown;
+	/* Parked MMUs, under mmu_lock */
+	unsigned int nested_mmus_parked;
 	int nested_mmus_next;
 	bool nested_mmus_grow;
 	bool nested_mmus_no_grow;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0f899addafa8..952853ab245a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -174,6 +174,7 @@ extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_unmap_cipa_range(struct kvm *kvm, gpa_t cipa,
 					size_t unmap_size, bool may_block);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
+extern void kvm_nested_s2_shrink(struct kvm *kvm);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d530a37716be..9251f3fd4840 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -96,6 +96,55 @@ struct nested_s2_mmu_block {
 	struct kvm_s2_mmu	mmus[];
 };
 
+static int s2_mmu_nonempty_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				  enum kvm_pgtable_walk_flags visit)
+{
+	return ctx->old ? -EEXIST : 0;
+}
+
+/* Only looks at the stage-2 root unless it finds an entry in use */
+static bool kvm_s2_mmu_empty(struct kvm_s2_mmu *mmu)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= s2_mmu_nonempty_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_PRE,
+	};
+
+	return !kvm_pgtable_walk(mmu->pgt, 0, kvm_phys_size(mmu), &walker);
+}
+
+/*
+ * Park @mmu if it is grown, unreferenced and empty, returning it to the
+ * budget. It is invalidated, so no lookup can hand it out, and skipped
+ * by the victim search. It keeps its slot, its struct and its stage-2
+ * root until the VM is destroyed, so walkers of the table that drop
+ * mmu_lock never see it go away. Parking always leaves S2_MMU_PER_VCPU
+ * unparked MMUs per vcpu, so the victim search always has a candidate.
+ */
+static bool kvm_nested_s2_park(struct kvm *kvm, struct kvm_s2_mmu *mmu)
+{
+	unsigned int keep = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (kvm->arch.nested_mmus_size - kvm->arch.nested_mmus_parked <= keep)
+		return false;
+
+	if (!mmu->grown || mmu->parked || atomic_read(&mmu->refcnt) ||
+	    !mmu->pgt || !kvm_s2_mmu_empty(mmu))
+		return false;
+
+	if (kvm_s2_mmu_valid(mmu))
+		kvm_init_nested_s2_mmu(mmu);
+	mmu->parked = true;
+	mmu->pending_unmap = false;
+
+	kvm->arch.nested_mmus_grown--;
+	kvm->arch.nested_mmus_parked++;
+	atomic_dec(&nested_s2_mmus_grown);
+	return true;
+}
+
 int kvm_init_nested(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->arch.nested_mmu_blocks);
@@ -167,6 +216,7 @@ static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr, bool grow)
 			goto out_free;
 
 		blk->mmus[i].s2_mmu_idx = size + i;
+		blk->mmus[i].grown = grow;
 	}
 
 	if (size + nr > cap) {
@@ -216,14 +266,15 @@ static int kvm_nested_add_s2_mmus(struct kvm *kvm, int nr, bool grow)
 /*
  * A vcpu had to recycle a shadow S2 MMU in concurrent use. The request
  * is per vcpu, but the pool belongs to the VM: grow it by one MMU per
- * vcpu, within the budget and S2_MMU_MAX_PER_VM. If the budget is used
- * up, the pool keeps recycling until another VM's destruction returns
+ * vcpu, within the budget and S2_MMU_MAX_PER_VM, reactivating parked
+ * MMUs before allocating new ones. If the budget is used up, the pool
+ * keeps recycling until parking or another VM's destruction returns
  * some. Stop growing for good if an allocation fails, so that a VM at
  * its memory limit doesn't retry on every recycle.
  */
 static void kvm_nested_s2_grow(struct kvm *kvm)
 {
-	int nr, add;
+	int nr, add = 0, reactivated = 0, first = -1;
 
 	guard(mutex)(&kvm->arch.config_lock);
 
@@ -238,15 +289,57 @@ static void kvm_nested_s2_grow(struct kvm *kvm)
 		return;
 	}
 
-	add = min_t(int, nr, S2_MMU_MAX_PER_VM - kvm->arch.nested_mmus_size);
+	scoped_guard(write_lock, &kvm->mmu_lock) {
+		for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
+			struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
+
+			if (reactivated == nr)
+				break;
+			if (!mmu->parked)
+				continue;
+
+			mmu->parked = false;
+			reactivated++;
+			if (first < 0)
+				first = i;
+		}
+
+		if (reactivated) {
+			kvm->arch.nested_mmus_grown += reactivated;
+			kvm->arch.nested_mmus_parked -= reactivated;
+			kvm->arch.nested_mmus_next = first;
+		}
+
+		add = min_t(int, nr - reactivated,
+			    S2_MMU_MAX_PER_VM - kvm->arch.nested_mmus_size);
+	}
+
 	if (add && kvm_nested_add_s2_mmus(kvm, add, true)) {
 		WRITE_ONCE(kvm->arch.nested_mmus_no_grow, true);
 		add = 0;
 	}
 	WRITE_ONCE(kvm->arch.nested_mmus_grow, false);
 
-	if (nr - add)
-		atomic_sub(nr - add, &nested_s2_mmus_grown);
+	if (nr - reactivated - add)
+		atomic_sub(nr - reactivated - add, &nested_s2_mmus_grown);
+}
+
+/*
+ * The guest hypervisor invalidated all of its stage-2 TLBs, and the
+ * caller has just unmapped every shadow S2 MMU. Any MMU of a torn down
+ * nested VM is now empty and unreferenced, but so may be those of live
+ * nested VMs that aren't running right now. Park every grown MMU that
+ * is unreferenced and still empty. Parking doesn't unmap or invalidate
+ * TLBs again, as every removal of its mappings was followed by a TLB
+ * invalidation. An MMU that was refilled since the caller's unmap is in
+ * use, and is left alone.
+ */
+void kvm_nested_s2_shrink(struct kvm *kvm)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
+		kvm_nested_s2_park(kvm, kvm->arch.nested_mmus[i]);
 }
 
 int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
@@ -976,7 +1069,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	 * one left behind by a torn down guest), is recycled straight
 	 * away. Other free MMUs lose their accessed bit and get a second
 	 * chance. If every free MMU was used since the last pass, they
-	 * are all in concurrent use and the pool is too small.
+	 * are all in concurrent use and the pool is too small. Parked
+	 * MMUs are skipped until a grow reactivates them.
 	 */
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
@@ -984,7 +1078,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 		struct kvm_s2_mmu *mmu;
 
 		mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
-		if (atomic_read(&mmu->refcnt))
+		if (atomic_read(&mmu->refcnt) || mmu->parked)
 			continue;
 
 		if (!kvm_s2_mmu_valid(mmu) || !mmu->accessed) {
@@ -1010,7 +1104,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 
 	/* Every free MMU is in concurrent use: the pool is too small */
 	if (in_use && !READ_ONCE(kvm->arch.nested_mmus_no_grow) &&
-	    kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM &&
+	    (kvm->arch.nested_mmus_size < S2_MMU_MAX_PER_VM ||
+	     kvm->arch.nested_mmus_parked) &&
 	    nested_s2_mmus_budget_left()) {
 		WRITE_ONCE(kvm->arch.nested_mmus_grow, true);
 		kvm_make_request(KVM_REQ_NESTED_S2_GROW, vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c7d91138a6d4..df81adf96259 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4047,6 +4047,7 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 * corresponding VMIDs.
 	 */
 	kvm_nested_s2_unmap(vcpu->kvm, true);
+	kvm_nested_s2_shrink(vcpu->kvm);
 
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-- 
2.43.0

