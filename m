Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010000.outbound.protection.outlook.com [52.101.69.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CC480DF3
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522798; cv=fail; b=jWZ7HZUXgNNYX7tRbfoBRsz60R48CquIEq8FJeyxapDHVj+Jjt4WWVkt//RUeF00eY6WgNq140x8Htd0jVCGcStW7fVGVKiXTdBMNIOntSK3nEVID0MsgL0ZhE7S8IhGM1gbZ4LEc7wguB6MMCK74e4F1vF+s8KG2l14QPqAonE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522798; c=relaxed/simple;
	bh=JltHQTsRnz6HPzbkYtNQ0G74h4fGN0azWhPTgY+7Z9s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SJWd0tPuPWqs80WaW15UDObdki3R0hnugr89tpOSNYqaYSfgGNi4PyU24shufzPMbOL6H5D//VHrsPo5k42rObI0du/03b620YPjXCi+gdocOSpVivdGZEzxc3Cq93ZvDW/f0EBZJvdEZwrdRQvqkY9feiq4T9MTNkqcjhxVsj0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mE/4Qwg4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mE/4Qwg4; arc=fail smtp.client-ip=52.101.69.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mE/4Qwg4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mE/4Qwg4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tAManew5keEsX/icAnBx8AKPEfVCzXRcVjYxgpgVPdDEjvt7fBPGvDsP/rFNXooaeu71C2MsfRUc7nLSaTbfyxQQh12+yfU0UayUAdl+9hnWpBJIQUfEdyiiKV2FeBQI04eKWXTWgSYo8ytiD6xpbFkUFoYqPbWBgwAnwzbSeGocuRKGB65aEnbq523kKWsmKA5i2g5hcMIl6tLd4WGj9AtZJAa7zyORqwu4q1z8J4Ctqg/Nlf7qqdZBM+aKcWmxbP7mBqGWJFFv26fWqOLU0q4oAYxXhHYNElqAbb3x0ZDyQQd3Wmkz0GGDduB0DeBtXFax1uofC20NpS6Y5VGPTg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=VLJi326OFAoFdKBbomtRs70lJgQuT9MrxSxo1DKw0W03BXsrPUIka/s/H61kUNMww7CRQPQKpRLyFbtsuahhJ8e56Qxj4O0yBFOQOGpCdlrRbXWlT/JNJiuQDZKvMPvfqwp3Kxrd9R6d7MIv1Vxz7DokCpr4eMmJkg932WaPiMYfl2ALf2xt2dDi8KM5YmnXZUuUKz10v196lpr7nHzECoLPoq/2sPNzbCQ+3bQ1IM9GTDu5msO8/ahdNtPHskeIzAE4o+NfE02cI4pGMKchqKdXXNGLtFq3OyYSPASPxA3ez0OfprJmt9j3kqar8CmAr9F0yKfsSM194tqLckOEEw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=mE/4Qwg4sUcoGM7JNpwxaWSgKB+ZI9IQ35PSCXneG5SWF2unEtgkHk3mHGuTUr6kFKEAvE71U2j20JJTA6+UzzumMWAHniTnVo/HysDVppkIPpKIzJQsKwszoiERKjiDcKQnU2S+lRKevY7kmpq3i+kr09ybzUa2pVh4wzPac8w=
Received: from DB8PR04CA0014.eurprd04.prod.outlook.com (2603:10a6:10:110::24)
 by AS2PR08MB9152.eurprd08.prod.outlook.com (2603:10a6:20b:578::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:53:06 +0000
Received: from DB1PEPF00050A01.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::50) by DB8PR04CA0014.outlook.office365.com
 (2603:10a6:10:110::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:53:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A01.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:53:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vor2IWDCPTZBfS6ZEJP27nA2Q9dtnaxnCgZIJ9xyEcxZOFx8dLZGDGLtrVpNKq2C3sfFSOYB7r80HIDIrJHXSA9cFfm/XD1b7dlGB+hlRiXeOkXY921WyGe1lrIe31I5wbLw0P7lQtEbiZ6QV2ksLssF4mcLziBrYMLC7fVBAYm9VRkqtdF4mC3bsZewSGUwNak1cR8EqVQFBVKOsmCcn4JxioJ5dWlvF25+od9nBO0mgYUU4BwRtXQlJ60Jgq7u3cZ3K+Bb4NDi3AOe5a7au6SZvoOjNO0sW759l14CmetWQ3esW406WVdOc7xAfKP8hyFa+Ob1lCx/kcFfg4scDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=TYTHxTDOzD0SbCJYJ3ER8w8A11Ylx3fVQRIlUcXPZ1wULzaOVqkTR3EWsIscD30FkuGSTnAEGXZlpW52ToJLZ1Cb1nyYzcvr01CfwNezW2tD1eX+wLwSluU8ip3ToXg5G30H8XeSMDZj/kcccj4k0mvOVCJ7yvFoBXMVbJ6eKP8xshxIntWw9VYKnyW8aoL6zdYYkTr1dG3zM9gsbs8f/6mJ1R2VyJHI9oTRgvXHy+CgsdkQMzFTOavaJ6Owfi/QXa6U2mAfsLcPWxpDJlnzqa3bdQYIomNkaSyeM4IwwD7ULgbOBXdidqxz5zsYSUj+jEkb4U6jLVqM9npDNCuBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+27jgll1V/vh0RzLGcaZ6MEIIdwGaRJRTd8ce816mY=;
 b=mE/4Qwg4sUcoGM7JNpwxaWSgKB+ZI9IQ35PSCXneG5SWF2unEtgkHk3mHGuTUr6kFKEAvE71U2j20JJTA6+UzzumMWAHniTnVo/HysDVppkIPpKIzJQsKwszoiERKjiDcKQnU2S+lRKevY7kmpq3i+kr09ybzUa2pVh4wzPac8w=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMCPR08MB999887.eurprd08.prod.outlook.com (2603:10a6:20b:784::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Fri, 4 Sep 2026
 11:52:34 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:52:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v6 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v6 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdPGPfh+SZfnCPM0GdlkAjVbVYew==
Date: Fri, 4 Sep 2026 11:52:34 +0000
Message-ID: <20260904113404.4051341-37-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AMCPR08MB999887:EE_|DB1PEPF00050A01:EE_|AS2PR08MB9152:EE_
X-MS-Office365-Filtering-Correlation-Id: ba50bf2d-9c3b-4a94-a8bf-08df0a7b1519
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|38070700021|3023799007|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 j80JaH1+V2UtimKK4t3KRBVXsDfjMohp4q4I9J9dZQhDxf31N5EWZvLT1C5Vf5jvn+RIdprNF22zp0HjLqCP951QjGZXjXrxdBLZqDtcpa9AH1PKtz0UviEKXGa3gePRUza80pGLctDs4oKaocr+EcBSQz81rc2h+yQFw5E2fzzOyivFX8CMGzsdXZwp/6clNyircat33tSapf+Rz2NSXTATEPnU8agHz/nyJ3dHsp7Yle3zXriz/y2mOORFUE8PCHbqbw65yHrqLsvI0zio6hQQgyk1emfpfX4qqTMVobHrQ40lYcf+KJj7NuVX5d/696NuWGXyqRQ5t1e4nIsKq2xLnLqYQpauLmv72ywjDo1P5kOkMM4jPC9kB7PjrHgo444a5Zb/q9/d7y5bijcPng8Dq8MhqjaoUEvYYuovPQMIHwvX4iGaJV4EI6ej/UAFYuS3c+/syJdqfiiAlF56ETALve7Gb4bvHKvUqwhCDs3a/n7oaYFU/zRO5CzfNFGe99QPfZOR3zTACRHcv1r6X9kMdNHSL05fX5DfAONZzIkqGhbzFl1a0Dma3oHdH2+qbjMdaSKICPVTy2qaou9GIwvbYwDgnJ1XpkAeJMQbkpjocs3QhH0ImFrnAYp41Pn4gOEiviyxZLS3Vz4KCglRDI8jDUGCc4CvKZoXH4WOdDv3MQexP2V0cZDDfV8oDsTLKMNlJlbSGXz8sGxMpqy4NQqw2IsGRAZIOY2GSGkk9EI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(38070700021)(3023799007)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 QD6Jt+bH1/0t3ZYo6h59ydXt6PfPBBphY/bswwqV207deXY8WEEIJVn/QAmjOvats3FT280oqH6EQIaZwGm43vCI8BTYWF+tdU/5hL/RgG0eak2FCaPsINgQqbXSd8XQScj3ph+Tbk42S7topYfJJOWOTHIWPkRqt7plEyb48geZM4p5wqy+8H5GyVnMUawbSaRDQPFewPW7V/BOgCvzaFWkLPlN8A1bq28+VFzJDLSrXTRS1ZiVx8IeHwgYk/e0S858mf99HV9UW2Q/pj66KfnOwXFsUjDjF2XnnMruVQWQlGfLI9RREobxRhpH2Mvr1HRMUmBXWuaVu/5kgAU7tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999887
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c44bcae7-d18d-4e26-6af0-08df0a7b020e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|35042699022|14060799003|1800799024|376014|82310400026|10067099003|6133799003|3023799007|18002099003|56012099006|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	zdxBwtvZq3BU/FpwlnRFupz0w5Qk1+W7xq9QwRVCXG0zJU9thpXucqlssGoda47a0V0uQeryChuCMQB+/9ggD/EVWeJImfAICvJzSW9EYp0XdcJQGuSvcVQYTeed7Kvb/GwK1EdF5e6twdia2a/OUuOejjmo8WEgkpE43VoaalcRleZlK3+vhTbHrB8ioIq2eS8J8jGjpV7YU09+RuzDDnyNKZlGPYEL42TO6ldv9vQ5gTI1sOfB5pTWLYv/37sBgRwCu8LAw8fffnukFqrki0M9u7VGG8vtE9rXjiTdZGnrQVgWw9hTot+yUiLAwkoUo9poKcpKtrxw3VG21qhoWz25/nSIEwfKWSjxWRWGjAXk/pJtkX+veZWMhWgPtsZGHApCOUwKEbWHICdkO8O2UuVZ+Bj2wOSUk0PIya5gfmVF9V6jFks/c82v1/ta5czTiN2nlwomey7M6hjIgscLxLx+U+xvn5IdIMDT9OPl3NRRsDpB5HHvu9i4CQcAJGkebMk28QfiEwg+TMwWdT3iBAZoOs+gJTMqp3xr2RjU7iivGHndYpl58ADkJ1UgvWUculBATEkjVvO74K4wOhbe7xTssFvgSzOpMmf27fWFFAfDW3hLrRgL7pmnFhtKPQWmyywVI2gF4RSScZbRdo2qIACdpn9syuDU5HUa2CXsw1s=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(35042699022)(14060799003)(1800799024)(376014)(82310400026)(10067099003)(6133799003)(3023799007)(18002099003)(56012099006)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dr5PpllrbimHjV8ZlS+UfxBegJLF5E9k7yfDMt131km1iqIlf7/WdpqV0n8CoZj/FqRowYV1E4N4hPx+gWjq1hbjWUZe3N2jrIdwbOylcBzLLZLKMqb7BFVCVs2bIxUCJpDmCJvYXz9QTX5YW+FvKLoys+/fea1sPIxPN6KFYIC1flPhvklHcuen6MZZbqqM3aQOsG/dyQM7Cphh5lTYeU+6M29JkjAexLq+RV6Kk2A/WM/BeqIUzgCigaOdNTkEa9BzEPpcUX1X9VxZA6g44wV3Sx4DsEEhSj111B9ws5oehw4S3p9Av8kSKF2F/xziIGq35QPqUmAR2mbOuxXWXvAcQqfTdfLHhQctAqxuPHRGlQlvSagxRnCEttYZeXU3dlWMJIVAI7I3GxpzjG9nddymXb5U5yBy3JwupR38zN4kZstqs5cyvH1Zax53gVF5
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:53:05.9902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba50bf2d-9c3b-4a94-a8bf-08df0a7b1519
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9152

The virtual GICv5 adopts the same mechanism as GICv3 for userspace
reads and writes of the system registers, albeit operating on a
different set of registers, of course.

Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for GICv5 in the VGICv5
documentation, explicitly calling out the registers it operates
on. The main body of documentation has been directly copied from the
VGICv3 documentation as it has identical operation.

One key thing to note is that for two sets of GICv5 registers - those
pertaining to Active and Pending state - the operation of the
interface is different to how the actual registers operate. Both of
these registers have C and S variants (to set and clear bits) in
hardware. However for this interface, we ONLY implement the S variant,
AND treat it as a raw write. This simplifies the act of reading or
writing the state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index c782ea4d4609c..7e41d6699538f 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -75,3 +75,77 @@ Groups:
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
+   Attributes:
+
+    The attr field of kvm_device_attr encodes two values::
+
+      bits:     | 63      ....       32 | 31  ....  16 | 15  ....  0 |
+      values:   |         mpidr         |      RES     |    instr    |
+
+    The mpidr field encodes the CPU ID based on the affinity information i=
n the
+    architecture defined MPIDR, and the field is encoded as follows::
+
+      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
+      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
+
+    The instr field encodes the system register to access based on the fie=
lds
+    defined in the A64 instruction set encoding for system register access
+    (RES means the bits are reserved for future use and should be zero)::
+
+      | 15 ... 14 | 13 ... 11 | 10 ... 7 | 6 ... 3 | 2 ... 0 |
+      |   Op 0    |    Op1    |    CRn   |   CRm   |   Op2   |
+
+    All system regs accessed through this API are (rw, 64-bit) and
+    kvm_device_attr.addr points to a __u64 value.
+
+    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS accesses the CPU interface registers =
for the
+    CPU specified by the mpidr field.
+
+    The available registers are:
+
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+    ICC_ICSR_EL1
+    ICC_PPI_ENABLER0_EL1
+    ICC_PPI_ENABLER1_EL1
+    ICC_PPI_SACTIVER0_EL1    ICC_PPI_CACTIVER0_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER0_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SACTIVER1_EL1    ICC_PPI_CACTIVER1_EL1 is not supported. Write=
s to
+                             ICC_PPI_SACTIVER1_EL1 are treated as RAW writ=
es of
+                             the underlying state.
+    ICC_PPI_SPENDR0_EL1      ICC_PPI_CPENDR0_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR0_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_SPENDR1_EL1      ICC_PPI_CPENDR1_EL1 is not supported. Writes =
to
+                             ICC_PPI_SPENDR1_EL1 are treated as RAW writes=
 of
+                             the underlying state.
+    ICC_PPI_PRIORITYR0_EL1
+    ICC_PPI_PRIORITYR1_EL1
+    ICC_PPI_PRIORITYR2_EL1
+    ICC_PPI_PRIORITYR3_EL1
+    ICC_PPI_PRIORITYR4_EL1
+    ICC_PPI_PRIORITYR5_EL1
+    ICC_PPI_PRIORITYR6_EL1
+    ICC_PPI_PRIORITYR7_EL1
+    ICC_PPI_PRIORITYR8_EL1
+    ICC_PPI_PRIORITYR9_EL1
+    ICC_PPI_PRIORITYR10_EL1
+    ICC_PPI_PRIORITYR11_EL1
+    ICC_PPI_PRIORITYR12_EL1
+    ICC_PPI_PRIORITYR13_EL1
+    ICC_PPI_PRIORITYR14_EL1
+    ICC_PPI_PRIORITYR15_EL1
+    ICC_APR_EL1
+    ICC_CR0_EL1
+    ICC_PCR_EL1
+    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   Getting or setting this register is not supported
+    -EBUSY   VCPU is running, or write attempted after a VCPU has run
+    -EINVAL  Invalid mpidr or register value supplied
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--=20
2.34.1
