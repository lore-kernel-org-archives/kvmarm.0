Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5334334AA
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 09:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141667; cv=fail; b=RQdBSO0+oNaE++lsFVdr/4E+9vVj76FkclMZQCnMSU3UisM/aAhjs7QNtM2AXssIRMgDoGXbhFibOFUTuLq71woEUBpxnxYfQagbiQLBz4/pQ0U0Ht5Jj4EURuD4Ltl6UHZRQMCiqbreEkFXZWEAUOW1R1WDTIopV7MAXhqn7DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141667; c=relaxed/simple;
	bh=k2nDElEQIH9RfIA/pnfX+JnTvP6MzMkw9WA5UCdPizM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vCcHTk16eOaFgGDSkxg7M2RVRB/Y74fwTXL/X0mgjD0tAayRlYZNuCN1WCwnPJ2bMiFZZG66rAY6iuhk0KOvvDYehXxVl3YqHYwQryH3w4YyVdzo3FqMRaHzk5ooH7ozRMe4bRkb5doOvscVHTvDQ/MT0Uc9h4N35V69M9FG0PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=1+l1nh7n; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cN/8g85k; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="1+l1nh7n";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cN/8g85k"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FMbjmq4145080;
	Fri, 16 Oct 2026 02:07:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=k2nDElEQIH9RfIA/pnfX+JnTvP6MzMkw9WA5UCdPi
	zM=; b=1+l1nh7niAA0fnDtpwuHTKAQjCYw6KrQLRFu4C9WjH7LxGT7xbJmBPKvv
	L90dxGTKAUzHXRi8lZ6EQ5nFFhGxS+FrkCTMJpJRGFRdBqU0Hj8SY/VPc5ckfzXU
	6f3KimcekOSiTQFmfN60D79MkHtxlOV+RxHuXokUnnNNlzA2dY+mR5wkeAFPmEq2
	6X3jl+I6o3QgMB3wshcm+9EEQZ3HYWjzHdhJ6wYlyGtObg7qGuvbsVi6VYN78tLU
	jf9CEQaBsGE31ABbzghBWIN5e2kXlOv8fVU4Dp/fI7cuPPEDx/+N4XCSYeT+gBVK
	smpwtZ2mFg36abwesxQtQVs3bE5KQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020143.outbound.protection.outlook.com [52.101.46.143])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4haysxtdjy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 02:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S4B44A980W8/d8IaQvWqzgeYKPSkNmnRlF1WFJ9rYoaPa+B/3N4Z4J8x0eoVLZF3b8BlLExoehdgks+yGKo6oEq4qjZUXrysEhIT6+8/qzBZm9hrVM0VAfcR8xS6NNApgMpQMql8eok9dMWnB7o0HwX62jwxSUH3ukk4IPAefTn2DSESPgOOLCaYJRYb49mv3vFg7rltr8D05lj0o8MGDT9/i5DXRZ1e3oQe/eOBHmRcd53acb9rfz5mnwOBC8iAjpo0vJy0OB8HT1SiLiMKZOq3CsFHn8NkeeygcztqbNm6W+y8Ht/0i71Oj32IJwjuT1kYW2m8k+LdU3KoRMwZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2nDElEQIH9RfIA/pnfX+JnTvP6MzMkw9WA5UCdPizM=;
 b=Le1OsVZTlxWBWnBsIJRZ7drK+fK5RRHjjU57+m7ZaSPI1G4oHg41JesDKLedpvVRC3QsX37K3+HsuCLzCl4bKi6FJRBVxOnY58PdznZfDK0MKTLcw8nY8qaFhw88hxEl0iIlsPoQfuMLBI5Fz7VIy2jbyCOuFPncBiXbRnNpRPlh3x/VxvN8FA5OzCEtBdJG2yNbrdwGO8c436K6BCiqjroqCvSEdu2i/tlLuWjM2fSi1wSDFgMRfXJ0qOpVMMwQH1jZ8V8QaUVVbMaJunnsyRAjkOePNOMtjCHV3onKFdOkHNOJrx5UOMmd3cAcUynqFTh97afTGZwY5Wpj4MWd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2nDElEQIH9RfIA/pnfX+JnTvP6MzMkw9WA5UCdPizM=;
 b=cN/8g85k4JZYyhadQ9/3wHKW843yLni1is3ELhkpglBjqnMuXzglXrt/IY3eQC2XOebUGGGplcz3EVaRnZdnY1IS1338a7BZzHyr0pHDVI+XQUJFL7nAc0wXEN5lDJvSeDQwz/vlBZj7rL5CO5glhPjyHPc+poJQpX67mw/Ec/VVnLKOI3UvvqEyG5VtAtJ6rUZcimSf2qkghQAx+CFUSkfylzS4IEm7T4ef6qAezM/Nnsrs6554HQWwBsgQhMqVcSQJCCvSTkoVPZsR1DFwN4Y2Vcjdg8E+9dopLM++WsJvnk9V8jN5sCmshYXOTTmUe2vzD/TktFVRPleewtAmOg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by LV3PR02MB10235.namprd02.prod.outlook.com (2603:10b6:408:21e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 09:07:38 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 09:07:38 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "oupton@kernel.org"
	<oupton@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Mark
 Cave-Ayland <mark.caveayland@nutanix.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sandesh Patel <sandesh.patel@nutanix.com>
Subject: Re: [RFC] Exposing arm64 ID-register safe_rules semantics to
 userspace?
Thread-Topic: [RFC] Exposing arm64 ID-register safe_rules semantics to
 userspace?
Thread-Index: AQHc9ys4Pfmi3ncHT06ezHa+2K+t47Y0gGsAgAAmgQCAAAtGgIDL+v+A
Date: Fri, 16 Oct 2026 09:07:37 +0000
Message-ID: <27B87634-9720-438E-8153-1918E6515230@nutanix.com>
References: <B5C9AE36-8181-4A76-905F-3E89B7200215@nutanix.com>
 <86se6xthih.wl-maz@kernel.org>
 <E58B3007-0BB1-460F-9225-707FCF811B04@nutanix.com>
 <86pl21t99k.wl-maz@kernel.org>
In-Reply-To: <86pl21t99k.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|LV3PR02MB10235:EE_
x-ms-office365-filtering-correlation-id: c053979d-0027-4bc6-0af0-08df2b64ecd4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|56012099006|4143699003|5023799004|10067099003|22082099003|6133799003|18002099003;
x-microsoft-antispam-message-info:
 ByhHoHGQM/5/bPYz8bkFfZ4ILoaFOD5KygnSPtczn3f5qrmgVOIxoE+IahJpMCIVaOqppUiFifZpIirWZ6mTvtKNmIP/wuwA8X3wCnY+jOFJ0lgH4yJzGnCmeJ44a3vi+P1HCJxBiUYNmU6xeBGgxbLRgQn/zGbh8vbx3Rf2zQAkTAnT0gOHJnqjK/JRNMVsJcyfsncxzNfQ/s+Y9qlaQ1pdydGm00Qcbl1bmWFLwHJLImyCRJhswrXQrP4aM8Gz5oawxzCBa2xn/VY0Zer5Gb3CUSNooIKXq3ax6KzlzbpMHkVwB7niojI0cLummqFICi9YLZJ+fPbdZTNSLKcS4ClWz1GX/lpHlqvx5UyLY/vzsS5oSzZi1ymxfCmdoUEoWwtzssKGd59FvP17qjU9AFuHiy8dhIcykIsyog3VIro/JoJOZgFACHOtC4wsDc3TXchu4FBZZ7ZWqjxySqHp/5jklqP/D8dhzK8TpXl1hcTUqZk2zfyrxsiTLi6hM4pyKwDOZv6T7BIPntr+W5gsFqj9myd3I6B5kJ1b7yRD6yVCUiCIDPVAuN/g+txjwKSW5FyDsrkh8z78txHv3eB35rTr6h31SjY/rsshFMEJ+RqL0pgfFn2NMDCOhn/8AKLrh7gt8BTiSVusuWANZ2d9zgfFPrn78tu57dO3ZRo8qNxQvDVfe0fFr8KpKBjlm76saWgtoyYTaJIKH6+yt4Lga0t7XBcJ1DKfvA2Es8t6YDo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(56012099006)(4143699003)(5023799004)(10067099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V0g2Zld6bkFHR1B0eFlOYi94WnNxM0lnc2w4bHk5MEJKTzhSazFqQzZwYmdI?=
 =?utf-8?B?aDNjRFZtd3dpK200RFd1ZXQvdTBSRDRWM3BkdVUwL2cyVHRCWkY0TUxsN2w5?=
 =?utf-8?B?T25kWG1NKzRhNGd2MVpTa2EwR0lHWWN1RmMwVlhlS2FaQnFEa3FpREVJaG5P?=
 =?utf-8?B?UDQzWXMrOG84eG9IZWtPTEl4NGZ1VUw2UFpsS3NFMG82RDNlNnQvdVlrY0dS?=
 =?utf-8?B?V0luQVVpZkN4eFlhakRSbzZJS0VBamwyUGNhSWUzVk1PRnVhZGtSZm1Yenk5?=
 =?utf-8?B?dEU3VFVMc0dqNE9NQTJiRXlWbkFBcktaM0ErcWsxYUNOQlVTN0ttQU16Y1RJ?=
 =?utf-8?B?SHpPTDRCNk9lalpOYk0rRXZkY3RIeWFSMGdyUWQ0MHJaZC9IUE5Uc2dhdmc1?=
 =?utf-8?B?UFJoa3R0Rk1QNkh3dVBPWVhOL2dNeEJ0ZlU0VG5sdHVleEQ5YW8xbEFSaEpV?=
 =?utf-8?B?V3dDTkc3bWgyTG9zaGlYNUtNcEYrK2tXM1VxVSt3ZFBSbGdOMjRLaWljMHRh?=
 =?utf-8?B?dTBFSnE1eW9pdDZNU2JBa0lmWEg3VmNmZDF5V1AzRnJ2MWVRWGVTaGtwU1VF?=
 =?utf-8?B?NnlwcmxsNXBJZ2U2NnptQkx6NlJZVGJQQXlqajJxQzYrbHNJRHM4YjIyRWZH?=
 =?utf-8?B?ajNmeC9GZk1VeEYrcmJWOWVhZnRHOW1nbmpMempqZzNtMUptZWllaVdWSXpF?=
 =?utf-8?B?Q2htcVFvMTVTaHhoK3ZVaGRnd2Vwc2pteUJZR1JMUk5VeFFJSVNqN3gxeGhB?=
 =?utf-8?B?VGZKYi9XaFRhSHlwSzloaUJjb3k2WHczcXI3OVVrNmdSU0lHVkhNbXUwTDhP?=
 =?utf-8?B?TlpicHNzbGdVU3RiYnpoRzdoNzM5cGhhQ0dQSDRhaTBjcENzTExVZzgwemgr?=
 =?utf-8?B?YWozMGtuQ3NsbldId05ZbXZDNGZWYWVBdU5weTlpK0xrNmRHdHBIZWVUZGp2?=
 =?utf-8?B?WUJ1eGVMTzJlTmZqcytjQysvK01JWmswblhPQ3pEUVE5QXpSdVRReEhiVlZ4?=
 =?utf-8?B?N0U1dWprRmV0UklVUmpyWlhIN3piTFJvd3IvWWI0U3pQcm9uL21Od0FVSTdH?=
 =?utf-8?B?Q1Y4N2lYbWFyMlpxdGpWMnUzQTZNMk1oWFRTRmhJOGJHSk15Ly9xVUhqYU1x?=
 =?utf-8?B?b0NuWHRjcllpczRJdjJScklhS0R6TnlEVGl6ZlVVSkYxdmdES3VUTE5NY1Bl?=
 =?utf-8?B?SFMrVEY4UncyUmRQQXB3YldFRjd1Q3BsYW8rd3VBS2RXcG0rbVVPRXR2VDEx?=
 =?utf-8?B?MnRKZEJGd0FNZFV6blR5MlhtQTZ4aHdzajVwelBJSnM2Zzc0MWc2enZvdmsz?=
 =?utf-8?B?OXNTYVZ5RlQ4b0NQNEc1S3JodG1RcW13UGZ6RDV1WlhldFNFbjJTTm1CRVli?=
 =?utf-8?B?dXE3Y0wwV2FjbHptTEx3NjdWTmdCc1JFZ0NQZjJEQnJ4TndFY0k2YTJZWnFT?=
 =?utf-8?B?TVBYWVQ3aWdBR2xOSlF6Z1Q0VVg1U2VJQUV2eXBrc2RuOHBvWWxwYWpHN2VR?=
 =?utf-8?B?V283am5KM1dDQ2pGQk9NZ1lVL2w1TUJ6dS9yODB5TDcrQVFkZk5DMDZOeFh0?=
 =?utf-8?B?N09ycEthTlFnVEpsYzNIcWhMWkM3QnVYUEUwUUwyWmFXeHlUd0FIOWtlWHp0?=
 =?utf-8?B?ZFJVNG9wV3lOVDQ1OSsxT3JpL05oeFBxQlg2LzZPNENJblhUKzZ1aFRyZmhh?=
 =?utf-8?B?cjdOckg0ZFBtaGxQVmhxTCtoRmpWOTdLNmdZTWRpL21sWXRyUTdIdVgwdFZq?=
 =?utf-8?B?cldYUVNpZmZxSEFPbjh5N2EwRW02VzgzUm9zTGdMdGhFQlFwYWdoZHM2UENW?=
 =?utf-8?B?ZXZ0OCtrMGNVT0d2TGhSMnVYZzB4QXpDWms2eUVwelI2Ymc3elltUUNSNlhn?=
 =?utf-8?B?VFRweEJXRGtLYkZIa0lJalROd2tzbVpjRXBVdnBHMThJNHhDcDF5SHdGQkU1?=
 =?utf-8?B?QTNLbW11aGg2SzBFTldLTlI5MUpHN0xnaXBrTGhoU3V6cWZRWEQyaDR3VEpi?=
 =?utf-8?B?YUhvejgzWW82ZDdBL2xnQWlyMnFBY1NvSXp0bGo3REZSY2FHekdjcUQ2ZERU?=
 =?utf-8?B?TXhYU3J0bldpdUJuWjk3Si9relRhY3Z5UFd1RTV0cm9PK044eFlaS0o0T1Bh?=
 =?utf-8?B?RlhGSDYzdDBsZ0EwV3BydGNwcHVIQmtaRENTTENrY1kzcWp4YkZTNWRiYlNj?=
 =?utf-8?B?VkRoejNDazQ2WUZVY3F0d0hhUFRMMmpaYjlkc3hDMkQ4OVBjSG5BdGMybXYz?=
 =?utf-8?B?dUhuN3RGV0FHeHViK2tvMlRhUUhXUG5qVUJPZlFtMCt6QjcyKzVReVAvS05k?=
 =?utf-8?B?b3lXMmVJQjhTVGJaQWYxREFISlM5MVdnOC90SVA4ZGtSdEpybkFLRG5wbFFm?=
 =?utf-8?Q?op3mrLo+V1Tp/DnI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2B06EE6B9C946469E6F90F8C2EEE250@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	zrs5fmR5O4Ytw0UP3b0HMSI1hpUXbGS+TSIZpdraQNCB3SUvsW7Q0buqSzI79iTC3fGIzWJLSHQOS00Pka/sr55lTPTmARu5maWC62HLQ4VmyCYsU9tFZXp55+2xJpx41bMxi5YPbQBiyITAwGzIVhBNzcM3ZThzqKUozj9LIyuYvkFYJAAsl45AJQa481cvdD8n7Kq8nYQGr5C8MsW5L4qbpuUVLL5q0H1ma0tzNKfi70O91oPvKeZ9sXT/t6Qgn0DgdyioBnIap+XckIHeokj7BV/uskXkHNjYF7CCUpWLKQmo1mgdTh2ATSdsrPfBfAeNiPs2S0iirm7Vthqwhg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c053979d-0027-4bc6-0af0-08df2b64ecd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 09:07:37.9511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KRUVK6udRLQvOyri4Jkj39bVtq9cCFBlDiwK2uEmnVhc0Wqn84Qi6cxl6DH8/sasYUPiAVYBU1QrZKlqacrwH7WPQXfvadNdOaUHtIVjR6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10235
X-Proofpoint-GUID: SPe8maSAMRclnHcwzmb5n6QlM0HxkGdF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAzNiBTYWx0ZWRfXyHiiAoJ1A5/F
 pFxq0aEIyOjGk+9tbx8doi5BiAqHzVesTKQq/+0keVakhJaI08b+3udadmhFoLFNYGRbBYKkRu5
 Jp2mIl7mJ63HZZOv1q1A1dFsnejqCH66krs15Q+ioHLw3EYGKBjHPycs12s79yldFaaW/gSij15
 BKt26/sB1K2nKP1dEcdd4BKzBgJ4SqkHmIkv9dX3+/YZ8f5y5s1hQpvrQ95R26Y9R+y3pj5B30q
 ktZX/2r6ZAmCSz5z2Lc5fHUMafeZLayDSbgc6YwLG+7HnHXr+9KBnmCbo3paSRzYfIEzwAl1Q+L
 UT/ZUWGSMu8E11pmFOTq/HbeLgYVUxBKpYgYwzX0jfhCiZGAW9vcK5TtYFYU1+JHb9whFmtYUCp
 tMVZ2BfcgFSGIxu2gcSVm0CLpf4n+HDwUFNHykrPE4kFQ8symiyCUFS/H8IcifBv4qZxVVCOg4p
 DBTM523L5punm6Gbcpw==
X-Proofpoint-ORIG-GUID: SPe8maSAMRclnHcwzmb5n6QlM0HxkGdF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAzNiBTYWx0ZWRfX5XAsx0md4tx5
 YmyZlIDXmPPq7gYscWHEt7p4rTPs/omXP8mGhodlxZsBjUyXeMsw1eKt4yc4MLrltJoZSIFrNAA
 F0gWM52ijGd7ulYiZNNkBTRA4WnVUTs=
X-Authority-Analysis: v=2.4 cv=C/x8WgP+ c=1 sm=1 tr=0 ts=6ad1e95d cx=c_pps
 a=XSy6xVanZX0hR9uvxkBJyg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=VwQbUJbxAAAA:8
 a=64Cc0HZtAAAA:8 a=DEtyqtdQINJn1iMDQkQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gOCBKdW4gMjAyNiwgYXQgNzozOOKAr1BNLCBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgMDggSnVuIDIwMjYgMTQ6Mjg6MTMgKzAxMDAs
DQo+IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPiB3cm90ZToNCj4+PiBP
biA4IEp1biAyMDI2LCBhdCA0OjQw4oCvUE0sIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4+IA0KPj4+IE15IHF1ZXN0aW9uIGFib3ZlIHN0aWxsIHN0YW5kczogd2h5IGlz
bid0IGtub3dpbmcgdGhhdCBhIGZpZWxkIGlzDQo+Pj4gd3JpdGFibGUgb3Igbm90LCB0b2dldGhl
ciB3aXRoIHRoZSBtYXggdmFsdWUgb2YgdGhhdCBmaWVsZCwgZW5vdWdoIHRvDQo+Pj4gZGVjaWRl
IHdoYXQgaXMgcG9zc2libGUgdG8gYmUgc2V0IGZvciB0aGF0IGZpZWxkPw0KPj4gDQo+PiBPa2F5
LCBtYWtlcyBzZW5zZSwgdGhlcmUgYXJlIDU3IGZpZWxkcyBpbiBjcHVmZWF0dXJlcy5jIHRoYXQg
YXJlIG5vdA0KPj4gdW5zaWduZWQgRlRSX0xPV0VSX1NBRkUuIA0KPj4gDQo+PiBSaWdodCBub3cs
IG9ubHkgMjEgb2YgdGhvc2UgYXJlIHdyaXRhYmxlLiA4IG9mIHRob3NlIGFyZSBzaW5nbGUgYml0
LA0KPj4gd2l0aCBGVFJfRVhBQ1QgYW5kIHNhZmVfdmFsdWUgYXMgMCwgc28gbm8gc3BlY2lhbCBj
YXNlIGZvciB0aGVtLg0KPj4gDQo+PiBTbywgb25seSBzcGVjaWFsIGhhbmRsaW5nIGZvciAxMyBm
aWVsZHMgYXJlIG5lZWRlZCBmb3Igbm93Og0KPj4gDQo+PiBFWEFDVDogNCAoVEdSQU4qXzIsIEwx
SXApDQo+PiBTSUdORURfTE9XRVJfU0FGRTogNyAoVEdSQU40LCBUR1JBTjY0LCBJbm5lclNociwg
T3V0ZXJTaHIsIERvdWJsZUxvY2ssIFBNVVZlciwgUGVyZk1vbikNCj4+IEhJR0hFUl9TQUZFOiAy
IChTcGVjU0VJKQ0KPj4gDQo+PiBIYXJkY29kaW5nIHRoZXNlIDEzIHdvcmtzIGZvciB0b2RheeKA
mXMga2VybmVsLiBCdXQgd2hlbiBuZXcgZmllbGRzIGFyZSBtYWRlDQo+PiB3cml0YWJsZSBvciBh
cmUgYWRkZWQgdG8gZnRyX2JpdHMsIG9sZGVyIFZNTSB3aWxsIGJ5IGRlZmF1bHQgbWFrZSBhc3N1
bXB0aW9uDQo+PiBvZiB0aGVtIGFzIExPV0VSX1NBRkUsIHdoaWNoIG1pZ2h0IGJlIHdyb25nLg0K
PiANCj4gSGFyZGNvZGluZyAqYW55dGhpbmcqIGZlZWxzIHZlcnkgd3JvbmcuIEVhY2ggb2YgdGhl
c2UgZmVhdHVyZXMgaXMNCj4gaGFuZGxlZCBkaWZmZXJlbnRseSBmb3IgYSBudW1iZXIgb2YgcmVh
c29ucyB0aGF0IGFyZSByZWxhdGVkIHRvIHRoZQ0KPiBhcmNoaXRlY3R1cmUgaXRzZWxmIGFuZCB0
aGUgd2F5IHRoZSBrZXJuZWwgaXMgdXNpbmcgaXQgKmZvciBpdHNlbGYqLg0KPiBUaGlzIGluZm9y
bWF0aW9uIGlzIG5vdCBzdXBwb3NlZCB0byBiZSBjb25zdW1lZCBieSB1c2Vyc3BhY2UsIGFuZCBp
cw0KPiBub3QgZXhwb3NlZCB0byBpdC4NCj4gDQo+IFRoZSBwcm9ibGVtIHlvdSBzZWVtIHRvIGhh
dmUgaGVyZSBpcyB0aGF0IHlvdSB3YW50IHRvIGRlYWwgd2l0aCB0aGVzZQ0KPiBmZWF0dXJlcyB3
aXRob3V0IGNhcHR1cmluZyBhbnkgdW5kZXJzdGFuZGluZyBvZiB3aGF0IHRoZXNlIGFjdHVhbGx5
DQo+IG1lYW4gaW4gdGhlIGNvbnRleHQgb2YgdGhlIGFyY2hpdGVjdHVyZS4gSSBjYW4ndCBzZWUg
YSBnb29kIG91dGNvbWUgb2YNCj4gdGhhdCBzb3J0IG9mIHRoaW5nIGluIHRoZSBsb25nIHJ1bi4g
VGhlIFZNTSBpcywgZm9yIGJldHRlciBvciB3b3JzZSwNCj4gcGFydCBvZiB0aGUgb3ZlcmFsbCBo
eXBlcnZpc29yLiBJdCBjYW5ub3QgdHJlYXQgdGhlIGZlYXR1cmVzIGFzIGEgYmFnDQo+IG9mIGJp
dHMuDQo+IFRoaXMgaXMgYWxzbyB3aHkgdGhlIHdob2xlICJDUFUgbW9kZWwiIHRoaW5nIGlzIElN
TyBhIGJhZCBpZGVhOiBpdCBpcw0KPiBzeW50YWN0aWMgc3VnYXIgdGhhdCBmYWxscyBhdCB0aGUg
Zmlyc3QgaHVyZGxlLCBzaW1wbHkgYmVjYXVzZSB0aGUNCj4gYXJjaGl0ZWN0dXJlIGlzIG5vdCBm
dWxseSB2aXJ0dWFsaXNhYmxlLiBGb3IgZXhhbXBsZSB5b3UgY2FuJ3QgdGFrZSBhDQo+IE5lb3Zl
cnNlIFYyIGRlc2NyaXB0aW9uIGFuZCBhcHBseSBpdCB0byBhIEtWTSBndWVzdCBydW5uaW5nIG9u
IFYyIEhXLg0KDQpIaSBNYXJjLA0KDQpJIHRha2UgeW91ciBwb2ludCB0aGF0IGEgbmFtZWQgbW9k
ZWwgY2Fubm90IGJlIGEgZmFpdGhmdWwgTmVvdmVyc2UgVjINCihvciBhbnkgb3RoZXIpIFRSTSB2
aWV3OiBldmVuIG9uIFYyIGhhcmR3YXJlLCBhIEtWTSBndWVzdCBvbmx5IGdldHMNCnRoZSBzdWJz
ZXQgdGhhdCB0aGUgYXJjaGl0ZWN0dXJlIGFuZCBLVk0gY2FuIGFjdHVhbGx5IHZpcnR1YWxpc2Uu
IFdlDQphcmUgbm90IHRyeWluZyB0byBwcmVzZW50IGEgVFJNLWFjY3VyYXRlIE5lb3ZlcnNlIFYy
IHRvIHRoZSBndWVzdC4NCg0KV2hhdCB3ZSBhcmUgYWZ0ZXIgaXMgYSBtaWdyYXRpb24gQUJJOiBh
IGZpeGVkIGd1ZXN0LXZpc2libGUgSUQgcmVnaXN0ZXINCmNvbnRyYWN0IHRoYXQgc3RheXMgaWRl
bnRpY2FsIGFjcm9zcyBhbGwgaG9zdHMgY2FwYWJsZSBvZiBydW5uaW5nIGl0Lg0KDQpJbiBteSBy
ZXNlYXJjaCBzbyBmYXIsIEkgaGF2ZSBpZGVudGlmaWVkIHRoZSBmb2xsb3dpbmcgcGl0ZmFsbHMg
d2l0aA0KdGhpcyBhcHByb2FjaDoNCg0KLSBHdWVzdCBlcnJhdGE6IGVycmF0YSBoYW5kbGluZyBp
biB0aGUgZ3Vlc3QgaXMgZHJpdmVuIGJ5IE1JRFIvUkVWSURSLA0KICBzbyBpZiB0aG9zZSBkbyBu
b3QgbWF0Y2ggdGhlIHJlYWwgaG9zdCwgdGhlIGd1ZXN0IGNhbiBwaWNrIHRoZSB3cm9uZw0KICB3
b3JrYXJvdW5kcyBvciBza2lwIG5lZWRlZCBvbmVzLg0KDQogIFNoYW1lZXIncyBlcnJhdGEtbWFu
YWdlbWVudCB3b3JrLCB3aGVyZSB0aGUgVk1NIGdpdmVzIHRoZSBndWVzdCB0aGUNCiAgbGlzdCBv
ZiB0YXJnZXQgaW1wbGVtZW50YXRpb25zIGNvdWxkIGFkZHJlc3MgdGhpcy4NCg0KLSBQTVU6IGV2
ZW50cyBhbmQgY291bnRlcnMgYXJlIGNvcmUtc3BlY2lmaWMsIHNvIHRoZXkgY2Fubm90IGJlDQog
IHN1cHBvcnRlZCByZWxpYWJseSBhY3Jvc3MgaGV0ZXJvZ2VuZW91cyBob3N0cy4NCg0KICBXZSBj
dXJyZW50bHkgbGVhdmUgUE1VIG91dCBvZiBuYW1lZCBtb2RlbHMgZm9yIHRoYXQgcmVhc29uLg0K
DQotIElNUC1ERUYgcmVnaXN0ZXJzOiBBQ1RMUl9FTDEsIEFNQUlSX0VMMSBhbmQgQUZTUjAvMV9F
TDEgYXJlIHRoZQ0KICB0cmlja2llc3QgaW4gcHJpbmNpcGxlLiBBIG5hbWVkIG1vZGVsIHNob3Vs
ZCBvbmx5IGJlIGFsbG93ZWQgdG8gYm9vdA0KICBvbiBob3N0cyB3aGVyZSB0aGVzZSByZWdpc3Rl
cnMgaGF2ZSB0aGUgc2FtZSBzZW1hbnRpY3MgYXMgb24gdGhlDQogIGltcGxlbWVudGF0aW9uIHRo
ZSBtb2RlbCdzIE1JRFIgZGVzY3JpYmVzLg0KDQogIFdvdWxkIGl0IG1ha2Ugc2Vuc2UgZm9yIEtW
TSB0byBtYWtlIHRoZW0gUkFaL1dJIGluc3RlYWQ/IEFGQUlVLCB0aGV5DQogIGFyZSByYXJlbHkg
dXNlZCBieSBndWVzdHM7IG1haW5saW5lIExpbnV4IGRvZXMgbm90IHRvdWNoIHRoZW0gYXQgYWxs
Lg0KDQpUaGF0IHNhaWQsIG9uIHRoZSBoYXJkd2FyZSBJIGN1cnJlbnRseSBoYXZlIGFjY2VzcyB0
byAoTmVvdmVyc2UgVjIgYW5kDQpOZW92ZXJzZSBWMyksIHRob3NlIElNUC1ERUYgcmVnaXN0ZXJz
IGFyZSBSRVMwIChhcyBwZXIgVFJNKS4gSSB3YXMgYWJsZQ0KdG8gbWlncmF0ZSBhIGd1ZXN0IGJl
dHdlZW4gVjIgYW5kIFYzIGhvc3RzIHVzaW5nIGEgIk5lb3ZlcnNlLVYyLWxpa2XigJ0NCm1vZGVs
ICh3aXRoIFBBdXRoIGRpc2FibGVkKSwgYW5kIGJldHdlZW4gdHdvIGRpZmZlcmVudCBWMiBTb0Nz
IHdpdGgNCmRpZmZlcmVudCBmZWF0dXJlIHNldHMuIEluIGJvdGggY2FzZXMsIHRoZSBndWVzdCdz
IElELXJlZ2lzdGVyIHZpZXcNCnN0YXllZCB1bmNoYW5nZWQgYWNyb3NzIHRoZSBtaWdyYXRpb24u
DQoNClRoaXMgcmVmbGVjdHMgd2hhdCBJIGhhdmUgZW5jb3VudGVyZWQgYW5kIHRlc3RlZCBzbyBm
YXIuIEdpdmVuIHlvdXINCmV4cGVyaWVuY2UsIGFyZSB0aGVyZSBvdGhlciBwYXJ0cyB0aGF0IEkg
YW0gb3Zlcmxvb2tpbmc/DQoNClRoYW5rcywNCktodXNoaXQNCg0KPiBJIHRoaW5rIHlvdSBuZWVk
IHRvIHJldmlzaXQgeW91ciBhcHByb2FjaCB0byB0aGlzIHN0dWZmLg0KPiANCj4gTS4NCj4gDQo+
IC0tIA0KPiBXaXRob3V0IGRldmlhdGlvbiBmcm9tIHRoZSBub3JtLCBwcm9ncmVzcyBpcyBub3Qg
cG9zc2libGUuDQoNCg0K
