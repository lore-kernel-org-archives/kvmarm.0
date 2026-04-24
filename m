Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022113.outbound.protection.outlook.com [40.107.209.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446740DFA3
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 00:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988972; cv=fail; b=ArwA3zpTrNC6zTNikPRXd4xEw4B0pcqUN8JmDFVtltfdwoOvL5lWsFRGpPjXlzM2/quFEPN5anVECMXqp9mFwm7hcJEbxPLt18KVeR2se6WV1TPwaSGspiL3LAsieb1GuSCloN//xyclpk/Bcs4ehgooSjaI+yE9QNvbnCz4cl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988972; c=relaxed/simple;
	bh=ncYc6nGuKX09CqW3KqIpp0tuRI5q149yiNS4IST4LEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KvuXgbHzBMTMqeVDE9uX1vHe4ElQMqVQYSI6PfyW5M5e/56n0FVBiU5L+huZpBvm4JbSWzjQ5LjAJPTjV6BUs//kNdqEqeLoxA61xMMDI95Swz0MLYnFfTARO/KVt7nMTZuarewvEyAUnxigipvr85RI0+oIjO90uuoEjUwsnhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=eQNWBZsx; arc=fail smtp.client-ip=40.107.209.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="eQNWBZsx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IfO1doebXE9572cHN2RzujjtF4rm0mb//MTzbWf/3zFoqpTE1JoA6uuFWo4o1pOlSQsIDL+rl8onED9UU9eMgccmNlD+HudQWaH2YZQ8xOefdc6lk0U9Sn/bc/ntUJ6z3drEmDwc2L2kDTpL8qNojh8sgEyMg7Hnl/AwUmwaL6FmPvAMtSCmfD2gbrZYkGmf3jugb0uUwati3uG7erfkk+aYs5rxUbmgUZ0cDMV+s/WYEaz2HlVMDdFGqeg66KwZ4efeCYqDqJlrt2Y2y3ECJqvLMk7OKlxT1dwNQganruaVtIOJ1n8NIFETr8WE3hGEsQd5YUO/EDCJfIehwUbGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfp1wl6y0LsXP3f29TYrxkQRy4kI0cCqR1p6wUW5ULI=;
 b=bkK4WFcKvD8vpqDAkD43iAkUndpYsnPXybSboOmBjivwnWo12cH0VWJGjam38wTOOb47p7sagQAn97Z4EsHSlx509uHYh+ZSLlXc6/7u/4zjaTENT3aVPxOE9Fva6dq3LmiEJGDVFu8KyJgb6bRSIQ2WHvocvxRAFPc6pr9F+71Eo4eiW5Ar0g9vkIutxg6fNuQGLFEz5NUnLhm96Cpbn85B6KBx0Jeip3rT7Yedznt3TG5u+sxzyFu/iigdFPLYMBUnFxnwEADgXdVTbXPsygsE2zv7WesdxVWQ4kbCbjfbyXs2Y0VdeIE0/5XK88XOB0KRHtD2lf2j2ioKWj3/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfp1wl6y0LsXP3f29TYrxkQRy4kI0cCqR1p6wUW5ULI=;
 b=eQNWBZsxiiwNf6VUWShJ9SOShH5M3p4IpSOCKVL8rQyZhLu7Uyydl4lKrdczqC5qxljsYPZBGUuttLM2dPkv6Qx3MAkaGcGQBW+sEbAnvLyiZiiGuN2bLnxok8CIZvv+qGWglZXX5FVTs5eKmKSCoCLmFK/os3MqQkU3PvQzi3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA3PR01MB7917.prod.exchangelabs.com (2603:10b6:806:314::11) by
 PH7PR01MB7607.prod.exchangelabs.com (2603:10b6:510:1d2::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.19; Fri, 24 Apr 2026 00:02:43 +0000
Received: from SA3PR01MB7917.prod.exchangelabs.com
 ([fe80::fef2:9b37:9ea:31d1]) by SA3PR01MB7917.prod.exchangelabs.com
 ([fe80::fef2:9b37:9ea:31d1%5]) with mapi id 15.20.9846.019; Fri, 24 Apr 2026
 00:02:43 +0000
Date: Thu, 23 Apr 2026 17:02:40 -0700
From: Darren Hart <darren@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vishnu Pajjuri <vishnu@os.amperecomputing.com>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Mark Brown <broonie@kernel.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into
 deactivation primitive
Message-ID: <aeqzIIT2n86CxB-T@Fedora>
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-36-maz@kernel.org>
 <2e12c5c2-a1b6-47b7-b54c-7281a77bbe0a@os.amperecomputing.com>
 <878qb9cxzr.wl-maz@kernel.org>
 <1e050b67-2276-41ad-9265-796ba853dc7c@os.amperecomputing.com>
 <86a4vo49ni.wl-maz@kernel.org>
 <86eck71o1v.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86eck71o1v.wl-maz@kernel.org>
X-ClientProxiedBy: MW4PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:303:b6::9) To SA3PR01MB7917.prod.exchangelabs.com
 (2603:10b6:806:314::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR01MB7917:EE_|PH7PR01MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: a54cf18d-f2e0-4eaf-156f-08dea194ce86
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	8KmGi6zjA0VSWlZ64b5hZJnexvUf08NyKtnLVjj8cgQ2atUU6wlQVRn1NsEHMJeoxfhLeDTfnStyOmpIt5hHJsH9kp8GnvE6lu2PxKUfRjxrYIhPUB8CD8EalhC+OFMbHKO7zgmOKSBTa8tXQgg0p6W4Alr/nVKzK570A5ozYWwH78FDf3LT73mXBU0tCWv2PklelSOjFDKpIi5Xyg7oGK4S1M+8Ub5qL0F6k/A0TZYmrMsmqa0STi6gUvw+TIkFUkW852l/ew9wv4024X7oDo9bVBH8qyKUYk4kBFZXroQwMMpHcnF8Xf8DJvnuqFEQvAduKLeabVWrR1MC1rDq1d03A6BLdNIfFrch0sZTN1Kp6XwWvQHyV5jiACKLAGUgGwElAO8NK6NQ8cmcwZYRqHx6jLSfbG91tkJeEijfhGG3GmVZJouY+LRYxD/yuD4QXxYPrMDorNAOhu/5memK2EVTJ9ILCru/kfCX1L1a3JvTpGlSymdWJQQKEJlvevHzSb2dtWuZ+Uzek3YgDxPYHe7hwCoIC7pjh0JQPnpyAcP8SsF2U9gruQ/xw+LipUTshdpyQpXVnGQsA2PiyNdCcu+5X4EV4f1uRji8ES6ZYyzKEvN5BtU/B+dsXsUTB9J22vd5CQOALTcyEcRBpW/5ZrSjzt9PP/Mblzze0BQxHgZUzICeinqOQX0t95cuyWaKG8im7wIYLXyScuNQ0mQo/8sse3XdblJIv5clb9OGWx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR01MB7917.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k7JE9ZxSwsAqxJgx079eRQbs91y5fMY8rOhyGhlmeuwMYfK8yEOCXBVHnTws?=
 =?us-ascii?Q?iSzKLtXTOdZJR1q6zBOjz4VV7PhFGrF5DPsSminXECH+8n2f/pYeygjc0i7f?=
 =?us-ascii?Q?zUVvORcUBF0/QlLtoyaxUfccvkUJcum0vqgrhtCaYUaxwZ9Ys/r73JVaKF++?=
 =?us-ascii?Q?fFRt7FZenRp706/TBX+7w0KTernlKDT91B/teAHJv1a+ZlP9Ccoaad/anjSM?=
 =?us-ascii?Q?322MJgD0Fc1BHwrHj1rHbXZQuk1/FnsvHpaAcag1zY/yywqLWjVKBcoZNzJS?=
 =?us-ascii?Q?Dy9NGiXixjYz6EHZAucP0cs+YNEiyzlJQRzMmLRuTq7vYgpy8V1YslUbmlAa?=
 =?us-ascii?Q?u2oMZPNAWRiVIExCAhNM2gxkfRAxhK9OQ98aGeF7DeG+mPKqCrl1bS06b90p?=
 =?us-ascii?Q?SrSYr2h6IdgiKPErqqoxhJzT4A0TJ8vjOg8U+aboiVWESpceDsmAdjwQgUHl?=
 =?us-ascii?Q?HlZB6f3CEpwT4moVqOEqTBGzX9Dm2wf6d1KXt0hewIo4YJpcTEoFIFD5mdef?=
 =?us-ascii?Q?y148PY3Zi3yOPNjNFes6wi7nezPI5Jm0uXvI6IrmmYDcmIBq3b/k5XKYQeyX?=
 =?us-ascii?Q?Q1TVXzQzOhmnABKEVv4Z1edd/muaZPIxIZQnLJkLNx2rBk5aQYTCCXrUCLFH?=
 =?us-ascii?Q?Cxm2rXTqFFAqxXo1wNbpLBOQ5PXzF4Dm6xpa2UlxXN99bi76N3WVCni8D9sI?=
 =?us-ascii?Q?OHMw3nxz/h2otKxsnHiVFlynd0i4tN4fGSuifYvEIKAC2JGzhkzLJ0UPDdBk?=
 =?us-ascii?Q?hTMgVTqAesf5Syexy2bVz9VKuCD7EE2ZcCHJvswiX7ebe6Wq7r0EYH5SWWLa?=
 =?us-ascii?Q?dQcQtJemXDwZ6u6DtSeYBiWETVdhq48g5ejs3fnLAyyyA7sRRg/eN+cEqMec?=
 =?us-ascii?Q?ClSPsduz9Pk/A2RMSU5Ozz5eVEDRpTUnyZHPviM6VaSZBOl4Ij3uZE7n2GBU?=
 =?us-ascii?Q?2drvxueR9kf68GQf4oSinD/artq75HlmTWboO0fG0i9q37+9UO9jsu/63WnT?=
 =?us-ascii?Q?ITCYVifPvPyhmjwnnAr3Z+/sFgq50mfAnUcSZKY2JcsYEreAXvHPzduT1hwy?=
 =?us-ascii?Q?dmJjeM59EgkLiNGucz++wEGlk/r0j3EeagQ3Rj/ZCWFUBLJ612d6vScDfREY?=
 =?us-ascii?Q?/FYXKW+xQnG913oI3hABrDvMtdywcrz6pkJ+SLWRoKU+efLhspVi58Uclbes?=
 =?us-ascii?Q?bu6IoNqN6ZFfavbWbxQTY3WtQ/to9QqsQw4m5Bk63dLpAXEjR5GKRJWuOQT5?=
 =?us-ascii?Q?WWJGX2U+6VaIHVhxAxgimM+lLU48N0CSeBF7ZGbNpH28YrRmtpgBdG6AGMew?=
 =?us-ascii?Q?C1R0T8tdReswfcj3yZh8wg5969lLGbG/QUbwTXZYTBhim92qLytqdqczV3VD?=
 =?us-ascii?Q?2B9tuk0A+cpMgb6ba6bhSRw0zM4aPykuNM3tMuOLQ3m6AtdhRj4LRjMGL/c+?=
 =?us-ascii?Q?sJ1XfStzmC/Ik+hbWfnOXret4sd8LnYxDtnnXO0V2obBfXJ6T96fvmIOgeqY?=
 =?us-ascii?Q?piHCmTx7hWzpuq2cnUfmNSbflI/cK/+X33ne2u3HoQ8mAacsDIcQBV8tD1Wo?=
 =?us-ascii?Q?P/A7khB5txASUyBVbQW8hE6+OrlWWxqPAJK6Qao4v++QieazYyga9b11jIEf?=
 =?us-ascii?Q?OvgddgMlWgGqzx6VoVPpocqjq9dj1gZ55B8vnPcvUBu9/mcrmiewVWxqijpw?=
 =?us-ascii?Q?htBsvz+SAchxQ4q53qPe/8yfWWVBGZnzWOt0+pGRrcKCy6QsHgkzQqafcSmW?=
 =?us-ascii?Q?GwHtKVA447jH1S2vfT1KrhDkGRHM2jUnAQ1iS7jiEPKQ2sU1DmEv?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54cf18d-f2e0-4eaf-156f-08dea194ce86
X-MS-Exchange-CrossTenant-AuthSource: SA3PR01MB7917.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 00:02:43.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdcsoEg1Yoje1fA9Kkz9/EfZ4kzi4LB3qEtlSX1SgLPHYWM4VrQs3ezDvthezHd/WL8H/ooBdJOIjCujL1g0n6kyt5wztYMzHG4ttMrWA4lyKMP47aA8C+j0l9Y4W3cz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB7607

On Wed, Apr 22, 2026 at 07:55:56AM +0100, Marc Zyngier wrote:
> [+ Darren]
> 

Thanks for the head's up Marc. 

> On Tue, 31 Mar 2026 10:42:57 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > > 

...

> > > Although this behavior is puzzling, it matches the trace I typically
> > > observe on L0. After reverting the patch, I was able to boot L2 guests
> > > successfully.
> > 
> > Well, this patch fixes real bugs, so it isn't going anywhere.

Understood.

> 
> Have you made progress on this? I can't reproduce it at all despite my
> best effort. I'm perfectly happy to help, but you need to give me
> *something* to go on.
> 

I didn't give this the attention it deserved. I've now got Vishnu the
resources he needs to help move this forward. We owe you something
concrete/actionable/reproducible and we'll report back once we have it.

-- 
Darren Hart
Ampere Computing / Linux Enabling
