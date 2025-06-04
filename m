Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D0028D8EC
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032113; cv=fail; b=MUYrWxsWLdXsqAssYd4y0jI4sJqpGxoXUv4kuKc0pEh8zj7sF+bVHtCLasCJeUfnFFpdDsmPYfpsOWRBVlyqC8aORHWui8QHlXjBNATD2Bfle6fm1JZ4TtIMwFD1Fi5Mwkynrid9o66iPFNQE9KqmtCzSUaCOt/lp2QSfCjIRlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032113; c=relaxed/simple;
	bh=Kc1dLxkNPNjh4jbdRDC+fvNyGv1tlYssmXwjNqYDxvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K/90NHA9gRBMtL14M+np112rq7MYM8NUOZA5NPxFk0HrZQVPyx+57uU7ofN4mq7L1KA7aJHOeoJTbj1tx3yQFHQh9/zjWdQmztvYJCnIZzXm3GGvvfnCNpBHbbEuO30gKx1RclUOUFnf5UaT3mrKXhw3xVWIr2KXfRSeZ+ccedQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ft+yLWT6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cVolO0WL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ft+yLWT6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cVolO0WL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5549Mflc024860;
	Wed, 4 Jun 2025 10:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kc1dLxkNPNjh4jbdRDC+fvNyGv1tlYssmXwjNqYDxvQ=; b=
	ft+yLWT6AQKqpt34jbD37nzzEbrYez2xjhEVFbkzvA/heLZP6t0MtUD16DzzVvBk
	C2jMONHO5qqvy/d951xlkTpnASUzi/ezUDqQWffKj5zyzXf4Z6PsCvmptEUddOMr
	RjB+52UAzh87p0NMU8hZLQ1Yu5aUNhmtmQ/DRZVBXsC/oIXNDJV9UpDYo1W/iJqx
	MbgwQI4EpUyza/3RCveraBBXYxQR3Ozs7OLfOSsfO9HHV/vVAuzgN3u6JTpGFuiS
	RlSkrQWVBVceJRF5JRyEh4XmOJggMf0LaQ/q2mGeyU6K7F4pVPqZqM9Fjk0eD9ZU
	E+/2/pUdgFB/WFJLjBi8/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8gbnfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 10:14:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5549dqgU030680;
	Wed, 4 Jun 2025 10:14:53 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7ajvuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 10:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qscAGm/GMlAIw2PI3pLMWKuxxWiT3iieqoHafNVcXcFDR7PNT19tKs9wbbIEnxXzGm0ogKsc49To+RekuCCuk/5aJOkMkGAyBqCqCIuRxEqGa+O5hYWjoG+3yJZFlaETop9PftqBzFf9/9N8xwfQhCn1r8e4pBNthYqipKBamEyOKAVHI1s7igxMOz6MAITJI9fjDrNdID+UDH+1jX+Sd4Bm2r3Kmub8b/XKOa3kZSY+e+IhVJWqzRLv63VEB7O9ObntILZGNfudHzuKn0zcMXSsoAnmOdVuPMHSH0Z17wXsfrqXJ2hfHeYFEntOv//znNEMqT9cq5wq9W6bAl9Jig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kc1dLxkNPNjh4jbdRDC+fvNyGv1tlYssmXwjNqYDxvQ=;
 b=mXzQoZnkwrdrdhuxtHNJW92B01M3c8Z34FAqo9jxwgl/Iv7oxUoBIgeYZ33mFJnoKeXGkZmyswiCOicdyczttDfhQaCNmsvJMY8jefAvDZemCHgJJH1HD1gNlzql4Gq1I4UgFeXobjLTZjROYPYTBLQVL3Oqu96b3dy4iwCAMk9t4loQXoQMWM9fFjipp9ZcCW5QzceozZAaVIwXePDUSH8WZxhHh6kd9dvvPBv2//wnNsvlxSi+Z2gFgl8gS7Z+grHhdpO+2JYjrmWiT7fK8Uo1dopXqwb4ibFj+PwCfmvxJLHlP1CdFM4oVww74xQuOZS1Fm84BaO8w/rbMxHtBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kc1dLxkNPNjh4jbdRDC+fvNyGv1tlYssmXwjNqYDxvQ=;
 b=cVolO0WLUj/EIkjKB86dRpo9wzrgm7Qj+nt4OQMogyabh/XaU+cu9MsC2BTcPdUftDImuPhxg6cHBtPU1bDCjvJkMPI93UXnYf2FPmB+BsA9Q3g7kGGY/4ztur737T6TTjIah8Vv/YtGeoX1noPq+zmvvJpWdTaCTJoaaIi+UuM=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CY5PR10MB6012.namprd10.prod.outlook.com (2603:10b6:930:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Wed, 4 Jun
 2025 10:14:50 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 10:14:50 +0000
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
Subject: Re: [PATCH v2 1/4] KVM: arm64: Add assignment-specific sysreg
 accessor
Thread-Topic: [PATCH v2 1/4] KVM: arm64: Add assignment-specific sysreg
 accessor
Thread-Index: AQHb1FZnevywAwfY5kO+OoerOuGUWrPxulwAgADXVICAADiaAA==
Date: Wed, 4 Jun 2025 10:14:50 +0000
Message-ID: <F09E1C4E-FAC5-4976-B792-1CD8A48AD6C5@oracle.com>
References: <20250603070824.1192795-1-maz@kernel.org>
 <20250603070824.1192795-2-maz@kernel.org>
 <84553621-E2B8-47A0-A812-FE273505ED47@oracle.com>
 <87ecw0dmne.wl-maz@kernel.org>
In-Reply-To: <87ecw0dmne.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CY5PR10MB6012:EE_
x-ms-office365-filtering-correlation-id: 775d3561-143c-4a9d-15c7-08dda350a453
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QWlmMTZRSFBXZXNxeFZ3S2lsN3RjUkEzZWNicGQvcGlxWXByRFFYdnU2VnBu?=
 =?utf-8?B?Zk8xb2p3bHVidjZwZmZBVm80c0ZSVW9QMlY4K1FjM1dOSm1VTitTRHJ5U3dY?=
 =?utf-8?B?dFN4NkpzZ3hkdGwxTFJBNUxObTVsNlQrL3dvV1RKUC85Z0krWVd1NlB1UUxO?=
 =?utf-8?B?aXFpUnNsNEorYjl0aE9wRUpXM3czWXVjS09mWTV4Y1NrVCszQ09YLzhZRFlr?=
 =?utf-8?B?UGJjeG1ncjllZWlFUTJWOWc4OEpmU0F0RUtVdTAwb0lHRkhvcjNCZHR6bTZ4?=
 =?utf-8?B?amY0NHdIWjEzSWttbWs3cW01UERRNFFxNS9WZmdVWkRzQXY0c05yV3hDTmRy?=
 =?utf-8?B?R0REYk5EUW4wTmhJcTJ1dGMwQUJOTml5b0lMNzFneGJ4QmpFekhNQmRPbUg1?=
 =?utf-8?B?NE5LVDFLOEpZVk1QaFdVZ2RCblM1dWw5QU12b0NYcWh0VXV1b1NSNEVvK24r?=
 =?utf-8?B?QzJQamxLQ3A3bE83aGZPckcvZXNuSCtGelR6NDV1M3pzMnZHaE5SRkpWamFQ?=
 =?utf-8?B?bTh4WmQraVRUNGxDelcwbWpGVGdqZ0o5d2lMa2ZFdnpUOG5PUCtPdkU5TFpE?=
 =?utf-8?B?bGpUZ3EraldvczdGMzdhWGMvbGd2ZlBxREprQXZRQ0pNVUN6NlBjZ0tpbFpj?=
 =?utf-8?B?Wk9lNWk3WkthRDN6L3YxSzkvdHh1ZGtVZCthZnRwalBGR3RuSkczOWFZNm9K?=
 =?utf-8?B?R0pQTjB1NkU1Y1pRV3VPY0xiYzZydG9ZdjBnc1pqWG9ZZUIvcVp0NEdYUDBp?=
 =?utf-8?B?RkxXdlF4Y1ZCQUxzcHFRWmhxS0k5ZzBvZmFoanZncUJaOHVXWWRzOEl5Q2U3?=
 =?utf-8?B?L1NCeEdlU0EvdUU1SWs4ZnJwS0VDMCtWc29Yd2dnV1VURzBFT1Y5OHJKOXI2?=
 =?utf-8?B?U21kamFOV000SUZsaTlUYW9yUzNGcTVwUlhnK2dwdmNJanJ4RFBXcGxkS0VB?=
 =?utf-8?B?dThGRVE4VmxGdUJ1SVBuSXYxUlU5bEY5TExlcVZUZWwwYjNnRE5nSWZ5dzk4?=
 =?utf-8?B?Z29nSzBuZUw1TGxPcWtZTlNsSG5ocVVWdERmRW1UTEZsUEZoM2cxSzFLUEly?=
 =?utf-8?B?bkh1Uk1zTnk2OTRhdHNVeHZObU13bTBXUWFQaTRrUkgzb1N1clpENEI5Ymtx?=
 =?utf-8?B?RUJYcmdsSGJlc041eElkMUR4ZCsxU2V2OUcvVEttcS9KaU9lczlpQ0pTSExl?=
 =?utf-8?B?T0JzNE9pbjlIelhIdGNYTzlBRWRqRjJvUngzcVpHRkszWDdTd3JmLzM2ZkdH?=
 =?utf-8?B?QmhSN29qSlFGb042WVp1M3ZxTFpHbFQrMFQ0OHVQMHVZRGVEQWptd2lXdTRa?=
 =?utf-8?B?b0ZmQ3JYRG1xbFMzTUU2MEZ1SjYveFVTRXE1bDdtY3R3bDBRZ2l1TWVJTkxw?=
 =?utf-8?B?YjJINllOWVpkMFJpSXhTblZnbTY4R1RiNUxrUGFBYTFqQ2dzOFpWVnVzMjhN?=
 =?utf-8?B?c2FvNVlRNWdyVEt2L2xSYXFPSStzTDNOM0FMZEFieFk1Q3pkK1Evc0d5Nnht?=
 =?utf-8?B?akdCWFVqWVlpN0UrUEppOXRISjE1TFBKam00OGtpQ0pWMHRnaTh6V3VWVmNE?=
 =?utf-8?B?SGw0UzhuTERobVkrdTFxTkhScmRsbjB1ZDBVd1c0VEJvY1VndFhuT2dOQlRQ?=
 =?utf-8?B?RGF2dW5wR2JIcEd5Q0l2b1VMM2FkRUJKWkxSUlZHSkVWUC9wT2lKWlkvMkRw?=
 =?utf-8?B?TVZVSmY3UGNROVRBdGR5eVROYTdHSWJlb2ZVd3VvbzRBakV6ZCsySW43ZjNT?=
 =?utf-8?B?SlYyUUp4M29vcVJuTm9ZbVNYY1JaZm1JT1ZNSTFJTWRoTk5idHZJNCt6TVQr?=
 =?utf-8?B?OXkzcXdocjZubldvcWZZVTNwV0JScDk4amU3cUkrbEhDYVpDSVpHYzNxVE9V?=
 =?utf-8?B?K0kzTkR6OWZxT05oTE1MT0h3R1RTRUhsZlRsZHJvLzVRRmgvTWIrNS9GSUgz?=
 =?utf-8?B?cDh4enpEUEFrdW5JQTVicWZOOU1VTjNtS3B4NzVUK1gzMDlxcEJVLzZCd2I3?=
 =?utf-8?Q?mr8U9vnlAtFaajr6Nkm/lHWkErLMwg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aE5NckV4LzIyTHVEdGs3UitTQ2hEOWpWRWQyQ3FUYUhPWHpKNUtzZWlZQ0Zt?=
 =?utf-8?B?eUlSeFZMT0NMc1lnbCtXK0lzL0VCS0lqTE9HdHBOTWI5WndXc1RkS3VwOVBO?=
 =?utf-8?B?MFVzZVhqWC8xV2JvdXVHUjFXajkrYTBGTXYzYmpobUc3ZWFVRHN6V0xSbmRt?=
 =?utf-8?B?ZFZ4NEJ0S3ozMWpDZE9YOURReDZuMENEdlpFOWVQaHlTVzQwSTRPMWxvcFZa?=
 =?utf-8?B?TjFFTU5HY0xGRjQxeVF2Rzk4UmdjWTB3RElyQzZTYndOSEJmN1diemlQclc5?=
 =?utf-8?B?TXp6TXBieFByRmNKQmpzaUFMM3Uxc284c1hVdHB3MmxiRGVGc21xNzdDMVJp?=
 =?utf-8?B?K2o5VjkyaFk0RVBTWnMzWkw0TnhSaDhHQkFqYXMreWhrN0YxTkFoRTRLekdC?=
 =?utf-8?B?M295RUUyTlpNOXNaRll4Tks3WGhNOW5heUI2c0dSY3RPaSs5L09MdTJXZ0t0?=
 =?utf-8?B?eXllVDhUaFNyMzkvVVdMWFBsaG10ZVdEUkdhK2kwb3lDNGVwMzlSUWlxL05N?=
 =?utf-8?B?UWE0WGVXMEJ4RmxxNDk0Tmx0TFhMQlRmU3ZYbXJqZFhTQVhMdHNENkNVaFdP?=
 =?utf-8?B?cUQ2cDVZNDJaNGFEOTduOCtnaHNXOUpyNDlvSTZQRFMvMnQwSTBYdWg5ZXBT?=
 =?utf-8?B?ZFZmamt5SCs1dkczdElRSWY1b09kT2dndTlLUCt3K0VOMktmM25WYlZ0empq?=
 =?utf-8?B?RnFZSHBrYzl6L3lPMmFmMTk2R3JqZyt0QmxJbVY3RnZkYXFtZlVLZkhoV0ls?=
 =?utf-8?B?TlpQbmx3SXRoVWN2RVZXR1FETjVqSmRrTmdjNW5xbExjaGg2cWxZS0I1RFR0?=
 =?utf-8?B?am1RL3NlY1ZyamtpL3lNRC9UMmwwNDgzaEpVcC9NVVdNMjZ4WVRQR0J4STFl?=
 =?utf-8?B?aVM0TE9sUkl1MlpjTVlBSFNJb1lnUlVXSjJPNFNhT3BmR3c4c0crVHdaWlRr?=
 =?utf-8?B?eG55bnprbE9WMndKT1RHTG1mQTlMQzNscnRwRWo1bDRGNi8zNDJSZjdVTmlV?=
 =?utf-8?B?Q2F2UU9QWi85MzMzOGw4a0pZNEJiMzk4bjRzdFA2R2lKRkpqZWV6TExtaUhT?=
 =?utf-8?B?aWhGSmlCNlI0UHMzWWpJNzYvVDNwUVV2UTJiK1I0VmZCSElZZ1pvNFdRTVc3?=
 =?utf-8?B?WmxmY0RoMEg4ZWdzWDJGbUI1UGNzbXEwT1h2cTNISE5LTEFFczFobGwvdVF1?=
 =?utf-8?B?elZ5KzJubldMT1J5TWJ0bzhDQktlNFd6MUxBekJlREwrQTIramwyRFNpNW83?=
 =?utf-8?B?RHpodmR0VlJ5THpCN2RVZXJSTHRQb09KbllkQlBQSmVvY3FVa3Vab2VBNEJ6?=
 =?utf-8?B?MGtBWlZYQmhEcTZGMDNsQTdWaUY5TUFRS09rUmkvMmZaYnZLK2dSaEgxWWV2?=
 =?utf-8?B?cEhydklzS2RxN211RldFdHZqUjRwVVhaNjFCdnlMWTF5S0RtNzNHbGlQWWdR?=
 =?utf-8?B?cUhtQUZYNHR3NTRCajBORDBsSCtkWURDenJqVXZPbUVSNWRRVENUakF5dVdK?=
 =?utf-8?B?TlJmVWJUOUJRdzlnQWhyY0hLNkFYSmFuYy9wNXBQR2UwK2I4VkdLTGVMYXVF?=
 =?utf-8?B?QVUwT3JBeGo1TzhmT2hGUGxDK2tvbFBnVDAwWmRvcDJtZDgyY3ZyWFpvcVJG?=
 =?utf-8?B?ZFQrYlZldXN2VDFYV0hsSmZWRWNFZUxVR2tOYXZtQjEwQzV6czl0Yi9QUXg5?=
 =?utf-8?B?d3Z3ejh1RjRXUWRZUkwvY2VnNGs2YWFSK01CTHB5RDdNNjRtSExEanBHVnRw?=
 =?utf-8?B?SklUd3ZPVXZWZEprMVpidFFzSnN4U05WdGRVVkJROGcrWlVJZnpvQ1FwZEZa?=
 =?utf-8?B?NVNLWlh0aStNdkZEVHN0MjRoOFJxeExXbnZFM2JkaDE4cUx4R0s5ZEdBN0Qw?=
 =?utf-8?B?NXJyODBybzdoNFhNeU1kenZKa3hjeDgxRFdLRm4zV3RDQTlaUnFFNC9WR0xI?=
 =?utf-8?B?eGswNWhNZk5QWEZVOUwrRlVTVkQ3UnRHUUY3SGllU0RTUjRRSW5rVTFMdFpK?=
 =?utf-8?B?OUN4bTRDTWs3TGsxMk9uQm55dTVtS295ZFFRYWx0OVQvMnF1N2V2SUxxZWw1?=
 =?utf-8?B?Ti8xTlU3bm1pb2JmUklmUWJObzFRTmZ3SUhTVkIvbzhOZmN5SENhNUJOWFR5?=
 =?utf-8?B?MGFjQWJDY09EMzJqNlprc2VyV0tBV1d6WGpwS1FtaUc1S3VGVXRpSkV6V1ND?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C26F2551BDD30347A575D558EA9592B2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tzOcg94IvO/85Ms6/4jFXcZsLbi8J9C40bncaB9/sZ2NxhrCSFPal5aia4dwAG9IQbigN28C2zFnY77XMObbu60yk31RwfGJmHFfLaNGPQkPatgRgHESRN88iLh4ha7wRbc9eFqxeGIbK6TXgc8LiCppRT5sj9eaa6AmjI41A7xDyEvUpA6rJDNB5FF2/cEb1nWa+JSNpR170JQzHGQXdJwRZcC0oaGYI3IgTarJenQxiShMjyEnsukvbZlQArLFHITcgz9bnS1l0PxGxmb3TXO34dcdlsS4IfxJ0+n/0wMyblGEk/scSZPVUVbr1+h/lQfYromsoV56CPsGFykl3h22m9wQxkBjsLLBd+nNXRnzOqWBmJ3m2hI5+ZHQUnCAABH6Q0nClgI70KO2bvS6KeDO4w29Iwduo1AOqsDXhyxU3fcU64ko/gkitRdwtiEDdxS4wM6wFtCSt89WvMgII/vKj2UuqurDy78TbGdPyB0lW3+vDlV8w7rkZq5EnmVwCb18ygYLb/tfMD9sWwXbotQ0Cq31pVmcAehy+iNMz576gbie9+QANz1aGflncyxElM+j5oRrwtLbMHoqmnqP8kZWZgA+/dumA8FpVMmDRX0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 775d3561-143c-4a9d-15c7-08dda350a453
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2025 10:14:50.5517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jyO9MAzdDsjDcSaDgMgYTgXwmLWk9eoq8lueTlH2UbeSMrVhOC9AyE4myQhoa0wtU7gNMJW223ceT+k6RhfG8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506040077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA3NyBTYWx0ZWRfX55iv9lBwJqZz u4HAJcW5BR4HprJtXket38rRGIjpkX49E8VlgOQtUZLC4o2E8RiFbsmx5NcIFJgAOyTGgiTsnZK ydVJyhNK2VgeBbnkdBlihWP1A3uadPjuIQ5vh3bLyqmVh5f9Zk3IxhGRA5252eG41kfPQ9xwGzg
 v5kuDRR7LXcGLcq62BqU1IQzGWgLEAJ+LmuYx9An/afwrHRxNhSug/m+T4AWOXyDdsdWmYReNsg bB63fA/Zezhwpn1sIEwlcvCghBku89ZcFfwAcesrVh3ieAVLEaa4nmDUjEpbu4m1bVl31GDDW3l Wk+FFlsB8OzBxxTqK+n6vEziSL+irV35DimpTe2Udz9xrpqVAeqmlnRLpTxp7MUz7LzASH5JNI8
 Z3iLf4dw/Va1Dvcj30pC2ZT+G07VO2nsFLTNzpJo0OGBQYj9J9u2Vcq5dbUFlFx6VcFpmMvJ
X-Proofpoint-GUID: ZAqvDlt3s1r0z_7fCKcMpTJNumJ2MpdM
X-Proofpoint-ORIG-GUID: ZAqvDlt3s1r0z_7fCKcMpTJNumJ2MpdM
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=68401c9d b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=m9SyGI3Rct9LSQmnvhUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714

SGkgTWFyYywNCg0KPiBPbiA0IEp1biAyMDI1LCBhdCAwNjo1MiwgTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIDAzIEp1biAyMDI1IDE5OjAxOjM0ICsw
MTAwLA0KPiBNaWd1ZWwgTHVpcyA8bWlndWVsLmx1aXNAb3JhY2xlLmNvbT4gd3JvdGU6DQo+PiAN
Cj4+IEhpIE1hcmMsDQo+PiANCj4+PiBPbiAzIEp1biAyMDI1LCBhdCAwNzowOCwgTWFyYyBaeW5n
aWVyIDxtYXpAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4gDQo+Pj4gQXNzaWduaW5nIGEgdmFsdWUg
dG8gYSBzeXN0ZW0gcmVnaXN0ZXIgZG9lc24ndCBkbyB3aGF0IGl0IGlzDQo+Pj4gc3VwcG9zZWQg
dG8gYmUgZG9pbmcgaWYgdGhhdCByZWdpc3RlciBpcyBvbmUgdGhhdCBoYXMgUkVTeCBiaXRzLg0K
Pj4+IA0KPj4+IFRoZSBtYWluIHByb2JsZW0gaXMgdGhhdCB3ZSB1c2UgX192Y3B1X3N5c19yZWco
KSwgd2hpY2ggY2FuIGJlIHVzZWQNCj4+PiBib3RoIGFzIGEgbHZhbHVlIGFuZCBydmFsdWUuIFdo
ZW4gdXNlZCBhcyBhIGx2YWx1ZSwgdGhlIGJpdCBtYXNraW5nDQo+Pj4gb2NjdXJzICpiZWZvcmUq
IHRoZSBuZXcgdmFsdWUgaXMgYXNzaWduZWQsIG1lYW5pbmcgdGhhdCB3ZSAoMSkgZG8NCj4+PiBw
b2ludGxlc3Mgd29yayBvbiB0aGUgb2xkIGN2YWx1ZSwgYW5kICgyKSBwb3RlbnRpYWxseSBhc3Np
Z24gYW4NCj4+PiBpbnZhbGlkIHZhbHVlIGFzIHdlIGZhaWwgdG8gYXBwbHkgdGhlIG1hc2tzIHRv
IGl0Lg0KPj4+IA0KPj4+IEZpeCB0aGlzIGJ5IHByb3ZpZGluZyBhIG5ldyBfX3ZjcHVfYXNzaWdu
X3N5c19yZWcoKSB0aGF0IGRvZXMNCj4+PiB3aGF0IGl0IHNheXMgb24gdGhlIHRpbiwgYW5kIHNh
bml0aXNlcyB0aGUgKm5ldyogdmFsdWUgaW5zdGVhZCBvZg0KPj4+IHRoZSBvbGQgb25lLiBUaGlz
IGNvbWVzIHdpdGggYSBzaWduaWZpY2FudCBhbW91bnQgb2YgY2h1cm4uDQo+Pj4gDQo+Pj4gU2ln
bmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCj4+PiAtLS0NCj4+PiBh
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggICAgICAgICAgfCAxMSArKysrKysNCj4+
PiBhcmNoL2FybTY0L2t2bS9hcmNoX3RpbWVyLmMgICAgICAgICAgICAgICAgfCAxNiArKysrLS0t
LQ0KPj4+IGFyY2gvYXJtNjQva3ZtL2h5cC9leGNlcHRpb24uYyAgICAgICAgICAgICB8ICA0ICst
DQo+Pj4gYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N3aXRjaC5oICAgIHwgIDQgKy0N
Cj4+PiBhcmNoL2FybTY0L2t2bS9oeXAvaW5jbHVkZS9oeXAvc3lzcmVnLXNyLmggfCAgNiArLS0N
Cj4+PiBhcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jICAgICAgICAgfCAgNCArLQ0K
Pj4+IGFyY2gvYXJtNjQva3ZtL2h5cC92aGUvc3dpdGNoLmMgICAgICAgICAgICB8ICA0ICstDQo+
Pj4gYXJjaC9hcm02NC9rdm0vaHlwL3ZoZS9zeXNyZWctc3IuYyAgICAgICAgIHwgNDQgKysrKysr
KysrKystLS0tLS0tLS0tLQ0KPj4+IGFyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMgICAgICAgICAg
ICAgICAgICB8IDE0ICsrKy0tLS0NCj4+PiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jICAgICAg
ICAgICAgICAgICAgfCAzOCArKysrKysrKysrLS0tLS0tLS0tDQo+Pj4gYXJjaC9hcm02NC9rdm0v
c3lzX3JlZ3MuaCAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4+PiBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjMtbmVzdGVkLmMgICAgICAgfCAxMCArKy0tLQ0KPj4+IDEyIGZpbGVzIGNoYW5n
ZWQsIDg2IGluc2VydGlvbnMoKyksIDczIGRlbGV0aW9ucygtKQ0KPj4+IA0KPj4+IGRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmgNCj4+PiBpbmRleCBkOTQxYWJjNmI1ZWVmLi4zYjg0YWQ5MTExNmI0
IDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4+
ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4+IEBAIC0xMTA3LDYg
KzExMDcsMTcgQEAgc3RhdGljIGlubGluZSB1NjQgKl9fX2N0eHRfc3lzX3JlZyhjb25zdCBzdHJ1
Y3Qga3ZtX2NwdV9jb250ZXh0ICpjdHh0LCBpbnQgcikNCj4+PiAjZGVmaW5lIGN0eHRfc3lzX3Jl
ZyhjLHIpICgqX19jdHh0X3N5c19yZWcoYyxyKSkNCj4+PiANCj4+PiB1NjQga3ZtX3ZjcHVfYXBw
bHlfcmVnX21hc2tzKGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqLCBlbnVtIHZjcHVfc3lzcmVnLCB1
NjQpOw0KPj4+ICsNCj4+PiArI2RlZmluZSBfX3ZjcHVfYXNzaWduX3N5c19yZWcodiwgciwgdmFs
KSBcDQo+Pj4gKyBkbyB7IFwNCj4+PiArIGNvbnN0IHN0cnVjdCBrdm1fY3B1X2NvbnRleHQgKmN0
eHQgPSAmKHYpLT5hcmNoLmN0eHQ7IFwNCj4+PiArIHU2NCBfX3YgPSAodmFsKTsgXA0KPj4+ICsg
aWYgKHZjcHVfaGFzX252KCh2KSkgJiYgKHIpID49IF9fU0FOSVRJU0VEX1JFR19TVEFSVF9fKSBc
DQo+PiANCj4+IFdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gbWFrZSBpdCBtb3JlIHN0cmljdCBieSB0
ZXN0aW5nIDwgTlJfU1lTX1JFR1MgdG9vPw0KPiANCj4gSXQgaXMgaW1wb3J0YW50IHRvIG5vdGlj
ZSB0aGF0IHlvdSBkb24ndCBwYXNzIHJhbmRvbSBpbnRlZ2VycyBoZXJlLg0KPiBZb3UgcGFzcyBz
b21ldGhpbmcgdGhhdCBpcyBvZiBhbiBlbnVtIHR5cGUsIGZvciB3aGljaCB0aGUgbWF4aW11bQ0K
PiB2YWx1ZSBpcyBOUl9TWVNfUkVHUy4gU28gYXMgbG9uZyBhcyB5b3UgcGFzcyBhIGxpdGVyYWwg
dmFsdWUsIHlvdSdyZQ0KPiAxMDAlIHNhZmUuIElmIHlvdSBwYXNzIGEgY29uc3RhbnQgdmFsdWUg
dGhhdCBnb2VzIG92ZXIgdGhlIGxpbWl0LCB5b3UNCj4gd2lsbCBoaXQgdGhlICpleGlzdGluZyog
QlVJTERfQlVHX09OKCkuDQo+IA0KDQpUaGF04oCZcyBjb3JyZWN0Lg0KDQo+IFlvdSBjb3VsZCBm
YWxsIGludG8gYSB0cmFwIGJ5IGl0ZXJhdGluZyBvdmVyIGEgYmFzZSB2YWx1ZSBhbmQgZ29pbmcN
Cj4gb3ZlciB0aGUgbGltaXQuIEJ1dCB5b3VyIGNoZWNrIHdpbGwgb25seSBjYXRjaCB5b3UgZ29p
bmcgb3ZlciB0aGUNCj4gYXJyYXksIGFuZCBub3QgdGhlIHN0YXRlIGNvcnJ1cHRpb24geW91IHdp
bGwgaGF2ZSBpbnRyb2R1Y2VkLg0KPiANCg0KVGhhdOKAmXMgYWxzbyBjb3JyZWN0Lg0KDQo+IEZp
bmFsbHksIHRoaXMgaXMgcGVyZm9ybWFuY2UgY3JpdGljYWwgY29kZSwgYW5kIEknZCByYXRoZXIg
bm90IGFkZA0KPiBleHRyYSBjaGVja3MgdGhhdCB3aWxsIG9ubHkgYmUgYSBidXJkZW4gYXQgcnVu
dGltZS4NCg0KVGhhdCdzIHVuZGVyc3RhbmRhYmxlIGFuZCBzbyBmYXIgYWNjZXB0YWJsZSBhcyB3
ZSdyZSB0cnVzdGluZyByZWcsIHJkLT5yZWcgYW5kIHItPnJlZw0KcHJvdmlkZXJzJyBjb2RlIHBh
dGhzLg0KDQo+IElmIHlvdSB3YW50IHRvDQo+IGNhdGNoIHRoZXNlIG92ZXJmbG93cywgdXNpbmcg
S0FTQU4rVUJTQU4gbWFrZXMgYSBsb3QgbW9yZSBzZW5zZS4NCj4gDQoNClRoYW5rcyBmb3IgeW91
ciBzdWdnZXN0aW9uLg0KDQpUaGFua3MNCk1pZ3VlbA0KDQo+IE0uDQo+IA0KPiAtLSANCj4gSmF6
eiBpc24ndCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4NCg0K
