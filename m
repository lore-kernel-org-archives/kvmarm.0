Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2070.outbound.protection.outlook.com [40.107.104.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B0118B488;
	Tue, 15 Oct 2024 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728985837; cv=fail; b=sk9jn5VOEOV7ARh6GBWOmJ8YQA/urhE3qQ7UAK8+FBsvJt/PyoEaaiNAbnIAUyd/pz33cmkcPuXMU00nE8mbB4BYJNCakLgBzMAPi6AxCJTkvszxjNLMI00Hwt3FAN625vNYC+hdI112P///FEIAG26IQfMtdLb/gdzOy84pFCo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728985837; c=relaxed/simple;
	bh=vUbDwPDWuiRhAFzxehmVe8id1VXWxHNjRCSkQ3LDylc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P7F5qC7rlWD7kAK0nuEwvZ39PkjZO0zwefFXHg44oGSzOHaMkH8Kk9ecfiL59MtMf+NiqrtE0iF9WsD0o2w9SPW+FgOV3igNhXB4qMuAq+c/cepPD/wBXsOcDKlqqJGo9RkWaTpA7ffL/z/puMdDJ75YOdFEzUvPj3qK8mmnvPU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V198M1GC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V198M1GC; arc=fail smtp.client-ip=40.107.104.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V198M1GC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V198M1GC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=H7bDGssI0jFXM4jc5G0nXg7r/+lQwz9avnUlN7ce3ZjSL0k+qXuBiArOzacTOdUfr6+nBZT4d5tAUqDXN8AcNDSEJDzDcBibI2TxBcOAUs9syEP6seUoWIFw0oxP/lsCvyjiq7AlW/kRU4Q1iCoXQN/B7VlesUCoV08EK5OmlMWx25EMc18pMoaECR35SlnT96lq2gJKkVl3DDZBXnP2Tw5Vf/ojgCI7Yf6ZH5ZMgWtDOnKwTRC/JzdiHPDQNaOqa8XGRFg/uL02ZQdbhD3jNB0dOv5jGTva8kM4KpFoJbp1wSdIly0KilTE4RAkTQgABGv3dndlbfM2kBU34ltnVA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=KYei9FF9MtcEbkK/sshYj24qP4uYFH7O9xx35zgLpoWyE/FxKQMZwXbsUJOl2VLpqOZsbSgS1bZjNFStQrXqe7sO4vp31VEXE/qsweQl5aYIJSmI+DFLAh/WLuWkjXqKw8oRnh13H2/XzImMxF/QL/BVDT+VOz5X6O5WXE2oJPT75m4zfQP0BYPNIBWLe7l7AXq1JpJRm1m5zBpK34dgGXBTDWQ4zweQ5i2E84wds3U9EIcM+OIIWeSgkdrYn5brvC0jg4y8coPG5Z1JVp4553bqCI+YhQmKKi/pLJV5749zDc1nBqOdB/eOVQwzeR7nGrOm8DRGpvjl16UKmEGnbg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=V198M1GCw4oVm490TAbvH/kzj1BMFeceGhPmN7VyYJhl8JqsHZhZAMjNvsRwTnaAsRZ3LKN0EQzho4zOK+xdYayP9W+31ATa3tDpVZ8CX0ZJVcYLdwOd10sXeVxKRLDeyy+TPCNwtEyQ39TkkVkaLRLjN4Yrkhadggo6bJeOTqc=
Received: from DB8PR04CA0026.eurprd04.prod.outlook.com (2603:10a6:10:110::36)
 by DU5PR08MB10400.eurprd08.prod.outlook.com (2603:10a6:10:521::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 09:50:27 +0000
Received: from DU6PEPF0000A7E1.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::d4) by DB8PR04CA0026.outlook.office365.com
 (2603:10a6:10:110::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Tue, 15 Oct 2024 09:50:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU6PEPF0000A7E1.mail.protection.outlook.com (10.167.8.40) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17 via
 Frontend Transport; Tue, 15 Oct 2024 09:50:27 +0000
Received: ("Tessian outbound de6fe3af73ff:v473"); Tue, 15 Oct 2024 09:50:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9e4ba14d390810ea
X-TessianGatewayMetadata: 38I3scu9nUjdit9UgGg41MgVfCfJuoKWrrNyRyf589mN8RGf6qOhTa/B+Xv69xcIS7rMBSyqzjDJZM2wJksMO7Yn3aVCzF0+FAyhL/uFhjfT/wY0u2wOQtoEmEUi0k2tL10I3joiRWyOojiUyIeqSYy5CjvwRYkUnFS5HBGYv+0=
X-CR-MTA-TID: 64aa7808
Received: from L55565543ef01.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 91022FBA-2715-4296-98A4-4F0780517350.1;
	Tue, 15 Oct 2024 09:50:14 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L55565543ef01.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 09:50:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COerVVTaQ8SHBuiPoYFSt/kDuBu136bU7IuOEk0d3QoO1gePMi5YSSZm1BLkiLk3/teWwqj/9SUURYFfA33CR22BCUq2rO1pFfdFyesnDF1B83q9yXlOEv+nERgqJqmlPTGOmTDwG8bI7ML4rFODUKfmrvG5G5zxFeGux+QX+VEKCN/q1N+51D3nxAnLRpwgmxYqoN5AVXnDcY1vX/Xfll1HflY5z1ws0ivQkkP51ZqdBrEK0hB7crAVkJCF8BNz+ZefcRY1lVGZzR7ye/NrZjRKpcOFI+isOgTsS2bGp9QHaO/p3I8DsZbx/YTaBJhrGQqMXCBmSlYOTBCuIBviJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=ZE0v1hhsaA/ALwv5opEe7hjE7AqnPaMZ7rzlUueRixcfseS6zFEvzBIJohAurzoAbYG4xyBK0p+KuI3diBYumn+N3+SO0r9Vbpb9OOr1me0GWSf0wPscIxVoomzVlfXi3yBFOvbNZAPBhNidd0GK34Ls8z/4FR/gNsxsMEGXb9WZpXVaovPXUoXJbrWobVMIY8JJwgYOY/lnbVikhMSsVZ58v8Z/AwfiWbqcCbwWjCng2vqx/+HAijXJHA7zSNYxCCFJTp2McqN3CdvrvS1WVPk+RSaa/bPXkoYP+SGz5B8wiqX0pt6IjZk07yTHwqqf0+vJNwrghSepmFkCUIvJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=V198M1GCw4oVm490TAbvH/kzj1BMFeceGhPmN7VyYJhl8JqsHZhZAMjNvsRwTnaAsRZ3LKN0EQzho4zOK+xdYayP9W+31ATa3tDpVZ8CX0ZJVcYLdwOd10sXeVxKRLDeyy+TPCNwtEyQ39TkkVkaLRLjN4Yrkhadggo6bJeOTqc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by DU0PR08MB9846.eurprd08.prod.outlook.com (2603:10a6:10:445::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 09:50:12 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 09:50:11 +0000
Message-ID: <af109240-ae77-470c-9d10-046890754e6d@arm.com>
Date: Tue, 15 Oct 2024 10:50:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/11] arm64: mm: Avoid TLBI when marking pages as
 valid
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-9-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004144307.66199-9-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|DU0PR08MB9846:EE_|DU6PEPF0000A7E1:EE_|DU5PR08MB10400:EE_
X-MS-Office365-Filtering-Correlation-Id: ab97e57e-7806-4c4b-c6db-08dcecfecc62
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TXB0V0ZaRWl6SFBCbkEvZW9WMWhvNzVjK2ZBR0l1RDBLbi9ibnFJQTAycE40?=
 =?utf-8?B?RUozMkkvNi9tMmh0L05YdHZONFlJVFphY2czMFdxUHpEa1hHZzk5Q2Y2MmFa?=
 =?utf-8?B?RjlqM04xc0VVeVNZc3NEQVNjeDNYY3krSUx2cG12MXpZa2FJUlNiSjVVUXl0?=
 =?utf-8?B?NCtLekFmMG9JNnVxZE9SeTVtSjFZMTIzNGxXL3lPWlprTG1iV1V6WTg4bFR4?=
 =?utf-8?B?KzVoek9SWHk0U3M2bHN3M3owMXJQRFQraVkyNTBnZDZ3aTFIN1RYK2Rndjd2?=
 =?utf-8?B?SjlJdWs3MnE2NDhPNlBrd0ZWUHhDTHpqK0FGcnQ1YUlsRFNRVWVnajVGemls?=
 =?utf-8?B?Z2dGejhtUlVzZ3Jxc0JKK0lidmtXcW0rQTVLTzV3dW5SeDJjWFhsdTBwblU1?=
 =?utf-8?B?ZWs5QjVQNzY0WDE1QkI5bUhxckh2eUtGRkw5ZlpXM0FYcmVIU21MZDl0ekI1?=
 =?utf-8?B?am5oSHlJeUgzd0J5Zlo3UDBzLzJTVXVPdFdRbDBhRTU3RGFEa1JveENSMm8z?=
 =?utf-8?B?V2xTb0M0WnhkRWpPUElNQTlPWEpsSVRodXBsTG1UT0VjM3Nza3hyc0dYdlJB?=
 =?utf-8?B?SFVNQ1c5aVAzcDAxL3RXOUxSRkVpcWo2T3dzZEk2YVZqOGEzWlh5TllvM0hz?=
 =?utf-8?B?dVI4SWtIMElpekxkTHY1Zk82MjF5aTVtY3hzOVIyWWdZMldEcm9pNDJ6VFM2?=
 =?utf-8?B?eUZGNVNXZ3NsUDFMK0NySEw0TTQ1L2NtVEV1Zm9PVytOMlRsb1k1WEh4eDI4?=
 =?utf-8?B?QmVHZ0dBUURRNW5pV2tTRGpxWU90QnlrRUhQclRmRXd3L2FtWFF6cXJLUEdx?=
 =?utf-8?B?QVQ0dVBMMGw3R0dOYitzdlJOaUwveW5iL1d5RFRhbFoyc29yYW5tWGxBU3RJ?=
 =?utf-8?B?Mm9VbWlzNmM1UFdQUURUWHhRZ3RKYWNSR2VYUjJrTngrMVozVHJicXcwZEZk?=
 =?utf-8?B?emFWVkFYTkdBcklucDFLRit1RjhGYWNmNzcranJsUGkzdmdJaTZ3S1B4Q05H?=
 =?utf-8?B?RnlXaDNlUys2bkVFSk44YmFmd2xTZXBsQTh1dDRCRlEzd2FIQ0Q4Y05TYzdn?=
 =?utf-8?B?aVo4ZmluTkNmMG9BZm14ei9OM3dGckFOSG45ZGFQMkVlUHlaVUNRWVNJQ0dV?=
 =?utf-8?B?di9FQnRaUDF1aHFBME5laEJXZDZ2bzMzdS9qaXc1Znk2dDN6eWVzU1lENW5r?=
 =?utf-8?B?emY2TThUSEcxN1k4bGJSNUJpdnJPV3ovaUQ4WU5QU2ZCeVRtbWNIY3BnUzl0?=
 =?utf-8?B?bzVnVFoxaXRzdzhXUFYyd0g2L3BuM0pGc0VVeUxsVEs2NllRME83U0hNMnNC?=
 =?utf-8?B?Qi9McHQyTTZjMFNLMTI5OFI5MEJSYTFSUTliN3gwNG9sQU5YeEUvMUUvcDUw?=
 =?utf-8?B?a2l3RzJpZHIyNjA0S3FHQ1FlWFJtSDNUK05sNlFRZkxGU0pxamwrVU1vcU5X?=
 =?utf-8?B?K2RRb1JuRlRhNEdkOUUyRmVEUXJKS3cwRFJRRjlQRlQvbzl5TGtVL2JsSElN?=
 =?utf-8?B?QitWS3dWUm50U04veXdJMFFweVpWU051cERsMXJNY2kxc2EyajJQRWREeThr?=
 =?utf-8?B?NlZIZW9VRE9NcWVrcGsweDBPMGtPa1NoVThZV0g4TWlCaGpZYTkrQWREbEhR?=
 =?utf-8?B?MytwN1lwVDI3Y2FYdWFoaDZNWXJHNmN4VmJBTkZqNXE3T2dsTk9iazBjZ2sx?=
 =?utf-8?B?VUErR3dCNGFLZGYxckU0N0RFNFBCM1lGeEd4T21IWGt4aG9BTVNuMVBRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9846
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	801a5743-4c69-4b04-b5ba-08dcecfec2f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bG9EcXNmdldRU1ZMSkZhUjFYV09zNE84V29xUXprdjR6eWtHWis4WHVuNWw1?=
 =?utf-8?B?WnBNNzVja3p4M2lNSURvKzI5eWxzdStWaFNyMGlQSGZ6ZDEzZVZlNnNFUEd1?=
 =?utf-8?B?VEhBL292aGFaUEF6TU9kWlQwQjN4aWxSaCs2ZkY0YXFLOStHYkpIeHFsSis5?=
 =?utf-8?B?YzJLRnFQSGV6SWtNbHVTNTQxS2VieWVTemRMQVFTTDZiUGpqb0laK2FGVUV0?=
 =?utf-8?B?RUZDb0gwQ1czOG9nQlRGNjA3aFpJeVpDS05UblZ3SXRGRW9ZNVdYQXRBR3hs?=
 =?utf-8?B?eVA5OFJvbmY3dW53NEhyMC93dGpyOGNVWjR2cXhocXFYOWx6cm9OR3pDSk9L?=
 =?utf-8?B?K2NXbXJLTUJBaEFLeWdpRXdoNDZINzZURjR2SkFRcFRGQm1hUjZDZjhUSUdj?=
 =?utf-8?B?Q2ZRTjllN3EzZmJwQjR5YXJ3UHlneUlGTlNxT1I4dm9nSWhyYlNlaGFqZ2ZC?=
 =?utf-8?B?aFJBakM4VXpvREJZV0M4N0dPaXVYdTNSbFM3d1FTSjJac1hBeVZIS1lrd3lL?=
 =?utf-8?B?NCtscG5JcmxzSlord0NiNXJrTTFTTjJvMXVaQk10SFdpV3ZXdWRUWHlaVHEv?=
 =?utf-8?B?dUx6QzdLeDlSY0d6VEVkaStDc2l5WHlKRm16NEhpMjdXQ2pybVpZNkhNdHRh?=
 =?utf-8?B?U0UvWktUUW1UQmJuUWR6Q1VnQ0x5RXU0ZU4vQ1QrcUlWNmJ2eEN6NGRud040?=
 =?utf-8?B?Zk1jemFGbVZHenhhWFJKSGdDN2huZ3QrR2c1eGo2cGdmUVg2TEp6WDBTMm80?=
 =?utf-8?B?R0RPM3hiTkxHcVZ1L1RBRHhaVjlMd2lNUCs2RVhJTnFNdVJQMGtxOEpnTVA4?=
 =?utf-8?B?anR1OVZMRU5XNzgzbVNGQnVvUk10R0d5eVRQbnpsa2JQRExzUnJ1L1BEOFFK?=
 =?utf-8?B?cmdHWHlycTgvL2tBa2lKeHE0MW9lL2VMWjd6TjZINkNKVWtId0YzSlFHdWo4?=
 =?utf-8?B?V3I3OHNTR2s4SEZPQ2tzSjZ2L05CSE5ubG0zV05lWWlkTGp2UGN3dXF0alk3?=
 =?utf-8?B?S3ZCbEljOVJrL3dMcmY1eGNpREYxa0xZRUJSV0pBUVpydGhTTjcwbU1ueUt6?=
 =?utf-8?B?YkNVQWc0UGdZQVJIOTBvNVpmK3FaYjVxWEsvaE1PR2Rlb3JxUnhuOGJoSGpQ?=
 =?utf-8?B?UWhSNXRrVG0vRmtsUGRId3JyQnZnQk15RjQxZlF1ejZ1Uk9mQS94YThCTzU4?=
 =?utf-8?B?QUtJNk1MenpYOXl4d1I1eDFzSzJZRjlRbmxudnRQTCtJNHdhMThuQkxqYk45?=
 =?utf-8?B?U2VsUlU1MVoxZG4xMkNKRmlDTHcxVVduZXlhcDkyanVaM2JRWmJaTVkyTU8w?=
 =?utf-8?B?NTBXZTR1ODBFbitidE1mZGFRL05MK3NEWDhTVnhHVXlpTWU2ViswSFoxR1ZH?=
 =?utf-8?B?VDg5WDBONXVHZm9XTWpYUGtpenFUZjVkUWRWWnZBQi9wekxRRjJQcEViNnl4?=
 =?utf-8?B?UmEvNG90YUhnVnhwRmJ3WjBwMlRFR2M0V0wzaEN5MSsvV3lHMFg2ZFJkbVJM?=
 =?utf-8?B?aytJNkx6RkxTcUljdFVvOHFjR0FvTHhSZm9EMi8xM3VGejd3OEZGdTYrNHJk?=
 =?utf-8?B?dG5RaDhFNHptZjh0RWNYTU1aMlJiMGdsQkN0UDJXdWtoam5MMUVqU0dHajNM?=
 =?utf-8?B?c1Zvb1dYMFZUUXc1alFXTkRvRDhsNG9SbWVrZ3ZFRGlnVC9ZeHRVcitUdjJq?=
 =?utf-8?B?QmFsdk95UEpncEJHZS9YTlhEY085RHo3eTQzQklBL3VVWGFIc2lxV0pxSmRC?=
 =?utf-8?B?RkZXWDFqWGJaZFFCc2R4RExiYis0cUk1R0lHRCtuMUFXcVZzb3hKcUVDc1ha?=
 =?utf-8?B?cmZjWWhJc0tMVksybHpmZnhDL1hRWHdlcWZPQ1Z6NngvZjZBR0hUWnNzTUI2?=
 =?utf-8?Q?lHSwiVAeJPBJp?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 09:50:27.4485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab97e57e-7806-4c4b-c6db-08dcecfecc62
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10400

On 04/10/2024 15:43, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
> v4: New patch
> ---
>   arch/arm64/mm/pageattr.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 0e270a1c51e6..547a9e0b46c2 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>   	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>   					&data);
>   
> -	flush_tlb_kernel_range(start, start + size);
> +	/*
> +	 * If the memory is being made valid without changing any other bits
> +	 * then a TLBI isn't required as a non-valid entry cannot be cached in
> +	 * the TLB.
> +	 */
> +	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
> +		flush_tlb_kernel_range(start, start + size);
>   	return ret;
>   }
>   

