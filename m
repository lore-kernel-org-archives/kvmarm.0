Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339023C988D
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237998; cv=fail; b=AchvO7imsPgCefqpNDoDX9UfKawE02ymXRRxoR7ub1CdyTt+wtIXzZhq8TcZGWb62Kl/OYF2gcfOiMAzg/TodJQ2ayhaDwivDF13nXYzZxNhsxTh6164LC86ETdJ5EiocwFpRJeu6dDgwuQwxBW5ej7x7C1dRGO3QCrUDRgwrSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237998; c=relaxed/simple;
	bh=jj4g0ERqvSPGqWgjLzpSdbSzLwcwEVrAhvjvc1MrnBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cRW2jWJPM+CiNEfYD/QysRPEtcBkTYwDE9cMSp7XghwijmiOl7VQtF6tn2MkPiiRIrvAEG9QMH43v2JE962iXtyU43m0u25VKLrvKig7Kyst/rzZCk2UvxmnsVUdPpD4anx7azd6BusgJRpWx7qtcyDb3IbUYbvy+oh6gFENd/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Je4pL7NL; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=l6IyTBb/; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Je4pL7NL";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="l6IyTBb/"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhw1763910;
	Thu, 16 Jul 2026 14:39:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=7XpSfTTOZcwSLfQR/4RCKyp1WfFPozFlnQJD1YftR
	iw=; b=Je4pL7NLwqRPjokPmLBVVjB31+qdRedXiiiJ5zSv+x+OOY71Gl50+6FjH
	EJFg7FAJXuq5HgtOR20DM1jScQQwXbsofClRctB4bAf8f1yhieT2AlaufAZRV/kQ
	MyRic6BG7FOGUZMNMbr5Aj7z7F11uBObMecKwUxeJnoxsVuzooyyf3Yg2ApnlZ10
	ybNvVOgze9Xh3mJPtiClyrXIhr03fkNX4KUbpz1Y7rYMhkrgK7/0EVTrDqbcWkVC
	wmWdDwPVPotkPqRYUJZOf94R06mSbcY8fihLcTsyafQIBmqT8f7DX1DtlXLtHb4Y
	t9IkBl6iIixKRGMPC1BK2Sslor56g==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-14
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7j86m4IcMUwJGLbholWlE6mJriqTBwBhddvUCj2lbGmWxCab6XmWrenvKqSGW4yP9RzcZgdab0QZV7B2L/dw73Q2oAEFp0mD2+prvg81NMk1cp9uSfNF47r5A6Xhq0SBh289Q2gej+7eBAeJN1mZR6cAdnYiDEfVxcLAzKy1CzH/4QyCuDfejeZf9TudMwv4YWoYRwhndBx1O8fip0LAdvSH9mIOasImSFeX5O4jUCerQ/r10sKx17htFXFk27uCbxkvfkVlu0Uhsef2MrYiqxAb6nC1+Yuo5+50L6gFtAohc/pee2m/5evDvSAbCm29l92wVDV0u05d1FsYfCGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XpSfTTOZcwSLfQR/4RCKyp1WfFPozFlnQJD1YftRiw=;
 b=kNlZlFQ0DpWAoX92PuUgovBqVXEdWNQMVLjPNjbIwY0EvgNpTvjuVauNCfNb7R6Wwkc9JEP0npLSj/h4vVSQ07Gx35KJBkGsy24jNZTkXNg2ZO1TaSLskmoMJc7IKJYzJcx+MXzDap3r4u4Hz7OWa6bACst+K3x/vI6Bi9LkYZAnxA/4tlOscDirhKxenJ0hKlV+qUX8OQJGljcH+BzrBoosqLZTpSaRaVnP1WE0y2jFtETm9HB2CkFGqWBQj1SPBHVNYh1JNdrEpAo5ZJkGm5OeXbiyF05eKclsYUlosA637acbUuvfFEewa7TtzpEQ+E3RZoj0/MNcgsV49pT4CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XpSfTTOZcwSLfQR/4RCKyp1WfFPozFlnQJD1YftRiw=;
 b=l6IyTBb/rs07wjboK9Gv6D/7z8nJsQvo9xcKEZqmsMZoutxD3pmQ7E9iuaPzTWGwp+urpHUPw5YAJLaP0iZDnFAzTZW8hgg9YLyWvY4cspqkyDtSd0nrCunh729drdeXtqx42kZQ+25oM41ANtxwPRZw6VxwGafdoF0iu2ISryJRujhk1HZi0TuDmwoJo9BnPKPS3GjPpPnMZehsjsivnQsM6sQ0nCjV6Hfx1Iu0Wr6MN5ZChWR/HII4brTNjI3CqNIH4WSP5pk8Sb/AnhWrGWglHL7+lDvaE4Ow6gtdtZBHBTPDIx3qlz6Pbx/O6sI4o2uan82epzxXRx823FtaBQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:37 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:37 +0000
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
Subject: [RFC PATCH v3 13/19] target/arm/qmp: add named models and properties to cpu-model-expansion
Date: Thu, 16 Jul 2026 21:38:52 +0000
Message-ID: <20260716213858.609699-14-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9c6eeac7-1a5b-4bf5-466e-08dee382bbea
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	HxETs8bXWVidcvl3WpOV1kh4oJ7znlSRvhCAu9uvLPi0/5uXa7yzbmdO6j5fTWcEm/U23Sm5vssgp+D/riJyJz1whJv0nWzZXLcGSF7cTm7k9fg96iYMNnTFfgsp/wN7vOrgFi651A5F6TulrK23hhzRrkiFMAV2LznCKdpkDEurMEF+CF9pF1pHmgb4FDWvbscuhaWfkqJt5QXbmiP3CVPj6FL9hw8zKZMNBwdkV8THGxNRtT4RI0CzFOBzv4DTOcvp2v1pSqyhvgFH6NE1Tsu4ynEMAQOBkYgoIFo23nzeO1oNkWl0tEkiAP0y1PMevxKKQYTfMX/HsmFzbFjNt4ZH7cr/JIaKVDj+Me+qa3wcrj1QVvCheQyIB5QJC0guRJrZPOORjI7+5NMSgaFIEcSd56pYB2U1C5+9ahRQO64zn2FMBnM1s63dLCkgkq8S53ImE78KzmX9CG5WE24Ef49rZl37AXZ2zYgGU0yFVJAbWs/Fold8U7YF6IW89+BOxaAKLjf97l6csfjAgl+wiLLB9Tb/cGCHOSfseZE2xu0q42qf6nM2Ru7kq6tq8AQd91LyebMLRIP1Cs3YULpake2ydtL9k80ZXsY0cJ2V2h/lzXUDJzShFPQcmws7scfq3/1CG5DzflUnV5J71jcMYI0M/CUeexQPZxthkUY9QrQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WCJ+5mIyuTVwnkOolaL6EQRLQPRhNPCPLzsps6PF9vDAFjuTbfVrmacv6Q4z?=
 =?us-ascii?Q?OBrx/gAGk4xqjHV5qHE2oiO+a+uT2BWue8NGYKvsaaufvCCdJFNloQXqCaaL?=
 =?us-ascii?Q?047NuvW3RraPhp2rS1LpTMZgVsbFdWj/sAxLZOT7o9V8SATGA3kEnnVajTwy?=
 =?us-ascii?Q?ot6ikIRl9Ceafv5b/QzZvgDgv8tCnZA9SQiinwSPoMUTkTa+ZtDt3DxYsTXN?=
 =?us-ascii?Q?CPh64stsjgkdzIa0uyGDyXX3WcUZHpxROQxlSSzXn1btcITh/E+vbrH5Dqth?=
 =?us-ascii?Q?zlc+hb/sICcjcFxVOGqPGl64ERzrhIqfzrMKTzNffdvz+clo5y/YNr7RHRUp?=
 =?us-ascii?Q?Aa6VlAyh+DlYtw7T784Ell5Im6x3d64L7GDu4sfeEYEOReP/olD4k5itleab?=
 =?us-ascii?Q?pWkTsagHU0o7l1JOgVdt5kghQW3HoaOYMHMh4defXxW9hwNlf2HGYQJVUhV/?=
 =?us-ascii?Q?yn6rH+AVY5rj9id/8V1TjHpYYYlfzQ2oQCXPRsrh2ONgYJ/zG8tyfLC1yARw?=
 =?us-ascii?Q?VCkLiNoq32pBv7cTMksCeEn+U3xV6wYMOy7Y0T7WNdI+nekxrT4vjvry2/53?=
 =?us-ascii?Q?/Wavsmhjj+fIsKdmwBDv0UmQUxSos7QjYCyzxwPghpEjmic1ysnTC6QZ6/6q?=
 =?us-ascii?Q?EG0KH0fb6MO046BQdXU079yi+WO++P+1eOXBFNnE/nhSY14WG4mUEwDYAENW?=
 =?us-ascii?Q?L+e0b/W1eGM3rjT9wHpqC/ZRAmZzjKomEK7p0CyDYakaI2dsEDxedeT/lxA7?=
 =?us-ascii?Q?QL/yZ5hhRlC5o78kqlpXzBnIofXgKebwak/RtzopQqwgb+S/pizrIebiW8aO?=
 =?us-ascii?Q?fk/12V9izQa3smH3jq3Mch6ByQh7ZVNXlHH25obwfvAcpDeEWBuK888WiUBe?=
 =?us-ascii?Q?t7GhWlbpAQsByTTeaRYgLJijGnxZHcnCQjEsb28wuQPTuepJjuu8OsaZVnYV?=
 =?us-ascii?Q?5Gh59IaIC1+MqCil0xGGx664BoYkqTTszzzmCNpwTlwLudJnQWTAskVJOhgn?=
 =?us-ascii?Q?pAQbke9VrIArq3fLUwlQRFvK/ttjDm3CgiT90ZXR5DCkJoqMtcj8SC6ejBWF?=
 =?us-ascii?Q?BZh5J/7BquA+ZgPSsWWTiBpYvuV0KoSW3cnjr3R+vB9RmEFL+aspaeBduzOU?=
 =?us-ascii?Q?ZnN82nHhzEpnWPWIo6WthMthtd1trCWI0ugYfri3VDH1qhhVMR+Xmw/dWcBW?=
 =?us-ascii?Q?76hfg2KgcoA73EVDiZQoIwv18Rnqp1nEcTvxS+Ufhy4GcItQX/i8ZqMBfWRh?=
 =?us-ascii?Q?oAHviOBdUmWbJ4RjV6i15ooHvhDjeevx+DNC2qA0KNV0DnlKk9fUhktAunN1?=
 =?us-ascii?Q?N1wDoEB8RPOL3o+ErlhgZpOiiaXKwuLVu8svaj+efupjxA4ba0Ssv49+Wfh+?=
 =?us-ascii?Q?hC2b/e+fQx17hfEOJ8NiuFq7u8JpG7NYHzltEHiVariHHgSZwFa/ISps4AAn?=
 =?us-ascii?Q?mvsxnfwfmn3V0m3N7MgOM9Lizal0NQokozoqCMyPKx+gkYDIQAWrD73JOy1F?=
 =?us-ascii?Q?nd7OJN2XYa4g6bex6fv8ARX4L42GU+SHWFVd8gClPrLy7uZ1Iacy1ovuJv6l?=
 =?us-ascii?Q?8dsU6sAG+Z3hEtw6Y0cXNL3hLHQ2UBA2OxgPO17TZBI5SUGzMTyhxl9H2fgw?=
 =?us-ascii?Q?2sNg2tTqMFKvQcnh5QK38SjpXbhAwL40USzH2GgT28k6zyxZuRC7amo+ISQR?=
 =?us-ascii?Q?wTZPS6Vm8Ubo6Bjy+qibPhLS3jk0qhz9Hml1+/kV6nXrzuMmPlKrctzMn5qH?=
 =?us-ascii?Q?sUG8eqwCUHk6S0dM7rVP/YIm9iwRtg8=3D?=
X-Exchange-RoutingPolicyChecked:
	BeSDWI70k5nLsb+5X3sK21E0JYCiJTLB3e1UErd75tt4PWJRhmM1zLpfwQRZLoXJ5mvot7ZEWINFK56hluEkTqe2T67edjgNwp9omzO4gHLOKWMG2IIo9J4DK4LIOWxmQDhyVmPSLJVz4Fga1HRrL2OpI2gRZtv97+gxQBbq+N9t/naoA4UwFTQjmXsaU+aAgUXQ8t161RLdFRzLxcD1g+b9rXLxaUZjY6t9Eo13EXGzIQ8WVU5bdqK0MSP8obRjOpvffG7eYOi2OEM0dezsLW/10wvd1EugnmyBp8TzG+ssPC+mNnlmf2F+Tw2O3vLOVEQfPD36t42HDlAz+EXvgA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6eeac7-1a5b-4bf5-466e-08dee382bbea
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:37.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA01+3ybOdTf4VMRPXtKB+kjVZe6IDCu+iKwBGtn10n1ctbvg8iu4LU6ErikFGYaLqJZmMRp058h7PomhRIeMkiBoGdn1gDR3Pm5w5YifIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXzMjjzggIUsm6
 NL8FrxsQc5OD2zqOCKaXAHh2d4QMinoCnC9qQ+dnEFoN6+az5pdUopUylBRPtqy90/mSF4a8REM
 mSwe5zM8y+BnwrCqW6SeAK2szDkUF30ZjsMvqlpuXPl5KuQYTSaNVv8Txizy0o3Sb2PqHqDqrxo
 ri5eocZvSGeB5WanrFE0we9iblj7EZAAn8BaF9g7zUrbqQQO58mHOxArdqn+S+6VyrkR6u57+Js
 fjqAs7V8Rn4E/LFeF41/B8BGpxWlW2yCXA8uCkdkBGr2RITJ/BITGLX/mxqjqNt5/9Dd0iOV2Qx
 fRh4wtWifCgJk8BvxXBuxD2KRTGOhznOAsrphhmTBbYpWklP132L+ID1XR3B+niVONmZ7NvMGmJ
 NL5PU/DUQO0dmF9OzJ7q901LY0UibjbM5Myq4Y7wez4o0bww7LpXNDZzIq/2IcOkfsV2cxWibTO
 AEAUbmmVZzyoVs9IbTA==
X-Proofpoint-GUID: MEGmzORk6kY_UAtzgaWzX7Tqjt0QGfRr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfX6jcnEiQyTeNB
 qTGI+sefDBmazRRhPIcs3Yh33AQ6rnAOsrKVgdo+4quiJtzqVMtlSNLKbSWHUiX20Zcxs4/Sz03
 0dobEk4kge2x8Fn/aWxmVfLStgcv624=
X-Proofpoint-ORIG-GUID: MEGmzORk6kY_UAtzgaWzX7Tqjt0QGfRr
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9d cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=cp790dm7hVwQy6wAJXEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Allow expansion of the new named CPU models.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-qmp-cmds.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index edcfc82a25..bdf46c823a 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -33,6 +33,7 @@
 #include "qobject/qdict.h"
 #include "qom/qom-qobject.h"
 #include "cpu.h"
+#include "arm-cpu-models.h"
 
 static GICCapability *gic_cap_new(int version)
 {
@@ -92,6 +93,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     ObjectClass *oc;
     Object *obj;
     const char *name;
+    bool named_model = (arm_find_model(model->name) != NULL);
     int i;
 
     if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
@@ -104,6 +106,11 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         return NULL;
     }
 
+    if (!kvm_enabled() && named_model) {
+        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
+        return NULL;
+    }
+
     oc = cpu_class_by_name(TYPE_ARM_CPU, model->name);
     if (!oc) {
         error_setg(errp, "The CPU type '%s' is not a recognized ARM CPU type",
@@ -117,6 +124,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         if (!strcmp(model->name, "host") || !strcmp(model->name, "max")) {
             /* These are kvmarm's recommended cpu types */
             supported = true;
+        } else if (named_model) {
+            supported = true;
         } else if (current_machine->cpu_type) {
             const char *cpu_type = current_machine->cpu_type;
             int len = strlen(cpu_type) - strlen(ARM_CPU_TYPE_SUFFIX);
-- 
2.52.0

