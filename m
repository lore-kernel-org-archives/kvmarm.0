Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C2E3019A9;
	Thu, 19 Mar 2026 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929447; cv=fail; b=QDoLzbZf77cJZp2lxT2//23qquVoVrQSp5qVFPMzki68iIpLzO2D+Ks/odiPE+eyCMRz3ZEceBZmt2Y4cLCBv6fF0Tbr/PLmwg6r5SzV2hR/sJZ2rGggCNbNXhvFIjsvNgJn0tIGeDr/M1G7YA+DE1F+CIgc4ZFZ5s2cRATggSo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929447; c=relaxed/simple;
	bh=XR+KrZdrOOrR8x0HWJQ7Z7mV2MtZdfqWFLqN8TYEyDs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r4eyAOw0qSyZAAZlk4EHTS6XFUKKolL/kIZ6EZM1OEU0rbjeLh/gs+FWarHI0fu64IWxi0Acd0WG8pLxji/adWRqlDk/gP7EES8NhSzt2K7mZ9SwYSNMOY8yVtWJdKaSYN/IWvQbk+/OqXHO6R81Rwt7ItM6OnnOD3UXnm6S7Gg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hC/rpOGm; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hC/rpOGm; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hC/rpOGm";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hC/rpOGm"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PVpc+lS5BJc6/qrdbl5XfLEY4GJn7cpz33Y2sRWxiN4UVJbxsz4SEpY7hD+BqkQZm1GLjCiZeBTaekFFxnVd23nYPEKtUXeTnyyE+WVxAJxvLOkEp0YXskhszcKXvKluGfeMQL1/7uNwfoUz+nDa504cdNZLGnSHUGKgTNpfSnQK5cFgEorQUUnBaZeS6lmHFUB0z+7yQA1Evj7scbY5sA8wXYcCUgTEu/l/FE45+YQpJxo6Emo/dS9sdDZrnPEtWF5ku6u6P3XdXs7PdX3UghnM7RyHicDhlmRpb0X6/SQcRHnWVrdrfC7zacRlidovsQHslSFZv1hPzkOmmx5gvw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMXO9IUALQXVPohXev52/OP4HC1X8vNQDRQvOKVLAMY=;
 b=pl9GChCb7pWiJo/NJxnDPP6M1d/1v3OQ22P6XvEnDkJ3eEOmrzRXq23ZNw1uP/KmZB5eLzsRAwB+GdCZsr/QK32JFRRj+TxeOPGEW/Yg8S+w3ZdbCUtStxyewc8D2GoFkfNkQlMwC+kduon58Hzl6vNBgfNz7tkk98mZImKy8oYL+Cp9asxXHBMjDkWUvKK8z9S2WO5TMIVHxQL7PT6ikDyMGGPQtQoyLdJ3mIIjPo7pTrZnauac9sBPhBn7cKzHK1CTg5c3MJxNI4ZHZf7XhiybvbM7/vX3xb/IpTZV5/hhXAptHdG1VvnF1I1uLBpF64sDfmCN19H71iPKiIwCkA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMXO9IUALQXVPohXev52/OP4HC1X8vNQDRQvOKVLAMY=;
 b=hC/rpOGmkpJ4y6gjlzs7CANouRDDvufPUmQLunbiZSGMoUpgRTjTlgQIjCYT/Yir3D9maH+wxanstw9OY9mnq6ynBOfB9z2TkdIkIdSjTyV+fH/AtgJAA33S8vnOFgHnz4r+l9Iz+3sYzQjhE7OPabjZFjG7voggwI6VenysmG4=
Received: from DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) by VI0PR08MB11711.eurprd08.prod.outlook.com
 (2603:10a6:800:312::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 14:10:40 +0000
Received: from DU6PEPF00009525.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::75) by DUZPR01CA0084.outlook.office365.com
 (2603:10a6:10:46a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 14:10:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009525.mail.protection.outlook.com (10.167.8.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Thu, 19 Mar 2026 14:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhmtTIQF8QJW9GYg14GPTabTOh9og82nFTn5s/bbMD2T304IJRadcDxePflyo+2H0Ikn4G9f/K6FhHWswo/VrgVuAuk4Za3Pry7nesHm59EtkPdrCYE/LoGiHdnK7X+785bBJuywKSjL8tgNTIkL+7DhuaePUmzgYGoEGnHIS9FnSndG6AP4iQVR3eNeuLz2zA5yEUq9yPsD9VPOudFtvjVs185JxPSjX7uQA7ImgZ5s3v71rsUxFX/HQFZfX2ZnRu28MeMA+0dmh3EmZ4ks1qnShGY3jgqMieo42xZR54wRlRXJy1VqoCU68rBImYZ5S1h/ls0Tzg/TAliwDu3Mpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMXO9IUALQXVPohXev52/OP4HC1X8vNQDRQvOKVLAMY=;
 b=xmP3KqoN5eC/nAGYVvP+E1+gLi4Wg3fB/YzmIEqgXmrOsI4fxUPuIq8gfxhUXIgXvEkIxA0RlVxmWd8+6x7QaNbNOTaqGJ9eKRipzRpulMNV3IF5HeiLnLeOrvekDNULrTuPgoSJiunG1HZch4hXedVTJMypo94+kV7SvFGTTjIfajxLfoplNj4YhLzOTgzCxrI6f5+B05eBRRO5IRkIIovuGWqIWdIU2sdJvA6ZCsgV9qRnC/5GO9TDB6WVFiEh+vgcSl7SWQz5bDmEPyw75x1LN+P0/HqISXw4VO+koOAkCdeoIXz36ETgNwM6arV1Qu6t8x3UnImz/cO7rFhhQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMXO9IUALQXVPohXev52/OP4HC1X8vNQDRQvOKVLAMY=;
 b=hC/rpOGmkpJ4y6gjlzs7CANouRDDvufPUmQLunbiZSGMoUpgRTjTlgQIjCYT/Yir3D9maH+wxanstw9OY9mnq6ynBOfB9z2TkdIkIdSjTyV+fH/AtgJAA33S8vnOFgHnz4r+l9Iz+3sYzQjhE7OPabjZFjG7voggwI6VenysmG4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AS8PR08MB6326.eurprd08.prod.outlook.com (2603:10a6:20b:335::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 14:09:37 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%5]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 14:09:37 +0000
Message-ID: <56fb42ad-eada-40df-8c81-53cb7c0c310e@arm.com>
Date: Thu, 19 Mar 2026 14:09:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 13/48] kvm: arm64: Don't expose unsupported
 capabilities for realm guests
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
 <20260318155413.793430-14-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0176.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:344::17) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AS8PR08MB6326:EE_|DU6PEPF00009525:EE_|VI0PR08MB11711:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d59353-65ab-48fc-03d3-08de85c14cc2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 xfuf6JxXrILbkqUZ2ryuIKs4mZy35Kgkd5NLQtOdDm6Uk8iwog6J2X+QovfF0jSBWDdm3ygbovPFMCWG6IPXrhABpAXKX0KnDbQ3Ru9slMjSeO9HFjzK1ckE/gvnz3rRFLs3T+ebqAAn6RU5JMLPnm86Sn/t7SiyApwlzWNxW9cefXFaSclB9xN77sWSc22apC6K8VyZt9BNB7tlSWBFO+86qjf03pTMUQ+kskeGRpbIFEziw2FkbMFazgpsug70rPcEz1dHs1m+2T9Yww/xwXQrlmB1nqHoESSMTG3XeSbYpasj34v9RfdAnqobKmjT1sxq8rr0fUTlwbK/tKa2FKwfEca7KE+09lDRBO64ped8vxuvwujuTPx2B2YS15vj+s91L3NPOHnq1XTiLXwSn0IBFqkl5kaLdTAQAySCPiknvgK4HomJfBaeNujqlj7o/3eK/teZTfNknalUrbU4fWgEjvjrN5Wn3qxqeDQNq5DnowXwclvwWCzDzoR9M2M0pQQnnUU74AufCr02TMTg1pY0b3zgzXG+kYxbGun0TtsDH1S4y6lmR06H+UlhFXjbYFiRdj5IaPU7FD6TeCTjkfqpyEjhy/KIfC6rtICSURFSKyeHTUYNwPNlq06Geq+urfj1/ihfh/KD0QUEbmDp8AOIameCUmZqoxSLRSV+3rCrO7pCr+2hZSa/LSVJZb28N4f0gskLig+UlU9FyUnvRstIBEg6hyH2Ydt6ZQ8VQ2Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Uzc7qji2i4qev87EsuCTHP2iBYhDzZoeLd9KLAhTl2wmogqee5mxHmts7jSSPhd4ZXVPRjXBcXiaa9qNwIS88fAI7psCLcEK0HLEUXJtnJbJw+AWxCrfc6mAfXeV7jqe0uCwVNEWnPUFlebGtBSn4h7LFucBv4jjc3XQFgciucb0L8i+bw9xv155EQYr2JLJCGL03cMHMc+yM8Q8nYo7w5C1TA22LVbxVN0QILk5Tk+yJfBxG0WdtNnJdW9QtfYN7lpWX2tzEdWqdGXAoHsRom+bjqb+GQQ/yqvPXMiJSHM1o4U458sXOsf+E5hilQrbaO9mqeeuvoSVpCdfExUhHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6326
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e8edd642-92cf-4763-e7c9-08de85c12764
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|35042699022|36860700016|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fMglCFAeJrNGiLUjNwrcdUPJbKldyZeneYukE+aKdVmMLpdjls2RMk6F3Ws1dgAOfeSTos8CBBm/Lc76FpRV7zbMBFFFWh7YhODb+3kQNxFiLU3gs1Mlw7M+WPi716pUnpnVCIAPQqopG/ncM+AfSCMpE216UW8KWxnAzXMAxNVRxVlea5M1ttT/5Yw6ST//L+9bz7dzD+JLO6UwHyD/VdLD1CM8JgIcRjVrzi51u4+2mXDpncSgZp2p5yf8yAWZuvCY+khaC6pA6aQj9dToWT1/B7ec+BcaK1w9TD75X995E4D7v3Pdj2dHNSaN5lld/hqnpMk9KJfXNn6Hjrse8YkcYKgsX5lyVvH7XLgYziApjry2W95LmTY/PjU4ULBVudGAnJBg3ePZtQ5ayzvTMoLNL6QG9TnoHGr9ciu4j0QWy24BCWGFPZD6B1Hp2vftNGZOtDgIFaQKTE72CnWeeAow9j0CKz4DLYVX/vg/1ByT/EVUyM6A9NSF0JniTRsAHfEDFzzRvAaAIULLy561swrIXZM07ZQqzcXF6FX70bse/bJaxz94F+8FsnPEinEW2gN1gUe9NJkqEany0gwnJlrFdgBdpFWVhI+H1beSO8Kk0xCnJYeY5qWjancxzfUAah2yh8Dlp51PKkjgYlzgLwKmrrcC9+ZX9JCKtjfzXVyFzXerKguGh9/0PEbbgaPfSK1fdoucdIuj0Bo81egYpWF+Id6afs+Ns0ziRTF7DfQus1T1c/d81R5aZB9G+II5TncQbOlbFTYs3JZNdU90cQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(35042699022)(36860700016)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wzLJVTN6ZUnFp2Ha6dcbPhjDmWr3yWFvubvU/DDRf9am/VmZ9hxCH3WPjxxpoxoDCRdjIIlp3bnCqt176RbT8RQPyRFFcMC8nyvcJurU70NG90piEX0dyqc8ZXpslZtsxSBzAyoSKV3aDg0joKvyYiW3ljFRensc8+7TCbbUhxSN+zWzc/xg1R10th1OngaIsN6FrI3aYp+h9GL058G+8hHcQYiN6HjQP+B/pbfQeazGHBTv50n5m2D+nIrFY+h1a64uC3WYOsqnYQhysk5wcgVSTuD8thhwIXBIttkE0yJuLj0vmCrN5e+IAPcmodeczLVo50FpdQoe4EcTRIPlRqA5ddVmkDruXovMqXiGcHsG46woYD+e1rxJHQnYHIV2sH0qu0LjCUcyT4m364VphcovsCE9AZrr08odMh1CUqDAiEfAX2zO0S7D1ccBJf/7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 14:10:39.5164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d59353-65ab-48fc-03d3-08de85c14cc2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009525.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11711

On 18/03/2026 15:53, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> RMM v1.0 provides no mechanism for the host to perform debug operations
> on the guest. So limit the extensions that are visible to an allowlist
> so that only those capabilities we can support are advertised.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v10:
>   * Add a kvm_realm_ext_allowed() function which limits which extensions
>     are exposed to an allowlist. This removes the need for special casing
>     various extensions.
> Changes since v7:
>   * Remove the helper functions and inline the kvm_is_realm() check with
>     a ternary operator.
>   * Rewrite the commit message to explain this patch.
> ---
>   arch/arm64/kvm/arm.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9b17bdfaf0c2..ddbf080e4f55 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -357,6 +357,25 @@ static bool kvm_has_full_ptr_auth(void)
>   		(apa + api + apa3) == 1);
>   }
>   
> +static bool kvm_realm_ext_allowed(long ext)
> +{
> +	switch (ext) {
> +	case KVM_CAP_IRQCHIP:
> +	case KVM_CAP_ARM_PSCI:
> +	case KVM_CAP_ARM_PSCI_0_2:
> +	case KVM_CAP_NR_VCPUS:
> +	case KVM_CAP_MAX_VCPUS:
> +	case KVM_CAP_MAX_VCPU_ID:
> +	case KVM_CAP_MSI_DEVID:
> +	case KVM_CAP_ARM_VM_IPA_SIZE:
> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +	case KVM_CAP_ARM_RMI:
> +		return true;
> +	}
> +	return false;
> +}
> +
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   {
>   	int r;
> @@ -364,6 +383,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
>   		return 0;
>   
> +	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(ext))
> +		return 0;
> +

We need a similar check in in kvm_vm_ioctl_enable_cap() to prevent 
enabling the filtered caps ? Otherwise looks good to me.

Suzuki

>   	switch (ext) {
>   	case KVM_CAP_IRQCHIP:
>   		r = vgic_present;

