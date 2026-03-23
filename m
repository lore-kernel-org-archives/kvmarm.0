Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93691386435;
	Mon, 23 Mar 2026 11:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774265598; cv=fail; b=bBfDDOy7FzRYfVYeSXlj5LBTWaDji0/Me9ewnJFBLWOokIV0BEeb8tFKYmpB0ldhZLYevuGZ1vmtUbsCllLw38YLNlmuqXAwn+irK0GFX/8LweoESEUvfrhVjex+2PjIeFkEOMwDGH1U8BAlcvm64077pPfwIR3KejbTYrsnjvQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774265598; c=relaxed/simple;
	bh=ZGmV2Tq45H4kgKqpVt9Gh1v0CSebZIu/as874i6bnNU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ns75tQpCVOxDKNQhrsUcvLxYLXLy/q9z4+Tt0EucYvJGdKNWxMro2qFXmpC8fgIsIMU0jgElwMYxYY5HRjgSJQuJAw5a70gpHtnoPrrBHfEqgKklXrcv/s3DJX8oIod4rk8CocY/65ssUUhJCn4aDA5FpumMNa0qW8rorCHlSRQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j5iC2pwM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j5iC2pwM; arc=fail smtp.client-ip=52.101.72.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j5iC2pwM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j5iC2pwM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hhk1Dx6xDDjm1ND5cmvz5OaIpCJFuWbNgveiVpseziIrlH/nPEZWbsgTui2zIGhoOSM0ZuYcSHbFwalsPUTS7Nbn9Jyv+SzRq2Comxm0pLvwc7u9cNvpkD12Mw0LKeGG5EqC0Auq01vtykmEscYimL3WvLoBpbCA3x+MxIMHb5481i7XC6eHN9bQhtV+N/dTUrPOrY43QnjXq+pTrB7FhFEWSv/6MnzCDEYPnjcEazCOGFDdihp4FFBprVJzv53P8C/IiSOZ5tAZqT3xFPMZ+4WpGYjIRExpVUDdB0WzrZsAmfvaDRZ4Lq3dx59fS7WMb4JbMJDglD94TDs3dAaFjg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iIGlhP1GxmWBISCr6xbm2BLgW/acl79hHZ+o+ZLILM=;
 b=rpwmzMbboPUw731a+jlu+MNRGA4QGtUbZAPbZI4e1RTQX759/SotbD4cBM80f2rY27eOIJE7ICYCVdQUrgHOt8DXWzA5MQ/Zno/uOrY81SNbt1kzF14WZRzsekFQvbDJH1tr72In3QuuhqBklr6mIasAS0TSvPYJLeKA86dCQqNDDJiDnMQoK76uyJ9vdTW7ZmbewigRuFo3FF65R2QONrVmKL+NH99NQ0mYZk+AO0lWeMrBZawwKm4o06R3tvsoxrROzCEQynJyWFW9chwT98D7IuWknlT2Q/8egkudJTqwGrzpCmd2RKbNNcHachGmp+U9TGVbAs3B8o/gVJgmBA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iIGlhP1GxmWBISCr6xbm2BLgW/acl79hHZ+o+ZLILM=;
 b=j5iC2pwM/Q6ODeYUIt27WHoX8M9ppVCzpdqPbcPQBL5U3AH3FDvF6Askp0rlsX8PbcfPSQsjoHKkf7UAig5F9+BDyX9O2Uk7tvq/vW1Y1i3/1k0Zj7GOwxtsXnJRx890k5v9csxZS2c2rbdjnxPIUSsTTCOExiR0XxYeK6+fwAU=
Received: from AM7PR03CA0003.eurprd03.prod.outlook.com (2603:10a6:20b:130::13)
 by DU0PR08MB8688.eurprd08.prod.outlook.com (2603:10a6:10:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 11:33:10 +0000
Received: from AM3PEPF0000A793.eurprd04.prod.outlook.com
 (2603:10a6:20b:130:cafe::eb) by AM7PR03CA0003.outlook.office365.com
 (2603:10a6:20b:130::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.29 via Frontend Transport; Mon,
 23 Mar 2026 11:33:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A793.mail.protection.outlook.com (10.167.16.122) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Mon, 23 Mar 2026 11:33:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tB8z3TP+fLItEoKHHoZqLRQynr6gTdrZGHL2byHuPYVyL1NmJ4kI5ns1iCeW8Lkht/xl1e1fvfWS6PfgItmxiZUj2GPoptsnSsevsaMBSl8T1Khos4vmXSkWxOm1KHzZTkVHlydseaWlY8Lm/DfFbfqYc1HPydqfdTqaVtnjlo9PdZOHbrKEobRky4EdY5xdAya/LJz9d5Et/yjFsJ2JTjPwIk6TtGdGcs5u6R6T8xrrS7gcB6SRYjAf0VvBoCvqSqy3KwP0ct+QBmEbHh12SqE4fhQfu1ZcBXd9qAJIu71XS8jEdmstQ4c7j4WFnK3PvJSKcBzQXM6aNm/0f6STtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iIGlhP1GxmWBISCr6xbm2BLgW/acl79hHZ+o+ZLILM=;
 b=wrIayNxN+NWphAKLtVi/kN0M9zJ7ZfBIr1kqwZ5PZIWhpalNPIcfyUnQ7GqV/0MwpYUGXWgEz6Mdl++FNJV2nXwyioy+EL/t48osvoiHtFgASEohKEw90N3xKi0IiHNJ9VpZbK6S87dNEvrDBuEiNrdwjLsnVtVfKyc6lZZrRvIFDvOeD6k3xBAlmN5YZ5h+hsKbkuxTXZ2VrbZXNXQVbw3ZLkoieaSR2zeN/VXJBq491kpl6tZXIDb3ZtYQAUbiSTN+yuDaQwXtfqrFPop7EYXjFFRlQxXqhxj8kXT/UC6ctF1LwTndzz1yQ/nOc7F/qOynLdGacsSUMgMPV9G/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iIGlhP1GxmWBISCr6xbm2BLgW/acl79hHZ+o+ZLILM=;
 b=j5iC2pwM/Q6ODeYUIt27WHoX8M9ppVCzpdqPbcPQBL5U3AH3FDvF6Askp0rlsX8PbcfPSQsjoHKkf7UAig5F9+BDyX9O2Uk7tvq/vW1Y1i3/1k0Zj7GOwxtsXnJRx890k5v9csxZS2c2rbdjnxPIUSsTTCOExiR0XxYeK6+fwAU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS8PR08MB8804.eurprd08.prod.outlook.com (2603:10a6:20b:5ba::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 11:32:06 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.022; Mon, 23 Mar 2026
 11:32:06 +0000
Message-ID: <7ab3dcd2-23b9-45a6-84ef-9617c4614c0a@arm.com>
Date: Mon, 23 Mar 2026 11:32:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 24/48] arm64: RMI: Allow populating initial contents
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-25-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-25-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0667.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::20) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS8PR08MB8804:EE_|AM3PEPF0000A793:EE_|DU0PR08MB8688:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba26419-59f6-4cf6-cc31-08de88cff5c4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 z5/3Jiw3fiOPAgtvcj0LPCRAWjz/R93g5TGLA+R72XGOevGFOdRh+mhoz7hTp3loLOZEmZ1VLfI8nboe8Ms2/A8Xtf7G0LltDAsEUsZL3pIeggTYVZF/cSCcU3RdcIjXN1lGWnWMvbO5LZb13mW2inwBWFHHR9QK3w+u2ELpXDLDe34XHh0cywoXG4M3cmMJPkfFJV7LuPXXPMGChC95b0ITzlZc+PUb7sS4X00W7wB4JgjYh3Kerj9SGKBKCHXZXPrWBN66dnGZuSue+tAWIdbSrH0rQtw7I8ezHkR3a/0Ue/p1IJIGPuR2wBTKiiGQjhATvBaa1efS0XGD3gC62jbqq6ZJbTqDUUvHRq6xJWZ+SK9w0Vcb0Ox7XE0y//m5Y/cCpoj0YbP1o0HYDarge8MmwxUnEXK8D+d1kHMXEur/aP0d1mkv/v7vW3nfaI1vmKB1Z5WK8nQaMDYUQ1gxqGtFoiraDhPNejGHejFUl6Hg/NGqcCITnwRkvIo4U1ZtnYvECT2X+FvV/XqOd2AlEmGWDu25Ywh+zq+8giNPyVHqqvgZqoz0TtN8QgCTAR5UKgf/lmM1nzNTZaTJJYxklHhbaoGLL+OA164Ef/fAYfqYZBv6TwUcziaC1YpF1aRIUEMFrLmAiXfqy+KxqK0ut4Gfku9614UQXxNemj2TxHesp4KWJjXNDw7A6kjPpXxeEGRlNYpix1rmVIDIFn2yoK3f0219IM/O1wF4sV6547I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 kj17I6nd/AeRoO1ugztcrnpjLluhmhbzsbzDbLCAmpzfAyXTaWZ3DJcaYJCYIIGnR21j6m7WlHShgj7mZW6hjk1UDykgFkkTnDY+bMbaocnqQ7XVeqWCocVlv3mYxULDVa2bLtzrWs6ueeMDZvvqaKZ9Ox1yypceTDbntqLVcuSRn5SGFwX/32XVKs5talb9wOmtagyzUdkFXbDKhwQ1pj6T4anENmIswxLwuGOQ4W4BrPpFlXH3hA6iXXC2JDA4+BsBmzT2jYW46Syv+ycQTks0HAOIbBA345qt8o5vZrtLpVA/PqtHHqTwGTmn1lmHG8lMksBuKi4fgbVqxsUavw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8804
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d721d023-4e25-4fe7-62fc-08de88cfcfc4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|7416014|376014|14060799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5JOqZ6SP+LzShPPN5YtU7QAXFk6cjMEp9Ght0WgMpXlIXgEp8pdqVBPK0SCxsWFdpHvRpNi3wJvcoHLzuynaMCpzjnGTYUKGEbjJVu/WruPd8klfcde9YobEXtRmYIECvEDGjPLM6bKgyFCR4GAPYJrLrNEnR720Aae35XkPtBTTlrnnLwsCzg/PbDCTOhxaCzhueNZinOeIVGLCxjN3pe+2LJ4smSns7eKZxyaLXmFG6w4dP6qMCsgdffcihBxkedtnSxbuBURzIXPOzI2k1HO7zEv9oJft9GwNQRPHmzXQb3e/0NgDyrMwLu5cnQmPGs1mifH7iwKoRy00j3tx/XBq5F+4saXhyQ7qIxVHhEhjOaKPSjcE4Xz3D9jVBgcriaaVmWBU9RX9cEn9Kvz1xS/C7rRj1Ndj3XtlGvyVjXiK2W5irlhvl6mNJGS5pq0h7WzSHIBxlvR9DyqgN/cgPYD/3DWBvkU3GdZPvpLszoArKoOkE5j/HOks2NKFAsw/WCBpvGD6Ogt/e5eun5Zflq9iUmnAIh6mbKEw2cmP7LzpoLH2YjA+1T2EGEIQO9nVfMIvUg+6LoH9JtxLGgMvDkeQ5fYycgcJ3cBdeBSXNVSOZGtokY7H6qlefD/UjVw7zCRatKbw/qynJWqo6TQicqTU8BhZ2IlkO2F/SYfjB9thRKWwO7jneqr3nxuv2eaU6mHsnfpf3BkNEeeZQ1rEgbpnrrrb/U8n6A1Yee9IPC6D3MoofXNi4EFAPMWc8u4yd8998bGQfKhYL9SPEbw6WA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(7416014)(376014)(14060799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s5/aysC7IW34jLALM/orQqdVKUJrYve6z5xgzJTzdXJlOzsegs1bRzjA7p3hMzOukKGGHsca1o3S76yHR81BJq6jIL0i3GRVtuGlWpu7FWyn0e1fsUtXbjF1luabtyVghqHvONQVJlJznZuFNRwbYO1sS5Whsk2TMwDegx2Uvsbz6dN55TNfC6cD9ybAuutBbp6oriR2qXNhhGIIdBMAY5fldLliFLmxQRPsKLr9GFtAwGPKwE1jxKa0y4siP/Ydmd9uZTJ15yK2dDr3onxkMMgijBhCkW0lw9p0l6L1cMF5anwIYYsPr4qAWXts5qWye3e0h3oExYPGWisLI/dpCzpn/5eIOxRd2FhJKKI2iNomlNmUx3JtmYRWU+7169PN4aXbqwNhhbZxrskJ13OSup/P47duBmdiUPZX08FUKaiEU5SGwd0YlPOO+sV3WZnC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 11:33:09.5056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba26419-59f6-4cf6-cc31-08de88cff5c4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A793.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8688

On 18/03/2026 15:53, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * The ioctl now updates the structure with the amount populated rather
>     than returning this through the ioctl return code.
>   * Use the new RMM v2.0 range based RMI calls.
>   * Adapt to upstream changes in kvm_gmem_populate().
> Changes since v11:
>   * The multiplex CAP is gone and there's a new ioctl which makes use of
>     the generic kvm_gmem_populate() functionality.
> Changes since v7:
>   * Improve the error codes.
>   * Other minor changes from review.
> Changes since v6:
>   * Handle host potentially having a larger page size than the RMM
>     granule.
>   * Drop historic "par" (protected address range) from
>     populate_par_region() - it doesn't exist within the current
>     architecture.
>   * Add a cond_resched() call in kvm_populate_realm().
> Changes since v5:
>   * Refactor to use PFNs rather than tracking struct page in
>     realm_create_protected_data_page().
>   * Pull changes from a later patch (in the v5 series) for accessing
>     pages from a guest memfd.
>   * Do the populate in chunks to avoid holding locks for too long and
>     triggering RCU stall warnings.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |   4 ++
>   arch/arm64/kvm/Kconfig           |   1 +
>   arch/arm64/kvm/arm.c             |  13 ++++
>   arch/arm64/kvm/rmi.c             | 111 +++++++++++++++++++++++++++++++
>   4 files changed, 129 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 46b0cbe6c202..bf663bb240c4 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -96,6 +96,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>   int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>   int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>   
> +struct kvm_arm_rmi_populate;
> +
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *arg);
>   void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   unsigned long size,
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 1cac6dfc0972..b495dfd3a8b4 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -39,6 +39,7 @@ menuconfig KVM
>   	select GUEST_PERF_EVENTS if PERF_EVENTS
>   	select KVM_GUEST_MEMFD
>   	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Support hosting virtualized guest machines.
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index badb94b398bc..43d05da7e694 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2089,6 +2089,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   			return -EFAULT;
>   		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>   	}
> +	case KVM_ARM_RMI_POPULATE: {
> +		struct kvm_arm_rmi_populate req;
> +		int ret;
> +
> +		if (!kvm_is_realm(kvm))
> +			return -ENXIO;
> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		ret = kvm_arm_rmi_populate(kvm, &req);
> +		if (copy_to_user(argp, &req, sizeof(req)))
> +			return -EFAULT;
> +		return ret;
> +	}
>   	default:
>   		return -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 13eed6f0b9eb..b48f4e12e4e0 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -718,6 +718,80 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>   		realm_unmap_private_range(kvm, start, end, may_block);
>   }
>   
> +static int realm_create_protected_data_page(struct kvm *kvm,

minor nit: To align with the RMM ABI, could we rename this to :

	realm_data_map_init() ?

> +					    unsigned long ipa,
> +					    kvm_pfn_t dst_pfn,
> +					    kvm_pfn_t src_pfn,
> +					    unsigned long flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t dst_phys, src_phys;
> +	int ret;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	if (delegate_page(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		KVM_BUG_ON(level == RMM_RTT_MAX_LEVEL, kvm);

A buggy VMM can trigger this by calling RMI_POPULATE twice ? Should we
return -ENXIO here rather ? The delegate_page() above could prevent
normal cases, but is the VMM allowed to somehow trigger a "pfn" change
backing the KVM ? Either way, this need not be Fatal ?

Otherwise looks good to me.

Suzuki


> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      RMM_RTT_MAX_LEVEL, NULL);
> +		if (!ret) {
> +			ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
> +						    flags);
> +		}
> +	}
> +
> +	if (ret) {
> +		if (WARN_ON(undelegate_page(dst_phys))) {
> +			/* Undelegate failed, so we leak the page */
> +			get_page(pfn_to_page(dst_pfn));
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +			      struct page *src_page, void *opaque)
> +{
> +	unsigned long data_flags = *(unsigned long *)opaque;
> +	phys_addr_t ipa = gfn_to_gpa(gfn);
> +
> +	if (!src_page)
> +		return -EOPNOTSUPP;
> +
> +	return realm_create_protected_data_page(kvm, ipa, pfn,
> +						page_to_pfn(src_page),
> +						data_flags);
> +}
> +
> +static long populate_region(struct kvm *kvm,
> +			    gfn_t base_gfn,
> +			    unsigned long pages,
> +			    u64 uaddr,
> +			    unsigned long data_flags)
> +{
> +	long ret = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	mmap_read_lock(current->mm);
> +	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
> +				populate_region_cb, &data_flags);
> +	mmap_read_unlock(current->mm);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
>   enum ripas_action {
>   	RIPAS_INIT,
>   	RIPAS_SET,
> @@ -815,6 +889,43 @@ static int realm_ensure_created(struct kvm *kvm)
>   	return -ENXIO;
>   }
>   
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *args)
> +{
> +	unsigned long data_flags = 0;
> +	unsigned long ipa_start = args->base;
> +	unsigned long ipa_end = ipa_start + args->size;
> +	long pages_populated;
> +	int ret;
> +
> +	if (args->reserved ||
> +	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
> +	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
> +	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	ret = realm_ensure_created(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
> +		data_flags |= RMI_MEASURE_CONTENT;
> +
> +	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
> +					  args->size >> PAGE_SHIFT,
> +					  args->source_uaddr, data_flags);
> +
> +	if (pages_populated < 0)
> +		return pages_populated;
> +
> +	args->size -= pages_populated << PAGE_SHIFT;
> +	args->source_uaddr += pages_populated << PAGE_SHIFT;
> +	args->base += pages_populated << PAGE_SHIFT;
> +
> +	return 0;
> +}
> +
>   static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm *kvm = vcpu->kvm;

