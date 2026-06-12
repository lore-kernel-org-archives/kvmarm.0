Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51CB347505
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262129; cv=fail; b=KB392dE2+xDWAZXn5JdgFfS4nCIZRrDSITgRRq/xHB+VVbI8tZ6lLVuRkl/S+WQZTlRk+RY03VpQhu9Zg5HHMyi6c88rFRmWDf+oAyRn1sn7UxbKtyPKDmidIUBq8o9Yl3BtpI0B717vDdQkW2v7I3rmJeBxuUcZPBcU3kpMI9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262129; c=relaxed/simple;
	bh=lJ/CJuvtD52uGNWYR/3MbsekWfbAiuJZoNZC27Wph/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Utth2F1IK+qqvAiJHjeScjgeb+PeCrRQotbPnM5LV1Xu/ekdsShff2xt5AIPylTk8lrtFOP0++2UCfsMG5O9adau4el4UdcMpGZbDxv6r/wbZyz7yacLzPxkmZOaeG45a2uccXOIYdjqkASTmUskA2RKoMCsknnnVGyhA7y5fpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zGauljS4; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=S3P7s4sr; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zGauljS4";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="S3P7s4sr"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38Jml1585237;
	Fri, 12 Jun 2026 04:01:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lJ/CJuvtD52uGNWYR/3MbsekWfbAiuJZoNZC27Wph
	/s=; b=zGauljS4VeRlSOWd28yfdQIsLK2vzk95si2PQ8SGB8V68yzcPLhESu6Ve
	FjmetoybchYs7ou7ORqFbqwqn0dPQhjMRLPQVAxZUaZRymOYqBArRmi/lUqLAxgf
	KYQU7AQXLOVnN2iC7SdvAgUsQ7gkt1hMc0IiwZk4Cm5LjfN3C8Oxi1WvxSMsM7O3
	BrHO3je9Ctua7Hi4CbtaWITS90peq2czMp4LheHZH5hger60DRDUm6A0MX5NRiu2
	wOfVbtFpwtzVcUGWQtf0IJ18RRR+oUMyMHguVcYv8EfM+y5zg4nb6gC530Of/rrk
	Eo1G6RXNzv9zUU/uwNZMI+8mOfoAQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020115.outbound.protection.outlook.com [52.101.46.115])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4eqe5j50pe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 04:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzXWxlN8sKwoLeMlx0KWUyUECjEXRNOUFRFpkfSrjvq4xDRdn+KavFhI+1Y6w2KQt7o2G+/UlU7ZkEFRcQIz5dmM+urJmu317GmzMV/BnI59L2EX7TVVh2f/yl7L6gLs7hMa1RNlavmLiMwI4CnE9gXsWTaNnB8Vk6orUY3Tbw9F3XkYKm64xp44bDVxQ0+sCgvAXZXlUR9uwAri8xKTf/GCrskiGcFdaV1hfMgZD5ZPnjuFHTJaMjn7KI1uIPbBzGOnScg+VPraJS1J/Y3cxzvHk0MTtvHTfQrWFJNNYxDt7RSbaqYmQlqEU9ntGaEIrkAcLbvqjVnKoCdZvvdkzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJ/CJuvtD52uGNWYR/3MbsekWfbAiuJZoNZC27Wph/s=;
 b=FQcozResugghasqEVOXu9KNs/ZNs5zYIppDsOmBlC3JNmBGpkNn1tmoJK5gEZHullvMJPsolx+zV/BBy/HRZgMHOzR7bzL6vI/SlSr3pPwxLD1evuua4XNjcwI7T62ZtsE7clYEWI5vZe2k+VkZ6aFuGzaLKAWyHhunCfXiJiK7YMjzfIsvbXOaAqVdy4jkUCuMn3iJvcY4V6nI+BGnsL3ucp6XWtq2RX9aQ3UP4XuF/tmn/iDWkpCMOalxPlL/Yk4SRmdB3sYGl1tV4g5rr1l8OO57yBSoxml0ZyUgLmNPutDteONxPKJGIAap/xTQn4bE1YuXsRmxVeyu9JrgM8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJ/CJuvtD52uGNWYR/3MbsekWfbAiuJZoNZC27Wph/s=;
 b=S3P7s4sr6soz0CTU0RXP29vGKY0Y0kmwJUDWiE3EzfgeDu+t6HcPAlR1chmxQMYnRif1uT/QPKB++1Njes1SwMpHExuyLf6mydJzXFk/2o2yIYB4mbzQPUoOb6UlBM6gHMHJ8OiX/blKonUOYiEsGCu9QGyoa7FkgvU7T8Wk7H+P01/xqTAB7kHlN1g1jBQZMwnOZZ+WdexNntr/IBb91knjTZtzh7pvMwQAvYS5IJRV8b80CI/xedHMDXWiT9jqYDNBnvxqAJf3aWZ/cX+HgC5o8QkxXQ/EhuzZULO3EbMf91p4Q2vM6hohN2kBDhszmZogKNe5ovehePkxYCqpWg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9932.namprd02.prod.outlook.com (2603:10b6:610:174::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 11:01:31 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0113.014; Fri, 12 Jun 2026
 11:01:30 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Andrea
 Bolognani <abologna@redhat.com>,
        Jiri Denemark <jdenemar@redhat.com>, Gavin
 Shan <gshan@redhat.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Sebastian Ott <sebott@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        Jinqian
 Yang <yangjinqian1@huawei.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: Re: [RFC PATCH v2 02/29] target/arm: Add ID Register field
 descriptions in cpu-idregs.h.inc
Thread-Topic: [RFC PATCH v2 02/29] target/arm: Add ID Register field
 descriptions in cpu-idregs.h.inc
Thread-Index: AQHc9MdWrrCTilo4XUyVl1SfTS/ydrY6s+6AgAAYG4A=
Date: Fri, 12 Jun 2026 11:01:30 +0000
Message-ID: <4FCC55AC-5079-4647-B4FA-220E15F46A77@nutanix.com>
References: <20260605083358.1320563-1-khushit.shah@nutanix.com>
 <20260605083358.1320563-3-khushit.shah@nutanix.com>
 <ea4c9d58-1993-4b61-8318-7c72f1650bc2@redhat.com>
In-Reply-To: <ea4c9d58-1993-4b61-8318-7c72f1650bc2@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9932:EE_
x-ms-office365-filtering-correlation-id: a4c9792b-222b-41a1-9de1-08dec871f561
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|4143699003|56012099006|22082099003|38070700021|18002099003;
x-microsoft-antispam-message-info:
 05iA3KiOrE1R+HJ6aPE7pjFqkC9+Q14Sp+0afH+26ZQXvNNc1wIL3qtyP/O2MMjNXCzRayY/GtpU38j4KrXfg2MTySvk5mW83iQIrAOmSCVDrCHe953B6hvweG4X+yYnx9QGlWrP+Kq7Q2RQCaRpZrHysvZQNZ2I11wgrkAp5KK3EuELcw+WFZYA9/vvNGZbR23hCTuGJGHpjsM+9C3Y46nSh3bWlGEWyFq74Yev0DmZ+jnd4oINglJQjFR1LaahR50bhvx83Iy3OJvQWHbxAH3/Il1N6mM0YrqgSU2aKwfllVTDEIgKlSxq8ipcf1/EUXXoaa3RF6ImJrGD4W+k1ixc5L+Qa3ctBaFdWcI+MocJCKuTDF8TWIyxAqrCFy9AuKfvsBOXLMsyY8mpmFNm6D37uZfT6V7vMUBYJjZTilmGyt51/L1nKcmW/WpY7A+yuLkp8HS229qmLYRjyxkYR4EzqxJwECp07gQUrNJH7PP8ZaUpfjFCsyVqw8JQCnJGGi1MNZZ4s8UyRZxffGilZUCpB1tqs9eQ5+cSxv6thxkEwwPjooLCZ/+qHqtrYpD0Wl43zKJdTgIZ7GHYWynd8hbU+V7oGIWIzL66qwbc813CyQ2DcFts9hLOzYuZpcYKRfsfGKocqAWsVnG+LsTCTN87NyFSNJ83lWj2Bneltpn17qUa8gemcALzKbyAAGOeU8IK5pdiZi/lwoo5KhDKEVj0F651U9OcHladL6Owwy6qKD5jzPayNmcIm4BlaeLr
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(4143699003)(56012099006)(22082099003)(38070700021)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NTE5c0hjQjZocXB3MlNCQTVRVGg5WVd5aU14bEkvSnNORE5jRStwd29XNTlM?=
 =?utf-8?B?ZTBmaG5JMkxqSURoc1FRYXpXOGpLTDRmaTdOeWdTMTl1RDgrcHkwSU44Wm5m?=
 =?utf-8?B?TC9rNFhBS3Mwak0wakM5bjROZlNISUdUOU1JMnU4cUduYjBVeXgvN2Z1Q0t1?=
 =?utf-8?B?UHp0cnFmN0FuTXRSOExKc2tlMmR5RVdXZnAzYzdML0Qvd1dBSlVFYXFiWFM5?=
 =?utf-8?B?OWJpNHZWbHdyVVYwaW1UclQvT3BCVXhVVFNtdUJzTjJLdmNJQ1FTL2FCVHdG?=
 =?utf-8?B?U2J6K0Qrd3lvRXVOdU5NT3NVNU01RFBYOTN4M0pJTzFNc2lwLzRzWXlOUldR?=
 =?utf-8?B?ckJLemlPN0s5Y29ndlFFRGVYeDVROUhlUDVRd3MvaFRXeFhmcmxLTVVUUlVh?=
 =?utf-8?B?MFlDRStNMmVmODZVSTZkamRXY1RNMDlIVzViWGx1UDlYQ0ZKNVVBN3hpc3pY?=
 =?utf-8?B?SzE0c2NQM0t0Z25GVkdmQ01EL2dZYkE2L1ROWmVNU3ozU0tzdjNnRkRYdDM5?=
 =?utf-8?B?Qnlnb0JWbDU0UEp5WkZZeEUrOFZDK1Z0TjFPT2JEZ3cwYk9nSFJlbzIzamk1?=
 =?utf-8?B?bG1VNjRxZ2VNVE9aMXVCMzh1STFpenJSd295bUNyN29SeXRoUWpmVHE0Ymcy?=
 =?utf-8?B?U08rb3laYU0vY3l3RWdlaElPaENJMHhvaHZSTDV6ZnNTemRxWGZMcTM5cjEr?=
 =?utf-8?B?VEEyYnBZS3QxK1lqZnplWVRQSTdKdS9TTnloQmM2Q0ZRQlc4RmdjMDFpQVhM?=
 =?utf-8?B?YkpWS0FCYXJrQ3k4QnJKbVBzdEhML3hkR3hEVG9wL1VKVjJKdHVNK0k4a055?=
 =?utf-8?B?YzJDQmJYVnRWVExVeithZWsza3dsTU01YitGejc0V1phSXcrbkc2S3Z2YmUr?=
 =?utf-8?B?RXF1SWt0V3lWWjdFVmVkN3d1U2F1d3N0bnU2L25pSGtTUHBpSmFSRlVacWhu?=
 =?utf-8?B?cTlpY3JyUENNOUJLelYzSnhCUHBPM3ZoVXJoS0lwTmNEOWJPL2RodnNNU3Nx?=
 =?utf-8?B?SXJDSVZxQnRlWERsK3lCbW9PWm5hcjRqcWc0OFJlVm5URkVGOUZjb2pUVjlJ?=
 =?utf-8?B?c3lJM1V5R2M2bVlBbzd4YWczTWlPTUZuQS9oOGJRU1oxUE1FbHZQbmVhQUYw?=
 =?utf-8?B?b2RFVWtaWExwTzJiWmxNRGJTYWZsZjIvZ09VMGFDekl5RGpIdHlvY3RVdDJS?=
 =?utf-8?B?cFk5eFkybUlBZWVnYUlNcHdCTGt1clRUSDJNYTVwY04raW5xdHFkOHdlTDU0?=
 =?utf-8?B?OEcydXFtU0hwYW9xWERxZ2ZtTFJxRFFCZmY3TkVlbm9IY2xPd3NLYkpvVW1y?=
 =?utf-8?B?Y0c2T2RnTXlwMHRKVVMybHBzVkFjRFYxU1F3alZlZ0M1TWVRazMzOHJZTjda?=
 =?utf-8?B?OW1PaWN6cmtXcGd3WlVpOExhNmdZSXh2ckJybE5UbUtuRXg2c1Y0ak1RNDZi?=
 =?utf-8?B?dXV2aDFhd0RXTmxKdWp3OUE0Vk1BekVjN1pZeEZURTI4eWlhanJIMWIzZHV2?=
 =?utf-8?B?ZW5EYzR3b3p1ZG1XWG5TZEZRbXpaeFhRVUtPQnBlN1RWS1JDQlFUcnhLdHJy?=
 =?utf-8?B?WVF5Rnc4b0lQdmZzS3NmUnIvMXlYdXA4ajVqQU5kQmhjOW9uRFlSTmNaUDJu?=
 =?utf-8?B?NUVZcjQzNUtxdkpUencxN0djdVBsL2MvVWM1czRmQXdVL2YrLzlBcXB3Z253?=
 =?utf-8?B?d29NMVJpRUlvSEFxZnVvWmY4S1cwSzllV1E1WmZkdVJUbU5mNm9tU0NHa0Y5?=
 =?utf-8?B?cmRUUGtFU0RjTytiSUNNYzZjWlQ1dVUvMmZqMjY0L1ZFeG91aGMvQ2VWbDZM?=
 =?utf-8?B?YytSVmNpU0JhRms4Ry9sMVBmVGczKzBXOVRrbEVrU2ZsdHo4REY1L2JGazBm?=
 =?utf-8?B?dU5xbEpVWHphTHBRRUxNN29xV3A3aDFUMU5XL0ZWRnJpZFpBTG41UTd5ZG9G?=
 =?utf-8?B?SjNMeXozcEYzSXR4SVJVdEI4b1hPb3ZzcWpWZUttRXdrQ3Q2a3R4RU5vc2Zm?=
 =?utf-8?B?alJGTWppSm4yajgzY0p4WGpZbHkzUUJpTm1jMmZUazhZOEd2dWVWcjJVbVF4?=
 =?utf-8?B?ZGVwanlUMmtXSDB2SHc5VjR6OXkxSVNiZ0pVdEhtTTB3UWtmZlRva0tyMDB4?=
 =?utf-8?B?NzEwTDJxZkpHb3pYVUE1Q3pHeXVnczQ5UE0xTnFOM055aXk2TWx6U1BUN1BT?=
 =?utf-8?B?eHJzakFRT1ZnempwWU5hQTdLMnF3OFI2MmRWNytMTitBMXVOdWZRdFNQWWVj?=
 =?utf-8?B?VFFMUW1POHNvZDArVWQ5aElNZjcvK3BiSE0yck1JWkFETHh2UUNyMXR0Rk93?=
 =?utf-8?B?NUx6TjlHdzlqc2FUdW1WcUluVnRKWmZFK2t3MHQrZzNTSXBEcVBWd25IQVdW?=
 =?utf-8?Q?tExe2WBP9J8dg0TU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FDE7DF847B92845980993997DDCC631@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	B7Zxs5yAUGYgCMynm2Y7WfcCckR8HHAr+xjldN6Bs8Z8R6/fSMGoww/F9i1doKfEMnxscA6vmZdE0x04rN2O84GDp/VtvmSg3AupNJ/BMpRBwLe8QtU5EgK0zZOnAsXVAsMpSxCwde0IUrTUTugmmZvcaCb9+XhUiU+ptUoby/24OZ+IBU727regdKDlAOXdkLGIbk7RsFfoLYlXW2IzFsvWcMab+CyBreW+pyKI6xqPAFejWF60E3uMGBemS5ltHDxgk4jZgwYo/zwb7NOm2ZI9KBotXu8+DAPXUknKHLj/st35hYcF5kjcmIkhD1JsGGoBofqmTjeoaFftJXCk0Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c9792b-222b-41a1-9de1-08dec871f561
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2026 11:01:30.6774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 468JQZInDCsEdsKqZA8LAUJxZOXL+CRp1/qP+FdwdJB76JutBDb0FW8QEen1Dzlsq8c6P5E0zQFuFEMK/two2FfglCa7HwXd8tyE4i6FJS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9932
X-Proofpoint-GUID: 5rzVzl0Bdx8aHG54KISwdUPYw2sk2iEu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5OSBTYWx0ZWRfXxYJfqFGMd+YX
 rTC7SnApJqO82wfXqzELgJkrfXHbVTbFmDmEOzFU79MWoxZXuZvy94UbByBsQA3z+2w7FlMVWoP
 ljzjHwQVCRQlDZm7qLhWNmxLuqMmjLE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5OSBTYWx0ZWRfX4TwL/FgkP481
 BOcCMckBn/6Sta6Bhz9boc661Xb2e/pHKHtgU3dGwDF+9CPBp561pUApjZO2ZRLT0b6/hkgQb0r
 bXYH4KrsdQPQLUT3QHzMfRPJlVNEVeLnb3O0UJtXWtmkzxv5XXNVip7igBfhAfGkJULfARJ3p9w
 o34V+iqSEBQ11bCsNgw5ijXcax5pXoRnrvOiwkKiQeOZGlEzyv8YOBHRVhaRNo2jHCbMMGMobf7
 xBbEy7b8GMitZlNb2/9PWPvChkj/Rn+mpY03ViYd4kY5ecq78+lCXbCtvMIS3GtG3HrdytV3tZH
 bmlcBwF+diPnH8Xe+JIy22hS4BsJXJ38DErkO8ovSCbi2EVqnD20JhrspkZUU3D5b5smkSU2rDA
 lxL7CapgrEqDZ3ZJ/1O6dGhrDx1Wsy/keq8KY4KqGxmE3X+o7oHfyrnW1P40/F6OaT+49p9c66j
 mttNsSJM8ChxOcHLTuQ==
X-Authority-Analysis: v=2.4 cv=OfKoyBTY c=1 sm=1 tr=0 ts=6a2be70d cx=c_pps
 a=3+BHtXVVVEj9tth3MIVLhA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=tcjJa4N0bUe3Ez2rcQwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 5rzVzl0Bdx8aHG54KISwdUPYw2sk2iEu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgSnVuIDIwMjYsIGF0IDM6MDXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEFmdGVyIHJld29ya2luZyB0aGUgcHl0aG9uIHNj
cmlwdCB0aGF0IGV4dHJhY3Qgc2RhdGEgZnJvbSBSZWdpc3RlcnMuanNvbg0KPiBJIGNhbiBnZW5l
cmF0ZQ0KPiANCj4gSURSRUdfU1RBUlQoSURfQUE2NElTQVIxX0VMMSkNCj4gICAgIElEUkVHX0ZJ
RUxEKElEX0FBNjRJU0FSMV9FTDEsIExTNjQsIDYwLCA0KQ0KPiAgICAgICAgIElEUkVHX0ZJRUxE
X0FSQ0hfVkFMKElEX0FBNjRJU0FSMV9FTDEsIExTNjQsIDApDQo+ICAgICAgICAgSURSRUdfRklF
TERfQVJDSF9WQUwoSURfQUE2NElTQVIxX0VMMSwgTFM2NCwgMSkNCj4gICAgICAgICBJRFJFR19G
SUVMRF9BUkNIX1ZBTChJRF9BQTY0SVNBUjFfRUwxLCBMUzY0LCAyKQ0KPiAgICAgICAgIElEUkVH
X0ZJRUxEX0FSQ0hfVkFMKElEX0FBNjRJU0FSMV9FTDEsIExTNjQsIDMpDQo+ICAgICAgICAgSURS
RUdfRklFTERfQVJDSF9WQUwoSURfQUE2NElTQVIxX0VMMSwgTFM2NCwgNCkNCj4gICAgIElEUkVH
X0ZJRUxEKElEX0FBNjRJU0FSMV9FTDEsIFhTLCA1NiwgNCkNCj4gICAgICAgICBJRFJFR19GSUVM
RF9BUkNIX1ZBTChJRF9BQTY0SVNBUjFfRUwxLCBYUywgMCkNCj4gICAgICAgICBJRFJFR19GSUVM
RF9BUkNIX1ZBTChJRF9BQTY0SVNBUjFfRUwxLCBYUywgMSkNCj4gDQo+IC4uLy4uDQoNCkFtYXpp
bmchIFRoYXQgd2lsbCBiZSBoZWxwZnVsLiANCg0KV2FybSBSZWdhcmRzLA0KS2h1c2hpdA0KDQo+
IFRoYW5rcw0KPiANCj4gRXJpYw0KDQoNCg==
