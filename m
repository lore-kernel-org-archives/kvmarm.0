Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EED4C77D9
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691550; cv=fail; b=iH/fa1bT30vx9AKC5J2JAIjgXNAhBRTVtb//xe0ikVlXM5GUxKCnEp/5lrMXsspaaF1d6d3BluotFI/VZnZ/qUf++tCGux75lsi40VWZb6DRS1iuLz+nOywnG6h50x9OOQs/CTeIHt04b3iFky0TwJqgCuScYNgr9yYxUFXmfzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691550; c=relaxed/simple;
	bh=Gcs0shCfLQ7vckKPk0v4klHUFMOlCYpSW1YSmYo+e4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CTl07YCWyoKQ/Ni0GrJ+LVYpR4IuolcqeQ9XFU7jBTFMGhk1Y6wfD7nCiHSMdE20JbDx9XkSgHzQDkSvPkcmpqsHlXyNlQha9WH2Fojz4eINtMu9e/sxAt1fWQ9rh+CAJzwp6UJTDk9G2rQ2cZKJl6Quaq3zNWTzH01MwLnCTiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nrKUfEnF; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=v4Wo/Ed6; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nrKUfEnF";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="v4Wo/Ed6"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKdnV1855322;
	Wed, 13 May 2026 09:34:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=qQia2sTu14gaaSj1X2ihN36jAvHDyr7AuM5sfCilu
	5U=; b=nrKUfEnFzk36WL4V2EglYekR2uvS0tg3uHaBWd9HfAsIpYPXlWGzOYeWf
	OL98gIPB0ADRFYwyfF1KBrAqsgk3VfW3ipDFgYh0P9jyLd9oadqw7oM6mVxIeOCK
	IXayeIX9LKo2sOOkp5tb2GBayZMK4AxDtqUdzRVo4uqFvTvz4ivYlz7DYar8R3D7
	i+G5T63BgpTJYHt/SBKD6i9aCIUe65LusmTfBH9vaXwK80lysK15TnA6VHPPBDg3
	JKJTMbqpkbwxtm5HwnJ829X6TD9HzjzecTgSUSmh6mAiNR6UL+e3Eh9EKOcs2ZhJ
	1nIcUXIKDmQN+TJqbOhj5YIpG9LwQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022087.outbound.protection.outlook.com [40.107.200.87])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nvke988-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ycJ2i14kNxlRZVQlBWsLvWta7FZPDasorXLNJipoPCDv78VLGaQEIUWQz10tTu1+EH8O1DE6ntiGE0sX6HZgj696Isi8gY00yzAuTitGsLaalHGombgKHJE1sOr4i+X1+QNdvI/XHwbqIfTOh85laDptXTbwvO/NEjx5+q/xfJzmP6GfF4zp3Z2NeU6j85RsLP3AHASz/JqOaRkdclsdH77woe+JRh7L6kas9DOiH9FUgqJnKrC7MVJ7ybqKfuPF1TNIKqoUw7MBC16Ugc/Zn8zsf2ocsyW9ss6hmjx3QQhiNzyPSiwPNdUCpiiLqnxtsFCnfBC1KdFlJQLW1fjUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQia2sTu14gaaSj1X2ihN36jAvHDyr7AuM5sfCilu5U=;
 b=PN1m7MIVTsy2VfrU4aQWaix548tnFkYZuy5T09nwQXFXWXBugpTHgOoZsVohr2A3Dk8u8OXz5pxcGHH85uq2mqwFjgyr7Rs0NMPfhYmGdURHVoLtb1/1actKJhAzij9O8hBKo1hQi0WFhhbI8pZa+onCG13+k1X9/bDPPFcKpbDT+jApCKBmxwi6Q4YR9cI1CHKwdjJKaEv2n+iV7Dzganay/dpywSAdzTLNetzi76f751Es21kJBI/BpwbEGUQ2ehQgWn/4ldLZxCmeWriQM44y6i8XCwFF5YDCYYldIiR07Yc+nm21G5bma4EFur2IY1eIsvj2+ewwsYveXAf/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQia2sTu14gaaSj1X2ihN36jAvHDyr7AuM5sfCilu5U=;
 b=v4Wo/Ed6oqGmbSxSm3nkLcu6LMnKvXFyszYnkgn5F134xk9XfEf6q5dH4I0cbXRw+8toMmOdXrTjbbHKch/pvAiwO9e8dQh6sHhn/Vtltyvb/H1N1G3dpcTL3caeO/hcTmoRuaxPHg2MCV4TfZ0x/Aatd05/mu717NHMwrhUUWhCnLaSiGtJmM30W4d2UyW2AqQAvapwGGbrQe/1Qf8Vm17MrwVi7TsuHIccJpN9VR0gSm3JLy40w7somqgAVwuPrVoAVl1TAUT78d8+RkpCL1t8W0LBseYbWiBpEQkpTr5qdjQtFnHZjxTQZD9WeARnPmzDhXGAPeIGQv7PvgT0WA==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:19 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:19 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 07/13] target/arm: named_cpu_model: define ARM properties
Date: Wed, 13 May 2026 16:33:50 +0000
Message-ID: <20260513163356.3033159-8-shaju.abraham@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:930:1c::30) To PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR02MB10160:EE_|SJ0PR02MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cf236d0-0094-4b12-b8d8-08deb10d7b2f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FwDxsfcLl3UucvSleC7s77OFQEvZC/tJTv1c7xI20tzztSUXVknkU7jSyjdcvnnnS3fCwkdi6loE+w4TagaGMort3biSmWa8zchZl48a9YZAgOuZmHWfp5iBr6GRkKtbsP+YXSAiQzpdMr/5AEY1Iy6eBLcZ9mBvK1yHKxqd4JJfaPpG/RoAsjwxEwBoAPMGrgI7Levf5F9M9xxEc/8bL/WY3baTZCUk4+930OxlchomDexp9faIHPs6dqNFHIz8OMxxW2VkrlNKopzIfFNNH6C25okBQs5sKt9y7h0QHzB/kO0k46uP9B7stN8GjXfrWN6I0OX3WK0Gcth9hiIh0qa4lTpnShH8LSjEHanP7F9XLAubzTTajIflsTWm4aiZDNvpJamRE9CbZd0zwzCCKX3bpNFvQfulJT6NC+Sd7VIK88DoRBxX4ZH78ELm9qw+cgqvP/8FhEMR9gWQ1Z/QJq9nPbwTwp0Sxg8SNJE4fqMmyjp/Qv4Eea6xesBRW7wog/pJvom8DLfMd0eWMInTz8iAymtpX9p7yplMepdPDiF1z/owgqmQJW94Zi3NkMvlInyAosecpoImfbLBlBj8Xgj3Ngo1tb3WIXCQpJwU/mLeFIw/Dx1vWnoV/C4nSgS1pfsnqYxrVcxO3l07WUKJ1eiwpHsHb0uf5QHWSKa1FF7eNmyCQvTO/LA0SnZXAEX4mpLy7c/qFnGEffJy23Qb5WKfdNg+g/8zP3MuY0cPG/U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pjCteXg8ZUdSdVqHvymdf5zIR/OGGvYHYiOs6T6uSNR4Vi15wx89+exde+Ow?=
 =?us-ascii?Q?fRgaxmOJxkK3moQGAD2F0kSJjTgMqc0uN4OATpqyurnB7E17kk+l1CCmvqTT?=
 =?us-ascii?Q?QCrllHRIGlvwc2aITzRIf3Tww/vfviC5IYsz8vX0FSlokiQgr4ZMWHgV8gxA?=
 =?us-ascii?Q?SLSa7XHus22TaDSy5t2+03uto3zCaGktkmWDVVNIvW1ANO9X20eqMoPvOtCf?=
 =?us-ascii?Q?EWAXwmYPeXyN+4INbmfSI/lz3ASaJO4WPcHxjntFBV2TQOf46g4KnZyQt6bV?=
 =?us-ascii?Q?uwywOmOfDLCAH2+IuVX6tbS70UvlQKkl8apf01h442YaeNwwGIDvuxNMt7QS?=
 =?us-ascii?Q?dqEzGnPgQcifxN1cO4+wuOrlGJuof6gtOgCIyOyWN/kYNFj+m3tobT9lXDrn?=
 =?us-ascii?Q?iHCJBveBIbpWhqcpZu+gnnO3l6phN1Mjfuxn82gAeTuKTPGh76ueGUtw3ahq?=
 =?us-ascii?Q?HPAYJbG/2I3k3lAvBMceYeSZpDShqs4ydOR1CBWC+xT0QmMA8E6KVHAUZqD0?=
 =?us-ascii?Q?0o+zyuKQ2TzF63PgoywMJFXmB6utvWsxbFSnScsxxBvgYBtt5jlr+k+HhTHn?=
 =?us-ascii?Q?W4vPosuo59k2jdHb53M86itHi0Z3o3rHNpa9OTb3e50pJPPaXlOxChk20W33?=
 =?us-ascii?Q?NZnxjqe3NQITrEBZ0U5uIb04rqegfEheek48OxMYNryTN1Melxbh11b+HszL?=
 =?us-ascii?Q?quaPi0ZiyqRYUVHRJFOOHoKa+swWCp8hM6U9FQMFgWi7KflhSfs6iE6kzuWp?=
 =?us-ascii?Q?kk3elC6+IkYDaItgeDkO/2j33+x744JKrbnpp8kb0KAcR8fllraIGN8SFJJq?=
 =?us-ascii?Q?3SFe0czI+YrmzeiBc4QiWRBlBhNlwhn5Ka+xufN1iQFbwuRGB9WDmvZgZPZD?=
 =?us-ascii?Q?W6kOUsEt1PPhoq2C8CX58p/9n6eb2YpwU3fLgF1b4hCcU52Jc9lw5820SRGj?=
 =?us-ascii?Q?t9P8mPU2xMZR3bvSxSngLSnQRrXESgDSDRcHWVYouTTaGJz587FBoaXPLAbY?=
 =?us-ascii?Q?lo2j/Esm12XWwjvO+We4StYMeQvrVp/Uv9kiiYYoR2RrsmCJSfrUiNnkloNh?=
 =?us-ascii?Q?IjOsnlwcJ5wY1IpPq69woLGZQTd9QC+qxuXXQBM5QaBt+FiAfViU3EDypNxe?=
 =?us-ascii?Q?hZR4cb1qj5oAcyMlGqg//FO9trhfgLRULyxW02TFROjOnWrPWrfqiTlQVzYe?=
 =?us-ascii?Q?ymT3Z+gMi4h4s48x/IIyHsFCwHfdKM/3uSFh4mI9FUBV9dBuQPsXjgAIlhps?=
 =?us-ascii?Q?HD4PO3sAKFCT3ZmRe4EPY2806vo0E7sz8EhVImVPKDJSvooplkWIEdg8Ze++?=
 =?us-ascii?Q?msBitya1Hke1ltvX/1EGHR0XhEk4qFv04Vi3B/T4rj5iBdlL1Ie+muvPzWue?=
 =?us-ascii?Q?CQJNaRwS0YEVjD8VHlt+Y08q5g09TZ5phTE96N6rTI2PMUTg/MFJdoqzMAMC?=
 =?us-ascii?Q?M805h8Z6Ben2T8X6kXVVveeHo0r/YsxGX2cmOsmTz99OmiyBkRiIA8MEVh1W?=
 =?us-ascii?Q?aFqy3FCK8kTYwN1hMFrteUdyQD3E3P3lI6kLQCrDaOHMiba/sCrBRqxVyrh6?=
 =?us-ascii?Q?ltYH1zZzqH10e1MLaq7Ua3I7QAdrYDMa8SDKkzhSYO9j/58dfQZjs8ElUu3Z?=
 =?us-ascii?Q?zGVucHTsAbzbn8Sz6bXRpk47MyGJDinYm3bbddXE4CyAMZbgyicijQrnHroS?=
 =?us-ascii?Q?qDfqmZ9736/acE7yDSpx7yOaTQzoRYTBk6ROl8jg5LTru8Es9MuyXEeeyW2O?=
 =?us-ascii?Q?IeCR/5rsoqVzOdVe7AsdB3xzp2AS5qA=3D?=
X-Exchange-RoutingPolicyChecked:
	WRMuTbgDEV9kWXgmKabePPO7JUUHcwFlIDhwYygzzuYs06Wf2krj6P3qdEj/+C0hpT3sVADeM/SzPUQpyf9yJzCLACCkVnP8BF9CkAcYURvwrPDJaMisy8WsBHLOZecCYXerSxjp8hcX1X2+PuQlhO+hrdv534dDndxn6dNBenHbWaa8YAKMSS2Xti1DAY004gbfYbjpSmbiIoR8J77d1qbaWiwsH51QfC7IjaR0aC/r9AmE3x3jshCXqnxM4Eb05fo5Up5xAHrlD9tPQH4Jj5pdi+xGZxiR0OxR5K+SiHWsXpC66cDKcpSeRdy5x/8B5rC51l2O1lRifAC4a+Uc+Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf236d0-0094-4b12-b8d8-08deb10d7b2f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:19.6141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71VLqTltxZCDMIDHQCekjRMkb7Pi9bwAorxkvtixsCgamxQC2kTbNppqULYEpDhAlFXz9j+LVMumjY5nLPgtkrssQQZuIBzbFo1HWQFna00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-GUID: 6Q3erpIlI5hwl3Y89pM1FQneuNuJKgTZ
X-Authority-Analysis: v=2.4 cv=WcU8rUhX c=1 sm=1 tr=0 ts=6a04a80e cx=c_pps
 a=sjA+6HJZU54iCSkNkQ7fig==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=1L6crL_YRTbalZ11mEUO:22
 a=64Cc0HZtAAAA:8 a=lbUGho734beyiQ__YtEA:9
X-Proofpoint-ORIG-GUID: 6Q3erpIlI5hwl3Y89pM1FQneuNuJKgTZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX1la9rHU7UPiR
 UmdBdP+MQY27SMnoxrbTK9fF2DJbttQxhGfAszS4a93ghRydY9bDYjM3oUJb33VrcVsFbtd2/dB
 bG8bcuriDMS0B8vBr1mV8SlbFZfkBQwIXkhVU+Rtq4KBHGqGY3rFuAyNxQH94+RkIArGkwNx/oJ
 Vzzk9aAji7myqVG1jxqupPw0ssvICohL+C7aHa5EGvPiNV8Mp86sKsjE/xxNRCxvdW4pt6Wj3Xl
 OY2VVg2fCcg/bY87abHrHbYlJ8MoBI+hs+WIhrESWeHHv2h/lPryxAx5t+UHYFxbTtfiST4brb4
 ggISkS5MfsXvCqPHzZ8dmHFXoF0+ajqCa/Kuj7Uo/Yaom+4jIj+kPHkM65BxR6c0jfcwQy2wDoY
 26nnmf01FUmcdlB+wW/D6dqyZ8ydsuH4zKEegr+Xlo5C28iW6mK+L5JGUG3WALtEoI9xTp2Ya9h
 NoUHB0LxlG9d51VYlWw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Define X-macros to generate tables for all user-facing CPU properties,
including fractional properties.

Properties that map to fields that are not supported by the linux kernel
(i.e. not in the ftr_bits array) are not included.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
---
 target/arm/arm-cpu-frac.inc.h  |  34 +++++++
 target/arm/arm-cpu-props.inc.h | 180 +++++++++++++++++++++++++++++++++
 2 files changed, 214 insertions(+)
 create mode 100644 target/arm/arm-cpu-frac.inc.h
 create mode 100644 target/arm/arm-cpu-props.inc.h

diff --git a/target/arm/arm-cpu-frac.inc.h b/target/arm/arm-cpu-frac.inc.h
new file mode 100644
index 0000000000..6c194daf7c
--- /dev/null
+++ b/target/arm/arm-cpu-frac.inc.h
@@ -0,0 +1,34 @@
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+FRAC_TABLE_START(CSV2)
+FRAC_VAL("0.0", 0, 0)
+FRAC_VAL("1.0", 1, 0)
+FRAC_VAL("1.1", 1, 1)
+FRAC_VAL("1.2", 1, 2)
+FRAC_VAL("2.0", 2, 0)
+FRAC_VAL("3.0", 3, 0)
+FRAC_TABLE_END(CSV2)
+
+FRAC_TABLE_START(MPAM)
+FRAC_VAL("0.0", 0, 0)
+FRAC_VAL("0.1", 0, 1)
+FRAC_VAL("1.0", 1, 0)
+FRAC_VAL("1.1", 1, 1)
+FRAC_TABLE_END(MPAM)
+
+FRAC_TABLE_START(RAS)
+FRAC_VAL("0.0", 0, 0)
+FRAC_VAL("1.0", 1, 0)
+FRAC_VAL("1.1", 1, 1)
+FRAC_VAL("1.1_base", 2, 0)
+FRAC_VAL("2.0", 3, 0)
+FRAC_TABLE_END(RAS)
+
+FRAC_TABLE_START(NV)
+FRAC_VAL("0.0", 0, 0)
+FRAC_VAL("1.0", 1, 0)
+FRAC_VAL("2.0", 2, 0)
+FRAC_VAL("2.0_only", 2, 1)
+FRAC_VAL("2.1", 2, 2)
+FRAC_TABLE_END(NV)
diff --git a/target/arm/arm-cpu-props.inc.h b/target/arm/arm-cpu-props.inc.h
new file mode 100644
index 0000000000..13a82e5b22
--- /dev/null
+++ b/target/arm/arm-cpu-props.inc.h
@@ -0,0 +1,180 @@
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+ARM_PROP("feat_AES",         STRING,  ID_AA64ISAR0, AES)
+ARM_PROP("feat_SHA1",        STRING,  ID_AA64ISAR0, SHA1)
+ARM_PROP("feat_SHA2",        STRING,  ID_AA64ISAR0, SHA2)
+ARM_PROP("feat_CRC32",       STRING,  ID_AA64ISAR0, CRC32)
+ARM_PROP("feat_ATOMIC",      STRING,  ID_AA64ISAR0, ATOMIC)
+ARM_PROP("feat_RDM",         STRING,  ID_AA64ISAR0, RDM)
+ARM_PROP("feat_SHA3",        STRING,  ID_AA64ISAR0, SHA3)
+ARM_PROP("feat_SM3",         STRING,  ID_AA64ISAR0, SM3)
+ARM_PROP("feat_SM4",         STRING,  ID_AA64ISAR0, SM4)
+ARM_PROP("feat_DP",          STRING,  ID_AA64ISAR0, DP)
+ARM_PROP("feat_FHM",         STRING,  ID_AA64ISAR0, FHM)
+ARM_PROP("feat_TS",          STRING,  ID_AA64ISAR0, TS)
+ARM_PROP("feat_TLB",         STRING,  ID_AA64ISAR0, TLB)
+ARM_PROP("feat_RNDR",        STRING,  ID_AA64ISAR0, RNDR)
+
+ARM_PROP("feat_DPB",         STRING,  ID_AA64ISAR1, DPB)
+ARM_PROP("hw_prop_APA",      STRING,  ID_AA64ISAR1, APA)
+ARM_PROP("hw_prop_API",      STRING,  ID_AA64ISAR1, API)
+ARM_PROP("feat_JSCVT",       STRING,  ID_AA64ISAR1, JSCVT)
+ARM_PROP("feat_FCMA",        STRING,  ID_AA64ISAR1, FCMA)
+ARM_PROP("feat_LRCPC",       STRING,  ID_AA64ISAR1, LRCPC)
+ARM_PROP("hw_prop_GPA",      STRING,  ID_AA64ISAR1, GPA)
+ARM_PROP("hw_prop_GPI",      STRING,  ID_AA64ISAR1, GPI)
+ARM_PROP("feat_FRINTTS",     STRING,  ID_AA64ISAR1, FRINTTS)
+ARM_PROP("feat_SB",          STRING,  ID_AA64ISAR1, SB)
+ARM_PROP("feat_SPECRES",     STRING,  ID_AA64ISAR1, SPECRES)
+ARM_PROP("feat_BF16",        STRING,  ID_AA64ISAR1, BF16)
+ARM_PROP("feat_DGH",         STRING,  ID_AA64ISAR1, DGH)
+ARM_PROP("feat_I8MM",        STRING,  ID_AA64ISAR1, I8MM)
+ARM_PROP("feat_XS",          STRING,  ID_AA64ISAR1, XS)
+ARM_PROP("feat_LS64",        STRING,  ID_AA64ISAR1, LS64)
+
+ARM_PROP("feat_WFXT",        STRING,  ID_AA64ISAR2, WFXT)
+ARM_PROP("feat_RPRES",       STRING,  ID_AA64ISAR2, RPRES)
+ARM_PROP("hw_prop_GPA3",     STRING,  ID_AA64ISAR2, GPA3)
+ARM_PROP("hw_prop_APA3",     STRING,  ID_AA64ISAR2, APA3)
+ARM_PROP("feat_MOPS",        STRING,  ID_AA64ISAR2, MOPS)
+ARM_PROP("feat_BC",          STRING,  ID_AA64ISAR2, BC)
+ARM_PROP("feat_CLRBHB",      STRING,  ID_AA64ISAR2, CLRBHB)
+ARM_PROP("feat_RPRFM",       STRING,  ID_AA64ISAR2, RPRFM)
+ARM_PROP("feat_CSSC",        STRING,  ID_AA64ISAR2, CSSC)
+ARM_PROP("feat_LUT",         STRING,  ID_AA64ISAR2, LUT)
+
+ARM_PROP("feat_FAMINMAX",    STRING,  ID_AA64ISAR3, FAMINMAX)
+ARM_PROP("feat_LSFE",        STRING,  ID_AA64ISAR3, LSFE)
+ARM_PROP("feat_FPRCVT",      STRING,  ID_AA64ISAR3, FPRCVT)
+
+ARM_PROP("el0_mode",         STRING,  ID_AA64PFR0, EL0)
+ARM_PROP("el1_mode",         STRING,  ID_AA64PFR0, EL1)
+ARM_PROP("el2_mode",         STRING,  ID_AA64PFR0, EL2)
+ARM_PROP("el3_mode",         STRING,  ID_AA64PFR0, EL3)
+ARM_PROP("feat_FP",          STRING,  ID_AA64PFR0, FP)
+ARM_PROP("feat_AdvSIMD",     STRING,  ID_AA64PFR0, ADVSIMD)
+ARM_PROP("feat_GIC",         STRING,  ID_AA64PFR0, GIC)
+ARM_PROP("feat_SVE",         STRING,  ID_AA64PFR0, SVE)
+ARM_PROP("feat_SEL2",        STRING,  ID_AA64PFR0, SEL2)
+ARM_PROP("feat_AMU",         STRING,  ID_AA64PFR0, AMU)
+ARM_PROP("feat_DIT",         STRING,  ID_AA64PFR0, DIT)
+ARM_PROP("feat_CSV3",        STRING,  ID_AA64PFR0, CSV3)
+
+ARM_PROP("feat_BT",          STRING,  ID_AA64PFR1, BT)
+ARM_PROP("feat_SSBS",        STRING,  ID_AA64PFR1, SSBS)
+ARM_PROP("feat_MTE",         STRING,  ID_AA64PFR1, MTE)
+ARM_PROP("feat_NMI",         STRING,  ID_AA64PFR1, NMI)
+ARM_PROP("feat_MTE_FRAC",    STRING,  ID_AA64PFR1, MTE_FRAC)
+ARM_PROP("feat_GCS",         STRING,  ID_AA64PFR1, GCS)
+ARM_PROP("feat_DF2",         STRING,  ID_AA64PFR1, DF2)
+
+ARM_PROP("feat_MTESTOREONLY", STRING, ID_AA64PFR2, MTESTOREONLY)
+ARM_PROP("feat_MTEFAR",      STRING,  ID_AA64PFR2, MTEFAR)
+ARM_PROP("feat_FPMR",        STRING,  ID_AA64PFR2, FPMR)
+
+ARM_PROP("hw_prop_PARANGE",  STRING,  ID_AA64MMFR0, PARANGE)
+ARM_PROP("hw_prop_ASIDBITS", STRING,  ID_AA64MMFR0, ASIDBITS)
+ARM_PROP("feat_BIGEND",      STRING,  ID_AA64MMFR0, BIGEND)
+ARM_PROP("feat_SNSMEM",      STRING,  ID_AA64MMFR0, SNSMEM)
+ARM_PROP("feat_BIGENDEL0",   STRING,  ID_AA64MMFR0, BIGENDEL0)
+ARM_PROP("hw_prop_TGRAN16",  STRING,  ID_AA64MMFR0, TGRAN16)
+ARM_PROP("hw_prop_TGRAN64",  STRING,  ID_AA64MMFR0, TGRAN64)
+ARM_PROP("hw_prop_TGRAN4",   STRING,  ID_AA64MMFR0, TGRAN4)
+ARM_PROP("hw_prop_TGRAN16_2", STRING, ID_AA64MMFR0, TGRAN16_2)
+ARM_PROP("hw_prop_TGRAN64_2", STRING, ID_AA64MMFR0, TGRAN64_2)
+ARM_PROP("hw_prop_TGRAN4_2", STRING,  ID_AA64MMFR0, TGRAN4_2)
+ARM_PROP("feat_EXS",         STRING,  ID_AA64MMFR0, EXS)
+ARM_PROP("feat_FGT",         STRING,  ID_AA64MMFR0, FGT)
+ARM_PROP("feat_ECV",         STRING,  ID_AA64MMFR0, ECV)
+
+ARM_PROP("feat_HAFDBS",      STRING,  ID_AA64MMFR1, HAFDBS)
+ARM_PROP("hw_prop_VMIDBITS", STRING,  ID_AA64MMFR1, VMIDBITS)
+ARM_PROP("feat_VH",          STRING,  ID_AA64MMFR1, VH)
+ARM_PROP("feat_HPDS",        STRING,  ID_AA64MMFR1, HPDS)
+ARM_PROP("feat_LO",          STRING,  ID_AA64MMFR1, LO)
+ARM_PROP("feat_PAN",         STRING,  ID_AA64MMFR1, PAN)
+ARM_PROP("feat_SpecSEI",     STRING,  ID_AA64MMFR1, SPECSEI)
+ARM_PROP("feat_XNX",         STRING,  ID_AA64MMFR1, XNX)
+ARM_PROP("feat_TWED",        STRING,  ID_AA64MMFR1, TWED)
+ARM_PROP("feat_ETS",         STRING,  ID_AA64MMFR1, ETS)
+ARM_PROP("feat_HCX",         STRING,  ID_AA64MMFR1, HCX)
+ARM_PROP("feat_AFP",         STRING,  ID_AA64MMFR1, AFP)
+ARM_PROP("feat_TIDCP1",      STRING,  ID_AA64MMFR1, TIDCP1)
+ARM_PROP("feat_ECBHB",       STRING,  ID_AA64MMFR1, ECBHB)
+
+ARM_PROP("feat_CNP",         STRING,  ID_AA64MMFR2, CNP)
+ARM_PROP("feat_UAO",         STRING,  ID_AA64MMFR2, UAO)
+ARM_PROP("feat_LSM",         STRING,  ID_AA64MMFR2, LSM)
+ARM_PROP("feat_IESB",        STRING,  ID_AA64MMFR2, IESB)
+ARM_PROP("hw_prop_VARANGE",  STRING,  ID_AA64MMFR2, VARANGE)
+ARM_PROP("hw_prop_CCIDX",    STRING,  ID_AA64MMFR2, CCIDX)
+ARM_PROP("hw_prop_ST",       STRING,  ID_AA64MMFR2, ST)
+ARM_PROP("feat_AT",          STRING,  ID_AA64MMFR2, AT)
+ARM_PROP("hw_prop_IDS",      STRING,  ID_AA64MMFR2, IDS)
+ARM_PROP("hw_prop_FWB",      STRING,  ID_AA64MMFR2, FWB)
+ARM_PROP("feat_TTL",         STRING,  ID_AA64MMFR2, TTL)
+ARM_PROP("feat_BBM",         STRING,  ID_AA64MMFR2, BBM)
+ARM_PROP("feat_EVT",         STRING,  ID_AA64MMFR2, EVT)
+ARM_PROP("feat_E0PD",        STRING,  ID_AA64MMFR2, E0PD)
+
+ARM_PROP("feat_TCRX",        STRING,  ID_AA64MMFR3, TCRX)
+ARM_PROP("feat_SCTLRX",      STRING,  ID_AA64MMFR3, SCTLRX)
+ARM_PROP("feat_S1PIE",       STRING,  ID_AA64MMFR3, S1PIE)
+ARM_PROP("feat_S1POE",       STRING,  ID_AA64MMFR3, S1POE)
+
+ARM_PROP("feat_E2H0",        STRING,  ID_AA64MMFR4, E2H0)
+
+ARM_PROP("feat_DBG",         STRING,  ID_AA64DFR0, DEBUGVER)
+ARM_PROP("feat_PMU",         STRING,  ID_AA64DFR0, PMUVER)
+ARM_PROP("hw_prop_BRPS",     NUMERIC, ID_AA64DFR0, BRPS)
+ARM_PROP("hw_prop_WRPs",     NUMERIC, ID_AA64DFR0, WRPS)
+ARM_PROP("hw_prop_CTX_CMPs", NUMERIC, ID_AA64DFR0, CTX_CMPS)
+ARM_PROP("hw_prop_PMSVer",   STRING,  ID_AA64DFR0, PMSVER)
+ARM_PROP("feat_DoubleLock",  STRING,  ID_AA64DFR0, DOUBLELOCK)
+
+ARM_PROP("hw_prop_SVEVer",   STRING,  ID_AA64ZFR0, SVEVER)
+ARM_PROP("feat_SVE_AES",     STRING,  ID_AA64ZFR0, AES)
+ARM_PROP("feat_SVE_ELTPERM", STRING,  ID_AA64ZFR0, ELTPERM)
+ARM_PROP("feat_SVE_BITPERM", STRING,  ID_AA64ZFR0, BITPERM)
+ARM_PROP("feat_SVE_BFLOAT16", STRING, ID_AA64ZFR0, BFLOAT16)
+ARM_PROP("feat_SVE_B16B16",  STRING,  ID_AA64ZFR0, B16B16)
+ARM_PROP("feat_SVE_SHA3",    STRING,  ID_AA64ZFR0, SHA3)
+ARM_PROP("feat_SVE_SM4",     STRING,  ID_AA64ZFR0, SM4)
+ARM_PROP("feat_SVE_I8MM",    STRING,  ID_AA64ZFR0, I8MM)
+ARM_PROP("feat_SVE_F16MM",   STRING,  ID_AA64ZFR0, F16MM)
+ARM_PROP("feat_SVE_F32MM",   STRING,  ID_AA64ZFR0, F32MM)
+ARM_PROP("feat_SVE_F64MM",   STRING,  ID_AA64ZFR0, F64MM)
+
+ARM_PROP("feat_F8E5M2",      BOOLEAN, ID_AA64FPFR0, F8E5M2)
+ARM_PROP("feat_F8E4M3",      BOOLEAN, ID_AA64FPFR0, F8E4M3)
+ARM_PROP("feat_F8MM4",       BOOLEAN, ID_AA64FPFR0, F8MM4)
+ARM_PROP("feat_F8MM8",       BOOLEAN, ID_AA64FPFR0, F8MM8)
+ARM_PROP("feat_F8DP2",       BOOLEAN, ID_AA64FPFR0, F8DP2)
+ARM_PROP("feat_F8DP4",       BOOLEAN, ID_AA64FPFR0, F8DP4)
+ARM_PROP("feat_F8FMA",       BOOLEAN, ID_AA64FPFR0, F8FMA)
+ARM_PROP("feat_F8CVT",       BOOLEAN, ID_AA64FPFR0, F8CVT)
+
+ARM_PROP("hw_prop_IMInline", NUMERIC, CTR_EL0, IMINLINE)
+ARM_PROP("hw_prop_L1IP",     STRING,  CTR_EL0, L1IP)
+ARM_PROP("hw_prop_DMInline", NUMERIC, CTR_EL0, DMINLINE)
+ARM_PROP("hw_prop_ERG",      NUMERIC, CTR_EL0, ERG)
+ARM_PROP("hw_prop_CWG",      NUMERIC, CTR_EL0, CWG)
+ARM_PROP("hw_prop_IDC",      BOOLEAN, CTR_EL0, IDC)
+ARM_PROP("hw_prop_DIC",      BOOLEAN, CTR_EL0, DIC)
+ARM_PROP("hw_prop_BS",       NUMERIC, DCZID_EL0, BS)
+ARM_PROP("hw_prop_DZP",      BOOLEAN, DCZID_EL0, DZP)
+
+ARM_PROP("cpu_revision",     NUMERIC, MIDR, REVISION)
+ARM_PROP("cpu_partnum",      NUMERIC, MIDR, PARTNUM)
+ARM_PROP("cpu_architecture", NUMERIC, MIDR, ARCHITECTURE)
+ARM_PROP("cpu_variant",      NUMERIC, MIDR, VARIANT)
+ARM_PROP("cpu_implementer",  NUMERIC, MIDR, IMPLEMENTER)
+ARM_PROP("cpu_revidr",       NUMERIC, REVIDR, VAL)
+ARM_PROP("cpu_aidr",         NUMERIC, AIDR, VAL)
+
+/* Fractional properties */
+ARM_FRACTIONAL_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC)
+ARM_FRACTIONAL_PROP("feat_MPAM", ID_AA64PFR0, MPAM, ID_AA64PFR1, MPAM_FRAC)
+ARM_FRACTIONAL_PROP("feat_RAS",  ID_AA64PFR0, RAS,  ID_AA64PFR1, RAS_FRAC)
+ARM_FRACTIONAL_PROP("feat_NV",   ID_AA64MMFR2, NV,  ID_AA64MMFR4, NV_FRAC)
-- 
2.52.0

