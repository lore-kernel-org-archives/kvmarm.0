Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A8C3D9DB2
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779896701; cv=fail; b=E8MhCb4Tptfbfn/MQ+eOhFOzo9I2scXaKPMTCMvzj1UYoHvW1kPP4oGT9q6u98GGkv3McLZWiDRUe+/mEjl79OJMELi1fDqlHhm0LNSPLkA3NfQWx3w1uwMKRat9f3eoP+swPt0O3XVWUaC9+Dstu34c1rDeVLoZvNVvOSn7iFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779896701; c=relaxed/simple;
	bh=SQvRDzQENpCt+RMk9gm1C96RDQJIqhPxClqPKGCv2O4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lEoQQANO/dL8XVimUxXMm+Tr230HHbmJebkwiBYoArpGoRtVqN6g0elXAiXeghwizt1lkp3CcQLUY2aVD1K54+8RjlaanjZB9FsC2Oj3Hjsaj9s7DDY4hRIiRzpU26QVMVQ5Ex1q/V9HuauVuYi4MDOXhdDWl77WIBVgXuKEPRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zBRRe0SI; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SnIuzk9o; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zBRRe0SI";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SnIuzk9o"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCs6mw2641613;
	Wed, 27 May 2026 08:44:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SQvRDzQENpCt+RMk9gm1C96RDQJIqhPxClqPKGCv2
	O4=; b=zBRRe0SIlLDco12DWJw9R69s4h0sZbssTVcxIuOKUfHZokRpEDEjSgqSQ
	E28Tzu0VJvV29zewjalWWRc9jwuKcdoCcA3a7Tp+bKnNwK5QzrLRBbzbbefyw/vu
	vC8SaUHQTCi1/M+4jbaAZeqR9VcKlG2KROORw2Coq8A51MNV4unkXwIGOgiWfXpd
	OMhJKHIq/5pM9IOq8dVjiIRyMGhKv4E2SuFpGUS7hhx5USq1ln3ZQZFlmNBh367l
	SPKLAj8GM5zi5Txo1Hxu2HM4woD6oVKMI6e667ElRoPlE4danP7UMV2laamUQtsE
	f1ag740A1BDMZ/9C6KMpUuO9GweJQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021093.outbound.protection.outlook.com [52.101.57.93])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edkqt25ky-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+T5ZZN3e6oHRBibF6Fzii4Jfy7FHUVGYiynDt1mENfsMPLd4BQ/oR064NWqPzkHXJxGndPe6OTbt+x6y5zd/mD03YVi4o2R8C80YkMMn5TVn6Wz1XicpOHIEgzUgzws8W3gqObITaPbrdFhGFblze+gVvR4f6soYSLpkc457SnOQ103un6uV1g6Tc+0VfwTE9dLaOpykQ9ltELyr9wjwG7+Mng3LXDzqVEi8dC4x7U7xriW+jiYjCtnHeARiWshatJScL0f3vv3wMnq7O226n9baP8JkyskDsV7814DYZtD+2kx31KvCSR3RsbcTcxUWt2gC6601mJDFCaWizKncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQvRDzQENpCt+RMk9gm1C96RDQJIqhPxClqPKGCv2O4=;
 b=QVY/HjnRSk0BcVxCXokExl8Xb0sHstGyiJVeZgYOM8BIOG6lWM+Rg/X+hQIJVX9TKw+aNAi3bVLzePw0h6jkPw8m1MI3/aoRWuMj0fGvfoKkROUQpWv5ssgTegPOoae6Ex5MXofwbcRG8afI6tF4z4J+si31gc7/BLlNV0B7nutCA+FRXRETh+hToSX+OTHoHSsxyV4TgQ6an8VqiJHc0IJqwy6N50bNZ984bo+1V1o+zwiXZo1KEewwULdTWiMgqWJm1Yoch16uCRtvtzJZ733ysKSn1nbWcrZ8VUTvf++UKc9b9/d5XmBXDBXgnnpKIBpEu49RbqDKmBD0QLIxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQvRDzQENpCt+RMk9gm1C96RDQJIqhPxClqPKGCv2O4=;
 b=SnIuzk9obWd5kcsImHIjveTGpsJtpaXYgU3oQ6p9zSs1SFOg1vVtoSG8MMfK91+FRtjpXJwxlycWda/6JJE9TmP/O0w8GldUVGLB709nGklvC4pGB9zJ2TGbdNqANPa42qc6dfQqVZfDzvtsNmcM8y0ODjIzfxNp3hdycNj77KG03U8jwRLTFFLAmcO08ktOG+OqLYcoPtO0Xku36RRUqTMfqG79cMlKf3ot7B6KiLB+2DuHHHGujwDNZzVE02Sca7XnQ0SZGKEbZnViA+MHuARlS4q9I3gKCzswi9XNJoYvKWsav8yzllSqF49LEL41jnE+D8FGNKbi4piZSnv0aA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CHXPR02MB11332.namprd02.prod.outlook.com (2603:10b6:610:2f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 15:44:43 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:44:43 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Topic: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
Thread-Index: AQHc55O5Scpifk99ukS97TxWxklCprYiBjUAgAAGyYCAAANEAA==
Date: Wed, 27 May 2026 15:44:43 +0000
Message-ID: <F50EB764-5F22-42AD-89E2-677BF7DB453B@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-14-eric.auger@redhat.com>
 <3344B74E-39B1-421D-8417-373A688DB372@nutanix.com>
 <c4a38526-a803-4e69-b6ca-f6bf0583198a@redhat.com>
In-Reply-To: <c4a38526-a803-4e69-b6ca-f6bf0583198a@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CHXPR02MB11332:EE_
x-ms-office365-filtering-correlation-id: 25270fdc-76ab-4f34-374f-08debc06df15
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 WO4LUyWvWGpFES01xW2PsBunbDghc6FWPSZyn2lm3vOO5KVju61pDkBlpgkS0f/JUDiWu/Mj+CUiJjzsliNFCBhBcsY1ez143fmRDC14YdvzCoU3ETzltRuGTfgCVHb3FAW9ICiT7GbrdJsaSysBdDF3ov9ke0Q0qF72d+T29Ss2R/NKVB8MF4VLHdq1OM6mnuH4zqXevLkrw4OFfczvC10+wFkrfz0AGvC7OT91147GR4Vsi1SsAWuNhbwwig8n/SU6T0UlQvs0PebauxN2b0X++h3Gznrr3+KOzI9Cxlu0/lOu0O+R1jHZ7FH62GJPC2eY/EXGgwk9QkiOIepo/Lwlqn91DVyTVNITdJw0XBTlrQ+XKxjyderqTJNhp2PU1H3j5X6vJ+tCejtgTqg2jcMQQ7DLmKbluZYJfh+edyQOTfg+gPC9OczZKfMUKnt0WTrHvAOHsluAJLb+vEJBVDSyeDP0pYFjNfd+AHmVSJT67i+B15RaqGy+lPtNrxgCwrKdtlLj1jgZwoQkb7PO/gpK59ch7YD/maQ3Oxtd0ACSBs4j0ESQE1K8wHoc8fXnVN3etzxCCKp973w5NWWUQcHHVo70Y57QsRBGH6gKfAIRO/nqTMP6Q0tTGfTTORVpU9eJxUemBvyE6sA+pWkfgI6ymtXe85bhQwO+xTa+AFkTSmioIAMbeFzrDdRH7u0vb8Bt4LGwYfwccrJCr48XLh1fz7PBilxkj/2mgs3T3PAB9SPGnBzGoIio7D4cI2zz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QVIzQkh2bzFUNXJNaytYUGt6VWFHZTJ6NXlmaUFvV2pLdXNZQzUxZVMwUlBQ?=
 =?utf-8?B?U1JIeDYvUlc3TFdGQ2MzNE14WHZ0cXVWazUvdjh2bjJYRTQrdlVaYXVTbUdL?=
 =?utf-8?B?WUwvOFZSZmFvaVVLdE0ydlEwK1FqZXFzd09OWlppbVpRdmdBS0VrQnV1Rnpv?=
 =?utf-8?B?S1h6aTBYekNPQlp2dWZKbXZNZDdwQTZydWJnOUFwc3hZL2xyaE9XZjA0M0Mx?=
 =?utf-8?B?aHp1QWFmRGhxWXF4alJ3NVdGQS9xaVhqcEpOSnl2Z0NqaGVid0tVY0kyS01E?=
 =?utf-8?B?VlJrTkozR3FvV3d5aTJHNnI5bE5lc0doeGI0UkVQVnNzR0hKZWt6N2l4UHdR?=
 =?utf-8?B?UFE0R0hVc0g2cmxmVDdnY2xTR2VaNUZZR3Y3L3hLT1p3WkFabDBtL2FPWndQ?=
 =?utf-8?B?b0RSVGM2VkV1Y3BiTHFVVnVsdnc1N2tTeEVodU5Fak43MFJXcmJQQzdtWXFJ?=
 =?utf-8?B?RDNkNG9peE8yRGhaRnpvMWJFaXlqaFZ5QXNyOCtlYmxtQkdrMGpqcllpTkV0?=
 =?utf-8?B?SGJhNDlqTXkzdXNmVjZRMGpUOFBFanQ4cVNCcUowWWJra2VKbExhSDd0RVhi?=
 =?utf-8?B?V3NoTjEwd3hUQ3RlWVQ3dWxMTnFMcGt4aTk3V3FSb0pUK29kUmxYSHFCd0NS?=
 =?utf-8?B?Q2hqZU0xK2tvc2pvSm83YXU1NzJUMWNRZTFDWFFGWUdsaTgzbm1oLzNaY3RF?=
 =?utf-8?B?QTgzVWZFZUFuTXFZc2djcFZMZ3lRT3AyR0ZBUUdPOEp3SmcrS1FTZWJieS83?=
 =?utf-8?B?R1BWSngvVUFESEo5TVZZOWZKaXY4QVFCOEU2MEswZXM2RmxDbko3MlQxRXA0?=
 =?utf-8?B?UEhPRmNLWXVaNGwrQUl1UWRwZlBHQzRkL0lHMzhtSnBKU3JvcEFCN2orc3RS?=
 =?utf-8?B?eVIrRmZIdEhiUGF5WkpyM29Vdm91aGEyQjR0eXE4SGNTYk9GSE5ZVExlaW1O?=
 =?utf-8?B?ZHNlUU1yMXNnaUVNMVBORWc2UXdVem0wczYwRVd6WDZSYlpnVUYveHh3Nzhz?=
 =?utf-8?B?SUdIVWF0QXRydHJycUdLcldxekY4cDdkSXhjSnpUZzBSbWVhWERtTDEraWoz?=
 =?utf-8?B?V3FaZ1NzeTlOVDk5SG1OeUFVRGV0VTdnSkRCczFCaUdDWEswdEV6SWxIaGhS?=
 =?utf-8?B?Smd3dmVmM0F3N3JGOTdnN1cvMEFVdmMwQ0NvQnVXWDVxcWNGZTBtQVFkV0ZB?=
 =?utf-8?B?K2pJVHh5Q3l1YUlvR0lQYVVvNmxjQlkwMDZXM1dTZkljWjNYV09UWXJ0MjI1?=
 =?utf-8?B?S24zOTFxLzhFSzJabk5EakppMnh4dmhkZ2NQZGhlYTk4Rld0RGh4REg5cnlB?=
 =?utf-8?B?K3NrdUttZjFWYU5ZOUgzQyt3clozQTVraGhhRXB3MFd4bXBLUG5qMGY3dEFW?=
 =?utf-8?B?YnZESFoyaVNvS3lKTERBSGVBNG1Hcm5BNVpoVHltUGtydG1qZTZ1L0FsVDhm?=
 =?utf-8?B?YkYvNHRsamlIcy9EdVBGbStSaUxGRlhrb3pONUpJZGUzK09mR0FCclFCWDQx?=
 =?utf-8?B?L2dVWGJXY1VRWUtsaTVVeGJvUzBnY3JmTjZFd3hELzFUTmVuR3ZoZHZMMTBI?=
 =?utf-8?B?a3hDZEcyZ3BlNUZrNXRQUzJTd3RZemM4U2NtcEZyZzNJYW1nNGhuaHp6dmZI?=
 =?utf-8?B?eXRuRXRpM1QyMDhmZXRKeWw1RENhN1piWnZmd1l5elZoQWIwUm5FeEJKTzZE?=
 =?utf-8?B?VUc3MGM3VStLT1N3WDBpa3NpK0ZtQ0M0bU5WaWhLWmFYOVZOV3RhWkVLeGpX?=
 =?utf-8?B?QVdlREd6NFdPQVlIaDNMdzFNNUxJbFpCYkxjN2xxRkY5ZUVrNnI0TGwvSytK?=
 =?utf-8?B?a0dTbytKSGRwdHdWZXhLbE9EQXZzWGl6K1h6UXEySEhDalM5YytneE00blk4?=
 =?utf-8?B?UmljbWJ0NmxjSlBzRzYzczdxbCtUc0pZNzhUejR1dDB5NXArUkZ2WVBzT2ZF?=
 =?utf-8?B?U3hpTXJBcVExVUZ0c2dZRXZPeC9mZkdXRHpoNFdkT2xleWp3c0FySjRZdjNI?=
 =?utf-8?B?SXR4dFRZZXFydktRWlpWV2duZW4yMHZrejc0TnU2bU14aDJVbGV3YlFERVVa?=
 =?utf-8?B?cWsvc1FFN3NHU1RlZi9DYkh4YmFnV0hGdHp6aUVCVElwMjVqM093aDgyMXpU?=
 =?utf-8?B?RXVaUmRLK3o0NENxZXpYU2VzelRSSG9OTklaQTVsL1pDNUYxTDFoMGdyWHF0?=
 =?utf-8?B?T1ZUZzhVTmtWYWJNM210bzdRWXRQUzluYVdSeFJyMjNNR3dtMlhjOHI2QVFD?=
 =?utf-8?B?R041aCtHcXk2ejByMEtkWGRqOEZCQ3pJM1NNc2JXaFhvS3FGVzkrcWtWN1Np?=
 =?utf-8?B?dDAwNFZoNVIxUjBXMklaV3cwU09tdUJPNzJuSmFFVWU2dnpGQ0hBQ0RFTVJL?=
 =?utf-8?Q?kup24dA75j7V5gFE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9097045F1FB07044A150670FB5B8DD59@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	hcHTS7lsdDmMgv5SjfQw40UGBpuTVltFK1k+lQC0ql1/vrbGbBpQ8QqJkCwGwak1G62SUQXfvfDSU6cMyXx5Rx0KTF+0vFekqBZjgI9Sw0tRaxqwOCKpYVMJbb6zLuUVm3CVs4gWXvgGvk2sGzAFF2YmyGBA+SZbX93JQAwiNPXZz1Jidizmc2qcCQyUz13QkcPADYzDYWx6vNyDi+83uvVE4zYLgZVqPd4r3JE5Da5c2DTZqd6iJxB9G3Wyq8z/CzHaHy9WW/Yf2Y8RQXbUvdcw5JDcNDq0ubUE+8v28n2WXrnw+7gh9plXXbLThSkta5m6fPjkNfaj33ICpv9gDg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25270fdc-76ab-4f34-374f-08debc06df15
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:44:43.1120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5DRymFNNxdxq3meRSdw8a2VIwVXblBw5SzCUV2lkeaexLmUz5MenE+22PdnstVPrQjTdONs0gfCf/b2lpB7VmHHn93oRnR1XXA6/3N0jAwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHXPR02MB11332
X-Authority-Analysis: v=2.4 cv=Z8Tc2nRA c=1 sm=1 tr=0 ts=6a17116d cx=c_pps
 a=sVyPeiiUi2aMWm4r2qpWVQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=yt8oDgAaeGEy77Q33qIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RVc2VHLX8DwnzJbgU3GlGjJpPGF8Wl_2
X-Proofpoint-ORIG-GUID: RVc2VHLX8DwnzJbgU3GlGjJpPGF8Wl_2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1NiBTYWx0ZWRfX3iOyApZOz9U7
 o9gXHFGoahw25ab2BzBc9W0ZpjAGf07nPDOaUMFED28BxCBxCEeTQ6yMMPVtrRM+ivq5ZX2km+g
 /Vp8VB4izpAKT6FWnGuTSNhWFPhrYxn/m3e/V6nYqwudxffrUlVItD6h1fuT4vHMVikn4P+xISy
 c33KNPOqDvAZHh0zsnRLdxCpTjY6cPRfKoeWhM7GviXhTmcQgxpN+8zgLdfowJT2md3q2uOh5EY
 jLaDFxQyXhULzsNZU5R1qzuYZ+v23r+FpbsRx/I5CBnkwvwn8J08prKWEyvUp6ZUDsdVQzqEADe
 zXtP7Ibxn+jFk7Cj5S+lWMPgDVFzSUEed5y3cp2MAnCnu8u3HgWUJwvrT+cS17QWioz9GpFRMoD
 5Ii95M0FXm0h5mjj6qqPNy6B2X4YJW3YzGIv0bhsi3ju+tlbwO3WLDMZsfB/vhYReWey6KezUh8
 ZWHetq+tJ4mU7rbWG6A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjcgTWF5IDIwMjYsIGF0IDk6MDLigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEkgcmVwbGllZCBzZXBhcmF0ZWx5IHRvIHRoaXMg
b24geW91ciBzZXJpZXMgdGhyZWFkLiBJIGFtIGluY2xpbmVkIHRvIGRvDQo+IHNvIGJ1dCB0aGlz
IHJhaXNlcyBhbm90aGVyIHByb2JsZW1hdGljIGZvciB0aGUgbGF5ZXJlZCBwcm9kdWN0cyB0byBr
bm93DQo+IHdoaWNoIG1pc21hdGNoIGNhbiBiZSBmaXhlZA0KPiANCj4gVGhhbmtzDQo+IA0KPiBF
cmljDQo+IA0KDQoNCkhlbmNlIHRoZSBzYWZlLXZhbHVlIHRhZ3MgOiksIHNuZWFrIHBlZWsgdG8g
djIgb2YgUkZDLCB3aXRoIHNhZmUtdmFsdWUgdGFncy4NCkZvciBlYWNoIHByb3Agd2UgY2FuIHNh
eToNCiAgICAgICAgLi4uDQogICAgICAgIHsNCiAgICAgICAgICAgICJuYW1lIjogImZlYXRfUkRN
IiwNCiAgICAgICAgICAgICJzdXBwb3J0ZWQtdmFsdWVzIjogWw0KICAgICAgICAgICAgICAgICJv
ZmYiLA0KICAgICAgICAgICAgICAgICJvbiINCiAgICAgICAgICAgIF0sDQogICAgICAgICAgICAi
dHlwZSI6ICJzdHJpbmciDQogICAgICAgIH0sDQogICAgICAgIHsNCiAgICAgICAgICAgICJuYW1l
IjogImZlYXRfQVRPTUlDIiwNCiAgICAgICAgICAgICJzdXBwb3J0ZWQtdmFsdWVzIjogWw0KICAg
ICAgICAgICAgICAgICJvZmYiLA0KICAgICAgICAgICAgICAgICJvbiINCiAgICAgICAgICAgIF0s
DQogICAgICAgICAgICAidHlwZSI6ICJzdHJpbmciDQogICAgICAgIH0sDQogICAgICAgIHsNCiAg
ICAgICAgICAgICJuYW1lIjogImZlYXRfQ1JDMzIiLA0KICAgICAgICAgICAgInN1cHBvcnRlZC12
YWx1ZXMiOiBbDQogICAgICAgICAgICAgICAgIm9mZiIsDQogICAgICAgICAgICAgICAgIm9uIg0K
ICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICJ0eXBlIjogInN0cmluZyINCiAgICAgICAgfSwN
CiAgICAgICAgew0KICAgICAgICAgICAgIm5hbWUiOiAiZmVhdF9TSEEyIiwNCiAgICAgICAgICAg
ICJzdXBwb3J0ZWQtdmFsdWVzIjogWw0KICAgICAgICAgICAgICAgICJvZmYiLA0KICAgICAgICAg
ICAgICAgICJzaGEyNTYiLA0KICAgICAgICAgICAgICAgICJzaGE1MTIiDQogICAgICAgICAgICBd
LA0KICAgICAgICAgICAgInR5cGUiOiAic3RyaW5nIg0KICAgICAgICB9LA0KICAgICAgICB7DQog
ICAgICAgICAgICAibmFtZSI6ICJmZWF0X1NIQTEiLA0KICAgICAgICAgICAgInN1cHBvcnRlZC12
YWx1ZXMiOiBbDQogICAgICAgICAgICAgICAgIm9mZiIsDQogICAgICAgICAgICAgICAgIm9uIg0K
ICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICJ0eXBlIjogInN0cmluZyINCiAgICAgICAgfSwN
CiAgICAgICAgew0KICAgICAgICAgICAgIm5hbWUiOiAiZmVhdF9BRVMiLA0KICAgICAgICAgICAg
InN1cHBvcnRlZC12YWx1ZXMiOiBbDQogICAgICAgICAgICAgICAgIm9mZiIsDQogICAgICAgICAg
ICAgICAgImFlcyIsDQogICAgICAgICAgICAgICAgInBtdWxsIg0KICAgICAgICAgICAgXSwNCiAg
ICAgICAgICAgICJ0eXBlIjogInN0cmluZyINCiAgICAgICAgfQ0KICAgICAgICB7DQogICAgICAg
ICAgICAibmFtZSI6ICJmZWF0X05WIiwNCiAgICAgICAgICAgICJzdXBwb3J0ZWQtdmFsdWVzIjog
Ww0KICAgICAgICAgICAgICAgICIwLjAiDQogICAgICAgICAgICBdLA0KICAgICAgICAgICAgInR5
cGUiOiAic3RyaW5nIg0KICAgICAgICB9LA0KICAgICAgICB7DQogICAgICAgICAgICAibmFtZSI6
ICJmZWF0X1JBUyIsDQogICAgICAgICAgICAic3VwcG9ydGVkLXZhbHVlcyI6IFsNCiAgICAgICAg
ICAgICAgICAiMC4wIiwNCiAgICAgICAgICAgICAgICAiMS4wIiwNCiAgICAgICAgICAgICAgICAi
MS4xX2Jhc2UiDQogICAgICAgICAgICBdLA0KICAgICAgICAgICAgInR5cGUiOiAic3RyaW5nIg0K
ICAgICAgICB9LA0KICAgICAgICB7DQogICAgICAgICAgICAibmFtZSI6ICJmZWF0X01QQU0iLA0K
ICAgICAgICAgICAgInN1cHBvcnRlZC12YWx1ZXMiOiBbDQogICAgICAgICAgICAgICAgIjAuMCIN
CiAgICAgICAgICAgIF0sDQogICAgICAgICAgICAidHlwZSI6ICJzdHJpbmciDQogICAgICAgIH0s
DQogICAgICAgIHsNCiAgICAgICAgICAgICJuYW1lIjogImZlYXRfQ1NWMiIsDQogICAgICAgICAg
ICAic3VwcG9ydGVkLXZhbHVlcyI6IFsNCiAgICAgICAgICAgICAgICAiMC4wIiwNCiAgICAgICAg
ICAgICAgICAiMS4wIg0KICAgICAgICAgICAgXSwNCiAgICAgICAgICAgICJ0eXBlIjogInN0cmlu
ZyINCiAgICAgICAgfSwNCiAgICAgICAg4oCmDQoNCg0KCUkgYW0gaW5jbGluZWQgdG8gZG8gc28g
YnV0IHRoaXMgcmFpc2VzIGFub3RoZXIgcHJvYmxlbWF0aWMgZm9yIHRoZSAJbGF5ZXJlZCBwcm9k
dWN0cyB0byBrbm93IHdoaWNoIG1pc21hdGNoIGNhbiBiZSBmaXhlZA0KCQ0KSSBhbSB0ZW1wdGVk
IHRvIG1ha2UgdGhlIHNhbWUgYXJndW1lbnQgZm9yIHdyaXRhYmxlIGZpZWxkczogaG93IHdpbGwg
dGhlDQpsYXllcmVkIHByb2R1Y3RzIGtub3cgd2hpY2ggdmFsdWVzIGFyZSBzYWZlIChvciBlZmZl
Y3RpdmVseSBjYW4gYmUgc2V0Pyk/DQoNCkkga25vdyByaWdodCBub3cgd2UgZG9u4oCZdCBhZ3Jl
ZSBvbiBrZWVwaW5nIHNhZmUtdmFsdWUgdGFncyBvciBkZWZhdWx0IHZhbHVlcy4NCkJ1dCwgSSBo
b3BlIHRoZSBhYm92ZSBpbmNsaW5lcyB5b3UgdG93YXJkcyBrZWVwaW5nIHRob3NlIDopIA0KDQpX
YXJtIFJlZ2FyZHMsDQpLaHVzaGl0
