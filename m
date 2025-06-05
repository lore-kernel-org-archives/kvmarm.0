Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA5F20A5D6
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 09:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749116538; cv=fail; b=jt+NulrhpndPPP/vVHPmSgPx+eM9YyObHHUssvD5lnbIitiHnNb+fL5YolkxAPlQunUo6pdXWJvh9WiJFfJLDlfYm4um8cuE/m8pcIl7pVFPMVdMt4Ctmx9gfg0hTrELsEut5aHsEkRt/AsDXKS8HPVUWhrHxy/JaYjitY6O/ZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749116538; c=relaxed/simple;
	bh=P2PtWBA494Z54whBkAy0RtVaHiyY+dOZO8WfdJJ6y3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LNhO5QbeAuE3hyKgqBf3co202t7Nauae6l40PJ22QzFgh2dKYJyfl5QqZ82RjDE/xDdrJrBeNVjgNazadzDiudFsi3ic0Ie3g7JbPAI+8WozHVGcSRsHO7uSf9NS/qUE5uyvWBgSvMxaokNGEXIie+Y6mab8W+0W6n+Mj258qOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fqIZT7b1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DGmrOH6w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqIZT7b1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DGmrOH6w"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5554vCtU021326;
	Thu, 5 Jun 2025 09:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P2PtWBA494Z54whBkAy0RtVaHiyY+dOZO8WfdJJ6y3k=; b=
	fqIZT7b1dgLtUCbPVmup3p8xgnliO64x3AS1ymyNWihE7+IfMre9L3g0B9kkZB7O
	AWH9elRj2pJXiII3T0MW7GgTeQ0MOScL0eg0r7T/yGuZnhZTMIvvLCz+PTTot9LX
	nTFXrMbhBKaM1GSNEKXUjWc8HBKOxdEEkLyhkGobqumHFWhC1flQpN/VpsYBc4v9
	j9dpuFUm1W2k7VUkANIqOnqzf8S09oR9k5QSHJ9r6IrgTIEwTuqg4hWEFQ78ql/l
	SU1GhVrfVbF3K6XdjCpTVd5OAesJglHs9GTYoYEeCKwslHYaPmT0KX24rien6Zya
	LZQQEtdnakmn9brqZiX65Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahdwg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 09:40:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5557q7jk034815;
	Thu, 5 Jun 2025 09:40:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c3y9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 09:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIF/OVWX4D2ar2sk3JTwu/FTNzdcCUfPUcRNPn5uahoQuQKxMD47xGjnEKoRbiESXdcTXyDgdmWYkmXoknRT8BtFL8lx63ExD75x0iWze9uQCfXG28qxQjTjzSEuq9h+a7T7PL0gDdrf4V8ZN0YWuwKNjdI44otRqzc3raTbuaiM+VfSfs2yrVmXFlBuoEi/eIlntE5BFEEuJchnCHVxBHK50LWwwj46VFz1wsAlPT6LYRai5+d+YhtaafdUHhjJFNBlf4o4+AIXYZiYgXMODrVLg8QNNWcLTsGTOWOoIRiv9Cu4uWU3KrBtynI3nofLH+LMx4ZqG5c0eWJTnF00Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2PtWBA494Z54whBkAy0RtVaHiyY+dOZO8WfdJJ6y3k=;
 b=IzmsTwEcpvTTm7dvI7Cu1dgGjryLzDF6AyoW/WTOMzx9/zUnxf8RErE3GDX/39un+Otoq4ISDvIku7RTrxvQVhfgSUcSi+m3nwbOHiAXxE3buYFy7c2UUUTTQHKZrPM+GbCWcvldDEh23LIebPXp/BwVJYPcoaFwZHh4dcnEV5XPVONNzJZbJLOZdkGzBsKfSVi9x84SR8JTzINKb7gbs4jAWaEvbV+7Xad7cOMpuloipCeX0VhUhrxhMMol28Xq0xjc/VIQ97egaMQ73Yt/QjUwofqDNmH8A2JUTtOSUpSA/8gRg7L55mgnUWiVVfAeU+fH0raII0ded/q9t5Xklw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2PtWBA494Z54whBkAy0RtVaHiyY+dOZO8WfdJJ6y3k=;
 b=DGmrOH6w563rES/qBJ6gaznJs3+p4sGqerU2667M2lgXEMbOdB79L/nEyWTznphbd4t45maddKudAicDaluvuk2M/JsI1AsaVz6tmiKY0xpohPB0gKwIdPAXx0ScQ+S9cBbp3HgykiE5Xk6l9Ma0AULOLddH1ObE0F1Ct0yUjNw=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CH4PR10MB8123.namprd10.prod.outlook.com (2603:10b6:610:23f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Thu, 5 Jun
 2025 09:40:47 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8813.021; Thu, 5 Jun 2025
 09:40:47 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Thread-Topic: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Thread-Index: AQHb1FZzymAUnIIEoUuFA1EqPZKnrrPy04qAgABLewCAAAnBgIAAM8mAgAD2ioA=
Date: Thu, 5 Jun 2025 09:40:46 +0000
Message-ID: <2DFD74B1-4D2A-46FF-89DA-0178BA93A82A@oracle.com>
References: <20250603070824.1192795-1-maz@kernel.org>
 <2264D21F-C28B-4523-9132-A53EB8ABFCF0@oracle.com>
 <87bjr3edsr.wl-maz@kernel.org>
 <AD26CFBA-FE32-4C7D-A75B-53729B70C591@oracle.com>
 <877c1re3lo.wl-maz@kernel.org>
In-Reply-To: <877c1re3lo.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CH4PR10MB8123:EE_
x-ms-office365-filtering-correlation-id: 10fbe84f-e597-4e6a-17e9-08dda4150cad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eGFVZTVDTERNaFRTeVVCY0NsU2xvOXhueDRlMkVUUjEzTkpCV1h2YXlpNVpR?=
 =?utf-8?B?Z1hyY2ZZZ2ZQU2sxb3V3Q29GV3QxUUdzdDNvM0V0dTF1U1Z1cnlza2tuZVJz?=
 =?utf-8?B?S2FEZWU3Q3pXOEZaVkJKMm1tMmNXa3M4UUc1RVMxOHc1MS90eEttYlcrU2du?=
 =?utf-8?B?NGttdlhla05QQWpFMWxoR0xvdzlyQ0tCbDYwdVlGTGVGR250NUFuQk5vZmxO?=
 =?utf-8?B?RWNmM2FlOC9udVpic29ML3FzR0JCcHNaK000c3Z0SWJHWGNmdk5EVnV0dWlL?=
 =?utf-8?B?ckhMSkVpVU1jVGlDQXhZMm1mdXcxVklJOEdlK2tVeXl1RmJiN1c4T0FNZXVy?=
 =?utf-8?B?R3FUUzZTa0R3bDQ5U3JJbFlqdWZ3YlJuYUlPUWVuOVhDL2xXL0FPTERrTVNE?=
 =?utf-8?B?d0xid3ZRWWRiZ3M5Um8zTVdla1dSNVVSM0c1UkF5NlRrYkJraVBPY0oxa3Nh?=
 =?utf-8?B?WDBiMzJQR1pBdHBQbE9ZVjNzeGczVnR3Z1Nud2h5eDZPREFSN2Y1SG42UThp?=
 =?utf-8?B?UkZKckpVQWxnVlJSVXE5QWpYRlNUamt0T29LZjBraG51ajYvMERCeG9GdlpB?=
 =?utf-8?B?bzJPYmpSYzhUOEZxeHFPdlo1bWJNTjNqdm5yL3EwVlVXUGNzVDhSdVlJUmE1?=
 =?utf-8?B?R3orZjM4VUZoY2J5NzJoWnl5dU5OZG8rbjAzQklDdDRNQnFQMERWQWZMdUo1?=
 =?utf-8?B?RFNUZW90YVAzK2FvcWxaejZMbjJJNmFuVElJc2l4SXNSLzk5NUh4Wm5HdmZj?=
 =?utf-8?B?dHFEUlRaMUNzMHNUb1VtRlJhalpjV1h1RXZHQkVsZkhaWjVYMFRpWWtDSG0r?=
 =?utf-8?B?eGpDNlhZc1I4S0x3aGFxOW16QXdmQmxpbUYwL1JhejY5OVlKcVhOUUt5QklU?=
 =?utf-8?B?V0V3WTdlV3NDSTlMYjBrOUNtNVBNR3FUNE5tYUlsKzZKQmE4V0VWVkk4ckdz?=
 =?utf-8?B?OFdsek1ocE4vWWhrVmZuQXVVRHU5THgwclRlZkFNUGRiODVwY29ZTkpDejF4?=
 =?utf-8?B?Q0w0U2hkVUNsMGJ2ZldMdDBIc1V0OEZCV3pWUW0xMjJuTFl3U25pVklYK25W?=
 =?utf-8?B?K3Bya3ExaVl6R1hoL3FpczdEVDNRWnppMEp0OUNWRnY4aFl0OWhRTGtwV054?=
 =?utf-8?B?bkRYazdHcDNFVkdOOHo0dStsdjViYy84SEJrNWNBc0FmK1RjZ0VTUEd4OUt0?=
 =?utf-8?B?SDJiVHh5Z0oxSVFtbFVzRVlvVUVsRVpVeHVhMVFqRnYrUjhFS20rRzdaL0x6?=
 =?utf-8?B?SWRHSndtZFoySEIrMmdjTU5SRURYN1lDRzM0WHQrYTB5a2NMcXpkUm1WTnNi?=
 =?utf-8?B?WkV2QTkrUE5GT1NNVElNeTZPcE5wY0M3V2FLQ3o5bHNFcUdXYm05K3p5OU5Q?=
 =?utf-8?B?SmhPQ29aVUxEY21QaWdscGtWU056TVB6MzZzbEtrZlhRUG9sRGdLaVpvWkFu?=
 =?utf-8?B?M3BIck5lc1RCcjFIMThoQk1Za2hKV0g3STlleTFLZHZmY0tUcVJqSGRINGdE?=
 =?utf-8?B?dmxxSkxQYkFmUURKaTR6UTFhUGNUQUtQcGhSdkNhUUVydHhrKzB5QU5sOHNi?=
 =?utf-8?B?N1Yzc3JLam8ycjZTUW41WXU5R2huMUxuaGVKdnhsb1ROQTB0dlpFYys0RGpV?=
 =?utf-8?B?Nm1RNWtwNy9iUXppYzA1azZtdVpkL0tUN0RvTmpvR1ZERk5mVlRhdys0UHJo?=
 =?utf-8?B?T25jbmExbHFydzJoMzVhMDV5OU1wbHVYQjRhZDQ5Y1QveVEvTTRvcEhDWWZN?=
 =?utf-8?B?WGUrTmIxN0Y4S29ISEpaOWx5VTZKY2NDWWZBa2NYNmZyMC9CSlVWOEdORnNQ?=
 =?utf-8?B?WG1yTUloaEJGZ3RMYW9wYmtXTGJEWjM0L3diaDQzemdSak5zbnZ4L2lCMDFi?=
 =?utf-8?B?ZzcxL0JuTVVRb1pqaUJHNHJ4OXI3SjVlc2lOeUIzMVgwb3VkSHVFN2pKVEdN?=
 =?utf-8?B?V2duV0JJVCtJcGVlTEhrZjZHSVZlR0NmZ1JCdDFialp1RXFOM016dTJVbzBO?=
 =?utf-8?Q?HVC2Y9PHBJnZyvP/dbjqg708KOj4dU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NXlxSHdGOTRFTXBySFJuVnFlRFJDYTlTbWhQOEZSUVNoRFhGTy9PbjEreTlH?=
 =?utf-8?B?REV6MStuTysxSTgxMk44Q2EzQ1l0dzh3eDNMY3FQVTJyWFpTZ0dBbnlMMlFD?=
 =?utf-8?B?RWp4ZkNJWjZQKzE0MmtlZDBTbklPTHBZa3UzcTljaVRpN3RybjJUZk5RNkhL?=
 =?utf-8?B?ZWg3WnJaY3VGSHVuYmwza1I1dFNXN1pqNjQ3Q3YxbFQyZmZPd0xVM0lYZnFm?=
 =?utf-8?B?TG5NN2FJT2cybzRlVktnTVZSK09rVk0vanZmZWd0ZWM2MEw1akNwUjhHWEhu?=
 =?utf-8?B?QlRFOGp3UFR5OEt6cjNhdm9EaXVwcnN1KzVFOFF6RzlNNGg2TkVScmlpeDNN?=
 =?utf-8?B?M1NWL1hrOWVaSHJaeWRvQjViNklrc1FrWnIrT245MzVrTFIwcDNOU3R5bzhj?=
 =?utf-8?B?Y2xHVXVGQTR5cjBYSGJJai9JOVh6bVhOeloxKzBYS084cEc4ellwdkJTa2py?=
 =?utf-8?B?VDAweWpBVmQ1ZXBVa09KcTR4WElzNFNxNk9qM2RzNVQ4VkNNZUFwMzFrcEdX?=
 =?utf-8?B?dHBWQ0gzWmltZXkwbjdYaWVQdHR0M25ONWJXOGlJTUdjcXhnU3Y1eTRkYk1r?=
 =?utf-8?B?YmZSQ2J0bEtZTUIvd2lvMjhBZDNNMDZnOTRHaVh2eXRrL1FGWG1aTnZ5d3pa?=
 =?utf-8?B?aDB5b1kraHlZdmRmYjhjam4xZk1yK1cvRnFXbm5wNnNvdnJyVDAxYWN0eXVi?=
 =?utf-8?B?Y2hJODhGVFA3ejU2d241ZmFmQ1dwbno1MENDOWE5Wk5rTzl3aGQ5YTcyZ3Jy?=
 =?utf-8?B?cXRnNlY0VkdiSDBqcDNEa3Q1V3o4VStHUk96S2JnZzdlazZiRTc1T0VlQksx?=
 =?utf-8?B?bEcvTU9qOTBHRXhyTmk1a0k2NGNNT29XYjBEbGZQR1RMNzNtSERZWlFwYW9x?=
 =?utf-8?B?N1ZGMlEzRnBEQWE5UUI1Z0pIUTJmU3ZncU9KelJWakFUNTZGUzQwcytBR2R1?=
 =?utf-8?B?dmhUeGlTQ0lnaGNLQ2JIVWtuMVprSHdZMk5ad01Nc3NibWNCUVRyU1M4cEwr?=
 =?utf-8?B?WDJpNjJqYUVRVHJHZTU1MXNhWHVOa0UrZlFKSVQ1YkIvNE5uRll3WEtDTWxB?=
 =?utf-8?B?MmhITGZ6R2NIdGxpQXorT002S3krbUxsNEYvUDBZOUVTYnBWWkZ2MEpmL3RO?=
 =?utf-8?B?ck9JR2JlQWpIUS9kTDNadnlCMi95M1pUUTBhR0tHYmtmWDU3TU12dzBHbncz?=
 =?utf-8?B?cEplaUU2eUU2SEI1UzhWSEhmV3FpbG5kVm1BemFERkE0NHBCcU82NnBKTWRj?=
 =?utf-8?B?T3RveFJ0NTFtNFo2WnJMT1NkNUFyRjJ6QTZxdEF5aFFqeWo2SjVFVkl1ZjBy?=
 =?utf-8?B?VlFiK240S0NhNC9yV1dxamt6QklKSGsxeDc5c3crMFdMSFF0UEJLYnVTVnB2?=
 =?utf-8?B?aVBUa1NhejFmQU9TT1F1SWRmMVlFN29VUXNuMStSWis0UkhEUWtEdkdJcHF4?=
 =?utf-8?B?RDQ4RkN6TlM5Z2FaT3JaNzZtTHd3Z0pYT1M1Q2RwbWprRXpwZmRFUjNHNU8y?=
 =?utf-8?B?d3FBV0pZN1Z5YUlZbUlVMmphZWNxOVRjQ1krMXRaNkVXR253WEtKTkJOS204?=
 =?utf-8?B?bG1SWFZLcjVCbWM4RjA3TzRPVzFpSVpQU2hLRUJ4RnBjUTFrUUhCb0dnOHdM?=
 =?utf-8?B?UUlNYmxuNGhwQVJ0ZFU0N0lWbTMwVXErL1BRRUNPUGIyS2V6Q1ZsTHYyemZR?=
 =?utf-8?B?THdJWHFFYkhDMnFoczNlaDlrUTRFVGFNMXZJRDU3cnJDcEx3OHVZdE82aEgx?=
 =?utf-8?B?YjUvUXRsRnlHaTBCZmE2dmFBN01oNGxTS0tTMzUzN0NHNElkWEczaTc5VnJ0?=
 =?utf-8?B?RGs1dmZsVDQvVC8zNXgxeStrUjJSc0JhNWhiSnRmMUJmUmFLNVIvenVBZzZw?=
 =?utf-8?B?Uk4ybXdrMEZLZjFyd0E5U2p6eUtFV2NEWGhaZFUycXFvM1ZqTTVES1NodTk3?=
 =?utf-8?B?UWVkd0w2M2xmMG1pTDhyOVVZRENLU3NlT2swV1M5TzUzTS93M2pmRU9ibTFT?=
 =?utf-8?B?NkFUU2JjSnVoTHBDM3lyTTFNWVo2SUFtZ3V0SXJ4RHFqeFZnWUNmTGZ5VWdQ?=
 =?utf-8?B?ZGlqc25YRW5QbVBqNWc3cnk4TVh2aGx1QWgrWHNLQUZhNHNhYmxMbVNpb1Zz?=
 =?utf-8?B?N3ZiQXQ3TWFVcUwzaGZybk44aGFBb3doc2lkOUliSDJraE1zOVZKZzFYZ3BD?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2E560D092D0894CA1EC5808679F6FC0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3TMWUb8bBXSQ4HUXQfBpsjb4XcAgkcsE9MYS9MwX02gh//mqmfMv4GWoAOQaxifFZyK/gCgekwK2mnQgHdSd88DsgFkYc+zVcpOo8zsq8Gvhl3+fT2xhO90gSOb9DrwO+Wubx1SU7hXnyGBWtfym0BB97ygQPTEhKgzYMb6EuZTQlsOcgEO0biKu9xrQlVHHPr37NejYb1sAtkVoemJMK9lIRyrVzMPUk5N/2svsYQuaqDcuvtK5eIvI1VYYeW7Ic1umWdm5Peh8Yd7eXe/vjsIrQl8IEQcBF1VkAFnqWuzo2GHzNNUIm0mIGz6mXf29nLpdqtDaz6XUM3uL0JCguOBNCqRu+JYGRyHP9REpRDs8eqlI/ueCabAQAsrb4oKOKUZGO4bvT2JZl0rcfMmWK+N0cxdPQ2bu+iVKGbtfF14gNJu+RKGxzfvBSh39JIiCDI4+I2R9HmbhRT3FYz4bL8cFQXtC1hSDAdE+t0mkPVJTN3TPGrzNwySvM879jexHMbsI0p/sgVqN0gP2Sq+JN9kyHdJ/tIuZSI4Xb4uZG4EnPygDoiLAztiUPqW3ifeTxI7INnYOqzmh+5Lg9ScYknCKUiM/PCFy143BmUoU+q8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fbe84f-e597-4e6a-17e9-08dda4150cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 09:40:46.9819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3PK+UoO3Iauc7UIyMc9pULam+zD+IX5ZoKM9cTMLqEMFlfgcySn0HvU4pz13Y5B23Y4EiZgjaZ850bmaDSi/Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050084
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=68416622 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=96a7OwkIOOS2I4pYGhwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LWjDDNXHmxdkY-vZwvkcN_XHsduVPpQK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA4NCBTYWx0ZWRfX7XJkGiJeTjUf RXsXAa4B3k5vphYEJFo7DpxCmElFbDH8D27M2sored/K4OvyVQNuTnm+LztzSRz6XfnGj3/eEdN /2xI0ryzRIPGeqovWisI9nvEGaMogrSAOPWxKimM+MJEN071s290QhAAD3seTaRvsYEkeoLu5vw
 iJIBX9gjsF8hBFEf1OuQGkF8bvLGw5ymdCOegv/lfcz+IE2/UWRLTUDq250hdXEdRFcmsUHPb4z 43IUxnDK3AbPC9jcglFWxszppzSnaXfBf7ygh9ayuL/N5/kbNGdWP4IrctghLWw6frEhdC+jp0h 89HF69eS8kIqxQtN2406Szg/sAKsCBHXNKF4/e+fXNgyUESaCRrZMRRzDkalsb19ojKXsYXcleO
 b48la+rYWlWDXvgzwY/TAzkCJ9KzhLsc7HUDgfn7pLEKIgwPXjEdiz0a6vdHqQGg/eqwhxBc
X-Proofpoint-ORIG-GUID: LWjDDNXHmxdkY-vZwvkcN_XHsduVPpQK

DQoNCj4gT24gNCBKdW4gMjAyNSwgYXQgMTg6NTgsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCAwNCBKdW4gMjAyNSAxNjo1MzowMSArMDEwMCwNCj4g
TWlndWVsIEx1aXMgPG1pZ3VlbC5sdWlzQG9yYWNsZS5jb20+IHdyb3RlOg0KPj4gDQo+PiANCj4+
IA0KPj4+IE9uIDQgSnVuIDIwMjUsIGF0IDE1OjE3LCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToNCj4+PiANCj4+PiBPbiBXZWQsIDA0IEp1biAyMDI1IDExOjQ3OjU3ICswMTAw
LA0KPj4+IE1pZ3VlbCBMdWlzIDxtaWd1ZWwubHVpc0BvcmFjbGUuY29tPiB3cm90ZToNCj4+Pj4g
DQo+Pj4+IEhpIE1hcmMsDQo+Pj4+IA0KPj4+Pj4gT24gMyBKdW4gMjAyNSwgYXQgMDc6MDgsIE1h
cmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+Pj4gDQo+Pj4+PiBUaGlzIHNl
cmllcyB0cmllcyB0byBicmluZyBzb21lIHNhbml0eSB0byB0aGUgd2F5IHRoZSBSRVN4IG1hc2tz
DQo+Pj4+PiBhcmUgYXBwbGllZCB3aGVuIGFjY2Vzc2luZyB0aGUgaW4tbWVtb3J5IHZpZXcgb2Yg
dGhlIGd1ZXN0J3MNCj4+Pj4+IHN5c3RlbSByZWdpc3RlcnMuDQo+Pj4+PiANCj4+Pj4+IEN1cnJl
bnRseSwgd2UgaGF2ZSAqb25lKiBhY2Nlc3NvciAoX192Y3B1X3N5c19yZWcoKSkgdGhhdCBjYW4g
ZWl0aGVyDQo+Pj4+PiBiZSB1c2VkIGFzIGEgcnZhbHVlIG9yIGx2YWx1ZSB3aGlsZSB0aGF0IGFw
cGxpZXMgdGhlIFJFU3ggbWFza3MgYmVoaW5kDQo+Pj4+PiB0aGUgc2NlbmVzLiBUaGlzIHdvcmtz
IGZpbmUgd2hlbiB1c2VkIGFzIGEgcnZhbHVlLg0KPj4+Pj4gDQo+Pj4+PiBIb3dldmVyLCB3aGVu
IHVzZWQgYXMgYSBsdmFsdWUsIGl0IGRvZXMgdGhlIHdyb25nIHRoaW5nLCBhcyBpdCBvbmx5DQo+
Pj4+PiBzYW5pdGlzZXMgdGhlIHZhbHVlIHdlJ3JlIGFib3V0IHRvIG92ZXJ3cml0ZS4gVGhpcyBp
cyBwb2ludGxlc3Mgd29yaw0KPj4+Pj4gYW5kIHBvdGVudGlhbGx5IGhpZGVzIGJ1Z3MuDQo+Pj4+
PiANCj4+Pj4+IEkgcHJvcG9zZSB0aGF0IHdlIG1vdmUgdG8gYSBzZXQgb2Ygc3RvcmUtc3BlY2lm
aWMgYWNjZXNzb3JzIChmb3INCj4+Pj4+IGFzc2lnbm1lbnRzIGFuZCBSTVcpIGluc3RlYWQgb2Yg
dGhlIGx2YWx1ZSBoYWNrLCBlbnN1cmluZyB0aGF0IHRoZQ0KPj4+Pj4gYXNzaWduZWQgdmFsdWUg
aXMgdGhlIG9uZSB0aGF0IGdldHMgc2FuaXRpc2VkLiBUaGlzIHRoZW4gYWxsb3dzIHRoZSANCj4+
Pj4+IGxlZ2FjeSBhY2Nlc3NvciB0byBiZSBjb252ZXJ0ZWQgdG8gcnZhbHVlLW9ubHkuDQo+Pj4+
PiANCj4+Pj4+IEdpdmVuIHRoZSBsZXZlbCBvZiBjaHVybiB0aGlzIGludHJvZHVjZXMsIEknZCBs
aWtlIHRoaXMgdG8gbGFuZCB2ZXJ5DQo+Pj4+PiBlYXJseSBpbiB0aGUgY3ljbGUuIEVpdGhlciBi
ZWZvcmUgNi4xNi1yYzIsIG9yIGVhcmx5IGluIDYuMTcuDQo+Pj4+PiANCj4+Pj4gDQo+Pj4+IEZv
ciB0aGUgc2VyaWVzOg0KPj4+PiBSZXZpZXdlZC1ieTogTWlndWVsIEx1aXMgPG1pZ3VlbC5sdWlz
QG9yYWNsZS5jb20+DQo+Pj4gDQo+Pj4gVGhhbmtzLg0KPj4+IA0KPj4+PiANCj4+Pj4gbml0OiB0
aGUgcm13IGFjY2Vzc29yIGltcGxpZXMgYW4gaW1wbGljaXQgYXNzaWdubWVudCB3aGljaCBjb3Vs
ZCBiZSBzcGVjaWZpZWQNCj4+Pj4gd2l0aGluIGl0cyBtYWNybyBpbnN0ZWFkIGJ1dCBpdCdzIGZp
bmUgYnkgbWUuDQo+Pj4gDQo+Pj4gSSdtIG5vdCBzdXJlIHdoYXQgeW91IG1lYW4uIExvb2tpbmcg
YXQgdGhpcyBtYWNybyBhZ2FpbiwgdGhlIGVhcmx5DQo+Pj4gd3JpdGViYWNrIHRvIHRoZSBzeXNy
ZWcgYXJyYXkgaXMgcHJldHR5IHVuZm9ydHVuYXRlLCBhbmQgY291bGQgYmUNCj4+PiBhdm9pZGVk
Lg0KPj4+IA0KPj4+IERvZXMgdGhlIGZvbGxvd2luZyBjaGFuZ2UgYWRkcmVzcyB5b3VyIGNvbmNl
cm4/IElmIG5vdCwgcGxlYXNlIGNsZWFybHkNCj4+PiBwb2ludCBvdXQgd2hhdCB5b3UncmUgYWZ0
ZXIuDQo+PiANCj4+IEkgYmVsaWV2ZSB0aGlzIHNob3VsZCBnaXZlIGEgY2xlYXJlciBpZGVhIHdo
aWxlIGF2b2lkcyByZXBlYXRpbmcgdGhlIGFzc2lnbm1lbnQgZXZlcnl3aGVyZQ0KPj4gdGhlIGFj
Y2Vzc29yIGlzIHVzZWQuIEp1c3QgcmVwbGFjZSDigJgmPeKAmCBhbmQg4oCYfD3igJggYnkg4oCY
JuKAmSBhbmQg4oCYfOKAmS4NCj4gDQo+IEkgaGF2ZSB0aGUgb3Bwb3NpdGUgdmlldy4gSSB0aGlu
ayB0aGUgJz0nIHNpZ24gY29udmV5cyBhbiBpbXBvcnRhbnQNCj4gbWVhbmluZywgYW5kIGhpZGlu
ZyBpdCBtYWtlcyB0aGluZ3MgbGVzcyBvYnZpb3VzLiBJZiBJIGhhZCBsb3N0IGNvbW1vbg0KPiBz
ZW5zZSBhbmQgd2FzIHdyaXRpbmcgQysrICwgSSB3b3VsZCBoYXZlIHNpbXBseSBvdmVybG9hZGVk
IHRoZSB2YXJpb3VzDQo+IG9wZXJhdG9ycywgcmV0YWluaW5nIHRoZSBleGlzdGluZyBzeW50YXgu
IFRoaXMgbWFjcm8gZG9lcyB0aGUgaGFyZCBqb2INCj4gb2YgYXBwbHlpbmcgdGhlIFJFU3ggbWFz
a3MsIGJ1dCB0aGUgb3BlcmF0b3IgaXMgd2hhdCBpcyBzZW1hbnRpY2FsbHkNCj4gc2lnbmlmaWNh
bnQuDQo+IA0KDQpUaGF04oCZcyB1bmRlcnN0YW5kYWJsZS4gVGhlIFJlYWQtTW9kaWZ5LVdyaXRl
IG9yIOKAmHJtd+KAmSBvbiB0aGUgYWNjZXNzb3INCnJlaW5mb3JjZXMgdGhlIHNhbWUgaW1wb3J0
YW50IG1lYW5pbmcgYXMgdGhlIOKAmD3igJggc2lnbiBpcyBjb252ZXlpbmcgd2hlbg0KZXhwcmVz
c2VkIG9uIHRoZSBhY2Nlc3NvciB1c2FnZS4gUGVyIHNlIG5vdCBhIHByb2JsZW0uDQoNClRoYW5r
cywNCk1pZ3VlbA0KDQo+IFRoYW5rcywNCj4gDQo+IE0uDQo+IA0KPiAtLSANCj4gSmF6eiBpc24n
dCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4NCg0KDQo=
