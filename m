Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234933D0C0B
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650591; cv=fail; b=uZ9EMDepfgTjzRuvt2iJLza2bECLnIb+o6MiEV3Gkpe3sHBH082wjGjGQRsWhxFD3qGGDPnNazn9hnZcPxWTGHp0qzC7pf4daGQp8UrFM3P/iA/KK/fXtpY9zF450sD276A5aK5m5gYonamAkJiA8nI2TveZJOfdHV2MjwMtAMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650591; c=relaxed/simple;
	bh=3Vhxtgo47RW/9SL0ZavK0fRnD6KHL+mVlPaTHaWaKp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GypkR+/bdAWh7DZkQ/hKV3Gkx1jHgblg4mgShDVx1XaXrpgGWeyxSJNqVov96SHPVkdmdACJgjjbBJACqke1T1nrmL2UUTfpmwbSeXCWJqHhvHk659LdqnPNchEBuER5mVp+E07kv3Yo1lZ4aE+qLBGZEZSqcSFKxex+cu7urKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mATnUc11; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WZURjruB; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mATnUc11";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WZURjruB"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556OdLV854749;
	Fri, 5 Jun 2026 01:43:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1PIlUSyRyQbnqMIaxmvn+wIaL5DWKu+at5o6+pZkt
	FA=; b=mATnUc11DzIjRhV3a8siZFKG/p79ZoNjQAG+fTK7S3I/+OFPbnNMnodxQ
	uA6FQuUjdaBfwA/haxAGApFXR1kRdNHq8mQUxhgJgefUvgqjSmXratttgAyRFUXC
	IUJXiq6ne4ZHZHxX3T0i8ND+l6NnCBJCUmpgdBkqZdYnl11G1r5sQetqcmgncn8R
	MeQDFC9WerkdCGC71eLQsds8P61jZCAm9pKeeDnweWfjKvdsZEuANdfsiBnyFHpa
	t1e8lDSaZlzyZ5ynUhJ9+ZpSLL0IauSl8tTCPzoRGsd4iE0RyBWlm+Th8ylwoY/L
	L5REN7jTdLJs25WNEsFNhxdJ3c0sQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021094.outbound.protection.outlook.com [40.107.208.94])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejupdmnv4-12
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnL7LfVIuLwz3GFGcZItVRyIOLv8nedshm31oa7mkbX+r9j5l6lkMiC6yu7/3bDS0mYUyNTCE8Qmi0J9KZfNlIAM0soGrKp06D5esujnpBXgl/Phnv0hSDMWEGr51u/BH8dJamNKbnEEuLO0aB6q9YUkGNAe+D8AF4dywwXAY5nXgZl/SFcRBmFD/bMovq2vfsdRGeeGx458WLuEOx1NtKK0vu0LxTC0Nel1780n7lfQmOZ6GQvCyckZ0qGeFmjyCrctRJyNc19sncWD3v+yuXL7nN9/LYWRy3GDSgBHXtYT3EZOsnPap3lHmhczr2R+ErS/vl1n8YZBSQpsD7/tHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PIlUSyRyQbnqMIaxmvn+wIaL5DWKu+at5o6+pZktFA=;
 b=AxImPM2ntOIo55XztkiyP2x9eFf2iMvqW6joqI0Fr71jubMm2M6O3xounqD84nynS07FK0erv0BshPAn0hfYy5zvNriNBiwEY1K2sctH0QMFHID/Cq7PLMO4MYxQ3KXrzHJzwmMKQa3puk0n7AM4UN9UPklWIrp6u3AXr3rd3nfs1BrSUV1BuzfhOlGAwECyslwhUUUSii4/b02pQZDSux3AC/PWJmSzLIR9vBz5JsPHube2nHpk9mSQlwqRBnq8EkP2TmHNQXjUASvrKee/d3XDUjuE3f85Uo4imoPCop5zp9aXQxLkMw1bMVXJqj4h2MMq2q8IWeS6rX1lEZo4vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PIlUSyRyQbnqMIaxmvn+wIaL5DWKu+at5o6+pZktFA=;
 b=WZURjruBc+AtW/SHYDFLMhq3mWAceVtOmkKaLYekC3NAAhZI9Z84rncWJ9liAUFL6eK39VHLf/hrVMbwK8ULAhNC1F2ehupRMGuCkvqm9XAFuDCRlP6fIgcBzM9LN55kRyjxJz2HjjxvqHnbRxOP7wL+C8xY3hvZS39uQNKGmQRJ/rOAfam1/arB6wTvoCKGM4H1UQmyBAqNzF4vr6wUPq8s4mTl1bP43xJ9nQ8VuD3P3dC1UQMVmseILCa1i4JXSk5nDtgr+rLXdbVgn83CWp60YXwC3QGgZW5I0WbCwkMdlUF2d85ITS4kqhZfgQv2DUE/a9FG/cHkXWXHEhg99w==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO6PR02MB7812.namprd02.prod.outlook.com (2603:10b6:303:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:13 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:13 +0000
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
Subject: [RFC PATCH v2 12/29] target/arm/kvm: Writeback modified ID registers to KVM
Date: Fri,  5 Jun 2026 08:33:41 +0000
Message-ID: <20260605083358.1320563-13-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: f7529985-e1ba-49b6-894a-08dec2de7abd
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/KY0Bn5hohR+GB84xpabSBIWE6MAy0D8NYygBNakSHu+xiR0qklAEYlEEe5iIbjpqTrPMiKg8YgC3INHFFoSANBgEo7vM+93iy/98Uhu0wVQvw/YUSj0GpnfZxYiou16d8FZ4sEl/0kjj9i75U+r25nQHpv5CWAUO1yRuDwrzgVHqj28o2QmrU9Huk1cj2i0m6KFJr2TD6PTt1L3+9XqQSCGXCcud+vQVqFOsIyzkDA04N++leMIb8EMHIJzMLMpfH/IQEOWDKgyRZR4dGCiR+zVfAw4AzIG7m7WwoBmQE9Pz1f7I9Kqy1TTx+4qmVzkwTNgb8TK6EDtBDtLtANbo24nx4nOGx+spaOpAMk8bNrnulxN94dDUL5GXadbJhUBI3Nth/WUvJdwrawuOsRlabLRBZRjSlZprPC4G/m1bQm+q6hK+w5lqJbx43XDF5B1xrSKritSYOSqm11MyrcpzqMEZcUOksAOouYOIYY3nQ9j3wLKBLCi+mgcnTWAIXFozQWquDHQsafTq2Vwfk3A9w6oTrpKwHURW9Sh94/3xu/jdNfU/DFip3kCZUDpWLnKiHKtsEMz5KdonM4M/Dk/0E6wLLgysPE4hKMyFn38b4bYLBXeZEHie73qidZJZmmdHWZhe07ovTxLabL9pcdqjpGSGiQGWGSia2Gz6hFfycx32xEHMO92G69CDQ7nU4cY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oi6lRsAk8kKyk/Sb1z4OrM7nd73+Ew7RjqhXiByJaODWPHaQ/ZYo0ssZ3tz5?=
 =?us-ascii?Q?zsxJ2JD0RNjByO8s7bFzNzVoCi38QzKaSteOpKfMdP+6zhV6HDDij8gsqAvq?=
 =?us-ascii?Q?Z7p6a1f95qu19+YOYt9aR9zYRI7mpJI8RGmrJXxO7TzH9gIWv/KUad8kwlxL?=
 =?us-ascii?Q?d54MXJR+F9Th6in416OTslMOrY4OFyf1p9UOzvBXpuaeukY0Uw76NrIRCmj4?=
 =?us-ascii?Q?UPiYKnldfZD+C6yAtFz9XTK7gVkGPz9Q4puvCCImyRHZdfMzKAJXlqS6J1cV?=
 =?us-ascii?Q?kiFJ7o2qLtuNf5OReSKRsaNGr+DmG+fmkZ2hYjUYGdvgB0+RE5kFLIt5QRWo?=
 =?us-ascii?Q?wC4oCUKRhbE8qZ1h4vxLbKz+qrPtLjrbckfVzHxqPJtfujxtgmzUcEOvHTz9?=
 =?us-ascii?Q?uRFitRwWviCHe//pl6ayE70NxEOeFuCsDWL7Xujk9HeYXgrf9JmpitRuchXk?=
 =?us-ascii?Q?aOrkXr+wDvPMKZaUz0fNrtp5hF90bsWHq49+hPK+/n1T7pd1Yvqs/iC4gp2X?=
 =?us-ascii?Q?pzjjB6pf+NRp7j2sq/Lbuw0pCtTxkgRsiL3i/Cxyh5K0gWf4Syg4qeCcamH9?=
 =?us-ascii?Q?iu9/fOs11W8bgiNnredUW86I4lUZZ4NJtooX6ulFYHOGUNgHJI65NT+oRbF+?=
 =?us-ascii?Q?2Av1pCY7mqvIZTKCyOyPBu26w5KJzNkHx7xvCPQZZNEGTCa91zul3udPlTLo?=
 =?us-ascii?Q?H0BS5SI9BsK9yn9TbOGOI8OCWI9/o8BZAVQUPbT2Y9HSKsHKlNeKpkLIyNJl?=
 =?us-ascii?Q?s4pCyxu1aj6QVncpRNZkRxNj7Fb0f+jk9UbIeG0x80KC5fN/hcvGtgvnnYe3?=
 =?us-ascii?Q?fnOGdDMCJgiPVXVtc1YAHvb4vTcNz7UReSdQXbu3IlW9sVTi4/sx6XdQm8zQ?=
 =?us-ascii?Q?PBKSD8LRAGoDQM9XAUKlkxcNTfEfgZjTS3QIfLvWixezSYBH7fvRK3ykMrx7?=
 =?us-ascii?Q?3YwDWlOUFBfUgqQDazVqdrg3J3LJWM3hi6NtnW9BSuOmOezHPgQTQqC3vzoy?=
 =?us-ascii?Q?uLZ13+t0KwcznNytkSdKC3mmiFeWUd71CjYtHfDqfn4Cn4yMzCy6siGbU+G+?=
 =?us-ascii?Q?EFxKPl43EzZmLMwBFt325jd9OAg5GKgFfJU/2eXGGhEXDc7h8tnCQCu9pXUs?=
 =?us-ascii?Q?0uYo07QFQoB/2nltYneGbm2UaAm19ZJlUOFrSmo1idf0oGhpeNm8FqsqxDs3?=
 =?us-ascii?Q?QzWXRXLA08SkAhXuybrYP/xNLrMFKTliclFXhUil151xWiJSsyJZvR8tRxLS?=
 =?us-ascii?Q?DUBvIW9RcKfLt2TZt8bFMUYMnZZJlPAWbgCPta1pkmgKjrEfy0u3Bb+2R7ra?=
 =?us-ascii?Q?PEbtLWIbuVi9EYWNlJTSyHatoDzUxUQEVpsopy5IEBEB+6DnQIGfSojB/Z6R?=
 =?us-ascii?Q?Ra6VD7i9kCh4oDkMWo7cGLTZR1/fY5EE8rD7oSSo8WDuuS1KB09EVCiBgFS9?=
 =?us-ascii?Q?6ACHuGYOu1sPISm4WN7ZBJ5zXtxRk+f/+p4O0i3avGq9AQtFk4uVzNbB/JRL?=
 =?us-ascii?Q?ksR80QPfuMrjxvXJEIMXGcoPkhNc1bMfn7UiLpGiqNCphE7v82gC40uOKi9E?=
 =?us-ascii?Q?nT8w17NuS7Z/dBUZfXnLOmmR6Fv7KkIwVRQ7TlPNMBBkijjeW0j+behGp6dl?=
 =?us-ascii?Q?eZcqoV0ooGA91YCRB+BHB26xWPHEzDXj1sj6jjkTAJLqOHmTnylmkY3leuf3?=
 =?us-ascii?Q?XTrdpEqSzJWFOEdRCwOETYhDXda9MPyp8y+ZkhwEE70ShsNk6k3MBH0JJ2qq?=
 =?us-ascii?Q?rgnPBrgQUlVb3LCiHrWeMvLDmolGouU=3D?=
X-Exchange-RoutingPolicyChecked:
	AZDNZMS//6BG3ylUpRhczKjU71u4Kgb2KR30RD1Y8aYQ9eBJ4JowflJZk53gTQNB4LD9xbPm/l2Zh5kWChkGHGExMnnccdmyl604dNDtjh536JCWZLJOJaBb+PqLDJd1V4klyCcI/xTJMs22x8+j9HFt7OiW9uuqKOy0vbUt0PmbQozWhWJP3T4HxC/rk56FZWtpUmF2uLchMXT0nHTQIEWQTvTmJE9XhLxbrc5bCLyVKpVvgH1MlQkQc8j4jQLth0vkdVQM1M7lK3MFbwvp5zUy9kt0S4qIia/DNlmFVwnl2hJjaYqETya+Fg58bWXK2uGGrjrgR35UOXuZcUHMew==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7529985-e1ba-49b6-894a-08dec2de7abd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:13.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8YUlpt7rXMS8JjiYqCdE8xuPe4gdzpHT4Fwev6f2ed6asxv+xpLzvv2LnOfEEBNTv0m2NPUYBukzPV6CPoQYi/Itg9aCh+MAHNQHrMwOKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7812
X-Proofpoint-ORIG-GUID: eokLnURUXjhavsveopOjz59dKiCPjHCk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfXzH02XDBOmqKK
 qMnUMsR7uDPHoBJtx/6TrTdw7iO0Gr5UfMoXJnRW4Wv+eJwxr081mjGRcb3SPHQMbcaEz35x8r2
 gfmEimgU6JhDPA40CnO0csbOwD1gk9gMWAQ1vIrx7AvjIMMPlNn6Gspn8aBfNddvSYmblOEdoa1
 u/fIJwqPp1/ss8C82f84Az2UG9TOnHam2Kr36HyMouMU/S9oc8U++MV1fXvn4asHBz8silMsHNl
 jX0DrfXIzQOVbaIAkDRnKkvQzmsKk2bprYop8VEOVYpORDR4NSPmF/4zYmQPDGAhCXPS6C60Nbf
 z8I23P/WwpnGyyorOfOegLdnivC1T+WGB76jXyb3i9WyNnjJQLLL8Itt/8SgVpDWZWCnhzRuKqI
 zL5gPk20VIxYChkSp9ZCeo8hOEBBHnsGBA+t9K1nT9VoiuPP9c1hp90DirQyeOPabxEaUG5pLGC
 Tc+NnvVFUv9kgYtY44A==
X-Proofpoint-GUID: eokLnURUXjhavsveopOjz59dKiCPjHCk
X-Authority-Analysis: v=2.4 cv=dYmwG3Xe c=1 sm=1 tr=0 ts=6a228c25 cx=c_pps
 a=Dy1/g0x6RHl9kMZQX3cATQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22
 a=64Cc0HZtAAAA:8 a=4gZVCyc41vjegMDvRH0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

After named CPU model is realized or host model is customized,
writeback the resulting cpu->isar.idregs[] back to KVM. Warns if
any non-writable bits differ.

For this:
 - Fetch and maintain writable mask per ID register during scratch
   vCPU creation.
 - Try to read all ID registers values, so we don't writeback any
   stale value to KVM for -cpu host.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/cpu-idregs.c |   1 +
 target/arm/cpu-idregs.h |   1 +
 target/arm/kvm.c        | 160 +++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |   1 +
 4 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index ee6165622a..591ca54e39 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -72,6 +72,7 @@
         .name = #reg, \
         .fields = reg##_fields, \
         .fields_count = ARRAY_SIZE(reg##_fields), \
+        .writable_mask = 0, \
     },
 
 ArmIdReg arm_idregs[NUM_ID_IDX] = {
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 01d1b8f797..1389005099 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -71,6 +71,7 @@ typedef struct ArmIdReg {
     const char *name;
     struct ArmIdRegField *fields;
     uint32_t fields_count;
+    uint64_t writable_mask;
 } ArmIdReg;
 
 extern ArmIdReg arm_idregs[NUM_ID_IDX];
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7d194ea112..dc64cfbeb6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -28,6 +28,7 @@
 #include "kvm_arm.h"
 #include "cpu.h"
 #include "cpu-sysregs.h"
+#include "cpu-idregs.h"
 #include "trace.h"
 #include "internals.h"
 #include "hw/pci/pci.h"
@@ -66,6 +67,12 @@ typedef struct ARMHostCPUFeatures {
 
 static ARMHostCPUFeatures arm_host_cpu_features;
 
+#define DEF(NAME, OP0, OP1, CRN, CRM, OP2) [NAME##_IDX] = #NAME,
+const char * const sysreg_names[NUM_ID_IDX] = {
+#include "cpu-sysregs.h.inc"
+};
+#undef DEF
+
 /**
  * kvm_arm_vcpu_init:
  * @cpu: ARMCPU
@@ -244,6 +251,63 @@ static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf,
     return ret;
 }
 
+static int get_host_cpu_idregs_all(int fd, ARMHostCPUFeatures *ahcf)
+{
+    int err = 0, i;
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        /* Skip registers whose plumbing is not yet added. */
+        if (!arm_idregs[i].name) {
+            continue;
+        }
+
+        err |= get_host_cpu_reg(fd, ahcf, i);
+    }
+    return err;
+}
+
+static int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx)
+{
+    ARMSysRegs sysreg = id_register_sysreg[idx];
+
+    return KVM_ARM_FEATURE_ID_RANGE_IDX(
+        (sysreg >> CP_REG_ARM64_SYSREG_OP0_SHIFT) & 0x3,
+        (sysreg >> CP_REG_ARM64_SYSREG_OP1_SHIFT) & 0x7,
+        (sysreg >> CP_REG_ARM64_SYSREG_CRN_SHIFT) & 0xf,
+        (sysreg >> CP_REG_ARM64_SYSREG_CRM_SHIFT) & 0xf,
+        (sysreg >> CP_REG_ARM64_SYSREG_OP2_SHIFT) & 0x7);
+}
+
+static int get_writable_id_regs(int vmfd)
+{
+    int cap, ret, i;
+    uint64_t regs[KVM_ARM_FEATURE_ID_RANGE_SIZE] = { 0 };
+    struct reg_mask_range range = {
+        .addr  = (uint64_t)(uintptr_t)regs,
+        .range = KVM_ARM_FEATURE_ID_RANGE,
+    };
+
+    cap = ioctl(vmfd, KVM_CHECK_EXTENSION,
+                KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+    if (cap <= 0 || !(cap & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        return -ENOSYS;
+    }
+
+    ret = ioctl(vmfd, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+    if (ret) {
+        return -errno;
+    }
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        int kidx = idregs_idx_to_kvm_idx(i);
+
+        if (kidx < 0 || kidx >= KVM_ARM_FEATURE_ID_RANGE_SIZE) {
+            continue;
+        }
+        arm_idregs[i].writable_mask = regs[kidx];
+    }
+    return 0;
+}
+
 static uint32_t kvm_arm_sve_get_vls(int fd)
 {
     uint64_t vls[KVM_ARM64_SVE_VLS_WORDS];
@@ -455,6 +519,22 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
             arm_host_cpu_features.sve_vq_supported = kvm_arm_sve_get_vls(fd);
         }
     }
+    /*
+     * Try to read all the ID registers. KVM does not yet support it
+     * for all registers, hence ignore the errors.
+     */
+    get_host_cpu_idregs_all(fd, ahcf);
+
+    {
+        int wret = get_writable_id_regs(fdarray[1]);
+        if (wret) {
+            warn_report("KVM_ARM_GET_REG_WRITABLE_MASKS"
+                        "%s: %s",
+                        wret == -ENOSYS ? " unsupported"
+                                        : " failed",
+                        strerror(-wret));
+        }
+    }
 
     kvm_arm_destroy_scratch_host_vcpu(fdarray);
 
@@ -1080,6 +1160,71 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu)
     }
 }
 
+/* same as kvm_arm_get_cpreg_ptr() but can return NULL. */
+static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
+{
+    uint64_t *res;
+
+    res = bsearch(&regidx, cpu->cpreg_indexes, cpu->cpreg_array_len,
+                  sizeof(uint64_t), compare_u64);
+    if (!res) {
+        return NULL;
+    }
+    return &cpu->cpreg_values[res - cpu->cpreg_indexes];
+}
+
+static void kvm_arm_writeback_idregs(ARMCPU *cpu)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        uint64_t kvm_reg = idregs_sysreg_to_kvm_reg(id_register_sysreg[i]);
+        uint64_t *cpreg = kvm_arm_find_cpreg_ptr(cpu, kvm_reg);
+        const char *name = arm_idregs[i].name;
+        uint64_t writable_mask, previous, desired, diff;
+
+        if (!cpreg) {
+            warn_report("KVM does not expose ID register slot %d "
+                        "(kvm_reg=0x%" PRIx64 "), %s; skipping writeback",
+                        i, kvm_reg, sysreg_names[i]);
+            continue;
+        }
+
+        if (!name) {
+            /* No field table, don't push back. */
+            warn_report("ID register slot %d "
+                        "(kvm_reg=0x%" PRIx64 "), %s: "
+                        "no field table in cpu-idregs.inc.h",
+                        i, kvm_reg, sysreg_names[i]);
+            continue;
+        }
+
+        writable_mask = arm_idregs[i].writable_mask;
+        previous = *cpreg;
+        desired = cpu->isar.idregs[i];
+        diff = previous ^ desired;
+
+        if (!diff) {
+            continue;
+        }
+
+        if (diff & ~writable_mask) {
+            warn_report("%s: non-writable bits differ: "
+                        "kvm=0x%016" PRIx64
+                        " desired=0x%016" PRIx64
+                        " diff=0x%016" PRIx64
+                        " writable=0x%016" PRIx64,
+                        name, previous, desired,
+                        diff & ~writable_mask,
+                        writable_mask);
+        }
+
+        if (diff & writable_mask) {
+            *cpreg = (previous & ~writable_mask) |
+                     (desired & writable_mask);
+            trace_kvm_arm_writeback_idreg(name, previous, *cpreg);
+        }
+    }
+}
+
 bool kvm_arm_cpu_post_load(ARMCPU *cpu)
 {
     if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
@@ -1116,6 +1261,10 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
         fprintf(stderr, "write_kvmstate_to_list failed\n");
         abort();
     }
+
+    /* Re-apply named-model ID register overrides after KVM_ARM_VCPU_INIT. */
+    kvm_arm_writeback_idregs(cpu);
+
     /*
      * Sync the reset values also into the CPUState. This is necessary
      * because the next thing we do will be a kvm_arch_put_registers()
@@ -2051,7 +2200,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    ret = kvm_arm_init_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
+
+    /* Apply named-model ID register overrides on top of KVM's defaults. */
+    kvm_arm_writeback_idregs(cpu);
+    write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+
+    return 0;
 }
 
 int kvm_arch_destroy_vcpu(CPUState *cs)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..975236b24f 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+kvm_arm_writeback_idreg(const char *name, uint64_t previous, uint64_t desired) "%s overwrite 0x%"PRIx64" with 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.52.0

