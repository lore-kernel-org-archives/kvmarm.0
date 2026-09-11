Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E16D4AEBC7;
	Fri, 11 Sep 2026 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151191; cv=fail; b=HHGXu33Q7KdESv9fs7JC3Ogoq3Brrbzkt/HxYo7Ji8WIpf+4+g4zc3486Y9q8pZ0ATZb4xZFb7fuB9HSy1moNQKMEqQZ7Kn/Of3vlQ+ONfAWdJjV+J4sVeTLh2EyUttmoEcQKNHLpw202t3MdFXW3uP2J73Y6QVclTTXojW54nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151191; c=relaxed/simple;
	bh=/SHhAsa7lIR8IYSX06C9u59VChPNTvf7/tK3OIetCNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dB+C0e/X3InddSVJDJj02LxnhZm2Me3/DO47pJNhM+9GKKiiatfnD1TjgukAXAif6oGCHnWd3yBOKAML+GB6Ws+OC+HVRNOlQHtqnRLAaa+fLSo+6PiTYEvZD9pT3hpjM0sPvn3HZ6DZO+tseRQurtVGWazXV5raLHM52chxPEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dt95SPf4; arc=fail smtp.client-ip=52.101.52.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dt95SPf4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkfVsPBbQip6rpJChrreAmrkwdUe1fdtSI2CMcryfEPtthJ00toP1Zh30WctfmCEU5ZOK2XjJPo3XSi5+XqJoGY2l2Zr5hU55MQ29YeCpSFTN9gF8crpvy/eEYBNXVRym7RifAsU5EG8pgBoJ2tYPjlW/vEBv0WfVpVYIJivrP9uu9fU1wgiefGn/H0ZKCQK6x9Mv7HXjm9P3fArb6xbbomvSicOSKQZ2q5j/TFlyRRk+ZGmWKXtb+9TNdRmKxL7kyf1aiDvuJcNrdN1PdqWbGbOJeGTcwHq9m+y/07pnOF9vFBMKNbDkmw0DMpTR8Y4MOR8MB3UObFSi9dAetXIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LMRtlUR7sTdG76/BNIXgqLjAi2QN6gfhfMxJdpzKhxA=;
 b=OT/ycauYXu4LUvWXgn0/tRpX9K8O2m+ofxXm0qqGEZVsionY2y4WlgbW+NH7uSKs9qJQoLHqx390WcmHs6xccPsDJlp7dexyDc8xvfJFZ1LSBElbpzpJa/0eV6Wr1KRocxYTHEQWijMwI6h9eDa/NHOyvMaVawM01OFQ1G0DdNp9XxBilhPx3SWVl1aj06qwroumGIN6OEfiM11ebBbmsBQxpXtz8JZMrYQ9L/ON6pjkO5mPwe9BuiOLkyyou/7Gz7aqwU7HuAt4GWw90Tn1XGODiEufs9dI0RYdCLGAYlvn6Ai+k+8ggB42TN8Q5Uns6oDkMe8/1i4VklGVq2larA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRtlUR7sTdG76/BNIXgqLjAi2QN6gfhfMxJdpzKhxA=;
 b=Dt95SPf4qj4IgwYKyKRnLtoEJU8HxZ9AidymuxIxWDhyORKD3oZbq4lnI2O9AJTCFwqLL+4qFLr4fLs17wA/f6u/I7LdOZJoHFzseaOLtygdqNP4ZNne6gIUjF1SD+BdaR9IWbKTJNUX3LfpmmL1jwAwtbJuxnWf4/NNIpSGUYVDXDWge/nDVELCwqcQJaAe1HyXcZvw7ucR3nduPIo6a1TP4d8eZ5z80w+NGx+yTCbNSUG0Sa3CrxEuM6Y2zqizm+Cu8kNvGynKBfi44AL2eibHy2kmc6UmlGH1Iin7CrTB49BGcdVtYP0T/yArfYP+2gXru4PAS2Qjt5YUZw5Zng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BL3PR12MB6401.namprd12.prod.outlook.com
 (2603:10b6:208:3b1::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 18:26:13 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 18:26:13 +0000
Date: Fri, 11 Sep 2026 15:26:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, maz@kernel.org,
	oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org,
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <20260911182612.GK3968357@nvidia.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
 <a3c2d0f6-a7b5-4344-b837-434aeac5dbc0@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c2d0f6-a7b5-4344-b837-434aeac5dbc0@redhat.com>
X-ClientProxiedBy: YT4PR01CA0122.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::13) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BL3PR12MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: b5d33c9a-8abf-494a-227c-08df103228f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|18002099003|22082099003|3023799007|10067099003|5023799004|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Fd58NVEkaYYab7sm/5nz/kjdl/HOVcpsGGNZyUJT/MIVL0RkQEmpmmQUVRdwRTPOR8cZkVGLQ5JAeyIpp1T/A6ZZY6qxYu9kdA6TdNAAJiko+sSQAhLi1xBBDL4VJc/uXudWvMVgwdIywyBCkp1VpASaH6oGNEBO93jJBOOY0abg/rczSr0k3b/3vY8OVEedQkKvr6J7KqHFxmWlGhzyMmhtuj6hDKJHun8H963iX/H2uzL4nLr1X0ZPgtxhJPKvCkYVCajl6dLtYrE6Ncws9sYk2MzeeqQcNH8IEQhAdz068OztosQjn0vl5jkjz5M8+TdVD5+aGOyudb0xk2YuYh+kJTt8gbAR8abAoJrDck5GRCPilNEmN3liNpJDIJ/XiknQ8reBWs6kxXgRDvvHMHeGO61pTOyWPx04LFD3P/bjGpBIlfxm6/OS45aAUN0o+9DVXZRJAj8O8m0iKmj5xqCxy2t7F/z4g5UiU4rHe3lDtVA6DrMq3AEwAklWlQbTb/kpg8pYdrcnLyQ0fAeRe8PPX8OIjUqQrGfLszu4DwDy8w799waUFaXmWsPFZMWu2kULnoBfNOKqUxA8XD58r95n4vodyQIQRHEsHCKskeqwr8YmatABgqvlWCHWWURUK258f4YJC9pTVt3Ugp1BmwDD5NveKeAHyFpyGji0Tpg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(18002099003)(22082099003)(3023799007)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N7REO+16Fir73RvcGyKMFm7GqOJZe2m3rzU1/aocxo6KCaFYcpuhdlQaokrF?=
 =?us-ascii?Q?E/ozWD+yRlqxP0XMcP+CFy3a3X0Zle1AHtEuynfPMwOG/CeV5hT9i3TWkA3A?=
 =?us-ascii?Q?rC7igiGVMcCtH6gkVxi6hRPUgqy2qmo94PuvOfX91w2kgwBHa2x917WoxYpt?=
 =?us-ascii?Q?vREx6WZYkimEEClDWYXLWBnjwmBsBD+Grq3iipi2h640qal7S2TscBJX4g5m?=
 =?us-ascii?Q?Bq03bx2Htwt39K2MkUaNOSzsRpMFUWsg6lo3QCjnseywXmoJQVAj5ABWG289?=
 =?us-ascii?Q?VLk+4zCKhvU2zRItL+gcQSASdM5JK0nVUg9Cm3u9twkkCTveP1Rp1LgB7hJA?=
 =?us-ascii?Q?kLLYtYysy51Ktw2ZDlPbKbQpsCVHe63/3dbpaMLxKuUcSZwclEWUU7G0C7Fq?=
 =?us-ascii?Q?LrlrbjMgMEKA0RW3cQy1sHmjPfeTVm78zTiTCGoMidoEKupkAW2pVp/hsfJi?=
 =?us-ascii?Q?oLZ9rHgEc9LzI7Ef5+/6tZhInJK7y2JkN1NGw3LzO/7iiWD2+E5m5gDdqAgg?=
 =?us-ascii?Q?QAq70YnpaCikJ2EvPeS5Vv6qky/YIMUfz6G+cuoJ7G4FaJwAbqs3q/QnK8K3?=
 =?us-ascii?Q?ChOILjKTbW/r1OLCUnuuCHv1LGYPD/5fqkZwCR88AppYhts7iBWXsWVgm8R5?=
 =?us-ascii?Q?jwFVxXqOb8/ABY6NshfqsQML6aWMd2JIc07zRflUCEZme2/n9uCAFU0MGa/S?=
 =?us-ascii?Q?4Mc2yO5XQKqSFqWKdyQm/72NYvTLEq8O6VL3oHhjMVxy+fsGsrtdKBHxqEIx?=
 =?us-ascii?Q?88GzCHHxX2Xi9dXkz1bA32AR7ErQoq5S24gtnQe+xrTDSNODBqk9gQq/08V8?=
 =?us-ascii?Q?3kg4UpV4NebcFzesPzl+aZz8i4TAfTIwJKVNm1p1VNo/tfzxdda+Ccp3MkVT?=
 =?us-ascii?Q?dEcRpLViH4z2JS7gSDpVbEn031hMYAswM7SZYZ8PIJgIWsS8SM+Za8Mr2smr?=
 =?us-ascii?Q?EGvA4oXbXm5ZVsmWeixT1SBnStlmZm9rqn4WPxn5BAmt20S6ohJ3KRRooGsx?=
 =?us-ascii?Q?rJB1S/1OcYeyOhiq2y3HlJ1ARe3f+n3Ag0PQuRFDuUyq8wlcpbmbf668l0c2?=
 =?us-ascii?Q?Erk4lQQ10IXPwcBF7axY8Epw2fcw36hd2p8mtF8JC6x6TQU3cWNJE9pIVdg2?=
 =?us-ascii?Q?Ao0RP1Gvg+asyUldyEJODnzmPa+MGC9njJ/49g8uA68vWYHsVswymTfNypwR?=
 =?us-ascii?Q?KuiGrbtvspr9nbYGiMxfhiJRQ2q3e3J4Z2H9bXX6XiSfmAB10CS6r0/k0WQq?=
 =?us-ascii?Q?hHPHZiCCBWFv6aCsP9Jh2D4tQ9HAKfYOzfxqwby+0ou1ee4P8j8QULhpnItj?=
 =?us-ascii?Q?e+XAG5xXV+c1HEVBaqfbRF0qqGanG7VRuRevjhD7i21uuhYSJwFpct0WGS+i?=
 =?us-ascii?Q?5pViM7blszTrkdrwAC4sOTVM9QcvWLy8SMlkgp6li+eyXZG7FlAHdRtXeY/W?=
 =?us-ascii?Q?6Czyas/DgGY246FGFO9xXUOG4Lpfq7rfPMR6ixcnLVA+Ud4nulqPMfLbYlc9?=
 =?us-ascii?Q?qcBDF6TC8VJwLMYqkhqAiMpCxNJrifW/EQo9X/CdhGi9VbMzYemEqlivSKau?=
 =?us-ascii?Q?ktlo+UOmFmp62oKmTeD7+VCybCAOOl/2q6gckrmmyMkHQW3v+QPy4ImW0bph?=
 =?us-ascii?Q?orSlAmSInz9AjCv5X0jQHBoMnLwy9RGZFCinTac6K3HJ66sPxpIi5T+ihlg3?=
 =?us-ascii?Q?NqJfQOT5HuxrupoIUcJGJgkQrkhb8u85rE4DcuYcrqcr80m3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d33c9a-8abf-494a-227c-08df103228f3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 18:26:13.2562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SU46+jkJoGaKXtrsG/TdpjfkeuedhcIZtSchcwh7yB7bCwKBycw51AAmYcf5CST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6401

On Fri, Sep 11, 2026 at 07:16:23PM +0200, Paolo Bonzini wrote:

> Rather, forwards kexec *must* work (again, that's nothing but a variant of
> "we don't break userspace") and for backwards kexec, well, you must know
> what you're doing.

Again, I strongly disagree with this MUST. This is not a variant of
"we don't break userspace". It is internal kabi and the kernel gets to
decide which versions it supports. There are no promises here. It is
not a breaking change to say we won't support A->B.

Community needs to agree on what these parameters are. I've been clear
my stake in the ground is same stable version only as a starting point.

This is typical in the industry, nobody does live update where you can
jump ahead multiple years of versions. Sequential releases only is
very normal.

> QEMU has been doing backwards live migration forever, and QEMU is a
> gnarly C program that has grown by accretion as we were learning all
> this stuff, so it's not impossible at all.

I agree it is not impossible, you can always make things harder and
more complicated to keep it working. I don't want the kernel to turn
into a "gnarly C program" because we over engineered this.

> It's not easy, but you aren't even trying to do it right in the kernel. You

Right, I've been pretty clear about this, I want to start with
same-stable-version only and if that works out then consider if we
want to do more.

I am not doing this for any sort of technical reason. Not because it
is impossible, but because it is HARD. I do not want to force anyone
to take on hard and difficult projects like this for a niche feature
only a few CSPs are likely to use. If we take this approach LUO will
fail because maintainers will be scared to take on this extra work and
simply won't merge LUO patches.

There needs to be some balance that we can try this out and see if a
broader use case develops before we commit to doing the hardest
possible version of it.

A niche feature only for CSPs like live update must not become a boat
anchor on kernel progress!

> fact!  It's just that you're solving for the wrong complexity, and only
> partially so because (if I'm not wrong) there's still the question of how to
> bring the manifest of kernel B into kernel A.

There is a proposal to encode information into ELF sections. Feature
flags should flow through there just fine, I think.

I have not seen a proposal to re-inject this information back into the
A kernel as a 'restriction' so it fails luo instead of producing
something unsupported.

Jason
