Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF42C36195A
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 07:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915161; cv=fail; b=i8v9AFm00TBpGdkZ/MPI9mq6uP58CZl/eP+wxb54yTRx7NzNMonaFPtcoS0KXbUbIEFzjhGHahG4KdlcWHViePU+M/YtWmBa4OVOKdNbP5zlAHsgk79uYFZioqy0iZdVHD3iD/2vaJCz2EP1rjy8jocBktwStdpJVjP4oUq/yZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915161; c=relaxed/simple;
	bh=MRBZEbB6SFgUsz9o5MdDYxV0t4vN+69dIfKvzRGM9Iw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DhURyzDL3oHkvhTVoAL39wEz/cGlBQfLP9uR2xl3/rq0GHBJplWCAz2M5czhNe6vdtfDDSqL1iqASgNKGVC+2Y7SZM44QILvr+GIO0aE4MZoxtPGIiq3Jy9Uu6LN1QQ6GFY6lESWhJEDjHrn9i0b0Ewf1gvPN7mcra3iYeOBC5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gv7Qgrbp; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gO5E9Xec; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gv7Qgrbp";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gO5E9Xec"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755oThe2419059;
	Wed, 5 Aug 2026 00:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=MRBZEbB6SFgUsz9o5MdDYxV0t4vN+69dIfKvzRGM9
	Iw=; b=gv7QgrbpqJL2VOwtpxJjmfHesZWdPlzS+trsKFWEP+TIxFsinY2unkkGh
	rsLC8x1p4QHn6L36L274EaeGdI/HSOXgkNfam02Os52nNKGPDVWYZOnTyLynBD9G
	vaERtqjEOzepEyIS9vDpazMRUyNWFWuSMhAaAWbanR622GcA2ASG4WFW1u1IOTBY
	2q0NS63vw6RObd2x470wL+yjofzaiMS+V0wcRXGux37ZwVBV4X6POFFL/wjsVfmc
	hAR0oPQGsrXvEGMwX3u85ECq+DD/ltJzqU5iFH7mg8gPugOo72/JAZ6EweMy23Yp
	9y784ZfFk7goqJ11ybjJcOCIb0IZA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020139.outbound.protection.outlook.com [52.101.56.139])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fujcjsyk8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 00:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnkOG7QX2BrXuSH7YlqHh2ndpF/edr9ilkQnxhGlQgWHNDYBYRxRzFmgFFamNjtThIcGc5V4QE3WqLzO1oY2jfDNOT0XQgdGQu50TkOFBZtKO44CyoKEKmaoocEHDAfma1eeVWx1LV5Iv2Qh9DElKgCJyrB7hYUbGq62MFnymA2dM+8LUtjNZcW8cMl2QaleUe1J6NXcW4zWvqfjJkt8p2ISCb2LBufWOCt9Nm+Unbd01l3RMtJ8xZSq/dMDnUPrUhN9C4ZIcffO6xxvei5rsGjF7kY6IE/J8BthxtHX7hOsLbt5BMUUml4BhKJuomBn6OX4SuG8IcsaDbpBDgAO3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRBZEbB6SFgUsz9o5MdDYxV0t4vN+69dIfKvzRGM9Iw=;
 b=k7v/RS8owZo0cyygReeYT2FuTI5OLgpcamprqX9sReG7b1+HtUOipHcN958rM4biWnmvPIJszfJj3qUP8rhCIV9Vj8GToU+UkcbFaYxLj0qjUWwkE07WltDqlLG6yp9zne6t9ESKMg6b2uA0mNUwvuzel3ml8cNe6Jn4LK6YLDCoFeiQXHfbr+iDmGfYQSCDWKedNb+9/dOJ30kinaDupgJeukq1H/XyxjgNgjFwsCid8BMN0BlYNgZBYpcPIp23TPqUZKd66L8tx8lOtMKw16/R6Ljz8hHgRXRQNW7LZwWw83LZm8aLQUQ1WwHohdVk8MeAIhWGDu6onFLwyg6OBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRBZEbB6SFgUsz9o5MdDYxV0t4vN+69dIfKvzRGM9Iw=;
 b=gO5E9XecLQ5rNTWsll7ItYbzi0A3hiV2jC13uhVSYaKf3uUE1CvRPgJoWItIkL6d0zuzp+lKHJw10+wgUAC1ji9jRn9qc28VZoca0uJ0sAa55EijlInAcRb3iEqqBv/9I3cB/J8Yu09kWhdWEvVyhvoZPFaYK6kHezBVYkB61edbXr2dVziiDfbsUZrDAvd0vicwiwB/dPEYI3mYC8uBLedKW7Vh+wvLIkg+nzsQysIs0krWrXzc0zxEtW+X/+g59D73Gw6o7ZcP3M7UTuTdv+dY3esWx9oT9UlrKxxCJQ7Tchk/jeJPsmayQhENSx0Y/bDcRH2LbbOD2wcPKiyc6A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB9354.namprd02.prod.outlook.com (2603:10b6:8:151::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 07:32:28 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0292.013; Wed, 5 Aug 2026
 07:32:28 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Markus Armbruster <armbru@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Thread-Index: AQHdFWubvCZ5bHZqSUmcDdL6/mUClLaNjwqTgAGSvoCAAALFi4AACbIA
Date: Wed, 5 Aug 2026 07:32:28 +0000
Message-ID: <951A15BC-5E1C-4CA7-AE3E-003565F6CD4E@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <878q6m5qox.fsf@pond.sub.org>
 <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
 <875x1p12cv.fsf@pond.sub.org>
In-Reply-To: <875x1p12cv.fsf@pond.sub.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB9354:EE_
x-ms-office365-filtering-correlation-id: d87f0125-7bbe-45d0-0a12-08def2c3b3e3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|3023799007|22082099003|18002099003|56012099006|10067099003|4143699003|38070700021;
x-microsoft-antispam-message-info:
 4lfmVNRrY1ESz0xGf6Lo5iSbwTXMtrOZlK3SoNrQ+a1l+vYoFbVzaIYzaMC29vJ7nAU/W+T3xIG2O0mRYMvZpF2giW3s1WoLgZLm7mfcW4PtLIfXMPJwV/xDrvZ4p+zinm5X6Zq+9euL52JMzUlAslZKFdmdO5Z7HlRK4tt5eQAtGWq7K53ni1C2F4gzkey1WvFp43wC9rAcHZc/fHWQ1ivAU37fpD57+YgMxrrHFQsEW/xStd1/hV9YG17PoZ4cnRrlVWA1OlNyIuwyUQMf7zi7jKd596F7W23oY39lwewJ+o4K0HYvCVpn2MD7Ljs7UtViseI4vkTwfAopzy+He9BoYPWlq6ZW/oUKJePR/7EevyoUpJbngdcNSgsk/Dlhj+cct/3NqUpT4nDuG7aFX0A4hRTqPhjmD5mmVc1rclEjgvwERFuZhQnYSlZFCr1coirtON1eUQLyq6HruVKU/6utLyy/B7ET3jk0WrpbrK9d4jrtY/9tKYFPw3XDdS1KreQW/qVHv7fJlTQC4SXhQ1WN0QdD7RpSV1vu2jxoZvO4yDnJ+sPnKTB8uWw3OPAJiD80n+16YY1wMbcDquYd2uEEKIfGRchbGRipi4veHZCq0Rmi3z627tkw0lOTUkD6xu2uG74AhJVBeVmr3XaHs5+5+c7YPBvfRwZ6zhS4gI+UR19bQ410NJKQRMhOKozgTfKENEgDvkH4OBpdeuvDnA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(3023799007)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S05oUDhTTFRBU3diQnlQVytTSk04bGFralZYZlV5d2ZRZGg5emM1Ui9PZFlX?=
 =?utf-8?B?MURCNzlLeG81UTFYMTN0VW1kVmpnSWxiNFRlSFl3ek41MGxlQUpjZ0ZXQWtX?=
 =?utf-8?B?b0phdDY2Rjl6OEI2dzNyaVlqTHVNTTYyTUlzUUIzQ203d0t4WlZWR2lQL3Vk?=
 =?utf-8?B?RnVxNnNWYUxzSHkvM0xkd3VsMjJsYUZVN3Y4Q1ZNUmFxak9xRkE3N2wyMWRD?=
 =?utf-8?B?WEduTjB5aXgwS1JRSlZRK0ZycS9QUURGY0NFaTd4eXh2VU5ldU12UEhTRkhG?=
 =?utf-8?B?anNPeEJ1dytZM0dJTVRaNVhvbFhPeWRoV0pYWDZNa0YwcXM3U1FnTmdRdlNz?=
 =?utf-8?B?a1pjbjczZkEvd3grNzYwYU9iSXhxUTQrZkl0Nzg4S1RrWHR3MGZkQTNnTlB3?=
 =?utf-8?B?a2NoVmZvMU9pOU5xeUZlVHo4bkFHdmhhbUZsaGNMN051VHdDQWpFOXZxZUVa?=
 =?utf-8?B?ZGFVWGIxME5kdlVlK281YW4wS3cwRVF6a3JBbDVvcERJbUtZL1R2Q1I5c1M1?=
 =?utf-8?B?SHZvVEo2b0hnaDllaWRyVDlRRjQ1M2I4c0c1VWpscyszdEtVdnRDVndES24y?=
 =?utf-8?B?Ry9kZ2VPNFIxZnd1ek1lTDJENi9DODFYdUFLNFpUZWNqR1ZNeTJaR2NhTGR0?=
 =?utf-8?B?L0VLZFJTbnVYSlFHbCtzTHoxQ0dPalV5T0FZa2JETWRtdk4xYW0xc1lTTEVa?=
 =?utf-8?B?akh1ZlVJVWpvUmNhNTNrQzRsNFdBQlJ1VFZaZ1J3NE05SVZEU3dpZEgzUzdR?=
 =?utf-8?B?SXpqNjVpN3gwNjU2N09weVExN1Z1aVNBemtTYUdRSFVuVXpGSTRhUUROazBD?=
 =?utf-8?B?VFo3R3BVckxvanFma0pqdFNHT0hQRG1rY21obXpCaE4vNGtYL0JialQ2TXNR?=
 =?utf-8?B?YjY3ak9BUzhwVExJcVNLS2hrK2krc3hoZ0YrQXhVUzVEZmlWTENlL2RCOEVw?=
 =?utf-8?B?MG9SaFZ5UktUclhwRGYyWGlaOGtLTHIvNjVyTVA0SUc0L2o4eC9aWENwbDl3?=
 =?utf-8?B?NVpjc2J6L3ZqbXRDOTlqSEZqMVJvSDFWa0dQR3pZMlVmeElVWDNuNkxYVW13?=
 =?utf-8?B?MnQxSkJ2U3c5YmVpd1lBM1pXaml2TzMrMzNHdWQvZmdQcnFIUWZLSWs2UEYz?=
 =?utf-8?B?RmpvRzRlUktOdmlnN0luZjg0NnBqMnp3TXJ3aUJDS0dYd3BCQ0FQVXNTQ3RU?=
 =?utf-8?B?V3ZUWEhoZm9JRmI3d3hUcDk3RTYrbjV3Z2hXRHNnS25OOC9uRG51S00raWVY?=
 =?utf-8?B?R2c3Z1FscXhlVTM5MFdHak9BNmpEdUFnMDJvNUIrYzF3L1M5ODdyN1pRcC82?=
 =?utf-8?B?VzA5RFB5RUdLZFViejhXdEw4Ry9VNmUzT0g5NlFKS01vWFQ1OE1ZVFVaOVN6?=
 =?utf-8?B?TjEzT3AySXhXd2ZiaHo0aEs4MDFzc0lqZDRPT1lnZnpsQmsxamo3djJadnBL?=
 =?utf-8?B?LytPZENlUVljcTg1WUZHZG4vdUxZNlBOL21raUZEaGg1ZnEwTkx3UmFNbUNu?=
 =?utf-8?B?b2lKNWtpREtzT3NYTHZsVFVDZ2NOOVVRSXVaazN2cFI2eUNvZDczYVdlNVRH?=
 =?utf-8?B?Wm42Mml2RVI1cDRZdHhHM0sybEthd3N3dmhmSDkyTjNyWjdqU0x1NnNXdGxy?=
 =?utf-8?B?OUdNWlFrRG9aLzdYM1N3QnYrSEdJRVZBdGhuRUZGaDhKM3lyaEd6VkV1RGxi?=
 =?utf-8?B?R3NzWWF5UW9lWVhuZ2JmbG9hdTFha3lnRjR4c1RLLzB0ZVE4TDhrUE9lUDVj?=
 =?utf-8?B?V0tYMkNaYTlpOTBwQVovQkt2c2FyK2xRYWJWM013amhFaHZjMWhNcm9rWVpv?=
 =?utf-8?B?ZTRlZzBWNEkyVlZlSG52VXNRenVIV1c5TDdBVXk5Vm1MWFZSbnJjNHhjckhU?=
 =?utf-8?B?emxzVERXa1UrL0xaVHp6bk1lcmdjS1ozZWNVcTlHWHpySjZDcWZrZnllY2xE?=
 =?utf-8?B?ZWk5SjA5bWFuT3hWTFpnZ1BRTkcvNjBjaThFRklFYS9iNHpzcUNUa1ZGZzZ6?=
 =?utf-8?B?SUUxYUp1ejRzem9oZzBURW1rRXF2VFEzNjVnVjdpNHlsWUR2emxneGppVUxG?=
 =?utf-8?B?dlFNbG15MHI0YWRmaWdsZlE0NitVS1VsT3JtYjdJaVB4N3RNTzlvcm41elFS?=
 =?utf-8?B?MU1hY01PYzYxdzU4OWRTd1F3bGl2WWMvRmRsWTh2b05ZWUJxdk5jbThVUVJ0?=
 =?utf-8?B?U3NUUWVLdVRXV3h5ci9MZmJGVjZZY3NqMllMYkFFWTdiQm81ekpQSjBRMDJK?=
 =?utf-8?B?eXZNdkpoRHczb21wWC9kUjZDbTk5bWdMbmVvcEtKTWVrNzJ0TnZVMUI4Tkha?=
 =?utf-8?B?OCtIT1VSTTl5Wi92RWNVU1pCQ3djbHJNOUorZWtDMW5KV1Jza2VleGU3Yk9N?=
 =?utf-8?Q?lE569662zT4cjQhg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B15FAE20A42784896F29621A95CEBCB@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	eXJF+CRZnK3KQuMlWsvmtauoD853ggrxGWi2eeszNlbbQFcAuPo7UIiVZCK8aRN9C6j0rVWtnllvFp3AD4WwcyJkibczZId8v2Umj9NDc4WJa6hVVUkyVsY2ZWJmbnCg6FmutjVPXbDVYcWOb9pUXpuIQdUV8cNpzX2WJ5kb4lv1Sc/8ahe1O3lybApeGTEkEkeKK7V4VrlORaeDOuC2WVK6DF4ZqiqxoONZRV70oTDcJPQB49E0ISsS0OWOoJAxaWchUyZXsCeX3v/ENB+qh1V91oIS63tKzeJmOKioirgGJBxiqwmLblI+35SeS9+fdlwUlWG8pAAbeCQfY8HJtA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87f0125-7bbe-45d0-0a12-08def2c3b3e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 07:32:28.3241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tyi/RFSfZOMScOARu8ldg3TniUbnyO8+h2bg03446qWOw+6eNxHvX+3yqbypo08moKMIUfVS8qhm64xoUCrhd6LSJn/AI061kx9bM42gTcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9354
X-Proofpoint-GUID: XgL0PpHM4W4F3f2aqWPxsPqj5xrCpP5z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA1NyBTYWx0ZWRfXwVLAynswXoRK
 QOr6j9fKfKoVVxnza3690cu1eJ+3ibHi09aCnhzVD5CkSbYz/Vv6o31Kuspu4c8Cwib3fq6qWRJ
 TVd9ymZUot/IBgy42Dd0PT2pJayurYY7rSMB3ajNZ9ximCaorqHPIQz4f5RtvIB9ACGi/JBLPfS
 7ub2Uv8w+iGYeoFIAStQ7dZQ/8g3lJuJlzc4wBjLnJSbAsI+YerP2e3lQLG2RnEBiI1UW5AXlA4
 xlqNsVIxl+XKk0WVT6kGIb0u10ekd2x3YA/BLiJ6rQONIaJzjQRnaOm1LnyU6zKTrKgC5Yr2cD6
 4LhyQFDdSrwdjoSczKNzuAdoIZLrNnqwwWlSEGhSuLhhFDE7qq8kMZCDMIWaAZvv9BoKvkkvQ7u
 waSNqqsmRnZYXJKB6ruJH07Igisa/DZh0Oqiw/869nt5WhOebW13T6O1X5ITXiB2VT+wK2oLhyo
 f0n6PfT5/7dmg5Dlu+A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA1NyBTYWx0ZWRfX6wujdDU/5XHC
 bdz1I4u3rdIavI+/TJ0w3gvmlTLRlY/usw/LSxcHe0s7VMwV/So/UbET2dz8QgKhg1Bc6g/5WRk
 ZJPZohk3mm1X4Tvzdcl8u0sJpTQRBW8=
X-Authority-Analysis: v=2.4 cv=VOHtWdPX c=1 sm=1 tr=0 ts=6a72e70e cx=c_pps
 a=HngsKjkEkW2FdqPxnP33Yg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=z4329KXCuIL4XoBGyfoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XgL0PpHM4W4F3f2aqWPxsPqj5xrCpP5z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gNSBBdWcgMjAyNiwgYXQgMTI6MjfigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFy
bWJydUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+IHdyaXRlczoNCj4gDQo+Pj4gT24gNCBBdWcgMjAyNiwg
YXQgMTI6MTXigK9QTSwgTWFya3VzIEFybWJydXN0ZXIgPGFybWJydUByZWRoYXQuY29tPiB3cm90
ZToNCj4+PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0K
Pj4+IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5z
aGFoQG51dGFuaXguY29tPiB3cml0ZXM6DQo+Pj4gDQo+Pj4+IEludHJvZHVjZSB0aGUgJ3F1ZXJ5
LWNwdS1wcm9wcy1pbmZvJyBRTVAgY29tbWFuZC4gRm9yIENQVSBtb2RlbA0KPj4+PiBwcm9wZXJ0
aWVzIGl0IHJlcG9ydHMgdGhlIHR5cGUgKGJvb2xlYW4gb3IgbnVtYmVyKSBhbmQgdGhlIHNldCBv
ZiB2YWx1ZXMNCj4+Pj4gc3VwcG9ydGVkIHVuZGVyIHRoZSBhY3RpdmUgYWNjZWxlcmF0b3IgYW5k
IGhvc3QuDQo+Pj4+IA0KPj4+PiBGb3IgbnVtYmVycyB0aGUgc3VwcG9ydGVkIHZhbHVlcyBhcmUg
ZXhwcmVzc2VkIGFzIGEgbGlzdCBvZiBpbmNsdXNpdmUNCj4+Pj4ge21pbiwgbWF4fSByYW5nZXM7
IGZvciBib29sZWFucyBhcyB0aGUgbGlzdCBvZiBhbGxvd2VkIHRydWUvZmFsc2UNCj4+Pj4gdmFs
dWVzLg0KPj4+PiANCj4+Pj4gVGhlIGNvbW1hbmQgYW5kIGl0cyByZXR1cm4gdHlwZXMgKENwdVBy
b3BlcnR5VHlwZSwgQ3B1UHJvcGVydHlJbmZvIGFuZA0KPj4+PiBmcmllbmRzKSBhcmUgZGVmaW5l
ZCBpbiBxYXBpL21hY2hpbmUuanNvbiByYXRoZXIgdGhhbiBhbiBBcm0tc3BlY2lmaWMNCj4+Pj4g
c2NoZW1hLCBzaW5jZSB0aGUgY29uY2VwdCBhcHBsaWVzIHRvIG90aGVyIHRhcmdldHMgKGUuZy4g
eDg2LCByaXNjdikNCj4+Pj4gdG9vLiBUYXJnZXQgdGhhdCBkbyBub3QgaW1wbGVtZW50IGl0IHJl
dHVybiBhbiBlcnJvci4NCj4+Pj4gDQo+Pj4+IFRoZSBBcm0vS1ZNIGltcGxlbWVudGF0aW9uIHNw
aW5zIHVwIGEgc2NyYXRjaCAiaG9zdCIgdkNQVSBvYmplY3QsDQo+Pj4+IHdhbGtzIGl0cyBRT00g
cHJvcGVydGllczogU1lTUkVHXyBJRC1yZWdpc3RlciBmaWVsZHMgYmVjb21lICdudW1iZXInDQo+
Pj4+IHByb3BlcnRpZXMgd2hvc2UgcmFuZ2VzIGNvbWUgZnJvbSBhcm1fZmllbGRfZ2V0X3N1cHBv
cnRlZF92YWx1ZXMoKSwNCj4+Pj4gYW5kIHRoZSBhZHZlcnRpc2VkIGZlYXR1cmUgdG9nZ2xlcyBi
ZWNvbWUgJ2Jvb2xlYW4nIHByb3BlcnRpZXMuDQo+Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBL
aHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NCj4+PiANCj4+PiBUaGlzIGV4
cGxhaW5zIHdoYXQgdGhlIGNvbW1hbmQgZG9lcyBhbmQgaG93IGl0J3MgaW1wbGVtZW50ZWQuICBJ
dCdzDQo+Pj4gc2lsZW50IG9uIHRoZSBtb3N0IGltcG9ydGFudCBhc3BlY3Q6IHdoeSBkbyB3ZSB3
YW50IHRoZSBjb21tYW5kPyAgV2hhdA0KPj4+IGlzIGl0cyBpbnRlbmRlZCBwdXJwb3NlPw0KPj4g
DQo+PiBXaWxsIGFkZCBzb21ldGhpbmcgbGlrZToNCj4+IA0KPj4gVGhpcyBoZWxwcyB0aGUgbWFu
YWdlbWVudCBzdGFjayB0byBkaXNjb3ZlciB3aGljaCB2YWx1ZXMgYXJlIHN1cHBvcnRlZA0KPj4g
Zm9yIGEgZ2l2ZW4gQ1BVIHByb3BlcnR5LiBUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZv
ciBub24tYm9vbGVhbg0KPj4gcHJvcGVydGllcywgd2hlcmUga25vd2luZyB0aGF0IHRoZSBob3N0
IGhhcyB2YWx1ZSAneCcgZG9lcyBub3QgaW5oZXJlbnRseQ0KPj4gcmV2ZWFsIHRoZSBmdWxsIHJh
bmdlIG9mIHZhbGlkIHZhbHVlcyBzdXBwb3J0ZWQgb24gdGhlIGhvc3QuDQo+IA0KPiBCZXR0ZXIu
ICBQZXJoYXBzIHRocm93IGluIGFuIGV4YW1wbGUgaWYgeW91IGNhbiBjb21lIHVwIHdpdGggYSBz
aW1wbGUNCj4gb25lLg0KDQpOb3RlZA0KDQoNCg==
