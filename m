Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011003.outbound.protection.outlook.com [52.101.65.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6A40FDAD
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773134332; cv=fail; b=X4E478XUwEGanl3QKv9bGWZPbv6MYodb4z7fs8GxCirtf4n8EJqNnr6pR5l8trEr7XDWduNJtL89OoZ1gDDhmGf3tqlg+dhn5z2VpIGRBiGSaFzb5JK7OuoZ6PjUt9mYsc2Jot1oSlnJDBoVP0mspy7OMPjgVNawSkqkB+W3Kw8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773134332; c=relaxed/simple;
	bh=CuFWIIv+VOpbB299XH+WTBey1t4onJoM39NW+WIAkao=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AgjJbxpUIx/ClSjaFAcgXFalnIDKRjhr8lAuscGK4OKmRC6Ufr5SoxpH5VUX/rAUZoPtOO4u8TC3Sce2OfuOaw0kg7TTqQJwd3W09TBQWpvKPxsmW9bB5gCsysiNCXyYTtZc9nKEztDsqcIHFCgcq5ntHwKNrj2dtezL4icci+A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VUzS/8hd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VUzS/8hd; arc=fail smtp.client-ip=52.101.65.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VUzS/8hd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VUzS/8hd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bjMCN9hAoddF4fsCeUYXkHhLP07sm1cc7OaMGVH9ALjgecV5APTAlmSKYLBC7tm/Kns2FtcwpYUDD9QI9grV8Q3y37OuFR0iI9hf5mLBoMFZukux/Iqx3H+zmrAlRd1zk5y5BAoMpCt6GSLX5vj8vy6Z6IuCXLgxAv+Vf0lEsHETZxXdbou5aBrJZR91q/yPudGzHX+vF0Q5JlUubw937D+9tQr25N2ErLZedx31PkKmCV6zOIbbLWgAnZIDwgtCV426k5zqOIVP4yTn65o2sdFNGqouunrr0LHHwiGSDKSw2Wzf7WIPNcPK8JiohvBbKWCHyUmVaHJkqKVP1Zhi9w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ADtyX/5ASGYqaEHcYgR0CUzzzgvVFE1tRSQQc7PvdI=;
 b=xrdcD1V+1jADpWkXqgxrQARZ9XOahs/5abO3V7QbLSPBMpjC8t7V4P+CFhJHC4kEBLZAgX9joz1UF4tqbi01XAzWxo1d4q+8mYg9v6Qazpv0o31Szkdwydu8kwUyzMeLmXKzeODMSIRjjBbBoO7ZaYZxepkSwYv+LyF1H60XxV3VES/qV0Llw/3Dlf/oSGdNciRSkCwJX7IVmXR/mWTZZRddqJbKbJ0w3UuIAkw07BrUsTft8mGjL+yu37npkGm5GPHK4tbSydRFUfda7C/2+qQeMOg4kLEYOc4nK+FABNqimocJED+iD9PY3j0ddK2LQzc3tBXt4j6cyUQ2jDX31Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ADtyX/5ASGYqaEHcYgR0CUzzzgvVFE1tRSQQc7PvdI=;
 b=VUzS/8hd2MNtYJYzT+LLQz/KXNc2sughLMygH+OhHUHZy/qxHQ48/LyDT5ElDdLljiBzK45ay5TIUOJrlVPSvNzTvVdnrMfj8a8pFWUEfBeKCYmCdopkctTjtcMSK0X9vvcKiBiS2Y4XF/X8baZYGR5cuUxJgHSB2JAo0A8WFAM=
Received: from AS4PR09CA0026.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::9)
 by FRZPR08MB11874.eurprd08.prod.outlook.com (2603:10a6:d10:1cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 09:18:48 +0000
Received: from AMS0EPF0000019A.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::ab) by AS4PR09CA0026.outlook.office365.com
 (2603:10a6:20b:5d4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Tue,
 10 Mar 2026 09:18:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019A.mail.protection.outlook.com (10.167.16.246) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Tue, 10 Mar 2026 09:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gofETa8eKlx0W1Yj1e3UYCm7Hz1w3V1J+oQgCGqAGrxKMXiOCxEzloplW/HiOyNeFEMLpx4DyRHCCJY+i0Oi3aqMdOnCxPVQJ5eRU3N30iuMTVJ/5aEWa1FtZ/fgmORplOaa3KdWkNYTiGIpKzx0p8SkM0HStZ0SuFjEj4P0fe2UFiAgR39b5GvNk+5rorg3K2mNf0lpu/XtNlmfj3VzhEHA4ChGbGHMh+Im3SOZ7PsCjL4B+s0AR0oUcSVvsHbo7rUEj7aIm+dMmqYWVOCsvWk5QUlGu/6DMnYizxBOAo+VNF5SmSPLy459y/X+jdl/3tePlLt+vNpD6cVDUakBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ADtyX/5ASGYqaEHcYgR0CUzzzgvVFE1tRSQQc7PvdI=;
 b=NUbQ8cHokb3FiVaqwS6OWSyal0PCUc6LPpoitv3s3wdlu64qaiSIUvaKxxXmnLt/ZK94lsTJmBFxUkmObcrxHSdDRDWZqguVxvs7TwV8vgCpuF1t7b4SI7lIaNEtgso5lg7OYImq3QbLLYmicKsE2NOYbO6i9qROjqzHzAcyN8cIyWD+qU2zAa4CZj9KM+fd/54ohK0LCLuKehCGANY0wt09y1uBC/tqmnFjCAzh3jjf6yIAJSlK97NkQx2IMfyATe85MD5dOB/vINs6GsyxRT1a9hKfJ4Ezsy+wpVw115BzhVSCSj+qzRHLu6XnHx6cCz0bw5m+Nd3V98+7CDuNtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ADtyX/5ASGYqaEHcYgR0CUzzzgvVFE1tRSQQc7PvdI=;
 b=VUzS/8hd2MNtYJYzT+LLQz/KXNc2sughLMygH+OhHUHZy/qxHQ48/LyDT5ElDdLljiBzK45ay5TIUOJrlVPSvNzTvVdnrMfj8a8pFWUEfBeKCYmCdopkctTjtcMSK0X9vvcKiBiS2Y4XF/X8baZYGR5cuUxJgHSB2JAo0A8WFAM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com (2603:10a6:20b:743::9)
 by AM7PR08MB5318.eurprd08.prod.outlook.com (2603:10a6:20b:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 09:17:45 +0000
Received: from AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850]) by AM0PR08MB11754.eurprd08.prod.outlook.com
 ([fe80::3427:f97c:862d:1850%4]) with mapi id 15.20.9678.017; Tue, 10 Mar 2026
 09:17:45 +0000
Message-ID: <5a5afd0a-de2d-4697-a5ba-0e470ddb20f2@arm.com>
Date: Tue, 10 Mar 2026 09:17:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on
 CPU hotplug
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
 Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
References: <20260310085433.3936742-1-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260310085433.3936742-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0323.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:395::11) To AM0PR08MB11754.eurprd08.prod.outlook.com
 (2603:10a6:20b:743::9)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB11754:EE_|AM7PR08MB5318:EE_|AMS0EPF0000019A:EE_|FRZPR08MB11874:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d2ea2b-df4f-47ea-4f0d-08de7e86098e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 fBMfSwnvxqwxkJV3xM4UZ162b0eP1VV8WxDkdkEWs8wUs+k4gmzHEPOcSHGY0h3hOOuDKWOlAddAuGbJi4RAZ6rVyHpTlcPLc3pKD8xDTQGZzsdr0mDC3nD6E5rFJ/AWPdqAjAfk68ZYXATXsnei32cb72o6QnJgvsj3arlo1X4A/VeNjTjGLILMXC/jL9IBn+lJ5r7pkfFcpvaGginMV7n29m0H1OOr+HwZCP54mk5UZxOxetkxOERNEFs5/jkSBqSeJygk9okH5AW+8aA/47NOM6+zqZtwZm4K9XYgjSP6LBCqFMGGcw7WHDamTUk6oV5rSIRWN7tFNcUYFFMLVuABBzOTR0eO0A9lckQZK/0Tbdg0PGSJ8xg/A9haNHBKPZ08WsN5tjywrICXRZUGNDOy19CN6rv4BnY4yNxMCrJeIaIZPUsX1/8COHTaW4ybRj5dxVY+7vbqXDmhlptCU883gOSghkEyPawY/cDI2ym6phTsWTDq4xn71u2r6LVFp03AoPlk/Dzgotck+FdP0/3yie5s0o5hQJrvhoRAiGZsSh34cGsk5lF5uoPSqRfafalLQAgNs0/H+HMjaqEoIAFIKM+UspVW9gZZF0StzngluTrpHbYawdr/pBo9YzlWsBm4753DD7xreWY1v79U23hAadN1nHlAxNj/nzysDylg6v94ZQQTxadr7ssPEbQ1zgFegjBkUyC60T9xzO8SEZkeqtBFy7URB9v0uJ5jLjo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB11754.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 v76+OmenQDzIjdBxMO60jt/vozeZNsiX3Yw32RYPtKoRqndkAwMv/Hxt3EeSCai4WmDevqVJF0iKkzvZb0Y93sigjsrZsXnRsghEBijOPdanj4SbFoWAFGgogKBVLLtGR6t7UNTQDqfXtmiL5PBvM0cO8Ey34Rj9o80byTvZOH6r3ZiZ7Iv3fGX2c4vhGQcVnbGUAUvD87v0iAxSy58x7bQ8TN9a0kck/ugQMyLyP+aQNJRdxSUNjXaRaoxhYp8vR+Gs7fhjcKIis2kcCnkQzuoO/3KXqH2PYw+eZXCHvRqJLF9W2pilFJE4RAS1NWU3Q5e7RavCby1jKqzpMtYIQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5318
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ae36d450-2a7d-4b78-e353-08de7e85e3a1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|7416014|35042699022|1800799024|82310400026|36860700016|7053199007;
X-Microsoft-Antispam-Message-Info:
	u9N8Bm9/3Ul0ao3EzRXixZYlxCAUiiOgZ4or5PCypkOD4ID8DBA0b03aglVHumhpVXdQDfx+nhkse5A2BR8aHeIP9ZW0/8pcNJ84CjFT5KuUF84BshnRdI1kPvTfnVgkHi0WlZZC+bf9QUpn5dcvy5MmvS0fVDqn9DiUd+t1H/2WN8CYQ1yXhzrPELtLen/iGJbmMsJf6y90xQH5jeS8gelSFyjvM4+3AE7QRQG0RCni2w6bRAf8nqvd2UOfPqeg8VPPCwolw2pj0mqEnHl6gnbNMfb+TAqXH0l7d34gzkwptt7lieP1vHMtiWRbPsCttqLkK5yh0xZQZ0+2OpruDKvA81JQuS2YnpPIoGE2ZTv1L3IpS8wXmkrrjkz9CjSw7Sfo0maF8DwVvfcUC6uMd47DWZZHQUzCEEK/PDAK2ESPaRM2C9vFeu9hP7jI//y0/eNATvylqCvUBjsHBs8bd3eUBSL0OllfF6BZ4IoI1xkLZW5r8/HX6R3EFUPwxOHYC5+UWhi1TST4ltYFUdSIhZDzhcRU2EivoPaxdr72rwo6W/97eF1F+FSnBa68JDV/gw2T1BZ7/LEKqZXKdaHnIAVZFAxmV7++OVCWS9BL5Bs0Y2K/q0ZaIPnVPKCW/HWJrSNKYwH6QHY7FBelcVCVBTQOiyVAGQJPhfmF341/rbgJ9xcFY1KIy9x/dalDXS3wz14E4KW/Wo7Gtkr2WjE3l15sjav9oMAn3EOt3+zpT9O18G/H72Oq0AkgjRRPL4uspxsQ9GnRNXgnoe1JI7SW4Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(7416014)(35042699022)(1800799024)(82310400026)(36860700016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gp3VkmlO4wf0j4oy0UhFa8kWqXyFqQ4HdouuYpNoPK2+TbIPRNfOl4HzyZzUlW/CeGAb18B0mtj+x+a7IQfGMgd4pzbu8cI8hDZMiOyvJECbjY04Gd19k92IhY4Vzn4h0cGS1JUt4D1LEWLraCnZ35yz6zec+rXyR33jveEsAVTPdzpSZ757M0QFS8IbYYjUzH992RCh81wmKq7kuGOL2xhTndUyALSub1hwgLg1fKkltW38xVu+AS9kY9ceclTVfRsv9mgFJuuLxdJC78CCZ70Eaci3QrSrBFA03kTzlgpKp3BS2oo4RyJBS4vKQUnPoH7slvuVQijSdp+xMZ79jlWzf6G0rM60VBFNgQpOjAi1luJpVH2qAHkXLCOfaDgdpZnsiwsLSc6C/1DHKen1VXHgNtT6fNaw5LjNKCdkpYM18itMMDvOBvbZdW22fQro
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 09:18:48.3280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d2ea2b-df4f-47ea-4f0d-08de7e86098e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11874

On 10/03/2026 08:54, Marc Zyngier wrote:
> Hotplugging a CPU off and back on fails with pKVM, as we try to
> probe for ICH_VTR_EL2.TDS. In a non-VHE setup, this is achieved
> by using an EL2 stub helper. However, the stubs are out of reach
> once pKVM has deprivileged the kernel. The CPU never boots.
> 
> Since pKVM doesn't allow late onlining of CPUs, we can detect
> that protected mode is enforced early on, and return the current
> state of the capability.
> 
> Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>   arch/arm64/kernel/cpufeature.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c31f8e17732a3..947ff71b3b66b 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2345,6 +2345,9 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
>   	    !is_midr_in_range_list(has_vgic_v3))
>   		return false;
>   
> +	if (system_capabilities_finalized() && is_protected_kvm_enabled())
> +		return cpus_have_final_cap(ARM64_HAS_ICH_HCR_EL2_TDIR);

Is it a worth adding a comment here ? Otherwise this looks very odd -
Returning the system state of a capability for a "hotplugged" CPU.

Otherwise

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> +
>   	if (is_kernel_in_hyp_mode())
>   		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
>   	else

