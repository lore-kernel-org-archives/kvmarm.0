Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E862271A71
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781696387; cv=fail; b=tfzQcdrfPjYzIF3Ou4M369wkLO3yghYC/emcQkwMKet7CYfuYIPCpXKBR2nsFWjy/mJ2lKY3An9r1xRB7FwCB0eHJeGN07JUqRCVjBh9MJEaNXW2/WZnh/KFQXr0iMstP1BffgPFDGmu/tjQBjZc4qB1tQFMPP/sEXA98YeEXRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781696387; c=relaxed/simple;
	bh=bt1lDJ/fOH+jDzo7DapqX7wsd2uxJ90wRNDIRx/KKk0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SMNdU/LG4ALI0x1BpH2p3eQ/TRUsk3d4h43FDST7o31DJVZAqsAhFeMJ++e6cnjldGquKpQCQmMeHXMkh2c9FeqwnEiGMk3EDPhcVRfWG5Nple6CSeY9RvIYbSDVoJdE2qlHsurC87vWSiAnEd7xQoNqBxGVLQiQZJFVbiYWoCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qiTH6RTG; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hQjLKbKR; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qiTH6RTG";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hQjLKbKR"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65H8WHgg1161042;
	Wed, 17 Jun 2026 04:39:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=bt1lDJ/fOH+jDzo7DapqX7wsd2uxJ90wRNDIRx/KK
	k0=; b=qiTH6RTG6o0GYmwLus+NYBx4pDr6lmeuMwS4o9SGf3pe2RIljQP0BKIse
	/Ov3yNvmLnsltp5D0UgqyEJ3mvWhjulp14EL+CwQRq2EWYqKmNROqpLfzS78gp5t
	hu38F2XvnweYLODooMF7U5Nc7lb0Vdx9QGyuszpDJNPvtr2Y2buH85EUbtPgxbW5
	qaDzvJIAsgo0DE72mFXHcj8kMBENCzH0XbFBEwgBf54qb0JOmoA9LAoQGujnbh6I
	Z0lKOd5Viy8BSLQ6nQLy3xWwKBXfzG2q3oBzd8NwvjfVfAOJS688AKAXOQbtDN6S
	76/NM6UHVfo1D5/ab9+mul6PFMAhg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020092.outbound.protection.outlook.com [52.101.201.92])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4eueg1hkpc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 04:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LarfvRK03RfJyzD+gMerRJsyUVqhJre7bBycfe0JXNvnkX0IKMk6zERwgEKooclfwsRIE5F7ZT55ZTksWyhIWUPPXsFMVFmA0M83NoQNFeBtJf8nij0WnYHy8VvY+w5VBrms3y/j7+uAyKK8O49dWC5Ujdnd0kWh9oSsZsXbcIzpOrdh2FRzo8QxUD2mbH0UpUgjoRA9CP2CYivQ8c9eOs4ukzCXABQNsssMKnuM5jv7bTKasetFqqHwbmFFnqALseTsinPc+8j8x2zeWFevbu5aHKzAImCD9vlHXw6vbOjNr8F3CIuH4W3E74wQoNrhy/JhwyGeD1Mu3qxMMiu0mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bt1lDJ/fOH+jDzo7DapqX7wsd2uxJ90wRNDIRx/KKk0=;
 b=oJMB19ipctgFVpaS80tAdgUlZbS5vbtM83JcKYlAUHBhhITJWZD8Zf2YSfTmvsCuorUs7IDbe9Ub3L8KbLLyTBiuKo5JxlMmGCrTMgTIzdCoTy6g2DyytquuVw7pXQ+PZDFWBIHFQNyVpd2qvPMrIJIcGwU1ru67GPScZuvHstgCym5c6kD2ekgMAW22L6h33RHeTnDCYoBmEyspSzrKmGTxGyzTn5cBq2RLvZaqUk3GLNv0kcTmX5zqqHQcx9mK5VA5mD4FuWOZ9UqKHtk2hkZExnSRiJiUS1b4y17Ohk78zA9370JRrLxzqm+siMXV2YAl6rgi0LZqsjV5BvHuGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bt1lDJ/fOH+jDzo7DapqX7wsd2uxJ90wRNDIRx/KKk0=;
 b=hQjLKbKRwgAkR8hMjPaOEfL5bnPaBg4JKFMdQJk9aKfCqUAbP+R5DgAZ3aSR6Yalv/pyQ61VC2Q3mkx+6nM0MOC14oOF6JmTpzvDL9DyA0ZAEOCMlLCqildDdo0Uqv/cuD/c+3uBtmoRnvFbT70CMbjZdi5RK7zpV040r/e4beGGFJZiie3bHfF01ydVjwxvL79+xGvdvfRw8wJdLjgtCDRxuJmZZ+dxLk1kwSKxtiESDrZzEGCE6Hrim0DnMZwpzC6pZoESPfCISE8eWn5f0D6Xfs0sbWyU1R99MyUxINSgq/67LDgMeube+3kz9qzIscbaNOEp/fKnPbOChOgsbA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV8PR02MB10239.namprd02.prod.outlook.com (2603:10b6:408:1f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 11:39:30 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 11:39:30 +0000
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
Subject: Re: [RFC PATCH v6 00/17] kvm/arm: Introduce a customizable aarch64
 KVM host model
Thread-Topic: [RFC PATCH v6 00/17] kvm/arm: Introduce a customizable aarch64
 KVM host model
Thread-Index: AQHc/ZPHyQrX8EhbCkmBuRBc61+CurZCfRAAgAAdyICAAAXegA==
Date: Wed, 17 Jun 2026 11:39:30 +0000
Message-ID: <23B60237-1CFB-425D-8333-055D35AB5C1D@nutanix.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <6A6A8465-A9CD-4FF4-AD4D-9A5231BD5062@nutanix.com>
 <44746edc-2cdb-4fc3-914a-da7c3458c866@redhat.com>
In-Reply-To: <44746edc-2cdb-4fc3-914a-da7c3458c866@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV8PR02MB10239:EE_
x-ms-office365-filtering-correlation-id: b85c9062-1a3d-4ef0-29ab-08decc65180f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|56012099006|6133799003|4143699003|5023799004|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 7IubhxL6EPkSRnKlx+JdBkYjJH4I37JhhcdcLGkfe1B5+TUeV5Mo5Io/43EWaa4xSCiwz4OTPnjhZX9Z43NbzmN4zj884tS6FRMI5J2xEX6EyB51GmKSNAPCqyC5l0nmS4gGuXtqoFuqfiO+4JoZi9yZo8nZJPVCxlO9EmC0HIShMj1q/HK4fce27NKSmquyW/L4cLjs8bMCs/7DRrL6GBoAoXvGTDermqpT57lGc4VysI1Te/jaUkPSEX6DCkesLj4giC/4g2K0GdWJJu9TX6du6cXHP3BHKoatTPMqK8Qt0GfHbLyJOTnoZm6JdwCz1jh0hALFoo00c49p/Ddaz0AavzzUom1TNSBOK6HNntm1Yxu/MqWEYcD7FMitEja6RntIOv6nRfu0C09oT7eT2UC+KVDD61EVgPCAZSrIRunJyGujAqBSVeOCLKI6V9RP2CHxEjh85deymC7bkhTIcuXnqkbGOnIFsdXHsvGXfotNk1tQM2O7Ver5srJcO4/QO0Kdk4zqpkw4FD8UXsF82lf6mnf++fwvyU+Pd/JJ9hau9f/bdPDghBFzaeVQIWfD4+enesPKi/XRo2OjKEumPurzuBWmiqE1oARlJJ9Rz5IC+qTFS+iffVtg+/Uf2uvq/wjjsek/Aa9HQOc71H8O/TinVRWmTPkgdDh/wClcY1k4GSG7qAG3HzKdazElDsGjb1xleY5eUAQvhD0XkDVxtcVagS/FuGj5Wg3F1VJm1AT56NmaFEhR04pR+v6bROuE
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(56012099006)(6133799003)(4143699003)(5023799004)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aStNTjNiUnhuMWZSU3dKZk4zaUVLSExmZXRiMWlMNjErc3VsVHQ1U01DNEE5?=
 =?utf-8?B?ejY1dDlmNCtlZXhmeGUyWXJ1ZHhWNittRHArbys3eUVRSmlZOG5ySytJTDAv?=
 =?utf-8?B?elZwSjRGVG9tbGViSDRLbFJ4cFdZUUFITERDUUQ1S3hlYjNjTEdUdnBoZzVZ?=
 =?utf-8?B?bVZFUklDTU9CZk5kcTRybGtvbnlnQmhKRXk4M2RsZ1YybnJjcDVJWGtRTFdh?=
 =?utf-8?B?UUVvcDRuVjJyU3pJU0lSVUF6aTRhMkdRMHQxSnFUcU5IcUpPZXJhSDZhZkt1?=
 =?utf-8?B?UWhpb0ZkeUxuQWVwY2Y3SWFOY0ROemMzbVpRbnhnc0NyYndLWWVVUUtqNTNT?=
 =?utf-8?B?VkZDZTBBdTB5aUZCUHlseUFGY08zSXd5ZmRqdXYxNCs4OUZNbTNQUGNSTGM5?=
 =?utf-8?B?VHB1WUJYS2hYVDl5WEJhd2pka1JrbzJPQW8raFMvS0UrSUFLTk5ZdDlKQSs3?=
 =?utf-8?B?ckN5TDFiTTBlV3dwTE9sUDE3MmxjOG4wSG55WGliVHNtUEtHVUJvWWlIeStB?=
 =?utf-8?B?MUxxUTFWeEl6YlIwY0tja1NaSjR2YjZoSHZRYTh4T2FDbUhROTRrOXl2Q2to?=
 =?utf-8?B?dnVUbERXV1ZGamw0Y0xPYjYyT2RJRmNMOHRWeDEvakJiTExlcjBwamVZK3A4?=
 =?utf-8?B?Q1ViUXJzVUE5OXQzZmhJbWRoampwQUMvcDh5c1ZUMkJCcHUwV0J1cW53U3Qx?=
 =?utf-8?B?aEh5dWMyY2xTaE9QSWhzQVNvYnVUY2h6VytUbHpGN2RmRTVXQWFLK1V2Qk4r?=
 =?utf-8?B?M1YrYm5QaVgza0sxa3I3cEkyNDhxc1lMeStLYkZqd0FudGxITW1OditMWi9D?=
 =?utf-8?B?dTFRK0cxdFpxdFM1ZzBhZnlKcGdZdkxkcGJUUTIwZ0tNZ0g0NG5qWTdkdnda?=
 =?utf-8?B?L1BUYnpERXVGWDhDTzR2bFNFU3YyOHhwU3ZDZDVIS09sWEo1Y0xLbE5XUGhp?=
 =?utf-8?B?UE4wRUdkMjNQdmhGM1NNRko2dFd3cTNKSHVZRENrQm9ySW5UaEFnU3cvYlRK?=
 =?utf-8?B?SDdodXVXako5VnhucXE0NXpGQ3loVVhCMkVzRlVraUZEUEJFRXZIeGZpeEhI?=
 =?utf-8?B?TEYrS1dyblhSWDFOYkRXa2hnakxyeFhqK3RDZTY0bnRqcVVLdnVxaFBzcUg2?=
 =?utf-8?B?ZEg0bUQxNDBpeC9oZXRSYlFIZEJCSVMrTTRGVllxdGxFa0JSdkxpT2VIb2xL?=
 =?utf-8?B?dkxJMkdHL0N5cXF2KzVwZ3hNay9GdUFNd3JpdEJEMEdCMXkwSEY2NFJiOGc4?=
 =?utf-8?B?UnliZUxkQzNqN0Mvdk8wK0lHNHpJdGFtNWRKVHMzbUhnSjFyeXpxbXNvNDdr?=
 =?utf-8?B?SlNUV0dmYkN3czQzWW8zQ1A4ZkxrSlNFQ2ZWQWZrZzFTa3ZYS0FXcDNOR0Rh?=
 =?utf-8?B?ZEtMbjZhbmFPcDBHTnlCV2dqUGxodEduckRUQ1FIZGxVQ0d0aWVza0l1ZGh0?=
 =?utf-8?B?RzQvc2svakNHYi9TSlRsc3MrWHpSRys3ZUZDUGw4eDJyRlpBSGNCb0tuR05L?=
 =?utf-8?B?cys1cWsxWVEveG9abTJpOFQwRzFXWUU3bGc1MndKWTVRa2RYUS9yTWkrdmVq?=
 =?utf-8?B?T0tLVVNCOWs2dXVhQXo2dnkzRGNKbmJjdG9SeU1JRHlhbkQyRFJOLzFoRjJq?=
 =?utf-8?B?KzNvSExGR3o1ZEpvckxPZThsSWtYWFBiL1lidHJsWmVuK0g3Z214YWxoL3Nx?=
 =?utf-8?B?NjlEbktCekd1NWY5dzJJbjhxTGQrMzA0a3RtZlBSRkR4c0tLRW0wbDlGVU92?=
 =?utf-8?B?MzZxenM4VmVDY3Ryc04rM1gxbUttY3dWcnU0Z0pRWTA3OGFJMHFrRDkyU1FV?=
 =?utf-8?B?Qi9HNUdxTnRJbk54V0JSTkxTaTlEVmVtMUM2TUd2RS9sNm1IV0VXVC9RbjFF?=
 =?utf-8?B?WFVCMHRsVFJMYS9GTjVaZGN5UW5vWnJCNzVPeGxyMXo3VUUxdlJpbmdrc3JE?=
 =?utf-8?B?MEpEb2NqRGJtM294eGJ4V3J5Wk1ENE81SVAzVURIczZRb3NqRGdablRRNzF2?=
 =?utf-8?B?T21PUHc0WTZNamlrTXFRaE1DYnY1TDFzRmlYa0lKSTV5TDNtUitjeEc1KzVO?=
 =?utf-8?B?am9vWm45M0pEWXl1Qy9BdzRKbmtzVlZmeFZvTmRLYThYdGprM05WejduSytN?=
 =?utf-8?B?ZFo1ODhGbUt2dG9ERXhjbFJFL2RkdUc0TnUxdWVEQ0tTaFdobmRPUVdjVThy?=
 =?utf-8?B?ZUtmUDJRbnZiQmFtbUlFelBDbU43OTlHcXZDeDFybXNET1ZoNmRHMXVqdTBV?=
 =?utf-8?B?Z05pSHhIdCsyZlpRcXlPWFhOK01SWWd5Q3ErdFNNandBL1hUL1R2U1QxYXZm?=
 =?utf-8?B?SzhXQ0JnbXpJVmhyRndDRTI4MnIyOFdtd1FZdzQ1a25YUklKVDl3aVdmaTVE?=
 =?utf-8?Q?NGlTBiwvuEv6QaN0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE7447C012E1B746AE52FEC99150221B@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kOSTsr03RE6RfNRerZ337vVkzc0lfaQVVDnUNpXWtQI4ZvOKfaRisE3TJGLk/J3nc/cOzbTQ/GHDqzut7oAz/h6GBMRIslV3nhx4tvETioP7vQiAdDmxps01zEDqgmw7dWxCTTanVmqVQiFW5AVa/rEtozOe2HgUJuy7HniebkKm/09QucHLoLOfEvwDIWrwvytuNXcmt839zFEGIw6dQ2bEVgTIBvgSP3B3qvU/xobswdFG0fbAjIkXoKSIZ5gabpTfFRHsTEwq0BdH9Z4AW2e75qq/QEXucGFP6D0XNOLnwYfA5Br266kxf+k/YNeV++ewWBtcdTr/emp2/4gxrw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85c9062-1a3d-4ef0-29ab-08decc65180f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2026 11:39:30.0358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wX4g3yFgUZoxTThzf/4eOXr+9DbZZYjGAdsK+ov1MU2GU8gz0HDfkzJ397zIh4t1YNDFdSgoYF1KpWBudqFnCyxfgVUoBcaHBbum+g/CeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR02MB10239
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDExMCBTYWx0ZWRfX3LvPxHL05J1w
 WhcEBfTIwL4ayoBlxtX+PL4BVJ26umJhYLraJDX8YXU1/HAuYcYKfMwD5ONJ+5Ce97nWn/fuXmT
 lKZY7mA6OnP+gFbmZ3DFAtaIaoDYwAg=
X-Authority-Analysis: v=2.4 cv=NqThtcdJ c=1 sm=1 tr=0 ts=6a328774 cx=c_pps
 a=LY2ru7gGMFScFVOHk0H8xQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=UQ1wtcaD8JH1EvzdWGcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3tu2b_uGqlkl359df1toEWcp14gJd9eb
X-Proofpoint-ORIG-GUID: 3tu2b_uGqlkl359df1toEWcp14gJd9eb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDExMCBTYWx0ZWRfX6LyoCJfmYx5v
 Phbn9EU7gsR4bY30eZ1/S1FJnaJZcyAnhwMivebJdqQ2snU2pS8+bu4OuH0MDuNlGnamA48BdAN
 +8NvrKVNuHDqK5C9qa4+0QYWXDzieW0ceSg7LFZTV1FGpKugXmhXOF9QcRGMgcZNgYpv+oai0qa
 9Gw639/sHoqkXrOaCvI1y5fL6pdNAtGFqrwOJo1I28pW8q/H3KN+WxfYiay0uG/THI7IKQqlflB
 HhmLXeY0Aqzwph/VM1xLmnr+1zoQFwVk+7wnO/tMkrCDmE1PNktEGmOH+HsHaHqIIn9hdkrj0Yv
 uvOWlr3n20hwRopMfLav6xv6zqT8wseZiXt7wv7SJAbHX+Qose3SGR8FUwTWpbPdFUXUe9pKwrf
 836fKEUSCeNKeVA0J+hcjon3g0CWVgLnvLCPABwRAgKF89XYUsx8odEEI5MRcnxhTQSh8TlXLRM
 J9rcltLeVqVVPRdnCwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_01,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTcgSnVuIDIwMjYsIGF0IDQ6NDjigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEZldyBub3RlczoNCj4gLSBJIHNhdyB0aGVyZSBh
cmUgY2FwYWJpbGl0aWVzIHRvIGRlZmluZSBwcm9wZXJ0eSBhbGlhc2VzIChzb3VyY2UgYW5kDQo+
IGRlc3RpbmF0aW9uIHR5cGVzIG11c3QgbWF0Y2ggdGhvdWdoKS4gU28gdGhlcmUgY291bGQgYmUg
d2F5IHRvIGFzc29jaWF0ZQ0KPiBhIEZFQVRfIHByb3BlcnR5IHRvIFNZU1JFRyBwcm9wZXJ0eSBm
b3IgdGhvc2Ugd2hvIHN0cmljdGx5IG1hdGNoLiANCj4gDQo+IC0gSW4gY2FzZSBwZW9wbGUgd291
bGQgbGlrZSB0byBoYXZlIGxhYmVsbGVkIHN0cmluZ3MsIHdlIGNvdWxkIHR1cm4gdGhlDQo+IFNZ
U1JFRyBwcm9wcywgd2hpY2ggYXJlIGN1cnJlbnRseSB1aW50NjQgaW50byBzdHJpbmcgcHJvcHMu
IG9uIHNldCB3ZQ0KPiB3b3VsZCBjb252ZXJ0IHRoZSBzdHJpbmcgaW50byB0aGUgaXNhciB1aW50
NjQuDQo+IFlvdSBjb3VsZCBtYWludGFpbiBhIHNlcGFyYXRlIGRlc2NyaXB0aW9uIGZpbGUgdGhh
dCBhc3NvY2lhdGUgZW51bQ0KPiB2YWx1ZXMgdG8gc3RyaW5nIHZhbHVlcy4gSWYgYW4gYXNzb2Np
YXRpb24gZXhpc3RzIHdlIHdvdWxkIGRvIGFuDQo+IGludGVybWVkaWF0ZSB0cmFuc2xhdGlvbi4N
Cj4gDQoNClRoaXMgaXMgbXkgcGxhbiwgYnV0IGZvciB2MyBJIGFtIG5vdCBmb2N1c2luZyBvbiBw
cm9wZXJ0eSB0eXBlcy9uYW1lcy4NCg0KTGV04oCZcyBnZXQgaW5mcmEvbW9kZWxzIHdpdGhvdXQg
dGhhdCBmaXJzdC4NCg0KVXNlciBmcmllbmRseSBwcm9wZXJ0aWVzIHdpbGwgYmUgYSBzZXBhcmF0
ZSBlZmZvcnQuDQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQ=
