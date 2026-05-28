Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26B5343893
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946228; cv=fail; b=Aeleb0wnRdq1Jm60e6rdmmtG6a3J232bSBjr97EgWFNc3DLrXli9iTyPq0+DGHTF1g5GrLzg9eYXs4x7/AAPLYPnaTBwMNKvmrGgGP1hKRw83kp+hbSAmm2kohRZeElijUnH1ih2F7Zq9SxC2deyccsYtJGVhwDG+E/+wldBV3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946228; c=relaxed/simple;
	bh=wkUqkW8LFpCndy57ECU8uTLbEQiQHlSToCLjprDREZ8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sl71DlkxVLaCaZyyrZzT2gr5mm9B0DxSYjAvdir879ZoI+X8BWCJf06nvG8RC/AIMvEHjJNG4WEYCfW+X1zFO6DqB6PwewzCbUSx+OURalghswDjrLWcIqhYK0YyFFT4jjOSYVQfPZU2P0Thgbqiksu46yya5WlFkKKvJiBiYJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ics/Q4ox; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MBVSiQ9/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ics/Q4ox";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MBVSiQ9/"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S3Gpb0291804;
	Wed, 27 May 2026 22:29:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=wkUqkW8LFpCndy57ECU8uTLbEQiQHlSToCLjprDRE
	Z8=; b=Ics/Q4oxDwop3/C02pOPHcA3wtng6tnKwrayTav8dGCKSbbZX/8m5yglw
	rNIfoln7IOCSpEp5lPA8YEKyTBR/1/HGaMYzSvhH56g8XVx7HDNEOPh9R78fCkRA
	tRNFvbSMXwGHic/Uqxptw6gm8hfJTJYGC1zhiXHhK9tD8DMpnX5TGGLLRwJMblSq
	LR4mzVDnNxmwvdJ7d9SxEyEF+lRnSiOFLtiCtn58RECMJVG4MCrjc6sueyXm7yKl
	68RUz45U2nqEjJvf6SH3xUsV3sEV6mN/1ruxdrPUJb1HL0jE9LILrtsuyDFAcEQ/
	KBEaHQbZOOSlEz0rVKTu8ukFtIizg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021073.outbound.protection.outlook.com [40.93.194.73])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ee7wgrvy2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 22:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIwA2dt6CmhUbE9DKyo2VgnOEdfx7F+gFMeIAsLXSPJT4ozhfA9NIVYiiEUB7DJGjkmquZbMdIminfFj+rZUqJye8GW4JLYBnOpw7mrJk8Hn1USw189P3SJZTidNkD9Sya2VuUMXENNGAapvwFt2xHB99jYYpFcpsvvi5DKbmIaIfZU3iHHPakz18GNmK+LmYpuJ6GSD4GrF0XE4WSv7bpiR49BT78uYYvUSzwkLHDkUH7iZvu9tOxObzHYKsOiUPg93EWp5+JNvGpm0QS28r0cI2E/6sJXsfYVmitBUKPVLF2S0DaAFX6y4vJpKsN8kf3cpnQP3alBmeRdLF6JK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkUqkW8LFpCndy57ECU8uTLbEQiQHlSToCLjprDREZ8=;
 b=JGjs/EgDhp/2hlnhyn7GQyEDuJOE+OD+fDfeqjP1mcEj1JNAsjJd/kZwcC9sSLH5YHM3FOKr82BNB0KzdzqyZPBICyTH1genvUqOVLaNmYyhvtgpyKpznoCzNgFtjKHFSFD6CXz7u+M8AxENrSnGPm758yTgKeLM9OvFsuzMwacgIw0FZ7zVIY3hipo370ndKdMmpn3Mqax+1R6XarN3HMb7btK/2M4fxwIvdwR7OibBAVSz1WIYMm8ZDRbI+iyP7j7VTRLngopTk2/b1WQ9oS0u8NybE2Tqox88TTikGvAPiv+sT4mxTZ/HLgm6NAmrPqnnZlabohSe3ik3gDazGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkUqkW8LFpCndy57ECU8uTLbEQiQHlSToCLjprDREZ8=;
 b=MBVSiQ9/kkD5m6Uw3bdU3rhGMQB4xDvNoKx0azyk0E+c0LHdAamoyTIyqoCcUl2mLX85yVI4LwxkIacC1akYhc37iW0PzqVML9siWrBNErvva2z3ARnBbcPe2aaaowf5eTiDsIU7NXDHFMk9xAIp00DanRnCy4hCF4QDhVgJX9De8JKsNUZS/HcU1I9ubkrgG5e5Ja3LAe8MVMJgc+NN78oQrj4VmGMYWZJj+tnuJWYqaIPTZ8Cqjt8nKjvnJkuI3/Gm1po3njCh9Bv5+KQrcdUJyHPOqjqdW6sxSp3hWuJcqzQgt2kTpn5X8AFvx99dg80WCuxHLLICQbGuiwkpPA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DSVPR02MB11616.namprd02.prod.outlook.com (2603:10b6:8:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 05:29:55 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 05:29:55 +0000
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
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Topic: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Index:
 AQHc55PDWfKVatqEQkCeq1pFPAd4RbYiCFaAgAAJ0gCAAAFOAIAAAoMAgAAB14CAABM5gIAAy8oA
Date: Thu, 28 May 2026 05:29:54 +0000
Message-ID: <7737B413-51C1-49FA-AC0C-31DCEE1FD45E@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
 <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
 <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
 <8ee2b611-ef48-4805-aaf0-087856dc30f0@redhat.com>
In-Reply-To: <8ee2b611-ef48-4805-aaf0-087856dc30f0@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DSVPR02MB11616:EE_
x-ms-office365-filtering-correlation-id: 081e2d56-1551-42e2-dc14-08debc7a266d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|38070700021|56012099006|4143699003;
x-microsoft-antispam-message-info:
 sNGWZERWKZ30laR34qVoGemTqxtks8veamxI2XQ8tptYvHPm5NXMbmUTsg4ElFX5O1C3KterCjUqkjlsBZVkQ0gdkNK7sXFOmZsldbLu+LZV09zU9TCd6SJJ0/KPvjQ17nC1AFcy4larqiKwoGMwMlBUwWc3nfN9ml0FW9in+Sl3BYCuOKKUOR59NIaBgnw/OqAYxau2GleV1MaT6GEZ3eUWyQd4FwBYINtrh+mdsnuLhKwLPRx9Zsn7zamttzNMkAEmW7p9iGOWAxYM9jkaUWfG+wyylnxdoOYc5snpWr6N/IuHKEzC1XySawiZ9QkFL6GJ7nWIVt3E3pKiFZ3jlgBwNS09kStoe4QFl9ey2JmcM9MDv1BtjEOpn6LofXjjp5SaeLPUGAVWddX6M6QmR+cGsyh6Aj93bBEUpkXNKeBTvIgh76j+/RTlNLCvEp2fvehld5ReE6bOHDGWCE6tY1F503BqerWp5GHm3gVIUhWOjXpkSYN6FRDSUt5QkIzxXGA07cwMPXWYP02IXFodXGEdlVUAFdUjHhB+C8O1+d3njtpWJVjgN+Eyj3DepiDX3J5MUbp58MMkcekF3zZuMtZiaSk5sHVOpFdIlhn7BuLnqTkd8iNeTzdMUlKGLJOFqM2AyJRZJDFJSNsDMzdibEivxAXYSe0vFnrZoraLZvjkvx50U2KNL/n82OhM3B5QL+DuB6h8sCYZYBPyR6/hb8rmlXjjl7ScUCX5pNvgzfsYr9Ynyi7QAgEstISaiUpF
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(38070700021)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NjhCTm1XWGgzRjdZNlRNSy9uVkR5cHFLUGg0WldMeUZyaWhhZ3ZFR0hNcDVh?=
 =?utf-8?B?b0Z6cFNXcnc4R0NDd2pVbkVXNnZMM0k1U2FKYVlTaVVjUWxZZXRCb3YyWlpP?=
 =?utf-8?B?RkIxek5RM2ZyTDliZm1XUy9oaThGanZSY1pxeDlTblU3NzMxa1ZzTnhQeHB2?=
 =?utf-8?B?dzNNNEs5aEROR3I1ckdLMGRxSmQwT0ZVQkQzdVg1NFZLVGlLb28yOW4xSGcv?=
 =?utf-8?B?NlhJNGp2RkJUMUxaUzlYWUQzZmMyMUNQcHRpMnV2c3RzOXJmdERqMmF3clRi?=
 =?utf-8?B?cmVhVk8wbHFiYStNSHkzakkrdXB4cGIxRWdqUWJ5b05XQzZod1F3WUhsMWcr?=
 =?utf-8?B?dVZ5MVhucGNmdENJeE15b3UvNTZUZjN2dVdhV0NBVU5EZkQ1V0RDbDY0dE8y?=
 =?utf-8?B?clN3dG5WdTMyWFY0ZExrWlc3Rlk5Z1lEdHhZMEJsZzJlajFiRHBwUnNaYkhr?=
 =?utf-8?B?cGRpQ3Y4T2N2cG5sL2h4SGhoZUFnTnlPQkt1YU5ldUhvYUV4OVFkNVYvb1JP?=
 =?utf-8?B?c1FmSWVEWENTY2hQWlRlTkpZMzNPbTEwS0ZJK0FWeEg5SkdYK3pma0t5c0dL?=
 =?utf-8?B?ZmFnNTBheGQ5WkpJaGYrajFWcTFURDd1MHFqT0RnTmZLTkt3VkVWcUV1Z0Zp?=
 =?utf-8?B?dXE3aGZiTS9MdW5tTTBTRGJIS1pIYmJvY0RBYk4wcVJ6elYrOUVNL1R0RUY2?=
 =?utf-8?B?QmxCSGdhZTA4bzE1MEtpbjVqblg1T3Btd3hPZWJzL3dQdVgwQzNsWWtrZS9F?=
 =?utf-8?B?UmdqYW1xOG1uSkdnV3VYYmIxa0JGdUR1OGZXdzVFdzRkeVRCenNSTGNUN3VT?=
 =?utf-8?B?YjE3U2pVZENhb3ZqRXlrRGYvUFAxeVdkTUJvbU5FNXRWOExlWjlnbncrM2oz?=
 =?utf-8?B?ZmtEcEhkckNJWDUycnlMbzIwaVVXaWd6WGRyZWFyNkZXdFRCdy9iZmFGbVVo?=
 =?utf-8?B?VEQ4anVjYUVuNGwvSzlza09iNlcwTFRsVFoxNU1idkoyY3FIUVF6bER6Q2RZ?=
 =?utf-8?B?ZzQzaTBRUDIwUGM2b0FVaURJMk5jTDlHS1g5YTBudjgwYzl4NE4zUjd0Nm9F?=
 =?utf-8?B?QTc4NkNZa3ExOTJqdVhkdElLR2JjQTRMa280U2tXemJRaDdsTmJsdVdhUlpJ?=
 =?utf-8?B?S3FyT001M0dDVGt1QzJRTEpjRi83UDd2MjJsNTJRU3k5QVlKTUpGYjhFbVNu?=
 =?utf-8?B?b2R4NndPeWwrRUh3M3pVOGxiRmVwUFNmZU5Jc1JsVjhpVE1ZUk5KeEo5bitx?=
 =?utf-8?B?TjFmNXIxNktDRUZja3FTQ1J5QkZpeXRZczBqUFBLRWEyS05LU09QcEhIa2xI?=
 =?utf-8?B?MkxTWkVtVmY4eG9jVkZML2ZKSEpVcU5Ib09ibWV4QnlzRTgvT0pibmpibG0v?=
 =?utf-8?B?ZndCbUFlb0RLRmRVWTZ6QVlaVXVlVGc4UzM3U1JsaWdnWkFMOVArMXFHMmJz?=
 =?utf-8?B?MW9XQWp3U2RoYjRtVHlaYTVOc1RwNjVCT0Jpb2xHdGxHQ2dlS1BBK1FBQWFa?=
 =?utf-8?B?M1cwajRIM29sQnhOLzJBY2NPT241UnNyQVhQQzFzOGJzUEJTaFUrQlF6SGs5?=
 =?utf-8?B?Sm1UUFBBUktFeENtMzNkN2sxa2RiaDFxOElwK0ZJNnBqb21NbXB6UVJYL0J3?=
 =?utf-8?B?WGZIdEpLTXZNS3FYQnlSRUtDcG4xR0NkTXl3NGJLK2xEUzcrc09PSjQrY1M0?=
 =?utf-8?B?eWF0dkl4NGg5UmN3M0h5UnM5MjdMaUFiYVc0eGVnekxabVRWMGRlaHVGaDBz?=
 =?utf-8?B?OEhZdGViNnc4MzRxYzlpNGZIMnZvMzlTdnpWOVZ6T1RBNWZIUkdrOVBPelh3?=
 =?utf-8?B?UjBFbTNaeUFqUWphTG02VGxNVFg4QU01ZkFZem40M2JJam1OWjRkdDZ3Yld2?=
 =?utf-8?B?Q2Z0WnYwNzQxRm9ubUtBb0dRV1FnK1BFa0VVK05QVVEwSHlDNithdld4SkVX?=
 =?utf-8?B?cy9VRE1ibTdxRVR6NjE5MzFzU1RBcXJBbC9YVyszNkJyeE1IVjNqNEt1K0lr?=
 =?utf-8?B?cVA3Uldzdk9MS1JsR01UUm4yS2xCODgrUStobEZhMVk2ZzNraGNETUEwdUFH?=
 =?utf-8?B?NldlWnc1Zjk4WENKZTR1cjRDTHNGM3VsTzNIL2Z3ODc3YmxuOG5oMjJTdytv?=
 =?utf-8?B?MnVwa2pRWVhpUnY5RGoyLzVtYThranErRHJHcW9NdFR1UGlOTEhQUGZMRUto?=
 =?utf-8?B?bDgvVHZMTmdXNkxLWEFDY041djVUZ0hsU1JTMXRwcXp3N3B1blJaZnNubHVx?=
 =?utf-8?B?TlkxTVIzUkRvTlc4VGM0TSszcCt4RVpwZUdzVnd3VVMxRisyMG5FSlBRcGQ2?=
 =?utf-8?B?b2RpTUF5VjA2aWZ5ZmpkQkN3bWdyVDBqK3A4WVMvVkRDdEVUZENRMFllZktR?=
 =?utf-8?Q?bFmkuGCrsfzLiN0Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E570AFFC9CFE54AB3B9108B4CC2878B@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	VxKlolgKDZjk6ysrAp/C8vol0Qkuho9r0uyKr0KaSlg5tAFiC0V3WDYWNr2zRyKE2xCTbB6r0MJnDNMCZOZELBzLrKB2bkWwoTyq8mq2FdJnk8jLLAoWo89tIPgeHXuP/w2wgj9ih5aFxohHu8hQmJ5bN3MDoT9afGAEptTHtEsao8SkJKeaLjanaUyeW1FjMftbJpwpdVntgijuHRHYt/ao4stKxZ0KCse9stuyiaOtxNoYkrFKwCaEWvfJ1vm6jPkTDgmDUet7+TOK215jLsgAKP7f0x41Xx5cdzoKgakQAgLLTwq304611UXDpOgLhjy7sCQDJC/K6Qn+oWTzSA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081e2d56-1551-42e2-dc14-08debc7a266d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2026 05:29:54.9933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sLvR4QnidHMDj3np6yzojYXgG8zHEZZosEDqp1yDegTDEQ9HC6i2LLoiE09GbVt4f8o32+bc7lupSzwUqBYcXTfdZMuPmj1BOVnaOU62+us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR02MB11616
X-Authority-Analysis: v=2.4 cv=AIAs8BhH c=1 sm=1 tr=0 ts=6a17d2d6 cx=c_pps
 a=tL1cjTdHg3x6ttwi1NwRWw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=2dcoCDx5fZwvF-Nd_tMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mahY2Z8lA29OxayhpSRmuSphbyltWHzQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA1MCBTYWx0ZWRfX3tqvwSBQ9SN7
 /J7e4RQt5f5E8yzBxh2d98VAi82X+8zAe/ZS63UiZvxeJsUWEtEJBf8i06nmuPz0yNdCg/BpmCB
 zTJQImaW3hrD9mhcd2zHevbO5BG1c8cq3vxT1kxlofnhd7KsQ9fglBV1b3M5Wj/37wWeYOPKD8i
 ICQcNIjhymsirWYNJKLHKcL9OzMJrtfRdqTWq0r3w1vHGQaD1CFyaRUQyzmOV+TzLMiScy+4TZW
 LBcxEY/hHO1cmXmJD4MZ/Xj0D7PIFjbow+LKTyQWeJ541EeGXsNl8+ktqAm1Vfb6QREzpWoKYtx
 rwf2NlX7xLz1ocJc1WE4i64YO3l4ki74o1zCblp7XL1RkOE5je//zv6BIEHlDVPvaMl1QvLCkV7
 gSsQlS6TVpViSm8OfeCwLtJGOZ6br4h63JzBwm7xnMlY2dC045VtJstz2/29NpDToLY5eo1VPZ+
 xySVS5cRIJrcCWUMFcA==
X-Proofpoint-ORIG-GUID: mahY2Z8lA29OxayhpSRmuSphbyltWHzQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjcgTWF5IDIwMjYsIGF0IDEwOjUw4oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBNeSByZWFzb25pbmcgd2FzOg0KPiANCj4gYXJt
X2NwdV9wb3N0X2luaXQNCj4gLS0tPiBrdm1fYXJtX2FkZF92Y3B1X3Byb3BlcnRpZXMNCj4gICAg
IC0tLT4gc2V0X3N5c3JlZ19wcm9wIHNldCB0aGUgbmV3IHZhbHVlIGluIGNwdS0+aXNhci5pZHJl
Z3MNCj4gYXJtX2NwdV9maW5hbGl6ZV9mZWF0dXJlcw0KPiAtLS0+IGFybV9jcHVfc3ZlX2ZpbmFs
aXplDQo+IC0tLT4gYXJtX2NwdV9zbWVfZmluYWxpemUNCj4gLS0tPiBhcm1fY3B1X3BhdXRoX2Zp
bmFsaXplDQo+IC4uLy4uDQo+IHRob3NlIGZvbmN0aW9ucyBkbyBzb21lIHN1YnNlcXVlbnQgaXNh
ciBhY2Nlc3Nlcw0KPiANCj4gU28gSSB0aGluayBpbiBnZW5lcmFsIGlkIHJlZyBmaWVsZCBzZXR0
aW5ncyBhcmUgYXBwbGllZCBiZWZvcmUgY29tcG9zaXRlDQo+IGxlZ2FjeSBvcHRpb25zDQo+IA0K
PiBUaGFua3MNCj4gDQo+IEVyaWMNCg0KDQoNCk5vcGUsIGt2bV9hcm1fYWRkX3ZjcHVfcHJvcGVy
dGllcywganVzdCBhZGRzIEtWTSBzcGVjaWZpYyBwcm9wZXJ0aWVzLg0KDQpSaWdodCBub3csIHNl
dF9zeXNyZWdfcHJvcCBhcmUgY2FsbGVkIGFsb25nIHdpdGggbGVnYWN5IHByb3BzIGR1cmluZw0K
DQpUaGUgY2FsbCBzdGFjayBpczoNCm1hY2h2aXJ0X2luaXQNCi0tLS0+IHNldCBjcHUgc3BlY2lm
aWMgbWFjaGluZV9wcm9wcyAoaGFzLWVsMiwgaGFzLWVsMywgbXAtYWZmaW5pdHkpDQotLS0tPiBk
ZXZfcmVhbGl6ZShjcHUpDQogIC0tLS0+IHNldCBjbWQgY3B1IHByb3BzIChwcm9wIHNldCBpbiBv
cmRlciB0aGV5IGFwcGVhciBpbiBjbWRsaW5lKQ0KDQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQ=
