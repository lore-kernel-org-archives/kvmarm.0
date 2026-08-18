Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B8C29C327
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046385; cv=fail; b=OgsgzV1YE9ySpJ8Puoggy8+a+EbalyLGnccV/u3LcVHij8uuJtl+RXX3J654yZumzohaJvbQRLHysZ71/xQrnp0W95dQTjLhJbCjTXODJceEQuoDKuuLO7RFGaFll2TlIvWEAQsdYK3rum5ILXcYAv18EqLmz9ilV+yAm1LOUlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046385; c=relaxed/simple;
	bh=07wFu0xx1SnnGISev5AA8uIB0bWgGWM1e7CMmWcYRdI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fmdtmwENCVAa7+RinjiXngOz9v5X/YFc8lT72zjK2VoGm3DcOs1jkA7WXSaNmYqApSHU6Sy2l7kfNpWbx9JroUcso28MgHYQQ9+kLkY/IhcCEHVtuB3y/sEGnItpUCg+tDSZ65dAePa2JBzBIdt1XztfZr93kTzBMOWOgEXPFs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sYcrcpxc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ecMjects; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sYcrcpxc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ecMjects"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67I86CEP3780950;
	Tue, 18 Aug 2026 02:46:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=07wFu0xx1SnnGISev5AA8uIB0bWgGWM1e7CMmWcYR
	dI=; b=sYcrcpxccNco3EPcNMHeV6wemA/RHJx/tjQzvyjSW0DkSz+E1Qp7b8hhW
	NSnIbLzH9rtcszkv0XDgxYMaYznTQHJqY8Wffd4ni86Hgnwy7d1PpWdroD4jpEcj
	nX4tMqtlDknFxJ30gDPyFiT1mnkx0T5cFMnfiPezhZdJ0Tj75GFjWkrddl+4y4E/
	cCq1q3llErWxC5l/OW/tayKrwy/TVGnq/bdoYW5QIV+egSf70uKy1lkI/+xQ3DAK
	KS3LsoYAV9JXs68Aqq2b9ATpISfPRzJl0h8lh2r3T7VOE5k0k3DdS/vKFLClWMHB
	s70pWiMa/kBmtx07AIIZNJfVRlhzw==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020141.outbound.protection.outlook.com [52.101.56.141])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4g2m156a3r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 02:46:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ydl6kYoLl6JzhkqoomVqNB12/dF8fwVrHRMUCl8EJdhx6TpFi+twGYaeY+nvJhBKD2D+HOEHWfU/ezqSo5uPQ9qU1MF3OEdHW4+m74O+0snNAYeOOeW/5ka/NAu1glNg0qOqjoltJDJWe3015CLlUHtgKKpC6UPQRwrBkoEsDzS3RITpVoJlS6ePAM13moCIiXmPrPkdexAr1VwLZOIF25aN2ZIX90Ljfe0MPM/NYEh97lwEzlR0pBdOglcW5glXnR3m8IH63BBDovsetdt+RoxKEx5tNWILvf8YTTXGc5WJpGvfk0w68y2E24qyG4UrhF63bt0QpeOE3L3MhyUeFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07wFu0xx1SnnGISev5AA8uIB0bWgGWM1e7CMmWcYRdI=;
 b=HC8ybuIvR1/UPBxhNnlbANwgDyaRwrsk0EDTfQcqSIhnkAF2O44MG00ZuN9+uG8WXPGQeLqJTjoKLJFx0BTOExPi+rheidDZjAwlT8ekQ/soChwCwR1aKUnAkky60P13/Wb1N3Cu1l9+PXPNlGRy0NzO8zHoBcJFpUk/fmkZGgX4VioHGwkBiMlTptI2q3OHVj5QuT1VaUa/mBxQPAswxypaBOxdI0KeIqo8hj84o2u0uKTJCvMGZHQxDY6VdvkFnwnQK2bd9xBS2L2SOWOimIwR73/3CsvynT7Y1wIX5xxLtVTvoZqvZEDN7jvmOoyvTp6JZUnJHLb8FDK9QpPiiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07wFu0xx1SnnGISev5AA8uIB0bWgGWM1e7CMmWcYRdI=;
 b=ecMjectsDTpE0hM6ykPJzL/WtafV3FYki1Ek0jAiMiIRtfqYPDCjRdobh+0KS8QVtIoKbTSAJdKZiipG2IjgWHsu9ZlshJhupI+XR1kUN7ULbQMRouNiAnitRaXoam46J4LnoK7lDWlfExqON892SHiTZwtRtSZtDcExWomwFdeuDf/l6TnaLCpmdeHI8Hztbvs0L3/ym7Q8tIbqvjGzfvecdH8KmuYO5GGpiU4I0e7XpPrnkY3JRUs7/2mbFaC54oJVfHbqchqMdUNQlEG+qEpTNAx0aWw0jbwJTSHjCFsTva5wiKJjlCsjbC+UwwQS0NlpSk2aKyRsltsDX+UYPQ==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CH2PR02MB6726.namprd02.prod.outlook.com (2603:10b6:610:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:46:04 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 09:46:04 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Markus Armbruster <armbru@redhat.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com"
	<jdenemar@redhat.com>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com"
	<sebott@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Topic: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
Thread-Index: AQHdFWubvCZ5bHZqSUmcDdL6/mUClA==
Date: Tue, 18 Aug 2026 09:46:04 +0000
Message-ID: <676C0BA3-A842-4784-84D2-8B446E8CAB67@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <878q6m5qox.fsf@pond.sub.org>
 <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
 <9909725f-7dd8-4f88-b016-2a6134906a60@redhat.com>
In-Reply-To: <9909725f-7dd8-4f88-b016-2a6134906a60@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|CH2PR02MB6726:EE_
x-ms-office365-filtering-correlation-id: 4e6b1abe-9274-4427-5676-08defd0d8570
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|38070700021|3023799007|56012099006|10067099003|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 AZIY/Hl62SHm7G+fL/aQzX6sElTBYkoMIg/x2UbcoX0iv9zj4CTXMYpb1hR7wSkCRiSTRhLI6pbqY4eqMXAv8l/0dXnEjodkFQNV1pRMSTTbHYWD9d4g8kTWnwlGw6DudCd39MjNw3WWC95PzQdEMwSRb6AflLF80ADRx+HhXBlTfqrhfEZrDvzN1efTL0buochXGG9p7NvFplaz0gyiGRx0biNkD31y9A/KLBnlLBDDYwlmWOsYJks1zFI7TNOsBzCmnX8j+zf3rYUCX7MBRUM0h3eL+jyggu1kMmuMQgn438soSAEO1GtnWuZl9ycjtAjO2HbBxSKb7WR5plDqmKNy035PBeOIupmU7KqG2/lWJ6C7l98T+X7G2u/4t7enJgqzr2wqUB/4rtP7YiaTTOwEHBRMIUFMZys0zFRQ6Ijkzk+9uIAMC/Etgw10474X7NYugeaQbJFeRkC5a/MB6Di/izvO0Jzc+iUMQa9bz+PcHGKubf4doM0HJi+FWiurXZ8ogCF/c1CX3HomGBniSNeV6kL4oZKIyPsq3NxN6XRShVNVJexil125vjYLVLydc44X+8/n3fEgG//MS62NcnaNtNC0lQw1CHMNy4fvPXFbuchXHd5bxBHjQSS81y6azr7VZnZgMQ7sVRybjR/SKImWfggQk6ZSlXYOtjBS9Xs+n6GyV3nN/UjV71jgreKwP4EnLrom455snDbuunFiqw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(38070700021)(3023799007)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1lmaHVlN2U2R25QQk9oUjA2Y1VSQldOdERxRWk5SjkwY1h0a2tnUTE0SUpy?=
 =?utf-8?B?ODAvT1lVaWpEWDIrOGxNa21pbzVNcENvcTIxVXoyTjV3NGUvVGtqZElLSGtO?=
 =?utf-8?B?RFhWWWFMbjdBakpNZVVnNFRQcDVLK3VLYTBGM3VUcmNuYUlRRFVoYzV3cW4z?=
 =?utf-8?B?d3VDa0hRRGRMekkxdi93MGRVdmtOVWNZTzkrMHVvNHRmd2toQi9HUXNjcFBu?=
 =?utf-8?B?dTNycXBycmxnWkpYeEtQbkZQUlhVcTFkL2xLZll2V2srbzc3MjdyVnFPVGlz?=
 =?utf-8?B?aDNobUVEM281NUpDTE90RmZpV0VhR241NWMxU1ZwQ0dJbytwOWdNdDZVS3I0?=
 =?utf-8?B?UUFvZFAzWVliSmM4QVc3NGZvQVZaSmNPTnExQitSdFZhd2hHMkVPNVZLVXY3?=
 =?utf-8?B?a29WYk12akk4Mm93RGpoUy9mck03TTlURDJjTUlRcDZybGVkOW42OFVqOE42?=
 =?utf-8?B?bEVzQ2lpZ3IxaEY5SFpva2diL3NuZEdMTVNBek15UGZGdzFPLzZuOUhtNU9z?=
 =?utf-8?B?eFlyQ2pMbVl3Z0RvWTlTalhnMHpoK1B2bFlnR211MHFQaEtxSnl6ck1zRFRM?=
 =?utf-8?B?NDdVd000OGVXT2ZkTDhNRWtLTCs4QzlzeTRhc0N4M08ra3JVOUIrR3lyNGgr?=
 =?utf-8?B?a3ZMQThEeC9iZG1TZ1J6aEdZZkFGeEhzZFFuYno5MjNCcTFxV0hiYU1qazgx?=
 =?utf-8?B?YXJQa3Q4K0FvWS9LUFdhSzU0eCtZKzRVUk1KMTh1anJiaExCVEYwZjdjaGxi?=
 =?utf-8?B?ZStUdlIzQTBkN01ENE5rbGdrRklNYWo5bW13QVRtSE0zZFZVdTlWSGlHM3lR?=
 =?utf-8?B?blJrYlVrdmRUN09URnU1b1BoT3Qra0xWdWtTd1JOQWpZT0I3cGF2aWgwRits?=
 =?utf-8?B?SFZnVjNqMzBFTkFkSmRoM3dDdzF4ZDlPeHdENzFBNTFVb0VWajFyL3NJb0s4?=
 =?utf-8?B?bjMwQWRtaExCVVNaZGV4Njk2RlIrbUYzQWY2ekgrSytqb1krdlVLWVJ3M0ty?=
 =?utf-8?B?d3hUNnczd2VlQ3oxakFlV2trbVc3ZVdLOFlyUUVTS3NuV1ZkU2svbW1ZbkNR?=
 =?utf-8?B?LzB1YkpIWXVEN2dZOVZGYSszTlVGekFDVERDSU04Z0pjUy9ZZW1OeEJlMWln?=
 =?utf-8?B?U1ZtdGI3VmcrWWtUQzFJZnJrY0dmNjBnWk9rU3BwV0VGMHRTLzNaSU1yM1Vn?=
 =?utf-8?B?ZUxXY2ZuNmJJNk9HUmhPelRzUTBKbEJ6RVQxN09XN21KaGRtYmU5MzMxenRx?=
 =?utf-8?B?STJoN0xrUkMwWXZ3TUxpbXlKVUh1TWlTeTdPSVZWd0NpYURCWGNmcmIxSUg2?=
 =?utf-8?B?T1JlNVNUM3JvRHFEQVI1SmRKaGM2aDdNL1EydTMwUzV2bFFZVzFHb25wZkNq?=
 =?utf-8?B?ODNwYktFcllZSXhWZG1maU5KL0JPUEdMc2E0MkpRblAvS00xdmVCL1ZXTlB4?=
 =?utf-8?B?VHFMQWxtSjF4Z0hjYitzRWxXKzFGellsY2YvOVhpdlhvYkIzcFl2RTAzREtq?=
 =?utf-8?B?cDl5OUQ4bmJObGJDZGxodWVqM0Fnb0V0SlhPMFZpdC9GNXVFbGZ3bDVZdWJo?=
 =?utf-8?B?VVBkdmllMkIwQmpxU21OVlA0aXB4OEJTdFlRZ0Rpb0owcTZLVVVRdWZsaEx2?=
 =?utf-8?B?NWNJajVRSmNKbmtPeGNMSkpjbW1xRkdCenl1cUxuQzI0RHdSRWZJOTdHS2pZ?=
 =?utf-8?B?VnUxTytLd28zVVIvOTdsVWYvR2F0Qll2MVZWLzY0STFFSFptZEpqZWtsMDl1?=
 =?utf-8?B?citGcFVOSHVhUzZLTW1kTmVIam8wY2Z5OGwrbHhBd1F1a1B3WVdvWWQxUjlH?=
 =?utf-8?B?T21WZTZLVXZHM1hqbWJvOGVrTkpyTkJjODhXTFBRVlhueTZ1elVPRUNWeUpj?=
 =?utf-8?B?Qld1TkVrdFdJYjFrZHd1bnR6S3R0dXFhWENxQnNteElhY2pBN1FHL1V4REdF?=
 =?utf-8?B?bGg2eGJ1bnB4VUZVYlN6WXFBTDBnMnA1dEtsSG1RR043VHRQQTQ3VnFaZXV1?=
 =?utf-8?B?dEZVaFlGQW5DK2ZrTkFKNnowSk45aHRCMjVxZnVBM2t6NUJleWhzTjlCWkxa?=
 =?utf-8?B?UGd2T0ZrQzd6L3poNEovaHJzUk5DTFI1czlNeENMVmFoWmRCUUp3S1p6ZHZY?=
 =?utf-8?B?NmdyaUo5UWFZalNvNGdncGRBbmRucTNjd1ZVSnltaWFVZWZEMEJIaHd0WkxQ?=
 =?utf-8?B?aVEwVElEOFN3OVZadFh4NDlncW5na3R1aUVaVFNIeVdXRlRiMXF6c3M4dURC?=
 =?utf-8?B?TXI1MWhVdEQ0T3dJaWJKaXNRSEVDdUNxN3REMXlEQmQyLy94TlllMEQvMlMv?=
 =?utf-8?B?QVBsd1o0dWdEeHV4MXl4RFFwcEZrc05qclJJSXVqK29tWFZnSGZMRkthZy9R?=
 =?utf-8?Q?UXFYMy7YUbK0Zses=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7710AF318F642A428617A9BA08986180@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mL3LdDfgb77hnipyxmrv4WJS7HYtQAoJYdq+mhWtgUJp7MzFToZ3j2R7aCpxAsNIp2UCj5Av3TbDaR17wpIW3nRMF26Ysk4Q8iRZJAYWlcVG1CSu6JnEBp171kmtIqtYvarRxzJtvC8CNNVm/yqjylMEW43OdhEFXdTA+6mhDW0LUWoMNh1x/DpGx8CPE5MG4rVoMM2do5wBH4jH/9Lm7RBTmKvxwAYlXWslrtz53r4l2ZGocZg1wHqdL1WgojGl3TR0h0caAc9+Yx67RCeZIGn9iJuAQhCHjb9jnuX/q7sjUaNrs8LCiPjn31uQAZgLScQN/HzTaW/fUWz0uKSslg==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6b1abe-9274-4427-5676-08defd0d8570
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 09:46:04.7990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LH0Lp+0Kh7BKSqYKIYlLmwzNr4Hg10S7xhFQLFDHKUGENyAwysXHlSGLvwVhLlYw+sluH5eJIoRho7+2Xdz+77K7Y12phycUVkiJRtE7Tdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6726
X-Proofpoint-ORIG-GUID: ru02FjCCd_8DH2rlx5JB0dJ8sH3ipIRX
X-Proofpoint-GUID: ru02FjCCd_8DH2rlx5JB0dJ8sH3ipIRX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA3MSBTYWx0ZWRfX1Ky/5kefZw/V
 F8In+5m/4IySIowUpcgTz9afwfgjBwqreOU3lcoQkz8JvxFL2zqGWGFrGFlzXnsVs3lKiqSrIJy
 HblwUizkqjll/EF04L2TSm9Z45jaV7eAnCRjA2jnm4zKQ5n3L4+mFhgbCuVQtV6DeQhWWoA5s4X
 4a1LspOlUyoBBVHOBL1l9dRGi4s1ZMIpX6Je5CSAdZNhbnzyzTLO4d4FZpzttdIwpT88zD17nvR
 8YSBiKWOmZ2RAHkge863e3N9f+uLYXcB49zBWfL9ptIiy7FGw0GuLuNHJEsPQwtFenmn8CdQ2kj
 g/xDpyRwGOXa8+iCjmhUAHZ5a/jQ341EoQV4YVCUO6hYpwgMvC+YqMcpPEfWgwR9SREyEpEQvJ6
 LZ0+U95rkLwghg5wEICi0hxZ4zTxsg7j2grSr6849hjr3HewUuUR4+t/1uoMe9Wd1oH6J/QEFUa
 UTtU1QforDzjYJ93vrQ==
X-Authority-Analysis: v=2.4 cv=RImD2Yi+ c=1 sm=1 tr=0 ts=6a8429de cx=c_pps
 a=8dnTEL0w31pCL/ZHUAqC1A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=zqOu6-1sf_JSKxam7AoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA3MSBTYWx0ZWRfX+VKne9FcoTbM
 t4zlY+7O5qBO9JXdi+Ujnrgu+7NRZmg0HKwhLlEu+hJnm1/3y0uAa1BrGrtiAYLS1E9e3iHdg4Z
 P2MZYh0CTQAiC2BezeHO1jj6vhJvbAw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTQgQXVnIDIwMjYsIGF0IDc6MDjigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDgvNS8yNiA4OjQ3IEFNLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiANCj4+PiBPbiA0IEF1
ZyAyMDI2LCBhdCAxMjoxNeKAr1BNLCBNYXJrdXMgQXJtYnJ1c3RlciA8YXJtYnJ1QHJlZGhhdC5j
b20+IHdyb3RlOg0KPj4+IA0KPj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+IENBVVRJT046IEV4dGVybmFs
IEVtYWlsDQo+Pj4gDQo+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4gDQo+Pj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4+PiANCj4+Pj4gSW50cm9kdWNlIHRo
ZSAncXVlcnktY3B1LXByb3BzLWluZm8nIFFNUCBjb21tYW5kLiBGb3IgQ1BVIG1vZGVsDQo+Pj4+
IHByb3BlcnRpZXMgaXQgcmVwb3J0cyB0aGUgdHlwZSAoYm9vbGVhbiBvciBudW1iZXIpIGFuZCB0
aGUgc2V0IG9mIHZhbHVlcw0KPj4+PiBzdXBwb3J0ZWQgdW5kZXIgdGhlIGFjdGl2ZSBhY2NlbGVy
YXRvciBhbmQgaG9zdC4NCj4+Pj4gDQo+Pj4+IEZvciBudW1iZXJzIHRoZSBzdXBwb3J0ZWQgdmFs
dWVzIGFyZSBleHByZXNzZWQgYXMgYSBsaXN0IG9mIGluY2x1c2l2ZQ0KPj4+PiB7bWluLCBtYXh9
IHJhbmdlczsgZm9yIGJvb2xlYW5zIGFzIHRoZSBsaXN0IG9mIGFsbG93ZWQgdHJ1ZS9mYWxzZQ0K
Pj4+PiB2YWx1ZXMuDQo+Pj4+IA0KPj4+PiBUaGUgY29tbWFuZCBhbmQgaXRzIHJldHVybiB0eXBl
cyAoQ3B1UHJvcGVydHlUeXBlLCBDcHVQcm9wZXJ0eUluZm8gYW5kDQo+Pj4+IGZyaWVuZHMpIGFy
ZSBkZWZpbmVkIGluIHFhcGkvbWFjaGluZS5qc29uIHJhdGhlciB0aGFuIGFuIEFybS1zcGVjaWZp
Yw0KPj4+PiBzY2hlbWEsIHNpbmNlIHRoZSBjb25jZXB0IGFwcGxpZXMgdG8gb3RoZXIgdGFyZ2V0
cyAoZS5nLiB4ODYsIHJpc2N2KQ0KPj4+PiB0b28uIFRhcmdldCB0aGF0IGRvIG5vdCBpbXBsZW1l
bnQgaXQgcmV0dXJuIGFuIGVycm9yLg0KPj4+PiANCj4+Pj4gVGhlIEFybS9LVk0gaW1wbGVtZW50
YXRpb24gc3BpbnMgdXAgYSBzY3JhdGNoICJob3N0IiB2Q1BVIG9iamVjdCwNCj4+Pj4gd2Fsa3Mg
aXRzIFFPTSBwcm9wZXJ0aWVzOiBTWVNSRUdfIElELXJlZ2lzdGVyIGZpZWxkcyBiZWNvbWUgJ251
bWJlcicNCj4+Pj4gcHJvcGVydGllcyB3aG9zZSByYW5nZXMgY29tZSBmcm9tIGFybV9maWVsZF9n
ZXRfc3VwcG9ydGVkX3ZhbHVlcygpLA0KPj4+PiBhbmQgdGhlIGFkdmVydGlzZWQgZmVhdHVyZSB0
b2dnbGVzIGJlY29tZSAnYm9vbGVhbicgcHJvcGVydGllcy4NCj4+Pj4gDQo+Pj4+IFNpZ25lZC1v
ZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KPj4+IFRoaXMg
ZXhwbGFpbnMgd2hhdCB0aGUgY29tbWFuZCBkb2VzIGFuZCBob3cgaXQncyBpbXBsZW1lbnRlZC4g
IEl0J3MNCj4+PiBzaWxlbnQgb24gdGhlIG1vc3QgaW1wb3J0YW50IGFzcGVjdDogd2h5IGRvIHdl
IHdhbnQgdGhlIGNvbW1hbmQ/ICBXaGF0DQo+Pj4gaXMgaXRzIGludGVuZGVkIHB1cnBvc2U/DQo+
PiBXaWxsIGFkZCBzb21ldGhpbmcgbGlrZToNCj4+IA0KPj4gVGhpcyBoZWxwcyB0aGUgbWFuYWdl
bWVudCBzdGFjayB0byBkaXNjb3ZlciB3aGljaCB2YWx1ZXMgYXJlIHN1cHBvcnRlZA0KPj4gZm9y
IGEgZ2l2ZW4gQ1BVIHByb3BlcnR5LiBUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZvciBu
b24tYm9vbGVhbg0KPj4gcHJvcGVydGllcywgd2hlcmUga25vd2luZyB0aGF0IHRoZSBob3N0IGhh
cyB2YWx1ZSAneCcgZG9lcyBub3QgaW5oZXJlbnRseQ0KPj4gcmV2ZWFsIHRoZSBmdWxsIHJhbmdl
IG9mIHZhbGlkIHZhbHVlcyBzdXBwb3J0ZWQgb24gdGhlIGhvc3QuDQo+IA0KPiBIb3cgZG9lcyB4
ODYgaGFuZGxlIHRoaXMgYXQgdGhlIG1vbWVudCwgdGhleSBkb24ndCBoYXZlIHRoZSBjbWQgZWl0
aGVyPw0KPiBIb3cgZG8gdGhleSBjdXJyZW50bHkgaW50cm9zcGVjdCB3aGF0IGFyZSB0aGUgdmFs
aWQgdmFsdWVzIGZvciBhDQo+IHNwZWNpZmljIGhvc3Q/IElzIGl0IGVhc2llciBmb3IgdGhlbT8N
Cg0KeDg2IGlzIG11Y2ggc2ltcGxlciwgYWxsIHRoZSBjcHUgZmVhdHVyZXMgcHJvcGVydGllcyBh
cmUgYmFja2VkIGJ5IGNwdWlkIGJpdHMNCmFuZCBhc3N1bXB0aW9uIGlzIHNpbXBsZSwgaWYgaG9z
dCB2YWx1ZSBpcyDigJx0cnVl4oCdLCDigJxmYWxzZSIgaXMgc3VwcG9ydGVkLCBhbmQNCmlmIHRo
ZSBob3N0IHZhbHVlIGlzIOKAnGZhbHNlIiwg4oCcdHJ1ZSIgaXMgbm90IHN1cHBvcnRlZC4NCg0K
V2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KPiANCj4gDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPj4g
DQo+PiANCj4+IA0KPiANCg0K
