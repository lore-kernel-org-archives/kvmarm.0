Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3043E0C4F
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216831; cv=fail; b=GaG6UzANfK+fuo64e6S2ZJ9hIC2TLGWKPrXhE68LbpFGInUAUOay5cM3XWoFltYdwkdjL+YzMoUCZ6s/tbhQB6gtn0ADMCf6DQfq6ADP1ulr7QtFpcTL4wNr/NpkXANZfdMKZCEQ5hxx4CDLjd6O9eAitcerKdu+G48AO+BHNGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216831; c=relaxed/simple;
	bh=8q2es3jjbaoMW7Gp/6P2AsdMoZZjrEhWDqo4qez8zPo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kEpLKb9LrQW7IM8oKSbG88OnU6fSUZQjtaIvoAncAvNWV94/qkCYv6pu0Hfc6tM/vJGVa2OMKcvL+OBLTYwSspBA9jjworc+TMcM4inX6T4XnluwhtlxI11W3cPIrJ01aKMiFE5wb1A4iCGeDVbk/xE/9dVAmL/ScNSYGTWHhEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oJZSdUBt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=D9e6pS7G; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oJZSdUBt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="D9e6pS7G"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLB5Rj1477695;
	Thu, 20 Aug 2026 02:06:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=8q2es3jjbaoMW7Gp/6P2AsdMoZZjrEhWDqo4qez8z
	Po=; b=oJZSdUBtCZqO+IrzmpaEbNyTw+T8J2T+XMHNMQjZ0e7ih9ovbg1Rbgwo1
	mitaX6x5LHAO5UhgSe3ZRzHEBxkHqalIsnONZAqwCjZE2Wd+LBuitKcngCuS9Z+m
	hwhfgNLKeQYloKOmwH4a4lM4RElWsunQALYCLpnqksL+1Y/wT50P1uxVByjiLpko
	Y+YEfkupaB0ShqoYI5vVGjl2MKM1lTvdMgzu9FFd2XhvwTnQsT2+4qjJVg+LuddS
	aN6Avm247qRM/7WTmSHNpxXiWO9yEoa35dKUvGv1Y56k7NSNTU38VP5JSjickrGC
	CpvA7SKo5PggE8OjDUL5HIYLf2HCw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023133.outbound.protection.outlook.com [40.107.201.133])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4g4xnxcp1b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 02:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tmbUSdeZoJB3WEvJuqXLOy7b9yatTneA5S9WEhdZ0kej6w0q5ZJvlhto1IO8hRgCqPXUMEukdfB0bwzYExO5j7669/4+jjOmlCRmnE1xH7uubfqEjLdpIZTE5MqfDEq8Jeo/96yD4ACSPPb39ddyQ0GBgCEPfrvkJpvBWT/WRY+VonGieVHia2sP0V4Orru2NQ+R1JTMa/ib7uz0aP+TYEWIgj/9bd9SAu9EW8zZ0H+8PlqimLoNtzouo+rDypc5SlAYyS0HTGn8e67/B6HIx0aF6b10a0iaZMxCqWlBLxCALW2IXmnJRjC+9y0dz1rcwtMeL78WZt1H6iLPzzPy5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8q2es3jjbaoMW7Gp/6P2AsdMoZZjrEhWDqo4qez8zPo=;
 b=bL8B8D/zSI0i4Ou6wENU8pctwMOeShPkffUB6nbfhkBJzfXRxP/VMAAM/zntT/BfGUlcGz9foU063p4i5gWSunUMzmLGmqOJLUUAoj43cyCXVpw9SedSd53h6o83/gdbh7XUuZrDwh2LdjDxhOLqXBFF+3c1BGGMkfIqA2qBvCU0qCBTMskZppsyT6TX0jZcQ24tS/1U1raOMmSVX93eeyYSXM4qkXjVl/rx+R4gBMaAWdj7CkxJSO6w6RA267aYxA/Vq769s5JJAWARPWvdGmhdH1XMmseAPvHioJL7fuUnX7YsjnqMfhi3uMFSCkGy6YZsR7gIlzUo4fuXwuGDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8q2es3jjbaoMW7Gp/6P2AsdMoZZjrEhWDqo4qez8zPo=;
 b=D9e6pS7GZHhIJBiN5UW+Up6N5XL/FYZiCKrZ7LsZM5YZmrLOPxOh465OD9QB3bb4/bNuSuOEAhPVZGpjEM0xz26/gPBGHKBOfCfSu82WxRirqNWyR8v3zc2mtC1tp1pCJXhz4vcgd27efsgPBY6dBmNAw2wyed7NpiWCZBZPVoMIpbNCCVIQS4O6CsQwffh0+My47ziicA826Yw2VCPvDfbYm7MUKSRYt7KculFVjXP5aOutDMXb7lfRZWn1KZCmeae55m83YBCpFrPc1bXD6ebzRy7XH6pPjx3U+GT7MBlZywj96kvBua+3lZ4Jt1dP3itfFxmqvD/1nD88us72QA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by SA3PR02MB9280.namprd02.prod.outlook.com (2603:10b6:806:313::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 09:06:54 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 09:06:54 +0000
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
Subject: Re: [RFC PATCH v7 09/18] target/arm/cpu_idregs: generate tables for
 Arm64 ID registers and fields
Thread-Topic: [RFC PATCH v7 09/18] target/arm/cpu_idregs: generate tables for
 Arm64 ID registers and fields
Thread-Index: AQHdMIM+toraSn9bIUK8/xkdnTB+rQ==
Date: Thu, 20 Aug 2026 09:06:54 +0000
Message-ID: <5440A74A-2431-45A0-B8E0-DF16C545FE33@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-10-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-10-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|SA3PR02MB9280:EE_
x-ms-office365-filtering-correlation-id: 3f3d439d-b0c2-4548-e4d0-08defe9a6133
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|38070700021|56012099006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 pWKhOBKjUy8yHrNykU62BnqkJIGaqHbDwmnzr6kp7Fm+DSOW3/RHB/fHrMEgVXXOM2dfNMjItpkfZ488b26Kqb5mPm5xWpxUD51op/nda/oALsSNhQubWtxF6LqqtpfrQBc84Edn0Xy/AK3GAIILq034cVTTr79xY+2vJBEiSVuiPN/HOoXtOUAnBr+Umbq3fbsc/+c8x56zUxERMREruMGCqzBIkhxIFLMoeYk1rTFN3dTF2DVrlRKk/lqzBVumHNyUNcwegsXuJ5+9sXg0GzZA7Pu7lDLM15zDLxNXwD56Ez15ctNt+9TNClOh15weIkcTGUmh4RWgh+fa0BVm6cqZJPujdTNdihZ5Hvez5No+6dLSovm6/Y+FJ0l2+ZbfklX/+6maW/bulXDR1oPu0FF29OYRQZ+0yfZ5d9JN5IsfHHYNaJkg8vGp02ZRKGN/IwzfoApyp3tYIUv+Ae3W66w2lvaqs/Vh52HrINyUt1GFg7m/bbrR7jEJQS5bKDBgEUbuBGrSqOyyayDvK8DMY5p/JYYFQYeDaU+29VzH+/81LIcjhnn4p9rUCN6pvx32x38QZ6gB/aeVaoHqo54G10SGbPD8MP3mX1fortNNRbD2oKqKzHtLL9HwI8zRDH0UGUiCqDxxsaBel2+6ESnyD20Xzg+x/AFzAJYqN4UYm3/UNdzR981e8bQK94fePW2AhJCEfpU8KhBxXSw8Rsf2yIl9n72gQLhLINq6jBNLB6Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(38070700021)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUlYemh5eWxJMnZSaTZ1b2F1Yk1LTlpPNytWVHMrZXpIdkh5dGhOSm43a1ZP?=
 =?utf-8?B?OGxDYUF3am9rbWZoQ2FYMW5iZ1VFK1g0c1NMb0d4RHdHQTlLa3FJNzhoN3c5?=
 =?utf-8?B?T3RVN0pMYXowTk9wYUhhRDg3N3BBU0pSWlM2eW11MUtKaDdCM2FxTE9zTGZl?=
 =?utf-8?B?TFpPOGljcW9XMGZnU0pqQUFKcE5JUjR0MDIrTmV6d0tWZXpvRWlSMEJrY09U?=
 =?utf-8?B?TGZFemFVRXRRSVU1azM2cWRDYllwMTYvaXlGdWVQYWt6RVR2eWpIQVJiTTls?=
 =?utf-8?B?UWJzZDBhZ0RoeExZZTNZanhucmo4ZWlVSHF1c0VtQkhDY2tIVFN6K0FIc2po?=
 =?utf-8?B?SVc3Y2lBdjZPazVENmRwUktoWTN2K0gyWFYyS1VDbkNOdDNLL00xc1F3TVJ3?=
 =?utf-8?B?UnZkdkkzcDhpeUR2UzJQUEI1eVY5VHdzdERSQlljVEJUQXFyd3BpNlBFdWhI?=
 =?utf-8?B?bXFSMll5RWlzcjFicEhrRVI3US8yRmFlMVJYWXJ4dzJkL2wrVnp6U0UwK04r?=
 =?utf-8?B?bVBDOXpZRm1Vd0JRV3ZtOE1SV2VIRnNoNDlWcnlraFM1SUE0OFNZTXMvalgr?=
 =?utf-8?B?SU04VkprQ1crY2J6amtHL0d0NHpIeFQ1TExiOVQ3ekJwTmRJZ3ZKT2IyVjBr?=
 =?utf-8?B?MFA5NkpsSTRTTHZJUWVPeTVwcGs4VTJaVWJiY3hLYjl1NGZrZ1pzRXRRaWpm?=
 =?utf-8?B?bTQvTUY1bzNFenNMNkgxMXBLZlQwbjFXVXdDK1BVTS9ONWlLOHpnS2lTdGVH?=
 =?utf-8?B?TlZacHVKNjRmeHIrRVBrVys1MU5GdXRSYTJhQTlNZi9rR0haNmtpaER3Y20w?=
 =?utf-8?B?cWZ3ZVZLMnBUcDRueGxyYnJVZ3NhZUJVZXVNYnR5WExTSEZiaTBuZ0QwR0tx?=
 =?utf-8?B?Mkw2MFhDc2FyQ3pSemROTndRekpvQjdBd1VTZmp3clRCQWdDUlEyK2c2N0pE?=
 =?utf-8?B?WVZrZzN6VDBnUCs3ZlczTXhSMmFlNm0yWk4yd1N1VEJndEJNc1pDSU9yZXZ5?=
 =?utf-8?B?eDJvTlovSUlhQ2o4OFdsVjY1Y1V3UmF2TEIrYm5tWWRhVnRVS1AxSWlSN0ow?=
 =?utf-8?B?bGl5U1FpbDg5RUYzQnRHSjlTdDBnaWkvSDBoRDJHR3hGL3g4UWR0VjZnQ1BQ?=
 =?utf-8?B?YVo0Z3BldjdoQzVkZjNpZFlPNUFQWGZaN3FRSjkwN2dJVys1UVFxR01KZ2VW?=
 =?utf-8?B?TFBBS3FFc0pmMkpoNlhRMUg5eWZldmZIblZxaHNTMXMyUWN0NmdxaEQ3TW5G?=
 =?utf-8?B?T2RPUXN0UWRBZmlhMVhESmc5dVh5WWdyN25UclI3cG9MZlp3WHgxdU4wZnFq?=
 =?utf-8?B?Z1h1cmpXN2x4c1Bzd3VuQzVJcERiVkFwSE5nL092WCt2NFgyb3JwdVdUOFJu?=
 =?utf-8?B?eUVNaGE1bE1sL2pDTnJwdnZFS2ZJL0I0eXJuQytQNEVQTk55Yi9aZmZNZ0Rt?=
 =?utf-8?B?MWZrL2hqcjZVMGtrdGhaSGpOREJiTG90eUcxVnBYQkdrS3NjZU5HUFRyRDEv?=
 =?utf-8?B?T1IyUDQwWkVyWTNIdCt5THBYK00rQys4NDlTM2VQVjhwNDhVdVJyR0pyaXha?=
 =?utf-8?B?UHdtL0Vpc3FienBKYjRKbTE3WnhJcTM0SlBuV0JxZ0tnbnlFQ0ZrMVB4R2Jj?=
 =?utf-8?B?VDFHaTF4Z0tLK2RkenRhdHE2QXJQQXVhUDlBWTBmWEZHQjIzOVlhck1nY25J?=
 =?utf-8?B?KzlhMFpxK3Mrc3pDQ2NsVnB5MDB2U2h5R3VjSnF5bHNiUEhNeEZkL2s5SUFw?=
 =?utf-8?B?bnBiOGRYeDgzaURFMWk3T21Dc1FkelJFWnBSS3hSZGJTWG8xTEplazFnT1N3?=
 =?utf-8?B?Vmd5cERUQS8waGRDY0g1M0lMQzk4MDhkaGtPYjdJT3NjQmFCRWlKajZMWHJy?=
 =?utf-8?B?OW9KOXh1WDhVLzZKS1F6Q2tUc1MxcHVzUEk1VVRSdENCanF5WHVtT1psaXdJ?=
 =?utf-8?B?MWJhaW5DODMxYXVCN1pIamZNdnM2VmREeC9Zc3pETWNwd2F6cFkrZVdEZXdU?=
 =?utf-8?B?cXZiN2VEeXJWMjN0QW5GSERtMlA2NzF1QWZrN2JMSmpqcWdDWWNDUnpySDhU?=
 =?utf-8?B?dk1GbDVQUlVqZEg2cTBoOUtncFVTRlpmSEJSWXVWVE5mR085YmNQZm1aSW9X?=
 =?utf-8?B?aTZ2RGIrdVJYVnJjUHVUQjY2ZWlyVFBZUDhtVTRXTHhadlB0NlluK1RKMCs1?=
 =?utf-8?B?ZmZucHJJUVdvdDhzRVlaSG1uUS9Nb2pCb0VSK0hCN2dUN0JPTjlGZWZTU2xF?=
 =?utf-8?B?WkVRM2s0ZGpZLzJwZnVTTkl0K0tna2YybVFtV1JseHN0T0lrNGtHcTJvMTFZ?=
 =?utf-8?B?aTQ3QlJxeEF6ZU9EQ3BmdGt3K21wYm5OS0tGb0RqNzdYL1pBZ3RkejFXajZm?=
 =?utf-8?Q?Kw4BAr6amN3Q3ww0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F48166E1A79E7479E83286142694087@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	szQhJ2NVQbPquW4nycqCtcG4lSYJcKypSb8LLUidtBmRsrLu2xqZwhFlPerNHOS3H8OmYwVvqvjyXh3qsv2pX3OL1txp5lXvUuBUtfryz2AvCOsu2GwTleZ0PJp6Yzjy9X4i82ulNtgYZDOwxsJXxKaxF4DaBxKSvctELLiwSe0Y0pkov18z+feO8Hfn8PSaOyk2KEoTHdQUaCsK/IpttFjSxfnG4ZPzhkSt2QomqAA8VHMOPCP7b0zqh8/3Zl+QKMxJFGUP3ExXiAIbJJerOcXOB0xwk5dF5zWfOJ5loyqQtGwOvgpBJB2PQE5fKWxEigyBf5VNnNuUopGP9cEqmw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3d439d-b0c2-4548-e4d0-08defe9a6133
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 09:06:54.1353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UGG6Iampq/mrOX8rgJRx7fyPcAZtdT1qf36v3w11mCFdcQ+SMwGk6kpsGsyj8GFUD8a42Ag3z4qzex9D/q5tgYNnXAtANbAlGmh0x0eetS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB9280
X-Proofpoint-ORIG-GUID: 9k2dwjmmmr54-taZaV3ZZlwW-k_9P0Nz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA2NSBTYWx0ZWRfX9V8m031xvuJE
 FbRG5p5Xwd054cMg1gnhLxMD97mL0E/dtSaleDNMwM+f/idkg8sCfSlCdppc7s0i4YSkKPliZ/L
 GokolkuoHOv2IMRoUwtc5tgLg2+7zLwJbbvTiMTXcij+VfGIO8oRikZmZh0XaAWvmz+z0GAU6iK
 Lt3mMA/xONxPiVqqWUrxE4oA+2+HozP5rxZ0qo6RID6SSFgD5673Hpgy+n2katv2ELpTdWWbf9r
 sm3aVlyPDt0f76HwLE/NH9ywqAzg8imxtyfuOZSvO3kfl1AolW05IcSlkfNa2/iQaBgGdS5PyrJ
 bT5tZWQP129K0KjLbN+BnvSRbG/K3X8fhBMgeKCyYy5yRq8Jnx3omwu8rLIsT6+Mmdtg7TX8U9G
 G/Goj2vjXUKGZpuKiADRVqR+CtNhVxs9vbOB/oyipvxcFqyS066RqYxsGlyvYuiy0tjLuRGG4K/
 khqRA3C69/ZNtFDM03A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA2NSBTYWx0ZWRfX1Ev+vEAXf8mH
 9u/x8QYNyDdMIIfacoe+GUrv+2/aH3GFiJCoPXjwqqhJY6ExBu2oiWtZmFxjaP+UUcfdK25GpQK
 ZYvs5N4sOLfbRX4+WIJUYBNbynU66UQ=
X-Authority-Analysis: v=2.4 cv=TfqmcxQh c=1 sm=1 tr=0 ts=6a86c3b0 cx=c_pps
 a=4JgRTaXVPfESfdVeiImlhw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=rok4wjhScJExe7kjtJYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 9k2dwjmmmr54-taZaV3ZZlwW-k_9P0Nz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogU2hhanUgQWJyYWhh
bSA8c2hhanUuYWJyYWhhbUBudXRhbml4LmNvbT4NCj4gDQo+IEluY2x1ZGUgY3B1LWlkcmVncy5o
LmluYyBtdWx0aXBsZSB0aW1lcyB3aXRoIGRpZmZlcmVudCBkZWZpbml0aW9ucyBmb3IgdGhlDQo+
IFgtbWFjcm9zLiBUaGlzIHdpbGwgZ2VuZXJhdGUgdGFibGVzIGZvciBhbGwgQXJtNjQgSUQgcmVn
aXN0ZXJzIGFuZCB0aGVpcg0KPiBmaWVsZHMuIEFkZGl0aW9uYWxseSwgaW5pdGlhbGl6ZSB0aGUg
dGFibGVzIHdpdGggYWxsIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkDQo+IHZhbHVlcy4gVGhlc2Ug
dGFibGVzIHdpbGwgYmUgY29uc3VtZWQgYnkgdGhlIHByb3BlcnR5IGxheWVyIGluIGZ1dHVyZQ0K
PiBwYXRjaGVzLg0KPiANCj4gQ28tYXV0aG9yZWQtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5z
aGFoQG51dGFuaXguY29tPg0KU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNo
YWhAbnV0YW5peC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNoYWp1IEFicmFoYW0gPHNoYWp1LmFi
cmFoYW1AbnV0YW5peC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4NCj4gDQo+IC0tLQ0KPiANCj4gdjUgLT4gdjYNCj4gLSByZXN0b3JlZCBz
dXBwb3J0IG9mIGVudW0gdmFsdWVzDQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2NwdS1pZHJlZ3MuYyB8
IDk2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+IHRhcmdldC9h
cm0vbWVzb24uYnVpbGQgIHwgIDEgKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDk3IGluc2VydGlvbnMo
KykNCj4gY3JlYXRlIG1vZGUgMTAwNjQ0IHRhcmdldC9hcm0vY3B1LWlkcmVncy5jDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMgYi90YXJnZXQvYXJtL2NwdS1pZHJl
Z3MuYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwLi5jNDFkMGFi
MGM0DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMNCj4g
QEAgLTAsMCArMSw5NiBAQA0KPiArLyoNCj4gKyAqICAgQVJNIElEIHJlZ2lzdGVyIGZpZWxkIHRh
YmxlLg0KPiArICoNCj4gKyAqICAgQnVpbGRzIHRoZSBwZXItaWQtcmVnaXN0ZXIgZmllbGQgZGVz
Y3JpcHRvciBhcnJheXMgYW5kIHRoZSBnbG9iYWwNCj4gKyAqICAgYXJtX2lkcmVnc1tdIHRhYmxl
Lg0KPiArICoNCj4gKyAqICBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRl
cg0KPiArICovDQo+ICsjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0KPiArI2luY2x1ZGUgInFlbXUv
ZXJyb3ItcmVwb3J0LmgiDQo+ICsjaW5jbHVkZSAicWFwaS9lcnJvci5oIg0KPiArI2luY2x1ZGUg
ImNwdS5oIg0KPiArI2luY2x1ZGUgImNwdS1pZHJlZ3MuaCINCj4gKw0KPiArLyoNCj4gKyAqIEdl
bmVyYXRlIGFuIGFycmF5IG9mIGFyY2hpdGVjdHVyZWx5IGRlZmluZWQgdmFsdWVzIGZvciBlYWNo
IGZpZWxkDQo+ICsgKiBhc3NvY2lhdGVkIHdpdGggZW51bSB2YWx1ZXMNCj4gKyAqLw0KPiArDQo+
ICsjZGVmaW5lIElEUkVHX1NUQVJUKHJlZykNCj4gKyNkZWZpbmUgSURSRUdfRU5EKHJlZykNCj4g
KyNkZWZpbmUgSURSRUdfRklFTEQocmVnLCBmaWVsZCwgc2hpZnQsIGxlbmd0aCkNCj4gKyNkZWZp
bmUgSURSRUdfRklFTERfU1RBUlQocmVnLCBmaWVsZCwgc2hpZnQsIGxlbmd0aCkgXA0KPiArICAg
IHN0YXRpYyBjb25zdCBBcm1JZFJlZ0FyY2hWYWwgcmVnIyNfIyNmaWVsZCMjX2FyY2hfdmFsc1td
ID0gew0KPiArI2RlZmluZSBJRFJFR19GSUVMRF9BUkNIX1ZBTCh2KSB7ICh2KSwgIiIgfSwNCj4g
KyNkZWZpbmUgSURSRUdfRklFTERfRU5EKHJlZywgZmllbGQpIFwNCj4gKyAgICB9Ow0KPiArDQo+
ICsjaW5jbHVkZSAiY3B1LWlkcmVncy5oLmluYyINCj4gKw0KPiArI3VuZGVmIElEUkVHX1NUQVJU
DQo+ICsjdW5kZWYgSURSRUdfRU5EDQo+ICsjdW5kZWYgSURSRUdfRklFTEQNCj4gKyN1bmRlZiBJ
RFJFR19GSUVMRF9TVEFSVA0KPiArI3VuZGVmIElEUkVHX0ZJRUxEX0VORA0KPiArI3VuZGVmIElE
UkVHX0ZJRUxEX0FSQ0hfVkFMDQo+ICsNCj4gKy8qIGdlbmVyYXRlIGFuIGFycmF5IG9mIHBlci1y
ZWdpc3RlciBBcm1JZFJlZ0ZpZWxkW10gZGVzY3JpcHRvcnMgKi8NCj4gKw0KPiArI2RlZmluZSBJ
RFJFR19TVEFSVChyZWcpIFwNCj4gKyAgICBzdGF0aWMgQVJNNjRTeXNSZWdGaWVsZCByZWcjI19m
aWVsZHNbXSA9IHsNCj4gKw0KPiArI2RlZmluZSBJRFJFR19FTkQocmVnKSBcDQo+ICsgICAgfTsN
Cj4gKw0KPiArI2RlZmluZSBJRFJFR19GSUVMRF9TVEFSVChyZWcsIGZpZWxkLCBfc2hpZnQsIF9s
ZW5ndGgpICBcDQo+ICsgICAgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiArICAgICAgICAubmFtZSA9ICNmaWVsZCwg
XA0KPiArICAgICAgICAuaW5kZXggPSByZWcjI19JRFgsIFwNCj4gKyAgICAgICAgLnNoaWZ0ID0g
KF9zaGlmdCksICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+
ICsgICAgICAgIC5sZW5ndGggPSAoX2xlbmd0aCksICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXA0KPiArICAgICAgICAuYXJjaF92YWxzID0gKEFybUlkUmVnQXJjaFZh
bCAqKXJlZyMjXyMjZmllbGQjI19hcmNoX3ZhbHMsICAgIFwNCj4gKyAgICAgICAgLmFyY2hfdmFs
c19jb3VudCA9IEFSUkFZX1NJWkUocmVnIyNfIyNmaWVsZCMjX2FyY2hfdmFscyksICAgICBcDQo+
ICsgICAgfSwNCj4gKw0KPiArI2RlZmluZSBJRFJFR19GSUVMRChyZWcsIGZpZWxkLCBfc2hpZnQs
IF9sZW5ndGgpIFwNCj4gKyAgICB7IFwNCj4gKyAgICAgICAgLm5hbWUgPSAjZmllbGQsIFwNCj4g
KyAgICAgICAgLmluZGV4ID0gcmVnIyNfSURYLCBcDQo+ICsgICAgICAgIC5zaGlmdCA9IChfc2hp
ZnQpLCBcDQo+ICsgICAgICAgIC5sZW5ndGggPSAoX2xlbmd0aCksIFwNCj4gKyAgICB9LA0KPiAr
DQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX0FSQ0hfVkFMKHYpDQo+ICsNCj4gKyNkZWZpbmUgSURS
RUdfRklFTERfRU5EKHJlZywgZmllbGQpDQo+ICsNCj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmgu
aW5jIg0KPiArDQo+ICsjdW5kZWYgSURSRUdfU1RBUlQNCj4gKyN1bmRlZiBJRFJFR19FTkQNCj4g
KyN1bmRlZiBJRFJFR19GSUVMRA0KPiArI3VuZGVmIElEUkVHX0ZJRUxEX1NUQVJUDQo+ICsjdW5k
ZWYgSURSRUdfRklFTERfRU5EDQo+ICsjdW5kZWYgSURSRUdfRklFTERfQVJDSF9WQUwNCj4gKw0K
PiArLyogZ2VuZXJhdGUgYW4gYXJyYXkgb2YgdG9wIGxldmVsIElEIHJlZ2lzdGVycyAqLw0KPiAr
DQo+ICsjZGVmaW5lIElEUkVHX0VORChyZWcpDQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEKHJlZywg
ZmllbGQsIHNoaWZ0LCBsZW5ndGgpDQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX1NUQVJUKHJlZywg
ZmllbGQsIHNoaWZ0LCBsZW5ndGgpDQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX0FSQ0hfVkFMKHYp
DQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX0VORChyZWcsIGZpZWxkKQ0KPiArDQo+ICsjZGVmaW5l
IElEUkVHX1NUQVJUKHJlZykgXA0KPiArICAgIFtyZWcjI19JRFhdID0geyBcDQo+ICsgICAgICAg
IC5uYW1lID0gI3JlZywgXA0KPiArICAgICAgICAuaW5kZXggPSByZWcjI19JRFgsIFwNCj4gKyAg
ICAgICAgLmZpZWxkcyA9IHJlZyMjX2ZpZWxkcywgXA0KPiArICAgICAgICAuZmllbGRzX2NvdW50
ID0gQVJSQVlfU0laRShyZWcjI19maWVsZHMpLCBcDQo+ICsgICAgfSwNCj4gKw0KPiArQVJNNjRT
eXNSZWcgYXJtNjRfaWRfcmVnc1tOVU1fSURfSURYXSA9IHsNCj4gKyNpbmNsdWRlICJjcHUtaWRy
ZWdzLmguaW5jIg0KPiArfTsNCj4gKw0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9tZXNvbi5i
dWlsZCBiL3RhcmdldC9hcm0vbWVzb24uYnVpbGQNCj4gaW5kZXggNDQxMmZkZTA2NS4uZWQ4NTM1
MTkyYyAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9tZXNvbi5idWlsZA0KPiArKysgYi90YXJn
ZXQvYXJtL21lc29uLmJ1aWxkDQo+IEBAIC0zMCw2ICszMCw3IEBAIGFybV9jb21tb25fdXNlcl9z
eXN0ZW1fc3MuYWRkKHdoZW46ICdUQVJHRVRfQUFSQ0g2NCcsIGlmX3RydWU6IGZpbGVzKA0KPiAN
Cj4gYXJtX2NvbW1vbl9zeXN0ZW1fc3MuYWRkKGZpbGVzKA0KPiAgICdhcm0tcW1wLWNtZHMuYycs
DQo+ICsgICdjcHUtaWRyZWdzLmMnLA0KPiApKQ0KPiBhcm1fc3lzdGVtX3NzLmFkZCh3aGVuOiAn
Q09ORklHX0tWTScsIGlmX3RydWU6IGZpbGVzKCdoeXBfZ2Ric3R1Yi5jJywgJ2t2bS5jJykpDQo+
IGFybV9zeXN0ZW1fc3MuYWRkKHdoZW46ICdDT05GSUdfSFZGJywgaWZfdHJ1ZTogZmlsZXMoJ2h5
cF9nZGJzdHViLmMnKSkNCj4gLS0gDQo+IDIuNTMuMA0KPiANCg0K
