Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011049.outbound.protection.outlook.com [40.107.130.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EEC372B2E
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748034; cv=fail; b=Y8y3J9jCdKm9vIh/5BV5KdA9iyV2hpVZ+bIY4d7INCFfKnJ1aTg9c1cOSH5taYgrwuPS/tFdzkHh4wiQjBVbJXGEfD8eWY3QrPQqqAN19kaOYtdFDB/hgBon4ymkkBTlr2WJ5lg42V+lj9Y0JHPpDbxAclzlDIDEbUAVeYaHSK4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748034; c=relaxed/simple;
	bh=ykYkCh72lgKx/orTDPyqGTwQFeGO0O1KfBGdUZK4/ek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jKdJ2Fu+S2MRzf6EdfGkZc+9yPxLPJD7TvcClP24RSAPoy0O1yp78hyWYTAgLjWj/xOBIaD+nCoflTeutsW3eoSbDJ0JcG9kmY1x2EyPaHWxTnHROGpFrYAfnNke8nlnH2FmJmDYLdNjxI2kFcRPallRMYd7rBZFXf6dpaQBwpQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eaIIWgRC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eaIIWgRC; arc=fail smtp.client-ip=40.107.130.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eaIIWgRC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eaIIWgRC"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N1BlniofZPxSLfdFZWO7P4sksRprfKyIqUk9U7gzFcvjhvAdQIpeBgXrU8G3i4ZtBgiAzdAj3ZdlCfL6CPSrn2N1+n8dUUX0gHns72w05v8TM7ccHaBb6Mc4t6dtoFFYckupda3e986CMZ/ZLHVyuyr3yL/RFZWGqEu0xjpuM2Y6gVmsSweD/DznqPh0lsCzpuT/sjWsNrhPIZpTdOQQEunL/2yRE1FlF3weutp1BmufEb9mf/S4Dq6gsMv4vccqMgpyAwFt++fkUK6awtsuPnh1VsgXrNLpDBnnPrq9PixIjTcIp8DK3ZMcBU/j9TR50aEtB9jWX6CzUhgsLc1zTQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwSd7xKeqby8AZoGyjPx5K1iTf7vmwwuLHpvESDGjhg=;
 b=FGaG/UFn95eag8YRw1eJ/9ZZHgi4mMSQdQ1dCdHBUGcwbikPGxQCuKKPaoUatSp3oGiVnLyYI5uva4QRi66Zrc4tO+qnJ4HJqY92apQNrQZGwR+q5vomrO7W0lLA8S+IOctpKJkCrU5DiHprQvCRd4TldOf6kQ7LXqSeLjg73LkL/RGUT/vypIYX1wb9sScPXCXx+lqtKk5JqqDg8wHzWIwkNHmbrAlR46Yb3g0onKvaV0cdILRwleOQUe4yhmIVD1SHoofsg+R9W82M1LCrJrbIA/Y72WjUyWruDsUD2PO/0GKyTWtUg+hSEmk9xK4MWz4GnkSbvWlGWSQsejwtkg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwSd7xKeqby8AZoGyjPx5K1iTf7vmwwuLHpvESDGjhg=;
 b=eaIIWgRCi01g6nv7t7cn7P9KdTboN5151QMI90wkMYLzAi+zffBqPPfziX5anfcoBQ0TNx4G2UQmghow0UUPF/IHD/Bc54NWng6Arz9s30ANGtjejbwGmfYSEJiHLs3pOHY72JsGNZ8CLzH6N02v9vdXa0axp9lEx+PYgH+Ii8U=
Received: from AM9P193CA0020.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::25)
 by AS8PR08MB7718.eurprd08.prod.outlook.com (2603:10a6:20b:50a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:47:05 +0000
Received: from AMS1EPF00000046.eurprd04.prod.outlook.com
 (2603:10a6:20b:21e:cafe::ce) by AM9P193CA0020.outlook.office365.com
 (2603:10a6:20b:21e::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.22 via Frontend Transport; Tue,
 17 Mar 2026 11:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000046.mail.protection.outlook.com (10.167.16.43) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.17
 via Frontend Transport; Tue, 17 Mar 2026 11:47:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZoiO69wowuYEdLA9C9O37Nu+qRp7qGEoc1KgwB4szq0XSMcq5ODdbwFSESIT46PIClGevxZ9d1nrQxQYFcSYrb9nOwtLRjggI4kL6BuHIwupN7X1v9/MsUUmqCVxjUwkp/SJUWvJoPMd5iN4vNPEiIDD5UkWbeangBXAlN5dcbb1pE9XRMrMsVXeSU719QdxpzStfVE0Qvm20F16wZivkcXhE6qoQLiyV1qcfJdm0aNhC5A2x0f44hU3DbBbtrKoiZUPs7CwPTEgRUQcVWWSr9kvSGR9Pt4fSWJ+F3VCYFM9ExWlGKs72eEhBmp7GaT16HxNyrVQgCyqCdzINOsddg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwSd7xKeqby8AZoGyjPx5K1iTf7vmwwuLHpvESDGjhg=;
 b=kF6GpSHzAx8/2XuaPRDyAlerddAbeH5aDiAng2InQD4Iv/VFybP3BZzRA8QQklMKCqkjn4AzHkdQ8ecJ0wKKHNMIhK9yR/FTEvKYdTz7TiXkMZPNdU2SMSEWXf1VBZON6r9bXBaAG7x+iQq7nIs4jLizF+f9DXOlMtCK/SdfdyrL3QZ2rUP/RYApqpj4XL8r+WwyVWd082OYKDwuvJgM/0xQYz26gyA4Rh1mPajKavjOFfsvTcN/DjC91IBWfDmd7wqbR/Gznc+62BmXOSF4sA5lT/hm8yIiVmrA/v7CRMCZ/tXv5ELfUBIWlnoqO40d4a9sIQy0teA+zhyGxeySgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwSd7xKeqby8AZoGyjPx5K1iTf7vmwwuLHpvESDGjhg=;
 b=eaIIWgRCi01g6nv7t7cn7P9KdTboN5151QMI90wkMYLzAi+zffBqPPfziX5anfcoBQ0TNx4G2UQmghow0UUPF/IHD/Bc54NWng6Arz9s30ANGtjejbwGmfYSEJiHLs3pOHY72JsGNZ8CLzH6N02v9vdXa0axp9lEx+PYgH+Ii8U=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:45:41 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:45:41 +0000
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
Subject: [PATCH v6 22/39] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v6 22/39] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHctgOV07LqaANQV0i9ef2yuSntDQ==
Date: Tue, 17 Mar 2026 11:45:41 +0000
Message-ID: <20260317113949.2548118-23-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DB9PR08MB8483:EE_|AMS1EPF00000046:EE_|AS8PR08MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb42047-17b4-4099-d727-08de841ae8f8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 qHSLRWI5zmNisXkrSsM8D3Y5mQQPHO0FzUngDwf3IgcHEhNa7vO5cAebBWJlfYLKS6KugEqbAE9I28BqneF8fR5aeQ+xBR1I9rgsemMCXL461EWbWMm6zkLD+LVktwe+uNBv9j74FjmdA6DbmLzLyJe+JK1WVyNVbBJIBRQ12JJIfsX2LOhvqF9W1ThhDflaOmdn9yFac473YVO6LrH/EUlaR5935rLPmAmikcVViurpc/6vMzZWbc7a6RGaRRoZSfXEZywiwfXkkVaBynIk2Xvkrp1x2ShriLkWAIM91qn2xr2QmT25tuDLIZc/D7boYOQqPX6Mmb2kbzabDR25QiCvW19/9B4aSVgT5yXgyng5eCLpqaDLp190DVau8GYRDVlo4o/lMGwdalYFp5JV8li/lc9t4MoMIJL+lXYApFPmM2OwxtdiPxC/2xhT8OA6ut2S9UPkXfJwYLkmc1SiBz/rwjZKF+zZZseW/vd6Ri0Ir8TfMAu9rgNtxEHsAYQyLBXR36DBuHADFc+xBK2Om4oBVvqABqqU6ToP06OBymZtTj2c9hhvzob8xLmeriQGlUFusx18LfqYl/xgoDEP7xLI11bPo+CxLLgpB8qKmH3QmZkpNhYFpXUYLPyTYw1ZkugdRgoeSSjmDLurzA9hSt2PahPSBj4y42zt0vaMeJhD+KdrJCTQjHQY7AAFxuPCYMtr/BGxTQFPtd3YTkjVRuBq/UZOdFiqiCgVdojoMYZcNB5K3ezk23nbPB6oGI7N3ENIKiamoZiPAk2ywlLIZJtZ9/7A0oNiNTh/or6KtuI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 mI5mqe58cYGezUtkOzSJac817UYsxqIKL5q8CkDlBpGltNqfTsvoRpoZuvWFV0KuYsaJBA59BtMXF2KdigR2fpdudMunC/0Opc+095eKnNXjraD84ZVBSOBnP9iQfUwyGCtpoOXrX3PXlAcpF+EnWEmJX3G5nZ0jeUMDNl3OxhExUzF6V90jg2781wydrGSvxgebbEjpi4xEaCOHKQDNyiXRP2/9Sk+jIQEtvH4GbkevkFyPE+5CAyRocBUhiqrj/qH4XOI/0XAQ4FknoV3r8yQUHWcn80bG4dSsWShgvkTOjPUVKs6o8uRIGKhYX2qFYo9tjnxnB8jK7F+RPGWsEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	30b13560-e4da-48d8-44ff-08de841ab792
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|14060799003|82310400026|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8SWp+Cfd68UyOX7BtTDLO/qXWNOp4iY11hwdirNSANtFLic2FjPQX868mSHZyxRMKz/SB+TDZpU+Hvq18B2BsL1WqRU1fn5G8IQMSTPKBaGejzq4qfj2La0uN+Omm8kFEWA7zO+a2hT0c7KJA7Ftm7oiTFdcHKDEzd97XwVLEHZ9WC+5noc3fvQB0NzluRtnAqe6dIzi4KTKz9YxYbvquNSyPXjtgWaiOSOwO90kvVK9obes9qtCPia7WHSOIoL+3gspH7GfheXf6sAGlsvbCWY7Va68QMRd/2N1mtlPASz9H2pJFEYETtVwEe9Pmy1CULtYKVR3V7/iZwP+CNM58ksHpHoSQIyQg8Qgx48+Ug8UtbU9nzeIopU/D06WG1IvNB/nvx1w36vAgDEYgcQOuUsbiO0K617r/9YZwzu2yBxNGLEqSPyvq8NuOhg3NfOB2q0UWNfGedg98KO4vxTW/20K90WHxaZ/4wqsX5Zu6wkW11qrMW7ovNlz0W+OL7lBJtQvbK4rMg4LmXHVJh7zNktoDSY6F/Q52yUxIYFER7IHs2ZsfyhdY9+f4F08hbMNJGUVKvdoLzf+dkVICUUAWZG88y3PNsgZ6IPGlVpqqAiz4Su2aVLWvNiW/y6yIoRQcYYrbRLPGXLA4ICWy31p8pvyLP88GuozeW+VFRaC7F8NUFiR7OsgorpnALb0PFrGSNQaQYmStgC2aJZPnCCiuR7oFT+YY/0/8mkyZt3jDEy9dLPVrsTgWuhfjkThC9nYoxom5DcB2Yai/liXVSE6Yw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(14060799003)(82310400026)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eHEfe12fH8PtMUDI0yjuN9nN529B7QIMl+XyrQtI+0EKRFS8gM9kowl3gUz1zpXOS2LU9gT5CglASuAGpT2LBu0yJqOY8UCj35WBuvxlm6L/+F1JQfILRzC+FvprTWoCYZfHG6hJ9kVo3Z7/H3LCjI1i7hMoWQAvMt4vz1hd2os19BvnZq+nu1NF1qQAHOcdqcxiUSNDqegBa0OG6sjV+lvY1EVf9W3XgvQB2rRliUcUzJuLtY73QeJqDIP50YDrD5TvinM4lIOfCz9PvAqkBzU9zsT+no4OZvB4joKGPcGKq8xsg6AS81soyufYDFO8JIMzsYBTmxfPB8cbdRjsQ35iCOC0FrkYGIRAyV5xKdLpqOA6J9zo6pg7rXfu/muqiFtN+8TxQsRS+GP4XNF1sAD4vxUxYE6k6JD7ZIzaKaglNBDXrCRqsJGJbcd0R/IO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:47:04.4762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb42047-17b4-4099-d727-08de841ae8f8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7718

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's priority is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state on WFI entry - this is skipped in general
operation as it isn't required and is rather expensive. If any Enabled
and Pending PPIs are of sufficient priority to be signalled, then
there are pending PPIs. Else, there are not. This ensures that a VPE
is not woken when it cannot actually process the pending interrupts.

As the PPI priorities are not synced back to the KVM shadow state on
every guest exit, they must by synced prior to checking if there are
pending interrupts for the guest. The sync itself happens in
vgic_v5_put() if, and only if, the vcpu is entering WFI as this is the
only case where it is not planned to run the vcpu thread again. If the
vcpu enters WFI, the vcpu thread will be descheduled and won't be
rescheduled again until it has a pending interrupt, which is checked
from kvm_arch_vcpu_runnable().

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 101 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   3 +
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 105 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index e080fce61dc35..14dba634f79b4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,29 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 highest_ap, priority_mask;
+
+	/*
+	 * Counting the number of trailing zeros gives the current active
+	 * priority. Explicitly use the 32-bit version here as we have 32
+	 * priorities. 32 then means that there are no active priorities.
+	 */
+	highest_ap =3D cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+
+	return min(highest_ap, priority_mask + 1);
+}
+
 /*
  * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
  * hypervisor) handle the pending, active, enable state save/restore, but =
don't
@@ -172,6 +195,80 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
 		irq->ops =3D &vgic_v5_ppi_irq_ops;
 }
=20
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state for any inter=
rupts
+ * exposed to the guest (skipping all others).
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 priorityr;
+	int i;
+
+	/*
+	 * We have up to 16 PPI Priority regs, but only have a few interrupts
+	 * that the guest is allowed to use. Limit our sync of PPI priorities to
+	 * those actually exposed to the guest by first iterating over the mask
+	 * of exposed PPIs.
+	 */
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_=
NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+		int pri_idx, pri_reg;
+		u8 priority;
+
+		/*
+		 * Determine which priority register and the field within it to
+		 * extract.
+		 */
+		pri_reg =3D i / 8;
+		pri_idx =3D i % 8;
+
+		priorityr =3D cpu_if->vgic_ppi_priorityr[pri_reg];
+		priority =3D (priorityr >> (pri_idx * 8)) & GENMASK(4, 0);
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->priority =3D priority;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority_mask;
+	int i;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/* If the combined priority mask is 0, nothing can be signalled! */
+	if (!priority_mask)
+		return false;
+
+	for_each_set_bit(i, vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_=
NR_PRIVATE_IRQS) {
+		u32 intid =3D vgic_v5_make_ppi(i);
+		bool has_pending =3D false;
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->enabled && irq_is_pending(irq) &&
+			    irq->priority <=3D priority_mask)
+				has_pending =3D true;
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+		if (has_pending)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
@@ -299,6 +396,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->gicv5_vpe.resident =3D false;
+
+	/* The shadow priority is only updated on entering WFI */
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		vgic_v5_sync_ppi_priorities(vcpu);
 }
=20
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 3b148d3d4875e..d448205d80617 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1230,6 +1230,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return vgic_v5_has_pending_ppi(vcpu);
+
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ef4e3fb7159dd..3a9e610eefb00 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -365,6 +365,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1
