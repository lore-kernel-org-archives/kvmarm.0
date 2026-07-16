Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDE23368AA
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237995; cv=fail; b=dfKvev2q8/OwfVztaxrSrrNHkmfnyCeOlD9vWExDPlsC/xODRpODL+2G/zgRfBz7jCX9EvebaD1KG4p/trQIzvq7oQbf0IrQwyfmvPuyZWJ9SPv6kZhLboPetvDLQZ59bqU8thO6bDbfhKRXSJU+CWpSRSB79gNznUFHkPzizpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237995; c=relaxed/simple;
	bh=6y525sJ84wRTke7iV6cRjYnOKX3IWIUVTWxpKL/ACUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kzGaWm8bgQ34LlRlCkKgZBN9amZiNUSS8mmmMqKWotapDj4NgNXK5u4IIvIEN+mHtNVnrUTixJlH/8aH+E4lunb63b9eqWnS3eWynD9HG7PMPjijuwVTT+2jt32671t7c7FzJuoab/6DJY/M7GW5WeeTDW2nD1ck3JB/xdLuxI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QSqEiWia; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Nm4YfI0e; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QSqEiWia";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Nm4YfI0e"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhr1763910;
	Thu, 16 Jul 2026 14:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=zvekfeQcqWHs8d8UDsTB37Cna0DrgJXCV1RYs3py1
	X4=; b=QSqEiWiaiTqOdekvZWm5E/WMrRPoC631RnEBUt5IvtL8qgMnaMCeRCWJO
	84ie4uz8MX9UhopyS/fT2ciY9f6tQ+1y6tlyylosrEW3ce73SXFFkfluvuYMuOIw
	SFdYomnl5j2pppM66xLfWMAS4wgTTUnE2BTdFc5U0SUPcePgoXsET0rR6NkhH+MY
	FHR/Urg0WFEdjqoqUInNtbIGvvFMSfbV/sREf2go+7TedTjG0NfqfutvGDlgoAEZ
	lSdWMWkG98LzoA41T6AZ8bBzz7HhR57fFzlHP+emH8VjwhbOl/PavYpoxiAq1Su0
	2DGjTo/pHrWytfWxS1W0gCVg00zLg==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-9
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bI4FKzNX9rqYNg47tH2HjNQNwYNDCHb9ewS7VhSbCb9i/wpWSlhO/nClwId1KevFOt5lJC8NX7aF5FCxwgHE/aosUaIgDo9oNEgpfe5HR5yxWcLUd9TkO1MlWf6pMw5I6g5h0PTLOWgjGNlZjZ3/z1gxAAm4d6zmHQh0Qq39ZFcSt0jfvKi8Nha+3OWPeZ9J4AHcwGMx7r+7Vw78K4RanLg/3rDHrNpjXCUwpu9KFo5OFAPfvkSzVxvAr7dSKHk5PalCy2Yuq1FLjA3CLDERGEUmFrS9osscgHgoYx0WFfRk47Er0ZaazJusPAwJ2QctyzP05y4Ax1APuIgo3xctQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvekfeQcqWHs8d8UDsTB37Cna0DrgJXCV1RYs3py1X4=;
 b=afzXNNFAkiA+ud8ap4Dt48yZomBsgQ+098TytZW0xA4tSk3ASwvDX+to0eqR/4fL1KQ/a6kZTOqKorLgs0xBuTBXbQa/QQVd6Qmj6y2cJpldjdjyeJP5munSXBLs1lLpbDFQlRtl3hnDCWufzcoOoj8dxKDgtHF+xtIEZ6fOU33g0P8NaxiEjzUBKuzk3yqjtIF7CqVR5SFhS8j4nF+0yP4ZfsXiFX2RpGkJy1MKeb3Xtfn3kvL0TUIDWyWKe/JzqpFX/6UwdJfq5gGPIco6AXAaecu55YDd4+xhd6mRwEhegnc0aALkaSuf5TI9oiF0iprEC+j4WAe1JkHh8ltNXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvekfeQcqWHs8d8UDsTB37Cna0DrgJXCV1RYs3py1X4=;
 b=Nm4YfI0e1vNUnB/6xbzHrUWdJ/tFr2S2l2NoTwrhEA/dtoUoyHqF4uFPN/7KZtI98kgO3KP2rJBJNsGklRQXQiTpXKKjAahFD28+15H3LiJX+dsau0djd4fruIwJt3zgSVkUoAT+xgvrAC3oMRFUw62SG3trtol0KXaTpHE4nNc9VIKJhMmymAGe7+kSJU2DuBdbB9v0wlVw9fnh8lDWLEobmiYu6JKc5Oza2xrtLr59jcw2YMCdnWlT7g8cAUfjCQpPDyBjaMq+1caMfSWwLHUSQbWgHlS/1xCxajoGb4d6BITBVuOVut/j6a4VRbNjNx0r5ySofpj0dRBGQxauUA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:33 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:33 +0000
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
Subject: [RFC PATCH v3 08/19] target/arm/kvm: Handle writeback for special ID register fields
Date: Thu, 16 Jul 2026 21:38:47 +0000
Message-ID: <20260716213858.609699-9-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 132a4cbe-35e4-4d2c-e7f1-08dee382b997
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	rzcu3iWIYKnenXR8muV+q/0TZDveL8IrtqLwBX0A0x1G5Pu+jPflCvtjqp0xVnlvczq12t6A5TGGqUkIggDqqgXkd3PEiUePPtmZpdJM8gkwwnBihKOxh07oZn5vE0FEneRCOs8y1tp3NClfhOz/mS6JcotoZ3OHaRbSUIS5tZ50/UfAPZ/7vooq17jUz1RHysTBz9Uz+JRaJKxTQgG1qrg+ZXhUUPmgMIc7hI5umMpqvY1bAqtc04no+VWqri3LSIQ1lCWBx9+h0Xt7tD2Kl4ZvHQUfVk8aHzgHJq7s5tu2iqQUI9cI56O3PzAdOfSWwvf8Q5s7RfPc3IlW4zIhdDZ74MuZsIe7LxkPEAtmWpkE9Veo2dICXu/+n1pB2ewELdAFsNSEdpsKou+7aveVFxUJi7pCDmMAgH+/dPwF7qEL2fEZPvgVL9UNglutiPrDtlr9lOJqlGVJOb0BAG+T2WpYMZvyQVtA6CzNNQ/J2InvisYQac+Df89wwVvIA0aliH2an26H+kOB0E6Bv+0nm/RMPHMcxJMxj9GUH3nOiscWLeITY8Vaa8eJPxvV/yXrxJqbZ0MUem76GUAQrlBoXsSBHc+o++5Jl5iq4y0iGoVmcSHwz7T/JZlXjzXs7BYoyS+WGC9R014d8aeDMnI3OLtTHWvBlluEwU0Vr+/uMNw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KuTS+DFZdpMxbTrOV1HlyrCOwL8Rgr5idjLu6XW5KT0mmlNqoD/m4HRxZ/Mh?=
 =?us-ascii?Q?dVeAFkdBEaxebfNEhYrwpUCa4RsjwXgSip9dtOOAyLbM1UrTYPnPGxP7MKHB?=
 =?us-ascii?Q?OTyMrXF0oCHNs7lTGuh+vavUYFQyX1/q9mt9PLLxLPV8BN4uQz0tIn+pkkNe?=
 =?us-ascii?Q?MB240aoFo0mGgC71sHAKdy9CfEgeflwkmVLa3CTILrahJ8niyCH6SwLaEJWs?=
 =?us-ascii?Q?jXFgjpe4zxBCq+0hsBtaCab/RNJ/VwF3HPOxRaFtNXPMJtfOXZ0wVex2TcB4?=
 =?us-ascii?Q?oSJggSxOX/GAk7PUq8fekcQCwKK28AvbuGdDPWoAnjC8EXevRJVMxtUFRTkd?=
 =?us-ascii?Q?xx2H7oi0V0oRroRb9Fb+ToSIWaNzNeXBE6etN5N4U1Rl010isql2zon/MlJv?=
 =?us-ascii?Q?L70Qw5tQrbGV/4temXe7PftG3h+9SHMngu0U6Q9ODLLVxrED6ns2n/+MxHxt?=
 =?us-ascii?Q?7qeUqiPgMYpxv50nkKDHclJK7jgS+BWgi0yJ/HjYzE1tWhuJRe+FR8mWvujA?=
 =?us-ascii?Q?dAWF3tZYt5ke6NO8Syp2x+ax6fnqgCz8rf/Dz+QrWZO/0A9Y5mHgnIes22i8?=
 =?us-ascii?Q?4mD/2OUk9R3Y4YBI+/SpcTTR/pXx2o2IXQsc9wDhdtLqiT/VmAXh4QaeryFO?=
 =?us-ascii?Q?BH1cUITeKR/y07kYJtURCaXyAd2JIELDp45MNWRo3wujuUtN0FxZbPgIQzXK?=
 =?us-ascii?Q?sJnut8KU65jMWTYeWekWSerLbL8bDwXyv9qitq77MmmCOW+IjAxkLcTBLDYp?=
 =?us-ascii?Q?b6EOqPZJ20v50ygyScLC/04JhVV1qskG31Oth/lu0jmhfQWmvCAk4oUHsP/z?=
 =?us-ascii?Q?Af14qARpN/vEDgPlvhZ1F6v52dtoWdiZ6mUfg7afpEgK1UriQ1CPYjO7gFC3?=
 =?us-ascii?Q?lgm+dzooIaseaOY/Lc9DFProW5E3uxaLmiyqPcELvtr1AI7VdvyomANcv3ei?=
 =?us-ascii?Q?e0eygJh6Q4hRm1T8lr/Z6nuOMYcgq7igbJ7UVsyjKvQOcrQc2JUAWefP/2vz?=
 =?us-ascii?Q?e6VADva+lwsAkj4Zz64u4bL/JoM/7WeBdD4emDCs6NNex1U7NiH3LRC6ALDQ?=
 =?us-ascii?Q?ALyDITJQVZ6dtgTRTxIo75Mo3OE9bzKFpF2WNQoQ5twc+b9Esp0KDIB5FXh1?=
 =?us-ascii?Q?q2NjImrj5PEusRxdgWctHkP/VgXYDCvoW4bvYiPwVj3ayalsg5O0AgrcLOhA?=
 =?us-ascii?Q?hXgKvDQuEKwof8XhgPdyrHTEhaKyVnTFyq4XLJvbkV5soK9GJ32CG3D2rSCe?=
 =?us-ascii?Q?fMc9H7hXRM9SIl7Ex/LCxnmZeNm/FGR1u55AfXC20cRibr57xhdnpZAa6tWx?=
 =?us-ascii?Q?SpsVGzK1fPFLaSwdLktmnMhpUqrie9QjaKW6/lrL4VIRMDySLMD/JFFpK2pQ?=
 =?us-ascii?Q?6XVp2+GD7m7bXVtIgKbJFYEuIkEWW9ApruoKoCK0O3fuq9pxa5u/GGXpT9YW?=
 =?us-ascii?Q?y9FjTQdWr8LyL2FoLPmHOZHEksx3zb+pHoz8DHHw4bampNU9eR6h61Bye2L8?=
 =?us-ascii?Q?XAEcywPjbwnPKYY1qqjyugvW9uEQhrcs2qx3fxfAL0F1uKY6DsB3BSehcef6?=
 =?us-ascii?Q?lbhqDMoMbV9SILtc4dBnph8oBxxzTTlv9fRm7A4fAN6O/DObDlOh51Oe7GWT?=
 =?us-ascii?Q?rMO7GDLcvBe9+TeVRcYH9MulvJ0ieuyfu1RFQm9esTtg2unrVmYKXfhbGvWG?=
 =?us-ascii?Q?01qa9NjOAUkP1l1FCtZdbd0kh3oPYAGiFevmBQgyrQxZrdDFNCPWCTmKDmy2?=
 =?us-ascii?Q?h7ZzJKIjq82VZ56BbWKPe5uCAes+VvE=3D?=
X-Exchange-RoutingPolicyChecked:
	A+AgWtJx3nI5p+htzhf4kkmN2HX1siVVotai63jRUzILvMznG4QQtNDc4bQMmhd9quF35+hb3D3ERMcJYr59u0xKd3KPF+iXRLThLwDZDnq8KvAEuCT/umHunO0MNge+uzV/VswL/T0eAGr6eVL8R2qj9Rf5tZR9ol7oS0BXCt81dr9TvUv0ngePzVu+7TBIeJBrOnueUgwe8m2PjW2ql3B0UbK4qvhR33xIQ0IwLJ05gKkrryyvjcECy/36eFDCtOY31i6THTVi/WNewT/ij5A6/mtn3W7VegvRoXJOJxeQzdGVZMjE1msP9/Z0aB4FDT/Se860AJQylXZsZpFjOg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132a4cbe-35e4-4d2c-e7f1-08dee382b997
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:33.3437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vj94gShHwbiQN/75/J3a/99yHDXjsmLr4Vz8qQPBOzgE0vZmtLKiq/V5/lTwibH1J6hIPboGxj4clByHJSMRZ10x3C4U6AMrGg6akXSnJqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX7/bCE+65Ns31
 AT96CwvrXW4744GW/uoURyBcS0GnxanZPtwCejItg12CPLcAfiQyA9i+gy41mANjSQh0jWhwO/B
 Efwakbjzw656wiV6+R/iBj1U9sj/w8sZtH9Oq/2SRnthtaiUdjuzE5XWMBvnrVUkXGHgGu4dcep
 AfZqn4aBgoig/O5r+3Gxz3IvUujoUhYfMn8AWPeF8AFuffHndMdQqzfBdHNujkYahhvFoFUVOp1
 TVjgZgbmG2IknEac7Xcsmwyay9UBmIarezVO9kJpYg+33YprapZQrSINkg2FDscXhklNr3tF6qN
 JGN8Ul48qTR/os080KABw3v7X/h3HkyxlAUiRzKc8VkCaAL00RL1Xz/OKTuc0uFuYrXxF1HTtPU
 VLPPZxXK2inB2qe/eUwUomV0Yd9CAPV9UEVv396JC9YKxRIVB+JLic5DzdD6hCHFTswUoF+qnq4
 uNg52tW1rqmbXkYTC5w==
X-Proofpoint-GUID: UnD6zOjytkDdx3IIiio5aOav2AgMqFXp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXxohzbxRZ/l45
 7MoZsCPlB8ww8D/vG65qk3zZpwrX+Lx49Mb2BIIkVOIOYuJmO0EVj8Pr6mnV2sN7rFXzS5UCw2f
 L/M62df/iOhz+ocrNdoQCvOMJrI8nyw=
X-Proofpoint-ORIG-GUID: UnD6zOjytkDdx3IIiio5aOav2AgMqFXp
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f99 cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=OgtRPnsIBCFWunfy8BcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Some fields should not be written back to KVM for various reasons:
 - ID_AA64PFR0_EL1.GIC / ID_PFR1_EL1.GIC are fabricated by KVM based on
   the gic-version property.
 - KVM does not allow writing 0 to ID_DFR0_EL1.CopDbg, which breaks
   booting an AArch64-only guest on a host that also supports AArch32.
 - ID_DFR0_EL1.PerfMon is populated by KVM even for AArch64-only guests
   but is not writable there.
 - MPIDR_EL1 is managed by KVM based on vCPU index.
 - Hold off writing back CLIDR_EL1 until we properly support exposing
   cache topology to a KVM guest.

Some registers such as DCZID_EL0 are not exposed through the KVM cpreg
list at all, but guest still sees the host value, we verify that vCPU's
ID regs values match the host value.

To do this, refactor kvm_arm_writable_idregs_to_cpreg_list to
kvm_arm_write_idregs_to_cpregs_list, which operates per field and now
returns an error if a non-writable field mismatches with the host value.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c |  19 +++++++
 target/arm/cpu-idregs.h |   4 ++
 target/arm/kvm.c        | 116 ++++++++++++++++++++++++++++++++++------
 target/arm/trace-events |   2 +-
 4 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index c41d0ab0c4..6fa02af0f3 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -7,6 +7,7 @@
  *  SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "qemu/osdep.h"
+#include "qemu/bitops.h"
 #include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "cpu.h"
@@ -94,3 +95,21 @@ ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
 #include "cpu-idregs.h.inc"
 };
 
+uint64_t arm_get_field_mask(const ARM64SysRegField *field)
+{
+    return MAKE_64BIT_MASK(field->shift, field->length);
+}
+
+bool arm_field_is_writable(const ARM64SysRegField *field)
+{
+    uint64_t field_mask = arm_get_field_mask(field);
+
+    return (arm64_id_regs[field->index].writable_mask & field_mask)
+           == field_mask;
+}
+
+bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
+                   const char *name)
+{
+    return field->index == index && !strcmp(field->name, name);
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 245f1c8103..d866bd9e0a 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -38,4 +38,8 @@ typedef struct ARM64SysReg {
  */
 extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 
+uint64_t arm_get_field_mask(const ARM64SysRegField *field);
+bool arm_field_is_writable(const ARM64SysRegField *field);
+bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
+                   const char *name);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6974e5c551..c38b99cfce 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -951,6 +951,16 @@ static uint64_t *kvm_arm_get_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
     return &cpu->cpreg_values[res - cpu->cpreg_indexes];
 }
 
+/* Like kvm_arm_get_cpreg_ptr, but returns NULL if the register is not found. */
+static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
+{
+    uint64_t *res;
+    res = bsearch(&regidx, cpu->cpreg_indexes, cpu->cpreg_array_len,
+                  sizeof(uint64_t), compare_u64);
+
+    return res ? &cpu->cpreg_values[res - cpu->cpreg_indexes] : NULL;
+}
+
 /**
  * kvm_arm_reg_syncs_via_cpreg_list:
  * @regidx: KVM register index
@@ -1252,32 +1262,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
+{
+    /*
+     * GIC is controlled by the gic-version property and fabricated by KVM
+     * when the vGIC device is created, so a named CPU model must not touch
+     * it. KVM also rejects writing 0 to ID_DFR0_EL1.CopDbg, which breaks
+     * booting a model that lacks AArch32 support on a host that supports
+     * it. MPIDR_EL1 is managed by KVM based on number of vCPUs, skip
+     * writing it back. Similarly, skip writing back CLIDR_EL1 till we
+     * properly support exposing cache for KVM guest.
+     */
+    return field_matches(field, ID_AA64PFR0_EL1_IDX, "GIC")
+        || field_matches(field, ID_PFR1_EL1_IDX, "GIC")
+        || field_matches(field, ID_DFR0_EL1_IDX, "CopDbg")
+        || field->index == MPIDR_EL1_IDX
+        || field->index == CLIDR_EL1_IDX;
+}
+
+static bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
+{
+    /*
+     * KVM populates ID_DFR0_EL1.PerfMon even for AArch64-only guests but
+     * does not expose it as writable there, so skip it when it is not
+     * writable.
+     */
+    return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
+}
+
 /*
- * Copy writable ID regs from isar.idregs[] to cpreg_list
- * in case their value differs from the original init cpreg value
+ * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
+ * so the subsequent write_list_to_kvmstate() pushes them to KVM.
+ * Only writable fields are copied; fields that must not be written back
+ * (see arm_field_skip_writeback_*) are skipped.
+ * Returns -1 if any vCPU's ID reg value differs from the host value and the
+ * field is not writable.
  */
-static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
+static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
 {
     for (int i = 0; i < NUM_ID_IDX; i++) {
         ARM64SysReg *sysregdesc = &arm64_id_regs[i];
         ARMSysRegs sysreg = id_register_sysreg[i];
-        uint64_t previous, new;
+        uint64_t writable_mask = sysregdesc->writable_mask;
+        uint64_t desired = cpu->isar.idregs[i];
+        uint64_t previous, updated;
         uint64_t *cpreg;
 
-        if (!sysregdesc->writable_mask) {
+        cpreg = kvm_arm_find_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
+        /*
+         * Registers such as DCZID_EL0 are not exposed through the cpreg
+         * list and are therefore not writable. Use the host value
+         * snapshotted at probe time as the reference to check the vCPU ID
+         * regs have the same value.
+         */
+        previous = cpreg ? *cpreg : arm_host_cpu_features.isar.idregs[i];
+
+        if (previous == desired) {
             continue;
         }
 
-        cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
-        previous = *cpreg;
-        new = cpu->isar.idregs[i];
+        for (int j = 0; j < sysregdesc->fields_count; j++) {
+            const ARM64SysRegField *field = &sysregdesc->fields[j];
+            uint64_t field_mask = arm_get_field_mask(field);
+            uint64_t prev_val = previous & field_mask;
+            uint64_t new_val = desired & field_mask;
+
+            if (prev_val == new_val) {
+                continue;
+            }
+
+            if (arm_field_skip_writeback_always(field) ||
+                (!arm_field_is_writable(field) &&
+                 arm_field_skip_writeback_if_not_writable(field))) {
+                /* Never write this field back; keep KVM's value. */
+                writable_mask &= ~field_mask;
+                continue;
+            }
+
+            if (!arm_field_is_writable(field)) {
+                error_report("%s.%s is not writable: host=0x%" PRIx64
+                             ", requested=0x%" PRIx64,
+                             sysregdesc->name, field->name,
+                             prev_val >> field->shift, new_val >> field->shift);
+                return -1;
+            }
+        }
+
+        if (!cpreg || !writable_mask) {
+            continue;
+        }
 
-        if (previous != new) {
-            *cpreg = new;
-            trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
-                                                        previous, new);
-         }
+        updated = (previous & ~writable_mask) | (desired & writable_mask);
+        if (updated != previous) {
+            *cpreg = updated;
+            trace_kvm_arm_write_idregs_to_cpreg_list(sysregdesc->name,
+                                                        previous, updated);
+        }
     }
+
+    return 0;
 }
 
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
@@ -2235,8 +2318,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (ret) {
         return ret;
     }
-    /* overwrite writable ID regs with their updated property values */
-    kvm_arm_writable_idregs_to_cpreg_list(cpu);
+    /* overwrite ID reg fields with their updated property values */
+    ret = kvm_arm_write_idregs_to_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
     ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
     if (!ret) {
         return -1;
diff --git a/target/arm/trace-events b/target/arm/trace-events
index f33b0d821d..f042ab59b8 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -14,7 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
-kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
+kvm_arm_write_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
 
 # cpu64.c
 get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
-- 
2.52.0

