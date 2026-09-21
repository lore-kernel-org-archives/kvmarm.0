Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6AD49890A
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995868; cv=fail; b=Yim+FAKe+3DHKPJg3ff1mVUlbQqKRC9yntGpEqadY1TdsZn9AsVazctduKHNJ3TvvaanX1nhB+4imp5sKqFuDXbEziO7ulvfQpEg/+g6IL2MbYkIJOmfQS8g6wcHAAihyGWf7UH6EzAIz4KvrQBZ3AfLhNzz5PEoxZFp5sjA9PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995868; c=relaxed/simple;
	bh=GA9K2rpfJii0tD1+2V57rIO17lhdqPZA8AzVfwZPsj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J4UqbuttXm+iepcQEUknT+ss1sph1DciJVn8C00sHS7IHB2y8vquq6wvcXj2pwhQkyag+3QcmnsLjRV0F9qXybcSse0nvYKqhjXxUxiEreFBpkezmTO5RXmu4HgPdvTwru89ctXeyDPSBQB6q4bk+UvtPxHKE7BffhEfpW5V2rE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QVbefnEy; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=v8dpAbRm; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QVbefnEy";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="v8dpAbRm"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAflUH774316;
	Mon, 21 Sep 2026 05:33:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pr81Oh6zOc7AJNkrhtUWdfxnIJ6AYkrUs51BxVtNI
	fE=; b=QVbefnEyAmOO2fAWz8IGFW06v93EQ7TjLY2NYMsnu0xyA7P5An4abTp5h
	AzLNFea+S3x+0cnKgkPtqUG5deR3WQELvTpZo5AuhGeK4J2ZowiBp0/dVUY623iF
	Y9u587peU3EVRCGM1hzuHpKazwhALdu1j43vLhdk+nulRTZ7yiI44LosLNktNd7e
	CkGEcoO5y+JkBJ5VWhDySx1hFP0j0TMr+8zqZXJ/pSIZR59CMYvZt3DHs2yrhXrf
	2IwsL91i/Cxhh3DK2g79uH6vL6tDtRTn8izeQsZZ1uvmGYkiumlMxjpoDbiGaHmd
	rU4iQi1aghSTEjIqQSC1mq4mCjmPw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gsqx831cb-4
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:33:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkeHeXOCsjrBbR+MyYoX/nAUM4rVV0mtAHaapPHgubA0b5qi3ZxgWthQNfOrccTycp/PJShzf6eRaMCX9DhGkRun2V8mm3quAIvuhol+LK5cOvMb/zCUiAItT10GiR6cMi3vyynqtVmbH2qWmzx7lNMT0Y36UVwD9/+m1ATXxfgDBDqoCPNwW+4TxVl1FLDrviuey82cVCuXo0Ja8va1QhUbux/yfEVD+O/c6KG80zwvSDqh7VKkMRlmiTOcUoP7A/sf4sZKporpTDi8ofmD05Z5eLK5QJsEESqPgCBi/lS1Msn3/oDdCNVOAHlElftfIyGVqDAzQ80rAdKspOKLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pr81Oh6zOc7AJNkrhtUWdfxnIJ6AYkrUs51BxVtNIfE=;
 b=NATj1ISKulwf3bChIwPzt7aQOSyo28B5FxGTjB4SRDdp6VgME4w8iF8FDRAh+D+zRPGkbh43L3staecZSmQXvKstbq8Sv4fvUG3ElAye0RDCruHlQHAUrlF3jGdydvw0zEwPwF1NRfAb6plHIsWso4yyhNOpxALJ+uF8UGqgW8XLGejfyAGuPTK0Z5J9UnaNz4//YBjJLx+uX8Y5anScGhfFHobgTM6P+vJk1QqF8AuC0B1yi9Yv88DkY0DAcQxnWSTlnNbATdR3Td7cfFfuplRzJmBA6/7qRNu4/LrzAGU7jHF3vqv/kevB2M8R9ZK/vTIGdUWToytGDE8NJGJVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr81Oh6zOc7AJNkrhtUWdfxnIJ6AYkrUs51BxVtNIfE=;
 b=v8dpAbRmBzf+6fxTwcAIe3tP5EqkEAgTOM9C5bogQPY0Cqz/SMmhPEnnMbNH75dqyY959OiQKO9QoQiVePauXWwMtM/VbviXQLsx2AvTstm17+ix3RsN9ttOiqvSoOqc+x4/w6Fwov1q6/6x+2T8UCjH104YoaPKopIItJCSfocI7EbrtBafZnIoH5vp1Nt6lqU25hOygClna7eTeJpZ2BhHofEy9CTQxnlHE8iwSMPFEalOHTc9fjTN3KtcgRyLRiktls0XGT1gr6qkhZqMIGvm3AefWXMHeG18EU/wQzZqqTHIBJ7xMJ/v0RtrMBhq2nXPRi8upJS5noLVTOQxtA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SJ0PR02MB7534.namprd02.prod.outlook.com (2603:10b6:a03:320::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 12:33:30 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 12:33:30 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        ping@khushitshah.com, sandesh.patel@nutanix.com
Subject: [RFC PATCH v4 11/25] target/arm: disable PMU support for named CPU models
Date: Mon, 21 Sep 2026 12:32:35 +0000
Message-ID: <20260921123249.1708067-12-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260921123249.1708067-1-khushit.shah@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF0001330D.namprd07.prod.outlook.com
 (2603:10b6:518:1::1c) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SJ0PR02MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: afd0e491-6182-4c4e-6b19-08df17dc8b1d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	D6jP0kXtb/7e4nDi/VEzPa70/N+j5/0prNPbxP4yzk/3e0/MbDIl7DewnLdvD4vPAPOp4lmQuGpcE8k17IZemflr8JFVxTpkr8LrthpFqeVy4Ck/yzBD/xGZ2KU/93b4Hn5pM46R1FywsKlHad/yCLsYTjJz9ukRvnKdJOgfA1TYVdmPgs/dA6MQTjh2GamXzGHWs5U5jRmJcBRmei6gZ9RBw5m3yfjWrEYmJEUihTJhq2WbFPmN2+Xq3Krf9J/dCFlO1OTfZE38QQYHLA/fKoGUf1jFOlFIsLjh71kKn4n2tz2vldr0+ClG2ULvTkqRuyF+LJ1taxJa66JYi/KqLjlOXJHPYT5SLSzD/GHIVuJ+NiIvC4amrjobhNUglzbGw6OutIT724l1qrV+VOGMyPT+pZEkVE50g3HVPfcwV3E2TjVxpKMsA0YkfwhpKi66noJLafM/VuJaeB3+opuYBnHOT9R5KnH81DphdXdjD9eZPNw78+fOCUfWZZv9nolguG5DjNz73k/kYfSffLe0o49F1DvG3o0sZScR4bxy7uTNbh9Fn1vYbjRVjSkMGXAO+2UiuXSet4KY1KXRJKC5TltCCQJQip8Xm4THBqhhuM3pWxNvwP3kvAhEZEPFmQVJHct1HAMkMKu002Dga2IfZQvDS1ywAjDz03SqqA6MTc0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Q7mzo1VOejr2ATrpv6UfGaxvV3E/NBhriwAJREGavxDwkVtR/TviQXr3fBn?=
 =?us-ascii?Q?YqwGeuM3CpmGKCZfsGtSCzlG8dizdOAfPvl9eLmBbqzMRsv4foOII8y0wOhT?=
 =?us-ascii?Q?0EsVb4HnQwMLt1K+MMiAgpQR68sOxPEhLxnWZo2Nt1xb2seMPT05Jk3U0QT9?=
 =?us-ascii?Q?8B9CCxnD2IDUj+TZilM5MDBouxQ6sY3j5DMVyi1dIZGzA4QdkIhShsai1BAF?=
 =?us-ascii?Q?Qsm1aEmkta5HtmeKT4Ho+NNjTW0lmxzYg3uIxoJ+jEuJ/+J4B5mZRYiARJHM?=
 =?us-ascii?Q?kQqxwH3mE4EKeoQGEFgRGACJ01NHgRyXtOzLareyaIdOJFdgJfRg13QMviOK?=
 =?us-ascii?Q?tvOygMD7SyIwrrcwfjrWwKeTIrAJPeVLCFNfd5FRmahEZZCD5ouEdqz7exMV?=
 =?us-ascii?Q?fn03wEuKZZGykxEhT64uw98tcbqyw9dvTD5Or45bBiZAW8uWctbXHsedNtjl?=
 =?us-ascii?Q?33Tu5/UO08rXBcEPF9KakOn5jD5CIIoATPGjB1oojk0eSKVjthWFABxJGi7/?=
 =?us-ascii?Q?j7afsBhBBKjZzBhzkVuoL9NXoFpesz15jqbF2mTVDirAn3zx1Ovc7XpdsbyX?=
 =?us-ascii?Q?qfcOpGo3VrpV1rKeT0EWEvDFMWDoRPhQAGLcgaEM0g0/41ivNYNWS1GGwnvO?=
 =?us-ascii?Q?UIXoTsMpdUMLw/G6TDW4ZSwjrkSAkLSibmCC/BgdxrCjUul6ulRYdzXqI7S+?=
 =?us-ascii?Q?TVuZ7Xx2iidFs8ywvNWL8WuZx7ZAWIOu7IR3x0hpTkKlYQjT1Q5h5a+OmELV?=
 =?us-ascii?Q?KTD5ZUzqmY6q73K9qmq8QVxJh9NrfwKQFZzo1klPdqaVMJ+LvKZfgRdTuNTZ?=
 =?us-ascii?Q?KPfCwY1IgI57IeutaWy5VUWtTpkng7fBggJ0zvQmv8eL/FbfBVG6M0XC+AFy?=
 =?us-ascii?Q?+GUueA6JkEBTWcV3N/jgtNwjlE8L+Ttw2EO8efG3eAN/izkwiq3DpLmGZjlj?=
 =?us-ascii?Q?XSqz0Cg7IyRT4Lahz1nCifA9IcVmUCIPK2UlSwAmYLpiBF+hX3gdF4xi2Z/B?=
 =?us-ascii?Q?f/hmLgz7h+6p0NVH+VsFIeLABSW2ZLnArlIeL1jk7VNuq9hhckobwqpYJxxz?=
 =?us-ascii?Q?/XgjXGX57BKme6qkM1XCSCR7E9HPiv4QwYyNhbRnkLQB5OD8RZsMkQF/Q8CB?=
 =?us-ascii?Q?FpbazkDEf1u09o3Z43hhADGTiMYGF782DpQ1qBW1eEOCMvkbzqP0jh94cxyO?=
 =?us-ascii?Q?NZKy1XJd3jKjPHyTCvRJRtMv6ERzodcvFUIq39f4stIaV0YIaWCrE0A2//H8?=
 =?us-ascii?Q?9ynw+HFif7/lpuQFpv/PLmZYM9eWZC9oLOL4LrQ7bhT7fKsivA5evkjuDVFp?=
 =?us-ascii?Q?s81JZDncJ3gEBJJaxUtclPeDKKytYTJzhGMeAvOaTRVIHAPXudR9yjpPssZ2?=
 =?us-ascii?Q?Tdlwf/X9FShcAPYXvwxGKVIiWXISCoBEGiAQileKnIakBN618eWGT+PrZ8vm?=
 =?us-ascii?Q?4ihtNzCRds583AovfpaI4whf1iRobKCjNrOVn0q1A8/Csl5Lj0b2kIBuK4f8?=
 =?us-ascii?Q?+87Mc2R5q+n7pfxQknKeOHtouY6qYUbnYMWup52Tt/969nEAXAtAxvxHnMs9?=
 =?us-ascii?Q?VifOPGTD7esUhdB5Bavo4uLBqIaiTW8EpD0IQ0V6UrqqHWBBD4VXRiTjoT3i?=
 =?us-ascii?Q?3V1U/Xal0C6JHZoAYmpRCe8A6MtRCsZO1aAtGTwMDUnsDcNhTHFIRw5e+gKA?=
 =?us-ascii?Q?Z93S1u0KNp9jtaQXpLUEKa1cyy3wbJOcOzwSem+8h/d6Jm9er1NXwjiPNUsQ?=
 =?us-ascii?Q?pTkCe3K84HxHm1TMK0TRiWlJ47y2Fj8=3D?=
X-Exchange-RoutingPolicyChecked:
	NgG8sQnZnAbgQ6AkKhHkk6Hbc+Ct05dEF35cbe9uIOwWjwTp+vqDoOF0XPNlxTot/EL3/7MGvJybsZGZ6brxfRGne3lZ1EH+F0g6vzAAqY6CCd/jgT9TrA3MGuI0+RwQF4kOoLhLQD2y8G4VmtPyBlqOoY6+wG95v27p4rT3PehwqC/THvdu4v0UJZuoKlaoI3wDYs/6Nq8PigZaFS0hRQQzBQBGe4/gzGNEBV8cD+e4bLkLV1eO3SntUW8Zkn+rEPJBaj9rANYux4OutmTBC7u1u1P9CpDHsfXr+oxiCNqhXkPJwZ6vkspkdQxeX9NVQ1mqUoxlf7qJnVscFLT4EQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd0e491-6182-4c4e-6b19-08df17dc8b1d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 12:33:30.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ew8VNJdlLl62qlIMcFXwkWuKpAxTm+uXVfSpFkCCDfV7ZIVrhJvTYXimW1CSA8i7MMPPIQ7hG7mEkfi0e4l/FK78e6PZ7CQXzdol15oQETc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7534
X-Authority-Analysis: v=2.4 cv=KInPn1Fo c=1 sm=1 tr=0 ts=6ab12424 cx=c_pps
 a=jYOLmuRG9FCngycrw98U6Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22
 a=64Cc0HZtAAAA:8 a=qDXpWOp4m997Zg2teoIA:9
X-Proofpoint-ORIG-GUID: zx3YAXciy01Ng93oubWafOhhI1GTI9-h
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX953Nie+i29Wk
 14suM4ne0F8cfmWNey96scE9M6ji+ARsL4CsNMRuN8KS5ZuvE/yVo5PO0MoTZvv5VzPwUUNfcHE
 9GSuhExDW2cnwtKSq5LoY9VJCe2lTdM=
X-Proofpoint-GUID: zx3YAXciy01Ng93oubWafOhhI1GTI9-h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4MiBTYWx0ZWRfX3aWj+jDiWbs1
 F+zQZV8QFIfcABYCPUo2P+XX46EOc0j0V5oeGcblJVdeSSwx8vXu1zVJa0bcOmvgk629M5qNMZB
 6dGqgGvKPj8L8srPUkIPN09bEgDrnCiTWd+fi4f+NgyBaZ0BF6wbm6LGnZ8OpjVIvW7Rdhf7j+z
 YIIDKAZVCHUruW3/KJhjy/7Kbd43s2a6mpGVKBml0pFyzISlJB2P9BwpdTKUEetTMynACZQzddV
 AjKmujuYhtkoBKuf2FUFj0X4pF1EjSgxEccNdFYtvKntetgZLZu9Z3bDgytfZuPNvtetowPNE4B
 IQ4KvtJzVTgwDlJUs9yC7RjVE5D8hUvuVzVOfeivrhnBcasCD933LOgpQC2i8RK/tADhcOzgbRN
 DhIDR/AcCE9DsXd2DboQEEjPMhq3AC5cARgQITeS7ALSOQzNvFos5pTAiEBdu3ss4+RM22RQiNC
 efPX9trPiIkwMz/wLnQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Under KVM, the guest PMU is backed by the host PMU (event set, PMCR.N,
and PMCEID), which may not be portable across heterogeneous hosts.

Disable PMU support for named CPU models by clearing ARM_FEATURE_PMU in
the named-model init path so arm_cpu_post_init() does not create the
"pmu" property.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-models.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
index fed3197186..153ee10ae6 100644
--- a/target/arm/cpu-models.c
+++ b/target/arm/cpu-models.c
@@ -159,6 +159,10 @@ static void arm_named_cpu_initfn(Object *obj)
     /* 1.b Properly set RES1 fields. */
     reset_res1_fields(cpu);
 
+    /* Disable PMU for named CPU models. */
+    unset_feature(&cpu->env, ARM_FEATURE_PMU);
+    cpu->has_pmu = false;
+
     /* 2. Add sveNNNN and SYSREG_ properties */
     aarch64_add_sve_properties(obj);
     aarch64_add_idregs_properties(obj);
-- 
2.52.0

