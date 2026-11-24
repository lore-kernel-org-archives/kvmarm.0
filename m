Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554749;
	b=ceLNmyqyo8C/7ZS52hv4Riwjq575KkmJdGvIvNQmSNh/Qpcks9SjQ5GloM05w4RQ9ZNl
	 +XD9QPbEO/H0GHuzV2fdmu9EGloGCZGykuUQSsKaDuCj9kCMLYubSz5TLfvF6rHPmHOnS
	 NApSVvHBneMld3jB5mfaM8B3KTDCykwae+/hg0PjGKo1dbe4eL95d4EYY93rXhWuE6u45
	 aNnmSzDxINWssLbWS7horyhjUESvKo7DIMIyaNNGLwFDLbzjH7NKxjskDfRdg9Wxg53yF
	 Dtb/5jcU+quw2ud8RxIK3A6DFd0K89fIjw1cvUIz19O5S2yyJj+Z8VmhiN2o1MDBIpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554749;
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
	bh=fnds1nB0cIupqib3I+md1sT/0uWOulwds2MgFsk3VZM=;
	b=ZnGtwphugupG3uPi8eoPPYVfABvVtJGm/R713LnKJkR7op0vFi+ttvCDOOnD+GE6BZEr
	 vzi16VjJ19BqcybjJnBZ6bsT1z2cgzbAlC74VsYxolW+P/SA5SEeyWNBvTZMKUWmQAtzQ
	 iHwzUNx+sXE6tJyxqZK0nj/IJS6MF6CbqKbBmmRBlJxArEwZhQ6AGCUvtFAygmaI7OvWg
	 z3xavL9TeZoEOIe0bsxQPML5NVinJ2tnRuG3P+qBEcWwu4YfSyD4Wc4tX/ZpFO4mVS35C
	 4uAn6O6As7fiStcyGtCijyhbVsI7jbBzisv6TXZw3Yj0J7bVkePTdc7pDsY6EXC7b3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cpHEi8hI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.19
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47895606A33B
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 21:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47895606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cpHEi8hI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfoCu+aXa3CW5WzSOP4V/JZ8VkdYIJPb4q7+gqZIkNaAtqYe+uAyzD4eQv1FsJewdiiOMcIkQtgqxrTpmVJPjkHRRvthdYliHuS8Y8aNCN/nTeEFp8jqVrroqZODTEVDoWYbHO1LeJdwIMm9kp52wEc7gKV8GcigGhZHuZPSOk/cEWrQ3dUGUB9oZonj1uX/hTuL260X2869DcSYU8aUyKSR5Lp7wMFEZSNHCopbx3LskogxRiDN1OQKmRC8Dk3GcOcYqFnVmaCqy1hr3Iu69loqGIZwSLwpSOvXZDtWuJjY4e5CvFJ4ajRWeDuPCUpebNtp/ZlAjqQjAZdgshURyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnds1nB0cIupqib3I+md1sT/0uWOulwds2MgFsk3VZM=;
 b=uV2Oyr6YlFAYFZ0wgbK79KaVG6HDgkkVuTT1Zft9SEUhZMvH5vCDEZE4YViLUpjNf8W1ahqXCMKIMKK267c8CyQ9YErFigdL482949VXdBS7YjG8NSqqBMGEx1UbAkDs4BwXpV0zPI8RHUEI9ri0odisPm51RK1ou/h2WRbAh5R9lTs2A1r1kJ3pk0ETviQwe2MbiNi8E3d0zoXJZ1SbZ3P9QlNFd+rzwWnnsnESxC6FrIWYToYZ/8r6XjUlg7AVn3JpE0+7mpUJ7NiQIWevqN1E4iBIXCfVcwwmpYzlHjFLSS8w3tExKicScy+F2CWiCoMXz7OqmAbzBTFieoZQvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnds1nB0cIupqib3I+md1sT/0uWOulwds2MgFsk3VZM=;
 b=cpHEi8hI0iJjqa0iQbr0ggdJvD1GpTFBjwMsCMLZ4NIPNN+ZB0AwFRdLn3U6rrRH/zY4GqMvWRWvhlOGE0nh2VDuXFm5NFmvMjAAEgW731ByN9yseacu+0lxekxR80aSkT8uC9glFn73ikULdv5pG5ZESqc2eAXXscdrigPcJD8vfqbNCE1eatJ4azLms+ZGhnzE6J5wsuIVMWo3E594uD7r+qYYLM36VYgfLEirIQPGbYp5FM6BzOxibo/uywvt5hpYayB2ho2qXuQwaNKQncR3JsFC6zSqQ/PrJnO7/pfq4FLQ2hQOLd282to9RkOL6+7GgQqJCAAGUxi+4bp6Wg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15)
 by LV9PR12MB9784.namprd12.prod.outlook.com (2603:10b6:408:2ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 21:12:23 +0000
Received: from DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720]) by DM4PR12MB5390.namprd12.prod.outlook.com
 ([fe80::2815:c27e:a0a:2720%3]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 21:12:23 +0000
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
Subject: [RFC PATCH 2/6] KVM: arm64: nv: Pick the shadow S2 MMU to recycle with a clock
Date: Tue, 24 Nov 2026 13:12:14 -0800
Message-ID: <20261124211218.2751086-3-nathanc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124211218.2751086-1-nathanc@nvidia.com>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::21) To DM4PR12MB5390.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: e0637e69-c6f2-4e93-5d95-08df4a6fa231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261028144727099003|10067099003|11063799006|260925021311599003|260925021911599003|260925022911599003|56012099006|261021121427099003|261022105027099003|261026140227099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	J+mxGp76IsBB+/YMm6e+tPhjYJED80CaQ8tOKL6OJA7qR+T6LWXRveQ4UoZsamhR7DH0a73hOcr56/tlTH1Z1qI8LS/92plXiNlAqpDvSguebjxMrscG/aA0DLLKdQtf0zGAbqYtRdvKpS3TyGmOOd3cDbGsjVnlznT/KJbIQZ2KqE58J6F3GV98yzRifDKNacb7XAgADmHC90bGEgrUnV8dsHcPeZO4ViL4JltpEV/iFnA07+h2TTz4adBV7HiGyIrtm/vNoBiGzEcyZPEDraDUqIHA0jqBprlPSXWsv64Pi+5OzEBR/v/snWfsBKIThKEVQ+oTdo/0z4u9T9BSE3ZUx/S24J9Ns0rdTvIODFcni0DPCuym3IGG09aRaTOedkX9Jw+ATz7UTey6SD8fXzlNFhBz2f8po6vXpc3yKJkllfRTrW9GMuXhNGUA/FPSDwg3RTUvbLSqlpLFx6a/X6KECBqt1uYkI3ESjPx7JvVLqZsC1BZtqZlllsEbBJttdnv8iNBkiYUdm6rRaRltw2tGQlInh6p6XA0L+kcsOj8aGDSbBXlg0WKJNehZMxS8IcVkAf7Bte5db2uW9SKnClYuhszE2MOzylR3HjEfCgBRqbVtkzjGZsuwcPxhAM1uFjuGQvtn89MkL6Ptr1bg1R5rbLMXsO0hKn/Qbz3MltA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261028144727099003)(10067099003)(11063799006)(260925021311599003)(260925021911599003)(260925022911599003)(56012099006)(261021121427099003)(261022105027099003)(261026140227099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1SWNoST2ugwyfJWhgi6nyYoS0H3ujn1jj1ynH0AhTXhAZG1DlRL4xLFnLFDI?=
 =?us-ascii?Q?2BbkemAWch/KymDgiqHRECiUVeDouqMh/mImqHYPD8Prtt56yHEAP7XxJFq5?=
 =?us-ascii?Q?X7gKvn1X37+izSVMw5rnqDE8ZYx2Z/NtEgc0IP9k/+7Lqi/Px/Tpw1tq3XAB?=
 =?us-ascii?Q?m2XXMS841owQe/PuVut3bHjUDJX/ica/qQsaA/T19x+0u3ol/+9hE5S53KqI?=
 =?us-ascii?Q?+mrMQZ2W44cR8dtlgnUf12Ezm2S8VwNh0ZefzxSRBRxwoxze1xOSuxrE763I?=
 =?us-ascii?Q?x6MwNG/sdRqCjLGPtHuuCWJZKfMUuKYIwD+f+J577V0FYCMo9BG4CrYHx04Q?=
 =?us-ascii?Q?G9LA1mM5HL2X5GYSYzEFG9jYHoqmp4rtHKu8Zbo92GbM4H2UDI1qQydZ5a1j?=
 =?us-ascii?Q?5znQfPZHMba2XgQ+BIL8nSWQUGaYKBPHmnrZY3Ih0D03OUKpEuBkTt8FBJZL?=
 =?us-ascii?Q?cV6xfGLioD1R8NDRe7Nj7Nh9Bv2yVqL5lUBswzUDlYU88mdaARPFN8WS66Ii?=
 =?us-ascii?Q?kAF2QWF7TM6zO85AjKvcBGM1Ly5S0/cqVWRPabsuK7rUsOqaStV798XBrVul?=
 =?us-ascii?Q?iptctJmDX6mjqoD9UjWDIIuBmUx5i1jEQim3IDkNwfeVLnUhbxQON2vP+5nj?=
 =?us-ascii?Q?3FuT+wus4oGsM9ZUzIFIk3kg//8JKJrLEhvhrPrwulOCgKcKEG8fCya2sRR7?=
 =?us-ascii?Q?g4rmPP33Qg/Ze0S/TaOhODF8P2+yv+rHe4BW0Z0y3Q097QRIOyV3/ZvxCvQe?=
 =?us-ascii?Q?YxUMlIoBZEuTUEGF5TbYPQ2//mddE3j6gMKO7uN+GlD/z8CX6Y2ufKDHKd8p?=
 =?us-ascii?Q?YI2bDdO+bEzY1V4K39KoqO+bcy3ddtZODxbll0euVdbN6ej98LJtJqp/c8Qj?=
 =?us-ascii?Q?8EVgEAcllQycLEtRHe/OodoOJJyFXe38OBlfP4jlTtvGhGtH8spPsk8Ngcff?=
 =?us-ascii?Q?ZMJVixPpcNqF0jjjrKFOElK0Y43093JB64pQc9dHmRHsxvwcv85sNBt3wgJh?=
 =?us-ascii?Q?tUToiDmdowtlNhb9nvGqyUrolZstHw3xPGjELQyBQtZOrRJC9Kku4ts09lu6?=
 =?us-ascii?Q?zA3imYRH/sFUdOqDnVDk3c/aBlDtkYdX5z+CYH1waGKnkajI/Moi8pADeTZ3?=
 =?us-ascii?Q?Y0Kif7y4fRi0G2B+FHH7AhhQCvm1J4FhjH0Rq2rptqnB5EQ9mocNHaN+FtP3?=
 =?us-ascii?Q?Sv/qbQIQ76vD5EvQ9jTUu993OQQ3k7N1WVASE5A6gzV7AAnmhxfxE52xkVfR?=
 =?us-ascii?Q?Fc1K2vW17v+63uQ2PCPRB6AyTtdrL/F5iYAZh0lADW4q3Cz5CeRdNZBlt+du?=
 =?us-ascii?Q?KwtzqCsJgWCmHyWz97HJqpCPBpIKbZ2HJHrQuKgh9HuxZ249vuXRLlpz3pv0?=
 =?us-ascii?Q?5uZ+K6BvUKGy9sSl4OcyN0gng+QGAWIsxgUC3xNOfgzHt/l//gyALzGsO4Lm?=
 =?us-ascii?Q?AJ7rMD66jc5iB6XAp6kvtENS2VpqfJS+iEk1oSRtSwShR58p1E77qCzpZlsN?=
 =?us-ascii?Q?MuTkFxm1woMo7A1xWBRE2lWXqaVx5uJxlBPZhhqauTlurSboKITdY0WmdoK9?=
 =?us-ascii?Q?1FVW1li9LQSl20nbjV3V6iK6740oCc8nU8t8uEjtFlLVh3xIhYsbC4kjGf8x?=
 =?us-ascii?Q?GjSPhkAkiRQ9boCY6uPR28Y69MBdHmKhCDasuASzrmP0sZmO75mEmRQpNYS3?=
 =?us-ascii?Q?XeyhW+JZT1fHiX+F+M9ehfJaqlR1lWjOFGrlJla6AW7NI52LE1LbuuBadTFz?=
 =?us-ascii?Q?H2oRw5EiDg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0637e69-c6f2-4e93-5d95-08df4a6fa231
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:12:23.4618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFZhwJiOyv0nLR3E/NnZtZkX0ICBXaTQC9Zwun9Zo/H6XaaS8vDhvRbRpUw1cLaUi/GOSriLE80q0i+EAd+yqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9784

On a lookup miss, get_s2_mmu_nested() recycles the first free MMU after
the last one it picked. That MMU may hold the shadow stage-2 of a nested
VM that is still running and about to be loaded again, while the pool
has MMUs nobody has used in a long time, such as those of torn down
nested VMs. Recycling a live MMU throws away its shadow tables and
makes its nested VM fault them all back in.

Track use with an 'accessed' flag, set whenever a vcpu takes a reference
on the MMU, and pick the victim with a clock (second chance):

- A free MMU that is invalid, or wasn't used since the search last went
  past it, is recycled straight away.

- Other free MMUs have their flag cleared as the search goes past them.

- If every free MMU was used since the last pass, the first one found
  is recycled, as before.

Signed-off-by: Nathan Chen <nathanc@nvidia.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/nested.c           | 30 +++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ff5073b13338..c7133999296f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -325,6 +325,9 @@ struct kvm_s2_mmu {
 	/* Index in the S2 MMU array, only valid for a shadow S2 */
 	u16	s2_mmu_idx;
 
+	/* Used since the victim search last went past it, under mmu_lock */
+	bool	accessed;
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7d78efee5296..44dc6780fe6f 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -842,7 +842,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_mmu *s2_mmu;
-	int i;
+	int i, victim = -1;
 
 	lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
 
@@ -854,19 +854,38 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	 * Make sure we don't always search from the same point, or we
 	 * will always reuse a potentially active context, leaving
 	 * free contexts unused.
+	 *
+	 * Pick the victim with a clock: a free MMU that is invalid, or
+	 * hasn't been used since the search last went past it (such as
+	 * one left behind by a torn down guest), is recycled straight
+	 * away. Other free MMUs lose their accessed bit and get a second
+	 * chance. If every free MMU was used since the last pass, the
+	 * first one found is recycled.
 	 */
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
 	     i++) {
-		s2_mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+		struct kvm_s2_mmu *mmu;
+
+		mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+		if (atomic_read(&mmu->refcnt))
+			continue;
 
-		if (atomic_read(&s2_mmu->refcnt) == 0)
+		if (!kvm_s2_mmu_valid(mmu) || !mmu->accessed) {
+			victim = i;
 			break;
+		}
+
+		if (victim < 0)
+			victim = i;
+
+		mmu->accessed = false;
 	}
-	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
+	BUG_ON(victim < 0); /* We have struct MMUs to spare */
+	s2_mmu = kvm->arch.nested_mmus[victim % kvm->arch.nested_mmus_size];
 
 	/* Set the scene for the next search */
-	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
+	kvm->arch.nested_mmus_next = (victim + 1) % kvm->arch.nested_mmus_size;
 
 	/* Make sure we don't forget to do the laundry */
 	if (kvm_s2_mmu_valid(s2_mmu))
@@ -886,6 +905,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 
 out:
 	atomic_inc(&s2_mmu->refcnt);
+	s2_mmu->accessed = true;
 
 	/*
 	 * Set the vCPU request to perform an unmap, even if the pending unmap
-- 
2.43.0

