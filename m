Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010034.outbound.protection.outlook.com [52.101.69.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C6C36F8FD
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333501; cv=fail; b=mxliT69JFqRZ97dSBESFp7QwoJf5bkF12tuhPqLiy03DbFayDp1NqEdSODstTGAV0vMBUe3aevy9e/Cd218+lgjm6cbOADJyKS8GAJFT2rpZU6UFaESWCteoe8QtH1El+jUIE52aTH3MXLhzzzQRiLZKm4wQt2sgeF2Zf/EOY9U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333501; c=relaxed/simple;
	bh=TD2Q3o6FzuGmVy7tgKRxvWta551sYUWF/kw06hnmwrw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Brhejm4jg4J+LG5qY707dcEEUSFEBMdIer3G3N+6e7Sn+dB33qr12t9zpUcP05ufdCfGZmdloJQbo2M9C8SA2NhBwxf1onCfbPJGH5iMnl4nI9wpLrgLiokQz9H4Z9PVfFO6flIo4/5OqJ/DiP3lB4QNN2NyvDt7zz8G4t4+XmM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cwBvX6cM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cwBvX6cM; arc=fail smtp.client-ip=52.101.69.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cwBvX6cM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cwBvX6cM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OpRPkK7jEmHwxboWwQh2sQMXFeevF/Di5MkLlnh/zPWhGJScKPmWDzyE04H3N5L4DU6bZestgBfXx6//F9VXcYHgnKUk2Cpqcz5dr3UgkmNGPGBF3JfgkjRzIFyPAw4kP2mRcM9jGtWAmI7pQmn7Ypy53GYtLRTARaqHleXlfLFYlpoTrmIZCaA0U9KNAf9vDlbIwLW6oo2MklMtlRxfkPsEMPa4nX1M3o2z0u9EgkqdxnY36YBQp+Ew46+tcVhoGGjkY1bns4te5QhyScRtjXI2MRUosBn1riADI3zzKilit+2xaH/NaLj0J6gKokmX0pCmjGTdbmDW85mNVzoJ4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ttlXtiMHXuvJaHGpY1UI8E5q0jMCLIzt+j+NDWM+ms=;
 b=FQIGM/2haF3yIsrXEMWpWtxLnRT9OYklIHmC96YVXgVVyptue6MVUQUEpZav+57rC0ak0EthwVPZ9883nCX9VM2qUAbU5EU4jnaqUnRTzmoeze3f8YNFhIqcZTT9ba0gtfA8+8q+/9bYQaQMyPurP7bnU+Vh43d4SDrKBuyurh4GwGOa+yMWwNtSI+8Y7s71Uv5Ng8BTTMHDQzGVyZWwLpIVpbpbGVozf0haDs9l+SdlhWq6iG41XKcmPkOAX5yKURjHyBUVtlwmMjApDyWp1GNhIva7CkJYbK5F5oX8tpVsIitk434cedH1xx34mqZvPCEo+ePzZXWF3Z2LLV05ig==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ttlXtiMHXuvJaHGpY1UI8E5q0jMCLIzt+j+NDWM+ms=;
 b=cwBvX6cM6epFNgne8mydlqC1jVBm66pUxp9odByqSCHsNgW3VLhjZm47M3+Kg9a8/rOo3P3Uz5Jgpm5L3FRM++/HYDXynsV7dKDfb4za8D/1BIpJFTlBP0xmuFrhrL24ctkAJWpeOtvwPUQIB3sZU9TcFbLURIIerhBhjlllypE=
Received: from AS9PR06CA0559.eurprd06.prod.outlook.com (2603:10a6:20b:485::23)
 by VI0PR08MB11042.eurprd08.prod.outlook.com (2603:10a6:800:257::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 10:24:54 +0000
Received: from AM4PEPF00027A66.eurprd04.prod.outlook.com
 (2603:10a6:20b:485:cafe::71) by AS9PR06CA0559.outlook.office365.com
 (2603:10a6:20b:485::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Mon, 6
 Jul 2026 10:24:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A66.mail.protection.outlook.com (10.167.16.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Mon, 6 Jul 2026 10:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7MC664acSpTtpWx+9+C9bL1wvlfy25XKa/FlBKdH1BBRXU1aVvsX8MuafFE0pLtpgXw/l/J/K+b2Q58T1apS6UfzsgIfMzZ6hOEXQMaHFzYvT9EUZOInmpkWv7fUYgqUHXsjXerj19YYfEk93slrJaBKoHUF6Nekmjqv+bxi+8VS3F0Oj3oTKP23oYepffR9NQTrbaD0hh6n0ShyTDMaeMFLmpd7PTQ7vGtFwOsoyIOCmos6BON4YnME/V0c0KA4bHyyZXAn+ANoI+wETOTVYT+F3H9umzT9jIdPvU1Yqwj9tmivjoQ6JItPf7289MQgMmywY1i+Cx5rXmuf/Umrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ttlXtiMHXuvJaHGpY1UI8E5q0jMCLIzt+j+NDWM+ms=;
 b=BgGZyzTXl1jJIAM+UxZQEX3e5+LHkRIIQOiAPUcKqFKGV7MDXPbO1O5y20GM2kmO6gmc2TpA0iDLFKrnQ9naoyvLv5Hn45Pz+0QfKauGspOwZODsyh/uh+6ivjH75v0pnkdxam99HVm0F3DGn2c6AJ0+7Y6ZU3Mq5kCpuJauM5cNhipIu9sDIyslnhcYQ2l2UVTqgijPuNpJCfQSXysSLSYBZ8z5TCcMTuzJwa83XcKP1t2hTVU8XvWPAcw0E27vqQ4sLF2RbLSzriYGnlASlUY+Qa6z0AEIhyVL0G9jWDXayIRKBlMPYMNh4fagZMFBv23z5R401xBtGcNs2MSdtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ttlXtiMHXuvJaHGpY1UI8E5q0jMCLIzt+j+NDWM+ms=;
 b=cwBvX6cM6epFNgne8mydlqC1jVBm66pUxp9odByqSCHsNgW3VLhjZm47M3+Kg9a8/rOo3P3Uz5Jgpm5L3FRM++/HYDXynsV7dKDfb4za8D/1BIpJFTlBP0xmuFrhrL24ctkAJWpeOtvwPUQIB3sZU9TcFbLURIIerhBhjlllypE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by GV2PR08MB11465.eurprd08.prod.outlook.com (2603:10a6:150:2a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Mon, 6 Jul
 2026 10:23:48 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 10:23:48 +0000
Message-ID: <556ab72c-f440-434b-a24d-84200bd25842@arm.com>
Date: Mon, 6 Jul 2026 11:23:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v1 3/5] Use kvm_userspace_memory_region2 for all
 memory registration
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260706083555.302972-1-fuad.tabba@linux.dev>
 <20260706083555.302972-4-fuad.tabba@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260706083555.302972-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0684.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::17) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|GV2PR08MB11465:EE_|AM4PEPF00027A66:EE_|VI0PR08MB11042:EE_
X-MS-Office365-Filtering-Correlation-Id: 379fffe2-7590-485f-4e3f-08dedb48d1f7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|18002099003|22082099003|4143699003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 Y8MmAeHr4DoOUT6cNUSnPEkX9+Xq0LdK/3Sub7Ou4vroCgNtVTPRcoXXcHuSRCfmOwUP6o6VOvHOyRHUo5V8uB3wFmbk4AnXtet/meWKdqmt+KTtEwrRHPuPV7DGP2OlSGhV4A8hORKMMxhVYSCza2CMNw2zzw7fwTJwOc34b48ZV3djar2xFqdksP8iUKOgChnfgcTVTTI1Ma/+yPL4yA+lwkei/AaIzNFXrXCwhU1QHK2MQ6i1w62RpIN2zRn8lVfb96CfjuPb2JY+hP29L9KiARc/9EN0E5nZY03nyzBQYEJjhTINWLaK5k9qOUdTC4qFBRMg1hfYtDMhNRx25O9sRWmSRpXfUt786RAGYj+AyYkvJUBz3otAPOnu2J6Z3BDel3fEt8E2Mn071phTHve5O7bJGzSrWCW4mP+3kvv7e+JGMlAsNSgFTCSJA8Af7MWRXkZeIYVybi/DD/cx3YsbhP0VDfMKn8W8mPtQBbtAvjjW3WnbUFAU8hbGg0c7YTbFuW4lYHERdAY6ICCegS/VvG97Kb4KOpwnCIh+tWFtQM9kyX65ZpD8l3zTNVWFIoUpNBqzHUEg9o4lh0oBWO21sNFrGM44zKfuoyCWfabGdD0PoRRbZtr5ail1XR4SDEqDdn1kdi9p5UbwkDyAXi7qOeqPnKAD1XXLefFOGGo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 tEFFOF7YSYDhu4KcXQPGsfBE5TmKuobEXWtp5+j5T8+QtTllroryHJq0JWcay7oT/ZHHqJ5Scn/NM1kEsNCqBvOrIxx9nguJk0uvFBP9SoRroKw5J4lDW9h7Sc4133996le/IsPQaB6QDwJJ4dVmRAJrgtQUWtPXXn20eme1ZbsRETTaDtA/Q3PEOop9mQ193bkKrODcOvTmJypWoR2fn8MgrClN3aAbgRxikqqhSZR8/ndv4WLgiyYZWvW/BnwIDmJiE+JevB8ZNzjirNTDzyMDZDpKFFXNw+9/RcfN3LkYnyhcxJr9h1XTElETFU2yNWdvznReJ12lXNYVA76sDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11465
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A66.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2bbcae51-bb86-4272-63f7-08dedb48ab01
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|1800799024|376014|14060799003|23010399003|18002099003|4143699003|11063799006|22082099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	ffbEnED64Xk/d4SprTVWd3srTOpT/xgZX8+rQmcxRAbIBtktyGPS6I8w2n662XGgEuXor39bog01KX8gBjXS97kzQDeXnSp9TG3SpQzx2k+1fQxVLX1khJyKRJzm4M5cbbmURn5PO+mnRL8ewkpss0DJUAl+pnrXJG3OLAea550d7RzLdwJufm1FP7XBdMSy29LQ0Aj9OI1s7to8I7++LaJR9LXUUPE/axIZCO4tBJc/NWVFLgsmE8tmOXelunKIr2KqIS2vJKFPjUrHiDACACRoap053nAqPs7gsIsTNQg3r25vmTpRpYmc1h/Zf3U2g5Zwn11GH0mhH3Ui0w+DI7y/zOROm/3CIHRtlbDVmYIjGpxjIIpWGfYKcaxjEFNWJi7euk3AtQOQCyI+t45AAGHykCKyh6Ef39VAXdXdIG49FAGLBGiv8RQ3HW1D4lI//hvSO8lVOh2ITsRlaG0R1vMV18nVHiFWC0NiLNch91VaHTqIW/68boKdWiGjRTxecSP3wCtNiI8h2CcWGR8cgPGOt2Xfnf4bvvx2Ns0paL9XaLIM/6E8zPn0PfxVGRHa+Egm66+gEo6e7pg2kkL9xGNiRSdCuZKsCxE1ZU8n7o0VG/5dahnF0NfIGXFQ6Qu0LFIzEfHQ1l1J3XUVum6jALYuiR+ysZdo9Rk0DTfNPfHoj0u0BspRThYl0cUK0HsDzzvWD7KUWcerWtSEyWkaHg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(1800799024)(376014)(14060799003)(23010399003)(18002099003)(4143699003)(11063799006)(22082099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I3zhi/LgszvYu8wpKIjxU6qEuFzAe7+k+cnD8SiGA1Fo8d0LMQCnE7wdk/FiF9bkz3Un7p+aKREou8JSaiQQOsW1fE5l0zE55kaJQYkQnQ4gQ+DUUt6838IXZOhffO6Zn1/oBDs1zPZbbKYYeO9MbPKHR56++kzE+jWqp0ys/Xc7LFqlcR56sDavYpOK+LqH09n7wr6LEHUMY2HfbjO+ZXZVIjanT8r3L2b3C0Lk+HBf23dmqvVnP75QpSPnyeAD4pf3KpVAJ4SHwmVEPZQ7BhbnhXm23Ubf+Cbd1YdXF4THN9Jaa1DT7cYlzIb+oaM7Mi1LMm4c0MCxrhY/EFijFUaMQOoSfRYoOLGK7BtRE2RxxbjkAIbv91TGvHVedQGh/xPSgGlz6HFE3SIzTWO2/H8AZb1FvexiAdIscpIzL2t1PSFcsmsvUuzF/xxKKDDw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 10:24:53.9112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 379fffe2-7590-485f-4e3f-08dedb48d1f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A66.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11042

Hi Fuad

On 06/07/2026 09:35, Fuad Tabba wrote:
> Switch kvm__register_mem() and kvm__destroy_mem() from
> kvm_userspace_memory_region to kvm_userspace_memory_region2 and
> KVM_SET_USER_MEMORY_REGION2 unconditionally. The v2 struct is a
> superset; when the extra fields are zero, the ioctl behaves
> identically to v1.

Doesn't this break using this on older KVM implementations ? Not that I
care, but do others care ?

Cheers
Suzuki


>
> This prepares for adding guest_memfd support.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   kvm.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/kvm.c b/kvm.c
> index 95ccfcb..8a7fd09 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -189,7 +189,7 @@ core_exit(kvm__exit);
>   int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>                    void *userspace_addr)
>   {
> -     struct kvm_userspace_memory_region mem;
> +     struct kvm_userspace_memory_region2 mem;
>       struct kvm_mem_bank *bank;
>       int ret;
>
> @@ -213,14 +213,14 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phy=
s, u64 size,
>               goto out;
>       }
>
> -     mem =3D (struct kvm_userspace_memory_region) {
> +     mem =3D (struct kvm_userspace_memory_region2) {
>               .slot                   =3D bank->slot,
>               .guest_phys_addr        =3D guest_phys,
>               .memory_size            =3D 0,
>               .userspace_addr         =3D (unsigned long)userspace_addr,
>       };
>
> -     ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> +     ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem);
>       if (ret < 0) {
>               ret =3D -errno;
>               goto out;
> @@ -239,7 +239,6 @@ out:
>   int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>                     void *userspace_addr, enum kvm_mem_type type)
>   {
> -     struct kvm_userspace_memory_region mem;
>       struct kvm_mem_bank *merged =3D NULL;
>       struct kvm_mem_bank *bank;
>       struct list_head *prev_entry;
> @@ -320,7 +319,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys=
, u64 size,
>               flags |=3D KVM_MEM_READONLY;
>
>       if (type !=3D KVM_MEM_TYPE_RESERVED) {
> -             mem =3D (struct kvm_userspace_memory_region) {
> +             struct kvm_userspace_memory_region2 mem =3D {
>                       .slot                   =3D slot,
>                       .flags                  =3D flags,
>                       .guest_phys_addr        =3D guest_phys,
> @@ -328,7 +327,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys=
, u64 size,
>                       .userspace_addr         =3D (unsigned long)userspac=
e_addr,
>               };
>
> -             ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem)=
;
> +             ret =3D ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION2, &mem=
);
>               if (ret < 0) {
>                       ret =3D -errno;
>                       goto out;

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
