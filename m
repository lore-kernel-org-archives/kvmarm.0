Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552D04BC017
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650734; cv=fail; b=WMjzPzFjW4w7B7X4wug6HsnNzCe726GLeDI4afk7AKO30mW/6Ocms4Zk56iorWsvetPcBjulgaPeiVDYN+cQNn2IDl/pjZDCbTUnPslr3rbciPP1o9Fa/SmFkEvU0RpT5JtsHg7xzxTPQVUKqImWOURuyVK3q6kt6IFO/mzJ8wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650734; c=relaxed/simple;
	bh=2FkQkdcc8HxiNefH3CPRzTW4o8rY+dLKOJ68nZIcjko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M/KeVBSEuHNc/1YWpOZCOm5i2SrRPn89TfSMyDImo0Pa4LMqa4GHzghigRAads/uix0HaAWdnzLk/XWgVdyX2Yuh0xwibHnMMkh4xCxQvOy3DQbIncPUAgQfGAn624TY0NUHYGf370Ag9DdYy8VGjfq6NJg8aGzapVXQk5iWxgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RIPx2TOV; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=D53h3be1; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RIPx2TOV";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="D53h3be1"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUS1185382;
	Fri, 5 Jun 2026 01:43:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=hQaEAz08JKn1aAsLYTiEElBUVD8YXZTF756KPlDND
	Uk=; b=RIPx2TOVP7acm7tAjEYAN57z7wwxQIvhcRqLin9XiObRPTYuOvf4wMRZR
	JEu5HM0nxJxXx1OBqg9bx0Yh+88DpjfDwIivreJBh0TVEDUDJcBl47LZ5pGDRjQ/
	Dc3jVW1vwEyk45pRKGz7QugAvffvDWbvPhho5JTW+9NVWiZWyavlMH6WvFTdeuSa
	+YLr/BVFcvBZkWCUx0hHgkd9IxaZTH98Ssa2LTCjKqjvz8rxJadTzatJQqpI40CI
	40HS1mtsjvXYVuKwjOaiBAXBlzSzeUjnBDK3rnQlnOUh+WywgvflaKmx5Lk6TcMk
	Jxs4jjGqsGSZ2BvFE4ucQRp8wrK2A==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-11
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hqucc49NQ6bdgi9s//E+labJ7zTeAmhBAZ4g8g5mFNQh595I8CxoF/kEl8BK600KDRkklYm81pwNmrYY6D5fQpClJnjkBLMVDn821kn2mKaywKcvT1Zbc4sZtuUJh3FxXRIc7uZ+8ZU/s+Q1FY0cX3ho2QgEdJqJtA5d+xa08j8SBCAIY1NjqvIHhxQyCkVoMO5wuGb3VGP37zEdTc5jGEmsd0Gnkd8DGOL6dU5oJxzmvLrn/QxS6HAI+P6gDNeEOKvudBGjp/W66ZVqJ+RGuFA95vblvVy8lJtXQxVIv9BqXLQ9PGWyAiKpOKoB5i/IgTOfhm0D7h4lUlejFEqWqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQaEAz08JKn1aAsLYTiEElBUVD8YXZTF756KPlDNDUk=;
 b=SEo/SQiW2KrRwgWfzzbUjZYp3/JwmG2cY4FibUF9NhgSHyPeK9ukBnzkmy36SgOpTiIRdJ6kc5D56gtOck2pR/Bfw4tBs/qAFbD4ak7xe4YLgWpWrWPYKxXzjFjtjTTfYB+s0fDULm/ahEPFDogPxlAbVzd2CyLojhuoOakcSqFwrz5hIib9QELMF9sLzDtFu2FSbHP+iMgqRVnp9t2ptdDTFllpF6IfBiqc3BYHiwtOkgBqoWyG9gl0VECF/l6ORb5DDfxrpbiSJNskTZrU0MhfPBn1R95qr2O2D/iKEPKJlTUuzD95SmftyJaduHDXKgkapogvYiUZYINhGe2frw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQaEAz08JKn1aAsLYTiEElBUVD8YXZTF756KPlDNDUk=;
 b=D53h3be1cEL2h9u/i0DLmoz6o1yXwiAuEjdSL4qMcdSw3LjJRDdhPItfadKR2cVy1ovJA+4ys9zHYvS/MvanVPCDeCr+y8R0e+bmGsGLJ08lW7ST2cTozmCuTpjL6GYtL/StRPLikVxcFGK36qnZI88SnKrAJesi7xGNrJhdHmzxiabF6GGNFeOmiOeJapEchENehMBJLFbMNjAggmxMsrRJgKEx4mA3BqVdNyvrCK8YN20XquVD2KQzsxbYFkPRsOL2kDf6AoN/ClGPDup16iUuM9Vhnf5lLRlxaLsAXluG6mJD20R4yOhk6GcjslN0TcxIB4Q0zbyfk68x52JMsw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:22 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:22 +0000
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
Subject: [RFC PATCH v2 28/29] target/arm: supported-values and blockers for CCSIDR cache properties
Date: Fri,  5 Jun 2026 08:33:57 +0000
Message-ID: <20260605083358.1320563-29-khushit.shah@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|MN6PR02MB10630:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fbb60b6-b7eb-4828-1934-08dec2de7eab
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q2/ry90KWyDn7YAW0GxU3POYZ9fZdNcZnrvicfogZsMBp61ZxjDDKYHTQAu8N+1Ox1iaMCsGOcw0QLc2CRE430nhlrLm7CtLrlrSmlYmeb2TlK568P2wWp3nxNGBaD2UjaXRRwHeFo2LOHd+uMdWiWbIOO63zxXdYoBgqriW6mMrIfJzBfABBPLBL/JgFVJcOWl9/ykCnbMCkTLm0p/u6FBYhed2Y6aGcKfaJAdXVAjPzpBV5ap/aUuFbPlA2JNGtwd6vf48PRMyPjhov7sdeva0NJNFNKajN4bTmo45UHNU75Ekk48hSTy1JloNDci6AmR8pwjol3/kY6koMQ0CRwtVTRcDi70SPdzTaer3XeQ5p0VIV9cuPfdrLrpJOFEn3dVjm9ncACA05CMr1eyNNaY94SjcMeKAppr/VhIvS6j/VFuGPxMca1supq6HTikj1FbJulpyDtR4fjsMA0xQs9Y3NEEONfFx+uDqwdDkt+HatI6d7DT0gFMoAvgMKE0AphJqLqFj4p+KH40P58y4AYZ4JjW39RqZD1SfNHBCxEFzhb7jQKHfWJrh/YTfDilDHEyhZm2f7xPqT7qCjWjSlDDeTxqypmO4jI1Yk4zJYWAFOYfEU1dSB/eP3yDTqzPK0WgjrgbAtqjtptPzV4/vgz4yOh+NBSXZm1LdPvrnbw7E/BwCkDJFtEqSYukr0BhU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VDtEmwEQwwOccReTMHaksJahhtXpDKIC3DaHBnaPMKibgFSNc3rn9gkJompZ?=
 =?us-ascii?Q?KrkmxKs+BCpJi7xw+3qkadoSE7llLEP7trGL8tJTdAdrYVXoJeQDZVYPTl1P?=
 =?us-ascii?Q?uiaXpSPBLSOg7bNm01G/mFZ9dqv6JBd2u7FsPl9kdG77VZn7AFwv2OK9QLtj?=
 =?us-ascii?Q?b6IF310KrTFeBn8OWmVrqCcG/hSa6IxG0z+iRb61G8vWEh6lJ9jDr8ZinBsS?=
 =?us-ascii?Q?sO9QJTIGclqClAYZuOSwKQK+jzxtN9Q2JtvbxjtkBswFMPr6vUswAw+riR9f?=
 =?us-ascii?Q?BXUkxr4Qo36ofm0nDKYrtNlewnj9MbFrVQOaKXcal9hvcMK8W588StOCMkix?=
 =?us-ascii?Q?rBLFo32BrJoRseo+uatlhH0tSjoEZT3etCeie/6LiswbfsUD6FaCl0r592v+?=
 =?us-ascii?Q?7lt02SO33IidVA4lyRTnIkT2apeZ3caakIHLIUVo6I6ezkFE9GSP8jJKV8JR?=
 =?us-ascii?Q?dVolNJSB6RKGC9RUlWyAg8L9LMRG8yfhWsQORLdnX2fgDPk/TM2SfBwHTwk7?=
 =?us-ascii?Q?F0fGOjzHDqHbGyQBfQKVgWKLs/4sMqId95YeWWVhMioshJXT2aWoz86jY7Y3?=
 =?us-ascii?Q?Vp2D0mL/P6SwXabnsTiLRNIoYcagmNcVMW8WDyekgAcFMBxyW8NJpP6+ebqP?=
 =?us-ascii?Q?R+0SFkPLcd6+tfVr96unufVmDirerPW+OPTuT2jdGNNtDY9XshDKhsL5we2R?=
 =?us-ascii?Q?13Ut0nGRkAOBL0OMZ6dEgmghP6JP5+gAgThdWxYmTN4tzHBCGrwPAys1YjnE?=
 =?us-ascii?Q?ZJDzu23Zw916kqm3OmtoUT1B9ZZP/e8UQvZ9rbwiey9gR7JLI4ixP6EIi25t?=
 =?us-ascii?Q?6oOE0wTUxY5/LGDTziRoIVbNO3o1Bvr+2u7G8s+QdMwjwcUEWjJIJB8LjI7w?=
 =?us-ascii?Q?KkE94WiPwwByrh0ANn7JfK3Oe11O8rAfPTeLG+CCF7lgtwAgfkofWf5ys+vs?=
 =?us-ascii?Q?6iMq0V310kPpLToaadi/3sRgIco8MoQ8OoH42JQQOiZulGXiAYsi4jEdyQX0?=
 =?us-ascii?Q?guoE+RPaqedP7VfJu6XUtdJbQCakS9N0x7XkrI0Zn8okaOsd7I1q/fd+Zr1U?=
 =?us-ascii?Q?DlbbPoVp1V7coXF+0DLm/LjbEsawiqx4jNGZXCtCrj+MO8TWaks/SPQdD6ap?=
 =?us-ascii?Q?y5MKAvL0KzoFJ9TTTDvU9Qd5iTeH9DVCBMt7ICIiVyhULdoN0X4/b1VPMXyZ?=
 =?us-ascii?Q?4yknXlByy8CzK2/v/90fqNdRSCU0EpLJDcdWMCVcIN9zJFKEHtZUmFIMMreY?=
 =?us-ascii?Q?yPS/WDFHhmoffB5EFg7oPnFGOsIO+HxI6CeR46njYq40uH4XQj+N+MOqN/Ku?=
 =?us-ascii?Q?cXGeWQ4JlKhZnvNF6zC2u9LX83xPQEPY6X3KnCYotu+p/WGsy9Sym8w6yiNa?=
 =?us-ascii?Q?xTTBALfH7Vk10ZKCiQmQaw/aJN172fiq4p/6F6Ejud7d6AbTS1rsS9DdwTJQ?=
 =?us-ascii?Q?IimQk5Vh5jNST2Ud27wqew0k4Je+jwnHeXCrVI6TwuNE+tiumuhb3yL1u5Q/?=
 =?us-ascii?Q?QB4Va8Ft7gbGdheIx+hN9mjkF9/W0CeWQpoZUi23RNA/aU0u2XAU7WTvdR0s?=
 =?us-ascii?Q?yw8QRhbnH2BqXv2GYDL5avqrNK5eqX1ky/0gRDLwwPTe3a+CLJK+ShnK84Xa?=
 =?us-ascii?Q?X0xMYa4F/IHaf69VHLZAE19HbAkS9jIjj+TV7/rJ4Ixa+itqrkb2Ss/U9jDE?=
 =?us-ascii?Q?yGGbOq7pehC/OocPdM94PIkFfojRdwVWcmLykD71kOmH6Fe5oko44206IwEt?=
 =?us-ascii?Q?JOKgyRapKrALf9vCqree47YUcNdxjmU=3D?=
X-Exchange-RoutingPolicyChecked:
	lm/BAajwFrMGqUe28XsxnevGVQdqalLzI8MwYOz+C+7Qr0XjNeLFk9eExiNFHEfeNcLGlKitsHWLe9UPUxnblor+FSpQcF57vuK11G6pfqQ8Vod7aIc7hXwAK2xervlB6dGI2tgFDvNCph8/5mR454tsGXhRELkS2LoND6VOFt1lJpWedEQLzUP3u64FhcllPf/vPlUUtJMX7BhaXiQejpK2RchMi5B5ovULO+PQiE5G7ar83JJEQNTGxMYK4776rZ4UyMAiuZcaRBZTuTm9swRsYTKXbEKr36SKgkgdky6VrXgxF3Qpi2WUt2lftKDSJrX5OjoWGbpr3i3mhVdv1Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbb60b6-b7eb-4828-1934-08dec2de7eab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:19.8735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: au+3l1Go483W5kwgitC9u+mXmKT4N1RI/L2Dc+SgGaZbF+5aWSrC/WlMyBv/W6A+DLwVMK3jqzHPXI/iwUSvUJ+/0E8BIyjvDRdhn+MceSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX/ata+H3ezmN1
 tBznngWMdgonZQ29n7LTttqsWj7nXkR3zaNJT8X7ux0pL+yHbM74V0crl+uZkQ6Ib096lppd4QN
 hsT5Fzua2L+/jVbKHZbzGBiLdigG57qCKNF1Hf2u3LgbprnVphjq0+ZDSHQep5GmLtCe3a6ScVR
 i9XqBgdvc98LX4gJhHMGc80aguNg9sSUylXJdcaWUqSAhUN8G3BVz7btyKQGlUMD1+VSFbLkGpg
 DjoSxHzWd/gQFYgtAzR1sFI83MQz7IRyIhZaXQzD4Wi70wkkhaOguZczUYhBu0ILezx8MCc/gDE
 JElhp50ZV6S821GKNchKmH1+CN85fghcSrY6wc5k+tuKeeLCg29lyMDUyqs9kfIXOhydV8ESrbT
 iBthHI03sDcbRFVFHTdFdKgpBC8CkiG/T5R3fm/1Yibd+i0JkjOE4ChlE39Xan19wSfgoylDPY1
 Clxem97VvPhqXbW3eaA==
X-Proofpoint-ORIG-GUID: lErz9HKEcAczflRpGWxrAOzMvU5OjqFu
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c33 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=lWSKPyB6u50o3MQsOS0A:9
X-Proofpoint-GUID: lErz9HKEcAczflRpGWxrAOzMvU5OjqFu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

As CCSIDR banks are not backed by standard idregs[], add special
handling for them to hook up supported values and blockers for them.

KVM rejects CCSIDR[] linesize if it is < host CTR_EL0.*MinLineSize.
Report such case in qmp's cpu-definition blockers using
arm_ccsidr_get_blockers.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models.c |   6 +-
 target/arm/arm-cpu-props.c  | 154 ++++++++++++++++++++++++++++++++----
 target/arm/arm-cpu-props.h  |   5 ++
 3 files changed, 147 insertions(+), 18 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 5f59650c81..d38293cfb2 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -568,11 +568,14 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
     Error *err = NULL;
     Object *obj = object_new_with_class(OBJECT_CLASS(acc));
     ARMCPU *cpu = ARM_CPU(obj);
+    const ARMISARegisters *host_isar;
 
     if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
         goto out;
     }
 
+    host_isar = kvm_arm_get_host_isar();
+
     if (cpu_isar_feature(aa64_sve, cpu)) {
         arm_cpu_sve_finalize(cpu, &err);
         if (err) {
@@ -592,7 +595,8 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
         }
     }
 
-    arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+    arm_idregs_get_blockers(cpu, host_isar, blockers);
+    arm_ccsidr_get_blockers(cpu, host_isar, blockers);
 out:
     object_unref(obj);
 }
diff --git a/target/arm/arm-cpu-props.c b/target/arm/arm-cpu-props.c
index 44f21de1c5..cb1c44ea1f 100644
--- a/target/arm/arm-cpu-props.c
+++ b/target/arm/arm-cpu-props.c
@@ -54,12 +54,13 @@
       .get = _get,                                                       \
       .set = _set }
 
-#define ARM_CUSTOM_PROP(prop_name, _custom_type, _get, _set, _reset)     \
+#define ARM_CUSTOM_PROP(prop_name, _custom_type, _get, _set, _reset, _gsv) \
     { .name = (prop_name), .type = ARM_PROP_CUSTOM,                      \
       .u.custom_type = (_custom_type),                                   \
       .get = _get,                                                       \
       .set = _set,                                                       \
-      .reset = _reset }
+      .reset = _reset,                                                   \
+      .get_supported_values = _gsv }
 
 static void arm_composite_set_internal(ARMCPU *cpu,
                                        const ArmCpuPropDesc *p,
@@ -123,6 +124,44 @@ static void ccsidr_sets_set(ARMCPU *cpu, int level, bool is_icache,
     *r = FIELD_DP64(*r, CCSIDR_EL1, NUMSETS, val - 1);
 }
 
+static uint64_t ccsidr_sets_get_max(const ARMISARegisters *host_isar)
+{
+    return 1ULL << R_CCSIDR_EL1_NUMSETS_LENGTH;
+}
+
+static uint64_t ccsidr_associativity_get_max(const ARMISARegisters *host_isar)
+{
+    return 1ULL << R_CCSIDR_EL1_ASSOCIATIVITY_LENGTH;
+}
+
+static uint64_t ccsidr_linesize_get_max(const ARMISARegisters *host_isar)
+{
+    return 1ULL << (((1U << R_CCSIDR_EL1_LINESIZE_LENGTH) - 1) + 4); /* 2048 bytes */
+}
+
+static uint64_t ccsidr_linesize_get_min(const ARMISARegisters *host_isar)
+{
+    uint64_t host_IMinLine;
+    uint64_t host_DMinLine;
+
+    arm_idreg_field_read(host_isar, ARM_FIELD_CTR_EL0_IMINLINE, &host_IMinLine);
+    arm_idreg_field_read(host_isar, ARM_FIELD_CTR_EL0_DMINLINE, &host_DMinLine);
+
+    /*
+     * ccsidr_linesize_{get,set} are in unit of bytes.
+     * CTR_EL0.{IminLine,DminLine} is represented as log2(bytes / 4)
+     */
+    return 1ULL << (MAX(host_IMinLine, host_DMinLine) + 2);
+}
+
+static void ccsidr_sets_get_supported_values(const ArmCpuPropDesc *prop,
+                                             const ARMISARegisters *host_isar,
+                                             QList *out)
+{
+    qlist_append_str(out, g_strdup_printf("0-%" PRIu64,
+                                                        ccsidr_sets_get_max(host_isar)));
+}
+
 static void ccsidr_associativity_get(ARMCPU *cpu, int level, bool is_icache,
                                      Visitor *v, const char *name,
                                      Error **errp)
@@ -150,6 +189,14 @@ static void ccsidr_associativity_set(ARMCPU *cpu, int level, bool is_icache,
     *r = FIELD_DP64(*r, CCSIDR_EL1, ASSOCIATIVITY, val - 1);
 }
 
+static void ccsidr_associativity_get_supported_values(const ArmCpuPropDesc *prop,
+                                                      const ARMISARegisters *host_isar,
+                                                      QList *out)
+{
+    qlist_append_str(out, g_strdup_printf("0-%" PRIu64,
+        ccsidr_associativity_get_max(host_isar)));
+}
+
 static void ccsidr_linesize_get(ARMCPU *cpu, int level, bool is_icache,
                                 Visitor *v, const char *name, Error **errp)
 {
@@ -175,6 +222,15 @@ static void ccsidr_linesize_set(ARMCPU *cpu, int level, bool is_icache,
     *r = FIELD_DP64(*r, CCSIDR_EL1, LINESIZE, enc);
 }
 
+static void ccsidr_linesize_get_supported_values(const ArmCpuPropDesc *prop,
+                                                  const ARMISARegisters *host_isar,
+                                                  QList *out)
+{
+    qlist_append_str(out, g_strdup_printf("%" PRIu64 "-%" PRIu64,
+                                        ccsidr_linesize_get_min(host_isar),
+                                        ccsidr_linesize_get_max(host_isar)));
+}
+
 static void ccsidr_sets_reset(ARMCPU *cpu, int level, bool is_icache)
 {
     uint64_t *r = &cpu->ccsidr[CACHE_BANK(level, is_icache)];
@@ -206,7 +262,14 @@ static void ccsidr_linesize_reset(ARMCPU *cpu, int level, bool is_icache)
     static void cache_##NAME##_##FIELD##_reset(ARMCPU *cpu,                 \
                                                const char *name,            \
                                                Error **errp)                \
-    { ccsidr_##FIELD##_reset(cpu, (LVL), (IC)); }
+    { ccsidr_##FIELD##_reset(cpu, (LVL), (IC)); }                           \
+    static void cache_##NAME##_##FIELD##_get_supported_values(              \
+        const ArmCpuPropDesc *prop,                                         \
+        const ARMISARegisters *host_isar,                                   \
+        QList *out)                                                         \
+    {                                                                       \
+        ccsidr_##FIELD##_get_supported_values(prop, host_isar, out);        \
+    }
 
 #define CACHE_PROP_FNS_ALL(NAME, LVL, IC) \
     CACHE_PROP_FNS(NAME, LVL, IC, sets)   \
@@ -439,53 +502,65 @@ const ArmCpuPropDesc arm_cpu_props[] = {
     ARM_CUSTOM_PROP("cache_lvl1_icache_sets", "number",
                     cache_lvl1_icache_sets_get,
                     cache_lvl1_icache_sets_set,
-                    cache_lvl1_icache_sets_reset),
+                    cache_lvl1_icache_sets_reset,
+                    cache_lvl1_icache_sets_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl1_dcache_sets", "number",
                     cache_lvl1_dcache_sets_get,
                     cache_lvl1_dcache_sets_set,
-                    cache_lvl1_dcache_sets_reset),
+                    cache_lvl1_dcache_sets_reset,
+                    cache_lvl1_dcache_sets_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl2_sets", "number",
                     cache_lvl2_sets_get,
                     cache_lvl2_sets_set,
-                    cache_lvl2_sets_reset),
+                    cache_lvl2_sets_reset,
+                    cache_lvl2_sets_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl3_sets", "number",
                     cache_lvl3_sets_get,
                     cache_lvl3_sets_set,
-                    cache_lvl3_sets_reset),
+                    cache_lvl3_sets_reset,
+                    cache_lvl3_sets_get_supported_values),
 
     ARM_CUSTOM_PROP("cache_lvl1_icache_associativity", "number",
                     cache_lvl1_icache_associativity_get,
                     cache_lvl1_icache_associativity_set,
-                    cache_lvl1_icache_associativity_reset),
+                    cache_lvl1_icache_associativity_reset,
+                    cache_lvl1_icache_associativity_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl1_dcache_associativity", "number",
                     cache_lvl1_dcache_associativity_get,
                     cache_lvl1_dcache_associativity_set,
-                    cache_lvl1_dcache_associativity_reset),
+                    cache_lvl1_dcache_associativity_reset,
+                    cache_lvl1_dcache_associativity_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl2_associativity", "number",
                     cache_lvl2_associativity_get,
                     cache_lvl2_associativity_set,
-                    cache_lvl2_associativity_reset),
+                    cache_lvl2_associativity_reset,
+                    cache_lvl2_associativity_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl3_associativity", "number",
                     cache_lvl3_associativity_get,
                     cache_lvl3_associativity_set,
-                    cache_lvl3_associativity_reset),
+                    cache_lvl3_associativity_reset,
+                    cache_lvl3_associativity_get_supported_values),
 
     ARM_CUSTOM_PROP("cache_lvl1_icache_linesize", "number",
                     cache_lvl1_icache_linesize_get,
                     cache_lvl1_icache_linesize_set,
-                    cache_lvl1_icache_linesize_reset),
+                    cache_lvl1_icache_linesize_reset,
+                    cache_lvl1_icache_linesize_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl1_dcache_linesize", "number",
                     cache_lvl1_dcache_linesize_get,
                     cache_lvl1_dcache_linesize_set,
-                    cache_lvl1_dcache_linesize_reset),
+                    cache_lvl1_dcache_linesize_reset,
+                    cache_lvl1_dcache_linesize_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl2_linesize", "number",
                     cache_lvl2_linesize_get,
                     cache_lvl2_linesize_set,
-                    cache_lvl2_linesize_reset),
+                    cache_lvl2_linesize_reset,
+                    cache_lvl2_linesize_get_supported_values),
     ARM_CUSTOM_PROP("cache_lvl3_linesize", "number",
                     cache_lvl3_linesize_get,
                     cache_lvl3_linesize_set,
-                    cache_lvl3_linesize_reset),
+                    cache_lvl3_linesize_reset,
+                    cache_lvl3_linesize_get_supported_values),
 
     /* Fractional properties */
     ARM_FRAC_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC, csv2_frac_vals),
@@ -1011,6 +1086,10 @@ void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
                                       const ARMISARegisters *host_isar,
                                       QList *out)
 {
+    if (prop->get_supported_values) {
+        prop->get_supported_values(prop, host_isar, out);
+        return;
+    }
     switch (prop->type) {
     case ARM_PROP_STRING:
         arm_field_foreach_supported_arch_val(prop->u.field, host_isar,
@@ -1066,11 +1145,11 @@ void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
         break;
     }
     case ARM_PROP_COMPOSITE: {
-        /* not supported for composites */
+        /* no defaults for composites */
         break;
     }
     case ARM_PROP_CUSTOM: {
-        /* not supported for custom props */
+        /* no defaults for custom props */
         break;
     }
     default:
@@ -1090,3 +1169,44 @@ const ArmCpuPropDesc *arm_prop_get_composite_of(const ArmCpuPropDesc *prop)
 
     return NULL;
 }
+
+void arm_ccsidr_get_blockers(ARMCPU *cpu,
+                             const ARMISARegisters *host_isar,
+                             strList **blockers)
+{
+    uint64_t max_linesize = ccsidr_linesize_get_max(host_isar);
+    uint64_t min_linesize = ccsidr_linesize_get_min(host_isar);
+
+    if (!cpu->cache_exposed) {
+        return;
+    }
+
+    for (int level = 0; level < 3; level++) {
+        for (int is_icache = 0; is_icache < 2; is_icache++) {
+            uint64_t level_linesize;
+            char *linesize_props;
+            uint64_t ccsidr = cpu->ccsidr[CACHE_BANK(level, is_icache)];
+
+            if (ccsidr == 0) {
+                continue;
+            }
+
+            if (level == 0) {
+                linesize_props = g_strdup_printf("cache_lvl%d_%s_linesize",
+                    level + 1, is_icache ? "icache" : "dcache");
+            } else {
+                linesize_props = g_strdup_printf("cache_lvl%d_linesize",
+                    level + 1);
+            }
+
+            level_linesize = object_property_get_int(OBJECT(cpu),
+                           linesize_props, NULL);
+
+            if (level_linesize > max_linesize || level_linesize < min_linesize) {
+                QAPI_LIST_PREPEND(*blockers, linesize_props);
+            } else {
+                g_free(linesize_props);
+            }
+        }
+    }
+}
diff --git a/target/arm/arm-cpu-props.h b/target/arm/arm-cpu-props.h
index 55333de858..b32973349c 100644
--- a/target/arm/arm-cpu-props.h
+++ b/target/arm/arm-cpu-props.h
@@ -47,6 +47,9 @@ typedef struct ArmCpuPropDesc {
     void (*get)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
     void (*set)(ARMCPU *cpu, Visitor *v, const char *name, Error **errp);
     void (*reset)(ARMCPU *cpu, const char *name, Error **errp);
+    void (*get_supported_values)(const struct ArmCpuPropDesc *prop,
+                                 const ARMISARegisters *host_isar,
+                                 QList *out);
 } ArmCpuPropDesc;
 
 const ArmCpuPropDesc *get_arm_cpu_props(void);
@@ -61,5 +64,7 @@ const ArmCpuPropDesc *arm_prop_for_field(ArmFieldIdx field);
 void arm_prop_append_supported_values(const ArmCpuPropDesc *prop,
                                       const ARMISARegisters *host_isar,
                                       QList *out);
+void arm_ccsidr_get_blockers(ARMCPU *cpu, const ARMISARegisters *host_isar,
+                             strList **blockers);
 
 #endif
-- 
2.52.0

