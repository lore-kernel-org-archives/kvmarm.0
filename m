Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C3388E67
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 08:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611527; cv=fail; b=uOyvzdft5HHsITxh1pHy8vqmQBPHneQc7YhajbrS+wftqhhz/DxrfxFZWCA+piDMT0yNKMn/UqQZTVaQeZWsh0bQrA+iQrJ5jHQIll7f0ZsdEz2GwZrkbWNMR2uEIglVGqD6QXoTfrD6CiTeFLwsbObbbGwl7zsPl8GZ4jQc5ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611527; c=relaxed/simple;
	bh=mUZMnL86NYQ7nX9gZSny2BJtHQbXlpqplZ1DO/ognGs=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=XGBK6MQkWE/6F2n+F4Q3nte6uNSP26F/NNxa8QnMA2MgIKxgZ+6mv1HKHUHU6ZnIrHb2dtNm/CVl9qUuvKunyKoxyfx5LGQ/Cz5Ktg3H2fT47aKVoO4q1tMVNCg6U/EST4s8KPWauMqeCepAHzExyKc5fZqYOKcRpRVaH63Taj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=orO8gmD0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BOu4zORM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="orO8gmD0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BOu4zORM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6247Vxn01135926;
	Wed, 4 Mar 2026 08:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u3quoeUvcg/pUOhB40pZrR9aZEnnH+uTu3wz3Hn6vyc=; b=
	orO8gmD00+WIO1mi25ro+avYnrfsxvkDJD4dEnuYU06utvLOs/fzzQJLzicKE9uM
	RDfaSs2d8S4ibhIgRrAY3U5wkz7Ov4GEj6vE/Nb1+46NQO/9h9jxMJDeSHvQUkGb
	D2bZJz5Tdz6kajJ467k6AQyYai8H67g098wul/u39ILfeashBidubXKWOyS6Tolm
	GmMmUs22D6UQMVgGcPV1Q1sZrC1K2pbYFr1eZyQwdXLjBUHmBZYqmlL0VDSgVIjQ
	JaBhvyXw8Jgwt2zaO4RRoZ86AqDuweuMjTVO4MPGtoU7eP5p+ep+R7ZRpOyiHrIW
	tsj3eA9nIfFBjnT1wwRz7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpge5g18h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 08:05:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6246UiEJ027460;
	Wed, 4 Mar 2026 08:05:11 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptb7ftq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 08:05:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHIO9OWEYrEIuwxxZg9q6NYQowkuxArFrCq3QK5vimbFk9Oys+pS6SHeVOHAYKOrxJ06XvKejIVGzjw3OSm1xjckM+xRc6T3sy/n2RGyhOUp+gX3KtZc9IW7IaPdRXwkqYCWXYLecp1O1z1V08/A27YGNjuDRw3e1fsIw8l41VYPasvB9mawY2ZwrtM2h5d+eaafVmOWJEuoJ3V15+7eZN/czKsVrlZxCBThNzZQJkhNi7wICP8twq1wbKetFEgEA0fsyy10sFWw0bvz0W5kXn9tgbpoGzeKnERtvIIBTQjThe1yoaNNi3qdwFyV28LsL7/UKapegvPFmKe2NHXX6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3quoeUvcg/pUOhB40pZrR9aZEnnH+uTu3wz3Hn6vyc=;
 b=sTCqx5GoObFBtXHI4N1L0cmO1l2/U1xFdrkfK1jdiQ13itTzAJL4kRD6/ELVNdpv5NzwWovlopDBLGfAz/GfAD3xvNgGeJsR1Tou2tsEPQ0RCFSrshRTgy0D2IQilyeMcVor1pX/uRRA0dAJveIWkdQistRUZd6svegXfrgOBwkuhenoinIo06AOTGgAjCp4bQLS8p+P+MF/mr0LK0LkDYnTPyrs5DCVW2//BZLkdckD4zLg9jFogcOqc9uFQIR8clHL08is3cjZAoxeCxw8K7r+KGnEY4FUa3/04cuMOSHpSnhvQxGS5b+ls4WKcXYeBxkm/GFmZIp5wwx1nNxSzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3quoeUvcg/pUOhB40pZrR9aZEnnH+uTu3wz3Hn6vyc=;
 b=BOu4zORMzDoMXjCk9nkNytO+VcveUHEoKrNR2t0Wi+sDbH8X5BP3OH6mHWHcw46CEFmQkCqthGaaesp8s/3breKeM28r3hDxMqPjSTcqkheZhAsUHXAy39RMM3D38lF0p2DKeMFvAq2QCDXxEqdm4svBxjs6Af3UJDAkJn3tcT0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7548.namprd10.prod.outlook.com (2603:10b6:208:490::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 08:05:06 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%6]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 08:05:06 +0000
References: <20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org>
 <aab0SvA0dU0R0pnl@willie-the-truck>
 <CAD++jLnhe_k1-eU90KjOi_Aj57S53a9GJoCZ-LTE0fz-TVSqvg@mail.gmail.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Linus Walleij <linusw@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose
 <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ryan Roberts
 <ryan.roberts@arm.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        David
 Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        James Clark <james.clark2@arm.com>
Subject: Re: [PATCH] arm64: Implement clear_pages()
In-reply-to: <CAD++jLnhe_k1-eU90KjOi_Aj57S53a9GJoCZ-LTE0fz-TVSqvg@mail.gmail.com>
Date: Wed, 04 Mar 2026 00:05:04 -0800
Message-ID: <87v7fcuij3.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0325.namprd04.prod.outlook.com
 (2603:10b6:303:82::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: d3efe2d9-3767-46fc-50c7-08de79c4bf05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	EViD5u5seWLqBnc4K65n9p4RySQLiZwVQ036RskA6MHCnPGovBMgCPzhX8/GrcR5nvTOlvpPoohnz1A7rV0IzQRkYkGgkaHZO0mhg6yL0ebMvnXiylXypuik/vUhKBWxKCCOBAPKSxwmlbpZ8kfUEaf7bdCxeu33Bt4vTshj6xa+lwa7+RhLpTft8f8EoInjbgVuBB+W8DPjx81tTTfZ51DUts2n2aVwki0/DwvSEk6yJ0DA9LBtts/1wdK0nv5zZctjppctw3TvOwzh3rw7brtEntNKXZuNDqAckif7r032O0lCYYuy1cDaYt3Dra1TOepump04Xx/UjE1+zdhqXmuyALI+17GH9xhcEFLM6DzCZo4vp1u5BhazpUbr4DDeSvqAvE0SeUHd5Rv0SczzepGXR8oBhB2j/6HILgeXO9Lh4g89WSjbN8Uup/Mvp8B67rprEMnTUaBEKvrN9tuU/dvJZx5h2qF5OcMHj3zD2qOu63dDQGkSb+GShHm0OBlpGdCr5ffX0gqzFbEi8KCatUxJnarl9mPo251386luRJlzYE+6Mo5RY631mcjNha64izaNmppzE3weWbvmV3brbkaRGL/oe+V/PPwVEXy5xcTmoHxLX9hPqKSJgszuovcRMptHuq2nNT5EVmJ2BBSmOmDPWyDR+frfvjDaiTAtfRfkL3FRq+C0nBMvbqymAgr+wzGAOvMt4vFohKT9Fn6KIk/Gq9aLZPD0Y8TvV/1hX6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmdxZHR3dGRqTUN2Y3lwZHhQNEFQeXAvN1IzQmV5SGtDcUZPTHZDdDQ5Vmho?=
 =?utf-8?B?WU1BS0ZVc2hiRUtxV2hCZ0hmbVRKcU1tZGNwTEVuNCt5ZnFnaHY1TzUvWHo0?=
 =?utf-8?B?QVU0Rm9IYnZYZFU0eTRsUTlmdjM2bXA1WEw0TkZXZ0pDZjc4UlVCWDdoYnBY?=
 =?utf-8?B?YzdQdWdKT0JZdmVWS2tlbkQxZzJzV2tERFVEM1V0aXVsN1VmQzA1eFVZMkxG?=
 =?utf-8?B?TFQva2lNampERm16ajFuMHNjY3hyQW1rYTFFUjdCNlA2NGRJNi9MZ21LbExp?=
 =?utf-8?B?aW1OanpaeEVmMUQ1UWtVNk5WMlc5amk5ZjBZbXp2UU40eWZ6amF0ZC9Fdjkw?=
 =?utf-8?B?Y1FGVjRzeWkzbHJpMTcrNlBNUDB2YW11VDJlSUhJR0tVQ0RFUkxNRlEvSnoz?=
 =?utf-8?B?bFc4L0UwR2JxL0I4VXpkK2plT2dFc2pxZnBBNnpTaW9tTmVJMGw2VG8xMGgy?=
 =?utf-8?B?Z0Qrc1Qra2pYcy9sR3k3WFFtUnkyVzF4MnNJb2ZNQmNEdUhhOGFwYmtwMFJn?=
 =?utf-8?B?RHF6dldHR0tYWk9FQ001a2d6dHJrQ2xiMUZJRVlpTHBOL0FWUFFadzV6bUZS?=
 =?utf-8?B?ZWx4WXJMY3R1anlrY3FKem1IbEtteDJzL01Sa2RtSEFPcUZnZGlYSXgrcHpQ?=
 =?utf-8?B?cTZIM3E1cWJEVmtUak5OanA0Tk1DbWQ0OTA1NVdkeS8ralhVRVJIZmx2L2gr?=
 =?utf-8?B?WkpJbXNlbnQ3VkNGTWs2ZUhZb24wcEMwZStld1NYZW9zZ2tBSlI3QXBScDVp?=
 =?utf-8?B?OWZlcHFsSkovM3d1cVF1TkRqNVdmNXljWGNjS3hPaE9aRkRnenRRMXlwL3U2?=
 =?utf-8?B?VmxnMFZoVFJFNVVJSXpmOWJwczgydHFXSFhJalFqQUNHZUZIMUcrbkVpdHVx?=
 =?utf-8?B?bnp0cXhZYVJtZXgxRys1aWpyaXl0dzY2MXkwak5YZ3Q3RjkvSW9WTzJUcnhv?=
 =?utf-8?B?dTF6MXVkV1NWbWZqL2tOcXM0aHVlbWViS0RkSTVBZzBIYkwrR0FtcmtaUmRB?=
 =?utf-8?B?MU5KTEovWXh4SHpyYytPLy9qY3ZzakttQVgxblAvRkZoNDNpc1Jwbi9OaFd5?=
 =?utf-8?B?M1dHU0ZueHZLMjB5bytRejJUZ29sTldvL0F1TEs2ZUIzM0U5TTdXNXppL1dH?=
 =?utf-8?B?NTFucUhnQkxoMmVEVXVUQ1ErcXREQTUvVG14Ris1ZzhjYm45YVZHRUdvVHow?=
 =?utf-8?B?aXBaMnpDUUEzN2JoeVBJRmVkelFoQWZoM2dZM3JYT3RNTjEzNnBPL08wYWlM?=
 =?utf-8?B?TzA4U2VWelQ5M1RmYzBONkt3Z1htT0d6c05nZUw0by9SZml5M3ZXSTVKUUdZ?=
 =?utf-8?B?b0dZV0VHdjBDL3lTVnBpN015Nzg4YWQ4RDdXMG8vMjZjU0FWUUF2S2hYVFdz?=
 =?utf-8?B?a0lqVjF4aDBxM2dHSkFUM1RIRjJKbHhUNktiV1NuT09SU0NUVGlhaG4zVzNw?=
 =?utf-8?B?anUzcXI2YzNHckRadnhjMmsxOUxmS0greW0rTUlqVkZrSjI5cEFMUTBoSnd2?=
 =?utf-8?B?ODNuRFpVYkMvNVVrL0pwZnpPMXEwLzVxRkZtN01BMGgrZ3RqemZaMVUweTdC?=
 =?utf-8?B?ZzVCbnpXK05qUVlBYkJ3NldsdFFvTFhVVXA5VWpHYUhPUzBtRnBsSUhrSEZT?=
 =?utf-8?B?Z0EwZDh6R3VBeEZ4TWNLT21NUE1NY3VydkpVbVMzb25BRGNGWFY0T1J5aEI5?=
 =?utf-8?B?UVdtMEFDZTFiN0VnYTcyamxNR0dINmdqZ01VME5NMjVsdDFpbVN0WHJEWVhh?=
 =?utf-8?B?SlREZlRwR1hPOEdUdzY0TlFJRW05aktJeUNMa2Ixc1h3VUNYQ0QrNUtIUE0y?=
 =?utf-8?B?MytIQVpCTmZuZzhtQmNNdGswVlR0MjlPU0IrbG42TFVCUVQySmhDS2NiTnow?=
 =?utf-8?B?SE9TMGpSblY0c2Q5KzhxdEF6UUtUMnpvTTlVM014aXJSazZYQ2pLa3I1NHhr?=
 =?utf-8?B?UUlRR1BGd0hQQ2VnWXZwRVdNM0UyUkhyb0NaeXpOdnYraW5rOW1SZnZjaDdu?=
 =?utf-8?B?R09SdUVudmU1WXR5eVlPWGZCMkNCclViclZSVkZGVFN5SHI4NmtOVXpLMkVi?=
 =?utf-8?B?WnMwTUVoWDF4c2crSCtGb1QzcDZxQ3JWRFd3ak82VDgzVUwwOWhGbnQzc0p6?=
 =?utf-8?B?WDV3SXRGVWtVUFVqT1pMZWt2OEtoZmtsT0dadTcxVldrN0tJWkZ0alBxRTJW?=
 =?utf-8?B?TEVSSXJXZkdwUytueTR6NnhyQzVuR0x3aXhhMmdkZmNYc3c2aHg3R0ljb3Fk?=
 =?utf-8?B?c3RrK1hpa2NIejJYSE9BSFIwQWVhQ3BnTWZycW1CY2pFUTFyZk5HYTRvRjdK?=
 =?utf-8?B?UWFlTjJzeVVtOG1mY0hjYXNPSmF4NTg0MVdCNGYveHFMNytvd3hoc0YzWGUr?=
 =?utf-8?Q?udlK0TUY5sVIApRg=3D?=
X-Exchange-RoutingPolicyChecked:
	Wr/HjjtnsiO8OmiqY7Ns78r0GB8bnl5hANaMddDBqd9Golwd7d11Gyj3fb7AvwJl1+i+SZkMkWGvLtNTh4q3UEHQ5qhy/dITRDM9PmaOBVETSRz0dtbSAE+rzx+xAOEPO+8vK5TrdSWx1gigUFf3jsGtZkOJEQqSEg4xoUr0ox6Cif5tNXBJy22W1njSnHbqsMVCbOYmaemMczIPh7cBqOpWKU3aBMs2Ac8NRzo/0cBEFLtZIhQyprbcZj9uZjYETdy7OYQlDQ+ZeouiNBzZcDYGvUrHyxyFO4OE7Nb+4mDi7HDX/czAVIZjbYgqeR9USSKxA9rKo0cWS8wN5Rw8LQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/DCJ2FcCTp6mo8zXise8BBDkSReA86RgDdzJdi1TmxOMVoVnFO8hXeTHq8sXIxyFao+lWCoTI8JtqsnlAo00AQeNArDAxL6iYmhMiwLGV1eiNcSJGY1NzuHvW7slqzPY5GnG71+y+7RPCilSkOmnsGm9OpDGDpKimyMhTs52NxEIJDY3zGHJNsdGtjMyZT0lpZFlTXzb1P53BqgQrlFs+bO8YuTd8X7HUQgORsO3KFiWqT8SXbBMkfgRkazloUhHQOucLDB/EKHGqx+CELX07fsr20OCCmDfGvuOFTNUjgodbOV1m3VxLbjchorWtgWs88aoQL7wVjJnnAPCu5ZceOFsq39wW9bkbjucJD/Y+q4Z9hqn4W6BxOsRFUCLV+25MJOU4HvX3HBP5bK6R361QZSnn9yeTFlfqY0l5cWmZVMd5UZ3I45Rs6Ii3pjLWmbyBkn5UBleIcHDv7o9QHa7pFr8oJDkYzfQVmaGhld70XUr6qlWDmAr3272LPJyVO3tZQ7q/EAB/0lVbZyarToEeJ8rE2JRNoFW10cGxCTDzmZb5Y+eK/l5uEXjBj6Eyp8vgWsuZHTKKomBCmctX7CD8fCj99PwFEYfKe96cJARigs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3efe2d9-3767-46fc-50c7-08de79c4bf05
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 08:05:06.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWNSI4eV6jbqoWTyghsrVrKFLyBuvxc7FitWYuaa2EY1QzlIiD/y2h8lrXY1YB/5zg7GTEIP728blnk1Fu46hEeXqgQiT4M7BPW1I+WBXgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_04,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040063
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA2MyBTYWx0ZWRfX/VoxYK9jD0gf
 6xToHWuRwFXmG03FL7B7tej0SZygvEYvZPN/0Bf98UFU0BGJrCq9W1blzTI0HMmylXq2HY4uu4w
 +5NutD4tbwRr6IwG80h3FayysuQ+ZSjqBcgBPOHQxGN3wlRGLjozc0YiTYbi07COh0nYeEwX/Gm
 u1ibBQIL2u45QmbdAkuzEFpHG56FlxzviBNa5q9YVQcyqkRNkIkNKBGm9B7T8Dm835KIi6keiok
 ryapCBFHc0iMqrgB9imA4CC2LXYbuPzPyThkF6rkJsYZf46s5RLsiEk+3ejlN5QMnfVdtMiMtmP
 ZzIzsJz5lZOmM8QN7GAqHcg0HjYxyCIISblzUdPPUT6LjILRCMt/dscawNsGKzAnjfPkaM0g9VJ
 ox5mFRIlJRZiWHahLzNK4J5rbgCZtzkbiRUY4W7wTcSdQQf9qxgEUwplucyjEQguOkvSxj6KQo3
 pVwFHNg42ZwA+Su9Ayw==
X-Proofpoint-ORIG-GUID: x1i-uCh8ERo6yU4CiKkdYh26aor6WJiG
X-Authority-Analysis: v=2.4 cv=XLA9iAhE c=1 sm=1 tr=0 ts=69a7e7b8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=Rm3cgVsPat493vJfkTYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: x1i-uCh8ERo6yU4CiKkdYh26aor6WJiG


Linus Walleij <linusw@kernel.org> writes:

> On Tue, Mar 3, 2026 at 3:46=E2=80=AFPM Will Deacon <will@kernel.org> wrot=
e:
>
>> > +extern void clear_pages_asm(void *addr, unsigned int nbytes);
>> > +
>> > +static inline void clear_pages(void *addr, unsigned int npages)
>> > +{
>> > +     clear_pages_asm(addr, npages * PAGE_SIZE);
>> > +}
>> > +#define clear_pages clear_pages
>>
>> Hmm. From what I can tell, this just turns a branch in C code into a
>> branch in assembly, so it's hard to correlate that meaningfully with
>> the performance improvement you see.
>
> I think what I see is the effect of #define clear_pages clear_pages.
>
> Because without that <linux/mm.h> open codes:
>
> #ifndef clear_pages
> (...)
> static inline void clear_pages(void *addr, unsigned int npages)
> {
>         do {
>                 clear_page(addr);
>                 addr +=3D PAGE_SIZE;
>         } while (--npages);
> }
> #endif
>
> So for clearing anything multi-page we get an outer loop
> and an inner loop inside clear_page(), but with clear_pages()
> implemented there is no outer loop, instead the total bytes is
> computed first (not one page at a time) and then there is a
> single loop.

So, on x86 (specifically on AMD Zen and Intel Icelake systems)
the extra computation, branches, and in an early version calls
cond_resched() after every single page did not seem to matter.

This is probably uarch dependant but seems to me that the cost
of an extra address computation or an easily predicted branch
would probably be just noise.

>> If we have CPUs that are this sensitive to branches, perhaps we'd be
>> better off taking the opposite approach and moving more code into C
>> so that the compiler can optimise the control flow for us?
>
> Hm! That would be to create a default clear_page() in
> <linux/mm.h> and simply delete the existing lib/clear_page.S
> and let the default kick in.
>
> Right now every arch is implementing it custom.
> Maybe for no reason in some cases, I could try it!
>
> I doubt the compiler would emit this part though:
>
> #ifdef CONFIG_AS_HAS_MOPS
> (...)
> alternative_else_nop_endif
>         setpn   [x0]!, x1!, xzr
>         setmn   [x0]!, x1!, xzr
>         seten   [x0]!, x1!, xzr
>         ret
>
> Three instructions to clear all pages. But maybe that is not good
> if this is a gigabyte, and the per-page loop provides a good breather
> preemption point in that case, and then we just shouldn't touch
> anything.

The code in folio_zero_user (clear_contig_highpages()) takes care of
chunking up the clearing based on preemption model.
The idea being that if you are running with preempt=3Dnone or voluntary
then you might want to call cond_resched(), say every 32MB or so.

If you are running with preempt=3Dfull or preempt=3Dlazy, then it would
just clear a full GB page.

That would need the set[mpe]n instructions to be interruptible though.
(Seems to me that that is true but maybe someone could confirm.)


Thanks
--
ankur
