Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020143.outbound.protection.outlook.com [52.101.193.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964692D996A
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745355278; cv=fail; b=tKBe6pY2Eq4fMwiVFbdKQyJ8/nkwov08sGjWJMjScl12KldFVD3ruOB6syZkxHLGDPZY+jyZ7+9rEvoeDvvEOq9HsyQzGyn4lNNtxViaejDC+1v/K0rW/b7Hy1sLHQO83sdWwjz30Ggq+zmly+vmhy50ypJifEMgFdkoE848h2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745355278; c=relaxed/simple;
	bh=T1gio/g1Mnf3smj2x/f4FUWYmlwjYqo8+wDQFNaHfvY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=KdzIWZkAtyCMmNYwLUA7NSXsXG/7UbxFLWPPpCJFbKJUD9rxJ0Hn2e4Dh9rytplytI1zTE9cOaxRf0dUB5c1NWV6PmUfFBNiBYy41ujyl+4MPu22KCZvA1AAj31K6lKOCUyFK19WuYWWPZeJ/ClZqg6EVX8KjbviquSJiHh4A8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=awHi1jTG; arc=fail smtp.client-ip=52.101.193.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="awHi1jTG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrMELXiGY55RwUuZLRVdeifdNc+ehD28SQfvHXVbDLIEV3AdjSCA1vIJsq8JGVpp0yAU0itQHGuKeEycVws/XZ11iWqjOBvo1HsdNpCayRhakXfP5zcuFksSbP5ihWUZpJ7mUs/+Deh9jifB94U/L6HtfzE0OtpZK6ZMNTE77YHh/DOTu5Z8NyHJ+rX+E5vA8Mro/nnD7247LoaUjoGBNssGKG5+/8fv5BHrFqgKGAUsywFyGtcr4pELmi38b+hc0UXgnLkPQm6eFVSncK14ZpPaJakkT79nVqkXquFOHFhIqEzShj1T0O5r5MIn42JxHoqEH/k8dbNtOv61TrlShw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXsn8wtIMjjN/gReGMqtFpduOKsBTAck1o+dSS1WiS0=;
 b=QeDxw+WqFr+VI8dWbBiP7WYSoUrgRSPXvFn7UliOtO+E+dgauQUmsoxB2WvUtz/dKYUYNSeLsxYEtYGES+PiI5hmGTnqjjyN7fX3kALz5CIUWCFsrecv3DuGycGQzsVss/VF1K8O8Gg2eahrrt8gDSAWUzgsCYQiKd6FlRxJsk77Wi5W9qBMNKWrTHafT6t3+Ol6gBtJyPmlb7ZUt/OhUvH07LcZu2DW0XQp8jp7v6OgimYF9FqIIj56ioUfj//3yk4XuCe+yAXTktYWQNQs+NtP4ejCgqCx/xXFbW137wE3z7+gw3ZUVuK3FhoP/aHJHycqk9j0+ub0Maa4pTwA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXsn8wtIMjjN/gReGMqtFpduOKsBTAck1o+dSS1WiS0=;
 b=awHi1jTGwMnFmfh4LIa4OwRls4zvXzCEY4cK/Cq03uFc/nd8BvidXfu66jYBb4IVftWhD1XIURrutP6weV8sHulC56EX0pVyhg/33DyiHDCJJVzx4wlkzvH3Dgeb+yV9hoGi9+3c9R261E1yyHTQjH7o0n8e2xOqWp3aBaRk3/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DS7PR01MB7782.prod.exchangelabs.com (2603:10b6:8:7d::17) by
 CY1PR01MB9267.prod.exchangelabs.com (2603:10b6:930:104::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.35; Tue, 22 Apr 2025 20:54:31 +0000
Received: from DS7PR01MB7782.prod.exchangelabs.com
 ([fe80::b3b0:a90:453a:e924]) by DS7PR01MB7782.prod.exchangelabs.com
 ([fe80::b3b0:a90:453a:e924%6]) with mapi id 15.20.8678.021; Tue, 22 Apr 2025
 20:54:31 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui
 Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Teach address translation about access
 faults
In-Reply-To: <20250422122612.2675672-3-maz@kernel.org>
References: <20250422122612.2675672-1-maz@kernel.org>
 <20250422122612.2675672-3-maz@kernel.org>
Date: Tue, 22 Apr 2025 13:54:26 -0700
Message-ID: <86frhzyl19.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0276.namprd04.prod.outlook.com
 (2603:10b6:303:89::11) To DS7PR01MB7782.prod.exchangelabs.com
 (2603:10b6:8:7d::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR01MB7782:EE_|CY1PR01MB9267:EE_
X-MS-Office365-Filtering-Correlation-Id: b2a502f4-c749-40f2-da11-08dd81dfe0e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VezdylssVLf9KE66ZOn29kip2FpChYjMo/Pshvfbiv2mfWIoFTFI04BFFvOk?=
 =?us-ascii?Q?zyy8kc//JI2V6x5XUKYIp3d/fmku9wzRPD0v1AW/rOv1TA7ycikJV2nbh8Sb?=
 =?us-ascii?Q?SdixXOg/2GxUoaQCur0QE4rISUHt3YNwgz5TDIRP23r8+mEcq9XU5qC/v8RI?=
 =?us-ascii?Q?DrPeT0ICwjWhxrMO25Y5z7F1sGmDEUoTQHUlo2o+vDgJCa6qr13QvRtTxH5f?=
 =?us-ascii?Q?DxcQCQde0sj2DU3c6vgElFK3f8cCVm02AU1Qpf76ox6HNJnpM8+a/g6/IpT/?=
 =?us-ascii?Q?U36nhGf2vY4OV6PUgI58sZv/Oya31yqVFVuFLaMQGvmFQkEHdcOakCfsstHN?=
 =?us-ascii?Q?kgbdXLbdpspXOkXTsq5mCWy8Mzy97kMPkWEBUIK9r6o3+tCNqCWZlB8oElL8?=
 =?us-ascii?Q?A7lfFwrTaaGfWMCa8BKH49UeqUBTOsWP2c9lx773+ySnJcPPOp8ytjHZC3Yf?=
 =?us-ascii?Q?7BIW564YbQTYcYbTpuMUoyMoH9zAMDBCyU0QhtmvIMEoxVKg/otYngwD47OR?=
 =?us-ascii?Q?MTYl+lBy9CDWzuw3dFiw0H4t0s//R6xvWU4dOvJQSZJoD966kNW3vvv/C5zN?=
 =?us-ascii?Q?Ug1LV3kiQPvitk6nQuyeaiDiLFBFg+IdN/Ak/hCwfInGJbYTC7SHmV3fUQwi?=
 =?us-ascii?Q?S/9FjfDNUL2xU55Da+AGfuhyFisihEbN9/qLu6bqug9qjp4rREX5yXh4RVrZ?=
 =?us-ascii?Q?X3Z/ZZXrojVry+VdahepkrImGUE2RgJdzsK3C3F8BGdKxdMz/tj+yaIPG1RM?=
 =?us-ascii?Q?H0zOQBanjOOtwY30QABGa0Kh/P67q7ZVXA6zcFV5nWfA+GkzA2BLsjnFZOr/?=
 =?us-ascii?Q?y/QK4HukFkGc3g/dsUfGTYAy3+dMC5NjykWW99fU+JzoShG20qVhLIFG/hHV?=
 =?us-ascii?Q?7nJ0wAe//m6TqUqMYqjEcBIWYiLBmf44JKOvXGQXA9he4NHUuvL3Him8yGjQ?=
 =?us-ascii?Q?Dkq3AfAoYPiTRGuQcQtKbmfh8HjzN51lOE8nfC7WKo598r9otDpbaQMD7KaK?=
 =?us-ascii?Q?obkIWhQZpjUd+OK8a5pWgwQqDsTcV0HrC3o0vrOexuOwmyw8WdgM+mOj1XIP?=
 =?us-ascii?Q?rADfpBB/8Ha9x/FQ441R8Hv7J+l8NIFHkxQ4Om2g82ANit6mtz2TEt++qCEc?=
 =?us-ascii?Q?JEsPLBPSmVBRQ8t9k0MZeJ3f+ModoG2+6vgNO/pjl1k5uPRWW91lzKDRWIoA?=
 =?us-ascii?Q?qBcI/VXjFnzklLTlkncd+uaD/NxsW8+jie+vwC5lgrTgbYcj2DRnpZByBr7t?=
 =?us-ascii?Q?TjbiDCLgFplHzpQ6aVwIq+EQ5F5irlrWPujibqgqBnakY3kmX3CE2/LnHfPF?=
 =?us-ascii?Q?oJ3VACL1X45wgz5zZJJn718XmcBja+xZlXP9d5LhVcSNmIJ2T17/4dOhMnOs?=
 =?us-ascii?Q?F4LfZTFjEAK9YHYnK9fHG23nQCZmBH8FZGHioFsLaXthOZfIaE7NDoZ2P9+k?=
 =?us-ascii?Q?1eHmjR0kAsTYRZuicJXsBMplA/HMArjSiHJwHVLbL4BSxBigWZBNRA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR01MB7782.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W7bi/EvKnwNwNq046mqHXAc5O3TucOltjgpKXgB6nG1i42zvJgNEvKi0WCeO?=
 =?us-ascii?Q?lDhQcF1qBf212g9LQ/toP84I8dNd+Z+opvbnXDPV+hjPVWqTAUijb8VfUXCq?=
 =?us-ascii?Q?s9hnvR0yPClDFQR6CTTIwT9lEgMu3w7zW/EVrhmjiHPiXYIXykxDrEf+1B1e?=
 =?us-ascii?Q?GYXbtgikXznBLwIM6N9CvTMPwEkzDKkumANfYnU/qLOqITvXVtAVgQ0gmvrR?=
 =?us-ascii?Q?ZvfLtPN7NC8Trl65kr41hvZY6IIvnKO3XB/VBUqrsXdaa73ekyFOhzWsCBh4?=
 =?us-ascii?Q?Z2rcE8JWTfbdhPQypkT3sL2vgvgjVrn4Jsq3++m0/dxdYXLUNG5nPHSxr2Rg?=
 =?us-ascii?Q?slfFrT6Ln08uJGj2oBCaBaO5JiKlMreQJ11Y5cJfe91+GWaqU5MvKQQsTtKm?=
 =?us-ascii?Q?6Cq7IDGjxR/lb7LJIN6ZWhBJKzOTvrxg+KbEHKoipeSAD8pwyHk9vXWviSRI?=
 =?us-ascii?Q?lNMPPFDRtrMMxPFUmSKvl/lIPo2xFc9aP9L41NpX2uqfy/wjG2j+7WPo7smC?=
 =?us-ascii?Q?nr9wI416GSUFWwlaNN1h3bKv2GlODD9BzGV531RMzgGrCjIzULQ53xDB4V1f?=
 =?us-ascii?Q?lTRpt6xB4QDCzbSWp4TPo2JBIJF+ErMTJGsdHFhqItB9eW7P6A30S3ZMp22p?=
 =?us-ascii?Q?JpGuuocMRQe4zdlyNnxKKspZGj42BdoyBIBQW5Hd9CU1DXMVEJ+OiVTqjqGh?=
 =?us-ascii?Q?p6dE+Qsv+UA7imOMUps0N3NRZhJh5JuRTBa55Xij5AQaS9gLYFIxjYZDp9lE?=
 =?us-ascii?Q?ZqK0QSK35ntOcQLAvwJfywJPc2fieWnwfyW1QJu8VIOccF+zGwY6fIfktfzu?=
 =?us-ascii?Q?AzqObJlKJbPT3tjDIdM/txae7YHYC26COmNlz2A5r0CKj4wm44mfF9vDvYwS?=
 =?us-ascii?Q?dCQHyqijSewEkJTdBHZ1jp6spk/A2x1RFGhL2POPXn8xtumfqIOPgeOGkodX?=
 =?us-ascii?Q?KGv855LiIwkyDqpTLF9tsr8Z1cyZTvoPZn9ttQ9inY9cvSqKI+K8JMnqxqKZ?=
 =?us-ascii?Q?RS2VSQj+zsmuCApKiX+vXSMbtgv+t1rX/Ai0kjK0rdt/qhuzAVXzrNBmqnCJ?=
 =?us-ascii?Q?2c1VeCriS9Mr0VDanLOGLx4u8Qh0qoUpvSGg6gbsdGPFIXOIMGm2V/36NlMK?=
 =?us-ascii?Q?BjTYNMAcCQUpYqb2mKxe0mk0su7iT/i7dI1cKs2QPTT+3NwwLsQ41XQeRjy9?=
 =?us-ascii?Q?+yDbqWC32HNB7Y4o58baLYJGDV5QPrRBUQKgoha6okbX3uNkoLYW/0Ag7sOs?=
 =?us-ascii?Q?xgYzS5FfrEupEznhSmrRUFaE0xfBPgvb8n9XejNEErsICQejIZB6U7LekmSQ?=
 =?us-ascii?Q?HW3/nfajsC2Pr1oSlUCN/kjvKGx9AVVBmjWtIbCORiUoA+vN9B6e4jLFx655?=
 =?us-ascii?Q?YIe5za6dNjC2VqCNee1MbIN089J26RNkJUj7VapICqQU7lBF6uEg9oWWGoXh?=
 =?us-ascii?Q?cSewa1JONu4sX3P241iBV6uwLsAbzeHIHhAwn+SPl9AxwtqSwGCvPe+zXSGf?=
 =?us-ascii?Q?7tpmElDoD/uWVqyVk8yoBiA3ar4MF5lAKFDNnHh8980VV9uBRFOcKfNKaY1J?=
 =?us-ascii?Q?7fzjxJUi5Df6MS7wHlRKtGpbfTrHDMWMM2pkVeSF3ENHnWVTToyMYYHGES5H?=
 =?us-ascii?Q?izhg5fYKoAcZLB0ul9N3E4I=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a502f4-c749-40f2-da11-08dd81dfe0e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR01MB7782.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 20:54:30.9179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qmBITcgYGHy6LDiGEM3pEVKJVLVpV6s3F1zrIFJ9X07voGHJ2AOEtTInc7MwnuoPNYSrQ8S2Suhs7I3mEdfZkcKC8JyMvRDHb7qv11YqwV2hvzO6IpNvi6NfloJRm5n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR01MB9267

Marc Zyngier <maz@kernel.org> writes:

> It appears that our S1 PTW is completely oblivious of access faults.
> Teach the S1 translation code about it.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 3a4568e2de910..c40583edebc4f 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -456,6 +456,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
>  		goto addrsz;
>  
> +	if (!(desc & PTE_AF)) {

Shouldn't this depend on TCR_ELx.HA == 0?
