Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010004.outbound.protection.outlook.com [52.101.84.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F53B961A
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 10:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773137654; cv=fail; b=CrkCWPaW67R5rNHI4pwQd6ILRJdnsYl3YxZEmlK7uK4vEX/+sMaGrPAxXG6l7ChVKj+Ar2dZ4fArukniIxebEA1LchMt/ckeG01jXoz38YUHfioC0G+od8Xh3vgr8IyojIuG3hOhPh4Oe7U+uzw4eyXwrsZePZuFCvtOhz64WV8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773137654; c=relaxed/simple;
	bh=5BbxYhL+hyaVEHt3LjDHf+uw5hhnvsX60qsHzviz+wE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=snbeuiyjYk/tT+b+pX/3uX7sQLbvv6JAnIf9I0j36CmTIwU+HWYt9MgxcOXKFd2ccLqiOhkYNtzNfxIy5qFN9n4GcmpEzZxMg00JoIK07Zx6NAZGc5p9zyUqGAlmowIwA4YdE9cWF4jviBG0TvuVmmfXAzlMrniuzRRyLo4hqiw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g2lNVnDZ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g2lNVnDZ; arc=fail smtp.client-ip=52.101.84.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g2lNVnDZ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g2lNVnDZ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=o6X6gSx7UnQxAiJ2lZeKNQVOeTylp3TJJQ84qzcLmV5z9Sr2t/VkXRTkG63fFmkY3azvQysSkLMW+zjwXxO9D6Xlz84b5SMNR6RagClVBqzwl6WVKYW8UCi0njoMmPaupWhW1xyVuhSAxzkptfaOBne26CAUFBecyyFppdpiGjWO8yyjQru3zq+eU39S+gXHznWPDMvQqMtfLfaD3m0PG74PZracjYgTNRPzIYTXudifEHjzPrH2K8ywmUo+kteKKdy25HbAGdv7/uQjZmw54BK+7Wca1JPlxn+oJ31iMCnPlIyYSMNg+tacuLAUz90wI8S/XsbNhkkM3GvLxRCDgA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75fJgtMiuv71uu2+0KuMSE4uY3sN9niqpQ3au/YGYVY=;
 b=j3KNScnKBu+XWyYIdntvgpuQbReSXqOpSn/AT5buBgOFCUAUjg2VQp/Sq5iED+IGprNE8TDH9IoxYgQQ9Zz0qridewYdO17A4795nTtsv3N4HOJ1sK2WG1hl7fHTZnMvJfWMZFcgxQz4QSm/zBMzukSgeEKMRZwQiigdMZS5lfP0/dYt26vbmY+x3opE+C2xDkGoN5vCjkkz1hIr3Y7Lms0qH/0W95LwWfH9UYqme+Wmju6KS5Q2/PdzzS5u2CQdTxbcvY0B+EckmSQ5Dls8Fp2LlxIqBCaS44uE+7aF6uaD0pk2dNCgmCoF3c4ycaRozxnvhMPZLSZrLqeGhLANvw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75fJgtMiuv71uu2+0KuMSE4uY3sN9niqpQ3au/YGYVY=;
 b=g2lNVnDZAKCjW52K4/PEImmmI8pQlXApL8/O8VmarpthyHHap5SIto3P9qXPYlKyWTbiU5AsLoDh/3xPuPBcBsMJVrLDo7eFsCS2DW57vSYp/0L9phtecjoQEKwZC7dblhNY9f2bj09gNdtXKpLsd0JlP+d2c+NcvF/2uy2uNcE=
Received: from AS4PR10CA0020.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::10)
 by AS8PR08MB5976.eurprd08.prod.outlook.com (2603:10a6:20b:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 10:14:07 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::5) by AS4PR10CA0020.outlook.office365.com
 (2603:10a6:20b:5d8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Tue,
 10 Mar 2026 10:14:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Tue, 10 Mar 2026 10:14:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eGntd2EAARV68YeG5z2WtcHwPPuN9UvhXsV6y1+a6zFQrWSY41x7a06L3HJiQ1OJW1xOpRgHmqtFuTxBWrTvOR9wTQev+q/1qYXpi+cQN3qguaIaGo5xLG+N8B9Lg89WYVT+kapF5UQiN398jB/q0Sh4g/+FGF9kzR+ESczsEjMPdAs01bs6QKlMMX4SWLia4aKeCQqYSjQyC8SdU4R0H0H8aMh7wFfV9acZmCQsykF+PJoLF5ekOM5rqYBgIkMV8COnaT5LQOl3Y7tg/8qlOowrFrm1xMetkEnM8JcNyLfw8/xLSUE4mmDXU1i3JLPBAMgHASjWq2AMCNe51UXL3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75fJgtMiuv71uu2+0KuMSE4uY3sN9niqpQ3au/YGYVY=;
 b=Jf6jkVto6paR69vc06E1BKk9EayftaRsxQoahmvUcand+xWgolTq/rOdrrUS7LkrZTPKuWsrAPtFZXva92Majhe7OKYfukfeWUiwY0HBYlk8cyoD4wNmj0IzMmpKTL90ZUaUnaIzEQ5eJRJTSohYHtXtGpbo1D6g55lPaUJ0XB7sVzVH+eur7dUGPsLr0bivZrHoWXfzVsgdl/m+E0yrGdJoSWkJt5tnQG+1Mk8MWG5ec8tcfcCYF+1JOTpsfWfkXzDxsKQ8sPx0+V8MxMdHBoWASbhE6Rk9Fj0RXop+H8EcOo+hNxrYI5JEomfwafygwXwfCuSGT5QFQZutJkHvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75fJgtMiuv71uu2+0KuMSE4uY3sN9niqpQ3au/YGYVY=;
 b=g2lNVnDZAKCjW52K4/PEImmmI8pQlXApL8/O8VmarpthyHHap5SIto3P9qXPYlKyWTbiU5AsLoDh/3xPuPBcBsMJVrLDo7eFsCS2DW57vSYp/0L9phtecjoQEKwZC7dblhNY9f2bj09gNdtXKpLsd0JlP+d2c+NcvF/2uy2uNcE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by VI0PR08MB10990.eurprd08.prod.outlook.com (2603:10a6:800:252::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 10:13:04 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9678.017; Tue, 10 Mar 2026
 10:13:04 +0000
Message-ID: <7a3f67c0-ab25-4b74-8002-0650cb3ffa0d@arm.com>
Date: Tue, 10 Mar 2026 10:13:03 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on
 CPU hotplug
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
 Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
References: <20260310085433.3936742-1-maz@kernel.org>
 <5a5afd0a-de2d-4697-a5ba-0e470ddb20f2@arm.com> <86cy1c6mve.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86cy1c6mve.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::16) To AM0PR08MB11754.eurprd08.prod.outlook.com
 (2603:10a6:20b:743::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB11754:EE_|VI0PR08MB10990:EE_|AM4PEPF00027A69:EE_|AS8PR08MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a88171d-2137-4524-b46e-08de7e8dc355
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 7i76hJnm5ZdVdM7/1mXsKWS3XwnZke9ZB+IxWWQUHYUhUpQt8XlNNz9eb7DTQnIQQ2T0mghMh6ZetPyLpJgWH30luQNv76aAfxQoaYekIT3tYbI6yC4y3nPKASi3EyaDTj5k0l+UwmXxzno8brPoVd5YaiRKpTbOb9oOsfdyEx5gBiPpCTfSrfOdWARV+6kNCsYS8+39SuopzhsSZQkrp8iKO5xVcbd/QLDTGSeQtgOXwbw9ZZO6Xhc0OtCvqaG7TX7BfOI//eNY2BQtL9PUy1EZcgERQEo5PYzsOuzY8wEcXvdPvZo9XJLg/hwYO8YwiA3pu3zDyCwU9uqoX7tqYort6oLj74WXKbSz6Wem1Qa/+eUOEN4XkPsSy5OVWfVPDbt40Yg1Vl5LCKmOAwvZzJOnelyoBo8FgmgGd1PsSNaWrxfsW2HNg9SssUdNlw0+rkLgExzz6ejG9IDfXQChIarn3ghE4mKzEL3NtLv5PxLHI5iUXjAP3/vxWrvUkuB3YZYFyxd8vqIN83sjRRecjKqs6EHPnj69DbdcH7h73WHmH8aEJ8Iga3A7254Z8cdYtRgJuGw2BYUtQnd5lLvNQkfnXi30z40Xo4fSEw97OX2FgP7/m8VCw9lQIEX0OBDwrrr1+WdPmheCnuJQ8/5CSddF2vAcCfMV2c7bzEvn1yjsUiRyqj/G/NpEIJjRXNHhtOJuKyzSfX6c5nVaYOpcCTqkWX5TVC2aRq0PTHgpPjo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 FPQKgXPy4SlGneXnhDJ2CzNlWWobvBuSnf9KfU44/PDP57xE5efyvyYIMqtAhafbcmb8LntXBjAVxyl+JFtx0dIoCsuHbwnGJWFsvZOQUEAD+0AcgkL41B60q1cLwS3w/unWkm9caclZMyaX9m//zzE4m8VH3HyBeISN68DRt2ZQX5hm3G2b+cBYVDbsveogL792+JrJaSBPlE8tpCx/zfoo1IQLnU3G2xq7Z1T5kgqKPbdJ9I+KCPCC7viwHm+yLpKijT6RRKcWiQYpPB/VLsRfgd/d5MV2eRmRIndFR/px/4YTTcTkhSLTMEU6d/pgzXrW9jddpUbSeUhdVQeS7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10990
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	83bc4056-0fb5-4ebf-8ae3-08de7e8d9def
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|7416014|36860700016|14060799003|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	eVoE8okahumdgyfGG8/+zh6GEsP+hbfCkqpG4AgeDXnI/xa+QXQysYFP4rs+jSQ58G7tm4lMH52ruxu7UQeK5Kj7360ibW36wmois+fPgAS52mFTG/y/mTUgpZDLjY1MC8EY3homA1n0UAn1GQyTXQVEJmuUPX7wFzmBVYb0TH2DTHJFo99c3vJ0Q6YB+Q7mIAV49h7wRN8vHolw6m1Nff0mNcEAKUL//mvh6bAxjKHAo+n6JxC/VU4P/QeZfSOHmJ+dFSvZOpf6w+OM/A4AB2NFZ6tKROlIbDsPUbpIbLvc8sx8AWIybmDSmRjtEdbFdsScVVgfGqiG9DoozRio8jImpH5xsFIlZpE70Gx3siVhvzoyIy/2HGn1oysvWUIOa5XUVdxGnpcVIc8oNs3LCAdaMVqlw8U7kRzZcdY5mNToCLZDkjm5AMHs3Fi6cqJPATx+WUB93A//7Jeq1zimKpHgG+a3ky86Yc8CdGtCvqLY176BlPseZZoMmmm4O0wKSmmAoDsK7vIO5geZ8194oivykcba9cGYEbw5dpJNpeqm1K514/4judUxx9mJw8rrDXkOzSO/uKeKcHHdhQkzs5NP6d2/PvlBACDsOwiIRJj5R259pXIJbyktYy7W/OaJZyqkis6BfayVBS7t0Zk7sKtlDEyqmDiRHvSIMwt2GLZBAgwQZ1RxqWnMrGQYmuC6eNDosKjoIyErF/RakQDU5HT4qnHO9Y/meOf33gM7/nVS8MPdArIz9XHPiRux6jtEtPtXRPu+/4lIyGMwLdP7Kg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(7416014)(36860700016)(14060799003)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	89phEBJLaQHOCMn7c3UZw0FFR6XK3NS1ZeBS5p7ZJ5NJGZAjHP7gsOZsBLoi/w+1S0gRM94htMOJWtaop4J8yHs/pUmY6HE2jK21n8jvtNSVzSCm7mxlwTgQdATpooBKuu6jNmFuzRHikN9SlF3TDVlBMXL5hkiQkBIQIWd9uZrDeN3ogDBqExdN3Zu5tQfFGbiL9mReEHDOQibnsQVZfoVXAJqmM+JITPWRAWPpXa9BqVjAcVLd88bVUdZr0CkMZILZACY0SRL/o/1wuuhBj/TnPl2fxr4VTybtnFDRCkdFWT9nXol+ACTar+HLjNksUb+s2KNLaRlxdPUwBeH4VSeCRLkrN0CF/xsuNyu8ji/61P1+x/M19T98JeT0Tka5GkHhY4UJb5Njhbd01jtV/xgIvIBnrlI0G4kVy6+cUbbp0r2Ssg8XCGF1tE0GVofI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 10:14:06.4877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a88171d-2137-4524-b46e-08de7e8dc355
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5976

On 10/03/2026 09:43, Marc Zyngier wrote:
> On Tue, 10 Mar 2026 09:17:43 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 10/03/2026 08:54, Marc Zyngier wrote:
>>> Hotplugging a CPU off and back on fails with pKVM, as we try to
>>> probe for ICH_VTR_EL2.TDS. In a non-VHE setup, this is achieved
>>> by using an EL2 stub helper. However, the stubs are out of reach
>>> once pKVM has deprivileged the kernel. The CPU never boots.
>>>
>>> Since pKVM doesn't allow late onlining of CPUs, we can detect
>>> that protected mode is enforced early on, and return the current
>>> state of the capability.
>>>
>>> Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
>>> Reported-by: Vincent Donnefort <vdonnefort@google.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    arch/arm64/kernel/cpufeature.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index c31f8e17732a3..947ff71b3b66b 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -2345,6 +2345,9 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>>>    	    !is_midr_in_range_list(has_vgic_v3))
>>>    		return false;
>>>    +	if (system_capabilities_finalized() &&
>>> is_protected_kvm_enabled())
>>> +		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
>>
>> Is it a worth adding a comment here ? Otherwise this looks very odd -
>> Returning the system state of a capability for a "hotplugged" CPU.
> 
> How about this?
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 947ff71b3b66b..32c2dbcc0c641 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2345,6 +2345,12 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>   	    !is_midr_in_range_list(has_vgic_v3))
>   		return false;
>   
> +	/*
> +	 * pKVM prevents late onlining of CPUs. This means that whatever
> +	 * state the capability is in after deprivilege cannot be affected
> +	 * by a new CPU booting -- this is garanteed to be a CPU we have
> +	 * already seen, and the cap is therefore unchanged.
> +	 */

Thanks, that looks good.



>   	if (system_capabilities_finalized() && is_protected_kvm_enabled())
>   		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);
> 
>>
>> Otherwise
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Cheers
Suzuki



> 
> Thanks!
> 
> 	M.
> 

