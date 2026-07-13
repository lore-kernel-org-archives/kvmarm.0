Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013062.outbound.protection.outlook.com [40.107.159.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B00B3859F7
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950236; cv=fail; b=iFC4B3KH1vkcppLYsLnPZGvIkJaB7L2d9qc6+2wEeqAxFSMCO1pixlhnnrD0iC9QbhO/NmGseco/iP2aJY7seTQw3AfJQFFWrPV7cso/DoPYNEoIN3hmR+bvntRVG1M4bPMnjFYNCRgQlBS6L8jElxpuJyMuHdw0H7sQjK9YHMg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950236; c=relaxed/simple;
	bh=gm1Y2FHCXLhlzAN53s0HluE7CArjW/eUg/Ncr5+mK5g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ENPN7oR1SmMmXK+4DMaj+BBhbgnaBxih2TY6akB5m0G22uMHEZsEVeVwgw37DDSbLg5v0QYNC3eSXQTe7o75K+PJYiYhi9f24lwBI2u0jFwsP0jcvD3e9tP8K/CCU+UhqkNog1u2iz/LmcfmHtMmah4GCZ8wpE1n3vTqDlJWybw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CRB8yTvV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CRB8yTvV; arc=fail smtp.client-ip=40.107.159.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CRB8yTvV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CRB8yTvV"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eh2pfVJzAj1NGrvsdtku2cU6wBhKAe2+kZ+J1hsJOAx5edr21k4NCcmgBi/Xqk4y4MIKCfXEq9RfoejpfaQ4TCvQL9DdAYVyDkXesXTV9cvKOh56G9ahkmbN7jTas/vQAgy/gYgmxlt0EVJzau4KT6f70WseqwJIsrGMZ2T2geV1KbfNknoLrp26CwVw2s8CjoRmKi3m8PoM+EtkGrfy3uJTUyjRNTO17AmJxXA1uCmqkZCWD9xWaMUxzbJScXKBe8DkKKNPLhWU1bA8dZF/v5uJOB+Z5V5eifGsmJn6oXRb1NbZgT77YS9AqOk5o+05/fxsfof89U0OV3k2UE5VlA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oqe66u+7laYTduB3fCbqPzp0apkrbgqUeYzANKVlPA0=;
 b=S2ZRDSsLFQPBmbEiKr9pzd1A9q+jk0p2f8hYQkXcP5ToyvOOQlzTSTlDOOyL3VXwiKa73hozBH1DxI35BACmCRCsIqu01JtttFSoQq9LJvHolSuZEAR8xrytTjcDvzjpZMexeza836SQ1VeMYL9TLImF/Wr1eahtf1a96u1MAI0o7or2bkrOePOJD/6R6mAdAK6WCepOWFClM1PHaOIQtuIT0Bg1rsUOCRP8Tvo+ggZkp2RaCszZ2JN28CivsGLIY/i8afKlOiy/4feB1nEUUVqbyEjrcLcitbHVmCgXBiZ57NjK03vpAeq3ZOq1oCMcawV8VLJA7Nnqs2IEujrw4g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oqe66u+7laYTduB3fCbqPzp0apkrbgqUeYzANKVlPA0=;
 b=CRB8yTvVWfugroNdZokt9dT/otdJ3pg+PkbciS5KZrHGRk0X+BVUW+UmoZP/dcS0ILArn5U3LDxcBKdZdsn7ImY9GnAMXE0yN9m2YHmoU1DsRUvnUkBGY1R/Y8Bjrj5WolriYL8Qy2yx2VxpqZhIsC/+jkpVf4Pqse/cqOFWB9o=
Received: from AM0P190CA0004.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::14)
 by DB5PR08MB10114.eurprd08.prod.outlook.com (2603:10a6:10:4a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 13:43:45 +0000
Received: from AMS1EPF0000004D.eurprd04.prod.outlook.com
 (2603:10a6:208:190:cafe::4d) by AM0P190CA0004.outlook.office365.com
 (2603:10a6:208:190::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.19 via Frontend Transport; Mon,
 13 Jul 2026 13:43:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004D.mail.protection.outlook.com (10.167.16.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9
 via Frontend Transport; Mon, 13 Jul 2026 13:43:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEYiK+FaZUY/33bVGL/fZrhZP4SRrU2vsPJxivWUA5Ef8TX2+xHdWTdUtnwN1NgIYYge7eg1yqtIWHtCBOTVIN6KfiDVOKATz7MhM+aZSBpFdYBwfDAsUe8UpMXYiCJoDwvtzRrt8IJB4cEL46zLqSVs1GOMXyNbE4E7NtTinnsHAdDsAkwG8Vy4hRAJxBn1FFiZMshB0cEfZlkJpSBGu2Junulb89iI7NV/IlXtFmCjonoK4tzgcdvMeCYRR2mxM23FDFsVZJjRB96hV9ulBEyLe58FQ8g2nociCGYLMJSx4vub5HO07SbWCwE/VHqzzd0v0EefEwOW6GlYb1Nopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oqe66u+7laYTduB3fCbqPzp0apkrbgqUeYzANKVlPA0=;
 b=n64bsWxBehHpIRExw1LJN2CuvHgnGOclBk/ChEaekDdp46i1iT5OXOpUtP+63DwWa5Gc+IEeILmwqPsHXjEvzEQ7qLohd9RNZ85Nbz3p70KZFfjItIHIGGVTgm3DFAAp/bBeIfGEePH4YnmQZKLehsj0Qn6YQ7eWyXoq35eUooHSC+PqUVoDLIClQpOzNzIJpcSx8Y4cTj4+xJ709jXUMm7qVG29BST0KFHo9Bfo9QXdUqoCOxwDMAbv6Cs98qZG25VM2kRgPIfTdZIlUMT2G0j57iCD1bghzAmB59FhCbjMiH+3r1WldscEgQiTRov3fOMr2WnjV0T6eNvJwPRbRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oqe66u+7laYTduB3fCbqPzp0apkrbgqUeYzANKVlPA0=;
 b=CRB8yTvVWfugroNdZokt9dT/otdJ3pg+PkbciS5KZrHGRk0X+BVUW+UmoZP/dcS0ILArn5U3LDxcBKdZdsn7ImY9GnAMXE0yN9m2YHmoU1DsRUvnUkBGY1R/Y8Bjrj5WolriYL8Qy2yx2VxpqZhIsC/+jkpVf4Pqse/cqOFWB9o=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by AM8PR08MB6435.eurprd08.prod.outlook.com (2603:10a6:20b:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 13:42:42 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0202.018; Mon, 13 Jul 2026
 13:42:42 +0000
Message-ID: <a54c6321-a89c-4d33-a239-0f941777bbaa@arm.com>
Date: Mon, 13 Jul 2026 15:42:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track of
 associated memslots
To: Sean Christopherson <seanjc@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev, mark.rutland@arm.com
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
 <akwhexqW66RK5Gru@google.com>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <akwhexqW66RK5Gru@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0125.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::22) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|AM8PR08MB6435:EE_|AMS1EPF0000004D:EE_|DB5PR08MB10114:EE_
X-MS-Office365-Filtering-Correlation-Id: ee846e4c-b533-4f91-0bf4-08dee0e4c238
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 cweZPo9rO8km5SeTKDkV66Tlx8lqdL+/xWSLZuQ29q92TJGdBTsQk1FcEoD9tJemXdlMGmsiFjeB6t4l8OjLOeYplWMsCyfMlydZ8A1uMWyttjGMkS332K1D00OUT+116qkI6x5qibpXG+WNOIPFUR0jFhVy3Ubi2afMr7e02cOXv6JnMuhUPxUJmgM+VppC6WNDlXrEDMS7bJd1iDgTvoZkGHJq+IxXhb9pwts/JGjGz3WdrM0zzFmF3j3j633BuB70d/zMyH5RBJQz3D4JaJU79UpxcuWmx5PbaYBESn2I36PRRuNtjvAAEXQp90LBA/OtBYFoh6SDVGdTxWUONtY1uvM7jkY6YOQCN3v2CXgUaJYlev2aIKJbiM2EsI5hGooKwGv+0iHXIR2Pf4waAUdB6uk/6Q7pJ+AKBl57gaS1r56oALw2vchipX3Iww+Oa9fDcyemQX8VlwcxV/Z/egDVwscHEGqz6BMgPzzx3l7gx4AXZkDKOQuVfsChDiXxlhBrBbzU7lIRiuMJpRC71fPVk5pH+W9+TP+PHDmZTqKGXPR/JhOy84N+DZj7PydM1uZHF/+SuAy++dOJtwh2NhLjwOh8Ur2ZFJfJFY2muedac78EIlFZfAieNyRRFqCUm5eQqJsD1cEdKEav1qtwwuokJT41YVe12zqqnXcLa50=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 XL7hGbCf5LgMtVkQUFWJMnj/zydDOW9mz8rCAOQyLjvYtMzBj3MSmlTOXQPme/VMbfxsE+pKg0wrCkKayBQstIky3dUVf5Llbv6S/qFIkHRmi3MudNa+h/X9v2c8gmHU8P9nz9FW3xP2zUb8l2uZCbHyY/LX27iyN8VONDroVhSQKlj3ydER60KeqUPQz2ArJ7zbngEtcXBopBf3N0g4fEGNZn8OE7VBwjgeqXWM82EcBixJ3fJGkOrHQA2oGz4moae3JqYRGIsRFoEdbO0N750furE4cjD2yg5f+qsEieHjdv78cOyp226dF8cNwi+9FhMLunkmZqFjELjEHi4Ogg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6435
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fccb98fa-a99c-413b-b80d-08dee0e49cbc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700016|35042699022|376014|7416014|82310400026|23010399003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	32UqVgIdJsCCfW/8uIwRuIAjuH7V/OXgU0gskhhpHY+5jcD/P8EecYGEhfTIPbC5QuIRCjk5IV3wklk4jagdEgig5z86M0MHrhw76QPgW6FztzxknlOodcZxtQfdyv6q3E8f1oERLY/lwIG2NcJAlKbjOYWoehN0f9qS8mLjlzA0eF8PE6Mp8CEseD3k/uRutz3ScZ4079g3hhvCH/N4On1HWNdhrlxW1qxhgXJBXm0eaVmH64F1SHlUikGzDqi7/e3Q7md8rg46zhMMohQKaFghbN3TmHg20FbJ4nHmTnZS47S+WTIUVYoQzCLF0A5rPaSgkYP0FfPOG406XlrhqlrWDRIB3jkxh3KyrG/AWd1CUpE64G2rxMZOxRMNXsjam999zoSDvelzGkSf9g5tWho1DihY0E9X/uXTS4PjNeENwAgXaBvpVUqTGxeoTnpTDymQBeff4Yc6NVb9YOuzTf33C9LYhrzmNX/ZdM9oN7DFdovOsPQzfv0JMk8o0K8S91ScqpmATuRp+gGXZvWhQr3I2WK+ekDbfrSgOwYxIkLtF6tOtIdRoBUNjkgIsAGXE9EVONTugrkCRqB+CGZplfTpX4tvQTFusho7u3y+RL483h2sHbmNoYMSjkpLBkjZMYsXRXR4gGhgm7zwx8gqP31hjBu9ZONgNyst0p7gdyPrgrVX3I6Mx5wiQLK6+61JhwUVGwvom+TAhP5sdvHiUA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700016)(35042699022)(376014)(7416014)(82310400026)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	56ZAIDhcqIdY8DMUNXvqUK0JVkr0laVbu++1ChEmljseixC7vz3U3rhXS/gD4CKE/xHGHCRwnsE8VXFwH6RzLxSwtjHp6g6rfuaVpgy8e5YbdK0agTNZRxfi9QlkKt0zlpWEKMEcJQEXnVvLu296UAyjFRzEJtk/RrYZfb/yNyry52KySyi5FtZHdDt5bezBAnbXgyN8Vhzk9JcAqDaZJqoLuFjr3FAlJrJWh+OqW/WFWPfPLp/E2qGxKLTTSJ5/d5gUu3+s7quuWC0cmfJw8ejJBtX8n5JeybtT5YIbOqbao/vIGlgVksjydd0t3+AuyqaTsCOingDDWKSKUmUvlY1akmIrsfG0sqfZAnU+yN0kBzVDFhY7A/f5AvfedOagE9bmCS/bstefJWtIm4WPyMKPEVIaYzSa17XZhHN17XaCG90luqAqg7NP0M9QBaWM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 13:43:44.7847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee846e4c-b533-4f91-0bf4-08dee0e4c238
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10114

On 7/6/26 23:43, Sean Christopherson wrote:
> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
>> To enable memslot operations, KVM maintains two arrays of memslots, and an
>> RCU pointer to the active (in use) array. Changes are made first to the
>> inactive array, and the RCU pointer is updated to point to the inactive
>> array, which becomes active.
>>
>> The guest_memfd file maintains an xarray of pointers to memslots that use
>> it as the memory provider. After the RCU pointer to the active memslots is
>> updated and until SRCU is synchronized, readers can observe the old or the
>> new value for the active array, and therefore the old or the new pointer
>> for a given memslot.  For memslot creation or deletion that is not an issue
>> for guest_memfd, as readers will either read the same memslot pointer saved
>> by the guest_memfd file, or a non-existing memslot.
>>
>> But when changing the flags for a memslot, readers can read two different
>> and non-NULL memslot pointers. 
> 
> And?  Why does that matter?  KVM memslot updates aren't atomic.  Practically
> speaking, they _can't_ be made atomic.  Userspace is required to quiesce all
> activity that must not observe inconsistent state, i.e. userspace must pause
> (stop running) vCPUs when performing a memslot update.

I agree with that. It took us quite an effort to sort that out in QEMU.

I was especially when nasty when, some guest activity resulted in memslot splits
or merges, while some VCPUs were still active.

-- 
Cheers,

David
