Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA5918FC75
	for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 07:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268893; cv=fail; b=NTsEtx+fQoaqhZVsHIXe9xNhjhfR/OuhDOBjZI+johcDiIgvbCPH2U6p8+t6aMgM+s2bowfkL5D9dp6Zpj/5kw3qieau61W8vdX0gwcO3xJIqgenNtq/jxJt1QPmE+alB7rYeahyPbnJOKTmumoY2V9RourC1mo6BgAH2KVemKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268893; c=relaxed/simple;
	bh=QOQKK61NVpeanjsw/gtXKOBB4VK+zw6zZhWGQ/qQEbs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VY6jhGwdQXbtoU0jPP5z97YoSLr93/ABbOZrYTOau4ajG03HHF/Uc9LiZMDZPDmcnnmiFRQPIA+LupkJr3EkhUuW9BuvCbGuNDL5InY87aMoY9TnH2A/OHeBsY3lcKOyEm3X/M8NIdyVkdiDJKG4b1zjvsQPhgpnlhb91/YM1Z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=S/w0CmhN; arc=fail smtp.client-ip=40.107.243.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="S/w0CmhN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lGfQ1Grvw53Tcu6YzuR4kupSJvVWGLH7BMpQZyKp2nPBoDefER6eyP8bu/FAaba+ALAw7REIQ4XEWffAMcBxj/4c9I+kV5woxEk08OfpAy4FV2pnn7QoL7PVGwr2UTk6rn6FctC3zSvCZaJYSkIgl6NB+rfYvmwDR94lOU1q9q9HQHik0FASBhxFnd+iFRY7wisaBBzSioplTlpFGw04BsJEsz+RyVaqUDok6XTMq1/VzJJwAUybvkpSUL1IB8prb2JNJDMi+MZAGEsVqEOz6TJmWosOwk8qKt58urmQ0/VMV3ZxKa7G+yEv6GLmTjFFTSgKmBRMMBAm2qqw9jGskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPh3zTlWjK0J98+eIPEcyG2/MGy3MCDc0gPKQUr56ZY=;
 b=S4f1O4sQzDsQ4m3zGt/RVwHKMGHT0eM1KffUNBr1EwglY7D4WnAaL2aY59o9/UjahqSfAl1OUDqbiinjZ3rd+d3hZVld7uBXnHKgy90mVF+TuBURHDzMpqz0PAI7jx4by9A/ENGOTnq9q90nIaoRCgWDiOzn0LtZGBL3mfYDVTMQ0BTirqYXiymSu1087cpHuFqlAN+FCDklwdwtfy/QIQuJQJxI/EvD0Vkpx97Yqx8ar28iK4NIhOijeU+S2tJAi/rG8eVRJwU4LJTZRTVyW1TWVBQYuN5uxORbOoNUfCJDmDJ6EURrA/wlh5wQHXQZKOwQGjwLbweeJzSYq13PIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPh3zTlWjK0J98+eIPEcyG2/MGy3MCDc0gPKQUr56ZY=;
 b=S/w0CmhNAUlEwgebGtVy6rPTzSYC2zUHGFbB2YGRqDQM4/+00/3hwAT0crgPDs/voTBeCb/Q2+8ORL1DkJQddiReUYWsbZebjAWPCDfnvlTKMYgp6IUeyoMWoTYVrd7T3OOr8uAknxXnzbSLXy4Uij/Hkuik2YrWOsYZp6JIklM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 MW4PR01MB6387.prod.exchangelabs.com (2603:10b6:303:65::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.33; Thu, 10 Apr 2025 07:08:07 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8632.024; Thu, 10 Apr 2025
 07:08:06 +0000
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	darren@os.amperecomputing.com,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH] KVM: arm64: nv: Forward hvc traps if originated from nested VM
Date: Thu, 10 Apr 2025 00:07:43 -0700
Message-ID: <20250410070743.1072583-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYXPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:930:d0::10) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|MW4PR01MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dafb282-21db-4434-8b9e-08dd77fe714e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CPZlTWVRpsZkrotxXH+usBLjcHehRiCyPUKGaYHRbpXV4DBRV8YZZN+5E0ue?=
 =?us-ascii?Q?mz0PHFjhn8kZVh10QuZPmT3StJT2zxIfvEWvwx1jiqaXi0O3Z8ZibqsXev7C?=
 =?us-ascii?Q?UcnlQRQW79ndGukB30W6TFuZkqSsbihmJZZq1RJokfK8w8dJjWxAThTR/OMX?=
 =?us-ascii?Q?XTigSq+Rk0jMBZVMTxF1GO3LLEw+LnuYtWSZdb2He4OFIC778J9uZdXD/Xz5?=
 =?us-ascii?Q?vjvssTYLQgDj4+Bpu3XJr0ZpZtKlz0CyOHcv9owdBR6D1AivAIz2s82Y7dbB?=
 =?us-ascii?Q?Vagv+hZhMA8Yu73Vnn42DlzF/rd3k2WSIabh7pTAHu42GCgXBm2LtLwbIOXd?=
 =?us-ascii?Q?FXucOjoWGur6rsn7GLtn4VRFTXfEF/DCzRgKEH5RzJ3o5etMVQHFuIb64QSy?=
 =?us-ascii?Q?20WHz8EcvBHeEHo3Yx6N3UhTRqJ3kcH0872+jQxbsEvB8INoiG4FVYBGuGrK?=
 =?us-ascii?Q?coa/TVP5R4PrH442s2oJrz5sYSdHgv1zYMFEPtu9UU3HHsm1qYEZlq8Ley0A?=
 =?us-ascii?Q?VCUBcQO2OpHz8xbXPY/RYOqDps252LOmcmVPlJQkLlI0EBUXACwKCQdFWplJ?=
 =?us-ascii?Q?Sbev33uEOEluRtgqDyitN10/Kg4nLfCcu+aaW7XXqHLc3H1l5MJNPW0dw+kZ?=
 =?us-ascii?Q?QuRnkui2GCSqZIBrqOvJrGLNSxgfm80GP7vC7Q4zUwS6ZEbsA2UVc/F9yfWp?=
 =?us-ascii?Q?cojxn0Jc8isyqRSJKQHC3h71Y/s2CCeQloTTxq5QXYwXRyySaoa1xHVLWhXx?=
 =?us-ascii?Q?oJvi4QXnkJrbnSKMSFcvu9et6d3y0ZykzFY5MQE3XTgqf32Q4JdyFQfjL7kv?=
 =?us-ascii?Q?D3u4IRMrCEqyKlb/Ai0TxPsIuX+/Tm4c0mHkKRYQ9uexlkhVg+yC7Uk+GEtd?=
 =?us-ascii?Q?mnRz3U3IXWf83xXqfNW7vTXxZtRxXuxYs8kMadK/JusG6zfT3g46mfJylVVz?=
 =?us-ascii?Q?8E71U8WayVj5O8nFm1v2tQfF7+eYqJM0Wfak//UG1ogSFdsSQ9pJzjcrp0Qo?=
 =?us-ascii?Q?VInl/5lubuVtbUpGAx5xk7zdo6y8UwwSb7PaLhnfnZZ512Du0wDzDxCrQy12?=
 =?us-ascii?Q?iSq0J8881xOiBJDpzSXjMakjlsUMIES+anSmoo5Wpj8fwWe5HpzbtPhydNSe?=
 =?us-ascii?Q?C3Gmr3+0nknbwG8TPiWxePg8Ye39ZQWLyArTrVn1K8L+DYKSU8UsMVl+TMDr?=
 =?us-ascii?Q?sJwQvHlhiKrW1SoZXs6X3NojZbtdnH1IKQAN1T67JyMxowjcX33n9RKb/F0N?=
 =?us-ascii?Q?0I1TXLI6/LiXZVR68WQGrg+9aoUhzmvY4qrcgEWZ63gy9Ijgs9Og0nvY/KsL?=
 =?us-ascii?Q?7WfHJ9odeqVb8VY4vGadQiJf74hUwg21uQvCGCG+Dtjn0ipYK/5kFko4NMjd?=
 =?us-ascii?Q?58/fe8LJY9DM6mAtaHKDJliIFxVwAlEP5R48HXlNv7eFpalqWon1OXr36dPx?=
 =?us-ascii?Q?u+BWB8Pcz5LLT+bxmvMqLvtCi4sgCe/P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CTCMLepPhQB8E2w7AuAFz6Jr5b3ysfdNO3xyzD+VHHUOeTRD1WNCXckH1EHO?=
 =?us-ascii?Q?Oxxvfjba+4snTDGHHgmhazqiLN1XUehNXsZdI/h5WMyFiyCgr2oNL5Q0o+CX?=
 =?us-ascii?Q?HesI73htooqR+/wxw8x1qE0P0CFFgr+WwUh0EyObZNGWaYhb29J9X3LDskmf?=
 =?us-ascii?Q?5X7SXpgrNHImvOeWV0yviJMOIQbl0NiBE3q9Z8USGf5JqK4Zc69NNDygkSYQ?=
 =?us-ascii?Q?IUhXK7H6SMn1m29VQleCVzawv21EUx0R5sp1XUiETg9GTcwLKdEh4aOkfngF?=
 =?us-ascii?Q?tCJVE5ve11SW8+d+HHn2jJ8bKuKfsmUIbrOw15tDaPhGBTbVB/Xi7VB0GOhR?=
 =?us-ascii?Q?exabV5M61KUhezSQXSKpiJj7xUIuWcvQNMMDoIidS5xqVDtmPCv9xCB3eOKu?=
 =?us-ascii?Q?ddIB3heM+43o4CdFLI4ncu/6oclhZmV7ZQs7/ckdX/f1sS/dNLw670h2WoXE?=
 =?us-ascii?Q?0ZbS2W9k1m+11NrMTKqD2EjC8bsqig3JlQGHEFOBTgtVjvXBrBl72crg4Rc7?=
 =?us-ascii?Q?Z8LPYTJod2NQd+KKc3WbyrbvSyfLaji9gRsDdkMQlwrkhZ+SRsKVFaDsTAVL?=
 =?us-ascii?Q?vpQ7KWcePuUQGOASHBhNBZo7WCjHrfrblxue5feIiDzP+xLTVVZpCIqTvqRS?=
 =?us-ascii?Q?r0/amzuEFT5NhxL5iSSJPHVlsJTsUmMTf1ObJNfplvXEJhajfFHtBJQ2fKew?=
 =?us-ascii?Q?UQps6HDyFX1KC9H7DT07cwXqBlgRAB/vPyi9O9QUEc4CB2fk7kKcIEXI0edE?=
 =?us-ascii?Q?7yFfXlegTFpVtrycZbm55HNQ5dKAgT4Ea+4Q2XCvrfQQOfjV9uczTLg+E/5Y?=
 =?us-ascii?Q?9FoA2hQBHTmNWrUwYPnZHXT8L4R3PSoVH1kwb5VLIa1lV9lCUJCCZPE1lxHk?=
 =?us-ascii?Q?L1j6DJSLpq2o7pomoNIBDo/twtLlGuROrDvyNhyVLcOS54/NiHuyP1TNE7eO?=
 =?us-ascii?Q?PDWVrUjJSh/nUpmP5xdQUOH/F6klTbifJOIaRiQCC2ag0/ohIosKq3BHolJG?=
 =?us-ascii?Q?X0wUD8XIrBTrD7C9IJRjomVziTpAY5bMyXqD2K+UevnFS2wvBB+FS9zdwzGP?=
 =?us-ascii?Q?vAwXW52zAPIMh/ZY3e46md8iGGfJvtTcyjwNx9CyumWqA6HnLLALUfkRUti2?=
 =?us-ascii?Q?5VfAWNpgWBtvdePYrBzoEf5WBF9Kj8ZwLrfcUzlegdbt9dO2ZY9VHKvh77Er?=
 =?us-ascii?Q?D0QYVMqhaqkBs65fNiyLoavcHl33dKILPFeh/tAogYPViFZOBsTq4AWj2+h/?=
 =?us-ascii?Q?p8v+yb6R+MGfRziNc3Ad0FeB814/o92HJz4Ye7GjTnuqlwdqwb6E8v9SkwDX?=
 =?us-ascii?Q?KDW4Xy7kSr0135eDHy/kN6ZneUSypSZf/uz3WJZstPLJ1jYxX+8+CjejNwtD?=
 =?us-ascii?Q?gUgKN2QsQwHxI8FkJkcCmpvn1v1I5939F9P3sz0PLbWDNj4PWrIB1gaMcQSp?=
 =?us-ascii?Q?AH3hK8JcouDcA7XkXcCRIMQX4Rq9WBb7316nfCktdbns15qgx+FG7ujW+z05?=
 =?us-ascii?Q?KSRTv3c3V1hMssltQ86Tg/BPIRT1xHGqhKhFQXXRDcIAwdj82MFOGf2GRbrX?=
 =?us-ascii?Q?7BRDCVzLGZCyaLXE4RMsb+cCjsnkNgpBe94emBTsW0Iki3UJKQquHsWAlTQA?=
 =?us-ascii?Q?KSKWi0EnfVp70/REozwLx1aY9MwkPpbp7S36QKCgLJ0B?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dafb282-21db-4434-8b9e-08dd77fe714e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 07:08:06.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djPO5zbwBizllMAK82B9el+pvyHt96Zte/SdEemy1u4mi5WCERaRY7YC2mZNgERL8zTGRYPnDcHSl9xqILEIeQ+/Qh+K+gAYshYO4Ov0px1YEIXQpKwY5R2tSKDL+NMB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6387

It was discovered while trying selftest(smccc_filter) that the
hvc trap is getting forwarded to guest hypervisor even if it is
originated from itself.

HVC traps from guest hypervisor should be handled by the host
hypervisor and traps originating from nested VM should be
forwarded. Adding check to forward only if the hvc is trapped
from the nested VM.

Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 arch/arm64/kvm/handle_exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 80218f62773b..894f92693ed9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -40,8 +40,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
-	if (vcpu_has_nv(vcpu)) {
+	/* Forward hvc instructions to the virtual EL2, if it is from nested VM. */
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
 		if (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_HCD)
 			kvm_inject_undefined(vcpu);
 		else
-- 
2.48.1

