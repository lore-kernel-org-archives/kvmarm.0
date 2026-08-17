Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2FC3BE16A;
	Mon, 17 Aug 2026 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998521; cv=fail; b=GCrVbc5jxjCjlHHyJB3cwaKzTVJ/C1kBvgNqqh3x4nuIJlcL0aBn0bKK/u0MJG8/LgOZUZ51HsA8/7YLG4xuM7EK2lZF1ixWKyvZNIBzouSe1L1tkzj4AJ/K6lfNoTrLwBR0Q3+5ENJ+PFyzuaox+emATh89jCZtSvEv/We2Gpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998521; c=relaxed/simple;
	bh=BK7RoFLovqYdpqSa23uy9LGP/LpbRbe6CNK7fnYEkuI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ESCBsjlx/4jn7FjNwssLbybAIWEaOmi4iXPwlhkd2ZqGRo/tCIh4xfplKf3CaJ5x6gFMo25zxgXJy9WMODfW93llAC8eABq24lF3Vt01O76q/bR5k4bnOceAOoz83yYOhPwM+JCn8dvJsu/LFg+KlwhKFp3p/iFaKVZ3RTQgdZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OFc5ha2K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GcBERgvn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OFc5ha2K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GcBERgvn"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HFe6VO2038391;
	Mon, 17 Aug 2026 20:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sBDWjiGVuy7NZeyZIsnMlhZi0qNSqOwaMousVIXNMQY=; b=
	OFc5ha2K83zv1IYScGoZ1QHkIBfUNxSSy8kQl4UikNjnATDjkPojW3F3Xt8sNLaG
	L3UA+v78SJAPnPGLg6KlIBg1eErsLG6YffB9DVXhcBR3xTSbk0y35/EqGhtt3Fj9
	MM6qMPFrb3BdsyDpgXx29MI2g26ANUY04+8o2cRvIk845nrClsT1Ma7ZDrQyep7C
	qdUYNa9e2w0D1l01CQzAY/jXq3tWAE1moPBGQqmFzx+KPGAIx503oHIyPgOtAfdo
	RvQ6ivO6cDB/sX4ofwQcJn+HZghrutCbBQD9cyPgpfUqrSIlSBd+aAAfeX2uOLj2
	+n7iemajNyE3f4Ag/PxmKw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g5cb3uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 20:28:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67HKPA3Y016340;
	Mon, 17 Aug 2026 20:28:35 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejbq95e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 20:28:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fFGroAQCJ/McL3sK3psQucjrNJzlcsrwoRpmI7F/xYRiSwQTnLYePBwQE5MT0L997H50Qz3DWx/8qD+OSaoMspvCHDj9btFKa8Pmk6BFWHJlvOJx7pbetj9UzP4BxE9AUfOGmINGe1vfXZDcJ0lX+ZSFbhlWx1cAMxgUsV/htEXhie+TEPmuga7rxd+ePQt5MUbdqhaRtZto6FmqnIMZLoIdGwRojVtv8x15TE+KoqU1QK7lxTSLiSLKWkXTWiGmj+wBGqzk9osgqVaPRu7nyNH5z/pATY5hzNvh5J59CAE0xSGsuG/i4WNQfwezc90uIH0cH/Q14cUxwjkdW/liQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBDWjiGVuy7NZeyZIsnMlhZi0qNSqOwaMousVIXNMQY=;
 b=EL3KEgOS3t3AjpFfZ9pg1jXhAMnq2oRyDgaFpbGar6B1GxQbfR9P44LYLCbU5iERhwoQKEa7UPIjoa7vURZ0eC/vPpoNRvW7SBQ4kgDYt7LCy1gKy/j2dONrQnpTKEuXpqMjSnMjtt/J8vXiWsHmNwszffSCGvoEqAQNZPGYUf4HP8OzEWxgaCylf8jj6ln1BGYuGKaxwOIH04zddfGKQ9ytVnVhBW2ZBi9Hip1IdHZtkLffK+ciiiJrMREmkLSicsVsjTyz2GF7krXugMHNMBcziYupeWKteecWxSMwGYDwAd8/GFW59DqaFsaG3EcNPQ7zUt1DjZvR9EuNzA0hBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBDWjiGVuy7NZeyZIsnMlhZi0qNSqOwaMousVIXNMQY=;
 b=GcBERgvndIcLqNSOcLV2U+5TspaHqCrJEv6fAMf9zIw0NTmZTzvVMCErnCqEVu0fN6J84D6zQOyL44UoLFGh7ZSZ14GWTQiu3734pSFr5o9HBWJKmjTPTgnJgEBlcSK+/AqwxbJ770ZncPqdvxi70A3YN2U9UtmABvXkmsd61sc=
Received: from CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7)
 by SA1PR10MB5841.namprd10.prod.outlook.com (2603:10b6:806:22b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 20:28:29 +0000
Received: from CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4]) by CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 20:28:25 +0000
Message-ID: <23754814-4a94-4100-9786-2c7dc5168f72@oracle.com>
Date: Mon, 17 Aug 2026 13:28:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: selftests: Test steal time across vCPU pid
 changes on x86
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <20260816053630.527528-4-dongli.zhang@oracle.com>
 <20260816055519.E96F11F000E9@smtp.kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260816055519.E96F11F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P220CA0042.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:2d9::14) To CO1PR10MB5506.namprd10.prod.outlook.com
 (2603:10b6:303:161::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_|SA1PR10MB5841:EE_
X-MS-Office365-Filtering-Correlation-Id: eabdbbb3-38c1-4dab-692f-08defc9e1717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	uNvq3lttI7rb3bWxa2x5hUPrvCz77JmReHAOvPNeS7PgJQmpeyrc0xO6cSwiplNrjfLFApQte6J2uAljBEzo+lcxKZ3rL/PQW7xgY3lHHzc+Mw3mI2p6mOK3AUTvNav62CYA+j1k4ESqsYoeTQpSPHhhf2SIc/CPsgtzdCVtQhRLDjKwX6HTkLEfbBgTHXq+G/fMKj9qW48oojCOFPII0T9qapBXcR02Ti9Vzxj8GePsyceZ9HRGRezNICSs/laNd5pyRx9FgO1yO6eKqcyssA6s+slhBwMcz3NfhAW9T0eOr1pQPIEWgoa+gWlb1oCRKzHEVBBd9BbrLF5Uku/bxkKiPdH6n4QIutnaXaeD2exs/EFlo/SoOzRj+gdiaEa+c+rykpo3cuWImFq0c5LlohW3/OVOTio40Ll69sVi0GNaQDv4NTPjMYSEwNAn8pgPVslaLoMkgyfk5mNSYQRU5YTO7ICKWlLlxeyQSHQA1c31H8PIUfn9e+DL0Gy+Ns2jVJ3R1iOLdE0Lu1H1mYMDYQsaPqEiTiiPCzJoSZzg75VVaowhzvNpEb6mRJRX7x2cBwbSzv3hxhK0W2Ak1uXEpAnV00k+YPS2ySBra/b5+CwHgb2aypizAr9eApiCpekbAKe+REHxS1B0SYLeWrerP7kCkxJIn3RwSzbBSbddQGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB5506.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXRoMWFFZlk0MlpBeUsrZ0dLYnNsS3pSSnhaUnBrZVNHb1c4Umt0UmE4M3Q0?=
 =?utf-8?B?aFJiY3lmOVI5aTJEZ0toZ0VvUCtkV2E0aWtPTWtiYmJVN0JSSzFtMW1Dc0Ix?=
 =?utf-8?B?ZFhEZUNyVzk0T253b2xNQmNKYjE3K2REdno5dkttblVQNmlHcGMrWVhBbHJH?=
 =?utf-8?B?eGVPQ05CSlhTVTNka2tIMnVWckp3Y0pjdXhNRjZmVEhTaHFzdGRyU3A4cnFX?=
 =?utf-8?B?ejJzWjN1ZU5aUGdFZmpFMTFJbUdtdEhjajNMRkdEMUppN1VBM2M2TGszL3Jy?=
 =?utf-8?B?dHRkaHdSU2tzSWVxbk5najlGb1NTNHdiWUZDMWVCbnVNQ3VJeHRtdmRlcWdD?=
 =?utf-8?B?dC92TEg4RzVmMk9tL1pkUEg5UXdPTi9OVElORmtkSjMveEEvcXphTnM0RkFL?=
 =?utf-8?B?ZVY1SUZVTlJBSXZMVGtHdjlTNU1Ec05lZGJLakFLS2FXN21EeGVVSzFqWnJR?=
 =?utf-8?B?Qys2cGU1L1lUWHVTNEIwMDJqd2FTSmdiZ2NIOFNnNkJpMUN5WnFVWWdlS0pG?=
 =?utf-8?B?dUdyTGt2RzBrWlM0MXhvNy9wUk9uTjhPaUdWRE5ETWR6K3F4eDVHeGxvWGJF?=
 =?utf-8?B?b0ttN0ZGUGxyRmVjRTFuYzRSaSt6Y2tVdWh5NGtqWGdMWFBiaUdJUzBrV3JY?=
 =?utf-8?B?OC9ObjlQMG9qTkRkNlh0S1UwbTJQdmtzYjFacUdRVFhOZXU1QzRpanVzblBi?=
 =?utf-8?B?clFWSGUvQUU4RkYwcnRnN0xQR2x3RS9LUnBWK3lQTUlDeWZFdUdTS3ZQZE9G?=
 =?utf-8?B?ZEtWbTQrWGYxSWRBLzdBZmtDOFBmTUhGNmhGQlRVZExaL0R2M3lxRWI5UW5y?=
 =?utf-8?B?ZmFRTmFIRHhtNWZnT0FtL1JHcXQ4M1p4VWxVYzZhMS9oT0xwNVdtNWdJNktD?=
 =?utf-8?B?L0JFSWZtdDgyQVRhbDFqaGtGUGlVcHZpZ3BLQXlrYWllQy91WkI1Vlpqb3ph?=
 =?utf-8?B?WHVrV08xMmRPbU9sR28zdVp0bWl0MGdDRkNOdEZUUlF0L1EvekFSWDNMeWJY?=
 =?utf-8?B?bVdXd3EvalpiemhySFNWa3lJNHFaWEFKMUlYWmJ3b29ETDlhTzY0V3dqYWsz?=
 =?utf-8?B?a0lpanFQWStNejY1ekdvUkJHcUM5a2hZV2VONWdEam95c09RaFA2RnNlc1FJ?=
 =?utf-8?B?WllGcVJoOHBBcXcvcEk3N2NpTWNEakZ5em1SSk5FMDhlZGZNSkdkV1lJWE1p?=
 =?utf-8?B?YkU0R1QyRStuTUhDV3Y1Z1c1M3NWWXZCMUN4YWlQeXdDc293ZmVwVnZDK0ln?=
 =?utf-8?B?N2dKR3F3QklYOHR6TStLWGI2VEpINWpCV1cvdnFCVjNPVE9ockVUQ3NlZnV4?=
 =?utf-8?B?RDF1eGl0UjNKU2pZcE5rY21HZzAydU1XNTZic0crNldmSFlJalpreUV3ZVZU?=
 =?utf-8?B?dks1NFMwNXFrbVdGdDFBSWpVa3daSSsrSTQ2ZHBrcC83WjJDM2JldmFNV0NO?=
 =?utf-8?B?VUxodllIbW1sTGVkLzlLM2JKN3pWNEZ4clZWZnlkdVdtSkN1V3AyVjlTaVg2?=
 =?utf-8?B?dHFXQkJxSFVJVTlsZXlrL1dzcm1Tc0VFakJQbDNzSFhmZkw0ekpLbW9sOUhH?=
 =?utf-8?B?eGNRa0loNFJFKy84WVF6Q3ZKN2c2b080WUU0WXVRTEhwT3krWFRzWS94V1d6?=
 =?utf-8?B?STNiMGM3NDQwQTQrNC9zZmdyaFdxcThZdVI1MWRXV01TeE01QVlqRXc3VE1u?=
 =?utf-8?B?bUdjTFh3V3RoaEdreE9zNEQrTVVxZzB6MkpqRFdzTndsdm9ONE1PTzNRNnNH?=
 =?utf-8?B?K3pMR05TRGdpV2NKWE1ScDQ0dGhyUkpWZTZEL2x0Zlp0eUxtK20rMlp5ZEti?=
 =?utf-8?B?aFgvcXA4UXFvc0o0Q21hRUpueTkxL2s0cysxRVRKZ1lyQXN6MXJzZEZqTkRs?=
 =?utf-8?B?U1gxSFBkWVJSQW9PekFMc0EyUkF1UG5QWEJETmhUTmh0SERadU02ZjdxYXZm?=
 =?utf-8?B?am1zZ050Y2Z3NEJVcllYVk9lODFEaHU3RERVOWp6R3RrRkJ4cWRWb3g4NW91?=
 =?utf-8?B?OUd4S1lFWkdjRTVPeXNvUTZaZVJtR3dJNTZ5allKeC9MdEloTUt2aWpYOGNz?=
 =?utf-8?B?UUYxNVJCWVBka3hGSVZNT3A1K1Y3ZGdPQ213NWlyeFJvMEF2cXVyMldTLzU0?=
 =?utf-8?B?MFJsVEdDeUh1RDE0YnM2L05aQVJ1TG5UaFR4UjNQT094NVhsUXM1OTlTVGF5?=
 =?utf-8?B?M2N1Z1RNYkhXMjJLc1VGWVg1ZGVGWXc0aVV3VFQ0RUJpamJuYmgyalQ3V3R2?=
 =?utf-8?B?UGc3UGFyUlpXYXh3WnNzMTBjdjM4ZC9UaFl3RWZvZ2dpMVZRSkl1Z0NRNE9a?=
 =?utf-8?B?WWx1b3lsV0xxWUlGQ0dlM0o2T0hoeTFBRUZHOWVYMEdtWHlpanlDQT09?=
X-Exchange-RoutingPolicyChecked:
	ZoOJduHMKmYOzGvya7pfD15KCQCfJBsxZC7+GDPZPFDqQb7v5mAGjI4Ju7U8LywDWoG3CGbkQ7E/4mO/H9nJ6XSlIvvPj8jxhlPo/ry+tHhCTy7pRbXkUwQ5kF8pdX1SyaheWwkKOmkV6fKFoGXNpEDer/1x0zXjS6J6wz+za81/RzDHJ0s8wVX5SPygaNcMNxRAjUxWfIwwOQv9pUqAsjY5oliEUfhRGPFU398C66Dpfj/OHyvzSZh0CMVyNTP4jZ4PakhDMIeY1/5A8IreSm+/8fy4hwZyNvhfaucWpnagoYydcDNHEZggCXjSIQxtcF5ZDEcFOfhmPm21jDyj7Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QXvE3AzQS/umXtupDsecn2looHxwhJDT9w0W1Da/5DJlMWu6fnn52l0R15gpSEja8pjdPZTCiacYVBf/uc7Y6veS2LIvjapujkwjRmLfOnzLg+SxGg7vmC02MZfCkg/oJSKYC26KPOtghHMS809VTMXBD1AqwR5C3obHL0EGpYNAvcDE8SsEAS1+v8n1AJIehLtmJLM4Dj+nmjJWC1djJ5OB0LC/ljwmgz3QVPD2raJRQiW26jNX5mlchkhBFJWRenB0mfRWgLvjTbVZ895cZ4uFBZTJz4eyP+kAZxuIV3Q7um2tNF7APNObfWLRbMIWq1JmkAxWJEf3NhYTF6Vu1GsnGfI4VMvNO4pjtiv2evm3iUJClzEjy61cOWxPmSC2V0XyeaEARyr6gTiivr7PkOaSpf9rsCiunXH/WbqzRlrXLLrUeamFVeMnNtzluitH4HpgVaLMDUacfhZU99Yd+VpFCG6E+1azul1JBXrekWgYnsiBz6xW+ixJegS8F8dQb1Y8mrAkTa3mBewgy0XkF/B0n8QfwAx83Bih5v8TlLWhJlkqLMOHgVUTygO7yracMBcQQ7p2mIJNb24e4QMf/OMCBo5qt9DD7pfEvj376Wk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eabdbbb3-38c1-4dab-692f-08defc9e1717
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB5506.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 20:28:25.6603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIvCpL+rxf7peLZFOPfG7e8s2n72lt8mqESdyhmPzfwIjg6otZ/BIXCcEgy8JfXc8CrW7XsjBeAH3wNKtXwiUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5841
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608170156
X-Authority-Analysis: v=2.4 cv=INoyzAvG c=1 sm=1 tr=0 ts=6a836ef4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=wSN6PNIQBud6TREbdlMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: QPmJRAZUUR46ATYncRa3eCNznRCnYyv5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE1NiBTYWx0ZWRfX4SvfsHHLJtA1
 hnYOEW8m7T52tTd4ksHBJaOrX6ptUTjCTB5BaEXwSaC0hEFGxGbVggKPHLOR18ogWX1ScjfxK9Y
 y6lzwR6Jkpw03rPfWoNV2UnODwXPKRaHQkutkPYUC9t0TvZDdc1BsSUDubcEKtNZrXbmVuJFNkt
 HFwMbiQRy2QOLdl5vPzuApR4uv7m8RZmcpy9V+OVVduMfHy5yBvDPtD0q1oLk4IcwPU0dcCjzb7
 w/uXWuGuNbNUTQQifcnAGEnQshNOeVGwkr2D6IInl46xKjxZzVwWxNqyikSf7f6JhApDPDiXFKa
 PYlHlJcZSzA5q4VMe412UJBk5g58Ps2G/UaHdIv593p9gjFRMAzsL2UUlmafeSG3iKZhQUjSudk
 SN6BIGmc7Qmgdmr9BeLcjWsxBKXRQdS7aTNQg55BqMDqad3n7ZFBMMGxEqZKFDsBdkzVF3R3EgY
 nSTXDVTd6aYF26uSZ+w==
X-Proofpoint-ORIG-GUID: QPmJRAZUUR46ATYncRa3eCNznRCnYyv5
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE1NiBTYWx0ZWRfX9EOieiJL4cyy
 J11X9+o6qZMAZg5AWne40S21h3/9lU8gNT5xwJwVsqnX+yPjD1KkJyBde47h2cyB3S3Qga2oS5s
 Jm9ILasG4UM9xBQmTmxfao7SJ9sFRgNCmUQONEDZWh+DPGHe8hSS



On Sat, Aug 15, 2026 10:55:19PM -0700, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] The test races and hangs infinitely if the main thread is scheduled during the helper thread's 200µs wall-clock window.
> - [Medium] Unhandled `pthread_create()` and `pthread_setaffinity_np()` errors lead to an infinite test hang and undefined behavior.
> --
> 
> --- Patch [3]: [PATCH 3/4] KVM: selftests: Test steal time across vCPU pid changes on x86 ---
> commit dbc0e15e73158fcb584e1322da57a03214c88dd3
> Author: Dongli Zhang <dongli.zhang@oracle.com>
> 
> KVM: selftests: Test steal time across vCPU pid changes on x86
> 
> Add a selftest for the case where the same vCPU fd is run from a new host
> thread after steal time has already been enabled and updated.
> 
>> diff --git a/tools/testing/selftests/kvm/steal_time_change_pid.c b/tools/testing/selftests/kvm/steal_time_change_pid.c
>> new file mode 100644
>> index 0000000000000..3c39594db398e
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/steal_time_change_pid.c
> 
> [ ... ]
> 
>> +int main(void)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;
>> +	pthread_attr_t attr;
>> +	pthread_t thread;
>> +	cpu_set_t cpuset;
>> +	long run_delay;
>> +	long run_delay_delta;
>> +
>> +	ksft_print_header();
>> +	ksft_set_plan(1);
>> +
>> +	CPU_ZERO(&cpuset);
>> +	CPU_SET(0, &cpuset);
>> +	pthread_attr_init(&attr);
>> +	pthread_attr_setaffinity_np(&attr, sizeof(cpuset), &cpuset);
>> +	pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
> 
> [Severity: Medium]
> Is an error check needed for pthread_setaffinity_np()?
> 
> If CPU 0 is offline or excluded by the process taskset mask, this will fail
> silently. The threads would then run on different CPUs and avoid runqueue
> contention, preventing the main thread's wait time from increasing and
> potentially causing an infinite hang in the later sched_yield() loop.

This test intentionally follows the existing steal_time.c pattern, which uses
the same CPU0 affinity setup, unchecked pthread calls, and run_delay wait loop.

> 
> [ ... ]
> 
>> +	steal_time_enable(vcpu);
>> +	run_vcpu(vcpu);
>> +
>> +	run_delay = get_run_delay();
>> +	pthread_create(&thread, &attr, do_steal_time, NULL);
> 
> [Severity: Medium]
> What happens if pthread_create() fails here?
> 
> If thread creation fails, do_steal_time() won't execute to generate
> contention, and the subsequent loop waiting for run_delay to increase could
> spin infinitely.
> 
>> +
>> +	while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS)
>> +		sched_yield();

This test intentionally follows the existing steal_time.c pattern, which uses
the same CPU0 affinity setup, unchecked pthread calls, and run_delay wait loop.

> 
> [Severity: Medium]
> Can this loop hang infinitely if the main thread is scheduled during the
> helper thread's wall-clock window?
> 
> The helper thread do_steal_time() bounds its execution to strictly
> MIN_RUN_DELAY_NS of wall-clock time:

This test intentionally follows the existing steal_time.c pattern, which uses
the same CPU0 affinity setup, unchecked pthread calls, and run_delay wait loop.

> 
> static void *do_steal_time(void *arg)
> {
> 	struct timespec ts, stop;
> 	clock_gettime(CLOCK_MONOTONIC, &ts);
> 	stop = timespec_add_ns(ts, MIN_RUN_DELAY_NS);
> 	while (timespec_to_ns(timespec_sub(ts, stop)) < 0)
> 		clock_gettime(CLOCK_MONOTONIC, &ts);
> 	return NULL;
> }
> 
> If a scheduler tick occurs during this window, the main thread may preempt
> the helper thread to evaluate this loop condition.
> 
> While the main thread is running, its runqueue wait time (run_delay) does
> not increase, but the helper thread's wall-clock timer still advances. As a
> result, the helper thread could exit having been on the runqueue/CPU for
> exactly the requested wall-clock time, but the main thread will have
> accumulated strictly less than MIN_RUN_DELAY_NS of wait time.
> 
> Once the helper thread exits, there are no competing threads on the pinned
> CPU, so the main thread's wait time stops increasing permanently, causing
> this loop to spin infinitely.
> 
> [ ... ]
> 
>> +	run_vcpu(vcpu);
>> +	sync_global_from_guest(vm, guest_stolen_time);
>> +	main_steal = guest_stolen_time;
>> +
>> +	TEST_ASSERT(main_steal >= MIN_RUN_DELAY_NS,
>> +		    "Expected steal time >= %ld, got %"PRIu64,
>> +		    MIN_RUN_DELAY_NS, main_steal);
>> +
>> +	pthread_create(&thread, NULL, vcpu_thread, vcpu);
> 
> [Severity: Medium]
> Should we check the return value of pthread_create() here?
> 
> If it fails, the thread variable remains uninitialized, which would trigger
> undefined behavior when passed to pthread_join() on the next line.
> 
>> +	pthread_join(thread, NULL);
> 

This test intentionally follows the existing steal_time.c pattern, which uses
the same CPU0 affinity setup, unchecked pthread calls, and run_delay wait loop.

Thank you very much!

Dongli Zhang

