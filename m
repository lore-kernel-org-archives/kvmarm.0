Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF83CF679
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650731; cv=fail; b=g9hXL6CSGWmv9PkLDdrw7uglrdujAMKovSW3wWY449z5ZCDr1+4Mj/zPonVWxSEsyXOCPvXrbWKZt0nwlveFgXQaVfAj0Cm0JTqWSALVClgOkwhwVm5Y/6C/NoQtlhLlWppWVhKiqokgfK4SZuP5NVYb9TsRdR4W2r+iu1TcHPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650731; c=relaxed/simple;
	bh=vAQIFtZMvumJ5DlfR616N/fQu/gwIntiuEykDIQ1m30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DmO9PoMjQaXRCanf8+fV1nHR2ahFKJP29BuFM0UhncPrNt8cDXtRyEBI9WISQhMJL+gr8bOmrQFxyUPNI40aDg+Az/MHpDgSjfftFCzXAhTamU5RDXDpLiclKiVPsoPMig2NzcjzDJH6GtdTTptX7buRAR8m2+LJ9HOh0Bb9eJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LMep5Upd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GMVQjf9I; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LMep5Upd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GMVQjf9I"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUL1185382;
	Fri, 5 Jun 2026 01:43:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=PUqWccgJjHOkAJlU13gERauIcCZye81QjWxvyuKzd
	iw=; b=LMep5Upd/bsE8FAGRZetgUgwDORSbNtimi0S+oBaGQ3Wvg6ICSpD7LeH7
	3mxH22pwuWm8pRUGz/Oyn2eFUTP80G3PZfnLAiKn+2qVifbfL5T3a39O3rNp4tFz
	1djcKKXQJKp/OoN4CMv+kwTmdZNR+gXsa/TrETI9iB2LsND52D++MY4B7pAVWn3Q
	BFYGVKbkOz5WSdzVY9EMpp+f2605yF8B04mhIs1V9Pbc6AK+Vj58g0LA9p+PRge+
	h0ZtYcOnwqJfv/SuDy0jR5xnCGAg4nurteuY+qjCZnP3vRUJpSRsDYNduWmEsm7S
	sQHh0GqdDPmrtTCaSrArOr5i3Ec4Q==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-7
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dd4r8iBjN6MO/EQ3/BNdUVOE6fxw4dwWFrVqku+w0NXre0kGEcB4yugB7o2aNXJRLrIuM6NxiopmDnmOq2KQJJT9UVb0oEPD1A6tcB5twENqks/bN7VKKLe3t1+I/j8Ws1J2abhAT1rLXsP7oxQ02dsahwlUCSGLlTUHyX53GNYXAVZ6f9JiJJlAEKi/Hxah20Uz+bvonBYM4lC28vLRiEpQD5QCaJtk865xlYtX5hD9+uWZeeCiowgrDYLbYGiPReSVlhaPNrMz0zeHbg6rhyfzd+yR6PLxJ75gM74/bBVIjrtdXBw4pRBaG3krQhXMMS0sN/nQpgsYdvuQkV9CWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUqWccgJjHOkAJlU13gERauIcCZye81QjWxvyuKzdiw=;
 b=XZxp6dZo3VTjXsTRjmi3ZIx7ejQZu7W63Hz6UnpWhkovYgmF0IW9iFx0u7gM7w2WkkdQYm6yzJDINd4t1Ep+yLjA+m2nvTfSssCow0Ymzvkp2F4vwhNXTxwzJh9t3NUHLcmuywQIw6ewmffioB2w6GokSbo9Fv7ck/3Su2bB8GY7UHptozQ3zOWVb2+WGtQvJQ4RyF66an4jMG7bR0paFUOS6cJHAmfb4G0l0akAfbTl+37MNxpVD7zHaNrfkshA3mLg5inqbT9+io56TT6y2Lt9F57N020vFPieQ0G120oj3SBqru5LeF+pyS9hR+8tnfw9tq64Xj9P8IeLExlfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUqWccgJjHOkAJlU13gERauIcCZye81QjWxvyuKzdiw=;
 b=GMVQjf9I92yks4PAxTEZYePCgaus1toZvNXkQp1nSVXopq7hgTGoj5bBSnYjlHvb3IMiedmZyNOWhN5eLp+jRp+q9kbN68O66YSD+d5OiIwXCW8nbMknGcImST7Wx2129CGFLlTAm10V8jtUZcY3BAUDTXSA4LgDsxE9VTmiljTbGWxCRkcF8SMz6iBT6SY2i326SPcJvdBqG8O3JWZusXzI2wz8TEIN8IqyadXyk4SrmfJQUR/jAY9N9XP2iVjgflwEippOKzJbWHvJ7+Ajv9XCG8KACUGl3DK95HxRJV5V4uKvQou2+y+oFrot0D/ZIJO56bdZVzCVnuStVgK7xg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:20 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:19 +0000
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
Subject: [RFC PATCH v2 24/29] target/arm: Report "off" for ID fields gated by vCPU init flags
Date: Fri,  5 Jun 2026 08:33:53 +0000
Message-ID: <20260605083358.1320563-25-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4cd33c0c-0cb3-4b9d-f301-08dec2de7d9f
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WPb5YBLwiETCMGiMAgeKOTcg+HIPEAD8+uzuSKhZJtC6Mo2EmUeqS3FOLfW6EzTckjMjbUbbo2QcQktwDVomUVKXBuK35a2Ze8i/92pgGlOTK5bmlw+OJB6BNhFyXJ+deOB1j+VVsboTKBxahavxEJRVYQTV7a+RIBdE9Tfvhj0uuynIGBlH58+n51XuxHv+AB7bSIZiYCWRfDywaCPVQRWzjJoAxdXv4b0bg/GVwHkd2SDm5e0nzLggc9o0hjuPbzm07vHqVsb2TaB5Q0ZCiytJcVfM3jWXUn/bpdrRWZlYfjovxHm0iH4P1m2ZxsaBFCie2Q+MYA7/3Hrbdc3c5gAA5WHFyFx32s56hZQ4xUO8SeWGLzyCJWTEN/I/C6Z91o4Lp7DYoJZP7Onpu4wL2AkHH0Po+L/JQWPmtZDRAzTV88kA/1a8JvrJ3GIzIE7dNWn4R+UmhD1iQVtqoW+UJyPNf/X4E0ILVdPWZATIoRDK/ZX2ZaZ+jjOdDVPQ6I3JZsL4Gs4nTEEVvKNcoHhqEaiSNJ//Z6iscJf4BM8DyPlIPnfwbVg693byQTk9j5cnM9ZnbYpPEj1aMBMsoeC/jQYVrt9vBhuSfZDr4RsvKB9F25YT9wNWkOjgRLTzVn/8q2/RaSFQT0jPECNpL0J0PShT/3m5rjIYM3al3436nvhRY1ZPtRVK/efitx8bR5It
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xGRwTfNRgm+olJy8VtKiZmb7Zo32WPfGpA46sv8akg5+8HblMhPYcCBh42x3?=
 =?us-ascii?Q?jezx26yVdb445BI721nXy5NT+VxIznlt+3i7caRKNv1JsPJLWd+icKLCzwNP?=
 =?us-ascii?Q?n0T3kn5rgskL7aY4hXfCjac6W04Lf9c1EWz41464SHYgOC4Bre7xN0gezorB?=
 =?us-ascii?Q?Rxc6b1+S8iPNJwmoByzDelSluYhlmHNUpxesjD0DmCizr+qUjM9xiPh113K9?=
 =?us-ascii?Q?7aK6Q3pislLCNB6gKxu5FYthrJWYGtd9LEMmz50k4xZb0NGlC/BxT4fFzGHG?=
 =?us-ascii?Q?5tP0AYo8rK1FzGouLiVHqL/D2hJ3ri/l33mZNRQwziIze6YQjDSpTAf5o28r?=
 =?us-ascii?Q?JaD5kzE0RLeUytdy2OI81GFyeHHCe3pRNhTWU13R2US/jzj25tEVnLBJHGoL?=
 =?us-ascii?Q?1Jd42e2bIygEZLACKTBTl7TmTY6NrEkNq9G0JvUkN9akhwqfvPpN5O/4wqe9?=
 =?us-ascii?Q?h7hm6zOOBf4c8szYPO30T8863iYvWP49NvMus25OGFogMFVbkA2mGDmn0iut?=
 =?us-ascii?Q?VaNijDP0wSnyc4O/NPbMTteO1EoqNH6InKrpk8x6AMNq46IXNprF8QXdasd8?=
 =?us-ascii?Q?/oKQxhRBALE4GDq806mpwRaQyVVT1DyVzw409/SCT6ROwZ7KEXTuEeKECQYc?=
 =?us-ascii?Q?S47SEq/VePEwWO63WFAJcvG4XEMXX99itwdUGoG3x0bfi+7/ihiOMPkANWDQ?=
 =?us-ascii?Q?52SAO9lW//7ctP65WobHVCqLsn2eguivNCvfxKowFtKUmah/yg40Oi6oBj8E?=
 =?us-ascii?Q?IgcynzwDRmgtzD6/0MocbUmc+yXOEPOb5uCWhJ97GJkuDIaHOhdTy/W2Pe7U?=
 =?us-ascii?Q?vgJ0b1obPVEBqXcHY+NdhDtefVJq0BLuFiQPk+GiMO2Oh/3/nsDchaACaQxS?=
 =?us-ascii?Q?CqFk2QpeOJqfGIT6QNi4hid5z8lMJV3C8BCWdm/zVTb/bB+YT38UihF4pZkp?=
 =?us-ascii?Q?C+H5BBxGhUPljQRCCvomYQcqv1e/AJYGRVkZjblV5GqlvrVTtaft6IqMhoa0?=
 =?us-ascii?Q?x6NsAa7GObhoW1Va3HoqXviJL13gzPJGpAE51nISnS2q1zO2xQ15/q0/wI3x?=
 =?us-ascii?Q?GJAjfr6yLxVeREmRWzAZhnT7U4/HWau4BSTbTviwQUPdMvAUn0Z7cM76LIVf?=
 =?us-ascii?Q?HluH1hk4LV44VQoBW+xP82dqeZex9d/6ItJStgy8zAm4ZmNUy193RMxTY6F3?=
 =?us-ascii?Q?Tor0FwyvRdtkWF+3r0+1BQW+zXY3vCoLCh5uNIRDyRjhfIDUtm+HYQHpp5l9?=
 =?us-ascii?Q?EmLbaQuGy0ljSkCeqDpBcFORJzV5liLJFN0u5bWCRqI69EhkUd5DU4j0L+7f?=
 =?us-ascii?Q?7oIyg89pvFgMsP2Jnq+scSvhffOI5q8vJ2O6HcO2659NAB64Vti0hMoVL9GP?=
 =?us-ascii?Q?jCmF+iSNySux7wgwJIxNZOpi/6sJKG4ot6jwrDi5dltHt+/bZNDE50kyuuhH?=
 =?us-ascii?Q?A6Sb2kRUTjh3OiqFF/rpmUb332AVt7QZ8ZEel8y/xaDHnAXYNxaNi0v0O4Hb?=
 =?us-ascii?Q?VsuX9LDdQl7dNuq2X7CYPkUvL4rMAMIEV+Kdr1iJD5aU9/HiozQkUGy3xKhM?=
 =?us-ascii?Q?TfBo9yl0wQNo2Nl/t+FK7z55jVs9cP3naj5wbBpeApVi0jtoMHA8CuoICnpI?=
 =?us-ascii?Q?r0W9ffmxpW7Ef8qTB+//74675CDTgxN3bjGxAyp3eZ6Eotp+9TU9VdgHO3Op?=
 =?us-ascii?Q?n6bv2QSgy5XHi/GQN6sLpQSCAp7IblEOgSW/YD5LJil8843CycrFFO6q+N5D?=
 =?us-ascii?Q?BxxwYYKBAPDIn9n4Y5Yg2OJX3EmmkTY=3D?=
X-Exchange-RoutingPolicyChecked:
	rPlNTUnz8SOrCw0QvNra/fy2A1+AXWf8Zd67z5BHsHhDKJsfnHOsCjz6BzcFuhB3vrZPtXMvvMmSTwxut3msN9usDl0nCOAIV0ISzyilwxlhSLdM7fGo1v8SwQelnCLqxvG7EAnpNUNp/QAg3n5RoscdpKX4ypg/yJTMGIjiNHZ4tby6ap2cwXzSusfZEwMUbWWn2Fnnl5rwJD0Yku2PywmGxqMfB2unHdEWMb4XuNQjhvOkO+78TX9xHIJ/uYR6N3IZEZSOtwYRdQJ33lYZsynPE/HeXkNuNzQ7+g2y38iMmUGlSYyaQI1lVLfmMAAAwUOFBSyhn5emCQItAfSe7g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd33c0c-0cb3-4b9d-f301-08dec2de7d9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:18.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: covAenvJfodqEWzyLuy/43jOs9kuSWM8YapV9L9xSPsLgAIKTCJibfxjW4m4gCHLvbK3rBin5k1prlUIDZI3CrmP2x3nm3ACLTrs9heN5dA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX8e1XrbdF/waS
 Isdxr+sNfVl6XHyI33g63QtOtkHuXRZT5F3Uuv4aVvKYtcJzpUeD4fP2588aiLFHiaI5vhNlHt1
 rqLd8vJQRTyUQ6ZDCb24Lc58tmgRwB9UvWqWoF+EE8oA5pILpJRYyEr3XbWFkiY5+uRCqwiqa/r
 3SQthDvRoeJxJvNlvsy2Lq2es8ApejnwkocSBC9tjIW2b5VIHJva4zEitdxtv7sEw+RKLjaNVvr
 0kscpoxbtFgi3iqN2FiMxeiBWVBe0pviwg1X0HBbNHYROQIWcoWl46wET0BsvPeBPOZju2fXquR
 cPRp9HX8RfFvrx2LSDDL0VkLE7oSX2Z+eo4RvuwMRSGVo2QrfWHGn+KvuZ+IAF1DIecbpS/eemZ
 h9CDY1DUqIU1IboDPd6Ni9KdYQD2iuFjhTaWytObXqy3EQXlsbcoVjQU4JO22oGpycNpwal2J3i
 KuMLAY/NhkTv9l7y8xA==
X-Proofpoint-ORIG-GUID: vseeslpaDd-hqF2QLFcVzu6HFwlvy3HK
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c2c cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=gcVIAeWjapZ606p5YZcA:9
X-Proofpoint-GUID: vseeslpaDd-hqF2QLFcVzu6HFwlvy3HK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

When QEMU queries supported CPU properties via KVM, it uses a scratch
vCPU initialized with all host-supported features (like SVE and PAuth).

KVM exposes the corresponding ID register fields (e.g.,
ID_AA64ISAR1_EL1.APA) as read-only, the supported values only shows the
enabled host value (e.g., "fpaccombine") and omits "off". This will lead
into falsely flagging a model as blocked as the features can be masked
by not passing those flags.

This commit introduces arm_field_supports_off_via_vcpu_flags() at the
ID regs level to identify such fields. For these fields, even if KVM
reports them as non-writable, we explicitly append "off" to the list of
supported values if the host value is non-zero.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 7671925869..1ec1a38866 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -355,6 +355,29 @@ uint64_t arm_get_field_mask(ArmFieldIdx field)
     return field_mask;
 }
 
+/*
+ * Some fields which may not be writable but can be disabled or set
+ * to host by not passing appropiate vCPU init flags.
+ * These is needed because supported values are derived from scract-vCPU.
+ * Actual vCPU and scratch vCPU might have different init flags.
+ */
+static bool arm_field_supports_off_via_vcpu_flags(ArmFieldIdx field)
+{
+    /* sve and pauth can be disabled by not passing appropiate vCPU init flags */
+    switch (field) {
+    case ARM_FIELD_ID_AA64PFR0_SVE:
+    case ARM_FIELD_ID_AA64ISAR1_APA:
+    case ARM_FIELD_ID_AA64ISAR1_API:
+    case ARM_FIELD_ID_AA64ISAR2_APA3:
+    case ARM_FIELD_ID_AA64ISAR1_GPA:
+    case ARM_FIELD_ID_AA64ISAR2_GPA3:
+    case ARM_FIELD_ID_AA64ISAR1_GPI:
+        return true;
+    default:
+        return false;
+    }
+}
+
 void arm_field_foreach_supported_arch_val(ArmFieldIdx field,
                                           const ARMISARegisters *host_isar,
                                           ArmFieldValVisitor fn, void *opaque)
@@ -371,6 +394,16 @@ void arm_field_foreach_supported_arch_val(ArmFieldIdx field,
         if (name) {
             fn(name, host_val, opaque);
         }
+
+        /* not writable, but can be disabled. */
+        if (arm_field_supports_off_via_vcpu_flags(field) && host_val != 0) {
+            uint64_t off_val = 0;
+            const char *off_name = arm_arch_val_name(field, off_val);
+            if (off_name) {
+                fn(off_name, off_val, opaque);
+            }
+        }
+
         return;
     }
 
-- 
2.52.0

