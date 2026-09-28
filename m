Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5E49B457
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601824; cv=fail; b=B9MbQqmIhPkhwR9bKDe1K4mJF9pVo9w/7C1HO7NGPezGcaEg8IobRaJkeHi1V1ljXrPFsaXH5uRhsdciz2rudbuQBRPROlRlheWO1ahHI/uRdIqiN9SC/KdzGf3OGcR1iKgitLvWZlMRTb8VVJu7XUammf87FI1Vs+VjezZl/Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601824; c=relaxed/simple;
	bh=Ek5yVsczsoLYab6+ZvUru96FblE6cGRfBLyFd21wwAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehfesVLcqd41UEvo4RcRwXYBnSez/AdxTXcEmeNwrfeaA68wLUOSFTL3Rs6wST2Lb5I1CDW7qUSuRTuCsq9Fu6jfXuE1kQLPNfKcjAb26ek4InVYxw0hiEGqPrXOtOkHlGvOkTeSI7cCYkGArsP/X20XQqWEP0rD/6djQkaMm6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kTERWPnd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GK7u8nPB; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kTERWPnd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GK7u8nPB"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBD55q1535206;
	Mon, 28 Sep 2026 06:23:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Ek5yVsczsoLYab6+ZvUru96FblE6cGRfBLyFd21ww
	As=; b=kTERWPndk77u//culIBfGItfGQke8vKzVJxjoHZJwEMftQJyzWYWYwcD1
	KexBAFZcupoS3+wrRLcU/PFQbI08UPH5gou99x8vwwnvZUNr/K0ispElXW2MxIIK
	Cg0wIYJFJS48jkU0My1zNsaOtACYwZrIaCWicb2zsbmfQBJmun2MIaajXnr2KzaU
	FPRKPXx7+gBwLEAT9XzvvIFv4Bccz74m6urWDPYlbLpFqLOUHsXsJP7inQUYYveG
	z19gaB78rygTQgctfQa9s2hprChvQd1557X0rf3x7uTfG+acXVZBhCgqWGpK0Twb
	vs4+4DlRnQwYi7zfgzQibssAmnGuQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020075.outbound.protection.outlook.com [52.101.61.75])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gx9y7436m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 06:23:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLZks68qNKs79IKEj6Uo3nHSqBiFqCboX+xfiqA8k6AUmnoem0+sAWzFlKS0PnDL0tBWRnVzM735Ter/Fq2NhofMrU1lUFRwfcVWteIxDwCVRBUDni5W9BtbiCEJGcOu2GnhKAJDzowkU51jh3TBASwJIA/ARU66A2pS5NVIYnQq2ZVdhk196jLp3U6wqRLfEQlA4CWCLMVQgDcADrhE8jt0NyNz2er6YqOIGL7KVKNo75PLCwMx17YXrY5WrBWkEmvRt3ddnVYZZc0YEwDmj9niVj978qEh5wgB7emwPurMb5B8Sv6LiwS7oN2fP2G26eqfeavZ0eIY8PyvEIEXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ek5yVsczsoLYab6+ZvUru96FblE6cGRfBLyFd21wwAs=;
 b=D6So8WbrYrpegL4jUZTaldN9TOVBgyp8/yYfalwZuKqQFEk6HllPPYamFxdn2yihoYJLpSCS8Qs4TLebHdOcX6jPJy7dtGUF/8apP/TqQ/R2x1FkJKKcZYv8eNRZ8FK+6/KWJXfoHzB9ITF9OJQxNWSmLdcNwd4XkXtD54shbvoqBiY9HG/w7TYwZjLB47GuEeOxFTbxBWB4n/WWJMf7WviyGvb8qsPArJ9ZOs+n9wEhDo721VHf4nc9w4NN2Vo6NHbtJUxgvMvcIQpNigrzRGpmdL4lCxau9BlAlBFzOWN4jPrNuxlndbZsrLtQDP4DavQm/0iFupeu/Ae4UIkmdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ek5yVsczsoLYab6+ZvUru96FblE6cGRfBLyFd21wwAs=;
 b=GK7u8nPBUw+ZmldFXHOLyv9C5z2GrZS3+m7qvYk3/4+GA48aklElqrfKx+y7wikkX4Dls6q4FCq4r0k744NKNd0iFDEpvKVQIayZj16/OM32xYYj1ZVCIZZo4+G2oCmwDizj2gUQFwp04koEaMkut6NIC4fBZ77Ov73gKUgYvwOUwa0FbYtWWMvlWb082I8WF/lrC17yaoioiFFvv6BmcD3Pj2cWajd0HBIZkpCvSC9AmAXAutFasZtM6w4vLgtDxaY/SLWAqAR6cyQQukcbfireeG175sAO8mAZKrP5M0boBxVTG9P0SLqzNoOY0Y3C3ds8wthrD8tuK7DQpJflhw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH0PR02MB8117.namprd02.prod.outlook.com (2603:10b6:610:10a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 13:23:18 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 13:23:17 +0000
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
Subject: Re: [PATCH v9 10/26] target/arm/kvm: Retrieve writable ID reg map
Thread-Topic: [PATCH v9 10/26] target/arm/kvm: Retrieve writable ID reg map
Thread-Index: AQHdTOqt02gXbkhXxU6xCmbY0cTM8Lbj8ZkAgAANjwA=
Date: Mon, 28 Sep 2026 13:23:17 +0000
Message-ID: <7920D0B3-76B6-49E2-B6E5-A313B386B53B@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-11-eric.auger@redhat.com>
 <FC2C35F5-6C1D-4C8C-B4E2-9D2EB1924445@nutanix.com>
 <c70d8f51-958c-43cd-b07b-96f2a4fada6f@redhat.com>
In-Reply-To: <c70d8f51-958c-43cd-b07b-96f2a4fada6f@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH0PR02MB8117:EE_
x-ms-office365-filtering-correlation-id: f9823afa-2d13-41f0-71a4-08df1d63a860
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|38070700021|56012099006|10067099003|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 PYQCQ4biUnB/rYVwlcbnNG8cTAZ0D+57Zt2Q0+33HCi8fKwR5flZwHjmKVaSt7c7gvi/2k8saSsfQfWNQb9zWJK3niMC+WSgRnHmQ+7s66tbfNQvtcCZIgVR9irnEmOS/3cWfag12cQbUy0ytsjJ1j/a2NxHMEF0C01K9Nu5Jg2U6E12QkNS/huZd5Ruhl4+ErcD5q8t2D8xWiDWqTWwmrlslvzkY9aqtrJ4PSttJZtVD294DkCknu1q5ST2wOia7sw7klo03dgcszglKEz+MzVoeaUo25YV73WvKwu/4VfLKSB6SyZrZ/O4XTFoxd9GGaL+mSlhK1Kz+mL0YHq8DeezwtphY0f6xcP5yu2qzWVIrlo7ag8/D5xdTxRKSVpuDB6dhDq/eqwc4P7Tw3sY0iKiyRNrkKMEJeU/3UAh+KvTlqWbNwE5VWcTHcWvc+UWzjEI8A04JmB8WRlG9W7TWCh75eM8hY6AcE/mkP9ZqcfqCru2gqQCQwkUOvVTRkNE9A2Vd5/2pjIjmU1FTUE49GyvPGiouPHGtjVZvcHWBUbLQfSDKMU3rNI58VGVnzGrCe6ksrjEvW4JPvsNdM5VwqPi0rmd/TISBRl57ScVNiVSPukXExotXTTNw9wjWAwkrPmYwKhUvVQ3h71jVcrNrXL6NW7CoG9Q/fxg5GFKRutdH9BSPbosGzLX6peFpPfh6cnzuNJNzj2YSpj8LVZ5GQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(38070700021)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UTdDTVJFL3JZZ05UZWp3Mk1BYm9wcTVJOFA0c0h5UHN3dit1eFlCZ0hxZlg5?=
 =?utf-8?B?NE5SU0FxZHhibGNMb0UvMjVNcGY3Y0JRRnhRL1AzckU1WGJqQ210dTdoa0dQ?=
 =?utf-8?B?TlQ3enNkZkN3UjMwMjJPeWl4Nkg5VjMvZER0R3RBMERSQlVlYTRjSWp3c3J6?=
 =?utf-8?B?eHZUamMrOVN6Q2hMWDludHMvdUpjRExoTmxsMnFYeWY2WFgzUEhOZDIvR3Y0?=
 =?utf-8?B?SlpHMmZtK0xPTnR0c3o1SnFqT3J5UUhuaEtPcDRiVXNDZUVlckxVUzFrY2JH?=
 =?utf-8?B?NkwxSE8yNWtVK3AyRFBkMkJYQlR4bk9qUzNvbVphb0dUSnpoeE10RStYTjZD?=
 =?utf-8?B?K2JoS0NGRXZvbFp6dCtjQ1dKZXkwY1BGUGhacFRRZ2dYS1ZQRjNXNWFHT2Nt?=
 =?utf-8?B?ckowUWh0dTV4Z1o2ZGFDTSt5ZmllR3JmcXhUMGxrNEtyVHBhUUovcERPS3Vw?=
 =?utf-8?B?NVJkaTFBYm9CZ1B6dVZOdzcxZ0FXSVRyK05weEsvdUY0NnR2WGRRbVpBdGZS?=
 =?utf-8?B?eGtSVXh0Zm5CZVZ5YWk1NTZMeDNOZkx2SlZHeldxclFQR0hwYjRNWVBhbDkw?=
 =?utf-8?B?TWZvMzJLWTRKbDJqY1RRMFNMN0NZUzRzL0ZJU0M3WmNXQW5MbnJxM0VhTUpp?=
 =?utf-8?B?Ni9zZ00rSitVU2pBdzFZSndRQTVwZW5BdC9qMGJxQ0dVSFkvbkFINmZtZ3JY?=
 =?utf-8?B?R1V2MmZ5czJSZUFRUFl3N3UrZldXZW1qUG1lSkduMURnOUlmUC95bWhsajk5?=
 =?utf-8?B?YmROVkpma2FFbnM3T2FVUThUUHNUZ212NkMwQkszbkFvRlFEbDdRNDFvcWFP?=
 =?utf-8?B?bnJDV0pvdUNoTGV1cU11aWdXNVBKd2dzUWx1OHhYVndMeHdSRjc2bGlJa3Yw?=
 =?utf-8?B?alQ0NGdzWlZFOFVZNTc2b05yTW50YXJlUVNjREVwVFdwZmN5QVp0WXZ2Vk9T?=
 =?utf-8?B?aktIazNmNUhxTXR1TitHWlR5eTU4SCtiSll5c3UwSjJNY1Z2eHhXd3M3bnlE?=
 =?utf-8?B?UkQxVWlkUWIyUzE3aUhUMjJTR1VHSk5mNHdLWEFGdGJRUnJUZi9uODJOWmJZ?=
 =?utf-8?B?S1F5TkNOZzhMVHNyOVBrMVl3akcvczdhV0FBaGw1Ry94cm5yUEgvUEZjVHZ2?=
 =?utf-8?B?R3J1ZXJZQkwxVVczQkYyaVBrYXBack0yVWUwcGFNQXdIa09leWdsSlVsa3I1?=
 =?utf-8?B?dUNXZ2tMeXNTUDByUldlWXphMlczVTE2dzcyY3dRSUc2ck5OZkN0WElFSFE3?=
 =?utf-8?B?YVhWb3pzK0xnUkhnd2h4eGlRbytwQ3J2Yjk3ZHhjdkpybXRVYytGOThScXdZ?=
 =?utf-8?B?VGlHS3ovVHhaN3FCL1JMbGowNHFkVGRvWlJrbmJQazdWKy9DVUd2Sm1EU1pC?=
 =?utf-8?B?VWRMS3JMbm1OVyt3ZEdDZVd4WEl3R1EyaFNOWWh2NW1LZkY4RGxlK2U1Sm9X?=
 =?utf-8?B?UWRzd3k0cU5hdmw1YU1Sb0x6RmJjNE56RU5BU1BaYWpZSXJRNXM1YU5ROU9u?=
 =?utf-8?B?eUV6V1k2bVQ0dytXeEN4YUdFSmpDc3IwRDhkeFh4cjBzZkFHcEFQOHp1RkM3?=
 =?utf-8?B?K1prVmEvT2FpNEdxYlFSbVZLVktUNE9yV1c2L3ZlYVJWZXZqUkdPeHN2KzdU?=
 =?utf-8?B?d01uY3Y4alJUSWJVcnhzYXBUY0ZLWkFaTGNyYjZCYlpyK3VvUVNTN0t1RVd4?=
 =?utf-8?B?VWk1eXBlSTV1bkhQM04zVGdhWi9ucDU4YitiU3hlTnZiNDhaZ3J0T1IxN2I2?=
 =?utf-8?B?YzRUUGJ4Z0xiZGdhWkR0SGVUcUQ2b3pxbnRBMFJYQzRoaDIrT1MxSkt6VW1T?=
 =?utf-8?B?MXMwRUlmaG02SmJ0L2lOMHZUUklhalZrQjZtckEyVTNXeHIwSjg5d2tNSCtD?=
 =?utf-8?B?ZU5uVVNNUTlsSlQ3QmV0Ty9aNURwZEx0dE5OV1oxZ1RBRWx0QnVKNnJvOGZD?=
 =?utf-8?B?S0hvc1RDSW9La2txSzNmNFNHMHR2dnZma0xqNk5DL2M0MlZtaENyWElMS1hW?=
 =?utf-8?B?KzlnWkpOOHY2aVRiTUVHc3o2Q0dLcTlzamc4dGlMeHVmdnZmWFFmQUlOWExX?=
 =?utf-8?B?NEZ4cnQ0WVpZTWFRMTlnczdVbExEeUZTOVBYYWdPNjlhUWtZSmlxbnRxMWdy?=
 =?utf-8?B?OHNZMlVjazJvRXVSMnZ2VXRmZjh1N0RrUGxYQTF3QXB3NTIxb2NZUGJxdGZ4?=
 =?utf-8?B?WW9VWHhtbi92aWJXdXc4SnRuelhzamVxL2xyeEY2aitBQUVRbGxsUG1mVVRk?=
 =?utf-8?B?UEc5VUx2ZHVwY3pNQThPWHFMMHVydmtOU2tPaWVjVHAwVktHemU1cktaTlpv?=
 =?utf-8?B?WE4yWXRjL1IwN2l4Vy9UNzBPaGt4ZXNWRXpGV2hEdmJZdDlINisxSnB5UENU?=
 =?utf-8?Q?HswBw9LMAVfwmrq0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DC9A52A274E4542AC551D194E06B0BF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	MWB1/YnSc61ZedIDBgaxUi6yR2a1M1enWPK1zZgXOOz5IUZs/h8thn2xFp6hyxKBZudsin4L79gB4zyX/6zwCag+qw1JTvNfnNq1gfyDxkc6vyKY0i/wzBq1Iha2hDZ3jRGGuy6xPFGkiiwVyaYJiBqH6ksdJ72OouxYNsLaeWLvGdmiP0LUyVjJJpnCYDu1pelq04WHJ1cTOqL6G8+kPGwCaLz5FIyopveqium6ZRLpWSxI5WJSrBsJE3rlJOEfpf/CJCEDuotXM/EhP/if3imm7k7ryg4u4pi7gF7vtSO+PKcpqJPkEVvdHwS+ShdvoMzkzMSIFxKe/Z02wQ5DMg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9823afa-2d13-41f0-71a4-08df1d63a860
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 13:23:17.3439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBT/2b9mW2OKn1tANxJIaBBrU7LqimyQN8cByN4hnpWSeIRd9sTRQV/I/4IxBhnHAh1t2GxxmDVNlDWT2oOpwt5f4eAa0X9RG16ScYixPCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfX+RWP/OU3o3S8
 trfwSuzoiliKuXa1wj1+NnfOYN7gagvvgOzJZSjDq94nmUrnqUWfj31/bSwBcViiHyCBhtnBzIo
 OVh6mlpylWfnBWLme2fTEkqU6F7EIDCb7KYQ+9QceftC4iMhGHg3kL0q92noHQdbAFqVEIewZct
 xZVS/XJg2L2ZhAacbIX9BAlIGJA4vSv9jm2+xX9ZMBkZml1nS6Ykng8GznzK1QcSWzDQrSrU16D
 6WOpIpohxDMGNGm6VVrFpYH5o23LY+FG5kc1o7XvI0QU/sNDELsKcs6dX3CmRcv1HIAVwXnaMgp
 pjCQydSXP+IVT+QzjwHWkazqKElRWjOQGRnsk/bNL1FUWJYVAGihhM8jllPPF5CsFHUv4dhM8xa
 jO3RWlnoBOmv2Wc7evodZg8CtnVua1pCrI7FgJ1ssEFcXdi+GL1mb8ItllgIwdheiP6fI/1ifik
 QFiReLM7Qmv9BJqJ6fw==
X-Proofpoint-ORIG-GUID: IWYtUpXUnPF4GxZCdJSOQ5d78gDSYUhp
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfX8rcp2kHNgPxu
 lW/KaiYwEX9AxgfiapnlVtnn2VBoUvvaCelKDzDmsz4m9WWKaCvdeZ1on8sf8ie5rESo0/ZXtem
 NPmtE+a0Xsxrx5AYmJH17JoOsHzkZt0=
X-Authority-Analysis: v=2.4 cv=c/A+0h9l c=1 sm=1 tr=0 ts=6aba6a52 cx=c_pps
 a=lGbZo3fvpWwFrLh1Calggg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=QhHjhpne-6u2cxrOt_QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: IWYtUpXUnPF4GxZCdJSOQ5d78gDSYUhp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjggU2VwIDIwMjYsIGF0IDY6MDTigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IFVzaW5nIGEgZHRiIHJlbGF0ZWQgY29uZGl0aW9u
IHRvIGRlY2lkZSB3aGV0aGVyIHdlIHNoYWxsIGRvIHRoZSB3cml0YWJsZQ0KPiBtYXNrIGRpc3Bh
dGNoIGxvb2tzIGZhci1mZXRjaGVkIHRvIG1lLCBhbHRob3VnaCBpdCB3b3VsZCBlZmZlY3RpdmVs
eSB3b3JrLg0KPiANCj4gSSB3b3VsZCByYXRoZXIga2VlcCBpdCBhcyBpdCBhbmQgd2FpdCBmb3Ig
b3RoZXIgY29tbWVudHMgaWYgYW55Lg0KPiANCg0KQ29vbCwgSSBzdWdnZXN0ZWQgYmVjYXVzZSBp
dCBpcyBjdXJyZW50bHkgdXNlZCB0byBnYXRlIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVz
KCZhcm1faG9zdF9jcHVfZmVhdHVyZXMpIGp1c3QgYSBmZXcgbGluZXMgZG93bi4NCg0KV2FybSBS
ZWdhcmRzLA0KS2h1c2hpdA==
