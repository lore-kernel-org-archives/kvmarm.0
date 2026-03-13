Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013019.outbound.protection.outlook.com [52.101.72.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231303C7DE8
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773420754; cv=fail; b=keUGzZC5XvnyDGCFidQ6u9wfEYlmeD4kYmSAVoKik+TmHREc/gWFewBBt3RyLCDmsbWAOYbW0Njc+f0JjXQ94qpfSGRUoFnpeR+O4i5bHHijUa9eqQsa4/Vt2Hf21SWMYENffTge8WWqD+SadP9j0BcNYyLsIb916yjed4JNyaM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773420754; c=relaxed/simple;
	bh=QiFP6RL0fX9noba7YpsHHXMt9f5U17RondMoLxIyS3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c7iQW2gGq1oHrBlclwELVZOhfauTp+p4eOqhT9ll5Eb6CARK42Tc3Y892Zf2bcyELlN3EOoC0L8SbumecS6lftvXHAn0sUl4xRXR3U85IF4a4rS62pBhMbMefS77wX4BfW1BflLnnlRQ4kwfrVI6m+AJsSgtOumH5LnWdQO83CE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OdZcpmsY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OdZcpmsY; arc=fail smtp.client-ip=52.101.72.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OdZcpmsY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OdZcpmsY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ZDk1cUEGwaEIi9qIO+8vifKr52rbQWoFac/18haeqFX/JbmOkq9drvKpxZrQEhVvvr32W/MyFXPureLktgOMwLJ6aP5V7opoX18/Sw/3ZHIjApMJPOhkJuqEg5o1E4E2SCr797FgOWBVikxzZ/J6U/3P2aRrKtCzUIrn2Ic8+j8IKoiqTDKA3La+ULwvXk+k27tIOJqOCh34SsTjDw9c04BQCq34CJwcP8L/ss+8xs99Zpe9K4db9W3zpMfGEFWQZnjy870uxSvLzHgMZer61uTSvDpKaoJDg3zXZtMnHvaiauULUkJHw9l9isU6q3Xyyevb7OyKr0h6vZFWEtIuGQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiFP6RL0fX9noba7YpsHHXMt9f5U17RondMoLxIyS3Y=;
 b=IuHi0/7sMnjhzUdVrTY/67nYDPxPst3s/4wfgGU/aR0hc74QkxYHNAs4TAz+KSTNqp8mH1weCkKhMVu0VKf39MqI1cFAybcpDXaDBDWiiroXPEKYyMGsJj6Y3cUybKEB0gEsAITt+E27AmD21pMUmSGucL87+81FyEvcN0kswenBgKitscyZBE2UcuJzzwFAslZK3rX8fTF8ZuKaZ7My0QSOlRgON1j7tiQhXLbU4MV1w1EBAQpVJ4Es2MO5F5q2lb6aF595FcN6p81+I4FQrnZhIGHy/SvEDsuvSdZN1oN4A7maKKUXBZ3piwYTfEYPKKM1eymF6NR4LIdmBRmjPw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiFP6RL0fX9noba7YpsHHXMt9f5U17RondMoLxIyS3Y=;
 b=OdZcpmsYbgWNHplo3vlxbb79xIiqpw5gzx1Yr7tkcQis/HPH+3z2mBmORaHD7ueKI8LLTEDBGWRLFDs7YGprZ+eJt9J2j1CEJ1llySp+jNZF0a2vt8gOpXUDnnn4sshk7QKFrzUMhtDCKNg9lHm7E+qf1fbA/O/HzMAxlT+D2bg=
Received: from DUZPR01CA0292.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::14) by DB8PR08MB5339.eurprd08.prod.outlook.com
 (2603:10a6:10:114::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 16:52:27 +0000
Received: from DU6PEPF00009525.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::d6) by DUZPR01CA0292.outlook.office365.com
 (2603:10a6:10:4b7::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.16 via Frontend Transport; Fri,
 13 Mar 2026 16:52:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009525.mail.protection.outlook.com (10.167.8.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17 via
 Frontend Transport; Fri, 13 Mar 2026 16:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTB5Wng5KzP+tphrkCKWOPqMRZckRPUbfqLFkNb8h7cE1/e/7OuAQso/uiFQKYNsnnIgZ7YgL6KQBiTv82d7AuOQZWaMkVh7d6m8KczhKmEhAdyuuPcCVu1EQbcSkiww9KtoLO1dZ5l80k4gE1/yKrfP9hdU/GooGWBY3lU6wdZwiQj2r8KQXlXpafQguYXKd8qZH3xQAdnANS+3A+2PdVUy1/9ExWcX+edIRtKc8XlMFuXAFdd4h9JV8ZqbCX363x2v/pLCoYiQd5WBS5tE88TEqI58Od0HbtlsvtTL6H4uj+31/BKwm0t3UUIKtP3mAn1mxX+C5m8FltJ9T5wgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiFP6RL0fX9noba7YpsHHXMt9f5U17RondMoLxIyS3Y=;
 b=kpv4x8QUKTAGOQ6vkyftTcQfLtl0/Nd+K/Y5PWSQu/wDid+s4DXLwC/c+KiX1/aRULOTIOaNKSgBqCwqHv/PMUDWfNWuQJRc7h7Dj4vZwf+qWFqNESnMPYzACbLQtu7ITFb4XGbFOQBVMAvWmXaE9O8YO5ifqhigjtYwmkWbc/vbKzhoKERIuu5w9mpu1UZxGxBZUpoPFNDiHkQPGjND0CJavV2FTUL4ijVmpufhcH6rdjAoy+Blbi27zJA25QaXs6q9CtG/T8yWJU3cLGRANTfz0++ZM2FO4QiSSm9FBDulXtifLD2/o+8jfXPR3ZRLVHGDxg9jNUHG/BgXJoGjbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiFP6RL0fX9noba7YpsHHXMt9f5U17RondMoLxIyS3Y=;
 b=OdZcpmsYbgWNHplo3vlxbb79xIiqpw5gzx1Yr7tkcQis/HPH+3z2mBmORaHD7ueKI8LLTEDBGWRLFDs7YGprZ+eJt9J2j1CEJ1llySp+jNZF0a2vt8gOpXUDnnn4sshk7QKFrzUMhtDCKNg9lHm7E+qf1fbA/O/HzMAxlT+D2bg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PA4PR08MB6046.eurprd08.prod.outlook.com
 (2603:10a6:102:e4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.17; Fri, 13 Mar
 2026 16:51:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%4]) with mapi id 15.20.9700.010; Fri, 13 Mar 2026
 16:51:24 +0000
Date: Fri, 13 Mar 2026 16:51:20 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abRAiHC+si1/fmnZ@e129823.arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
 <abMDOC5DYEm74And@arm.com>
 <abPXrvl9tC+nv6q9@e129823.arm.com>
 <abQiSiX_xxjSY96-@arm.com>
 <abQlhhSDkmzUugMW@e129823.arm.com>
 <abQ-wLJj8MZfe5tS@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQ-wLJj8MZfe5tS@arm.com>
X-ClientProxiedBy: LO4P123CA0297.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PA4PR08MB6046:EE_|DU6PEPF00009525:EE_|DB8PR08MB5339:EE_
X-MS-Office365-Filtering-Correlation-Id: 2583d8a9-856e-40c7-def9-08de8120e892
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 EDGW3urSqfUsz6Hy7G+BSWUu11fF/2A2njyLvfQ8VIKQ6jq++Ly5iuvj9aJGHHFcP7ZtTMSWKkXAhLNCnqC+cjh7QBiNS2LKACgro4FPfXYjAuePjSPfc/N8KPt8z/TfGTdQyUAnNmMNER2F75XljvdktQZ/nr6g9S1/4GrGJ+nkCKEgTiAU4BqvyAdZjitO1i+n9yB7W5zvkXcLSUYyXOp/dI9k6ww1UcziJHxa1xMxroOBtrFqfeof7e3XIiaay+hDscZd7Z/cvjIUy6lXOsWE7CeL52q+BIrd7XhJcsY/iudxluPMj+LXhfcWxn65oKMno7iLkCg0vDUAHpLGPy28S3IfX6G28x1l7frWy2oq8x79jLpWn5Yd0OMdojGpLCH988fLuL/1W/7cbiCjx1LMeKQTtlaYj5RutqVIl3Hvu+lHKJBQ6/Px0XMDEjPn8N3gXy3m/EGL6pro0Ep2M/r+96ioUcs3unDs84S6nOsMprRNCKcLsZlgzBzFXwMz82stZM0MLl0UfULDRbFrEiEWbUJIFM6WBou0t/2WuVtQDGgs81dVI9fONi2BmjXgCS9dOP+97g+nwPv11IqLddksTyB78e88VGJK/7g2jCtBIeRZYlqweci/noxlj+iO66qZKf7MP84J1fowy7wLxHXvsRhKp/Yv1zWlTnaOGBwue5I6sGMJPGQ8VAAJ4nJpmjlLeNU3Z26HpIY9C8Xu1bbGbkLatw2n9f1pxmlN+pk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 cJgwrKxx2SKaaF6W7yu1nnMrtoxjOqYea/p1YnQZtLIexIfpwr/tx2bw8rnM/GeZJdwP9pYSMHBn9hTDRQ/5RoXVb/JmFVOJWWot7YJNYeuchDlnJ4FGD6jslTncC+N+A90fZhOHF097VN0ZREF/WWu7FnR1b3rg5u2axN8MJtEaylpCIR4bTawKygbFPAgzvKfSQkSlGsNOC83KUVZ6KDzHto1aqNpXNLTKqZcR756oR7NzTgzR4fIxxiUbV1JxPnxQWajzyHTDfyfTVldkcDHQfgClqmZ6lvBKtEV3Alg6PJjQ6C5QJagEPsE38wsVelg/YXDfqu/GOdymRNzksg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6046
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9819a3fa-6d07-46ba-4c6a-08de8120c309
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|14060799003|7416014|35042699022|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	PcTpEo6+qQ+IteNEwxgPIzalvFib58xwmIxciEQayYugUBBFn4nfmDLFM9kDnVXSV86hP3BgoHUSZY12jC1dqxqY0GKQ5p7YquCoL0oTOsbghBJXJ3T3n4zB4Dlwfr0tucUGaII+qZYF506TKbuxlip/RKCPae71e7I8AfYghcSUvHVYmDThe1gprgdG2mr2mNDgvhb7FJbPPz5OV0OrNDqj5t30GZydVNw0ldec9Ty3OjAYwko66QfOgiicbq4XizCQS0noU5YMddFpmAE7Za5TKXIIzcMc3aVD1o5nUhWJAYNPHFIaVrH2Vx95DIRY0IdO1CeBpRtjuA6I4Qnij4n2+WVetLJidtroxVVkaMQw1DhC4MC9AcJnGw8njXvFWUOEej2MaDOIs/rkLxFGnPh/XGzsg69qbhdkOuZqbPgV3CeS3EXZavz2R7nVa5SvGt9AiUnDs9PQ0mt7uXho69xreM1Ej7lRkHjHCQvgg2Gtt8Ei/U0nUAQE7+F3QoiIpRblF4gQFZs0L0smed+tm0/n6KZCW/q7Qo1qy86nC1BzWZY3jJZ47C178FaoRgJErrkwOYa9Vxy+m93O++Aqefy5MYx9vraIRClkmd4/dXwfh7QjlU3NdMk5hxCI8NCrEZPSv0yCx+H3+U3k3avYS6jFvmuN/0K/uL0aFq61ga2PLpXaqtsut1yccwF3GeTEKydmsrfVSspsKahP2uO4IdFw5EpjxP+pXHuALEYT1WFrlEFoJ9ovLFtYcl3MmF0PKUgOTXlpfqAa964GH4XewA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(14060799003)(7416014)(35042699022)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DjFV06PYfGR1ceFZlOKkj+WVGirf6iG/MUy6scsVyhcb1mrJ7psWiN2+k1lLEhd8DRvFzQVsY9kho6+DorTx98eWe3QWzmEK6oCpa2m/g8F3mpgR7HzK9i5DCfjKYAguWl/7sTUCPLdjDNs43Sr2bXreT0tyYvfafZKKBDRxcGtHsbEWhLumm+ExJs+R1RF9Lwm9aLf2ezBXLHiXA3Cztv/MB4vxsZOs9WSVgglXdI9vUammqxmVc4EfZvKYptssAeSevYqHl4ojPqb7Xlf3KHxNbfsMwbpgJSrXRJyTDfhObweMvXRlTlsyRDT3LieeIKt0zbiyNe1UuSVQVFv7TggGmxxajMMmfn5LHixOK3kP2HkXCGmCuZ7LYP6yWFp+PII9gr77igYw8zuiUhqDBZcOM4ekfA8r2cd0hY1UnUX8EP+xCbK/Fui4bfKvcnOi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 16:52:27.3003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2583d8a9-856e-40c7-def9-08de8120e892
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5339

> On Fri, Mar 13, 2026 at 02:56:06PM +0000, Yeoreum Yun wrote:
> > Thanks for confirmation, I've changed them as we discussed.
> > But let me sent it on v7.0-rc4 based with v17.
>
> No need to rebase to -rc4 unless there are some features you depend on.
> The arm64 for-next/core branch is based on -rc3.

Okay. then I'll send v17 based on -rc3.

Thanks!

--
Sincerely,
Yeoreum Yun
