Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011038.outbound.protection.outlook.com [52.101.65.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E60344052
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936030; cv=fail; b=Sy6tLhj0rNVBHpHOV+vqhoni019pgkvo9FcKThr3PO+lWPf76p+rqQfoiW/mTocq92DTVEzdSrjMiwKceFq6aQQgRAgT/hF5TxyEQFeV7QvnpQenJH7rZCdQKV+7K2S8aO+bzrhsdyWHGlmGRYYC6+32DrfizxvW/v8FZrbpfAg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936030; c=relaxed/simple;
	bh=B0+yYFSYvzIbI/YIKbLBt+azoMUsaWg39Yv5CuwQGCk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rZpIrJjMrYWWiynbn+/nH/AmDF3sbXC+rq60shhMxdHvCRGPA825Y2kV9IoUJ3gkg9P7RosfwIJyC7oBM4pcLLLETNoeCYjNmYuVM4Qxtn2rVDHlsAaabGFTPJ63ypebWaCQt/OyuMJc3hCu85//u8R31v+aSabbSiuTSshEt4A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gNI3DIE/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gNI3DIE/; arc=fail smtp.client-ip=52.101.65.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gNI3DIE/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gNI3DIE/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=awq44FDZf4seb0OERrDG3IktercPkVrnKmZZ4tiat+5mS6F59WrcrIyFCGi2u9QhCCKcfBTng/Y5cL6eirvMAOYfft3HaG8uqrn8fKvHOVnjVR5hbesACRfNkd7nar+kGnoeUiZ09NG16zvqarwyyBwVf8mqMGJLmv4mwf+FHeCo0aFPvxR/ZcptIeRRAnpNfp7HQ9cGADwRLQOEJKHpRHQf2nMobzLzR8i/ITlYDtYX6xTfcrClYUXlUl5zXnUOS5+NwaskGtVuIMKrYmqtgFKmiW8XnGISdKhu6bCsAJODXoQF3GDcV/WDz3ss9kvsfvDQ3RijoKBa9f4skgcQgw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXvWW2kzXycqQT+ZgoZ5oDN1ray4Qd8cAZJLvsYoALA=;
 b=CqNeEJdgGS9B5JjSR816SJBFoehrRkKNfC2q/XDvYnET3Rf37VH+dDbkM/kKOx/cQ/J4erYEEoqBbT0ACC/fVG4oUDF4fT+rYYPJBs0o5xoS5DFSr/48mWk+v/axewOelSpGiBohoCmvazhS24N0wYICdaH+r2RG0ZBdYCu9ZFCPzyxDBNzMxxuoxyvcrae7pNCl+DRYkBhQZHiAjlXRgReEYG4Mg6/tXZpD7QrAqXz6tHnmPtskUeT4uX/b/Afq06n5frvfh6VdXL4O4nXAXUag5uf5KOiDWBa/ecoKDgp8PGzZVGZ3sd/k3Xv/ydsEQqR7RMeEnavjiB8S7WHwPQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXvWW2kzXycqQT+ZgoZ5oDN1ray4Qd8cAZJLvsYoALA=;
 b=gNI3DIE/6g/QRPu11bmzhiqUPAccsDcP/wuIIxhVVkI60rWetfxaIsn4YlQJSijc45bKo5aGpKGDgFO2lviMYBHf1jUKkSjVFxR7D9iIm2h9xb4BmzWaK0QWHXQo4CuvE3+ojgEtM96pgjnDLn/td1ryb6yEVxxT6EqxEVJefuI=
Received: from AS4P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::16)
 by DB4PR08MB9285.eurprd08.prod.outlook.com (2603:10a6:10:3f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 16:00:24 +0000
Received: from AMS1EPF0000008F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::5d) by AS4P189CA0013.outlook.office365.com
 (2603:10a6:20b:5d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 16:00:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000008F.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 16:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yb7XmmR9Nj4HCRePi0eUlHjZjCQc9wPD8l++iZnDGrMpOGsUxyGfu36+slrI5Hyp8JsGWP/ECdnl4aWzIgJQmDiOTsiZ2eDa7uCxlsZZwaVf9wH4a0yA2w+5asfMwOu13xvaAyAG7tIz7SZl3U2iVye7H7D4clmly9OgwxacOa/xXfTeeLnnUHPRaslxwq0BTGcTtLx/G9Z32Qu+MYn9RYPFdxm2RRyvV//7zvVz7MAlCxPe4QK52wvbR24wS34nxs3UIcJBvo0R8ReeUgTDitGIW+VsvnCDU3/thwMIwW1y40JBEzp9qLh6+J6zbl7OXAUjkIhbCR32+BoiWFjVYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXvWW2kzXycqQT+ZgoZ5oDN1ray4Qd8cAZJLvsYoALA=;
 b=MRQaQfPUTbQDkXc8RrU9OFQOkGzs+z962RycefNdb2rRqKFVthzU1RlF8YDl+i2DkVX/Gd8rTAGcbJnQwzIC0K4aQ73TpntQXf6pkew5ji2NFtf2KDSE7IiWpFOw9Yp3rTmVTDBXb9Ler0RUYCa4W9E2Hx97AOK+cpRPcQUXEwUShkYY1iJV+qkdfqbXIceyv/IELal7d+lEcyZxHJ4sc9qA3xgS/adcqseGX5HzOEXPPkWucYfXIMEmMW5tYr6c0sWsZiozI0HO816V5zCW5iTz02sMPYeXMSVDVLdt7dVgUcIkYxBV51OIE0RNQXIy5Xza2qiQCAQjnQD6EtPUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXvWW2kzXycqQT+ZgoZ5oDN1ray4Qd8cAZJLvsYoALA=;
 b=gNI3DIE/6g/QRPu11bmzhiqUPAccsDcP/wuIIxhVVkI60rWetfxaIsn4YlQJSijc45bKo5aGpKGDgFO2lviMYBHf1jUKkSjVFxR7D9iIm2h9xb4BmzWaK0QWHXQo4CuvE3+ojgEtM96pgjnDLn/td1ryb6yEVxxT6EqxEVJefuI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB9414.eurprd08.prod.outlook.com (2603:10a6:20b:596::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Thu, 19 Mar
 2026 15:59:20 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:59:19 +0000
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
Subject: [PATCH v7 37/41] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v7 37/41] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHct7lYllGXu8awAUuSw9M6BhVVwg==
Date: Thu, 19 Mar 2026 15:59:19 +0000
Message-ID: <20260319154937.3619520-38-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB9414:EE_|AMS1EPF0000008F:EE_|DB4PR08MB9285:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c0357c-b4d0-4796-6e6b-08de85d0a139
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 tHm+HVBScyvPkJ1NOXZ3wdGvRVgtAbctmhQXyMW37V86OFMTjcMHZ3MIUkc9U462L9ZP12fEsk1IufftxKJ3lOG8UIwwRCd2qAalVqzsAkHrH415D2XqXUVmdYvKprMrwrMIUfXWWv+8tVz896txw4ReDHDOE9pWH8cmQ/L+vpKlBnkOWqT5Xvekqfaun+mx6iG9+fCBjimr1wlPfdN+DTaGYHBKbKGWwZAHmBs0vfDFCZJsP5PNOXLpUuCaK5mc7aYWRg0+pPkEPkIBzN3jvBMNbYlVGFnUEvdGxnH9CHAKHXUFKRw6HEAUx1ecJMypebUh5BletaQiyWbAzzNsfaAYe618ucHfkMJ713vwPl5i/afcQTbk8XBh5Di85dMOOZogL6wqlC/6uu9OXIzBlYp7ACdVJWZbrf9CvOllXy4q6CMisiYOnndlO+UzYQw/T+yqlsY/phNcWxbjbnhpAmWg4NE499au3uDIGaq9fwDcUhicbuWhagH6/qtwRja6ayO219wAVltBPqc+BgF5zX45Bg8IwgrpMKu+UKP7Jb/vUdOHFy84hoNl3qE13tra4NdQs3eDluNEET/vbrXV7d07bKz8HoyOmFRHUWNBNfIYth6B4XHvUBOdHvV5UZ0gCSKfNjhW5YywpQjeQCkyXx7Yiv/gq6sCE209GDE1NBAggfhV+8wyPfGGw1m5Id/19uN08Wv6sZzHp3uHg80Vzk4LHxNjqo3uJjOXFsOwVbXHzPwC5m79xUb5X/uO2ERMljM/f8wCLT+41O9YQ/xFFnSAhHDVpi1a3Ra0jpHWb2o=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XXFB12KSGvB5/76WaGNeoEfLfEoPz/2NuTaHq7YR69cgmBBfKco9nWR+Cm68V7lRdOzHDorLdzVVGVI09ohfw6qscwWGduprwqhCKtZIpqHK3DO7xqTGwOasSDdbDq1DDnYBpRhaeZDHB4i0uskcdkanvm++Ig79gTvUd4vxTsfOEs/DqH8+lqYU8sc8Rb5MFPa5NWZ/DaTFp8SBzfvGDzj2MRvhLCTU1knG5B93YR6Vf/9e/G3TAR/CsCSX4uTKKGq4NNan+ZY8GDXGmcgMcuWqkS1K8UwOmYARY7nSR1vffNysDk4CSm9yfurhNz/ZC2jlkQvD3Z0iBNEXUAfNRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9414
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c62dbfaa-e2ff-4f72-1ba2-08de85d07b06
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|36860700016|376014|82310400026|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ouUFyXNYgJkzFGC/xfd4J2WPakIbeg9skC5DmqeYppFipRgJMwzed/0Q/6SZNDves7RaWUKglOjU2pI33EPwpiTBcMsbtKYg8/CJPRGexW8w5LL04J3PqyJ3RBPB3QRzEIEZJGUQ7CcKuThdAs6aTkuUhXp1/Yzc2vZdEnNBO6X+3hdw5pkrJ1QfByQXMr6UlVJLH8z+HXdUsgHwqZP4XfhR2kIVa0Yk1+cVhpOsldHdQ2lyglPtaFC6yUy0ntiqQ5xde0P7w4K+nuJeGCUdFUEcLFJ7lZI8mRfWyhhXBYPrABdSrWUMXlduzBEg1apGUdiHi1mnt1Utrc2mWw0VVbnXKRHvSaPk+NhIDYMkBbyQBHS0AC3xcnw3FcMWJnSHQDjFioTWGd2a0jrXGEC3Mp/az8+2c0H+E7HACAcxLH2pI60Ww+q/h5X+BRdgkc/Kq/MGe/w33EvHluqyRNamfLfvGGHf9v5LI3+iWKw5wJmbmjm+v7Pggd9WiS/bSMeLU00PXjZ7uQRTXTQvC09Ik58BCBWF60gvqZ4JhskFolh6J85/m8+vGd0ty+mPZOc35SYepl79aJanLNLIjslLLPKh+M+JZkS/wyfez8vXk1vFnE2PPisnXqB26LpoR+lC+9eeLJDX268aQQ/WDPAag9//n6BKZr1vsznmHNlXvMC8W2xFlkL2J2y1J/jC1/PTDkwc0Nqy3T1goBw4lvPS0cHMyRlkG0riuJ9a4G0S4HwAzNTyUsLL4bJmaX5xektX+BP83hQyYRmoktAn/9b4kA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(36860700016)(376014)(82310400026)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bmi0zDXjShZXi4+nYD4JZZfOiJt8Jw1+IJiayY1U2719iMuzRsORKlGZtRz1JYtM1Kjne7xPiU3LVOBH3tjMDXs4DXXHFsEoau675fknESU+8A3r0cYAaPNWFM/SfD2Igqrh3xJxA2JXtGQEjla85WRDXrHj23W+QAjrmOD0gsktdCRlqOGr9MZj4Sv9bAftGbUJecb2Y0Raqch2kuqWAefbhcick+Lm4iggOpOOFr/nlr9eGNce9W831bkU7jdUUNVYVGWR36Yjin+kr3GqAu+696BqrLRbxGzaxJsYxogDJGGNKw/ZLlqpzBOiw0qQ2ZEccEY7He7ro6oO6UQepAJV4jDKRqD5eZoJx3z1Eb5tWcfmlDSQtxpejsxxGUVGRVNXbUqrCduqNpMLzdcDUOdNe+xQXcHe3FOVeY2YOZ3DaTYif4epPDH+SE8w9cmR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 16:00:23.6837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c0357c-b4d0-4796-6e6b-08de85d0a139
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9285

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 48 +++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9384c7fcb1aaf..f7a24ea6ad784 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -39,24 +39,14 @@ static void vgic_v5_get_implemented_ppis(void)
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
+	bool v5_registered =3D false;
 	u64 ich_vtr_el2;
 	int ret;
=20
-	vgic_v5_get_implemented_ppis();
-
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -64,6 +54,38 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	vgic_v5_get_implemented_ppis();
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	v5_registered =3D true;
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY)) {
+		if (!v5_registered)
+			return -ENODEV;
+		return 0;
+	}
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -79,6 +101,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1
