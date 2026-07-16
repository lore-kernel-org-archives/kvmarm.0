Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11AD222590
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237996; cv=fail; b=Z4yvnQWc6bF8Lz5/7dV3G0o+xRXQa2ZoP3CFfdrSITBYVE+CN7JlZeW7SNJYWHiadvJIjJwcpF2i22uAS43UOrEGOpPO9TB5sVq9g6vKfKcwP21IOSkYbh9o6mu+UN/qttP7aCbmM8ahvOyj0CVX/xmtuuZx3S4PX86g6JQuPuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237996; c=relaxed/simple;
	bh=lmz9FDhr5ZITm50a8kduij2V03k9AvajSzpN21Gzatc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G3oVPiEycAzUkP1/v9p0y2cBF9VZ0MG0QhxaM/jo4oVv3sLzn+R/WMGMcMEy06WqtF5x/fvecPvdymxMCEagceZSsvfgJIzTbEP42Dh/oRZWg+QN8GSQbcldEzRRBTcv9V6aopipC4PxidfRS2PSEbq9khpasU3iitEhDECvXos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KFzUyrNS; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jAsuTCZe; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KFzUyrNS";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jAsuTCZe"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJrZhs1763910;
	Thu, 16 Jul 2026 14:39:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=CIhWjxN7iV8eSrFYXRkDt8l/u/0uuUaPxQMX3ofgZ
	fc=; b=KFzUyrNSJnMAqiK6YKRP3ChB3grMtI7fKP3xedS21vN/yZAobVLRJPUNG
	taJKIhGNzCuA31Du4HD4G/f9HaqVUL4wnji3s9SHQnvC8nxlFs4jN04VXk0/9xTe
	KH9w3A2Gi38spZWZ95Pt8+LsGalGAMjbfCMctLrREa7dbhOJAyk8sjRzOnkigQIA
	xBM/kPjNjJcvIZ6/n2zOmOSSCRVKv6HliHq5pgV0nJDCxWQuh4Np5/HTkkKcRUOs
	gF2fMFDu6/hGuJeJURDg8KWlXexJc/EPX/RXAZEiZuKO9jHm2sqEerwYAgDyo3nx
	a+NnVYcYyLKg9kHw4ZYGZT0ovaVxQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020094.outbound.protection.outlook.com [52.101.46.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4fdstheva0-10
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 14:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mu2y+DcoSY2O/LgTQKQxK8MB1zIeP+JcXUmNrOWvAw1UaK6Qn2Gryk60BzdO6mnsTcMwlDhjyvE3v7c7DTpG0DvH1FX44CB1DzmW97jQeqW0abJDgBsmUZuCUctqmC44i3tkpBaqSvf+bedlKqdJEJEtvkfKUMmXfV/RphIWesbD3qHBdUB9L8i4yiUpSJC+1pq4OkMwXNY+FWSB/Z957gQo4sSPTQ5dvZNzLvPsKdxEjmqDyAlQ/7wQgy3aHFeWFANsu8NrAOzndeGzKlDH0+1vzuhsxO9+3n9FDSFCY6+s6fasRJMat+wAlwNvK9YFl3yenvGiqdloD4X2/1SItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIhWjxN7iV8eSrFYXRkDt8l/u/0uuUaPxQMX3ofgZfc=;
 b=CGoedq2eKsmN6Vk2SOD0NQ4TNQtsMFK4GFghixDRAVXDJgSJbvkCnrLUHbwDjVUugOCQmeOLx00lEbC1PJG5lQir2Q6L8f4D9Idfg0oIcNt+mR0pitnlnsWA8xZ//dqnJKxIiwLnGCPrFTrZoS7YwREfS0CcvjMnVba3QRnZ+vSxAiP0ejx6M43HoSJimHMJ1Ko3nsJDpz9v8jH8OWc5MriFDRM0NJIoCkvi9LxwjGZa8z7qojeCXFO6tWWzVKwg+aJs4bID8NorGkEYS0EvRouNoMfZ5TGR0QIQ50LwUwym55o1RNU9ikOrjqtJEquBwRnBHiYKZ+E71nYvL5GiOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIhWjxN7iV8eSrFYXRkDt8l/u/0uuUaPxQMX3ofgZfc=;
 b=jAsuTCZesoBp+kbFRcp/PgFWJpwQP9ztZtkteoCLKcg3mMqKg9gy9eGTqzC2QH7Y+ctPh58fA4G+XQyHsTTV0QQyRvX3Cf+CpYeMuiVpc1/zdAP31Yv/kECH39ldBiMxnu/fRKtacINhQvTWB57XlorbLzTcmX0PPvtERZTgGGb00IUiEJwbbp1QWNdAI5iFUB/yWTkGEwL+lQgUMNPJiJNPe08IXEDSljUiLVid83wHfQBGN21spLazpZcbNUoG55MlVhjWoxqbKZxslGF46wsmEf1zE3TdGEFPx6Wx+ni4M6ZHZjB7lcHyQLnWPAjR78yzp8OpMOx/9NQkRr14pQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA2PR02MB7756.namprd02.prod.outlook.com (2603:10b6:806:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 21:39:34 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 21:39:34 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
        eric.auger@redhat.com
Cc: cohuck@redhat.com, peter.maydell@linaro.org, richard.henderson@linaro.org,
        maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com,
        abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com,
        skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com,
        philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com,
        mark.caveayland@nutanix.com, khushit.shah@nutanix.com,
        prerna.saxena@nutanix.com
Subject: [RFC PATCH v3 09/19] target/arm: Add named cpu model infra + graviton3 named model
Date: Thu, 16 Jul 2026 21:38:48 +0000
Message-ID: <20260716213858.609699-10-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260716213858.609699-1-khushit.shah@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:510:325::28) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|SA2PR02MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df5b58d-427b-4f97-5e3f-08dee382ba0d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	uzdalSaOPHKYLWPOFGS8SHln8BmQ+dRhFn43Bx/Lq2HBMPCd4wMkk8WOBq9tFUQOcjNTyC2AQjBSAhZyif5mRN6Cxl9drW6u2TLTX8sT/jBAjIY55CIPrEXKUOpJUSyBvQJQMZp3WjiiSzGLHVVmNhfV0SgeJudEp7cKi+NxoQ/guPxfTzS53jhap+7dZO7Bs8Qj6h4vudbTJrkYsdy36DNPn1Jqh1jbHi24YXQDIqJ5aI2o0AxLjkTq/zTa4S3BXI8ExxRHhyu9pveDz9lyIj77SQrGAQM0sRbyQMTglVrFVnhUHApylWj3RPuVUTQd3YpJP1L7RKdAOiWoWvKdv8/8rt7e+oaHiNfnxAAhBWIUp0Be0p3rbu8TeJZsZ23fxDnBcpwVaRofHCc4+Zrq94F0SqPOERDUr/0j4frKN8I5YrV2x3nG0SKpqA9ZJMshQcdhSMWF7imuD0eKKnEjiS3/EUC81GKUId6+tN0q8KAIPwiwAw2tPoebYHZMkHSHxrLErAQNGE0AKo6T3wzY6qeF6hM7fACEy5Q0oNoKO/6enYCdV38Fg/2kP9VtUe37KAPubO1Ef2UPw2lEOzibNTzW8ENclIsBRdXbMOuS8ZvWeh/ZscC0q67p73isiZ737/7wriE7YbJZeWTN5YtJ1Dbzw5OT1goyeXdx6YBsXvQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5x/yjLWNOJyjaCLzgjEwehTRX5eCoUe4MKOesb9Uoe4Z/2G+NwkXiq/yOviZ?=
 =?us-ascii?Q?aWl2kCVCW+NF3NGDvVNesA8QLwBWrWNMY3chFI5iD1dTuYekMrlBiFeDo1Fw?=
 =?us-ascii?Q?M8c241qpu+Gxzr6w05EJIj0leTg4+JwgDRDKSbDl2c1Zf0GwJ6QmEGwA2SJe?=
 =?us-ascii?Q?OpLd5BQegotA1EzZBaz78Di7bbSCFreo1UXqXoqMR4Ws9ApI2DsY43K3fNKK?=
 =?us-ascii?Q?KeoYf+ysRZ0wUDqGP7JY5DoMp1bAHQZ8vJ/JCCR9vNGhiJQU7O44oWVZXtpP?=
 =?us-ascii?Q?ap48SS75Q82cSYZbNV3V6F+g/t9DSexSvlMulF6fkn8QWZ68WbcS2tfZCELF?=
 =?us-ascii?Q?rUMQxKodXq73QOM4mY8VNn/QIdM/bHrkunhUbV6Cap4CoDwL/TMEggsaqJ/A?=
 =?us-ascii?Q?mnyWfl9Ah8lZYSWl4iS/LtKoxorKw5uUdjl8K9/XLB1s6lDrdrjWhNGkzdMA?=
 =?us-ascii?Q?NDF+MY/y+C0txpiuvh15/UbxQpoN5z1pa86WGvHDZSC7Y46EMRtcmRFaovFo?=
 =?us-ascii?Q?SOdJftYCkcBdEeUt4IX6nujbzTh4K8ZB+Xp5tf06DHwvE/T8p1iG/5jPoXqX?=
 =?us-ascii?Q?/3Ijl/I8OGam1Cx2LtS9K821MFoR27SZU9kfu8MaB3Sv/ftGen818BMavfer?=
 =?us-ascii?Q?+fhpzzIA+YwQICDvpGQiTIKADpowxpHIyTTPpcbhsd0OJhjjqY+0yEw7OJqg?=
 =?us-ascii?Q?hH5hwfKpuL2gcYDdACFzM2WhYMaLylJCT+xVZG74Lg1zh2H/pJqFB32/avdC?=
 =?us-ascii?Q?oVY3izEoeyM8q0ql4UEmwIfetPCIQRV26PyRQT/AAefG+VamxxfEe689hMwl?=
 =?us-ascii?Q?80P4+on1u94OptakOOODPfZ6+jhiTO4HupCRi4usOAff8iowiljFB90BesqW?=
 =?us-ascii?Q?AwJ4CZWLtK5ymEH5L1F9W7Pmwtya81lM0KYnnZ4DyRv7vRx7MIU5jRgXIwdV?=
 =?us-ascii?Q?7IPp4unZydfIvXq6OhyBnxsNaejuGzz6hY7NCIus9Urbo6n2bVwbeFlS62Hu?=
 =?us-ascii?Q?2uorRjWDGoqn9J/dmvk3GC6Bv6HOGF2bXghOgiVST0YoBttQln/HOpsy2ibj?=
 =?us-ascii?Q?b3JW8Lw2Xp/iQdwboVx4TdribRQreBUEKb2d9LYZOv0IiO5Tcq+GpKL7kQeK?=
 =?us-ascii?Q?8DP4wNtSinhk+1DasfMKROyEqnGFl1Tn+AdLcXIVbPPHEpdfPmVz8ijxS/Xe?=
 =?us-ascii?Q?TiOgmDAlSOSsWloLzRgNVtuf4+vVIE+3/cDlDrbRDtrw5J/GdNNpQjdnK6sE?=
 =?us-ascii?Q?EkdgUGr2WJz/yvBGoB5ZIuqNy+2Ka0hU3vAVysGxjHbd6Ur0dLwBwaN3z7Hx?=
 =?us-ascii?Q?Vk6XTxeM2a9bZtJx4gPRTY6JoL8Ts7NhY49ZZG4CzvSIHz164xi3lRW2G4H8?=
 =?us-ascii?Q?nfqv/oAIalE6heN2d2RJQd4SUSh39FWFi6dq7rRRlzMaqOb0gW1ZpCjFmvzA?=
 =?us-ascii?Q?ydsFmvD8VLWf9LWvbS4crEh1Ux5BMqYtPxdfCOJcR+h42iQtFJBKmIenH9mS?=
 =?us-ascii?Q?PRbrpD+8B20E4qRYHKfiPidjFVVp0PZeO7cxBIRWIKE44j7VaNlktYpA5EfA?=
 =?us-ascii?Q?d0K25ctK58LQL8rteSwuL0SOREXzEAfFi+5eQOotyd6oS/GzhK9bXs2DzRMo?=
 =?us-ascii?Q?35X+nxATjOKCZ751V5I/Qim1mo/cPcyp5RXfG7+AdfwwW/BNmLZbEHx39NOu?=
 =?us-ascii?Q?cDG4QkdgWvRQq0vhgOm6AZiuct8ZMjyDwPug+DksiBpTdRzSO7sA/phMLMsI?=
 =?us-ascii?Q?NxRt5+SXZAbrnfMPQKvAQinU/eD7SyQ=3D?=
X-Exchange-RoutingPolicyChecked:
	APUZY8GcCihNYUHxB3ZZMN9NZ54bDNRgG5x6N8Q9w/r2Hwug3/N1YmLWW5XFZNTC0oZO1Zor418zU7K4yb1NlxoNklB4y8c+GFYtEFcb6Ddj5qdJks7JFra0ZnNRTYah7h0Q+peeYNzbKiJcpDlLzl8mrspMFApAD1moSmCPGLqSe6rJ1TDuCHwCgSRXVZDwOb5k2e4UpadCXhMgp1D5Bx0lwp6FliwgaMlbThwJNb2z0ETvgvt0KDcbXIzPDoL88tPsnKqbhNBGqJQ2DgPbEgGslZZ0/hvXCZ7fjcwoEbPcNvF9mGAaPHczfIr0MBkgi212D8fo521ITiWcsfg4nA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df5b58d-427b-4f97-5e3f-08dee382ba0d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 21:39:34.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpxj2X1QSWXCA7huP0UNfQgKpkFAlRSX3aHZ2qa4CamN/y8ZFsdcF0UpbJE/KVkG34f8+9B6v2ijwGbivvQ/TnJZmRlXv3BWShBOtPilXoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7756
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXwrRqNVtTjGvx
 x37A6RreWysVwwejmyExXTqbYMHnrr/V4Kv1hyz2yyydEHT5/kimaL9XTFOROYkP1NyZTA6Ut7Q
 Jay8BWNylifQdmJdbT5Iu7Q4nou70+wl6Hvtoo83o/V7N8ZbfuPQow0e6XTf5ovd27e6gGvlp39
 KRb2SoLF2M3GrViXOjiY15X7UiFPhJhPLCAJ8acKTY/C6cGmHZ33Dbw3W+SKqxdbE3VP13mduP1
 MFvl98ECnODIWPCzrMSpSNoGXGC7z+kjgyVvVyvQ8+dDlOA8l9pzPbxS5sZfnlPlm36zz6D/2Q4
 eTKK8iQDFwsPSHKRT5sGGw0lVaelkxQipTAuxuRGt3lx6DLMbD7nMBTh10QuKI/BREIFJ4lsEQX
 c/YbXhebBUC6YMY+M1F6gUhPp2nxVepnxabKv2i5PAPJ9pXZmFFV9D3l8SvALlHn1+2fgwiQBTf
 64BKky+RAQ14yJHLpZw==
X-Proofpoint-GUID: FpvtAtBiVYisrUKQwh-22vFhKzrAfIhi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIyMCBTYWx0ZWRfXx7RvSGYKXecX
 T57NGYvU6n6+jxkpCX1PXEUlq5s+HjapfffsXP4ro5rv2S1qlV5SwIgQyZSLWqZV5OlNhSVSslW
 uGP0tQhAXo3DiCVCHRM+cqUST/6YtNI=
X-Proofpoint-ORIG-GUID: FpvtAtBiVYisrUKQwh-22vFhKzrAfIhi
X-Authority-Analysis: v=2.4 cv=J8uaKgnS c=1 sm=1 tr=0 ts=6a594f9a cx=c_pps
 a=aWGlcXfvBePkFyJsMZzBEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22
 a=64Cc0HZtAAAA:8 a=W77-Ua85cY-YALAvpcAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: Shaju Abraham <shaju.abraham@nutanix.com>

Introduce a small named-CPU-model layer on top of the field-backed
property infrastructure. Each model is a flat table of (name, value)
overrides and a parent pointer. At instance-init, the parent chain is
walked root-first and every level's properties are applied via QOM,
so a child entry overrides its ancestors for the same name.

For example, the graviton3-v1 named model hierarchy is:
non-zero-defaults-v1    Known non-zero default ID regs field values
  arm-v8_4-a-v1       ARMv8.4-A architectural mandate
    neoverse-v1-v1    Neoverse V1
      graviton3-v1    AWS Graviton3

non-zero-defaults-v1:
   Field that should be populated with some non zero value by default.

arm-v8_4-a-v1:
  Only features mandated by the ARM ARM.

neoverse-v1-v1:
  Reference manual derived feature values for the reference core.
  Values differ from TRM values based on what was exposed to the guest
  with -cpu host.

graviton3-v1:
  SoC integration choices (crypto pin, cache hints, PAuth alg).

The model values are figured out from ID register dump visible to
QEMU with -cpu host on Graviton3 machine.

Model realization:
1. Zero out ID regs array.
2. Add all properties to the CPU Object
3. arm_realize_model_chain: Walk the parent chain from root first and
                            apply all the properties.

Co-authored-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 hw/arm/virt.c               |   5 +
 target/arm/arm-cpu-models.c | 336 ++++++++++++++++++++++++++++++++++++
 target/arm/arm-cpu-models.h |  35 ++++
 target/arm/meson.build      |   7 +-
 4 files changed, 381 insertions(+), 2 deletions(-)
 create mode 100644 target/arm/arm-cpu-models.c
 create mode 100644 target/arm/arm-cpu-models.h

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index fe19030886..34e56dc1f1 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3812,6 +3812,11 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
             g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("host")));
         }
     }
+    if (kvm_enabled() && target_aarch64()) {
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v8_4-a-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1-v1")));
+        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("graviton3-v1")));
+    }
     g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("max")));
 
     return vct;
diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
new file mode 100644
index 0000000000..747e0df010
--- /dev/null
+++ b/target/arm/arm-cpu-models.c
@@ -0,0 +1,336 @@
+/*
+ * ARM named CPU model definitions.
+ *
+ * Each model is defined as an array of MODEL_PROP macro, listing only
+ * the properties that DIFFER from the parent model.
+ *
+ * At realisation the parent chain is walked root-first and
+ * every level's props are applied via QOM, so the leaf's values
+ * naturally override its ancestors.
+ *
+ * Hierarchy:
+ *
+ *   non-zero-defaults-v1           Known non-zero default ID reg field values
+ *     arm-v8_4-a-v1                ARMv8.4-A architectural mandate
+ *       neoverse-v1-v1             Neoverse V1 (TRM 102649)
+ *         graviton3-v1             AWS Graviton3
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "system/kvm.h"
+#include "cpu.h"
+#include "internals.h"
+#include "kvm_arm.h"
+#include "arm-cpu-models.h"
+#include "cpu-idregs.h"
+
+#define MODEL_PROP_FIELD_STR  str
+#define MODEL_PROP_FIELD_BOOL b
+#define MODEL_PROP_FIELD_NUM  num
+
+#define MODEL_PROP(_name, _type, _value) \
+    { .name = (_name), .type = ARM_MODEL_PROP_##_type, \
+      .u.MODEL_PROP_FIELD_##_type = (_value) }
+
+#define MODEL_PROP_END  { .name = NULL }
+
+/*
+ * These fields should be populated with some non-zero default values.
+ */
+static const ArmModelPropValue non_zero_defaults_v1_props[] = {
+    /* ID_AA64PFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL0", NUM, 0b0001),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL1", NUM, 0b0001),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 0b1111),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 0b1111),
+
+    /* ID_AA64PFR1_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0b1111),
+
+    /* ID_AA64MMFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0b1111),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0b1111),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 0b0001),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 0b0001),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 0b0001),
+
+    /* ID_AA64DFR0_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 0x6),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0b1111),
+
+    /* CTR_EL0 */
+    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 0b10),
+    MODEL_PROP("SYSREG_CTR_EL0_RES1_31", NUM, 1),
+
+    /* ID_AA64MMFR4_EL1 */
+    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0b1111),
+
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue armv8_4_a_v1_props[] = {
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_CRC32", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_Atomic", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_LO", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_RAS_frac", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_UAO", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_CnP", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IESB", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_DIT", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 9),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_PMUVer", NUM, 5),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TS", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_LRCPC", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_AT", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IDS", NUM, 1),
+    /* KVM zeroes out these field when MTE is not enabled. */
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0),
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue neoverse_v1_v1_props[] = {
+    MODEL_PROP("SYSREG_MIDR_EL1_Implementer", NUM, 0x41),
+    MODEL_PROP("SYSREG_MIDR_EL1_Variant", NUM, 0x1),
+    MODEL_PROP("SYSREG_MIDR_EL1_Architecture", NUM, 0xF),
+    MODEL_PROP("SYSREG_MIDR_EL1_PartNum", NUM, 0xD40),
+    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x1),
+
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_BRPs", NUM, 0x5),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_WRPs", NUM, 0x3),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_CTX_CMPs", NUM, 0x1),
+    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0xF),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RDM", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_DP", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_FHM", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_JSCVT", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FCMA", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_BF16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DGH", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_I8MM", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_RAS_frac", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_CSV2_frac", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1),
+
+    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_SSBS", NUM, 2),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_PARange", NUM, 5),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_ASIDBits", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_BigEnd", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_SNSMem", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 0),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HAFDBS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VMIDBits", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_VH", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_XNX", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_SpecSEI", NUM, 0),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_FWB", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_BBM", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_EVT", NUM, 2),
+
+    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0),
+
+    MODEL_PROP("SYSREG_CTR_EL0_IminLine", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 3),
+    MODEL_PROP("SYSREG_CTR_EL0_DminLine", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_ERG", NUM, 4),
+    MODEL_PROP("SYSREG_CTR_EL0_CWG", NUM, 4),
+
+    MODEL_PROP("SYSREG_DCZID_EL0_BS", NUM, 0x4),
+
+    /* pauth */
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_APA", NUM, 3),
+    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_GPA", NUM, 1),
+
+    /* sve */
+    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_SVE", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_BF16", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ZFR0_EL1_I8MM", NUM, 1),
+    MODEL_PROP("sve128", BOOL, true),
+
+    MODEL_PROP_END,
+};
+
+static const ArmModelPropValue graviton3_v1_props[] = {
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_AES", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA1", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA2", NUM, 2),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SHA3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM3", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_SM4", NUM, 1),
+    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RNDR", NUM, 1),
+
+    MODEL_PROP("SYSREG_CTR_EL0_IDC", NUM, 1),
+    MODEL_PROP("SYSREG_CTR_EL0_DIC", NUM, 1),
+
+    MODEL_PROP("SYSREG_REVIDR_EL1_VAL", NUM, 1),
+
+    MODEL_PROP_END,
+};
+
+static const ArmNamedCpuModel arm_cpu_models[] = {
+    {
+        .name   = "non-zero-defaults-v1",
+        .parent = NULL,
+        .props  = non_zero_defaults_v1_props,
+    },
+    {
+        .name   = "arm-v8_4-a-v1",
+        .parent = "non-zero-defaults-v1",
+        .props  = armv8_4_a_v1_props,
+    },
+    {
+        .name   = "neoverse-v1-v1",
+        .parent = "arm-v8_4-a-v1",
+        .props  = neoverse_v1_v1_props,
+    },
+    {
+        .name   = "graviton3-v1",
+        .parent = "neoverse-v1-v1",
+        .props  = graviton3_v1_props,
+    },
+};
+
+static ARMCPUInfo arm_named_cpu_infos[ARRAY_SIZE(arm_cpu_models)];
+const ArmNamedCpuModel *arm_find_model(const char *name)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        if (g_str_equal(arm_cpu_models[i].name, name)) {
+            return &arm_cpu_models[i];
+        }
+    }
+    return NULL;
+}
+
+static void arm_apply_model_props(Object *obj, const ArmModelPropValue *props,
+                                  Error **errp)
+{
+    const ArmModelPropValue *pv;
+    ERRP_GUARD();
+
+    for (pv = props; pv->name; pv++) {
+        switch (pv->type) {
+        case ARM_MODEL_PROP_BOOL:
+            object_property_set_bool(obj, pv->name, pv->u.b, errp);
+            break;
+        case ARM_MODEL_PROP_NUM:
+            object_property_set_uint(obj, pv->name, pv->u.num, errp);
+            break;
+        default:
+            g_assert_not_reached();
+        }
+        if (*errp) {
+            error_prepend(errp, "property '%s': ", pv->name);
+            return;
+        }
+    }
+}
+
+static void arm_realize_model_chain(Object *obj, const ArmNamedCpuModel *model,
+                                    Error **errp)
+{
+    const ArmNamedCpuModel *cur, *parent;
+    const ArmNamedCpuModel *chain[ARRAY_SIZE(arm_cpu_models)];
+    size_t depth = 0;
+    for (cur = model; cur; ) {
+        if (depth >= ARRAY_SIZE(chain)) {
+            error_setg(errp, "model '%s': parent chain too deep "
+                       "(possible cycle)", model->name);
+            return;
+        }
+        chain[depth++] = cur;
+
+        if (!cur->parent) {
+            break;
+        }
+        parent = arm_find_model(cur->parent);
+        if (!parent) {
+            error_setg(errp, "model '%s': unknown parent '%s'",
+                       cur->name, cur->parent);
+            return;
+        }
+        cur = parent;
+    }
+
+    while (depth--) {
+        arm_apply_model_props(obj, chain[depth]->props, errp);
+        if (*errp) {
+            return;
+        }
+    }
+}
+
+static void arm_named_cpu_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    ARMCPUClass *acc = ARM_CPU_GET_CLASS(obj);
+    const ArmNamedCpuModel *model = arm_find_model(acc->info->name);
+    if (!model) {
+        error_report("'%s' CPU model entry not found)",
+                     acc->info->name);
+        return;
+    }
+
+    if (!kvm_enabled()) {
+        error_report("'%s' CPU model requires KVM (-accel kvm)",
+                     acc->info->name);
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu);
+    if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
+        return;
+    }
+
+    /* 1. Reset ID regs to 0 */
+    memset(cpu->isar.idregs, 0, sizeof(cpu->isar.idregs));
+
+    /* 2. Add sveNNNN and SYSREG_ properties */
+    aarch64_add_sve_properties(obj);
+    aarch64_add_idregs_properties(obj);
+
+    /* 3. Realize the model chain. */
+    arm_realize_model_chain(obj, model, &error_abort);
+}
+
+void arm_register_named_cpu_models(void)
+{
+    size_t i;
+    for (i = 0; i < ARRAY_SIZE(arm_cpu_models); i++) {
+        arm_named_cpu_infos[i].name = arm_cpu_models[i].name;
+        arm_named_cpu_infos[i].initfn = arm_named_cpu_initfn;
+        arm_cpu_register(&arm_named_cpu_infos[i]);
+    }
+}
+
+type_init(arm_register_named_cpu_models)
diff --git a/target/arm/arm-cpu-models.h b/target/arm/arm-cpu-models.h
new file mode 100644
index 0000000000..ac4e510499
--- /dev/null
+++ b/target/arm/arm-cpu-models.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * ARM named CPU model definitions - public API.
+ */
+#ifndef ARM_CPU_MODELS_H
+#define ARM_CPU_MODELS_H
+
+#include "qapi/error.h"
+#include "qom/object.h"
+
+typedef enum ArmModelPropType {
+    ARM_MODEL_PROP_BOOL,
+    ARM_MODEL_PROP_NUM,
+} ArmModelPropType;
+
+typedef struct ArmModelPropValue {
+    const char     *name;
+    ArmModelPropType type;
+    union {
+        bool            b;
+        uint64_t        num;
+    } u;
+} ArmModelPropValue;
+
+typedef struct ArmNamedCpuModel {
+    const char              *name;
+    const char              *parent;
+    const ArmModelPropValue *props;
+} ArmNamedCpuModel;
+
+void arm_register_named_cpu_models(void);
+
+const ArmNamedCpuModel *arm_find_model(const char *name);
+
+#endif /* ARM_CPU_MODELS_H */
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 64d1ec63ab..72eed1bcc6 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -10,7 +10,7 @@ arm_user_ss.add(files('gdbstub.c'))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
-  'gdbstub64.c'
+  'gdbstub64.c',
 ))
 
 arm_common_ss.add(files(
@@ -21,7 +21,10 @@ arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
   'cpu-idregs.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
+arm_system_ss.add(when: 'TARGET_AARCH64', if_true: files('arm-cpu-models.c'))
+arm_system_ss.add(when: 'CONFIG_KVM',
+                  if_true: files('hyp_gdbstub.c',
+                                 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss.add(files('cpu.c'))
-- 
2.52.0

