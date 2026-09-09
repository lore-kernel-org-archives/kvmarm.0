Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DAE48A8CC
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 09:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944666; cv=fail; b=YfOGETwONkUzQTmk3iHSpIKCqrBjb3V70i1WSmrQpUDc8jxlPe1PIySfPy6MNX1VZJWgv1R+oZHUqnSuNk2GdVHyrEz9DygAq9OFDDl6DUJtn4FYEKBF7jZuyx5npGGiQpFXv985lYT2uhoYBb+KgCzcXC4J8XPJd1mSLOSue20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944666; c=relaxed/simple;
	bh=oF9YtWzRCXZJfkMI2DAhG89uPx4x4tBvkcLaJYYTNe8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b1bUwMbNtb1Ai5T5fVmkNgfEqSd0wrBtZWnVslLdALWvLmfrZ6dl7kqPtxs0tbx5xbhuj962UkSjEkdm3wxavZXNFSR9/5T9Krp2rW2phimKCTU6e3wh3VnpmSu+DdDV5bPvAjZvktRPLmDZ4GyPGpZSL+/0WwJ54bGDdqnPLW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Z5onsghh; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=iiXRN7Rg; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Z5onsghh";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="iiXRN7Rg"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688MfL7s229006;
	Wed, 9 Sep 2026 01:47:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=oF9YtWzRCXZJfkMI2DAhG89uPx4x4tBvkcLaJYYTN
	e8=; b=Z5onsghhJwqd/pGVjEwP4DIDVLeyjHeLEtc/Dpx6rXGr71MxL8TdeyEZw
	S1h27XwAFKw2YfXTgiTM8lhzRg7DFx366ZoitnXxIC6MnPG9V/7o+hOYwNvpKy/e
	/0y5IXmZx8mmdHjYBFgFJs8kChRVBdoZGiDYxCCYuzcOwVjaJmN2dJlQ59LOKgNK
	OOPNGuY8qhKQu4wCQ+lh8N+f09x8MgGARbJYnyc7GM72PAHnT/5L8D1i83Affqnq
	1rYjwG6sIkMTTKm+NV/IonFJJm3jCJFdH/63lc9gmSWR8KkPjwT+3xs8xYxXfTXZ
	X8JuLCQ7VYXVAO5K8jYCxlVRzyjgQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11021087.outbound.protection.outlook.com [52.101.57.87])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gjp7m9wk1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 01:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpJSktze1HWWo/aXHPvQNHJLCE/v+C4UXd1CKAioPogGYp+wsFRkVKYNGNbPoQC1tnZmp0XWDtrbtbczonFU5wUtBJXCXc5OXDbRv9pkmNAPwALOG3FrpDiARprbmTrb8xqVYfCLNkouJXSH/7FYCBOmC+IGmrsOIQ0Pu5MhGIOXjWo/owSgkK2vfuQlheRJ9OW4QjV1RNVqIS+M1WAbS4JqOTResjIJ/I3naGdzchX4SJBtR7LI0aBm1YK9H1m2nuWR1cJSCRlIlp0gSCp0UhNOyC6GPSR/XUliDMwPUr3hIbhamD3LppdL7+XF5QXCZH9TB+s95A8ANbgd9lF1EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oF9YtWzRCXZJfkMI2DAhG89uPx4x4tBvkcLaJYYTNe8=;
 b=LzywnY1dIVLETNAiA5TeNj96uNm1nwQHPu2dFq7m5Jis13L0P6xvQLRG6wZzecc2xr+Z83YKy9fyHwsPlFkHIZeNM2ARJwPwRmOzlgM9f8imsMqE/C60QTLXDqnKh1KYPBAN6Wqybx6CP8TWW3ONHYkteAxpeILW14saJgGuLiotZwamxKVyI38f8grHtCN9HGtOKJOPZZzFIPajNypaFF4VFu3L2cUXKLAMg4nBuH4JFAcIXcR/49j1RMYfPXEggAmWJwENcOPRha++gB5loVb45Lydia3VHnOYA4T/J5gUA/1wdtRYEY1eT1PAcx15TQArLmCN0moFENgse68sJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oF9YtWzRCXZJfkMI2DAhG89uPx4x4tBvkcLaJYYTNe8=;
 b=iiXRN7RgsSz/4ODs6TkShpjwaFbADSypo0F9BYOlMrdPo2yIU2XSKCq2acytchPlOhRcgqUl6sxnLNxvU6gy45zxT2d0eGD3zddvhTFOESaDuZi3xuVweJG6O5lVmS290B6gvtesLMmqN2gNbMDzWc/eAU1b+zUGKHujMXuRSQ83EN/tslWXf3orzLU45OBamdePbuB3qMS2RLCaR6qc9mknviuPQw7RFjpZeEMkHCEfmY8C1NiutJ7Fre/zcbsxoLc/NunflH1Vi8YavCMwwAmKU31RNT7d2V0iglFdprrChvtp6nBgZJUTFdjdTpwYG+6WgP6lUoOe1AHj7bClag==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9713.namprd02.prod.outlook.com (2603:10b6:610:17b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 08:47:13 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 08:47:13 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
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
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [RFC PATCH v8 20/20] arm-qmp-cmds: introspection for ID register
 props
Thread-Topic: [RFC PATCH v8 20/20] arm-qmp-cmds: introspection for ID register
 props
Thread-Index: AQHdQDfPmdCCwMJ1t0+SvVyVZWQ5ZQ==
Date: Wed, 9 Sep 2026 08:47:13 +0000
Message-ID: <879F64C1-D472-4772-A4B7-A5733148201A@nutanix.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
 <20260826093747.1670077-21-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-21-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9713:EE_
x-ms-office365-filtering-correlation-id: 1bb03392-f7c0-4fea-f2fa-08df0e4ef1a8
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|4143699003|18002099003|22082099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 Zuq+cuhote1Ea/sTm9qcqu4jqtmE3PGaoMRhkjampSSyitA5ubhSadf5s9sdZBuPHmVdg2G/QNH86TUQzbPLUpPOLfEtlwVbIRdMJuDuWgvTGpsgwGBPzhXhbs8SZea3mwat76Ta7flzhj584+MgMYonH89Oim7Nc8doQhOLT/XvdptcnHVAZLBfvU/m/Vz0c5SaptURWJ8QbGZ+7hzxx/pW4m3ioZzYgK+ux0Wfgq7UfSDPeq4naXOUdVWNY/FkrC9d7F/h/KMy03READpTNc1+N5jktV+ms8N0sBzlg4LLZLXk7rdwofgF27puvInBb7//Jb2tmhuu1vsVEdNWTBrVt9NI/+nZCO125PqGwsWmwy0ROf8om5UBAI15zGIbU0JHOaewXaCKRHvVuB7O5Ps2fEO4NlztPGzUNIx/M3o/BXez7txRmLUnzAosQ99a4xQJgF+f2rApmRAHIAP3JW4li3gr2DM6S0mfNJs6CARH+E2UW5Qx94yb6Ko/BUzWm8SpDJhQoWjnSSvQFQpUIWlGgwY6aotTLGnbFZCT3Tqq5L61Bpw0lkpPrDa6Y/Fcyp8UsK4dOH+yJaW7UcEzz0RMWDDdvRyb7JcILbBY8jP2OGUvdruyRopzP11VT+R16w/VhJtPznDjoTXh4ujtuVPiS63IIRHCTIsFdIyjXO0xQma4rbQH3xV0EV/fvgcB7YzX9lkN6pIppCsyhrnF449feib28Xcgn5DGAT8ZiGE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(4143699003)(18002099003)(22082099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXBzS05QMVZLREJZRGp2MGp5aEt4QUZKMzdNK1BLY1dUKzJ3TTNRL1g0SUt0?=
 =?utf-8?B?WEhuaVlzQ3BvT28rMm5XcHVZai9HRFY4WTdFOEg5empZeWluOVdVbVc1TThY?=
 =?utf-8?B?VWhtTldFVldUVk0xbW4xbUI0aXJQdE5XakZNRlZycE9QYUkyM3ZoSGRhRTNi?=
 =?utf-8?B?d2hTMUhqZUM3Wm5oMkp0M09KaW9pU2ttNjBmd21QR0grZURWTFFzSGU2R2Jq?=
 =?utf-8?B?MGVkU2NOQzNtR21lMVR4a3lqRDRMcGRPNlZLcEdTMHhQR282VmtTbDZna25h?=
 =?utf-8?B?cVljZUJwenQxUGsrQnhqcjRza0ZzVnZnYisrdmJHUHZzdW5xOUFueCtJZ2d5?=
 =?utf-8?B?T3d6MFJxNWN2a3dzeEpoM1pDKzNtRWVJT0V1Q2FBVHdQZEU2VVN4RHdWdzFK?=
 =?utf-8?B?b1FleTVBTGltdElSTFF3NExnZkpweGR6YldDYit4bUVQZmFkN0RKWnlXbFd2?=
 =?utf-8?B?ays1WU4zODdvL1BIWjdKdDdvZmhhR0ZoV0lycDl3cXBicEFrUW1RSk8vN2hV?=
 =?utf-8?B?YW0vckgwMTkvRC9nbnVlaDkvbHRqeHFacXpFSVVpTXBUOUxJSjBRS25xTmxP?=
 =?utf-8?B?ekdLR1hKTng4aXNKaVhZQzFnYWx0NlBhODRnSTNLdVh5bFNlMnNXWGVrTkNy?=
 =?utf-8?B?V2JLZThiKysxZm9DRG5iQ0trVWJqZkJoSjBGcm1OcTZLb3FvYktNandqa0NC?=
 =?utf-8?B?WjR6RTdyam0zWG5xb3I3dHBBRCszSVlBdm1PN0tzQ0NmdTNqVzQvalVBWWR5?=
 =?utf-8?B?YkkybVhoM29oUHVVK0NKV2FWdEFjZ2RuUlZ5dHJPTXo5V0QwT0NuaTN3VExY?=
 =?utf-8?B?dVpEbitjdlBFM2xnenk0dmVXejhGNk93Z2lyTTBOSVVnajYwMjFyMTZOcTBn?=
 =?utf-8?B?S1NuT25Oci9tVU9Vd2FTODRVRWRock91TXZpRDBlRVVudzM5dzJlamsvaWxJ?=
 =?utf-8?B?K1FtbEpxYjgzenRsbmYwanNUN1IwODlaanFqM0ZKenJxN1k3YkQ0aUNtazJv?=
 =?utf-8?B?bmZkTWlUZG1GcTVFaTZCQituQm1DNDlaQlBDRlZSU0xiK3JNSnliZ0FZNlFa?=
 =?utf-8?B?bU5vQTRIOGJnYnRNMWhuaTVZM3lJdmFQaExMRU5kMHBoS2taWllIVXlPMzNk?=
 =?utf-8?B?SmxZaFVWVEdkYi9OM25QN2pjK2NHeTNOVHpWSkgwSmlkTmVUMzB3VFRVV0RR?=
 =?utf-8?B?OXV1RVU2RTljSlNYUkFzajhlUThWdTRpUnZ6MnhMdXVPK2tGNHpCeU4vakYr?=
 =?utf-8?B?SEdSSVVZcmZ3QjVSS3Z6K3lLamFlaittNDdCTWthTy81RFpoTzlwZ3VwZndu?=
 =?utf-8?B?N2FnOFR3YThMZ001UjZldzZRK0VkNTdIMHM0VXVndXNhMHlXdlEwQS9WUXhV?=
 =?utf-8?B?andySmF5TE52Q3oyWXVVKzcrYU1oSWl1ay8vc0YwSisrdFZ1NG1XZkZtLzFY?=
 =?utf-8?B?ai9DOXdFdVpLMFlUZ3llUnZiQWQyR0w2cXdYQk0vU1FqRFNVeWtTS0ppUGxt?=
 =?utf-8?B?NGY5V1FlZnlEdFkyd0o1L3BDVlU2NE9ndElhaTBJZlpkV2NZZFVkOTVJYjUy?=
 =?utf-8?B?YlhDd21BMDBoWFVXSzgyZDhTdGZzSGZ5emlFamZHc051azRIOXpNTHB2cXNx?=
 =?utf-8?B?c0QzcW5uakxoWHp0d2Z0RDJieFY0cTllVlh3S3JQODh0bXBSTEN6dlozVFRU?=
 =?utf-8?B?Vlo0OVRBTEMrMDBMNnovc0h6TEV1MHpwbnMyNkVZUEgvZHo4eFBiZGpvVEsr?=
 =?utf-8?B?TkRTeXZrd2FQVVRFWDZ1MWZRMnZwM1N0bFlNZTBhbDJOWWd0bFdVQlo1Uyts?=
 =?utf-8?B?NjZ2WXhjaDZ1SWN4QnB6eERaSzN1WmoxNEI0Q1VocDJxS212Ry9MbTBnSXVt?=
 =?utf-8?B?a1JzNFRxaVFQUTRFdVA0MytmZnIzUmM1akxzemh4OXBSZnRDcmFzVlhyNzVm?=
 =?utf-8?B?c252ZkdPT0Q3ZHFOZ2dKYWRXNTNOWGJHZjFpQTNuai9jeWpzQ3pLbWc2R2Z4?=
 =?utf-8?B?azh6YnRIZi9LczJKSkFzY2F6T0hwdlJYbThML1pISmNIZUppZWI0RE9BSnNu?=
 =?utf-8?B?eDY1bXNUR2ZxVTE4T3BIRVc3ZEpZSVAwNXZaVm9WMzU5MkFIaGY5UTJNcXRi?=
 =?utf-8?B?REcxY05MVGNBclREVXoyTzA0WFg0OCtWQjc5WTRaWHJRTUdyb2xlbEJBL3dm?=
 =?utf-8?B?RERDWUp4MzJ0Y2t2aXF4NmxhenUwYTE3RXJndXdjbU9QTVBzcjA5YXEzUVVt?=
 =?utf-8?B?Yk14S0NuZUZxYjg2bWk1V3JqNWtWeGtzWUtqU3BwaldQYkUzMU5RTUl2Qi84?=
 =?utf-8?B?Ni8yYXdHRS9WVU1uek95dkp3M2tzc24wcE9GNHBhenFQYTJsZm9tRTlVcTZm?=
 =?utf-8?Q?081sU0gNvzl8kSDk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E0A42DCF3D1766459E1E46D3C7C0E81A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	rv0OOFvXZtn5UtFUpT/tNTSD2nORaPxDuWDLb2AhiI1SDWOuiN2JmtsgdrAY9c6Khi497xQ8DYmPdH7fF9OQou+0OUVWROG1XoA89P6DBEPFGGYl2XLSADLqftThxvvfQZ67SgjzO2epdc3iYY2AqGMs+Iw4Yko0VsloMnsMvxf0JGmJVN5S+Dokk1SPpQaVX6okFkndw8f10iC/+b+X7gAT/Wr5plprlukykFpKBDOmy1KKwzRLCWvzwpZrVwDVHC8yIHTLie4Kv6UlBAd7wZ2R1z+aFV7PAwY3T7u/hfR3KdOv0aHB8MMz1ERI/LTDYuCTH/nK9UB8D/8zYjyumw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb03392-f7c0-4fea-f2fa-08df0e4ef1a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2026 08:47:13.4030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nEFny4kLXPeU1fgdyHnCAekNGfrzYM49qqmGzP6SlxYMlinCSjB0q1ARRLTANNuRAkWSRywL6AuXmF0MTTeV9jJUVf70NopsAcGKilgV6Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9713
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA5OCBTYWx0ZWRfX6oVc42hignhZ
 LsbGYpWBiRBw2VxBECY+0Epkd8987+TXfowQRW0kCn4Ptk3f/QpQ6+VZnnmVCWW4qHGfENGrMUx
 U1LtKbuR4vgr/gh2N1jWM6UcholXkIKDHwgg+sts+AVwxGOVKT7mjounFW7tApGAgPhBLKEhPpC
 rsBaW2ks/141cLRr+DA7/FnnBLj41fmhJt2uuoqQLrcT7M6NG8ZCvr5a5s+u9GJElsqBf6b3R0L
 pwVL4ekpmAn7GPzPLdba3m5+ZDTylcVQ4usylDpnd/0azDpF63A82noE3g8xGMq9A2eoq5kEphT
 EBhRr5cNcySM9Z11ZvgZxWqxA+eh6aAzRDvftUpMRLPpN+Wz8gYfE7IJHjkmm4TRv3D2fgyC42u
 +6NvGDzY3snNNZNwOktgfQZ96rhXH5ZgbZX9+Z+5WoxCeFRqA6F1ESs3i1nLEBaISpm32xjYhEE
 3chRfeoIuYns4N/E6TA==
X-Authority-Analysis: v=2.4 cv=d7fFDxjE c=1 sm=1 tr=0 ts=6aa11d13 cx=c_pps
 a=PDMYrpmLcA1CqgnwcVHdMQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=Uigu8AJExeiRF7gAJD0A:9 a=QEXdDO2ut3YA:10 a=QbcjlK4JNLEA:10
X-Proofpoint-ORIG-GUID: 4EOH2-g7E0gqHJHDKN7IsKPOhSxyy2MD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA5OCBTYWx0ZWRfX0+08/0EKGWL9
 ZgIfmLtbmw8463gyQYMMd929DyqtLW5KIW0bTS6D+CnEAdKyn48kAafplXitcy3HyZRrLcafYQA
 Xru6cXr8AIXqR348iwTC+I1B8NTqlmQ=
X-Proofpoint-GUID: 4EOH2-g7E0gqHJHDKN7IsKPOhSxyy2MD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgQXVnIDIwMjYsIGF0IDM6MDbigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICsNCj4gKyAgICAgICAgaWYgKGt2bV9lbmFibGVk
KCkpIHsNCj4gKyAgICAgICAgICAgIGt2bV9hcm1fZGVzdHJveV9zY3JhdGNoX2hvc3RfdmNwdShm
ZGFycmF5KTsNCj4gKyAgICAgICAgfQ0KDQpIaSBFcmljLCANCg0KVGhlIGNyZWF0ZWQgbWF4IHNj
cmF0Y2ggdkNQVSBpcyBsZWFrZWQgaWYgbW9kZWwucHJvcHMgaXMgbm90IHByZXNlbnQuDQoNCldh
cm0gcmVnYXJkcywNCktodXNoaXQ=
