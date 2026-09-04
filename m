Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FC83EC826;
	Fri,  4 Sep 2026 08:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511406; cv=fail; b=j2jDln2WqNtImyT3SbU3GCfu+iOoumXGdQfCdmzQ+nZKm95SAWxIOzujAgOOgMfWTE7CZ1n9WtCaVR3F+5wsXyFzQtD//Ih2eGTJBs6bQ3BsQzv2LUysRl4HlhSyf5o36P7N2gmFPkoTy3R6LspyC7N7W/H3voOzCefu1ZxrR7I=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511406; c=relaxed/simple;
	bh=mdkFC02CaXLAcnSCt3RH2a8jEFwrojNmFSTh4S5te7E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HpGa7qziHZdl2l4GrlrkVUga9opLQnhRK+V66I7M6Xojp/vY6bdNpx0yfIMjT7DnszwNWxwNQiBpLuRz9Qcl7G+mYH6UepFxeJuq+2TaIRaYxaW5lMabN8L5i4j6xK/pMnG+TWakuaCn5zYFgrEnVNZ1deYUF+zxFz1YtBpNqWg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VkYy5AE+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VkYy5AE+; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VkYy5AE+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VkYy5AE+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VCwCiKLemPi8cYlPRGg/tDBcHZbZTG2yddrdFRTFuID7Rqf5470CSwifCxRmZzTiauRIMJHN05ZTQidWc7sdUsY2drFBGsaBwUD7bITC4yxLzCEE5GRYbVF2myAnKQtz7RwoTkzb6yHasugMlvQPKeIWvS866kYZ3NS+Qmj0czbiQiePBa0Gdt1+QrCjlK5aauuFk7ORnLZ1yaY7jUzS5rRBH+K8pfboKPG1iy2dcX18lMrKTS9T2PvrXN8QlPfrFT2qkwYAwDb8e0JqxJ6K/zXEhS/VihKdnma0DlhSwT/P6iP/MSnDi1iOFuD7K/dg2I2w+qWust5pEBBJ5gsogw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdkFC02CaXLAcnSCt3RH2a8jEFwrojNmFSTh4S5te7E=;
 b=K1UG6OVhBGdle7sk/hmr6k6Jw9g8y/E/CnE+tUtqLCCszUfKcLHCzFm7Y5TYuDhd1pzJLU8JfaAMxcTbmr8+TALhC852HzOolkvhvAoRBqevjex3hxcR1OhhLDy1d+nzduGBo379J9ykXTTA0j1sVBJRCFBVnpoh1kXKoK4kO9Ma/z6cbUFIlh1C2Ya/DQCNVv8d4RV56TPGHWObijHyKiRWSq/30YJW/j/w7bk4LJNC8JyZGLCxzJqCHGkDAyyYaBz21D1tdtKPl6jtdcvghenEEZnrxM7xqBifCWO76LXTAnaySZb4XExYqXF0ZMOZrRW2cpy34rzY/tC1XZDxIQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdkFC02CaXLAcnSCt3RH2a8jEFwrojNmFSTh4S5te7E=;
 b=VkYy5AE+tv6gIzkpj4CZ15CnUXOZbA3Q3HJuFzoL5R/C2HlG3Z9YkbBfpZ/hAnFFlgw8XUKI2WZF2DgphR8pUHBY6g9XTeXsTNVPNka3EO9vow6n4Eg9p4hheSQ6Kfp/H+WWedbJZ5cOu0h6n3p+DFocf9l3LrPe7Y+/JoGavh0=
Received: from AM0P309CA0025.EURP309.PROD.OUTLOOK.COM (2603:10a6:20b:28f::10)
 by PA4PR08MB7596.eurprd08.prod.outlook.com (2603:10a6:102:272::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:43:19 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:28f:cafe::53) by AM0P309CA0025.outlook.office365.com
 (2603:10a6:20b:28f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.4 via Frontend Transport; Fri, 4
 Sep 2026 08:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 08:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dRfxDgTB8tGQzhUzF9OjCHyM01ajdwoQnwgZA3obSFn7c7UIDkfG5W3TIvSPp9DC21bp4ExDwSxueu2C+Cn0BdoFAGyEZb3Scrh3sJtXN5F+ruChZzFr8Xli/T5x+6xoyg5kXlE9LUWvZz5Zqu49n8VT3Xqur3tuJQ4NOIgehY2xjN76f1PhBs+6qrouAGUJMdsm6n3Wi8EjascOp48rB9UXa6fi0XJwdpwvrmrNBZ1WkPNrW+h/HwXI3n4mIjxcNOy4NlmgurzEd3OTQqtoBl9+tiVxkME2f+eTFTmvswcfgaXnpCDrwwsHoTNK+IIg6GHHcPXoxLqjRZEs2XxeBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdkFC02CaXLAcnSCt3RH2a8jEFwrojNmFSTh4S5te7E=;
 b=RwIxDeycywPyk4m2PgyzJE0k0GStXWnR1EyDdgdqTHfF2MvRr6S0YVb1OukyMZE/h+IhvYcyMrEbRyusADdGjEvb6N1AfM7KR3RHp37dCFQT2G+qtjc/y0TNJ55JdauxGuwDqQ/OCoNUYTmSXF80vXTOSFA25SDuRJWYxRrFul7gEUXh/skQ8bCVdNtl14U06jvJ6eSkN82vhbyryKJPJ1hakVnioWztKvwecDBveVSSZx2RVoIcISJDOeTictNDxFgv2xDmZVqfglVF1Ki8xkmMo9+PdlTAwkT568kF7qzz7XKV5aKDadnaFWqlWqhXGunQAhiw4m0tDllheve6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdkFC02CaXLAcnSCt3RH2a8jEFwrojNmFSTh4S5te7E=;
 b=VkYy5AE+tv6gIzkpj4CZ15CnUXOZbA3Q3HJuFzoL5R/C2HlG3Z9YkbBfpZ/hAnFFlgw8XUKI2WZF2DgphR8pUHBY6g9XTeXsTNVPNka3EO9vow6n4Eg9p4hheSQ6Kfp/H+WWedbJZ5cOu0h6n3p+DFocf9l3LrPe7Y+/JoGavh0=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DB9PR08MB6684.eurprd08.prod.outlook.com (2603:10a6:10:26d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 08:42:46 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 08:42:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 19/49] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Topic: [PATCH v5 19/49] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Thread-Index: AQHdJl8AtYz06E10UEOs8KK76lVwS7aSpSOAgCug1YA=
Date: Fri, 4 Sep 2026 08:42:46 +0000
Message-ID: <bfc53cc46cd7f1e2901ec1afa0e5a30335cbe036.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-20-sascha.bischoff@arm.com>
	 <20260807142757.784E41F00A3A@smtp.kernel.org>
In-Reply-To: <20260807142757.784E41F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DB9PR08MB6684:EE_|AM3PEPF0000A791:EE_|PA4PR08MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: b7193929-4e43-4f24-61fd-08df0a609248
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|56012099006|38070700021|11063799006|6133799003|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 1rRscCBgp0a9YUf/nb+C6V3JCzrNU+YGMKMNx+AmWqkng3n5TArKZW7vFrd9VXB5APbux8YadnGpi2Sk+smxINfrqJy0GO6OU1PPkRUeiOog94X15XZ4JVVC+YSWvByisRX6zUWmxpFsCYVoseMel6duVicNtuu6U/Ph+MMN7RRVLv1xzH3W1dhZhehjPHt3RnSadx/nig59iVrFyP/uY0aMfhIcPRhfNcEk3L/gmzZSpQL851fHd+q5sV+7Pm0vYv3WpR3Pi6TkkSSQtrDoI50Yao9N6CBiEpD0LMN6uJHON/T1YwTKfq3PmClbtqU/yI/i5/N0Bth2OnXYQ4XG6RFIxTcCcth45cMj+RpisBKSMO2IM8VEyyFIAwXiLxx3JrfHF0KWyNeM9V+v0pDhbuWoCPlUN66c4919G6tqrWIZYcKt//Tsl36H1r8iOjLBT9dWqja8UouqL5XUupq+mBZJM+kCgQSkqQkxgY43nqQjx99SFuxOBIl20nR4tk9mupH1fsSIXzcLwcKv85uspEWs3GtdG+mmnwGTj2ymZkISyRDGqvjz0P9YVAk3M/uRfAgzqAPCzE8m/ijQw0Grz1XgjsTm38XTdfMjfuXmXDnz9D8monmsdu0LQck6NyLOKuJlsKXwnK1Z7P78pb8ibM7j37nn51yO68TsM4UujwukK7gWTb8Dpk1jEB+g+H95BVQ3EftQ+NCfr18eoaaPUuuii8ZKlDejja/s6t7zjkc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(38070700021)(11063799006)(6133799003)(10067099003)(4143699003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <05B9051EFF6F66479C3E370E51D74065@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 4zQz6xx0c2HZaP3VdG11291LSrK8vsKL/VQm9YPH9lcaVeYY7p2BygjfK1BbLZpjcpYK4WhPjJo7AhKEpHI5+laYi0ss1mFtsAADMT4/stRJiY4JoPxeRHM2gx77LRtu25eER3/L3xhZr92yPflZuJDOl3TKfO/gzHWaWa1bZPA/vyv5+O6IXQ7CgjQarbh1kp1QN8RG7tD4tJBXu2jiERT7OecNB+LFzmFHKKPBiB3pfw16xS02ZWQCaSsRszaqy78JIz1cWL4DkQhfh6k51m91d22VWaikKHEFJ51EjPn2xrxdAkR0yn5duCq2AfNSqCWFAYSKPycmi3+0jDmPsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6684
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4be0d668-225a-44a5-2ddf-08df0a607e53
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|35042699022|1800799024|14060799003|56012099006|10067099003|22082099003|4143699003|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3uFoc9jJlj2zISw7CqNehv21sB8BAwKbGAzGEyxkbVA5BSxfUPgbZZ3mQd8lhw2xA1xffI6V4XpEOzQoh0AjXpzjuwiT928J1ooHHflTsBhE+gXr9jts2eqEtIuKLW93GgO+PXb/aUMe6F/r3H7M7Q68SEVhzJgrJhDeV39AYSpa0rIGb9a9+LEY9CXFxpcsiIwmS+8bml83CUm+nbjjmgvuuJSBEArsDCuTBYd//iluNbumJhEsch8X41AYy+KadRDPhEa5jxChBxCmelbJONIp3CFqcOaTMB3vGJb10D3RHoKhCRTADXMiM3OAiyBhMblLwx/Q9de85QhgS0vrsozTYwaUWC21+TpTU+N4LQKf0FEaXxPWVZzQMZ+DlGiKNke8ppuj/1V1+nhlqnFuqIGs6tscZt/AqMjQ3YV0AodiMVZKIYg0QQynQYoBc8JegHsqvtpSUElwFL8G61Y/33gO3UJ6Ux3wSIaMCwcecJbZicIocxFLtRHSJ+eH5CHmmXlvW13lJI7SfrxUlsAAwjAWeiDVgwH3+D2VLLf1z7fUEoZg8mVl1C9Iq3p9Z5E3W6GOq9XywDGqbzlZFQzrYvh43OhKCKceLOzeVgezOWcIavlSumxpT+6uMblTzo7v1jR4aWCJ6MITlzvnoMBhDiA5+8JsLADH7cka2NF5jzw=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(35042699022)(1800799024)(14060799003)(56012099006)(10067099003)(22082099003)(4143699003)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fqKi0kHMlXZYrFSmApJlIPWWg15Co4nK2ToXb4C4efXf0FVhxbWIUv3QzaQtIyoM2xCpbblduks1C3AUO8pffFQJqqPwXaHo/hhrWiBgMH61mQ3J8/u5PtLZgd5jWCWqGLflBrrSun5jxX6XVtgE9iRJWo2u5Of3LFRJJwCq9k9Ug0zW1RIMZDXflXpPGB5148c5uSkOnFFITG/9Q2fxARiUDUh1RnuoW1G4nXrsiW5L50i0KqvPko/d4aXiaCzq5baOVy0pEPgZcFgTm4II23GGJE8NobCWMwe1tT5Rjc07qy/DdQdQnaXvb1G7PvVsGGJU5CVeu0ijxbZg6j0ImHgFHffinmoj2cuymDkAAzJuZNnCGpy4FRMAEjci0SH0puYveeuT/xKZw07FyFOzIVEyi/DLKw0XR2vxHbW2WYxiVQQ5A5mhmKr8hx7YR5Qp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 08:43:19.6271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7193929-4e43-4f24-61fd-08df0a609248
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7596

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE0OjI3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIHBhdGNoIGRlZmluZXMgdGhlIFVBUEkgY29uc3RhbnQNCj4gS1ZNX1ZHSUNfVjVfQURE
Ul9UWVBFX0lSUyBmb3IgdXNlcnNwYWNlIHRvIHNwZWNpZnkgdGhlIElSUyBsb2NhdGlvbiwNCj4g
YnV0IHByb3ZpZGVzIG5vIGNvcnJlc3BvbmRpbmcga2VybmVsIGltcGxlbWVudGF0aW9uIHRvIGhh
bmRsZSBpdC4NCj4gLSBbTG93XSBUaGUgbmV3bHkgYWRkZWQgVUFQSSBtYWNybyBLVk1fVkdJQ19W
NV9JUlNfU0laRSB1c2VzIHRoZQ0KPiBrZXJuZWwtaW50ZXJuYWwgbWFjcm8gU1pfNjRLLCB3aGlj
aCBpcyBub3QgZXhwb3J0ZWQgdG8gdXNlcnNwYWNlIGFuZA0KPiB3aWxsIGNhdXNlIGNvbXBpbGF0
aW9uIGVycm9ycy4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbMTldOiBbUEFUQ0ggdjUgMTkvNDld
IEtWTTogYXJtNjQ6IGdpYy12NTogQWRkDQo+IEtWTV9WR0lDX1Y1X0FERFJfVFlQRV9JUlMgdG8g
VUFQSSAtLS0NCj4gY29tbWl0IDJkZWViYjNiOTdjZTNlMmY4OGYwY2RmMDQ1MjEwNGVkYmQwYTdl
YTYNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0K
PiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lSUyB0
byBVQVBJDQo+IA0KPiBUaGlzIHBhdGNoIGFkZHMgdGhlIFVBUEkgZGVmaW5pdGlvbnMgZm9yIHRo
ZSBHSUN2NSBJUlMgYWRkcmVzcyB0eXBlDQo+IGFuZCBzaXplIA0KPiB0byB0aGUgYXJtNjQgS1ZN
IGhlYWRlcnMuIEl0IHJlc2VydmVzIDJ4NjRrQiBpbiB0aGUgR1BBIHNwYWNlIGZvciB0aGUNCj4g
SVJTIA0KPiBDT05GSUdfRlJBTUUgYW5kIFNFVExQSV9GUkFNRS4NCj4gDQo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiA+IGIvYXJjaC9hcm02NC9p
bmNsdWRlL3VhcGkvYXNtL2t2bS5oDQo+ID4gaW5kZXggMWMxM2JmYTJkMzhhYS4uZDFiMmNhMzE3
ZjU4NiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgN
Cj4gPiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gWyAuLi4gXQ0K
PiA+IEBAIC05Nyw2ICs5NywxMSBAQCBzdHJ1Y3Qga3ZtX3JlZ3Mgew0KPiA+IMKgI2RlZmluZSBL
Vk1fVkdJQ19WM19SRURJU1RfU0laRQkJKDIgKiBTWl82NEspDQo+ID4gwqAjZGVmaW5lIEtWTV9W
R0lDX1YzX0lUU19TSVpFCQkoMiAqIFNaXzY0SykNCj4gPiDCoA0KPiA+ICsvKiBTdXBwb3J0ZWQg
VkdJQ3Y1IGFkZHJlc3MgdHlwZXPCoCAqLw0KPiA+ICsjZGVmaW5lIEtWTV9WR0lDX1Y1X0FERFJf
VFlQRV9JUlMJNg0KPiA+ICsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gRG9lcyB0aGlzIHBh
dGNoIHByb3ZpZGUgdGhlIGtlcm5lbCBpbXBsZW1lbnRhdGlvbiB0byBoYW5kbGUNCj4gS1ZNX1ZH
SUNfVjVfQUREUl9UWVBFX0lSUz8NCg0KTm8sIGl0IGRvZXMgbm90Lg0KDQo+IA0KPiBJZiB1c2Vy
c3BhY2UgYXR0ZW1wdHMgdG8gdXNlIHRoaXMgVUFQSSBkZWZpbml0aW9uIHdpdGggdGhlDQo+IEtW
TV9ERVZfQVJNX1ZHSUNfR1JQX0FERFIgYXR0cmlidXRlIGdyb3VwLCB2Z2ljX3Y1X3NldF9hdHRy
KCkNCj4gZXhwbGljaXRseQ0KPiByZXR1cm5zIC1FTlhJTyBmb3IgdGhhdCBncm91cDoNCj4gDQo+
IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmM6dmdpY192NV9zZXRfYXR0cigp
IHsNCj4gCXN3aXRjaCAoYXR0ci0+Z3JvdXApIHsNCj4gCWNhc2UgS1ZNX0RFVl9BUk1fVkdJQ19H
UlBfQUREUjoNCj4gCWNhc2UgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQ1BVX1NZU1JFR1M6DQo+IAlj
YXNlIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVM6DQo+IAkJcmV0dXJuIC1FTlhJTzsNCj4g
Li4uDQo+IH0NCj4gDQo+IFNpbWlsYXJseSwga3ZtX3ZnaWNfYWRkcigpIGxhY2tzIGEgY2FzZSBm
b3IgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lSUw0KPiBhbmQNCj4gd291bGQgcmVqZWN0IGl0IHdp
dGggLUVOT0RFVjoNCj4gDQo+IGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1rdm0tZGV2aWNlLmM6
a3ZtX3ZnaWNfYWRkcigpIHsNCj4gLi4uDQo+IAlkZWZhdWx0Og0KPiAJCXIgPSAtRU5PREVWOw0K
PiAJfQ0KPiAuLi4NCj4gfQ0KPiANCj4gV2l0aG91dCBoYW5kbGluZyBpbiB0aGUga2VybmVsLCB1
c2Vyc3BhY2UgY2Fubm90IGNvbmZpZ3VyZSB0aGUgYmFzZQ0KPiBhZGRyZXNzDQo+IG9mIHRoZSBH
SUN2NSBJUlMsIHdoaWNoIHJlbmRlcnMgdGhlIEdJQ3Y1IElSUyBlbXVsYXRpb24gZmVhdHVyZQ0K
PiB1bnVzYWJsZS4NCg0KU2VlIG5leHQgY29tbWl0cyBpbiBzZXJpZXMuDQoNCj4gDQo+ID4gKyNk
ZWZpbmUgS1ZNX1ZHSUNfVjVfSVJTX1NJWkUJCSgyICogU1pfNjRLKQ0KPiA+ICsNCj4gDQo+IFtT
ZXZlcml0eTogTG93XQ0KPiBEb2VzIHRoaXMgbmV3bHkgYWRkZWQgVUFQSSBkZWZpbml0aW9uIHJl
bHkgb24gdGhlIGtlcm5lbC1pbnRlcm5hbA0KPiBtYWNybw0KPiBTWl82NEs/DQoNClRoaXMgbWF0
Y2hlcyB0aGUgZXhpc3RpbmcgZGVmaW5lcyBmb3IgR0lDdjMuIEkgZG9uJ3QgdGhpbmsgdGhhdCB0
aGlzIGlzDQphbiBpc3N1ZS4NCg0KPiANCj4gU2luY2UgPGxpbnV4L3NpemVzLmg+IGlzIG5vdCBl
eHBvcnRlZCB0byB1c2Vyc3BhY2UsIHVzZXJzcGFjZQ0KPiBwcm9ncmFtcw0KPiBhdHRlbXB0aW5n
IHRvIHVzZSBLVk1fVkdJQ19WNV9JUlNfU0laRSB3aWxsIGZhaWwgdG8gY29tcGlsZSB3aXRoIGFu
DQo+IHVuZGVjbGFyZWQgaWRlbnRpZmllciBlcnJvciBmb3IgU1pfNjRLLg0KPiANCj4gV2hpbGUg
dGhpcyBwYXR0ZXJuIGFscmVhZHkgZXhpc3RzIGluIHRoZSBmaWxlIGZvciBHSUN2MyBzaXplcywN
Cj4gaW50cm9kdWNpbmcgYQ0KPiBuZXcgaW5zdGFuY2UgcGVycGV0dWF0ZXMgdGhlIFVBUEkgYnJl
YWthZ2UuDQo+IA0KPiA+IMKgI2RlZmluZSBLVk1fQVJNX1ZDUFVfUE9XRVJfT0ZGCQkwIC8qIENQ
VSBpcyBzdGFydGVkIGluIE9GRg0KPiA+IHN0YXRlICovDQo+ID4gwqAjZGVmaW5lIEtWTV9BUk1f
VkNQVV9FTDFfMzJCSVQJCTEgLyogQ1BVIHJ1bm5pbmcgYSAzMmJpdA0KPiA+IFZNICovDQo+ID4g
wqAjZGVmaW5lIEtWTV9BUk1fVkNQVV9QU0NJXzBfMgkJMiAvKiBDUFUgdXNlcyBQU0NJIHYwLjIg
Ki8NCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oDQo+ID4gYi90b29scy9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gPiBp
bmRleCAxYzEzYmZhMmQzOGFhLi5kMWIyY2EzMTdmNTg2IDEwMDY0NA0KPiA+IC0tLSBhL3Rvb2xz
L2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiA+ICsrKyBiL3Rvb2xzL2FyY2gv
YXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiBbIC4uLiBdDQo+ID4gQEAgLTk3LDYgKzk3
LDExIEBAIHN0cnVjdCBrdm1fcmVncyB7DQo+ID4gwqAjZGVmaW5lIEtWTV9WR0lDX1YzX1JFRElT
VF9TSVpFCQkoMiAqIFNaXzY0SykNCj4gPiDCoCNkZWZpbmUgS1ZNX1ZHSUNfVjNfSVRTX1NJWkUJ
CSgyICogU1pfNjRLKQ0KPiA+IMKgDQo+ID4gKy8qIFN1cHBvcnRlZCBWR0lDdjUgYWRkcmVzcyB0
eXBlc8KgICovDQo+ID4gKyNkZWZpbmUgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lSUwk2DQo+ID4g
Kw0KPiA+ICsjZGVmaW5lIEtWTV9WR0lDX1Y1X0lSU19TSVpFCQkoMiAqIFNaXzY0SykNCj4gPiAr
DQo+IA0KPiBbU2V2ZXJpdHk6IExvd10NCj4gQXJlIHRoZSBzYW1lIFNaXzY0SyBhbmQgbWlzc2lu
ZyBpbXBsZW1lbnRhdGlvbiBpc3N1ZXMgYXBwbGljYWJsZSB0bw0KPiB0aGlzDQo+IG1pcnJvcmVk
IHRvb2xzIFVBUEkgaGVhZGVyPw0KDQpTZWUgYWJvdmUuDQoNCj4gDQo+ID4gwqAjZGVmaW5lIEtW
TV9BUk1fVkNQVV9QT1dFUl9PRkYJCTAgLyogQ1BVIGlzIHN0YXJ0ZWQgaW4gT0ZGDQo+ID4gc3Rh
dGUgKi8NCj4gPiDCoCNkZWZpbmUgS1ZNX0FSTV9WQ1BVX0VMMV8zMkJJVAkJMSAvKiBDUFUgcnVu
bmluZyBhIDMyYml0DQo+ID4gVk0gKi8NCj4gPiDCoCNkZWZpbmUgS1ZNX0FSTV9WQ1BVX1BTQ0lf
MF8yCQkyIC8qIENQVSB1c2VzIFBTQ0kgdjAuMiAqLw0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQo=
