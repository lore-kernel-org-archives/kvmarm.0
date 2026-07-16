Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC562045AD
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237993; cv=fail; b=ftqolCsJ48ySY47Id9UZNKdAGYBtztGYSzHZ6mPUslsUaLCl/JScEhXY0pFf4k24VJAnhyq6BIiwJArVi9HvsSfQWDUFVQHW7o5KATSADDHPVh8ODLKzuSyKoTl5D0N5KYQXy/OD+JC0SQQlBgKI+XiAaVOW+Y6aLmHsIfWIIok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237993; c=relaxed/simple;
	bh=3ISUxulc1pxZLiBGcfq7mOmiXs7d9Ms4vjB3oURg8W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mkqAMAOhhZUgCq/6FP255a5aOpmPxSFei+TEQ7swg9qGhTEHvBkYeS/Ot6woKv2C2bnmgZ1p6a6mnBgL1Ajv/sZZUcQ1OfCeNlwv2GexBYqNhUlKCR83733zTiIazM9I4DRf+H+uXsupVFRqom8bi9yf8CUxjxYdfM39K8CUIj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CIKm3v7s; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B1s57/62; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CIKm3v7s";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B1s57/62"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZi01763910;
	Thu, 16 Jul 2026 14:39:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=N8CMA7CQoLaQ07KXiqre6m8+0Zo0uQt2OhokGcSIf
	HQ=; b=CIKm3v7smROIGBD3RNNhGLLY9tTf9xK+AHlvOrmSARrSuGTuiAfkAOOo3
	T2ofhm9/AE5nk6syg4oIzd5tEQD1hWW6s9zQurUSNs6j9L8zC98LVp53/shqnN6M
	1/n4X78pM/choYoeVLzxbj9f1kTjhhLegwvOAq8Zi+R+h79rGxHEpoFkpvLgjhod
	ySsYPqnhPEOmyXkvv+xU26CpNjyRF7q6OV9JXcBR3JvSTQwnai+V9LJIIkg16Wj4
	ZyvepJx02b/PlRsHoIRs/A+Ilcvz49iYtI7cwEWufjbiDhf1Ag/awDpC0tWCnoQu
	aGfKJaoFS1qeEwvihAkFrlTktCXjA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-16
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAP5/KIxMzyxnNZlWgFH63XhXT58x9GHUHlQVtQMXLMEH5a24EXzJ3V9BaKlucvMA0Mq55weMtxFSirhtCQS68EZJwqKgs9s6rm2LUW8XgAycVUg0xMt7QLYiKbiBncEsoFDmpPFExd48Nrb8fGBeE1y226mrpWOvnbcyTLG0r61w3Nx7BgsMFTY2SQfMe8YXwEo65BfwKP04qdXxcO2owkoph8iJugTLQCVdorEydldXkHvXm3qBsaubFDnOqXNfTpNjr9fimplDvSdzRk2GadG8qTaqFxCOEPeOai4rrFc5uTXrEXDxC/35StEKdhuAUCrpThuE8UwB3K48mNZFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8CMA7CQoLaQ07KXiqre6m8+0Zo0uQt2OhokGcSIfHQ=;
 b=E9puCSuDhO4Dor8J66WWmTGmKO4te3PoDbB025MdlQJUE7rSVuwdBD5vLLve50P0obWJGCpspkweL+a3oXZs5muEkhJFVsEKztN/1uwmYqeKKwJwXRGdyBd4tU1z3afhdCh6NOW3W8dNc1f4rcyVRo7T/2Powv9/7S8ylh3BBJRGvby1QE5xncfI3q1G+iGuY+OeMp/Lfk1b5emeoGMZLJZd/0reuo4Ukalpbny2DaNS9FcBPY6GIEM2W82UhnG34Duzrc8irL/gp4mXNaU9n2u8Cs9/gdJYKvrwwEBSolbZGS2ZzZhfScPmucRzbu4TWrvsHFw+CN0uQ2uvA7b1dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8CMA7CQoLaQ07KXiqre6m8+0Zo0uQt2OhokGcSIfHQ=;
 b=B1s57/62i9qQdat/5ZuoqvBLUYqDIa4UaGgSQp1ERL/2BgOtOGCNTLEUC+tTrsV3QQ//W1AtfQx+FXN4gp8qfdhopZFYgjKvoiqwM+s+efyzt4KxIvc6dmMh+Ug8OGIEtZ7Yxo5uokqCpFvr6SUtgdAv2XvEJ2jEs6n6OKmEIO8UIPgINIcmhzklCzCghlnxnUkVp4n+hWD0ajC8eTmGIzhnC38S5ULii1N8hJytOjDt+RLCYCvDraUNXS12qfn1ct19m+9gofDxsEbHM2nkSI8Guk5SHfZx+bulebQu7qrYdWr/GAo6AspOIqWFlX5NUcEJnfMFQ68JaTImiEdxeg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:39 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:39 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        prerna.saxena@nutanix.com
Subject: [RFC PATCH v3 15/19] target/arm/kvm: introduce kvm_arm_get_host_isar helper
Date: Thu, 16 Jul 2026 21:38:54 +0000
Message-ID: <20260716213858.609699-16-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260716213858.609699-1-khushit.shah@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:510:325::28) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SA2PR02MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: 684e6c48-5ad6-4649-2b0c-08dee382bcfc
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	3wB501hp/A/IrvOKGll3H9PuUtIvq8rHXzpi6DAzbzLbBk9qREYSMAoWNJLiL6aWVzHGKgv3L9HzKWp7trXdFmuDMH4MJlTSTp67V8Z5t9hz2BpsKi3/70YeZcrrWd/EVHjSynTncGnczPmA9Hd3PN1iJt5gOvbCfcmiiX6hA6aRxBa+ahvZBEhVlktBPscLrb8qbpZ4oKdLTa/WYhs2+/cWYtlcNOQmNkh5lXnkoFTpgn4yqK6uTYpxkULUANekgEOUna/wZNds8aMQFL2qXVDXc10QOpA7gbRUyEvIe7xQWEd8gWuEYdLCAmFNkE0Y7p7unFE47v04lh2W+P3allCqefJVx1sbxp4FO8ScDZ9YWDgdbJKOhU83Q/xL7ClOpsgA4xFH9/tsoSDPnUyAJN69G+/3LekkgzhbuIBGh7vVLIgO+NTI4/3z6R4BZDgHEIDLaOTLnkNvnREc1Fv7u58bsKXxphW9SdhsGm4q8RaMK4irYhcx5t+3K8XLQ34cw+2Aj99eVTiXfYp0M0JqJc6rmtEJRYyPZj4ydkyioe5oFIjrnRmKO/4HTskzOQZGfbqtmAJ9CLONiO5rPzvU+SJ8HcTZJRqSI6ndB4dFuzZLN+TFodrPB+ha7IKwSme2U+jKfuaQfKUEOqvphMOLo3sK5VuQcf+ALHE5BMJm1jA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wC0p+3JbA9Dgi5DKYdNhcYtGQhW+Z8sKoifM1KWVMDQZ5K5Ujllo4lTtuFOE?=
 =?us-ascii?Q?K/Xmef5+wTcFKWQDv4caCScf387mPuosUgs0+SUacAt6E63TCoa7EwbztPjT?=
 =?us-ascii?Q?pXFCaljm6S5G2UC+I9G38UgGy0j3Sznc7qj1Orq71ZIIPPnsoX6TYuEfxZt0?=
 =?us-ascii?Q?mVqhM3t4cj/tV28vt1T5vWmIOQSqToaQ9q8dZ4cR/tLnU4t1ljyGKifEpRnB?=
 =?us-ascii?Q?5U8pDmxrQELEYFqpInDsdTk/3b9Br63xeajrCK9S1UjaXpcIntlMvIjEC9oR?=
 =?us-ascii?Q?x0dPPIPEDzqchhZljf+y6TcPYh4s4fiZJH+UrOzoM0PEeV7DWpz0XugtdsZc?=
 =?us-ascii?Q?JVCofMAXb/EfRbKU5LCnGrjE34opBLg6554MpY20zqJ1/vD7xd1iCXwMGJ0U?=
 =?us-ascii?Q?62WV1WG4MGvSe9aUP/c7alO1RloeghHq2dklq7J1oH1o66+w8IUw6q7jxhun?=
 =?us-ascii?Q?HrAJA64qUdDxXHTkgtp7C6a9om9ivIe3Y0/y54DcaKNsCYEtE/Lc1vX9eWuD?=
 =?us-ascii?Q?P8DssAbJnfrZFM11zxaO+fFD2IGsgrhRN+kwlll78CRwttdWASc/VFVryOXH?=
 =?us-ascii?Q?2YTcXfejEg+XMjJb8satJscePGm1aHLz2jFLAq/JLuc2GL2K7z1DHCCyyU8U?=
 =?us-ascii?Q?xI2/t+nELWZCL4zuHsbM6qqRIqL1w1jDveLw84SO3itnMW2x2bPlIixlaUoK?=
 =?us-ascii?Q?AOtyhCCoV6M6mm27tLztdXgOBM+2/TcOMnPAmLnGWAKkU0JJ3gwqbwI2YliF?=
 =?us-ascii?Q?ab+ibdevX74IWyQzrjViwiHmWBJWH7FjZ4l+R3NghesmQPo+TVfuFlWihHaq?=
 =?us-ascii?Q?uSynHSck9GkvOtkJF+s2lzwa9Vi/zdyfyghiCRFzQMEkeMkViiVQxlgsHX4F?=
 =?us-ascii?Q?X2fnFwaDyq6hwrAU+wIfYo/y5GW8qhOVLy7pw5wZjK53U8BGtRPgc4nPP7aa?=
 =?us-ascii?Q?pAWtmqhMKZTsW0UuxdabaMSjYoQDF4pIvbXavbK1nIu1ggypbclxewxXUmyI?=
 =?us-ascii?Q?pzTfJ5w+ztTcHz2dKG/xoYlR8t3snWhn+OI3DHmkhqLr6Jq5pMcZI8yjI6Hm?=
 =?us-ascii?Q?xjETzESkpemRwzzBN+g+r0/5neDgdZdnJSUXXSm9iRKFPfADP8teQ1cHor1p?=
 =?us-ascii?Q?97n/RLIta3RVeKH19YQoPoKzjdQVZF/37jaIm2pDWg2cvjPzgo8nU9USx7N3?=
 =?us-ascii?Q?TA55aqIWseRdgRIW5peThIZlsGieR9vlIfotGCGegsjwbL0mh+7TLxkz7h3r?=
 =?us-ascii?Q?CPkYAtBa6Gi9t91k08Dx9b8cJysmyhX4qny87WoUCHXUufnSsaGCYg99NXYu?=
 =?us-ascii?Q?xyt23V/kuvuBqYEZTiw/3fJVHp43PBo2BAuRH8PIn7JyQhnnIwfkMOzsH1hu?=
 =?us-ascii?Q?8HHsa0PsMI3asv2p/ijcHo5WEEmIm28K0vd+vXra0O6Pm7zx+VMYGwIscuMs?=
 =?us-ascii?Q?4CMjl2KrXWr/MaZHRJvWq4Wk04Lr2l8pzhTiDSS/0oIgUyqljIs4rG7n+PLr?=
 =?us-ascii?Q?IRuBMyNN2JOkCLKA9VZvcEkiN+D/7qJuqhoPr7IXxJXhARmGFXVXY4qxbCqR?=
 =?us-ascii?Q?XpwUyQUWnBV3BA8/lXT1GvxmBixiEPDv4n5lBZyBrOLUKAypEbkfdwN/M2Sb?=
 =?us-ascii?Q?lzdWVK2LzqUjjK1W0Y5ChaytI+Wotx6y0m2Q1GGDqTBInwhfgznuyGYPVbah?=
 =?us-ascii?Q?BDOyDFXUVbu35aaSmf6Cj8J0PasoRRtXS8vD3im6DlZUUnp4aem0pE0p6j01?=
 =?us-ascii?Q?hvz3GjKTNo6YjxWmVHnpPfPWUrD8aX0=3D?=
X-Exchange-RoutingPolicyChecked:
	Pm5HtWfLL/R/I0jOMNEd9HHgrEBKX9YXxCxhpVqUnNGw8VyeJrtEo5hQb+l3tpkdzVXOhRexvEL2pZ8gRYlYofsBhLPBuPGVLJNyNbhNR5CCVRw/COyYcKGk+dte0YDODd58HpVTNg8KT1HTPZwcjiYQJF/ozMV0Cg6mbeVodrvtCZ5+9mEyzbocfQmZV03IWcz1UfvozZLjrFMXQPusaaEVXJH2PNcNnjbNr4OPV0lCyMHciQe66YDgXsWeARjXunkncQbQirhgKP7LWJM4ReL54pbLGfYntS4c5hoy9BqNQ63I1OwnDA3ZzzsQfp9yUCF8F+/39zBpzgtDhNuA2g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684e6c48-5ad6-4649-2b0c-08dee382bcfc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:39.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxQ7dRrP4LIRSuk4Opaq9mveDfJV2Chq6EQVc/faVZ5IKRGZRdFJdJTXEVyp5UgWlIyJyULuopD0lTpgq+wkGhNgXhMKUIW9QdDjVLw8ltA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX+C3zguYcqo2b
 +zCj1JhdInqJQKLdQkfx2p5+eN/gRiciHFaILz3MVxBAdX2ZIxvk3FAsQ9Yec9aZduhQN4owUOU
 IdvHV6Mu4Utf0xNQ/sC+2tUCgMvav2t1pVdiLn9LLyRF1xdPSL3o88jU2yL8on2yVmuElzzqmGb
 l/HTIonthoregzzAQEMdUOI0VeCFq+EdmjjrJj93bYT/lAyganEhM5JAX57uuXSOvML5Tn15Xga
 9TpWCNrlj/TcuqQn94tWEYT0XdecKGbbo6f6pSxAhShMdArWgd5YWlrpCtxeM6LDVma+O3uz+V3
 i/Ipr6klw39ogfLOIOvJCeJ5Pk20G80hFGKYWntmHSmuMju1yrbh5uccTggjfPRo4n7aZUqxAS2
 dNMEjZA2DliGSZ4+BGFriu5JrBqZkpjCH4S0bjkg2TnhgzuWQ3FWWd8AOGfDjSzphHiSObzzceS
 FUbub9Y349Hgm7ZNaEQ==
X-Proofpoint-GUID: Q9ibRqCVLlsfYVeVp_XmAafvkh3jVH-3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX+hQOzH/2IlwU
 xt5acFK547P/T1LCbmjeXyNa1YvRVUUY3HmMPr++YEO9Q7AKF56FPL5ZHmAUGdP/Ugzzxy21n8U
 n8mOP0cRddVST0DP2yEaBxi4XRNfmyc=
X-Proofpoint-ORIG-GUID: Q9ibRqCVLlsfYVeVp_XmAafvkh3jVH-3
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9f cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=vS_ObyiCXZHXlSlc3J4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Introduce kvm_arm_get_host_isar() to provide scratch vCPU probed host
isar. Will be used in future commits.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm-stub.c | 5 +++++
 target/arm/kvm.c      | 8 ++++++++
 target/arm/kvm_arm.h  | 4 ++++
 3 files changed, 17 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..dd683beaaf 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -119,3 +119,8 @@ char *kvm_print_register_name(uint64_t regidx)
 {
     g_assert_not_reached();
 }
+
+const ARMISARegisters *kvm_arm_get_host_isar(void)
+{
+    return NULL;
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8f452f9570..042d5fe804 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -650,6 +650,14 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     env->features = arm_host_cpu_features.features;
 }
 
+const ARMISARegisters *kvm_arm_get_host_isar(void)
+{
+    if (!arm_host_cpu_features.dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    }
+    return &arm_host_cpu_features.isar;
+}
+
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
 {
     return !ARM_CPU(obj)->kvm_adjvtime;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 9f15c91c4e..4a04d72e39 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -15,6 +15,8 @@
 #include "system/kvm.h"
 #include "target/arm/cpu-qom.h"
 
+typedef struct ARMISARegisters ARMISARegisters;
+
 #define KVM_ARM_VGIC_V2   (1 << 0)
 #define KVM_ARM_VGIC_V3   (1 << 1)
 
@@ -257,6 +259,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
 
+const ARMISARegisters *kvm_arm_get_host_isar(void);
+
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
 
 /*
-- 
2.52.0

