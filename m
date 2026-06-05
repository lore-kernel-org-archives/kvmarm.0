Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C61B3002DC
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650469; cv=fail; b=Ace5RJ60JT3o+0WbVOiJkMoBy+XYTJVCwFYam/Zkx8lLqgGNFwiNjyLpb5pekATYV2K+wva08ZY43+ewZ/QF2AH1U4lCbT8DwtNSIH+l9lComR6hRDIsWPgxy1Azsi71GNf3G9VHe6eVEZcCHwsIzVCZL5+00BS9XPL/e5ynlfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650469; c=relaxed/simple;
	bh=V/TyXAqptfWUWdqdhA3n+vcZuX3wyx26h6/fM3zSY/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tf/bXuPI2KmMmhNK9GBLeu3Oi2oe3jYbbbmQZj91lyckI5OlrezQLE8lWuhoN1G4NCe0an/AT0fpcVC+Lp5jaH44XpuLUrMarrdxjMGU49A+4i+m+x5MK1tY2zAPHfV2yu/oLu9HiJby9m3Wuts89C8KnXZWFyo5chyBEqNqppA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sw11JG8b; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BYG0FK/I; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sw11JG8b";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BYG0FK/I"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUH1185382;
	Fri, 5 Jun 2026 01:43:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=HBTuVLeW1X997hLBAnESt8sTrEr+TXwqbBOtJlAd3
	rU=; b=sw11JG8b6Sg1O0qqlVX5lzR1nWryI/Pl+kkH/ZcTuikR4lX93rJ5ckeNM
	JxFwr2xsXe0oYu3G+NewBXZVS8G7tWRtzsIksNvd6gkZnRqfzlcgURxB5ByLU2Us
	NZZ4oVWNgEN0koB9qWKWPkOVB6PeoySJnUbbLqJW3Xz1DlSrX8s1Zh0zA3eSgzYX
	oefc32VgR8hha+vOcyyj2/bjYw4Gvw3NzLlGaoLLwiLZCVFgUc2oWyXSVSIS2Xom
	Ydzjn8+QaBpgiHFuCrEhrgjpUW9tjpD/DFmB8WUHO8ZnntNQAkGWBPr9BRtKNgzg
	DCuWzq+X6YrE9IQyQCogENwePcPxg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzA8zjqfIbx6DVUE2wDkPtuMZ1aN81ZF/e4rDwVjUVNKj1gk8GOjtVxt6Rv8xcEn3+dgOJaYfJGGtiU9PIb8H39n+ysEtPIf97uEFRb5HE7qGmLKf8M9oQQPCGV7Ce+ZfdD8EyGOA+pF1v+Ko632g/64WU8qFP6XBRsez8UfHBqJFFwg2m2EfKiNfYvaXIkpc+vaTOoUiJwYKXAtfGBWNXo3qsoXg76G7wB6Z6KropE4BMbnbpIMhc5iSMw+eURcGO/ngg8UmkHqKz8qa7Vh58K9oyOcEtFd67kaDlnQj+VUi/pc4rl+JXdK5KZijqdH+4y85uUF6BYQ8PX78psRQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBTuVLeW1X997hLBAnESt8sTrEr+TXwqbBOtJlAd3rU=;
 b=SEUwNHSlGkVm2e7+CSry4uyYYHspwSgwQWj+03kxjk9ewlNBWrsQDDdw7uoLnFuGGfmOu2pErRGCEINt48yfgal3amSuL0SOzJLKDYBaUVqaCZckRYJ5epwTijovS8pL5AK/124SmuFS8dvgSWfwMkhBDJqNr6nTPXSH2ZrsUwxarthXu27itjORg6/GghIQiFE5odobE0Oz0m/iM2GMlcxO7Ir1TYx+BBCpMS/suAaBlbi/A2rVLxvpYL9TM2t0pMsS+cgy+6TlkCWM3CHaaCRurQbDyA/1ZlMI8/pdKDcclLdy294nt/n6Xl7Jj7FLmUnctspJvj4Cu5ROwb8EeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBTuVLeW1X997hLBAnESt8sTrEr+TXwqbBOtJlAd3rU=;
 b=BYG0FK/IoUb5sitNHfZuDnNBRn2eVmHYHwXG75DzQNQKyJ8bBFM3flKojiDpqEBYrecQ5jnzj4u03uZmyEhIXUv99XMVb9IV7Rf1AXJYxY8Dh3lNqycMEPYOR/8T3T91vgvireqfAPTdeLYThENb+3gZICUevKWhe9S58oCAHBZEoKuEtkkKQAVDPQMQRvqzaTAHzeRy8Ez3h6G5WldDj0CDRuaHQKQlrSeuW0dRZUzX1iftsBjMPXru2nKImzx4LoY4q7KijBsyn+PgTHyi8bgsMWWbcIeXOaWpOHojPegH6NqUT7v9q7aqUsBLX4bJcn1DfQEEGZhTikOdxRlLnw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:17 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:17 +0000
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
Subject: [RFC PATCH v2 20/29] target/arm: Introduce stub files required for qmp support
Date: Fri,  5 Jun 2026 08:33:49 +0000
Message-ID: <20260605083358.1320563-21-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08a472a4-bcc1-424a-6ee1-08dec2de7caa
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WQi90WIidDNdqWIaZtJ1FUdyvQBHQKHwR566yH6dHqguJGDEpGCaEWDsdzgsE5v4U7oNFV+uqA0LEtmHTEnNzMI33CSrt6ghcsksIdkN6p7wLYl39Ogfp51kznGkdzW0FNiV1ykEPhIxhXIUsmfyPDyb4/NnGrhqNcEB6krXqwKTPrnzmco5Jq2U2A1RlBXatINvvqdE3BcBNQMJLN1Sgpnka3Qyyqt4FcxnEKxuNni41uNmQfIqdmY4MQZrN0pK07trQiXuK3BDBgop8KC2QHhqBvwBCI374/Gpt8wSPoYkd8zMgoET0mv7333fjeo3cBYo4SVFdoQVfFdAlQPlB5OIMUq28ey6JZ9InwAbvikQgblrqLqSeEwoH0jpKrD8NeEU/kUfWa/wQdpx4OM0y2zzNRV6esRiofLddWPGe1QEIrxOGc5D73A3j+1OTy1f9yqHtc4F3eF5JHOpfLKDPfDy+a91C3XCLbX485fEPyCcREOY+75B15ZWBVFLLCkiKc5gDvuOOoy0yTky9Fzlq8aPpUiV8ddLbUezteSPeSjnyVCBs+Zq8N6ZsZmoCxDpqUphN1sE+nyqRa00b5rB2IX4IYFC4u28l8Ng0S016he/CSmv/XnwsJcGx9XOjehHdL+yclyk1v6Nt94TdHovnoRJcmj0UrUtg0KESU0p/i9oAwODWwTxdhyv4tFN1OCg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sQyks88w+Ys3ZDJCqWFB9miBjXQDOE4jSrwDAwncwXeN+1kyBNcs12KYCKyg?=
 =?us-ascii?Q?b6ek08MKCXt/Zph1HN5tqbVsnuRNM0MW7mGAPhy6jPP1ebm7vJB9qnDn8qra?=
 =?us-ascii?Q?AhMI7dca56/hJp+CXWKj3MZ/LZb2SIdoHRLlQnKmbDL3rWbT4v5jIMa9fW7y?=
 =?us-ascii?Q?lzhCgZsJLa9GxiX0vr1WLpFrYhZymzztJHocDsw6o8WGuhdPo0vqDH8JkpmM?=
 =?us-ascii?Q?qpIB6PviMd7mvzwb7E4iCp7DXyln9c7tu+vAjqZlZQSj62z5uMLVeqVY5sC5?=
 =?us-ascii?Q?SKGu8jxboA4XlQjKRkMxQow/+V65INOliuHNaHKt3Mc1Fw7j0oTppNHifHHR?=
 =?us-ascii?Q?Aw1uhnCYLYVDjaPbvrPGm6v15vSmv+2MfmkcOwfofY5KUAhuzVYfV+f9NIgZ?=
 =?us-ascii?Q?WYLSADl4Zox3tuYOdWOSR+CENxv/bt5j85WDlJiVE5X83MpySa1Koj37jWbK?=
 =?us-ascii?Q?1YgqGs32tM0kPsm2jLhk2X3lg10q0Yu691a037rjvBM/F3H6vGqF/ZCGq8rf?=
 =?us-ascii?Q?fUneXds/aip9++Edemm4KSfozXDe6S2UsDccMHIcZCmao3uQL12mpcMVzqeH?=
 =?us-ascii?Q?H/EfNjS01ETWjqJ0Fsvewu2U3oy6nFnDzvjir1Vcq+0gtEIY958Rb/6OdCch?=
 =?us-ascii?Q?Ae5y0cvOJ8+WbSi12az+CyvWQZccB1hOf6XdGPuDWc/rWmIGWkQ9QCaCtUE6?=
 =?us-ascii?Q?c38ks6oIzpPuei8CVGTfJNXVyXDgNxGdC+qCxjU0vjIwvezeR4VQ6BrfLfSK?=
 =?us-ascii?Q?NBw/wWMHRmqEO0xyU47guF/m5qbhdjd85R+fswkBCRkZOVxp++wK8qN+dDU/?=
 =?us-ascii?Q?ZEeyoTvI4EAg46SqF2WtPPkW7KFShnIbyaeGIoCQRf4VV1T39S/EEdLMdHO8?=
 =?us-ascii?Q?8agUq9PPtt+GCnX+NOGvJw8seefoaUNGdBsG/799jgQV4qlPdwmpiq6PUgKl?=
 =?us-ascii?Q?aIT2HWHlv4Eyc5z6EgOUY3Ec27FH1mQuQRMFH7BaazYHwnJL/ZG+7LSiaH0w?=
 =?us-ascii?Q?ufNVedKhqoBmqIxdSSCDavL3ZFz/fsqPI3rxNZS7IpBUSHE3j/QMW9lL4L8K?=
 =?us-ascii?Q?axOPNXN9DSL1+TkocFxrB8F6n+e2OyA4FjF+XL+4hzva9DAx+E7p5em41f4e?=
 =?us-ascii?Q?ch5VSxJXwaHAThlWkIcPY1Qm6jQLCv5aTZL+F2K0bwyqkAqk8zTe5UghNs3W?=
 =?us-ascii?Q?/cNn0EVAkXVI908AL8dGzjvklLe7BC0M6f9fjxfqxDsh09cOKbn9SRKPjp8a?=
 =?us-ascii?Q?aUE12nuxej6VbMRJvSZ2bJT684g/tcbI3sgeS+PLuGMWXhm8q4sc9dNNk899?=
 =?us-ascii?Q?14IRI5PQtAl5ka4yB++dkpjFVMna1MxLJHh9lYpQ1G6jJhuRGYfxovpQVCPZ?=
 =?us-ascii?Q?/WX7rr/6AHHcQcaFYTOrpoClbji7SH1JkuHu+pdUzFvcorHZRRKDBoU7hlCQ?=
 =?us-ascii?Q?VjyW8e1iZfi9869JSMJnheXkXwDtUEtiSEgo0NlVbO3u0SilZlTgGGmNfFVf?=
 =?us-ascii?Q?VdoaTCD4nCU656SbLxlVY6KzXPApEGSLrpE/66eOvj5MzmAA80f3w/nLK0qH?=
 =?us-ascii?Q?HGWhD8Wei5EG9lWYMy4ub8cl79e48JcJwGvJivTnU5cDK0QSKfa3WRoxVU4g?=
 =?us-ascii?Q?k2yfKQj0Pcsu6AjMRnMyaF6YVSxP6Zg0iN8pq5F8xClieQEICtVb0cAQmN+q?=
 =?us-ascii?Q?Behqm8g+pqtlmoS9BeKfA7xC2Fa7wlU/qHshIm9q5148/UtBkm+vKxdSW3ga?=
 =?us-ascii?Q?S21DJMIAkVEnCTdQ9YYN6AAZE91OOcg=3D?=
X-Exchange-RoutingPolicyChecked:
	JTqWI+kySbfDEuLl5vatEXUL6EYHpEfl3NekBsN1s6by6gvS7LS4F7EgQZ7OaAHamaaSyB3qecJrr1LecUxKG5OZ8C60F6MkiT5kKoS0ZDWCjU6ztvNZtlDwu6ceazQ9t8CuCEquwBHa3oPcbo6KaSL6IjhJ1bYWMNXJxnqPGV/UpRs6l0CaSrJP3oNa2fHbaab2nBiaHqCqmwsbe3lm3tZnSCrn8gFLBhWNJ9LepgDBTE4rvdXqf+OvXvXwp4lztrOevEDAyF/MiozPtgWdY8sVBAAZ1xEuHMYwpygXobuAohqfzol3CwKujRrnN+CIo8jGi5MH9hq8sQC9Q3RR2A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a472a4-bcc1-424a-6ee1-08dec2de7caa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:16.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1oZw94UFaM02TUak6+HjuidsNi/wyllE8MX0e36uhUzzDEQ9PnV9tHtt4EfQ1scxkPv0Wy041eTBlT9EMuDtYsfGx+xDN50WJFvvQrJ5u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXyuydJM0Xof1G
 dzLjQaHiRVNC0EAu1X5GsiCOY4hmU/AGXZyfeSCyh0aHBHwMN6EfZQPxwB96ZRUGPbqBtFjyq5U
 B29IispG2Gsn06m51+5ijTEA0sExN6XxfLOnNTY9MCCwaU8LUoDDb2SNtsNx9ITY+ACRecfwtcX
 4zzCB2CT+LmyWOiT+UK3+1qhKhAF8Ux/YPi2v0uj2hygSCzVw+XkSfbUQL1BZZ/MHIctrVEo0Ff
 QzGzmMgI9EeTja+u2Bh0GM0csi5kG2CUR9yOBx5+7S7KleFF/kQuaw1AHqrZXyvbHAcEefusfk7
 dhw7hWYjk/Y9GA34odjVcfmO1PGMwjNLlgT7Gl1xt24n9ylVPe3CirY0SgoP+AZcZj85euhLjc1
 3b0XtU/wee3K2l/Wbz22/idhF74vFrlcx/zICK0iu+8VQaUHIP8GvT7XyciVYnKJlDgmNGL9ZmQ
 mvGulucVDg2Ac5pmZ7A==
X-Proofpoint-ORIG-GUID: QGhJ-W2E3A8zvEwiHj_qkg_6DcYJxQxQ
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c29 cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=GiayiNAqsrDiKACkrzoA:9
X-Proofpoint-GUID: QGhJ-W2E3A8zvEwiHj_qkg_6DcYJxQxQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add arm-cpu-props-stub.c and arm-cpu-models-stub.c, which will be
required to add qmp support.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models-stub.c | 13 +++++++++++++
 target/arm/arm-cpu-props-stub.c  | 23 +++++++++++++++++++++++
 target/arm/meson.build           |  2 +-
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/arm-cpu-models-stub.c
 create mode 100644 target/arm/arm-cpu-props-stub.c

diff --git a/target/arm/arm-cpu-models-stub.c b/target/arm/arm-cpu-models-stub.c
new file mode 100644
index 0000000000..0481f0f946
--- /dev/null
+++ b/target/arm/arm-cpu-models-stub.c
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model definitions - stub implementation.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "arm-cpu-models.h"
+
+
+const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    return NULL;
+}
diff --git a/target/arm/arm-cpu-props-stub.c b/target/arm/arm-cpu-props-stub.c
new file mode 100644
index 0000000000..abac29ae50
--- /dev/null
+++ b/target/arm/arm-cpu-props-stub.c
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM CPU feature properties - stub implementation.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "arm-cpu-props.h"
+
+const ArmCpuPropDesc *arm_find_prop(const char *name)
+{
+    return NULL;
+}
+
+static const ArmCpuPropDesc empty_props[] = { {.name = NULL} };
+const ArmCpuPropDesc *get_arm_cpu_props(void)
+{
+    return empty_props;
+}
+
+const ArmCpuPropDesc *get_arm_composite_props(void)
+{
+    return empty_props;
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index a7638f8778..63d038f285 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -14,7 +14,7 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu-idregs.c',
   'arm-cpu-props.c',
   'arm-cpu-models.c',
-))
+), if_false: files('arm-cpu-props-stub.c', 'arm-cpu-models-stub.c'))
 
 arm_common_ss.add(files(
   'mmuidx.c',
-- 
2.52.0

