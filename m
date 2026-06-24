Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013028.outbound.protection.outlook.com [40.107.162.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC58397B12
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291266; cv=fail; b=Td4IKyX1/4SPWPKLKld0kUHtMuwr35OAWBlJFjJ3SeZkVAWkgG1MO9JRommieEmULotCaOOYckubUp3Bf49q3gYSfgiOqEyAGvsQGYdKZ0U+kZTgr+ifqE3yD8dguE0JQ8wuclzLoSimnSOC0IV4G90SYhIBo/uH7acyWS7nfEk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291266; c=relaxed/simple;
	bh=gbWtRIfZSvmNXeiiABPor+xY2U2Gf4PUK81fHfwVFCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P4EgV2reLTiJ8uWYI5jI96ZV4bHki9ptheo8+Oki2nTqyf1nDyhxQxVM0jh9aNAD3bldoltIh9B3BGCPBVKKe3tNjLPs8gkBVacK5yuseZ5+GvN+9VxUoZSsBCNIUPfotEHB80twsQBAvMIolGDG0n9Y3EGPAzL0kzvZmP2lJzs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F4f1Nfle; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F4f1Nfle; arc=fail smtp.client-ip=40.107.162.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F4f1Nfle";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F4f1Nfle"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PT9yAg3bAjWxXTCxqEEQS6S/WRFSpDDoHRk7+FVuBwdmV4fWnpY8s+vfifuZxlZeVnhMYm0JXXRmFpP7bi4Busj+dgOMqMLNUoss5tiWhJWrJ0pKv3BzG3kiM8QYmiw7HNR1vAsFhGDx2tMEdcuxxfq96QwhpfVTr7PsEo4s8HodS0I3WaCm4rs86+v11oQkYS4i36IFKLxmQXjoBKArJiLHyRI99BnMKzyXAdarc2dEid9FABhBRy8DIeBO6ghYLLk2Ah1RtNudMXry6UJA27OL11GHBTblMMgJ5gZ6kISUGkZROEAHxIhTsTQTMG0QsbHnBK5p11Fea1QbdfepLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzLVusvRiO8pE7j6kuCLFLvLG4tbqaGaxVHL0vJW8Es=;
 b=bIJFu9HmSC7CewG7pf3kKxcBUk85WFl+b8EKYfWkXBzYcgyEdUe9Saa1Q8F21FZGYJU7lMHfZNRzY0yofAkahxO7TygBQ2RECeCAGbfx4OsdROBkp64MAe6pBuQEW5Bkaql7f2VDeH3eertYK+18MHAEAZEpXHWaFGRce4Tgsohkz1TwxuDsQiEB0h89sn/481EuND/OC8kYdJJKBqn/r5nfqCjmnyoLATMllag7AvtluG/MMFi/Ba60DIbXeBAaxbS+NOkvJdPvbaZORv90qEkxnuQ+0dkYqSFIHlGi2Pc7iPPQuiIEMo3amL17C6t/XPIQFD7K3z0ekY/DjjrfJA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzLVusvRiO8pE7j6kuCLFLvLG4tbqaGaxVHL0vJW8Es=;
 b=F4f1NflehB5U7FKs8cJdPQSYFvMS5ZPCTFcToPnOxzyuWmnAn/CQ+zrKr2vVincHBP9AA543jF18qoTWRdef3rTDmg4eEDJLX8Zrj2Nun4xDUNd5qfp+yCqQsjWUrPN6+ZLC96dOCrzrAgae0Yszw9uxnuY12DD6oeUZai9riT4=
Received: from CWXP123CA0005.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:73::17)
 by DU0PR08MB8139.eurprd08.prod.outlook.com (2603:10a6:10:3ee::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Wed, 24 Jun
 2026 08:54:14 +0000
Received: from AMS0EPF000001AC.eurprd05.prod.outlook.com
 (2603:10a6:401:73:cafe::a8) by CWXP123CA0005.outlook.office365.com
 (2603:10a6:401:73::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.14 via Frontend Transport; Wed,
 24 Jun 2026 08:54:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AC.mail.protection.outlook.com (10.167.16.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.10
 via Frontend Transport; Wed, 24 Jun 2026 08:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CgJiss5Nchigu10iKVHOm9Z1vD7FYzp9qpCat6M99RNWOI+yec0OYCs/hG3fXykoNa5MnvN1wNMfraxZywKV/n1eMl3qcZ3XTdk7nkirvDvL31zxhD7I2YzdxFbT9r5eLSoj3exVRnizz3mI2ntukwawngnapUohnpauLkvZwZrlZBb4p2d3CjHhMS2LIrhsIMjFSFQWYijDHlAStNyY84qHTQ9bVA7KW3FcogOJzQbER1GhZMrJmu/dF1WJuKSVVwzVLHyir8k4Xtwt6suG3x2N1LOAsyqHNrflyfN/MrC+OAq+VrFbKtqNuZeymYsr2z4xMRqgHfcKBQcbQAXNxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzLVusvRiO8pE7j6kuCLFLvLG4tbqaGaxVHL0vJW8Es=;
 b=m4J6i2bEKA83OWS0Uv/pVeLPiYV3rQortrl3kwgdhduN4jVgIlN/MDvKJgRVafg9faOvq8UCOjNt3KUg1+1G97SJEZ8LX6fEPcDL0DhvkB+CrkrM1VC6tIRggJiu+U8FKE91Ao6Gm+ZmA77l79inlgWPdeS687wlF8WJOACsoaKzbcAL6IzW7RHCWrQgUspyGvyTVQ0iTF7b4+JDvIa7Yg8ZK0yV0Tv6eU1NVApLAPwjEPV2VmTKaYlLq56gU4ZNaN9IoWl8EBkVoMIGFO66VAW92/5xBq1qPxlMVdtZDURsgsPLMX8Ns91HVxfdUEymPoJd16BZjbX0zD33UuDnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzLVusvRiO8pE7j6kuCLFLvLG4tbqaGaxVHL0vJW8Es=;
 b=F4f1NflehB5U7FKs8cJdPQSYFvMS5ZPCTFcToPnOxzyuWmnAn/CQ+zrKr2vVincHBP9AA543jF18qoTWRdef3rTDmg4eEDJLX8Zrj2Nun4xDUNd5qfp+yCqQsjWUrPN6+ZLC96dOCrzrAgae0Yszw9uxnuY12DD6oeUZai9riT4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by AMCPR08MB11994.eurprd08.prod.outlook.com (2603:10a6:20b:76d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Wed, 24 Jun
 2026 08:53:09 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0159.013; Wed, 24 Jun 2026
 08:53:09 +0000
Message-ID: <b161c306-5b78-41dd-aab6-79fc35086c8f@arm.com>
Date: Wed, 24 Jun 2026 09:53:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 4/4] arm64: Add support for protected VMs
To: Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
References: <20260619115415.5475-1-will@kernel.org>
 <20260619115415.5475-5-will@kernel.org>
 <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>
 <ajqnfXfp-fCf9jGF@willie-the-truck>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ajqnfXfp-fCf9jGF@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0076.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::11) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|AMCPR08MB11994:EE_|AMS0EPF000001AC:EE_|DU0PR08MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: af3194fc-e2bd-4993-fc7d-08ded1ce29a9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|3023799007|22082099003|18002099003|11063799006|56012099006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 X9l92leaRFU/TH+NzJZu1Z5aJefB0IKZKmxUwW3bIu/w4iTi3B/ZIsz83NddqsTtp/Nu5oajhfVxP/dvhPiDKhrJwxvbhSi/NAWqU751D9zCksuS664A/lGehUkaJCCuObc5arD5on3UZysTuEa3kiKgdetrTuGBppZype5cdxbh8zliGSN226zs9NHdfL1EenCkHkJBai59x9sGAaTFpctQ0M8k71IKvqzF8dsOHdoYLD0cZNgTqq7rsOKOdLyOkOWIBEVZrx3nYRIeqwGebrdMUG3lWftPzUn17LW96qXR4vJcV80zYWuVwiElTu6rc46IHEaxy1B9pKPAIrUvtddHBiynG90lf8rKF2rsCiSYlrcKKF2uVovdecyJMSLUFE0GVP5LQHdm85adNrWQRGbnLj1ikgYqoXCn0DMmYYOzKLfPfAQZQETMU/LA95FzBmwUGun3mgnZtQ4WaWNWL8nHXFlvzChTe+XeSBBPV6VJLLi1/TICzH8ZtZt7c6mpY/4wqwsLZj1Sk3gnwOxpOxDosRIykK79uGqdA307WhjKqplkJ3SDDCyZMgZRwdXZyYVfy6TvEnxevakJusS6bVrmz5Lf9sLF+ZORR7V2eCPWAgJ/CPDESL1Qq2W3OPE2Leo7oMtUrHZHz4jgzsKIjxo9hZx0DTZY48LJH2511MQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(3023799007)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 iIW2IPQ44HsrRjYur1jdgm0tCkKd0EB2JHvtAUBCPZNoUPze4qiWDyoJOezCpWe6PXK++v/UZ3y80v3Q6iqySBnkty0f/RlrTLNLIvk62LmTqCgwnRpvAK/yuXdfSMO8Eld+LF5e/u0s+bR5WrfYk/XgPR8P0/YRY7+JCo9hdVni+giMRH3rlLtqg/vMpjsGYpUXRsGBLGjATu21udLlWxvZWabCjnvdwU07EYd8WFRLfcRERML3JCRzZyLvhTc1N1ZqLJBhv/4D6f0FjjfvJBzkmfq3Ji2UUR4jbJmfVIS8hRmEui8AGvtXXodp4c4HoYEEJ2MbjBjV9wSKA8PjNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB11994
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5e3fdbd1-f124-4e32-68cb-08ded1ce0355
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|1800799024|36860700016|14060799003|35042699022|3023799007|6133799003|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	4Ylwr+DXpInGBrZRFBrsTI3Nw3L7My54/U2bzSnekwx4TgDp/V5tbbQ4aUloCSIfOZyjvKLCuZCCkgMT3aabDWjtueD9aforQwjr00XtAvrKCWCfOROwoycAroZOVS5CVe7dTuC4SaObBvDmRaBOhKoMUCBWwlywKC7p+7UD8kB18PeLzmBePgdfB3OPQEjjCH7HMmpOBTI22yEOn/ejQoOrqxOH71oAxxj3FFJoZ67WzUc5RaPhmajBFYVTM27B6NJExdQLrVkIW3ZoRjx8Ew71Rx8DFasVd4UffyIzNt4x+3le1D251vSXCNJCKF2BGyar6UTf2cFIR8C9rWRKuV6YWJGowRywi99zP1cSK3zonfu0ZY1XUrtLTv8J35BJy00QkTSWMV8TY/nGbabsPBxffPkYjuEQ+Zxu61zpWhadYoo+wePoT+FJpKD0wdQ0MTqWjgcoXx4Os+DZOKMkPMh2nGqlQgLO/CI3VE1T6XGRF+I2F4vqZmiQSm04u4qq545K9ExNvgC4snZmREsNQET6p4lvcpkit8bqovW7ZBylRXOzQdUCUSYp/SMT5YmJfnxu+xLJcK+I7cNNy2EZQ3zmhWN781mM6DwK3z3Cd3zuH30Wl+BsEHqMlIuNCnjvcCrc9sIgJSdMv5VhebYRGtlk4sLNWmP557zZegdkqpLpzZZqsrxUG1Mt2BGLxXIIKKOwQy58qeQwiI1UL9kaLg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(1800799024)(36860700016)(14060799003)(35042699022)(3023799007)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EDaLwl10ygXUhqABW2bfPN6zkhFs92vWhAKIcFLYHof8X+S1eqoFa5LfTZlfhOjyKHSPz7JAOnmi8bN5glk9X+jx9UhyCCmNrDvenYYBp64psX39cCcD/sqfI3XZxEze8O5fPkOTNI6zRLo01qWAN/f35sfiChx4pnu9rrWOK/KWjImqh0x57E/XVvXTkc3OnqnJ2xG/VOd6epYBePaSvzNzRn7EUta0U3K4Uyl3crC+Doldyk6MwzoMixtGH0aRA5loMI62l0xRp5b4QwoxFUDTK2gG0Y0Ouk5uF/BnYsQ7EbAi2oLVd3IqvmB8s2UMEdLGrt5L74jPrzw5NBVcEBUcPPjk21/ttdLQp0vxBaPbmwM0P1hRbBFDdWIGMCEB+KALnRIrg63Lofhpl4F/UDfCUQURKNV0sK2615+j71IlbeQJ/RRug8RnmlZbz04I
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 08:54:12.4611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af3194fc-e2bd-4993-fc7d-08ded1ce29a9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8139

On 23/06/2026 16:34, Will Deacon wrote:
> Hi Fuad,
>
> On Fri, Jun 19, 2026 at 02:49:11PM +0100, Fuad Tabba wrote:
>> Hi Will,
>>
>> On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
>>>
>>> Introduce a new '--protected' parameter which requests the creation of
>>> a protected VM type from the kernel. In addition, a reserved DMA region
>>> is advertised in the device-tree and VIRTIO_F_ACCESS_PLATFORM is
>>> advertised so that virtio transfers can be bounced through a shared
>>> memory window.
>>>
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>
>> Two nits below, otherwise:
>>
>> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
>> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
>
> Thanks. I'll spin a v2 to address your comments, so I won't add these
> for this patch just yet.
>
>>> diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.=
h
>>> index 60c2d40..8a0a460 100644
>>> --- a/arm64/include/kvm/fdt-arch.h
>>> +++ b/arm64/include/kvm/fdt-arch.h
>>> @@ -1,6 +1,14 @@
>>>   #ifndef ARM__FDT_H
>>>   #define ARM__FDT_H
>>>
>>> -enum phandles {PHANDLE_RESERVED =3D 0, PHANDLE_GIC, PHANDLE_MSI, PHAND=
LES_MAX};
>>> +enum phandles {
>>> +       PHANDLE_RESERVED =3D 0,
>>> +       PHANDLE_GIC,
>>> +       PHANDLE_MSI,
>>> +       PHANDLE_DMA,
>>> +       PHANDLES_MAX
>>> +};
>>> +
>>> +void generate_dma_region_prop(void *fdt);
>>>
>>>   #endif /* ARM__FDT_H */
>>> diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.=
h
>>> index a50e6a4..e7dd526 100644
>>> --- a/arm64/include/kvm/kvm-arch.h
>>> +++ b/arm64/include/kvm/kvm-arch.h
>>> @@ -87,6 +87,8 @@
>>>
>>>   #define MAX_PAGE_SIZE  SZ_64K
>>>
>>> +/* Size of DMA region for bouncing when running a protected guest */
>>> +#define DMA_MEM_REGION_SIZE    SZ_32M
>>
>> Worth scaling with guest RAM, or making it overridable for DMA-heavy gue=
sts?
>
> It's a bit difficult to know how much to allocate here. It's some
> function of the number of devices, but then it also depends on dynamic
> properties such as virtqueue sizes. It shouldn't really be related to
> the amount of guest RAM or the DMA throughput.
>
> The number of devices isn't readily known, but even if I did something
> horrible like enumerate them from the arch code, I'd then still need a
> magic number to multiply that by. I think that making it overridable
> would give the user of kvmtool the same headache.
>
> For now, I think I'll add a check to fail if the guest has been
> explicitly provisioned with less memory than the bounce buffer (diff
> below) but I'll leave anything more advanced for the future if/when we
> know what the problems are with a constant size for the pool.

In the future, make it a user problem ? i.e., specify a size for the DMA
pool. We did have some hack for this in the past. Can dust it up if
there is interest

Cheers
Suzuki


>
>
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index b899ebd..fb0b98d 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -469,6 +469,12 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>                  pr_warning("--e2h0 requires --nested, ignoring");
>
>          if (kvm->cfg.arch.protected) {
> +               if (kvm->cfg.ram_size &&
> +                   kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
> +                       die("RAM size (0x%llx) smaller than DMA bounce re=
gion (0x%x)",
> +                           kvm->cfg.ram_size, DMA_MEM_REGION_SIZE);
> +               }
> +
>                  if (kvm->cfg.virtio_transport =3D=3D VIRTIO_MMIO_LEGACY =
||
>                      kvm->cfg.virtio_transport =3D=3D VIRTIO_PCI_LEGACY) =
{
>                          die("Protected VMs require a modern virtio trans=
port");
>
>>> @@ -485,6 +499,7 @@ int kvm__get_vm_type(struct kvm *kvm)
>>>   {
>>>          unsigned int ipa_bits, max_ipa_bits;
>>>          unsigned long max_ipa;
>>> +       int type;
>>>
>>>          /* If we're running on an old kernel, use 0 as the VM type */
>>>          max_ipa_bits =3D kvm__arch_get_ipa_limit(kvm);
>>> @@ -500,7 +515,10 @@ int kvm__get_vm_type(struct kvm *kvm)
>>>          if (ipa_bits > max_ipa_bits)
>>>                  die("Memory too large for this system (needs %d bits, =
%d available)", ipa_bits, max_ipa_bits);
>>>
>>> -       return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>>> +       type =3D KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
>>> +       if (kvm->cfg.arch.protected)
>>> +               type |=3D KVM_VM_TYPE_ARM_PROTECTED;
>>> +       return type;
>>>   }
>>
>> The "old kernel" path above returns type 0, so --protected is dropped th=
ere
>> silently. die() rather than downgrade a protection request without a wor=
d?
>
> Well spotted, I'd missed the early return. I think I'll set the type to
> PROTECTED early, then we'll get a failure from the CREATE_VM ioctl() if
> protected VMs are not supported.
>
> Will

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
