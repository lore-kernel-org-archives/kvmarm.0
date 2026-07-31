Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010016.outbound.protection.outlook.com [52.101.69.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCD3EF0C8;
	Fri, 31 Jul 2026 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785504847; cv=fail; b=cCLHZlyhIcDII792NCwcBYRLql2QazcdUr7dazUPPA8MyQK6+Bxc8lEHwWopvH+yrp5+AEg+a4WztTGrVTMFwj+a7Oxmes74WUK78cSgyMYYhpHmTMvs1utRIqu1G77quKg5Z9OLIoy8wFEcGYbrUtrEqmZUCfHL6mBrjckQSJQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785504847; c=relaxed/simple;
	bh=53omxlqpR6v2+Pt3160r5bJg8dTSFBNDczuLjWhA96c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QVrgCoS7GbtLkTDNYlSvpW3N29LPnS45CW929JdvZYgkCInc4cwvjzOJGS2UXV8I4pA4qqXMjsEcQpLP9i0EgDo9Z+kiyWj7DOo+3hyRkfw0//2qadsbuwg1e+Gk8ZnY04RBrkjSH1oEe7Z1cW6Km2XfBBU6XOrVdKy6oNt4DfE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NDrhZ+Lf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NDrhZ+Lf; arc=fail smtp.client-ip=52.101.69.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NDrhZ+Lf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NDrhZ+Lf"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SOlXWZsjKG+doni1rQcl7JLJBbxM+GwW8m8dHeqzbnJNTgYfSjCENKRPJy5fR60Xyj6uncKjKsJ5yOXkiFOzNvJwAhHecGIlMiCjerJxAPNq3hwJoJTNKpRJduULvnaN+9RWMla1nSH/LxXWa3DLleAC2HN9t0TnICy8XT64x870MlDlqI2eT1CABuFO+vB3gZ2oVPx256lJMpWed2rkVKsvhGeufjbgW2xtyjZBsTfcxh8QC66AbMSt3zpQVjgJneR7umNwYhT1ONmFnyO4YKWAV8/XjV8BFzG1YbQdExmgjELl7hpI/3+tS3UIqlOPCQ7txnEqlJC1C36VjNIikA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53omxlqpR6v2+Pt3160r5bJg8dTSFBNDczuLjWhA96c=;
 b=N/KvbGDQ5XQCijbydXIhpN8lqXWFDagG51HpJWwkb28rucGbNkHrKUWCpB4UeE7IcpaIJIc9sG9tjlFwkWTGEM6EGjkVQDQtUqgLKEDkMzsInJeghujpIqyCtWRiZ8qqTYLug5C1LPCnPxeP0VtcIm1BHUGe68JXQNxk9xQpDhlWsoaAVaNPZWdR0BmDULGcI+E6GqLjjyhzCzQSRTEAcyI+ND7u7nDUXIJd3WZvEahsU/QV+20arOE9WbLizFxTgoOkCA86ZWXTc0YIvMn7VWd+ZpWKDnGtSQsVYh251brF9CzNY5Djf+bojdCwF9KUnllcQkkwGWyOIUWMCN6vlg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53omxlqpR6v2+Pt3160r5bJg8dTSFBNDczuLjWhA96c=;
 b=NDrhZ+LfIex0gexST+Jr0Bf+ZOCDwZOsK+OF+62zfGjxTXUR3sUcBRCZkq/WjhafP+b3K2O+MxN6iRxmSpD/vFA2fCP10Yp+0ITYPLBOuNA74CYhiKv/YLX71BnS4S6zLDPR9dFJ2LVH/CvlcMXaUomqXle9d5RAZwUnK/7mJMg=
Received: from AM0P190CA0013.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::23)
 by DB9PR08MB11461.eurprd08.prod.outlook.com (2603:10a6:10:608::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:34:00 +0000
Received: from AMS0EPF0000019E.eurprd05.prod.outlook.com
 (2603:10a6:208:190:cafe::3e) by AM0P190CA0013.outlook.office365.com
 (2603:10a6:208:190::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 13:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019E.mail.protection.outlook.com (10.167.16.250) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 13:34:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLwzXeINyh75XIvnW1shGXZhKgsFsgt3n92UXvAkMuTg0ASxuXvIARVBkh7BjFn0NxBe+TOMrQFCvBnifJf3Upj06yDMr0yT0Vx7GnY0RNI0W+W/qDNT4AtQuC2mEeX71yK4wzWak+7zRx9SY9+AS9hXqTHTmSCbaE5VKb5Ii9vbXQxLGcdBCmTnx7dnsy2N8yKQPhoZ7kqpGyPnR7K1fbFbF/G7gv2LMWvBKifI7z/QkY9BlevsMDPRKQ8Xrzuwg92adLW9jtFgN6RMWITuxuACI0FwAH86fdDDfT9+wPT4tuJudo9FBiSn6mIFgCvWftnHj1nXXNAMZSrye2vilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53omxlqpR6v2+Pt3160r5bJg8dTSFBNDczuLjWhA96c=;
 b=kudg4BbyE7I0raSHOHRLZKo9FIJlmzZGQrJld33lSkMFsWUJMjpju/4LBx+HAR5l2Q3cfPe0dnVn34oAA/p8Yj+LkpLkxqwNgQMAFBzGUymEFYscvPY17HXDtZobSzEIAwM0uVY4D2ndZj5pAFVqeDI+Z1iLvxsl3PNC5WkkiNmn2wzBNtrdRuibyw+Akbm4dzSnK6CVBU4dS5S4lrEczP9IAwy+gNSN23S6BV3VPdRYzZbPNEvJMmdy15ezGfB2uPQl33NJT/8hYt4H+knx9mHbWptKe1iKh2Ps52dbLw8zagXHNtOv7tNpflms0cqXyoz4G+hKXrop/+tcGUN2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53omxlqpR6v2+Pt3160r5bJg8dTSFBNDczuLjWhA96c=;
 b=NDrhZ+LfIex0gexST+Jr0Bf+ZOCDwZOsK+OF+62zfGjxTXUR3sUcBRCZkq/WjhafP+b3K2O+MxN6iRxmSpD/vFA2fCP10Yp+0ITYPLBOuNA74CYhiKv/YLX71BnS4S6zLDPR9dFJ2LVH/CvlcMXaUomqXle9d5RAZwUnK/7mJMg=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB8004.eurprd08.prod.outlook.com (2603:10a6:150:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:32:57 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:32:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS
 enable state
Thread-Topic: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Thread-Index: AQHdG1rHMEBbTcIjEk6cvjvril31W7Z8i+MAgAsfl4A=
Date: Fri, 31 Jul 2026 13:32:56 +0000
Message-ID: <f9ce76dacce43a14a31c782068b222f5f17ce1eb.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-24-sascha.bischoff@arm.com>
	 <20260724114100.EF0161F000E9@smtp.kernel.org>
In-Reply-To: <20260724114100.EF0161F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GV2PR08MB8004:EE_|AMS0EPF0000019E:EE_|DB9PR08MB11461:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c895fc-ffb9-4844-f128-08deef086143
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|56012099006|11063799006|4143699003|6133799003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Q2nVYprx9nw55XAmW5XiyBj8D0mf+XpHmYQc3Tzfm+zfXZSQ3ILZAXiZG+eHny98lPQEWUPeqDoEjiJXsVVmm4LQKysgjRShC3LbR0NCindccrVR4YcIwi1GpfUEj6Xuq3NEDTNivUuyv7lRW7Yl3TZda0z9mdcS8I752Pr32M1+JLvddLeeMErwpCpRxrjgu2k56FUi6W8ZDTRLaorTiiVEKwtmeNbo1NLz/VqKRlWs41PFjoiotcLltMAx/7YhQzr6ZVVVtLIJrsljYiCm40SlFUJHUBr39IajNdL8R8aZZvvy7ZB3FrIl78IhKWfznRrcGt4OpZNBdYZ/exLaoADzfTgVCdRE6qbxrvO8NrS8gvWgTO2HJJ/lzTvMlKF5iozBK5LmTTZuxNH/rzRBON+ALRKIY0viP0OODqgSq3qp7H8tVyoVequUwMta95guKalrLrViTb9gjxR2SbcaLi41cGrdofHOiDtsrl83VQF+hN3Y2MH/rZJAw5owEJlQc7I3fpQAhZd9orqO/nvjSIV9ydeNbICReP241ePhbdHmOBJ2ukJb0nkRe3J7+6zg56Ko9+i1MkK/LAMl4z3EZJUvp5cMWjJXxZnQ7UJz3884Pp0wngRJvqfbxX0vDpbkHyqvwu5kzSN2uTHwXkhP6UdgeQlIvUcmbRpT35WQIqqSzvFiIWET+YBTcwcwjZlhYerujWImUzhnBPcZakiC7YVGMEiu2tJx6RxQxuSAo7s=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(4143699003)(6133799003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3E5F6CD20A630498209B9F039C6BA26@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 kv/1eI+2NfH4yW1gAHj4wUuS7btUvqZG7bAztrmWoJu5zbSuC1Zckw7JF2I7UDdB3Vsa7M2RGg9Itb9CjAZLFp2XkX6tsABXKkSLUwAKVGgTgvMu80i7s6TewmUPexfMY5fgmY+XWxiH9zAlNk7lul+ko5AcN/a33R69/1lG6qfq8SU6ZhCGpAUkyBhN+EskBpeXOqb6snt5ztN0TmPMaQq/HHnzZPuMbTBaqwwv8Zjsmw8SPo3LYUgYallf/o+DutTqOfbwNpwzinEEHIiyIgCkknmBkM8i9RIoyWCb1hmVLs9k3nUjSJTcDVLLH2CJW4nvM5NbIPKPPYQp8bXbLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8004
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0ee67c05-ee70-4cc0-5646-08deef083b6b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|35042699022|14060799003|23010399003|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FRcauD1ofY6zohPPoYk20ZJuL+EktXgJOoPwD4rqsaOlzH2Qo2V1ec5qR62YXj6qgKhm1U9bvRsaIQ1tBHuQRepw8jdy7YcK9kvYDBvKWJRAs//3NqNvPyaTqYkjkYt9Bg8Dr6rgmtBMz5LlYZk0B9SplttjgzJcBhU091cWEfS/unLjXdtGUbmXU5Rq6NqXlByC0MqupssIvu7IE1hjTFaJRaFdTNce0RZAzvrp7U0nWT6i2yxvJdkI5r/opOLX+Qkzgm5uU2uGjNeLJcKTMfa9G0vVVzy/Lpokvp+bYq8LPTA6o7fC1IKXSDaGp/v+Mf9fCGYo7CvajVQ+hL4abn6E6drYyzaMKVkK3c+VplW5YDO2YLsWGgp/LX6b2MlfF84uyfcFBfL643dp9BapJQfB2ldP6kYGFLa9mkQA/1uwS0x3o9+XyeaEAMYVnhcvSlPJSKt0uVgmUXRD0ARZTCcLhRJi7Qgc0hHlZN8UoAsiJlG9dANPJmuzuYuI0QEapM9FRybRrsXKMHRI9VwCkFWfIpGd+CZiUkPxji9DWSeyC9YBUYFZ5KC1ZUVBRTDgtDjSb4z8ghHVeiturPfEli8QE/8zrQD7Lq1aJaJKoSRY2rMq1n3ujx4PV/3xrnSXCD7ZIZqWzq1zA4A1BvJNt25dKhPIo+hoCxvWcpVsPCnHOgR+SL8oDnR+JRCVM6Azp7H9XoWr2ef8CD+hQ4+NJg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(35042699022)(14060799003)(23010399003)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fJn+cHJ/ZN360ljxD11xxnxXE+BCAkBKmb5/nwg/rxjOufKXKskjkLe53BjbX4mohr5Ixe0pA8LtGwskSYD58OOzlmTAaq7YnnGIzqVnmdbOMgX+cz7/OkdauazltZTGctYW4KfYm787L4m2gGFfCMWW23q4FTtkws9wwqp43PExX2ANNKpUP73PoH9iiNuWFPcOQENgiWP9CxM5xn1E+4x7FWEfAYTBValG5SWlvCVt5mjydlfD+2nB50ttjjePhVCAL+Ct2EjvxVUwH/XH8PO0cezeMiMCZ4vr0LNpqKs24vXySM5TaKH77N/9lZs++M8PlgF2BlDVvhfIWXBUxa72rJvFRzJY2yhDP6LNYuwRpaQiveDDWTxnHrK/b4KMEQ2h4oubLYQamXeDY/Q1nmi3BIBqsJHAco7KegHcOr+cWR9LOlOXKIzikEa+ixcM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:34:00.2731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c895fc-ffb9-4844-f128-08deef086143
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11461

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjQxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gU3B1cmlvdXMgVlBFIGRvb3JiZWxscyBhbmQgaW5maW5pdGUgd2FrZXVwIGxvb3BzIGR1ZSB0
bw0KPiB1bnByZXNlcnZlZCBJUklDSFBQSURJUyBzdGF0ZS4NCj4gLSBbTG93XSBNaXNzaW5nIFJF
QURfT05DRSgpIG9uIHZnaWMuZW5hYmxlZCBjYXVzZXMgYSBkYXRhIHJhY2UuDQo+IC0tDQo+IA0K
PiAtLS0gUGF0Y2ggWzIzXTogW1BBVENIIHY0IDIzLzQ4XSBLVk06IGFybTY0OiBnaWMtdjU6IFNl
dCBJUklDSFBQSURJUw0KPiBiYXNlZCBvbiBJUlMgZW5hYmxlIHN0YXRlIC0tLQ0KPiBjb21taXQg
NDBmYmFkNmIzYTJiMTYxN2Q0YmM0YjE2YzNhNmIxNzZlN2JlNTE0Ng0KPiBBdXRob3I6IFNhc2No
YSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBLVk06IGFybTY0OiBn
aWMtdjU6IFNldCBJUklDSFBQSURJUyBiYXNlZCBvbiBJUlMgZW5hYmxlIHN0YXRlDQo+IA0KPiBU
aGUgR0lDdjUgSUNIX0NPTlRFWFRSX0VMMiBoYXMgdGhlIElSSUNIUFBJRElTIGZpZWxkLCB3aGlj
aCBhbGxvd3MNCj4gdGhlDQo+IGh5cGVydmlzb3IgdG8gZW5hYmxlL2Rpc2FibGUgdGhlIEhQUEkg
c2VsZWN0aW9uIGZvciBTUElzIGFuZA0KPiBMUElzLiBUaGlzIGNhbiBiZSB1c2VkIHRvIGVtdWxh
dGUgdGhlIGd1ZXN0IGVuYWJsaW5nL2Rpc2FibGluZyB0aGUNCj4gSVJTLiBUaGVyZWZvcmUsIG1h
a2UgdGhlIHN0YXRlIG9mIHRoaXMgY29udHJvbGxlZCBieSB0aGUgSVJTIGVuYWJsZQ0KPiBzdGF0
ZS4gVGh1cywgU1BJcyBhbmQgTFBJcyBjYW4ndCBiZSBkZWxpdmVyZWQgdG8gdGhlIGd1ZXN0LCB1
bnRpbCBpdA0KPiBlbmFibGVzIHRoZSBlbXVsYXRlZCBJUlMsIHdoaWNoIG1hdGNoZXMgdGhlIGJl
aGF2aW91ciBvZiB0aGUgcmVhbA0KPiBoYXJkd2FyZS4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjUuYw0KPiA+IGluZGV4IDQwNDJkNDY4NDMxYjEuLjc5NTdiOWRhOTVlN2MgMTAwNjQ0DQo+
ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IEBAIC0xMDY2LDYgKzEwNjYsNyBAQCB2b2lkIHZn
aWNfdjVfZmx1c2hfcHBpX3N0YXRlKHN0cnVjdCBrdm1fdmNwdQ0KPiA+ICp2Y3B1KQ0KPiA+IMKg
DQo+ID4gwqB2b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqB7
DQo+ID4gKwlib29sIGlyaWNocHBpZGlzID0gIXZjcHUtPmt2bS0+YXJjaC52Z2ljLmVuYWJsZWQ7
DQo+IA0KPiBbU2V2ZXJpdHk6IExvd10NCj4gSXMgYSBSRUFEX09OQ0UoKSBtaXNzaW5nIGhlcmU/
DQo+IA0KPiBUaGUgdmdpYy5lbmFibGVkIGZsYWcgaXMgdXBkYXRlZCBjb25jdXJyZW50bHkgYnkg
dGhlIElSUyBNTUlPIGhhbmRsZXINCj4gdXNpbmcNCj4gV1JJVEVfT05DRSgpLCBzbyByZWFkaW5n
IGl0IGxvY2tsZXNzbHkgaGVyZSBtaWdodCB0cmlnZ2VyIEtDU0FOIGRhdGENCj4gcmFjZQ0KPiB3
YXJuaW5ncy4NCg0KT0ssIEkgYWdyZWUgdGhhdCB0aGlzIGNvdWxkIHJhY2UgZHVlIHRvIHRoaXMg
Y29taW5nIGZyb20gZW11bGF0ZWQgTU1JTw0KYWNjZXNzZXMuIEkndmUgYWRkZWQgYSBSRUFEX09O
Q0UoKSBoZXJlLg0KDQo+IA0KPiA+IMKgCXN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmID0g
JnZjcHUtDQo+ID4gPmFyY2gudmdpY19jcHUudmdpY192NTsNCj4gPiDCoAl1MTYgdm0gPSB2Z2lj
X3Y1X3ZtX2lkKHZjcHUtPmt2bSk7DQo+ID4gwqAJdTE2IHZwZSA9IHZnaWNfdjVfdnBlX2lkKHZj
cHUpOw0KPiA+IEBAIC0xMDgyLDYgKzEwODMsNyBAQCB2b2lkIHZnaWNfdjVfbG9hZChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQo+ID4gwqAJa3ZtX2NhbGxfaHlwKF9fdmdpY192NV9yZXN0b3JlX3Zt
Y3JfYXByLCBjcHVfaWYpOw0KPiA+IMKgDQo+ID4gwqAJY3B1X2lmLT52Z2ljX2NvbnRleHRyID0g
RklFTERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX1YsDQo+ID4gdHJ1ZSkgfA0KPiA+ICsJCQkJRklF
TERfUFJFUChJQ0hfQ09OVEVYVFJfRUwyX0lSSUNIUA0KPiA+IFBJRElTLCBpcmljaHBwaWRpcykg
fA0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBXaWxsIHRoaXMgSVJJQ0hQUElESVMgc3RhdGUg
Z2V0IGxvc3Qgd2hlbiB0aGUgVkNQVSBlbnRlcnMgV0ZJPw0KPiANCj4gV2hlbiB0aGUgZ3Vlc3Qg
ZXhlY3V0ZXMgV0ZJLCBLVk0gY2FsbHMgdmdpY192NV9wdXQoKS4gSXQgY3VycmVudGx5DQo+IGNs
ZWFycw0KPiB2Z2ljX2NvbnRleHRyIGJlZm9yZSBzZXR0aW5nIHRoZSBkb29yYmVsbCBiaXRzOg0K
PiANCj4gdm9pZCB2Z2ljX3Y1X3B1dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IHsNCj4gCS4u
Lg0KPiAJY3B1X2lmLT52Z2ljX2NvbnRleHRyID0gMDsNCj4gCWlmICh2Y3B1X2dldF9mbGFnKHZj
cHUsIElOX1dGSSkpIHsNCj4gCQkuLi4NCj4gCQljcHVfaWYtPnZnaWNfY29udGV4dHIgPQ0KPiBG
SUVMRF9QUkVQKElDSF9DT05URVhUUl9FTDJfREIsIDEpIHwNCj4gCQkJCQlGSUVMRF9QUkVQKElD
SF9DT05URVhUUl9FTDJfDQo+IERCUE0sIGRicG0pOw0KPiAJLi4uDQo+IH0NCj4gDQo+IElmIHRo
ZSBndWVzdCBkaXNhYmxlZCB0aGUgSVJTIChzbyBJUklDSFBQSURJUyBzaG91bGQgYmUgMSkgYW5k
IGVudGVycw0KPiBXRkkNCj4gd2hpbGUgYW4gU1BJIG9yIExQSSBpcyBwZW5kaW5nLCB0aGUgaGFy
ZHdhcmUgd2lsbCBzZWUgSVJJQ0hQUElESVM9MA0KPiBhbmQgREI9MS4NCj4gDQo+IENvdWxkIHRo
aXMgY2F1c2UgdGhlIGhhcmR3YXJlIHRvIGluYWR2ZXJ0ZW50bHkgZXZhbHVhdGUgdGhlIGludGVy
cnVwdA0KPiBhbmQgZmlyZQ0KPiB0aGUgZG9vcmJlbGwsIHdha2luZyB0aGUgZ3Vlc3Q/DQo+IA0K
PiBJZiB0aGUgZ3Vlc3QgdGhlbiByZXN1bWVzIGZyb20gV0ZJLCBzZWVzIG5vIHBlbmRpbmcgaW50
ZXJydXB0cywgYW5kDQo+IGV4ZWN1dGVzDQo+IFdGSSBhZ2Fpbiwgd291bGRuJ3QgdGhpcyByZXN1
bHQgaW4gYW4gaW5maW5pdGUgd2FrZXVwIGxvb3A/DQoNClllcywgdGhpcyB3YXMgYW4gb3ZlcnNp
Z2h0IG9uIG15IHBhcnQuIFdlIHNob3VsZCBvbmx5IHJlcXVlc3QgYQ0KZG9vcmJlbGwgaWYgdGhl
IGd1ZXN0IGhhcyBlbmFibGVkIHRoZSBJUlMsIGFzIGl0IG90aGVyd2lzZSB3b3VsZCBiZQ0Kd29r
ZW4gZm9yIGFuIFNQSSBvciBMUEkgdGhhdCBpdCBjYW5ub3QgcmVjZWl2ZS4NCg0KPiANCj4gPiDC
oAkJCQlGSUVMRF9QUkVQKElDSF9DT05URVhUUl9FTDJfVlBFLA0KPiA+IHZwZSkgfA0KPiA+IMKg
CQkJCUZJRUxEX1BSRVAoSUNIX0NPTlRFWFRSX0VMMl9WTSwNCj4gPiB2bSk7DQo+ID4gDQo+IA0K
DQpUaGFua3MsDQpTYXNjaGENCg==
