Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C008335BBB
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772031; cv=fail; b=IItDx6DEEhowltxnuB6TOBui1jHSPcFiFEw5y2sOKm9fiL5O/fZkldNy/FKoAjqVV06GeQBha7PytUpb+i4MSNtKLuSRHF80/MYA8usqjyEEGgLnhG7K2qsptPiXzHbB/vIksuUPuVQlPkj2Eq5NwrCDbiolFZ5gG9rtAlj/by4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772031; c=relaxed/simple;
	bh=iO+5b3PssF0onf3+EMC4E2LWrVAARRfyKsr2IuMbxUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ULEVBmDFfGqpuectWKxMoXXBrQCeHem2GR2WJwvLI6ldtdMePwVonreykMGdF1/7F5ohzeuJpE5/huJpz8gJRWIkhT5kqQuGOSZq3x4vMbQ3LUe4pzuuMSkhow17JOX4ooVxUfRc+vNapj66qtI7QTw/GGkab7yiocarNKvzPy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2iGxTRmc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RZZc7Wqm; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2iGxTRmc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RZZc7Wqm"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EEjT81749687;
	Mon, 3 Aug 2026 08:46:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=iO+5b3PssF0onf3+EMC4E2LWrVAARRfyKsr2IuMbx
	UY=; b=2iGxTRmc/ingJx2Guplf/13sckwtN3lNqsLHWoZcyQngkHnSobYd+Mwi7
	FWDUybB2bNakTWHXnv2iZn52G1fPDqtDJ6x48YFcumpppzrAAfGDsNM1H5ShbyZd
	CfZ552659qAdLlcZHiOtwGL+jqA8oSHxXRfbKn2x+5Uy83vZ8i9v93gdnT+rvHgg
	RwQEvyQRs3e4pFG8TMScE8FZQ7HRe6qn9tgFvF5cspIxBb2QZ6oU3amgompY3Ewu
	gXr8NekP3zzVITk5KHiISMSAdA91YUhupWH1luI59LJBDcM8Y827uoOuA9fpF5/e
	kEuvQ7ca+LYqeblEgoM7aBFMSR7Gg==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020122.outbound.protection.outlook.com [40.93.198.122])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fseb6bxfp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 08:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7kLEr9yOjudVCw56ws07tDoVZgMxqaTQGmsun6TDEwDuAOopSpxpoCnPzjDSL1Gl3iM+ec/SYObbXUeamu9dI1A6SBmDm6DDQenfGYyHfDy42/Ptz/Vk035SbKjLx4uURaDV0qHaZuSKW1EO5sOI6TOZ/eNLD4+5b9hkT7tuMkiMUMiG5jntzk02vhi7aGhNqXgZOXCyEMNTMalDDHFKLk3SCVGIFBmh1vY89i5yo6lEd8R7GbBeaN1KxDkXoEYQqvqSFmkN9MaS0BpnffLvmF23+nT0XK65ccHL+qEBssEhTpUkTYb/51wwg/v5vW8+WX0b5azb0R9SCflhq72YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO+5b3PssF0onf3+EMC4E2LWrVAARRfyKsr2IuMbxUY=;
 b=oBxdgXll5B3S0emKIhOFBUJJ4ut5GA7QOmYC7gJZ0x00apfukx+67xUdwu1O9/ULP4OCGk4B8MzjM0tvp4DTz5bhpgSmqDW9hw55UE+V5nL+Zu2/OeLE0oYYvoC+aDwna/sfhbslQbz7ALOVrPPliX2pRJy4fRcfoSO+LETGns0CiC+qZBdCiSvNLAr5lJzCcOPOqRPiToMgqaBWwHRRd8rs9IWX8UkE/HqegM3OsILOFdWBdCirp9/deO2gNTbBmdA6zh8fgmBf3wnz3bxmeVs8uLGuLqb3jerPRBDtbV3KgNqfelrp9ONLOYGtLzZY8gyEvBawGBsPGSnzhGFbDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iO+5b3PssF0onf3+EMC4E2LWrVAARRfyKsr2IuMbxUY=;
 b=RZZc7Wqm6b+D5gfWB7PhFPx+ljohgLQBhcTQ5ngytEZhzKq46vr5/yRQyIabaVuXCClZjIrz8m1BarVbu3Pqm05uwaSj/Ub2/T0ts8tajKkh/27fFfusye1U2yBK0gsjhw1N3r8HeC6ell/cjypo/oHQA+NH4mAK2dbLv+Kus+YHKlUH2D2p5x8+dYVumLG8W9Fh/pHWu8SmtGGQ4JwewNH8D0y9C9QZ9sLmeN5FYPXXOppyXOnLcCqXNICI8hjXLl1s5UpT/2jSQ/iZXpSKJ31ydmyNBkp14V9aa6Q8P2IIPWr87C0NcfGE59TH3mTVYnAcsM/m53Z4iwTI4ZShdA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6867.namprd02.prod.outlook.com (2603:10b6:a03:21c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 15:46:49 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 15:46:49 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 05/19] target/arm/kvm: enable writable
 implementation ID registers
Thread-Topic: [RFC PATCH v3 05/19] target/arm/kvm: enable writable
 implementation ID registers
Thread-Index: AQHdFWuVvcyFc0GeiU+X80FqMMvIjLZ4GUqAgBR6aoA=
Date: Mon, 3 Aug 2026 15:46:49 +0000
Message-ID: <C0AD0BF0-DBAF-4911-9C4E-EB46382AB997@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-6-khushit.shah@nutanix.com>
 <da8487e6-2253-43ef-967e-b4d3daf3808b@redhat.com>
In-Reply-To: <da8487e6-2253-43ef-967e-b4d3daf3808b@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6867:EE_
x-ms-office365-filtering-correlation-id: 2755a1e7-0eee-487e-0bda-08def1766e88
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|4143699003|56012099006|4133799003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 csrtd73YPIxP5l45znpfsPJM3xZejOCzlCeyLjripd3ObA/SF/p+9xc7sZM8dbKH1Mr7ghMlULJEIJX7MlF/p7g1eAV9/QjRJF46eBw/OFN2lXqoUWEVkfonMn6zU2FwwWQM6VQo+Do7BnV/fxOj9I7r2hn/+XN/pMi7yhBj77p3tfmx53iUrAdqHyOHcbWvfgI/9PM2zFvocw2c6wQb76DtwP0O56I5viMwYlgmmoaEwXjH4+yjB4LSUCiFx4BA4eHa2fanJN1zNpamFzQA8ujXawaRXwjDE8ywuuUdiQkhw0DxlqAoLES6p3Ito9YyYtVLhdnTf3I2IknMyW3F4dKISh59X8ydu7kF672LYCIcrBJ5Ue70gB/c/gFrfc9O91Kafr3YJbvIRgYoDxKNV8UFFvgNcn7UM9Bi5zqiuH7rYzouhlJOcmp+2BzWL8mihsrKwT8MtGKuvrtFTtFs3m/UWb8xpkWkmaQJpRXhAe2CkPCjYXqetQ8c5k91eF2pITRmx4t4Ltm/7j0fkJ9lsj1BXBuJezsJdpMe8XBHVmdbahOgX9NN+C4aF+h5kvn6icKsKSwSZznhkshzk3E7HAIGO+2wmLYtnonc2sXn1QQVOek5iXppS/BHAZ3d71/L8hLxbxb/rS1WpHrsK3dRcw8+8WnuWrAj26k/uS2IpuhLpGGqpKluWh3yNEd0GRANstA2orx3tImwhjXBaMn56vqwYAfLxC0Nvycfa9J1qrw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(4133799003)(38070700021)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ai9RM1BzQWg4YUVmMnJRN3dlbjJzOUt1UlorWlBIOHNPZ3NtSndrQjN2OWNS?=
 =?utf-8?B?TlRrRWExWWVJUWVYbEcwWk1SWGQ0d3VXRDVuelhFamhuMDc5OWpjUVh6YnRW?=
 =?utf-8?B?OVhMODdLR01Ka201dk5QZlVYZkcvNkt5N1VSdkE2Q0RBY2tleEExa0ZUbEE3?=
 =?utf-8?B?UU9lWlNpOWEvMUJ6b2wwbnFvZ1VWUVkvY2JseU5ReWNYcnY5VFVxc3p3YzBx?=
 =?utf-8?B?eExyMU9icnorZStaL2tjRXVrUUJXM05wb2dBSk8wVFpDREJ6Q0hDVGZHbUFG?=
 =?utf-8?B?Q1pGdjVqZHRDREZKY1dydzNhMnJBanYzaDZneW15QS9HMStabzhLOC9uR21R?=
 =?utf-8?B?TTYwdmE2WkNJYUtSS0VkSE5TVXR1Mll2TjBpOGl5WXRrcUl2bVdDVzRGMmhI?=
 =?utf-8?B?TitHTjlKUFdSVzF1eEM2RzRPcFZWOXEySkw3d0lpdzRURGlqUTRlWWphTC9Y?=
 =?utf-8?B?cEdkNkdFMDBFSHRnVWxQb09hZ0VEUG10aUd4M1IyVXplRFlQSDdOSjhZNzQ5?=
 =?utf-8?B?enRWMGlneHRCS3ZZU2VkUmE2MWpoNHVyK1VBWGpyMVFVU05keW4zaDFBRmhl?=
 =?utf-8?B?b0hwd1N3dm5VcUlvQUx1RW9lblNFaGhDTzdkQkM3WHhPR1VLb3RCaUVxQyti?=
 =?utf-8?B?c1Rqc0tXNDFxaDJWeHJNSGtYN0ErcmJqOTRaZE9IdHBQMm1YM0NIT0tZUTVN?=
 =?utf-8?B?WDBWSnZ3RFFPd0dOdlNucWxqcWV0L2dRcEl6Y2FtYTZ1NlV4eGZsZ21KTjJp?=
 =?utf-8?B?dFNXU2ZIQk85cS83VXdJSFQ2V3VOaGx5d0YraktTN3hmWmw5T3J4MXN1NlBD?=
 =?utf-8?B?L09mMktTeGVKeFBRdy9vMDB6emF5aTFRSkozUkpuSmoxUXQ0d2hDcDZYaGV1?=
 =?utf-8?B?c20zYk9iMkQ1Uy84Q2YvTEFUNnBoRHY3M3hJTnRCVzhmaVJmcVI5WHZ1WVdl?=
 =?utf-8?B?QUJQaFYyUnUyU29OUVk0SHR1SHJhNzNnM21kYklEZm9mTHM2dTZaQnVJSGZ5?=
 =?utf-8?B?VllBSkM5Um41TDR6TWVEUTVkSVg1L0lxRmp1QTBySFNTU3UzakE2U3Y1R3Iv?=
 =?utf-8?B?MkhBbXFPRUFaTmgzS0w1Rnl0TW9aYXV2TTE1dXhPN0R1cGJTTzFBaCtIRGRv?=
 =?utf-8?B?dmVPMWlsSnQzS0swZm9wNUtQS1QzbmVFUUM1WFdzVXAwcUM5V0h2LzVkQlc2?=
 =?utf-8?B?aGhxOHRnOEpIZHFmaEYrakpyQkRsMi82c05CY09lSjBXRExUQURWR21SRTNv?=
 =?utf-8?B?UHJEMlZqb0gxK0xXWUFBMGllUmZUUWZLWFR2ZFJCdFZlVm9Rb3pmenI2M3Zs?=
 =?utf-8?B?SkZkM3I2NWI4VWIrUElIcGpjSmFHZDU1dE91S2lGdVExbWZXTlBNTTQxNE9K?=
 =?utf-8?B?UzhEZVdySTJMb0xCMmNFa3JqVVFCanhuU2p1V0JhVTdjOEJEbFkrR0dLRkZL?=
 =?utf-8?B?aVU5VmJOcHh1RzR0OWRUZC9jaTc1MHNnZW1MdS9ObHFmNWkrTUZSQ0NyV0Rh?=
 =?utf-8?B?eXBOQy93d2lVeDNuUnpwc1A0eHhnOTlnSnRWUzNFdTNFRWxwNHpuTSthOUty?=
 =?utf-8?B?enp2Qk9BdmxoZ3ZZOGVCeXoyV1pKQ0h2ZGF6Z2luOGNGWSttYzlTQk1iK3dt?=
 =?utf-8?B?L2xHSzhEVFRxRURBZjV4a0FROEo4V09POVFtd3JSSVhsaENVd00rTk5GUDdN?=
 =?utf-8?B?czRLRnpyWXNQOXZ0NGtrT1JhVE5lMmlvdTF1dVhYb2ZUOXJ2WlVEZGVlYks5?=
 =?utf-8?B?Y2taQWc3OVRCaW5CMFo5ZVlWUi9pNC9LYURXV2V2eTlpdXFzTytRcXRCQXNI?=
 =?utf-8?B?U3lZUVFuamdWd1pTZituYjMvRVFqNFljYjJHNUxRZFptdVlqZm5YWkVyRUVw?=
 =?utf-8?B?MW9qc2QybVQ4VnAzVm1vdmxFbVVQemIzNS9raU1XTkZDRlQ1S3FIUkxZTldu?=
 =?utf-8?B?L3B5ZmR3bHhhSEYrRjhrcFI4ZkRZOTZMc2l1b1VSV3E5UEhjYzJOc0lhSm9h?=
 =?utf-8?B?NEd5UCtQeHlnTTlYQWJuZTBwUHFIRVpjdWppdkR4cTZNaDlBM05oQkpXOWJh?=
 =?utf-8?B?eGFyczBDVkd2SVRySUErRTRnZ05tSzNKTXBXQXBqVlY0VzR4KytuaVViZTNV?=
 =?utf-8?B?YkFNcDZyOFhoT3BzOUFoVk1yMk1SSlhIcVQ5Z09yMEIwNTJmNzBhK3dJYW43?=
 =?utf-8?B?SitOckdSN2I0NTU2UER5ODduS0RsaHpSdmVObzh2YTRxQmxFSnRuV2dTZ2Z6?=
 =?utf-8?B?ZXZzQU1Wa1RTSjNNTFhXQWxHbTUyRG5Hb0RSVnBJU29yaE84ZnZaY2VEb1Ja?=
 =?utf-8?B?YjJoSVZrdmdENEJLQWM3SVk2aDA3NmlUM0RBK1phWUhuWTYvc25KdnJFTm12?=
 =?utf-8?Q?JXJHbqO6p8cb6tnQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03C4B4FD813A5E4587674AD045CAE93D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	btlOSbCa34dW30t5lmAi9mdtmCZjMfD7XJbsJejZ8sX6QTSH0oqYIwPj+QVuKui0+1UPglj4A1IO2CUAsfLoelK2aeB+Ys1mTBJInPXKv5N3yL4uuRCHOMd++vOG4poEwAUtCJx0CqO66p1Tgy47oDEWFBVUgQNxDECZ/cna8fX17DsjmIWp2w94iA6D9sXfbPDsrY4ptHf8l6uxXB3YqszSdsZQTy6yKsYMAKabpSx8+OrW/RTLaSDvzit37VKKGGOi8b3Aozs6pU7oYZ9/Lxrg0c41fk8NlvAWzwjnqMAuS5J5EKltcM4fLD+olx9r+UlwEC3RcHEolGw+EdKSMA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2755a1e7-0eee-487e-0bda-08def1766e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 15:46:49.5430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nDf6P2yqdXxa5G0vKT+y5h8KMNT//Wh0ZR8LMkndMkexPNWxhPgKnKiLY9TGQTg9JuFy7PyqfnmwcjwCFw+7eNpoVZzKjQtw8vfY//6ZJ3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6867
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfX1U3nS3oxJ4CN
 vrAzZcp/QrMuRZxUfDrZUPfaHv1Eljb1wUi+Xl86H8C1LWYkHXlgyUy3vpFF0qmhTkIJSuNIi3M
 5QLSBBEnceWoGCQM0INWW4giKaWQI+J2fuMJ9Hi4gPgXy02QZp1g7CLMuSFaeUwRffjthAhWlMu
 qhfW2sfsFYPZLO84mIg7VFKzJkqDIqCHq6l5CHvnp+DVT5PQdPCP0Cx9wm12xTcD+0H5l1HihtK
 ppudz73wurUqRPsksP+WtMw7+YxwJ+CVQ4Jz+7LpqS8JwjnwelgcE/JEAFeoLO1+nBAbuAubQ3h
 zW1sAqwXD9pTHEWuY3dWgAff6mWZUdvg5OJhM7QU/y0LrcYVcV6K89/HReup0DrfYpprba0aP65
 YrM0FjbQFl0ZNlJ54ibt/AATGwXJiNdwzcVrJvXNbovkZ0w4E9Pu4CLow1iGDZaeMpqBhyQa6de
 vg8EBf0Fm8XzfUJ7Afw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfXwYARBJBEBG/Q
 YQgO312RSw+oVkSL8PSMuY03lSxdD6xm9bIBlWSVGPLpXxnWMrFkYhCNNP3Yti55NfdxR5Rlx51
 +aiqfscrFeetOQkGDoaMih3PxukZLJ0=
X-Proofpoint-GUID: Vwe0fLZQM7evQlCb5kJDyusGffmx8wk5
X-Authority-Analysis: v=2.4 cv=CcI4Irrl c=1 sm=1 tr=0 ts=6a70b7ec cx=c_pps
 a=NDowVQyA5LMHuT8sjPEy7w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=r4qjCuoxqP3BR8BjDFMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Vwe0fLZQM7evQlCb5kJDyusGffmx8wk5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjEgSnVsIDIwMjYsIGF0IDg6MzPigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdCwNCj4gDQo+
IE9uIDcvMTYvMjYgMTE6MzggUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IEVuYWJsZSBLVk1f
Q0FQX0FSTV9XUklUQUJMRV9JTVBfSURfUkVHUyBpZiB0aGUgaG9zdCBrZXJuZWwgc3VwcG9ydHMg
aXQuDQo+PiBUaGlzIGFsbG93cyBRRU1VIHRvIHdyaXRlIGltcGxlbWVudGF0aW9uLWRlZmluZWQg
SUQgcmVnaXN0ZXJzIChNSURSLA0KPj4gUkVWSURSKSBzbyB0aGF0IG5hbWVkIENQVSBtb2RlbHMg
Y2FuIHByZXNlbnQgdGhlIGNvcnJlY3QgdmFsdWVzIHRvIHRoZQ0KPj4gZ3Vlc3QgaW5zdGVhZCBv
ZiBpbmhlcml0aW5nIHRoZSBob3N0J3MgaWRlbnRpdHkuDQo+IFRoaXMgaXMgYSBzdWJzZXQgb2Yg
DQo+IFtSRkMgUEFUQ0ggUkVTRU5EIDAvNF0gaHcvYXJtL3ZpcnQ6IEFkZCBzdXBwb3J0IGZvciBU
YXJnZXQNCj4gSW1wbGVtZW50YXRpb24gQ1BVcw0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zw
b2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9yZ19hbGxfMjAyNTA4MDEw
NzQ3MzAuMjgzMjktMkQxLTJEc2hhbWVlcmtvbG90aHVtLTQwZ21haWwuY29tXyZkPUR3SURhUSZj
PXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1QR1dNeWlnbkEwTmlEbVRseVA3dk9USG96QndzX1ZO
ODZ5clZtU01rQnAwJm09cEJCaEtnZ3BDS2VEUzRTZDdjWGQ4RTVDcWhoLVdqRWJraDVRLWNTZV9J
TnAwTmpPajY5c0ZWQmJ3T0FnN1BwMSZzPVEtdktpNU1MV2RDemRLZFhNVVozd09ObmpBSTZ6VjBS
aWF3d2w0VXVWeW8mZT0gDQo+IA0KPiBhbmQgZXNwZWNpYWxseSAxLzQNCg0KT2theSwgaW50ZXJl
c3RpbmchICBJIHdpbGwgbG9vayBpbnRvIHRoZSBzZXJpZXMuDQoNCldhcm0gUmVnYXJkcywNCkto
dXNoaXQuDQo+IA0KPiANCj4gVGhhbmtzDQo+IA0KPiBFcmljDQo+PiANCj4+IFNpZ25lZC1vZmYt
Ynk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KPj4gLS0tDQo+PiB0
YXJnZXQvYXJtL2t2bS5jIHwgNyArKysrKysrDQo+PiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRp
b25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2Fy
bS9rdm0uYw0KPj4gaW5kZXggNzY1ODNkYjNmMC4uNjNiMzcyN2UwNSAxMDA2NDQNCj4+IC0tLSBh
L3RhcmdldC9hcm0va3ZtLmMNCj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+IEBAIC03NDEs
NiArNzQxLDEzIEBAIGludCBrdm1fYXJjaF9pbml0KE1hY2hpbmVTdGF0ZSAqbXMsIEtWTVN0YXRl
ICpzKQ0KPj4gICAgICAgICB9DQo+PiAgICAgfQ0KPj4gDQo+PiArICAgIGlmIChrdm1fY2hlY2tf
ZXh0ZW5zaW9uKHMsIEtWTV9DQVBfQVJNX1dSSVRBQkxFX0lNUF9JRF9SRUdTKSkgew0KPj4gKyAg
ICAgICAgaWYgKGt2bV92bV9lbmFibGVfY2FwKHMsIEtWTV9DQVBfQVJNX1dSSVRBQkxFX0lNUF9J
RF9SRUdTLCAwKSkgew0KPj4gKyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgiRmFpbGVkIHRvIGVu
YWJsZSAiDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICJLVk1fQ0FQX0FSTV9XUklUQUJM
RV9JTVBfSURfUkVHUyBjYXAiKTsNCj4+ICsgICAgICAgIH0NCj4+ICsgICAgfQ0KPj4gKw0KPj4g
ICAgIGlmIChzLT5rdm1fZWFnZXJfc3BsaXRfc2l6ZSkgew0KPj4gICAgICAgICB1aW50MzJfdCBz
aXplczsNCj4+IA0KPiANCg0K
