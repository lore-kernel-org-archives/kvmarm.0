Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C08F4CA269
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690082; cv=fail; b=EhwGnoffKFcq3CZN3HJhF1cnM7X53DlkeOyKEhH1E0efJr8fV8DSBirBS0ZuPeV6YZJhuUT4Xz1U6IkuY6WSv70n40nFbJl1GNGbV+X9sWmz52wF4kzMZW5l0Z+d2hO8Xu5htp9iXws6CcClOexvFEjJ6bnu70Zz46Z42/xmNsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690082; c=relaxed/simple;
	bh=lI5AzOIyoYaHl3pQPSQbftUTRPGzdmMgYCBtbNc+V2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XczQBNMbsNgAKDDvXlttCb/xiLgjlIyc74OugJy8Xr3Es+XNXVx/0VuO7TScy9Q/pw4zHim8SzhbZiJdjG+lFTjdRBtSogW66Eaf1hfAJywvAvaIAOCM6nH1ZSFFeUWQ5TmSFoHCTTkZOx4x5y9GOUzBIH5AlXDLM4ZXZl6sdfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ucDCNkAE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mQNBZfQr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ucDCNkAE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mQNBZfQr"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DGKYmV2540280;
	Wed, 13 May 2026 09:34:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=A4OHX5bXpzeWyRKysDAO4klw4Wzyj/cMbBTWHsbXY
	88=; b=ucDCNkAEkqHCLeAx7tFkEh1K5VTJF4lYWfoucRlK+uXMpps2+dG+KZBNk
	hv6P/M9X9JcKp0CdhN183R+ZYUlgwQgRlS+LmxNFiUfiES4DpI8LcZP60DcFDZ5j
	TQ3T9EJET5/gRXkteLXO86+h4Tmm54EjXVNBUlfxSK4h0wfzn6ux0hftRGZq4fWQ
	bfkYZvV5pe+s8DDS1LFOBTE3GYMXuCmAW54GCj957JZhRNu2+7Dnd1qDf9ltMgAb
	dDI7O40/XuLhl7UniUSIBhy3T++JBYaRzSj39fO6Yo/YPORPc/3XLk/WwMI2ofbp
	4JDpARFIa6gg1yR3pmLdzb5aVL6ew==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021101.outbound.protection.outlook.com [40.93.194.101])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4e3nv8p7bg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 09:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+nb3zicCVDZ25xoeI6r6yvo7QVODyu4JU5n4pWoggZt0ohKgASJV+84AvoWZJE68gtseT0lF/scEaUqCJ4jfwiO+5Z34S9pIqEm3CFzifyybgoqzgXVYScfI8AmUVE0crRMJ3i/aG0fHkjawp/DBW1TweCfOpJiRX+3iMQP36tXBD4/fX9hjq8jSOiJ7Y4R1pcTwjW81sG1ecG9w7B90C3fZwVnZnk/5desYWJFrshHAc5gupUKs7JIsJz3E0ebQvwbpd5F9k/V8yp8dAnP+PMfcPRy2e/V22E02jbFnwkUiEGd9NJKO2YA4IjU12aiq9+iGMoQ/7L4Gft2pPSVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4OHX5bXpzeWyRKysDAO4klw4Wzyj/cMbBTWHsbXY88=;
 b=oal4DPw7jnN3sUY9mLUAvKJC1kaMWVik50DdELW9eBJsZL0QqECNdpwRTj/SYQ3eZUVGDHhP14GdRl5USLXJxoXbePiwpiuCFsd1q1/Lh72hmgmzTRN6kCdRmTDUBCymGIoJZhl0OOC5/RR7VGCZ5gW6pKXQ2Gk2VMl24cmWdtNFOuEtdfncDHwxHGFUgcNjVAVvbmARi3CaUt1Djwhhm3JJWWVldPEBgDSkX3cE2iwQqVpIcTIFnCnd1Ba9dRajTeXI+OJvWwA1lh5L10HahDcu9mHXS7+n/YMa0W5tKXc76twq7XO/MeA47dDXVBDib8DEx071qgcdaUvozu9W1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4OHX5bXpzeWyRKysDAO4klw4Wzyj/cMbBTWHsbXY88=;
 b=mQNBZfQr+lZaUfns2YEzrUG6oC12EtTHwVpteyMtl0EsqgqoorY1H0NZ/B1sDsdK76nosetD7WyRe62cVzKwgUB2TWBzhnjAC5tImgWu9+H+1L28FDm18U45ePIpmzh7DHJLbKS1bYfvv6jPXSiERsxyjzB6XhVUT0UzugWbAvE4/qxRkiJmaeQgszKEefDKvTOpudoNOegpymKc3Nj+PKbSdT4ZCwBmMisWmekCowDRwGVlk61L4KFFB0sb5cERERirSElisQHsLjfvyrWwMFUrdRNnTN+gluHdbbxsz0QHZpgUkMc317ygWfJ2jnBjdZaS1W8+8fKhGzhEOCd0Ag==
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 (2603:10b6:510:2e7::19) by SJ0PR02MB8813.namprd02.prod.outlook.com
 (2603:10b6:a03:3d6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 16:34:31 +0000
Received: from PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23]) by PH7PR02MB10160.namprd02.prod.outlook.com
 ([fe80::4ed7:5c74:48e0:ff23%7]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 16:34:31 +0000
From: Shaju Abraham <shaju.abraham@nutanix.com>
To: eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        kvmarm@lists.linux.dev, peter.maydell@linaro.org,
        richard.henderson@linaro.org, cohuck@redhat.com, sebott@redhat.com,
        skolothumtho@nvidia.com, philmd@linaro.org
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
        prerna.saxena@nutanix.com, jon@nutanix.com, jond@nutanix.com,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [RFC PATCH v1 13/13] target/arm/kvm: enable writable implementation ID registers
Date: Wed, 13 May 2026 16:33:56 +0000
Message-ID: <20260513163356.3033159-14-shaju.abraham@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 76b5cb64-6a3f-4756-2b13-08deb10d8280
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wZ64Vd6Blqb2/DTZAtCdjLLteS1V4tdwackDaGyPANotZcPQNCv90wDpDsZRZMpasmmEEokVZKnx/1UGhA9j+jHK/KMLpiXIjXsP2uk11vc+Q9nbv3I3jOMPNElEimL8Neo1AOFcZ5qrchDcTbUN7MABawsY+XkYGc/KtocmZhrGWMX6KZv0/TZAq6jJy1/vhL1SoIZp4BbGawf59jEEVqT3hnx4UVBm+/PsFwCLCyC70eMIEp7BsVUwPVBs9vUitcw8EpNHTSpQ1y/N7jVgh7MCMgVdRBxQc3PJ3+tumepLUXQrJlbCGlXXjwOVslBsm6OIdLHnbbwdQgFgE67QbkThnBDTzv+xHf0X/lKuucmKoMzQXbISfUtr00L02VegXv/SuFlSNksbI6+P/nb36NnwjBpJOE+U2fuSDkx+CLkS0mErekB0r21ImUaJ2GbomB1aEX4BWjs/TD492GrATlWpRr2SLLhMl4VLQM/lHzdVHhhWLAfx0TvRTC730VMTNqjlMEw8w3VqBuQlYV+iY2J5jAqqbX64LRV7PCRPizEkfrrh2pALGMxfjUIi1JtsI9pvTelSnUgdCnffLlWBopaTiMdKLFj0GS4FFnJi4cz9SSzNMe9GMgMUhYCnAmcZ8pCGSsfjEBWoo/n4wm+slf54B2xJBGczYNNMSEOC+VqPziZwJRorqnwcaHgtFf4mWvwO3RESnEOG/LNDN0sSgdgjvU80nCAanQqVigz2aXk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR02MB10160.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?phVDmO5Sh46wc5DoMb/DXdYOkdwy93mSY5+z+EHEQfcUoQ3ycUgoHmE3h2s0?=
 =?us-ascii?Q?2tiLX4MJHJpvR7Wv/5VbQVRhAE69Lqsp0TdcMVPk0fUADYgHKU1fvLQ+QQi0?=
 =?us-ascii?Q?vjTcGVwxDO7IyPRRIPDUY5kEMF6w1Oo3ZJD52lA8idu1oYyyy93YyQ9MhCMh?=
 =?us-ascii?Q?LK5dnMJ7dMwZW3SJEZUMWx50mkvfuvsiou0k1g6KuCVm6tz0Ze5eYZrr7xx3?=
 =?us-ascii?Q?VMpZrpYeWI0a4qLj88FveVOnG/bzyAOl9ZOWnEj5t6ogjy/VJpA/t63H/Efx?=
 =?us-ascii?Q?9YQDn7wV/4My3NvkIB8V9QzGN7Z6NC+23G08C2K0gN94gTjTi0Z8Jfe4NTUq?=
 =?us-ascii?Q?QAMRAf80F4g/GU0pG9w5KCwnqMX9z6XLxScV8yJzKFpX2H25r54N/0NY6+a3?=
 =?us-ascii?Q?F3Kih95YOF6Il7MHexu+YRpjHG0jNwrYkZNCufxenYjeMUu06GTUX3dJfcys?=
 =?us-ascii?Q?Nkp9cm4777cHC70aA0NRTfJhWbTpZjcO2neX07PMZP/+J6HzfpKcJcMwJ8Vg?=
 =?us-ascii?Q?Sw9QqAMLWhfuu14kbsl4pgI45ALjDQ4bLHjmSk+q25bVonxV/z6ur2VYGg5U?=
 =?us-ascii?Q?biIv72Vk3+z8he1CUYP1xrFYgdlKqkyrW/np1SBkH9c34QqSjeJXIVUDLNQ1?=
 =?us-ascii?Q?qNvNv0ObyTPLYINPRpKqNtgvFZWs/PEfIw/RS5kKXYic4DNpLQVL08fSikIJ?=
 =?us-ascii?Q?L4O0pf8uuRkD1srQuTMCiwyOhLyyE+hKiQGyzPDNjKKhsSCopzOUdg7VeZDp?=
 =?us-ascii?Q?vOdySnyxRYLk0U68mFt6gxYONFrWdO+Nj+CV6RWMnOOa+F2b9+r77GLuK8ah?=
 =?us-ascii?Q?1MsWYK2xiRkSQciUF3Ed/91inewUvyoheXcE7ut+L2ISBSdqcCSAJZnzxibK?=
 =?us-ascii?Q?bdSvIHhcpj9k/M5nDMNeGVPj3fonYhZ7VEp8Q5CuXEiFeNmDvoZUvYCkgAub?=
 =?us-ascii?Q?S8M6bvFweVpVgG4rke+VCxWruwre+LNE6+gCFazo2Dl3OQzTECWNfjiwdXdo?=
 =?us-ascii?Q?fFatIv4kEB5OTgahcR3r2L2AIC/JUZstYsQ+oKzvL5PqMvpquZmDsBUvI4et?=
 =?us-ascii?Q?1GKAIPzFrwOe5zWwYWfWqNcDubA1RxQgo6kO86uvsEOwDwaVbbTUmH07z+a8?=
 =?us-ascii?Q?g/oHZmhFWQObbez9+Xgud8HH5VMQlrQz3O1JMMbLpZWZNCWfExbL7pwf6JUl?=
 =?us-ascii?Q?f9IYWAP/Ne4CVLhb2rX8wP3lW2A803+PBsasuRAeKpY9PaTrBy3BwMrBpnpS?=
 =?us-ascii?Q?TqjCEQ3LBmHN/NBaiSDXI0oj/nJ8TfL4X9DO6Gqpu7eJdoX8XbZxePRfmMED?=
 =?us-ascii?Q?ZgsHF4iD3Uhilr+uSIOVMObR40B/wA/hDL9q7NZZVxVZ048gyB+RaL2jAAGC?=
 =?us-ascii?Q?AsePGUWWXokCnDCFcmeRBItoqSaGgd5i/Oty41vSfMTLT3nK8U0y1bT3koIX?=
 =?us-ascii?Q?fsdQ+Vrn9BVdgL6zgJImCyXY7V8ZXVD63UqKevPMHqQ9RVTuBB/Jr0y4GqMm?=
 =?us-ascii?Q?BG+yvDDDbWleFvUsSmUkRDXgmYY6pqlgCNjDas1J0zavTxZMKze5luwrTsg2?=
 =?us-ascii?Q?4jat6p32tC9wST3z8FV5JT5FVyJFCpCkTscTdlikRKay9xwPQmelggTzhY1q?=
 =?us-ascii?Q?37sK5DVmF+e4D7QB4+SrRRwzB1xrexLe1m+roWRf+aewnhk/V33eLURPdks1?=
 =?us-ascii?Q?K42bQfjK0FokP+XNukTe0kiuF/A8CwRLlQ+Dob+Ky2jt8B6SbzLS913WJUze?=
 =?us-ascii?Q?QeFIRvrNgoR7+Xo5kKxn6kMXrxjwca0=3D?=
X-Exchange-RoutingPolicyChecked:
	Jl1MrMJYIoCfbKk52C00vlxThJuGGwox4T8QAIPyx+fR27ksvRBocGcQajMB54Wv2S+O0DXg/pu8TUDz8VXwvOnC5mOU37pC72IIGNhFWpEsGINkb6GBA6TFtinm/XnZtcT02GJ51+WxZjSSPmc5jZjM1nDPhegIWenW0B7VOpA6HgZ9V9+JcILjEFV/+N+C3+JVy1mOZWap24/yXlq9vN9WpP9axEUjPGS2woLx4BbVMa+XiDfXxV+On/OD+yyaaWJ/o6ipg9zwCTa3+wjrXsnZSSa27XsJ3VknfTLI3lV27qjTO0m3nNzMtMZEfZyRKbwQFubyDa3nGJxl5AiN1g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b5cb64-6a3f-4756-2b13-08deb10d8280
X-MS-Exchange-CrossTenant-AuthSource: PH7PR02MB10160.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 16:34:31.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DhXX9ZU46IHyc0R5eXBWjKvqlyeHS36aLGaN/WVWOPljE19l/J5mDDg4ub6dTHkD7j0YgTa2rEiEJTJh5r8Y7HNabtq93U0Q/Du5f6Mz95U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8813
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2OCBTYWx0ZWRfX6taMs2rRzb8w
 YBow2eOAJzbv1drXi3YgMe0qZZ+qij9v1Mm/Yynha9jXLmE7sGI7NBXP7TfDGl4SjLUpAuNE6z1
 /siVpyUHOhFso7YEGJ6BhOTfUC50OULmgSBV3WrnDENg1vcJcYz32ihP7Feu7SwHoA0vsuNKOK9
 fgaAHz6Lf0WsYUwDIye2buWMcTgsoGZZGJpjLjeDd/dB7qWgTJ0zuCFKA48TqRfImwxrqH/jxEK
 dY8w6MYbDd74FWWUj4/lP91w9GqQvBhbVTafv5szHF7NVRhOXRNyKZzbwrjb12Y1riFtYCxfmed
 8g0zJRGu3o4qH7F7ZUmCHPnnUC//dyyvWT+s5PZnYpfDumc37GtljbzDhG3mhcHqKqVYUbJxqVJ
 1wOaexFQqVF75iEu0naeGug+V+6PRyoqDmGbJvZ5SCPowuvY2jS4FLsVmxJxI1Zd+hvsPUG9rTQ
 ahEoMa1DGacvYeJANwg==
X-Proofpoint-ORIG-GUID: ATqqBg8fSzgWlSzGQEdfr7wyINzCACT5
X-Authority-Analysis: v=2.4 cv=PdjPQChd c=1 sm=1 tr=0 ts=6a04a81a cx=c_pps
 a=+kXwOJT9iXP9BgnuWAWdUA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=i7znhvatu4o865_pIWsA:9
X-Proofpoint-GUID: ATqqBg8fSzgWlSzGQEdfr7wyINzCACT5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Khushit Shah <khushit.shah@nutanix.com>

Enable KVM_CAP_ARM_WRITABLE_IMP_ID_REGS if the host kernel supports it.
This allows QEMU to write implementation-defined ID registers (MIDR,
REVIDR) so that named CPU models can present the correct values to the
guest instead of inheriting the host's identity.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index dc64cfbeb6..288b5ebe85 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -711,6 +711,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (kvm_check_extension(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS)) {
+        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0)) {
+            error_report("Failed to enable "
+                         "KVM_CAP_ARM_WRITABLE_IMP_ID_REGS cap");
+        }
+    }
+
     if (s->kvm_eager_split_size) {
         uint32_t sizes;
 
-- 
2.52.0

