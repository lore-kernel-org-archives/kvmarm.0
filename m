Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F04A2E39
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650468; cv=fail; b=huOVxKgpcc6dBcmnYNBRqDsaWz/GZ05xk/5/jH11JgUBTR7bE9If0wB9+qr3oFp5aRPhmgGo1ZZK9Sf8eyE4negGzZ+NqAUKU+mC2O/FZtjfE5yjF8pa2fD2aAygomKsT2RXGJJlaFjrPnzMMSe3uteNIl+O5dRLjwv5CAvsKNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650468; c=relaxed/simple;
	bh=77nFAAqG2o6gGawH25gtTII68ccRTr1mtfg4iHTCgPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JwNM+ZJA72pM0vTPuhNrkYKyC9kLE2/qplE+bnfMUxBRWZft4fACsEcPgCO+4OxeDyDCnEPX1k4huPeL6bfpUXwwFaygO+6Gw0BFXPYJm5KqVm3/nmmjeztheO+UfmBTBzPvUlULIjiG2I+kLz8MSf8BTT0lF2hYuy5l9BmdzB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QBxtya3C; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=K8YWYO7k; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QBxtya3C";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="K8YWYO7k"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLR854749;
	Fri, 5 Jun 2026 01:43:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=asgc3Y2B/cvHyFb+lfCg+QcWfZN9NoXUjXT8zy3eF
	c0=; b=QBxtya3CRfIDeOl83GtLHJLKXWptay0yDJ6In0NQmXk74kZJs/u5a0NX9
	kmtupcGnSX528Cumq2dJd0c7FQif2A2DbBMt1mKmr9h13P+a56PjvS/6QfJik8Ae
	wkmFrw9cMeRfeBWsKCMMwsa3FQKh97tgwkLO4QXdLjQF+WircIoh1fTDtDKuEG83
	9/tYpt3+Y/Uw7ODxdFXomqTUJ2TegCv/2FUd0o9A7N06bA5czyovk8Ru3Y8GjLt5
	5ZXl3a4I0+vgz5IZwBbInjhrSHF0laCKcMaIlDQT7zQTT1qgaTpMqzfdntfzdsOD
	TEeReGQam5DJvUAYArk/wXyd+/i7A==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-8
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUHAqaJliJtaK47NJb+TkG/s8iz11RhbejFKMsalH+ESQoqubfxr3q1leA5ppirPHr2LwZhSu5e4An2RY0NSbNadu6uX8dvS2VhuUqZEB1iztK4JhbjNbFVWfg2D0MelUkOdwkJox/UPXur262Atx3+7KrvCsPk852gh7roj9fLfgJcKs/hlafeCNYoFzfKTIv7cRXXWLS3L0mx2iz+o61r3FUpN+uIpWhq62FpVolKg3fpQjbVgOloi2mAV84Sjp0lX3aiCJ6Vdpk7LacJWjRWBWx8JRQ5f1qVIG3LEL+BDz7A7OhOkq0SwjgQScqQsGSXTgDNfFjyaxmVlE456fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asgc3Y2B/cvHyFb+lfCg+QcWfZN9NoXUjXT8zy3eFc0=;
 b=sFRpY3+2CMP46pLodKoyfHn6GWS0f2Y3JuayuAV3FUX7Mmyjecu3Lf/hbNmDSFQbD9hAK4aE2/0Ki9IEw+z3h/NN/owwuZ+/S6v4a03MA3uCG/ppKHx6piGZpXeSIKI/AheN4s/DLrzHMybeGfAqzjCQWvI9A/fQUU2WFZst6lP7g1T3oTdXWwYk651ixA7zfwisXSs7QtmuwPo24I2cYCw0XSmO6BbVdrv0gHCEFzlhgbXQdF7tYusRJn+2zB2SAcnih46CDbrmb40dYnAJp0Xpf/hq/Sh3XefPUDgaPNH2FKGC6A5lRkbOSddciXde6G3ashbuS7FUGsm5RA3MGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=asgc3Y2B/cvHyFb+lfCg+QcWfZN9NoXUjXT8zy3eFc0=;
 b=K8YWYO7kny7EiAmmfTRCWM4g0mhKQ/99J0qrY29AFfqd82YITEyfUAtVi7paost9jiu4rqGagObQ9raRjS+hlnUNWRayJGUBNHwgjKU6PMAO8xJzfHIqetY37zo0xgAFWi4a7MjqeIspzRjeNC5TXPzJuikS17BsU23sQkLkNKNmXE2Y2T3XVK9CZwOLGmF1j0SPxhFanzCrWMUIA25V0pXcsbgrfJL+LDh7uI/axB3dWHGbTGBYadg8UCs+s8aylnPVw0/2a+7WQhqFoXKvHF0BxkFj1W161aR9bjBW2x58/f1TlKTK4J9prg0g7nLY8EoZ2QdPrZJYsRQYURui+Q==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:11 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:11 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Jinqian Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v2 07/29] target/arm: Define ARM properties
Date: Fri,  5 Jun 2026 08:33:36 +0000
Message-ID: <20260605083358.1320563-8-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260605083358.1320563-1-khushit.shah@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:510:324::18) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|CO6PR02MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: e3db09a2-1bf1-42cc-7850-08dec2de799c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YsVlZZ9oR/1f7zQiZGF0XDUJoW+lUMSZRv8o8jVMnhEqJiSfGaKb8qovez6+Mi0Rp78ytyHjFNq8K5yrdRR5DECWID6KeQc8jjuovV9aO68ouwlsS94TtuRpdmnbqJG5o5S8q0pdEYiQmObu3zIFdrvdTQXZAeZgLebSwp3myw9dB0tcYYIIVDdH3bnGMrkmwO4iH+eV00sLxGnHMyBlZjxV4+K+kjM26CBNHUZ2pVDh2xoYLCm0JwhRYskzqRSu0sldAP+OXrPiHhuLfs0PukPqY6yt2CbVnsoLyzemJKeAXorLtu0XevN+Sbik47vzbKDDwy1yWHLNRGNYgxBUJoDIP/rSZymF6RJy/u/OX2oCsas1yY9W/u4MsecNBeFLhNYdtMeIPq4QDPSKYqV5q/kdVVmgaAVMxDtR1VG9Kd0Bt/t3Wa39IUR10mz/jVTqJM9gLBCAUnzEVvMj29vOQVA1yUF8CnQ5K+j6uyiM3fEFqJPI3Ha9/2XYsfy3Rl8RVY72NpgXHFsKSWXDcRdmSNnf2X/ivrPJ3jYtDvLGvwEFqWnPNmjBvVr9nIyZwCq9MAZBrbX5lg8TjN3vAD+WkT5z8+Kk/BjYilHj1vgFT2rQCnkB3uu/L7FqqLYE5A/2alA2pYpsxi6WHdIUcfhvXyVdzgt0x0kcXJfkiTJYaSn8lEf9LVTMxXRnTCj/5mfm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i2mfPT17sGETjdBkMj3C/hXbYUsSukaLOgox+WlU3Naaqne6Uw9hlS3qK37X?=
 =?us-ascii?Q?7rMRa/pT6jCk9/svsSQedbZlMO8GrwZ8Occ/RtSJmzDFm9PbLrBt0wSivebS?=
 =?us-ascii?Q?OuKfhmH376oGbrqUNPsjnxtDmSS2bNKiYzVaKFmCTQWjPfqJHuG+tzvOXP7o?=
 =?us-ascii?Q?W3IE7XgiWQn4Uq3nIPkMFwQYlKHysfzMfFhUJXMeMy3z8PUs/fOMxWXftu7p?=
 =?us-ascii?Q?yFnG0DvUEcqRkn0CbhsQ512ZsSt9YQQECQfS870GdmvPJcEh0IgYGDaK74Yr?=
 =?us-ascii?Q?BG3dHqMqKOfIBwMxiSWWaSNwE82PqkyAyWzZPT/yGGRdLGnic/y4E8eGxTNu?=
 =?us-ascii?Q?hQvxeaAIRXlxnJwq/CFTyfQp56hAX8LouWDpdKVyMNZdQmxWlDFXoAlIoBfh?=
 =?us-ascii?Q?Dvi/zKX2Cj5T7L5ua4lq9Tv1ksHtJE1zoZ9+NdtCriaeH1QP736J3AgYhJpH?=
 =?us-ascii?Q?OxUAPMtArmOhocjx5FUeZ/ETK6NQQyfGwelsG+7+N8NRTamPEAADzVbDbnRU?=
 =?us-ascii?Q?9iwdlNxofMyimD0HcC+IWlUAO7NXQIae5p0htF6+OJCfyPG5p8r/8QIcblB1?=
 =?us-ascii?Q?JHbg+p8E7pSScRPAWiuGNIbJOg1Y07hX1hgx7JYnmlcgg0wf7OdNqn+XnMqc?=
 =?us-ascii?Q?6Ba2fZoxrNWcbin628mWtf59cxrScFi9/lDWNl086CnNNzgXhQYlndVZTv8b?=
 =?us-ascii?Q?o7EjUzbsuyekAF/1cwnQlUDWbqcQssV1AkZefqBqH15BT2YVdzChaRyWf99a?=
 =?us-ascii?Q?5yFmh8sngG5rozObM7RuZAhd+/mceGR6wOon/C4UmvT9ag7CI0dn8m7yM4Nu?=
 =?us-ascii?Q?/vbeVeMWiJQRPZxBIHaXA2d0aYwJX6+XYlyshx+vKQCi392LXkC8yTdtweBp?=
 =?us-ascii?Q?eKdiAfzbxjrAPf6jm9kalT8EW7TxV3LYdrg04tkazYxX9wA33oY4LaEgXtBa?=
 =?us-ascii?Q?KD5BjfDteB19iSAb0KIeE5ZkBoQB9j9x+9JQ5/o7Yji1YdA0KedOmWPOvYZ7?=
 =?us-ascii?Q?8lylpd1GsF8p7SOWNLU0eIWmKhWpS99QyJt8CSBrdielJMOzgfhtpWoKDTrJ?=
 =?us-ascii?Q?gyHVYOFxMDrEKSzoOcPuCEiHFc2Pv/3xgXmb/FleaGYOesZaSl15jNv/30cR?=
 =?us-ascii?Q?b6NaP1UhwIJeZuMQb5KA6KkZSZIPR2hx0/inaRnxhuAYwtu+s9j8XgdhWzjP?=
 =?us-ascii?Q?KYxz2pOkbgHvsIqyxns0nmhdDRsNzw9y+M+MI3jx0gsoaooUpGrNsmfWqjlU?=
 =?us-ascii?Q?AV1m1yAjtSZmvh5CSzM/exHq1KekZrEZ4LnQLde0c0LIOj68H3Ds9uaUsg19?=
 =?us-ascii?Q?4YHVGoPIh1Ee0Wuz1WFvbavCB7tIRIolYMDixUFC3ngEIiiSlgLjU8hf2Nco?=
 =?us-ascii?Q?XSvn8YtOJi/mmJ3i14DMRuJKtldmRR9gT4gjhtDfpTeKAkyCi0yTixVPWS40?=
 =?us-ascii?Q?8Sg3CW0fmMLN2b+ILt6npSfutHipxfNfN4WTn+8vqK3a/EQwD6L67JcLtoEO?=
 =?us-ascii?Q?WeSnuE5BdErwpSDT2ABOADfXZsYiKsWlyD07DB/pnGGdVjfLv8REGViIy+dY?=
 =?us-ascii?Q?fmL1WOXA/KI8WKuVrQ9fR4yUs4LJK+yJzt17VYiniXHx6Du/TuIgCEDsg7Yz?=
 =?us-ascii?Q?cxdf+iHJz+A/DsaKtZocRuXnNI82yiOLWtK58AqGN01c2EWDOylupNsddna4?=
 =?us-ascii?Q?RJQpcxh+8ZhtZ0QgXN3znjCDRWViqdm2s9MBSrRKYNSJ01NuxSpFIbIZmgXb?=
 =?us-ascii?Q?seRjQf3NGJEHwl1K7Tgs5+KzXF5qOKw=3D?=
X-Exchange-RoutingPolicyChecked:
	QuG6nPIcv/HmEV91Lnoa4BWjSjHmd33yl0ddVEvuAvjTfd0m/EEvuGOf2cKSBiI0iM1Wi1DksmEWpN68uWu4+UUWCec4Wzr8MM8hriMKUHGjPILlgGuWocKUZWuaNEL8AZX9Exfvrq6JTRy/Ii2wADm69XNc73z4XdNfInbqY0P75e1tJs34m0a0a0DE/rJh/J3TiWGnXgsNuJCwK8bs7JF8xr5npwN8N4f17jmlQrq86VQJ67xsXbbA9MdxVsRXMnSJLh4Z8KsLYduoG823Eb3FlwOGk+AE3j6aSpagda7TqGaBtxR5FcjEQjRZ7QL1qEvk+d/NP0vjrSQjWJ+XkA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3db09a2-1bf1-42cc-7850-08dec2de799c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:11.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cc6rO/+LZ/fxU2+K3WdtH7GT7xTAhnm9ApPUxjHPnFgeX/Cjt/+IW7PzftSqg46xnx9JcMExaSHyAFSlZCBi2ZM2Tj7bedYQDTFCz1BNrJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: 98w9pmmdeR9L49oMbTEGLTGBAHo9I3Pb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX1XMU5efnHK28
 WTGuAARBgmg7SrlvBElL90NB4TRivsONQASa1IMhB8NxMmQBH9zS/YskNt/HFsl902Z36904CXa
 y1Zjo3UNMGEvMvpau2fDgYkTm4hRQCzRnUsSt7auabkBEXpPROGBJVetMUrtpfZ8kzwnoiRPWdB
 qXWo/s6gee2yLGAEYdXDwS+CJdfWGVdanU7IHPUbsbPWODohdXPBpit62JCvhty0lujuDzflUl8
 qEetWbevvskCqydYRX7D1gnHgLZTamK1xIhmR7EVCpEW+zEgurluSSWCiVzRvD5zos8Nb/2u0+s
 eNFg/SBeI4u8GtapnV/tW4MrMgBYIrKgUJWvF9EvFojTkveNsl4WNbDGnsl1NG0H6QKaf0qhmGd
 C2n//kjPlSGWOrh1vG++QoRtWgfeiCqn6Peo+4mJ+jPNChktMg4XHvgZ3ccyC0OU8XDub1lIxAC
 6MLwbAnKy7NlaI+hRrw==
X-Proofpoint-GUID: 98w9pmmdeR9L49oMbTEGLTGBAHo9I3Pb
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c22 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=VJJ9atyF7iw2-Rhtw2oA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Add properties for most fields.

Properties that map to fields that are not supported by the linux kernel
(i.e. not in the ftr_bits array) are not included, as these fields
are already zeroed out by the kernel and are not writable.

Add new properties as kernel start supporting their respective fields.

These properties will be added to CPU objects in future patches.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-props.c | 242 +++++++++++++++++++++++++++++++++++++
 target/arm/meson.build     |   1 +
 2 files changed, 243 insertions(+)
 create mode 100644 target/arm/arm-cpu-props.c

diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
new file mode 100644
index 0000000000..1c5d4c5727
--- /dev/null
+++ b/target/arm/arm-cpu-props.c
@@ -0,0 +1,242 @@
+/*
+ * ARM CPU feature property definitions.
+ *
+ * Maps ID-register fields described in cpu-idregs.inc.h to user-facing
+ * QOM properties.
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "qom/object.h"
+#include "cpu.h"
+#include "arm-cpu-props.h"
+
+
+#define ARM_SINGLE_FIELD_PROP(prop_name, _type, reg, fld) \
+    { .name = (prop_name), .type = ARM_PROP_##_type, \
+      .u.field = ARM_FIELD_IDX(reg, fld) }
+
+#define ARM_FRAC_PROP(prop_name, base_reg, base_fld, frac_reg, frac_fld, valid_vals) \
+    { .name = (prop_name), .type = ARM_PROP_FRACTIONAL,                  \
+      .u.frac.base_field = ARM_FIELD_IDX(base_reg, base_fld),            \
+      .u.frac.frac_field = ARM_FIELD_IDX(frac_reg, frac_fld),            \
+      .u.frac.vals = valid_vals }
+
+const ArmFracVal csv2_frac_vals[] = {
+    { "0.0", 0, 0 },
+    { "1.0", 1, 0 },
+    { "1.1", 1, 1 },
+    { "1.2", 1, 2 },
+    { "2.0", 2, 0 },
+    { "3.0", 3, 0 },
+    { NULL }
+};
+
+const ArmFracVal mpam_frac_vals[] = {
+    { "0.0", 0, 0 },
+    { "0.1", 0, 1 },
+    { "1.0", 1, 0 },
+    { "1.1", 1, 1 },
+    { NULL }
+};
+
+const ArmFracVal ras_frac_vals[] = {
+    { "0.0", 0, 0 },
+    { "1.0", 1, 0 },
+    { "1.1", 1, 1 },
+    { "1.1_base", 2, 0 },
+    { "2.0", 3, 0 },
+    { NULL }
+};
+
+const ArmFracVal nv_frac_vals[] = {
+    { "0.0", 0, 0 },
+    { "nv2_only", 0, 1 }, /* KVM: MMFR2 always cleared */
+    { "1.0", 1, 0 },
+    { "2.0", 2, 0 },
+    { "2.0_only", 2, 1 },
+    { "2.1", 2, 2 },
+    { NULL }
+};
+
+const ArmCpuPropDesc arm_cpu_props[] = {
+    ARM_SINGLE_FIELD_PROP("feat_AES", STRING, ID_AA64ISAR0, AES),
+    ARM_SINGLE_FIELD_PROP("feat_SHA1", STRING, ID_AA64ISAR0, SHA1),
+    ARM_SINGLE_FIELD_PROP("feat_SHA2", STRING, ID_AA64ISAR0, SHA2),
+    ARM_SINGLE_FIELD_PROP("feat_CRC32", STRING, ID_AA64ISAR0, CRC32),
+    ARM_SINGLE_FIELD_PROP("feat_ATOMIC", STRING, ID_AA64ISAR0, ATOMIC),
+    ARM_SINGLE_FIELD_PROP("feat_RDM", STRING, ID_AA64ISAR0, RDM),
+    ARM_SINGLE_FIELD_PROP("feat_SHA3", STRING, ID_AA64ISAR0, SHA3),
+    ARM_SINGLE_FIELD_PROP("feat_SM3", STRING, ID_AA64ISAR0, SM3),
+    ARM_SINGLE_FIELD_PROP("feat_SM4", STRING, ID_AA64ISAR0, SM4),
+    ARM_SINGLE_FIELD_PROP("feat_DP", STRING, ID_AA64ISAR0, DP),
+    ARM_SINGLE_FIELD_PROP("feat_FHM", STRING, ID_AA64ISAR0, FHM),
+    ARM_SINGLE_FIELD_PROP("feat_TS", STRING, ID_AA64ISAR0, TS),
+    ARM_SINGLE_FIELD_PROP("feat_TLB", STRING, ID_AA64ISAR0, TLB),
+    ARM_SINGLE_FIELD_PROP("feat_RNDR", STRING, ID_AA64ISAR0, RNDR),
+
+    ARM_SINGLE_FIELD_PROP("feat_DPB", STRING, ID_AA64ISAR1, DPB),
+    ARM_SINGLE_FIELD_PROP("hw_prop_APA", STRING, ID_AA64ISAR1, APA),
+    ARM_SINGLE_FIELD_PROP("hw_prop_API", STRING, ID_AA64ISAR1, API),
+    ARM_SINGLE_FIELD_PROP("feat_JSCVT", STRING, ID_AA64ISAR1, JSCVT),
+    ARM_SINGLE_FIELD_PROP("feat_FCMA", STRING, ID_AA64ISAR1, FCMA),
+    ARM_SINGLE_FIELD_PROP("feat_LRCPC", STRING, ID_AA64ISAR1, LRCPC),
+    ARM_SINGLE_FIELD_PROP("hw_prop_GPA", STRING, ID_AA64ISAR1, GPA),
+    ARM_SINGLE_FIELD_PROP("hw_prop_GPI", STRING, ID_AA64ISAR1, GPI),
+    ARM_SINGLE_FIELD_PROP("feat_FRINTTS", STRING, ID_AA64ISAR1, FRINTTS),
+    ARM_SINGLE_FIELD_PROP("feat_SB", STRING, ID_AA64ISAR1, SB),
+    ARM_SINGLE_FIELD_PROP("feat_SPECRES", STRING, ID_AA64ISAR1, SPECRES),
+    ARM_SINGLE_FIELD_PROP("feat_BF16", STRING, ID_AA64ISAR1, BF16),
+    ARM_SINGLE_FIELD_PROP("feat_DGH", STRING, ID_AA64ISAR1, DGH),
+    ARM_SINGLE_FIELD_PROP("feat_I8MM", STRING, ID_AA64ISAR1, I8MM),
+    ARM_SINGLE_FIELD_PROP("feat_XS", STRING, ID_AA64ISAR1, XS),
+    ARM_SINGLE_FIELD_PROP("feat_LS64", STRING, ID_AA64ISAR1, LS64),
+
+    ARM_SINGLE_FIELD_PROP("feat_WFXT", STRING, ID_AA64ISAR2, WFXT),
+    ARM_SINGLE_FIELD_PROP("feat_RPRES", STRING, ID_AA64ISAR2, RPRES),
+    ARM_SINGLE_FIELD_PROP("hw_prop_GPA3", STRING, ID_AA64ISAR2, GPA3),
+    ARM_SINGLE_FIELD_PROP("hw_prop_APA3", STRING, ID_AA64ISAR2, APA3),
+    ARM_SINGLE_FIELD_PROP("feat_MOPS", STRING, ID_AA64ISAR2, MOPS),
+    ARM_SINGLE_FIELD_PROP("feat_BC", STRING, ID_AA64ISAR2, BC),
+    ARM_SINGLE_FIELD_PROP("feat_CLRBHB", STRING, ID_AA64ISAR2, CLRBHB),
+    ARM_SINGLE_FIELD_PROP("feat_RPRFM", STRING, ID_AA64ISAR2, RPRFM),
+    ARM_SINGLE_FIELD_PROP("feat_CSSC", STRING, ID_AA64ISAR2, CSSC),
+    ARM_SINGLE_FIELD_PROP("feat_LUT", STRING, ID_AA64ISAR2, LUT),
+
+    ARM_SINGLE_FIELD_PROP("feat_FAMINMAX", STRING, ID_AA64ISAR3, FAMINMAX),
+    ARM_SINGLE_FIELD_PROP("feat_LSFE", STRING, ID_AA64ISAR3, LSFE),
+    ARM_SINGLE_FIELD_PROP("feat_FPRCVT", STRING, ID_AA64ISAR3, FPRCVT),
+
+    ARM_SINGLE_FIELD_PROP("el0_mode", STRING, ID_AA64PFR0, EL0),
+    ARM_SINGLE_FIELD_PROP("el1_mode", STRING, ID_AA64PFR0, EL1),
+    ARM_SINGLE_FIELD_PROP("el2_mode", STRING, ID_AA64PFR0, EL2),
+    ARM_SINGLE_FIELD_PROP("el3_mode", STRING, ID_AA64PFR0, EL3),
+    ARM_SINGLE_FIELD_PROP("feat_FP", STRING, ID_AA64PFR0, FP),
+    ARM_SINGLE_FIELD_PROP("feat_AdvSIMD", STRING, ID_AA64PFR0, ADVSIMD),
+    ARM_SINGLE_FIELD_PROP("feat_SVE", STRING, ID_AA64PFR0, SVE),
+    ARM_SINGLE_FIELD_PROP("feat_SEL2", STRING, ID_AA64PFR0, SEL2),
+    ARM_SINGLE_FIELD_PROP("feat_AMU", STRING, ID_AA64PFR0, AMU),
+    ARM_SINGLE_FIELD_PROP("feat_DIT", STRING, ID_AA64PFR0, DIT),
+    ARM_SINGLE_FIELD_PROP("feat_CSV3", STRING, ID_AA64PFR0, CSV3),
+
+    ARM_SINGLE_FIELD_PROP("feat_BT", STRING, ID_AA64PFR1, BT),
+    ARM_SINGLE_FIELD_PROP("feat_SSBS", STRING, ID_AA64PFR1, SSBS),
+    ARM_SINGLE_FIELD_PROP("feat_MTE", STRING, ID_AA64PFR1, MTE),
+    ARM_SINGLE_FIELD_PROP("feat_NMI", STRING, ID_AA64PFR1, NMI),
+    ARM_SINGLE_FIELD_PROP("feat_MTE_FRAC", STRING, ID_AA64PFR1, MTE_FRAC),
+    ARM_SINGLE_FIELD_PROP("feat_GCS", STRING, ID_AA64PFR1, GCS),
+    ARM_SINGLE_FIELD_PROP("feat_DF2", STRING, ID_AA64PFR1, DF2),
+
+    ARM_SINGLE_FIELD_PROP("feat_MTESTOREONLY", STRING, ID_AA64PFR2, MTESTOREONLY),
+    ARM_SINGLE_FIELD_PROP("feat_MTEFAR", STRING, ID_AA64PFR2, MTEFAR),
+    ARM_SINGLE_FIELD_PROP("feat_FPMR", STRING, ID_AA64PFR2, FPMR),
+
+    ARM_SINGLE_FIELD_PROP("hw_prop_PARANGE", STRING, ID_AA64MMFR0, PARANGE),
+    ARM_SINGLE_FIELD_PROP("hw_prop_ASIDBITS", STRING, ID_AA64MMFR0, ASIDBITS),
+    ARM_SINGLE_FIELD_PROP("feat_BIGEND", STRING, ID_AA64MMFR0, BIGEND),
+    ARM_SINGLE_FIELD_PROP("feat_SNSMEM", STRING, ID_AA64MMFR0, SNSMEM),
+    ARM_SINGLE_FIELD_PROP("feat_BIGENDEL0", STRING, ID_AA64MMFR0, BIGENDEL0),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN16", STRING, ID_AA64MMFR0, TGRAN16),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN64", STRING, ID_AA64MMFR0, TGRAN64),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN4", STRING, ID_AA64MMFR0, TGRAN4),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN16_2", STRING, ID_AA64MMFR0, TGRAN16_2),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN64_2", STRING, ID_AA64MMFR0, TGRAN64_2),
+    ARM_SINGLE_FIELD_PROP("hw_prop_TGRAN4_2", STRING, ID_AA64MMFR0, TGRAN4_2),
+    ARM_SINGLE_FIELD_PROP("feat_EXS", STRING, ID_AA64MMFR0, EXS),
+    ARM_SINGLE_FIELD_PROP("feat_FGT", STRING, ID_AA64MMFR0, FGT),
+    ARM_SINGLE_FIELD_PROP("feat_ECV", STRING, ID_AA64MMFR0, ECV),
+
+    ARM_SINGLE_FIELD_PROP("feat_HAFDBS", STRING, ID_AA64MMFR1, HAFDBS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_VMIDBITS", STRING, ID_AA64MMFR1, VMIDBITS),
+    ARM_SINGLE_FIELD_PROP("feat_VH", STRING, ID_AA64MMFR1, VH),
+    ARM_SINGLE_FIELD_PROP("feat_HPDS", STRING, ID_AA64MMFR1, HPDS),
+    ARM_SINGLE_FIELD_PROP("feat_LO", STRING, ID_AA64MMFR1, LO),
+    ARM_SINGLE_FIELD_PROP("feat_PAN", STRING, ID_AA64MMFR1, PAN),
+    ARM_SINGLE_FIELD_PROP("feat_SpecSEI", STRING, ID_AA64MMFR1, SPECSEI),
+    ARM_SINGLE_FIELD_PROP("feat_XNX", STRING, ID_AA64MMFR1, XNX),
+    ARM_SINGLE_FIELD_PROP("feat_TWED", STRING, ID_AA64MMFR1, TWED),
+    ARM_SINGLE_FIELD_PROP("feat_ETS", STRING, ID_AA64MMFR1, ETS),
+    ARM_SINGLE_FIELD_PROP("feat_HCX", STRING, ID_AA64MMFR1, HCX),
+    ARM_SINGLE_FIELD_PROP("feat_AFP", STRING, ID_AA64MMFR1, AFP),
+    ARM_SINGLE_FIELD_PROP("feat_TIDCP1", STRING, ID_AA64MMFR1, TIDCP1),
+    ARM_SINGLE_FIELD_PROP("feat_ECBHB", STRING, ID_AA64MMFR1, ECBHB),
+
+    ARM_SINGLE_FIELD_PROP("feat_CNP", STRING, ID_AA64MMFR2, CNP),
+    ARM_SINGLE_FIELD_PROP("feat_UAO", STRING, ID_AA64MMFR2, UAO),
+    ARM_SINGLE_FIELD_PROP("feat_LSM", STRING, ID_AA64MMFR2, LSM),
+    ARM_SINGLE_FIELD_PROP("feat_IESB", STRING, ID_AA64MMFR2, IESB),
+    ARM_SINGLE_FIELD_PROP("hw_prop_VARANGE", STRING, ID_AA64MMFR2, VARANGE),
+    ARM_SINGLE_FIELD_PROP("hw_prop_CCIDX", STRING, ID_AA64MMFR2, CCIDX),
+    ARM_SINGLE_FIELD_PROP("hw_prop_ST", STRING, ID_AA64MMFR2, ST),
+    ARM_SINGLE_FIELD_PROP("feat_AT", STRING, ID_AA64MMFR2, AT),
+    ARM_SINGLE_FIELD_PROP("hw_prop_IDS", STRING, ID_AA64MMFR2, IDS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_FWB", STRING, ID_AA64MMFR2, FWB),
+    ARM_SINGLE_FIELD_PROP("feat_TTL", STRING, ID_AA64MMFR2, TTL),
+    ARM_SINGLE_FIELD_PROP("feat_BBM", STRING, ID_AA64MMFR2, BBM),
+    ARM_SINGLE_FIELD_PROP("feat_EVT", STRING, ID_AA64MMFR2, EVT),
+    ARM_SINGLE_FIELD_PROP("feat_E0PD", STRING, ID_AA64MMFR2, E0PD),
+
+    ARM_SINGLE_FIELD_PROP("feat_TCRX", STRING, ID_AA64MMFR3, TCRX),
+    ARM_SINGLE_FIELD_PROP("feat_SCTLRX", STRING, ID_AA64MMFR3, SCTLRX),
+    ARM_SINGLE_FIELD_PROP("feat_S1PIE", STRING, ID_AA64MMFR3, S1PIE),
+    ARM_SINGLE_FIELD_PROP("feat_S1POE", STRING, ID_AA64MMFR3, S1POE),
+
+    ARM_SINGLE_FIELD_PROP("feat_E2H0", STRING, ID_AA64MMFR4, E2H0),
+
+    ARM_SINGLE_FIELD_PROP("feat_DBG", STRING, ID_AA64DFR0, DEBUGVER),
+    ARM_SINGLE_FIELD_PROP("feat_PMU", STRING, ID_AA64DFR0, PMUVER),
+    ARM_SINGLE_FIELD_PROP("hw_prop_BRPS", NUMERIC, ID_AA64DFR0, BRPS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_WRPs", NUMERIC, ID_AA64DFR0, WRPS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_CTX_CMPs", NUMERIC, ID_AA64DFR0, CTX_CMPS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_PMSVer", STRING, ID_AA64DFR0, PMSVER),
+    ARM_SINGLE_FIELD_PROP("feat_DoubleLock", STRING, ID_AA64DFR0, DOUBLELOCK),
+
+    ARM_SINGLE_FIELD_PROP("hw_prop_SVEVer", STRING, ID_AA64ZFR0, SVEVER),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_AES", STRING, ID_AA64ZFR0, AES),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_ELTPERM", STRING, ID_AA64ZFR0, ELTPERM),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_BITPERM", STRING, ID_AA64ZFR0, BITPERM),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_BFLOAT16", STRING, ID_AA64ZFR0, BFLOAT16),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_B16B16", STRING, ID_AA64ZFR0, B16B16),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_SHA3", STRING, ID_AA64ZFR0, SHA3),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_SM4", STRING, ID_AA64ZFR0, SM4),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_I8MM", STRING, ID_AA64ZFR0, I8MM),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_F16MM", STRING, ID_AA64ZFR0, F16MM),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_F32MM", STRING, ID_AA64ZFR0, F32MM),
+    ARM_SINGLE_FIELD_PROP("feat_SVE_F64MM", STRING, ID_AA64ZFR0, F64MM),
+
+    ARM_SINGLE_FIELD_PROP("feat_F8E5M2", BOOLEAN, ID_AA64FPFR0, F8E5M2),
+    ARM_SINGLE_FIELD_PROP("feat_F8E4M3", BOOLEAN, ID_AA64FPFR0, F8E4M3),
+    ARM_SINGLE_FIELD_PROP("feat_F8MM4", BOOLEAN, ID_AA64FPFR0, F8MM4),
+    ARM_SINGLE_FIELD_PROP("feat_F8MM8", BOOLEAN, ID_AA64FPFR0, F8MM8),
+    ARM_SINGLE_FIELD_PROP("feat_F8DP2", BOOLEAN, ID_AA64FPFR0, F8DP2),
+    ARM_SINGLE_FIELD_PROP("feat_F8DP4", BOOLEAN, ID_AA64FPFR0, F8DP4),
+    ARM_SINGLE_FIELD_PROP("feat_F8FMA", BOOLEAN, ID_AA64FPFR0, F8FMA),
+    ARM_SINGLE_FIELD_PROP("feat_F8CVT", BOOLEAN, ID_AA64FPFR0, F8CVT),
+
+    ARM_SINGLE_FIELD_PROP("hw_prop_IMInline", NUMERIC, CTR_EL0, IMINLINE),
+    ARM_SINGLE_FIELD_PROP("hw_prop_L1IP", STRING, CTR_EL0, L1IP),
+    ARM_SINGLE_FIELD_PROP("hw_prop_DMInline", NUMERIC, CTR_EL0, DMINLINE),
+    ARM_SINGLE_FIELD_PROP("hw_prop_ERG", NUMERIC, CTR_EL0, ERG),
+    ARM_SINGLE_FIELD_PROP("hw_prop_CWG", NUMERIC, CTR_EL0, CWG),
+    ARM_SINGLE_FIELD_PROP("hw_prop_IDC", BOOLEAN, CTR_EL0, IDC),
+    ARM_SINGLE_FIELD_PROP("hw_prop_DIC", BOOLEAN, CTR_EL0, DIC),
+    ARM_SINGLE_FIELD_PROP("hw_prop_BS", NUMERIC, DCZID_EL0, BS),
+    ARM_SINGLE_FIELD_PROP("hw_prop_DZP", BOOLEAN, DCZID_EL0, DZP),
+
+    ARM_SINGLE_FIELD_PROP("cpu_revision", NUMERIC, MIDR, REVISION),
+    ARM_SINGLE_FIELD_PROP("cpu_partnum", NUMERIC, MIDR, PARTNUM),
+    ARM_SINGLE_FIELD_PROP("cpu_architecture", NUMERIC, MIDR, ARCHITECTURE),
+    ARM_SINGLE_FIELD_PROP("cpu_variant", NUMERIC, MIDR, VARIANT),
+    ARM_SINGLE_FIELD_PROP("cpu_implementer", NUMERIC, MIDR, IMPLEMENTER),
+    ARM_SINGLE_FIELD_PROP("cpu_revidr", NUMERIC, REVIDR, VAL),
+    ARM_SINGLE_FIELD_PROP("cpu_aidr", NUMERIC, AIDR, VAL),
+
+    /* Fractional properties */
+    ARM_FRAC_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC, csv2_frac_vals),
+    ARM_FRAC_PROP("feat_MPAM", ID_AA64PFR0, MPAM, ID_AA64PFR1, MPAM_FRAC, mpam_frac_vals),
+    ARM_FRAC_PROP("feat_RAS", ID_AA64PFR0, RAS, ID_AA64PFR1, RAS_FRAC, ras_frac_vals),
+    ARM_FRAC_PROP("feat_NV", ID_AA64MMFR2, NV, ID_AA64MMFR4, NV_FRAC, nv_frac_vals),
+    { .name = NULL }
+};
diff --git a/target/arm/meson.build b/target/arm/meson.build
index be4361fbfd..ae1c55c802 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -12,6 +12,7 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c',
   'cpu-idregs.c',
+  'arm-cpu-props.c'
 ))
 
 arm_common_ss.add(files(
-- 
2.52.0

