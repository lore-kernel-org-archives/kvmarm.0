Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F43EB81E
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935780; cv=fail; b=YunvhMXcHcR/JkksH2e6xY2CGKQMbgozAqvJXUX6YSfgvVDY2xmZw9A044EKpnLk547kGp4OuV1D723ekI7M/xs7UWbZuUPyTnaB8ycI0A9yPMKZFzocd8fQzMYQk7UYfeO7fX+k2okp5NprQvA+aabZC87VXbPmvRj8l0QLnGo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935780; c=relaxed/simple;
	bh=Dkra1Fj/tWASm4E3KNz+Zg6cwh7jiJ2BD3jaHqMpmqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I46gaYb/xWivSkf53A77im62HbF0rBl3ogUgmQG7nJcl2qo7RFDtS9NIYPqnp6zvpcz6KP17KSy1M68/FkRACsRebtxDdHcjk46nFfiIkfbjTrCyGKc3uBqs9EwvuLi+iQ8oFSD5n37TRnxGIAE3Ke6SG9jJK7glvACdPxgbReo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e81xoAnW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e81xoAnW; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e81xoAnW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e81xoAnW"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=igsv1CGgGfOMFSQeEo8jk9HRfto9NhxGrF+88vEiEScj8OrKIYrEhpWkA+dMFiuECXN14pZQuUUUNty3BY5/tT9v0SmAo+U9BG32O12NUJqMJ2r8IqMIEhca1DQtwJr2QZ69L6CO+gVKas4ht4JaPShtDtI7vE/RUtjFcoGBt1HP23mig31zDP9W5y00oReUnqfPN07+g0sD/FNGLIHBOaUNt7fycKwAcud016PR2wMsaENXG3SsOSJSVJqb3uOcdZeninex8geuDYUUHfzEbc8gcqY8kCnzqjZAL3ZTEWuEkAIF0RRWRVxWagFfQIPNywpM1Mk8ZtM6+/P8vhduAg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHWWkIscZzq2i/F8TT7lZt+vOV7qSstXtkR88hnIFFI=;
 b=MOGRt8N53m7ygEX3/q0krBD/5wRV+ZD4PcjdeucdKZN6XOwiEw3Wr/7WS10MZOUy+ZXDMPxfi9uDvqZ0EdczZdhI8kHk+yfxz0dW4WMXwWRYGo1e2yw0Yoil2kEX9oXLIpdOg4yULfcKdsRQePF44eFkRcbOjIP7jMBeBi/WoHwUZsOMcS8vl7GCLzmbymBXrNYceF1e3ivBaP8mVqJRnRpAs3QguoFXkf1I8AuJMlE4bVyp1cksZGv26BjPXRxAtZyXVtc2n8EX5lYbCj5ZM3yM+29lIFnarxcky0Yx2jC9dbEwipn8vqMXZdfmMYX06HMMbnndqNlkFRFecjsvUg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHWWkIscZzq2i/F8TT7lZt+vOV7qSstXtkR88hnIFFI=;
 b=e81xoAnWajQo6J19K/agrPG8cB+5eyTjPIedK8sunKBROIqX9x/0hLJDL7487n6QoCDKrHjCO2DuuHobwcyyoCBgZ4fCQd7sMuXF7JoV5mwx42W+zvRbWDozARS0CTNw2bUrzNz8kBAE4ueuwazrQmb9wZGRcapHN29z4M7iXII=
Received: from DU6P191CA0054.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::21)
 by AMBPR08MB11660.eurprd08.prod.outlook.com (2603:10a6:20b:735::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:56:13 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::14) by DU6P191CA0054.outlook.office365.com
 (2603:10a6:10:53e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:56:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via
 Frontend Transport; Thu, 19 Mar 2026 15:56:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0oKx6SiHgtIeAzJzvzP2ejusT0SLM9LvonuDSPiPH9M8ZJB/FT9Yt9Y8CfZPvAfCcNykGaDprZudrr+FSVFwLnoaCBooFIFG1xCFRYpNc6xyjQnv4uI553wcpKtYVBBk0AwvG3wsuxLjadIgLZiBSGKWzWBBDpJAi1ZOzPh+m7zjYeGEfIqycReQLQw/NFmAAA/ABuiiw9LlvDhyadECmQu8DRy22HU3yfi2j/M+rdOWgX5EAiansKbQ71TThbQcIlng+HnnLL4+0Vo0LC0Zib4Py3aypYy+0syxAl+tpKZa1kXWyjROic2/CEJnZNDAh1ssGAJj28s3dOnXPlt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHWWkIscZzq2i/F8TT7lZt+vOV7qSstXtkR88hnIFFI=;
 b=KdzysaaVPkyfhaOo5QR5xyFoZO/NcplRdg0SqClHXc1FOo7zKPjAixLC3LcRa+ytVnWq/MIVq/ybn+X7OntfcJ8GnESQjVNeVOoJqGVAuF2aN4p7u5fFY7efcuQzToX2vKhtV5ajcBaJHxYGtX8fsNHTUaWTfi+S9BPx0L7T6LYRcefGT2Onh6VBx7FmbhkP/jGtHodAUeXpA6yvl4q0RkR+cI+dIVNFJIJxiDfN1IfUkYmBms1dI9RCU1cUrKmsvGS0YsZJwuNqhdeb51kOX8/bUhId5a7l2OmZY+zt9DUBrto7Nyl4X8QYcVK0DOnmXUpOhGWFzPaQote4kFAgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHWWkIscZzq2i/F8TT7lZt+vOV7qSstXtkR88hnIFFI=;
 b=e81xoAnWajQo6J19K/agrPG8cB+5eyTjPIedK8sunKBROIqX9x/0hLJDL7487n6QoCDKrHjCO2DuuHobwcyyoCBgZ4fCQd7sMuXF7JoV5mwx42W+zvRbWDozARS0CTNw2bUrzNz8kBAE4ueuwazrQmb9wZGRcapHN29z4M7iXII=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:10 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:55:10 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 21/41] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v7 21/41] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHct7jEoBh4lzkD3kCx/Le8ZcHflg==
Date: Thu, 19 Mar 2026 15:55:10 +0000
Message-ID: <20260319154937.3619520-22-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DU6PEPF00009523:EE_|AMBPR08MB11660:EE_
X-MS-Office365-Filtering-Correlation-Id: 17326c03-68fd-4597-14f9-08de85d00c00
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 mpxqmnsOqdjZtJVCJzveE62svYlErfYNMISUXYcfrJGCVR70hRixeQVh6nljp/ocedM1OL472t23rn0ulRrB+SQL4k7kYEGrpNwbmVjS5/syoZZRaJU7EEonQaNuAtuZ1WWKeZghyT/6IlFXb1jXsiMviewRrxNBqQREbM86iqvI0JgN3bJV6Q7Wx0hjq1RIoAtBXsrNBJoLvyqwe8HqMQAcSrT1ii0F2hEWy6aYGo3mjDaZSml7NUeueiKBSOgSLay8pLdgqqSqMp6NuFH7PhsMS74B0drjSUaI9B97m7z5uRY76KJ4vEfKAzLwF/3yn5PwGsW8xe6yObyXbbxor17qoD+L8YIqhtu4Z/pEjZ2LTmbyhzJrBsSkXVAZ1xmOGTP+LXmw0z+wnIxTcskpY/lfIqzlX1F6vdXrU2SAyl6dCk1Ff1Bc8opFT4vYfS488DrvjwdMT4neDGRpSgMj2X7yj96dvxbp++k6UfyP/C+cuYwlEJljR3x13D9ylO/jeYrfTP3TZXzWG0YoJsQ5Qy1FCffc0GgwSwhaIfqDjfi4t1O4mhd8+vaFVw++Nq+EWbiHgTwd8Xc8DOIyIBhOpYmHwGVBucnweJTI35bDVgUIVUCzAPWyoC2LZSVhfP2+paxEQHqSPgmNxuSYPaQyR68dxyNJdh8yWIPw3jUefFH2XLSn20hSMsBQpEdXO0rno4zCh/zemDcQEltQC+nTGpQ5Jy4MVtGsfUTeQwI6mweVoeiNXLAb6sIkffz3WTTVsZomtCjIxEyBq/MLJICrXRIx4SgPsEZS8SpvcVNXM38=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bVMRQKD0YBS338u3WAF08tDEAORXnfwWJHD87VcsL9iCiz8ln7SM9d0SlX21zNFoKvdyWjcKBI6QSdIpa4MBCSppTEBU1c/fUZXicrWtAmMgzwbd2CVqpCOry4CyVmGuO54LtrAsOG34k/cuWYQzcLsIxDFTJGgqhrziw+Pf69yZSxOIZ3b+aGvWeZ5ypDt84sVrhYLLeXBCNPVSjGRC6n1fahOEt24hJMct6U5AzkqnzP24lr3yrMdhJi5+w1XkMMdTfkJ593G6ggh2sZTZqOKhoDoIe88IefQ4jh2mGKc31iH1EQr3GB9RZDmSvDaMMHP2pzFFUlYJuey1DcjJ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0a5b8afa-e7a1-440c-2c29-08de85cfe695
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|36860700016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/zaJwvzoj5WApgB5y431hBT7SNypnmcYaERHLq9Lv1zWybTpr1emJRwltyxt9u/RTtRAjZnCsDLxapyQxRzeWkX/4S0aqf/qn8IOMN9wTp3lP/z5YUGRYlajiuBDYzXl1QN5czE+eyLt+raIV2OfL1/l0bx9eIxZoSuRHIlXPQW+MgQt5gxfKZ9RCM5tIaPKPWVk3HNc/CpdwZZVcnQAema66Z3qAkGeBR9KY+wdDFKilQFfFaXRG4pHkuTWo73FEnQb6/63ZY2TvwmvBdRxHPJA43bv37BgRRMG+wSrBofDOSACYhGIMQD4iVxO3xSjxQvdva0A+bc0K1CvrnfFgP29iN69XHfGh+/tipkYYAY9L9F1QsKzifccV/4aT+THJkDEw8D1u2J5aI5qrgjw9o08BwGazlys4G1QA/wo46GMJF85fZEs271D7OAfvphjxWOHK9NSmia11VCG+KuMq2cbJzMrnRgysb53s6A3BkVRaS8B3P0tVDJdPf7gG9EQgKLUNbzshjwfylREAo4rnwnqn7purvI6L4zNfwQD4SR44oZeZjW3vho0otCLdD49+4iW9OOJXu6DnN6zuK8uimotRcQ+AdA9NdpHhe9mPkWDGcbTyoNhMoQFL7XsYg93xANmA+5T61MWAe6SqtjY498QRMSUmsYjM6dvhrNcirHbGyyPS5847RuorY+Gm9wHaYbM7g8H07IQGpu04xYG6ZKf2gqS/4DDREvLTknHswGcWpyjxBCjimPUckIy4KlG0D6mmkpM1ylAIvJlBWhPfw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(36860700016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WR08ZQbCe7mJEblSYJX5YC/n9vhzcOhP4xmuURHYGl65J4IjRDz2BgqFBGfQRmsVgb9RMQ7WaWDNZBXDSvtvnN0zJKxCrn4sYGuyukXIRCDrDxkhB9faWKSS0587FbAU9SME/J7vR/m7KbUzN2b1DM7fZADhIFAU5Su3wjXFLSBvaYEjzGpJ31/snylt457kZ1IMLv2wTKg7YJeUihvMLVFJGJbDM3HEtsE6Kj9Wymjdwbp5kkgzV3z7B9s2YvSNTArpC/uTeEvmcsBe9GcWuLLZ50PZtvdZ/PZiuQ7HBM+bJ30mKrz0aZm7jnew5SBS8DE7OsvHZGncb+32DAIU/eqUKMT5Z/pbdEPIZ/R2GPcV3htDFSwFahTBY4IInK741BDlGP5JWEvoBzRWonxcuP7+tQbriUWYIKsFGKiH9CXISRCy5ZCoF9wEPs48sNR/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:56:13.3166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17326c03-68fd-4597-14f9-08de85d00c00
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11660

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 96 +++++++++++++++++++++++----------
 1 file changed, 67 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index e1be9c5ada7b3..e0366e8c144d5 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -250,9 +250,65 @@ int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
+static void vgic_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32 ty=
pe)
+{
+	struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+	INIT_LIST_HEAD(&irq->ap_list);
+	raw_spin_lock_init(&irq->irq_lock);
+	irq->vcpu =3D NULL;
+	irq->target_vcpu =3D vcpu;
+	refcount_set(&irq->refcount, 0);
+
+	irq->intid =3D i;
+	if (vgic_irq_is_sgi(i)) {
+		/* SGIs */
+		irq->enabled =3D 1;
+		irq->config =3D VGIC_CONFIG_EDGE;
+	} else {
+		/* PPIs */
+		irq->config =3D VGIC_CONFIG_LEVEL;
+	}
+
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		irq->group =3D 1;
+		irq->mpidr =3D kvm_vcpu_get_mpidr_aff(vcpu);
+		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		irq->group =3D 0;
+		irq->targets =3D BIT(vcpu->vcpu_id);
+		break;
+	}
+}
+
+static void vgic_v5_allocate_private_irq(struct kvm_vcpu *vcpu, int i, u32=
 type)
+{
+	struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+	u32 intid =3D vgic_v5_make_ppi(i);
+
+	INIT_LIST_HEAD(&irq->ap_list);
+	raw_spin_lock_init(&irq->irq_lock);
+	irq->vcpu =3D NULL;
+	irq->target_vcpu =3D vcpu;
+	refcount_set(&irq->refcount, 0);
+
+	irq->intid =3D intid;
+
+	/* The only Edge architected PPI is the SW_PPI */
+	if (i =3D=3D GICV5_ARCH_PPI_SW_PPI)
+		irq->config =3D VGIC_CONFIG_EDGE;
+	else
+		irq->config =3D VGIC_CONFIG_LEVEL;
+
+	/* Register the GICv5-specific PPI ops */
+	vgic_v5_set_ppi_ops(vcpu, intid);
+}
+
 static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 ty=
pe)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+	u32 num_private_irqs;
 	int i;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
@@ -260,8 +316,13 @@ static int vgic_allocate_private_irqs_locked(struct kv=
m_vcpu *vcpu, u32 type)
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
+
 	vgic_cpu->private_irqs =3D kzalloc_objs(struct vgic_irq,
-					      VGIC_NR_PRIVATE_IRQS,
+					      num_private_irqs,
 					      GFP_KERNEL_ACCOUNT);
=20
 	if (!vgic_cpu->private_irqs)
@@ -271,34 +332,11 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
-
-		INIT_LIST_HEAD(&irq->ap_list);
-		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
-		irq->vcpu =3D NULL;
-		irq->target_vcpu =3D vcpu;
-		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
-		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
-		}
-
-		switch (type) {
-		case KVM_DEV_TYPE_ARM_VGIC_V3:
-			irq->group =3D 1;
-			irq->mpidr =3D kvm_vcpu_get_mpidr_aff(vcpu);
-			break;
-		case KVM_DEV_TYPE_ARM_VGIC_V2:
-			irq->group =3D 0;
-			irq->targets =3D BIT(vcpu->vcpu_id);
-			break;
-		}
+	for (i =3D 0; i < num_private_irqs; i++) {
+		if (vgic_is_v5(vcpu->kvm))
+			vgic_v5_allocate_private_irq(vcpu, i, type);
+		else
+			vgic_allocate_private_irq(vcpu, i, type);
 	}
=20
 	return 0;
--=20
2.34.1
