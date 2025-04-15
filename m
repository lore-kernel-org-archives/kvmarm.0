Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2119.outbound.protection.outlook.com [40.107.237.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E971F4622
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744732030; cv=fail; b=Skk8WEexuqBuI1arndzm6MUxuIJlrz24S5Ax+C+NMHcah4bpEElFI2fZyCVGJ5LVqAIwRvO4YRbGyfSpTZsQSt8lkaJrK1/WxFhnQx2Z65xXC3S23wKcVKbIzrwJLr0f555L97xm5nwyB4TaV4K4a+PHVndcwjbm8wqJ/aL6ERM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744732030; c=relaxed/simple;
	bh=7fnKiVJYPkkpKGT5o0cHuLHMf4mChZJKTn1KrIuga14=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pfPQD87YTDQBNglAB6y7b+NT5ByyPAveihB4aG9LGOdLydNXQGxQ6z1KNMeo/99F8ST5ecy3mehhxLuazphWTu6mwiSj3vRnyFbU6ixQORMBqDqxFUIXl2qHvnNnlcD25KDzIfEECgaZILJVggsZAIL9wg3l2Mfb92vNs9D5E30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=oq+FBJkd; arc=fail smtp.client-ip=40.107.237.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="oq+FBJkd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NsqZifO6+tJRjDW1K/wBeE6pp1wMJWtJQGmQjpLXhBWV2gYXoHC0Hsi7LUsO/91SG1+kVE5izhj6N3lfLBASsElNVpMRE3IeSPsV7eYFcPxrSjojcBk39L7Yk3soGan0ssHfmiXhXmZ4xoBtdQF/PIysXHGXkSOU1OYdPsJlsaV3z9KP69yKZj7qdA2aPP+uynJ+YhGmLHWpJJDHrNhoFpEw+qwrRMn83NFO0m+mZR+/kGwRtDIVAHDgFWZjkf/YRgJJM4EuNp9ttEjiJaUVzxbO8LtVLOj+l1XdSmzNpUebObsRMdtOz3tLzv7mhVANCIsQ/TjJ6efp6kQP62KmsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+rmAVxdnox/DDoFjtFbW1zT8e4hPhS5Q7ZU8ubJ6Tc=;
 b=YnY1S4BLR8tmnlJ7+dhFUDmZw1Lt5uglg5/bH+krH2vROTcpyfVGrOkXAntHOnCYpWFTichiJU1vVg7PhNEA4A9l9a9rCrzdGbOusduBK87guZsgCdxKDTuInlfOn6df47nzsb/MleVjvZl326Z9R4EDpRVVT4SJfWOj+xcFS3430sDHqcs6doez58prSguG72WueWjVI7zZ3ER1pGry3xQRO5uXgcMtkGLi1KjP5YgcKpNfVjAW9BgMKePkNjyk6zkIjMevoaT7y7DS2l62sbbcMHR757INpnR7CGhJvUtnbrs+fN06gS8JMPIE1WTm/ZRC0ikjpqZGn1F0RYLcgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+rmAVxdnox/DDoFjtFbW1zT8e4hPhS5Q7ZU8ubJ6Tc=;
 b=oq+FBJkdxDFlrSu7tjrBQ3ZDREDMa/DlV3qOxhwlPKWG4qsgU5fXtslru684mMmXZPr6A9DuPb3Hop5y8Jzn5kH7kiS7njslftnvvuV7xr+yBhMTfW6v1wqxICRVnQfj3sCJv5D9ZIrop64wuywpl9SyLyYbBBc1KrQLwTPY/7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.35; Tue, 15 Apr 2025 15:47:04 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 15:47:04 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: Avoid blocking irqs when tlb flushing/ATing with HCR.TGE=0
Date: Tue, 15 Apr 2025 08:46:56 -0700
Message-ID: <20250415154656.1698522-2-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415154656.1698522-1-scott@os.amperecomputing.com>
References: <20250415154656.1698522-1-scott@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:610:53::39) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|BL3PR01MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f510695-38f8-4fe0-b21c-08dd7c34c502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|52116014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mcp+U42Xa1VvYSEsX6xh8GJAg5CT/cOxeVNuTkS36kX5yqP098NYqzkvGcmJ?=
 =?us-ascii?Q?zQkw1ViIK2xoago1D6TcHatyjhgCiyEpy2dfgA6nkhmX2lpVfbAKRSvNpIqk?=
 =?us-ascii?Q?6A16pKY6BStB1oZIRMPxiMURYqetcyss6fcnnJ+XNDwpv36LeZTj/lykaEI6?=
 =?us-ascii?Q?OUJBCvSVmmYAtb4RwOOa2mG4aYhYnb7WIv9NhqyDMV2ETpjwlyqi/+y0fv7N?=
 =?us-ascii?Q?qZ6EWlWf6Sxgc2N3b8eM2mTdUdP+VjlXWXsHb1c4HA/6wAkQfGQwND8LzAfB?=
 =?us-ascii?Q?pGgI0GLqGvFbz0+bRFliF/kxcJvXAA+yfzoWUdB32HhciZ0Rl6SZp8OWb8sb?=
 =?us-ascii?Q?GzOuLiHKOWsJICM+EXsejWSVkxacH1z9Jue64/ZQ57zUvXcQSNTaIYNLP4FG?=
 =?us-ascii?Q?vhM2Qdk/qhFkCI2yCRCHJAzQlDfY8uLxU/G007V0ytVjwpHeelx6fMpREwqt?=
 =?us-ascii?Q?X0nvhGuu5FVam4JuLeyrgZuELX9cIc7YML3Y8O/nl926M93Rk8p9BmhR8QRZ?=
 =?us-ascii?Q?S331N4Ny1257ix5OOUZfk3zuR+QtGix1NXJpdcjhzSQ15TbcLbGxZseY5zAb?=
 =?us-ascii?Q?5KVwQOMJ2WWcEcfknsgFWVdPct+yChu960EHKARo4YdOkRwbTOnjwSShui8r?=
 =?us-ascii?Q?S4CFJQUioutZRW1G3AQnn0GDjayUQpiIS7C7LtRkBObk15y5Zr4jYOmLQWIj?=
 =?us-ascii?Q?TTKwu/7O5FbGjvCHvrH7CMKbc30YNi95Go4kxNGiKIjRD99pcRSffIBgjk7O?=
 =?us-ascii?Q?mm4ChHQ1IjosuGXeMkgPuyLBcidsHg5veiEnFEvKjDo6wq3WMEGz6WIZ2rA5?=
 =?us-ascii?Q?HFZ7EbDryiE4x9pf+iYT2zqszacREvTVd1qeiCaq9HuEn0UTZyuIoFS3ZdH3?=
 =?us-ascii?Q?51sISan/Lhm/bunq6wjy8uua792K46fA3JB6t7xaP98Q+VF7ugPe+87GpRgC?=
 =?us-ascii?Q?+8Afo5rbJ1LOTWN6qeFzXRwOtx7uQPXFmHmyFRx9qNAOA7uBcaznDqPz6dI3?=
 =?us-ascii?Q?QC/mfP9kZe3s90nuBOoj41/z/Z1S8WOfs6E2WBU1ExXXw8ZpO4K3lXNTScpj?=
 =?us-ascii?Q?iOtpwKK6OWdBvWqV4k1K3vPCkV/4l+4Ls+IB4VJscoMbbmgtcIJ9cQhmkXgI?=
 =?us-ascii?Q?Dt8CKXKcrXHY9X23/DLyuL7FR1SJ6DxyayIgeH3jvbTW4jMvABhIz1St0dje?=
 =?us-ascii?Q?6RsKQm4yu49SZyv41YwxHm0Wx5EEdBvVn30mDbnonkTZQkmAXgv/ZgBBtE1Q?=
 =?us-ascii?Q?M9f9K2BUjxc2tzGUofDOikxQAbOK65nuZ5w/UDJA9HQElzJOIZaFgex+idYJ?=
 =?us-ascii?Q?WFUJOVHjIzdg4AVzNw4GCDsYqrdBJppCra36rNAeJ4mq+/wfPn9aSXhsN/27?=
 =?us-ascii?Q?p9He4LTo7IfxNTvjkaH9JhjIzNSKCDWhsytC2QY5rW4v6UB8Et3X0WgorFEW?=
 =?us-ascii?Q?z9naRDIlIRCbKPhspgV1bzQVx1lHzSpUZkNTumzItVy+twdIoPh5L4hz6MeK?=
 =?us-ascii?Q?exCQC4i4eLh6MsE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(52116014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Obz5u96aXH2tAdCsXHs81UDfl6dq+cyUwLipqRvoJPisTb8R3Gfp1odmrqVe?=
 =?us-ascii?Q?Ui/d2dvCqSdblGHGmk1UXKWhl8nrb/B3yNJGHMTJjfTuu2xCxvgqXyeH9YvJ?=
 =?us-ascii?Q?+dNprtxd2j0vsy3brCl5E4E9FqMM8OcPs0ARLqkvFxt8QHvW3KbeRzu9sVGr?=
 =?us-ascii?Q?6BQOOLVsT74nX497YVgp9LxjalujpZSafpf0bT7Wae1asMvCxTOe8PVTQm+R?=
 =?us-ascii?Q?d5oiVtY5/UBBqc33JRwl9dHg03+KxMj9nD45Gs8Y9rzQn4XBEqN5+JjI+uux?=
 =?us-ascii?Q?jU0CJnSPwBB/I8q95RLV3W2uT9veABv8WrzXGvmz3xYVvpQPidnsjRSg91Sk?=
 =?us-ascii?Q?UkNXcwmNNOIF0sqyhZslTaZlAIUuUDms8PpbkKZmkbwKw8OzrNPXuuvdyGpt?=
 =?us-ascii?Q?cK7kBqeoh7BI9qelO7+ba5MHguf/J0NhWMc9tL9R7Trn2pe1vGsdCBPdNJKH?=
 =?us-ascii?Q?pVAUJOA9iViSMsgK2js9xTRfr7yOeNUGnRTDn9nHXve/YxUwI5Slx5TilR3E?=
 =?us-ascii?Q?VeAGvF3DvrlB+StW6a6PsydzE1WqWdVOjcfL7FidjIiVwndLRlE5abv+pwEH?=
 =?us-ascii?Q?dEy1letZrXwUyDo6LOqzVlPmekANCPU4JF5Mm0Dez+9cPAKA92mFLv2ngcSn?=
 =?us-ascii?Q?faoapwm7WDFny+ZZyv4XqxrxPkwcZEY1L+GJ+bNh9LzCeMKarleONMX6m/m4?=
 =?us-ascii?Q?yd5yLUspSCSV2AHVrn5p7+d4cuqfQgrebD3qH+xpYleFiRLFpEpzPUJaXNFM?=
 =?us-ascii?Q?BbDoqo6Q6UBiEWXUE5tSOxlEschLMxQuNNm1Js2WOBkw0hsiBWKawXI2BtuY?=
 =?us-ascii?Q?jI/OrnRts8aGt+iP32Z9gnXmduDefXz+aZT0G6VARDJCaajX+2006XHeydnq?=
 =?us-ascii?Q?ewpfQVShtVpeZTaa8kSBLqDaOZMAv/rXOnEw6MhA6D8lxyfO3hw2ijKZyls0?=
 =?us-ascii?Q?s/+0R6v47Wkty8FFCPXlxyJ3o5H9/BmY7zI6oUTQjFeVTUX+N6LmmbNrRTbk?=
 =?us-ascii?Q?telh8OiY4KQDL3yo9KUUETkL0weEQzxTWSq0GiCtwejjhAueBi68vCZyYmL1?=
 =?us-ascii?Q?qxjC5tBWO144Zwou92popnFsmZvaUMUWhoJNFiqoL8BUehBn2Wxks/FCY4rq?=
 =?us-ascii?Q?cx/M7mwWxCnuY3Uw0Z2LDxpZ5ndKQemYY6caRL+XycHwiVVwdYc42NPSDHx0?=
 =?us-ascii?Q?QuUnU4xGd2EWGfjn0rKK3yQUhmA3hrKoaXq6GsmIeAOpTlI4TcSY4X76YsCe?=
 =?us-ascii?Q?ZFUFYGGRdnrH2X5wKDMj5Ol/FIHYQ41f26D8F80DQHazzQzouDGTcm3qVt1t?=
 =?us-ascii?Q?ed4E8I3tNpEN7hpK5ZVdg0Vm7709kJGEV6pgkUpMlJtMaFLrGmtY9V9eYJYK?=
 =?us-ascii?Q?Mjy7xtxWlXOcM82TPFDXjIJ1qatS8fDGI6A41cOUsJ+cbM4psAJmd1VJK8w2?=
 =?us-ascii?Q?m3C3dIfebwRIioQt+ySE/QaZ4+A7n0o40Qfho+/qxq2hWmOv0630d54IQkXc?=
 =?us-ascii?Q?CMweX80IBa7fLWgCBR322ncuxILFsfOf3FxaiVwdeZfGdH+UQ4YTE/FYKsg6?=
 =?us-ascii?Q?84FGH+1G/8ZCLkRxaw8gsrJJgYtZszwo2SDMGBdoFE/mUF1tPC34g2z+WcXy?=
 =?us-ascii?Q?/JHNEzj60lCPTmaEOydZqrY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f510695-38f8-4fe0-b21c-08dd7c34c502
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 15:47:04.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfivTAjZBtoZD1LET26CrIhrxp9b5W/7YPqiP3liPbimFVW2yCHXjWIAalMm7BvE52inbSqjsN8BD/jZHXwhBgJLvsB2FRErw4HvLtHo16nLxGWCVIqtUUY1ycz8gGq+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB7099

pNMIs are intended to be deliverable during operations like guest
tlb flushing or nested AT, however the setting of HCR_EL2 controls
are accidentally blocking async exceptions.

You can see this by doing:

     # perf record -e cycles:Hk -g ./dirty_log_perf_test -m 3 \
       -i 4 -s anonymous -b 4G -v 32

Where no samples will be collected in __kvm_tlb_flush_vmid_ipa_nsh()
between enter_vmid_context() and exit_vmid_context() then many
samples are collected right after the write to HCR_EL2 in
exit_vmid_context(), where pNMIs actually get unmasked.

Set HCR_EL2.IMO so that pNMIs are not blocked during guest tlb
flushing or nested AT.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
 arch/arm64/include/asm/hardirq.h |  3 ++-
 arch/arm64/kvm/at.c              |  4 +++-
 arch/arm64/kvm/hyp/vhe/tlb.c     | 10 ++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index cbfa7b6f2e098..6eb3f93851023 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -41,7 +41,8 @@ do {									\
 									\
 	___hcr = read_sysreg(hcr_el2);					\
 	if (!(___hcr & HCR_TGE)) {					\
-		write_sysreg(___hcr | HCR_TGE, hcr_el2);		\
+		write_sysreg((___hcr & ~(HCR_AMO | HCR_IMO | HCR_FMO)) |\
+			     HCR_TGE, hcr_el2);				\
 		isb();							\
 	}								\
 	/*								\
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index ff4b06ce661af..f31f0d78c5813 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1269,7 +1269,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 skip_mmu_switch:
 	/* Clear TGE, enable S2 translation, we're rolling */
-	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
+	write_sysreg((config.hcr & ~HCR_TGE) |
+		     HCR_AMO | HCR_IMO | HCR_FMO | HCR_VM,
+		     hcr_el2);
 	isb();
 
 	switch (op) {
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 3d50a1bd2bdbc..ecb700bab3b8f 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -55,6 +55,15 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
 	 * let's flip TGE before executing the TLB operation.
 	 *
+	 * One other fun complication to consider is the target EL for
+	 * asynchronous exceptions. We want to allow NMIs during tlb flushing,
+	 * so we need to ensure that the target EL for IRQs remains as EL2.
+	 * HCR_EL2.{E2H,TGE,IMO} = {1,0,0} would set the target EL for IRQs as
+	 * EL1, and IRQs at EL2 would be "C" (Interrupts not taken regardless
+	 * of the value of interrupt masks). So we need to set
+	 * HCR_EL2.{E2H,TGE,IMO} = {1,0,1} so that NMIs will still be
+	 * delivered.
+	 *
 	 * ARM erratum 1165522 requires some special handling (again),
 	 * as we need to make sure both stages of translation are in
 	 * place before clearing TGE. __load_stage2() already
@@ -63,6 +72,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	__load_stage2(mmu, mmu->arch);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
+	val |= HCR_AMO | HCR_IMO | HCR_FMO;
 	write_sysreg(val, hcr_el2);
 	isb();
 }
-- 
2.48.1

