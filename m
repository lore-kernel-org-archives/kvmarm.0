Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390A4734EB
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 09:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453392; cv=fail; b=jXccyFqtOKnw6ZSzE5V6ndrXuPADGZR80yxsLYTPOrZztdggqAYX/Smi/bgct/5U50zcqxFxjd7gSlCWw1eJeaF8v/Z1ZedPTtxz8kwz5Jthn/8M2Xc2ZwfK3pkuoIdE3mExLaj0MIno4kQr/R5eEcO6IbP7zxkJ4kTfAjv6POc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453392; c=relaxed/simple;
	bh=jFj9JlwqcudaNGtrECe8/O3Ygr4oe9Rjk5XD+7Dbzr4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jp9njI1Ps5bCy0RiQd9Q89IZ9Ng8ooaJiK0ZOCVIhQEFluFFwxzSCJOGUNkA/2d7tLy0LkHDkbBeEegWFcKXKK0UuUlPv42WFIRMILP1gaP1PAAS+XUvCmktABTvefwlyPKZ5DQX5P7b4XiHulLo7dUvDjQ19AA0pHHnDbWzQ/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rVtvVcm7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oPJiF3Xl; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rVtvVcm7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oPJiF3Xl"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987N3523179146;
	Thu, 8 Oct 2026 02:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=jFj9JlwqcudaNGtrECe8/O3Ygr4oe9Rjk5XD+7Dbz
	r4=; b=rVtvVcm7rs7VnS4WQV/cCCeR+/yBZtsLvH3qu1Jpq/tXJ6jKZL4bRVjok
	ACuCPBFn6IxZOro2X9hMY47aZ22vm/LXE1lNUZKWXlosDn4rMg1DVbrdvXOY0Eiy
	ScS9eDpbmQB0dBEGdC4dXmG2xax1ccsxrbwyBHKVLw5wNJVpi40PkWlut1agpy8c
	Ppett283/zFe63jJTV/xdEW2+zjSRWWSLJM5n4Mm/e3x0BCbjzYwJ7cYFF1kc4OF
	qkr69wQ5MWNY7OMWc/ZzOb9vPcC11B/RlEsvJKtH4eLYoHA9mAElFqNtWMXf8yYq
	LB6J2O/ev9sWiXHqg/kDmV9Gd1YWQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020114.outbound.protection.outlook.com [52.101.46.114])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4h5xe5hamd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 02:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGro+F8gCYEyWe+99QNvWcTR5ZXgM4JbITXJctk2cKvqxT6PGSjs56VZ7B8aa8i4gNvbdE5oZX/JxA9n429RNZVtibPIEKt0oCWD8U8c5cr98yTxJpRQk4i5GuZhwa8xjUFkRoNeP3fU6qmoC1i8jz7VaHvEtF5Z8EJxwxZ18gl5YOlVoJnMAAq5F2/gHmm2gfSJLZYlvJvuymvYjo2CAqBIZmBQAir1+4w4M8DrqmLVEacY+hn8ChF/3WeXzvqKHY55sdqMseUbf6t2Rjj9W6Vt25qZcYrr53qb+JT2ymb5vfWWngXlnpcuktyLkKBgVqiVYvJNDaj15LPMWXyqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFj9JlwqcudaNGtrECe8/O3Ygr4oe9Rjk5XD+7Dbzr4=;
 b=nYF3MDSsg/EUeF3FaYQYhYRVvlx9ZynJhsFOOaC0YF6I97CsQenI9AWFYoPyQPb9X/5d4umSKi3NOqGloSlozum0srIGDomhfxscIYDqo6IhUbHHUw2EI9Lw80UE1AuLHesbSbHYuYyDrkNkbQZAcxc5Y5f4saVzQjR2rNpsD+SGjCbqW0mrMryTLCS9VxVaiAgPRNwnPDq1bBCxNHFNn+oT52dmLDoG/vwXvjclM1SGUrV+BxDvfKpalv/uj4d8Q+ZTgkLcPRJbGazUgoXz/BFV1SOUxJ8THIh2PJJwB4OJWTnOj61Blia8gpxUHVRGyXD+hshoKeG5q/QfTQs21Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFj9JlwqcudaNGtrECe8/O3Ygr4oe9Rjk5XD+7Dbzr4=;
 b=oPJiF3Xl10+f6clJ1U2nBYB23HldgwwA8OFzP42vcZf6768tcw0uqO812jUI/WU/RBNR9PWnGh4ArSHtm7UNClf0QGGUZ8mKxmy0SYwdO5anw6slAAjfTxdWVTvOLT18J0TC8VZ1OKkK08pFZZCjggnugfRZcsY0FDUh/E1TOhqUW7TU8XJwbb41f4dSNGUZS2gsGTFayULVHTqq9FiEe5A7Qw2vI+udRNpc6SvzQo49SjGws+NVlJz2pebl2rQudZUceLkMWdUtLYSp/zN3fT6RhATUcn4OYtibcb+n3nlknhsnDAhfcB+Sb6sdfmGO1ptu/mS7V3D/3vUoUDT9VA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH0PR02MB8731.namprd02.prod.outlook.com (2603:10b6:510:da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 09:56:15 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 09:56:15 +0000
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
Subject: Re: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Topic: [PATCH v9 16/26] target/arm/kvm: Apply SYSREG props to the final
 vcpu
Thread-Index: AQHdTzZFb+3vQGjy90CWHnrFypsV4LbnPJWAgAw7dYA=
Date: Thu, 8 Oct 2026 09:56:15 +0000
Message-ID: <8AB4E73A-A6EB-4D03-BC36-F7C0E20F91B0@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-17-eric.auger@redhat.com>
 <8F110441-6D38-4134-9196-76AFA021250F@nutanix.com>
 <bd747536-c8eb-4c21-a859-ac1f2a28794f@redhat.com>
In-Reply-To: <bd747536-c8eb-4c21-a859-ac1f2a28794f@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH0PR02MB8731:EE_
x-ms-office365-filtering-correlation-id: 831d5e08-6d7e-4fff-17e1-08df25226493
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|38070700021|56012099006|4143699003|10067099003|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info:
 vYPsOw9O+qDviL63lIEQodvDIL7Hb5w48xJftamdD51v7z828JlRY81zzxqVUk/c6ld1IdSGlG/Ek/7XaqaqGSBocEdir4ACdT9ViybaRHn9H4iTAHTL8xeNBNTlKkbiUxmkuwFIVHFoXw1ugVxpyQintDPa34nGlnwcBIf0QzLl1EkZvfRExoBeLdpd4qr5pVDgoubSSsnazM6brkSvo3EE0vmGDQ9nEItM7CAepWp2OT348keOYY6X3CchIVJRxO+pyAVtiFR3zCt2LeY079ZTmh1bOF9c2MPbiVu3M+mMvWPOQO7deWTK3pQHYGwHjLVqZleVZio427YMM5YZbGoSDki+AYs8y7XV3df17fwJwKdOVxsc+2/r59283ryribFPtVOl9W7FagU4xdQ1qTHi8cNeuNbZebAOrR0lryMvG/I9Yh6WnaLLWoufzJOdLKd7F1jLWh9GWfdH0WmAw/VN1aSE26qUmh9Bg3w2rswImIzMP4QgCeHIoUEjR9axANevsuqDm8YCspAIjcXgiscgg8bTRmhB1pfJfhtTxNG9WUFQ90xLo7UGFbhY1Uu6Iky2tq+2qJBM3ZjZngYEkrKMVow6T8LC1Bh7bm+TbeNEX/G15QQRx3aaDsG7pPCFhgcfLg6kWPJyv/uPO75mHWsM986/69ptB37OdTMvtDKo84WJsb3S06PYstVVCFQwKhlFzoM0rB3QmZD29LP73GZYhRrWytyE2NsTQCzMWgc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(38070700021)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWtEaTQvYmJ3YitVZGpDSGlzSFZFazdJSGp4OHY5STdFZHhURDIvb3kxMXpt?=
 =?utf-8?B?ZTkrT1VjRkovNzd6Wk5hdlNuN3R6OXUwcEZWc2FwMWFONjRGVEtHVGhrMXF4?=
 =?utf-8?B?aHc0N0xTaHFTZFpyRW9LRlZsbUlqSndLQ1B6RTRWSW03N2FQdDluT0tMak9j?=
 =?utf-8?B?T0laNWRaUkRMaCtERXVZZnBpUVlFSnRuK2hmdlZuWGFZT212K0o1dnRraXIr?=
 =?utf-8?B?d0h0REtTUlVhc0w4ZFZWeGxCRGtiSDc4ZkxHRGdvSDc2bVVaTWcrTDZOZk5l?=
 =?utf-8?B?b0hvYm5aM0pxUTN0MGpDTDBnUlZSQ3NQVlhDZkFPZUlKNEh5TVNyczBJcDho?=
 =?utf-8?B?TGlDNE5JZW1DbkI1bGVkNnE2UGFVem9ldm9xNGxjVVdicmE5UUR3MDNsM1dk?=
 =?utf-8?B?UmRhRFlKVXpZcTNsWWsvbG1jOG1mZk9VYy9wWlhyWGprVzRqUzZpUmhIUjlJ?=
 =?utf-8?B?and0NzBLNHBuVCt3L1A2K2orWWJBVERIUzRJYU43Tjh6Um56Sk0vMnZqbVRJ?=
 =?utf-8?B?bTlGT01PSnFveEkrMU5oclZtZ1FZbXk2cDBzVDBNckZENS8wcm0zQ2dWcHlL?=
 =?utf-8?B?OFFEUXJ6S0xTQjQxQkdzRU9LR0xnS2ZJaUNEQkY5dllIeGRib04rS1lTUmV2?=
 =?utf-8?B?QTFORTBDUTgxM1ViajRJNlR5bEcwclRML01ZaXJna0ZiTzBKN3lUUXp0RG0x?=
 =?utf-8?B?RmdISGtYRHNNVVNlVStDcVNUZEpDbVRqY1pnWmgySXNXNjN2M0RXOWlCZm0w?=
 =?utf-8?B?aWpzNUFGb3NCM3pZNXN6ckRWTFV6WmlzUGpxakRLeUVURytYaThBeUV1dHdK?=
 =?utf-8?B?VC8rUVI2eEVEVFZqKy9FY1ZxSWM5enhGZTh3cTh2anRBM2F5Y0FwTzF5YjRD?=
 =?utf-8?B?bk12bGRZcDhxWHlTUkJpTDN4OXB6bFFtVGlUZUVxaGU0MTJDeitoK25wWEV3?=
 =?utf-8?B?dWFhRkI5enk0Y3pZUlVKT0JHQlh1MXpVUkMybjNPYm4rekZVRTltdmtXSmZY?=
 =?utf-8?B?OVBBVWY0QVZWeElwdTlIRy9wZWRKWnQvdlNJeUcvSVpSVjQ4ZjdyUHFwYXVQ?=
 =?utf-8?B?VEZxaytxeWlPbTBQVkZoMDZ2OEMvaW5MaW1OaFdxckZYK2lXelJKaWtPS0RI?=
 =?utf-8?B?ZUsyeVhkSmgvNjkvRUtMSS9LNThUejB6WUhQS0JKbEM4RjliZnh0N1JiaCtl?=
 =?utf-8?B?dWx0T1ExRnN4aDZOaFl5SUVrZ3ROTkh3RzNEYXV6Rm1NN1YyY1BJWmRUcFRt?=
 =?utf-8?B?T2VLcHErYTE2QVk5QW9mdG1VS2swMDcyU2dVaUgrWkwxMWp1cVNmeWQxUmti?=
 =?utf-8?B?QlVhWFlmMnliL09GcGxOeDNVbm44bWxKS091YkgwVDhKVlowU1pRUmhuZ1ZP?=
 =?utf-8?B?MW44M2xnSyt5dTU2Q3VQR3g5MWRiMDFlUUxGWkVDQXZXaGhOUGJhZnVOYTlh?=
 =?utf-8?B?M3lBTmhJeWE5Zm5vZnpvQmRrbncxZE40Sy9yUDErVHd1WTcwSTlKbmczaTNX?=
 =?utf-8?B?b3VxV24rZ0UzTlRLSlpENm1tRCtiVGxndlh0YXRSOE5yVEN6SlNDQlZOWTFP?=
 =?utf-8?B?TGRlajlybEp3dEhWd2F6c0NDMlMyVHR5SnAyckNrTUYzWVVuaVlQZ1JTcVpq?=
 =?utf-8?B?U1ZQZEV1eGZyekRxM1hkR2dMVlhQemh6QlV5RFZzbmU1WGhxZFZ2ekNxOU02?=
 =?utf-8?B?dmhURW04MXEzaFF3WFJxOXBTUVRHWkZkdXQ2d1NhQTVwTGRtcm42MDVldVMv?=
 =?utf-8?B?dE1Tc2d6Z2crQWJYaFR4OUxPaG1PRkxRUUVzazlKblZyZXNXeDFmaXc3ZGRI?=
 =?utf-8?B?NjZ4TkFQUzBnM3YycVhyWWxIL1BvTjJGMjdaUnYvOTZLSElXSUhIVWFCa3Nz?=
 =?utf-8?B?dGc0d1I4L2FINzJjaVVveWNVM0xpa29sdWlqMGNnU0kwbHllakFCeFV0QlJF?=
 =?utf-8?B?MlRFdEhtOTcvYTJYZ0Fkc0QxV3RMWDBROFBDRnpwV0hVVjFLTjgrK0xOTUhp?=
 =?utf-8?B?d1JGeUlUL3RIeXU0RE1pY1RLUWhjanJEQTRLZGU3aFk3WWVVYU0xR1NHWUxL?=
 =?utf-8?B?SGhmVnBtOWZlblVOQ09nbWczRnM0em1kbyt3dUp0b3JjWFhKeTcvczEzM0tn?=
 =?utf-8?B?dk5ZUlF3VEtkNWJQbk8yaENsRUhSd2syQlVVcmoxei9RWENxQ3lJeEtIY2Zn?=
 =?utf-8?B?RUVXQzk2WTV1Sm1HaXBEVkY2RUExUFBra3FSYUd4NzRVN2tldFFndlM3TWJW?=
 =?utf-8?B?RWVkTkduZGtQSEwvekJnUzB2QVREMDNqRkpMWG5HTm00V1FTTFc0ZEVvUlk2?=
 =?utf-8?B?UGZXazVJSDNHL3kxbU1Dd1gxN1V2cUtycHBLbFJRZ0VmTFczRks3WlNOMnp2?=
 =?utf-8?Q?DYfj6tSJVnfpr0sE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDA18C2BA15392409D0FE6F4A6852B20@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	u1OP0LX5TkpVubS3GXN2zQFFM1vsZwvOVTCwm9//U2hZuOOLyHiSBP4Fym89bhoUV+IE/jt2nCMRAyTgyJhfW3eq7k00Z89ghAQVcdlv21qHuYmBVwU22iT48sFAK/AUAUHagzl6+imn4cBtDLCuXSCMAyLeXi99oMTe2QFiFDNVS0BO4F/Diwu+cZ6hn/G1V9WHm8u3aqxUslf1Ok6SeiUp2AzlDaFiVj4+oOCS1+bj0Frve0q1d/D0fay+sFCBlHgkXxdvYx7hiPBSFctHaX5zw5zBalsXg/ySJq23heAPv1tdBrxxE0qlO2kFY2MobnQCykOR/lT5b6BJ552Alw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 831d5e08-6d7e-4fff-17e1-08df25226493
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2026 09:56:15.6273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2WVRW+htJCwauJyy+FTf48SKoowVLi1sZdiCHyezPMp+MJTyBRubFiiff/eG6YSA9j5EnaRgVYjDQ/QJHaMld0CsXS59s7KROP4jTj9LdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8731
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzOSBTYWx0ZWRfX021xFjbEB2dW
 R9KkBN7SGjeHcJ7u8KPr50XigFfTKgYk9SKX9AQ6zJP5SJFJV3IyZHdoTcX8HY1jsVFBs3HuNQR
 8geapjtWWJay2Gvr2N/rkonVK4pPBk8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzOSBTYWx0ZWRfXw4ibWuti391G
 EmVGgQ4krZ+7Ri3IlW9I8X6Zt0QONnSd4UD/Pzbe4RfujpeTFimH0uJUWLZbGr7cvVqfL1KcgZk
 UP691/JxaCQeJ1ihGCCksoVgk1BeVonGsdEtgcrX6d9sWDxW2OpJXXLllkYuj5DbQi4USVbZqof
 FLFVbv91mFJ52TKaugJWjdgSwwD/LM/f11OlmhN4qfbm2iUv2OXB2Fw7Rojle9aN1NKupY345he
 Q4w30/FJysKcdJZ81oXiLuyDPwgPzuUjv1eThecsHwUCX8XbAiEALrPgWh27nHJUZF/99bh4H1O
 V44jBuocP/BhCZs0Gt7cWNyNtQMoTHTTuh22bfBDehDiKS+0c9hZ9SI/8vIU4UvS1y9APg1z5X9
 AJVwSmGgdlCn+tyqJegFYIOl919VaKaP+LY/1/837tQP2x/0AX7G8Vhbe1jJAASMamYaLSSX+WF
 dcFigOyGEvCVxKF0piA==
X-Proofpoint-ORIG-GUID: ThAS8x01ltBgkMiOwIiGYvr67b3A4B88
X-Authority-Analysis: v=2.4 cv=QKP91QLL c=1 sm=1 tr=0 ts=6ac768c1 cx=c_pps
 a=LvphRkG1ZSFrSK8rCZP5oA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=pYDu6lfzL3r3-lYT2l4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ThAS8x01ltBgkMiOwIiGYvr67b3A4B88
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMzAgU2VwIDIwMjYsIGF0IDg6MzjigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDkvMjgvMjYgMTI6NDQgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IA0KPj4+IE9uIDE2
IFNlcCAyMDI2LCBhdCA4OjE14oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4gd3JvdGU6DQo+Pj4gDQo+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4gQ0FVVElPTjogRXh0ZXJuYWwg
RW1haWwNCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBTWVNSRUcgcHJvcCBzZXR0
aW5ncyB3ZXJlIHJlY29yZGVkIGluIGEgaGFzaHRhYmxlIGJ1dCB0aGV5DQo+Pj4gYXJlIG5vdCB5
ZXQgaW5qZWN0ZWQgb24gZ3Vlc3QuIEl0ZXJhdGUgb3ZlciBhbGwgc2V0IGZpZWxkcyBhbmQNCj4+
PiBhcHBseSB0aGUgbmV3IHZhbHVlIHRocm91Z2ggS1ZNX1NFVF9PTkVfUkVHLiBUaGUgbmV3IGZp
ZWxkDQo+Pj4gdmFsdWUgb3ZlcnJpZGVzIHRoZSBjdXJyZW50IG9ic2VydmFibGUgdmNwdSByZWdp
c3RlciB2YWx1ZS4NCj4+PiANCj4+PiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1
Z2VyQHJlZGhhdC5jb20+DQo+PiBXaXRoIHRoaXMsIEkgc3VwcG9zZSwgd2hhdCBuYW1lZCBtb2Rl
bHMgd2lsbCBkbyBpcyBkaXJlY3RseSB3cml0ZSB0bw0KPj4gSUQgcmVnaXN0ZXIgc3RhdGUsIEFz
IGl0IGFsc28gZGVmaW5lcyBzdGF0ZSB3aGljaCBhZmZlY3RzIHZDUFUgaW5pdCBmbGFncyBhbHNv
Lg0KPiBUaGF0J3Mgbm90IHdoYXQgSSBoYWQgaW4gbWluZC4gSSB0aG91Z2h0IHlvdSB3b3VsZCBh
cHBseSB0aGUgU1lTUkVHDQo+IHNldHRpbmdzIGF0IHRoZSBzYW1lIHRpbWUuIEFzIG1lbnRpb25u
ZWQsIEkgZG9uJ3QgdGhpbmsgdGhvc2Ugc2V0dGluZ3MNCj4gYXJlIG1lYW50IHRvIHN1YnN0aXR1
dGUgdG8gbGVnYWN5IGNvbXBvc2l0ZSBvcHRpb25zIHRoYXQgYWZmZWN0IHZjcHUNCj4gaW5pdCBz
ZXR0aW5ncy4NCj4gQmVzaWRlcyB0aGUgcHJpbmNpcGxlIG9mIHRoaXMgcHJlcGFyYXRvcnkgc2Vy
aWVzIGlzIHRoYXQgdGhlIHByb3BzIGZvcg0KPiB3cml0YWJsZSBJRCByZWcgZmllbGRzIGFyZSBt
ZWFudCB0byBiZSBmdWxseSByZXVzYWJsZSBmb3IgbmFtZWQgdmNwdQ0KPiBtb2RlbHMuIE9ubHkg
cHJvcHMgZm9yIG5vbiB3cml0YWJsZSBmaWVsZHMgc2hvdWxkIGJlIHNwZWNpZmljIHRvIG5hbWVk
DQo+IHZjcHUgbW9kZWxzIGFzIHRoZXkgZG8gbm90IG1ha2Ugc2Vuc2Ugb24gaG9zdC9tYXggdmNw
dSBtb2RlbA0KDQpIaSBFcmljLA0KDQpTb3JyeSwgbWlzc2VkIHRoaXMgbWFpbC4gWWVzIHllcywg
d2Ugd2FudCB0byByZXVzZSBhbGwgdGhlIGV4aXN0aW5nIGluZnJhIGZvcg0KbmFtZWQgQ1BVIG1v
ZGVscy4gT25seSB0aGUgZmllbGRzIHRoYXQgY29uZmxpY3RzIHdpdGggbGVnYWN5IG9wdGlvbnMg
bmVlZHMNCnNwZWNpYWwgaGFuZGxpbmcgaW4gbmFtZWQgQ1BVIG1vZGVscy4NCg0KPj4gDQo+Pj4g
LS0tDQo+Pj4gdGFyZ2V0L2FybS9rdm0uYyAgICAgICAgfCA2NSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKw0KPj4+IHRhcmdldC9hcm0vdHJhY2UtZXZlbnRzIHwgIDEg
Kw0KPj4+IDIgZmlsZXMgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKQ0KPj4+IA0KPj4+IGRpZmYg
LS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4+IGluZGV4IDNl
YzI2MThjYzEuLmRkZjMyMGQwZTYgMTAwNjQ0DQo+Pj4gLS0tIGEvdGFyZ2V0L2FybS9rdm0uYw0K
Pj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+PiBAQCAtMzQzLDYgKzM0Myw5IEBAIHN0YXRp
YyBBUk02NFN5c1JlZ0ZpZWxkICpnZXRfZmllbGQoaW50IGksIEFSTTY0U3lzUmVnICpyZWcpDQo+
Pj4gI2RlZmluZSBNQUtFX0lEUkVHX0tFWShyZWdfaWR4LCBmaWVsZF9zaGlmdCkgXA0KPj4+ICAg
ICgoKHVpbnQ2NF90KShyZWdfaWR4KSA8PCA4KSB8ICgodWludDY0X3QpKGZpZWxkX3NoaWZ0KSAm
IDB4RkYpKQ0KPj4+IA0KPj4+ICsjZGVmaW5lIEtFWV9UT19SRUdfSURYKGtleSkgICAgICgodWlu
dDMyX3QpKCgodWludDY0X3QpKGtleSkpID4+IDgpKQ0KPj4+ICsjZGVmaW5lIEtFWV9UT19TSElG
VChrZXkpICAgICAgICgodWludDhfdCkoKCh1aW50NjRfdCkoa2V5KSkgJiAweEZGKSkNCj4+PiAr
DQo+Pj4gc3RhdGljIHZvaWQgc2V0X3N5c3JlZ19wcm9wKE9iamVjdCAqb2JqLCBWaXNpdG9yICp2
LA0KPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKm5hbWUsIHZvaWQg
Km9wYXF1ZSwNCj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICBFcnJvciAqKmVycnApDQo+
Pj4gQEAgLTIyMTUsNiArMjIxOCw2MyBAQCBpbnQga3ZtX2FyY2hfcHJlX2NyZWF0ZV92Y3B1KENQ
VVN0YXRlICpjcHUsIEVycm9yICoqZXJycCkNCj4+PiAgICByZXR1cm4gMDsNCj4+PiB9DQo+Pj4g
DQo+Pj4gK3N0YXRpYyBpbnQga3ZtX2FybV9hcHBseV9zeXNyZWdfcHJvcHMoQVJNQ1BVICpjcHUs
IEVycm9yICoqZXJycCkNCj4+PiArew0KPj4+ICsgICAgdWludDY0X3QgKmlkcmVncyA9IGNwdS0+
aXNhci5pZHJlZ3M7DQo+Pj4gKyAgICBncG9pbnRlciBrZXlfcHRyLCB2YWx1ZV9wdHI7DQo+Pj4g
KyAgICBDUFVTdGF0ZSAqY3MgPSBDUFUoY3B1KTsNCj4+PiArICAgIEdIYXNoVGFibGVJdGVyIGl0
ZXI7DQo+Pj4gKw0KPj4+ICsgICAgZ19oYXNoX3RhYmxlX2l0ZXJfaW5pdCgmaXRlciwgY3B1LT5z
eXNyZWdfcHJvcHMpOw0KPj4+ICsNCj4+PiArICAgIHdoaWxlIChnX2hhc2hfdGFibGVfaXRlcl9u
ZXh0KCZpdGVyLCAma2V5X3B0ciwgJnZhbHVlX3B0cikpIHsNCj4+PiArICAgICAgICB1aW50NjRf
dCBrZXkgPSAodWludDY0X3Qpa2V5X3B0cjsNCj4+PiArICAgICAgICB1aW50NjRfdCB2YWx1ZSA9
ICh1aW50NjRfdCl2YWx1ZV9wdHI7DQo+Pj4gKyAgICAgICAgdWludDMyX3QgcmVnX2lkeCA9IEtF
WV9UT19SRUdfSURYKGtleSk7DQo+Pj4gKyAgICAgICAgdWludDhfdCBsb3dlciAgICA9IEtFWV9U
T19TSElGVChrZXkpOw0KPj4+ICsgICAgICAgIEFSTTY0U3lzUmVnICpyZWcgPSAmYXJtNjRfaWRf
cmVnc1tyZWdfaWR4XTsNCj4+PiArICAgICAgICBzdHJ1Y3Qga3ZtX29uZV9yZWcga3ZtX3JlZzsN
Cj4+PiArICAgICAgICB1aW50NjRfdCBjdXJyZW50LCBvbGQsIG1hc2s7DQo+Pj4gKyAgICAgICAg
dWludDY0X3Qga3ZtX2lkeDsNCj4+PiArICAgICAgICBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCA9
IGdldF9maWVsZChsb3dlciwgcmVnKTsNCj4+PiArICAgICAgICBpbnQgbGVuZ3RoID0gZmllbGQt
Pmxlbmd0aDsNCj4+PiArICAgICAgICB1aW50NjRfdCBvbGRmdjsNCj4+PiArICAgICAgICBpbnQg
cmV0Ow0KPj4+ICsNCj4+PiArICAgICAgICBtYXNrID0gTUFLRV82NEJJVF9NQVNLKGxvd2VyLCBs
ZW5ndGgpOw0KPj4+ICsgICAgICAgIHZhbHVlID0gdmFsdWUgPDwgbG93ZXI7DQo+Pj4gKw0KPj4+
ICsgICAgICAgIG9sZCA9IGlkcmVnc1tyZWdfaWR4XTsNCj4+PiArDQo+Pj4gKyAgICAgICAga3Zt
X2lkeCA9IGlkcmVnc19zeXNyZWdfdG9fa3ZtX3JlZyhpZF9yZWdpc3Rlcl9zeXNyZWdbcmVnX2lk
eF0pOw0KPj4+ICsgICAgICAgIHJldCA9IHJlYWRfc3lzX3JlZzY0KGNzLT5rdm1fZmQsICZjdXJy
ZW50LCBrdm1faWR4KTsNCj4+PiArICAgICAgICBpZiAocmV0KSB7DQo+Pj4gKyAgICAgICAgICAg
IGVycm9yX3NldGcoZXJycCwgImZhaWxlZCB0byByZWFkIHRoZSBjdXJyZW50IHZhbHVlIG9mICVz
IiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICByZWctPm5hbWUpOw0KPj4+ICsgICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KPj4+ICsgICAgICAgIH0NCj4+PiArICAgICAgICBvbGRmdiA9IChj
dXJyZW50ICYgbWFzaykgPj4gbG93ZXI7DQo+Pj4gKw0KPj4+ICsgICAgICAgIGlkcmVnc1tyZWdf
aWR4XSA9IGN1cnJlbnQgJiB+bWFzazsNCj4+PiArICAgICAgICBpZHJlZ3NbcmVnX2lkeF0gfD0g
dmFsdWU7DQo+Pj4gKyAgICAgICAga3ZtX3JlZy5pZCA9IGt2bV9pZHg7DQo+Pj4gKyAgICAgICAg
a3ZtX3JlZy5hZGRyID0gKHVpbnRwdHJfdCkmaWRyZWdzW3JlZ19pZHhdOw0KPj4+ICsNCj4+IFdl
IGNhbiBpZ25vcmUgdGhpcyBpZiB2YWx1ZSA9PSBvbGQgdmFsdWUNCj4gc3VyZSwgbW9kaWZpZWQN
Cj4+IA0KPj4+ICsgICAgICAgIHJldCA9IGlvY3RsKGNzLT5rdm1fZmQsIEtWTV9TRVRfT05FX1JF
RywgJmt2bV9yZWcpOw0KPj4+ICsgICAgICAgIGlmIChyZXQpIHsNCj4+PiArICAgICAgICAgICAg
ZXJyb3Jfc2V0ZyhlcnJwLCAiZmFpbGVkIHRvIGFwcGx5IG5ldyB2YWx1ZSAweCUiUFJJeDY0IiBm
b3IgZmllbGQgJXMuJXMgIg0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICIocHJldmlvdXMg
aXMgMHglIlBSSXg2NCIpOiAlbSIsIGlkcmVnc1tyZWdfaWR4XSwNCj4+PiArICAgICAgICAgICAg
ICAgICAgICAgICByZWctPm5hbWUsIGZpZWxkLT5uYW1lLCBvbGRmdik7DQo+Pj4gKyAgICAgICAg
ICAgIHJldHVybiByZXQ7DQo+Pj4gKyAgICAgICAgfQ0KPj4+ICsNCj4+PiArICAgICAgICB0cmFj
ZV9hcHBseV9zeXNyZWdfcHJvcChyZWctPm5hbWUsIGZpZWxkLT5uYW1lLCBvbGQsIGN1cnJlbnQs
DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWFzaywgdmFsdWUsIGlkcmVn
c1tyZWdfaWR4XSk7DQo+Pj4gKyAgICB9DQo+Pj4gKyAgICByZXR1cm4gMDsNCj4+PiArfQ0KPj4+
ICsNCj4+PiBpbnQga3ZtX2FyY2hfaW5pdF92Y3B1KENQVVN0YXRlICpjcywgRXJyb3IgKiplcnJw
KQ0KPj4+IHsNCj4+PiAgICBpbnQgcmV0Ow0KPj4+IEBAIC0yMzE1LDYgKzIzNzUsMTEgQEAgaW50
IGt2bV9hcmNoX2luaXRfdmNwdShDUFVTdGF0ZSAqY3MsIEVycm9yICoqZXJycCkNCj4+PiAgICB9
DQo+Pj4gICAgY3B1LT5tcF9hZmZpbml0eSA9IG1waWRyICYgQVJNNjRfQUZGSU5JVFlfTUFTSzsN
Cj4+PiANCj4+PiArICAgIHJldCA9IGt2bV9hcm1fYXBwbHlfc3lzcmVnX3Byb3BzKGNwdSwgZXJy
cCk7DQo+Pj4gKyAgICBpZiAocmV0KSB7DQo+Pj4gKyAgICAgICAgcmV0dXJuIHJldDsNCj4+PiAr
ICAgIH0NCj4+PiArDQo+PiBUaGlzIHNob3VsZCBhbHNvIGhhcHBlbiBvbiB2Q1BVIHJlc2V0Lg0K
PiBPbiB3aGljaCBwYXRoIGlzIGl0IG5lZWRlZD8gb24gcW1wIHN5c3RlbV9yZXNldCBJIGNhbiBz
ZWUgdGhhdCB0aGUNCj4gZm9ybWVyIHZhbHVlcyBhcHBsaWVkIHdpdGggU1lTUkVHIHNldHRpbmdz
IGFyZSBrZXB0Lg0KPiANCg0KU2hvdWxkIGt2bV9hcm1fcmVzZXRfdmNwdSgpIGFsc28gYmUgdXBk
YXRlZD8NCg0KDQpUaGFua3MsDQpLaHVzaGl0DQoNCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+PiAN
Cj4+IE92ZXJhbGwsIEkgbGlrZSB0aGlzIGFwcHJvYWNoIGFzIGlmIHRoZSB1c2VyIGRvZXMgbm90
IHByb3ZpZGUgYW55IHByb3BlcnR5IG92ZXJyaWRlcywgaXQgc2hvdWxkIGJlaGF2ZSB0aGUgc2Ft
ZSBhcyBvbGRlciBidWlsZHMuDQo+PiANCj4+IFdhcm0gUmVnYXJkcywNCj4+IEtodXNoaXQNCj4+
PiAgICByZXR1cm4ga3ZtX2FybV9pbml0X2NwcmVnX2xpc3QoY3B1KTsNCj4+PiB9DQo+Pj4gDQo+
Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzIGIvdGFyZ2V0L2FybS90cmFj
ZS1ldmVudHMNCj4+PiBpbmRleCBkNzJhZDZiNjcxLi5iNGQyYjQ1YTdkIDEwMDY0NA0KPj4+IC0t
LSBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+Pj4gKysrIGIvdGFyZ2V0L2FybS90cmFjZS1l
dmVudHMNCj4+PiBAQCAtMTgsNiArMTgsNyBAQCBrdm1fYXJtX3dyaXRhYmxlX2lkcmVnc190b19j
cHJlZ19saXN0KGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2NF90IHByZXZpb3VzLCB1aW50Ng0KPj4+
IGRlY29kZV9pZHJlZ193cml0ZW1hcChjb25zdCBjaGFyKiBuYW1lLCBpbnQgbG93ZXIsIGludCB1
cHBlciwgY2hhciAqcHJvcF9uYW1lKSAiJXMgWyVkOiVkXSBpcyB3cml0YWJsZSAocHJvcCAlcyki
DQo+Pj4gZ2V0X3N5c3JlZ19wcm9wKGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2NF90IHZhbHVlKSAi
JXMgMHglIlBSSXg2NA0KPj4+IHNldF9zeXNyZWdfcHJvcChjb25zdCBjaGFyICpuYW1lLCB1aW50
NjRfdCBvbGQsIHVpbnQ2NF90IG1hc2ssIHVpbnQ2NF90IGZpZWxkX3ZhbHVlLCB1aW50NjRfdCBu
ZXcpICIlcyBvbGQgcmVnIHZhbHVlPTB4JSJQUkl4NjQiIG1hc2s9MHglIlBSSXg2NCIgbmV3IGZp
ZWxkIHZhbHVlPTB4JSJQUkl4NjQiIG5ldyByZWcgdmFsdWU9MHglIlBSSXg2NA0KPj4+ICthcHBs
eV9zeXNyZWdfcHJvcChjb25zdCBjaGFyICpyZWdfbmFtZSwgY29uc3QgY2hhciAqZmllbGRfbmFt
ZSwgdWludDY0X3Qgb2xkLCB1aW50NjRfdCBjdXJyZW50LCB1aW50NjRfdCBtYXNrLCB1aW50NjRf
dCBmaWVsZF92YWx1ZSwgdWludDY0X3QgbmV3KSAiJXMuJXMgb2xkPTB4JSJQUkl4NjQiIGN1cnJl
bnQ9MHglIlBSSXg2NCIgbWFzaz0weCUiUFJJeDY0IiBuZXcgZmllbGQgdmFsdWU9MHglIlBSSXg2
NCIgbmV3PTB4JSJQUkl4NjQNCj4+PiBuYl9zeXNyZWdfcHJvcHMoY29uc3QgY2hhciAqbmFtZSwg
aW50IGNvdW50KSAiJXM6ICVkIFNZU1JFRyBwcm9wZXJ0aWVzIg0KPj4+IA0KPj4+ICMgY3B1LmMN
Cj4+PiAtLSANCj4+PiAyLjUzLjANCg0KDQo=
