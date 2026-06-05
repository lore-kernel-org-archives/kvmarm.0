Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374A4A2E3A
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 09:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650417; cv=fail; b=Pd6eYynGem4Zy6Fx4o6eWmqxL6RheCpSE8glNoNckm7n4KDL5vasq5lpJCbHsIDR8ZhKTuC18jHIMNsZQPMb3CAOJIbFroKvZ18hA1jsjwy643gX5ObgYE5j0358UCh2Vt//ueg3Z1FiGmSXiEkuimnwNG3/1ZO4CMwhU2+ZG6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650417; c=relaxed/simple;
	bh=g6ol7PCUs0bU36FOSwkPK7EQsmoHKoaU8CIQmHU1elQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r42mIixuz2LtWqftgcvyr8tXRqx+QiV97INOCGs5qjiyMiCb8jMJixi0n2AYvzoXXELv/NqbaVEvzlMhsT3K8i4Dgk83/wpVSy+dyvxaP/Xewbjp/PkMfrD8yL04G4ccU/TBafW07UA7KNfaCg4hjyXEQHXV6XD3BFHu/bCRLKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Jo8MG/MR; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qAUtc3Re; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Jo8MG/MR";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qAUtc3Re"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6556MRUM1185382;
	Fri, 5 Jun 2026 01:43:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=FEYqNoMy0ZVdBCmKsMqF/W+KRXqxdxVrRHRtgRCqS
	UA=; b=Jo8MG/MRvMgHqsdrXbqKUtndBeIohGYQ7sTrF62DynqtuFHxgFMwp+X/x
	IPOrVChWMp046Fjb/oQOWtG7aKFHzisqcLxUmAQXMjmen1241tXrCxSVANsqIrdO
	Q1KcK/tZaB+VLOUv/Z0u98HLIeZhUbLmBY9bquSyGeFOGt+O7NahwMt7vPMZkKFC
	xSWsKY23E25wn5hkm9Yl8UfZYKFyHNVb0BcqF5xSW0Y81V4AllSpqeXpRSguyct9
	Ggw+Lw/N+wbtxx2DbqpBBlk+1fQkWNaZiYweoWqaMMT2ZDJ2o/XVe9gi16AZQVVm
	BQfxutMWEZGv9nizqBxn3lnz432LQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020134.outbound.protection.outlook.com [52.101.201.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ejuupcm1f-8
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 01:43:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROFT92bzZgEvpkZ7AMk9Nid+Vo4MnEYz71m5/EOfFxXqKJEOjsmx7CklV8vtUgwiQGI1BOPzGQsU1kVpbxgcqjBJxkXjHKToPfTt/Y7LHyOcmb6PmFvStEDkRaOB0Q7wuNaHkoKwSm3YCZnRnSsqw71d0RbQbm+CwzOvZI+PPBHNQwvut7RtVUXLLd638kGnEWHoCi9uZUMaw4RkexMluaZhCw+RU0jM/j55stE4HJUgdlZkcSRFn/slzO6ZjIWlYwr3XHwvXj9NIeHUEAWxIEITgKCFfjcZ+CofufxtsDKQTfM/HUOiy5EaEW2+nJ1iqDDyGO+KvfGPioi3ig5BZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEYqNoMy0ZVdBCmKsMqF/W+KRXqxdxVrRHRtgRCqSUA=;
 b=NIoqAaUkWqFMiyHBo7ThILJ5p+6KVYvVp1NS80+9/sTnqcqkVfkKiuFhKWy+C27d+Qtuj2q9FZK/Mdtp0OcZTcuoTQ4R7qBXek7HLwn03XXLI6fBFWwmxLADfqcjowKCx5wHanS27wzaKhDSBNYYFyNMrW8rm7TypXyFDZ+DAL+SX/GBTpiGCqmisdNs7ruWKPRFyweUhVjRDeQYQ8t+h8gnmbvOICB8bTV5kvA4YsuWtMIpPWOsvMNoubX7F0AcjM/iH9l00R2Y2OwhSPXcH7GxJYv254xxxkL/a4cnDkQ5kFw2qSa3VQaWvtYrAN+96xdT7iCof/EHejFKOnxpMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEYqNoMy0ZVdBCmKsMqF/W+KRXqxdxVrRHRtgRCqSUA=;
 b=qAUtc3Rec6AgfvWZqVT4f/gm2VZDdaZX+vEEFMHdMA24Qw1G6KSLOQ8pvJAfIveRZWwOgV0l5avngn2pJhTHvWDb/JBKC0DPfsy7G0esbJs0JyGo5TQoJcvIwONalFw8l0zvUBoQAWkbMFFAihBsqWwtxYCI+OKkF6YZsJF9aKBHLUqVWCOaE1sS+uJYYnETyufdxW5s9uVJLhNrKaaV8fcKtSpk+FnoWSfOlG4DejgPsyBJCOa9kC9X1jpXLnMbChlvI/RGvHzWP9v8oM5evhaHtZfM1RbqHKQR5aRnIRq0pkXM5FqCzrCF/fBhTxhSkXdH8oGIzTOt+V4JILKHPw==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by MN6PR02MB10630.namprd02.prod.outlook.com (2603:10b6:208:4f4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Fri, 5 Jun 2026
 08:43:21 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 08:43:20 +0000
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
Subject: [RFC PATCH v2 25/29] target/arm/qmp: hook blockers in query-cpu-definitions
Date: Fri,  5 Jun 2026 08:33:54 +0000
Message-ID: <20260605083358.1320563-26-khushit.shah@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: fca6e6c1-6f3b-4b4e-c14c-08dec2de7dcf
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Zs/9rwAE/jBMd2CT0QG8ArFJLjmfBAhj8ZsmQJPqNQgTLXXc9+/s2baAPJnJrQ9osiAibCCDqTyI9oI4qM95w981G+yYc9S4B0UiIWSGpd67+t3piHXiDK+KW7njjvcbfSE908okQz0ez4Nb3vke499p1YbJ6OywklPG0hf0/V8otSAM4i/pHusy2i8hNPrt+W0K6Z5CGp6a3y4EnyLt3+HV5E/s4YWgCiNfXJ2fM7iE/WD5zmXRStkML+/xblI+BJCETgdRfsdut2AVAR19MpzXJwvVy5UbVnq9qbXv5yKfxqhbRQtg7izyWUYaDiktCUXJGcIUwXky6qW7DbTniPGahwV7MoWYdn4qjVnP9zKqVHTXzh7lmoSB7GrRnIjwUCpPcX/ryurhprQ+omuqplu5U2iRks315mriiAaMVuaj92oSrMZj89Dc+Un16zgx/oUaxaaPYoVY2Yvi5vhc1nd7Y1Wugp8uSZYVcfNFsNMepIim8n6qcYEG2tUeGgFD5NjY2PN72M1sWFEtgR2BrRxs18ri4HgHTALDFBeQ31OOm3H8UgKdjVH+HqrPW3xSw/OC3KuacjxnobBxt70e9sy+Gu29sz5JJVAA5IYXGGqX9tsbmRZRQ80HXl4JywhTYUc0KRWRuLzYVLnG135k4mWsArDRKkbP8XUcZqd6nofOtgajEi20lX0VribGnPPh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7+qTh1onR38dtt0B/HmJpEIfl6j7d/iVaeJDBa+f7I/NH0jaYxxTsISPPl0R?=
 =?us-ascii?Q?+GTRmXix7IsBUned26ranN8C8kvYwZFOkBAVR1ig/O+Wtu4+ANEAkgnQUjhw?=
 =?us-ascii?Q?bmu4ktKJm1Qv3+qRwxccXBCXB2gBuoPo8tOa12z1mYQ4loGEaQXdL6ZeZyy6?=
 =?us-ascii?Q?xLeeIHSAbxreBqUbcC8jmO9TNSokD4cAQ0QHzlSdxi8X2PMLPqACQkD50lae?=
 =?us-ascii?Q?4/4aEbibZtsR3oQDAPjaMmodU8ocoCp7+tRNzbpvmDz7FO/oxMtkjpZo4Mfc?=
 =?us-ascii?Q?ottw8oRAqc9VDJV0K5aLCsCgg+Jm7gCWAXtNjL9aOtpzLHSJ1iRRKFPyHVy8?=
 =?us-ascii?Q?NslP9wWBwX8nI6k7ndluaIiXSDwPhhpKfOl7F2CdIzchjaNSbumOs8WTfMzw?=
 =?us-ascii?Q?/ZeyTAZJHt/syB0Mlr4i846hqH+2m9omN4D8yI9nbguw254AsDIvEHiBMv2Y?=
 =?us-ascii?Q?HrVaNcfL1xotmgmP2VTEAmLLwT7J+ZPS2CYp6SIFwTF2n6WGTc1dHxg/N4mH?=
 =?us-ascii?Q?q9gek+vZuQk9rx7VJm5Zx0ggf5LQztj90rasWEd8L3APPkrkrHSEDn1KCa1g?=
 =?us-ascii?Q?H9uiyUsJlx4RxPUxsl0bEusFMDgPt3n/zLmk9rDHhBr+5Nb1p3rN2NQe6GbQ?=
 =?us-ascii?Q?F2SnBaCyZ6Qh51up6H2rmaWD72c35bzv2MnAFVNhWG5ncUYFGvHY7cYVS7V1?=
 =?us-ascii?Q?syaRTjNsL7aC3THQYomKI6AL4m709zoxc4uJ865dCG5Ndhbx86w2DrSWOUR2?=
 =?us-ascii?Q?ecW5PVjtUXm9C3KVoAHrJtpvjjiKnkXV9JBpY6lxczqd5YhhFcRsf3kMykjO?=
 =?us-ascii?Q?Iu0ZyVinyI5EbunHEHqbCiM0oYyDwOuY7ZAXbPO9ncNExIVRRy2UnFHplPun?=
 =?us-ascii?Q?MLjfAq0rH7NxE9MzYo+b7sV6zwRC6Lbz/K47CBzwtjs48R4UAzcRBHpemdi/?=
 =?us-ascii?Q?Z+56smqPMXxTaV1bLu/xSeaGyDw1apdP5dg69HSTXtbg+QcEMJNP+rJbk2Wm?=
 =?us-ascii?Q?50CrnlYmT2jAxURORDcgV0IvOsCC4CFqqv/QHmPPWuVK70f1aubL3/rLSaZb?=
 =?us-ascii?Q?v0lpO2bLJoPYQsWTc4KXHCOmaWa+zMggSNDJdwoS76sOJaGGua3RvQMT40eV?=
 =?us-ascii?Q?RvCg4qzoxZZzkWB+1uDdpRTJ7hG89B9z0Euzq1NUsHCrMnPwEUxIVSi8cNRk?=
 =?us-ascii?Q?d/TulI45pUS4SY+78D8mfkvJfxZY+PqmlElo3qhMgCxXsT/tbFH08ziSXOsR?=
 =?us-ascii?Q?tNZAsWOLpFnoCHvYJ9BA89jL8iFrE41VeHR/J35z30Y196gQtJP6mxxTxUPL?=
 =?us-ascii?Q?4nJRiktQBkahLYhT1B7EbvzHjlleW12LIVsSaH7XePhoijfFIrRD+KLTD5fK?=
 =?us-ascii?Q?QBWozLyeSe1dgIkA78Ljf7WCpkHeYjdbu3embER553xnJQ2qxHklx2ySJRgo?=
 =?us-ascii?Q?YUjwKodmamfPR8cZ7MG62cE0kyJXBlW3MPSVSsF+k/3iiIZGZ4YIX08XBnuw?=
 =?us-ascii?Q?8Hew71JcRC/Mu+TUBuK/NS7KsLX1KHtJxYgH1YRv/HzX3ORB0KRHvpb1NbpK?=
 =?us-ascii?Q?8+fqwiW10rhWi8kQgzv/4F2lCubKFdOuRR9vZEroyIFCneUFMUlmXrQvooQM?=
 =?us-ascii?Q?5cbooNF70zy3Wbo4NvRsfUqjYUL5KOVFStlFXrQWOewfJIdM6UP0bl70wWA5?=
 =?us-ascii?Q?pcxKWlf8gacI8LexqG/dosveXHGWze/oFCxjQUhpKQR6iJTDmAyMQIJT+7WD?=
 =?us-ascii?Q?fweTMxWPBZ6nyQ/JiQmWSWzGQXu/hVk=3D?=
X-Exchange-RoutingPolicyChecked:
	TngyVCeURyTcP7ZCzApixlMJAnPhqZGBd3TTZLDfp8ybrqCEpaU33rQCy/Jdcrvo7Fmhw55whWa32A+hWA3ONwWg2mhq0Q0DhJpWhIpl9kZLevk50Ko/iVRgngeYddE+kYiMawZTZVjVB/OXrbPn6rBBBNYXk9unJdflplqOKfz5zyaMZqpOGeBmbNGw7jHeLL9W/UWjCY820IMOfia9v4CKUDcFu2C7Z6eIlA9W4FcFqUp0tKLcrsTNXoWgUWq4sCMgz19J3p1sIp5Vtsy3z1PDhTPNexfmgZ3F+Fa45WV0EMwpwmwhQFFaWxu9ooC3UlW+xF4D/c2hdYYXWBZikA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca6e6c1-6f3b-4b4e-c14c-08dec2de7dcf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 08:43:18.3580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23u6NSNnHaXBKXElSj2PvxN2hFHdxJMsEQjwoQu6cVwynRXzn7syYYOeveTIDwsNhvcTEEEz2h0+y08UzY7u6Z/6XlTZxyy5JpV0zVbz+yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10630
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA4MyBTYWx0ZWRfX6Knzagf4xiI6
 p9am5ZCD92siu7OQgeuqXnM41aqA+o477I84gWKSlBhAMPdyeLkLhKQIJYqBDeZPwro0GQM+CnZ
 0g9wD87frNqWTtX37iTQCgbhmHUFBVYHit4uFRBcO1VCzqPrMedSvx6I+GjpZYTQCktHBqOhgZx
 NiUfDE3KwurzAoqOQmd3zcGw8sWHvCIU27cwZTPrFX3P8F8n9IBQKVddiF0gKfrxBMx7Cp2rZG5
 KT2vSOSYc6lnzNwp2j/BUuPJGjr9rTd2rYuVTb0ysO8MXHWLJVe0J0NbF3jZq25zvFy+hz5tpW0
 ryDJPv38jpuoDg45k/ESOQvB5AHMqCt8C9wAdkxLt8Yas2s7LAQXySVxAARhiEUifXaJSWp1frn
 5eTsLfupmGJWvd/4vDCHS4kS1s5FUdZP1sj2hw5vip2ALk9fNR5dzd+4+zUCg2xDdvK7yDwTCpU
 SrLWlDbpSQXRHM7rA6w==
X-Proofpoint-ORIG-GUID: q8Cbvoq9gLG9GSawnhxLIlOdCbtK3YQW
X-Authority-Analysis: v=2.4 cv=V6FNF+ni c=1 sm=1 tr=0 ts=6a228c2d cx=c_pps
 a=h3Jk+6XEKCuoUZR+ZnWw9Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=AeifMptQDfo4Ryfwx0QA:9
X-Proofpoint-GUID: q8Cbvoq9gLG9GSawnhxLIlOdCbtK3YQW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Now, report blocker for named cpu models in query-cpu-definitions.
Heavy handling is done by validating the realized ID registers values
against the host values. sveNNNN needs special handling as those
are not stored in any ID registers.

Introduces arm_cpu_class_check_missing_features() and
arm_idregs_get_blocker() to achieve this.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 target/arm/arm-cpu-models-stub.c |  5 ++++
 target/arm/arm-cpu-models.c      | 34 ++++++++++++++++++++++
 target/arm/arm-cpu-models.h      |  2 ++
 target/arm/arm-qmp-cmds.c        | 12 ++++++++
 target/arm/cpu-idregs.c          | 48 ++++++++++++++++++++++++++++++++
 target/arm/cpu-idregs.h          |  3 ++
 6 files changed, 104 insertions(+)

diff --git a/target/arm/arm-cpu-models-stub.c b/target/arm/arm-cpu-models-stub.c
index 0481f0f946..dadd3b7647 100644
--- a/target/arm/arm-cpu-models-stub.c
+++ b/target/arm/arm-cpu-models-stub.c
@@ -11,3 +11,8 @@ const ArmNamedCpuModel *arm_find_model(const char *name)
 {
     return NULL;
 }
+
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    return;
+}
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 8a725a0c26..3eafa0efc5 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -517,6 +517,40 @@ static void arm_named_cpu_initfn(Object *obj)
     arm_realize_model_chain(obj, model, &error_abort);
 }
 
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers)
+{
+    Error *err = NULL;
+    Object *obj = object_new_with_class(OBJECT_CLASS(acc));
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    if (!kvm_enabled() || !arm_find_model(acc->info->name)) {
+        goto out;
+    }
+
+    if (cpu_isar_feature(aa64_sve, cpu)) {
+        arm_cpu_sve_finalize(cpu, &err);
+        if (err) {
+            error_free(err);
+            uint32_t host_vq_map = cpu->sve_vq.supported;
+            uint32_t model_vq_map = cpu->sve_vq.map;
+
+            if ((model_vq_map & host_vq_map) != model_vq_map) {
+                for (int vq = 1; vq <= ARM_MAX_VQ; vq++) {
+                    uint32_t vq_bit = (1 << (vq - 1));
+                    if ((model_vq_map & vq_bit) && !(host_vq_map & vq_bit)) {
+                        QAPI_LIST_PREPEND(*blockers,
+                            g_strdup_printf("sve%d", vq * 128));
+                    }
+                }
+            }
+        }
+    }
+
+    arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+out:
+    object_unref(obj);
+}
+
 void arm_register_named_cpu_models(void)
 {
     size_t i;
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
index 3d4d805da8..2c2038722e 100644
--- a/target/arm/arm-cpu-models.h
+++ b/target/arm/arm-cpu-models.h
@@ -42,6 +42,8 @@ void arm_register_named_cpu_models(void);
 const ArmNamedCpuModel *arm_find_model(const char *name);
 const ArmModelPropValue *arm_cpu_get_composite_subprop(ARMCPU *cpu, const char *comp);
 
+void arm_cpu_class_check_missing_features(ARMCPUClass *acc, strList **blockers);
+
 void arm_apply_model_prop(Object *obj, const ArmModelPropValue *prop, Error **errp);
 
 #endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 9bdf85885f..9b7eea7fea 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -326,6 +326,18 @@ static void arm_cpu_add_definition(gpointer data, gpointer user_data)
     info->name = cpu_model_from_type(typename);
     info->q_typename = g_strdup(typename);
 
+    /* calcualte blockers */
+    if (kvm_enabled()
+            && !g_str_equal(info->name, "host")
+            && !g_str_equal(info->name, "max")
+            && arm_find_model(info->name) != NULL) {
+        arm_cpu_class_check_missing_features(ARM_CPU_CLASS(oc),
+                                    &info->unavailable_features);
+        if (info->unavailable_features) {
+            info->has_unavailable_features = true;
+        }
+    }
+
     QAPI_LIST_PREPEND(*cpu_list, info);
 }
 
diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
index 1ec1a38866..3e69edf9cc 100644
--- a/target/arm/cpu-idregs.c
+++ b/target/arm/cpu-idregs.c
@@ -458,3 +458,51 @@ char *arm_field_supported_numeric_range(ArmFieldIdx field,
         return g_strdup_printf("%" PRIu64, host_val);
     }
 }
+
+void arm_idregs_get_blockers(ARMCPU *cpu,
+                             const ARMISARegisters *host_isar,
+                             strList **blockers)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        const ArmIdReg *reg = &arm_idregs[i];
+        if (!reg->name) {
+            continue;
+        }
+
+        for (uint32_t j = 0; j < reg->fields_count; j++) {
+            const ArmIdRegField *f = &reg->fields[j];
+            uint64_t model_val, host_val;
+
+            arm_idreg_field_read(&cpu->isar, f->idx, &model_val);
+            arm_idreg_field_read(host_isar, f->idx, &host_val);
+
+            if (!arm_field_is_writable(f->idx)
+                && !arm_field_skip_writeback_always(f->idx)
+                && !arm_field_skip_writeback_if_not_writable(f->idx)
+                && model_val != host_val
+                && !(arm_field_supports_off_via_vcpu_flags(f->idx)
+                     && model_val == 0)) {
+                const ArmCpuPropDesc *prop = arm_prop_for_field(f->idx);
+                if (prop) {
+                    QAPI_LIST_PREPEND(*blockers, g_strdup(prop->name));
+                } else {
+                    QAPI_LIST_PREPEND(*blockers,
+                        g_strdup_printf("idreg_%s_%s", reg->name, f->name));
+                }
+                continue;
+            }
+
+            if (arm_field_is_writable(f->idx)
+                && !arm_field_check_val_safe(f->idx, model_val, host_isar)
+                && !arm_field_skip_writeback_always(f->idx)) {
+                const ArmCpuPropDesc *prop = arm_prop_for_field(f->idx);
+                if (prop) {
+                    QAPI_LIST_PREPEND(*blockers, g_strdup(prop->name));
+                } else {
+                    QAPI_LIST_PREPEND(*blockers,
+                        g_strdup_printf("idreg_%s_%s", reg->name, f->name));
+                }
+            }
+        }
+    }
+}
diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index 171e03eece..c4f039f690 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -111,5 +111,8 @@ void arm_field_foreach_supported_arch_val(ArmFieldIdx field,
            ArmFieldValVisitor fn, void *opaque);
 char *arm_field_supported_numeric_range(ArmFieldIdx field,
            const ARMISARegisters *host_isar);
+void arm_idregs_get_blockers(ARMCPU *cpu,
+                             const ARMISARegisters *host_isar,
+                             strList **blockers);
 
 #endif /* CPU_IDREGS_H */
-- 
2.52.0

