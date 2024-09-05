Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2090.outbound.protection.outlook.com [40.92.52.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93A6E619
	for <kvmarm@lists.linux.dev>; Thu,  5 Sep 2024 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.52.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725517874; cv=fail; b=EGgLiAU3FPTZXFTVhl4EWhDkY9YJ2WOzCBR9ClERAshHP+8PHanBb5v2/Meppn0X6GlUlaIiHKlcgTQhGJuqru81F/j/vhBEpKB11JtneyolyiWMrxf6DZ5MsqJeR5FLIPyAjSrVppTLCCYcBYyRXB+IBfQ6z9poy7ygsc+KPKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725517874; c=relaxed/simple;
	bh=w5uOxjL/f/GVe2xAEV8V7g5+KibhswDbq0HwQYKypaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qkBORI06BPgxjHJM0VynD8C9OiLai8ytQmyBVU2euRtgheiLRKNFWgNVVpkup4AHdgcQHyoQqwGu0sVyu7eoy5JvDJVl0EedoJdzrasBymzpwZRqyBllvNP4nNmpyEYgiFnkCUqWEFRNZQQLs8IDSPYafgK7Ji5A37zxDyOZKEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PQ1jW5L9; arc=fail smtp.client-ip=40.92.52.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PQ1jW5L9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywbUeE7m4VbGccwtebDwsvovfPzbepU6Qoq9RnrgwONgsiAlaTkVJKYziCqqCE0stnL5iQ0I1O67y4KmeoaxbM43A3qTNcV6wqSA8vSNxZhYzKqvQg/19/+m7dHg25QEkYB2RVVPKbKjUwsXEezeh2VyRqUR0Ztl6UvhaF0/f3Poj79mStLrt2GtDlPnyiThQNeI/Wzf/bNl1EHgS8rMht4EezUtQw5svrBTxtYETawfgQuKWwOReg9B7Wwe4rNq8YM7pqfmqhrSdCDkOSDcbcVWu2djjkDwIR96xDdtdpn71/zy+FkqVOusHkCQlGPDZ8nAQLg4+hdQ+XUe2owGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6AOQTFQXZ3aIQJt/Ag7MYJ3ZWwVnhD5AKw59fQxJxs=;
 b=gpgl44VGr6aW4gtmOd6Z8IK0/5600sT9FvK0S25AHU5+2OkN+bAxcMxXd/UGu6s1MveaUMbj/5nUA8uQdliF5R2vV75eBwI4GM7sJB4Lwq50wGvmfJVM6IllBphUsYCWJjJcg4aIqdbT26cRqAeykbdttPCS4H2Z1VI+k8UKUDnRtjs5Q7//02v4DMLVLf4ZH3R2hL1zG2XoRtV5M0/Z+brM36UsA9jJ2RYJfD3bqNiJNztUUqVsqCwJwdRPwdMhWp3iQ/37Se8D/2bGRxOeyIUTwbwJBF6O0YYDvKYSbTn1YUu3l5FO7H5bie5h9mWzusMZDJN9tUq1F0MoT17p4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6AOQTFQXZ3aIQJt/Ag7MYJ3ZWwVnhD5AKw59fQxJxs=;
 b=PQ1jW5L93mLQjT+k6WHIihL6V9mNbuvM95cTe2oe3tqgxstQIVP8xvJ+jn0+LUoDoVN6JMKpCiEN7Z1vAyU6QLr/jZ9WmOQGt7iQGVlgyRECHDlcQpkjQox4aHIC3afeNasyAazgBufVO8rNPdEypZ2nH9M9NjDEfo7GGN7ojdfP9cNO3Cee9E/HMarJNwDykiSG345vcOA4YqSoMXMZ3fQkHmPRVpJYt0VVaiwpZD042/N+gi70Y0hTzoVJdX3oHYb9vBug0MytY0d0zJnRHcRNvJHwQDXUiFW7+Aj9391YrSJVIWQCz81j23+eF165swMSTa1G8hD/Jim+0gsctA==
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com (2603:1096:101:a6::7)
 by SEYPR04MB5737.apcprd04.prod.outlook.com (2603:1096:101:8b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 06:31:09 +0000
Received: from SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4]) by SEZPR04MB6319.apcprd04.prod.outlook.com
 ([fe80::8a6:22f0:5560:f3b4%4]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 06:31:09 +0000
From: qixiang.xu@outlook.com
To: maz@kernel.org,
	oliver.upton@linux.dev,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qxiang Xu <qixiang.xu@outlook.com>
Subject: [PATCH 1/1] KVM: arm64: Make nVHE ASLR conditional on nokaslr
Date: Thu,  5 Sep 2024 14:30:26 +0800
Message-ID:
 <SEZPR04MB631983048A8586896CEFE8829E9D2@SEZPR04MB6319.apcprd04.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905063026.3411766-1-qixiang.xu@outlook.com>
References: <20240905061659.3410362-1-qixiang.xu@outlook.com>
 <20240905063026.3411766-1-qixiang.xu@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [+c0HwO8i7Omk7GuaiYAD9MACED5BJ5bf]
X-ClientProxiedBy: SG2P153CA0003.APCP153.PROD.OUTLOOK.COM (2603:1096::13) To
 SEZPR04MB6319.apcprd04.prod.outlook.com (2603:1096:101:a6::7)
X-Microsoft-Original-Message-ID:
 <20240905063026.3411766-2-qixiang.xu@outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR04MB6319:EE_|SEYPR04MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: ed93d2e6-4edf-4dda-3ec2-08dccd7453dd
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|5072599009|8060799006|15080799006|19110799003|3430499032|4302099013|440099028|3412199025|1602099012|1710799026;
X-Microsoft-Antispam-Message-Info:
	CFJvn9h3UVR5z5jVwNC/Mmt62vM5hIbHhNcSPNb4CoJUDSLONvAF2eVC0/qtShC7q6ArkEbHDJUexL2N2YHrxb3/ecpMHcW3axvmbK1xoizK6uNSjxAVqdHjCg49hAr01qKqZU4kW0Vx5W3A5KGb15Y9uysj72+QKybPfubwkJjMlkKgvfsZUwfTwmckGtXYhGa0n5ArQycm/ROSnO5yfseqollRsYNC4ldqavh5tGAMt/SIvF+cFpLJDUiJdbX8gn95eUgc9wXxUc/lmhi0g8uZ05RAg21wE35REItnLjwhEpT5Z9C7LCa6CdLpZw+lgaw1o63Xv2EXNJgQKeEcSAGm0oAmJqx57aentZKP0DXQpCIqQ97GdlvV9UgQhUB/dgB4CUKNdZNflMebCGPHaob40B1bEOSe+eX7zqkXpyx8f5MRp5ioHBzWy6yd/+EA8FIoDVPZXZj9lrR3CBWLkZu71XxyFEmHusgQOKdUgMnM3i3SsOYgC8vEUqqcTwFi9681prvIbZTM/U0xEKsXTTAM5lkxxxTUyH1gC7VR4OddhR4V5udVdGdZVPyVeepldiFm9IBgp5MHDRBk7PFWDTG/W/LWkMPs2sD8SvCNvSBxYk+Bd0AdOwpIJkLPoKJvSv3qk913OCKYlNxYRUgZJXG7qcBz0eSTXvVNjYlQGog92RAOaCSc12A6+AmTCC4zGpDUNXcsvpCXlFv/b1kn8j9zH86D8l81fwFqzqT6D0fzWPvcDc3cOC3pPE5gLIfX9RWDeOlamd52tkjW1SJmVTJiOy7cszcUCpbWB0ZGLi0jT4+U/UiyJOxzSg19BWGBbgZ4vwidYeSbddVmUdW3tniIBl+IH6WyULXrhvI1LHxVJ6QS95O3MWT/4yOMQFL/YwV+GCi9bGNtyX3rjPz2iQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NLknOV10ZpAs7SfoZetecyimIM3xozQYepfEJVPtXlFDqP+6mPBabzaADWSY?=
 =?us-ascii?Q?+FmDKtiQUe0kLRo4u2DaZABLF1HK+KVmBRAUwgMjWp2oxZ//Pc2FHGKv14uT?=
 =?us-ascii?Q?NyRuc+m9reVv7YXOOpsP3DTntnD1tkAlxKLekRVmqAwYTwWlJJ6VmoZtzLj0?=
 =?us-ascii?Q?wCwszewv8tTrYcbm09jxNBPC3R0u3qeglbUTE5noEGjCK3Oycbdj410XYkHY?=
 =?us-ascii?Q?WKy07juGiuYD8kMFTE64LE+nE0mHgJefMA5UpwIk7MRDxQ5xaqU+eXKxqT1k?=
 =?us-ascii?Q?Lf9j723EyB/bEqdJZWw661FWt41KRsugfiTBSFk57yqHTubk5NBrTk0WpeES?=
 =?us-ascii?Q?AE0ceYiK7NpgY2+GjB5REOqEDQg4PWRw/CHICvtaR8NIi04JYeLkEPLWeeCV?=
 =?us-ascii?Q?DVKoJBd+fTABzb+5aDnO4iyAgNP9eD2Gbn7rtKLiQiVPcRN+FrvnNUp5jUmL?=
 =?us-ascii?Q?rVxJsOYlkonenW2bkEKnDknLSQaS9vAsGnW+m39/K3IU8aD9YoKwCEqhrarc?=
 =?us-ascii?Q?P3+69COyDXLEAPwA9jExTFxrlDAYLKQ/W90BriLteGIOQBNTJrlGuwO78yOI?=
 =?us-ascii?Q?om5tXcAhnx9W+cgU/AkK4MXA1rJVNMEa+Cbs8xfoMhlnLXIemPFg9oIn09WK?=
 =?us-ascii?Q?PXThKsbIsGpvQrdknO1YoFbZt6dF6q3QTWMMAKrQOODLCAscB9A+nzNf2j8I?=
 =?us-ascii?Q?BW6CGlLTJgHkBao8jX0/9xz1R3q4ifzYyKwNHgOTX/nFBLadCujKeivzhkuJ?=
 =?us-ascii?Q?6mNvLJdpy9yqu4rjzMcLd0DQBnknXZOqr2BoQ4RILQRtGLfqI9Kg5tN5VI93?=
 =?us-ascii?Q?zf1gJdJ80/EJBEicXUp7AAXpyPhERqdZ1n9PW5lAv/JEi0/1A/ukvj6cCFxn?=
 =?us-ascii?Q?XjthIjRNZ9l6f9e49c9XdCblDB4ljyErF9fJwYb+UAEpf9v7eesHvGhOmv9U?=
 =?us-ascii?Q?f1yzX2iAOsHC2hY5hr5cpFuRgnlAE/HKXX4wBMtUg2XT6lRz2OHfkceyCk3M?=
 =?us-ascii?Q?FeiujGdp9ip8XfnIAMY0bGOdHe7UQUTRtnztdnpko2+waUcIGoEervvkY2ZP?=
 =?us-ascii?Q?+iqiLD6jlu3SSXE5xe+gXjioLBVBRZAjOpz3In/0hQD/oP7P+GxYK6XjkKPh?=
 =?us-ascii?Q?JbrJFrX3zPIe4EMGimNNuS6gjl/WOuMf597mvV0AYwiB2GABKuZpwehbpjbE?=
 =?us-ascii?Q?F0E+Tcl+AN86O8PffqRGuYcaUwEH04G/6darfevafE8GRg7DNLCDl3XlSDY?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed93d2e6-4edf-4dda-3ec2-08dccd7453dd
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6319.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 06:31:08.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB5737

From: Qxiang Xu <qixiang.xu@outlook.com>

The random tag of hyp VA is determined by the `CONFIG_RANDOMIZE_BASE`
option, so even if `nokaslr` is set in the cmdline, KASLR cannot be
disabled for hyp VA. To align with kernel behavior, disable KASLR if
the kernel cmdline includes `nokaslr`.

Link: https://lore.kernel.org/r/20240905061659.3410362-1-qixiang.xu@outlook.com
Signed-off-by: Qxiang Xu <qixiang.xu@outlook.com>
---
 arch/arm64/kvm/va_layout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 91b22a014610..bebb4b1ddc82 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -72,7 +72,7 @@ __init void kvm_compute_layout(void)
 	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
 	tag_val = hyp_va_msb;
 
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
+	if (kaslr_enabled() && tag_lsb != (vabits_actual - 1)) {
 		/* We have some free bits to insert a random tag. */
 		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
 	}
-- 
2.25.1

