Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5085C2236E8
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000847; cv=fail; b=czM68jchZ7Mf2o97uSAUadAcbI4PL+N/pscmGUaVXEluTSxUIbSzhnipvnM4eoPXRf3kaa+vjEZiT6MjhJ3InghkIWyryn0LDqlvez1PoEMH/GA3lZHYhK4I+ihMou7cnjSn25c9jgQmjtchC+ShVtBrITIH4CECTpbvln/5Qec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000847; c=relaxed/simple;
	bh=YzIrdnn07FyYkh9olTJXFld2k+3xTLW5APvvpvuqvT4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JDGlhriMsApTXwNxoSifxVukSmkqGfdy3P90XVqp3XE11rxy57R0kqvcz1mhK/KK+0tUKyh99wEid+ADo5+jyY1PlEYp7SWYxtp9yeSFuRf5+rgghZjWVSZRxLYKparUUi/jHwv7jEm8hyu5X7G1vtW3hCJtKKHLZZ/jFGMa/Vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o1Fx+D2C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rVqyuXJe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o1Fx+D2C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rVqyuXJe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HFj85Q814889;
	Mon, 17 Aug 2026 21:05:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ODisOdi7DmSDatpk0UHQY57orwxe1KEMS5Nq27CXI9A=; b=
	o1Fx+D2CoqcWiEi20C/vY0tNfDpLB57fy/9ocQOEnW9t4RLOvanPyafmEg8F3Qkw
	uiK7IsuIBahbXRwzS/edbHM+JC98v0h3wsXKnFu5etAkPYsuUZbqeZEDinW7owAN
	LxQxT4yu+oksHzDAycOlrzkzcC5i5dCYqmb0kZPijRXNqPrHFxMaNwQGmtigCCp+
	0BVmFi9k3yBe5WJRlx4bNm4oE2EXiqMzYToBpJehVHGagBOQm3UGcZJ042PNbhLA
	JofLnjTiYjEOmsA9M0pu9DwdDlJJRY9LO6t69GbJRBB76bEXAcX0HIHl20vzalrJ
	XP3wCX8oCtyLEVG3NuVLTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2epy3brv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 21:05:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67HL5frG024049;
	Mon, 17 Aug 2026 21:05:50 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4g32hq137c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 21:05:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNZ7mAjvIYRt+9qrtxAV14qML/7L8QyaGgBJzVPwKLWcz3lxPmu6rpOOzewZ1Mc12GzT8veeLsTthHQpeXg9lgvRYa7JOCM4jxLmO7B4pJazAARjozuzWx4Lxbsavmyef9UJiKFbyWGkGOGEbGwMZpeaolJI8SqY1Lt3yMCDezXHZtzdV1XPAwHeqzVcdsXrBXI9ipvbIb6S0FCXa0xmmyNt/jSU1dHgpqbGfK7FU+Qubivoi21C+PIRCRVRjYuL6bIcV4/nkoOBw9MuqMyFf7FcNupgkgm7Kr/wyYS1B5ZQJqJXqAE2bqBw99q4Hag/ys4Lzsh7BreYhir2fwmZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODisOdi7DmSDatpk0UHQY57orwxe1KEMS5Nq27CXI9A=;
 b=LF4YYOe3Ln72znzk+65+s7hqFk08DvISIN9OqzObOyCwZmUN8+Cy3/+f1VMaYL8xa20xnUXzCBWHowRRUGEqTFNr656UyPxwWJDGsLiJOcmTEMBI4r3XD7IbC7GbpEzcpxRRTFS2LkZia/b5rl8WNVq31Kb22hWbHzZxdulD5cfUr+LixSYPE5MxgBMC/utaAK/Ws90VynrtyNrm+nSViKVZ0+fHQIk6dgBA8K46n1JyutkZHX/Vnx5511VXieDmEB3ABE9pii3YftXkqyRIUCRcNdDlQy6eAg3fwCbW1XXTQ4G9UV8qEkAKQvbpaXabQcZfTX8JTXt5biwpX6ap1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODisOdi7DmSDatpk0UHQY57orwxe1KEMS5Nq27CXI9A=;
 b=rVqyuXJeiYY3Og083BJVFle9QaXemDwbbsfGpodDtSbuoHnx5Yb14AzI02WY+5qKyKeY/SjEjg6OTwGIDrA2SUBI4db5N3lgAdLcdRcS9P7kTW8BVKneFFAr9BbJJmMC3jfJAB0Lth8jUaua10DH1ffnrRIOo1Cfvd4tl2vKthY=
Received: from CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7)
 by PH7PR10MB6459.namprd10.prod.outlook.com (2603:10b6:510:1ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 21:05:13 +0000
Received: from CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4]) by CO1PR10MB5506.namprd10.prod.outlook.com
 ([fe80::da72:a0a9:5f18:cda4%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 21:05:13 +0000
Message-ID: <d71a5dbd-cabe-476d-8837-9519b88ee5cf@oracle.com>
Date: Mon, 17 Aug 2026 14:05:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] KVM: Reset steal time accounting on vCPU pid change
 (x86 and arm64)
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, dwmw2@infradead.org, joe.jin@oracle.com
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
 <86tsotyxh5.wl-maz@kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <86tsotyxh5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::20) To CO1PR10MB5506.namprd10.prod.outlook.com
 (2603:10b6:303:161::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_|PH7PR10MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: d82b7fb1-81de-4b25-956c-08defca33af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|56012099006|10067099003|4133799003|22082099003|18002099003|4143699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	1YEOwu/oksa+W8JaJlfqr5mo3//xHxKR8ecj3wbgNGNFNi7mB1QK3bH6Pv15rKctfBUxLKByOB76YpM7Sf9PelNpAyOi5FvsfEciI+fvS7Yj8JNtgoSip07mULDckSXb2JUzMZP/W09qpt2No/1GKBIAlrrT6SPmfAAM2yZ4hQv73YZt1YHdiWAY2m6V28CCMvVeJOIMHCezg44t10jdw7J9urkJkgf8QzkgCWf2OOjE04nUkNhwjY/fcaLASSk1AOyGgOYDoKAuR4Nlj/WaMAlxEGiluSX1WiMEKAKaIH6QgDnuoV/MoWjexoiZ5GMmiunuS6q4DRL7v+AlBpR3KYiNNzrShwPpYABwb/Fh6phXPSIkgDlnv3txCN9u4bT9JvcYlEKS7NsjPsvyKnofRffnokhfQCmd4u2B4WMpgOiKViST2EkqeBW7pKCS9usBDsEgQqRpzWI1O6lkfgNiBX0hrVkE9GtfyC0duSXV1SSpjZL4QnuvTrDMvhqigNXlYfhDmvz00nVrUp/y+x7+tZE278MpxGWeNA9O82RBXBZ10SEfSwXrP9zoyoQy9bkfeIaKh4+w3m/QmaVJUED1rcXNQoLD3orb6622Ys+yPhvSJB87eNd+Mx1nBZqhJBmhs0x0ERxrrGFhQ4dzlEQZXh+Lg2ejULSdWGEGgkJkY0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB5506.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(56012099006)(10067099003)(4133799003)(22082099003)(18002099003)(4143699003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2w1ZXhOelpEaWRuR0Y5SUFlalo1LzJOdE9JbkFieTlzWGFlL2RtSVZWYmxh?=
 =?utf-8?B?RmlQdnd2dlBjUmFrdkFqeURaM3VTTi9NRDN3dm9MVGtHamQ3VnNDYUhONHlp?=
 =?utf-8?B?dE44NCszdE04V3huRW1tdjgxd1ArQUFOeTNmTFNoTDluMHpocXRXU2YzNjRw?=
 =?utf-8?B?a0VOZDNGT1haeDRmMitmWWU4VmhoQldoa1pkVHVQUzFFYUpUblE5UFpYcWZH?=
 =?utf-8?B?Y3RxK29SZHBNaEpsSWJRckY2a0xLWHl5Z00xRnduSFZOVmk5Q05ySUw5eHA2?=
 =?utf-8?B?dHdNUU9abkFrYmsveWx0aWk2WjJxUERIV3VYZnNDZmpNaWg4dGtxRE1udnAr?=
 =?utf-8?B?VHNmY0hPL3VzMG4rWEdtN3lWVVpzc3l5Q2ZTbUwrLzJyajBUZmZwRi9VR0FO?=
 =?utf-8?B?SGNXYUVUTHljVmRUQjhXMDAxRk0vdjN6ZDhDNXpCVjVFNFltcFBIcjF0OUVo?=
 =?utf-8?B?U1lOSTJZV2pqbWZRbHdmOGNyMlNZSS9XNklQZEkzaithbk05K2p2ZjNYcFIx?=
 =?utf-8?B?NC9wOGxsMU53b0J4eTJtRnFySTFxSUx3N3oxMUpvelpheklmOWxyd1Q5L0R2?=
 =?utf-8?B?bGNHVFZ1YWM3cmNCcDJpSlMzejVRcUZNWjUwK0dobHBlWTZTMVZsTDUyOEhz?=
 =?utf-8?B?SGNSSzdzRGlmQ2hkdGp6TTlxbUtRVmdOMUZiNmZuYk9OZDUxZGhDVXZmNzBt?=
 =?utf-8?B?UlQ5RVpnVFhrS0tnbXZ0dTVlQTZwYzE4cDQvTVJFeXlxdHVMSjFVU0RFbVRZ?=
 =?utf-8?B?aFhaRHBtdzkya2tTb1VHR0M0QVJVSWx2VHptSW5XcXVvVGxFQjRKRkR3Rlkz?=
 =?utf-8?B?QVFQVFpLSkJybUZtNEVrVDJwOUZ4Sk9ROHM4YWp5QW9zb0VVWTNOWHgwRXM4?=
 =?utf-8?B?c1FRVW5RU3lLcWlkUUlyYWFKTWx3SDV2TGU1SDFJb0lBeW5pRnlWUDMyUksy?=
 =?utf-8?B?aXJBd1JnUHlGUVRwazhwODdpUkJ4c3IySEJCWWhMR0ZTOUlFdWMwdXFreHJa?=
 =?utf-8?B?aVFJcm5mQ1dhUHBzblAwUTNMWW9PWjdveWJWSitHbkxiazhQOVAxUGtRWWlT?=
 =?utf-8?B?cFR3K1g1dUlFVSs5UlpuVXFoQnVFdDZQdWprRHRJbnhFUjZjZlFYdDFaZ2tP?=
 =?utf-8?B?bmdPY3lXVjFUeVJieDl6eE5SbXZVWC95QjZFdENpeCtJb0tNSmt1NWQyRTJ2?=
 =?utf-8?B?ejY3czZJK2NtL0h2eHhpODhnZ2N3ZGlOb1QvZHhuRXoxZG5rNXRPdWFQWnh0?=
 =?utf-8?B?Z29pU1l5dlZ0N0RtZVowL252bFcxL1AxQ0hkS1hKQnhENU1hT05GQUR5RVlY?=
 =?utf-8?B?cjdIUGR5cTRKUHdPUnlkamtDM0tGanNEVGpnd0kyN1hReHZLL3FUZndPUk5p?=
 =?utf-8?B?bEswRWYzdm4wQUQyandOeGVWUzBSdXlINzBUN1F1eGNDeTlEZmgzcXQyWkNk?=
 =?utf-8?B?dnNPcWFMaGtPNm1ibFQwa3JzR1h5eWZmZjhWQzNlU0Y2NXVkOXNIUzE4Ymx3?=
 =?utf-8?B?YnorUUVlMUl0L3Jsd1NmbVN0RnNzK3NxeTdUUTFSeEh3cU5naXBzeno0RXhR?=
 =?utf-8?B?dFM1TGJBcW44QVl3ajg0elFBUnJWdEdIZmFocmtZWkhveDJjQjgvbThrN081?=
 =?utf-8?B?Wm5pUHFZN052L0E2dGhuTEIvUlhqQm80cXBhdnlXWUVRSFc2RUEyQ0d4MGRW?=
 =?utf-8?B?WlljQjh1QWI0d2VGaWhVVkN5Nlp1a0xlbXdOdkFIYUJaQytDZXlHekZzai82?=
 =?utf-8?B?RGxoSysxbVYxYVRvSEdyb0dVaXVRcW9tMklsNW1aSG1UOGtoSTVVa1loNWVv?=
 =?utf-8?B?ZUVaT2hVZW9Wb25XMEFselhvYXVFSXF6NzNXR0RjREsvRmc3VEw3SUVjQ1VQ?=
 =?utf-8?B?V3UyT2lGZnoyNkljTms4aHJObEJCd2Z6V3BDZVhJNEI0VERhb3RWaWhIc2dx?=
 =?utf-8?B?WllIcHNkblYyUnlCTHZ4WE5meThyWFo3NTZacEZPYnpCQkNad29VdW83VHBp?=
 =?utf-8?B?YmRPNHhhS2FaWmhTMEp1OWh2SFU3Zi9XY092ME52NXdHb25sbS9yYjN6Qllq?=
 =?utf-8?B?N2JaUTBrT0tVOUhZYkJJTVMvOTdMUWJvell4WW9tZWF5clo4d2Jhak9sL3lV?=
 =?utf-8?B?YUx1ZjNkQkk1MzdvMWxZaFZ0T3huVERUdGlWVDlMNTI5d0hjMmNKVWhMMEJN?=
 =?utf-8?B?LzZWejhVcldnYjdycG9EaVhxeGhzSEVpL1VIemJHeEpIREEyVjJMQ3N4UTBl?=
 =?utf-8?B?cmNDcmMvZmdwcmkzTDN4UkwyUC8rcFNrVS95NnJGN1h1MHRISVhKSyt5ZktM?=
 =?utf-8?B?eGFRM0RzUDd0MGJJamNwdStCYlhuR1FGYm43UEx0Sm0vbnVzYzBMdz09?=
X-Exchange-RoutingPolicyChecked:
	h+c9WF35WVzv5UdsT5rhqB9nfZYO2jLTEIuqKbfG922lAgnrAkF2FZ3FUvIyu2+FFfyrKF2PYxUWsLUKLzRG8uqo5zqh0dDALT6oTst2aVBUPEhiCOF0XaXPPhmlovvscJcPpG+WBKoolw8Efa1xHIKrLPyCaJNZEyCK2yqjG6ijHiEyzrv8HQWwiA4aYxXqUUQYUraBiEthA38mt3Q8zNmPQ07DgCf08fdnc+56eRw6EZ2PrfCryY3coXBvI4gbT9ucGCrJr4i7bAiUChhilaBgzIybCz1zBawsqr9qcigB6iHMlLFeKWnDpij0q3KsawKxoi5SBSgpn+Ofvla2Xw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LCv6O9xzQfmTApOYhqsh4FnYTcgQXEbOJJF0Lv8gvyOERaVZ544NKyGQzZn3nIOHK052gaO9wx0bFSwpsCkN/F4kDnorgJX02iEYoJ2g4TUAJw7k8NR+4bPuoJ8eaBiTN/1dfZSuMkzuWjyFHY/FiWwpuopP2m4HuPAAMOSIJbRXOSHzJtTbG4YAAuvsiTCwYEdf1WbdrCM+C0YbseWi0RLeg9XcpFWt07oJh37wGFirinax7nc6Oo89i9rD/h8jRRdEHOoaIL+XgsbOTo2hKFAFJgqWRJjquMEATv+QbFsjE3d3ajGUjbyBdsg+qI8OEFl1ecjUmoiIq0MED94DOPNZ+qGsBThYR9fZZRp/sBExwm7abI4s45QPX1NoWAOgOEy2sUYwOZeC8nVmjcsYIt1IGU5Gq2cOkMYEp4UByor9wAxrf449cLaCOkYtQ1ANDdwK4hrZGXqPtEG2qjynJllDKiRYcni2KJyF6RaPDb0/M5J8DMyBdugOl5n5CK6G/xjhe5xL91civ2pGCLgyvwCOmSnfSCLVza0nV7YRlCtfUrUdMzScz8L51z/T6/ebfpz6Lb5UNDUGIWj+Kp4nLPUog+8PM2DWaJBI5iNbGOg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82b7fb1-81de-4b25-956c-08defca33af4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB5506.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 21:05:13.3697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gAFJZJlnumj5V0rqxAVcqlcuHo0szLI3tcghTk/qJtKeJz8t+YCdm00siGDm9J+4f7DHKO98hHyqCS0udl5fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608170161
X-Proofpoint-GUID: xwAVs9NP192bnzsMCmETGFMi1Iyq5YSH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE2MSBTYWx0ZWRfX6anAzb/Uc9t7
 TU5spX0woaA9g+1GLTzonPVTzeWWgWkBlepHpAs4rQqPx+ELUl/6jwcKw4tBUSP8T1hscjwZ0US
 HmACngp0AcFewjYnMqOZaxjmYxCAaSTFG3xRX+TRzZb0hjbzbuGOPXvvQ2kscbdHfJdSURCVEdG
 mA8hU9sm8x+cM1o7v7l8ffvBi/It4Bv6kQ0OCKfWGjmYz2qT3SmeniG4VrJZU/yfpbS2Y+N2Ssk
 ZO6Wvak6Zv5k5JxQ+rKLU5rAO6CC2EVkv9SvpZ/02Ny10QbYl2Di6DPIoTqAyMw5Q2xAFNdlgzM
 sUmaSCoF1zmqoR1MD8jfIfN7Lnrazvv7J/d1xFMkbu0vTZ0esUqKriMTht1PZ7D2WU8c6+ngVCx
 0ufAM75b0HjXlkw7PWsytt53/7xIZXrLSNUE/CGakKsI+vpqv+6B5uBqt+RFvI0+vDWCJw1knV7
 DRg4TuqMSnt53WAPkuVRnZnCQHGsvstu68uJmpR4=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE2MSBTYWx0ZWRfX3VmQmOS1xwCR
 fEb+H2IsW9g+me5s77pGyXaQB2uD6kCdWjP6xjQ2kl31xi09ba4dipftXAJJfxe91e+vydFexQ0
 V12K09jq5mpvun/7DPj4SlVcV9jICxgdeR8ipjooH72Vo8V90Ek/
X-Proofpoint-ORIG-GUID: xwAVs9NP192bnzsMCmETGFMi1Iyq5YSH
X-Authority-Analysis: v=2.4 cv=EP02FVZC c=1 sm=1 tr=0 ts=6a8377af b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=cXhUbMmNm04wmYEBA-AA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12099



On Mon, Aug 17, 2026 1:15:02AM -0700, Marc Zyngier wrote:
> On Sun, 16 Aug 2026 06:33:01 +0100,
> Dongli Zhang <dongli.zhang@oracle.com> wrote:
> 
> [...]
> 
>> 4. Guest kernel changes are not included. I may send it separately to keep
>> this series limited to the KVM hypervisor.
> 
> Hold on. Do you mean you are changing the guest visible behaviour of a
> PV interface? That's an ABI. It *cannot* change unilaterally.

No, this does not change the ABI.

Taking x86 as an example, the Linux guest currently does not reset the stealtime
accounting metadata, i.e. rq->prev_steal_time and rq->prev_steal_time_rq, when a
vCPU is brought online. I meant to reset that metadata before enabling KVM x86
steal time via MSR_KVM_STEAL_TIME, so that the guest is not affected by a stale
steal-time value from before the vCPU was offlined.

For example, in the code below, the guest resets rq->prev_steal_time and
rq->prev_steal_time_rq after enabling KVM steal time via MSR_KVM_STEAL_TIME.

[PATCH 1/5] x86/kvm: Reset prev_steal_time and prev_steal_time_rq when enabling
steal time
https://lore.kernel.org/all/20260505003044.78693-2-dongli.zhang@oracle.com

+void sched_steal_time_cpu_init(int cpu, u64 steal)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	rq->prev_steal_time = steal;
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	rq->prev_steal_time_rq = steal;
+#endif
+}
+
 #ifdef CONFIG_HAVE_PV_STEAL_CLOCK_GEN
 static u64 native_steal_clock(int cpu)
 {


@@ -337,6 +354,12 @@ static void kvm_register_steal_time(void)
 		return;

 	wrmsrq(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
+
+	/*
+	 * This CPU is not ready to be scheduled yet.
+	 */
+	sched_steal_time_cpu_init(cpu, kvm_steal_clock(cpu));
+
 	pr_debug("stealtime: cpu %d, msr %llx\n", cpu,
 		(unsigned long long) slow_virt_to_phys(st));
 }

> 
>>
>> [PATCH 1/5] x86/kvm: Reset prev_steal_time and prev_steal_time_rq when enabling steal time
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20260505003044.78693-2-dongli.zhang@oracle.com__;!!ACWV5N9M2RV99hQ!Kt5J7E63dvSlZsI1Ovt02JMZuh0BwYZZupi0BMQXDxnYkQ6iPNwB7tuWgd7wSVOEVHCF40thrD8Apg$ 
>>
>> 5. There is one remaining corner case: this series resets last_steal when
>> the vCPU run PID changes, but not when steal time is enabled. If additional
>> host run_delay is accumulated after the PID changes but before the guest
>> enables steal time, that delta could be unexpectedly accounted to guest
>> vCPU steal time. In practice, this should not happen for Linux guests.
> 
> Why is Linux immune to this? Also, KVM does not cater for Linux guests
> only.
I should have explained this more clearly.

I did not mean that Linux is immune in the architectural sense, or that KVM
should rely on Linux guest behavior. The corner case I had in mind is:

1. The vCPU is run by a new host PID, so KVM resets last_steal to the new PID's
current run_delay.

2. The guest has not enabled steal time yet.

3. The new host task accumulates additional run_delay before the guest enables
steal time.

4. When steal time is later enabled, that pre-enable run_delay can be included
in the first stealtime update.

For the Linux guest on QEMU/KVM x86 path, this window should normally be very
small. For example, on x86, a Linux guest enables KVM steal time immediately
from the CPU online path.  Also, QEMU does not enter KVM_RUN for an offline
vCPU, so the normal QEMU/KVM hotplug path leaves little opportunity to
accumulate run_delay before steal time is enabled.

Thank you very much!

Dongli Zhang
