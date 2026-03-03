Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013058.outbound.protection.outlook.com [40.107.159.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A293242DF
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 10:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534940; cv=fail; b=EIRaRFF2UQWGg/Wh/9fur1/ExsVwRP7BGDrq5Fb9eaSANkHtwGdpgZnJGHO15QsIWD5xPoj6s+1a/K4ZdTf7kc0B8FQlFQMHpJpp09UY1TXZpBuTKhkYf1UgdhPb6aSu5JqyuA9Wkk+62ibN14n5XWP4/N8NQwcC8RjTc/XZym8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534940; c=relaxed/simple;
	bh=dTVcFD7hxy1te5Td6dlyloD+bcjTcILonD5MgU7634E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cQQxK5hoU3EiHhdi/EMjoD1DNGav52zjmjtqBTZxhDIM3dKHAn+XKHMZoN+hdKsUohohpXjZTwBWxQ/CaOLeMF8hCgbtyTus6o/gRrRO2QGHoEn92uP8UoGwVKXKaVEOz2ZeWfdKmJKcI8M9LSVWjlRb1k6QtZlqaZNa2YhrcoI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E4eAF0kM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=E4eAF0kM; arc=fail smtp.client-ip=40.107.159.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E4eAF0kM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="E4eAF0kM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PGCOiUu5V3vXUuuiq4w/M6AQjhSR4JDmR8Db2WruljvpNwdb0MNtAGQzQGsNT39TXIehEC04t1EDV4OIaKrHFyoBJH8AYjUNPsAJyZOmVz5CaAwN6G3e3+ZJH9vsON3qh5zCucksF2vaLfyziwDOdHbSnGCv1FfVKmuTWGAOQMi31Od7+9gKsRCg1KJkz2sO0bSm69wKbZROQqQ3I6PNHUomGSnTCFJzhdZBzfqrI9XPamNBimZEswBOCuSBbS5gnZMrYgV2kUWQTJiVnRFckiI+ufUHKZlewtICTRj5F/XtY12nqWVc6NhAt5UMcWZ+V3Gy0u0NeSOsByP3caFdFA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oSGH8gEBzrCqkkZk6ayIe6S1542yxNmc5ElGppGFsE=;
 b=bSvPBTL3JqYpAOJe9Nkf8Luz6QMvJiAJBUbpy7BhCORu1yH00Pr2HamWK3gLq1pyMRi7mTNENaQ0vd+noFBu5vNN1t0DAbZbd3Jxu+449GgzxbP+l0VRi3BfIfE0EoBbs+yi8P8gCbqDSNZBqBJ1Q2FxcJwusaIKlgYbuE82i7kzY/9vNFtK0p//Ivp5uhZDll07MCxmwcAsLD+2dvPitjpW4BD7XF9V97V1OcUG2mEuhuo8sv85HmbRRyPMwGjEcyjZfu46OnBxyIaUs5SYKhubGRwYKsrYJNvHVPQATIPvOpTU70xUjO+w1tNa9eilhBKm3RUY+VFqcKFmA1Ja2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oSGH8gEBzrCqkkZk6ayIe6S1542yxNmc5ElGppGFsE=;
 b=E4eAF0kMylf2RMgss3UuTDsbXAQatetmcvmF3kqHXgGn9u3cLUZxr59DGJT53D6mCo1h8+mT11uGgrWl7+DMb+peP6gu6IrjMa69D6Xnlbd4YLBtf2e8xtYiduAKq7E6DC366x5mHgOCFWfYzM4UcOCGRWmZYd2fEmrL0S43b1Q=
Received: from DUZPR01CA0307.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::23) by AM8PR08MB6596.eurprd08.prod.outlook.com
 (2603:10a6:20b:369::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:48:53 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:4ba:cafe::10) by DUZPR01CA0307.outlook.office365.com
 (2603:10a6:10:4ba::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 10:48:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Tue, 3 Mar 2026 10:48:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xlu81KfJKzdpBTqDxiT+Ka9r4fk6P6isGwbGeio3iBXgNw40euBbOpdi7R/v0IX/wDTNpibEKiYLkTtO9jV41QNp9lq0OKjAkpAcGQdsbh3BBFWHjxF0b7sItx+DtJKan2sPGmVcYgbkTn5B7WaXBqSQm2FzthgL2NAv0VgzYL3Gu8Phv6K8R0US/BEjDa28eTes0R9v+/OA1vb8Zz0U+B/MBoeFmZeQHzFcvxNmZphvpGRH9l5tSea9UlmhcCqOIU567/tDOBB7kAKtzvjNWI4Crb7YOhLxEmhpV5OYPSDx1VCfRQDTEhZ+Q8x05omQAhXiprNy6ZbEJOyoImOGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oSGH8gEBzrCqkkZk6ayIe6S1542yxNmc5ElGppGFsE=;
 b=EddOkMksyiI8Du8zGTgNuWlr0PynDPTSmO9uT0/s0UbdPdTU3WNz2v1Ir+YV9yfloxCJqch904cGMbuL3z7oHRiR4gYQ3hkttMyH8KQiTYSuzEOT8iQcAPmCkNabcJjPfXUkOKIzbebYPDus1aYQYv3PxdjsaLyrk4G/Xwt4kuWUyRG3ZVvKlLV7MX4X2TSi4xMzjtmsUYnwnqTy3WqHEhfbdhEz7o/oTp9ZHSyNnDJ5+V/Fh9msfMY4s46ZIBGh820WRTuxnm/VbiqX13oMcPuvxQ/QtklgYiYtaISI4BoYqe4DYkbmcqB5Nh5pIy9n7nEDb5D2RdlezQn23WGqAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oSGH8gEBzrCqkkZk6ayIe6S1542yxNmc5ElGppGFsE=;
 b=E4eAF0kMylf2RMgss3UuTDsbXAQatetmcvmF3kqHXgGn9u3cLUZxr59DGJT53D6mCo1h8+mT11uGgrWl7+DMb+peP6gu6IrjMa69D6Xnlbd4YLBtf2e8xtYiduAKq7E6DC366x5mHgOCFWfYzM4UcOCGRWmZYd2fEmrL0S43b1Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by AM0PR08MB11701.eurprd08.prod.outlook.com (2603:10a6:20b:73e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:47:50 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 10:47:50 +0000
Message-ID: <4639b8cd-bcc5-4528-be06-e3a0681e6162@arm.com>
Date: Tue, 3 Mar 2026 10:47:49 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Leo Yan <leo.yan@arm.com>, Will Deacon <will@kernel.org>
Cc: yabinc@google.com, James Clark <james.clark@linaro.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <aZNec3B0Iou9PYGw@willie-the-truck> <20260217141917.GA136967@e132581.arm.com>
 <aZSAsC1YI5_lK3e0@willie-the-truck> <20260217190121.GB136967@e132581.arm.com>
 <aZcWC25GE2iUKsNt@willie-the-truck> <20260219185800.GD136967@e132581.arm.com>
 <20260225120956.GD4184494@e132581.arm.com>
 <aaHdcKGE94ze2fq9@willie-the-truck>
 <20260303103632.GH1098637@e132581.arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260303103632.GH1098637@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P192CA0015.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::20) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|AM0PR08MB11701:EE_|DU2PEPF00028D06:EE_|AM8PR08MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0b8bc9-b7e3-4ba7-41d6-08de7912761c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 7xUlHssLhYBsg6rcagvrRL42W5UbbbiA53xNa3861blzrizu2yp7GKYbA2L7i+fK2SmMdjLacKblCqvkb++89frSOERpZxY7A6UtdCK4ZMH48LpfMoxwRf9VjUL4oM/FqgxzKBp0TB9lAVZvTubG04G7xoS7E+HW7QyO2UqUDYiBRjF9eMC+QOsjUZeWOKh+KCvkZeM78DBbxSJEHnvqYU9vh1Ip9j1NHJJiqjDMK3BgkNUfEWGmxR54QcR2tLXSYKI11fd7xmi5yGb8XvORObfzhrkViQYlj0ppECKZxPuD+bJkkJeqsVsm4n/X3RclQm0C2J6r/5vwNTJDCmp8PBEoJuYPfQrApiLcMshVbwTuDQGXMSUrqZ+UPujl8f/7rmlCyOe+lTOFC7TR0QWSgXxoRzOOHpmBc3SSTxPEXzSgyvPwXajKxEpwpbyESarOwE4vCRWSHoO/FKtE1YHxUdc3C53r8Qo4+ySJGvGimiD3i3/njiTytcMBJ7bKstw32FnEIJKxidjloidT+uC84Mq3b785LDgokYqdbnUHZB61K2h2d+ydBNyontwBtOA1emaFLRhfceP7fBNaZPpx8b/FIkp19zE8bWFqq442BaIXp76xanBnGBoLUb44Ya0OFOogA492lLmZyi3F9a/iza8mPcZJjUNrpKdoWNhQRh/9xkO/hs4PbGDmdAFj6E7ASLi31ABJuAbMl5Ta+ohVM/uXXWOHDK7CE004Jdzs+5g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11701
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	af0f00c8-5691-4b8c-35f7-08de791250ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|14060799003|82310400026|36860700013|30052699003;
X-Microsoft-Antispam-Message-Info:
	jePWaiIYq6o9x0ycNp9yQgMrf27GbywYY2+oLShgX5K5mFRu+X+6NcH8bC/meoKN2A30QNvazfCfIjOnaewegUcbpZhtQoJYar1vUM3ShO8JEgPJ/lvIyXkN94Z/6YGkyv14MrIu6Ti1OVgkjRO5BxVjZnZRGQmX7S103ZsD0bzn2w5Cuoy2sFC9AhG+3bhoxRbiIMv2Lp1GTs5DG9bnTCQEubVZ5qjxJqYomDyF7HJIS7uLPd01qHe2+PveKDb4KEPlxo0MkRoZ7AUsaUG+zNRTP8URzb9chjdbB7zLOztgVddrRaEWxznzcdrgVsqPrGDAjWkei2l8n3WjisydspsRj8s/+6yo55hS36DQpUvHDnrkEQqBjSswYVI5AcSdrhu6hSCsST8YhREbYIz0a6sXdNrOggSdh3j4ift+nrbagqpTAxcwVS9VwriPTm/OHKWKE2A+fkEycu7NFvhTv5PvMtPR9Il2oICP9p29sy4hOS56swrcyeUGGYlLJ5LGEXOc2mindkNE6C3B6sAjUANGFj/2bTxIpCtRIW9sHxFM5Fjv4sTPAWHAGkkwU1GlYIg8SEce0Mm53rrFY/7Eo15Oii4tztV6OyaM3KhnpAO9DguDBXI8hTtFymILGmELx+XM4in58gmPSmMOwdRX58dIiSkXU/5StjTp4zUPGicJdDqcN8a+YqjRyySMZ5NoFka/A8wyzmGU8jOft+Ju8H4vOwLQdc2QuWNf5o5QC76ImePN/Ns7WAg6ohp1Qs8ccZPrixF7n5NHmPZLhIfWxTz+0Pn0kMyRL4YvmxgQ880yKELSFVVDzJ9Sst6wThIMs99ezZPV/g3DnreYnxbS621K8Bb/DLsyLJxLdaXCmnA=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(14060799003)(82310400026)(36860700013)(30052699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SNJstB3VERb4YHXH4wUqqzHNoHkxrQH68mI/TMfljMc3881cqcXruxKHfqvL0PFe+0Tp8wuz7Y970PE8H3xlAEAu+5nQqAELHyfV1sV8XWVBxB1IsYJEa4a0G8CIK0BJ0H7FkrqgeGTUFmRh0ngqasNOYhCsa8Gc4/SiWFTg+kYPC911lStMV++R6b9CgJEvm6IRxFq3csP0eb03FY38kkkg6pjlV+6INKyvAyhdFNXH+iBBlnk0Q77eJO5geclL3HdT1QahmKwYqXehNrYNhzXMvtIdIvRh5OlSeZMSPTCDsDIjCJibRz5XwXR663SmsNiGlpFFeR+qyOIiE3P1Q/6kkonn2KfwyA7zpqz4kpqOmsV0ykj3NVamPG1fLQCKxuGVcqvHNATet36Yuzi+Wfc5td6i74XFVXjlU362lFM4nvTEW0+1P61hzHlsCBry
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 10:48:53.0144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0b8bc9-b7e3-4ba7-41d6-08de7912761c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6596

On 03/03/2026 10:36, Leo Yan wrote:
> On Fri, Feb 27, 2026 at 06:07:44PM +0000, Will Deacon wrote:
>> On Wed, Feb 25, 2026 at 12:09:56PM +0000, Leo Yan wrote:
>>> [ + Yabin ]
>>>
>>> Thanks for Suzuki's reminding, I should mention that Yabin reported
>>> another lockup issue caused by missing CPU PM support in TRBE driver.
>>>
>>> We have a patch series to fix the issue:
>>> https://lore.kernel.org/linux-arm-kernel/20251119-arm_coresight_path_power_management_improvement-v5-16-f615a301ad0b@arm.com/
>>
>> Two nits on that series:
>>
>> 1. It seems a bit weird to me for the ETE driver to manage TRFCR but for
>>     the TRBE driver to manage the other registers
> 
> TRFCR_ELx is introduced by FEAT_TRF, which is a separate feature from
> TRBE, and it can be used for other sinks (like ETR).  I think this is
> the main reason that it is implemented in ETE driver rather than TRBE
> driver.

Thats correct. TRFCR is more tied to the ETE/ETM (e.g., filter traces 
for various ELs depending on the event configuration and also for
changing the ETM/ETE states). That said, we use that to prohibit
trace while we do maintenance on the TRBE.

> 
>> 2. Are you sure you don't need to save/restore the TRBE state when
>>     LIMITR.E is clear? Maybe the driver is fine with that, but I'm worried
>>     that we could suspend in a half-programmed state and lose some of that
>>     configuration.
> 
> If the TRBLIMITR_EL1.E bit is cleared during the CPU is idle, then the
> next time the TRBE trace buffer is re-enabled, trbe_enable_hw() must be
> called to reconfigure the TRBE registers (including TRBSR_EL1).

We don't leave the registers in  a half baked state. We always program
all the TRBE registers when we enable them. But, that said, we do have
a case now with the fix for Disabling the TRBE (TRBLIMITR.E == 0) for
nVHE, while the rest of the TRBE registers are retained. The chances
of us going in to Idle, without restoring the TRBLIMITR to the host
value doesn't exist. But we could save/restore the registers to be
safe.


Suzuki

> 
> One concern is that after a CPU power cycle, some fields in the TRBE
> registers may be in the following state:
> 
>    "On a cold reset, this field resets to an architecturally UNKNOWN value."
> 
> I will change to always save/restore TRBE state.  Thanks for
> suggestions.
> 
>>> Besides your fix the translation regime issue, I'd also suggest applying
>>> the CoreSight PM patch series to fix lockup caused by CPU idle.
>>
>> Yes, we definitely need something like that in the android kernel trees.
>> I've previously bodged a hack into the ETE PM notifiers, but if you have
>> backports of your series to 6.12, 6.6 and 6.1 then we should merge them
>> into Android. As it stands, I don't have a TRBE-capable device running
>> mainline.
> 
> Let us first merge the series on the master :)
> 
> After that, we can consider backporting (I assume Yabin already has a
> plan for this).  I'd be happy to help with backporting to v6.12.
> However, I cannot commit to backporting to v6.6 or v6.1 at this stage,
> as many dependencies are likely to be involved.
> 
> Thanks,
> Leo

