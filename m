Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC61EADC
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 07:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135706; cv=fail; b=S3I70RaNGCOaQI2cKfdQfOJluzGgNLrLBnK7CFMVZ1ukDaAgD6LeUzpvIE0QRFdUQAHyrPdn8qaW1hFU0VvLYw5WwTkrUp6d7W5Lw630Zgvomyp3OVRa1atC/0/wwLtPS1OdHF0vy1xtHZEakrmbSf1ex+yGH2K4u66g0S9ua0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135706; c=relaxed/simple;
	bh=WvdwvZ+Qi5T/SWRyq9Kzvy24gt7k3oZfH23EXDHAxNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dgY2BJWWgbU5YcHx7YqjiYoCqCSogu0lk7K7HksxEgGv0AoXUQIM6PbrSEPBOY/fzoMB8Xc5GrCIrjvoegoVpY9JZMBWo48QlitL9k9MR5r49J38jMcyXCEtlSEJR9e99gTaXMYGLJuGTh+qvtkcRPoqGAfF0cCwwTd02o26S5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HxzQs60a; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PKdAgV3h; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HxzQs60a";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PKdAgV3h"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FMSkOx4145019;
	Fri, 16 Oct 2026 00:28:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=WvdwvZ+Qi5T/SWRyq9Kzvy24gt7k3oZfH23EXDHAx
	No=; b=HxzQs60aA4c4sLF4sZxGnpqWSv+aXQDbyzNXrUjIRWddSbWGpdKakpUKR
	cTPT9CQgEvX9k3SiM2u9RPSdV6dMjUZXIhrROarEJsyNrZFzKHatAEU13d8WkXzF
	8jurAGc06SEYzSgHds+YrISdrK/iR09S7z1Nte188Ta1sbHM2B4X5tXEHZp4zJZw
	DXd1WkR1tDwj3+e58Yt8Diuf/QibQCinvVPHxcdkDoIl1MJdfP7EONtkG3QabG7Y
	iIBdy0k60t8OX9ChrP73B/HmbsYMSMC0IECJNIirYIp4TWLz39vE+kcsheoOXU9Q
	ArZ/5cJF6IAKBoQX4p6Fz25X0yP/A==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022100.outbound.protection.outlook.com [40.107.209.100])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4haysxt6rq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 00:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rg8JYnvqyF3DR/bwKAxdiAk11XUkoDNcgi8c3PvU95n2gwRgO3qcd1mskgey1fFZe4ijIzG30TatLwf+FlLspVPnaweJNZ9LBN960PLY+/deqJbeGaIep9E3a49j+NNFAfI8ebMsvAiHdHwbKQvGnDauhQltuyrGk1rp1JPLhosCZflI3/OQlXOHkCLnzR2jtjMUKn3yw+dN5dEreWAJV6U+xWeOp0EjcPtl/KWjM8PBrxOLyUvpy7JQyzUcpH/Y0C85W81KRGMgbAuch8Pw+DmLAV1SfmZM1rZjI42F36mEwNBxgyUB5OkcNtU9IiNTnGiDrhjfGe+JlTVpz5ldUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvdwvZ+Qi5T/SWRyq9Kzvy24gt7k3oZfH23EXDHAxNo=;
 b=Qp42NNoEr2u2XW7EPp5e8siQ1ihtSbUtN7/TK5mp08zEMqk9So8kKr1qjzCbDKVqZ27dc19n3zxdGMhw1/otoVhbeguu7lWir3LSTesCWjacs+v4A9SBG5zuey04vo/5NRZzWXtEef/8QBphVUKqsA8cyQezOvdek2Uqxb7AxkRzUTaoh1u1iGs/b82nVRiFDrUgptRIrFRqx5V0F1sMzasMxjXCah/patmNlaXlECQZ/I3OFE78DvHMdP55an+fAoX0yBEmO0NVRf5mbwLXa2IgMOn1eBsPnx1sC3cJRjEFhTDyxOMpp23hUhz5auckZS4d3tN3839VYkomjvSrTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvdwvZ+Qi5T/SWRyq9Kzvy24gt7k3oZfH23EXDHAxNo=;
 b=PKdAgV3hhAJ4prEXzJTzRH4T9HaJHiLu0EMyOGLARH4aWRkS2spgr/3svn/8jpQKZHAReJdAQOVoXJa1C98V67gGIs+rglTYBqGhXDkwJl3a5lBrvlx/uwy7urN7xkIJI/Htj/YfXqfFBQ6tthkXtzB27SBHlGTGl0mJXSvdNWD9tL1Ezw9zqwh3ZdFpiYoRN+U5d/OGwq9EcrjJPLwwEdCQW7pdrpoeDoCym7dcGsu4ukRW7UVyJQmitILCD28R+EX/GJxXIP4Ojrrmftmu6YOMNMyuaDUAfpb1C4KP2wPclmNjs1bwbuJo5FdqWbZv/OQzRIYAThVscdWWS2D9/g==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SN7PR02MB9302.namprd02.prod.outlook.com (2603:10b6:806:34d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 07:28:01 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 07:28:01 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com" <ping@khushitshah.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
Thread-Index: AQHdScVuCsCn7BcrT0iSyROZkWWAg7b+zTCAgAEWaACAAAYOAIAAAoCA
Date: Fri, 16 Oct 2026 07:28:01 +0000
Message-ID: <0408E14A-28F0-41A4-9403-96ED09B29E59@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-24-khushit.shah@nutanix.com>
 <543a8f0a-bd66-4c13-8117-07f069a754d8@redhat.com>
 <95CBB54C-21CB-4594-8EA4-9C596ADB65EE@nutanix.com>
 <88da51b4-bead-4446-8f33-d77ff605b59a@redhat.com>
In-Reply-To: <88da51b4-bead-4446-8f33-d77ff605b59a@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SN7PR02MB9302:EE_
x-ms-office365-filtering-correlation-id: dbfba04f-7a27-48ad-f88f-08df2b57025f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|260925021911599003|38070700021|56012099006|261009223027099003|4143699003|10067099003|18002099003|3023799007|22082099003|6133799003|260925022911599003|260925021311599003;
x-microsoft-antispam-message-info:
 F8aPVVoRKP9q8iRSgpQgfinO7Jx0LnciJwPJTPK/TxWKulwOJvun81C9kxytynKMLet7vXFP1eYnk33p5BN1t32AG4urzbj1Q8BaI9uY6nD6SqoHSScWm+C6fEonkhi89/foCtY4gYABcUrJFcbS3P9b4xNLnXm2S5R/C7FKDzd3SfEfwUIyeguqYq0Vjng/pdAD+Pibs3ZV5Ahx4n77Z52GYP+dbHCp71DYs1eWxEQSPj0OCDThoLlb3SoVwNlOK2MJSS6OUbr7rJz5jq4SlewGAKB0yT6pk9jlxU+lY31tJiDqPDgW4oRK1AMp5mQrcpgA8iBA3EgLINEUdrZLuvSv4bm4ZbzmASCfO1a7n05Y/po9eZGZAWZ75kDNjhzZDNlQ+D9w8nijWnnl4gfQLcyauc/pINoSFKx0OKQKYZ8NZconUw04HM3XvYbh5MB9f47ypCy0xwOCmU+3sbLIGQ4M3u7auL9buTkjiAkJ4BNkOVTBmuwgIij1fBdFcBJvuGyFFnlYuuTUfaVPY5m45hEZ3VgLEIv7RQMmKJArSWyiWsq4eLDNVAz8F/g02Sudgg8MvHpCCY/pljiDs+2PCU5Eh17itXpOUroCAfKbi2qr+Fr53ULqnMYPXQppZCytVkLWgSitY99V98my0/ho5tLCLqroNLLYpsGw5MrBb4D2jFFv4IIzyCXW52UHAKvkQKaPwcJLtDPQuEISiasNg8XUa6UneuFK0BRYBfEqYY8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(260925021911599003)(38070700021)(56012099006)(261009223027099003)(4143699003)(10067099003)(18002099003)(3023799007)(22082099003)(6133799003)(260925022911599003)(260925021311599003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2xpNGJUempnOG4yNmVYR0NzYjgyR3FSd1ZJVDFCc0FoTXJzazNIM20wRkpX?=
 =?utf-8?B?SzR2dHNtUE1LMFUzczE4YlM4MmVpeHE4OXFJR2JPaU15Um9hYkxwWFB4OElJ?=
 =?utf-8?B?MEp5dEJ0N1pvMGFjQTczcVdtNUp6YU9DZEdPU2xzL3FBTkExRkdpS1FrZWVh?=
 =?utf-8?B?d2tQQzJQVDRFUE1yMjdobjd4WlhqbWFTY3Q2Z3lTVWpzdzlRZUFmTFJCeHI2?=
 =?utf-8?B?Ny9hak1MMFZUWGVUbnRqTHErRWJXaEFBaUdDYVV3U1lhVG1ScjZjS1JQS0Fy?=
 =?utf-8?B?RVE5VjRYV2w1eHlvYmMvNk1MSnhRK1k0VmYwUWtsLzM5MEVCTlZpV1BGTjh2?=
 =?utf-8?B?b1ZjWHREbXlVcHZHY09iNWhGVXBQRWdzZlRhUjJnY29oRFRWaldSTHp2MHBH?=
 =?utf-8?B?dlE3dTByYTQ3VXp1WndMNXc5SDJESG9SSU5hNXJBbDYrTkRaREUyM2luUkZT?=
 =?utf-8?B?dWlXM0pPKzYxOXJXdi9VeUZJbVNUcGlhaFBFMVRpUlhsS2p1ejRRL3VITHBJ?=
 =?utf-8?B?eU9HN3VtZHpDMzlrdGRVVGQ1ZVlJK3o5bk5GQUk4TTBXeDVNcVVNdTNVcDlV?=
 =?utf-8?B?K3FzVGV1cnlPdVBMVjUyejZiSHdNeHJXUHZrb0QwRUswWHZGenpDNEpOdGR5?=
 =?utf-8?B?amF6VlZPTS9xOFlIUmo4cTRGWkJQbURYd3RCKzlFekpjU2lLRnR3TXFGN29L?=
 =?utf-8?B?WGE5cngxZkpJSzYvcjVnRS9qZXR1bkl4UHZCdklzaGlUL3NUUXNteG9EV0JT?=
 =?utf-8?B?K2xTM09pL2RYM3J0UnUxS1NNeXAvWkdPYXJBc2hjRFE2Nm5nTDROaWUvN0tD?=
 =?utf-8?B?Vy84L0pIOTg0dSs0bC9TOFBLempKS0gyanlUb0RVeVRpM3hGanRSWitIRDNE?=
 =?utf-8?B?aDJFK0h3eEppd0NJeFJXOWxwWWdvbEp1SWhQeFdTYkFjSGpTVnR4QXBmTFNC?=
 =?utf-8?B?bDVTbmx5UzdFZ216bVJNcHJWdlNLUG9BbjRFT1lLeXdoS0cxNnNrYlFscGd6?=
 =?utf-8?B?UllnZXIwTE9vbTRwcHljZzgrUGpLWVppRm83cVI1eG5uVVVSVDRscUoydXBK?=
 =?utf-8?B?Q0pVQ2Q4YzhaUCttOFIwWkFONWM5Tnk2dC85TVBHSDMzUUFWa1gvYWtodmc0?=
 =?utf-8?B?bWVKbllsczdKYlZPa0VuRzRZNHBkbUx1UmlGbGFsOXZERUVaNW9zN1NPaGNG?=
 =?utf-8?B?UzdQeVBuQW5vZkxIWFVCdXVyQXVyTXN6bXVpSFYrRDVXU3dNNk0ycHZKNEky?=
 =?utf-8?B?UHZWTVRhUXFyTVhWeTB1dWF6Q0w4dGo1SHRDR2pUTVpaTDNRZVR2NmJuMGIy?=
 =?utf-8?B?djVKZU9CdXZpOVZySllKeUR6TFh5ZHZWazRTekhFT2g0dUc2V3ViS3IrRDF3?=
 =?utf-8?B?bmJOZ2hMWkp0MWFuQ1pra0NyU0tIcGJKVHBmVm1BMFQyMHJUaU1YeVVBZzhq?=
 =?utf-8?B?MEk4SmlwWTlLMVNTZW9Rb0hLOEFSQ1VTRFk5ZEl3MHRZRGpmOWdaR3V1L0lG?=
 =?utf-8?B?WFFKY3cxSEtNdXlKUStYN0hQa1BibVA5NXZhWHJVRGpWTWgrZFF6NDE1UTFV?=
 =?utf-8?B?WVZtMmk1ODluRzRRR1RUYWtqb0I5amdLSUo1b09PV2loK1NmbmwvdnRubmU2?=
 =?utf-8?B?V3o4L2RYbS8zWktzbk1SL2YwaU9Zam9aV0VINGtDKzI1SXBmZk5OeWdFQ1JF?=
 =?utf-8?B?eVpQOU8xWTlldnBhQVNOZWUvYVByeDFQWDN0UDM2Y24yNCt4VU1qL29HRld4?=
 =?utf-8?B?VjhEczkwOTZFcHRqU1FoQVU4dHpVSHlsTHovc2xVUTJxa1FVNjhVWXFEdDVl?=
 =?utf-8?B?YlhkU2VVUlI1SEpSalBtUnNkMFNUY2RSelNZdXdwdTY3MHRZQnhGdlNDdHZk?=
 =?utf-8?B?eW54TFU2SDVySFhjNmFqVlFNQ3pUdDdRVGdlNEI3MGVpZkVMbDF5bFdybG4w?=
 =?utf-8?B?NkpWUEtRMkZTMmxrcXF0YkYyNVJYNjZLT1lBWWZleGR0SlVJSFdhZmJLeEU1?=
 =?utf-8?B?cjB4ekV5d0xHUmlaUkFPc0VPQ1krMWpZTU1ZVURHcVpjbkRIdlVkcWNDYzNM?=
 =?utf-8?B?SlVzYTQ1NXhHbUFja0k4eEFoTkRmV1I3SjJKbDRLTEQ5aGkxdkZwd3BOaW42?=
 =?utf-8?B?QzUyL2gyaHBUK1FhNTVlNW41MW9jRWF5dWVlRXZ3Tmt1WDdtUnRDOWJaazQ0?=
 =?utf-8?B?MTZxeVJ5czZJczNRaUZlVmRSdXVNTFRNUU9HZmNLaWNKUkQybHA1YmovUEJu?=
 =?utf-8?B?TU5DTUxIaGtVd0hsOEthWUwwMEhVVHBrcmJFejFCSmlhRDZxbExXcmE0WUpI?=
 =?utf-8?B?aVMrR29XSHlVWTVUdXowaTRzTG9ETjBnQXZ2M2czSVVKVU1vR0ZGWStOWXVM?=
 =?utf-8?Q?DZNPmwCBx1JscZ/g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8234C02D954EDF4A919D90E8ECECFBE2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	quwyD/SMd06a1/G8c02IvAX1zCnqf+D0ik4+kdO8tRPtcKyspnVdc8YQPxRYUx1Ttv8ot9qHQKpycWrgO52Ls0ChD3SXe4Qhs1stx3/6BULCT4aSg9fRed7Z8O/XpinoYBVk4aD5GAm3gIddtE17+WMYpimloumKYey+i3OM3TJYg0wQhq20/HOjDTuC8Jmjs0uRWnxWFncDXFAOClmXoHrV7JMCP8bm5hMKL/qLyIvzst7Mq/+VwXjY7ojdYUZ72pKx0BQOpDFn2Xi+uFOUgZwONGhHnRk/qZxy3TCk8cUnpFqBpTVqBeKzzj0M+XsQ+MXWr+Vco+mH52gWcMlWKw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbfba04f-7a27-48ad-f88f-08df2b57025f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:28:01.1560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZc/xMw8xW09stsZEC9sbN9fuGmW3V9MDklik+zm036PINVm7yuJv3oU9OWfEr1gLbsmLy1mucLvKP8ilIQNpvF+lKis69vBOdb9fIT4d7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR02MB9302
X-Proofpoint-GUID: icnIzYHChmC8pypgYDL40DK3aAz6W5Wv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX6tI9fsVv2BJ4
 HZkQFMvfw96PJalY9XsClm76PjStQRNZK5bPjmtuQ4lqjvT4yE8G4gPjYbhFQpVAIyuFK7SPVmZ
 Lno10fZ9TU2qrKdTvJ1SW64CXmHtJWvak4NxYroMIxAZ+cRAzTew2AJ4XNWpVTEnEmbKQz8OfNf
 YbCRJ3FI+HxKe3MkgZ/UB92oNyU9sLX2B+HR5COpv4FL9jp8g4LT4Kl8iA6LtgktbfcS53IVVv0
 vwM3l4Q7CNoqnBNanRMJ36qd/wcn/wDBt5wlu1I2KvstRrtfJnBIH/CiL8FF2K47okaja4qD7No
 fGz19j3z1Hvs18YmLQJitilBFsUNn2vNXCUEdaJM1MTfy0xrsB3sw5GBCHjmH0LDjlK0nQaty12
 xwS31cmGfyVONkJanaD3qJjn+NihyqWDCgQE7KjLvBpD7dGSslzUNih+lT8BiJ24VPC4/CSnrrn
 Izm8nZ1HkoDeAjWKcRw==
X-Proofpoint-ORIG-GUID: icnIzYHChmC8pypgYDL40DK3aAz6W5Wv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOSBTYWx0ZWRfX5+8DAjUaDIFs
 2ZdUWKFoVydKXWRL4gaKiFUM4S56VnoMLkIwRny2Cxvv3Sh244GTTy2OH6j2VTh1Ll+8EwlaWR/
 BJv3LMrAgUuoR0GSkXFdIEhSSvpYMJk=
X-Authority-Analysis: v=2.4 cv=C/x8WgP+ c=1 sm=1 tr=0 ts=6ad1d204 cx=c_pps
 a=GcMavwq5JhfCzntw+kKzBA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=FBJhUOI2v-ueEavLb6IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgT2N0IDIwMjYsIGF0IDEyOjQ44oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJT046IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IA0KPiANCj4gT24gMTAvMTYv
MjYgODo1NyBBTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gDQo+Pj4gT24gMTUgT2N0IDIwMjYs
IGF0IDc6NTDigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPiB3cm90ZToN
Cj4+PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPj4+
IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IA0KPj4+IA0KPj4+IE9uIDkvMjEvMjYgMjoz
MiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4+PiBJbnRyb2R1Y2UgdGhlICdxdWVyeS1jcHUt
cHJvcHMtaW5mbycgUU1QIGNvbW1hbmQuIEZvciBlYWNoIENQVSBtb2RlbA0KPj4+PiBwcm9wZXJ0
eSwgaXQgcmVwb3J0cyB0aGUgdHlwZSAoYm9vbGVhbiBvciBudW1iZXIpIGFuZCB0aGUgc2V0IG9m
IHZhbHVlcw0KPj4+PiBzdXBwb3J0ZWQgdW5kZXIgdGhlIGFjdGl2ZSBhY2NlbGVyYXRvciBhbmQg
aG9zdC4NCj4+Pj4gDQo+Pj4+IFRoaXMgaGVscHMgdGhlIG1hbmFnZW1lbnQgc3RhY2sgdG8gZGlz
Y292ZXIgd2hpY2ggdmFsdWVzIGFyZSBzdXBwb3J0ZWQNCj4+Pj4gZm9yIGEgZ2l2ZW4gQ1BVIHBy
b3BlcnR5LiBUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZvciBub24tYm9vbGVhbg0KPj4+
PiBwcm9wZXJ0aWVzLCB3aGVyZSBrbm93aW5nIHRoYXQgdGhlIGhvc3QgaGFzIHZhbHVlICd4JyBk
b2VzIG5vdA0KPj4+PiBpbmhlcmVudGx5IHJldmVhbCB0aGUgZnVsbCByYW5nZSBvZiB2YWxpZCB2
YWx1ZXMgc3VwcG9ydGVkIG9uIHRoZSBob3N0Lg0KPj4+PiBGb3IgZXhhbXBsZSwgYW4gQXJtIGhv
c3Qgd2l0aCBDVFJfRUwwLkwxSXA9MyAoUElQVCkgYWxzbyBhbGxvd3MgMg0KPj4+PiAoVklQVCkg
YnV0IGEgaG9zdCB3aXRoIENUUl9FTDAuTDFJcD0yIGRvZXMgbm90IGFsbG93IENUUl9FTDAuTDFJ
cD0zDQo+Pj4+IGZvciBhIGd1ZXN0Lg0KPj4+PiANCj4+Pj4gRm9yIG51bWVyaWNhbCBwcm9wZXJ0
aWVzLCB0aGUgc3VwcG9ydGVkIHZhbHVlcyBhcmUgZXhwcmVzc2VkIGFzIGEgbGlzdA0KPj4+PiBv
ZiBpbmNsdXNpdmUge21pbiwgbWF4fSByYW5nZXMuIEZvciBib29sZWFuIHByb3BlcnRpZXMsIHRo
ZXkgYXJlDQo+Pj4+IHJlcHJlc2VudGVkIGFzIGEgbGlzdCBvZiB0cnVlL2ZhbHNlIHZhbHVlcy4N
Cj4+Pj4gDQo+Pj4+IFRoZSBjb21tYW5kIGFuZCBpdHMgcmV0dXJuIHR5cGVzIChDcHVQcm9wZXJ0
eVR5cGUsIENwdVByb3BlcnR5SW5mbyBhbmQNCj4+Pj4gZnJpZW5kcykgYXJlIGRlZmluZWQgaW4g
cWFwaS9tYWNoaW5lLmpzb24gcmF0aGVyIHRoYW4gYW4gQXJtLXNwZWNpZmljDQo+Pj4+IHNjaGVt
YSwgc2luY2UgdGhlIGNvbmNlcHQgYXBwbGllcyB0byBvdGhlciB0YXJnZXRzIChlLmcuIHg4Niwg
UklTQy1WKQ0KPj4+PiB0b28uIFRhcmdldHMgdGhhdCBkbyBub3QgaW1wbGVtZW50IGl0IHJldHVy
biBhbiBlcnJvci4NCj4+Pj4gKFRoZSBmb2xsb3dpbmcgY29tbWl0IGltcGxlbWVudHMgdGhlIGNv
bW1hbmQgZm9yIEFybSBLVk0uKQ0KPj4+PiANCj4+Pj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBT
aGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiBxYXBpL21hY2hp
bmUuanNvbiAgICAgICAgICB8IDgyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+Pj4+IHN0dWJzL21lc29uLmJ1aWxkICAgICAgICAgIHwgIDEgKw0KPj4+PiBzdHVicy9x
bXAtY3B1LXByb3BzLWluZm8uYyB8IDEyICsrKysrKw0KPj4+PiB0ZXN0cy9xdGVzdC9xbXAtY21k
LXRlc3QuYyB8ICAxICsNCj4+Pj4gNCBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCspDQo+
Pj4+IGNyZWF0ZSBtb2RlIDEwMDY0NCBzdHVicy9xbXAtY3B1LXByb3BzLWluZm8uYw0KPj4+PiAN
Cj4+Pj4gZGlmZiAtLWdpdCBhL3FhcGkvbWFjaGluZS5qc29uIGIvcWFwaS9tYWNoaW5lLmpzb24N
Cj4+Pj4gaW5kZXggMmQ2M2MxYmFjMy4uNmU2NWJkYWQ4NiAxMDA2NDQNCj4+Pj4gLS0tIGEvcWFw
aS9tYWNoaW5lLmpzb24NCj4+Pj4gKysrIGIvcWFwaS9tYWNoaW5lLmpzb24NCj4+Pj4gQEAgLTIy
OTEsMyArMjI5MSw4NSBAQA0KPj4+PiAjIFNpbmNlOiAxLjINCj4+Pj4gIyMNCj4+Pj4geyAnY29t
bWFuZCc6ICdxdWVyeS1jcHUtZGVmaW5pdGlvbnMnLCAncmV0dXJucyc6IFsnQ3B1RGVmaW5pdGlv
bkluZm8nXSB9DQo+Pj4+ICsNCj4+Pj4gKyMjDQo+Pj4+ICsjIEBDcHVQcm9wZXJ0eVR5cGU6DQo+
Pj4+ICsjDQo+Pj4+ICsjIFRoZSB0eXBlIG9mIGEgQ1BVIG1vZGVsIHByb3BlcnR5Lg0KPj4+PiAr
Iw0KPj4+PiArIyBAYm9vbGVhbjogdGhlIHByb3BlcnR5IGlzIG9mIHR5cGUgYm9vbGVhbi4NCj4+
Pj4gKyMNCj4+Pj4gKyMgQG51bWJlcjogdGhlIHByb3BlcnR5IGlzIG9mIHR5cGUgdW5zaWduZWQg
aW50ZWdlci4NCj4+Pj4gKyMNCj4+Pj4gKyMgU2luY2U6IDExLjINCj4+Pj4gKyMjDQo+Pj4+ICt7
ICdlbnVtJzogJ0NwdVByb3BlcnR5VHlwZScsDQo+Pj4+ICsgICdkYXRhJzogWyAnYm9vbGVhbics
ICdudW1iZXInIF0gfQ0KPj4+IHdoeSBkbyB3ZSBzdGlsbCBuZWVkIHRoZSBib29sZWFuIHR5cGU/
IENhbid0IHdlIHNpbXBsaWZ5IGFuZCBzdGljayB0bw0KPj4+IHVpbnQ2NF90IGZvciBhbGwgU1lT
UkVHIHByb3BzPw0KPj4gSGkgRXJpYywNCj4+IA0KPj4gQm9vbHMgdG8gc3VwcG9ydCBleGlzdGlu
ZyBwcm9wZXJ0aWVzIChzdmUsIHBhdXRoLCBldGPigKYpIGFyZSBib29sZWFucy4NCj4+Pj4gKw0K
Pj4+PiArIyMNCj4+Pj4gKyMgQENwdVByb3BlcnR5VmFsdWVSYW5nZToNCj4+Pj4gKyMNCj4+Pj4g
KyMgQW4gaW5jbHVzaXZlIHJhbmdlIG9mIG51bWVyaWMgdmFsdWVzIHN1cHBvcnRlZCBmb3IgdGhl
IHByb3BlcnR5Lg0KPj4+PiArIw0KPj4+PiArIyBAbWluOiB0aGUgbG93ZXN0IHN1cHBvcnRlZCB2
YWx1ZS4NCj4+Pj4gKyMNCj4+Pj4gKyMgQG1heDogdGhlIGhpZ2hlc3Qgc3VwcG9ydGVkIHZhbHVl
Lg0KPj4+PiArIw0KPj4+PiArIyBTaW5jZTogMTEuMg0KPj4+PiArIyMNCj4+Pj4gK3sgJ3N0cnVj
dCc6ICdDcHVQcm9wZXJ0eVZhbHVlUmFuZ2UnLA0KPj4+PiArICAnZGF0YSc6IHsgJ21pbic6ICd1
aW50NjQnLCAnbWF4JzogJ3VpbnQ2NCcgfSB9DQo+Pj4+ICsNCj4+Pj4gKyMjDQo+Pj4+ICsjIEBD
cHVQcm9wZXJ0eUluZm9Cb29sZWFuOg0KPj4+PiArIw0KPj4+PiArIyBAc3VwcG9ydGVkLXZhbHVl
czogbGlzdCBvZiBib29sZWFuIHZhbHVlcyBzdXBwb3J0ZWQgZm9yIHRoZQ0KPj4+PiArIyAgICAg
cHJvcGVydHkuDQo+Pj4+ICsjDQo+Pj4+ICsjIFNpbmNlOiAxMS4yDQo+Pj4+ICsjIw0KPj4+PiAr
eyAnc3RydWN0JzogJ0NwdVByb3BlcnR5SW5mb0Jvb2xlYW4nLA0KPj4+PiArICAnZGF0YSc6IHsg
J3N1cHBvcnRlZC12YWx1ZXMnOiBbJ2Jvb2wnXSB9IH0NCj4+PiB3aHkgY2FuJ3QgeW91IG1vZGVs
IHRoYXQgd2l0aCBhIHJhbmdlIHRvbz8NCj4+IEnigJltIHNvcnJ5IEkgZGlkbuKAmXQgZ2V0IHlv
dS4NCj4gDQo+IEkgbWVhbnQgSSBkb24ndCByZWFsbHkgdW5kZXJzdGFuZCB3aHkgd2UgbmVlZCB0
byBib3RoZXIgYWJvdXQgYm9vbGVhbg0KPiBwcm9wcyBhbmQgd2h5IHdlIGRvbid0IGp1c3QgbW9k
ZWwgZXZlcnl0aGluZyB3aXRoIGxpc3Qgb2YgdWludDY0IHJhbmdlcy4NCj4gSSB3YXMgcHV6emxl
ZCBieSAibGlzdCBvZiBib29sZWFuIHZhbHVlcyBzdXBwb3J0ZWQgZm9yIHRoZSBwcm9wZXJ0eeKA
nQ0KQm9vbGVhbiBwcm9wZXJ0aWVzIGFyZSBmb3IgdGhlIHNha2Ugb2YgY29tcGxldGVuZXNzLg0K
DQpUaGV5IHdpbGwgY292ZXIsIHN2ZSwgcGF1dGgsIHN2ZU5OTk4sIGFhcmNoNjQgZXRj4oCmLiBF
eGNlcHQgYWFyY2g2NCwNCmFsbCBvZiB0aGVtIGFyZSBtb2RlbGxlZCBhczogSWYgaG9zdHMgc3Vw
cG9ydHMgdHJ1ZSwgaXQgYWxzbyBzdXBwb3J0cw0KZmFsc2UuDQoNClNvIHRoZSBvdXRwdXQgb2Yg
dGhpcyBxbXAgY29tbWFuZCBmb3IgYSBib29sZWFuIHByb3BlcnR5IGNhbiBiZToNClt0cnVlXSwg
W2ZhbHNlXSwgW3RydWUsIGZhbHNlXQ0KDQpJIGhvcGUgdGhpcyBjbGVhcnMgdGhlIGNvbmZ1c2lv
bi4NCg0KVGhhbmtzLA0KS2h1c2hpdA0KDQo+IEVyaWMNCj4+IA0KPj4gVGhhbmtzLA0KPj4gS2h1
c2hpdA0KPj4+PiArDQo+Pj4+ICsjIw0KPj4+PiArIyBAQ3B1UHJvcGVydHlJbmZvTnVtYmVyOg0K
Pj4+PiArIw0KPj4+PiArIyBAc3VwcG9ydGVkLXZhbHVlczogbGlzdCBvZiBudW1lcmljIHZhbHVl
IHJhbmdlcyBzdXBwb3J0ZWQNCj4+Pj4gKyMgICAgIGZvciB0aGUgcHJvcGVydHkuDQo+Pj4+ICsj
DQo+Pj4+ICsjIFNpbmNlOiAxMS4yDQo+Pj4+ICsjIw0KPj4+PiAreyAnc3RydWN0JzogJ0NwdVBy
b3BlcnR5SW5mb051bWJlcicsDQo+Pj4+ICsgICdkYXRhJzogeyAnc3VwcG9ydGVkLXZhbHVlcyc6
IFsnQ3B1UHJvcGVydHlWYWx1ZVJhbmdlJ10gfSB9DQo+Pj4+ICsNCj4+Pj4gKyMjDQo+Pj4+ICsj
IEBDcHVQcm9wZXJ0eUluZm86DQo+Pj4+ICsjDQo+Pj4+ICsjIEluZm9ybWF0aW9uIGFib3V0IGEg
c2luZ2xlIENQVSBtb2RlbCBwcm9wZXJ0eSwgaW5jbHVkaW5nIHRoZSB2YWx1ZXMNCj4+Pj4gKyMg
dGhlIGhvc3QvYWNjZWxlcmF0b3Igc3VwcG9ydHMgZm9yIGl0Lg0KPj4+PiArIw0KPj4+PiArIyBA
bmFtZTogdGhlIG5hbWUgb2YgdGhlIHByb3BlcnR5Lg0KPj4+PiArIw0KPj4+PiArIyBAdHlwZTog
dGhlIHR5cGUgb2YgdGhlIHByb3BlcnR5LCB3aGljaCBzZWxlY3RzIHRoZSBsYXlvdXQgb2YNCj4+
Pj4gKyMgICAgIEBzdXBwb3J0ZWQtdmFsdWVzLg0KPj4+PiArIw0KPj4+PiArIyBTaW5jZTogMTEu
Mg0KPj4+PiArIyMNCj4+Pj4gK3sgJ3VuaW9uJzogJ0NwdVByb3BlcnR5SW5mbycsDQo+Pj4+ICsg
ICdiYXNlJzogeyAnbmFtZSc6ICdzdHInLA0KPj4+PiArICAgICAgICAgICAgJ3R5cGUnOiAnQ3B1
UHJvcGVydHlUeXBlJyB9LA0KPj4+PiArICAnZGlzY3JpbWluYXRvcic6ICd0eXBlJywNCj4+Pj4g
KyAgJ2RhdGEnOiB7ICdib29sZWFuJzogJ0NwdVByb3BlcnR5SW5mb0Jvb2xlYW4nLA0KPj4+PiAr
ICAgICAgICAgICAgJ251bWJlcic6ICdDcHVQcm9wZXJ0eUluZm9OdW1iZXInIH0gfQ0KPj4+PiAr
DQo+Pj4+ICsjIw0KPj4+PiArIyBAcXVlcnktY3B1LXByb3BzLWluZm86DQo+Pj4+ICsjDQo+Pj4+
ICsjIFJldHVybiBpbmZvcm1hdGlvbiBhYm91dCB0aGUgQ1BVIG1vZGVsIHByb3BlcnRpZXMuICBG
b3IgZWFjaA0KPj4+PiArIyBwcm9wZXJ0eSBpdCByZXBvcnRzIHRoZSB2YWx1ZXMgc3VwcG9ydGVk
IHVuZGVyIHRoZSBhY3RpdmUNCj4+Pj4gKyMgYWNjZWxlcmF0b3IgYW5kIGhvc3QuDQo+Pj4+ICsj
DQo+Pj4+ICsjIFNpbmNlOiAxMS4yDQo+Pj4+ICsjIw0KPj4+PiAreyAnY29tbWFuZCc6ICdxdWVy
eS1jcHUtcHJvcHMtaW5mbycsDQo+Pj4+ICsgICdyZXR1cm5zJzogWydDcHVQcm9wZXJ0eUluZm8n
XSB9DQo+Pj4+IGRpZmYgLS1naXQgYS9zdHVicy9tZXNvbi5idWlsZCBiL3N0dWJzL21lc29uLmJ1
aWxkDQo+Pj4+IGluZGV4IDNiMmYyNjgwYjEuLjNiYjQwMjhiYWIgMTAwNjQ0DQo+Pj4+IC0tLSBh
L3N0dWJzL21lc29uLmJ1aWxkDQo+Pj4+ICsrKyBiL3N0dWJzL21lc29uLmJ1aWxkDQo+Pj4+IEBA
IC04Myw2ICs4Myw3IEBAIGlmIGhhdmVfc3lzdGVtDQo+Pj4+ICBzdHViX3NzLmFkZChmaWxlcygn
cW1wLWkzODYtc2d4LmMnKSkNCj4+Pj4gIHN0dWJfc3MuYWRkKGZpbGVzKCdxbXAtaTM4Ni14ZW4u
YycpKQ0KPj4+PiAgc3R1Yl9zcy5hZGQoZmlsZXMoJ3FtcC1jcHUuYycpKQ0KPj4+PiArICBzdHVi
X3NzLmFkZChmaWxlcygncW1wLWNwdS1wcm9wcy1pbmZvLmMnKSkNCj4+Pj4gIHN0dWJfc3MuYWRk
KGZpbGVzKCdxbXAtY3B1LXMzOTB4LmMnKSkNCj4+Pj4gIHN0dWJfc3MuYWRkKGZpbGVzKCdxbXAt
Y3B1LXMzOTB4LWt2bS5jJykpDQo+Pj4+ICBzdHViX3NzLmFkZChmaWxlcygnaG1wLWNtZC1pbmZv
X21lbS5jJykpDQo+Pj4+IGRpZmYgLS1naXQgYS9zdHVicy9xbXAtY3B1LXByb3BzLWluZm8uYyBi
L3N0dWJzL3FtcC1jcHUtcHJvcHMtaW5mby5jDQo+Pj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+
Pj4+IGluZGV4IDAwMDAwMDAwMDAuLjM2YjA1MzBiOTgNCj4+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+
PiArKysgYi9zdHVicy9xbXAtY3B1LXByb3BzLWluZm8uYw0KPj4+PiBAQCAtMCwwICsxLDEyIEBA
DQo+Pj4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlciAqLw0K
Pj4+PiArDQo+Pj4+ICsjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0KPj4+PiArI2luY2x1ZGUgInFh
cGkvZXJyb3IuaCINCj4+Pj4gKyNpbmNsdWRlICJxYXBpL3FhcGktY29tbWFuZHMtbWFjaGluZS5o
Ig0KPj4+PiArDQo+Pj4+ICtDcHVQcm9wZXJ0eUluZm9MaXN0ICoNCj4+Pj4gK3FtcF9xdWVyeV9j
cHVfcHJvcHNfaW5mbyhFcnJvciAqKmVycnApDQo+Pj4+ICt7DQo+Pj4+ICsgICAgZXJyb3Jfc2V0
ZyhlcnJwLCAicXVlcnktY3B1LXByb3BzLWluZm8gbm90IHN1cHBvcnRlZCBvbiB0aGlzIHRhcmdl
dCIpOw0KPj4+PiArICAgIHJldHVybiBOVUxMOw0KPj4+PiArfQ0KPj4+PiBkaWZmIC0tZ2l0IGEv
dGVzdHMvcXRlc3QvcW1wLWNtZC10ZXN0LmMgYi90ZXN0cy9xdGVzdC9xbXAtY21kLXRlc3QuYw0K
Pj4+PiBpbmRleCAyNzlhOGY1NjE0Li4yYzI1ZGJkOGNiIDEwMDY0NA0KPj4+PiAtLS0gYS90ZXN0
cy9xdGVzdC9xbXAtY21kLXRlc3QuYw0KPj4+PiArKysgYi90ZXN0cy9xdGVzdC9xbXAtY21kLXRl
c3QuYw0KPj4+PiBAQCAtMTAwLDYgKzEwMCw3IEBAIHN0YXRpYyBib29sIHF1ZXJ5X2lzX2lnbm9y
ZWQoY29uc3QgY2hhciAqY21kKQ0KPj4+PiAgICAgICAgImFkZC1mZCIsDQo+Pj4+ICAgICAgICAv
KiBTdWNjZXNzIGRlcGVuZHMgb24gdGFyZ2V0IGFyY2g6ICovDQo+Pj4+ICAgICAgICAicXVlcnkt
Y3B1LWRlZmluaXRpb25zIiwgIC8qIGFybSwgaTM4NiwgcHBjLCBzMzkweCAqLw0KPj4+PiArICAg
ICAgICAicXVlcnktY3B1LXByb3BzLWluZm8iLCAvKiBhcm0gKyBrdm0gKi8NCj4+Pj4gICAgICAg
ICJxdWVyeS1naWMtY2FwYWJpbGl0aWVzIiwgLyogYXJtICovDQo+Pj4+ICAgICAgICAicXVlcnkt
czM5MHgtY3B1LXBvbGFyaXphdGlvbiIsIC8qIHMzOTB4ICovDQo+Pj4+ICAgICAgICAvKiBTdWNj
ZXNzIGRlcGVuZHMgb24gdGFyZ2V0LXNwZWNpZmljIGJ1aWxkIGNvbmZpZ3VyYXRpb246ICovDQo+
Pj4gVGhhbmtzDQo+Pj4gDQo+Pj4gRXJpYw0KDQoNCg==
