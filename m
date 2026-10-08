Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3083DD521
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791454305; cv=fail; b=Kc0KUPxTZlVuBTXiqr84FZG7j8V5LJqUpVfjpJX0xh1UMPRigpbU0cv7/wfIr58SlhijWTLmGVTpg7I8f8ggQbnYnNvZP0l6ZVjsV+KO7s2mWEHx/xuxW5Bk94nYGNGk/C8LcxETYmSURMNIPRICtHgZlC7QdGM8lyJBn11hVM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791454305; c=relaxed/simple;
	bh=NvbT1LxBnU2Ueile7FGWXtKWB7KfnecSLupXTkhvm48=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LdbjqHqYchktIN48hr3KwTZdVIJuwKagDsmJgZiR5hUJn48UdRmNRUpScFExmTCK3Fo1Vc4YSz2Miv27Ruu1GaquZ51gUQw32lfjEYtwkX9cAyvgpM9YSxKp1/wk3qOl3k7UBvmAVmjsG09fJHxxeOvZSDi42w4GG61neZI1Z1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=h9zZWew2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=X2QLcznO; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="h9zZWew2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="X2QLcznO"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987MVKS2874951;
	Thu, 8 Oct 2026 02:37:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NvbT1LxBnU2Ueile7FGWXtKWB7KfnecSLupXTkhvm
	48=; b=h9zZWew2MiwPv4S/mgV5JGVB8EgPQ9Jr6KmbND/0+BmxC+ozKwDgwsiMS
	UXqvBSvt42xWovy059b7QUmhukUR+d+qR5RzNGcNNMBzrnLLTmHBVskYNc2/LOKQ
	oEWrKnG37TQlQaww+cnnjWhXrmo2wp7FsTp8/SlADXdZ+v92UspJx018a8dpQODe
	PZcp8vmxhf83FSDSMI09+/DaoFAcYHOdgrLhPZBGf5gxUXHPdB/i13cn1a5PJCRQ
	exKB8KvKYJ5hfSEWdIBY0P6ogc6mgy/nae71r8YZ7YV7imPztHUPHYvPrCDFITJ7
	Mefk7iFjCRm2yZMy1kC2oqLMtRGfA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022097.outbound.protection.outlook.com [40.107.209.97])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4h5xe6999g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 02:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnA3HwpJ3A1M4fik3VOi6E2naxEAu2YjoXGTc4KzYM0lqniTlcQAytdq3A8vArLcNsmsNTurBPPAtzZExMh9T961M9pVeNSYIfVCmFzckLyHvfiQvr9h2mzINdvPpNc5I82c2IqzkF20BzCNxuBVi3hH3+FWK9j+Hx+L9CWWpPLTzmd4+bUUrdSRQoptKOLLBTvLDb71J2aLj5rBPlgU8DoJUomYrPWqlu4IMoiVEhLMBFdr+9NQEHukjeePtSJl9gN6ut0KZFl9xk5lN0ftaJdou2rwE9pyiVCIEsr+qwOFeCRm8GxY2O3GfdJCUDJ5cpqE/hRcNET0UpKz8BU/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvbT1LxBnU2Ueile7FGWXtKWB7KfnecSLupXTkhvm48=;
 b=TGmlC8+TBqHyLCU9GntLLqfvfPqBu2Wc8JcluA6KLKlHyYGFBo3iBiJjsA4ecJhAQer1LGkz/UBiszOEsbAgbf3V2/9hrb0Kaz3oXzIKpjcfOoSRYG4d5Gys4hTsNjB5+zmGQJTMwpb3Mvlsj7q7+vxco/AcC8xxFohvABe7K7ab4rr1X8hSCOKhlovqppSeYYmsHkQPacznm6p+CiyCJ+aFX9DmDIgzVBQnheEU394KKhnSaNx80varoJr7MhvgXEX0dmOJ9Cas639Fci61wVd8vNDMOKhslktQK5occNQB71uo40cAajyMBySyApjh5wVBth1W09mrHZl8z8weqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvbT1LxBnU2Ueile7FGWXtKWB7KfnecSLupXTkhvm48=;
 b=X2QLcznOTUYRcciAzgwWBtDSe/w0FPRUXXxlsnLcFj9tJjqDSk0BUN8XbZ6iXWmTuPFqyPtaDfjor+iYRMncEliTrQ8UX21FeEktXETcZHvLU3m5Hl++8+Dgn0KH7KSxBl0V+gjfvduu2PFGz8k4Z+EF5//tCROfmZr9HIV9pqrFXubRWjQiGdxZQtP5K0sXcrQQ1BE7sLV5ZWU6bfeyhxzOuvUaUh4k2D7PRvnQ1PUAauA6Hx2rUPFrTHRzUZrO9S6uFAPAOteF3+h+R2zDXbdD2W1xJdo8/WY0W3WXJxqjkQCb5r2BtRhi/eoFUaYjPxhYTc7xXoOj/LuizIW0Vg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB055497.namprd02.prod.outlook.com (2603:10b6:5:30c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 09:36:57 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 09:36:57 +0000
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
Subject: Re: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Topic: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for
 SYSREG props
Thread-Index: AQHdUK4qGSxCvB0G5UGqlyLcKR6RWrbzUVWAgAAeYAA=
Date: Thu, 8 Oct 2026 09:36:56 +0000
Message-ID: <A5B31865-5901-45F3-B782-274DA54E8615@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-18-eric.auger@redhat.com>
 <CECAE32E-9A75-4D8D-827D-9F25D026F364@nutanix.com>
 <dc5aecf7-db4f-4b16-92fd-432d663ff900@redhat.com>
In-Reply-To: <dc5aecf7-db4f-4b16-92fd-432d663ff900@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM6PR02MB055497:EE_
x-ms-office365-filtering-correlation-id: 230fa622-0690-447e-c3e1-08df251fb1f3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|56012099006|4143699003|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 99Wh+eHGROkl9Dlz3bA1AjIh3Xk3wEX+7GWiXCUfOmma0T3nUuzJBt9JaZce8xMAX/TdHe9jUC0I7HsyPeQcpdHCXpiy8mNLrZn6ART2kzDt0DgMJNuMCrpWF9/xbgrrHqdLODPiN8nV+Js5MmbRKCPp8Kr1XVrdHLLiinqJQyFeRUNcif3jWT27sdDAeK+4FVhqiJWoQYD4v4eW2nixkdzoT5KmvE0TvD6OtRdWI0t8cB0QeZmsh4yNNzCAWRTCmLPjPEssLSi7c1mbEqD67vfUA66L39Y0Mv43hXxBEyK4sjl8wtdNqllYyc+xybsXRh+tf8hewhoiiU+hUpJs1LmkCN1TUUwm0n2yRvWfdGoJCUUTMhBJFlYTiOccbqmSu2IRwLArJZgPVZcRlcXPcKjhRYUXpk09JSAtVRvZows6M76i5I3IhPZO3WTQVJ7teJRPkDTWyFJNZI3uXA6/3+Z8pmXgDXSQrZ0mahMPDTMEd3viUZskeDS/WWJIW3+b79a289zDU6AY/Okp7pmh2fVMYucAxFItBQf7TCy7JxACRc4sVzzvcx1zjsABJwhwz2abJQH8I1C24YIvKn4xKFpXkyT9hxRUIb8RRgvwzS468LSh6viVhCJsK1vh2NwA9dzbexpeqCxTINdFQVYbyEfEOFu3/PmDKePmrwYwVhSXoeqowsCErTvOYPi6wSQcZ8zTQsn69LKe7LfiS62RyOOlhb7KHoJeLKF7Og/lS3s=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlM5N0hnZFU0SWRTeUVKVGk5UUozK20zdG5UT3VxdFphbmRIeXYyVGlKUEJG?=
 =?utf-8?B?LzFyK3RwdUllTXpBbWNyTEJEVDkxZVExc3ArWmpKdVhjUjNrMDBxYWJ0K2xS?=
 =?utf-8?B?YXBJTFAvdDlsYXY5YytNM08xZDdFWXl1SzBpN20vNDMwb1NteVhsQ3VVY044?=
 =?utf-8?B?OHVUb1IvTVZDMHhscnpjaWplQmh5Q0d0bjlMTFRBSndNRGZEQkVtNk9kczZC?=
 =?utf-8?B?Ri9CVzEvK1Q1WVZGYjBCVzNjTFdoby8wKytqeTBEcWVZVytOWjB6TEVmTUFr?=
 =?utf-8?B?TnMvUXJkMFZKNkM4QU9Td1k4NUluRk5jZmoxYU0rSHpyOU9TaFArcUxkSUIx?=
 =?utf-8?B?QjhHaWUvbzk4NnljTm5MVWdYWjExMCtidDhZTWhPRmlMUXNIaFV5ZnZjeDds?=
 =?utf-8?B?dmZRQWNraEp1dFlyZENMOS9BU3REc2lEZjhzOGYwam9vR0lIODk3a2NVMkRM?=
 =?utf-8?B?eGExSmQzY0VKSm5wTWhacW8ybjdUa3ZhSnVKMDVKNWJhT1ltVU8yanpTS0ZZ?=
 =?utf-8?B?NHRkbGhPL0tDV2YyNmJYMitpcUNWYm81NU9UN2k2L1NDdnR6QkhOLzJmbHhB?=
 =?utf-8?B?SUgzajUwV0tvTlJYRG1QV1JhVEZ0TGNjMUprb2hKaEJxbnZiYTdiZGY3UTZ4?=
 =?utf-8?B?SWl5ZWdKb3pmTkhkV0d5elRTZUtlOUUrM3VwOHU0QVlFYjc4RnN6WXpHK2wx?=
 =?utf-8?B?WnBhU1hQYWI1T3BkQjVzWGluUU9lU2k3KzFkNndPb3BXVW5zbVZPNDVRZVBr?=
 =?utf-8?B?ZU1xN0JDUzVlaEpuWTJHMzdMbGYyckplNW1icWYvYU5NUDJBUFdneExVVVZF?=
 =?utf-8?B?dTNjMUZEWFFDZmt2bmJJd245WXgzWlBJbml6elIzMURJZ0tyMXlSKzhwY3ZO?=
 =?utf-8?B?dnlha05scVBNa1ZVVUpkeXNSdGc4MEhIM05VOFJkc0U1a1NsTU5kK3Zza3Jv?=
 =?utf-8?B?ZURmTzFhYWRWWkhYeFRmci93YWVtdmlxME5adjdEbThDNytzSlpWTDJTVHU0?=
 =?utf-8?B?NjRwNlF0MU1UK0dMVkpIOWh2RkxoZytsYTcvWklRMWIwOEFpUDFjMVo3M0dQ?=
 =?utf-8?B?MFQ5dDV5eUlCMHJXQVBqRmtTZDJjNFY1V2s2OEc2Mjl5T3l3L2V0bm5FOE5p?=
 =?utf-8?B?cWI3TU5lWGdSenFsSjY2Sm9RTDZxdmZIZGNjOGlIUVBVWlJPVHJUM1AzRFY4?=
 =?utf-8?B?RE51R0JBUkJ6K3M0alY0NmowM05maUgwRzdsQWZYbm5RWFROUzFKWWwvWHdZ?=
 =?utf-8?B?Z1U2YmtYRG5YQ1RtaktNdExxeHpWSmQvSTVlWFVZNG95c3l6MlEvSjVBS2py?=
 =?utf-8?B?Z3dnWEJ4T3QrZG5tc2tXWkRIbHpkNFVhS2NNNXl6aUNPL1ZvWHpiRGE3UjBB?=
 =?utf-8?B?UDFyK0xqOXd4OVZaT3I4aS9CMkZXNTlIaGg4Q0ZVMmNmR0I2VmNIbjJnOS9V?=
 =?utf-8?B?L3E1b0RCNW9XSXZhekcyQlNRcUsvZ3pSZTF6b0hxZjVBQWZxanNINFd0SGx1?=
 =?utf-8?B?OExRSjFnSm81SnhCNFI2aFllQUdaNXB2V09xbGdHTWNTQTZ0WlE0K2xYVUFj?=
 =?utf-8?B?Yk1XdFprRDM1ZHcwbkxUWlBYQmJDSUdJYVYwcDQvYzlTMDkySlh2dHdIZms3?=
 =?utf-8?B?RDluSU5wQVU2b3JTQ2RUOWZuVVRkL05YS0psYVZnQ3U0NFNRUlpjYlJsNUVJ?=
 =?utf-8?B?czNKMDNyaU9ZeFFFQ0NtaGxOQjFTcFJGNWFjek16MkxQUFF6MkJaQk9OYkpi?=
 =?utf-8?B?d0t5anRJNVdKR2dHT1lBRXZ2WVNZbE9sMEtWeS9tUDFQTmhST0YvRFBjMW1h?=
 =?utf-8?B?eHArTlJWUWpTdzArcktJSG9jQmhFVlFUUHZyQWg4QmVMM2ZEZWIzb2F3N2xh?=
 =?utf-8?B?ZldpZkdOUWJ6TWJjcGhQMFp3T3U1MWxYV1hWeGRKTHlieEtOY3M4RVEwNEJk?=
 =?utf-8?B?cXhNM0FsekJ0T01YKzRTUy9Na2N6dzYzNmc5STdSNlEwZ1BNRFNCWlN2eDkz?=
 =?utf-8?B?UUtHYzVhQ01tK1RvWEs0RzIyOWhmQVpKNFdtaEt5bTNYOHdJUDYzY2FjNGFG?=
 =?utf-8?B?Sm95amROdExnOXY3aWZKTk5XQmZySGl3bzFjeks5UVhZb0VqUjlMNmZudTJN?=
 =?utf-8?B?VzRqTlpVa0Y4V21jMi9nOGNxY1lVdVRKSjV4eE55dVNrYVRKY0tjQnprT1NE?=
 =?utf-8?B?WS9MNlRMNVN5elB1M2EvVUhsQlliOHN4cE5WR3FMV1czTDZuRHJXYkJrMnRO?=
 =?utf-8?B?aVhhSWxsMVUzUU1tOEYxRWdYcVE3azN6K3haNWwyaUlvVldybndLN0ZzMkRz?=
 =?utf-8?B?YnRMT2g4MzVZVEtndWdtUHBqTjBkNDRKWUpNT1dVTVNjOEx6YTk3aTU1M201?=
 =?utf-8?Q?So5CrpJ73SmqltdQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <000D83D6BB67DE4E9E6AADBEDFAB1FBF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	XAOlXy7nErtGgl8Jg32W79R+heOWEMBu2f2K5itzMY3+5V384LAwW5qOLSUXaV0pAxezllMOkMyWBohoICjbFGiW8Sy8XhcVN4eq7ClhrlSUeYNuqq3qeZiPWbSCf/YJFnHPw9XuiqOCdv6tLp3FBvbHzegpA1Q7FLEoKLHLlFQiUM73q7pr1oTRDLtqMiKDCHaHMtsRYOttnBc41poO0+nwL3umYPjngGnit2hx3Tp4huSq8ZLjqfGn2EnAA54GczfCwrloL/iEptO2jRHICWweT/E0aMqUcMHjsHNtcSJExAoq3cyCDIZzsVTGVWvjCABAAHSFiFJ3NSeCkzdl5Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230fa622-0690-447e-c3e1-08df251fb1f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2026 09:36:56.9601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOdv2i/XbdE9/bHMKCQNvTBDX9v0SVubsnllCyU5zR2+m4NXPvbI7p55J6yNVFWuenQihmgL91cRZXKNT8ofg9nhE7o93WUjLNv6ZtwCISk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB055497
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzOCBTYWx0ZWRfX6+l6A98YXyuc
 XUWx27+ay+4Iw1ExsSmzDxwNSwJo+s56ZOp8qaCPhAlw1vA2Csv8JC4G+Me9eEPdEe+R7gG9qTn
 ufiHFvx5vqw5rROpHmcWxYv/LJOxkIjIHG3UO0IqSJeyed8G72e1vLXdxcR48lH2Vr/MlLqR29M
 4QryT+Bw1FooPjj36ri/i7EN8D/aqF7LSamD6elKtu3UmpB/1uMdOS4VfSIXZL256BB99xQ2vNf
 ONti/j/T9F7HzJKbZ586IDKvwQX6d6pECskgmHm7fcaa/R5eZIa//ysZvGUe1k36QjZdnL07N2g
 s3iKeTPFJppFLHkoO/9zBNyFQs4zHKTR9jAIWtAVjB+Z2gY4d9Nlw/4yJNB/pQbcp8ajVgtdKuY
 sgqY/48tS7m2LbLr++CPErmtqiKNhrpnRacKGeOhC5FXnXyUKtSs2bMzBJpFuGpm6K/ZknbRTDU
 0Eu4ox3cz/SWnEtMpog==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzOCBTYWx0ZWRfX5tz9ch4XIpCc
 Fvqw0MFJbBcKSq48GiZxAsYz7FokQdmz2ozYP9E4s+X5OR4pAUJ3jvoLoUqIteX5RzJHJIYUhCh
 g+49qpFhFApZIgjofV+3bU+jxL9zp24=
X-Proofpoint-GUID: -HaSR-RFOaYsTv3mllcWRFR9UmJr9KFd
X-Authority-Analysis: v=2.4 cv=Jv9kP84C c=1 sm=1 tr=0 ts=6ac7643c cx=c_pps
 a=r3te4Imtu9HTTQNar+7i2w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=Rm6tXRzwL3B33wMzA68A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -HaSR-RFOaYsTv3mllcWRFR9UmJr9KFd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gOCBPY3QgMjAyNiwgYXQgMToxOOKAr1BNLCBFcmljIEF1Z2VyIDxlcmljLmF1Z2Vy
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBFeHRl
cm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBIaSBLaHVzaGl0LA0KPiANCj4g
T24gOS8zMC8yNiA5OjM0IEFNLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiANCj4+PiBPbiAxNiBT
ZXAgMjAyNiwgYXQgODoxNeKAr1BNLCBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+
IHdyb3RlOg0KPj4+IA0KPj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+IENBVVRJT046IEV4dGVybmFsIEVt
YWlsDQo+Pj4gDQo+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4gDQo+Pj4gU2luY2UgbGVnYWN5IGNvbXBv
c2l0ZSBvcHRpb25zIChzdWNoIGFzIFNWRSwgdmlydHVhbGl6YXRpb24sIC4uLikNCj4+PiBhbmQg
bmV3IFNZU1JFRyBwcm9wcyBjb2V4aXN0LCBhZGQgc29tZSBiYXNpYyBjb25zaXN0ZW5jeSBjaGVj
a3MuDQo+Pj4gDQo+Pj4gVGhvc2UgY2hlY2tzIGFyZSBwZXJmb3JtZWQgYm90aCBpbiBrdm1fYXJj
aF9pbml0X3ZjcHUoKSBiZWZvcmUNCj4+PiBhcHBseWluZyB0aGUgU1lTUkVHIHByb3BzIGF0IHRo
ZSBlbmQgb2YgdGhlIGluaXRpYWxpemF0aW9uIGNoYWluLg0KPj4+IA0KPj4+IFNvbWUgSUQgcmVn
IGZpZWxkcyBjb3JyZXNwb25kaW5nIHRvIGxlZ2FjeSBjb21wb3NpdGUgb3B0aW9uIHNjb3BlDQo+
Pj4gYXJlIG5vdCB3cml0YWJsZS4gSW4gdGhhdCBjYXNlIHdlIGp1c3QgY2hlY2sgdGhhdCB0aGUg
ZmllbGQgaGFzDQo+Pj4gbm90IGJlY29tZSB3cml0YWJsZS4NCj4+PiANCj4+PiBTaWduZWQtb2Zm
LWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+PiBIaSBFcmljLA0KPj4g
DQo+PiBHYXZlIHRoaXMgYW5vdGhlciBsb29rLiBJIHN1Z2dlc3QgbW92aW5nIHRoaXMgdG8ga3Zt
X2FybV9leHBvc2VfaWRyZWdfcHJvcGVydGllcygpLg0KPj4gV2hhdCBJIHN1Z2dlc3Qgc3BlY2lm
aWNhbGx5IGlzOg0KPj4gLSBIYXZlIGEgbGlzdCBvZiBJRCByZWdpc3RlciBmaWVsZHMgd2hpY2gg
Y29uZmxpY3RzIHdpdGggbGVnYWN5IHByb3BzLg0KPiB0aGlzIGRlcGVuZHMgb24gdGhlIGRlZmlu
aXRpb24gb2YgImNvbmZsaWN0Ii4gRm9yIGluc3RhbmNlIGRvZXMgDQo+IA0KPiBQTVVWZXIgY29u
ZmxpY3RzIHdpdGggaGFzX3BtdT8NCj4gDQoNClllcywgUE1VVmVyID0gMCBpcyBpbmNvbnNpc3Rl
bnQgd2l0aCBoYXNfcG11PXRydWUgDQoNCj4gTmV2ZXJ0aGVsZXNzIHlvdXIgc3VnZ2VzdGVkIGFw
cHJvYWNoIGNvdWxkIHdvcmsgZm9yIHByb3BzIGJlbG93IHdoaWNoIGluIGNhc2UgdGhleSBzaG93
IHVwIHdvdWxkIHRyaWdnZXINCj4gICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vdyBl
eHBvc2VkIGJ1dCBxZW11IGlzIG5vdCByZWFkeSB0byBzdXBwb3J0IGl0IiwNCj4gICAgICAgICAg
ICAgICAgICAgcHJvcG5hbWUpOw0KDQpJIHdhcyB0aGlua2luZyBvZiBub3QgZXhwb3NpbmcgdGhl
c2UgcHJvcHMgYmVjYXVzZSB3ZSBrbm93IGl0IGNvbmZsaWN0cy4gU28gaW5zdGVhZCBvZiBjaGVj
a2luZyB0aGUgc2V0IHByb3BzIGluIGt2bV9hcm1fdmNwdV92YWxpZGF0ZV9zeXNyZWcsIHdlIG5l
dmVyIGV4cG9zZSBjb25mbGljdHMgaW4ga3ZtX2FybV9leHBvc2VfaWRyZWdfcHJvcGVydGllcw0K
DQpJIGFtIHN1Z2dlc3RpbmcgdGhpcyB3YXkgYmVjYXVzZSBmb3IgbmFtZWQgQ1BVIG1vZGVscywg
d2Ugd2lsbCBoYXZlIHRvIGhhbmRsZSB0aGlzIGNvbmZsaWN0cyBkaWZmZXJlbnRseS4NCg0KDQpJ
IGhvcGUgdGhpcyBtYWtlcyBzZW5zZS4NCg0KDQpUaGFua3MsDQpLaHVzaGl0DQoNCj4gDQo+IFRo
YW5rcw0KPiANCj4gRXJpYw0KPiANCj4+IC0gaW4ga3ZtX2FybV9leHBvc2VfaWRyZWdfcHJvcGVy
dGllcygpICh0aGUgbmV3IGZpZWxkIGJhc2VkIGFwcHJvYWNoKSBuZXZlciBleHBvc2UgZmllbGRz
DQo+PiAgd2hpY2ggYXJlIHBhcnQgb2YgdGhlIGFib3ZlIGxpc3QuDQo+PiANCj4+IFRoaXMgd2F5
IHRoZSBzYW1lIGNvbnNpc3RlbmN5IGxvZ2ljIHlvdSBoYXZlIHdpbGwgY2Fycnkgb3ZlciB0byBu
YW1lZCBtb2RlbHMgYnkganVzdCBhZGRpbmcgZGlmZmVyZW50DQo+PiBzZXR0ZXJzIGZvciB0aGUg
YWJvdmUgZmllbGQuDQo+PiANCj4+IFdoYXQgYXJlIHlvdXIgdGhvdWdodHMgb24gdGhpcz8NCj4+
IA0KPj4gVGhhbmtzLA0KPj4gS2h1c2hpdA0KPj4+IOKAlCANCj4+PiB0YXJnZXQvYXJtL2t2bS5j
IHwgMTA1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
Pj4gMSBmaWxlIGNoYW5nZWQsIDEwNSBpbnNlcnRpb25zKCspDQo+Pj4gDQo+Pj4gZGlmZiAtLWdp
dCBhL3RhcmdldC9hcm0va3ZtLmMgYi90YXJnZXQvYXJtL2t2bS5jDQo+Pj4gaW5kZXggZGRmMzIw
ZDBlNi4uZjUyYzAzNzQ1ZSAxMDA2NDQNCj4+PiAtLS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+Pj4g
KysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4+IEBAIC0zNDAsNiArMzQwLDEwNyBAQCBzdGF0aWMg
QVJNNjRTeXNSZWdGaWVsZCAqZ2V0X2ZpZWxkKGludCBpLCBBUk02NFN5c1JlZyAqcmVnKQ0KPj4+
ICAgIHJldHVybiBOVUxMOw0KPj4+IH0NCj4+PiANCj4+PiArDQo+Pj4gKy8qKg0KPj4+ICsgKiBr
dm1fYXJtX3ZjcHVfdmFsaWRhdGVfc3lzcmVnOg0KPj4+ICsgKg0KPj4+ICsgKiBWYWxpZGF0ZSBh
IFNZU1JFRyBmaWVsZCB2YWx1ZSBpcyBjb25zaXN0ZW50IHdpdGggbGVnYWN5IGNvbXBvc2l0ZSBv
cHRpb25zDQo+Pj4gKyAqIFNvbWUgY2hlY2tzIGFyZSBub3QgaW1wbGVtZW50ZWQgYmVjYXVzZSB0
aGUgY29ycmVzcG9uZGluZyBzeXNyZWcgZmllbGQNCj4+PiArICogaXMgbm90IGN1cnJlbnRseSB3
cml0YWJsZS4gSW4gdGhhdCBjYXNlIHdlIG1ha2Ugc3VyZSB0aGUgZmllbGQgaGFzIG5vdA0KPj4+
ICsgKiBiZWNvbWUgd3JpdGFibGUsIHdoaWNoIHdvdWxkIG1lYW4gdGhlIHVzZXIgaGFkIHRoZSBj
YXBhYmlsaXR5IHRvIHNldCB0aGUNCj4+PiArICogY29ycmVzcG9uZGluZyBwcm9wZXJ0eS4NCj4+
PiArICoNCj4+PiArICogcmV0dXJuIHRydWUgaWYgY29uc2lzdGVudC4gZmFsc2UgaWYgaXQgaXMg
bm90LCBhbG9uZyB3aXRoIGFuIGVycm9yIGhhbmRsZQ0KPj4+ICsgKi8NCj4+PiArc3RhdGljIGJv
b2wga3ZtX2FybV92Y3B1X3ZhbGlkYXRlX3N5c3JlZyhBUk1DUFUgKmNwdSwgQVJNNjRTeXNSZWdG
aWVsZCAqZmllbGQsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgdWludDY0X3QgdmFsdWUsIEVycm9yICoqZXJycCkNCj4+PiArew0KPj4+ICsgICAgY29uc3Qg
Y2hhciAqZmllbGRuYW1lID0gZmllbGQtPm5hbWU7DQo+Pj4gKyAgICBBUk02NFN5c1JlZyAqc3lz
cmVnZGVzYyA9ICZhcm02NF9pZF9yZWdzW2ZpZWxkLT5pbmRleF07DQo+Pj4gKyAgICBjb25zdCBj
aGFyICpyZWduYW1lID0gc3lzcmVnZGVzYy0+bmFtZTsNCj4+PiArICAgIGdfYXV0b2ZyZWUgY2hh
ciAqcHJvcG5hbWUgPSBnX3N0cmR1cF9wcmludGYoIlNZU1JFR18lc18lcyIsIHJlZ25hbWUsIGZp
ZWxkbmFtZSk7DQo+Pj4gKw0KPj4+ICsgICAgLyogdmlydHVhbGl6YXRpb24gKi8NCj4+PiArICAg
IGlmICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDIiKSkgew0K
Pj4+ICsgICAgICAgIC8qIGNvbnNpc3RlbmN5IHdpdGggbWFjaGluZSB2aXJ0dWFsaXphdGlvbiBw
cm9wZXJ0eSAqLw0KPj4+ICsgICAgICAgIGlmIChjcHUtPmhhc19lbDIgJiYgdmFsdWUgPT0gMCkg
ew0KPj4+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+Pj4gKyAgICAgICAgICAgICAg
ICAiSW5jb25zaXN0ZW50IC1tYWNoaW5lIHZpcnR1YWxpemF0aW9uPW9uIGFuZCAiDQo+Pj4gKyAg
ICAgICAgICAgICAgICAiJXM9MCIsIHByb3BuYW1lKTsNCj4+PiArICAgICAgICAgICAgcmV0dXJu
IGZhbHNlOw0KPj4+ICsgICAgICAgIH0gZWxzZSBpZiAoIWNwdS0+aGFzX2VsMiAmJiB2YWx1ZSA+
IDApIHsNCj4+PiArICAgICAgICAgICAgZXJyb3Jfc2V0ZyhlcnJwLA0KPj4+ICsgICAgICAgICAg
ICAgICAgIkluY29uc2lzdGVudCAtbWFjaGluZSB2aXJ0dWFsaXphdGlvbj1vZmYgYW5kICINCj4+
PiArICAgICAgICAgICAgICAgICIlcyA+IDAiLCBwcm9wbmFtZSk7DQo+Pj4gKyAgICAgICAgICAg
IHJldHVybiBmYWxzZTsNCj4+PiArICAgICAgICB9DQo+Pj4gKyAgICAvKiBzZWN1cmUgKi8NCj4+
PiArICAgIH0gZWxzZSBpZiAoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0UEZSMF9F
TDFfRUwzIikgJiYgdmFsdWUgPiAwKSB7DQo+Pj4gKyAgICAgICAgLyogY29uc2lzdGVuY3kgd2l0
aCBtYWNoaW5lIHNlY3VyZSBwcm9wZXJ0eSAqLw0KPj4+ICsgICAgICAgIGVycm9yX3NldGcoZXJy
cCwgIiVzIGlzIHNldCBidXQgcWVtdSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+Pj4g
KyAgICAgICAgICAgICAgICAgICBwcm9wbmFtZSk7DQo+Pj4gKyAgICAgICAgcmV0dXJuIGZhbHNl
Ow0KPj4+ICsgICAgLyogTVRFICovDQo+Pj4gKyAgICB9IGVsc2UgaWYgKCFzdHJjbXAocHJvcG5h
bWUsICJTWVNSRUdfSURfQUE2NFBGUjFfRUwxX01URSIpKSB7DQo+Pj4gKyAgICAgICAgZXJyb3Jf
c2V0ZyhlcnJwLCAiJXMgaXMgbm93IGV4cG9zZWQgYnV0IHFlbXUgaXMgbm90IHJlYWR5IHRvIHN1
cHBvcnQgaXQiLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgcHJvcG5hbWUpOw0KPj4+ICsgICAg
ICAgIHJldHVybiBmYWxzZTsNCj4+PiArICAgIC8qIFNWRSAqLw0KPj4+ICsgICAgfSBlbHNlIGlm
ICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9TVkUiKSkgew0KPj4+
ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vdyBleHBvc2VkIGJ1dCBxZW11IGlz
IG5vdCByZWFkeSB0byBzdXBwb3J0IGl0IiwNCj4+PiArICAgICAgICAgICAgICAgICAgIHByb3Bu
YW1lKTsNCj4+PiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+Pj4gKyAgICB9IGVsc2UgaWYgKCFz
dHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NFpGUjBfRUwxX1NWRXZlciIpKSB7DQo+Pj4g
KyAgICAgICAgaWYgKGNwdV9pc2FyX2ZlYXR1cmUoYWE2NF9zdmUsIGNwdSkgJiYgdmFsdWUgPT0g
MCkgew0KPj4+ICsgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJzdmUgaXMgc2V0IGJ1dCAl
cyBpcyBzZXQgdG8gMCIsIHByb3BuYW1lKTsNCj4+PiArICAgICAgICAgICAgcmV0dXJuIGZhbHNl
Ow0KPj4+ICsgICAgICAgIH0gZWxzZSBpZiAoIWNwdV9pc2FyX2ZlYXR1cmUoYWE2NF9zdmUsIGNw
dSkgJiYgdmFsdWUgPiAwKSB7DQo+Pj4gKyAgICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgInN2
ZSBpcyBub3Qgc2V0IGJ1dCAlcyBpcyBncmVhdGVyIHRoYW4gMCIsDQo+Pj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgcHJvcG5hbWUpOw0KPj4+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+
Pj4gKyAgICAgICAgfQ0KPj4+ICsgICAgLyogUEFVVEggKi8NCj4+PiArICAgIH0gZWxzZSBpZiAo
IXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0SVNBUjFfRUwxX0FQQSIpKSB7DQo+Pj4g
KyAgICAgICAgLyogUEFVVEggUUFSTUE1IGFkZHJlc3MgYXV0aGVudGlmaWNhdGlvbiAqLw0KPj4+
ICsgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vdyBleHBvc2VkIGJ1dCBxZW11IGlz
IG5vdCByZWFkeSB0byBzdXBwb3J0IGl0IiwNCj4+PiArICAgICAgICAgICAgICAgICAgIHByb3Bu
YW1lKTsNCj4+PiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+Pj4gKyAgICB9IGVsc2UgaWYgKCFz
dHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NElTQVIxX0VMMV9BUEkiKSkgew0KPj4+ICsg
ICAgICAgIC8qIFBBVVRIIEltcGwgRGVmaW5lZCBhZGRyZXNzIGF1dGhlbnRpZmljYXRpb24gKi8N
Cj4+PiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3NlZCBidXQgcWVt
dSBpcyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICBw
cm9wbmFtZSk7DQo+Pj4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPj4+ICsgICAgfSBlbHNlIGlm
ICghc3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9FTDFfR1BBIikpIHsNCj4+
PiArICAgICAgICAvKiBRQVJNQTUgZ2VuZXJpYyBjb2RlIGF1dGhlbnRpZmljYXRpb24gKi8NCj4+
PiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3NlZCBidXQgcWVtdSBp
cyBub3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICBwcm9w
bmFtZSk7DQo+Pj4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPj4+ICsgICAgfSBlbHNlIGlmICgh
c3RyY21wKHByb3BuYW1lLCAiU1lTUkVHX0lEX0FBNjRJU0FSMV9FTDFfR1BJIikpIHsNCj4+PiAr
ICAgICAgICAvKiBRQVJNQTUgZ2VuZXJpYyBjb2RlIGF1dGhlbnRpZmljYXRpb24gKi8NCj4+PiAr
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyBub3cgZXhwb3NlZCBidXQgcWVtdSBpcyBu
b3QgcmVhZHkgdG8gc3VwcG9ydCBpdCIsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICBwcm9wbmFt
ZSk7DQo+Pj4gKyAgICAgICAgcmV0dXJuIGZhbHNlOw0KPj4+ICsgICAgLyogUE1VICovDQo+Pj4g
KyAgICB9IGVsc2UgaWYgKCFzdHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURfQUE2NERGUjBfRUwx
X1BNVVZlciIpKSB7DQo+Pj4gKyAgICAgICAgaWYgKGNwdS0+aGFzX3BtdSAmJiB2YWx1ZSA9PSAw
KSB7DQo+Pj4gKyAgICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIDAgd2hlcmVhcyBw
bXUgaXMgc2V0IiwgcHJvcG5hbWUpOw0KPj4+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+
Pj4gKyAgICAgICAgfSBlbHNlIGlmICghY3B1LT5oYXNfcG11ICYmIHZhbHVlKSB7DQo+Pj4gKyAg
ICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgIiVzIGlzIG5vbiBudWxsIHdoZXJlYXMgcG11IGlz
IHVuc2V0IiwgcHJvcG5hbWUpOw0KPj4+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+Pj4g
KyAgICAgICAgfQ0KPj4+ICsgICAgLyogYWFyY2g2NCBmYWxzZSAqLw0KPj4+ICsgICAgfSBlbHNl
IGlmICghYXJtX2ZlYXR1cmUoJmNwdS0+ZW52LCBBUk1fRkVBVFVSRV9BQVJDSDY0KSkgew0KPj4+
ICsgICAgICAgIGlmICgoIXN0cmNtcChwcm9wbmFtZSwgIlNZU1JFR19JRF9BQTY0UEZSMF9FTDFf
RUwwIikgfHwNCj4+PiArICAgICAgICAgICAgICFzdHJjbXAocHJvcG5hbWUsICJTWVNSRUdfSURf
QUE2NFBGUjBfRUwxX0VMMSIpIHx8DQo+Pj4gKyAgICAgICAgICAgICAhc3RyY21wKHByb3BuYW1l
LCAiU1lTUkVHX0lEX0FBNjRQRlIwX0VMMV9FTDIiKSkgJiYgdmFsdWUgPCAyKQ0KPj4+ICsgICAg
ICAgICAgICBlcnJvcl9zZXRnKGVycnAsICIlcyBpcyA8IDIgd2hpbGUgYWFyY2g2NCBpcyBzZXQg
dG8gb2ZmIiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICBwcm9wbmFtZSk7DQo+Pj4gKyAg
ICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4+PiArICAgIH0NCj4+PiArICAgIHJldHVybiB0cnVl
Ow0KPj4+ICt9DQo+Pj4gKw0KPj4+ICNkZWZpbmUgTUFLRV9JRFJFR19LRVkocmVnX2lkeCwgZmll
bGRfc2hpZnQpIFwNCj4+PiAgICAoKCh1aW50NjRfdCkocmVnX2lkeCkgPDwgOCkgfCAoKHVpbnQ2
NF90KShmaWVsZF9zaGlmdCkgJiAweEZGKSkNCj4+PiANCj4+PiBAQCAtMjI0MSw2ICsyMzQyLDEw
IEBAIHN0YXRpYyBpbnQga3ZtX2FybV9hcHBseV9zeXNyZWdfcHJvcHMoQVJNQ1BVICpjcHUsIEVy
cm9yICoqZXJycCkNCj4+PiAgICAgICAgdWludDY0X3Qgb2xkZnY7DQo+Pj4gICAgICAgIGludCBy
ZXQ7DQo+Pj4gDQo+Pj4gKyAgICAgICAgaWYgKCFrdm1fYXJtX3ZjcHVfdmFsaWRhdGVfc3lzcmVn
KGNwdSwgZmllbGQsIHZhbHVlLCBlcnJwKSkgew0KPj4+ICsgICAgICAgICAgICByZXR1cm4gLTE7
DQo+Pj4gKyAgICAgICAgfQ0KPj4+ICsNCj4+PiAgICAgICAgbWFzayA9IE1BS0VfNjRCSVRfTUFT
Syhsb3dlciwgbGVuZ3RoKTsNCj4+PiAgICAgICAgdmFsdWUgPSB2YWx1ZSA8PCBsb3dlcjsNCj4+
PiANCj4+PiAtLSANCj4+PiAyLjUzLjANCg0KDQo=
