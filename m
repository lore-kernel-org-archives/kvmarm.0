Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2106.outbound.protection.outlook.com [40.107.244.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB3827A920
	for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745858115; cv=fail; b=PdrSAbhtaCkQ69sNwj8zhY/NOaw2Hu9KPOuILQgbOT7bsOg31vQNTab8B3kT64UckDUfVIeH7F8GA/TgJBtefdz3hF/DtAidsZc0IEwKpzgBnHFYIe5Ne0iQJvm0M05ks7KcOjv+cI4KKMaQdVi/EUbKqpQ+PR969OGExrz0UgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745858115; c=relaxed/simple;
	bh=dVr0hu4UzU5WQgDEUMLPoms4Q75HByP28o1qkk3Abu0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=JCyiXmaYgtLN35FtBNl4lWxW+xo/WEHLr+GU8IMAVKEucRKXE/01NKwsEILKSPhwEdzj0DY6tNGM31HJDwOTRiaS6V3s3OUUf7nFmHf9/340NdA23626idSw7HAK93W+PGBvUG0TIK1ARlwiUXB0CECCs89mHFMo/IP3bvU7CeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=FmON2stH; arc=fail smtp.client-ip=40.107.244.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="FmON2stH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9wKl94Ayyoi2UHHEf3hi6eTPzWCA02UR4Pp/LIs+gKFYTzo9bdicHJdPHy0YIlSq8f2yoVqYjkJ8TASl5tjVg5IJIDAJFSWO7HR/uh06sf47dkft0Ke5QnxhWSI9mMc4+zvD/pYsmpjSDThlURnG/+1iNbRYJcpJflsQOqgZOuA6al7fC/SqkfbUxHmK69F0mfjbNQyzIH/bWUimpdaNL0vVP6h8FVd1otGDG+uwPbee1TAiiiEIWaS5HUJFQrjg4bzuE5/ap3/yOzuMNeuuau+vfWL+yu5352m4j0mbZfA8/TN/0OJPcgf7qpGLHLuF1Br9z55ssDios4ARO3FxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjkIbtg2y5NqnJEDS0sWCs62ygjmcvOAJMIhDKGRE/w=;
 b=di80MTYIbTWkfdXIjovFgVy5qblB2hQ6HkAV6cUQ91MyVzT/A/KV6RKSYBi/aGZE6D0Pm/22Q92CUnYQr+ezj9UpW4ylDEDtU/kHHTip2QMHmbBpwwb0jxHwCwh4UYU/Q7BDEkoXn0ub5H9qsNLCoWJYnmPgXl9qJy0NECbZ6hgGinFVzgDLyRtKHzw34WMYRlkokkbfdwSHw9vTNKg9e/ZX5ODkdWpqyHdkQ/tg6P+g6TDmkczgNA8dM32155HwNxi+FElFWp9WQpNIp5wq9HdnJ3wwNJ/GMYbQq52g1HGIB1xj9hlhxu8GOG2qf/XQQBrRJirOxpiOnCQLvgjlQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjkIbtg2y5NqnJEDS0sWCs62ygjmcvOAJMIhDKGRE/w=;
 b=FmON2stHDEOdYmIz3O/9RKIfUL6NZFcSADafNjdLNlBVv+zpPR1FYWbVGMhN/GFO/ODYddwA0CG+vwHXLESoc3C8+ylcoRF55B53CShW/dTaDdiNfQHiulx99ZvrlSCR1Wa3sjqHl+rXVRTBgXPlcMJi7woVSY/V6cTsZ3tB+uw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 IA0PR01MB8379.prod.exchangelabs.com (2603:10b6:208:485::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.34; Mon, 28 Apr 2025 16:35:08 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8678.025; Mon, 28 Apr 2025
 16:35:08 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, James Clark
 <james.clark@linaro.org>, James Morse <james.morse@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, "Rob Herring (Arm)" <robh@kernel.org>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Shiqi Liu
 <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>, Yicong Yang
 <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm64: errata: Work around AmpereOne's erratum
 AC03_CPU_36
In-Reply-To: <86frhtkd6r.wl-maz@kernel.org>
References: <20250415154711.1698544-1-scott@os.amperecomputing.com>
 <86wmbkk1yz.wl-maz@kernel.org>
 <86frhx9ex6.fsf@scott-ph-mail.amperecomputing.com>
 <86frhtkd6r.wl-maz@kernel.org>
Date: Mon, 28 Apr 2025 09:35:03 -0700
Message-ID: <86cycw9rd4.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:303:83::21) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|IA0PR01MB8379:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bba714-511d-48ad-9577-08dd8672a353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|52116014|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JfpFoUl8ezzFLG0YOo78b9GkL12N5/79KydZDZA1JzpZhYnHudtnKYQdp8oU?=
 =?us-ascii?Q?Ye9bSas0c2MpBIJrekJz3EBck9TSVjQzrgW2d6biWmu3wGhQOX0hbpjzoLc7?=
 =?us-ascii?Q?UBgUopHD+c5DhMTfn7qyqAlrSfmc2soQgMU80bwT16guG2hKRr7jJcH5+JHS?=
 =?us-ascii?Q?fdw/wohQvV68Pc+A61nuSqgXO3KYxF4dw9OMQUPgTZfyfqYPTyx6iEtHyYMX?=
 =?us-ascii?Q?3ZxlLi1qFCV3eLjE/V5sCOuFrf0CGfi9ypioLG4imaCvp5p/FjraRk63Z6TT?=
 =?us-ascii?Q?GIJb+BSwZs7YW2f81D1T82hEpNr4qxhZp3WmNdnc1qKUOLz88oc1C8GV6c26?=
 =?us-ascii?Q?fDC9xF3vHT6PMo5HHAhUZFdzRU5z+5t1/YcqpMkdyIS69NtkLnXpRXPBN6BB?=
 =?us-ascii?Q?W9J1EemtMB81UK9KB1fPGQQovifcIgLbrnjDzAKuDBvsWxwYz1D2R/ohqjmU?=
 =?us-ascii?Q?28wfz/1BEh5R0g+QnAErw6BacF3uHRAO7v65pPdJKgkPxiud9LbEh66iLlvk?=
 =?us-ascii?Q?aH2cUC80lTkg17grb/byc+QED5qu6nQ/XRnlqCRPiGbgjL1affTkdHrNtx7o?=
 =?us-ascii?Q?YqzZb3bgu5OMjPOnoNFo1tNHgn7wiLT9LBH6SrCcYiBkGRSNXjn+u9HJEKeh?=
 =?us-ascii?Q?vDE8h0JpA735U/93ER48m44yfIOB3HbRHGluqdIUl0BtYn5QWLAZqsIWfuxm?=
 =?us-ascii?Q?Jt4gaBhUnvrog4Uj7mCXk+5q+/uUWncM0PuaRPt6tmvSfjOUMM16RMPf8z1D?=
 =?us-ascii?Q?dqsbi/cIzobOECTmiJp20duBDTjFDUUcXGlv+/CaaNTnuEdCcqbNAeFS1PSU?=
 =?us-ascii?Q?DcgEkFUdofg2h/lb3QFvbuWASZEz6ZDrLhhO56xT+Z+lo8VaRFFEARnSggRJ?=
 =?us-ascii?Q?jeLstteiancLO99epqiCHzBvieSeA2uAiKLRrDRDhRhnV5JqaH8O9RlbOUuF?=
 =?us-ascii?Q?eS0ya1LqK00Mo5+WXZDKns+IFKHSWPDYAzOFDJVfCRj1usEu1iPpNzVd818C?=
 =?us-ascii?Q?cpzgPpGbaJkodZ9YKr31jSuG/D4D00Yj9h9V65RKrBSV+wdvHad89zNtGjZ2?=
 =?us-ascii?Q?1NpAu5AfB/Mf8gP3YoMdQkupBQaE4snNkZZiGxDD335QSfucZCx6ugrwcdxF?=
 =?us-ascii?Q?ogmD7aSGOEpwKeOPIEoZnbk+CbCZIqG1J2OG0Eb1wlcJdnjCZq5h6hrxe8CF?=
 =?us-ascii?Q?aegSm1ewQFXkvN6lXwc0F3E+zzkY/foMcgZOBIOBnedr3OEN44Lxl5HY7l+4?=
 =?us-ascii?Q?QOED4MSOVNmHwz9zOzYcVt/il1rePt20/iV1lbK/R7lR7e5FwCRKk/B2pwgR?=
 =?us-ascii?Q?cCzGh5WQDHex3Ij/4bFML1lDHtYlU5dVHRYe23z30AoWYee9xy+kqpKWZc4u?=
 =?us-ascii?Q?MW+Zx41xtRzSEcygWjqjGVveDxSI1YuJMxxHN5Z9E1B+6Qu7aFduR+ZZq6Qr?=
 =?us-ascii?Q?cv8Ub4kD6U59DNo9QQXXH632uNi4kV8QrqlE5GTB1yWkrIaP8WGEsg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(52116014)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OMW7rJOK/ohIB4jhnOwKIZT0k0UcmQ91tTVN5YD1vX3EtVfvFjcXqBUVOgfX?=
 =?us-ascii?Q?cF/KKdNd+FiQNtY+W7l6koQ/KjGyVd0gtk9lQ1/chjt8jXV5FD20RUB1GqFN?=
 =?us-ascii?Q?rpHqUF8r0IWjttk3M0VPvpkh027/l2knrmFJPGHR2A1QQBpS+cx2pHnerlut?=
 =?us-ascii?Q?wCjPNhpMMU3Xqhp/y4qWGiN4WesYW2uVaxSq/r0uDcQFKy59N1/J2I0WmQQs?=
 =?us-ascii?Q?ZWcB0tc9Lc4oEgjpX8bskTFjH5hg6Unr36gRDIjUFudysUDDvWv2nn/NWoc/?=
 =?us-ascii?Q?6V920dpI1+HGMt1PXoUxPFcQpcnuQeMnyRCzdrWr7YMalLiq1u9S4q4MOHIu?=
 =?us-ascii?Q?FfKA16gF9pNEBpBXbidf/0I7m/dMnfEm3gx9tj46r/9aJyIKn0cqL86Nc6jM?=
 =?us-ascii?Q?tOQ0kSKyJ0GP3TXaf0DLNpMWR6mYS8xFW26JO6uyuyKAuIkDiXFgA0cfqPEc?=
 =?us-ascii?Q?7OZv5NW52je56e8Tr5cQixK9T1m0FXSM6SQ7TuWURrzIh5bsx2u4yuAiUPIB?=
 =?us-ascii?Q?vX+Ldnwy43mj1Sxb72HFeYGYJK71YqGLA2P+B9Fqq6FSldWx0zLYvwpJtxTM?=
 =?us-ascii?Q?ln1eUZY0e2UyasPV5qxK/OBl3awoQsXgFj/SjW/X/+Sn4aQ8HzccblvNchUM?=
 =?us-ascii?Q?E028klyNbWwYfEaV8BVODWlabOZHINIrmb2gIIxONKVkNecswlP55Y35EkRN?=
 =?us-ascii?Q?18TCdUB9/QZur0QugAE8V9JIaRhTYnwbJm5zv3k1j0KNn4euaYgBbUDAvlEc?=
 =?us-ascii?Q?iP1r7IAaYa6onyINaZgp0aHlh2nqKREulJA9Ui7NSk7QPWpdHmrdWEJzk987?=
 =?us-ascii?Q?3eYqGW41yoS6Khg0r+uchQJAYLFvOUbIqquaE2C1wW3R1Q/m09zcQ/48dOgm?=
 =?us-ascii?Q?lldrYGdGt/bYagtHtAvKfcPqpO47N6+GLLgbdpXoKyjOJbModLLOJOvZakos?=
 =?us-ascii?Q?PR68QsyxCkI9V7w0MypTRZvt0sejuSKe3I0CjOVTP7+MFDZsOMe7wGb0QI7v?=
 =?us-ascii?Q?2PP67iO+jxDJrknhIzTJDAVSDFXeMLHdEaBdHvhv1a3QQ1S/qLnGkdThbYeM?=
 =?us-ascii?Q?/Ve/+J2BvCjsgMLq8/f5kK014T0A2DCd/4uwYvBWRRG1A7Tb0JGS7oIb8qlh?=
 =?us-ascii?Q?iDZ8xaNYzm4VEwNcxqbn9Lc23mX1x2KeFvm3DkXxe5Q29PwZ/0lGLVFanFiC?=
 =?us-ascii?Q?pSkZHynAwkzFl9VufmdtEykbidDm/Wlkm5V6VaHj05/yceGoUec/t9XaTecW?=
 =?us-ascii?Q?Pdus7bkd8cPXb6V7lPmnOBinjjZXytb1zydljNYd+KprSI90onSwYUy8rEQB?=
 =?us-ascii?Q?mmMLo2/Oh+tNpzFNxY/tOuxvU5j+DhC15QwxWS/Dp6hXU0KRSLw75PMS52pf?=
 =?us-ascii?Q?q7w6ywKiSWHGAUzURG45Kb4WLhHWpKuSYkZvvUx4pMW+y0tEiw43pDlTqe70?=
 =?us-ascii?Q?zJTiwsEKbW+sYARtCJZqzLd1PprT0oQLvB0sm9WMPY9damv45d1Vete4x3XL?=
 =?us-ascii?Q?daQu0pCozKmyDIFn0+/0BYP0hq0eHw6BBgeJHB7jumjCPHiyhTSeEQFu2aIT?=
 =?us-ascii?Q?vWWdZZq6sYm/HuT8FlR39VtG5DxoyxNCmarQvxugESzTS8jsaaD5g277nA4+?=
 =?us-ascii?Q?gNW03oNfsOGoLjCR0+rn/W4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bba714-511d-48ad-9577-08dd8672a353
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 16:35:08.4416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcCpyIm9Z4M5x9o53eaB73qx9s12zfa/7sBsXPP9EeLOOPiAZsNJmKfDLxLJM5Sgv3zm5TCdxg1AZkOz+iwBm5SEsrzYZr7JQKz0w5N75IRljvmokaruy6h3pirmU+Ge
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR01MB8379

Marc Zyngier <maz@kernel.org> writes:

> On Fri, 25 Apr 2025 03:02:29 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>> > On Tue, 15 Apr 2025 16:47:10 +0100,
>> > D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> >> 
>> >> AC03_CPU_36 can cause asynchronous exceptions to be routed to the wrong
>> >> exception level if an async exception coincides with an update to the
>> >> controls for the target exception level in HCR_EL2. On affected
>> >> machines, always do writes to HCR_EL2 with async exceptions blocked.
>> >
>> > From the actual errata document [1]:
>> >
>> > <quote>
>> > If an Asynchronous Exception to EL2 occurs, while EL2 software is
>> > changing the EL2 exception control bits from a configuration where
>> > asynchronous exceptions are routed to EL2 to a configuration where
>> > asynchronous exceptions are routed to EL1, the processor may exhibit
>> > the incorrect exception behavior of routing an interrupt taken at EL2
>> > to EL1.  The affected system register is HCR_EL2, which contains
>> > control bits for routing and enabling of EL2 exceptions.
>> > </quote>
>> >
>> > My reading is that things can go wrong when clearing the xMO bits.
>> >
>> > I don't think we need to touch the xMO bits at all when running
>> > VHE. So my preference would be to:
>> >
>> > - simply leave the xMO bits set at all times (nothing bad can happen
>> >   from that, can it?)
>> >
>> > - prevent these systems from using anything but VHE (and fail KVM init
>> >   otherwise)
>> 
>> Hi Marc, I started writing up this patch and then realized that the
>> issue can also not happen in nvhe mode. While xMO bits are modified
>> there, async exceptions are always masked and so the "simultaneously
>> take an async exception" part of the erratum can't happen.
>> 
>> Does that sound right to you, or are there cases that I'm missing. If
>> it's right the nvhe is also can't hit the erratum case, then what do you
>> think is the right thing for me to do here?
>
> That's an interesting point. We always run the nVHE/hVHE hypervisor
> code with interrupts disabled by virtue of taking an HVC exception
> into EL2, so that particular case seems OK as it literally implements
> the proposed workaround.
>
> However, there's at least one catch: the SError handling code in
> hyp/entry.S relies on clearing PSTATE.A to take a pending abort (the
> so-called VAXorcism). I take that this CPU implements FEAT_RAS, and
> that we don't need to worry about this code path either, and that the
> erratum cannot trigger on speculatively executed paths?

Yep, right on both counts, the cpu supports FEAT_RAS, and the erratum
case doesn't happen speculatively.

> If we're OK with that, then I don't think there is much to do, other
> than always setting the xMO bits at all times, for which I already
> have a patch in review (v2 coming shortly).

OK, sounds good to me.
