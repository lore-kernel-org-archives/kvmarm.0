Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013019.outbound.protection.outlook.com [40.107.162.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2C834750F
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306115; cv=fail; b=ZrWxEM0vEEI82LVJpPYIhFXcJQfedMs8kZbJ1lmOewhV7WiQdmSMsozlYyEBhMPG+5nNHXJnwldZnA48WBzn9pISiLSYlHVH6Xv0GOix/YXQWyTi0RplgMNA3LltXUyr+DXc93i8BXfU7yX++/E1Mz0UxZKT3fbPszjA4v9Pcqc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306115; c=relaxed/simple;
	bh=gYb2MKu9yUBS4Kt9nIUIIh1dzgO29JNccVH/H77aQK0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SNXTAG37J6ddGcMayJc1zF0PnlFvCBEnLYFCYGVENYG4v1Q/XV7onxLUR7MOmZ8szy6fEqlWHYAJWAdWJE0xCLYZgXgF43SjkSVev3P5QuMc8iAyOF4em7QDniLBUuWHTbm/iLESqJNeFLCEbUJW3pBkjVQAEQrL56SdfXbfH6s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p3eQJ4fQ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p3eQJ4fQ; arc=fail smtp.client-ip=40.107.162.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p3eQJ4fQ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p3eQJ4fQ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MqM4UIwqJ/JXhsGbgijC3dNWQfnwh0mWGVpH9tMCvx+Ivxn7K/79ldMfwTylKUC4hoJYrxO8dfcaMIHjfHGksOt3WNeL7VYEUJbok4kDpSF/rU2WRuj2GiMgJa9CN/6Apdj1jK5KMx4OQExC1QbRQ7T0Q+qjyfzTU9ur2W4asLiIxpqHiTwq4r0bJsEPk2ZQctWfmY6Z5+2jSoSBn8RVlj/ddG0ZYP8TexkcXVVl8S1qh6SQhz8UZ2h9Dbv+8JLtVE/Sj/otZCupEQ3mxmdeGnLBJ4UBdQabMvKfLvADTCbPT+ZGBjuupHMLOe2nkpewivHCxY1Qtz6hfX0wU2J6iQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyQVz+vqGcF0zE0tci8Tqf5PbvQ6uiYL6CE4j1oZkSI=;
 b=iasglvO3HvdvREKpFC7W/Xs0Ytijs3DVKMXe3JydbGNBdeWnVVh1xPzVwa2T2/ZprrluqrzZ0xk8S+xWkI4HmCy2QzQMokeVVYDKFFEj81Fk7GZPkY9fLUQ3pzK9tEYnbF5Cl9IwQvH1CkJQ0zoAa7fHHqNbWo2rFCXrE68gp8w1ktEhAZ8DtR5ATIYJ4PTbJRq3DPWqfQKoz2RwJl7d3QjxeWqQoPDkdA15D9aY2LwdPHsPiyFAbzkxZWvfXF0x+UW3d2DzY2dJh7URrxGjqURnY769f2jWXJn/KMuOxMyacots9vL4oFw9eLvT6/FVnHnXA/Cj5KWPQnUz9wYxDw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyQVz+vqGcF0zE0tci8Tqf5PbvQ6uiYL6CE4j1oZkSI=;
 b=p3eQJ4fQcaq716JCVmeyI8RDBBwTXLPezjv+mjHaSL681LLzK1b+BaYJWje4xmM7ESNKNVrv8V2YFLryf6Ff9vzdqFKfx9oP5bdFTqLuyj7orxjeLuWptaJnjHec6Qo851U6YBcVS6G2GCLktdkg5esDCA3wRttaznkD3nI8564=
Received: from DUZPR01CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::7) by DU0PR08MB9439.eurprd08.prod.outlook.com
 (2603:10a6:10:42d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:08:27 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::60) by DUZPR01CA0014.outlook.office365.com
 (2603:10a6:10:3c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:08:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zF/qa5pFTazXZnldctWNhT2rmZvzzLqXcc/9yExIZWRMxMH7rKEr4hYDeMWPb4Ro57W0eKJ3x0K9KDWbWpOHBMH1NbvMFiWiG5HxwZZwVgglw3qGesI8z1zUJoGtK59IO8KGPEBg4rCucd5xxg5i4jKPT2S4mzKTPAfcL/xvWZMYkS40zY1lskmk+i0zflRed9V6UV1uuW7U6KlupQ7R5xpzS3Q3R7DXwbQ1zP1patS06cu5OEIRNmpRjofd2PUSzMMmQkL5cEwnmdjqrnodprrdBm4eWf8soJDIjchyICCtGqUcHterW6ZHvgpniqp1IqGyfxerz7eFpZKZg90RzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyQVz+vqGcF0zE0tci8Tqf5PbvQ6uiYL6CE4j1oZkSI=;
 b=p0eJ0mRbtFtqWQjYcVYUc/08imzaHmVDLN1oNmV0/FrdNBkykmBG7dLTOv2XE/KFjl7kwse/CaPEye/ZPCArlIgszJywQid5Ju8p0BqGgsNlIwoXzY1ljV3XcjVyi1sFqWZqMYwKviLZ7EvGZRjfTJCf7MRJDzgU6mt9TWwkGFpKA5AkbarNPM+m+y+ZUYZ8d/UDwYjYe/iCbV0Zq9e3tDckvOa7oAfXk+vNlBEfFaM1COAdtNCCp4c1Ie/xOz6gmrdl0mkrkgJ8QquFziz8K+TesgWprTCmfZuRAuxqhewiXC/2tRYfoc472F4904DYgocPNiJsmQCeKsw2eiAKSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyQVz+vqGcF0zE0tci8Tqf5PbvQ6uiYL6CE4j1oZkSI=;
 b=p3eQJ4fQcaq716JCVmeyI8RDBBwTXLPezjv+mjHaSL681LLzK1b+BaYJWje4xmM7ESNKNVrv8V2YFLryf6Ff9vzdqFKfx9oP5bdFTqLuyj7orxjeLuWptaJnjHec6Qo851U6YBcVS6G2GCLktdkg5esDCA3wRttaznkD3nI8564=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:07:24 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:07:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 04/43] irqchip/gic-v5: Provide IRS config frame attrs to KVM
Thread-Topic: [PATCH 04/43] irqchip/gic-v5: Provide IRS config frame attrs to
 KVM
Thread-Index: AQHc1l/veploA5YIZ0CWTPRUjFcuog==
Date: Mon, 27 Apr 2026 16:07:24 +0000
Message-ID: <20260427160547.3129448-5-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB1PEPF000509FC:EE_|DU0PR08MB9439:EE_
X-MS-Office365-Filtering-Correlation-Id: 29356101-fd64-487e-1459-08dea477377f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 k85QFmWC+pLFNDZ3X3ZAlBoK1aeL9SVfF9qx4BEvRnrl7nb4B0nmAfh1nzMylEIHPXy0sZfrqZLt6e59n9F+k0pm4SoBgTCF4px2kYabDHtMxjfsqFrVoj/Ss+NyOP+kWIZi3fR1FPEdwobvYQNnyJ4W1d9Sh6baOG8wCTRHAkmBH03pJiS8iWn8cuaoPLjEh5gCA/DpvTBLV7NtF2BMjyE1lGT4JhysgfELJDDEDtAZE9RYHunav5bmTqtzJ7fKNh/Mil6kd7Y4gRvh2+Eh3l0alud9oxrYiyHhN1J4r2dJng5vxpnM+5p0qtq90yxSkoZ9m2BYxPACPBltDbebfzfckKCWmfUFGTS3P2B7cDrghy8wsMKCiG4/+z8i2MlUSDpzSeM0cL836ToTdWLB52DxWjDTVvnQgHxn6dizeA2tbvHU5olKJiy1YMseeWyTz+14fHvJnzAeJXFdOY8keyMq4+j3U3lZXhmQIMJRrtXllqdvY7+SUV4sRNEE++aB2AME/V6XeeTyn3lL+VceIbgBn2jnEGFPByZNgbhOpI0cI/gxTl57mXRJdSP6WTk6NnXugjkIz8nOesmw3pEDhDGWRnW1cdQ45vG4wcjJAH9pAgwWgrSON+LPHvZ5UZsrJzHyA5vXNRziyIWtKifIJnn56jOIZ5pWjpWmt4B2SxfQ4EjFBGKx7XMfUDLOANn8Hzy45G0Ab5YNIyyl1RFGRD3qoVG2f7m+eQzSCoOnntoJCb9zxVgOv7k184FAckhncySH7iOQSkZnR7tMVt47RtpiLvIVSS0vggDi8nP3N8Q=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 uO1ZEOPSn5WD+YQin6vwfZ5hCcRa5ndHFjgEKz3RvboAkOy4Wzp/Ac6HisAoxeFPt8UFB+pdeAWFweTTBJZ+FIi88vHjC62sdwMcu0wZvTtibvsnKZJHMQeCDdXMg7O/cbDQpmw+0UGSAZK4fQEhd17CP3L6K3Aw28RAGTsNQU6nOhwopjk32KfT7jM5BQmUiNz6BA6QiilY54xcRJNDhzH4u+gdbWuDy+rvR4oEePr+2D+3TWN8NaWFkNtLOVfnu7SAsF8PEeTX4SXgYNIcmTNuZJvXbbuRyls/WEN2otPK9j6yUcWcpM71KTvNekWpXBs4ppMrtMCgJjw04Uyjwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d4035331-edcc-49ba-532b-08dea47711f9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|35042699022|82310400026|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UGbZOTzziY5D3HnNC+EN8rb7f2pADMvGsKHDzE1sTJvmpxJN2VvpSkLL7DIJ6vLO23SJ2/xX+ykQb0UpfmqwG5gi5LeTkdDP4PNaI8j7EesBNDmLagk9Ixsv5pMMBXnOgV0BbEu8vi6k5U8F0d0VVzB9uxRL6/3beAOQnVnhxOGzSj93TtKThW2rwbtN1qQUeLq3D305UKiypu9i1MQMqktb6aw3TgtKgBavXi22zGs94o8AhgSKHoW3oz49Cv88d74EnHyG5k6Kt0QQ69mnCfq0O5rB3S4m5wNaby4ySHLs12nGrHI7oXsqsWrn4/PdHO+kjqYrHAmDO4hxRiYZOh1ewZAIy3f8KvvAN+18S+NKvdb6fBUzno1tItdlLCkuTWU0v7WyNkPZCutD9TwuV+OOy4lPQInRp28l5URd6y5AYeVp2vSSsocEKwZIjjMJ2x7pJz4W0Agj+EZ25YlYVZiRwznIxgC70F9t+C4ElRfy1SXeVp+q4cINIcUkTljbeLbuyGJGwYILewqqepyZkdZrVv3BPypcuOeHyJpP8azENHWcSI8Xnhj3RqwIlJfPTpvJJTcZPDenEJMzbEWhNwOGtBAn0fAKNxuq3+NOiaRPcW6Bu93DeoHD5UomtFnX7ozSyMaMElAzw1rAbOMqjU9197+iWRhNX1GQkQGczchJnjUNVTIxD5edX9jCHRFOPzmI1/haJMARFgnbiDo9VturBNErfQpbKaaAj5HBq8Tm7kDE0uwNgLmgpXxtxzhwSXDIaeo7SRIPgEUhslG7fg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(35042699022)(82310400026)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rEz/2Hc99n9/vhcD33LyIa7R8figDRzvnYEnJ5/nDvmpcj0KHMQ2xLnspnhHGrlCzuhhU4YDW8YJrE/hd8Rtik5/fa0oCT2iSSxrlUJuoSJ0nEL1v/g7TXlBAWtyIea0WeablOFPwbIxkzTa2/jOb0xXrQxAvSaSsmpSsDZrK3gpXYXVulyRKIbwD034lmfA+zBPXeR64B0DN5K5AVRCSvn6sgAkB3oaBiobXChg+zL1YyrXF1Nvzis0nKAorCum3dpDRIqJOl9evsSTbrQI0Xopb0qIj+8JlQiRnt0qcfzY4SB3fmEviYOc3KhylyFNAnnM8FrA6fhih7KNVg5SOUsDTm9V8g+5LF4XEIoTjRRlSsf4HbuxbE47UcZcnza4zvhh6Se9gh3Bk9A6lK6dOZZaFc4XBXNZOWZbN/r8Ce6eBIXW80MvIU2LN+38tL37
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:08:27.1329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29356101-fd64-487e-1459-08dea477377f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9439

KVM needs to interact with the host IRS in order to, for example, make
VMs or VPEs valid. There are two potential approaches here. Either the
host irqchip driver can provide an interface, or KVM can interact
directly with the host IRS. The latter of these two is chosen as the
set of MMIO registers that KVM needs to interact with is orthogonal to
the set used by the host irqchip driver (with the exception of some of
the read-only IRS_IDRx registers).

Pass KVM a pointer to an IRS config frame - the config frame belonging
to ANY IRS is fine as long as one IRS's config frame is used
consistently - in struct gic_kvm_info. Additionally, include a flag
telling KVM whether the IRS is coherent or non-coherent in order to
make sure that KVM can do the correct cache state management, if
required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c      | 26 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v5.c          |  3 +++
 include/linux/irqchip/arm-gic-v5.h    |  2 ++
 include/linux/irqchip/arm-vgic-info.h |  5 +++++
 4 files changed, 36 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index f3fce0b1e25d9..5dfa043cf9e34 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -50,6 +50,32 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_dat=
a *irs_data,
 	writeq_relaxed(val, irs_data->irs_base + reg_offset);
 }
=20
+void __iomem *gicv5_irs_get_config_frame_base(void)
+{
+	struct gicv5_irs_chip_data *irs_data =3D per_cpu(per_cpu_irs_data,
+						       smp_processor_id());
+
+	if (!irs_data)
+		return NULL;
+
+	return irs_data->irs_base;
+}
+
+bool gicv5_irs_is_non_coherent(void)
+{
+	struct gicv5_irs_chip_data *irs_data =3D per_cpu(per_cpu_irs_data,
+						       smp_processor_id());
+
+	if (!irs_data) {
+		pr_err("Failed to look up IRS for CPU %d\n",
+		       smp_processor_id());
+		return false;
+	}
+
+	return !!(irs_data->flags & IRS_FLAGS_NON_COHERENT);
+}
+
+
 /*
  * The polling wait (in gicv5_wait_for_op_s_atomic()) on a GIC register
  * provides the memory barriers (through MMIO accessors)
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 58e457d4c1476..3329019722360 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1134,6 +1134,9 @@ static void __init gic_of_setup_kvm_info(struct devic=
e_node *node)
=20
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
+	gic_v5_kvm_info.gicv5_irs.base =3D gicv5_irs_get_config_frame_base();
+	gic_v5_kvm_info.gicv5_irs.non_coherent =3D gicv5_irs_is_non_coherent();
+
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 40d2fce682940..dfa4d29dc0012 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -377,6 +377,8 @@ void __init gicv5_free_lpi_domain(void);
=20
 int gicv5_irs_of_probe(struct device_node *parent);
 int gicv5_irs_acpi_probe(void);
+void __iomem *gicv5_irs_get_config_frame_base(void);
+bool gicv5_irs_is_non_coherent(void);
 void gicv5_irs_remove(void);
 int gicv5_irs_enable(void);
 void gicv5_irs_its_probe(void);
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index 67d9d960273b9..f05370e2debf4 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -38,6 +38,11 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* GICv5 IRS base */
+	struct {
+		void __iomem	*base;
+		bool		non_coherent;
+	}		gicv5_irs;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1
